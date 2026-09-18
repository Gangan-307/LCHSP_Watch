#include "ui_BluetoothSettings.h"

#include "../home_gestures.h"
#include "../hsp_font_cjk_22.h"
#include "../ui_screen_lifecycle.h"
#include "../ui_swipe_back.h"
#include "bluetooth/find_phone_ble.h"
#include "bluetooth/pan.h"
#include "ui/app_grid/app_grid_ui.h"

#define BT_BG       0x050608
#define BT_TEXT     0xF5F7FA
#define BT_MUTED    0x8994A2
#define BT_ACCENT   0x3B9BFF

lv_obj_t *ui_BluetoothSettings;

static lv_obj_t *bt_radio_switch;
static lv_obj_t *bt_phone_status;
static lv_obj_t *bt_network_status;
static lv_obj_t *bt_find_button;
static lv_obj_t *bt_find_label;
static lv_timer_t *bt_refresh_timer;
static uint8_t bt_from_grid;
static uint8_t bt_last_state = 0xFFU;

static void bt_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static lv_obj_t *bt_add_label(lv_obj_t *parent, const char *text,
                              lv_coord_t x, lv_coord_t y, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text_static(label, text);
    lv_obj_set_pos(label, x, y);
    lv_obj_set_width(label, 330);
    lv_obj_set_style_text_font(label, &hsp_font_cjk_22, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(color), 0);
    lv_obj_set_style_text_letter_space(label, 0, 0);
    return label;
}

void ui_BluetoothSettings_refresh(void)
{
    uint8_t enabled, classic, companion, network, requested, state;

    if (ui_BluetoothSettings == NULL)
        return;
    enabled = bt_pan_is_enabled();
    classic = enabled && bt_pan_is_connected();
    companion = enabled && find_phone_ble_is_connected();
    network = enabled && bt_pan_network_is_connected();
    requested = companion && find_phone_ble_is_requested();
    state = enabled | (classic << 1) | (companion << 2) |
            (network << 3) | (requested << 4);
    if (state == bt_last_state)
        return;
    bt_last_state = state;

    if (enabled)
        lv_obj_add_state(bt_radio_switch, LV_STATE_CHECKED);
    else
        lv_obj_clear_state(bt_radio_switch, LV_STATE_CHECKED);
    lv_label_set_text_static(bt_phone_status,
                             !enabled ? "蓝牙已关闭" :
                             companion ? "已连接手机应用" :
                             classic ? "已连接蓝牙" : "未连接");
    lv_label_set_text_static(bt_network_status,
                             network ? "已连接" : "未连接");
    lv_obj_set_style_text_color(bt_network_status,
                                lv_color_hex(network ? 0x65CE8C : BT_MUTED), 0);
    if (companion)
        lv_obj_clear_state(bt_find_button, LV_STATE_DISABLED);
    else
        lv_obj_add_state(bt_find_button, LV_STATE_DISABLED);
    lv_label_set_text_static(bt_find_label,
                             requested ? "停止查找" : "查找手机");
}

static void bt_refresh(lv_timer_t *timer)
{
    (void)timer;
    if (lv_scr_act() == ui_BluetoothSettings)
        ui_BluetoothSettings_refresh();
}

static void bt_radio_event(lv_event_t *event)
{
    lv_obj_t *toggle = lv_event_get_target(event);

    bt_pan_set_enabled(lv_obj_has_state(toggle, LV_STATE_CHECKED));
    home_gestures_refresh_controls_state();
    ui_BluetoothSettings_refresh();
}

static void bt_find_event(lv_event_t *event)
{
    (void)event;
    if (!bt_pan_is_enabled() || !find_phone_ble_is_connected())
        return;
    if (find_phone_ble_is_requested())
        find_phone_ble_stop();
    else
        find_phone_ble_start();
    ui_BluetoothSettings_refresh();
}

static void bt_back_event(lv_event_t *event)
{
    (void)event;
    ui_BluetoothSettings_return();
}

