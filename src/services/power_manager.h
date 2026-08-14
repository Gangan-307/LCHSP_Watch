#ifndef LCHSPI_POWER_MANAGER_H_INCLUDED
#define LCHSPI_POWER_MANAGER_H_INCLUDED

#include "rtdef.h"

#ifdef __cplusplus
extern "C" {
#endif

void power_manager_boot_gate(void);
void power_manager_startup_feedback(void);
rt_err_t power_manager_shutdown(void);
void power_manager_restart(void);

#ifdef __cplusplus
}
#endif

#endif
