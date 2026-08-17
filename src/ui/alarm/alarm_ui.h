#ifndef LCHSPI_ALARM_UI_H_INCLUDED
#define LCHSPI_ALARM_UI_H_INCLUDED

#include "lvgl.h"
#include "services/input_wake.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Alarm;

void ui_Alarm_init(void);
void ui_Alarm_screen_init(void);
void ui_Alarm_screen_destroy(void);
void ui_Alarm_open_from_app_grid(void);
void ui_Alarm_return(void);
uint8_t ui_Alarm_handle_key(input_wake_key_t key,
                            input_wake_event_t event);

#ifdef __cplusplus
}
#endif

#endif
