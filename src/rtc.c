#include "rtconfig.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"
#include "time.h"
#include "rtthread.h"

/* 
 * 关键修改：将本地定义修改为 extern 声明，
 * 直接复用官方驱动 drv_rtc.c 中已经定义好的全局句柄
 */
extern RTC_HandleTypeDef RTC_Handler;

/* 
 * 关键修改：删除了 RTC_IRQHandler()，因为官方驱动 drv_rtc.c 已经接管了该中断。
 * 关键修改：删除了 drv_rtc_callback()，因为官方驱动 drv_rtc.c 已经实现。
 */

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

/**
  * @brief  读取当前硬件 RTC 并直接填充到 struct tm 结构体中
  * @param  tm_new 目标结构体指针
  */
// void get_rtc_tm(struct tm *tm_new)
// {
//     RTC_TimeTypeDef RTC_TimeStruct = {0};
//     RTC_DateTypeDef RTC_DateStruct = {0};

//     /* 获取时间 */
//     HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
//     /* 获取日期 */
//     while (HAL_RTC_GetDate(&RTC_Handler, &RTC_DateStruct, RTC_FORMAT_BIN) == HAL_ERROR)
//     {
//         /* 错误重试 */
//         HAL_RTC_GetTime(&RTC_Handler, &RTC_TimeStruct, RTC_FORMAT_BIN);
//     };

//     /* 填充 struct tm 结构体 */
//     tm_new->tm_sec  = RTC_TimeStruct.Seconds + ((RTC_TimeStruct.SubSeconds > 128) ? 1 : 0);
//     tm_new->tm_min  = RTC_TimeStruct.Minutes;
//     tm_new->tm_hour = RTC_TimeStruct.Hours;
//     tm_new->tm_mday = RTC_DateStruct.Date;
//     tm_new->tm_mon  = RTC_DateStruct.Month - 1; // 转换为标准 tm_mon (0 ~ 11)
//     tm_new->tm_wday = RTC_DateStruct.WeekDay == RTC_WEEKDAY_SUNDAY ? 0 : RTC_DateStruct.WeekDay; // 标准 tm_wday
    
//     if (RTC_DateStruct.Year & RTC_CENTURY_BIT)
//         tm_new->tm_year = RTC_DateStruct.Year & (~RTC_CENTURY_BIT);
//     else
//         tm_new->tm_year = RTC_DateStruct.Year + 100;
// }