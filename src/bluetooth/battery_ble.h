#ifndef LCHSPI_BATTERY_BLE_H_INCLUDED
#define LCHSPI_BATTERY_BLE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void battery_ble_publish_level(uint8_t percent);
void battery_ble_stack_ready(void);

#ifdef __cplusplus
}
#endif

#endif
