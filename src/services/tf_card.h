#ifndef LCHSPI_TF_CARD_H_INCLUDED
#define LCHSPI_TF_CARD_H_INCLUDED

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define TF_CARD_ROOT_PATH "/tf"
#define TF_CARD_MISC_PATH "/tf/misc"

rt_err_t tf_card_mount(void);
rt_bool_t tf_card_is_mounted(void);
const char *tf_card_root_path(void);
const char *tf_card_status_text(void);

#ifdef __cplusplus
}
#endif

#endif
