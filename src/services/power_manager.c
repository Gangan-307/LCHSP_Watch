/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rtdevice.h"
#include "bf0_hal.h"
#include "drivers/rgb.h"
#include "drivers/vibrator.h"
#include "power_manager.h"

#define POWER_ON_HOLD_MS       (3000U)
#define POWER_ON_CHECK_MS       (20U)
#define POWER_VIBRATION_LEVEL   (80U)
#define POWER_VIBRATION_MS      (90U)

extern void BSP_LCD_PowerDown(void);
extern void BSP_TP_PowerDown(void);

static void power_manager_vibrate_feedback(void)
{
    if (vibrator_vibrate(POWER_VIBRATION_LEVEL, POWER_VIBRATION_MS) == RT_EOK)
    {
        rt_thread_mdelay(POWER_VIBRATION_MS);
        vibrator_off();
    }
}

static int power_manager_key1_pressed(void)
{
    int level = rt_pin_read(BSP_KEY1_PIN);

#ifdef BSP_KEY1_ACTIVE_HIGH
    return level != 0;
#else
    return level == 0;
#endif
}

static rt_err_t power_manager_configure_key1_wakeup(void)
{
    int8_t wakeup_pin;

    wakeup_pin = HAL_HPAON_QueryWakeupPin(hwp_gpio1, BSP_KEY1_PIN);
    if (wakeup_pin < 0)
    {
        rt_kprintf("power: KEY1 is not a PMU wakeup pin\n");
        return -RT_ERROR;
    }

    if (HAL_PMU_SelectWakeupPin(0, (uint8_t)wakeup_pin) != HAL_OK ||
        HAL_PMU_EnablePinWakeup(0, AON_PIN_MODE_POS_EDGE) != HAL_OK)
    {
        rt_kprintf("power: cannot configure KEY1 wakeup\n");
        return -RT_ERROR;
    }

    return RT_EOK;
}

static void power_manager_enter_hibernate(void)
{
    HAL_PMU_EnterHibernate();

    while (1)
    {
    }
}

void power_manager_boot_gate(void)
{
    uint32_t elapsed;

    if (SystemPowerOnModeGet() != PM_HIBERNATE_BOOT)
        return;

    rt_pin_mode(BSP_KEY1_PIN, PIN_MODE_INPUT);
    for (elapsed = 0; elapsed < POWER_ON_HOLD_MS;
         elapsed += POWER_ON_CHECK_MS)
    {
        if (!power_manager_key1_pressed())
        {
            if (power_manager_configure_key1_wakeup() == RT_EOK)
                power_manager_enter_hibernate();
            return;
        }

        rt_thread_mdelay(POWER_ON_CHECK_MS);
    }
}

void power_manager_startup_feedback(void)
{
    power_manager_vibrate_feedback();
}

rt_err_t power_manager_shutdown(void)
{
    if (power_manager_configure_key1_wakeup() != RT_EOK)
        return -RT_ERROR;

    rgb_led_set_color(0x000000U);
    power_manager_vibrate_feedback();
    BSP_TP_PowerDown();
    BSP_LCD_PowerDown();
    power_manager_enter_hibernate();

    return RT_EOK;
}
