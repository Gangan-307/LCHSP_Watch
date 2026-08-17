#ifndef LCHSPI_PAN_H_INCLUDED
#define LCHSPI_PAN_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

uint8_t bt_pan_is_connected(void);
uint8_t bt_pan_is_enabled(void);
void bt_pan_set_enabled(uint8_t enabled);

#ifdef __cplusplus
}
#endif

#endif
