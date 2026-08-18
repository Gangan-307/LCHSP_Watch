#include "water_reminder_service.h"

#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include "bf0_hal.h"
#include "lvgl.h"
#include "drivers/display_power.h"
#include "drivers/vibrator.h"

#define WATER_CONFIG_MAGIC             (0x48535057UL)
#define WATER_CONFIG_VERSION           (1U)
#define WATER_CONFIG_PATH              "/water_config.bin"
#define WATER_CONFIG_TEMP_PATH         "/water_config.tmp"
#define WATER_CHECK_PERIOD_MS          (1000U)
#define WATER_REMINDER_TIMEOUT_MS      (20U * 1000U)
#define WATER_VIBRATION_LEVEL          (76U)
#define WATER_VIBRATION_MS             (420U)
#define WATER_INTERVAL_MIN_MINUTES     (30U)
#define WATER_INTERVAL_MAX_MINUTES     (6U * 60U)
#define WATER_SNOOZE_MAX_MINUTES       (60U)

typedef struct
{
    uint32_t magic;
    uint16_t version;
    uint16_t reserved;
    water_reminder_settings_t settings;
    uint16_t today_ml;
    uint16_t reserved2;
    uint32_t day_key;
    uint32_t checksum;
} water_config_file_t;

extern RTC_HandleTypeDef RTC_Handler;

static water_reminder_settings_t water_settings;
static uint16_t water_today_ml;
static uint32_t water_day_key;
static uint16_t water_next_minute;
static uint8_t water_next_valid_today;
static uint8_t water_initialized;
static uint8_t water_reminding;
static uint8_t water_external_suppressed;
static uint32_t water_reminder_started_at;
static lv_timer_t *water_check_timer;
static water_reminder_event_cb_t water_event_handler;
static water_reminder_present_guard_t water_present_guard;

static uint32_t water_checksum(const void *data, size_t size)
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

static void water_make_default_settings(water_reminder_settings_t *settings)
{
    rt_memset(settings, 0, sizeof(*settings));
    settings->start_hour = 8U;
    settings->end_hour = 22U;
    settings->interval_minutes = 60U;
    settings->snooze_minutes = 10U;
    settings->serving_ml = WATER_REMINDER_DEFAULT_SERVING_ML;
    settings->target_ml = WATER_REMINDER_DEFAULT_TARGET_ML;
}

static uint8_t water_settings_valid(
    const water_reminder_settings_t *settings)
{
    uint16_t start;
    uint16_t end;

    if (settings == NULL || settings->start_hour >= 24U ||
        settings->start_minute >= 60U || settings->end_hour >= 24U ||
        settings->end_minute >= 60U ||
        settings->interval_minutes < WATER_INTERVAL_MIN_MINUTES ||
        settings->interval_minutes > WATER_INTERVAL_MAX_MINUTES ||
        settings->snooze_minutes == 0U ||
        settings->snooze_minutes > WATER_SNOOZE_MAX_MINUTES ||
        settings->serving_ml == 0U || settings->target_ml == 0U)
        return 0U;

    start = (uint16_t)settings->start_hour * 60U + settings->start_minute;
    end = (uint16_t)settings->end_hour * 60U + settings->end_minute;
    return start < end;
}

static uint8_t water_get_rtc(RTC_TimeTypeDef *time, RTC_DateTypeDef *date)
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

static uint32_t water_make_day_key(const RTC_DateTypeDef *date)
{
    uint32_t key = (uint32_t)(date->Year & 0xFFU);

    key = key * 13U + date->Month;
    key = key * 32U + date->Date;
    return key == 0U ? 1U : key;
}

static void water_emit(water_reminder_event_t event)
{
    if (water_event_handler != NULL)
        water_event_handler(event);
}

