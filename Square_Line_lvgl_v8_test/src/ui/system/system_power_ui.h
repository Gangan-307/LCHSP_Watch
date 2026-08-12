#ifndef LCHSPI_SYSTEM_POWER_UI_H_INCLUDED
#define LCHSPI_SYSTEM_POWER_UI_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void system_power_ui_open(void);
void system_power_ui_close(void);
uint8_t system_power_ui_is_open(void);
void system_power_ui_destroy(void);

#ifdef __cplusplus
}
#endif

#endif
