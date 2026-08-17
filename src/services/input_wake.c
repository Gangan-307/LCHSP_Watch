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
#define KEY1_LONG_PRESS_MS (1500U)
#define KEY2_LONG_PRESS_MS (2000U)

typedef struct
{
    rt_base_t pin;
    input_wake_key_t key;
    uint32_t long_press_ms;
    int active_high;
    int raw_pressed;
    int stable_pressed;
    uint8_t stable_samples;
    uint8_t suppress_until_release;
    uint8_t long_press_sent;
    uint32_t pressed_at;
} wake_key_t;

static wake_key_t wake_keys[] =
{
#ifdef BSP_KEY1_PIN
    {
        BSP_KEY1_PIN,
        INPUT_WAKE_KEY1,
        KEY1_LONG_PRESS_MS,
#ifdef BSP_KEY1_ACTIVE_HIGH
        1,
#else
        0,
#endif
        0,
        0,
        0,
        0,
        0,
        0
    },
#endif
#ifdef BSP_KEY2_PIN
    {
        BSP_KEY2_PIN,
        INPUT_WAKE_KEY2,
        KEY2_LONG_PRESS_MS,
#ifdef BSP_KEY2_ACTIVE_HIGH
        1,
#else
        0,
#endif
        0,
        0,
        0,
        0,
        0,
        0
    },
#endif
};
static input_wake_event_cb_t event_handler;

static int wake_key_is_pressed(const wake_key_t *key)
{
    int level = rt_pin_read(key->pin);

    return key->active_high ? (level != 0) : (level == 0);
}

static void input_wake_handle_pressed(wake_key_t *key)
{
    key->pressed_at = lv_tick_get();
    key->long_press_sent = 0U;
    display_power_note_user_activity();

    if (display_power_is_off())
    {
        display_power_notify_activity();
        key->suppress_until_release = 1U;
        return;
    }

    display_power_notify_activity();
    key->suppress_until_release = 0U;
}

static void input_wake_handle_released(wake_key_t *key)
{
    display_power_note_user_activity();

    if (!key->suppress_until_release && !key->long_press_sent &&
        event_handler != NULL)
        event_handler(key->key, INPUT_WAKE_EVENT_SHORT_PRESS);

    key->suppress_until_release = 0U;
    key->long_press_sent = 0U;
}

static void input_wake_check_long_press(wake_key_t *key)
{
    if (!key->stable_pressed || key->suppress_until_release ||
        key->long_press_sent ||
        lv_tick_elaps(key->pressed_at) < key->long_press_ms)
        return;

    key->long_press_sent = 1U;
    if (event_handler != NULL)
        event_handler(key->key, INPUT_WAKE_EVENT_LONG_PRESS);
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
                input_wake_handle_pressed(key);
            else
                input_wake_handle_released(key);
        }

        input_wake_check_long_press(key);
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
        wake_keys[index].suppress_until_release =
            wake_keys[index].stable_pressed ? 1U : 0U;
        wake_keys[index].long_press_sent = 0U;
        wake_keys[index].pressed_at = lv_tick_get();
    }

    lv_timer_create(input_wake_timer_cb, KEY_CHECK_PERIOD_MS, NULL);
}

void input_wake_set_event_handler(input_wake_event_cb_t callback)
{
    event_handler = callback;
}
