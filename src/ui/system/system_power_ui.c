#include "lvgl.h"
#include "services/power_manager.h"
#include "system_power_ui.h"

#define POWER_UI_BG             0x050608
#define POWER_UI_BORDER         0x293340
#define POWER_UI_CARD           0x151A21
#define POWER_UI_CARD_PRESSED   0x252C35
#define POWER_UI_TEXT           0xF5F7FA
#define POWER_UI_MUTED          0x8A96A5
#define POWER_UI_RED            0xFF5C6C
#define POWER_UI_BLUE           0x3B9BFF

typedef enum
{
    POWER_UI_ACTION_NONE,
    POWER_UI_ACTION_SHUTDOWN,
    POWER_UI_ACTION_RESTART,
} power_ui_action_t;

static lv_obj_t *power_ui_root;
static lv_obj_t *power_ui_content;
static lv_timer_t *power_ui_action_timer;
static power_ui_action_t power_ui_action;

static void power_ui_clear_content(void)
{
    if (power_ui_content != NULL)
        lv_obj_clean(power_ui_content);
}

static void power_ui_root_delete_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_DELETE ||
        lv_event_get_target(event) != power_ui_root)
        return;

    if (power_ui_action_timer != NULL)
    {
        lv_timer_del(power_ui_action_timer);
        power_ui_action_timer = NULL;
    }
    power_ui_root = NULL;
    power_ui_content = NULL;
    power_ui_action = POWER_UI_ACTION_NONE;
}

