#include "settings_ui.h"

#include <stdint.h>
#include <stdio.h>

#include "bluetooth/find_phone_ble.h"
#include "bluetooth/music_app.h"
#include "drivers/display_power.h"
#include "services/battery_ui.h"
#include "services/ota_service.h"
#include "services/watch_settings.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/system/system_power_ui.h"

#define SETTINGS_BG             0x050608
#define SETTINGS_PANEL          0x090B0F
#define SETTINGS_ROW            0x151A21
#define SETTINGS_ROW_PRESSED    0x232A35
#define SETTINGS_BORDER         0x303A47
#define SETTINGS_TRACK          0x66717E
#define SETTINGS_TEXT           0xF5F7FA
#define SETTINGS_MUTED          0x8E98A6
#define SETTINGS_GOLD           0xF4BE4F
#define SETTINGS_GREEN          0x55D985
#define SETTINGS_ROW_WIDTH      (342)
#define SETTINGS_ROW_HEIGHT     (100)
#define SETTINGS_ROW_RADIUS     (30)
#define SETTINGS_ROW_START_Y    (4)
#define SETTINGS_ROW_STEP       (112)
#define SETTINGS_ROW_Y(index)   \
    ((lv_coord_t)(SETTINGS_ROW_START_Y + (index) * SETTINGS_ROW_STEP))

typedef enum
{
    SETTINGS_PAGE_MAIN,
    SETTINGS_PAGE_BATTERY,
    SETTINGS_PAGE_INFO,
    SETTINGS_PAGE_UPDATE,
} settings_page_t;

typedef enum
{
    SETTINGS_TOGGLE_WRIST,
    SETTINGS_TOGGLE_MUTE,
    SETTINGS_TOGGLE_VIBRATION,
    SETTINGS_TOGGLE_DND,
    SETTINGS_TOGGLE_LOW_POWER,
} settings_toggle_t;

lv_obj_t *ui_Settings = NULL;

static lv_obj_t *settings_panel;
static lv_obj_t *settings_content;
static lv_obj_t *settings_brightness_value;
static lv_obj_t *settings_volume_value;
static lv_obj_t *settings_timeout_value;
static lv_obj_t *settings_battery_percent;
static lv_obj_t *settings_battery_status;
static lv_obj_t *settings_battery_voltage;
static lv_obj_t *settings_battery_bar;
static lv_obj_t *settings_ota_network;
static lv_obj_t *settings_ota_latest;
static lv_obj_t *settings_ota_status;
static lv_obj_t *settings_ota_button;
static lv_obj_t *settings_ota_button_label;
static lv_timer_t *settings_refresh_timer;
static settings_page_t settings_page = SETTINGS_PAGE_MAIN;

static void settings_ui_build(void);

