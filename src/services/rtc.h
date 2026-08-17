// rtc.h
#ifndef LCHSPI_RTC_H_INCLUDED
#define LCHSPI_RTC_H_INCLUDED

#include "rtthread.h"
#include "time.h"

// 函数声明
void rtc_config(void);
void set_date_time(void);
void get_date_time(void);
void update_ui_time(void);
void init_time_update_timer(void);
void stop_time_update(void);
void resume_time_update(void);
rt_err_t set_rtc_time_by_timestamp(time_t stamp);
rt_err_t set_rtc_time_by_timestamp_with_offset(time_t stamp,
                                                int16_t timezone_offset_minutes);
#endif /* LCHSPI_RTC_H_INCLUDED */
