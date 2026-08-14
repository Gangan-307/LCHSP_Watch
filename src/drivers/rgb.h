#ifndef LCHSPI_RGB_H_INCLUDED
#define LCHSPI_RGB_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

void rgb_led_config(void);
void rgb_led_set_color(uint32_t color);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* LCHSPI_RGB_H_INCLUDED */
