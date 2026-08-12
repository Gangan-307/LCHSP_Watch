#ifndef LCHSPI_MUSIC_UI_H_INCLUDED
#define LCHSPI_MUSIC_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_ScreenMusic;

void ui_ScreenMusic_screen_init(void);
void ui_ScreenMusic_screen_destroy(void);
void ui_ScreenMusic_open_from_home(void);
void ui_ScreenMusic_open_from_app_grid(void);
void ui_ScreenMusic_return(void);

#ifdef __cplusplus
}
#endif

#endif
