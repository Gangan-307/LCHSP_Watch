#include "rtthread.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "littlevgl2rtt.h"
//#include "lv_ex_data.h"
//#include "lv_examples.h"
#include "ui.h"

/**
  * @brief  Main program
  * @param  None
  * @retval 0 if success, otherwise failure number
  */
int main(void)
{
    rt_err_t ret = RT_EOK;
    rt_uint32_t ms;

    rt_kprintf("[lvgl][boot] main enter\r\n");
    rt_kprintf("[lvgl][boot] LV_COLOR_DEPTH=%d LV_COLOR_16_SWAP=%d LV_USE_THEME_DEFAULT=%d LV_USE_THEME_BASIC=%d\r\n",
               (int)LV_COLOR_DEPTH, (int)LV_COLOR_16_SWAP, (int)LV_USE_THEME_DEFAULT, (int)LV_USE_THEME_BASIC);
#ifdef BSP_USING_TOUCHD
    rt_kprintf("[lvgl][boot] touch input enabled\r\n");
#else
    rt_kprintf("[lvgl][boot] touch input disabled by temporary workaround\r\n");
#endif

    ret = littlevgl2rtt_init("lcd");
    if (ret != RT_EOK)
    {
        rt_kprintf("[lvgl][init] littlevgl2rtt_init failed=%d\r\n", (int)ret);
        return ret;
    }

    rt_kprintf("[lvgl][init] littlevgl2rtt_init ok disp=%p\r\n", lv_disp_get_default());
    ui_init();
    rt_kprintf("[lvgl][ui] ui_init done, lv_scr_act=%p\r\n", lv_scr_act());

    while (1)
    {
        static rt_uint32_t loop_cnt = 0;
        /* #region debug-point lvgl-main-loop */
        if (loop_cnt < 2)
        {
            rt_kprintf("[lvgl][loop] before cnt=%u act=%p\r\n", (unsigned)loop_cnt, lv_scr_act());
        }
        /* #endregion debug-point lvgl-main-loop */
        ms = lv_task_handler();
        /* #region debug-point lvgl-main-loop */
        if (loop_cnt < 2)
        {
            rt_kprintf("[lvgl][loop] after cnt=%u delay=%u\r\n", (unsigned)loop_cnt, (unsigned)ms);
        }
        loop_cnt++;
        /* #endregion debug-point lvgl-main-loop */
        rt_thread_mdelay(ms);
    }

    return RT_EOK;
}
