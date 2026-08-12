#ifndef LCHSPI_UI_WEATHER_DETAILS_H_INCLUDED
#define LCHSPI_UI_WEATHER_DETAILS_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_WeatherDetails;

void ui_WeatherDetails_screen_init(void);
void ui_WeatherDetails_screen_destroy(void);
void ui_WeatherDetails_open(void);
void ui_WeatherDetails_return(void);
void ui_WeatherDetails_refresh(void);

#ifdef __cplusplus
}
#endif

#endif
