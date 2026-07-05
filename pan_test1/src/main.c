/*
 * SPDX-FileCopyrightText: 2024-2025 SiFli Technologies(Nanjing) Co., Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"

/* Common functions for RT-Thread based platform -----------------------------------------------*/
/**
  * @brief  Initialize board default configuration.
  * @param  None
  * @retval None
  */
void HAL_MspInit(void)
{
    BSP_IO_Init();
}

/* ------------------ 外部驱动与服务函数声明 ------------------ */
extern void rtc_config(void);
extern void set_date_time(void);
extern void get_date_time(void);
extern void bt_pan_app_init(void);  // 声明 pan.c 暴露出来的蓝牙初始化接口
/* -------------------------------------------------------- */

#if defined(BSP_USING_SPI_NAND) && defined(RT_USING_DFS)
#include "dfs_file.h"
#include "dfs_posix.h"
#include "drv_flash.h"
#define NAND_MTD_NAME    "root"
int mnt_init(void)
{
    register_nand_device(FS_REGION_START_ADDR & (0xFC000000), FS_REGION_START_ADDR - (FS_REGION_START_ADDR & (0xFC000000)), FS_REGION_SIZE, NAND_MTD_NAME);
    if (dfs_mount(NAND_MTD_NAME, "/", "elm", 0, 0) == 0)
    {
        rt_kprintf("mount fs on flash to root success\n");
    }
    else
    {
        rt_kprintf("mount fs on flash to root fail\n");
        if (dfs_mkfs("elm", NAND_MTD_NAME) == 0)
        {
            rt_kprintf("make elm fs on flash sucess, mount again\n");
            if (dfs_mount(NAND_MTD_NAME, "/", "elm", 0, 0) == 0)
                rt_kprintf("mount fs on flash success\n");
            else
                rt_kprintf("mount to fs on flash fail\n");
        }
        else
            rt_kprintf("dfs_mkfs elm flash fail\n");
    }
    return RT_EOK;
}
INIT_ENV_EXPORT(mnt_init);
#endif

/* 专门用于每秒打印时间的独立线程 */
static void rtc_display_thread_entry(void *parameter)
{
    while (1)
    {
        /* 获取并打印硬件实时时间 */
        get_date_time();
        
        /* 挂起当前线程 1 秒，不占用 CPU 资源 */
        rt_thread_mdelay(1000);
    }
}

/**
  * @brief  Main program
  * @param  None
  * @retval 0 if success, otherwise failure number
  */
int main(void)
{
    // 1. 初始化并配置硬件 RTC
    rtc_config();
    set_date_time(); // 设置默认初始时间

    // 2. 调用外部接口，初始化蓝牙 PAN 组网后台任务
    bt_pan_app_init();

    // 3. 创建并启动独立的时间显示线程
    rt_thread_t rtc_tid = rt_thread_create("rtc_display",
                                           rtc_display_thread_entry,
                                           RT_NULL,
                                           1024,  // 任务栈大小
                                           20,    // 优先级
                                           10);   // 时间片
    if (rtc_tid != RT_NULL)
    {
        rt_thread_startup(rtc_tid);
    }

    // 4. 主线程退化为轻量级监控，释放绝大部分 CPU 时间
    while (1)
    {
        rt_thread_mdelay(5000); // 降低主循环活跃度以省电
    }
    return 0;
}