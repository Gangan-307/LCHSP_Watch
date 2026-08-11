/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rtdevice.h"
#include "lvgl.h"
#include "drivers/display_power.h"
#include "input_wake.h"

#define KEY_CHECK_PERIOD_MS (20U)
#define KEY_DEBOUNCE_SAMPLES (2U)

typedef struct
{
    rt_base_t pin;
    int active_high;
    int raw_pressed;
    int stable_pressed;
    uint8_t stable_samples;
} wake_key_t;

static wake_key_t wake_keys[] =
{
#ifdef BSP_KEY1_PIN
    {
        BSP_KEY1_PIN,
#ifdef BSP_KEY1_ACTIVE_HIGH
        1,
#else
        0,
#endif
        0,
        0,
        0
    },
#endif
#ifdef BSP_KEY2_PIN
    {
        BSP_KEY2_PIN,
#ifdef BSP_KEY2_ACTIVE_HIGH
        1,
#else
        0,
#endif
        0,
        0,
        0
    },
#endif
};
static input_wake_key_press_cb_t key_press_handler;

static int wake_key_is_pressed(const wake_key_t *key)
{
    int level = rt_pin_read(key->pin);

    return key->active_high ? (level != 0) : (level == 0);
}

static void input_wake_handle_press(uint32_t key_index)
{
    if (display_power_is_off())
    {
        /* The press that wakes a sleeping display is deliberately consumed. */
        display_power_notify_activity();
        return;
    }

    display_power_notify_activity();
    if (key_press_handler != NULL)
        key_press_handler(key_index);
}

static void input_wake_timer_cb(lv_timer_t *timer)
{
    uint32_t index;

    (void)timer;

    for (index = 0; index < sizeof(wake_keys) / sizeof(wake_keys[0]); index++)
    {
        wake_key_t *key = &wake_keys[index];
        int pressed = wake_key_is_pressed(key);

        if (pressed != key->raw_pressed)
        {
            key->raw_pressed = pressed;
            key->stable_samples = 1;
            continue;
        }

        if (key->stable_samples < KEY_DEBOUNCE_SAMPLES)
            key->stable_samples++;

        if (key->stable_samples >= KEY_DEBOUNCE_SAMPLES &&
            key->stable_pressed != key->raw_pressed)
        {
            key->stable_pressed = key->raw_pressed;
            if (key->stable_pressed)
                input_wake_handle_press(index);
        }
    }
}

void input_wake_init(void)
{
    uint32_t index;

    for (index = 0; index < sizeof(wake_keys) / sizeof(wake_keys[0]); index++)
    {
        rt_pin_mode(wake_keys[index].pin, PIN_MODE_INPUT);
        wake_keys[index].raw_pressed = wake_key_is_pressed(&wake_keys[index]);
        wake_keys[index].stable_pressed = wake_keys[index].raw_pressed;
        wake_keys[index].stable_samples = KEY_DEBOUNCE_SAMPLES;
    }

    lv_timer_create(input_wake_timer_cb, KEY_CHECK_PERIOD_MS, NULL);
}

input_wake_key_press_cb_t input_wake_get_key_press_handler(void)
{
    return key_press_handler;
}

void input_wake_set_key_press_handler(input_wake_key_press_cb_t callback)
{
    key_press_handler = callback;
}
