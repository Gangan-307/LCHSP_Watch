// rtc.h
#ifndef __RTC_H__
#define __RTC_H__

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
#endif /* __RTC_H__ */