static void settings_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void settings_ui_style_object(lv_obj_t *object, uint32_t color,
                                     lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, radius, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(object, lv_color_hex(color),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(object, opacity,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(object, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void settings_ui_style_card(lv_obj_t *object, lv_coord_t radius)
{
    settings_ui_style_object(object, SETTINGS_ROW, LV_OPA_COVER, radius);
    lv_obj_set_style_bg_color(object, lv_color_hex(SETTINGS_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
}

static lv_obj_t *settings_ui_add_label(lv_obj_t *parent, const char *text,
                                       const lv_font_t *font,
                                       uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_letter_space(label, 0,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);
    return label;
}

static void settings_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED &&
        !ota_service_install_in_progress())
        ui_Settings_return();
}

static void settings_ui_add_header(const char *title)
{
    lv_obj_t *button = lv_btn_create(settings_panel);
    lv_obj_t *label;

    lv_obj_set_pos(button, 22, 12);
    lv_obj_set_size(button, 44, 44);
    settings_ui_style_object(button, SETTINGS_PANEL, LV_OPA_COVER, 22);
    lv_obj_set_style_bg_color(button, lv_color_hex(SETTINGS_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(button, settings_ui_back_event,
                        LV_EVENT_CLICKED, NULL);
    label = settings_ui_add_label(button, LV_SYMBOL_LEFT,
                                  &lv_font_montserrat_20, SETTINGS_GOLD);
    lv_obj_center(label);

    label = settings_ui_add_label(settings_panel, title, &hsp_font_cjk_22,
                                  SETTINGS_TEXT);
    lv_obj_set_pos(label, 76, 19);
}

static lv_obj_t *settings_ui_add_row(lv_coord_t y, lv_event_cb_t callback)
{
    lv_obj_t *row;

    if (callback != NULL)
    {
        row = lv_btn_create(settings_content);
        lv_obj_add_event_cb(row, callback, LV_EVENT_CLICKED, NULL);
        lv_obj_set_style_bg_color(row, lv_color_hex(SETTINGS_ROW_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
    }
    else
    {
        row = lv_obj_create(settings_content);
    }
    lv_obj_set_pos(row, 24, y);
    lv_obj_set_size(row, SETTINGS_ROW_WIDTH, SETTINGS_ROW_HEIGHT);
    settings_ui_style_card(row, SETTINGS_ROW_RADIUS);
    return row;
}

static lv_obj_t *settings_ui_add_switch(lv_obj_t *row, uint8_t checked,
                                        settings_toggle_t toggle)
{
    lv_obj_t *control = lv_switch_create(row);

    lv_obj_set_size(control, 64, 36);
    lv_obj_align(control, LV_ALIGN_RIGHT_MID, -18, 0);
    lv_obj_set_style_bg_color(control, lv_color_hex(SETTINGS_TRACK),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_color(control, lv_color_hex(SETTINGS_GOLD),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(control, lv_color_hex(SETTINGS_TEXT),
                              LV_PART_KNOB);
    lv_obj_set_style_bg_opa(control, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_bg_opa(control, LV_OPA_COVER, LV_PART_INDICATOR);
    lv_obj_set_style_border_width(control, 0, LV_PART_MAIN);
    lv_obj_set_style_border_width(control, 0, LV_PART_INDICATOR);
    lv_obj_set_style_border_width(control, 0, LV_PART_KNOB);
    if (checked)
        lv_obj_add_state(control, LV_STATE_CHECKED);
    lv_obj_set_user_data(control, (void *)(uintptr_t)toggle);
    return control;
}

static void settings_ui_slider_style(lv_obj_t *slider)
{
    lv_obj_set_style_radius(slider, 10, LV_PART_MAIN);
    lv_obj_set_style_bg_color(slider, lv_color_hex(SETTINGS_TRACK),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_opa(slider, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(slider, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(slider, 10, LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(slider, lv_color_hex(SETTINGS_GOLD),
                              LV_PART_INDICATOR);
    lv_obj_set_style_border_width(slider, 0, LV_PART_INDICATOR);
    lv_obj_set_style_radius(slider, LV_RADIUS_CIRCLE, LV_PART_KNOB);
    lv_obj_set_style_bg_color(slider, lv_color_hex(SETTINGS_TEXT),
                              LV_PART_KNOB);
    lv_obj_set_style_border_width(slider, 0, LV_PART_KNOB);
    lv_obj_set_style_pad_all(slider, 9, LV_PART_KNOB);
}

static void settings_ui_brightness_event(lv_event_t *event)
{
    lv_obj_t *slider = lv_event_get_target(event);
    uint8_t value = (uint8_t)lv_slider_get_value(slider);

    if (lv_event_get_code(event) == LV_EVENT_VALUE_CHANGED)
    {
        lv_label_set_text_fmt(settings_brightness_value, "%u%%",
                              (unsigned int)value);
        display_power_set_brightness(value);
    }
    else if (lv_event_get_code(event) == LV_EVENT_RELEASED)
    {
        watch_settings_set_brightness(value);
    }
}

static void settings_ui_volume_event(lv_event_t *event)
{
    lv_obj_t *slider = lv_event_get_target(event);
    uint8_t percent = (uint8_t)lv_slider_get_value(slider);
    uint8_t volume = (uint8_t)(((uint16_t)percent * 127U + 50U) / 100U);

    if (lv_event_get_code(event) == LV_EVENT_VALUE_CHANGED)
    {
        lv_label_set_text_fmt(settings_volume_value, "%u%%",
                              (unsigned int)percent);
        music_app_set_volume(volume);
    }
    else if (lv_event_get_code(event) == LV_EVENT_RELEASED)
    {
        watch_settings_set_volume(volume);
    }
}

static void settings_ui_toggle_event(lv_event_t *event)
{
    lv_obj_t *control = lv_event_get_target(event);
    settings_toggle_t toggle;
    uint8_t enabled;

    if (lv_event_get_code(event) != LV_EVENT_VALUE_CHANGED)
        return;
    toggle = (settings_toggle_t)(uintptr_t)lv_obj_get_user_data(control);
    enabled = lv_obj_has_state(control, LV_STATE_CHECKED) ? 1U : 0U;
    switch (toggle)
    {
    case SETTINGS_TOGGLE_WRIST:
        watch_settings_set_wrist_wake(enabled);
        break;
    case SETTINGS_TOGGLE_MUTE:
        watch_settings_set_muted(enabled);
        break;
    case SETTINGS_TOGGLE_VIBRATION:
        watch_settings_set_vibration(enabled);
        break;
    case SETTINGS_TOGGLE_DND:
        watch_settings_set_do_not_disturb(enabled);
        break;
    case SETTINGS_TOGGLE_LOW_POWER:
        watch_settings_set_low_power(enabled);
        break;
    default:
        break;
    }
}

static void settings_ui_timeout_event(lv_event_t *event)
{
    watch_settings_snapshot_t snapshot;
    uint16_t timeout;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    watch_settings_get_snapshot(&snapshot);
    if (snapshot.screen_timeout_seconds < 30U)
        timeout = 30U;
    else if (snapshot.screen_timeout_seconds < 60U)
        timeout = 60U;
    else if (snapshot.screen_timeout_seconds < 120U)
        timeout = 120U;
    else
        timeout = 15U;
    watch_settings_set_screen_timeout(timeout);
    lv_label_set_text_fmt(settings_timeout_value, "%u 秒",
                          (unsigned int)timeout);
}

static void settings_ui_open_battery_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    settings_ui_wait_release();
    settings_page = SETTINGS_PAGE_BATTERY;
    settings_ui_build();
}

static void settings_ui_open_info_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    settings_ui_wait_release();
    settings_page = SETTINGS_PAGE_INFO;
    settings_ui_build();
}

static void settings_ui_open_update_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    settings_ui_wait_release();
    settings_page = SETTINGS_PAGE_UPDATE;
    settings_ui_build();
}

static void settings_ui_open_power_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        system_power_ui_open();
}

static lv_obj_t *settings_ui_add_toggle_row(lv_coord_t y, const char *title,
                                            uint8_t checked,
                                            settings_toggle_t toggle)
{
    lv_obj_t *row = settings_ui_add_row(y, NULL);
    lv_obj_t *label = settings_ui_add_label(row, title, &hsp_font_cjk_22,
                                            SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    label = settings_ui_add_switch(row, checked, toggle);
    lv_obj_add_event_cb(label, settings_ui_toggle_event,
                        LV_EVENT_VALUE_CHANGED, NULL);
    return row;
}

static void settings_ui_add_navigation_row(lv_coord_t y, const char *title,
                                           const char *value,
                                           lv_event_cb_t callback)
{
    lv_obj_t *row = settings_ui_add_row(y, callback);
    lv_obj_t *label = settings_ui_add_label(row, title, &hsp_font_cjk_22,
                                            SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    label = settings_ui_add_label(row, value, &hsp_font_cjk_22,
                                  SETTINGS_GOLD);
    lv_obj_align(label, LV_ALIGN_RIGHT_MID, -22, 0);
}

static void settings_ui_build_slider_row(lv_coord_t y, const char *title,
                                         uint8_t value, uint8_t volume)
{
    lv_obj_t *row = settings_ui_add_row(y, NULL);
    lv_obj_t *label = settings_ui_add_label(row, title, &hsp_font_cjk_22,
                                            SETTINGS_TEXT);
    lv_obj_t *slider = lv_slider_create(row);

    lv_obj_set_pos(label, 22, 13);
    label = settings_ui_add_label(row, "", &lv_font_montserrat_20,
                                  SETTINGS_GOLD);
    lv_obj_align(label, LV_ALIGN_TOP_RIGHT, -22, 16);
    lv_label_set_text_fmt(label, "%u%%", (unsigned int)value);
    lv_obj_set_pos(slider, 28, 66);
    lv_obj_set_size(slider, 286, 16);
    lv_slider_set_range(slider, volume ? 0 : 10, 100);
    lv_slider_set_value(slider, value, LV_ANIM_OFF);
    settings_ui_slider_style(slider);
    if (volume)
    {
        settings_volume_value = label;
        lv_obj_add_event_cb(slider, settings_ui_volume_event,
                            LV_EVENT_ALL, NULL);
    }
    else
    {
        settings_brightness_value = label;
        lv_obj_add_event_cb(slider, settings_ui_brightness_event,
                            LV_EVENT_ALL, NULL);
    }
}

static void settings_ui_build_main(void)
{
    watch_settings_snapshot_t snapshot;
    music_app_snapshot_t music_snapshot;
    battery_status_t battery;
    char value[24];
    lv_obj_t *row;
    lv_obj_t *label;
    uint8_t volume_percent;

    watch_settings_get_snapshot(&snapshot);
    music_app_get_snapshot(&music_snapshot);
    battery_ui_get_status(&battery);
    settings_ui_add_header("设置");

    settings_content = lv_obj_create(settings_panel);
    lv_obj_set_pos(settings_content, 0, 72);
    lv_obj_set_size(settings_content, 390, 378);
    settings_ui_style_object(settings_content, SETTINGS_PANEL,
                             LV_OPA_TRANSP, 0);
    lv_obj_add_flag(settings_content, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scroll_dir(settings_content, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(settings_content, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_pad_bottom(settings_content, 24, LV_PART_MAIN);

    settings_ui_build_slider_row(SETTINGS_ROW_Y(0), "屏幕亮度",
                                 snapshot.brightness, 0U);

    row = settings_ui_add_row(SETTINGS_ROW_Y(1), settings_ui_timeout_event);
    label = settings_ui_add_label(row, "息屏时间", &hsp_font_cjk_22,
                                  SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    settings_timeout_value = settings_ui_add_label(
        row, "", &hsp_font_cjk_22, SETTINGS_GOLD);
    lv_label_set_text_fmt(settings_timeout_value, "%u 秒",
                          (unsigned int)snapshot.screen_timeout_seconds);
    lv_obj_align(settings_timeout_value, LV_ALIGN_RIGHT_MID, -22, 0);

    settings_ui_add_toggle_row(SETTINGS_ROW_Y(2), "抬腕亮屏",
                               snapshot.wrist_wake_enabled,
                               SETTINGS_TOGGLE_WRIST);
    volume_percent = (uint8_t)(((uint16_t)(music_snapshot.volume_valid ?
                               music_snapshot.volume : snapshot.volume) *
                               100U + 63U) / 127U);
    settings_ui_build_slider_row(SETTINGS_ROW_Y(3), "音量",
                                 volume_percent, 1U);
    settings_ui_add_toggle_row(SETTINGS_ROW_Y(4), "静音", snapshot.muted,
                               SETTINGS_TOGGLE_MUTE);
    settings_ui_add_toggle_row(SETTINGS_ROW_Y(5), "震动",
                               snapshot.vibration_enabled,
                               SETTINGS_TOGGLE_VIBRATION);
    settings_ui_add_toggle_row(SETTINGS_ROW_Y(6), "勿扰模式",
                               snapshot.do_not_disturb_enabled,
                               SETTINGS_TOGGLE_DND);

    if (!battery.valid)
        (void)snprintf(value, sizeof(value), "--%%");
    else
        (void)snprintf(value, sizeof(value), "%u%%",
                       (unsigned int)battery.percent);
    settings_ui_add_navigation_row(SETTINGS_ROW_Y(7), "电池管理", value,
                                   settings_ui_open_battery_event);
    settings_ui_add_navigation_row(SETTINGS_ROW_Y(8), "系统信息",
                                   HSP_WATCH_FIRMWARE_VERSION,
                                   settings_ui_open_info_event);
    settings_ui_add_navigation_row(SETTINGS_ROW_Y(9), "软件更新",
                                   LV_SYMBOL_REFRESH,
                                   settings_ui_open_update_event);
    settings_ui_add_navigation_row(SETTINGS_ROW_Y(10), "重启与关机",
                                   LV_SYMBOL_RIGHT,
                                   settings_ui_open_power_event);
}

static void settings_ui_ota_button_event(lv_event_t *event)
{
    ota_snapshot_t snapshot;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    ota_service_get_snapshot(&snapshot);
    if (snapshot.state == OTA_STATE_UPDATE_AVAILABLE)
        (void)ota_service_install();
    else if (snapshot.state != OTA_STATE_CHECKING &&
             snapshot.state != OTA_STATE_PREPARING &&
             snapshot.state != OTA_STATE_REBOOTING)
        (void)ota_service_check();
}

static void settings_ui_refresh_ota(void)
{
    ota_snapshot_t snapshot;
    const char *button_text;
    uint32_t status_color;
    uint8_t button_enabled = 1U;

    if (settings_ota_status == NULL)
        return;
    ota_service_get_snapshot(&snapshot);

    lv_label_set_text(settings_ota_network,
                      snapshot.pan_connected ? "PAN 网络已连接" :
                                               "PAN 网络未连接");
    lv_obj_set_style_text_color(settings_ota_network,
                                lv_color_hex(snapshot.pan_connected ?
                                             SETTINGS_GREEN : SETTINGS_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_text(settings_ota_latest,
                      snapshot.latest_version[0] != '\0' ?
                      snapshot.latest_version : "--");
    lv_label_set_text(settings_ota_status, snapshot.status);

    status_color = snapshot.state == OTA_STATE_FAILED ? 0xFF6B6B :
                   snapshot.state == OTA_STATE_UPDATE_AVAILABLE ?
                   SETTINGS_GREEN : SETTINGS_MUTED;
    lv_obj_set_style_text_color(settings_ota_status, lv_color_hex(status_color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    switch (snapshot.state)
    {
    case OTA_STATE_CHECKING:
        button_text = "正在检查";
        button_enabled = 0U;
        break;
    case OTA_STATE_UPDATE_AVAILABLE:
        button_text = "下载并安装";
        break;
    case OTA_STATE_UP_TO_DATE:
        button_text = "再次检查";
        break;
    case OTA_STATE_PREPARING:
        button_text = "正在准备";
        button_enabled = 0U;
        break;
    case OTA_STATE_REBOOTING:
        button_text = "正在重启";
        button_enabled = 0U;
        break;
    case OTA_STATE_FAILED:
        button_text = "重新检查";
        break;
    default:
        button_text = "检查更新";
        break;
    }
    lv_label_set_text(settings_ota_button_label, button_text);
    if (button_enabled)
        lv_obj_clear_state(settings_ota_button, LV_STATE_DISABLED);
    else
        lv_obj_add_state(settings_ota_button, LV_STATE_DISABLED);
}

static void settings_ui_build_update(void)
{
    lv_obj_t *row;
    lv_obj_t *label;

    ota_service_init();
    settings_ui_add_header("软件更新");
    settings_content = settings_panel;

    label = settings_ui_add_label(settings_panel, HSP_WATCH_FIRMWARE_VERSION,
                                  &lv_font_montserrat_36, SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 82);
    settings_ota_network = settings_ui_add_label(
        settings_panel, "PAN 网络未连接", &hsp_font_cjk_22, SETTINGS_MUTED);
    lv_obj_align(settings_ota_network, LV_ALIGN_TOP_MID, 0, 132);

    row = settings_ui_add_row(178, NULL);
    label = settings_ui_add_label(row, "最新版本", &hsp_font_cjk_22,
                                  SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    settings_ota_latest = settings_ui_add_label(
        row, "--", &lv_font_montserrat_20, SETTINGS_GOLD);
    lv_obj_align(settings_ota_latest, LV_ALIGN_RIGHT_MID, -22, 0);

    settings_ota_status = settings_ui_add_label(
        settings_panel, "点击检查新版本", &hsp_font_cjk_22, SETTINGS_MUTED);
    lv_obj_set_width(settings_ota_status, 342);
    lv_obj_set_style_text_align(settings_ota_status, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_align(settings_ota_status, LV_ALIGN_TOP_MID, 0, 298);

    settings_ota_button = lv_btn_create(settings_panel);
    lv_obj_set_pos(settings_ota_button, 45, 358);
    lv_obj_set_size(settings_ota_button, 300, 62);
    settings_ui_style_object(settings_ota_button, SETTINGS_GOLD,
                             LV_OPA_COVER, 24);
    lv_obj_set_style_bg_color(settings_ota_button, lv_color_hex(0x9D7A35),
                              LV_PART_MAIN | LV_STATE_DISABLED);
    lv_obj_set_style_bg_color(settings_ota_button,
                              lv_color_hex(SETTINGS_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(settings_ota_button, settings_ui_ota_button_event,
                        LV_EVENT_CLICKED, NULL);
    settings_ota_button_label = settings_ui_add_label(
        settings_ota_button, "检查更新", &hsp_font_cjk_22, SETTINGS_BG);
    lv_obj_center(settings_ota_button_label);
    settings_ui_refresh_ota();
}

static void settings_ui_refresh_battery(void)
{
    battery_status_t battery;

    if (settings_battery_percent == NULL)
        return;
    battery_ui_get_status(&battery);
    if (!battery.valid)
    {
        lv_label_set_text(settings_battery_percent, "--%");
        lv_label_set_text(settings_battery_status, "正在读取电池");
        lv_label_set_text(settings_battery_voltage, "-- mV");
        lv_bar_set_value(settings_battery_bar, 0, LV_ANIM_OFF);
        return;
    }

    lv_label_set_text_fmt(settings_battery_percent, "%u%%",
                          (unsigned int)battery.percent);
    lv_label_set_text(settings_battery_status,
                      battery.external_power_present ? "正在充电" :
                      (battery.low_battery ? "电量较低" : "电池供电"));
    lv_label_set_text_fmt(settings_battery_voltage, "%u mV",
                          (unsigned int)battery.voltage_mv);
    lv_bar_set_value(settings_battery_bar, battery.percent, LV_ANIM_ON);
}

static void settings_ui_build_battery(void)
{
    watch_settings_snapshot_t snapshot;
    lv_obj_t *label;

    watch_settings_get_snapshot(&snapshot);
    settings_ui_add_header("电池管理");
    settings_battery_percent = settings_ui_add_label(
        settings_panel, "--%", &lv_font_montserrat_48, SETTINGS_TEXT);
    lv_obj_align(settings_battery_percent, LV_ALIGN_TOP_MID, 0, 98);
    settings_battery_status = settings_ui_add_label(
        settings_panel, "正在读取电池", &hsp_font_cjk_22, SETTINGS_GREEN);
    lv_obj_align(settings_battery_status, LV_ALIGN_TOP_MID, 0, 160);

    settings_battery_bar = lv_bar_create(settings_panel);
    lv_obj_set_pos(settings_battery_bar, 45, 208);
    lv_obj_set_size(settings_battery_bar, 300, 18);
    lv_bar_set_range(settings_battery_bar, 0, 100);
    lv_obj_set_style_radius(settings_battery_bar, 9, LV_PART_MAIN);
    lv_obj_set_style_bg_color(settings_battery_bar, lv_color_hex(0x303640),
                              LV_PART_MAIN);
    lv_obj_set_style_border_width(settings_battery_bar, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(settings_battery_bar, 9, LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(settings_battery_bar,
                              lv_color_hex(SETTINGS_GREEN),
                              LV_PART_INDICATOR);

    settings_battery_voltage = settings_ui_add_label(
        settings_panel, "-- mV", &lv_font_montserrat_20, SETTINGS_MUTED);
    lv_obj_align(settings_battery_voltage, LV_ALIGN_TOP_MID, 0, 244);

    settings_content = settings_panel;
    settings_ui_add_toggle_row(300, "低电量模式",
                               snapshot.low_power_enabled,
                               SETTINGS_TOGGLE_LOW_POWER);
    label = settings_ui_add_label(settings_panel,
                                  "降低亮度并缩短息屏时间",
                                  &hsp_font_cjk_22, SETTINGS_MUTED);
    lv_obj_align(label, LV_ALIGN_BOTTOM_MID, 0, -23);
    settings_ui_refresh_battery();
}

static void settings_ui_build_info(void)
{
    lv_obj_t *label;
    lv_obj_t *row;

    settings_ui_add_header("系统信息");
    label = settings_ui_add_label(settings_panel, "HSP Watch",
                                  &lv_font_montserrat_30, SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 90);

    settings_content = settings_panel;
    row = settings_ui_add_row(160, NULL);
    label = settings_ui_add_label(row, "固件版本", &hsp_font_cjk_22,
                                  SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    label = settings_ui_add_label(row, HSP_WATCH_FIRMWARE_VERSION,
                                  &lv_font_montserrat_20, SETTINGS_GOLD);
    lv_obj_align(label, LV_ALIGN_RIGHT_MID, -22, 0);

    row = settings_ui_add_row(272, NULL);
    label = settings_ui_add_label(row, "系统", &hsp_font_cjk_22,
                                  SETTINGS_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 22, 0);
    label = settings_ui_add_label(row, "SF32LB52 / LVGL 8",
                                  &lv_font_montserrat_16, SETTINGS_MUTED);
    lv_obj_align(label, LV_ALIGN_RIGHT_MID, -22, 0);
}

static void settings_ui_build(void)
{
    if (ui_Settings == NULL)
        return;

    settings_content = NULL;
    settings_brightness_value = NULL;
    settings_volume_value = NULL;
    settings_timeout_value = NULL;
    settings_battery_percent = NULL;
    settings_battery_status = NULL;
    settings_battery_voltage = NULL;
    settings_battery_bar = NULL;
    settings_ota_network = NULL;
    settings_ota_latest = NULL;
    settings_ota_status = NULL;
    settings_ota_button = NULL;
    settings_ota_button_label = NULL;
    lv_obj_clean(ui_Settings);

    settings_panel = lv_obj_create(ui_Settings);
    lv_obj_set_size(settings_panel, 390, 450);
    lv_obj_center(settings_panel);
    settings_ui_style_object(settings_panel, SETTINGS_PANEL, LV_OPA_COVER, 45);
    lv_obj_set_style_border_color(settings_panel, lv_color_hex(SETTINGS_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(settings_panel, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(settings_panel, true, LV_PART_MAIN);

    if (settings_page == SETTINGS_PAGE_BATTERY)
        settings_ui_build_battery();
    else if (settings_page == SETTINGS_PAGE_INFO)
        settings_ui_build_info();
    else if (settings_page == SETTINGS_PAGE_UPDATE)
        settings_ui_build_update();
    else
        settings_ui_build_main();
}

static void settings_ui_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    if (ui_Settings == NULL || lv_scr_act() != ui_Settings)
        return;
    if (settings_page == SETTINGS_PAGE_BATTERY)
        settings_ui_refresh_battery();
    else if (settings_page == SETTINGS_PAGE_UPDATE)
        settings_ui_refresh_ota();
}

void ui_Settings_screen_init(void)
{
    if (ui_Settings != NULL)
        return;
    ui_Settings = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_Settings, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Settings, lv_color_hex(SETTINGS_BG),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Settings, LV_OPA_COVER, LV_PART_MAIN);
    settings_ui_build();
    settings_refresh_timer = lv_timer_create(settings_ui_refresh_timer_cb,
                                              1000U, NULL);
}

void ui_Settings_screen_destroy(void)
{
    if (settings_refresh_timer != NULL)
        lv_timer_del(settings_refresh_timer);
    settings_refresh_timer = NULL;
    if (ui_Settings != NULL)
        lv_obj_del(ui_Settings);
    ui_Settings = NULL;
    settings_panel = NULL;
    settings_content = NULL;
}

void ui_Settings_open_from_app_grid(void)
{
    settings_ui_wait_release();
    settings_page = SETTINGS_PAGE_MAIN;
    if (ui_Settings == NULL)
        ui_Settings_screen_init();
    else
        settings_ui_build();
    lv_scr_load_anim(ui_Settings, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Settings_return(void)
{
    settings_ui_wait_release();
    if (settings_page == SETTINGS_PAGE_UPDATE &&
        ota_service_install_in_progress())
        return;
    if (settings_page != SETTINGS_PAGE_MAIN)
    {
        settings_page = SETTINGS_PAGE_MAIN;
        settings_ui_build();
        return;
    }
    ui_AppGrid_open();
}
