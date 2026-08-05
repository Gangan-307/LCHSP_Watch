/*
 * Companion BLE client for the HSP Watch Android application.
 *
 * The watch is the BLE central/GATT client. The phone advertises one custom
 * service, accepts writes for Find Phone, and notifies the watch for Find
 * Watch. Scanning is only enabled while the user has requested Find Phone.
 */

#include <stdint.h>
#include <string.h>

#include "rtthread.h"
#include "bf0_ble_gap.h"
#include "bf0_sibles.h"
#include "ulog.h"

#include "drivers/vibrator.h"
#include "find_phone_ble.h"

#define HSP_SERVICE_UUID_LEN              (16U)
#define HSP_PACKET_LEN                    (2U)
#define HSP_CCCD_UUID                     (0x2902U)

#define HSP_COMMAND_START                 (0x01U)
#define HSP_COMMAND_STOP                  (0x02U)
#define HSP_WATCH_COMMAND_FIND_START      (0x11U)

#define HSP_SCAN_INTERVAL                 (0x0030U)
#define HSP_CONNECTION_INTERVAL_MIN       (0x0018U)
#define HSP_CONNECTION_INTERVAL_MAX       (0x0028U)
#define HSP_CONNECTION_SUPERVISION_TO     (0x0190U)
#define HSP_INVALID_HANDLE                (0xFFFFU)
#define HSP_INVALID_CONN_IDX              (0xFFU)
#define HSP_DISCONNECT_REASON             (0x13U)

/* BLE UUIDs are sent least-significant byte first. */
static const uint8_t hsp_service_uuid[HSP_SERVICE_UUID_LEN] = {
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9,
    0x6A, 0x4F, 0x5C, 0x8D, 0x00, 0x50, 0x6A, 0x2D
};

static const uint8_t hsp_control_uuid[HSP_SERVICE_UUID_LEN] = {
    0x01, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9,
    0x6A, 0x4F, 0x5C, 0x8D, 0x00, 0x50, 0x6A, 0x2D
};

static const uint8_t hsp_state_uuid[HSP_SERVICE_UUID_LEN] = {
    0x02, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9,
    0x6A, 0x4F, 0x5C, 0x8D, 0x00, 0x50, 0x6A, 0x2D
};

static const uint8_t hsp_watch_command_uuid[HSP_SERVICE_UUID_LEN] = {
    0x03, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9,
    0x6A, 0x4F, 0x5C, 0x8D, 0x00, 0x50, 0x6A, 0x2D
};

typedef enum
{
    HSP_LINK_IDLE,
    HSP_LINK_SCANNING,
    HSP_LINK_CONNECTING,
    HSP_LINK_DISCOVERING,
    HSP_LINK_SUBSCRIBE_STATE,
    HSP_LINK_SUBSCRIBE_WATCH,
    HSP_LINK_READY,
} hsp_link_state_t;

typedef struct
{
    uint8_t stack_ready;
    uint8_t requested;
    uint8_t conn_idx;
    uint8_t sequence;
    hsp_link_state_t state;
    uint16_t service_start_handle;
    uint16_t service_end_handle;
    uint16_t remote_handle;
    uint16_t control_handle;
    uint16_t state_handle;
    uint16_t state_cccd_handle;
    uint16_t watch_command_handle;
    uint16_t watch_command_cccd_handle;
} hsp_find_phone_env_t;

static hsp_find_phone_env_t g_hsp_find_phone = {
    .conn_idx = HSP_INVALID_CONN_IDX,
    .remote_handle = HSP_INVALID_HANDLE,
    .control_handle = HSP_INVALID_HANDLE,
    .state_handle = HSP_INVALID_HANDLE,
    .state_cccd_handle = HSP_INVALID_HANDLE,
    .watch_command_handle = HSP_INVALID_HANDLE,
    .watch_command_cccd_handle = HSP_INVALID_HANDLE,
};

static int hsp_find_phone_ble_event_handler(uint16_t event_id, uint8_t *data,
                                            uint16_t len, uint32_t context);
static int hsp_find_phone_remote_event_handler(uint16_t event_id, uint8_t *data,
                                               uint16_t len);

