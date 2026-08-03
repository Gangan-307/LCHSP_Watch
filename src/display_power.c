/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rtdevice.h"
#include "lvgl.h"
#include "display_power.h"

#define DISPLAY_IDLE_TIMEOUT_MS       (15000U)
#define DISPLAY_CHECK_PERIOD_MS       (200U)
#define DISPLAY_DEFAULT_BRIGHTNESS    (100U)

static rt_device_t lcd_device;
static uint8_t saved_brightness = DISPLAY_DEFAULT_BRIGHTNESS;
static int display_is_off;

static void display_set_brightness(uint8_t brightness)
{
    if (lcd_device != NULL)
        rt_device_control(lcd_device, RTGRAPHIC_CTRL_SET_BRIGHTNESS, &brightness);
}

static void display_turn_off(void)
{
    uint8_t brightness = saved_brightness;

    if (display_is_off)
        return;

    rt_device_control(lcd_device, RTGRAPHIC_CTRL_GET_BRIGHTNESS, &brightness);
    if (brightness > 0)
        saved_brightness = brightness;

    display_set_brightness(0);
    display_is_off = 1;
}

void display_power_wake(void)
{
    if (lcd_device == NULL || !display_is_off)
        return;

    display_set_brightness(saved_brightness);
    display_is_off = 0;
    lv_disp_trig_activity(NULL);
}

static void display_power_timer_cb(lv_timer_t *timer)
{
    uint32_t inactive_time;

    (void)timer;

    inactive_time = lv_disp_get_inactive_time(NULL);
    if (display_is_off)
    {
        if (inactive_time < DISPLAY_IDLE_TIMEOUT_MS)
            display_power_wake();
    }
    else if (inactive_time >= DISPLAY_IDLE_TIMEOUT_MS)
    {
        display_turn_off();
    }
}

void display_power_init(void)
{
    lcd_device = rt_device_find("lcd");
    if (lcd_device == NULL)
        return;

    lv_timer_create(display_power_timer_cb, DISPLAY_CHECK_PERIOD_MS, NULL);
}
