#include "tomato_service.h"

#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "bf0_hal.h"
#include "lvgl.h"
#include "drivers/vibrator.h"
#include "services/alarm_service.h"
#include "services/water_reminder_service.h"

#define TOMATO_CONFIG_MAGIC          (0x48535054UL)
#define TOMATO_CONFIG_VERSION        (1U)
#define TOMATO_CONFIG_PATH           "/tomato_config.bin"
#define TOMATO_CONFIG_TEMP_PATH      "/tomato_config.tmp"
#define TOMATO_CHECK_PERIOD_MS       (250U)
#define TOMATO_MIN_DURATION_MINUTES  (1U)
#define TOMATO_MAX_DURATION_MINUTES  (99U)
#define TOMATO_VIBRATION_LEVEL       (78U)
#define TOMATO_VIBRATION_MS          (500U)

typedef struct
{
    uint32_t magic;
    uint16_t version;
    uint16_t reserved;
    tomato_settings_t settings;
    uint16_t today_pomodoros;
    uint32_t today_focus_minutes;
    uint32_t day_key;
    uint32_t checksum;
} tomato_config_file_t;

extern RTC_HandleTypeDef RTC_Handler;

static tomato_settings_t tomato_settings;
static tomato_phase_t tomato_phase;
static tomato_run_state_t tomato_run_state;
static uint32_t tomato_remaining_seconds;
static uint32_t tomato_phase_total_seconds;
static uint32_t tomato_run_segment_seconds;
static uint32_t tomato_phase_started_tick;
static uint16_t tomato_focus_credit_minutes;
static uint8_t tomato_cycle_pomodoros;
static uint16_t tomato_today_pomodoros;
static uint32_t tomato_today_focus_minutes;
static uint32_t tomato_day_key;
static uint8_t tomato_initialized;
static lv_timer_t *tomato_check_timer;
static tomato_event_cb_t tomato_event_handler;

static uint32_t tomato_checksum(const void *data, size_t size)
{
    const uint8_t *bytes = (const uint8_t *)data;
    uint32_t hash = 2166136261UL;
    size_t index;

    for (index = 0U; index < size; index++)
    {
        hash ^= bytes[index];
        hash *= 16777619UL;
    }
    return hash;
}

static void tomato_make_default_settings(tomato_settings_t *settings)
{
    rt_memset(settings, 0, sizeof(*settings));
    settings->focus_minutes = TOMATO_DEFAULT_FOCUS_MINUTES;
    settings->short_break_minutes = TOMATO_DEFAULT_SHORT_BREAK_MINUTES;
    settings->long_break_minutes = TOMATO_DEFAULT_LONG_BREAK_MINUTES;
    settings->sound_enabled = 0U;
    settings->vibration_enabled = 1U;
}

static uint8_t tomato_settings_valid(const tomato_settings_t *settings)
{
    return settings != NULL &&
           settings->focus_minutes >= TOMATO_MIN_DURATION_MINUTES &&
           settings->focus_minutes <= TOMATO_MAX_DURATION_MINUTES &&
           settings->short_break_minutes >= TOMATO_MIN_DURATION_MINUTES &&
           settings->short_break_minutes <= TOMATO_MAX_DURATION_MINUTES &&
           settings->long_break_minutes >= TOMATO_MIN_DURATION_MINUTES &&
           settings->long_break_minutes <= TOMATO_MAX_DURATION_MINUTES;
}

static uint8_t tomato_get_rtc(RTC_TimeTypeDef *time, RTC_DateTypeDef *date)
{
    uint8_t retries = 3U;

    if (HAL_RTC_GetTime(&RTC_Handler, time, RTC_FORMAT_BIN) != HAL_OK)
        return 0U;
    while (HAL_RTC_GetDate(&RTC_Handler, date, RTC_FORMAT_BIN) != HAL_OK)
    {
        if (--retries == 0U)
            return 0U;
        if (HAL_RTC_GetTime(&RTC_Handler, time, RTC_FORMAT_BIN) != HAL_OK)
            return 0U;
    }
    return 1U;
}

static uint32_t tomato_make_day_key(const RTC_DateTypeDef *date)
{
    uint32_t key = (uint32_t)(date->Year & 0xFFU);

    key = key * 13U + date->Month;
    key = key * 32U + date->Date;
    return key == 0U ? 1U : key;
}

