#include "calendar_lunar.h"

#include <stdio.h>
#include <string.h>

#define LUNAR_FIRST_YEAR       1999U
#define LUNAR_LAST_YEAR        2099U
#define LUNAR_SOLAR_BASE_DAYS  35L

/* Encodes month lengths and leap months for lunar years 1999 through 2099. */
static const uint32_t calendar_lunar_year_info[] =
{
    0x092e0,
    0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552,
    0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
    0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9,
    0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
    0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60,
    0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
    0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0,
    0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
    0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577,
    0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,
    0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0,
    0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0,
    0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0,
    0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,
    0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6,
    0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,
    0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50,
    0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,
    0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0,
    0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252,
};

static uint32_t calendar_lunar_info(uint16_t year)
{
    if (year < LUNAR_FIRST_YEAR || year > LUNAR_LAST_YEAR)
        return 0U;
    return calendar_lunar_year_info[year - LUNAR_FIRST_YEAR];
}

static uint8_t calendar_lunar_leap_month(uint16_t year)
{
    return (uint8_t)(calendar_lunar_info(year) & 0x0FU);
}

static uint8_t calendar_lunar_leap_days(uint16_t year)
{
    uint32_t info = calendar_lunar_info(year);

    if ((info & 0x0FU) == 0U)
        return 0U;
    return (info & 0x10000U) != 0U ? 30U : 29U;
}

static uint8_t calendar_lunar_month_days(uint16_t year, uint8_t month)
{
    if (month < 1U || month > 12U)
        return 29U;
    return (calendar_lunar_info(year) & (0x10000U >> month)) != 0U ?
           30U : 29U;
}

static uint16_t calendar_lunar_year_days(uint16_t year)
{
    uint32_t info = calendar_lunar_info(year);
    uint16_t total = 348U;
    uint32_t mask;

    for (mask = 0x8000U; mask > 0x0008U; mask >>= 1U)
    {
        if ((info & mask) != 0U)
            total++;
    }
    return (uint16_t)(total + calendar_lunar_leap_days(year));
}

static uint8_t calendar_solar_is_leap(uint16_t year)
{
    return (uint8_t)(((year % 4U) == 0U && (year % 100U) != 0U) ||
                     (year % 400U) == 0U);
}

static uint8_t calendar_solar_month_days(uint16_t year, uint8_t month)
{
    static const uint8_t days[] =
        {31U, 28U, 31U, 30U, 31U, 30U,
         31U, 31U, 30U, 31U, 30U, 31U};

    if (month < 1U || month > 12U)
        return 0U;
    if (month == 2U && calendar_solar_is_leap(year))
        return 29U;
    return days[month - 1U];
}

static int32_t calendar_solar_days_from_2000(uint16_t year, uint8_t month,
                                             uint8_t day)
{
    int32_t total = 0;
    uint16_t current_year;
    uint8_t current_month;

    for (current_year = 2000U; current_year < year; current_year++)
        total += calendar_solar_is_leap(current_year) ? 366L : 365L;
    for (current_month = 1U; current_month < month; current_month++)
        total += calendar_solar_month_days(year, current_month);
    return total + day - 1L;
}

static uint8_t calendar_lunar_decode(uint16_t year, int32_t day_offset,
                                     calendar_lunar_date_t *lunar)
{
    uint8_t month = 1U;
    uint8_t leap_month = calendar_lunar_leap_month(year);
    uint8_t is_leap = 0U;
    uint8_t month_days;

    while (month <= 12U)
    {
        month_days = is_leap ? calendar_lunar_leap_days(year) :
                               calendar_lunar_month_days(year, month);
        if (day_offset < month_days)
            break;
        day_offset -= month_days;
        if (leap_month != 0U && month == leap_month && !is_leap)
            is_leap = 1U;
        else
        {
            is_leap = 0U;
            month++;
        }
    }
    if (month > 12U || day_offset < 0)
        return 0U;

    lunar->year = year;
    lunar->month = month;
    lunar->day = (uint8_t)(day_offset + 1L);
    lunar->is_leap_month = is_leap;
    return 1U;
}

