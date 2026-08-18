#ifndef LCHSPI_TOMATO_UI_H_INCLUDED
#define LCHSPI_TOMATO_UI_H_INCLUDED

#include "lvgl.h"
#include "services/input_wake.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Tomato;

void ui_Tomato_init(void);
void ui_Tomato_screen_init(void);
void ui_Tomato_screen_destroy(void);
void ui_Tomato_open_from_app_grid(void);
void ui_Tomato_return(void);
uint8_t ui_Tomato_handle_key(input_wake_key_t key,
                             input_wake_event_t event);

#ifdef __cplusplus
}
#endif

#endif
