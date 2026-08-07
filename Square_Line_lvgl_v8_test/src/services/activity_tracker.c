/*
 * Daily activity totals sourced from the LSM6DS3/LSM6DSL hardware pedometer.
 * The chip counter is 16-bit, so this service keeps a 32-bit daily total and
 * safely rebases on a counter wrap or a new calendar day.
 */

#include <stdint.h>

#include "rtthread.h"
#include "rtdevice.h"
#include "sensor.h"
#include "bf0_hal.h"

#include "bluetooth/find_phone_ble.h"
#include "activity_tracker.h"

#define ACTIVITY_STEP_DEVICE_NAME          "step_lsm6dsl"
#define ACTIVITY_POLL_PERIOD_MS            (1000U)
#define ACTIVITY_THREAD_STACK_SIZE         (1536U)
#define ACTIVITY_THREAD_PRIORITY           (27U)
#define ACTIVITY_THREAD_TICK               (10U)
#define ACTIVITY_MAX_DELTA_PER_POLL        (12U)
#define ACTIVITY_CALORIES_PER_1000_STEPS   (40U)
#define ACTIVITY_STEP_LENGTH_MM            (700U)

extern RTC_HandleTypeDef RTC_Handler;

static rt_device_t activity_step_device;
static struct rt_mutex activity_lock;
static uint8_t activity_initialized;
static uint8_t activity_available;
static uint8_t activity_counter_initialized;
static uint16_t activity_last_hardware_steps;
static int32_t activity_day_key = -1;
static activity_metrics_t activity_metrics;

static int32_t activity_tracker_get_day_key(void)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};

    HAL_RTC_GetTime(&RTC_Handler, &time, RTC_FORMAT_BIN);
    if (HAL_RTC_GetDate(&RTC_Handler, &date, RTC_FORMAT_BIN) != HAL_OK ||
        date.Month < 1U || date.Month > 12U || date.Date < 1U || date.Date > 31U)
        return -1;

    return ((int32_t)date.Year << 9) | ((int32_t)date.Month << 5) |
           (int32_t)date.Date;
}

static void activity_tracker_update_derived_locked(void)
{
    uint64_t calories;
    uint64_t distance;

    calories = ((uint64_t)activity_metrics.steps *
                ACTIVITY_CALORIES_PER_1000_STEPS + 500U) / 1000U;
    distance = ((uint64_t)activity_metrics.steps * ACTIVITY_STEP_LENGTH_MM +
                500U) / 1000U;
    activity_metrics.calories_kcal = calories > UINT16_MAX ? UINT16_MAX :
                                      (uint16_t)calories;
    activity_metrics.distance_meters = distance > UINT32_MAX ? UINT32_MAX :
                                       (uint32_t)distance;
}

static uint8_t activity_tracker_poll_counter(void)
{
    struct rt_sensor_data sample;
    int32_t day_key;
    uint16_t hardware_steps;
    uint16_t delta;
    uint8_t publish = 0U;

    if (rt_device_read(activity_step_device, 0, &sample, 1U) != 1U)
        return 0U;

    hardware_steps = (uint16_t)sample.data.step;
    day_key = activity_tracker_get_day_key();

    rt_mutex_take(&activity_lock, RT_WAITING_FOREVER);
    if (!activity_counter_initialized)
    {
        activity_last_hardware_steps = hardware_steps;
        activity_counter_initialized = 1U;
        activity_day_key = day_key;
        activity_metrics.valid = 1U;
        activity_tracker_update_derived_locked();
        publish = 1U;
    }
    else if (day_key >= 0 && day_key != activity_day_key)
    {
        activity_day_key = day_key;
        activity_last_hardware_steps = hardware_steps;
        activity_metrics.steps = 0U;
        activity_metrics.valid = 1U;
        activity_tracker_update_derived_locked();
        publish = 1U;
    }
    else
    {
        delta = (uint16_t)(hardware_steps - activity_last_hardware_steps);
        activity_last_hardware_steps = hardware_steps;

        /* A large backward jump means the IMU counter was reset, not walked. */
        if (delta > 0U && delta <= ACTIVITY_MAX_DELTA_PER_POLL)
        {
            if (UINT32_MAX - activity_metrics.steps < delta)
                activity_metrics.steps = UINT32_MAX;
            else
                activity_metrics.steps += delta;
            activity_metrics.valid = 1U;
            activity_tracker_update_derived_locked();
            publish = 1U;
        }
    }
    rt_mutex_release(&activity_lock);

    if (publish)
        find_phone_ble_publish_activity();

    return publish;
}

static void activity_tracker_thread_entry(void *parameter)
{
    (void)parameter;

    while (1)
    {
        activity_tracker_poll_counter();
        rt_thread_mdelay(ACTIVITY_POLL_PERIOD_MS);
    }
}

void activity_tracker_init(void)
{
    rt_thread_t thread;

    if (activity_initialized)
        return;
    activity_initialized = 1U;

    if (rt_mutex_init(&activity_lock, "activity", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    activity_step_device = rt_device_find(ACTIVITY_STEP_DEVICE_NAME);
    if (activity_step_device == RT_NULL)
    {
        rt_kprintf("activity: hardware step counter is unavailable\n");
        return;
    }
    if (rt_device_open(activity_step_device, RT_DEVICE_FLAG_RDONLY) != RT_EOK)
    {
        rt_kprintf("activity: cannot open hardware step counter\n");
        return;
    }
    if (rt_device_control(activity_step_device, RT_SENSOR_CTRL_SET_MODE,
                          (void *)(rt_ubase_t)RT_SENSOR_MODE_POLLING) != RT_EOK)
    {
        rt_kprintf("activity: cannot set hardware step counter to polling mode\n");
        return;
    }
    if (rt_device_control(activity_step_device, RT_SENSOR_CTRL_SET_POWER,
                          (void *)(rt_ubase_t)RT_SENSOR_POWER_NORMAL) != RT_EOK)
    {
        rt_kprintf("activity: cannot enable hardware step counter\n");
        return;
    }

    activity_available = 1U;
    /* Populate the home screen with a zero baseline without waiting one second. */
    (void)activity_tracker_poll_counter();
    rt_kprintf("activity: hardware step counter enabled\n");
    thread = rt_thread_create("activity", activity_tracker_thread_entry, RT_NULL,
                              ACTIVITY_THREAD_STACK_SIZE,
                              ACTIVITY_THREAD_PRIORITY, ACTIVITY_THREAD_TICK);
    if (thread == RT_NULL)
    {
        activity_available = 0U;
        rt_kprintf("activity: cannot create tracker thread\n");
        return;
    }

    rt_thread_startup(thread);
}

void activity_tracker_get_metrics(activity_metrics_t *metrics)
{
    if (metrics == RT_NULL)
        return;

    rt_memset(metrics, 0, sizeof(*metrics));
    if (!activity_available)
        return;

    rt_mutex_take(&activity_lock, RT_WAITING_FOREVER);
    *metrics = activity_metrics;
    rt_mutex_release(&activity_lock);
}

uint8_t activity_tracker_is_available(void)
{
    return activity_available;
}
