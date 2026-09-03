#include "tf_card.h"

#include <string.h>

#include "dfs_file.h"
#include "dfs_fs.h"
#include "dfs_posix.h"

#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
#include "spi_msd.h"
#endif

#define TF_CARD_SD_DEVICE_NAME       "sd0"
#define TF_CARD_ROOT_DEVICE_NAME     "tfroot"
#define TF_CARD_MISC_DEVICE_NAME     "tfmisc"
#define TF_CARD_ROOT_OFFSET          0x00001000UL
#define TF_CARD_ROOT_LEN             (500UL * 1024UL * 1024UL)
#define TF_CARD_MISC_OFFSET          (TF_CARD_ROOT_OFFSET + TF_CARD_ROOT_LEN)
#define TF_CARD_MISC_LEN             (500UL * 1024UL * 1024UL)
#define TF_CARD_BLOCK_SIZE           0x200UL
#define TF_CARD_READY_RETRY          20U
#define TF_CARD_READY_DELAY_MS       30U
#define TF_CARD_MONITOR_PERIOD_MS    1000U
#define TF_CARD_INSERT_RETRY_MS      30000U
#define TF_CARD_STARTUP_DELAY_MS     1500U
#define TF_CARD_PROBE_FAILURE_LIMIT  2U
#define TF_CARD_MONITOR_STACK_SIZE   2048U
#define TF_CARD_MONITOR_PRIORITY     (RT_THREAD_PRIORITY_MAX - 2U)
#define TF_CARD_MAX_LISTENERS        4U

typedef struct
{
    tf_card_event_callback_t callback;
    void *user_data;
} tf_card_listener_t;

static struct rt_mutex tf_card_lock;
static rt_thread_t tf_card_monitor_thread;
static volatile rt_bool_t tf_card_mounted;
static volatile tf_card_state_t tf_card_current_state = TF_CARD_STATE_ABSENT;
static volatile uint32_t tf_card_current_generation = 1U;
static const char *tf_card_active_root_path = TF_CARD_ROOT_PATH;
static char tf_card_status[96] = "TF card is not mounted";
static tf_card_listener_t tf_card_listeners[TF_CARD_MAX_LISTENERS];
static uint8_t tf_card_listener_count;
static uint8_t tf_card_probe_failures;
static uint8_t tf_card_misc_mounted;
static uint8_t tf_card_initialized;
static volatile uint8_t tf_card_mount_requested;
static rt_tick_t tf_card_last_mount_attempt;
static rt_device_t tf_card_probe_device;
static uint8_t tf_card_probe_device_open;

#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
ALIGN(32) static uint8_t tf_card_probe_buffer[TF_CARD_BLOCK_SIZE];
extern int rt_spi_msd_init(void);

static rt_err_t tf_card_prepare_mount_path(const char *path)
{
    struct stat st;

    if (stat(path, &st) == 0)
    {
        if (S_ISDIR(st.st_mode))
            return RT_EOK;

        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "%s exists but is not a directory", path);
        return -RT_ERROR;
    }

    if (mkdir(path, 0) != 0)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "Cannot create %s: %d", path, rt_get_errno());
        return -RT_ERROR;
    }

    if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode))
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "Mount directory %s is unavailable", path);
        return -RT_ERROR;
    }
    return RT_EOK;
}

static rt_bool_t tf_card_system_root_available(void)
{
    struct stat st;

    return stat("/", &st) == 0 && S_ISDIR(st.st_mode);
}

static rt_err_t tf_card_mount_device(const char *device_name,
                                     const char *path)
{
    rt_set_errno(0);
    if (dfs_mount(device_name, path, "elm", 0, RT_NULL) == RT_EOK)
        return RT_EOK;

    rt_kprintf("tf_card: mount %s on %s failed, errno=%d\n", device_name,
               path, rt_get_errno());
    return -RT_ERROR;
}

static struct rt_device *tf_card_mtd_create(const char *name, long offset,
                                            long len)
{
    rt_device_t msd = rt_device_find(TF_CARD_SD_DEVICE_NAME);
    struct msd_device *msd_dev;
    struct msd_device *msd_file_dev;
    rt_err_t result;

    if (rt_device_find(name) != RT_NULL)
        return rt_device_find(name);
    if (msd == RT_NULL)
        return RT_NULL;

    msd_dev = (struct msd_device *)msd->user_data;
    if (msd_dev == RT_NULL)
        return RT_NULL;

    msd_file_dev = (struct msd_device *)rt_malloc(sizeof(struct msd_device));
    if (msd_file_dev == RT_NULL)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "No memory for TF card device");
        return RT_NULL;
    }

    rt_memset(msd_file_dev, 0, sizeof(*msd_file_dev));
    msd_file_dev->parent.type = RT_Device_Class_MTD;
