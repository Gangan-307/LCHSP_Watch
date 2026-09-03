#ifndef LCHSPI_TF_CARD_H_INCLUDED
#define LCHSPI_TF_CARD_H_INCLUDED

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define TF_CARD_ROOT_PATH "/tf"
#define TF_CARD_MISC_PATH "/tf/misc"

typedef enum
{
    TF_CARD_STATE_ABSENT,
    TF_CARD_STATE_MOUNTING,
    TF_CARD_STATE_MOUNTED,
    TF_CARD_STATE_ERROR,
    TF_CARD_STATE_REMOVING,
} tf_card_state_t;

typedef enum
{
    TF_CARD_EVENT_MOUNTED,
    TF_CARD_EVENT_REMOVING,
    TF_CARD_EVENT_REMOVED,
} tf_card_event_t;

typedef void (*tf_card_event_callback_t)(tf_card_event_t event,
                                         void *user_data);

void tf_card_init(void);
rt_err_t tf_card_mount(void);
rt_bool_t tf_card_is_mounted(void);
tf_card_state_t tf_card_state(void);
uint32_t tf_card_generation(void);
rt_err_t tf_card_register_listener(tf_card_event_callback_t callback,
                                   void *user_data);
const char *tf_card_root_path(void);
const char *tf_card_status_text(void);

#ifdef __cplusplus
}
#endif

#endif
