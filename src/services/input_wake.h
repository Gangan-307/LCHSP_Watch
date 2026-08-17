#ifndef LCHSPI_INPUT_WAKE_H_INCLUDED
#define LCHSPI_INPUT_WAKE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
    INPUT_WAKE_KEY1 = 0,
    INPUT_WAKE_KEY2 = 1,
} input_wake_key_t;

typedef enum
{
    INPUT_WAKE_EVENT_SHORT_PRESS,
    INPUT_WAKE_EVENT_LONG_PRESS,
} input_wake_event_t;

typedef void (*input_wake_event_cb_t)(input_wake_key_t key,
                                      input_wake_event_t event);

void input_wake_init(void);
void input_wake_set_event_handler(input_wake_event_cb_t callback);

#ifdef __cplusplus
}
#endif

#endif