#ifdef RT_USING_DEVICE_OPS
    msd_file_dev->parent.ops = msd_dev->parent.ops;
#else
    msd_file_dev->parent.init = msd_dev->parent.init;
    msd_file_dev->parent.open = msd_dev->parent.open;
    msd_file_dev->parent.close = msd_dev->parent.close;
    msd_file_dev->parent.read = msd_dev->parent.read;
    msd_file_dev->parent.write = msd_dev->parent.write;
    msd_file_dev->parent.control = msd_dev->parent.control;
#endif
    msd_file_dev->offset = offset;
    msd_file_dev->spi_device = msd_dev->spi_device;
    msd_file_dev->geometry.bytes_per_sector = TF_CARD_BLOCK_SIZE;
    msd_file_dev->geometry.block_size = TF_CARD_BLOCK_SIZE;
    msd_file_dev->geometry.sector_count = len;

    result = rt_device_register(&msd_file_dev->parent, name,
                                RT_DEVICE_FLAG_RDWR |
                                RT_DEVICE_FLAG_REMOVABLE |
                                RT_DEVICE_FLAG_STANDALONE);
    if (result != RT_EOK)
    {
        rt_free(msd_file_dev);
        return RT_NULL;
    }
    return RT_DEVICE(&msd_file_dev->parent);
}

static rt_err_t tf_card_prepare_device(void)
{
    uint16_t retry = TF_CARD_READY_RETRY;

    while (retry-- > 0U &&
           rt_device_find(TF_CARD_SD_DEVICE_NAME) == RT_NULL)
        rt_thread_mdelay(TF_CARD_READY_DELAY_MS);

    if (rt_device_find(TF_CARD_SD_DEVICE_NAME) == RT_NULL)
    {
        if (rt_spi_msd_init() != RT_EOK ||
            rt_device_find(TF_CARD_SD_DEVICE_NAME) == RT_NULL)
        {
            rt_snprintf(tf_card_status, sizeof(tf_card_status),
                        "TF card is not inserted");
            return -RT_ERROR;
        }
        return RT_EOK;
    }

    if (msd_reinit() != RT_EOK)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "TF card is not ready");
        return -RT_ERROR;
    }
    return RT_EOK;
}

static rt_bool_t tf_card_probe_locked(void)
{
    if (tf_card_probe_device == RT_NULL)
        return RT_FALSE;
    return rt_device_read(tf_card_probe_device, 0, tf_card_probe_buffer, 1U) ==
           1U ?
           RT_TRUE : RT_FALSE;
}