static rt_err_t water_save(void)
{
#ifdef RT_USING_DFS
    water_config_file_t config;
    FILE *file;
    size_t written;
    int failed = 0;

    rt_memset(&config, 0, sizeof(config));
    config.magic = WATER_CONFIG_MAGIC;
    config.version = WATER_CONFIG_VERSION;
    config.settings = water_settings;
    config.today_ml = water_today_ml;
    config.day_key = water_day_key;
    config.checksum = water_checksum(&config,
                                     sizeof(config) - sizeof(config.checksum));

    file = fopen(WATER_CONFIG_TEMP_PATH, "wb");
    if (file == NULL)
        return -RT_ERROR;
    written = fwrite(&config, sizeof(config), 1U, file);
    if (written != 1U || fflush(file) != 0)
        failed = 1;
    if (fclose(file) != 0)
        failed = 1;
    if (failed)
    {
        remove(WATER_CONFIG_TEMP_PATH);
        return -RT_ERROR;
    }
    remove(WATER_CONFIG_PATH);
    if (rename(WATER_CONFIG_TEMP_PATH, WATER_CONFIG_PATH) != 0)
    {
        remove(WATER_CONFIG_TEMP_PATH);
        return -RT_ERROR;
    }
    return RT_EOK;
#else
    return -RT_ENOSYS;
#endif
}

static void water_load(void)
{
#ifdef RT_USING_DFS
    water_config_file_t config;
    FILE *file;
    size_t read_count;
    uint32_t checksum;

    file = fopen(WATER_CONFIG_PATH, "rb");
    if (file == NULL)
        return;
    rt_memset(&config, 0, sizeof(config));
    read_count = fread(&config, sizeof(config), 1U, file);
    fclose(file);
    checksum = water_checksum(&config,
                              sizeof(config) - sizeof(config.checksum));
    if (read_count != 1U || config.magic != WATER_CONFIG_MAGIC ||
        config.version != WATER_CONFIG_VERSION ||
        config.checksum != checksum ||
        !water_settings_valid(&config.settings))
        return;

    water_settings = config.settings;
    water_settings.enabled = water_settings.enabled ? 1U : 0U;
    water_today_ml = config.today_ml;
    water_day_key = config.day_key;
#endif
}

static void water_recalculate_next(const RTC_TimeTypeDef *time)
{
    uint16_t start = (uint16_t)water_settings.start_hour * 60U +
                     water_settings.start_minute;
    uint16_t end = (uint16_t)water_settings.end_hour * 60U +
                   water_settings.end_minute;
    uint16_t current = (uint16_t)time->Hours * 60U + time->Minutes;
    uint32_t candidate;
    uint32_t steps;

    water_next_valid_today = 0U;
    if (!water_settings.enabled)
        return;
    if (current <= start)
    {
        water_next_minute = start;
        water_next_valid_today = 1U;
        return;
    }
    if (current >= end)
        return;

    steps = (uint32_t)(current - start) /
            water_settings.interval_minutes + 1U;
    candidate = start + steps * water_settings.interval_minutes;
    if (candidate <= end)
    {
        water_next_minute = (uint16_t)candidate;
        water_next_valid_today = 1U;
    }
}

static void water_schedule_after(uint16_t minutes,
                                 const RTC_TimeTypeDef *time)
{
    uint16_t end = (uint16_t)water_settings.end_hour * 60U +
                   water_settings.end_minute;
    uint32_t current = (uint32_t)time->Hours * 60U + time->Minutes;
    uint32_t candidate = current + minutes;

    if (water_settings.enabled && candidate <= end)
    {
        water_next_minute = (uint16_t)candidate;
        water_next_valid_today = 1U;
    }
    else
    {
        water_next_valid_today = 0U;
    }
}

static void water_stop_reminder(uint16_t next_delay_minutes)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};

    if (!water_reminding)
        return;
    water_reminding = 0U;
    vibrator_off();
    if (water_get_rtc(&time, &date))
        water_schedule_after(next_delay_minutes, &time);
    else
        water_next_valid_today = 0U;
    water_emit(WATER_REMINDER_EVENT_STOPPED);
    water_emit(WATER_REMINDER_EVENT_CHANGED);
}

static void water_start_reminder(void)
{
    if (water_reminding)
        return;
    water_reminding = 1U;
    water_next_valid_today = 0U;
    water_reminder_started_at = lv_tick_get();
    display_power_note_user_activity();
    display_power_wake();
    (void)vibrator_vibrate(WATER_VIBRATION_LEVEL, WATER_VIBRATION_MS);
    water_emit(WATER_REMINDER_EVENT_STARTED);
}

