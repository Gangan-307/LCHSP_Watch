#include "alarm_service.h"

#include <stdio.h>
#include <string.h>

#include "bf0_hal.h"
#include "lvgl.h"
#include "drivers/display_power.h"
#include "drivers/vibrator.h"

#define ALARM_CONFIG_MAGIC              (0x48535041UL)
#define ALARM_CONFIG_VERSION            (1U)
#define ALARM_CONFIG_PATH               "/alarm_config.bin"
#define ALARM_CONFIG_TEMP_PATH          "/alarm_config.tmp"
#define ALARM_CHECK_PERIOD_MS           (1000U)
#define ALARM_VIBRATION_PERIOD_MS       (1200U)
#define ALARM_VIBRATION_ON_MS           (650U)
#define ALARM_VIBRATION_LEVEL           (82U)
#define ALARM_RING_TIMEOUT_MS           (5U * 60U * 1000U)
#define ALARM_SNOOZE_MS                 (5U * 60U * 1000U)

typedef struct
{
    uint32_t magic;
    uint16_t version;
    uint8_t count;
    uint8_t reserved;
    alarm_entry_t alarms[ALARM_SERVICE_MAX_ALARMS];
    uint32_t checksum;
} alarm_config_file_t;

extern RTC_HandleTypeDef RTC_Handler;

static alarm_entry_t alarms[ALARM_SERVICE_MAX_ALARMS];
static uint32_t last_trigger_keys[ALARM_SERVICE_MAX_ALARMS];
static uint8_t alarm_count;
static uint8_t alarm_initialized;
static uint8_t alarm_ringing;
static uint8_t active_alarm_index;
static uint8_t snooze_pending;
static uint32_t ring_started_at;
static uint32_t snooze_started_at;
static lv_timer_t *alarm_check_timer;
static lv_timer_t *alarm_vibration_timer;
static alarm_service_event_cb_t event_handler;

static uint32_t alarm_checksum(const void *data, size_t size)
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

static uint8_t alarm_entry_valid(const alarm_entry_t *entry)
{
    return entry != NULL && entry->hour < 24U && entry->minute < 60U &&
           (entry->repeat_mask & (uint8_t)~ALARM_REPEAT_EVERY_DAY) == 0U;
}

static void alarm_emit(alarm_service_event_t event, uint8_t index)
{
    if (event_handler != NULL)
        event_handler(event, index);
}

static void alarm_reset_trigger_keys(void)
{
    rt_memset(last_trigger_keys, 0, sizeof(last_trigger_keys));
}

static rt_err_t alarm_save(void)
{
#ifdef RT_USING_DFS
    alarm_config_file_t config;
    FILE *file;
    size_t written;
    int write_failed = 0;

    rt_memset(&config, 0, sizeof(config));
    config.magic = ALARM_CONFIG_MAGIC;
    config.version = ALARM_CONFIG_VERSION;
    config.count = alarm_count;
    rt_memcpy(config.alarms, alarms, sizeof(alarms));
    config.checksum = alarm_checksum(&config,
                                     sizeof(config) - sizeof(config.checksum));

    file = fopen(ALARM_CONFIG_TEMP_PATH, "wb");
    if (file == NULL)
    {
        rt_kprintf("alarm: cannot open temporary config file\n");
        return -RT_ERROR;
    }

    written = fwrite(&config, sizeof(config), 1U, file);
    if (written != 1U || fflush(file) != 0)
        write_failed = 1;
    if (fclose(file) != 0)
        write_failed = 1;
    if (write_failed)
    {
        remove(ALARM_CONFIG_TEMP_PATH);
        rt_kprintf("alarm: config write failed\n");
        return -RT_ERROR;
    }

    remove(ALARM_CONFIG_PATH);
    if (rename(ALARM_CONFIG_TEMP_PATH, ALARM_CONFIG_PATH) != 0)
    {
        remove(ALARM_CONFIG_TEMP_PATH);
        rt_kprintf("alarm: config replace failed\n");
        return -RT_ERROR;
    }
    return RT_EOK;
#else
    return -RT_ENOSYS;
#endif
}

static void alarm_load(void)
{
#ifdef RT_USING_DFS
    alarm_config_file_t config;
    uint32_t checksum;
    FILE *file;
    size_t read_count;
    uint8_t index;

    file = fopen(ALARM_CONFIG_PATH, "rb");
    if (file == NULL)
        return;

    rt_memset(&config, 0, sizeof(config));
    read_count = fread(&config, sizeof(config), 1U, file);
    fclose(file);
    checksum = alarm_checksum(&config,
                              sizeof(config) - sizeof(config.checksum));
    if (read_count != 1U || config.magic != ALARM_CONFIG_MAGIC ||
        config.version != ALARM_CONFIG_VERSION ||
        config.count > ALARM_SERVICE_MAX_ALARMS ||
        config.checksum != checksum)
    {
        rt_kprintf("alarm: ignored invalid config\n");
        return;
    }

    for (index = 0U; index < config.count; index++)
    {
        if (!alarm_entry_valid(&config.alarms[index]))
        {
            rt_kprintf("alarm: ignored config with invalid entry\n");
            return;
        }
    }

    alarm_count = config.count;
    rt_memcpy(alarms, config.alarms, sizeof(alarms));
    for (index = 0U; index < alarm_count; index++)
        alarms[index].enabled = alarms[index].enabled ? 1U : 0U;
#endif
}