void ui_BluetoothSettings_screen_init(void)
{
    lv_obj_t *back, *label;

    if (ui_BluetoothSettings != NULL)
        return;
    ui_screen_log_memory("bluetooth before");
    ui_BluetoothSettings = lv_obj_create(NULL);
    lv_obj_remove_style_all(ui_BluetoothSettings);
    lv_obj_set_style_bg_color(ui_BluetoothSettings, lv_color_hex(BT_BG), 0);
    lv_obj_set_style_bg_opa(ui_BluetoothSettings, LV_OPA_COVER, 0);
    lv_obj_clear_flag(ui_BluetoothSettings, LV_OBJ_FLAG_SCROLLABLE);
    ui_swipe_back_register(ui_BluetoothSettings, ui_BluetoothSettings_return);
    ui_screen_release_on_unload(ui_BluetoothSettings,
                                ui_BluetoothSettings_screen_destroy);

    back = lv_btn_create(ui_BluetoothSettings);
    lv_obj_set_pos(back, 20, 12);
    lv_obj_set_size(back, 50, 50);
    lv_obj_set_style_bg_opa(back, LV_OPA_TRANSP, 0);
    lv_obj_set_style_shadow_width(back, 0, 0);
    lv_obj_add_event_cb(back, bt_back_event, LV_EVENT_CLICKED, NULL);
    label = lv_label_create(back);
    lv_label_set_text_static(label, LV_SYMBOL_LEFT);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(BT_TEXT), 0);
    lv_obj_center(label);
    label = bt_add_label(ui_BluetoothSettings, "蓝牙设置", 110, 23, BT_TEXT);
    lv_obj_set_width(label, 180);

    label = bt_add_label(ui_BluetoothSettings, "蓝牙", 30, 104, BT_TEXT);
    lv_obj_set_width(label, 180);
    bt_radio_switch = lv_switch_create(ui_BluetoothSettings);
    lv_obj_set_pos(bt_radio_switch, 280, 98);
    lv_obj_set_size(bt_radio_switch, 72, 38);
    lv_obj_set_style_bg_color(bt_radio_switch, lv_color_hex(BT_ACCENT),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    lv_obj_add_event_cb(bt_radio_switch, bt_radio_event,
                        LV_EVENT_VALUE_CHANGED, NULL);

    bt_add_label(ui_BluetoothSettings, "手机连接", 30, 176, BT_TEXT);
    bt_phone_status = bt_add_label(ui_BluetoothSettings, "", 30, 209, BT_MUTED);
    bt_add_label(ui_BluetoothSettings, "网络共享", 30, 270, BT_TEXT);
    bt_network_status = bt_add_label(ui_BluetoothSettings, "", 30, 303, BT_MUTED);

    bt_find_button = lv_btn_create(ui_BluetoothSettings);
    lv_obj_set_pos(bt_find_button, 30, 370);
    lv_obj_set_size(bt_find_button, 330, 56);
    lv_obj_set_style_radius(bt_find_button, 8, 0);
    lv_obj_set_style_shadow_width(bt_find_button, 0, 0);
    lv_obj_set_style_bg_color(bt_find_button, lv_color_hex(BT_ACCENT), 0);
    lv_obj_set_style_bg_color(bt_find_button, lv_color_hex(0x30343A),
                              LV_STATE_DISABLED);
    bt_find_label = bt_add_label(bt_find_button, "查找手机", 0, 0, BT_TEXT);
    lv_obj_set_width(bt_find_label, 280);
    lv_obj_set_style_text_align(bt_find_label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_center(bt_find_label);
    lv_obj_add_event_cb(bt_find_button, bt_find_event, LV_EVENT_CLICKED, NULL);

    bt_last_state = 0xFFU;
    ui_BluetoothSettings_refresh();
    bt_refresh_timer = lv_timer_create(bt_refresh, 1000, NULL);
    ui_screen_log_memory("bluetooth ready");
}

static void bt_open(uint8_t from_grid)
{
    bt_from_grid = from_grid;
    bt_wait_release();
    ui_BluetoothSettings_screen_init();
    ui_BluetoothSettings_refresh();
    lv_scr_load_anim(ui_BluetoothSettings, LV_SCR_LOAD_ANIM_MOVE_LEFT,
                     180, 0, false);
}

void ui_BluetoothSettings_open_from_controls(void)
{
    bt_open(0U);
}

void ui_BluetoothSettings_open_from_app_grid(void)
{
    bt_open(1U);
}

void ui_BluetoothSettings_return(void)
{
    bt_wait_release();
    if (bt_from_grid)
        ui_AppGrid_open();
    else
        home_gestures_open_controls();
}

void ui_BluetoothSettings_screen_destroy(void)
{
    if (bt_refresh_timer != NULL)
        lv_timer_del(bt_refresh_timer);
    bt_refresh_timer = NULL;
    if (ui_BluetoothSettings != NULL)
        lv_obj_del(ui_BluetoothSettings);
    ui_BluetoothSettings = NULL;
    bt_radio_switch = NULL;
    bt_phone_status = NULL;
    bt_network_status = NULL;
    bt_find_button = NULL;
    bt_find_label = NULL;
    bt_last_state = 0xFFU;
}
