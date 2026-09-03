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
#include "bluetooth/music_app.h"
#include "services/activity_tracker.h"
#include "services/camera_photo_service.h"
#include "services/phone_notifications.h"
#include "services/phone_sync.h"
#include "services/ota_service.h"
#include "find_phone_ble.h"

#define HSP_UUID_LEN                         (16U)
#define HSP_COMMAND_PACKET_LEN               (2U)
#define HSP_STATE_PACKET_MAX_LEN             (4U)
#define HSP_SYNC_TIME_PACKET_LEN             (7U)
#define HSP_SYNC_LOCATION_PACKET_LEN         (11U)
#define HSP_SYNC_WEATHER_PACKET_LEN          (13U)
#define HSP_STATUS_PACKET_HEADER_LEN         (4U)
#define HSP_STATUS_PACKET_ACTIVITY_LEN       (10U)
#define HSP_STATUS_PACKET_MAX_LEN            (20U)
#define HSP_SYNC_PACKET_MAX_LEN              (244U)
#define HSP_INVALID_CONN_IDX                 (0xFFU)

#define HSP_STATUS_PROTOCOL_VERSION          (1U)
#define HSP_STATUS_UNKNOWN_BATTERY_PERCENT   (0xFFU)

#define HSP_STATUS_FLAG_BLE_ENABLED          (1U << 0U)
#define HSP_STATUS_FLAG_COMPANION_CONNECTED  (1U << 1U)
#define HSP_STATUS_FLAG_BATTERY_VALID        (1U << 2U)
#define HSP_STATUS_FLAG_CHARGING             (1U << 3U)
#define HSP_STATUS_FLAG_ACTIVITY_VALID       (1U << 4U)

/* Commands sent by the watch to the Android application's STATE notify. */
#define HSP_PHONE_FIND_START                 (0x01U)
#define HSP_PHONE_FIND_STOP                  (0x02U)
#define HSP_PHONE_NOTIFICATION_CLEAR         (0x03U)
#define HSP_PHONE_NOTIFICATION_DELETE        (0x04U)
#define HSP_PHONE_PHOTO_REQUEST               (0x05U)
#define HSP_PHONE_OTA_STATUS                  (0x06U)

/* Commands written by Android to the watch CONTROL characteristic. */
#define HSP_WATCH_FIND_START                 (0x11U)
#define HSP_WATCH_FIND_STOP                  (0x12U)
#define HSP_WATCH_OTA_CHECK                  (0x13U)
#define HSP_WATCH_OTA_INSTALL                (0x14U)

/* Packets written by Android to the SYNC characteristic. */
#define HSP_SYNC_TIME                         (0x21U)
#define HSP_SYNC_LOCATION                     (0x22U)
#define HSP_SYNC_WEATHER                      (0x23U)
#define HSP_SYNC_CITY                         (0x24U)
#define HSP_SYNC_NOTIFICATION_BEGIN           (0x31U)
#define HSP_SYNC_NOTIFICATION_DATA            (0x32U)
#define HSP_SYNC_LYRIC_BEGIN                  (0x41U)
#define HSP_SYNC_LYRIC_DATA                   (0x42U)
#define HSP_SYNC_COVER_BEGIN                  (0x43U)
#define HSP_SYNC_COVER_DATA                   (0x44U)
#define HSP_SYNC_PHOTO_BEGIN                  (0x45U)
#define HSP_SYNC_PHOTO_DATA                   (0x46U)
#define HSP_SYNC_PHOTO_STATUS                 (0x47U)

#define HSP_SYNC_NOTIFICATION_BEGIN_LEN       (10U)
#define HSP_SYNC_NOTIFICATION_DATA_HEADER_LEN (5U)
#define HSP_NOTIFICATION_PAYLOAD_MAX_LEN      \
    (PHONE_NOTIFICATION_TITLE_MAX_BYTES + PHONE_NOTIFICATION_BODY_MAX_BYTES)
#define HSP_SYNC_LYRIC_BEGIN_LEN              (5U)
#define HSP_SYNC_LYRIC_DATA_HEADER_LEN        (5U)
#define HSP_SYNC_COVER_BEGIN_LEN              (11U)
#define HSP_SYNC_COVER_DATA_HEADER_LEN        (7U)
#define HSP_SYNC_PHOTO_BEGIN_LEN              (11U)
#define HSP_SYNC_PHOTO_DATA_HEADER_LEN        (7U)

#define HSP_ADV_INTERVAL                     (0x00A0U) /* 100 ms */
#define HSP_VIBRATION_PERCENT                (85U)
#define HSP_VIBRATION_DURATION_MS            (1500U)
#define HSP_PENDING_NOTIFICATION_DELETES     (16U)

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

