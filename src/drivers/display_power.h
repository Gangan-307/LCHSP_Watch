#ifndef LCHSPI_DISPLAY_POWER_H_INCLUDED
#define LCHSPI_DISPLAY_POWER_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void display_power_init(void);
void display_power_wake(void);
void display_power_sleep(void);
void display_power_notify_activity(void);
void display_power_note_user_activity(void);
int display_power_is_off(void);
uint32_t display_power_get_user_activity_revision(void);
uint8_t display_power_get_brightness(void);
void display_power_set_brightness(uint8_t brightness);

#ifdef __cplusplus
}
#endif

#endif
