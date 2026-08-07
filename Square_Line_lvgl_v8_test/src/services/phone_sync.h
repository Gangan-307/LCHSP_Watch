#ifndef LCHSPI_PHONE_SYNC_H_INCLUDED
#define LCHSPI_PHONE_SYNC_H_INCLUDED

#include <stdint.h>
#include <time.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PHONE_SYNC_CITY_MAX_BYTES 19U

typedef struct
{
    int32_t latitude_e7;
    int32_t longitude_e7;
    uint16_t accuracy_meters;
    uint32_t updated_utc;
    char city[PHONE_SYNC_CITY_MAX_BYTES + 1U];
    uint8_t valid;
    uint8_t city_valid;
} phone_location_t;

typedef struct
{
    uint8_t wmo_code;
    int16_t current_deci_c;
    int16_t high_deci_c;
    int16_t low_deci_c;
    uint8_t humidity_percent;
    uint32_t updated_utc;
    uint8_t valid;
} phone_weather_t;

/* Prepare the small, in-memory cache used by the companion BLE service. */
void phone_sync_init(void);

/* Apply a phone-provided UTC time using its current UTC offset in minutes. */
rt_err_t phone_sync_set_time(uint32_t utc_timestamp,
                             int16_t timezone_offset_minutes);

/* Store the latest phone location and weather snapshot. */
rt_err_t phone_sync_set_location(int32_t latitude_e7, int32_t longitude_e7,
                                 uint16_t accuracy_meters,
                                 uint32_t updated_utc);
rt_err_t phone_sync_set_city(const uint8_t *city, uint8_t length);
rt_err_t phone_sync_set_weather(uint8_t wmo_code, int16_t current_deci_c,
                                int16_t high_deci_c, int16_t low_deci_c,
                                uint8_t humidity_percent,
                                uint32_t updated_utc);

/* Copy the latest snapshot. valid is zero until the App has sent data. */
void phone_sync_get_location(phone_location_t *location);
void phone_sync_get_weather(phone_weather_t *weather);

#ifdef __cplusplus
}
#endif

#endif
