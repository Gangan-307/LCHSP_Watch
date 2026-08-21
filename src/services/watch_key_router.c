#include "lvgl.h"
#include "bluetooth/music_app.h"
#include "drivers/display_power.h"
#include "drivers/vibrator.h"
#include "services/alarm_service.h"
#include "services/input_wake.h"
#include "ui/alarm/alarm_ui.h"
#include "ui/calculator/calculator_ui.h"
#include "ui/calendar/calendar_ui.h"
#include "ui/camera/camera_ui.h"
#include "ui/compass/compass_ui.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/safe/safe_ui.h"
#include "ui/settings/settings_ui.h"
#include "ui/details/ui_MapDetails.h"
#include "ui/details/ui_WeatherDetails.h"
#include "ui/generated/home_gestures.h"
#include "ui/generated/home_pager.h"
#include "ui/water/water_ui.h"
#include "ui/tomato/tomato_ui.h"
#include "ui/generated/ui.h"
#include "ui/system/system_power_ui.h"
#include "watch_key_router.h"

#define POWER_MENU_VIBRATION_LEVEL  (70U)
#define POWER_MENU_VIBRATION_MS     (70U)

static void watch_key_router_back(void)
{
    lv_obj_t *active_screen = lv_scr_act();

    if (home_gestures_handle_back())
        return;
    if (home_pager_is_active(HOME_PAGER_PAGE_HOME))
        return;
    if (home_pager_is_active(HOME_PAGER_PAGE_APP_GRID))
        ui_AppGrid_return_home();
    else if (active_screen == ui_RgbLight)
        ui_RgbLight_return();
    else if (active_screen == ui_BluetoothSettings)
        ui_BluetoothSettings_return();
    else if (active_screen == ui_WeatherDetails)
        ui_WeatherDetails_return();
    else if (active_screen == ui_MapDetails)
        ui_MapDetails_return();
    else if (active_screen == ui_Calculator)
        ui_Calculator_return();
    else if (active_screen == ui_Calendar)
        ui_Calendar_return();
    else if (active_screen == ui_Muyu)
        ui_Muyu_return();
    else if (active_screen == ui_Water)
        ui_Water_return();
    else if (active_screen == ui_Tomato)
        ui_Tomato_return();
    else if (active_screen == ui_Camera)
        ui_Camera_return();
    else if (active_screen == ui_Compass)
        ui_Compass_return();
    else if (active_screen == ui_Alarm)
        ui_Alarm_return();
    else if (active_screen == ui_Safe)
        ui_Safe_return();
    else if (active_screen == ui_Settings)
        ui_Settings_return();
}

static void watch_key_router_event(input_wake_key_t key,
                                   input_wake_event_t event)
{
    if (alarm_service_is_ringing())
    {
        (void)ui_Alarm_handle_key(key, event);
        return;
    }

    if (system_power_ui_is_open())
    {
        if (key == INPUT_WAKE_KEY1)
        {
            if (event == INPUT_WAKE_EVENT_LONG_PRESS)
                display_power_sleep();
            else
                system_power_ui_close();
        }
        return;
    }

    if (ui_Water_handle_key(key, event))
        return;

    if (ui_Tomato_handle_key(key, event))
        return;

    if (ui_Calendar_handle_key(key, event))
        return;

    if (ui_Camera_handle_key(key, event))
        return;

    if (ui_Compass_handle_key(key, event))
        return;

    if (ui_Alarm_handle_key(key, event))
        return;

    if (event == INPUT_WAKE_EVENT_LONG_PRESS)
    {
        if (key == INPUT_WAKE_KEY1)
            display_power_sleep();
        else if (key == INPUT_WAKE_KEY2)
        {
            system_power_ui_open();
            (void)vibrator_vibrate(POWER_MENU_VIBRATION_LEVEL,
                                   POWER_MENU_VIBRATION_MS);
        }
        return;
    }

    if (home_pager_is_active(HOME_PAGER_PAGE_MUSIC))
    {
        music_app_adjust_volume(key == INPUT_WAKE_KEY1 ? 1 : -1);
        return;
    }

    if (key == INPUT_WAKE_KEY1)
        watch_key_router_back();
}

void watch_key_router_init(void)
{
    input_wake_set_event_handler(watch_key_router_event);
}
