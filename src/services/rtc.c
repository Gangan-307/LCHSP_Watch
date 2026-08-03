#include "rtconfig.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"
#include "time.h"
#include "rtthread.h"
#include "lvgl.h"
#include "rtc.h"
#include "ui/generated/ui.h"

extern RTC_HandleTypeDef RTC_Handler;

// LVGL定时器句柄
static lv_timer_t *lv_update_timer = NULL;

// 互斥量句柄（用于保护UI操作）
static struct rt_mutex ui_mutex;

/**
  * @brief  更新LVGL屏幕上的时间和日期显示
  * @param  none
  * @retval none
  */
void update_ui_time(void)
{
    RTC_TimeTypeDef RTC_TimeStruct = {0};
    RTC_DateTypeDef RTC_DateStruct = {0};
    char time_str[16] = {0};
    char date_str[32] = {0};
    const char *week_days[] = {"Sunday", "Monday", "Tuesday", "Wednesday", 
                                "Thursday", "Friday", "Saturday"};
    const char *months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    
    // 1. 获取RTC时间
    HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
    while (HAL_RTC_GetDate(&RTC_Handler, &RTC_DateStruct, RTC_FORMAT_BIN) == HAL_ERROR)
    {
        HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
    }
    
    // 2. 格式化时间字符串 "HH:MM:SS"
    snprintf(time_str, sizeof(time_str), "%02d:%02d:%02d", 
             RTC_TimeStruct.Hours, RTC_TimeStruct.Minutes, RTC_TimeStruct.Seconds);
    
    // 3. 格式化日期字符串 "Friday, Oct 25" (不显示年份)
    if (RTC_DateStruct.Month >= 1 && RTC_DateStruct.Month <= 12) {
        snprintf(date_str, sizeof(date_str), "%s, %s %d",
                 week_days[RTC_DateStruct.WeekDay % 7],
                 months[RTC_DateStruct.Month - 1],
                 RTC_DateStruct.Date);
    }
    
    // 4. 使用互斥量保护UI操作
    rt_mutex_take(&ui_mutex, RT_WAITING_FOREVER);
    
    if (ui_LabelTime != NULL) {
        lv_label_set_text(ui_LabelTime, time_str);
    }
    if (ui_LabelDate != NULL) {
        lv_label_set_text(ui_LabelDate, date_str);
    }
    
    rt_mutex_release(&ui_mutex);
}

/**
 * @brief LVGL定时器回调函数（在LVGL上下文中执行）
 */
static void lv_update_timer_callback(lv_timer_t *timer)
{
    // LVGL定时器回调在LVGL上下文中执行，可以直接操作UI
    // 但为了安全，还是使用互斥量保护
    update_ui_time();
}

/**
 * @brief 初始化互斥量和时间更新定时器
 */
void init_time_update_timer(void)
{
    // 1. 初始化互斥量
    rt_mutex_init(&ui_mutex, "ui_mutex", RT_IPC_FLAG_PRIO);
    rt_kprintf("UI mutex initialized!\n");
    
    // 2. 创建LVGL定时器
    if (lv_update_timer == NULL) {
        lv_update_timer = lv_timer_create(lv_update_timer_callback, 1000, NULL);
        if (lv_update_timer != NULL) {
            rt_kprintf("LVGL time update timer created successfully!\n");
        } else {
            rt_kprintf("Failed to create LVGL time update timer!\n");
        }
    }
}

/**
 * @brief 停止时间更新
 */
void stop_time_update(void)
{
    if (lv_update_timer != NULL) {
        lv_timer_del(lv_update_timer);
        lv_update_timer = NULL;
        rt_kprintf("LVGL time update timer stopped!\n");
    }
}

/**
 * @brief 恢复时间更新
 */
void resume_time_update(void)
{
    init_time_update_timer();
}


/**
  * @brief  Initialization and configuration RTC drvier instance.
  */
void rtc_config(void)
{
    /* RTC instance. */
    RTC_Handler.Instance = (RTC_TypeDef *) RTC_BASE;

    /* RTC use LXT (32K). Check whether LXT is enabled and ready. */
#ifndef LXT_DISABLE
#ifdef SF32LB52X
    if (HAL_PMU_LXTReady() != HAL_OK)
#else
    if (HAL_RTC_LXT_ENABLED() && HAL_PMU_LXTReady() != HAL_OK)
#endif
    {
        rt_kprintf("RTC use LXT, but LXT is not ready\n");
        HAL_ASSERT(0);
    }

    /* Set default DIVA/B. */
    RTC_Handler.Init.DivAInt = 0x80;
    RTC_Handler.Init.DivAFrac = 0x0;
    RTC_Handler.Init.DivB = 0x100;
    rt_kprintf("RTC use LXT RTC_CR=%08X\n", hwp_rtc->CR);
#else
#error "LXT IS NEEDED."
#endif
    /* hal rtc initialization. */
    /* wakesrc see RTC_INIT_xxx (RTC_INIT_NORMAL/RTC_INIT_SKIP/RTC_INIT_REINIT) in bf0_hal_rtc.h. */
    uint32_t wakesrc = RTC_INIT_NORMAL;
    if (HAL_RTC_Init(&RTC_Handler, wakesrc) != HAL_OK)
    {
        rt_kprintf("RTC Init failed.\n");
        HAL_ASSERT(0);
    }
    rt_kprintf("RTC Init success.\n");
}

/**
  * @brief  This function sets default date and time.
  */
