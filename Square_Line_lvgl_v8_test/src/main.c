#include "rtthread.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"
#include "lvgl.h"
#include "littlevgl2rtt.h"
#include "lv_ex_data.h"
#include "ui.h"
#include "drivers/rt_drv_pwm.h"
#include "vibrator.h"
#include "rtc.h"  
#include "rgb.h"


// /* ------------------ 外部驱动与服务模块声明 ------------------ */
extern void bt_pan_app_init(void);

// extern void lvgl_time_display_init(lv_obj_t * parent);
/* -------------------------------------------------------- */

void HAL_MspInit(void)
{
    BSP_IO_Init();
}



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
    rt_err_t ret = RT_EOK;
    rt_uint32_t ms;

    // 1. 初始化并配置硬件 RTC
    rtc_config();
    set_date_time();

    // 2. 初始化并开启 RGB LED 驱动
     rgb_led_config();

    /* 
     * 3. 【关键调整：图形与显示优先】
     * 在系统时钟最纯净、内存最完整的时候，优先初始化并拉起 LCD 屏幕和图形核心！
     */
    ret = littlevgl2rtt_init("lcd");
    if (ret != RT_EOK)
    {
        // 加上错误打印，防止静默退出
        rt_kprintf("CRITICAL ERROR: littlevgl2rtt_init failed with %d!\n", ret);
        return ret;
    }
    lv_ex_data_pool_init();
    
    rt_kprintf("SquareLine Studio LVGL Image Example\n");
    
    // 4. 初始化 SquareLine Studio 导出的 UI 页面
    ui_init();

     // 5. 初始化时间更新定时器（会自动更新时间）
    init_time_update_timer();
    
    // 6. 显示当前时间
    update_ui_time();  // 立即更新一次

    // 5. 启动 LVGL 内部的 1 秒软件定时器（自动在 UI 上刷新北京时间）
    // lvgl_time_display_init(lv_scr_act());

    /* 
     * 6. 【关键调整：网络最后启动】
     * 此时 LCD 硬件已经供电并完成初始化，显存也已经成功锁定了内存空间。
     * 这时再拉起后台蓝牙网络维护线程，协议栈怎么修改时钟都不会再影响到已经就绪的屏幕。
     */
    bt_pan_app_init();

    /* Infinite loop */
    while (1)
    {
        ms = lv_timer_handler();
        rt_thread_mdelay(ms); // 使用 RTT 环保挂起，避免 CPU 忙等死锁
    }
    return 0;
}
