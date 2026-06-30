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


// /* ------------------ 外部驱动与服务模块声明 ------------------ */
extern void rtc_config(void);
extern void set_date_time(void);
extern void get_date_time(void);
extern void bt_pan_app_init(void);

extern void rgb_led_config(void);          // 声明来自 rgb_led.c 的初始化函数
extern void rgb_led_set_color(uint32_t color); // 声明来自 rgb_led.c 的设置颜色函数

extern void lvgl_time_display_init(lv_obj_t * parent);
/* -------------------------------------------------------- */


void on_led_toggle(lv_event_t * e)
{
    static rt_bool_t is_on = RT_FALSE; // 记录开关状态
    lv_obj_t * btn = lv_event_get_target(e);
    lv_obj_t * label = lv_obj_get_child(btn, 0);

    if (is_on == RT_FALSE) 
    {
        // 执行开灯：设置成白色
        rgb_led_set_color(0xffffff); 
        lv_label_set_text(ui_Label3, "LIGHT ON");
         
        is_on = RT_TRUE;
    } 
    else 
    {
        // 执行关灯：设置成黑色
        rgb_led_set_color(0x000000); 
        lv_label_set_text(ui_Label3, "LIGHT OFF");
       
        is_on = RT_FALSE;
    }
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

    // 5. 启动 LVGL 内部的 1 秒软件定时器（自动在 UI 上刷新北京时间）
    lvgl_time_display_init(lv_scr_act());

    /* 
     * 6. 【关键调整：网络最后启动】
     * 此时 LCD 硬件已经供电并完成初始化，显存也已经成功锁定了内存空间。
     * 这时再拉起后台蓝牙网络维护线程，协议栈怎么修改时钟都不会再影响到已经就绪的屏幕。
     */
    bt_pan_app_init();

    /* Infinite loop */
    while (1)
    {
        ms = lv_task_handler();
        rt_thread_mdelay(ms); // 使用 RTT 环保挂起，避免 CPU 忙等死锁
    }
    return 0;
}