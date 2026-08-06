/*
 * BLE companion service for the HSP Watch Android application.
 *
 * The watch is the BLE peripheral/GATT server.  The Android application is
 * the central: it first reconnects to its cached BLE address and only scans
 * for this service when that direct connection is unavailable.  Keeping the
 * watch out of the central role avoids competing with the normal Bluetooth
 * profiles for scan and connection resources.
 */

#include <stdint.h>
#include <string.h>

#include "rtthread.h"
#include "bf0_ble_gap.h"
#include "bf0_ble_gatt.h"
#include "bf0_sibles.h"
#include "bf0_sibles_advertising.h"
#include "ulog.h"

#include "drivers/vibrator.h"
#include "find_phone_ble.h"

#define HSP_UUID_LEN                         (16U)
#define HSP_PACKET_LEN                       (2U)
#define HSP_INVALID_CONN_IDX                 (0xFFU)

/* Commands sent by the watch to the Android application's STATE notify. */
#define HSP_PHONE_FIND_START                 (0x01U)
#define HSP_PHONE_FIND_STOP                  (0x02U)

/* Commands written by Android to the watch CONTROL characteristic. */
#define HSP_WATCH_FIND_START                 (0x11U)
#define HSP_WATCH_FIND_STOP                  (0x12U)

#define HSP_ADV_INTERVAL                     (0x00A0U) /* 100 ms */
#define HSP_VIBRATION_PERCENT                (85U)
#define HSP_VIBRATION_DURATION_MS            (1500U)

#define SERIAL_UUID_16(x) {((uint8_t)((x) & 0xFFU)), ((uint8_t)((x) >> 8U))}

/* SiFli stores 128-bit UUIDs in little-endian byte order. */
#define HSP_SERVICE_UUID { \
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9, \
    0x6A, 0x4F, 0x5C, 0x8D, 0x00, 0x50, 0x6A, 0x2D \
}

#define HSP_CONTROL_UUID { \
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9, \
    0x6A, 0x4F, 0x5C, 0x8D, 0x01, 0x50, 0x6A, 0x2D \
}

#define HSP_STATE_UUID { \
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9, \
    0x6A, 0x4F, 0x5C, 0x8D, 0x02, 0x50, 0x6A, 0x2D \
}

static uint8_t hsp_service_uuid[HSP_UUID_LEN] = HSP_SERVICE_UUID;

enum hsp_att_index
{
    HSP_ATT_SERVICE,
    HSP_ATT_CONTROL_CHARACTERISTIC,
    HSP_ATT_CONTROL_VALUE,
    HSP_ATT_STATE_CHARACTERISTIC,
    HSP_ATT_STATE_VALUE,
    HSP_ATT_STATE_CCCD,
    HSP_ATT_COUNT,
};

typedef struct
{
    uint8_t stack_ready;
    uint8_t service_ready;
    uint8_t advertising_ready;
    uint8_t requested;
    uint8_t state_subscribed;
    uint8_t conn_idx;
    uint8_t sequence;
    uint8_t state_packet[HSP_PACKET_LEN];
    sibles_hdl service_handle;
    rt_timer_t pending_notify_timer;
} hsp_find_phone_env_t;

static hsp_find_phone_env_t g_hsp_find_phone = {
    .conn_idx = HSP_INVALID_CONN_IDX,
    .state_packet = {HSP_PHONE_FIND_STOP, 0U},
};

