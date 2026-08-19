#ifndef LCHSPI_CAMERA_UI_H_INCLUDED
#define LCHSPI_CAMERA_UI_H_INCLUDED

#include "lvgl.h"
#include "services/input_wake.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Camera;

void ui_Camera_init(void);
void ui_Camera_screen_init(void);
void ui_Camera_screen_destroy(void);
void ui_Camera_open_from_app_grid(void);
void ui_Camera_return(void);
uint8_t ui_Camera_handle_key(input_wake_key_t key,
                             input_wake_event_t event);

#ifdef __cplusplus
}
#endif

#endif
