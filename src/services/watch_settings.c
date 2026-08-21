#include "watch_settings.h"

#include <stddef.h>
#include <stdio.h>

#include "rtthread.h"
#include "bluetooth/music_app.h"
#include "drivers/display_power.h"
#include "drivers/vibrator.h"
#include "services/phone_notifications.h"
#include "services/wrist_wake.h"

#define WATCH_SETTINGS_MAGIC                 (0x48535053UL)
#define WATCH_SETTINGS_VERSION               (1U)
#define WATCH_SETTINGS_PATH                  "/watch_settings.bin"
#define WATCH_SETTINGS_TEMP_PATH             "/watch_settings.tmp"
#define WATCH_SETTINGS_DEFAULT_BRIGHTNESS    (100U)
#define WATCH_SETTINGS_DEFAULT_TIMEOUT       (15U)
#define WATCH_SETTINGS_DEFAULT_VOLUME        (64U)
#define WATCH_SETTINGS_LOW_POWER_BRIGHTNESS  (35U)
#define WATCH_SETTINGS_LOW_POWER_TIMEOUT     (10U)
#define WATCH_SETTINGS_APPLY_DISPLAY          (0x01U)
#define WATCH_SETTINGS_APPLY_VOLUME           (0x02U)
#define WATCH_SETTINGS_APPLY_MUTE             (0x04U)
#define WATCH_SETTINGS_APPLY_VIBRATION        (0x08U)
#define WATCH_SETTINGS_APPLY_DND              (0x10U)
#define WATCH_SETTINGS_APPLY_ALL              (0x1FU)

typedef struct
{
    uint32_t magic;
    uint16_t version;
    uint16_t reserved;
    watch_settings_snapshot_t settings;
    uint32_t checksum;
} watch_settings_file_t;

static watch_settings_snapshot_t watch_settings;
static struct rt_mutex watch_settings_lock;
static uint8_t watch_settings_initialized;

static uint32_t watch_settings_checksum(const void *data, size_t size)
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

static void watch_settings_defaults(void)
{
    rt_memset(&watch_settings, 0, sizeof(watch_settings));
    watch_settings.brightness = WATCH_SETTINGS_DEFAULT_BRIGHTNESS;
    watch_settings.screen_timeout_seconds = WATCH_SETTINGS_DEFAULT_TIMEOUT;
    watch_settings.volume = WATCH_SETTINGS_DEFAULT_VOLUME;
    watch_settings.wrist_wake_enabled = 1U;
    watch_settings.vibration_enabled = 1U;
}

static uint8_t watch_settings_valid(
    const watch_settings_snapshot_t *settings)
{
    return settings != RT_NULL &&
           settings->brightness >= 1U && settings->brightness <= 100U &&
           settings->screen_timeout_seconds >= 5U &&
           settings->screen_timeout_seconds <= 300U &&
           settings->volume <= 127U;
}

static void watch_settings_load(void)
{
#ifdef RT_USING_DFS
    watch_settings_file_t file_data;
    FILE *file = fopen(WATCH_SETTINGS_PATH, "rb");
    uint32_t checksum;

    if (file == RT_NULL)
        return;
    rt_memset(&file_data, 0, sizeof(file_data));
    if (fread(&file_data, sizeof(file_data), 1U, file) != 1U)
    {
        fclose(file);
        return;
    }
    fclose(file);

    checksum = watch_settings_checksum(
        &file_data, sizeof(file_data) - sizeof(file_data.checksum));
    if (file_data.magic != WATCH_SETTINGS_MAGIC ||
        file_data.version != WATCH_SETTINGS_VERSION ||
        file_data.checksum != checksum ||
        !watch_settings_valid(&file_data.settings))
        return;

    watch_settings = file_data.settings;
    watch_settings.wrist_wake_enabled =
        watch_settings.wrist_wake_enabled ? 1U : 0U;
    watch_settings.muted = watch_settings.muted ? 1U : 0U;
    watch_settings.vibration_enabled =
        watch_settings.vibration_enabled ? 1U : 0U;
    watch_settings.do_not_disturb_enabled =
        watch_settings.do_not_disturb_enabled ? 1U : 0U;
    watch_settings.low_power_enabled =
        watch_settings.low_power_enabled ? 1U : 0U;
#endif
}

static void watch_settings_save_locked(void)
{
#ifdef RT_USING_DFS
    watch_settings_file_t file_data;
    FILE *file;
    int failed = 0;

    rt_memset(&file_data, 0, sizeof(file_data));
    file_data.magic = WATCH_SETTINGS_MAGIC;
    file_data.version = WATCH_SETTINGS_VERSION;
    file_data.settings = watch_settings;
    file_data.checksum = watch_settings_checksum(
        &file_data, sizeof(file_data) - sizeof(file_data.checksum));

    file = fopen(WATCH_SETTINGS_TEMP_PATH, "wb");
    if (file == RT_NULL)
        return;
    if (fwrite(&file_data, sizeof(file_data), 1U, file) != 1U ||
        fflush(file) != 0)
        failed = 1;
    if (fclose(file) != 0)
        failed = 1;
    if (failed)
    {
        remove(WATCH_SETTINGS_TEMP_PATH);
        return;
    }
    remove(WATCH_SETTINGS_PATH);
    if (rename(WATCH_SETTINGS_TEMP_PATH, WATCH_SETTINGS_PATH) != 0)
        remove(WATCH_SETTINGS_TEMP_PATH);
#endif
}

