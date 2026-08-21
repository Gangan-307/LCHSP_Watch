/* Small recent-message cache fed by the HSP companion BLE service. */

#include <string.h>

#include "drivers/vibrator.h"
#include "phone_notifications.h"

#define NOTIFICATION_VIBRATION_LEVEL  (75U)
#define NOTIFICATION_VIBRATION_MS     (120U)

static struct rt_mutex phone_notifications_lock;
static uint8_t phone_notifications_initialized;
static phone_notification_snapshot_t phone_notifications;
static uint16_t phone_notifications_pending_preview_id;
static uint8_t phone_notifications_do_not_disturb;

static uint8_t phone_notifications_app_is_valid(uint8_t app)
{
    return app >= PHONE_NOTIFICATION_APP_SMS &&
           app <= PHONE_NOTIFICATION_APP_QQ;
}

static uint8_t phone_notifications_content_matches(
    const phone_notification_t *item, uint8_t app,
    const uint8_t *title, uint16_t title_len,
    const uint8_t *body, uint16_t body_len)
{
    if (!item->valid || item->app != app ||
        item->title_len != title_len || item->body_len != body_len)
        return 0U;
    if (title_len > 0U && memcmp(item->title, title, title_len) != 0)
        return 0U;
    if (body_len > 0U && memcmp(item->body, body, body_len) != 0)
        return 0U;

    return 1U;
}

void phone_notifications_init(void)
{
    if (phone_notifications_initialized)
        return;

    if (rt_mutex_init(&phone_notifications_lock, "phone_msg", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    rt_memset(&phone_notifications, 0, sizeof(phone_notifications));
    phone_notifications_initialized = 1U;
}

void phone_notifications_set_do_not_disturb(uint8_t enabled)
{
    if (!phone_notifications_initialized)
    {
        phone_notifications_do_not_disturb = enabled ? 1U : 0U;
        return;
    }

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    phone_notifications_do_not_disturb = enabled ? 1U : 0U;
    if (phone_notifications_do_not_disturb)
        phone_notifications_pending_preview_id = 0U;
    rt_mutex_release(&phone_notifications_lock);
}

uint8_t phone_notifications_is_do_not_disturb(void)
{
    uint8_t enabled;

    if (!phone_notifications_initialized)
        return phone_notifications_do_not_disturb;
    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    enabled = phone_notifications_do_not_disturb;
    rt_mutex_release(&phone_notifications_lock);
    return enabled;
}

rt_err_t phone_notifications_upsert(uint16_t id, uint8_t app,
                                    uint8_t hour, uint8_t minute,
                                    const uint8_t *title, uint16_t title_len,
                                    const uint8_t *body, uint16_t body_len)
{
    uint8_t index;
    uint8_t should_vibrate = 0U;
    uint8_t should_alert = 0U;
    phone_notification_t *item = RT_NULL;

    if (!phone_notifications_initialized || id == 0U ||
        !phone_notifications_app_is_valid(app) ||
        hour > 23U || minute > 59U ||
        title_len > PHONE_NOTIFICATION_TITLE_MAX_BYTES ||
        body_len > PHONE_NOTIFICATION_BODY_MAX_BYTES ||
        (title == RT_NULL && title_len != 0U) ||
        (body == RT_NULL && body_len != 0U))
        return -RT_EINVAL;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < phone_notifications.count; index++)
    {
        if (phone_notifications.items[index].valid &&
            phone_notifications.items[index].id == id)
        {
            item = &phone_notifications.items[index];
            break;
        }
    }

    if (item != RT_NULL &&
        phone_notifications_content_matches(item, app, title, title_len,
                                            body, body_len))
    {
        rt_mutex_release(&phone_notifications_lock);
        return RT_EOK;
    }

    should_vibrate = 1U;
    if (item == RT_NULL)
    {
        if (phone_notifications.count < PHONE_NOTIFICATION_MAX_ITEMS)
        {
            item = &phone_notifications.items[phone_notifications.count++];
        }
        else
        {
            memmove(&phone_notifications.items[0], &phone_notifications.items[1],
                    sizeof(phone_notifications.items[0]) *
                    (PHONE_NOTIFICATION_MAX_ITEMS - 1U));
            item = &phone_notifications.items[PHONE_NOTIFICATION_MAX_ITEMS - 1U];
        }
    }
    else
    {
        /* Android moves an updated notification to the newest position. */
        if (index + 1U < phone_notifications.count)
        {
            memmove(&phone_notifications.items[index],
                    &phone_notifications.items[index + 1U],
                    sizeof(phone_notifications.items[0]) *
                    (phone_notifications.count - index - 1U));
        }
        item = &phone_notifications.items[phone_notifications.count - 1U];
    }

    rt_memset(item, 0, sizeof(*item));
    item->id = id;
    item->app = app;
    item->hour = hour;
    item->minute = minute;
    item->title_len = title_len;
    item->body_len = body_len;
    item->valid = 1U;
    item->unread = 1U;
    if (title_len > 0U)
        rt_memcpy(item->title, title, title_len);
    if (body_len > 0U)
        rt_memcpy(item->body, body, body_len);
    item->title[title_len] = '\0';
    item->body[body_len] = '\0';
    should_alert = should_vibrate && !phone_notifications_do_not_disturb;
    if (should_alert)
        phone_notifications_pending_preview_id = id;
    phone_notifications.revision++;
    rt_mutex_release(&phone_notifications_lock);

    if (should_alert)
    {
        (void)vibrator_vibrate(NOTIFICATION_VIBRATION_LEVEL,
                               NOTIFICATION_VIBRATION_MS);
    }
    return RT_EOK;
}

rt_err_t phone_notifications_remove(uint16_t id)
{
    uint8_t index;

    if (!phone_notifications_initialized || id == 0U)
        return -RT_EINVAL;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < phone_notifications.count; index++)
    {
        if (!phone_notifications.items[index].valid ||
            phone_notifications.items[index].id != id)
            continue;

        if (index + 1U < phone_notifications.count)
        {
            memmove(&phone_notifications.items[index],
                    &phone_notifications.items[index + 1U],
                    sizeof(phone_notifications.items[0]) *
                    (phone_notifications.count - index - 1U));
        }
        phone_notifications.count--;
        rt_memset(&phone_notifications.items[phone_notifications.count], 0,
                  sizeof(phone_notifications.items[0]));
        if (phone_notifications_pending_preview_id == id)
            phone_notifications_pending_preview_id = 0U;
        phone_notifications.revision++;
        rt_mutex_release(&phone_notifications_lock);
        return RT_EOK;
    }

    rt_mutex_release(&phone_notifications_lock);
    return -RT_ERROR;
}

