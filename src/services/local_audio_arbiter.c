#include "local_audio_arbiter.h"

static struct rt_mutex local_audio_lock;
static local_audio_owner_t local_audio_owner;
static rt_bool_t local_audio_initialized;

void local_audio_arbiter_init(void)
{
    if (local_audio_initialized)
        return;

    if (rt_mutex_init(&local_audio_lock, "local_audio",
                      RT_IPC_FLAG_PRIO) == RT_EOK)
    {
        local_audio_owner = LOCAL_AUDIO_OWNER_NONE;
        local_audio_initialized = RT_TRUE;
    }
}

rt_err_t local_audio_arbiter_acquire(local_audio_owner_t owner)
{
    rt_err_t result = -RT_EBUSY;

    if (owner == LOCAL_AUDIO_OWNER_NONE)
        return -RT_EINVAL;
    local_audio_arbiter_init();
    if (!local_audio_initialized)
        return -RT_ERROR;

    rt_mutex_take(&local_audio_lock, RT_WAITING_FOREVER);
    if (local_audio_owner == LOCAL_AUDIO_OWNER_NONE)
    {
        local_audio_owner = owner;
        result = RT_EOK;
    }
    rt_mutex_release(&local_audio_lock);
    return result;
}

void local_audio_arbiter_release(local_audio_owner_t owner)
{
    if (!local_audio_initialized || owner == LOCAL_AUDIO_OWNER_NONE)
        return;

    rt_mutex_take(&local_audio_lock, RT_WAITING_FOREVER);
    if (local_audio_owner == owner)
        local_audio_owner = LOCAL_AUDIO_OWNER_NONE;
    rt_mutex_release(&local_audio_lock);
}

local_audio_owner_t local_audio_arbiter_owner(void)
{
    local_audio_owner_t owner;

    local_audio_arbiter_init();
    if (!local_audio_initialized)
        return LOCAL_AUDIO_OWNER_NONE;

    rt_mutex_take(&local_audio_lock, RT_WAITING_FOREVER);
    owner = local_audio_owner;
    rt_mutex_release(&local_audio_lock);
    return owner;
}
