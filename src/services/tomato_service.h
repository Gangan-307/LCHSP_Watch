#ifndef LCHSPI_TOMATO_SERVICE_H_INCLUDED
#define LCHSPI_TOMATO_SERVICE_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define TOMATO_DEFAULT_FOCUS_MINUTES       (25U)
#define TOMATO_DEFAULT_SHORT_BREAK_MINUTES (5U)
#define TOMATO_DEFAULT_LONG_BREAK_MINUTES  (15U)
#define TOMATO_LONG_BREAK_AFTER_COUNT      (4U)

typedef enum
{
    TOMATO_PHASE_FOCUS,
    TOMATO_PHASE_SHORT_BREAK,
    TOMATO_PHASE_LONG_BREAK,
} tomato_phase_t;

typedef enum
{
    TOMATO_RUN_IDLE,
    TOMATO_RUN_RUNNING,
    TOMATO_RUN_PAUSED,
} tomato_run_state_t;

typedef struct
{
    uint16_t focus_minutes;
    uint16_t short_break_minutes;
    uint16_t long_break_minutes;
    uint8_t sound_enabled;
    uint8_t vibration_enabled;
} tomato_settings_t;

typedef struct
{
    tomato_settings_t settings;
    tomato_phase_t phase;
    tomato_run_state_t run_state;
    uint32_t remaining_seconds;
    uint32_t phase_total_seconds;
    uint8_t cycle_pomodoros;
    uint16_t today_pomodoros;
    uint32_t today_focus_minutes;
} tomato_snapshot_t;

typedef enum
{
    TOMATO_EVENT_CHANGED,
    TOMATO_EVENT_PHASE_FINISHED,
    TOMATO_EVENT_DAILY_RESET,
} tomato_event_t;

typedef void (*tomato_event_cb_t)(tomato_event_t event);

void tomato_service_init(void);
void tomato_service_set_event_handler(tomato_event_cb_t callback);
void tomato_service_get_snapshot(tomato_snapshot_t *snapshot);
rt_err_t tomato_service_update_settings(const tomato_settings_t *settings);

rt_err_t tomato_service_start(void);
rt_err_t tomato_service_pause(void);
rt_err_t tomato_service_resume(void);
rt_err_t tomato_service_end(void);
rt_err_t tomato_service_skip(void);

/* Override this weak hook when a dedicated prompt-tone backend is available. */
void tomato_service_play_tone(tomato_phase_t finished_phase);

#ifdef __cplusplus
}
#endif

#endif