#define HSP_SYNC_UUID { \
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9, \
    0x6A, 0x4F, 0x5C, 0x8D, 0x03, 0x50, 0x6A, 0x2D \
}

#define HSP_DEVICE_STATUS_UUID { \
    0x00, 0x10, 0x7A, 0x9E, 0x0C, 0x1C, 0xB2, 0xA9, \
    0x6A, 0x4F, 0x5C, 0x8D, 0x04, 0x50, 0x6A, 0x2D \
}

static uint8_t hsp_service_uuid[HSP_UUID_LEN] = HSP_SERVICE_UUID;

typedef struct
{
    uint16_t id;
    uint16_t title_len;
    uint16_t body_len;
    uint16_t received_len;
    uint8_t app;
    uint8_t hour;
    uint8_t minute;
    uint8_t payload[HSP_NOTIFICATION_PAYLOAD_MAX_LEN];
} hsp_notification_reassembly_t;

static hsp_notification_reassembly_t hsp_notification_reassembly;

typedef struct
{
    uint16_t generation;
    uint16_t expected_len;
    uint16_t received_len;
    uint8_t payload[MUSIC_APP_LYRIC_MAX_LEN];
} hsp_lyric_reassembly_t;

static hsp_lyric_reassembly_t hsp_lyric_reassembly;

enum hsp_att_index
{
    HSP_ATT_SERVICE,
    HSP_ATT_CONTROL_CHARACTERISTIC,
    HSP_ATT_CONTROL_VALUE,
    HSP_ATT_STATE_CHARACTERISTIC,
    HSP_ATT_STATE_VALUE,
    HSP_ATT_STATE_CCCD,
    HSP_ATT_SYNC_CHARACTERISTIC,
    HSP_ATT_SYNC_VALUE,
    HSP_ATT_DEVICE_STATUS_CHARACTERISTIC,
    HSP_ATT_DEVICE_STATUS_VALUE,
    HSP_ATT_DEVICE_STATUS_CCCD,
    HSP_ATT_COUNT,
};

typedef struct
{
    uint8_t stack_ready;
    uint8_t service_ready;
    uint8_t advertising_ready;
    uint8_t requested;
    uint8_t state_subscribed;
    uint8_t device_status_subscribed;
    uint8_t conn_idx;
    uint8_t sequence;
    uint8_t ota_state;
    uint8_t ota_progress;
    uint8_t ota_status_valid;
    uint8_t battery_percent;
    uint8_t battery_valid;
    uint8_t charging;
    uint8_t state_packet[HSP_STATE_PACKET_MAX_LEN];
    uint8_t state_packet_len;
    uint8_t notification_clear_pending;
    uint8_t notification_delete_count;
    uint16_t notification_delete_ids[HSP_PENDING_NOTIFICATION_DELETES];
    uint8_t device_status_packet[HSP_STATUS_PACKET_MAX_LEN];
    uint8_t device_status_len;
    sibles_hdl service_handle;
    rt_timer_t pending_notify_timer;
} hsp_find_phone_env_t;

