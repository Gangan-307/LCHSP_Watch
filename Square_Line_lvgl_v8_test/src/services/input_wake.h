#ifndef LCHSPI_INPUT_WAKE_H_INCLUDED
#define LCHSPI_INPUT_WAKE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*input_wake_key_press_cb_t)(uint32_t key_index);

void input_wake_init(void);
void input_wake_set_key_press_handler(input_wake_key_press_cb_t callback);

#ifdef __cplusplus
}
#endif

#endif
