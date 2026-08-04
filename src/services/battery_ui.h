#ifndef LCHSPI_BATTERY_UI_H_INCLUDED
#define LCHSPI_BATTERY_UI_H_INCLUDED

#include <stdint.h>
#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    uint16_t voltage_mv;
    uint8_t percent;
    uint8_t external_power_present;
    uint8_t valid;
    uint8_t low_battery;
    uint8_t critical_battery;
    uint8_t critical_confirmed;
} battery_status_t;

void battery_ui_init(void);
void battery_ui_get_status(battery_status_t *status);
void battery_ui_bind_home(lv_obj_t *parent);
void battery_ui_unbind_home(void);

#ifdef __cplusplus
}
#endif

#endif
