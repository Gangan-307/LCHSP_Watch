#ifndef LCHSPI_RECORD_UI_H_INCLUDED
#define LCHSPI_RECORD_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Record;

void ui_Record_init(void);
void ui_Record_screen_init(void);
void ui_Record_screen_destroy(void);
void ui_Record_open_from_app_grid(void);
void ui_Record_return(void);

#ifdef __cplusplus
}
#endif

#endif