static uint32_t tomato_phase_duration_seconds(tomato_phase_t phase)
{
    uint16_t minutes;

    if (phase == TOMATO_PHASE_SHORT_BREAK)
        minutes = tomato_settings.short_break_minutes;
    else if (phase == TOMATO_PHASE_LONG_BREAK)
        minutes = tomato_settings.long_break_minutes;
    else
        minutes = tomato_settings.focus_minutes;
    return (uint32_t)minutes * 60U;
}

static void tomato_emit(tomato_event_t event)
{
    if (tomato_event_handler != NULL)
        tomato_event_handler(event);
}

static rt_err_t tomato_save(void)
{
#ifdef RT_USING_DFS
    tomato_config_file_t config;
    FILE *file;
    size_t written;
    int failed = 0;

    rt_memset(&config, 0, sizeof(config));
    config.magic = TOMATO_CONFIG_MAGIC;
    config.version = TOMATO_CONFIG_VERSION;
    config.settings = tomato_settings;
    config.today_pomodoros = tomato_today_pomodoros;
    config.today_focus_minutes = tomato_today_focus_minutes;
    config.day_key = tomato_day_key;
    config.checksum = tomato_checksum(&config,
                                      sizeof(config) - sizeof(config.checksum));

    file = fopen(TOMATO_CONFIG_TEMP_PATH, "wb");
    if (file == NULL)
        return -RT_ERROR;
    written = fwrite(&config, sizeof(config), 1U, file);
    if (written != 1U || fflush(file) != 0)
        failed = 1;
    if (fclose(file) != 0)
        failed = 1;
    if (failed)
    {
        remove(TOMATO_CONFIG_TEMP_PATH);
        return -RT_ERROR;
    }
    remove(TOMATO_CONFIG_PATH);
    if (rename(TOMATO_CONFIG_TEMP_PATH, TOMATO_CONFIG_PATH) != 0)
    {
        remove(TOMATO_CONFIG_TEMP_PATH);
        return -RT_ERROR;
    }
    return RT_EOK;
#else
    return -RT_ENOSYS;
#endif
}

static void tomato_load(void)
{
#ifdef RT_USING_DFS
    tomato_config_file_t config;
    FILE *file;
    size_t read_count;
    uint32_t checksum;

    file = fopen(TOMATO_CONFIG_PATH, "rb");
    if (file == NULL)
        return;
    rt_memset(&config, 0, sizeof(config));
    read_count = fread(&config, sizeof(config), 1U, file);
    fclose(file);
    checksum = tomato_checksum(&config,
                               sizeof(config) - sizeof(config.checksum));
    if (read_count != 1U || config.magic != TOMATO_CONFIG_MAGIC ||
        config.version != TOMATO_CONFIG_VERSION ||
        config.checksum != checksum ||
        !tomato_settings_valid(&config.settings))
        return;

    tomato_settings = config.settings;
    tomato_settings.sound_enabled =
        tomato_settings.sound_enabled ? 1U : 0U;
    tomato_settings.vibration_enabled =
        tomato_settings.vibration_enabled ? 1U : 0U;
    tomato_today_pomodoros = config.today_pomodoros;
    tomato_today_focus_minutes = config.today_focus_minutes;
    tomato_day_key = config.day_key;
#endif
}

static uint32_t tomato_get_remaining_seconds(void)
{
    uint32_t elapsed_ms;
    uint32_t total_ms;

    if (tomato_run_state != TOMATO_RUN_RUNNING)
        return tomato_remaining_seconds;

    elapsed_ms = lv_tick_elaps(tomato_phase_started_tick);
    total_ms = tomato_run_segment_seconds * 1000U;
    if (elapsed_ms >= total_ms)
        return 0U;
    return (total_ms - elapsed_ms + 999U) / 1000U;
}

static void tomato_reset_runtime(void)
{
    tomato_phase = TOMATO_PHASE_FOCUS;
    tomato_run_state = TOMATO_RUN_IDLE;
    tomato_phase_total_seconds =
        tomato_phase_duration_seconds(TOMATO_PHASE_FOCUS);
    tomato_remaining_seconds = tomato_phase_total_seconds;
    tomato_run_segment_seconds = tomato_phase_total_seconds;
    tomato_focus_credit_minutes = tomato_settings.focus_minutes;
    tomato_cycle_pomodoros = 0U;
}