static rt_err_t tf_card_mount_locked(void)
{
    rt_bool_t legacy_layout = RT_FALSE;

    if (tf_card_mounted)
        return RT_EOK;
    if (tf_card_current_state == TF_CARD_STATE_REMOVING)
        return -RT_EBUSY;

    tf_card_current_state = TF_CARD_STATE_MOUNTING;
    if (tf_card_prepare_device() != RT_EOK)
        goto mount_failed;

    if (tf_card_system_root_available())
    {
        tf_card_active_root_path = TF_CARD_ROOT_PATH;
        if (tf_card_prepare_mount_path(tf_card_active_root_path) != RT_EOK)
            goto mount_failed;
    }
    else
    {
        tf_card_active_root_path = "/";
        rt_kprintf("tf_card: system root unavailable, mounting TF at /\n");
    }

    if (tf_card_mount_device(TF_CARD_SD_DEVICE_NAME,
                             tf_card_active_root_path) != RT_EOK)
    {
        if (tf_card_mtd_create(TF_CARD_ROOT_DEVICE_NAME,
                               TF_CARD_ROOT_OFFSET >> 9,
                               TF_CARD_ROOT_LEN >> 9) == RT_NULL ||
            tf_card_mount_device(TF_CARD_ROOT_DEVICE_NAME,
                                 tf_card_active_root_path) != RT_EOK)
        {
            rt_snprintf(tf_card_status, sizeof(tf_card_status),
                        "No supported FAT filesystem found on TF card");
            goto mount_failed;
        }
        legacy_layout = RT_TRUE;
    }

    tf_card_misc_mounted = 0U;
    if (legacy_layout &&
        strcmp(tf_card_active_root_path, TF_CARD_ROOT_PATH) == 0 &&
        tf_card_mtd_create(TF_CARD_MISC_DEVICE_NAME,
                           TF_CARD_MISC_OFFSET >> 9,
                           TF_CARD_MISC_LEN >> 9) != RT_NULL &&
        tf_card_prepare_mount_path(TF_CARD_MISC_PATH) == RT_EOK)
    {
        if (tf_card_mount_device(TF_CARD_MISC_DEVICE_NAME,
                                 TF_CARD_MISC_PATH) == RT_EOK)
            tf_card_misc_mounted = 1U;
    }

    tf_card_probe_device = rt_device_find(TF_CARD_SD_DEVICE_NAME);
    if (tf_card_probe_device == RT_NULL)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "Cannot find TF card health probe");
        if (tf_card_misc_mounted)
        {
            (void)dfs_unmount(TF_CARD_MISC_PATH);
            tf_card_misc_mounted = 0U;
        }
        (void)dfs_unmount(tf_card_active_root_path);
        tf_card_probe_device = RT_NULL;
        goto mount_failed;
    }
    tf_card_probe_device_open = 0U;
    if (legacy_layout)
    {
        if (rt_device_open(tf_card_probe_device,
                           RT_DEVICE_OFLAG_RDWR) != RT_EOK)
        {
            rt_snprintf(tf_card_status, sizeof(tf_card_status),
                        "Cannot open TF card health probe");
            if (tf_card_misc_mounted)
            {
                (void)dfs_unmount(TF_CARD_MISC_PATH);
                tf_card_misc_mounted = 0U;
            }
            (void)dfs_unmount(tf_card_active_root_path);
            tf_card_probe_device = RT_NULL;
            goto mount_failed;
        }
        tf_card_probe_device_open = 1U;
    }

    tf_card_probe_failures = 0U;
    tf_card_mounted = RT_TRUE;
    tf_card_current_state = TF_CARD_STATE_MOUNTED;
    tf_card_current_generation++;
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "TF card mounted at %s", tf_card_active_root_path);
    rt_kprintf("tf_card: %s, generation=%u\n", tf_card_status,
               (unsigned int)tf_card_current_generation);
    return RT_EOK;

mount_failed:
    tf_card_mounted = RT_FALSE;
    tf_card_current_state = TF_CARD_STATE_ERROR;
    return -RT_ERROR;
}
#endif

static void tf_card_notify(tf_card_event_t event)
{
    tf_card_listener_t listeners[TF_CARD_MAX_LISTENERS];
    uint8_t count;
    uint8_t index;

    rt_mutex_take(&tf_card_lock, RT_WAITING_FOREVER);
    count = tf_card_listener_count;
    rt_memcpy(listeners, tf_card_listeners,
              sizeof(tf_card_listener_t) * count);
    rt_mutex_release(&tf_card_lock);

    for (index = 0U; index < count; index++)
    {
        if (listeners[index].callback != RT_NULL)
            listeners[index].callback(event, listeners[index].user_data);
    }
}

static void tf_card_handle_removal(void)
{
    const char *root_path;
    uint8_t unmount_misc;

    rt_mutex_take(&tf_card_lock, RT_WAITING_FOREVER);
    if (!tf_card_mounted)
    {
        rt_mutex_release(&tf_card_lock);
        return;
    }
    tf_card_mounted = RT_FALSE;
    tf_card_current_state = TF_CARD_STATE_REMOVING;
    tf_card_current_generation++;
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "TF card removal detected");
    root_path = tf_card_active_root_path;
    unmount_misc = tf_card_misc_mounted;
    tf_card_misc_mounted = 0U;
    rt_mutex_release(&tf_card_lock);

    rt_kprintf("tf_card: removal detected, stopping users\n");
    tf_card_notify(TF_CARD_EVENT_REMOVING);

    rt_mutex_take(&tf_card_lock, RT_WAITING_FOREVER);
    if (unmount_misc && dfs_unmount(TF_CARD_MISC_PATH) != RT_EOK)
        rt_kprintf("tf_card: unmount %s failed, errno=%d\n",
                   TF_CARD_MISC_PATH, rt_get_errno());
    if (dfs_unmount(root_path) != RT_EOK)
        rt_kprintf("tf_card: unmount %s failed, errno=%d\n", root_path,
                   rt_get_errno());
    if (tf_card_probe_device_open && tf_card_probe_device != RT_NULL)
        (void)rt_device_close(tf_card_probe_device);
    tf_card_probe_device_open = 0U;
    tf_card_probe_device = RT_NULL;
    tf_card_current_state = TF_CARD_STATE_ABSENT;
    tf_card_current_generation++;
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "TF card is not inserted");
    rt_mutex_release(&tf_card_lock);

    tf_card_notify(TF_CARD_EVENT_REMOVED);
    rt_kprintf("tf_card: removed, generation=%u\n",
               (unsigned int)tf_card_current_generation);
}

