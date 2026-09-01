#include "internal_storage.h"
#include "board.h"

#if defined(RT_USING_DFS) && defined(FS_REGION_START_ADDR) && \
    defined(FS_REGION_SIZE)
#include "dfs_fs.h"
#include "drv_flash.h"

#define INTERNAL_STORAGE_DEVICE_NAME "musicfs"

static struct rt_mutex internal_storage_lock;
static rt_bool_t internal_storage_lock_ready;

static rt_err_t internal_storage_mount_locked(rt_bool_t allow_format)
{
    int mount_error;

    if (dfs_filesystem_lookup("/") != RT_NULL)
        return RT_EOK;

    if (rt_device_find(INTERNAL_STORAGE_DEVICE_NAME) == RT_NULL)
    {
        register_mtd_device(FS_REGION_START_ADDR, FS_REGION_SIZE,
                            INTERNAL_STORAGE_DEVICE_NAME);
        if (rt_device_find(INTERNAL_STORAGE_DEVICE_NAME) == RT_NULL)
        {
            rt_kprintf("storage: device registration failed (0x%08x, %u)\n",
                       (unsigned int)FS_REGION_START_ADDR,
                       (unsigned int)FS_REGION_SIZE);
            return -RT_ERROR;
        }
    }

    rt_set_errno(0);
    if (dfs_mount(INTERNAL_STORAGE_DEVICE_NAME, "/", "elm", 0, RT_NULL) ==
        RT_EOK)
    {
        rt_kprintf("storage: filesystem mounted at /\n");
        return RT_EOK;
    }

    mount_error = rt_get_errno();
    rt_kprintf("storage: mount failed, errno=%d\n", mount_error);
    if (!allow_format)
        return -RT_ERROR;

    rt_set_errno(0);
    if (dfs_mkfs("elm", INTERNAL_STORAGE_DEVICE_NAME) != RT_EOK)
    {
        rt_kprintf("storage: format failed, errno=%d\n", rt_get_errno());
        return -RT_ERROR;
    }

    rt_set_errno(0);
    if (dfs_mount(INTERNAL_STORAGE_DEVICE_NAME, "/", "elm", 0, RT_NULL) !=
        RT_EOK)
    {
        rt_kprintf("storage: mount after format failed, errno=%d\n",
                   rt_get_errno());
        return -RT_ERROR;
    }

    rt_kprintf("storage: formatted and mounted at /\n");
    return RT_EOK;
}

rt_err_t internal_storage_init(void)
{
    rt_err_t result;

    if (!internal_storage_lock_ready)
    {
        if (rt_mutex_init(&internal_storage_lock, "int_store",
                          RT_IPC_FLAG_PRIO) != RT_EOK)
            return -RT_ERROR;
        internal_storage_lock_ready = RT_TRUE;
    }

    rt_mutex_take(&internal_storage_lock, RT_WAITING_FOREVER);
    result = internal_storage_mount_locked(RT_TRUE);
    rt_mutex_release(&internal_storage_lock);
    return result;
}

rt_err_t internal_storage_ensure_ready(void)
{
    rt_err_t result;

    if (!internal_storage_lock_ready)
        return internal_storage_init();

    rt_mutex_take(&internal_storage_lock, RT_WAITING_FOREVER);
    result = internal_storage_mount_locked(RT_FALSE);
    rt_mutex_release(&internal_storage_lock);
    return result;
}

#else

rt_err_t internal_storage_init(void)
{
    rt_kprintf("storage: DFS or internal flash region is unavailable\n");
    return -RT_ENOSYS;
}

rt_err_t internal_storage_ensure_ready(void)
{
    return -RT_ENOSYS;
}

#endif
