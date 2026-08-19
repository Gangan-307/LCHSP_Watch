/*
 * MMC56X3 magnetic compass service.
 *
 * The board is assumed to mount sensor +Y toward 12 o'clock and +X toward
 * 3 o'clock.  COMPASS_BOARD_ROTATION_DEG is the single board-orientation
 * correction to adjust after comparing a prototype against a known heading.
 */

#include "compass_service.h"

#include <float.h>
#include <math.h>

#include "rtdevice.h"
#include "rtthread.h"

#if defined(SENSOR_USING_MAG) && defined(MAG_USING_MMC56X3) && \
    defined(BSP_USING_I2C3)

#include "bf0_hal.h"
#include "drv_io.h"
#include "sensor.h"
#include "sensor_memsic_mmc56x3.h"

#define COMPASS_SENSOR_NAME                    "mmc56x3"
#define COMPASS_DEVICE_NAME                    "mag_mmc56x3"
#define COMPASS_I2C_NAME                       "i2c3"
#define COMPASS_SAMPLE_PERIOD_MS               (50U)
#define COMPASS_OUTPUT_DATA_RATE_HZ            (20U)
#define COMPASS_THREAD_STACK_SIZE              (2048U)
#define COMPASS_THREAD_PRIORITY                (26U)
#define COMPASS_THREAD_TICK                    (10U)
#define COMPASS_CALIBRATION_TARGET_MGAUSS      (300.0f)
#define COMPASS_MIN_AXIS_SPAN_MGAUSS           (40.0f)
#define COMPASS_MIN_FIELD_MGAUSS               (150.0f)
#define COMPASS_MAX_FIELD_MGAUSS               (1000.0f)
#define COMPASS_MAX_RAW_AXIS_MGAUSS            (100000)
#define COMPASS_FILTER_NEW_WEIGHT              (0.22f)
#define COMPASS_RADIANS_TO_DEGREES             (57.2957795f)
#define COMPASS_BOARD_ROTATION_DEG             (0.0f)

typedef struct
{
    float minimum[3];
    float maximum[3];
    float filtered_right;
    float filtered_forward;
    uint8_t filter_valid;
} compass_calibration_t;

static rt_device_t compass_device;
static struct rt_mutex compass_lock;
static struct rt_semaphore compass_active_sem;
static compass_snapshot_t compass_snapshot;
static compass_calibration_t compass_calibration;
static volatile uint8_t compass_active;
static uint8_t compass_initialized;
static uint8_t compass_available;

static void compass_reset_calibration_locked(void)
{
    uint8_t axis;

    for (axis = 0U; axis < 3U; axis++)
    {
        compass_calibration.minimum[axis] = FLT_MAX;
        compass_calibration.maximum[axis] = -FLT_MAX;
    }
    compass_calibration.filtered_right = 0.0f;
    compass_calibration.filtered_forward = 0.0f;
    compass_calibration.filter_valid = 0U;
    compass_snapshot.valid = 0U;
    compass_snapshot.calibrated = 0U;
    compass_snapshot.calibration_percent = 0U;
    compass_snapshot.interference = 0U;
}

static uint8_t compass_axis_value_is_valid(int32_t value)
{
    return value >= -COMPASS_MAX_RAW_AXIS_MGAUSS &&
           value <= COMPASS_MAX_RAW_AXIS_MGAUSS;
}

static uint8_t compass_calibration_progress_locked(float spans[3])
{
    float progress = 100.0f;
    uint8_t axis;

    for (axis = 0U; axis < 3U; axis++)
    {
        float axis_progress = spans[axis] * 100.0f /
                              COMPASS_CALIBRATION_TARGET_MGAUSS;

        if (axis_progress < progress)
            progress = axis_progress;
    }
    if (progress < 0.0f)
        progress = 0.0f;
    if (progress > 100.0f)
        progress = 100.0f;
    return (uint8_t)(progress + 0.5f);
}

