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
#include "services/water_reminder_service.h"
#include "services/tomato_service.h"
#include "ui/generated/ui.h"
#include "services/alarm_service.h"
#include "services/rtc.h"
#include "services/phone_sync.h"
#include "services/phone_notifications.h"
#include "drivers/rgb.h"
#include "drivers/adc.h"
#include "services/battery_ui.h"
#include "drivers/display_power.h"
#include "services/input_wake.h"
#include "services/power_manager.h"
#include "services/watch_key_router.h"
#include "services/wrist_wake.h"
#include "services/compass_service.h"
#include "services/watch_settings.h"
#include "services/internal_storage.h"
#include "services/local_audio_arbiter.h"
#include "services/tf_card.h"
#include "bluetooth/music_app.h"

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
    (void)internal_storage_init();
    local_audio_arbiter_init();
    tf_card_init();
    rtc_config();
    set_date_time();
    phone_sync_init();
    phone_notifications_init();
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
    alarm_service_init();
    water_reminder_service_init();
    tomato_service_init();
    input_wake_init();
    watch_key_router_init();
    wrist_wake_init();
    watch_settings_init();
    compass_service_init();
    bt_pan_app_init();

    while (1)
    {
        ms = lv_timer_handler();
        rt_thread_mdelay(ms);
    }

    return 0;
}
