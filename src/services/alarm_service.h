#ifndef LCHSPI_ALARM_SERVICE_H_INCLUDED
#define LCHSPI_ALARM_SERVICE_H_INCLUDED

#include <stdint.h>
#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define ALARM_SERVICE_MAX_ALARMS       (5U)

#define ALARM_REPEAT_MONDAY            (1U << 0)
#define ALARM_REPEAT_TUESDAY           (1U << 1)
#define ALARM_REPEAT_WEDNESDAY         (1U << 2)
#define ALARM_REPEAT_THURSDAY          (1U << 3)
#define ALARM_REPEAT_FRIDAY            (1U << 4)
#define ALARM_REPEAT_SATURDAY          (1U << 5)
#define ALARM_REPEAT_SUNDAY            (1U << 6)
#define ALARM_REPEAT_EVERY_DAY         (0x7FU)

typedef struct
{
    uint8_t hour;
    uint8_t minute;
    uint8_t repeat_mask;
    uint8_t enabled;
} alarm_entry_t;

typedef enum
{
    ALARM_SERVICE_EVENT_CHANGED,
    ALARM_SERVICE_EVENT_RING_STARTED,
    ALARM_SERVICE_EVENT_RING_STOPPED,
} alarm_service_event_t;

typedef void (*alarm_service_event_cb_t)(alarm_service_event_t event,
                                         uint8_t alarm_index);

void alarm_service_init(void);
void alarm_service_set_event_handler(alarm_service_event_cb_t callback);
void alarm_service_make_default(alarm_entry_t *entry);

uint8_t alarm_service_count(void);
rt_err_t alarm_service_get(uint8_t index, alarm_entry_t *entry);
rt_err_t alarm_service_add(const alarm_entry_t *entry, uint8_t *index_out);
rt_err_t alarm_service_update(uint8_t index, const alarm_entry_t *entry);
rt_err_t alarm_service_remove(uint8_t index);
rt_err_t alarm_service_set_enabled(uint8_t index, uint8_t enabled);

rt_err_t alarm_service_get_next(alarm_entry_t *entry, uint8_t *index_out,
                                uint32_t *minutes_until);
uint8_t alarm_service_is_ringing(void);
rt_err_t alarm_service_preview(uint8_t index);
void alarm_service_snooze(void);
void alarm_service_dismiss(void);

#ifdef __cplusplus
}
#endif

#endif
