    /*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "vibrator.h"

#include "bf0_hal.h"
#include "board.h"
#include "drv_io.h"
#include "drivers/rt_drv_pwm.h"

#define DBG_TAG "vibrator"
#define DBG_LVL DBG_LOG
#include <rtdbg.h>

#define VIBRATOR_PWM_DEV_NAME "pwmt1"
#define VIBRATOR_PWM_CHANNEL  2

static struct rt_device_pwm *vibrator_pwm = RT_NULL;
static rt_timer_t vibrator_timer = RT_NULL;
static rt_bool_t vibrator_ready = RT_FALSE;

static void vibrator_pwm_off(void)
{
    if (vibrator_pwm != RT_NULL)
    {
        rt_pwm_disable(vibrator_pwm, VIBRATOR_PWM_CHANNEL);
    }
}

static void vibrator_timer_callback(void *parameter)
{
    (void)parameter;
    vibrator_pwm_off();
}

rt_err_t vibrator_init(void)
{
    if (vibrator_ready)
    {
        return RT_EOK;
    }

    HAL_PMU_ConfigPeriLdo(PMU_PERI_LDO3_3V3, true, true);
    HAL_PIN_Set(PAD_PA20, GPTIM1_CH2, PIN_NOPULL, 1);

    vibrator_pwm = (struct rt_device_pwm *)rt_device_find(VIBRATOR_PWM_DEV_NAME);
    if (vibrator_pwm == RT_NULL)
    {
        LOG_E("cannot find pwm device: %s", VIBRATOR_PWM_DEV_NAME);
        return -RT_ERROR;
    }

    rt_device_open((struct rt_device *)vibrator_pwm, RT_DEVICE_OFLAG_RDWR);
    vibrator_ready = RT_TRUE;

    return RT_EOK;
}

rt_err_t vibrator_set(uint8_t percentage, uint32_t period_ns)
{
    rt_uint32_t pulse;

    if (vibrator_init() != RT_EOK)
    {
        return -RT_ERROR;
    }

    if (period_ns == 0)
    {
        period_ns = VIBRATOR_DEFAULT_PERIOD_NS;
    }

    if (percentage > 100)
    {
        percentage = 100;
    }

    pulse = (rt_uint32_t)percentage * period_ns / 100;

    rt_pwm_set(vibrator_pwm, VIBRATOR_PWM_CHANNEL, period_ns, pulse);

    if (percentage == 0)
    {
        rt_pwm_disable(vibrator_pwm, VIBRATOR_PWM_CHANNEL);
    }
    else
    {
        rt_pwm_enable(vibrator_pwm, VIBRATOR_PWM_CHANNEL);
    }

    return RT_EOK;
}

rt_err_t vibrator_on(uint8_t percentage)
{
    return vibrator_set(percentage, VIBRATOR_DEFAULT_PERIOD_NS);
}

void vibrator_off(void)
{
    if (vibrator_timer != RT_NULL)
    {
        rt_timer_stop(vibrator_timer);
    }

    vibrator_pwm_off();
}

rt_err_t vibrator_vibrate(uint8_t percentage, rt_uint32_t duration_ms)
{
    rt_tick_t timeout_ticks;

    if (vibrator_timer != RT_NULL)
    {
        rt_timer_stop(vibrator_timer);
    }

    if (vibrator_on(percentage) != RT_EOK)
    {
        return -RT_ERROR;
    }

    if (duration_ms == 0)
    {
        vibrator_off();
        return RT_EOK;
    }

    timeout_ticks = rt_tick_from_millisecond(duration_ms);
    if (timeout_ticks == 0)
    {
        timeout_ticks = 1;
    }

    if (vibrator_timer == RT_NULL)
    {
        vibrator_timer = rt_timer_create("vibrator",
                                         vibrator_timer_callback,
                                         RT_NULL,
                                         timeout_ticks,
                                         RT_TIMER_FLAG_ONE_SHOT | RT_TIMER_FLAG_SOFT_TIMER);
        if (vibrator_timer == RT_NULL)
        {
            vibrator_off();
            return -RT_ERROR;
        }
    }
    else
    {
        rt_timer_control(vibrator_timer, RT_TIMER_CTRL_SET_TIME, &timeout_ticks);
    }

    if (rt_timer_start(vibrator_timer) != RT_EOK)
    {
        vibrator_off();
        return -RT_ERROR;
    }

    return RT_EOK;
}
