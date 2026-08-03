/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rtdevice.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "lvgl.h"
#include "drivers/display_power.h"
#include "wrist_wake.h"

#if defined(BSP_USING_I2C3) && defined(ACC_USING_LSM6DSL) && defined(USING_CWM_LIB)

#include "cwm_motion.h"
#include "st_lsm6dsl_sensor_v1.h"

#define LSM6DSL_NAME                 "lsm6dsl"
#define LSM6DSL_ACCE_DEVICE_NAME     "acce_" LSM6DSL_NAME
#define WRIST_THREAD_STACK_SIZE       (4096U)
#define WRIST_THREAD_PRIORITY         (25U)
#define WRIST_THREAD_TICK             (10U)
#define WRIST_SAMPLE_COUNT            (10U)
#define WRIST_SAMPLE_DELAY_MS         (200U)
#define WRIST_WAKE_CHECK_PERIOD_MS    (50U)
#define WRIST_GRAVITY_MIN_SQUARED      (422500.0f)
#define WRIST_GRAVITY_MAX_SQUARED      (1822500.0f)
#define WRIST_RAISE_COS_SQUARED        (0.931225f)
#define WRIST_BASELINE_ALPHA           (0.02f)
#define WRIST_WAKE_COOLDOWN_LOOPS      (8U)

extern cwm_gesture_info_t g_gesture_info;
extern void cwm_all_fifo_data_input(void *buf, int16_t len, uint64_t ts_ns);
extern uint64_t CWM_OS_GetTimeNs(void);

static rt_device_t lsm6dsl_device;
static struct rt_thread wrist_thread;
static rt_uint8_t wrist_thread_stack[WRIST_THREAD_STACK_SIZE];
static volatile rt_uint8_t wrist_wake_pending;
static float gravity_reference[3];
static int gravity_reference_valid;
static uint8_t local_wake_cooldown;

static void wrist_request_wake(void)
{
    wrist_wake_pending = 1;
    local_wake_cooldown = WRIST_WAKE_COOLDOWN_LOOPS;
}

static int wrist_local_raise_detect(const struct rt_sensor_data *sample)
{
    float gravity[3];
    float magnitude_squared;
    float reference_magnitude_squared;
    float direction_dot;

    gravity[0] = (float)sample->data.acce.x;
    gravity[1] = (float)sample->data.acce.y;
    gravity[2] = (float)sample->data.acce.z;
    magnitude_squared = gravity[0] * gravity[0] + gravity[1] * gravity[1] +
                        gravity[2] * gravity[2];

    if (magnitude_squared < WRIST_GRAVITY_MIN_SQUARED ||
        magnitude_squared > WRIST_GRAVITY_MAX_SQUARED)
        return 0;

    if (!gravity_reference_valid)
    {
        gravity_reference[0] = gravity[0];
        gravity_reference[1] = gravity[1];
        gravity_reference[2] = gravity[2];
        gravity_reference_valid = 1;
        return 0;
    }

    reference_magnitude_squared = gravity_reference[0] * gravity_reference[0] +
                                  gravity_reference[1] * gravity_reference[1] +
                                  gravity_reference[2] * gravity_reference[2];
    if (reference_magnitude_squared == 0.0f)
        return 0;

    direction_dot = gravity[0] * gravity_reference[0] +
                    gravity[1] * gravity_reference[1] +
                    gravity[2] * gravity_reference[2];

    if (direction_dot < 0.0f ||
        direction_dot * direction_dot < WRIST_RAISE_COS_SQUARED *
                                        magnitude_squared * reference_magnitude_squared)
    {
        gravity_reference[0] = gravity[0];
        gravity_reference[1] = gravity[1];
        gravity_reference[2] = gravity[2];
        return 1;
    }

    gravity_reference[0] += (gravity[0] - gravity_reference[0]) *
                            WRIST_BASELINE_ALPHA;
    gravity_reference[1] += (gravity[1] - gravity_reference[1]) *
                            WRIST_BASELINE_ALPHA;
    gravity_reference[2] += (gravity[2] - gravity_reference[2]) *
                            WRIST_BASELINE_ALPHA;

    return 0;
}

