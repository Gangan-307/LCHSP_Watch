// Hand-built Bluetooth settings page for the HSP watch.

#ifndef UI_BLUETOOTH_SETTINGS_H
#define UI_BLUETOOTH_SETTINGS_H

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_BluetoothSettings;

void ui_BluetoothSettings_screen_init(void);
void ui_BluetoothSettings_screen_destroy(void);
void ui_BluetoothSettings_open_from_controls(void);
void ui_BluetoothSettings_open_from_app_grid(void);
void ui_BluetoothSettings_return(void);
void ui_BluetoothSettings_refresh(void);

#ifdef __cplusplus
}
#endif

#endif
