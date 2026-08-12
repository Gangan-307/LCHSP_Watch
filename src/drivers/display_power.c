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

/* The SiFli LVGL touch port exposes its registered pointer input device. */
extern lv_indev_t *touch_get_indev_handler(void);

static rt_device_t lcd_device;
static lv_indev_t *touch_indev;
static uint8_t saved_brightness = DISPLAY_DEFAULT_BRIGHTNESS;
static int display_is_off;
static uint8_t display_forced_off;
static void (*touch_read_cb)(lv_indev_drv_t *drv, lv_indev_data_t *data);
static uint8_t suppress_touch_until_release;

static void display_power_touch_read(lv_indev_drv_t *drv, lv_indev_data_t *data)
{
    uint8_t was_off = display_is_off;

    touch_read_cb(drv, data);

    if (suppress_touch_until_release)
    {
        if (data->state == LV_INDEV_STATE_RELEASED)
            suppress_touch_until_release = 0U;

        data->state = LV_INDEV_STATE_RELEASED;
        return;
    }

    if (was_off && data->state == LV_INDEV_STATE_PRESSED)
    {
        /* The first touch after sleep only wakes the display. */
        display_power_notify_activity();
        suppress_touch_until_release = 1U;
        data->state = LV_INDEV_STATE_RELEASED;
    }
}

static void display_power_install_touch_wake_guard(void)
{
    touch_indev = touch_get_indev_handler();

    if (touch_indev == NULL || touch_indev->driver == NULL ||
        touch_indev->driver->type != LV_INDEV_TYPE_POINTER ||
        touch_indev->driver->read_cb == NULL)
        return;

    if (touch_indev->driver->read_cb == display_power_touch_read)
        return;

    touch_read_cb = touch_indev->driver->read_cb;
    touch_indev->driver->read_cb = display_power_touch_read;
}

static void display_set_brightness(uint8_t brightness)
{
    if (lcd_device != NULL)
        rt_device_control(lcd_device, RTGRAPHIC_CTRL_SET_BRIGHTNESS, &brightness);
}

static void display_turn_off(uint8_t forced)
{
    uint8_t brightness = saved_brightness;

    if (lcd_device == NULL || display_is_off)
        return;

    if (touch_indev != NULL)
        lv_indev_reset(touch_indev, NULL);

    rt_device_control(lcd_device, RTGRAPHIC_CTRL_GET_BRIGHTNESS, &brightness);
    if (brightness > 0)
        saved_brightness = brightness;

    display_set_brightness(0);
    display_is_off = 1;
    display_forced_off = forced;
}

void display_power_notify_activity(void)
{
    if (lcd_device == NULL)
        return;

    lv_disp_trig_activity(NULL);

    if (display_is_off)
    {
        display_set_brightness(saved_brightness);
        display_is_off = 0;
    }
    display_forced_off = 0U;
}

void display_power_wake(void)
{
    display_power_notify_activity();
}

void display_power_sleep(void)
{
    display_turn_off(1U);
}

int display_power_is_off(void)
{
    return display_is_off;
}

uint8_t display_power_get_brightness(void)
{
    return saved_brightness;
}

void display_power_set_brightness(uint8_t brightness)
{
    if (brightness == 0U)
        brightness = 1U;
    else if (brightness > 100U)
        brightness = 100U;

    saved_brightness = brightness;
    if (!display_is_off)
        display_set_brightness(saved_brightness);
}

static void display_power_timer_cb(lv_timer_t *timer)
{
    uint32_t inactive_time;

    (void)timer;

    inactive_time = lv_disp_get_inactive_time(NULL);
    if (display_is_off)
    {
        if (!display_forced_off && inactive_time < DISPLAY_IDLE_TIMEOUT_MS)
            display_power_wake();
    }
    else if (inactive_time >= DISPLAY_IDLE_TIMEOUT_MS)
    {
        display_turn_off(0U);
    }
}

void display_power_init(void)
{
    lcd_device = rt_device_find("lcd");
    if (lcd_device == NULL)
        return;

    display_power_install_touch_wake_guard();
    lv_timer_create(display_power_timer_cb, DISPLAY_CHECK_PERIOD_MS, NULL);
}
