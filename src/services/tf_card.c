#include "tf_card.h"

#include "dfs_file.h"
#include "dfs_posix.h"

#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
#include "spi_msd.h"
#endif

#define TF_CARD_SD_DEVICE_NAME   "sd0"
#define TF_CARD_ROOT_DEVICE_NAME "tfroot"
#define TF_CARD_MISC_DEVICE_NAME "tfmisc"
#define TF_CARD_ROOT_OFFSET      0x00001000UL
#define TF_CARD_ROOT_LEN         (500UL * 1024UL * 1024UL)
#define TF_CARD_MISC_OFFSET      (TF_CARD_ROOT_OFFSET + TF_CARD_ROOT_LEN)
#define TF_CARD_MISC_LEN         (500UL * 1024UL * 1024UL)
#define TF_CARD_BLOCK_SIZE       0x200UL
#define TF_CARD_READY_RETRY      20U
#define TF_CARD_READY_DELAY_MS   30U

static rt_bool_t tf_card_mounted;
static const char *tf_card_active_root_path = TF_CARD_ROOT_PATH;
static char tf_card_status[96] = "TF card is not mounted";

#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
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
    if (dfs_mount(device_name, path, "elm", 0, 0) == RT_EOK)
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
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "TF card device %s not found", TF_CARD_SD_DEVICE_NAME);
        return RT_NULL;
    }

    msd_dev = (struct msd_device *)msd->user_data;
    if (msd_dev == RT_NULL)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "TF card device data is unavailable");
        return RT_NULL;
    }

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
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "Register TF volume %s failed: %d", name, result);
        return RT_NULL;
    }

    return RT_DEVICE(&msd_file_dev->parent);
}
#endif

rt_bool_t tf_card_is_mounted(void)
{
    return tf_card_mounted;
}

const char *tf_card_root_path(void)
{
    return tf_card_active_root_path;
}

const char *tf_card_status_text(void)
{
    return tf_card_status;
}

rt_err_t tf_card_mount(void)
{
#if defined(RT_USING_SPI_MSD) && defined(RT_USING_DFS_ELMFAT)
    uint16_t retry = TF_CARD_READY_RETRY;
    rt_bool_t legacy_layout = RT_FALSE;

    if (tf_card_mounted)
        return RT_EOK;

    while (retry-- > 0U)
    {
        if (rt_device_find(TF_CARD_SD_DEVICE_NAME) != RT_NULL)
            break;
        rt_thread_mdelay(TF_CARD_READY_DELAY_MS);
    }

    if (rt_device_find(TF_CARD_SD_DEVICE_NAME) == RT_NULL)
    {
        rt_snprintf(tf_card_status, sizeof(tf_card_status),
                    "TF card device %s not found", TF_CARD_SD_DEVICE_NAME);
        return -RT_ERROR;
    }

    if (tf_card_system_root_available())
    {
        tf_card_active_root_path = TF_CARD_ROOT_PATH;
        if (tf_card_prepare_mount_path(tf_card_active_root_path) != RT_EOK)
            return -RT_ERROR;
    }
    else
    {
        tf_card_active_root_path = "/";
        rt_kprintf("tf_card: system root is unavailable, mounting TF at /\n");
    }

    /* A normal PC-formatted card is mounted directly. The fixed-offset
     * volumes from the spi_tf reference project remain supported as fallback. */
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
            return -RT_ERROR;
        }
        legacy_layout = RT_TRUE;
    }

    if (legacy_layout &&
        strcmp(tf_card_active_root_path, TF_CARD_ROOT_PATH) == 0 &&
        tf_card_mtd_create(TF_CARD_MISC_DEVICE_NAME,
                           TF_CARD_MISC_OFFSET >> 9,
                           TF_CARD_MISC_LEN >> 9) != RT_NULL)
    {
        if (tf_card_prepare_mount_path(TF_CARD_MISC_PATH) == RT_EOK &&
            tf_card_mount_device(TF_CARD_MISC_DEVICE_NAME,
                                 TF_CARD_MISC_PATH) != RT_EOK)
        {
            rt_kprintf("tf_card: optional misc volume is unavailable\n");
        }
    }

    tf_card_mounted = RT_TRUE;
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "TF card mounted at %s", tf_card_active_root_path);
    rt_kprintf("tf_card: %s\n", tf_card_status);
    return RT_EOK;
#else
    rt_snprintf(tf_card_status, sizeof(tf_card_status),
                "SPI MSD or ELM FAT is not enabled");
    return -RT_ERROR;
#endif
}