static void tomato_refresh_day(void)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t current_day;

    if (!tomato_get_rtc(&time, &date))
        return;
    current_day = tomato_make_day_key(&date);
    if (tomato_day_key == current_day)
        return;

    tomato_day_key = current_day;
    tomato_today_pomodoros = 0U;
    tomato_today_focus_minutes = 0U;
    (void)tomato_save();
    tomato_emit(TOMATO_EVENT_DAILY_RESET);
}

RT_WEAK void tomato_service_play_tone(tomato_phase_t finished_phase)
{
    (void)finished_phase;
}

static void tomato_notify_phase_finished(tomato_phase_t finished_phase)
{
    if (alarm_service_is_ringing() ||
        water_reminder_service_is_reminding())
        return;

    if (tomato_settings.vibration_enabled)
        (void)vibrator_vibrate(TOMATO_VIBRATION_LEVEL,
                               TOMATO_VIBRATION_MS);
    if (tomato_settings.sound_enabled)
        tomato_service_play_tone(finished_phase);
}

static void tomato_begin_phase(tomato_phase_t phase)
{
    tomato_phase = phase;
    tomato_phase_total_seconds = tomato_phase_duration_seconds(phase);
    tomato_remaining_seconds = tomato_phase_total_seconds;
    tomato_run_segment_seconds = tomato_phase_total_seconds;
    tomato_phase_started_tick = lv_tick_get();
    tomato_run_state = TOMATO_RUN_RUNNING;
    if (phase == TOMATO_PHASE_FOCUS)
        tomato_focus_credit_minutes = tomato_settings.focus_minutes;
}

static void tomato_advance_phase(uint8_t completed)
{
    tomato_phase_t finished_phase = tomato_phase;
    tomato_phase_t next_phase;

    if (finished_phase == TOMATO_PHASE_FOCUS)
    {
        if (completed)
        {
            if (tomato_today_pomodoros < UINT16_MAX)
                tomato_today_pomodoros++;
            if (UINT32_MAX - tomato_today_focus_minutes <
                tomato_focus_credit_minutes)
                tomato_today_focus_minutes = UINT32_MAX;
            else
                tomato_today_focus_minutes += tomato_focus_credit_minutes;
            if (tomato_cycle_pomodoros <
                TOMATO_LONG_BREAK_AFTER_COUNT)
                tomato_cycle_pomodoros++;
        }
        next_phase =
            tomato_cycle_pomodoros >= TOMATO_LONG_BREAK_AFTER_COUNT ?
            TOMATO_PHASE_LONG_BREAK : TOMATO_PHASE_SHORT_BREAK;
    }
    else
    {
        if (finished_phase == TOMATO_PHASE_LONG_BREAK ||
            tomato_cycle_pomodoros >= TOMATO_LONG_BREAK_AFTER_COUNT)
            tomato_cycle_pomodoros = 0U;
        next_phase = TOMATO_PHASE_FOCUS;
    }

    if (completed)
        tomato_notify_phase_finished(finished_phase);
    tomato_begin_phase(next_phase);
    (void)tomato_save();
    if (completed)
        tomato_emit(TOMATO_EVENT_PHASE_FINISHED);
    tomato_emit(TOMATO_EVENT_CHANGED);
}

static void tomato_check_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    tomato_refresh_day();
    if (tomato_run_state == TOMATO_RUN_RUNNING &&
        tomato_get_remaining_seconds() == 0U)
        tomato_advance_phase(1U);
}

void tomato_service_init(void)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t current_day;

    if (tomato_initialized)
        return;

    tomato_make_default_settings(&tomato_settings);
    tomato_load();
    if (tomato_get_rtc(&time, &date))
    {
        current_day = tomato_make_day_key(&date);
        if (tomato_day_key != current_day)
        {
            tomato_day_key = current_day;
            tomato_today_pomodoros = 0U;
            tomato_today_focus_minutes = 0U;
            (void)tomato_save();
        }
    }
    tomato_reset_runtime();
    tomato_check_timer = lv_timer_create(tomato_check_timer_cb,
                                         TOMATO_CHECK_PERIOD_MS, NULL);
    tomato_initialized = tomato_check_timer != NULL ? 1U : 0U;
}

