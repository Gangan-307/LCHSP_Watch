#ifndef LCHSPI_SAFE_UI_H_INCLUDED
#define LCHSPI_SAFE_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Safe;

void ui_Safe_screen_init(void);
void ui_Safe_screen_destroy(void);
void ui_Safe_open_from_app_grid(void);
void ui_Safe_return(void);

#ifdef __cplusplus
}
#endif

#endif