static hsp_find_phone_env_t g_hsp_find_phone = {
    .conn_idx = HSP_INVALID_CONN_IDX,
    .state_packet = {HSP_PHONE_FIND_STOP, 0U, 0U, 0U},
    .state_packet_len = HSP_COMMAND_PACKET_LEN,
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
                                HSP_COMMAND_PACKET_LEN),
    BLE_GATT_CHAR_DECLARE(HSP_ATT_STATE_CHARACTERISTIC,
                          SERIAL_UUID_16_CHARACTERISTIC,
                          BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_VALUE_DECLARE(HSP_ATT_STATE_VALUE, HSP_STATE_UUID,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_NOTIFY_ENABLE,
                                BLE_GATT_VALUE_PERM_UUID_128 |
                                BLE_GATT_VALUE_PERM_RI_ENABLE,
                                HSP_STATE_PACKET_MAX_LEN),
    BLE_GATT_DESCRIPTOR_DECLARE(HSP_ATT_STATE_CCCD,
                                SERIAL_UUID_16_CLIENT_CHAR_CFG,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_WRITE_REQ_ENABLE,
                                BLE_GATT_VALUE_PERM_RI_ENABLE, 2),
    BLE_GATT_CHAR_DECLARE(HSP_ATT_SYNC_CHARACTERISTIC,
                          SERIAL_UUID_16_CHARACTERISTIC,
                          BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_VALUE_DECLARE(HSP_ATT_SYNC_VALUE, HSP_SYNC_UUID,
                                BLE_GATT_PERM_WRITE_REQ_ENABLE |
                                BLE_GATT_PERM_WRITE_COMMAND_ENABLE,
                                BLE_GATT_VALUE_PERM_UUID_128,
                                HSP_SYNC_PACKET_MAX_LEN),
    BLE_GATT_CHAR_DECLARE(HSP_ATT_DEVICE_STATUS_CHARACTERISTIC,
                          SERIAL_UUID_16_CHARACTERISTIC,
                          BLE_GATT_PERM_READ_ENABLE),
    BLE_GATT_CHAR_VALUE_DECLARE(HSP_ATT_DEVICE_STATUS_VALUE, HSP_DEVICE_STATUS_UUID,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_NOTIFY_ENABLE,
                                BLE_GATT_VALUE_PERM_UUID_128 |
                                BLE_GATT_VALUE_PERM_RI_ENABLE,
                                HSP_STATUS_PACKET_MAX_LEN),
    BLE_GATT_DESCRIPTOR_DECLARE(HSP_ATT_DEVICE_STATUS_CCCD,
                                SERIAL_UUID_16_CLIENT_CHAR_CFG,
                                BLE_GATT_PERM_READ_ENABLE |
                                BLE_GATT_PERM_WRITE_REQ_ENABLE,
                                BLE_GATT_VALUE_PERM_RI_ENABLE, 2),
};

SIBLES_ADVERTISING_CONTEXT_DECLAR(g_hsp_find_phone_advertising);

static uint8_t hsp_send_phone_command(uint8_t command);
static uint8_t hsp_send_ota_status(void);
static void hsp_send_device_status(void);
static void hsp_flush_notification_commands(void);

static uint16_t hsp_read_u16_le(const uint8_t *value)
{
    return (uint16_t)value[0] | ((uint16_t)value[1] << 8U);
}

static uint32_t hsp_read_u32_le(const uint8_t *value)
{
    return (uint32_t)value[0] | ((uint32_t)value[1] << 8U) |
           ((uint32_t)value[2] << 16U) | ((uint32_t)value[3] << 24U);
}

static void hsp_reset_notification_reassembly(void)
{
    rt_memset(&hsp_notification_reassembly, 0,
              sizeof(hsp_notification_reassembly));
}

static uint8_t hsp_apply_notification_begin(const uint8_t *value,
                                            uint16_t length)
{
    uint16_t title_len;
    uint16_t body_len;
    uint16_t total_len;
    rt_err_t result;

    if (length != HSP_SYNC_NOTIFICATION_BEGIN_LEN)
        return 1U;

    title_len = hsp_read_u16_le(&value[4]);
    body_len = hsp_read_u16_le(&value[6]);
    total_len = (uint16_t)title_len + body_len;
    if (value[1] < PHONE_NOTIFICATION_APP_SMS ||
        value[1] > PHONE_NOTIFICATION_APP_QQ ||
        hsp_read_u16_le(&value[2]) == 0U ||
        title_len > PHONE_NOTIFICATION_TITLE_MAX_BYTES ||
        body_len > PHONE_NOTIFICATION_BODY_MAX_BYTES ||
        total_len > HSP_NOTIFICATION_PAYLOAD_MAX_LEN)
        return 1U;

    hsp_reset_notification_reassembly();
    hsp_notification_reassembly.id = hsp_read_u16_le(&value[2]);
    hsp_notification_reassembly.app = value[1];
    hsp_notification_reassembly.title_len = title_len;
    hsp_notification_reassembly.body_len = body_len;
    hsp_notification_reassembly.hour = value[8];
    hsp_notification_reassembly.minute = value[9];
    if (hsp_notification_reassembly.hour > 23U ||
        hsp_notification_reassembly.minute > 59U)
    {
        hsp_reset_notification_reassembly();
        return 1U;
    }

    if (total_len != 0U)
        return 0U;

    result = phone_notifications_upsert(hsp_notification_reassembly.id,
                                        hsp_notification_reassembly.app,
                                        hsp_notification_reassembly.hour,
                                        hsp_notification_reassembly.minute,
                                        RT_NULL, 0U, RT_NULL, 0U);
    hsp_reset_notification_reassembly();
    return result == RT_EOK ? 0U : 1U;
}

static uint8_t hsp_apply_notification_data(const uint8_t *value,
                                           uint16_t length)
{
    uint16_t id;
    uint16_t offset;
    uint8_t payload_len;
    uint16_t total_len;
    rt_err_t result;

    if (length <= HSP_SYNC_NOTIFICATION_DATA_HEADER_LEN)
        return 1U;

    id = hsp_read_u16_le(&value[1]);
    offset = hsp_read_u16_le(&value[3]);
    payload_len = (uint8_t)(length - HSP_SYNC_NOTIFICATION_DATA_HEADER_LEN);
    total_len = (uint16_t)hsp_notification_reassembly.title_len +
                hsp_notification_reassembly.body_len;
    if (id == 0U || id != hsp_notification_reassembly.id ||
        offset != hsp_notification_reassembly.received_len ||
        (uint16_t)offset + payload_len > total_len)
    {
        hsp_reset_notification_reassembly();
        return 1U;
    }

    rt_memcpy(&hsp_notification_reassembly.payload[offset], &value[5], payload_len);
    hsp_notification_reassembly.received_len += payload_len;
    if (hsp_notification_reassembly.received_len != total_len)
        return 0U;

    result = phone_notifications_upsert(
        hsp_notification_reassembly.id, hsp_notification_reassembly.app,
        hsp_notification_reassembly.hour,
        hsp_notification_reassembly.minute,
        hsp_notification_reassembly.payload,
        hsp_notification_reassembly.title_len,
        &hsp_notification_reassembly.payload[hsp_notification_reassembly.title_len],
        hsp_notification_reassembly.body_len);
    if (result != RT_EOK)
        LOG_W("HSP rejected phone notification: %d", result);
    else
        LOG_I("HSP phone notification synchronized: app %u",
              hsp_notification_reassembly.app);
    hsp_reset_notification_reassembly();
    return result == RT_EOK ? 0U : 1U;
}

static void hsp_reset_lyric_reassembly(void)
{
    rt_memset(&hsp_lyric_reassembly, 0, sizeof(hsp_lyric_reassembly));
}

static uint8_t hsp_apply_lyric_begin(const uint8_t *value, uint16_t length)
{
    uint16_t generation;
    uint16_t lyric_len;

    if (length != HSP_SYNC_LYRIC_BEGIN_LEN)
        return 1U;
    generation = hsp_read_u16_le(&value[1]);
    lyric_len = hsp_read_u16_le(&value[3]);
    if (generation == 0U || lyric_len > MUSIC_APP_LYRIC_MAX_LEN)
        return 1U;

    hsp_reset_lyric_reassembly();
    hsp_lyric_reassembly.generation = generation;
    hsp_lyric_reassembly.expected_len = lyric_len;
    if (lyric_len == 0U)
    {
        music_app_set_lyric(RT_NULL, 0U);
        hsp_reset_lyric_reassembly();
    }
    return 0U;
}

static uint8_t hsp_apply_lyric_data(const uint8_t *value, uint16_t length)
{
    uint16_t generation;
    uint16_t offset;
    uint16_t payload_len;

    if (length <= HSP_SYNC_LYRIC_DATA_HEADER_LEN)
        return 1U;
    generation = hsp_read_u16_le(&value[1]);
    offset = hsp_read_u16_le(&value[3]);
    payload_len = length - HSP_SYNC_LYRIC_DATA_HEADER_LEN;
    if (generation == 0U || generation != hsp_lyric_reassembly.generation ||
        offset != hsp_lyric_reassembly.received_len ||
        offset + payload_len > hsp_lyric_reassembly.expected_len)
    {
        hsp_reset_lyric_reassembly();
        return 1U;
    }

    rt_memcpy(&hsp_lyric_reassembly.payload[offset], &value[5], payload_len);
    hsp_lyric_reassembly.received_len += payload_len;
    if (hsp_lyric_reassembly.received_len == hsp_lyric_reassembly.expected_len)
    {
        music_app_set_lyric(hsp_lyric_reassembly.payload,
                            hsp_lyric_reassembly.expected_len);
        hsp_reset_lyric_reassembly();
    }
    return 0U;
}

static uint8_t hsp_apply_cover_begin(const uint8_t *value, uint16_t length)
{
    if (length != HSP_SYNC_COVER_BEGIN_LEN)
        return 1U;
    return music_app_phone_cover_begin(hsp_read_u16_le(&value[1]),
                                       hsp_read_u32_le(&value[3]),
                                       hsp_read_u32_le(&value[7])) == 0 ? 0U : 1U;
}

static uint8_t hsp_apply_cover_data(const uint8_t *value, uint16_t length)
{
    if (length <= HSP_SYNC_COVER_DATA_HEADER_LEN)
        return 1U;
    return music_app_phone_cover_data(
               hsp_read_u16_le(&value[1]), hsp_read_u32_le(&value[3]),
               &value[HSP_SYNC_COVER_DATA_HEADER_LEN],
               length - HSP_SYNC_COVER_DATA_HEADER_LEN) == 0 ? 0U : 1U;
}

static uint8_t hsp_apply_photo_begin(const uint8_t *value, uint16_t length)
{
    if (length != HSP_SYNC_PHOTO_BEGIN_LEN)
        return 1U;
    return camera_photo_begin(hsp_read_u16_le(&value[1]),
                              hsp_read_u32_le(&value[3]),
                              hsp_read_u32_le(&value[7])) == 0 ? 0U : 1U;
}

static uint8_t hsp_apply_photo_data(const uint8_t *value, uint16_t length)
{
    if (length <= HSP_SYNC_PHOTO_DATA_HEADER_LEN)
        return 1U;
    return camera_photo_data(hsp_read_u16_le(&value[1]),
                             hsp_read_u32_le(&value[3]),
                             &value[HSP_SYNC_PHOTO_DATA_HEADER_LEN],
                             length - HSP_SYNC_PHOTO_DATA_HEADER_LEN) == 0 ?
           0U : 1U;
}

static uint8_t hsp_apply_sync_packet(const uint8_t *value, uint16_t length)
{
    rt_err_t result;

    if (value == RT_NULL || length == 0U || length > HSP_SYNC_PACKET_MAX_LEN)
        return 1U;

    switch (value[0])
    {
    case HSP_SYNC_TIME:
        if (length != HSP_SYNC_TIME_PACKET_LEN)
            return 1U;
        result = phone_sync_set_time(hsp_read_u32_le(&value[1]),
                                     (int16_t)hsp_read_u16_le(&value[5]));
        if (result != RT_EOK)
        {
            LOG_W("HSP rejected phone time sync: %d", result);
            return 1U;
        }
        LOG_I("HSP phone time and timezone synchronized");
        break;

    case HSP_SYNC_LOCATION:
        if (length != HSP_SYNC_LOCATION_PACKET_LEN)
            return 1U;
        result = phone_sync_set_location((int32_t)hsp_read_u32_le(&value[1]),
                                         (int32_t)hsp_read_u32_le(&value[5]),
                                         hsp_read_u16_le(&value[9]), 0U);
        if (result != RT_EOK)
        {
            LOG_W("HSP rejected phone location sync: %d", result);
            return 1U;
        }
        LOG_I("HSP phone location synchronized");
        break;

    case HSP_SYNC_WEATHER:
        if (length != HSP_SYNC_WEATHER_PACKET_LEN)
            return 1U;
        result = phone_sync_set_weather(value[1],
                                        (int16_t)hsp_read_u16_le(&value[2]),
                                        (int16_t)hsp_read_u16_le(&value[4]),
                                        (int16_t)hsp_read_u16_le(&value[6]),
                                        value[8], hsp_read_u32_le(&value[9]));
        if (result != RT_EOK)
        {
            LOG_W("HSP rejected phone weather sync: %d", result);
            return 1U;
        }
        LOG_I("HSP phone weather synchronized");
        break;

    case HSP_SYNC_CITY:
        if (length < 2U || length > HSP_STATUS_PACKET_MAX_LEN)
            return 1U;
        result = phone_sync_set_city(&value[1], (uint8_t)(length - 1U));
        if (result != RT_EOK)
        {
            LOG_W("HSP rejected phone city sync: %d", result);
            return 1U;
        }
        LOG_I("HSP phone city synchronized");
        break;

    case HSP_SYNC_NOTIFICATION_BEGIN:
        return hsp_apply_notification_begin(value, length);

    case HSP_SYNC_NOTIFICATION_DATA:
        return hsp_apply_notification_data(value, length);

    case HSP_SYNC_LYRIC_BEGIN:
        return hsp_apply_lyric_begin(value, length);

    case HSP_SYNC_LYRIC_DATA:
        return hsp_apply_lyric_data(value, length);

    case HSP_SYNC_COVER_BEGIN:
        return hsp_apply_cover_begin(value, length);

    case HSP_SYNC_COVER_DATA:
        return hsp_apply_cover_data(value, length);

    case HSP_SYNC_PHOTO_BEGIN:
        return hsp_apply_photo_begin(value, length);

    case HSP_SYNC_PHOTO_DATA:
        return hsp_apply_photo_data(value, length);

    case HSP_SYNC_PHOTO_STATUS:
        if (length != 2U)
            return 1U;
        camera_photo_report_status(value[1]);
        return 0U;

    default:
        LOG_W("HSP unknown phone sync packet: %u", value[0]);
        return 1U;
    }

    return 0U;
}

/*
 * Packet: schema, flags, battery percent (or 0xFF), version length, version,
 * then optional activity data: steps u32 LE, kcal u16 LE, distance meters u32 LE.
 */
static void hsp_build_device_status_packet(void)
{
    activity_metrics_t activity_metrics;
    const char *firmware_version = HSP_WATCH_FIRMWARE_VERSION;
    uint8_t version_len = (uint8_t)strlen(firmware_version);
    uint8_t activity_len = 0U;
    uint8_t offset;
    uint8_t flags = 0U;

    activity_tracker_get_metrics(&activity_metrics);
    if (activity_metrics.valid)
        activity_len = HSP_STATUS_PACKET_ACTIVITY_LEN;
    if (version_len > HSP_STATUS_PACKET_MAX_LEN - HSP_STATUS_PACKET_HEADER_LEN -
                      activity_len)
        version_len = HSP_STATUS_PACKET_MAX_LEN - HSP_STATUS_PACKET_HEADER_LEN -
                      activity_len;

    if (g_hsp_find_phone.stack_ready)
        flags |= HSP_STATUS_FLAG_BLE_ENABLED;
    if (g_hsp_find_phone.conn_idx != HSP_INVALID_CONN_IDX)
        flags |= HSP_STATUS_FLAG_COMPANION_CONNECTED;
    if (g_hsp_find_phone.battery_valid)
        flags |= HSP_STATUS_FLAG_BATTERY_VALID;
    if (g_hsp_find_phone.charging)
        flags |= HSP_STATUS_FLAG_CHARGING;
    if (activity_metrics.valid)
        flags |= HSP_STATUS_FLAG_ACTIVITY_VALID;

    g_hsp_find_phone.device_status_packet[0] = HSP_STATUS_PROTOCOL_VERSION;
    g_hsp_find_phone.device_status_packet[1] = flags;
    g_hsp_find_phone.device_status_packet[2] =
        g_hsp_find_phone.battery_valid ? g_hsp_find_phone.battery_percent :
                                          HSP_STATUS_UNKNOWN_BATTERY_PERCENT;
    g_hsp_find_phone.device_status_packet[3] = version_len;
    memcpy(&g_hsp_find_phone.device_status_packet[HSP_STATUS_PACKET_HEADER_LEN],
           firmware_version, version_len);
    offset = HSP_STATUS_PACKET_HEADER_LEN + version_len;
    if (activity_metrics.valid)
    {
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)(activity_metrics.steps & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.steps >> 8U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.steps >> 16U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.steps >> 24U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)(activity_metrics.calories_kcal & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.calories_kcal >> 8U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)(activity_metrics.distance_meters & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.distance_meters >> 8U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.distance_meters >> 16U) & 0xFFU);
        g_hsp_find_phone.device_status_packet[offset++] =
            (uint8_t)((activity_metrics.distance_meters >> 24U) & 0xFFU);
    }
    g_hsp_find_phone.device_status_len = offset;
}

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
        *length = g_hsp_find_phone.state_packet_len;
        return g_hsp_find_phone.state_packet;
    }
    if (index == HSP_ATT_DEVICE_STATUS_VALUE)
    {
        hsp_build_device_status_packet();
        *length = g_hsp_find_phone.device_status_len;
        return g_hsp_find_phone.device_status_packet;
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
        case HSP_WATCH_OTA_CHECK:
            if (ota_service_check() != RT_EOK)
                LOG_W("HSP OTA check command rejected");
            else
                LOG_I("HSP OTA check command received");
            break;
        case HSP_WATCH_OTA_INSTALL:
            if (ota_service_install() != RT_EOK)
                LOG_W("HSP OTA install command rejected");
            else
                LOG_I("HSP OTA install command received");
            break;
        default:
            LOG_W("HSP unknown control command: %u", parameter->value[0]);
            return 1U;
        }
        break;

    case HSP_ATT_SYNC_VALUE:
        return hsp_apply_sync_packet(parameter->value, parameter->len);

    case HSP_ATT_STATE_CCCD:
        if (parameter->len < 1U || parameter->value == RT_NULL)
            return 1U;

        g_hsp_find_phone.conn_idx = conn_idx;
        g_hsp_find_phone.state_subscribed =
            parameter->value[0] != 0U ? 1U : 0U;
        music_app_set_companion_connected(g_hsp_find_phone.state_subscribed);
        LOG_I("HSP companion state notification %s on conn %u",
              g_hsp_find_phone.state_subscribed ? "enabled" : "disabled",
              conn_idx);
        if (g_hsp_find_phone.state_subscribed && g_hsp_find_phone.requested)
            hsp_schedule_pending_notify();
        if (g_hsp_find_phone.state_subscribed)
        {
            hsp_flush_notification_commands();
            hsp_send_ota_status();
        }
        break;

    case HSP_ATT_DEVICE_STATUS_CCCD:
        if (parameter->len < 1U || parameter->value == RT_NULL)
            return 1U;

        g_hsp_find_phone.conn_idx = conn_idx;
        g_hsp_find_phone.device_status_subscribed =
            parameter->value[0] != 0U ? 1U : 0U;
        LOG_I("HSP device status notification %s on conn %u",
              g_hsp_find_phone.device_status_subscribed ? "enabled" : "disabled",
              conn_idx);
        if (g_hsp_find_phone.device_status_subscribed)
            hsp_send_device_status();
        break;

    default:
        return 1U;
    }

    return 0U;
}