BLE_GATT_SERVICE_DEFINE_128(hsp_find_phone_att_db)
{
    BLE_GATT_SERVICE_DECLARE(HSP_ATT_SERVICE, SERIAL_UUID_16_PRI_SERVICE,
                             BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_DECLARE(HSP_ATT_CONTROL_CHARACTERISTIC,
                          SERIAL_UUID_16_CHARACTERISTIC,
                          BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_VALUE_DECLARE(HSP_ATT_CONTROL_VALUE, HSP_CONTROL_UUID,
                                BLE_GATT_PERM_WRITE_REQ_ENABLE |
                                BLE_GATT_PERM_WRITE_COMMAND_ENABLE,
                                BLE_GATT_VALUE_PERM_UUID_128,
                                HSP_PACKET_LEN),
    BLE_GATT_CHAR_DECLARE(HSP_ATT_STATE_CHARACTERISTIC,
                          SERIAL_UUID_16_CHARACTERISTIC,
                          BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_VALUE_DECLARE(HSP_ATT_STATE_VALUE, HSP_STATE_UUID,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_NOTIFY_ENABLE,
                                BLE_GATT_VALUE_PERM_UUID_128 |
                                BLE_GATT_VALUE_PERM_RI_ENABLE,
                                HSP_PACKET_LEN),
    BLE_GATT_DESCRIPTOR_DECLARE(HSP_ATT_STATE_CCCD,
                                SERIAL_UUID_16_CLIENT_CHAR_CFG,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_WRITE_REQ_ENABLE,
                                BLE_GATT_VALUE_PERM_RI_ENABLE, 2),
};

SIBLES_ADVERTISING_CONTEXT_DECLAR(g_hsp_find_phone_advertising);

static void hsp_send_phone_command(uint8_t command);

static void hsp_pending_notify_timeout(void *parameter)
{
    (void)parameter;

    if (g_hsp_find_phone.requested)
        hsp_send_phone_command(HSP_PHONE_FIND_START);
}

static void hsp_schedule_pending_notify(void)
{
    rt_tick_t delay = rt_tick_from_millisecond(20U);

    if (delay == 0U)
        delay = 1U;

    if (g_hsp_find_phone.pending_notify_timer == RT_NULL)
    {
        g_hsp_find_phone.pending_notify_timer = rt_timer_create(
            "hsp_notify", hsp_pending_notify_timeout, RT_NULL, delay,
            RT_TIMER_FLAG_ONE_SHOT | RT_TIMER_FLAG_SOFT_TIMER);
    }
    else
    {
        rt_timer_stop(g_hsp_find_phone.pending_notify_timer);
        rt_timer_control(g_hsp_find_phone.pending_notify_timer,
                         RT_TIMER_CTRL_SET_TIME, &delay);
    }

    if (g_hsp_find_phone.pending_notify_timer != RT_NULL)
        (void)rt_timer_start(g_hsp_find_phone.pending_notify_timer);
}

static uint8_t hsp_advertising_event(uint8_t event, void *context, void *data)
{
    (void)context;

    switch (event)
    {
    case SIBLES_ADV_EVT_ADV_STARTED:
    {
        const sibles_adv_evt_startted_t *status =
            (const sibles_adv_evt_startted_t *)data;
        LOG_I("HSP companion advertising started: %u",
              status != RT_NULL ? status->status : 0xFFU);
        break;
    }
    case SIBLES_ADV_EVT_ADV_STOPPED:
        LOG_I("HSP companion advertising stopped");
        break;
    default:
        break;
    }

    return 0;
}

static void hsp_start_advertising(void)
{
    sibles_advertising_para_t parameter;
    sibles_adv_type_srv_uuid_t *service_list;
    uint8_t result;

    if (!g_hsp_find_phone.stack_ready)
        return;

    if (g_hsp_find_phone.advertising_ready)
    {
        (void)sibles_advertising_start(g_hsp_find_phone_advertising);
        return;
    }

    memset(&parameter, 0, sizeof(parameter));
    parameter.own_addr_type = GAPM_STATIC_ADDR;
    parameter.config.adv_mode = SIBLES_ADV_CONNECT_MODE;
    parameter.config.mode_config.conn_config.duration = 0U;
    parameter.config.mode_config.conn_config.interval = HSP_ADV_INTERVAL;
    parameter.config.max_tx_pwr = 0x7FU;
    parameter.config.is_auto_restart = 1U;
    parameter.evt_handler = hsp_advertising_event;

    service_list = rt_malloc(sizeof(*service_list) + sizeof(sibles_adv_uuid_t));
    if (service_list == RT_NULL)
    {
        LOG_E("HSP companion advertising UUID allocation failed");
        return;
    }

    service_list->count = 1U;
    service_list->uuid_list[0].uuid_len = HSP_UUID_LEN;
    memcpy(service_list->uuid_list[0].uuid.uuid_128, hsp_service_uuid,
           HSP_UUID_LEN);
    parameter.adv_data.completed_uuid = service_list;

    result = sibles_advertising_init(g_hsp_find_phone_advertising, &parameter);
    rt_free(service_list);
    if (result != SIBLES_ADV_NO_ERR)
    {
        LOG_E("HSP companion advertising init failed: %u", result);
        return;
    }

    g_hsp_find_phone.advertising_ready = 1U;
    (void)sibles_advertising_start(g_hsp_find_phone_advertising);
}

static uint8_t *hsp_gatts_get_callback(uint8_t conn_idx, uint8_t index,
                                        uint16_t *length)
{
    (void)conn_idx;

    if (length == RT_NULL)
        return RT_NULL;

    *length = 0U;
    if (index == HSP_ATT_STATE_VALUE)
    {
        *length = HSP_PACKET_LEN;
        return g_hsp_find_phone.state_packet;
    }

    return RT_NULL;
}

static uint8_t hsp_gatts_set_callback(uint8_t conn_idx, sibles_set_cbk_t *parameter)
{
    if (parameter == RT_NULL)
        return 1U;

    switch (parameter->idx)
    {
    case HSP_ATT_CONTROL_VALUE:
        if (parameter->len < 1U || parameter->value == RT_NULL)
            return 1U;

        switch (parameter->value[0])
        {
        case HSP_WATCH_FIND_START:
            (void)vibrator_vibrate(HSP_VIBRATION_PERCENT,
                                   HSP_VIBRATION_DURATION_MS);
            LOG_I("HSP Find Watch command received");
            break;
        case HSP_WATCH_FIND_STOP:
            vibrator_off();
            LOG_I("HSP Find Watch stop command received");
            break;
        default:
            LOG_W("HSP unknown control command: %u", parameter->value[0]);
            return 1U;
        }
        break;

    case HSP_ATT_STATE_CCCD:
        if (parameter->len < 1U || parameter->value == RT_NULL)
            return 1U;

        g_hsp_find_phone.conn_idx = conn_idx;
        g_hsp_find_phone.state_subscribed =
            parameter->value[0] != 0U ? 1U : 0U;
        LOG_I("HSP companion state notification %s on conn %u",
              g_hsp_find_phone.state_subscribed ? "enabled" : "disabled",
              conn_idx);
        if (g_hsp_find_phone.state_subscribed && g_hsp_find_phone.requested)
            hsp_schedule_pending_notify();
        break;

    default:
        return 1U;
    }

    return 0U;
}

static void hsp_send_phone_command(uint8_t command)
{
    sibles_value_t value;
    int result;

    g_hsp_find_phone.state_packet[0] = command;
    g_hsp_find_phone.state_packet[1] = ++g_hsp_find_phone.sequence;

    if (!g_hsp_find_phone.service_ready ||
        !g_hsp_find_phone.state_subscribed ||
        g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
    {
        LOG_W("HSP companion command queued without an Android subscriber");
        return;
    }

    memset(&value, 0, sizeof(value));
    value.hdl = g_hsp_find_phone.service_handle;
    value.idx = HSP_ATT_STATE_VALUE;
    value.len = HSP_PACKET_LEN;
    value.value = g_hsp_find_phone.state_packet;
    result = sibles_write_value(g_hsp_find_phone.conn_idx, &value);
    if (result != HSP_PACKET_LEN)
        LOG_W("HSP companion notification failed: %d", result);
}

static void hsp_register_service(void)
{
    if (g_hsp_find_phone.service_ready)
        return;

    BLE_GATT_SERVICE_INIT_128(service, hsp_find_phone_att_db, HSP_ATT_COUNT,
                              BLE_GATT_SERVICE_PERM_NOAUTH |
                              BLE_GATT_SERVICE_PERM_UUID_128,
                              hsp_service_uuid);
    g_hsp_find_phone.service_handle = sibles_register_svc_128(&service);
    if (g_hsp_find_phone.service_handle == RT_NULL)
    {
        LOG_E("HSP companion service registration failed");
        return;
    }

    sibles_register_cbk(g_hsp_find_phone.service_handle,
                        hsp_gatts_get_callback, hsp_gatts_set_callback);
    g_hsp_find_phone.service_ready = 1U;
}

static int hsp_find_phone_ble_event_handler(uint16_t event_id, uint8_t *data,
                                            uint16_t length, uint32_t context)
{
    (void)length;
    (void)context;

    switch (event_id)
    {
    case BLE_GAP_CONNECTED_IND:
    {
        const ble_gap_connect_ind_t *connection =
            (const ble_gap_connect_ind_t *)data;
        if (connection != RT_NULL)
        {
            g_hsp_find_phone.conn_idx = connection->conn_idx;
            g_hsp_find_phone.state_subscribed = 0U;
            LOG_I("HSP companion BLE peer connected: %u", connection->conn_idx);
        }
        break;
    }

    case BLE_GAP_DISCONNECTED_IND:
    {
        const ble_gap_disconnected_ind_t *disconnected =
            (const ble_gap_disconnected_ind_t *)data;
        if (disconnected != RT_NULL &&
            disconnected->conn_idx == g_hsp_find_phone.conn_idx)
        {
            g_hsp_find_phone.conn_idx = HSP_INVALID_CONN_IDX;
            g_hsp_find_phone.state_subscribed = 0U;
            LOG_I("HSP companion BLE peer disconnected: %u", disconnected->reason);
        }
        break;
    }

    default:
        break;
    }

    return 0;
}

BLE_EVENT_REGISTER(hsp_find_phone_ble_event_handler, NULL);

void find_phone_ble_stack_ready(void)
{
    g_hsp_find_phone.stack_ready = 1U;
    hsp_register_service();
    hsp_start_advertising();
}

void find_phone_ble_start(void)
{
    g_hsp_find_phone.requested = 1U;
    hsp_send_phone_command(HSP_PHONE_FIND_START);
}

void find_phone_ble_stop(void)
{
    g_hsp_find_phone.requested = 0U;
    hsp_send_phone_command(HSP_PHONE_FIND_STOP);
}

void find_phone_ble_close(void)
{
    g_hsp_find_phone.requested = 0U;
    g_hsp_find_phone.state_subscribed = 0U;
    g_hsp_find_phone.conn_idx = HSP_INVALID_CONN_IDX;

    if (g_hsp_find_phone.advertising_ready)
        (void)sibles_advertising_stop(g_hsp_find_phone_advertising);
    if (g_hsp_find_phone.pending_notify_timer != RT_NULL)
        rt_timer_stop(g_hsp_find_phone.pending_notify_timer);

    /* The Bluetooth stack is about to close and owns the registered service. */
    g_hsp_find_phone.stack_ready = 0U;
    g_hsp_find_phone.service_ready = 0U;
    g_hsp_find_phone.advertising_ready = 0U;
    g_hsp_find_phone.service_handle = RT_NULL;
}

uint8_t find_phone_ble_is_requested(void)
{
    return g_hsp_find_phone.requested;
}

uint8_t find_phone_ble_is_connected(void)
{
    return (g_hsp_find_phone.conn_idx != HSP_INVALID_CONN_IDX &&
            g_hsp_find_phone.state_subscribed) ? 1U : 0U;
}

uint8_t find_phone_ble_is_scanning(void)
{
    /* The Android companion owns discovery; the watch never scans for it. */
    return 0U;
}
