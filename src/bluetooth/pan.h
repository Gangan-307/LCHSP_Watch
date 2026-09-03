#ifndef LCHSPI_PAN_H_INCLUDED
#define LCHSPI_PAN_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

uint8_t bt_pan_is_connected(void);
uint8_t bt_pan_network_is_connected(void);
uint8_t bt_pan_prepare_ota_link(void);
uint8_t bt_pan_is_enabled(void);
void bt_pan_set_enabled(uint8_t enabled);
uint8_t bt_pan_take_picture(void);
uint8_t bt_pan_hid_is_connected(void);

#ifdef __cplusplus
}
#endif

#endif
