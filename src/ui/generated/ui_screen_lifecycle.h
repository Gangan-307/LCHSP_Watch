#ifndef HSP_UI_SCREEN_LIFECYCLE_H
#define HSP_UI_SCREEN_LIFECYCLE_H

#include "lvgl.h"

void ui_screen_release_on_unload(lv_obj_t *screen, void (*destroy)(void));
void ui_screen_log_memory(const char *stage);

#endif