static void wrist_detect_thread_entry(void *parameter)
{
    (void)parameter;

    while (1)
    {
        struct rt_sensor_data samples[WRIST_SAMPLE_COUNT];
        gsensors_fifo_t fifo_data;
        rt_size_t sample_count;
        rt_size_t index;
        uint16_t valid_count = 0;

        sample_count = rt_device_read(lsm6dsl_device, 0, samples,
                                      WRIST_SAMPLE_COUNT);
        if (sample_count > 0)
        {
            rt_memset(&fifo_data, 0, sizeof(fifo_data));
            for (index = 0; index < sample_count && valid_count < GSENSOR_FIFO_SIZE;
                 index++)
            {
                if (samples[index].data.acce.x == 0 &&
                    samples[index].data.acce.y == 0 &&
                    samples[index].data.acce.z == 0)
                    continue;

                fifo_data.buf[valid_count].acce_data[0] =
                    (float)samples[index].data.acce.x * 9.807f / 1000.0f;
                fifo_data.buf[valid_count].acce_data[1] =
                    (float)samples[index].data.acce.y * 9.807f / 1000.0f;
                fifo_data.buf[valid_count].acce_data[2] =
                    (float)samples[index].data.acce.z * 9.807f / 1000.0f;
                valid_count++;

                if (local_wake_cooldown == 0 &&
                    wrist_local_raise_detect(&samples[index]))
                    wrist_request_wake();
            }

            if (valid_count > 0)
            {
                fifo_data.num = valid_count;
                fifo_data.time_ns = CWM_OS_GetTimeNs();
                cwm_all_fifo_data_input(fifo_data.buf, fifo_data.num,
                                        fifo_data.time_ns);
            }
        }

        if (g_gesture_info.gesture == 1)
        {
            g_gesture_info.gesture = 0;
            wrist_request_wake();
        }

        if (local_wake_cooldown > 0)
            local_wake_cooldown--;

        rt_thread_mdelay(WRIST_SAMPLE_DELAY_MS);
    }
}

static void wrist_wake_timer_cb(lv_timer_t *timer)
{
    (void)timer;

    if (wrist_wake_pending)
    {
        wrist_wake_pending = 0;
        display_power_notify_activity();
    }
}

void wrist_wake_init(void)
{
    struct rt_sensor_config config;

    HAL_PIN_Set(PAD_PA40, I2C3_SCL, PIN_PULLUP, 1);
    HAL_PIN_Set(PAD_PA39, I2C3_SDA, PIN_PULLUP, 1);

    rt_memset(&config, 0, sizeof(config));
    config.intf.dev_name = "i2c3";
    config.intf.user_data = (void *)(rt_ubase_t)LSM6DSL_ADDR_DEFAULT;
    config.irq_pin.pin = RT_PIN_NONE;
    if (rt_hw_lsm6dsl_init(LSM6DSL_NAME, &config) != RT_EOK)
        return;

    lsm6dsl_device = rt_device_find(LSM6DSL_ACCE_DEVICE_NAME);
    if (lsm6dsl_device == RT_NULL)
        return;

    if (rt_device_open(lsm6dsl_device, RT_DEVICE_FLAG_RDONLY) != RT_EOK)
        return;

    rt_device_control(lsm6dsl_device, RT_SENSOR_CTRL_SET_ODR,
                      (void *)(rt_ubase_t)52);
    rt_device_control(lsm6dsl_device, RT_SENSOR_CTRL_SET_MODE,
                      (void *)(rt_ubase_t)RT_SENSOR_MODE_FIFO);

    if (rt_thread_init(&wrist_thread, "wrist_wake", wrist_detect_thread_entry,
                       RT_NULL, wrist_thread_stack, sizeof(wrist_thread_stack),
                       WRIST_THREAD_PRIORITY, WRIST_THREAD_TICK) != RT_EOK)
        return;

    lv_timer_create(wrist_wake_timer_cb, WRIST_WAKE_CHECK_PERIOD_MS, NULL);
    rt_thread_startup(&wrist_thread);
}

#else

void wrist_wake_init(void)
{
}

#endif
