/*
 * SPDX-FileCopyrightText: 2024-2025 SiFli Technologies(Nanjing) Co., Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rgb.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"
#include "drivers/rt_drv_pwm.h"

#define RGBLED_NAME    "rgbled"

static struct rt_device *rgbled_device = RT_NULL;

struct rt_color
{
    char *color_name;
    uint32_t color;
};

// 预定义颜色数组
static struct rt_color rgb_color_arry[] =
{
    {"black",  0x000000},
    {"blue",   0x0000ff},
    {"green",  0x00ff00},
    {"cyan",   0x00ffff},
    {"red",    0xff0000},
    {"purple", 0xff00ff},
};

/**
  * @brief  初始化 RGB 硬件引脚并寻找设备
  */
void rgb_led_config(void)
{
    /* 1. 查找 RGB 硬件设备，这里在系统初始化阶段进行匹配 */
    rgbled_device = rt_device_find(RGBLED_NAME);
    if (!rgbled_device)
    {
        rt_kprintf("Error: Cannot find RGB LED device: %s\n", RGBLED_NAME);
        RT_ASSERT(0);
    }

    /* 2. 根据不同的 SoC 芯片硬件平台映射对应的通道 */
#ifdef SF32LB52X
    HAL_PIN_Set(PAD_PA32, GPTIM2_CH1, PIN_NOPULL, 1);   // RGB LED 52x  pwm3_cc1
#elif defined SF32LB58X
    HAL_PIN_Set(PAD_PB39, GPTIM3_CH4, PIN_NOPULL, 0);   // 58x          pwm4_cc4
#elif defined SF32LB56X
    HAL_PIN_Set(PAD_PB09, GPTIM3_CH4, PIN_NOPULL, 0);   // 566          pwm4_cc4
#endif

    /* 3. 在 52x 平台上开启 LDO 外设供电 */
#ifdef SF32LB52X
    HAL_PMU_ConfigPeriLdo(PMU_PERI_LDO3_3V3, true, true);
#endif

    rt_kprintf("RGB LED driver device [%s] found and initialized.\n", RGBLED_NAME);
}

/**
  * @brief  改变 RGB LED 的颜色
  * @param  color 32位 RGB 颜色编码（如 0xffffff 表示白光，0x000000 表示灭灯）
  */
void rgb_led_set_color(uint32_t color)
{
    if (rgbled_device != RT_NULL)
    {
        struct rt_rgbled_configuration configuration;
        configuration.color_rgb = color;
        rt_device_control(rgbled_device, PWM_CMD_SET_COLOR, &configuration);
    }
}
