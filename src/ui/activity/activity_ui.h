#ifndef LCHSPI_ACTIVITY_UI_H_INCLUDED
#define LCHSPI_ACTIVITY_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Activity;

void ui_Activity_screen_init(void);
void ui_Activity_screen_destroy(void);
void ui_Activity_open_from_app_grid(void);
void ui_Activity_return(void);

#ifdef __cplusplus
}
#endif

#endif