static void compass_process_sample(const struct rt_sensor_data *sample)
{
    float raw[3];
    float spans[3];
    float offsets[3];
    float half_ranges[3];
    float average_half_range;
    float calibrated[3];
    float field_strength;
    float right;
    float forward;
    float heading;
    uint8_t axis;

    if (sample == RT_NULL || sample->type != RT_SENSOR_CLASS_MAG ||
        !compass_axis_value_is_valid(sample->data.mag.x) ||
        !compass_axis_value_is_valid(sample->data.mag.y) ||
        !compass_axis_value_is_valid(sample->data.mag.z))
        return;

    raw[0] = (float)sample->data.mag.x;
    raw[1] = (float)sample->data.mag.y;
    raw[2] = (float)sample->data.mag.z;

    rt_mutex_take(&compass_lock, RT_WAITING_FOREVER);
    for (axis = 0U; axis < 3U; axis++)
    {
        if (raw[axis] < compass_calibration.minimum[axis])
            compass_calibration.minimum[axis] = raw[axis];
        if (raw[axis] > compass_calibration.maximum[axis])
            compass_calibration.maximum[axis] = raw[axis];

        spans[axis] = compass_calibration.maximum[axis] -
                      compass_calibration.minimum[axis];
        offsets[axis] = spans[axis] >= COMPASS_MIN_AXIS_SPAN_MGAUSS ?
                        (compass_calibration.maximum[axis] +
                         compass_calibration.minimum[axis]) * 0.5f : 0.0f;
        half_ranges[axis] = spans[axis] * 0.5f;
    }

    average_half_range = (half_ranges[0] + half_ranges[1] + half_ranges[2]) /
                         3.0f;
    for (axis = 0U; axis < 3U; axis++)
    {
        float scale = 1.0f;

        if (half_ranges[axis] >= COMPASS_MIN_AXIS_SPAN_MGAUSS * 0.5f &&
            average_half_range >= COMPASS_MIN_AXIS_SPAN_MGAUSS * 0.5f)
            scale = average_half_range / half_ranges[axis];
        calibrated[axis] = (raw[axis] - offsets[axis]) * scale;
    }

    compass_snapshot.calibration_percent =
        compass_calibration_progress_locked(spans);
    compass_snapshot.calibrated =
        compass_snapshot.calibration_percent >= 100U ? 1U : 0U;

    /* +Y points to the top of the display and +X points to its right. */
    right = calibrated[0];
    forward = calibrated[1];
    if (!compass_calibration.filter_valid)
    {
        compass_calibration.filtered_right = right;
        compass_calibration.filtered_forward = forward;
        compass_calibration.filter_valid = 1U;
    }
    else
    {
        compass_calibration.filtered_right +=
            (right - compass_calibration.filtered_right) *
            COMPASS_FILTER_NEW_WEIGHT;
        compass_calibration.filtered_forward +=
            (forward - compass_calibration.filtered_forward) *
            COMPASS_FILTER_NEW_WEIGHT;
    }

    heading = atan2f(-compass_calibration.filtered_right,
                     compass_calibration.filtered_forward) *
              COMPASS_RADIANS_TO_DEGREES + COMPASS_BOARD_ROTATION_DEG;
    while (heading < 0.0f)
        heading += 360.0f;
    while (heading >= 360.0f)
        heading -= 360.0f;

    field_strength = sqrtf(calibrated[0] * calibrated[0] +
                           calibrated[1] * calibrated[1] +
                           calibrated[2] * calibrated[2]);
    compass_snapshot.magnetic_x_mgauss = sample->data.mag.x;
    compass_snapshot.magnetic_y_mgauss = sample->data.mag.y;
    compass_snapshot.magnetic_z_mgauss = sample->data.mag.z;
    compass_snapshot.heading_degrees = (uint16_t)(heading + 0.5f);
    if (compass_snapshot.heading_degrees >= 360U)
        compass_snapshot.heading_degrees = 0U;
    compass_snapshot.field_strength_mgauss =
        field_strength > 65535.0f ? 65535U : (uint16_t)(field_strength + 0.5f);
    compass_snapshot.interference =
        compass_snapshot.calibrated &&
        (field_strength < COMPASS_MIN_FIELD_MGAUSS ||
         field_strength > COMPASS_MAX_FIELD_MGAUSS) ? 1U : 0U;
    compass_snapshot.valid = field_strength >= 1.0f ? 1U : 0U;
    rt_mutex_release(&compass_lock);
}