void tomato_service_set_event_handler(tomato_event_cb_t callback)
{
    tomato_event_handler = callback;
}

void tomato_service_get_snapshot(tomato_snapshot_t *snapshot)
{
    if (snapshot == NULL)
        return;

    rt_memset(snapshot, 0, sizeof(*snapshot));
    snapshot->settings = tomato_settings;
    snapshot->phase = tomato_phase;
    snapshot->run_state = tomato_run_state;
    snapshot->remaining_seconds = tomato_get_remaining_seconds();
    snapshot->phase_total_seconds = tomato_phase_total_seconds;
    snapshot->cycle_pomodoros = tomato_cycle_pomodoros;
    snapshot->today_pomodoros = tomato_today_pomodoros;
    snapshot->today_focus_minutes = tomato_today_focus_minutes;
}

rt_err_t tomato_service_update_settings(const tomato_settings_t *settings)
{
    if (!tomato_settings_valid(settings))
        return -RT_EINVAL;

    tomato_settings = *settings;
    tomato_settings.sound_enabled =
        tomato_settings.sound_enabled ? 1U : 0U;
    tomato_settings.vibration_enabled =
        tomato_settings.vibration_enabled ? 1U : 0U;
    if (tomato_run_state == TOMATO_RUN_IDLE)
    {
        tomato_phase_total_seconds = tomato_phase_duration_seconds(tomato_phase);
        tomato_remaining_seconds = tomato_phase_total_seconds;
        tomato_run_segment_seconds = tomato_phase_total_seconds;
        tomato_focus_credit_minutes = tomato_settings.focus_minutes;
    }
    (void)tomato_save();
    tomato_emit(TOMATO_EVENT_CHANGED);
    return RT_EOK;
}

rt_err_t tomato_service_start(void)
{
    if (tomato_run_state != TOMATO_RUN_IDLE)
        return -RT_EBUSY;

    tomato_phase = TOMATO_PHASE_FOCUS;
    tomato_phase_total_seconds =
        tomato_phase_duration_seconds(TOMATO_PHASE_FOCUS);
    tomato_remaining_seconds = tomato_phase_total_seconds;
    tomato_run_segment_seconds = tomato_phase_total_seconds;
    tomato_focus_credit_minutes = tomato_settings.focus_minutes;
    tomato_phase_started_tick = lv_tick_get();
    tomato_run_state = TOMATO_RUN_RUNNING;
    tomato_emit(TOMATO_EVENT_CHANGED);
    return RT_EOK;
}

rt_err_t tomato_service_pause(void)
{
    if (tomato_run_state != TOMATO_RUN_RUNNING)
        return -RT_EINVAL;

    tomato_remaining_seconds = tomato_get_remaining_seconds();
    if (tomato_remaining_seconds == 0U)
    {
        tomato_advance_phase(1U);
        return RT_EOK;
    }
    tomato_run_state = TOMATO_RUN_PAUSED;
    tomato_emit(TOMATO_EVENT_CHANGED);
    return RT_EOK;
}

rt_err_t tomato_service_resume(void)
{
    if (tomato_run_state != TOMATO_RUN_PAUSED ||
        tomato_remaining_seconds == 0U)
        return -RT_EINVAL;

    tomato_run_segment_seconds = tomato_remaining_seconds;
    tomato_phase_started_tick = lv_tick_get();
    tomato_run_state = TOMATO_RUN_RUNNING;
    tomato_emit(TOMATO_EVENT_CHANGED);
    return RT_EOK;
}

rt_err_t tomato_service_end(void)
{
    if (tomato_run_state == TOMATO_RUN_IDLE)
        return -RT_EINVAL;

    vibrator_off();
    tomato_reset_runtime();
    tomato_emit(TOMATO_EVENT_CHANGED);
    return RT_EOK;
}

rt_err_t tomato_service_skip(void)
{
    if (tomato_run_state == TOMATO_RUN_IDLE)
        return -RT_EINVAL;

    tomato_advance_phase(0U);
    return RT_EOK;
}