static uint8_t hsp_uuid_matches(const uint8_t *uuid, const uint8_t *expected)
{
    return (uuid != RT_NULL && memcmp(uuid, expected, HSP_SERVICE_UUID_LEN) == 0) ? 1U : 0U;
}

static void hsp_reset_remote_handles(void)
{
    g_hsp_find_phone.service_start_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.service_end_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.remote_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.control_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.state_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.state_cccd_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.watch_command_handle = HSP_INVALID_HANDLE;
    g_hsp_find_phone.watch_command_cccd_handle = HSP_INVALID_HANDLE;
}

static void hsp_disconnect_current(void)
{
    ble_gap_disconnect_t disconnect_param;

    if (g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
        return;

    memset(&disconnect_param, 0, sizeof(disconnect_param));
    disconnect_param.conn_idx = g_hsp_find_phone.conn_idx;
    disconnect_param.reason = HSP_DISCONNECT_REASON;
    (void)ble_gap_disconnect(&disconnect_param);
}

static uint8_t hsp_advertises_service(const uint8_t *data, uint16_t length)
{
    uint16_t offset = 0U;

    while (offset < length)
    {
        uint8_t field_length = data[offset];
        uint16_t field_end;

        if (field_length == 0U)
            break;

        field_end = (uint16_t)(offset + field_length + 1U);
        if (field_end > length || field_length < 2U)
            break;

        if (data[offset + 1U] == 0x06U || data[offset + 1U] == 0x07U)
        {
            uint16_t uuid_offset = (uint16_t)(offset + 2U);
            uint16_t uuid_end = field_end;

            while ((uint16_t)(uuid_offset + HSP_SERVICE_UUID_LEN) <= uuid_end)
            {
                if (hsp_uuid_matches(&data[uuid_offset], hsp_service_uuid))
                    return 1U;
                uuid_offset = (uint16_t)(uuid_offset + HSP_SERVICE_UUID_LEN);
            }
        }

        offset = field_end;
    }

    return 0U;
}

static void hsp_start_scan(void)
{
    ble_gap_scan_start_t scan_param;
    uint8_t result;

    if (!g_hsp_find_phone.stack_ready || !g_hsp_find_phone.requested ||
        g_hsp_find_phone.state == HSP_LINK_SCANNING ||
        g_hsp_find_phone.state == HSP_LINK_CONNECTING ||
        g_hsp_find_phone.state == HSP_LINK_DISCOVERING)
        return;

    memset(&scan_param, 0, sizeof(scan_param));
    scan_param.own_addr_type = GAPM_STATIC_ADDR;
    scan_param.type = GAPM_SCAN_TYPE_CONN_DISC;
    scan_param.prop = GAPM_SCAN_PROP_PHY_1M_BIT;
    scan_param.scan_param_1m.scan_intv = HSP_SCAN_INTERVAL;
    scan_param.scan_param_1m.scan_wd = HSP_SCAN_INTERVAL;

    result = ble_gap_scan_start(&scan_param);
    if (result == 0U)
    {
        g_hsp_find_phone.state = HSP_LINK_SCANNING;
        LOG_I("HSP companion scan started");
    }
    else
    {
        LOG_W("HSP companion scan start failed: %u", result);
        g_hsp_find_phone.state = HSP_LINK_IDLE;
    }
}

static void hsp_connect_to_phone(const ble_gap_ext_adv_report_ind_t *report)
{
    ble_gap_connection_create_param_t connection_param;
    uint8_t result;

    if (report == RT_NULL || g_hsp_find_phone.state != HSP_LINK_SCANNING)
        return;

    (void)ble_gap_scan_stop();
    memset(&connection_param, 0, sizeof(connection_param));
    connection_param.own_addr_type = GAPM_STATIC_ADDR;
    connection_param.type = GAPM_INIT_TYPE_DIRECT_CONN_EST;
    connection_param.conn_param_1m.scan_intv = HSP_SCAN_INTERVAL;
    connection_param.conn_param_1m.scan_wd = HSP_SCAN_INTERVAL;
    connection_param.conn_param_1m.conn_intv_min = HSP_CONNECTION_INTERVAL_MIN;
    connection_param.conn_param_1m.conn_intv_max = HSP_CONNECTION_INTERVAL_MAX;
    connection_param.conn_param_1m.conn_latency = 0U;
    connection_param.conn_param_1m.supervision_to = HSP_CONNECTION_SUPERVISION_TO;
    connection_param.peer_addr = report->addr;

    result = ble_gap_create_connection(&connection_param);
    if (result == 0U)
    {
        g_hsp_find_phone.state = HSP_LINK_CONNECTING;
        LOG_I("HSP companion connection requested");
    }
    else
    {
        LOG_W("HSP companion connection start failed: %u", result);
        g_hsp_find_phone.state = HSP_LINK_IDLE;
        hsp_start_scan();
    }
}

static int8_t hsp_write_cccd(uint16_t handle)
{
    static uint8_t cccd_value[2] = {1U, 0U};
    sibles_write_remote_value_t write_value;

    if (handle == HSP_INVALID_HANDLE ||
        g_hsp_find_phone.remote_handle == HSP_INVALID_HANDLE)
        return -1;

    memset(&write_value, 0, sizeof(write_value));
    write_value.write_type = SIBLES_WRITE;
    write_value.handle = handle;
    write_value.len = sizeof(cccd_value);
    write_value.value = cccd_value;
    return sibles_write_remote_value(g_hsp_find_phone.remote_handle,
                                     g_hsp_find_phone.conn_idx, &write_value);
}

static int8_t hsp_send_phone_command(uint8_t command)
{
    static uint8_t packet[HSP_PACKET_LEN];
    sibles_write_remote_value_t write_value;

    if (g_hsp_find_phone.state != HSP_LINK_READY ||
        g_hsp_find_phone.control_handle == HSP_INVALID_HANDLE)
        return -1;

    packet[0] = command;
    packet[1] = ++g_hsp_find_phone.sequence;
    memset(&write_value, 0, sizeof(write_value));
    write_value.write_type = SIBLES_WRITE_WITHOUT_RSP;
    write_value.handle = g_hsp_find_phone.control_handle;
    write_value.len = sizeof(packet);
    write_value.value = packet;
    return sibles_write_remote_value(g_hsp_find_phone.remote_handle,
                                     g_hsp_find_phone.conn_idx, &write_value);
}

static void hsp_finish_service_discovery(const sibles_svc_search_rsp_t *response)
{
    uint8_t index;
    uint8_t *entry;
    uint16_t start_handle;
    uint16_t end_handle;

    if (response == RT_NULL || response->result != 0U ||
        response->conn_idx != g_hsp_find_phone.conn_idx ||
        response->search_svc_len != HSP_SERVICE_UUID_LEN ||
        !hsp_uuid_matches(response->search_uuid, hsp_service_uuid) ||
        response->svc == RT_NULL)
        return;

    entry = response->svc->att_db;
    for (index = 0U; index < response->svc->char_count; index++)
    {
        sibles_svc_search_char_t *characteristic = (sibles_svc_search_char_t *)entry;

        if (characteristic->uuid_len == HSP_SERVICE_UUID_LEN)
        {
            if (hsp_uuid_matches(characteristic->uuid, hsp_control_uuid))
                g_hsp_find_phone.control_handle = characteristic->attr_hdl;
            else if (hsp_uuid_matches(characteristic->uuid, hsp_state_uuid))
            {
                g_hsp_find_phone.state_handle = characteristic->attr_hdl;
                g_hsp_find_phone.state_cccd_handle =
                    sibles_descriptor_handle_find(characteristic, HSP_CCCD_UUID);
            }
            else if (hsp_uuid_matches(characteristic->uuid, hsp_watch_command_uuid))
            {
                g_hsp_find_phone.watch_command_handle = characteristic->attr_hdl;
                g_hsp_find_phone.watch_command_cccd_handle =
                    sibles_descriptor_handle_find(characteristic, HSP_CCCD_UUID);
            }
        }

        entry += sizeof(*characteristic) +
                 (characteristic->desc_count * sizeof(sibles_disc_char_desc_ind));
    }

    if (g_hsp_find_phone.control_handle == HSP_INVALID_HANDLE ||
        g_hsp_find_phone.state_cccd_handle == HSP_INVALID_HANDLE ||
        g_hsp_find_phone.watch_command_cccd_handle == HSP_INVALID_HANDLE)
    {
        LOG_W("HSP companion service is missing required characteristics");
        hsp_disconnect_current();
        return;
    }

    start_handle = response->svc->hdl_start;
    end_handle = response->svc->hdl_end;
    g_hsp_find_phone.service_start_handle = start_handle;
    g_hsp_find_phone.service_end_handle = end_handle;
    g_hsp_find_phone.remote_handle = sibles_register_remote_svc(
        g_hsp_find_phone.conn_idx, start_handle, end_handle,
        hsp_find_phone_remote_event_handler);
    if (g_hsp_find_phone.remote_handle == HSP_INVALID_HANDLE)
    {
        LOG_W("HSP companion remote service registration failed");
        hsp_disconnect_current();
        return;
    }

    g_hsp_find_phone.state = HSP_LINK_SUBSCRIBE_STATE;
}

static void hsp_handle_remote_event(const sibles_remote_event_ind_t *event)
{
    if (event == RT_NULL || event->conn_idx != g_hsp_find_phone.conn_idx ||
        event->value == RT_NULL || event->length < HSP_PACKET_LEN)
        return;

    if (event->handle == g_hsp_find_phone.watch_command_handle &&
        event->value[0] == HSP_WATCH_COMMAND_FIND_START)
    {
        /* Keep this non-blocking; vibrator.c releases the motor by timer. */
        vibrator_vibrate(85U, 1500U);
        LOG_I("HSP Find Watch command received");
    }
}

static int hsp_find_phone_remote_event_handler(uint16_t event_id, uint8_t *data,
                                               uint16_t len)
{
    (void)len;

    switch (event_id)
    {
    case SIBLES_REGISTER_REMOTE_SVC_RSP:
    {
        const sibles_register_remote_svc_rsp_t *response =
            (const sibles_register_remote_svc_rsp_t *)data;

        if (response != RT_NULL && response->conn_idx == g_hsp_find_phone.conn_idx &&
            response->status == 0U && g_hsp_find_phone.state == HSP_LINK_SUBSCRIBE_STATE)
        {
            if (hsp_write_cccd(g_hsp_find_phone.state_cccd_handle) != 0)
            {
                LOG_W("HSP companion state subscription request failed");
                hsp_disconnect_current();
            }
        }
        break;
    }
    case SIBLES_WRITE_REMOTE_VALUE_RSP:
    {
        const sibles_write_remote_value_rsp_t *response =
            (const sibles_write_remote_value_rsp_t *)data;

        if (response == RT_NULL || response->conn_idx != g_hsp_find_phone.conn_idx ||
            response->result != 0U)
        {
            LOG_W("HSP companion write failed");
            hsp_disconnect_current();
            break;
        }

        if (g_hsp_find_phone.state == HSP_LINK_SUBSCRIBE_STATE)
        {
            g_hsp_find_phone.state = HSP_LINK_SUBSCRIBE_WATCH;
            if (hsp_write_cccd(g_hsp_find_phone.watch_command_cccd_handle) != 0)
            {
                LOG_W("HSP companion command subscription request failed");
                hsp_disconnect_current();
            }
        }
        else if (g_hsp_find_phone.state == HSP_LINK_SUBSCRIBE_WATCH)
        {
            g_hsp_find_phone.state = HSP_LINK_READY;
            LOG_I("HSP companion connected and subscribed");
            if (g_hsp_find_phone.requested)
                hsp_send_phone_command(HSP_COMMAND_START);
        }
        break;
    }
    case SIBLES_REMOTE_EVENT_IND:
        hsp_handle_remote_event((const sibles_remote_event_ind_t *)data);
        break;
    default:
        break;
    }

    return 0;
}

static int hsp_find_phone_ble_event_handler(uint16_t event_id, uint8_t *data,
                                            uint16_t len, uint32_t context)
{
    (void)len;
    (void)context;

    switch (event_id)
    {
    case BLE_GAP_EXT_ADV_REPORT_IND:
        if (g_hsp_find_phone.requested && g_hsp_find_phone.state == HSP_LINK_SCANNING)
        {
            const ble_gap_ext_adv_report_ind_t *report =
                (const ble_gap_ext_adv_report_ind_t *)data;
            if (report != RT_NULL && report->data != RT_NULL &&
                hsp_advertises_service(report->data, report->length))
                hsp_connect_to_phone(report);
        }
        break;
    case BLE_GAP_CONNECTED_IND:
        if (g_hsp_find_phone.state == HSP_LINK_CONNECTING)
        {
            const ble_gap_connect_ind_t *connection = (const ble_gap_connect_ind_t *)data;
            if (connection != RT_NULL)
            {
                g_hsp_find_phone.conn_idx = connection->conn_idx;
                g_hsp_find_phone.state = HSP_LINK_DISCOVERING;
                hsp_reset_remote_handles();
                (void)sibles_search_service(g_hsp_find_phone.conn_idx,
                                             HSP_SERVICE_UUID_LEN,
                                             (uint8_t *)hsp_service_uuid);
            }
        }
        break;
    case BLE_GAP_DISCONNECTED_IND:
    {
        const ble_gap_disconnected_ind_t *disconnected =
            (const ble_gap_disconnected_ind_t *)data;
        if (disconnected != RT_NULL && disconnected->conn_idx == g_hsp_find_phone.conn_idx)
        {
            if (g_hsp_find_phone.remote_handle != HSP_INVALID_HANDLE)
            {
                sibles_unregister_remote_svc(g_hsp_find_phone.conn_idx,
                                             g_hsp_find_phone.service_start_handle,
                                             g_hsp_find_phone.service_end_handle,
                                             hsp_find_phone_remote_event_handler);
            }
            g_hsp_find_phone.conn_idx = HSP_INVALID_CONN_IDX;
            g_hsp_find_phone.state = HSP_LINK_IDLE;
            hsp_reset_remote_handles();
            if (g_hsp_find_phone.requested)
                hsp_start_scan();
        }
        break;
    }
    case SIBLES_SEARCH_SVC_RSP:
        hsp_finish_service_discovery((const sibles_svc_search_rsp_t *)data);
        break;
    default:
        break;
    }

    return 0;
}

BLE_EVENT_REGISTER(hsp_find_phone_ble_event_handler, NULL);

void find_phone_ble_stack_ready(void)
{
    g_hsp_find_phone.stack_ready = 1U;
    if (g_hsp_find_phone.requested)
        hsp_start_scan();
}

void find_phone_ble_start(void)
{
    g_hsp_find_phone.requested = 1U;
    if (g_hsp_find_phone.state == HSP_LINK_READY)
    {
        hsp_send_phone_command(HSP_COMMAND_START);
        return;
    }

    hsp_start_scan();
}

void find_phone_ble_stop(void)
{
    g_hsp_find_phone.requested = 0U;
    if (g_hsp_find_phone.state == HSP_LINK_READY)
    {
        hsp_send_phone_command(HSP_COMMAND_STOP);
    }
    else if (g_hsp_find_phone.state == HSP_LINK_SCANNING)
    {
        (void)ble_gap_scan_stop();
        g_hsp_find_phone.state = HSP_LINK_IDLE;
    }
}

uint8_t find_phone_ble_is_requested(void)
{
    return g_hsp_find_phone.requested;
}

uint8_t find_phone_ble_is_connected(void)
{
    return (g_hsp_find_phone.state == HSP_LINK_READY) ? 1U : 0U;
}

uint8_t find_phone_ble_is_scanning(void)
{
    return (g_hsp_find_phone.state == HSP_LINK_SCANNING ||
            g_hsp_find_phone.state == HSP_LINK_CONNECTING ||
            g_hsp_find_phone.state == HSP_LINK_DISCOVERING ||
            g_hsp_find_phone.state == HSP_LINK_SUBSCRIBE_STATE ||
            g_hsp_find_phone.state == HSP_LINK_SUBSCRIBE_WATCH) ? 1U : 0U;
}
