/* Home-only pages opened by vertical gestures. */

#include "home_gestures.h"
#include "hsp_font_cjk_22.h"
#include "ui.h"
#include "bluetooth/find_phone_ble.h"
#include "bluetooth/pan.h"
#include "bluetooth/music_app.h"
#include "drivers/display_power.h"
#include "services/phone_notifications.h"
#include "services/wrist_wake.h"

#define HOME_GESTURE_SCREEN_BG      0x0B0D11
#define HOME_GESTURE_PANEL_BG       0x050607
#define HOME_GESTURE_PANEL_BORDER   0x293340
#define HOME_GESTURE_CARD_BG        0x14181E
#define HOME_GESTURE_CARD_PRESSED   0x252C35
#define HOME_GESTURE_CARD_BORDER    0x303A46
#define HOME_GESTURE_TEXT           0xF5F7FA
#define HOME_GESTURE_MUTED          0x8A96A5
#define HOME_GESTURE_GOLD           0xF4C86A
#define HOME_GESTURE_BLUE           0x2F9BFF
#define HOME_GESTURE_GREEN          0x65CE8C
#define HOME_GESTURE_PURPLE         0xAE7BFF
#define HOME_GESTURE_RED            0xFF5C6C
#define HOME_GESTURE_ICON_PART_MAX  (6U)
#define HOME_NOTIFICATION_PREVIEW_MAX_BYTES (96U)

static lv_obj_t *controls_screen;
static lv_obj_t *notifications_screen;
static lv_obj_t *notifications_list;
static lv_obj_t *notifications_summary;
static lv_obj_t *notification_detail_screen;
static uint16_t notification_detail_id;
static lv_obj_t *control_bluetooth_value;
static lv_obj_t *control_silent_value;
static lv_obj_t *control_light_value;
static lv_obj_t *control_wrist_value;
static lv_obj_t *control_find_phone_value;
static lv_obj_t *control_low_power_value;
static lv_obj_t *control_brightness_value;
static lv_obj_t *control_volume_value;
static lv_obj_t *control_brightness_slider;
static lv_obj_t *control_volume_slider;
static lv_timer_t *control_refresh_timer;
static lv_timer_t *notifications_refresh_timer;
static uint32_t notifications_revision;
static phone_notification_snapshot_t notifications_snapshot;
static phone_notification_t notification_detail_item;
static uint8_t control_low_power_enabled;

typedef enum
{
    HOME_CONTROL_ICON_KIND_SYMBOL,
    HOME_CONTROL_ICON_KIND_HAND,
    HOME_CONTROL_ICON_KIND_BULB,
    HOME_CONTROL_ICON_KIND_PHONE,
} home_control_icon_kind_t;

typedef struct
{
    lv_obj_t *object;
    lv_obj_t *parts[HOME_GESTURE_ICON_PART_MAX];
    uint8_t part_count;
} home_control_icon_ref_t;

static home_control_icon_ref_t control_bluetooth_icon;
static home_control_icon_ref_t control_silent_icon;
static home_control_icon_ref_t control_light_icon;
static home_control_icon_ref_t control_wrist_icon;
static home_control_icon_ref_t control_find_phone_icon;
static home_control_icon_ref_t control_low_power_icon;

static void home_gestures_open_notification_detail(uint16_t id);

static void home_gestures_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void home_gestures_return_home(lv_scr_load_anim_t animation)
{
    home_gestures_wait_release();
    _ui_screen_change(&ui_ScreenHome, animation, 200, 0,
                      &ui_ScreenHome_screen_init);
}

