// Hand-built Bluetooth settings page for the HSP watch.

#include "../ui.h"
#include "../home_gestures.h"
#include "bluetooth/find_phone_ble.h"
#include "bluetooth/pan.h"

#define BT_SETTINGS_BG              0x050608
#define BT_SETTINGS_BORDER          0x293340
#define BT_SETTINGS_CARD            0x151A21
#define BT_SETTINGS_CARD_PRESSED    0x232A35
#define BT_SETTINGS_CARD_BORDER     0x303A47
#define BT_SETTINGS_TEXT            0xF5F7FA
#define BT_SETTINGS_SECONDARY       0xA0AAB9
#define BT_SETTINGS_MUTED           0x778291
#define BT_SETTINGS_BLUE            0x3B9BFF
#define BT_SETTINGS_GREEN           0x65CE8C
#define BT_SETTINGS_AMBER           0xF4BE4F
#define BT_SETTINGS_RED             0xFF5C6C
#define BT_SETTINGS_BLUE_ICON_BG    0x162B46
#define BT_SETTINGS_GREEN_ICON_BG   0x183126
#define BT_SETTINGS_AMBER_ICON_BG   0x3A3020
#define BT_SETTINGS_RED_ICON_BG     0x3A2024
#define BT_SETTINGS_CLOCK_ICON      "\xEF\x80\x97"

#define BT_SETTINGS_CONTENT_MARGIN  14
#define BT_SETTINGS_CONTENT_WIDTH   362
#define BT_SETTINGS_ROW_HEIGHT      88
#define BT_SETTINGS_ROW_GAP         12
#define BT_SETTINGS_SECTION_GAP     22
#define BT_SETTINGS_SECTION_HEIGHT  26
#define BT_SETTINGS_ICON_SIZE       50

typedef enum
{
    BT_BADGE_BLUE,
    BT_BADGE_MUTED,
    BT_BADGE_AMBER,
    BT_BADGE_RED,
} bt_badge_style_t;

lv_obj_t *ui_BluetoothSettings = NULL;

static lv_obj_t *bt_settings_content;
static lv_obj_t *bt_connection_title;
static lv_obj_t *bt_connection_detail;
static lv_obj_t *bt_connection_badge;
static lv_obj_t *bt_radio_detail;
static lv_obj_t *bt_radio_switch;
static lv_obj_t *bt_phone_detail;
static lv_obj_t *bt_phone_badge;
static lv_obj_t *bt_find_phone_detail;
static lv_obj_t *bt_find_phone_badge;
static lv_obj_t *bt_pan_detail;
static lv_obj_t *bt_pan_badge;
static lv_obj_t *bt_pan_switch;
static lv_timer_t *bt_refresh_timer;
static uint8_t bt_pan_preference;

static void bt_settings_refresh_timer_cb(lv_timer_t *timer);
static void bt_settings_screen_event(lv_event_t *event);
static void bt_settings_return_event(lv_event_t *event);
static void bt_settings_radio_event(lv_event_t *event);
static void bt_settings_find_phone_event(lv_event_t *event);
static void bt_settings_pan_event(lv_event_t *event);

static void bt_settings_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void bt_settings_stop_refresh_timer(void)
{
    if (bt_refresh_timer != NULL)
    {
        lv_timer_del(bt_refresh_timer);
        bt_refresh_timer = NULL;
    }
}

static void bt_settings_start_refresh_timer(void)
{
    if (bt_refresh_timer == NULL)
        bt_refresh_timer = lv_timer_create(bt_settings_refresh_timer_cb, 1000, NULL);
}

static void bt_settings_return_to_controls(void)
{
    bt_settings_stop_refresh_timer();
    bt_settings_wait_release();
    home_gestures_open_controls();
}