static void water_check_timer_cb(lv_timer_t *timer)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t day_key;
    uint16_t current;
    uint16_t start;
    uint16_t end;

    (void)timer;
    if (water_reminding)
    {
        if (lv_tick_elaps(water_reminder_started_at) >=
            WATER_REMINDER_TIMEOUT_MS)
            water_stop_reminder(water_settings.interval_minutes);
        return;
    }
    if (!water_get_rtc(&time, &date))
        return;

    day_key = water_make_day_key(&date);
    if (water_day_key != day_key)
    {
        water_day_key = day_key;
        water_today_ml = 0U;
        water_recalculate_next(&time);
        (void)water_save();
        water_emit(WATER_REMINDER_EVENT_CHANGED);
    }
    if (!water_settings.enabled || !water_next_valid_today)
        return;

    current = (uint16_t)time.Hours * 60U + time.Minutes;
    start = (uint16_t)water_settings.start_hour * 60U +
            water_settings.start_minute;
    end = (uint16_t)water_settings.end_hour * 60U +
          water_settings.end_minute;
    if (current > end)
    {
        water_next_valid_today = 0U;
        water_emit(WATER_REMINDER_EVENT_CHANGED);
        return;
    }
    if (current < start)
        return;
    if (current < water_next_minute)
        return;
    if (water_external_suppressed ||
        (water_present_guard != NULL && !water_present_guard()))
        return;

    water_start_reminder();
}

void water_reminder_service_init(void)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t current_day;

    if (water_initialized)
        return;
    water_make_default_settings(&water_settings);
    water_load();
    if (water_get_rtc(&time, &date))
    {
        current_day = water_make_day_key(&date);
        if (water_day_key != current_day)
        {
            water_day_key = current_day;
            water_today_ml = 0U;
            (void)water_save();
        }
        water_recalculate_next(&time);
    }
    water_check_timer = lv_timer_create(water_check_timer_cb,
                                        WATER_CHECK_PERIOD_MS, NULL);
    water_initialized = water_check_timer != NULL ? 1U : 0U;
}

void water_reminder_service_set_event_handler(
    water_reminder_event_cb_t callback)
{
    water_event_handler = callback;
}

void water_reminder_service_set_present_guard(
    water_reminder_present_guard_t callback)
{
    water_present_guard = callback;
}

void water_reminder_service_get_snapshot(water_reminder_snapshot_t *snapshot)
{
    if (snapshot == NULL)
        return;
    rt_memset(snapshot, 0, sizeof(*snapshot));
    snapshot->settings = water_settings;
    snapshot->today_ml = water_today_ml;
    snapshot->next_valid_today = water_next_valid_today;
    snapshot->next_hour = (uint8_t)(water_next_minute / 60U);
    snapshot->next_minute = (uint8_t)(water_next_minute % 60U);
    snapshot->reminding = water_reminding;
}

rt_err_t water_reminder_service_update_settings(
    const water_reminder_settings_t *settings)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};

    if (!water_settings_valid(settings))
        return -RT_EINVAL;
    water_settings = *settings;
    water_settings.enabled = water_settings.enabled ? 1U : 0U;
    if (!water_settings.enabled && water_reminding)
    {
        water_reminding = 0U;
        vibrator_off();
        water_emit(WATER_REMINDER_EVENT_STOPPED);
    }
    if (water_get_rtc(&time, &date))
        water_recalculate_next(&time);
    else
        water_next_valid_today = 0U;
    (void)water_save();
    water_emit(WATER_REMINDER_EVENT_CHANGED);
    return RT_EOK;
}

void water_reminder_service_drink(void)
{
    uint32_t amount;

    if (!water_reminding)
        return;
    amount = (uint32_t)water_today_ml + water_settings.serving_ml;
    water_today_ml = amount > UINT16_MAX ? UINT16_MAX : (uint16_t)amount;
    (void)water_save();
    water_stop_reminder(water_settings.interval_minutes);
}

void water_reminder_service_snooze(void)
{
    water_stop_reminder(water_settings.snooze_minutes);
}

void water_reminder_service_skip(void)
{
    water_stop_reminder(water_settings.interval_minutes);
}

uint8_t water_reminder_service_is_reminding(void)
{
    return water_reminding;
}

void water_reminder_service_set_external_suppressed(uint8_t suppressed)
{
    water_external_suppressed = suppressed ? 1U : 0U;
}