static lv_obj_t *home_gestures_create_panel(lv_obj_t **screen)
{
    lv_obj_t *panel;

    *screen = lv_obj_create(NULL);
    lv_obj_clear_flag(*screen, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(*screen, lv_color_hex(HOME_GESTURE_SCREEN_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(*screen, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    panel = lv_obj_create(*screen);
    lv_obj_set_size(panel, 390, 450);
    lv_obj_align(panel, LV_ALIGN_CENTER, 0, 0);
    lv_obj_clear_flag(panel, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(panel, 45, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(panel, lv_color_hex(HOME_GESTURE_PANEL_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(panel, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(panel, lv_color_hex(HOME_GESTURE_PANEL_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(panel, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(panel, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(panel, true, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_flag(panel, LV_OBJ_FLAG_GESTURE_BUBBLE);

    return panel;
}

static void home_gestures_style_card(lv_obj_t *object)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(object, lv_color_hex(HOME_GESTURE_CARD_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(object, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(object, lv_color_hex(HOME_GESTURE_CARD_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(object, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_opa(object, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_flag(object, LV_OBJ_FLAG_GESTURE_BUBBLE);
}

static void home_gestures_add_header(lv_obj_t *panel, const char *symbol,
                                     const char *title, lv_event_cb_t back_cb)
{
    lv_obj_t *back_button = lv_btn_create(panel);
    lv_obj_t *back_icon = lv_label_create(back_button);
    lv_obj_t *title_label = lv_label_create(panel);
    lv_obj_t *divider = lv_obj_create(panel);

    lv_obj_set_size(back_button, 42, 42);
    lv_obj_set_pos(back_button, 22, 12);
    lv_obj_clear_flag(back_button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(back_button, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(back_button, lv_color_hex(HOME_GESTURE_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_text(back_icon, LV_SYMBOL_LEFT);
    lv_obj_center(back_icon);
    lv_obj_set_style_text_font(back_icon, &lv_font_montserrat_20,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(back_icon, lv_color_hex(HOME_GESTURE_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(back_button, back_cb, LV_EVENT_CLICKED, NULL);

    if (symbol != NULL && symbol[0] != '\0')
        lv_label_set_text_fmt(title_label, "%s  %s", symbol, title);
    else
        lv_label_set_text(title_label, title);
    lv_obj_set_pos(title_label, 73, 24);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(HOME_GESTURE_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_size(divider, 354, 1);
    lv_obj_set_pos(divider, 18, 65);
    lv_obj_clear_flag(divider, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(divider, lv_color_hex(HOME_GESTURE_PANEL_BORDER),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(divider, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(divider, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *home_gestures_add_row(lv_obj_t *parent, lv_coord_t y,
                                       const char *symbol, const char *title,
                                       const char *value, lv_color_t color,
                                       lv_event_cb_t event_cb,
                                       lv_obj_t **value_out)
{
    lv_obj_t *row = event_cb != NULL ? lv_btn_create(parent) : lv_obj_create(parent);
    lv_obj_t *icon = lv_label_create(row);
    lv_obj_t *title_label = lv_label_create(row);
    lv_obj_t *value_label = lv_label_create(row);
    lv_obj_t *arrow = lv_label_create(row);

    lv_obj_set_size(row, 354, 56);
    lv_obj_set_pos(row, 18, y);
    home_gestures_style_card(row);

    if (event_cb != NULL)
    {
        lv_obj_set_style_bg_color(row, lv_color_hex(HOME_GESTURE_CARD_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_set_style_bg_opa(row, LV_OPA_COVER,
                                LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_add_event_cb(row, event_cb, LV_EVENT_CLICKED, NULL);
    }

    lv_label_set_text(icon, symbol);
    lv_obj_set_pos(icon, 16, 18);
    lv_obj_set_style_text_font(icon, &lv_font_montserrat_20,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(icon, color, LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_label_set_text(title_label, title);
    lv_obj_set_pos(title_label, 52, 10);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(HOME_GESTURE_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_label_set_text(value_label, value);
    lv_obj_set_pos(value_label, 52, 31);
    lv_obj_set_style_text_font(value_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(value_label, lv_color_hex(HOME_GESTURE_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_label_set_text(arrow, event_cb != NULL ? LV_SYMBOL_RIGHT : "");
    lv_obj_set_pos(arrow, 321, 19);
    lv_obj_set_style_text_font(arrow, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(arrow, lv_color_hex(HOME_GESTURE_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    if (value_out != NULL)
        *value_out = value_label;

    return row;
}

static void home_gestures_style_icon_part(lv_obj_t *object, lv_color_t color)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_opa(object, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(object, color,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(object, 2, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *home_gestures_add_icon_part(lv_obj_t *parent,
                                             lv_coord_t x, lv_coord_t y,
                                             lv_coord_t width, lv_coord_t height,
                                             lv_color_t color, int filled,
                                             home_control_icon_ref_t *icon_ref)
{
    lv_obj_t *part = lv_obj_create(parent);

    lv_obj_set_size(part, width, height);
    lv_obj_set_pos(part, x, y);
    home_gestures_style_icon_part(part, color);
    lv_obj_set_style_radius(part, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    if (filled)
    {
        lv_obj_set_style_bg_color(part, color, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_bg_opa(part, LV_OPA_COVER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_border_width(part, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    }

    if (icon_ref != NULL && icon_ref->part_count < HOME_GESTURE_ICON_PART_MAX)
        icon_ref->parts[icon_ref->part_count++] = part;

    return part;
}

static void home_gestures_add_hand_icon(lv_obj_t *parent, lv_color_t color,
                                        home_control_icon_ref_t *icon_ref)
{
    /* Finger bars and palm create a recognisable wrist-wake hand at 28 px. */
    home_gestures_add_icon_part(parent, 16, 18, 19, 16, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 16, 8, 4, 15, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 21, 5, 4, 18, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 26, 7, 4, 16, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 31, 11, 4, 12, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 11, 20, 9, 4, color, 0, icon_ref);
}

static void home_gestures_add_bulb_icon(lv_obj_t *parent, lv_color_t color,
                                        home_control_icon_ref_t *icon_ref)
{
    home_gestures_add_icon_part(parent, 14, 7, 20, 20, color, 0, icon_ref);
    home_gestures_add_icon_part(parent, 18, 28, 10, 3, color, 1, icon_ref);
    home_gestures_add_icon_part(parent, 19, 33, 8, 3, color, 1, icon_ref);
    home_gestures_add_icon_part(parent, 22, 4, 2, 4, color, 1, icon_ref);
    home_gestures_add_icon_part(parent, 7, 15, 4, 2, color, 1, icon_ref);
    home_gestures_add_icon_part(parent, 35, 15, 4, 2, color, 1, icon_ref);
}

static void home_gestures_add_phone_icon(lv_obj_t *parent, lv_color_t color,
                                         home_control_icon_ref_t *icon_ref)
{
    lv_obj_t *body = home_gestures_add_icon_part(parent, 13, 2, 20, 32, color, 0,
                                                  icon_ref);

    lv_obj_set_style_radius(body, 4, LV_PART_MAIN | LV_STATE_DEFAULT);
    home_gestures_add_icon_part(parent, 19, 8, 8, 2, color, 1, icon_ref);
    home_gestures_add_icon_part(parent, 21, 28, 4, 2, color, 1, icon_ref);
}

static void home_gestures_set_control_icon_color(home_control_icon_ref_t *icon_ref,
                                                 lv_color_t color)
{
    uint8_t index;

    if (icon_ref->object == NULL)
        return;

    lv_obj_set_style_text_color(icon_ref->object, color,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    for (index = 0; index < icon_ref->part_count; index++)
    {
        lv_obj_set_style_bg_color(icon_ref->parts[index], color,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_border_color(icon_ref->parts[index], color,
                                      LV_PART_MAIN | LV_STATE_DEFAULT);
    }
}

static void home_gestures_add_control_icon(lv_obj_t *tile, const char *symbol,
                                           home_control_icon_kind_t icon_type,
                                           lv_color_t color,
                                           home_control_icon_ref_t *icon_ref)
{
    icon_ref->object = NULL;
    icon_ref->part_count = 0U;

    if (icon_type == HOME_CONTROL_ICON_KIND_SYMBOL)
    {
        lv_obj_t *icon = lv_label_create(tile);

        lv_label_set_text(icon, symbol);
        lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 10);
        lv_obj_set_style_text_font(icon, &lv_font_montserrat_28,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_color(icon, color, LV_PART_MAIN | LV_STATE_DEFAULT);
        icon_ref->object = icon;
    }
    else
    {
        lv_obj_t *icon = lv_obj_create(tile);

        lv_obj_set_size(icon, 46, 38);
        lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 4);
        lv_obj_clear_flag(icon, LV_OBJ_FLAG_SCROLLABLE);
        lv_obj_set_style_bg_opa(icon, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_border_width(icon, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_outline_width(icon, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_shadow_width(icon, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_pad_all(icon, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        icon_ref->object = icon;

        if (icon_type == HOME_CONTROL_ICON_KIND_HAND)
            home_gestures_add_hand_icon(icon, color, icon_ref);
        else if (icon_type == HOME_CONTROL_ICON_KIND_BULB)
            home_gestures_add_bulb_icon(icon, color, icon_ref);
        else if (icon_type == HOME_CONTROL_ICON_KIND_PHONE)
            home_gestures_add_phone_icon(icon, color, icon_ref);
    }
}

static lv_obj_t *home_gestures_add_control_tile(lv_obj_t *parent,
                                                lv_coord_t x, lv_coord_t y,
                                                const char *symbol,
                                                home_control_icon_kind_t icon_type,
                                                const char *title,
                                                const char *value,
                                                lv_color_t icon_color,
                                                lv_event_cb_t event_cb,
                                                lv_obj_t **value_out,
                                                home_control_icon_ref_t *icon_out)
{
    lv_obj_t *tile = event_cb != NULL ? lv_btn_create(parent) : lv_obj_create(parent);
    lv_obj_t *title_label = lv_label_create(tile);
    lv_obj_t *value_label = lv_label_create(tile);

    lv_obj_set_size(tile, 108, 106);
    lv_obj_set_pos(tile, x, y);
    home_gestures_style_card(tile);

    if (event_cb != NULL)
    {
        lv_obj_set_style_bg_color(tile, lv_color_hex(HOME_GESTURE_CARD_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_set_style_bg_opa(tile, LV_OPA_COVER,
                                LV_PART_MAIN | LV_STATE_PRESSED);
        /* Keep a long press separate from the normal tile action. */
        lv_obj_add_event_cb(tile, event_cb, LV_EVENT_SHORT_CLICKED, NULL);
    }

    home_gestures_add_control_icon(tile, symbol, icon_type, icon_color, icon_out);

    lv_obj_set_width(title_label, 104);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 62);
    lv_label_set_text(title_label, title);
    lv_obj_set_style_text_align(title_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(HOME_GESTURE_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_width(value_label, 104);
    lv_obj_align(value_label, LV_ALIGN_TOP_MID, 0, 84);
    lv_label_set_text(value_label, value);
    lv_obj_set_style_text_align(value_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(value_label, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(value_label, lv_color_hex(HOME_GESTURE_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    if (value_out != NULL)
        *value_out = value_label;

    return tile;
}

static lv_obj_t *home_gestures_add_slider(lv_obj_t *parent, lv_coord_t y,
                                          const char *title,
                                          lv_event_cb_t event_cb,
                                          lv_obj_t **slider_out,
                                          lv_obj_t **value_out)
{
    lv_obj_t *title_label = lv_label_create(parent);
    lv_obj_t *value_label = lv_label_create(parent);
    lv_obj_t *slider = lv_slider_create(parent);

    lv_label_set_text(title_label, title);
    lv_obj_set_pos(title_label, 24, y);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title_label, lv_color_hex(HOME_GESTURE_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_width(value_label, 60);
    lv_obj_set_pos(value_label, 302, y);
    lv_obj_set_style_text_align(value_label, LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(value_label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(value_label, lv_color_hex(HOME_GESTURE_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_set_size(slider, 326, 14);
    lv_obj_set_pos(slider, 24, y + 32);
    lv_slider_set_range(slider, 1, 100);
    lv_obj_add_flag(slider, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_radius(slider, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(slider, lv_color_hex(0x3A4351),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(slider, lv_color_hex(HOME_GESTURE_BLUE),
                              LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(slider, LV_RADIUS_CIRCLE,
                            LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(slider, lv_color_hex(HOME_GESTURE_BLUE),
                              LV_PART_KNOB | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(slider, lv_color_hex(HOME_GESTURE_TEXT),
                                  LV_PART_KNOB | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(slider, 3, LV_PART_KNOB | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(slider, 3, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(slider, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(slider, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(slider, event_cb, LV_EVENT_VALUE_CHANGED, NULL);

    if (slider_out != NULL)
        *slider_out = slider;
    if (value_out != NULL)
        *value_out = value_label;

    return slider;
}

static void home_gestures_refresh_controls(void)
{
    music_app_snapshot_t music_snapshot;
    uint8_t brightness;
    uint8_t volume_percent;

    if (controls_screen == NULL)
        return;

    if (control_bluetooth_value != NULL)
    {
        int enabled = bt_pan_is_enabled() != 0;
        int connected = bt_pan_is_connected() != 0;

        lv_label_set_text(control_bluetooth_value, !enabled ? "OFF" :
                          connected ? "CONNECTED" : "ON");
        lv_obj_set_style_text_color(control_bluetooth_value,
                                    enabled ? lv_color_hex(HOME_GESTURE_BLUE) :
                                              lv_color_hex(HOME_GESTURE_MUTED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_bluetooth_icon,
                                             enabled ? lv_color_hex(HOME_GESTURE_BLUE) :
                                                       lv_color_hex(HOME_GESTURE_MUTED));
    }

    if (control_silent_value != NULL)
    {
        int muted = music_app_is_speaker_muted();

        lv_label_set_text(control_silent_value, muted ? "ON" : "OFF");
        lv_obj_set_style_text_color(control_silent_value,
                                    muted ? lv_color_hex(HOME_GESTURE_BLUE) :
                                            lv_color_hex(HOME_GESTURE_MUTED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_silent_icon,
                                             muted ? lv_color_hex(HOME_GESTURE_MUTED) :
                                                     lv_color_hex(HOME_GESTURE_GOLD));
    }

    if (control_light_value != NULL)
    {
        lv_label_set_text(control_light_value, led_is_enabled() ? "ON" : "OFF");
        lv_obj_set_style_text_color(control_light_value,
                                    led_is_enabled() ? lv_color_hex(HOME_GESTURE_GREEN) :
                                                       lv_color_hex(HOME_GESTURE_MUTED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_light_icon,
                                             led_is_enabled() ?
                                             lv_color_hex(HOME_GESTURE_GREEN) :
                                             lv_color_hex(HOME_GESTURE_MUTED));
    }

    if (control_wrist_value != NULL)
    {
        lv_label_set_text(control_wrist_value,
                          wrist_wake_is_enabled() ? "ON" : "OFF");
        lv_obj_set_style_text_color(control_wrist_value,
                                    wrist_wake_is_enabled() ?
                                    lv_color_hex(HOME_GESTURE_BLUE) :
                                    lv_color_hex(HOME_GESTURE_MUTED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_wrist_icon,
                                             wrist_wake_is_enabled() ?
                                             lv_color_hex(HOME_GESTURE_BLUE) :
                                             lv_color_hex(HOME_GESTURE_MUTED));
    }

    if (control_find_phone_value != NULL)
    {
        uint8_t requested = find_phone_ble_is_requested();
        uint8_t connected = find_phone_ble_is_connected();
        const char *value = !requested ? (connected ? "READY" : "OFF") :
                            (find_phone_ble_is_scanning() ? "SEARCH" : "ON");
        lv_color_t color = (requested || connected) ?
                           lv_color_hex(HOME_GESTURE_PURPLE) :
                           lv_color_hex(HOME_GESTURE_MUTED);

        lv_label_set_text(control_find_phone_value, value);
        lv_obj_set_style_text_color(control_find_phone_value,
                                    color,
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_find_phone_icon,
                                             color);
    }

    if (control_low_power_value != NULL)
    {
        lv_label_set_text(control_low_power_value,
                          control_low_power_enabled ? "ON" : "OFF");
        lv_obj_set_style_text_color(control_low_power_value,
                                    control_low_power_enabled ?
                                    lv_color_hex(HOME_GESTURE_RED) :
                                    lv_color_hex(HOME_GESTURE_MUTED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        home_gestures_set_control_icon_color(&control_low_power_icon,
                                             control_low_power_enabled ?
                                             lv_color_hex(HOME_GESTURE_RED) :
                                             lv_color_hex(HOME_GESTURE_MUTED));
    }

    brightness = display_power_get_brightness();
    if (control_brightness_slider != NULL &&
        lv_slider_get_value(control_brightness_slider) != brightness)
        lv_slider_set_value(control_brightness_slider, brightness, LV_ANIM_OFF);
    if (control_brightness_value != NULL)
        lv_label_set_text_fmt(control_brightness_value, "%u%%", (unsigned int)brightness);

    music_app_get_snapshot(&music_snapshot);
    volume_percent = music_snapshot.volume_valid ?
                     (uint8_t)((music_snapshot.volume * 100U + 63U) / 127U) : 50U;
    if (control_volume_slider != NULL &&
        lv_slider_get_value(control_volume_slider) != volume_percent)
        lv_slider_set_value(control_volume_slider, volume_percent, LV_ANIM_OFF);
    if (control_volume_value != NULL)
        lv_label_set_text_fmt(control_volume_value, "%u%%",
                              (unsigned int)volume_percent);
}

static void home_gestures_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    home_gestures_refresh_controls();
}

static void home_gestures_controls_back(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        home_gestures_return_home(LV_SCR_LOAD_ANIM_MOVE_TOP);
}

static void home_gestures_notifications_back(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        home_gestures_return_home(LV_SCR_LOAD_ANIM_MOVE_BOTTOM);
}

static void home_gestures_close_notification_detail(void)
{
    lv_obj_t *detail_screen = notification_detail_screen;

    if (notifications_screen == NULL)
        return;

    notification_detail_screen = NULL;
    notification_detail_id = 0U;
    home_gestures_wait_release();
    lv_scr_load_anim(notifications_screen, LV_SCR_LOAD_ANIM_MOVE_RIGHT,
                     200, 0, false);
    if (detail_screen != NULL)
        lv_obj_del_delayed(detail_screen, 250U);
}

static void home_gestures_notification_detail_back(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED ||
        notifications_screen == NULL)
        return;

    home_gestures_close_notification_detail();
}

static void home_gestures_delete_notification(uint16_t id)
{
    if (phone_notifications_remove(id) != RT_EOK)
        return;

    find_phone_ble_delete_notification(id);
}

static void home_gestures_notifications_clear(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;

    phone_notifications_clear();
    find_phone_ble_clear_notifications();
}

static void home_gestures_light_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        on_led_toggle(event);
        home_gestures_refresh_controls();
    }
    else if (lv_event_get_code(event) == LV_EVENT_LONG_PRESSED)
    {
        ui_Screen4_open_from_controls();
    }
}

static void home_gestures_bluetooth_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        bt_pan_set_enabled(!bt_pan_is_enabled());
        home_gestures_refresh_controls();
    }
    else if (lv_event_get_code(event) == LV_EVENT_LONG_PRESSED)
    {
        ui_BluetoothSettings_open_from_controls();
    }
}

static void home_gestures_silent_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        music_app_set_speaker_muted(!music_app_is_speaker_muted());
        home_gestures_refresh_controls();
    }
}

static void home_gestures_find_phone_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        if (find_phone_ble_is_requested())
            find_phone_ble_stop();
        else
            find_phone_ble_start();
        home_gestures_refresh_controls();
    }
}

static void home_gestures_low_power_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        /* UI-only state until low-power policy is connected here. */
        control_low_power_enabled = !control_low_power_enabled;
        home_gestures_refresh_controls();
    }
}

static void home_gestures_wrist_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_SHORT_CLICKED)
    {
        wrist_wake_set_enabled(!wrist_wake_is_enabled());
        home_gestures_refresh_controls();
    }
}

static void home_gestures_brightness_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_VALUE_CHANGED)
    {
        display_power_set_brightness((uint8_t)lv_slider_get_value(lv_event_get_target(event)));
        home_gestures_refresh_controls();
    }
}

static void home_gestures_volume_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_VALUE_CHANGED)
    {
        uint8_t percent = (uint8_t)lv_slider_get_value(lv_event_get_target(event));
        uint8_t volume = (uint8_t)((percent * 127U + 50U) / 100U);

        music_app_set_volume(volume);
        home_gestures_refresh_controls();
    }
}

static void home_gestures_controls_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_GESTURE &&
        lv_indev_get_gesture_dir(lv_indev_get_act()) == LV_DIR_TOP)
    {
        home_gestures_return_home(LV_SCR_LOAD_ANIM_MOVE_TOP);
    }
}

static void home_gestures_notifications_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_GESTURE &&
        lv_indev_get_gesture_dir(lv_indev_get_act()) == LV_DIR_BOTTOM)
    {
        home_gestures_return_home(LV_SCR_LOAD_ANIM_MOVE_BOTTOM);
    }
}

static const char *home_gestures_notification_source(uint8_t app)
{
    switch (app)
    {
    case PHONE_NOTIFICATION_APP_SMS:
        return "SMS";
    case PHONE_NOTIFICATION_APP_WECHAT:
        return "WECHAT";
    case PHONE_NOTIFICATION_APP_QQ:
        return "QQ";
    default:
        return "PHONE";
    }
}

static uint8_t home_gestures_find_notification(uint16_t id,
                                               phone_notification_t *item)
{
    if (id == 0U || item == NULL)
        return 0U;

    return phone_notifications_get(id, item) == RT_EOK ? 1U : 0U;
}

static void home_gestures_notification_preview(char *preview,
                                               uint16_t preview_size,
                                               const char *text,
                                               uint16_t text_len)
{
    uint16_t read_pos = 0U;
    uint16_t write_pos = 0U;
    uint16_t copy_limit;

    if (preview == NULL || preview_size == 0U)
        return;

    preview[0] = '\0';
    if (text == NULL || text_len == 0U)
        return;

    copy_limit = preview_size > 4U ? (uint16_t)(preview_size - 4U) : 0U;
    while (read_pos < text_len && text[read_pos] != '\0')
    {
        const uint8_t lead = (uint8_t)text[read_pos];
        uint16_t char_len = 1U;
        uint16_t offset;

        if (lead >= 0xC2U && lead <= 0xDFU)
            char_len = 2U;
        else if (lead >= 0xE0U && lead <= 0xEFU)
            char_len = 3U;
        else if (lead >= 0xF0U && lead <= 0xF4U)
            char_len = 4U;

        if ((uint16_t)(read_pos + char_len) > text_len)
            char_len = 1U;
        else
        {
            for (offset = 1U; offset < char_len; offset++)
            {
                if (((uint8_t)text[read_pos + offset] & 0xC0U) != 0x80U)
                {
                    char_len = 1U;
                    break;
                }
            }
        }

        if ((uint16_t)(write_pos + char_len) > copy_limit)
            break;

        for (offset = 0U; offset < char_len; offset++)
            preview[write_pos++] = text[read_pos++];
    }

    if (read_pos < text_len && text[read_pos] != '\0' &&
        (uint16_t)(write_pos + 3U) < preview_size)
    {
        preview[write_pos++] = '.';
        preview[write_pos++] = '.';
        preview[write_pos++] = '.';
    }
    preview[write_pos] = '\0';
}

static void home_gestures_notification_card_event(lv_event_t *event)
{
    uint16_t id = (uint16_t)(uintptr_t)lv_event_get_user_data(event);

    if (lv_event_get_code(event) == LV_EVENT_GESTURE)
    {
        lv_indev_t *indev = lv_indev_get_act();

        if (indev != NULL && lv_indev_get_gesture_dir(indev) == LV_DIR_LEFT)
        {
            lv_event_stop_bubbling(event);
            lv_indev_wait_release(indev);
            home_gestures_delete_notification(id);
        }
    }
    else if (lv_event_get_code(event) == LV_EVENT_CLICKED)
    {
        home_gestures_open_notification_detail(id);
    }
}

static void home_gestures_add_notification_card(lv_obj_t *parent,
                                                const phone_notification_t *item)
{
    lv_obj_t *card;
    lv_obj_t *source;
    lv_obj_t *time;
    lv_obj_t *title;
    lv_obj_t *body;
    const char *title_text;
    const char *body_text;
    char body_preview[HOME_NOTIFICATION_PREVIEW_MAX_BYTES + 1U];

    if (parent == NULL || item == NULL || !item->valid)
        return;

    title_text = item->title_len > 0U ? item->title :
                 home_gestures_notification_source(item->app);
    if (item->body_len > 0U)
    {
        home_gestures_notification_preview(body_preview,
                                           sizeof(body_preview),
                                           item->body, item->body_len);
        body_text = body_preview;
    }
    else
    {
        body_text = "New notification";
    }

    card = lv_btn_create(parent);
    lv_obj_set_size(card, 354, 138);
    home_gestures_style_card(card);
    lv_obj_set_style_pad_all(card, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(card, lv_color_hex(HOME_GESTURE_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(card, home_gestures_notification_card_event,
                        LV_EVENT_ALL, (void *)(uintptr_t)item->id);

    source = lv_label_create(card);
    lv_label_set_text(source, home_gestures_notification_source(item->app));
    lv_obj_set_pos(source, 18, 12);
    lv_obj_set_style_text_font(source, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(source, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    time = lv_label_create(card);
    lv_label_set_text_fmt(time, "%02u:%02u", (unsigned int)item->hour,
                          (unsigned int)item->minute);
    lv_obj_align(time, LV_ALIGN_TOP_RIGHT, -18, 12);
    lv_obj_set_style_text_font(time, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(time, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    title = lv_label_create(card);
    lv_label_set_text(title, title_text);
    lv_label_set_long_mode(title, LV_LABEL_LONG_DOT);
    lv_obj_set_size(title, 318, 29);
    lv_obj_set_pos(title, 18, 39);
    lv_obj_set_style_text_font(title, &hsp_font_cjk_22,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    body = lv_label_create(card);
    lv_label_set_text(body, body_text);
    lv_label_set_long_mode(body, LV_LABEL_LONG_WRAP);
    lv_obj_set_size(body, 318, 58);
    lv_obj_set_pos(body, 18, 73);
    lv_obj_set_style_text_font(body, &hsp_font_cjk_22,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(body, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void home_gestures_refresh_notifications(void)
{
    uint32_t revision;
    uint8_t index;

    if (notifications_list == NULL || notifications_summary == NULL)
        return;

    revision = phone_notifications_get_revision();
    if (revision == notifications_revision)
        return;

    phone_notifications_get_snapshot(&notifications_snapshot);
    notifications_revision = notifications_snapshot.revision;
    lv_obj_clean(notifications_list);
    if (notifications_snapshot.count == 0U)
    {
        lv_obj_t *empty = lv_obj_create(notifications_list);
        lv_obj_t *icon = lv_label_create(empty);
        lv_obj_t *headline = lv_label_create(empty);
        lv_obj_t *detail = lv_label_create(empty);

        lv_label_set_text(notifications_summary, "NO RECENT MESSAGES");
        lv_obj_set_size(empty, 354, 330);
        lv_obj_clear_flag(empty, LV_OBJ_FLAG_SCROLLABLE);
        lv_obj_set_style_bg_opa(empty, LV_OPA_TRANSP,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_border_width(empty, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_pad_all(empty, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_label_set_text(icon, LV_SYMBOL_BELL);
        lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 58);
        lv_obj_set_style_text_font(icon, &lv_font_montserrat_48,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_color(icon, lv_color_white(),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);

        lv_label_set_text(headline, "NO MESSAGES");
        lv_obj_align(headline, LV_ALIGN_TOP_MID, 0, 128);
        lv_obj_set_style_text_font(headline, &lv_font_montserrat_24,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_color(headline, lv_color_white(),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);

        lv_label_set_text(detail, "SMS, WECHAT AND QQ APPEAR HERE");
        lv_obj_align(detail, LV_ALIGN_TOP_MID, 0, 171);
        lv_obj_set_style_text_font(detail, &lv_font_montserrat_16,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_color(detail, lv_color_white(),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        return;
    }

    lv_label_set_text_fmt(notifications_summary, "%u RECENT MESSAGE%s",
                          (unsigned int)notifications_snapshot.count,
                          notifications_snapshot.count == 1U ? "" : "S");
    for (index = notifications_snapshot.count; index > 0U; index--)
        home_gestures_add_notification_card(notifications_list,
                                            &notifications_snapshot.items[index - 1U]);
}

static void home_gestures_notifications_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    home_gestures_refresh_notifications();
}

static void home_gestures_notification_detail_event(lv_event_t *event)
{
    lv_indev_t *indev;

    if (lv_event_get_code(event) != LV_EVENT_GESTURE)
        return;

    indev = lv_indev_get_act();
    if (indev == NULL || lv_indev_get_gesture_dir(indev) != LV_DIR_LEFT)
        return;

    lv_event_stop_bubbling(event);
    lv_indev_wait_release(indev);
    home_gestures_delete_notification(notification_detail_id);
    home_gestures_close_notification_detail();
}

static void home_gestures_open_notification_detail(uint16_t id)
{
    const phone_notification_t *item = &notification_detail_item;
    lv_obj_t *panel;
    lv_obj_t *metadata;
    lv_obj_t *content;
    lv_obj_t *title;
    lv_obj_t *body;

    if (!home_gestures_find_notification(id, &notification_detail_item))
        return;

    if (notification_detail_screen != NULL)
        lv_obj_del(notification_detail_screen);
    notification_detail_screen = NULL;
    notification_detail_id = id;
    panel = home_gestures_create_panel(&notification_detail_screen);
    home_gestures_add_header(panel, "", "MESSAGE",
                             home_gestures_notification_detail_back);

    metadata = lv_label_create(panel);
    lv_label_set_text_fmt(metadata, "%s    %02u:%02u",
                          home_gestures_notification_source(item->app),
                          (unsigned int)item->hour, (unsigned int)item->minute);
    lv_obj_set_pos(metadata, 20, 78);
    lv_obj_set_style_text_font(metadata, &lv_font_montserrat_18,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(metadata, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    content = lv_obj_create(panel);
    lv_obj_set_size(content, 354, 326);
    lv_obj_set_pos(content, 18, 106);
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_scroll_dir(content, LV_DIR_VER);
    lv_obj_add_flag(content, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_radius(content, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(content, 14, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_row(content, 18, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(content, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_width(content, 3,
                           LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(content, lv_color_white(),
                              LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(content, LV_OPA_50,
                            LV_PART_SCROLLBAR | LV_STATE_DEFAULT);

    title = lv_label_create(content);
    lv_label_set_text(title, item->title_len > 0U ? item->title :
                      home_gestures_notification_source(item->app));
    lv_label_set_long_mode(title, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(title, 326);
    lv_obj_set_height(title, LV_SIZE_CONTENT);
    lv_obj_set_style_text_font(title, &hsp_font_cjk_22,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    body = lv_label_create(content);
    lv_label_set_text(body, item->body_len > 0U ? item->body : "New notification");
    lv_label_set_long_mode(body, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(body, 326);
    lv_obj_set_height(body, LV_SIZE_CONTENT);
    lv_obj_set_style_text_font(body, &hsp_font_cjk_22,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(body, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(notification_detail_screen,
                        home_gestures_notification_detail_event,
                        LV_EVENT_GESTURE, NULL);
    home_gestures_wait_release();
    lv_scr_load_anim(notification_detail_screen, LV_SCR_LOAD_ANIM_MOVE_LEFT,
                     200, 0, false);
}

static void home_gestures_create_controls(void)
{
    lv_obj_t *panel = home_gestures_create_panel(&controls_screen);
    lv_obj_t *bluetooth_tile;
    lv_obj_t *light_tile;

    home_gestures_add_header(panel, "", "CONTROL CENTER",
                             home_gestures_controls_back);
    bluetooth_tile = home_gestures_add_control_tile(panel, 18, 72,
                                                    LV_SYMBOL_BLUETOOTH,
                                                    HOME_CONTROL_ICON_KIND_SYMBOL,
                                                    "BLUETOOTH", "ON",
                                                    lv_color_hex(HOME_GESTURE_BLUE),
                                                    home_gestures_bluetooth_event,
                                                    &control_bluetooth_value,
                                                    &control_bluetooth_icon);
    lv_obj_add_event_cb(bluetooth_tile, home_gestures_bluetooth_event,
                        LV_EVENT_LONG_PRESSED, NULL);
    home_gestures_add_control_tile(panel, 141, 72, LV_SYMBOL_VOLUME_MAX,
                                   HOME_CONTROL_ICON_KIND_SYMBOL,
                                   "SILENT MODE", "OFF",
                                   lv_color_hex(HOME_GESTURE_GOLD),
                                   home_gestures_silent_event, &control_silent_value,
                                   &control_silent_icon);
    home_gestures_add_control_tile(panel, 264, 72, NULL, HOME_CONTROL_ICON_KIND_HAND,
                                   "WRIST WAKE", "ON",
                                   lv_color_hex(HOME_GESTURE_BLUE),
                                   home_gestures_wrist_event, &control_wrist_value,
                                   &control_wrist_icon);
    light_tile = home_gestures_add_control_tile(panel, 18, 186, NULL,
                                                HOME_CONTROL_ICON_KIND_BULB,
                                                "RGB LIGHT", "OFF",
                                                lv_color_hex(HOME_GESTURE_MUTED),
                                                home_gestures_light_event,
                                                &control_light_value,
                                                &control_light_icon);
    lv_obj_add_event_cb(light_tile, home_gestures_light_event,
                        LV_EVENT_LONG_PRESSED, NULL);
    home_gestures_add_control_tile(panel, 141, 186, NULL, HOME_CONTROL_ICON_KIND_PHONE,
                                   "FIND PHONE",
                                   "OFF", lv_color_hex(HOME_GESTURE_MUTED),
                                   home_gestures_find_phone_event,
                                   &control_find_phone_value, &control_find_phone_icon);
    home_gestures_add_control_tile(panel, 264, 186, LV_SYMBOL_BATTERY_FULL,
                                   HOME_CONTROL_ICON_KIND_SYMBOL,
                                   "LOW POWER", "OFF",
                                   lv_color_hex(HOME_GESTURE_MUTED),
                                   home_gestures_low_power_event,
                                   &control_low_power_value, &control_low_power_icon);
    home_gestures_add_slider(panel, 314, "BRIGHTNESS",
                             home_gestures_brightness_event,
                             &control_brightness_slider, &control_brightness_value);
    home_gestures_add_slider(panel, 375, "VOLUME", home_gestures_volume_event,
                             &control_volume_slider, &control_volume_value);

    lv_obj_add_event_cb(controls_screen, home_gestures_controls_event,
                        LV_EVENT_GESTURE, NULL);
    home_gestures_refresh_controls();
    control_refresh_timer = lv_timer_create(home_gestures_refresh_timer_cb, 1000, NULL);
}

static void home_gestures_create_notifications(void)
{
    lv_obj_t *panel = home_gestures_create_panel(&notifications_screen);
    lv_obj_t *clear_button;
    lv_obj_t *clear_icon;

    home_gestures_add_header(panel, LV_SYMBOL_BELL, "MESSAGES",
                             home_gestures_notifications_back);

    clear_button = lv_btn_create(panel);
    lv_obj_set_size(clear_button, 46, 46);
    lv_obj_set_pos(clear_button, 322, 10);
    lv_obj_clear_flag(clear_button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(clear_button, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(clear_button, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(clear_button,
                              lv_color_hex(HOME_GESTURE_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(clear_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(clear_button, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(clear_button, 0,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(clear_button, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    clear_icon = lv_label_create(clear_button);
    lv_label_set_text(clear_icon, LV_SYMBOL_TRASH);
    lv_obj_center(clear_icon);
    lv_obj_set_style_text_font(clear_icon, &lv_font_montserrat_20,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(clear_icon, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(clear_button, home_gestures_notifications_clear,
                        LV_EVENT_CLICKED, NULL);

    notifications_summary = lv_label_create(panel);
    lv_label_set_text(notifications_summary, "WAITING FOR PHONE MESSAGES");
    lv_obj_set_pos(notifications_summary, 20, 76);
    lv_obj_set_style_text_font(notifications_summary, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(notifications_summary, lv_color_white(),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    notifications_list = lv_obj_create(panel);
    lv_obj_set_size(notifications_list, 354, 330);
    lv_obj_set_pos(notifications_list, 18, 102);
    lv_obj_set_flex_flow(notifications_list, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_all(notifications_list, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_row(notifications_list, 12, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(notifications_list, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(notifications_list, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_width(notifications_list, 3,
                           LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(notifications_list, lv_color_white(),
                              LV_PART_SCROLLBAR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(notifications_list, LV_OPA_50,
                            LV_PART_SCROLLBAR | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(notifications_screen, home_gestures_notifications_event,
                        LV_EVENT_GESTURE, NULL);
    notifications_revision = (uint32_t)~0U;
    home_gestures_refresh_notifications();
    notifications_refresh_timer = lv_timer_create(
        home_gestures_notifications_refresh_timer_cb, 800, NULL);
}

void home_gestures_open_controls(void)
{
    if (controls_screen == NULL)
        home_gestures_create_controls();

    home_gestures_wait_release();
    lv_scr_load_anim(controls_screen, LV_SCR_LOAD_ANIM_MOVE_BOTTOM, 220, 0, false);
}

void home_gestures_open_notifications(void)
{
    if (notifications_screen == NULL)
        home_gestures_create_notifications();

    home_gestures_wait_release();
    lv_scr_load_anim(notifications_screen, LV_SCR_LOAD_ANIM_MOVE_TOP, 220, 0, false);
}

void home_gestures_refresh_controls_state(void)
{
    home_gestures_refresh_controls();
}

void home_gestures_destroy(void)
{
    if (control_refresh_timer != NULL)
    {
        lv_timer_del(control_refresh_timer);
        control_refresh_timer = NULL;
    }
    if (notifications_refresh_timer != NULL)
    {
        lv_timer_del(notifications_refresh_timer);
        notifications_refresh_timer = NULL;
    }

    if (controls_screen != NULL)
        lv_obj_del(controls_screen);
    if (notifications_screen != NULL)
        lv_obj_del(notifications_screen);
    if (notification_detail_screen != NULL)
        lv_obj_del(notification_detail_screen);

    controls_screen = NULL;
    notifications_screen = NULL;
    notifications_list = NULL;
    notifications_summary = NULL;
    notification_detail_screen = NULL;
    notification_detail_id = 0U;
    notifications_revision = 0U;
    control_bluetooth_value = NULL;
    control_silent_value = NULL;
    control_light_value = NULL;
    control_wrist_value = NULL;
    control_find_phone_value = NULL;
    control_low_power_value = NULL;
    control_brightness_value = NULL;
    control_volume_value = NULL;
    control_brightness_slider = NULL;
    control_volume_slider = NULL;
    control_bluetooth_icon.object = NULL;
    control_bluetooth_icon.part_count = 0U;
    control_silent_icon.object = NULL;
    control_silent_icon.part_count = 0U;
    control_light_icon.object = NULL;
    control_light_icon.part_count = 0U;
    control_wrist_icon.object = NULL;
    control_wrist_icon.part_count = 0U;
    control_find_phone_icon.object = NULL;
    control_find_phone_icon.part_count = 0U;
    control_low_power_icon.object = NULL;
    control_low_power_icon.part_count = 0U;
    control_low_power_enabled = 0U;
}