uint8_t calendar_lunar_from_solar(uint16_t year, uint8_t month, uint8_t day,
                                  calendar_lunar_date_t *lunar)
{
    int32_t offset;
    uint16_t lunar_year;
    uint16_t year_days;

    if (lunar == NULL || year < 2000U || year > 2099U ||
        month < 1U || month > 12U || day < 1U ||
        day > calendar_solar_month_days(year, month))
        return 0U;

    offset = calendar_solar_days_from_2000(year, month, day) -
             LUNAR_SOLAR_BASE_DAYS;
    if (offset < 0)
    {
        lunar_year = 1999U;
        offset += calendar_lunar_year_days(lunar_year);
        return calendar_lunar_decode(lunar_year, offset, lunar);
    }

    lunar_year = 2000U;
    while (lunar_year < LUNAR_LAST_YEAR)
    {
        year_days = calendar_lunar_year_days(lunar_year);
        if (offset < year_days)
            break;
        offset -= year_days;
        lunar_year++;
    }
    return calendar_lunar_decode(lunar_year, offset, lunar);
}

void calendar_lunar_format_year(const calendar_lunar_date_t *lunar,
                                char *text, size_t size)
{
    static const char *stems[] =
        {"甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"};
    static const char *branches[] =
        {"子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"};
    static const char *zodiac[] =
        {"鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"};
    uint16_t offset;

    if (text == NULL || size == 0U)
        return;
    if (lunar == NULL)
    {
        text[0] = '\0';
        return;
    }
    offset = (uint16_t)(lunar->year - 4U);
    (void)snprintf(text, size, "%s%s年 · %s",
                   stems[offset % 10U], branches[offset % 12U],
                   zodiac[offset % 12U]);
}

void calendar_lunar_format_date(const calendar_lunar_date_t *lunar,
                                char *text, size_t size)
{
    static const char *months[] =
        {"正月", "二月", "三月", "四月", "五月", "六月",
         "七月", "八月", "九月", "十月", "冬月", "腊月"};
    static const char *days[] =
        {"初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
         "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
         "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"};

    if (text == NULL || size == 0U)
        return;
    if (lunar == NULL || lunar->month < 1U || lunar->month > 12U ||
        lunar->day < 1U || lunar->day > 30U)
    {
        text[0] = '\0';
        return;
    }
    (void)snprintf(text, size, "%s%s%s",
                   lunar->is_leap_month ? "闰" : "",
                   months[lunar->month - 1U], days[lunar->day - 1U]);
}

static const char *calendar_solar_festival(uint8_t month, uint8_t day)
{
    if (month == 1U && day == 1U) return "元旦";
    if (month == 2U && day == 14U) return "情人节";
    if (month == 3U && day == 8U) return "妇女节";
    if (month == 3U && day == 12U) return "植树节";
    if (month == 5U && day == 1U) return "劳动节";
    if (month == 5U && day == 4U) return "青年节";
    if (month == 6U && day == 1U) return "儿童节";
    if (month == 7U && day == 1U) return "建党节";
    if (month == 8U && day == 1U) return "建军节";
    if (month == 9U && day == 10U) return "教师节";
    if (month == 10U && day == 1U) return "国庆节";
    if (month == 12U && day == 25U) return "圣诞节";
    return NULL;
}

static const char *calendar_lunar_festival(const calendar_lunar_date_t *lunar)
{
    if (lunar == NULL || lunar->is_leap_month)
        return NULL;
    if (lunar->month == 1U && lunar->day == 1U) return "春节";
    if (lunar->month == 1U && lunar->day == 15U) return "元宵节";
    if (lunar->month == 2U && lunar->day == 2U) return "龙抬头";
    if (lunar->month == 5U && lunar->day == 5U) return "端午节";
    if (lunar->month == 7U && lunar->day == 7U) return "七夕节";
    if (lunar->month == 8U && lunar->day == 15U) return "中秋节";
    if (lunar->month == 9U && lunar->day == 9U) return "重阳节";
    if (lunar->month == 12U && lunar->day == 8U) return "腊八节";
    if (lunar->month == 12U && lunar->day == 23U) return "小年";
    if (lunar->month == 12U &&
        lunar->day == calendar_lunar_month_days(lunar->year, 12U))
        return "除夕";
    return NULL;
}

void calendar_lunar_format_festival(uint16_t solar_year,
                                    uint8_t solar_month,
                                    uint8_t solar_day,
                                    const calendar_lunar_date_t *lunar,
                                    char *text, size_t size)
{
    const char *solar;
    const char *traditional;

    (void)solar_year;
    if (text == NULL || size == 0U)
        return;
    text[0] = '\0';
    solar = calendar_solar_festival(solar_month, solar_day);
    traditional = calendar_lunar_festival(lunar);
    if (traditional != NULL && solar != NULL)
        (void)snprintf(text, size, "%s · %s", traditional, solar);
    else if (traditional != NULL)
        (void)snprintf(text, size, "%s", traditional);
    else if (solar != NULL)
        (void)snprintf(text, size, "%s", solar);
}