void set_date_time(void)
{
    RTC_TimeTypeDef RTC_TimeStruct = {0};
    RTC_DateTypeDef RTC_DateStruct = {0};
    struct tm p_tm;

    /* Set Time to 8:30:00, Set Date to 2025.01.01 . */
    p_tm.tm_sec  = 0;
    p_tm.tm_min  = 30;
    p_tm.tm_hour = 8;
    p_tm.tm_mday = 1;
    p_tm.tm_mon  = 0;  /* month since january, 0 ~ 11 */
    p_tm.tm_year = (2025 - 1900);  /* year since 1900. */
    p_tm.tm_wday  = 3;
    RTC_TimeStruct.Seconds = p_tm.tm_sec ;
    RTC_TimeStruct.Minutes = p_tm.tm_min ;
    RTC_TimeStruct.Hours   = p_tm.tm_hour;
    RTC_DateStruct.Date    = p_tm.tm_mday;
    RTC_DateStruct.Month   = p_tm.tm_mon + 1 ;
    RTC_DateStruct.Year    = p_tm.tm_year;
    RTC_DateStruct.WeekDay = p_tm.tm_wday == 0 ? RTC_WEEKDAY_SUNDAY : p_tm.tm_wday;

    /* Set time. */
    if (HAL_RTC_SetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN) != HAL_OK)
    {
        rt_kprintf("SET TIME ERR!\n");
        HAL_ASSERT(0);
    }

    /* Set date. */
    if (HAL_RTC_SetDate(&RTC_Handler, &RTC_DateStruct, RTC_FORMAT_BIN) != HAL_OK)
    {
        rt_kprintf("SET DATE ERR!\n");
        HAL_ASSERT(0);
    }

    rt_kprintf("SET RTC TIME : %s", asctime(&p_tm));
}

/**
  * @brief  This function gets current date and time by RTC.
  * @retval none
  */
void get_date_time(void)
{
    RTC_TimeTypeDef RTC_TimeStruct = {0};
    RTC_DateTypeDef RTC_DateStruct = {0};
    struct tm tm_new;

    /* Get time. */
    HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
    /* Get date. */
    while (HAL_RTC_GetDate(&RTC_Handler, &RTC_DateStruct, RTC_FORMAT_BIN) == HAL_ERROR)
    {
        /* Retry if error. */
        HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
    };

    /* Convert to local time. */
    tm_new.tm_sec  = RTC_TimeStruct.Seconds + ((RTC_TimeStruct.SubSeconds > 128) ? 1 : 0);
    tm_new.tm_min  = RTC_TimeStruct.Minutes;
    tm_new.tm_hour = RTC_TimeStruct.Hours;
    tm_new.tm_mday = RTC_DateStruct.Date;
    tm_new.tm_mon  = RTC_DateStruct.Month - 1;
    tm_new.tm_wday  = RTC_DateStruct.WeekDay == RTC_WEEKDAY_SUNDAY ? 0 : RTC_DateStruct.WeekDay;
    if (RTC_DateStruct.Year & RTC_CENTURY_BIT)
        tm_new.tm_year = RTC_DateStruct.Year & (~RTC_CENTURY_BIT);
    else
        tm_new.tm_year = RTC_DateStruct.Year + 100;

    rt_kprintf("GET RTC TIME : %s", asctime(&tm_new));
}

/**
  * @brief  根据传入的 Unix 时间戳同步硬件 RTC（内部自动处理东八区北京时间）
  * @param  stamp UTC 时间戳
  * @retval RT_EOK 成功，RT_ERROR 失败
  */
rt_err_t set_rtc_time_by_timestamp(time_t stamp)
{
    RTC_TimeTypeDef RTC_TimeStruct = {0};
    RTC_DateTypeDef RTC_DateStruct = {0};
    struct tm *p_tm;

    // 1. 转换为北京时间（东八区：+8 小时）
    time_t bj_stamp = stamp + (8 * 3600);
    p_tm = gmtime(&bj_stamp); // 使用 gmtime 解析可避开本地时区配置问题

    if (p_tm == RT_NULL)
    {
        rt_kprintf("Error: Convert timestamp to struct tm failed!\n");
        return -RT_ERROR;
    }

    // 2. 根据 struct tm 结构体填充 Sifli HAL RTC 驱动结构
    RTC_TimeStruct.Seconds = p_tm->tm_sec;
    RTC_TimeStruct.Minutes = p_tm->tm_min;
    RTC_TimeStruct.Hours   = p_tm->tm_hour;

    RTC_DateStruct.Date    = p_tm->tm_mday;
    RTC_DateStruct.Month   = p_tm->tm_mon + 1; // tm_mon 范围是 0~11，而 HAL 层的 Month 范围是 1~12
    RTC_DateStruct.Year    = p_tm->tm_year;    // Sifli RTC 年份直接接受 1900年起的偏移值
    RTC_DateStruct.WeekDay = (p_tm->tm_wday == 0) ? RTC_WEEKDAY_SUNDAY : p_tm->tm_wday;

    // 3. 设置时间
    if (HAL_RTC_SetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN) != HAL_OK)
    {
        rt_kprintf("Error: HAL_RTC_SetTime failed!\n");
        return -RT_ERROR;
    }

    // 4. 设置日期
    if (HAL_RTC_SetDate(&RTC_Handler, &RTC_DateStruct, RTC_FORMAT_BIN) != HAL_OK)
    {
        rt_kprintf("Error: HAL_RTC_SetDate failed!\n");
        return -RT_ERROR;
    }

    rt_kprintf("Successfully synchronized network time to Hardware RTC!\n");
    rt_kprintf("RTC Sync Time: %s", asctime(p_tm));

    return RT_EOK;
}
