/*
 * SPDX-FileCopyrightText: 2019-2022 SiFli Technologies(Nanjing) Co., Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "lvgl.h"
#include "littlevgl2rtt.h"
#include "lv_ex_data.h"
#include "ui/generated/ui.h"
#include "services/rtc.h"
#include "services/phone_sync.h"
#include "drivers/rgb.h"
#include "drivers/adc.h"
#include "services/battery_ui.h"
#include "drivers/display_power.h"
#include "services/input_wake.h"
#include "services/power_manager.h"
#include "services/wrist_wake.h"
#include "bluetooth/music_app.h"

#if defined(RT_USING_DFS) && defined(FS_REGION_START_ADDR) && \
    defined(FS_REGION_SIZE)
#include "dfs_file.h"
#include "dfs_posix.h"
#include "drv_flash.h"

#define MUSIC_FS_DEVICE_NAME "musicfs"

/* Cover Art packets must be saved before LVGL can decode them. */
static int music_fs_mount_init(void)
{
    register_mtd_device(FS_REGION_START_ADDR, FS_REGION_SIZE,
                        MUSIC_FS_DEVICE_NAME);

    if (dfs_mount(MUSIC_FS_DEVICE_NAME, "/", "elm", 0, 0) != RT_EOK)
    {
        rt_kprintf("music: filesystem is not mounted; cover art cannot be saved\n");
        return RT_ERROR;
    }

    rt_kprintf("music: filesystem mounted\n");
    return RT_EOK;
}
INIT_ENV_EXPORT(music_fs_mount_init);
#endif

extern void bt_pan_app_init(void);

void HAL_MspInit(void)
{
    BSP_IO_Init();
}

int main(void)
{
    rt_err_t ret;
    rt_uint32_t ms;

    power_manager_boot_gate();
    power_manager_startup_feedback();
    rtc_config();
    set_date_time();
    phone_sync_init();
    rgb_led_config();
    rgb_led_set_color(0x000000);

    ret = littlevgl2rtt_init("lcd");
    if (ret != RT_EOK)
        return ret;

    lv_ex_data_pool_init();
    music_app_init();
    ui_init();
    init_time_update_timer();
    update_ui_time();
    adc_init();
    battery_ui_init();
    display_power_init();
    input_wake_init();
    wrist_wake_init();
    bt_pan_app_init();

    while (1)
    {
        ms = lv_timer_handler();
        rt_thread_mdelay(ms);
    }

    return 0;
}