void phone_notifications_clear(void)
{
    if (!phone_notifications_initialized)
        return;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    if (phone_notifications.count > 0U)
    {
        rt_memset(phone_notifications.items, 0,
                  sizeof(phone_notifications.items));
        phone_notifications.count = 0U;
        phone_notifications_pending_preview_id = 0U;
        phone_notifications.revision++;
    }
    rt_mutex_release(&phone_notifications_lock);
}

uint32_t phone_notifications_get_revision(void)
{
    uint32_t revision;

    if (!phone_notifications_initialized)
        return 0U;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    revision = phone_notifications.revision;
    rt_mutex_release(&phone_notifications_lock);
    return revision;
}

uint8_t phone_notifications_get_count(void)
{
    uint8_t count;

    if (!phone_notifications_initialized)
        return 0U;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    count = phone_notifications.count;
    rt_mutex_release(&phone_notifications_lock);
    return count;
}

uint8_t phone_notifications_get_unread_count(void)
{
    uint8_t index;
    uint8_t count = 0U;

    if (!phone_notifications_initialized)
        return 0U;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < phone_notifications.count; index++)
    {
        if (phone_notifications.items[index].valid &&
            phone_notifications.items[index].unread)
        {
            count++;
        }
    }
    rt_mutex_release(&phone_notifications_lock);
    return count;
}

rt_err_t phone_notifications_mark_read(uint16_t id)
{
    uint8_t index;

    if (!phone_notifications_initialized || id == 0U)
        return -RT_EINVAL;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < phone_notifications.count; index++)
    {
        phone_notification_t *item = &phone_notifications.items[index];

        if (!item->valid || item->id != id)
            continue;

        if (item->unread)
        {
            item->unread = 0U;
            phone_notifications.revision++;
        }
        if (phone_notifications_pending_preview_id == id)
            phone_notifications_pending_preview_id = 0U;
        rt_mutex_release(&phone_notifications_lock);
        return RT_EOK;
    }

    rt_mutex_release(&phone_notifications_lock);
    return -RT_ERROR;
}

uint8_t phone_notifications_take_pending_preview(uint16_t *id)
{
    if (!phone_notifications_initialized || id == RT_NULL)
        return 0U;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    *id = phone_notifications_pending_preview_id;
    phone_notifications_pending_preview_id = 0U;
    rt_mutex_release(&phone_notifications_lock);
    return *id != 0U ? 1U : 0U;
}

rt_err_t phone_notifications_get(uint16_t id, phone_notification_t *item)
{
    uint8_t index;

    if (!phone_notifications_initialized || id == 0U || item == RT_NULL)
        return -RT_EINVAL;

    rt_memset(item, 0, sizeof(*item));
    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    for (index = 0U; index < phone_notifications.count; index++)
    {
        if (!phone_notifications.items[index].valid ||
            phone_notifications.items[index].id != id)
            continue;

        *item = phone_notifications.items[index];
        rt_mutex_release(&phone_notifications_lock);
        return RT_EOK;
    }

    rt_mutex_release(&phone_notifications_lock);
    return -RT_ERROR;
}

void phone_notifications_get_snapshot(phone_notification_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;

    rt_memset(snapshot, 0, sizeof(*snapshot));
    if (!phone_notifications_initialized)
        return;

    rt_mutex_take(&phone_notifications_lock, RT_WAITING_FOREVER);
    *snapshot = phone_notifications;
    rt_mutex_release(&phone_notifications_lock);
}