static void power_ui_style_button(lv_obj_t *button, uint32_t accent)
{
    lv_obj_clear_flag(button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(button, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(button, lv_color_hex(POWER_UI_CARD),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(button, lv_color_hex(accent),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(button, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(button, lv_color_hex(POWER_UI_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
}

static lv_obj_t *power_ui_add_action_button(lv_obj_t *parent, lv_coord_t x,
                                            const char *symbol,
                                            const char *text,
                                            uint32_t accent,
                                            lv_event_cb_t event_cb)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *icon = lv_label_create(button);
    lv_obj_t *label = lv_label_create(button);

    lv_obj_set_size(button, 144, 166);
    lv_obj_set_pos(button, x, 112);
    power_ui_style_button(button, accent);

    lv_label_set_text(icon, symbol);
    lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 34);
    lv_obj_set_style_text_font(icon, &lv_font_montserrat_36,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(icon, lv_color_hex(accent),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_label_set_text(label, text);
    lv_obj_align(label, LV_ALIGN_BOTTOM_MID, 0, -30);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(POWER_UI_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(button, event_cb, LV_EVENT_CLICKED, NULL);
    return button;
}

static lv_obj_t *power_ui_add_command_button(lv_obj_t *parent, lv_coord_t x,
                                             const char *text,
                                             uint32_t accent,
                                             lv_event_cb_t event_cb)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label = lv_label_create(button);

    lv_obj_set_size(button, 142, 58);
    lv_obj_set_pos(button, x, 320);
    power_ui_style_button(button, accent);
    lv_label_set_text(label, text);
    lv_obj_center(label);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(POWER_UI_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(button, event_cb, LV_EVENT_CLICKED, NULL);
    return button;
}

static void power_ui_show_selection(void);

static void power_ui_cancel_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        system_power_ui_close();
}

static void power_ui_back_to_selection_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        power_ui_show_selection();
}

static void power_ui_execute_action(lv_timer_t *timer)
{
    power_ui_action_t action = power_ui_action;

    power_ui_action_timer = NULL;
    lv_timer_del(timer);

    if (action == POWER_UI_ACTION_SHUTDOWN)
    {
        if (power_manager_shutdown() != RT_EOK && power_ui_root != NULL)
            power_ui_show_selection();
    }
    else if (action == POWER_UI_ACTION_RESTART)
    {
        power_manager_restart();
    }
}

static void power_ui_confirm_event(lv_event_t *event)
{
    lv_obj_t *button;
    lv_obj_t *label;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED ||
        power_ui_action == POWER_UI_ACTION_NONE ||
        power_ui_action_timer != NULL)
        return;

    power_ui_action_timer = lv_timer_create(power_ui_execute_action, 180, NULL);
    if (power_ui_action_timer == NULL)
        return;

    button = lv_event_get_target(event);
    label = lv_obj_get_child(button, 0);
    if (label != NULL)
        lv_label_set_text(label, power_ui_action == POWER_UI_ACTION_SHUTDOWN ?
                          "SHUTTING DOWN" : "RESTARTING");
    lv_obj_add_state(button, LV_STATE_DISABLED);
}

static void power_ui_show_confirmation(power_ui_action_t action)
{
    lv_obj_t *icon;
    lv_obj_t *title;
    lv_obj_t *detail;
    uint32_t accent = action == POWER_UI_ACTION_SHUTDOWN ?
                      POWER_UI_RED : POWER_UI_BLUE;

    power_ui_action = action;
    power_ui_clear_content();

    icon = lv_label_create(power_ui_content);
    lv_label_set_text(icon, action == POWER_UI_ACTION_SHUTDOWN ?
                      LV_SYMBOL_POWER : LV_SYMBOL_REFRESH);
    lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 82);
    lv_obj_set_style_text_font(icon, &lv_font_montserrat_36,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(icon, lv_color_hex(accent),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    title = lv_label_create(power_ui_content);
    lv_label_set_text(title, action == POWER_UI_ACTION_SHUTDOWN ?
                      "POWER OFF?" : "RESTART?");
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 151);
    lv_obj_set_style_text_font(title, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_hex(POWER_UI_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    detail = lv_label_create(power_ui_content);
    lv_label_set_text(detail, action == POWER_UI_ACTION_SHUTDOWN ?
                      "THE WATCH WILL TURN OFF" : "THE WATCH WILL START AGAIN");
    lv_obj_align(detail, LV_ALIGN_TOP_MID, 0, 202);
    lv_obj_set_style_text_font(detail, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(detail, lv_color_hex(POWER_UI_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    power_ui_add_command_button(power_ui_content, 43, "CANCEL",
                                POWER_UI_BORDER,
                                power_ui_back_to_selection_event);
    power_ui_add_command_button(power_ui_content, 205, "CONFIRM", accent,
                                power_ui_confirm_event);
}

static void power_ui_shutdown_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        power_ui_show_confirmation(POWER_UI_ACTION_SHUTDOWN);
}

static void power_ui_restart_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        power_ui_show_confirmation(POWER_UI_ACTION_RESTART);
}

static void power_ui_show_selection(void)
{
    lv_obj_t *title;
    lv_obj_t *subtitle;

    power_ui_action = POWER_UI_ACTION_NONE;
    power_ui_clear_content();

    title = lv_label_create(power_ui_content);
    lv_label_set_text(title, "POWER");
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 42);
    lv_obj_set_style_text_font(title, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_hex(POWER_UI_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    subtitle = lv_label_create(power_ui_content);
    lv_label_set_text(subtitle, "SYSTEM OPTIONS");
    lv_obj_align(subtitle, LV_ALIGN_TOP_MID, 0, 76);
    lv_obj_set_style_text_font(subtitle, &lv_font_montserrat_12,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(subtitle, lv_color_hex(POWER_UI_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    power_ui_add_action_button(power_ui_content, 42, LV_SYMBOL_POWER,
                               "POWER OFF", POWER_UI_RED,
                               power_ui_shutdown_event);
    power_ui_add_action_button(power_ui_content, 204, LV_SYMBOL_REFRESH,
                               "RESTART", POWER_UI_BLUE,
                               power_ui_restart_event);
    power_ui_add_command_button(power_ui_content, 124, "CANCEL",
                                POWER_UI_BORDER, power_ui_cancel_event);
}

void system_power_ui_open(void)
{
    if (power_ui_root != NULL)
    {
        lv_obj_move_foreground(power_ui_root);
        return;
    }

    power_ui_root = lv_obj_create(lv_layer_top());
    lv_obj_set_size(power_ui_root, 390, 450);
    lv_obj_center(power_ui_root);
    lv_obj_clear_flag(power_ui_root, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(power_ui_root, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(power_ui_root, power_ui_root_delete_event,
                        LV_EVENT_DELETE, NULL);
    lv_obj_set_style_radius(power_ui_root, 45,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(power_ui_root, lv_color_hex(POWER_UI_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(power_ui_root, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(power_ui_root, lv_color_hex(POWER_UI_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(power_ui_root, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(power_ui_root, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    power_ui_content = lv_obj_create(power_ui_root);
    lv_obj_set_size(power_ui_content, 390, 450);
    lv_obj_center(power_ui_content);
    lv_obj_clear_flag(power_ui_content, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_opa(power_ui_content, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(power_ui_content, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(power_ui_content, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    power_ui_show_selection();
}

void system_power_ui_close(void)
{
    if (power_ui_action_timer != NULL)
    {
        lv_timer_del(power_ui_action_timer);
        power_ui_action_timer = NULL;
    }
    if (power_ui_root != NULL)
        lv_obj_del(power_ui_root);

    power_ui_root = NULL;
    power_ui_content = NULL;
    power_ui_action = POWER_UI_ACTION_NONE;
}

uint8_t system_power_ui_is_open(void)
{
    return power_ui_root != NULL ? 1U : 0U;
}

void system_power_ui_destroy(void)
{
    system_power_ui_close();
}
