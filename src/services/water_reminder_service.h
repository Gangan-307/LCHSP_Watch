#ifndef LCHSPI_WATER_REMINDER_SERVICE_H_INCLUDED
#define LCHSPI_WATER_REMINDER_SERVICE_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define WATER_REMINDER_DEFAULT_SERVING_ML  (200U)
#define WATER_REMINDER_DEFAULT_TARGET_ML   (1500U)

typedef struct
{
    uint8_t enabled;
    uint8_t start_hour;
    uint8_t start_minute;
    uint8_t end_hour;
    uint8_t end_minute;
    uint16_t interval_minutes;
    uint16_t snooze_minutes;
    uint16_t serving_ml;
    uint16_t target_ml;
} water_reminder_settings_t;

typedef struct
{
    water_reminder_settings_t settings;
    uint16_t today_ml;
    uint8_t next_valid_today;
    uint8_t next_hour;
    uint8_t next_minute;
    uint8_t reminding;
} water_reminder_snapshot_t;

typedef enum
{
    WATER_REMINDER_EVENT_CHANGED,
    WATER_REMINDER_EVENT_STARTED,
    WATER_REMINDER_EVENT_STOPPED,
} water_reminder_event_t;

typedef void (*water_reminder_event_cb_t)(water_reminder_event_t event);
typedef uint8_t (*water_reminder_present_guard_t)(void);

void water_reminder_service_init(void);
void water_reminder_service_set_event_handler(
    water_reminder_event_cb_t callback);
void water_reminder_service_set_present_guard(
    water_reminder_present_guard_t callback);

void water_reminder_service_get_snapshot(water_reminder_snapshot_t *snapshot);
rt_err_t water_reminder_service_update_settings(
    const water_reminder_settings_t *settings);

void water_reminder_service_drink(void);
void water_reminder_service_snooze(void);
void water_reminder_service_skip(void);
uint8_t water_reminder_service_is_reminding(void);

/* Call-state integration can suppress reminders without changing schedules. */
void water_reminder_service_set_external_suppressed(uint8_t suppressed);

#ifdef __cplusplus
}
#endif

#endif