static uint8_t hsp_send_phone_command(uint8_t command)
{
    sibles_value_t value;
    int result;

    g_hsp_find_phone.state_packet[0] = command;
    g_hsp_find_phone.state_packet[1] = ++g_hsp_find_phone.sequence;
    g_hsp_find_phone.state_packet_len = HSP_COMMAND_PACKET_LEN;

    if (!g_hsp_find_phone.service_ready ||
        !g_hsp_find_phone.state_subscribed ||
        g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
    {
        LOG_W("HSP companion command queued without an Android subscriber");
        return 0U;
    }

    memset(&value, 0, sizeof(value));
    value.hdl = g_hsp_find_phone.service_handle;
    value.idx = HSP_ATT_STATE_VALUE;
    value.len = g_hsp_find_phone.state_packet_len;
    value.value = g_hsp_find_phone.state_packet;
    result = sibles_write_value(g_hsp_find_phone.conn_idx, &value);
    if (result != g_hsp_find_phone.state_packet_len)
    {
        LOG_W("HSP companion notification failed: %d", result);
        return 0U;
    }
    return 1U;
}

static uint8_t hsp_send_ota_status(void)
{
    sibles_value_t value;
    int result;

    if (!g_hsp_find_phone.ota_status_valid)
        return 0U;
    g_hsp_find_phone.state_packet[0] = HSP_PHONE_OTA_STATUS;
    g_hsp_find_phone.state_packet[1] = ++g_hsp_find_phone.sequence;
    g_hsp_find_phone.state_packet[2] = g_hsp_find_phone.ota_state;
    g_hsp_find_phone.state_packet[3] = g_hsp_find_phone.ota_progress;
    g_hsp_find_phone.state_packet_len = 4U;

    if (!g_hsp_find_phone.service_ready ||
        !g_hsp_find_phone.state_subscribed ||
        g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
        return 0U;

    memset(&value, 0, sizeof(value));
    value.hdl = g_hsp_find_phone.service_handle;
    value.idx = HSP_ATT_STATE_VALUE;
    value.len = g_hsp_find_phone.state_packet_len;
    value.value = g_hsp_find_phone.state_packet;
    result = sibles_write_value(g_hsp_find_phone.conn_idx, &value);
    return result == g_hsp_find_phone.state_packet_len ? 1U : 0U;
}

static uint8_t hsp_send_notification_command(uint8_t command, uint16_t id)
{
    sibles_value_t value;
    int result;

    g_hsp_find_phone.state_packet[0] = command;
    g_hsp_find_phone.state_packet[1] = ++g_hsp_find_phone.sequence;
    g_hsp_find_phone.state_packet_len = HSP_COMMAND_PACKET_LEN;
    if (command == HSP_PHONE_NOTIFICATION_DELETE)
    {
        g_hsp_find_phone.state_packet[2] = (uint8_t)(id & 0xFFU);
        g_hsp_find_phone.state_packet[3] = (uint8_t)(id >> 8U);
        g_hsp_find_phone.state_packet_len = HSP_STATE_PACKET_MAX_LEN;
    }

    if (!g_hsp_find_phone.service_ready ||
        !g_hsp_find_phone.state_subscribed ||
        g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
    {
        LOG_W("HSP notification delete was local only; Android is disconnected");
        return 0U;
    }

    memset(&value, 0, sizeof(value));
    value.hdl = g_hsp_find_phone.service_handle;
    value.idx = HSP_ATT_STATE_VALUE;
    value.len = g_hsp_find_phone.state_packet_len;
    value.value = g_hsp_find_phone.state_packet;
    result = sibles_write_value(g_hsp_find_phone.conn_idx, &value);
    if (result != g_hsp_find_phone.state_packet_len)
    {
        LOG_W("HSP notification delete sync failed: %d", result);
        return 0U;
    }

    return 1U;
}

static void hsp_queue_notification_delete(uint16_t id)
{
    uint8_t index;

    if (g_hsp_find_phone.notification_clear_pending)
        return;
    for (index = 0U; index < g_hsp_find_phone.notification_delete_count; index++)
    {
        if (g_hsp_find_phone.notification_delete_ids[index] == id)
            return;
    }
    if (g_hsp_find_phone.notification_delete_count >=
        HSP_PENDING_NOTIFICATION_DELETES)
    {
        LOG_W("HSP notification delete queue is full");
        return;
    }

    g_hsp_find_phone.notification_delete_ids[
        g_hsp_find_phone.notification_delete_count++] = id;
}

static void hsp_flush_notification_commands(void)
{
    uint8_t index;
    uint8_t remaining = 0U;

    if (g_hsp_find_phone.notification_clear_pending)
    {
        if (hsp_send_notification_command(HSP_PHONE_NOTIFICATION_CLEAR, 0U))
            g_hsp_find_phone.notification_clear_pending = 0U;
        return;
    }

    for (index = 0U; index < g_hsp_find_phone.notification_delete_count; index++)
    {
        uint16_t id = g_hsp_find_phone.notification_delete_ids[index];

        if (!hsp_send_notification_command(HSP_PHONE_NOTIFICATION_DELETE, id))
            g_hsp_find_phone.notification_delete_ids[remaining++] = id;
    }
    g_hsp_find_phone.notification_delete_count = remaining;
}

static void hsp_send_device_status(void)
{
    sibles_value_t value;
    int result;

    if (!g_hsp_find_phone.service_ready ||
        !g_hsp_find_phone.device_status_subscribed ||
        g_hsp_find_phone.conn_idx == HSP_INVALID_CONN_IDX)
    {
        return;
    }

    hsp_build_device_status_packet();
    memset(&value, 0, sizeof(value));
    value.hdl = g_hsp_find_phone.service_handle;
    value.idx = HSP_ATT_DEVICE_STATUS_VALUE;
    value.len = g_hsp_find_phone.device_status_len;
    value.value = g_hsp_find_phone.device_status_packet;
    result = sibles_write_value(g_hsp_find_phone.conn_idx, &value);
    if (result != g_hsp_find_phone.device_status_len)
        LOG_W("HSP device status notification failed: %d", result);
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
            g_hsp_find_phone.device_status_subscribed = 0U;
            hsp_reset_notification_reassembly();
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
            g_hsp_find_phone.device_status_subscribed = 0U;
            hsp_reset_notification_reassembly();
            hsp_reset_lyric_reassembly();
            camera_photo_cancel();
            music_app_set_companion_connected(0);
            LOG_I("HSP companion BLE peer disconnected: %u", disconnected->reason);
        }
        break;
    }

    case SIBLES_MTU_EXCHANGE_IND:
    {
        const sibles_mtu_exchange_ind_t *mtu =
            (const sibles_mtu_exchange_ind_t *)data;

        if (mtu != RT_NULL && mtu->conn_idx == g_hsp_find_phone.conn_idx)
            LOG_I("HSP companion MTU negotiated: %u", mtu->mtu);
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

uint8_t find_phone_ble_request_photo_preview(void)
{
    return hsp_send_phone_command(HSP_PHONE_PHOTO_REQUEST);
}

void find_phone_ble_publish_device_status(uint8_t percent, uint8_t battery_valid,
                                          uint8_t charging)
{
    uint8_t changed;

    if (percent > 100U)
        percent = 100U;
    battery_valid = battery_valid ? 1U : 0U;
    charging = charging ? 1U : 0U;
    changed = g_hsp_find_phone.battery_percent != percent ||
              g_hsp_find_phone.battery_valid != battery_valid ||
              g_hsp_find_phone.charging != charging;

    g_hsp_find_phone.battery_percent = percent;
    g_hsp_find_phone.battery_valid = battery_valid;
    g_hsp_find_phone.charging = charging;
    if (changed)
        hsp_send_device_status();
}

void find_phone_ble_publish_activity(void)
{
    hsp_send_device_status();
}

void find_phone_ble_publish_ota_status(uint8_t state, uint8_t progress_percent)
{
    g_hsp_find_phone.ota_state = state;
    g_hsp_find_phone.ota_progress = progress_percent > 100U ? 100U :
                                                              progress_percent;
    g_hsp_find_phone.ota_status_valid = 1U;
    hsp_send_ota_status();
}

void find_phone_ble_delete_notification(uint16_t id)
{
    if (id == 0U)
        return;

    if (!hsp_send_notification_command(HSP_PHONE_NOTIFICATION_DELETE, id))
        hsp_queue_notification_delete(id);
}

void find_phone_ble_clear_notifications(void)
{
    g_hsp_find_phone.notification_delete_count = 0U;
    if (hsp_send_notification_command(HSP_PHONE_NOTIFICATION_CLEAR, 0U))
    {
        g_hsp_find_phone.notification_clear_pending = 0U;
        return;
    }
    g_hsp_find_phone.notification_clear_pending = 1U;
}

void find_phone_ble_close(void)
{
    g_hsp_find_phone.requested = 0U;
    g_hsp_find_phone.state_subscribed = 0U;
    g_hsp_find_phone.device_status_subscribed = 0U;
    g_hsp_find_phone.conn_idx = HSP_INVALID_CONN_IDX;
    hsp_reset_notification_reassembly();
    hsp_reset_lyric_reassembly();
    camera_photo_cancel();
    music_app_set_companion_connected(0);

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
