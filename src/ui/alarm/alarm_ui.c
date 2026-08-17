#include "alarm_ui.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "services/alarm_service.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/screens/ui_ScreenHome.h"
#include "ui/generated/ui_helpers.h"
#include "ui/system/system_power_ui.h"

#define ALARM_BG               0x050608
#define ALARM_PANEL            0x090B0F
#define ALARM_CARD             0x151A21
#define ALARM_CARD_PRESSED     0x232A35
#define ALARM_BORDER           0x303A47
#define ALARM_TEXT             0xF5F7FA
#define ALARM_MUTED            0x8E98A6
#define ALARM_QUIET            0x66717E
#define ALARM_AMBER            0xF4BE4F
#define ALARM_AMBER_DARK       0x332919
#define ALARM_BLUE             0x3B9DFF
#define ALARM_RED              0xF05C63
#define ALARM_MAX_INDEX        0xFFU

typedef enum
{
    ALARM_UI_LIST,
    ALARM_UI_EDITOR,
    ALARM_UI_RING,
} alarm_ui_state_t;

typedef enum
{
    ALARM_ADJUST_HOUR_UP,
    ALARM_ADJUST_HOUR_DOWN,
    ALARM_ADJUST_MINUTE_UP,
    ALARM_ADJUST_MINUTE_DOWN,
} alarm_adjust_t;

lv_obj_t *ui_Alarm = NULL;

static lv_obj_t *alarm_panel;
static lv_obj_t *editor_hour_label;
static lv_obj_t *editor_minute_label;
static lv_obj_t *editor_day_buttons[7];
static alarm_ui_state_t alarm_ui_state = ALARM_UI_LIST;
static alarm_entry_t editor_entry;
static uint8_t editor_index = ALARM_MAX_INDEX;
static uint8_t ring_index = ALARM_MAX_INDEX;
static uint8_t refresh_queued;

static void alarm_ui_build_current(void);
static void alarm_ui_show_list(void);
static void alarm_ui_show_editor(uint8_t index);
static void alarm_ui_show_ring(uint8_t index);