static void compass_thread_entry(void *parameter)
{
    uint8_t log_sample_count = 0U;
    uint8_t log_failure_count = 0U;

    (void)parameter;

    while (1)
    {
        struct rt_sensor_data sample;

        if (!compass_active)
        {
            rt_sem_take(&compass_active_sem, RT_WAITING_FOREVER);
            continue;
        }

        rt_memset(&sample, 0, sizeof(sample));
        if (rt_device_read(compass_device, 0, &sample, 1U) == 1U)
        {
            compass_process_sample(&sample);
            log_failure_count = 0U;
            log_sample_count++;
            if (log_sample_count >= COMPASS_OUTPUT_DATA_RATE_HZ)
            {
                rt_kprintf("compass raw: x=%d y=%d z=%d\n",
                           sample.data.mag.x,
                           sample.data.mag.y,
                           sample.data.mag.z);
                log_sample_count = 0U;
            }
        }
        else
        {
            log_sample_count = 0U;
            log_failure_count++;
            if (log_failure_count >= COMPASS_OUTPUT_DATA_RATE_HZ)
            {
                rt_kprintf("compass: sensor read failed\n");
                log_failure_count = 0U;
            }
        }
        rt_thread_mdelay(COMPASS_SAMPLE_PERIOD_MS);
    }
}

void compass_service_init(void)
{
    struct rt_sensor_config config;
    rt_thread_t thread;

    if (compass_initialized)
        return;
    if (rt_mutex_init(&compass_lock, "compass", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;
    if (rt_sem_init(&compass_active_sem, "compass_s", 0,
                    RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    compass_initialized = 1U;
    rt_memset(&compass_snapshot, 0, sizeof(compass_snapshot));
    rt_memset(&compass_calibration, 0, sizeof(compass_calibration));
    compass_reset_calibration_locked();

    HAL_PIN_Set(PAD_PA40, I2C3_SCL, PIN_PULLUP, 1);
    HAL_PIN_Set(PAD_PA39, I2C3_SDA, PIN_PULLUP, 1);

    rt_memset(&config, 0, sizeof(config));
    config.intf.dev_name = COMPASS_I2C_NAME;
    config.irq_pin.pin = RT_PIN_NONE;
    if (rt_hw_mmc56x3_init(COMPASS_SENSOR_NAME, &config) != RT_EOK)
    {
        rt_kprintf("compass: MMC56X3 initialization failed\n");
        return;
    }

    compass_device = rt_device_find(COMPASS_DEVICE_NAME);
    if (compass_device == RT_NULL ||
        rt_device_open(compass_device, RT_DEVICE_FLAG_RDONLY) != RT_EOK)
    {
        rt_kprintf("compass: magnetometer device is unavailable\n");
        return;
    }

    (void)rt_device_control(compass_device, RT_SENSOR_CTRL_SET_ODR,
                            (void *)(rt_ubase_t)COMPASS_OUTPUT_DATA_RATE_HZ);
    compass_available = 1U;
    compass_snapshot.available = 1U;

    thread = rt_thread_create("compass", compass_thread_entry, RT_NULL,
                              COMPASS_THREAD_STACK_SIZE,
                              COMPASS_THREAD_PRIORITY,
                              COMPASS_THREAD_TICK);
    if (thread == RT_NULL)
    {
        compass_available = 0U;
        compass_snapshot.available = 0U;
        rt_kprintf("compass: cannot create sampling thread\n");
        return;
    }

    rt_thread_startup(thread);
    rt_kprintf("compass: MMC56X3 enabled on i2c3\n");
}

void compass_service_set_active(uint8_t active)
{
    uint8_t was_active;

    if (!compass_initialized || !compass_available)
        return;

    was_active = compass_active;
    compass_active = active ? 1U : 0U;
    if (!was_active && compass_active)
        rt_sem_release(&compass_active_sem);
}

void compass_service_reset_calibration(void)
{
    if (!compass_initialized)
        return;

    rt_mutex_take(&compass_lock, RT_WAITING_FOREVER);
    compass_reset_calibration_locked();
    rt_mutex_release(&compass_lock);
}

void compass_service_get_snapshot(compass_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;

    rt_memset(snapshot, 0, sizeof(*snapshot));
    if (!compass_initialized)
        return;

    rt_mutex_take(&compass_lock, RT_WAITING_FOREVER);
    *snapshot = compass_snapshot;
    rt_mutex_release(&compass_lock);
}

#else

void compass_service_init(void)
{
}

void compass_service_set_active(uint8_t active)
{
    (void)active;
}

void compass_service_reset_calibration(void)
{
}

void compass_service_get_snapshot(compass_snapshot_t *snapshot)
{
    if (snapshot != NULL)
        rt_memset(snapshot, 0, sizeof(*snapshot));
}

#endif
