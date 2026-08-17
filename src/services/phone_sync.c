/* Phone-provided data cache for the HSP companion BLE service. */

#include "rtthread.h"

#include "phone_sync.h"
#include "rtc.h"

#define PHONE_SYNC_MIN_TIMEZONE_OFFSET_MINUTES (-720)
#define PHONE_SYNC_MAX_TIMEZONE_OFFSET_MINUTES (840)
#define PHONE_SYNC_MAX_LATITUDE_E7             (900000000L)
#define PHONE_SYNC_MAX_LONGITUDE_E7            (1800000000L)
#define PHONE_SYNC_MAX_HUMIDITY_PERCENT        (100U)

static struct rt_mutex phone_sync_lock;
static uint8_t phone_sync_initialized;
static phone_location_t phone_location;
static phone_weather_t phone_weather;

void phone_sync_init(void)
{
    if (phone_sync_initialized)
        return;

    if (rt_mutex_init(&phone_sync_lock, "phone_sync", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    rt_memset(&phone_location, 0, sizeof(phone_location));
    rt_memset(&phone_weather, 0, sizeof(phone_weather));
    phone_sync_initialized = 1U;
}

rt_err_t phone_sync_set_time(uint32_t utc_timestamp,
                             int16_t timezone_offset_minutes)
{
    if (timezone_offset_minutes < PHONE_SYNC_MIN_TIMEZONE_OFFSET_MINUTES ||
        timezone_offset_minutes > PHONE_SYNC_MAX_TIMEZONE_OFFSET_MINUTES)
        return -RT_EINVAL;

    return set_rtc_time_by_timestamp_with_offset((time_t)utc_timestamp,
                                                  timezone_offset_minutes);
}

rt_err_t phone_sync_set_location(int32_t latitude_e7, int32_t longitude_e7,
                                 uint16_t accuracy_meters,
                                 uint32_t updated_utc)
{
    if (!phone_sync_initialized || latitude_e7 < -PHONE_SYNC_MAX_LATITUDE_E7 ||
        latitude_e7 > PHONE_SYNC_MAX_LATITUDE_E7 ||
        longitude_e7 < -PHONE_SYNC_MAX_LONGITUDE_E7 ||
        longitude_e7 > PHONE_SYNC_MAX_LONGITUDE_E7)
        return -RT_EINVAL;

    rt_mutex_take(&phone_sync_lock, RT_WAITING_FOREVER);
    phone_location.latitude_e7 = latitude_e7;
    phone_location.longitude_e7 = longitude_e7;
    phone_location.accuracy_meters = accuracy_meters;
    phone_location.updated_utc = updated_utc;
    /* City and weather belong to these coordinates; never mix old snapshots. */
    rt_memset(phone_location.city, 0, sizeof(phone_location.city));
    phone_location.city_valid = 0U;
    phone_location.valid = 1U;
    rt_memset(&phone_weather, 0, sizeof(phone_weather));
    rt_mutex_release(&phone_sync_lock);
    return RT_EOK;
}

rt_err_t phone_sync_set_city(const uint8_t *city, uint8_t length)
{
    uint8_t read_index;
    uint8_t write_index = 0U;

    if (!phone_sync_initialized || (city == RT_NULL && length != 0U) ||
        length > PHONE_SYNC_CITY_MAX_BYTES)
        return -RT_EINVAL;

    rt_mutex_take(&phone_sync_lock, RT_WAITING_FOREVER);
    rt_memset(phone_location.city, 0, sizeof(phone_location.city));

    /* The current UI uses Montserrat; retain displayable ASCII from the App. */
    for (read_index = 0U; read_index < length; read_index++)
    {
        uint8_t character = city[read_index];

        if (character < 0x20U || character > 0x7EU)
            continue;
        if (character == ' ' &&
            (write_index == 0U || phone_location.city[write_index - 1U] == ' '))
            continue;

        phone_location.city[write_index++] = (char)character;
    }

    while (write_index > 0U && phone_location.city[write_index - 1U] == ' ')
        phone_location.city[--write_index] = '\0';

    phone_location.city_valid = write_index > 0U ? 1U : 0U;
    rt_mutex_release(&phone_sync_lock);
    return RT_EOK;
}

rt_err_t phone_sync_set_weather(uint8_t wmo_code, int16_t current_deci_c,
                                int16_t high_deci_c, int16_t low_deci_c,
                                uint8_t humidity_percent,
                                uint32_t updated_utc)
{
    if (!phone_sync_initialized || humidity_percent > PHONE_SYNC_MAX_HUMIDITY_PERCENT)
        return -RT_EINVAL;

    rt_mutex_take(&phone_sync_lock, RT_WAITING_FOREVER);
    phone_weather.wmo_code = wmo_code;
    phone_weather.current_deci_c = current_deci_c;
    phone_weather.high_deci_c = high_deci_c;
    phone_weather.low_deci_c = low_deci_c;
    phone_weather.humidity_percent = humidity_percent;
    phone_weather.updated_utc = updated_utc;
    phone_weather.valid = 1U;
    rt_mutex_release(&phone_sync_lock);
    return RT_EOK;
}

void phone_sync_get_location(phone_location_t *location)
{
    if (location == RT_NULL)
        return;

    rt_memset(location, 0, sizeof(*location));
    if (!phone_sync_initialized)
        return;

    rt_mutex_take(&phone_sync_lock, RT_WAITING_FOREVER);
    *location = phone_location;
    rt_mutex_release(&phone_sync_lock);
}

void phone_sync_get_weather(phone_weather_t *weather)
{
    if (weather == RT_NULL)
        return;

    rt_memset(weather, 0, sizeof(*weather));
    if (!phone_sync_initialized)
        return;

    rt_mutex_take(&phone_sync_lock, RT_WAITING_FOREVER);
    *weather = phone_weather;
    rt_mutex_release(&phone_sync_lock);
}