static void watch_settings_apply_locked(uint8_t apply_mask)
{
    uint8_t brightness = watch_settings.brightness;
    uint16_t timeout = watch_settings.screen_timeout_seconds;
    uint8_t wrist_wake = watch_settings.wrist_wake_enabled;

    if (watch_settings.low_power_enabled)
    {
        if (brightness > WATCH_SETTINGS_LOW_POWER_BRIGHTNESS)
            brightness = WATCH_SETTINGS_LOW_POWER_BRIGHTNESS;
        if (timeout > WATCH_SETTINGS_LOW_POWER_TIMEOUT)
            timeout = WATCH_SETTINGS_LOW_POWER_TIMEOUT;
        wrist_wake = 0U;
    }

    if ((apply_mask & WATCH_SETTINGS_APPLY_DISPLAY) != 0U)
    {
        display_power_set_brightness(brightness);
        display_power_set_idle_timeout(timeout);
        wrist_wake_set_enabled(wrist_wake);
    }
    if ((apply_mask & WATCH_SETTINGS_APPLY_VOLUME) != 0U)
        music_app_set_volume(watch_settings.volume);
    if ((apply_mask & WATCH_SETTINGS_APPLY_MUTE) != 0U)
        music_app_set_speaker_muted(watch_settings.muted);
    if ((apply_mask & WATCH_SETTINGS_APPLY_VIBRATION) != 0U)
        vibrator_set_enabled(watch_settings.vibration_enabled);
    if ((apply_mask & WATCH_SETTINGS_APPLY_DND) != 0U)
        phone_notifications_set_do_not_disturb(
            watch_settings.do_not_disturb_enabled);
}

void watch_settings_init(void)
{
    if (watch_settings_initialized)
        return;
    if (rt_mutex_init(&watch_settings_lock, "watch_set",
                      RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    watch_settings_defaults();
    watch_settings_load();
    watch_settings_initialized = 1U;
    rt_mutex_take(&watch_settings_lock, RT_WAITING_FOREVER);
    watch_settings_apply_locked(WATCH_SETTINGS_APPLY_ALL);
    rt_mutex_release(&watch_settings_lock);
}

void watch_settings_get_snapshot(watch_settings_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;
    if (!watch_settings_initialized)
    {
        rt_memset(snapshot, 0, sizeof(*snapshot));
        return;
    }
    rt_mutex_take(&watch_settings_lock, RT_WAITING_FOREVER);
    *snapshot = watch_settings;
    rt_mutex_release(&watch_settings_lock);
}

#define WATCH_SETTINGS_SETTER(function_name, field_name, value_type, normalize, \
                              apply_mask)                                      \
    void function_name(value_type value)                                      \
    {                                                                          \
        uint8_t changed;                                                       \
                                                                               \
        if (!watch_settings_initialized)                                       \
            return;                                                            \
        value = (normalize);                                                    \
        rt_mutex_take(&watch_settings_lock, RT_WAITING_FOREVER);                \
        changed = watch_settings.field_name != value ? 1U : 0U;                \
        if (changed)                                                           \
        {                                                                      \
            watch_settings.field_name = value;                                 \
        }                                                                      \
        watch_settings_apply_locked(apply_mask);                               \
        if (changed)                                                           \
            watch_settings_save_locked();                                      \
        rt_mutex_release(&watch_settings_lock);                                 \
    }

WATCH_SETTINGS_SETTER(watch_settings_set_brightness, brightness, uint8_t,
                      value < 1U ? 1U : (value > 100U ? 100U : value),
                      WATCH_SETTINGS_APPLY_DISPLAY)
WATCH_SETTINGS_SETTER(watch_settings_set_screen_timeout,
                      screen_timeout_seconds, uint16_t,
                      value < 5U ? 5U : (value > 300U ? 300U : value),
                      WATCH_SETTINGS_APPLY_DISPLAY)
WATCH_SETTINGS_SETTER(watch_settings_set_volume, volume, uint8_t,
                      value > 127U ? 127U : value,
                      WATCH_SETTINGS_APPLY_VOLUME)
WATCH_SETTINGS_SETTER(watch_settings_set_wrist_wake, wrist_wake_enabled,
                      uint8_t, value ? 1U : 0U,
                      WATCH_SETTINGS_APPLY_DISPLAY)
WATCH_SETTINGS_SETTER(watch_settings_set_muted, muted, uint8_t,
                      value ? 1U : 0U, WATCH_SETTINGS_APPLY_MUTE)
WATCH_SETTINGS_SETTER(watch_settings_set_vibration, vibration_enabled,
                      uint8_t, value ? 1U : 0U,
                      WATCH_SETTINGS_APPLY_VIBRATION)
WATCH_SETTINGS_SETTER(watch_settings_set_do_not_disturb,
                      do_not_disturb_enabled, uint8_t, value ? 1U : 0U,
                      WATCH_SETTINGS_APPLY_DND)
WATCH_SETTINGS_SETTER(watch_settings_set_low_power, low_power_enabled,
                      uint8_t, value ? 1U : 0U,
                      WATCH_SETTINGS_APPLY_DISPLAY)

#undef WATCH_SETTINGS_SETTER
