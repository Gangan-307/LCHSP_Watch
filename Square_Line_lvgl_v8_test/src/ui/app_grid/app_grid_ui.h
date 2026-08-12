#ifndef LCHSPI_APP_GRID_UI_H_INCLUDED
#define LCHSPI_APP_GRID_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
    APP_GRID_APP_MUSIC,
    APP_GRID_APP_LIGHT,
    APP_GRID_APP_BLUETOOTH,
    APP_GRID_APP_WEATHER,
    APP_GRID_APP_MAP,
    APP_GRID_APP_MUYU,
    APP_GRID_APP_ACTIVITY,
    APP_GRID_APP_SETTINGS,
    APP_GRID_APP_WORLD_CLOCK,
    APP_GRID_APP_ALARM,
    APP_GRID_APP_CALENDAR,
    APP_GRID_APP_CAMERA,
    APP_GRID_APP_COMPASS,
    APP_GRID_APP_BIKE_STOPWATCH,
    APP_GRID_APP_CALCULATOR,
    APP_GRID_APP_DRINK,
    APP_GRID_APP_EBOOK,
    APP_GRID_APP_NOTEBOOK,
    APP_GRID_APP_PHOTOS,
    APP_GRID_APP_RECORD,
    APP_GRID_APP_SAFE,
    APP_GRID_APP_SOS,
    APP_GRID_APP_TOMATO,
    APP_GRID_APP_COUNT,
} app_grid_app_id_t;

/* Return non-zero only when the requested application was opened. */
typedef uint8_t (*app_grid_app_open_cb_t)(app_grid_app_id_t app_id);

extern lv_obj_t *ui_AppGrid;

void ui_AppGrid_screen_init(void);
void ui_AppGrid_screen_destroy(void);
void ui_AppGrid_open(void);
void app_grid_set_app_open_handler(app_grid_app_open_cb_t callback);

#ifdef __cplusplus
}
#endif

#endif