static uint8_t alarm_weekday_index(uint8_t rtc_weekday)
{
    if (rtc_weekday >= RTC_WEEKDAY_MONDAY &&
        rtc_weekday <= RTC_WEEKDAY_SATURDAY)
        return (uint8_t)(rtc_weekday - RTC_WEEKDAY_MONDAY);
    return 6U;
}

static uint32_t alarm_trigger_key(const RTC_DateTypeDef *date,
                                  const RTC_TimeTypeDef *time)
{
    uint32_t key = (uint32_t)(date->Year & 0xFFU);

    key = key * 13U + date->Month;
    key = key * 32U + date->Date;
    key = key * 24U + time->Hours;
    key = key * 60U + time->Minutes;
    return key == 0U ? 1U : key;
}

static uint8_t alarm_get_rtc(RTC_TimeTypeDef *time, RTC_DateTypeDef *date)
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

static void alarm_vibration_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    if (alarm_ringing)
        (void)vibrator_vibrate(ALARM_VIBRATION_LEVEL,
                               ALARM_VIBRATION_ON_MS);
}

static void alarm_start_ringing(uint8_t index)
{
    if (alarm_ringing)
        return;

    alarm_ringing = 1U;
    active_alarm_index = index;
    ring_started_at = lv_tick_get();
    display_power_note_user_activity();
    display_power_wake();
    (void)vibrator_vibrate(ALARM_VIBRATION_LEVEL, ALARM_VIBRATION_ON_MS);

    if (alarm_vibration_timer == NULL)
        alarm_vibration_timer = lv_timer_create(alarm_vibration_timer_cb,
                                                ALARM_VIBRATION_PERIOD_MS,
                                                NULL);
    else
        lv_timer_resume(alarm_vibration_timer);

    alarm_emit(ALARM_SERVICE_EVENT_RING_STARTED, index);
}

static void alarm_stop_ringing(void)
{
    uint8_t stopped_index;

    if (!alarm_ringing)
        return;

    stopped_index = active_alarm_index;
    alarm_ringing = 0U;
    if (alarm_vibration_timer != NULL)
        lv_timer_pause(alarm_vibration_timer);
    vibrator_off();
    alarm_emit(ALARM_SERVICE_EVENT_RING_STOPPED, stopped_index);
}

static void alarm_check_timer_cb(lv_timer_t *timer)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t trigger_key;
    uint8_t weekday;
    uint8_t index;

    (void)timer;

    if (alarm_ringing)
    {
        if (lv_tick_elaps(ring_started_at) >= ALARM_RING_TIMEOUT_MS)
            alarm_stop_ringing();
        return;
    }

    if (snooze_pending &&
        lv_tick_elaps(snooze_started_at) >= ALARM_SNOOZE_MS)
    {
        snooze_pending = 0U;
        alarm_start_ringing(active_alarm_index);
        return;
    }

    if (!alarm_get_rtc(&time, &date))
        return;

    weekday = alarm_weekday_index(date.WeekDay);
    trigger_key = alarm_trigger_key(&date, &time);
    for (index = 0U; index < alarm_count; index++)
    {
        alarm_entry_t *entry = &alarms[index];

        if (!entry->enabled || entry->hour != time.Hours ||
            entry->minute != time.Minutes ||
            last_trigger_keys[index] == trigger_key)
            continue;
        if (entry->repeat_mask != 0U &&
            (entry->repeat_mask & (1U << weekday)) == 0U)
            continue;

        last_trigger_keys[index] = trigger_key;
        if (entry->repeat_mask == 0U)
        {
            entry->enabled = 0U;
            (void)alarm_save();
            alarm_emit(ALARM_SERVICE_EVENT_CHANGED, index);
        }
        alarm_start_ringing(index);
        break;
    }
}

void alarm_service_init(void)
{
    if (alarm_initialized)
        return;

    rt_memset(alarms, 0, sizeof(alarms));
    alarm_count = 0U;
    alarm_load();
    alarm_reset_trigger_keys();
    alarm_check_timer = lv_timer_create(alarm_check_timer_cb,
                                        ALARM_CHECK_PERIOD_MS, NULL);
    alarm_initialized = 1U;
    rt_kprintf("alarm: loaded %u alarm(s)\n", alarm_count);
}

void alarm_service_set_event_handler(alarm_service_event_cb_t callback)
{
    event_handler = callback;
}

void alarm_service_make_default(alarm_entry_t *entry)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint16_t next_minute;

    if (entry == NULL)
        return;

    rt_memset(entry, 0, sizeof(*entry));
    entry->hour = 7U;
    entry->enabled = 1U;
    if (!alarm_get_rtc(&time, &date))
        return;

    next_minute = (uint16_t)time.Hours * 60U + time.Minutes + 1U;
    next_minute %= (24U * 60U);
    entry->hour = (uint8_t)(next_minute / 60U);
    entry->minute = (uint8_t)(next_minute % 60U);
}

