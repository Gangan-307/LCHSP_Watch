#ifndef LCHSPI_MUSIC_UI_H_INCLUDED
#define LCHSPI_MUSIC_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_ScreenMusic;

void ui_ScreenMusic_screen_init(void);
void ui_ScreenMusic_screen_destroy(void);

#ifdef __cplusplus
}
#endif

#endif
