#ifndef LCHSPI_PHONE_NOTIFICATIONS_H_INCLUDED
#define LCHSPI_PHONE_NOTIFICATIONS_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PHONE_NOTIFICATION_MAX_ITEMS       5U
#define PHONE_NOTIFICATION_TITLE_MAX_BYTES 96U
#define PHONE_NOTIFICATION_BODY_MAX_BYTES  512U

typedef enum
{
    PHONE_NOTIFICATION_APP_SMS = 1,
    PHONE_NOTIFICATION_APP_WECHAT = 2,
    PHONE_NOTIFICATION_APP_QQ = 3,
} phone_notification_app_t;

typedef struct
{
    uint16_t id;
    uint16_t title_len;
    uint16_t body_len;
    uint8_t app;
    uint8_t hour;
    uint8_t minute;
    uint8_t valid;
    char title[PHONE_NOTIFICATION_TITLE_MAX_BYTES + 1U];
    char body[PHONE_NOTIFICATION_BODY_MAX_BYTES + 1U];
} phone_notification_t;

typedef struct
{
    uint8_t count;
    uint32_t revision;
    phone_notification_t items[PHONE_NOTIFICATION_MAX_ITEMS];
} phone_notification_snapshot_t;

/* Prepare the in-memory recent-message cache used by the companion BLE service. */
void phone_notifications_init(void);

/* Insert or replace a recent notification. title and body are UTF-8 byte strings. */
rt_err_t phone_notifications_upsert(uint16_t id, uint8_t app,
                                    uint8_t hour, uint8_t minute,
                                    const uint8_t *title, uint16_t title_len,
                                    const uint8_t *body, uint16_t body_len);

/* Remove messages locally. BLE synchronization with the phone is handled by
 * find_phone_ble after these operations succeed. */
rt_err_t phone_notifications_remove(uint16_t id);
void phone_notifications_clear(void);

/* Read lightweight cache state without copying every notification. */
uint32_t phone_notifications_get_revision(void);
uint8_t phone_notifications_get_count(void);

/* Copy one notification by id into item. */
rt_err_t phone_notifications_get(uint16_t id, phone_notification_t *item);

/* Copy a coherent snapshot of the newest messages, ordered oldest to newest. */
void phone_notifications_get_snapshot(phone_notification_snapshot_t *snapshot);

#ifdef __cplusplus
}
#endif

#endif