static void bt_settings_style_card(lv_obj_t *object)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(object, lv_color_hex(BT_SETTINGS_CARD),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(object, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(object, lv_color_hex(BT_SETTINGS_CARD_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(object, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_opa(object, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_flag(object, LV_OBJ_FLAG_GESTURE_BUBBLE);
}

static void bt_settings_style_icon(lv_obj_t *icon_bg, lv_obj_t *icon_label,
                                   const char *symbol, uint32_t icon_color,
                                   uint32_t icon_bg_color)
{
    lv_obj_set_size(icon_bg, BT_SETTINGS_ICON_SIZE, BT_SETTINGS_ICON_SIZE);
    lv_obj_set_pos(icon_bg, 14, 19);
    lv_obj_clear_flag(icon_bg, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(icon_bg, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(icon_bg, lv_color_hex(icon_bg_color),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(icon_bg, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(icon_bg, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(icon_bg, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_label_set_text(icon_label, symbol);
    lv_obj_center(icon_label);
    lv_obj_set_style_text_font(icon_label, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(icon_label, lv_color_hex(icon_color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void bt_settings_set_badge(lv_obj_t *badge, const char *text,
                                  bt_badge_style_t style)
{
    uint32_t text_color = BT_SETTINGS_BLUE;
    uint32_t background = 0x102843;
    uint32_t border = 0x235B90;

    if (badge == NULL)
        return;

    if (style == BT_BADGE_MUTED)
    {
        text_color = BT_SETTINGS_SECONDARY;
        background = 0x202833;
        border = 0x465365;
    }
    else if (style == BT_BADGE_AMBER)
    {
        text_color = BT_SETTINGS_AMBER;
        background = 0x332A1B;
        border = 0x6C572D;
    }
    else if (style == BT_BADGE_RED)
    {
        text_color = BT_SETTINGS_RED;
        background = 0x382125;
        border = 0x74343B;
    }

    lv_label_set_text(badge, text);
    lv_obj_set_style_text_color(badge, lv_color_hex(text_color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(badge, lv_color_hex(background),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(badge, lv_color_hex(border),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void bt_settings_set_switch(lv_obj_t *switch_object, uint8_t enabled)
{
    if (switch_object == NULL)
        return;

    if (enabled)
        lv_obj_add_state(switch_object, LV_STATE_CHECKED);
    else
        lv_obj_clear_state(switch_object, LV_STATE_CHECKED);
}

static void bt_settings_add_section_title(lv_obj_t *parent, lv_coord_t y,
                                          const char *title, const char *hint)
{
    lv_obj_t *title_label = lv_label_create(parent);
    lv_obj_t *hint_label = lv_label_create(parent);

    lv_label_set_text(title_label, title);
    lv_obj_set_pos(title_label, BT_SETTINGS_CONTENT_MARGIN, y);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(BT_SETTINGS_SECONDARY),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_letter_space(title_label, 1,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_width(hint_label, 208);
    lv_obj_set_pos(hint_label, 168, y);
    lv_label_set_text(hint_label, hint);
    lv_obj_set_style_text_align(hint_label, LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(hint_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(hint_label, lv_color_hex(BT_SETTINGS_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *bt_settings_add_row(lv_obj_t *parent, lv_coord_t y,
                                     const char *symbol, uint32_t icon_color,
                                     uint32_t icon_bg_color, const char *title,
                                     const char *detail, const char *badge_text,
                                     bt_badge_style_t badge_style,
                                     lv_event_cb_t event_cb,
                                     lv_obj_t **detail_out,
                                     lv_obj_t **badge_out)
{
    lv_obj_t *row = event_cb != NULL ? lv_btn_create(parent) : lv_obj_create(parent);
    lv_obj_t *icon_bg = lv_obj_create(row);
    lv_obj_t *icon_label = lv_label_create(icon_bg);
    lv_obj_t *title_label = lv_label_create(row);
    lv_obj_t *detail_label = lv_label_create(row);
    lv_obj_t *badge = lv_label_create(row);

    lv_obj_set_size(row, BT_SETTINGS_CONTENT_WIDTH, BT_SETTINGS_ROW_HEIGHT);
    lv_obj_set_pos(row, BT_SETTINGS_CONTENT_MARGIN, y);
    bt_settings_style_card(row);
    if (event_cb != NULL)
    {
        lv_obj_set_style_bg_color(row, lv_color_hex(BT_SETTINGS_CARD_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_set_style_bg_opa(row, LV_OPA_COVER,
                                LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_add_event_cb(row, event_cb, LV_EVENT_CLICKED, NULL);
    }

    bt_settings_style_icon(icon_bg, icon_label, symbol, icon_color, icon_bg_color);

    lv_label_set_text(title_label, title);
    lv_obj_set_width(title_label, 174);
    lv_obj_set_pos(title_label, 76, 16);
    lv_label_set_long_mode(title_label, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(BT_SETTINGS_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_width(detail_label, 176);
    lv_obj_set_pos(detail_label, 76, 52);
    lv_label_set_long_mode(detail_label, LV_LABEL_LONG_DOT);
    lv_label_set_text(detail_label, detail);
    lv_obj_set_style_text_font(detail_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(detail_label, lv_color_hex(BT_SETTINGS_SECONDARY),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_size(badge, 86, 30);
    lv_obj_set_pos(badge, 262, 29);
    lv_obj_set_style_text_align(badge, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(badge, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(badge, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(badge, 6, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_top(badge, 7, LV_PART_MAIN | LV_STATE_DEFAULT);
    bt_settings_set_badge(badge, badge_text, badge_style);

    if (detail_out != NULL)
        *detail_out = detail_label;
    if (badge_out != NULL)
        *badge_out = badge;

    return row;
}

static lv_obj_t *bt_settings_add_toggle_row(lv_obj_t *parent, lv_coord_t y,
                                            const char *symbol, uint32_t icon_color,
                                            uint32_t icon_bg_color, const char *title,
                                            const char *detail, uint8_t enabled,
                                            lv_event_cb_t event_cb,
                                            lv_obj_t **detail_out,
                                            lv_obj_t **switch_out)
{
    lv_obj_t *row = event_cb != NULL ? lv_btn_create(parent) : lv_obj_create(parent);
    lv_obj_t *icon_bg = lv_obj_create(row);
    lv_obj_t *icon_label = lv_label_create(icon_bg);
    lv_obj_t *title_label = lv_label_create(row);
    lv_obj_t *detail_label = lv_label_create(row);
    lv_obj_t *switch_object = lv_switch_create(row);

    lv_obj_set_size(row, BT_SETTINGS_CONTENT_WIDTH, BT_SETTINGS_ROW_HEIGHT);
    lv_obj_set_pos(row, BT_SETTINGS_CONTENT_MARGIN, y);
    bt_settings_style_card(row);

    if (event_cb != NULL)
    {
        lv_obj_set_style_bg_color(row, lv_color_hex(BT_SETTINGS_CARD_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_set_style_bg_opa(row, LV_OPA_COVER,
                                LV_PART_MAIN | LV_STATE_PRESSED);
    }

    bt_settings_style_icon(icon_bg, icon_label, symbol, icon_color, icon_bg_color);

    lv_label_set_text(title_label, title);
    lv_obj_set_width(title_label, 188);
    lv_obj_set_pos(title_label, 76, 16);
    lv_label_set_long_mode(title_label, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(BT_SETTINGS_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_width(detail_label, 188);
    lv_obj_set_pos(detail_label, 76, 52);
    lv_label_set_long_mode(detail_label, LV_LABEL_LONG_DOT);
    lv_label_set_text(detail_label, detail);
    lv_obj_set_style_text_font(detail_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(detail_label, lv_color_hex(BT_SETTINGS_SECONDARY),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_size(switch_object, 66, 36);
    lv_obj_set_pos(switch_object, 282, 26);
    lv_obj_clear_flag(switch_object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(switch_object, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_bg_color(switch_object, lv_color_hex(0x3D4652),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(switch_object, lv_color_hex(BT_SETTINGS_BLUE),
                              LV_PART_MAIN | LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(switch_object, lv_color_hex(0xFFFFFF),
                              LV_PART_KNOB | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(switch_object, 4, LV_PART_MAIN | LV_STATE_DEFAULT);
    bt_settings_set_switch(switch_object, enabled);
    if (event_cb != NULL)
    {
        /* The full card is the tap target; the switch reflects its state. */
        lv_obj_clear_flag(switch_object, LV_OBJ_FLAG_CLICKABLE);
        lv_obj_add_event_cb(row, event_cb, LV_EVENT_CLICKED, NULL);
    }

    if (detail_out != NULL)
        *detail_out = detail_label;
    if (switch_out != NULL)
        *switch_out = switch_object;

    return row;
}

void ui_BluetoothSettings_refresh(void)
{
    uint8_t enabled;
    uint8_t classic_connected;
    uint8_t companion_connected;
    uint8_t find_requested;

    if (ui_BluetoothSettings == NULL)
        return;

    enabled = bt_pan_is_enabled();
    classic_connected = bt_pan_is_connected();
    companion_connected = find_phone_ble_is_connected();
    find_requested = find_phone_ble_is_requested();

    bt_settings_set_switch(bt_radio_switch, enabled);
    bt_settings_set_switch(bt_pan_switch, bt_pan_preference);

    if (!enabled)
    {
        lv_label_set_text(bt_connection_title, "BLUETOOTH OFF");
        lv_label_set_text(bt_connection_detail, "Turn on to connect a phone");
        bt_settings_set_badge(bt_connection_badge, "OFF", BT_BADGE_MUTED);
        lv_label_set_text(bt_radio_detail, "Off · Bluetooth services stopped");
        lv_label_set_text(bt_phone_detail, "Turn Bluetooth on to connect");
        bt_settings_set_badge(bt_phone_badge, "OFF", BT_BADGE_MUTED);
        lv_label_set_text(bt_find_phone_detail, "Bluetooth is turned off");
        bt_settings_set_badge(bt_find_phone_badge, "OFF", BT_BADGE_MUTED);
    }
    else if (companion_connected)
    {
        lv_label_set_text(bt_connection_title, "HSP PHONE");
        lv_label_set_text(bt_connection_detail, "BLE connected · synced just now");
        bt_settings_set_badge(bt_connection_badge, "CONNECTED", BT_BADGE_BLUE);
        lv_label_set_text(bt_radio_detail, "On · secure pairing enabled");
        lv_label_set_text(bt_phone_detail, "BLE connected · companion ready");
        bt_settings_set_badge(bt_phone_badge, "CONNECTED", BT_BADGE_BLUE);
        lv_label_set_text(bt_find_phone_detail,
                          find_requested ? "Ring request sent to the phone" :
                          "Send a vibration and ring request");
        bt_settings_set_badge(bt_find_phone_badge,
                              find_requested ? "SENT" : "READY", BT_BADGE_BLUE);
    }
    else if (classic_connected)
    {
        lv_label_set_text(bt_connection_title, "PHONE LINKED");
        lv_label_set_text(bt_connection_detail, "Classic Bluetooth link is active");
        bt_settings_set_badge(bt_connection_badge, "LINKED", BT_BADGE_BLUE);
        lv_label_set_text(bt_radio_detail, "On · classic Bluetooth connected");
        lv_label_set_text(bt_phone_detail, "Open the HSP app to finish companion sync");
        bt_settings_set_badge(bt_phone_badge, "APP", BT_BADGE_AMBER);
        lv_label_set_text(bt_find_phone_detail, "Open the HSP app to enable this feature");
        bt_settings_set_badge(bt_find_phone_badge, "APP", BT_BADGE_AMBER);
    }
    else
    {
        lv_label_set_text(bt_connection_title, "PHONE READY");
        lv_label_set_text(bt_connection_detail, "Waiting for the HSP companion app");
        bt_settings_set_badge(bt_connection_badge, "ON", BT_BADGE_BLUE);
        lv_label_set_text(bt_radio_detail, "On · secure pairing enabled");
        lv_label_set_text(bt_phone_detail, "No active phone connection");
        bt_settings_set_badge(bt_phone_badge, "WAITING", BT_BADGE_MUTED);
        lv_label_set_text(bt_find_phone_detail, "Connect the HSP app first");
        bt_settings_set_badge(bt_find_phone_badge, "OFF", BT_BADGE_MUTED);
    }

    if (bt_pan_preference)
    {
        lv_label_set_text(bt_pan_detail, "Preference saved · service pending");
        bt_settings_set_badge(bt_pan_badge, "PLANNED", BT_BADGE_AMBER);
    }
    else
    {
        lv_label_set_text(bt_pan_detail, "Off · use only for an active request");
        bt_settings_set_badge(bt_pan_badge, "OFF", BT_BADGE_MUTED);
    }
}

void ui_BluetoothSettings_open_from_controls(void)
{
    bt_settings_wait_release();
    _ui_screen_change(&ui_BluetoothSettings, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0,
                      &ui_BluetoothSettings_screen_init);
    if (bt_settings_content != NULL)
        lv_obj_scroll_to_y(bt_settings_content, 0, LV_ANIM_OFF);
    ui_BluetoothSettings_refresh();
    bt_settings_start_refresh_timer();
}

static void bt_settings_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    ui_BluetoothSettings_refresh();
}

static void bt_settings_return_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        bt_settings_return_to_controls();
}

static void bt_settings_screen_event(lv_event_t *event)
{
    lv_indev_t *indev;

    if (lv_event_get_code(event) != LV_EVENT_GESTURE)
        return;

    indev = lv_indev_get_act();
    if (indev != NULL && lv_indev_get_gesture_dir(indev) == LV_DIR_RIGHT)
        bt_settings_return_to_controls();
}

static void bt_settings_radio_event(lv_event_t *event)
{
    uint8_t requested;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;

    requested = bt_pan_is_enabled() ? 0U : 1U;
    bt_pan_set_enabled(requested);

    home_gestures_refresh_controls_state();
    ui_BluetoothSettings_refresh();
}

static void bt_settings_find_phone_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED || !bt_pan_is_enabled())
        return;

    if (find_phone_ble_is_requested())
        find_phone_ble_stop();
    else
        find_phone_ble_start();

    ui_BluetoothSettings_refresh();
}

static void bt_settings_pan_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;

    bt_pan_preference = bt_pan_preference ? 0U : 1U;
    ui_BluetoothSettings_refresh();
}

void ui_BluetoothSettings_screen_init(void)
{
    lv_obj_t *frame;
    lv_obj_t *header;
    lv_obj_t *back_button;
    lv_obj_t *back_icon;
    lv_obj_t *title;
    lv_obj_t *divider;
    lv_obj_t *connection_card;
    lv_obj_t *connection_icon_bg;
    lv_obj_t *connection_icon;
    lv_obj_t *bottom_spacer;
    lv_coord_t row_y;

    ui_BluetoothSettings = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_BluetoothSettings, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_BluetoothSettings, lv_color_hex(0x000000),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_BluetoothSettings, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    frame = lv_obj_create(ui_BluetoothSettings);
    lv_obj_set_size(frame, 390, 450);
    lv_obj_align(frame, LV_ALIGN_CENTER, 0, 0);
    lv_obj_clear_flag(frame, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(frame, 45, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(frame, lv_color_hex(BT_SETTINGS_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(frame, LV_OPA_COVER, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(frame, lv_color_hex(BT_SETTINGS_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(frame, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(frame, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(frame, true, LV_PART_MAIN | LV_STATE_DEFAULT);

    header = lv_obj_create(frame);
    lv_obj_set_size(header, 390, 68);
    lv_obj_set_pos(header, 0, 0);
    lv_obj_clear_flag(header, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_opa(header, LV_OPA_TRANSP, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(header, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(header, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    back_button = lv_btn_create(header);
    lv_obj_set_size(back_button, 50, 50);
    lv_obj_set_pos(back_button, 18, 9);
    lv_obj_clear_flag(back_button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(back_button, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(back_button, lv_color_hex(BT_SETTINGS_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_opa(back_button, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_shadow_opa(back_button, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_PRESSED);

    back_icon = lv_label_create(back_button);
    lv_label_set_text(back_icon, LV_SYMBOL_LEFT);
    lv_obj_center(back_icon);
    lv_obj_set_style_text_font(back_icon, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(back_icon, lv_color_hex(BT_SETTINGS_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    title = lv_label_create(header);
    lv_label_set_text(title, "BLUETOOTH");
    lv_obj_set_pos(title, 82, 21);
    lv_obj_set_style_text_font(title, &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_hex(BT_SETTINGS_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    divider = lv_obj_create(frame);
    lv_obj_set_size(divider, BT_SETTINGS_CONTENT_WIDTH, 1);
    lv_obj_set_pos(divider, BT_SETTINGS_CONTENT_MARGIN, 68);
    lv_obj_clear_flag(divider, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(divider, lv_color_hex(BT_SETTINGS_BORDER),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(divider, LV_OPA_COVER, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(divider, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    bt_settings_content = lv_obj_create(frame);
    lv_obj_set_size(bt_settings_content, 390, 381);
    lv_obj_set_pos(bt_settings_content, 0, 69);
    lv_obj_set_scroll_dir(bt_settings_content, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(bt_settings_content, LV_SCROLLBAR_MODE_AUTO);
    lv_obj_add_flag(bt_settings_content, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_bg_opa(bt_settings_content, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(bt_settings_content, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(bt_settings_content, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(bt_settings_content, lv_color_hex(BT_SETTINGS_MUTED),
                              LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(bt_settings_content, LV_OPA_70,
                            LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_width(bt_settings_content, 4,
                           LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(bt_settings_content, LV_RADIUS_CIRCLE,
                            LV_PART_SCROLLBAR | LV_STATE_DEFAULT);

    connection_card = lv_obj_create(bt_settings_content);
    lv_obj_set_size(connection_card, BT_SETTINGS_CONTENT_WIDTH, 100);
    lv_obj_set_pos(connection_card, BT_SETTINGS_CONTENT_MARGIN, 16);
    bt_settings_style_card(connection_card);

    connection_icon_bg = lv_obj_create(connection_card);
    connection_icon = lv_label_create(connection_icon_bg);
    bt_settings_style_icon(connection_icon_bg, connection_icon, LV_SYMBOL_BLUETOOTH,
                           BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG);
    lv_obj_set_pos(connection_icon_bg, 14, 25);

    bt_connection_title = lv_label_create(connection_card);
    lv_obj_set_width(bt_connection_title, 170);
    lv_obj_set_pos(bt_connection_title, 76, 20);
    lv_label_set_long_mode(bt_connection_title, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_font(bt_connection_title, &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(bt_connection_title, lv_color_hex(BT_SETTINGS_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    bt_connection_detail = lv_label_create(connection_card);
    lv_obj_set_width(bt_connection_detail, 170);
    lv_obj_set_pos(bt_connection_detail, 76, 57);
    lv_label_set_long_mode(bt_connection_detail, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_font(bt_connection_detail, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(bt_connection_detail,
                                lv_color_hex(BT_SETTINGS_SECONDARY),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    bt_connection_badge = lv_label_create(connection_card);
    lv_obj_set_size(bt_connection_badge, 98, 30);
    lv_obj_set_pos(bt_connection_badge, 250, 35);
    lv_obj_set_style_text_align(bt_connection_badge, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(bt_connection_badge, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(bt_connection_badge, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(bt_connection_badge, 6,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_top(bt_connection_badge, 7,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    row_y = 138;
    bt_settings_add_section_title(bt_settings_content, row_y, "BLUETOOTH", "DEVICE RADIO");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_toggle_row(bt_settings_content, row_y, LV_SYMBOL_BLUETOOTH,
                               BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG,
                               "Bluetooth", "On · secure pairing enabled", 1U,
                               bt_settings_radio_event, &bt_radio_detail,
                               &bt_radio_switch);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_SECTION_GAP;

    bt_settings_add_section_title(bt_settings_content, row_y, "PHONE CONNECTION",
                                  "ONE PRIMARY PHONE");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_CALL,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "HSP Phone",
                        "BLE connected · companion ready", "CONNECTED", BT_BADGE_BLUE,
                        NULL, &bt_phone_detail, &bt_phone_badge);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_GPS,
                        BT_SETTINGS_AMBER, BT_SETTINGS_AMBER_ICON_BG, "Find phone",
                        "Send a vibration and ring request", "READY", BT_BADGE_BLUE,
                        bt_settings_find_phone_event, &bt_find_phone_detail,
                        &bt_find_phone_badge);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_PLUS,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "Connect new phone",
                        "Use the HSP companion app to connect", "APP", BT_BADGE_MUTED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_TRASH,
                        BT_SETTINGS_RED, BT_SETTINGS_RED_ICON_BG, "Remove pairing",
                        "Available after pairing management is added", "PLANNED",
                        BT_BADGE_RED, NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_SECTION_GAP;

    bt_settings_add_section_title(bt_settings_content, row_y, "APP SYNC",
                                  "PHONE CONNECTION REQUIRED");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_toggle_row(bt_settings_content, row_y, BT_SETTINGS_CLOCK_ICON,
                               BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG,
                               "Time & time zone", "Sync on connect and once daily", 1U,
                               NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_toggle_row(bt_settings_content, row_y, LV_SYMBOL_BATTERY_FULL,
                               BT_SETTINGS_GREEN, BT_SETTINGS_GREEN_ICON_BG,
                               "Battery status", "Share level with companion app", 1U,
                               NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_toggle_row(bt_settings_content, row_y, LV_SYMBOL_TINT,
                               BT_SETTINGS_AMBER, BT_SETTINGS_AMBER_ICON_BG,
                               "Weather", "Phone cached weather sync", 1U,
                               NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_BELL,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "Notifications",
                        "Companion permission and filters", "PLANNED", BT_BADGE_MUTED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_SECTION_GAP;

    bt_settings_add_section_title(bt_settings_content, row_y, "BLUETOOTH AUDIO",
                                  "ENABLE PER MODE");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_AUDIO,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "Music control",
                        "AVRCP phone track and volume", "SOON", BT_BADGE_MUTED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_VOLUME_MAX,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "Bluetooth speaker",
                        "Use watch as A2DP audio output", "SOON", BT_BADGE_MUTED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_CALL,
                        BT_SETTINGS_AMBER, BT_SETTINGS_AMBER_ICON_BG, "Phone calls",
                        "HFP, SCO microphone and AEC", "PLANNED", BT_BADGE_MUTED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_SECTION_GAP;

    bt_settings_add_section_title(bt_settings_content, row_y, "BLUETOOTH NETWORK",
                                  "MANUAL, HIGH POWER");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_toggle_row(bt_settings_content, row_y, LV_SYMBOL_WIFI,
                               BT_SETTINGS_AMBER, BT_SETTINGS_AMBER_ICON_BG,
                               "PAN network", "Off · use only for an active request", 0U,
                               bt_settings_pan_event, &bt_pan_detail, &bt_pan_switch);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_REFRESH,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG, "Network refresh",
                        "Weather, NTP or MQTT on demand", "OFF", BT_BADGE_MUTED,
                        NULL, NULL, &bt_pan_badge);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_SECTION_GAP;

    bt_settings_add_section_title(bt_settings_content, row_y, "ADVANCED",
                                  "CONNECTION BEHAVIOR");
    row_y += BT_SETTINGS_SECTION_HEIGHT;
    bt_settings_add_toggle_row(bt_settings_content, row_y, LV_SYMBOL_LOOP,
                               BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG,
                               "Auto reconnect", "Reconnect to primary phone", 1U,
                               NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_SETTINGS,
                        BT_SETTINGS_BLUE, BT_SETTINGS_BLUE_ICON_BG,
                        "Bluetooth diagnostics", "RSSI, services and reconnect count",
                        "SOON", BT_BADGE_MUTED, NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT + BT_SETTINGS_ROW_GAP;
    bt_settings_add_row(bt_settings_content, row_y, LV_SYMBOL_TRASH,
                        BT_SETTINGS_RED, BT_SETTINGS_RED_ICON_BG, "Clear all pairings",
                        "Remove saved Bluetooth credentials", "PLANNED", BT_BADGE_RED,
                        NULL, NULL, NULL);
    row_y += BT_SETTINGS_ROW_HEIGHT;

    /* Leave enough scroll room for the last card above the lower rounded edge. */
    bottom_spacer = lv_obj_create(bt_settings_content);
    lv_obj_set_size(bottom_spacer, 1, 45);
    lv_obj_set_pos(bottom_spacer, 0, row_y);
    lv_obj_clear_flag(bottom_spacer, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_opa(bottom_spacer, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(bottom_spacer, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(bottom_spacer, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(back_button, bt_settings_return_event, LV_EVENT_CLICKED, NULL);
    lv_obj_add_event_cb(ui_BluetoothSettings, bt_settings_screen_event, LV_EVENT_ALL, NULL);

    ui_BluetoothSettings_refresh();
}

void ui_BluetoothSettings_screen_destroy(void)
{
    bt_settings_stop_refresh_timer();
    if (ui_BluetoothSettings != NULL)
        lv_obj_del(ui_BluetoothSettings);

    ui_BluetoothSettings = NULL;
    bt_settings_content = NULL;
    bt_connection_title = NULL;
    bt_connection_detail = NULL;
    bt_connection_badge = NULL;
    bt_radio_detail = NULL;
    bt_radio_switch = NULL;
    bt_phone_detail = NULL;
    bt_phone_badge = NULL;
    bt_find_phone_detail = NULL;
    bt_find_phone_badge = NULL;
    bt_pan_detail = NULL;
    bt_pan_badge = NULL;
    bt_pan_switch = NULL;
}
