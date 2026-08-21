#ifndef LCHSPI_SETTINGS_UI_H_INCLUDED
#define LCHSPI_SETTINGS_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Settings;

void ui_Settings_screen_init(void);
void ui_Settings_screen_destroy(void);
void ui_Settings_open_from_app_grid(void);
void ui_Settings_return(void);

#ifdef __cplusplus
}
#endif

#endif
