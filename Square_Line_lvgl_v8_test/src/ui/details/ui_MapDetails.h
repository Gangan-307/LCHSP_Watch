#ifndef LCHSPI_UI_MAP_DETAILS_H_INCLUDED
#define LCHSPI_UI_MAP_DETAILS_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_MapDetails;

void ui_MapDetails_screen_init(void);
void ui_MapDetails_screen_destroy(void);
void ui_MapDetails_open(void);
void ui_MapDetails_return(void);
void ui_MapDetails_refresh(void);

#ifdef __cplusplus
}
#endif

#endif