uint8_t alarm_service_count(void)
{
    return alarm_count;
}

rt_err_t alarm_service_get(uint8_t index, alarm_entry_t *entry)
{
    if (entry == NULL || index >= alarm_count)
        return -RT_EINVAL;
    *entry = alarms[index];
    return RT_EOK;
}

rt_err_t alarm_service_add(const alarm_entry_t *entry, uint8_t *index_out)
{
    uint8_t index;

    if (!alarm_entry_valid(entry) || alarm_count >= ALARM_SERVICE_MAX_ALARMS)
        return -RT_EINVAL;

    index = alarm_count++;
    alarms[index] = *entry;
    alarms[index].enabled = alarms[index].enabled ? 1U : 0U;
    last_trigger_keys[index] = 0U;
    (void)alarm_save();
    if (index_out != NULL)
        *index_out = index;
    alarm_emit(ALARM_SERVICE_EVENT_CHANGED, index);
    return RT_EOK;
}

rt_err_t alarm_service_update(uint8_t index, const alarm_entry_t *entry)
{
    if (!alarm_entry_valid(entry) || index >= alarm_count)
        return -RT_EINVAL;

    alarms[index] = *entry;
    alarms[index].enabled = alarms[index].enabled ? 1U : 0U;
    last_trigger_keys[index] = 0U;
    (void)alarm_save();
    alarm_emit(ALARM_SERVICE_EVENT_CHANGED, index);
    return RT_EOK;
}

rt_err_t alarm_service_remove(uint8_t index)
{
    if (index >= alarm_count)
        return -RT_EINVAL;

    if (snooze_pending && index == active_alarm_index)
        snooze_pending = 0U;
    else if (snooze_pending && index < active_alarm_index)
        active_alarm_index--;

    if (index + 1U < alarm_count)
    {
        rt_memmove(&alarms[index], &alarms[index + 1U],
                   (alarm_count - index - 1U) * sizeof(alarms[0]));
    }
    alarm_count--;
    rt_memset(&alarms[alarm_count], 0, sizeof(alarms[0]));
    alarm_reset_trigger_keys();
    (void)alarm_save();
    alarm_emit(ALARM_SERVICE_EVENT_CHANGED, index);
    return RT_EOK;
}

rt_err_t alarm_service_set_enabled(uint8_t index, uint8_t enabled)
{
    if (index >= alarm_count)
        return -RT_EINVAL;

    alarms[index].enabled = enabled ? 1U : 0U;
    last_trigger_keys[index] = 0U;
    (void)alarm_save();
    alarm_emit(ALARM_SERVICE_EVENT_CHANGED, index);
    return RT_EOK;
}

rt_err_t alarm_service_get_next(alarm_entry_t *entry, uint8_t *index_out,
                                uint32_t *minutes_until)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint32_t best_minutes = UINT32_MAX;
    uint32_t current_minute;
    uint8_t today;
    uint8_t index;

    if (!alarm_get_rtc(&time, &date))
        return -RT_ERROR;

    current_minute = (uint32_t)time.Hours * 60U + time.Minutes;
    today = alarm_weekday_index(date.WeekDay);
    for (index = 0U; index < alarm_count; index++)
    {
        const alarm_entry_t *candidate = &alarms[index];
        uint8_t day_offset;

        if (!candidate->enabled)
            continue;
        for (day_offset = 0U; day_offset <= 7U; day_offset++)
        {
            uint8_t weekday = (uint8_t)((today + day_offset) % 7U);
            int32_t delta;

            if (candidate->repeat_mask != 0U &&
                (candidate->repeat_mask & (1U << weekday)) == 0U)
                continue;
            delta = (int32_t)day_offset * 1440 +
                    (int32_t)candidate->hour * 60 + candidate->minute -
                    (int32_t)current_minute;
            if (delta <= 0)
                continue;
            if ((uint32_t)delta < best_minutes)
            {
                best_minutes = (uint32_t)delta;
                if (entry != NULL)
                    *entry = *candidate;
                if (index_out != NULL)
                    *index_out = index;
            }
            break;
        }
    }

    if (best_minutes == UINT32_MAX)
        return -RT_ERROR;
    if (minutes_until != NULL)
        *minutes_until = best_minutes;
    return RT_EOK;
}

uint8_t alarm_service_is_ringing(void)
{
    return alarm_ringing;
}

rt_err_t alarm_service_preview(uint8_t index)
{
    if (index >= alarm_count || alarm_ringing)
        return -RT_EINVAL;

    snooze_pending = 0U;
    alarm_start_ringing(index);
    return RT_EOK;
}

void alarm_service_snooze(void)
{
    if (!alarm_ringing)
        return;

    snooze_pending = 1U;
    snooze_started_at = lv_tick_get();
    alarm_stop_ringing();
}

void alarm_service_dismiss(void)
{
    snooze_pending = 0U;
    alarm_stop_ringing();
}
