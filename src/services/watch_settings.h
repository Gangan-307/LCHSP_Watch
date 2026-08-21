#ifndef LCHSPI_WATCH_SETTINGS_H_INCLUDED
#define LCHSPI_WATCH_SETTINGS_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    uint16_t screen_timeout_seconds;
    uint8_t brightness;
    uint8_t volume;
    uint8_t wrist_wake_enabled;
    uint8_t muted;
    uint8_t vibration_enabled;
    uint8_t do_not_disturb_enabled;
    uint8_t low_power_enabled;
} watch_settings_snapshot_t;

void watch_settings_init(void);
void watch_settings_get_snapshot(watch_settings_snapshot_t *snapshot);
void watch_settings_set_brightness(uint8_t brightness);
void watch_settings_set_screen_timeout(uint16_t seconds);
void watch_settings_set_volume(uint8_t volume);
void watch_settings_set_wrist_wake(uint8_t enabled);
void watch_settings_set_muted(uint8_t muted);
void watch_settings_set_vibration(uint8_t enabled);
void watch_settings_set_do_not_disturb(uint8_t enabled);
void watch_settings_set_low_power(uint8_t enabled);

#ifdef __cplusplus
}
#endif

#endif
