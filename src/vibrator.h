#ifndef VIBRATOR_H
#define VIBRATOR_H

#include "rtthread.h"

#define VIBRATOR_DEFAULT_PERIOD_NS (1000000U)

rt_err_t vibrator_init(void);
rt_err_t vibrator_set(uint8_t percentage, uint32_t period_ns);
rt_err_t vibrator_on(uint8_t percentage);
void vibrator_off(void);
rt_err_t vibrator_vibrate(uint8_t percentage, rt_uint32_t duration_ms);

#endif
