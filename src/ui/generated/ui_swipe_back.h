#ifndef LCHSPI_UI_SWIPE_BACK_H_INCLUDED
#define LCHSPI_UI_SWIPE_BACK_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*ui_swipe_back_action_t)(void);

void ui_swipe_back_register(lv_obj_t *screen,
                            ui_swipe_back_action_t action);

#ifdef __cplusplus
}
#endif

#endif
