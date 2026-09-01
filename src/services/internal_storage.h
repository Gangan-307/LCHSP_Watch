#ifndef LCHSPI_INTERNAL_STORAGE_H_INCLUDED
#define LCHSPI_INTERNAL_STORAGE_H_INCLUDED

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

rt_err_t internal_storage_init(void);
rt_err_t internal_storage_ensure_ready(void);

#ifdef __cplusplus
}
#endif

#endif
