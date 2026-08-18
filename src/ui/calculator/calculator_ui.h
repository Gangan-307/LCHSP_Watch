#ifndef LCHSPI_CALCULATOR_UI_H_INCLUDED
#define LCHSPI_CALCULATOR_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_Calculator;

void ui_Calculator_screen_init(void);
void ui_Calculator_screen_destroy(void);
void ui_Calculator_open_from_app_grid(void);
void ui_Calculator_return(void);

#ifdef __cplusplus
}
#endif

#endif
