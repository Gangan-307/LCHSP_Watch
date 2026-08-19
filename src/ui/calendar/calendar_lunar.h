#ifndef LCHSPI_CALENDAR_LUNAR_H_INCLUDED
#define LCHSPI_CALENDAR_LUNAR_H_INCLUDED

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    uint16_t year;
    uint8_t month;
    uint8_t day;
    uint8_t is_leap_month;
} calendar_lunar_date_t;

uint8_t calendar_lunar_from_solar(uint16_t year, uint8_t month, uint8_t day,
                                  calendar_lunar_date_t *lunar);
void calendar_lunar_format_year(const calendar_lunar_date_t *lunar,
                                char *text, size_t size);
void calendar_lunar_format_date(const calendar_lunar_date_t *lunar,
                                char *text, size_t size);
void calendar_lunar_format_festival(uint16_t solar_year,
                                    uint8_t solar_month,
                                    uint8_t solar_day,
                                    const calendar_lunar_date_t *lunar,
                                    char *text, size_t size);

#ifdef __cplusplus
}
#endif

#endif