static void tf_card_monitor_entry(void *parameter)
{
    (void)parameter;
    rt_thread_mdelay(TF_CARD_STARTUP_DELAY_MS);

    while (1)
    {
#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
        rt_bool_t removed = RT_FALSE;
        rt_bool_t mounted_now = RT_FALSE;

        rt_mutex_take(&tf_card_lock, RT_WAITING_FOREVER);
        if (tf_card_mounted)
        {
            if (tf_card_probe_locked())
                tf_card_probe_failures = 0U;
            else if (++tf_card_probe_failures >= TF_CARD_PROBE_FAILURE_LIMIT)
                removed = RT_TRUE;
        }
        else if (tf_card_current_state != TF_CARD_STATE_REMOVING)
        {
            rt_tick_t now = rt_tick_get();
            rt_tick_t retry_ticks =
                rt_tick_from_millisecond(TF_CARD_INSERT_RETRY_MS);

            if (tf_card_mount_requested ||
                (now - tf_card_last_mount_attempt) >= retry_ticks)
            {
                tf_card_mount_requested = 0U;
                tf_card_last_mount_attempt = now;
                if (tf_card_mount_locked() == RT_EOK)
                    mounted_now = RT_TRUE;
            }
        }
        rt_mutex_release(&tf_card_lock);

        if (removed)
            tf_card_handle_removal();
        else if (mounted_now)
            tf_card_notify(TF_CARD_EVENT_MOUNTED);
#endif
        rt_thread_mdelay(TF_CARD_MONITOR_PERIOD_MS);
    }
}

void tf_card_init(void)
{
    if (tf_card_initialized)
        return;

    rt_memset(tf_card_listeners, 0, sizeof(tf_card_listeners));
    if (rt_mutex_init(&tf_card_lock, "tf_card", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;
    tf_card_mount_requested = 1U;
    tf_card_initialized = 1U;
    tf_card_monitor_thread = rt_thread_create(
        "tf_monitor", tf_card_monitor_entry, RT_NULL,
        TF_CARD_MONITOR_STACK_SIZE, TF_CARD_MONITOR_PRIORITY,
        RT_THREAD_TICK_DEFAULT);
    if (tf_card_monitor_thread != RT_NULL)
        rt_thread_startup(tf_card_monitor_thread);
    else
        rt_kprintf("tf_card: monitor thread creation failed\n");
}

rt_bool_t tf_card_is_mounted(void)
{
    return tf_card_mounted;
}

tf_card_state_t tf_card_state(void)
{
    return tf_card_current_state;
}

uint32_t tf_card_generation(void)
{
    return tf_card_current_generation;
}

const char *tf_card_root_path(void)
{
    return tf_card_active_root_path;
}

const char *tf_card_status_text(void)
{
    return tf_card_status;
}

rt_err_t tf_card_register_listener(tf_card_event_callback_t callback,
                                   void *user_data)
{
    uint8_t index;

    if (callback == RT_NULL)
        return -RT_EINVAL;
    tf_card_init();
    if (!tf_card_initialized)
        return -RT_ERROR;

    rt_mutex_take(&tf_card_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < tf_card_listener_count; index++)
    {
        if (tf_card_listeners[index].callback == callback &&
            tf_card_listeners[index].user_data == user_data)
        {
            rt_mutex_release(&tf_card_lock);
            return RT_EOK;
        }
    }
    if (tf_card_listener_count >= TF_CARD_MAX_LISTENERS)
    {
        rt_mutex_release(&tf_card_lock);
        return -RT_EFULL;
    }
    tf_card_listeners[tf_card_listener_count].callback = callback;
    tf_card_listeners[tf_card_listener_count].user_data = user_data;
    tf_card_listener_count++;
    rt_mutex_release(&tf_card_lock);
    return RT_EOK;
}

rt_err_t tf_card_mount(void)
{
    tf_card_init();
    if (!tf_card_initialized)
        return -RT_ERROR;

#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
    if (tf_card_mounted)
        return RT_EOK;

    /* Full MSD initialization can block for seconds when no card is present.
     * Keep it out of the LVGL caller and let the low-priority monitor do it. */
    tf_card_mount_requested = 1U;
    return -RT_EBUSY;
#else
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "SPI MSD or ELM FAT is not enabled");
    tf_card_current_state = TF_CARD_STATE_ERROR;
    return -RT_ERROR;
#endif
}