static void alarm_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void alarm_ui_style_object(lv_obj_t *object, uint32_t color,
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
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void alarm_ui_style_button(lv_obj_t *button, uint32_t color,
                                  uint32_t pressed, uint32_t border,
                                  lv_coord_t radius)
{
    alarm_ui_style_object(button, color, LV_OPA_COVER, radius);
    lv_obj_set_style_border_color(button, lv_color_hex(border),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(button, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(button, lv_color_hex(pressed),
                              LV_PART_MAIN | LV_STATE_PRESSED);
}

static lv_obj_t *alarm_ui_add_label(lv_obj_t *parent, const char *text,
                                    const lv_font_t *font, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    return label;
}

static lv_obj_t *alarm_ui_add_text_button(lv_obj_t *parent, lv_coord_t x,
                                          lv_coord_t y, lv_coord_t width,
                                          lv_coord_t height,
                                          const char *text,
                                          uint32_t color,
                                          uint32_t border,
                                          const lv_font_t *font,
                                          lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label;

    lv_obj_set_size(button, width, height);
    lv_obj_set_pos(button, x, y);
    alarm_ui_style_button(button, color, ALARM_CARD_PRESSED, border, 8);
    label = alarm_ui_add_label(button, text, font, ALARM_TEXT);
    lv_obj_center(label);
    if (callback != NULL)
        lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);
    return button;
}

static void alarm_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Alarm_return();
}

static void alarm_ui_add_header(const char *title, uint8_t show_add)
{
    lv_obj_t *back;
    lv_obj_t *label;

    back = alarm_ui_add_text_button(alarm_panel, 22, 12, 44, 44,
                                    LV_SYMBOL_LEFT, ALARM_PANEL,
                                    ALARM_PANEL, &lv_font_montserrat_20,
                                    alarm_ui_back_event);
    lv_obj_set_style_bg_color(back, lv_color_hex(ALARM_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);

    label = alarm_ui_add_label(alarm_panel, title, &hsp_font_cjk_22,
                               ALARM_TEXT);
    lv_obj_set_pos(label, 76, 19);

    if (show_add)
    {
        lv_obj_t *add = alarm_ui_add_text_button(alarm_panel, 320, 12, 48, 44,
                                                 "+", ALARM_AMBER_DARK,
                                                 ALARM_AMBER,
                                                 &lv_font_montserrat_24,
                                                 NULL);
        lv_obj_set_style_text_color(lv_obj_get_child(add, 0),
                                    lv_color_hex(ALARM_AMBER),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_add_event_cb(add, alarm_ui_back_event, LV_EVENT_CANCEL, NULL);
    }
}

static void alarm_ui_format_repeat(uint8_t mask, char *buffer, size_t size)
{
    if (mask == 0U)
    {
        snprintf(buffer, size, "仅一次");
        return;
    }
    if (mask == ALARM_REPEAT_EVERY_DAY)
    {
        snprintf(buffer, size, "每天");
        return;
    }
    if (mask == (ALARM_REPEAT_MONDAY | ALARM_REPEAT_TUESDAY |
                 ALARM_REPEAT_WEDNESDAY | ALARM_REPEAT_THURSDAY |
                 ALARM_REPEAT_FRIDAY))
    {
        snprintf(buffer, size, "工作日");
        return;
    }

    snprintf(buffer, size, "周%s%s%s%s%s%s%s",
             (mask & ALARM_REPEAT_MONDAY) ? "一" : "",
             (mask & ALARM_REPEAT_TUESDAY) ? "二" : "",
             (mask & ALARM_REPEAT_WEDNESDAY) ? "三" : "",
             (mask & ALARM_REPEAT_THURSDAY) ? "四" : "",
             (mask & ALARM_REPEAT_FRIDAY) ? "五" : "",
             (mask & ALARM_REPEAT_SATURDAY) ? "六" : "",
             (mask & ALARM_REPEAT_SUNDAY) ? "日" : "");
}

static void alarm_ui_async_refresh(void *user_data)
{
    (void)user_data;
    refresh_queued = 0U;
    if (ui_Alarm != NULL && lv_scr_act() == ui_Alarm &&
        alarm_ui_state == ALARM_UI_LIST)
        alarm_ui_build_current();
}

static void alarm_ui_schedule_refresh(void)
{
    if (refresh_queued)
        return;
    refresh_queued = 1U;
    lv_async_call(alarm_ui_async_refresh, NULL);
}

static void alarm_ui_switch_event(lv_event_t *event)
{
    uint8_t index;
    lv_obj_t *toggle;

    if (lv_event_get_code(event) != LV_EVENT_VALUE_CHANGED)
        return;

    toggle = lv_event_get_target(event);
    index = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    (void)alarm_service_set_enabled(index,
                                    lv_obj_has_state(toggle, LV_STATE_CHECKED));
}

static void alarm_ui_card_event(lv_event_t *event)
{
    uint8_t index;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    index = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    alarm_ui_show_editor(index);
}

static void alarm_ui_add_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED ||
        alarm_service_count() >= ALARM_SERVICE_MAX_ALARMS)
        return;
    alarm_ui_show_editor(ALARM_MAX_INDEX);
}

static void alarm_ui_create_list_row(lv_obj_t *parent, uint8_t index,
                                     lv_coord_t y)
{
    alarm_entry_t entry;
    lv_obj_t *row;
    lv_obj_t *time_label;
    lv_obj_t *repeat_label;
    lv_obj_t *toggle;
    char time_text[8];
    char repeat_text[48];

    if (alarm_service_get(index, &entry) != RT_EOK)
        return;

    row = lv_btn_create(parent);
    lv_obj_set_size(row, 342, 82);
    lv_obj_set_pos(row, 0, y);
    alarm_ui_style_button(row, ALARM_CARD, ALARM_CARD_PRESSED,
                          ALARM_BORDER, 8);
    lv_obj_set_style_bg_opa(row, entry.enabled ? LV_OPA_COVER : LV_OPA_70,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(row, alarm_ui_card_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)index);

    snprintf(time_text, sizeof(time_text), "%02u:%02u",
             entry.hour, entry.minute);
    time_label = alarm_ui_add_label(row, time_text, &lv_font_montserrat_36,
                                    entry.enabled ? ALARM_TEXT : ALARM_QUIET);
    lv_obj_set_pos(time_label, 17, 7);

    alarm_ui_format_repeat(entry.repeat_mask, repeat_text,
                           sizeof(repeat_text));
    repeat_label = alarm_ui_add_label(row, repeat_text, &hsp_font_cjk_22,
                                      entry.enabled ? ALARM_MUTED : ALARM_QUIET);
    lv_obj_set_pos(repeat_label, 19, 48);

    toggle = lv_switch_create(row);
    lv_obj_set_size(toggle, 54, 30);
    lv_obj_set_pos(toggle, 270, 26);
    lv_obj_set_style_bg_color(toggle, lv_color_hex(ALARM_QUIET),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(toggle, lv_color_hex(ALARM_AMBER),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(toggle, lv_color_hex(ALARM_TEXT),
                              LV_PART_KNOB | LV_STATE_DEFAULT);
    if (entry.enabled)
        lv_obj_add_state(toggle, LV_STATE_CHECKED);
    lv_obj_add_event_cb(toggle, alarm_ui_switch_event,
                        LV_EVENT_VALUE_CHANGED, (void *)(uintptr_t)index);
}

static void alarm_ui_build_list(void)
{
    lv_obj_t *list;
    lv_obj_t *subtitle;
    lv_obj_t *add;
    alarm_entry_t next;
    uint32_t minutes;
    uint8_t count = alarm_service_count();
    uint8_t index;
    char next_text[64];

    alarm_ui_add_header("闹钟", 0U);
    add = alarm_ui_add_text_button(alarm_panel, 320, 12, 48, 44,
                                   "+", ALARM_AMBER_DARK, ALARM_AMBER,
                                   &lv_font_montserrat_24,
                                   alarm_ui_add_event);
    lv_obj_set_style_text_color(lv_obj_get_child(add, 0),
                                lv_color_hex(ALARM_AMBER),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    if (count >= ALARM_SERVICE_MAX_ALARMS)
        lv_obj_add_state(add, LV_STATE_DISABLED);

    if (alarm_service_get_next(&next, NULL, &minutes) == RT_EOK)
        snprintf(next_text, sizeof(next_text), "NEXT  %02u:%02u   %lu MIN",
                 next.hour, next.minute, (unsigned long)minutes);
    else
        snprintf(next_text, sizeof(next_text), "NO ACTIVE ALARM");
    subtitle = alarm_ui_add_label(alarm_panel, next_text,
                                  &lv_font_montserrat_12, ALARM_MUTED);
    lv_obj_set_pos(subtitle, 25, 61);

    list = lv_obj_create(alarm_panel);
    lv_obj_set_size(list, 342, 352);
    lv_obj_set_pos(list, 24, 84);
    alarm_ui_style_object(list, ALARM_PANEL, LV_OPA_TRANSP, 0);
    lv_obj_add_flag(list, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scroll_dir(list, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(list, LV_SCROLLBAR_MODE_AUTO);
    lv_obj_set_style_pad_bottom(list, 14, LV_PART_MAIN | LV_STATE_DEFAULT);

    if (count == 0U)
    {
        lv_obj_t *icon = alarm_ui_add_label(list, LV_SYMBOL_AUDIO,
                                            &lv_font_montserrat_48,
                                            ALARM_AMBER);
        lv_obj_t *empty = alarm_ui_add_label(list, "还没有闹钟",
                                             &hsp_font_cjk_22, ALARM_TEXT);
        lv_obj_t *hint = alarm_ui_add_label(list, "点击右上角 + 添加",
                                            &hsp_font_cjk_22, ALARM_MUTED);
        lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 66);
        lv_obj_align(empty, LV_ALIGN_TOP_MID, 0, 137);
        lv_obj_align(hint, LV_ALIGN_TOP_MID, 0, 180);
        return;
    }

    for (index = 0U; index < count; index++)
        alarm_ui_create_list_row(list, index, (lv_coord_t)index * 94);
    lv_obj_set_height(list, 352);
}

static void alarm_ui_update_editor_time(void)
{
    char text[4];

    if (editor_hour_label != NULL)
    {
        snprintf(text, sizeof(text), "%02u", editor_entry.hour);
        lv_label_set_text(editor_hour_label, text);
    }
    if (editor_minute_label != NULL)
    {
        snprintf(text, sizeof(text), "%02u", editor_entry.minute);
        lv_label_set_text(editor_minute_label, text);
    }
}

static void alarm_ui_adjust_event(lv_event_t *event)
{
    alarm_adjust_t action;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    action = (alarm_adjust_t)(uintptr_t)lv_event_get_user_data(event);
    if (action == ALARM_ADJUST_HOUR_UP)
        editor_entry.hour = (uint8_t)((editor_entry.hour + 1U) % 24U);
    else if (action == ALARM_ADJUST_HOUR_DOWN)
        editor_entry.hour = (uint8_t)((editor_entry.hour + 23U) % 24U);
    else if (action == ALARM_ADJUST_MINUTE_UP)
        editor_entry.minute = (uint8_t)((editor_entry.minute + 1U) % 60U);
    else
        editor_entry.minute = (uint8_t)((editor_entry.minute + 59U) % 60U);
    alarm_ui_update_editor_time();
}

static void alarm_ui_style_day_button(lv_obj_t *button, uint8_t selected)
{
    lv_obj_set_style_bg_color(button,
                              lv_color_hex(selected ? ALARM_AMBER_DARK :
                                                   ALARM_CARD),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(button,
                                  lv_color_hex(selected ? ALARM_AMBER :
                                                       ALARM_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(button, 0),
                                lv_color_hex(selected ? ALARM_AMBER :
                                                     ALARM_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void alarm_ui_day_event(lv_event_t *event)
{
    uint8_t day;
    uint8_t mask;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    day = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    mask = (uint8_t)(1U << day);
    editor_entry.repeat_mask ^= mask;
    alarm_ui_style_day_button(editor_day_buttons[day],
                              (editor_entry.repeat_mask & mask) != 0U);
}

static void alarm_ui_enabled_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_VALUE_CHANGED)
        editor_entry.enabled = lv_obj_has_state(lv_event_get_target(event),
                                                LV_STATE_CHECKED) ? 1U : 0U;
}

static rt_err_t alarm_ui_commit(uint8_t *saved_index)
{
    rt_err_t result;
    uint8_t index = editor_index;

    if (index == ALARM_MAX_INDEX)
        result = alarm_service_add(&editor_entry, &index);
    else
        result = alarm_service_update(index, &editor_entry);
    if (result == RT_EOK)
    {
        editor_index = index;
        if (saved_index != NULL)
            *saved_index = index;
    }
    return result;
}

static void alarm_ui_save_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED &&
        alarm_ui_commit(NULL) == RT_EOK)
        alarm_ui_show_list();
}

static void alarm_ui_delete_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED ||
        editor_index == ALARM_MAX_INDEX)
        return;
    if (alarm_service_remove(editor_index) == RT_EOK)
        alarm_ui_show_list();
}

static void alarm_ui_preview_event(lv_event_t *event)
{
    uint8_t index;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (alarm_ui_commit(&index) == RT_EOK)
        (void)alarm_service_preview(index);
}

static void alarm_ui_add_adjust_button(lv_obj_t *parent, lv_coord_t x,
                                       lv_coord_t y, const char *text,
                                       alarm_adjust_t action)
{
    lv_obj_t *button = alarm_ui_add_text_button(parent, x, y, 58, 38,
                                                text, ALARM_CARD,
                                                ALARM_BORDER,
                                                &lv_font_montserrat_24,
                                                NULL);
    lv_obj_add_event_cb(button, alarm_ui_adjust_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)action);
}

static void alarm_ui_build_editor(void)
{
    static const char *day_names[7] = {"一", "二", "三", "四", "五", "六", "日"};
    lv_obj_t *time_card;
    lv_obj_t *colon;
    lv_obj_t *repeat_title;
    lv_obj_t *enabled_card;
    lv_obj_t *enabled_label;
    lv_obj_t *enabled_switch;
    lv_obj_t *button;
    uint8_t day;

    alarm_ui_add_header(editor_index == ALARM_MAX_INDEX ? "添加闹钟" :
                                                        "编辑闹钟", 0U);

    time_card = lv_obj_create(alarm_panel);
    lv_obj_set_size(time_card, 342, 158);
    lv_obj_set_pos(time_card, 24, 67);
    alarm_ui_style_object(time_card, ALARM_CARD, LV_OPA_COVER, 8);
    lv_obj_set_style_border_color(time_card, lv_color_hex(ALARM_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(time_card, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);

    alarm_ui_add_adjust_button(time_card, 62, 11, "+", ALARM_ADJUST_HOUR_UP);
    alarm_ui_add_adjust_button(time_card, 222, 11, "+", ALARM_ADJUST_MINUTE_UP);
    editor_hour_label = alarm_ui_add_label(time_card, "00",
                                           &lv_font_montserrat_48,
                                           ALARM_TEXT);
    lv_obj_set_pos(editor_hour_label, 53, 51);
    colon = alarm_ui_add_label(time_card, ":", &lv_font_montserrat_48,
                               ALARM_AMBER);
    lv_obj_set_pos(colon, 157, 51);
    editor_minute_label = alarm_ui_add_label(time_card, "00",
                                             &lv_font_montserrat_48,
                                             ALARM_TEXT);
    lv_obj_set_pos(editor_minute_label, 213, 51);
    alarm_ui_add_adjust_button(time_card, 62, 109, "-",
                               ALARM_ADJUST_HOUR_DOWN);
    alarm_ui_add_adjust_button(time_card, 222, 109, "-",
                               ALARM_ADJUST_MINUTE_DOWN);
    alarm_ui_update_editor_time();

    repeat_title = alarm_ui_add_label(alarm_panel, "重复",
                                      &hsp_font_cjk_22, ALARM_MUTED);
    lv_obj_set_pos(repeat_title, 27, 232);
    for (day = 0U; day < 7U; day++)
    {
        button = alarm_ui_add_text_button(alarm_panel,
                                          28 + (lv_coord_t)day * 49,
                                          263, 42, 42, day_names[day],
                                          ALARM_CARD, ALARM_BORDER,
                                          &hsp_font_cjk_22,
                                          NULL);
        lv_obj_add_event_cb(button, alarm_ui_day_event, LV_EVENT_CLICKED,
                            (void *)(uintptr_t)day);
        editor_day_buttons[day] = button;
        alarm_ui_style_day_button(button,
                                  (editor_entry.repeat_mask & (1U << day)) != 0U);
    }

    enabled_card = lv_obj_create(alarm_panel);
    lv_obj_set_size(enabled_card, 342, 58);
    lv_obj_set_pos(enabled_card, 24, 316);
    alarm_ui_style_object(enabled_card, ALARM_CARD, LV_OPA_COVER, 8);
    enabled_label = alarm_ui_add_label(enabled_card, "启用闹钟",
                                       &hsp_font_cjk_22, ALARM_TEXT);
    lv_obj_set_pos(enabled_label, 17, 14);
    enabled_switch = lv_switch_create(enabled_card);
    lv_obj_set_size(enabled_switch, 54, 30);
    lv_obj_set_pos(enabled_switch, 270, 14);
    lv_obj_set_style_bg_color(enabled_switch, lv_color_hex(ALARM_AMBER),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    if (editor_entry.enabled)
        lv_obj_add_state(enabled_switch, LV_STATE_CHECKED);
    lv_obj_add_event_cb(enabled_switch, alarm_ui_enabled_event,
                        LV_EVENT_VALUE_CHANGED, NULL);

    if (editor_index != ALARM_MAX_INDEX)
        alarm_ui_add_text_button(alarm_panel, 24, 389, 94, 48,
                                 LV_SYMBOL_TRASH, ALARM_CARD, ALARM_RED,
                                 &lv_font_montserrat_20,
                                 alarm_ui_delete_event);
    alarm_ui_add_text_button(alarm_panel,
                             editor_index == ALARM_MAX_INDEX ? 24 : 128,
                             389,
                             editor_index == ALARM_MAX_INDEX ? 158 : 110,
                             48, "试听", ALARM_CARD, ALARM_BLUE,
                             &hsp_font_cjk_22, alarm_ui_preview_event);
    alarm_ui_add_text_button(alarm_panel,
                             editor_index == ALARM_MAX_INDEX ? 200 : 248,
                             389,
                             editor_index == ALARM_MAX_INDEX ? 166 : 118,
                             48, "保存", ALARM_AMBER_DARK, ALARM_AMBER,
                             &hsp_font_cjk_22, alarm_ui_save_event);
}

static void alarm_ui_snooze_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        alarm_service_snooze();
}

static void alarm_ui_dismiss_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        alarm_service_dismiss();
}

static void alarm_ui_build_ring(void)
{
    alarm_entry_t entry;
    lv_obj_t *icon;
    lv_obj_t *title;
    lv_obj_t *time_label;
    lv_obj_t *repeat_label;
    char time_text[8] = "--:--";
    char repeat_text[48] = "闹钟提醒";

    if (alarm_service_get(ring_index, &entry) == RT_EOK)
    {
        snprintf(time_text, sizeof(time_text), "%02u:%02u",
                 entry.hour, entry.minute);
        alarm_ui_format_repeat(entry.repeat_mask, repeat_text,
                               sizeof(repeat_text));
    }

    icon = alarm_ui_add_label(alarm_panel, LV_SYMBOL_AUDIO,
                              &lv_font_montserrat_48, ALARM_AMBER);
    lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 52);
    title = alarm_ui_add_label(alarm_panel, "ALARM", &lv_font_montserrat_20,
                               ALARM_AMBER);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 119);
    time_label = alarm_ui_add_label(alarm_panel, time_text,
                                    &lv_font_montserrat_48, ALARM_TEXT);
    lv_obj_align(time_label, LV_ALIGN_TOP_MID, 0, 157);
    repeat_label = alarm_ui_add_label(alarm_panel, repeat_text,
                                      &hsp_font_cjk_22, ALARM_MUTED);
    lv_obj_align(repeat_label, LV_ALIGN_TOP_MID, 0, 224);

    alarm_ui_add_text_button(alarm_panel, 30, 326, 158, 72,
                             "稍后 5 分钟", ALARM_CARD, ALARM_BLUE,
                             &hsp_font_cjk_22, alarm_ui_snooze_event);
    alarm_ui_add_text_button(alarm_panel, 202, 326, 158, 72,
                             "关闭", ALARM_AMBER_DARK, ALARM_AMBER,
                             &hsp_font_cjk_22, alarm_ui_dismiss_event);
}

static void alarm_ui_build_current(void)
{
    if (ui_Alarm == NULL)
        return;

    lv_obj_clean(ui_Alarm);
    alarm_panel = lv_obj_create(ui_Alarm);
    lv_obj_set_size(alarm_panel, 390, 450);
    lv_obj_align(alarm_panel, LV_ALIGN_CENTER, 0, 0);
    alarm_ui_style_object(alarm_panel, ALARM_PANEL, LV_OPA_COVER, 45);
    lv_obj_set_style_border_color(alarm_panel, lv_color_hex(ALARM_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(alarm_panel, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(alarm_panel, true,
                                 LV_PART_MAIN | LV_STATE_DEFAULT);

    editor_hour_label = NULL;
    editor_minute_label = NULL;
    rt_memset(editor_day_buttons, 0, sizeof(editor_day_buttons));
    if (alarm_ui_state == ALARM_UI_EDITOR)
        alarm_ui_build_editor();
    else if (alarm_ui_state == ALARM_UI_RING)
        alarm_ui_build_ring();
    else
        alarm_ui_build_list();
}

static void alarm_ui_show_list(void)
{
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_LIST;
    editor_index = ALARM_MAX_INDEX;
    alarm_ui_build_current();
}

static void alarm_ui_show_editor(uint8_t index)
{
    alarm_ui_wait_release();
    if (index == ALARM_MAX_INDEX)
        alarm_service_make_default(&editor_entry);
    else if (alarm_service_get(index, &editor_entry) != RT_EOK)
        return;
    editor_index = index;
    alarm_ui_state = ALARM_UI_EDITOR;
    alarm_ui_build_current();
}

static void alarm_ui_show_ring(uint8_t index)
{
    alarm_ui_wait_release();
    system_power_ui_close();
    ring_index = index;
    alarm_ui_state = ALARM_UI_RING;
    if (ui_Alarm == NULL)
        ui_Alarm_screen_init();
    else
        alarm_ui_build_current();
    lv_scr_load_anim(ui_Alarm, LV_SCR_LOAD_ANIM_FADE_ON, 160, 0, false);
}

static void alarm_ui_service_event(alarm_service_event_t event, uint8_t index)
{
    if (event == ALARM_SERVICE_EVENT_CHANGED)
        alarm_ui_schedule_refresh();
    else if (event == ALARM_SERVICE_EVENT_RING_STARTED)
        alarm_ui_show_ring(index);
    else if (event == ALARM_SERVICE_EVENT_RING_STOPPED)
    {
        alarm_ui_state = ALARM_UI_LIST;
        ring_index = ALARM_MAX_INDEX;
        _ui_screen_change(&ui_ScreenHome, LV_SCR_LOAD_ANIM_FADE_ON, 160, 0,
                          &ui_ScreenHome_screen_init);
    }
}

void ui_Alarm_init(void)
{
    alarm_service_set_event_handler(alarm_ui_service_event);
}

void ui_Alarm_screen_init(void)
{
    if (ui_Alarm != NULL)
        return;

    ui_Alarm = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_Alarm, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Alarm, lv_color_hex(ALARM_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_Alarm, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    alarm_ui_build_current();
}

void ui_Alarm_screen_destroy(void)
{
    if (ui_Alarm != NULL)
        lv_obj_del(ui_Alarm);
    ui_Alarm = NULL;
    alarm_panel = NULL;
    editor_hour_label = NULL;
    editor_minute_label = NULL;
    rt_memset(editor_day_buttons, 0, sizeof(editor_day_buttons));
}

void ui_Alarm_open_from_app_grid(void)
{
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_LIST;
    editor_index = ALARM_MAX_INDEX;
    if (ui_Alarm == NULL)
        ui_Alarm_screen_init();
    else
        alarm_ui_build_current();
    lv_scr_load_anim(ui_Alarm, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Alarm_return(void)
{
    if (alarm_ui_state == ALARM_UI_RING)
        return;
    if (alarm_ui_state == ALARM_UI_EDITOR)
        alarm_ui_show_list();
    else
    {
        alarm_ui_wait_release();
        ui_AppGrid_open();
    }
}

uint8_t ui_Alarm_handle_key(input_wake_key_t key,
                            input_wake_event_t event)
{
    if (alarm_service_is_ringing() || alarm_ui_state == ALARM_UI_RING)
    {
        if (event == INPUT_WAKE_EVENT_SHORT_PRESS)
        {
            if (key == INPUT_WAKE_KEY1)
                alarm_service_snooze();
            else if (key == INPUT_WAKE_KEY2)
                alarm_service_dismiss();
        }
        return 1U;
    }

    if (ui_Alarm == NULL || lv_scr_act() != ui_Alarm)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Alarm_return();
        return 1U;
    }
    return 0U;
}
