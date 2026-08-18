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
    ALARM_UI_TIME,
    ALARM_UI_REPEAT,
    ALARM_UI_CUSTOM_REPEAT,
    ALARM_UI_RING,
} alarm_ui_state_t;

typedef enum
{
    ALARM_ROLLER_HOUR,
    ALARM_ROLLER_MINUTE,
} alarm_roller_field_t;

typedef enum
{
    ALARM_REPEAT_CHOICE_EVERY_DAY,
    ALARM_REPEAT_CHOICE_WORKDAY,
    ALARM_REPEAT_CHOICE_CUSTOM,
} alarm_repeat_choice_t;

lv_obj_t *ui_Alarm = NULL;

static lv_obj_t *alarm_panel;
static lv_obj_t *editor_day_buttons[7];
static lv_obj_t *editor_repeat_summary;
static lv_obj_t *editor_hour_roller;
static lv_obj_t *editor_minute_roller;
static alarm_ui_state_t alarm_ui_state = ALARM_UI_LIST;
static alarm_entry_t editor_entry;
static uint8_t editor_index = ALARM_MAX_INDEX;
static uint8_t ring_index = ALARM_MAX_INDEX;
static uint8_t refresh_queued;

static void alarm_ui_build_current(void);
static void alarm_ui_show_list(void);
static void alarm_ui_show_editor(uint8_t index);
static void alarm_ui_show_time(void);
static void alarm_ui_show_repeat(void);
static void alarm_ui_show_custom_repeat(void);
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
    (void)border;
    alarm_ui_style_object(button, color, LV_OPA_COVER, radius);
    lv_obj_set_style_border_width(button, 0,
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
    alarm_ui_style_button(button, color, ALARM_CARD_PRESSED, border, 22);
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
    lv_obj_set_size(row, 342, 100);
    lv_obj_set_pos(row, 0, y);
    alarm_ui_style_button(row, ALARM_CARD, ALARM_CARD_PRESSED,
                          ALARM_BORDER, 30);
    lv_obj_set_style_bg_opa(row, entry.enabled ? LV_OPA_COVER : LV_OPA_70,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(row, alarm_ui_card_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)index);

    snprintf(time_text, sizeof(time_text), "%02u:%02u",
             entry.hour, entry.minute);
    time_label = alarm_ui_add_label(row, time_text, &lv_font_montserrat_36,
                                    entry.enabled ? ALARM_TEXT : ALARM_QUIET);
    lv_obj_set_pos(time_label, 17, 10);

    alarm_ui_format_repeat(entry.repeat_mask, repeat_text,
                           sizeof(repeat_text));
    repeat_label = alarm_ui_add_label(row, repeat_text, &hsp_font_cjk_22,
                                      entry.enabled ? ALARM_MUTED : ALARM_QUIET);
    lv_obj_set_pos(repeat_label, 19, 62);

    toggle = lv_switch_create(row);
    lv_obj_set_size(toggle, 64, 36);
    lv_obj_set_pos(toggle, 260, 32);
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

    if (alarm_service_get_next(&next, NULL, &minutes) == RT_EOK)
        snprintf(next_text, sizeof(next_text), "NEXT  %02u:%02u   %lu MIN",
                 next.hour, next.minute, (unsigned long)minutes);
    else
        snprintf(next_text, sizeof(next_text), "NO ACTIVE ALARM");
    subtitle = alarm_ui_add_label(alarm_panel, next_text,
                                  &lv_font_montserrat_12, ALARM_MUTED);
    lv_obj_set_pos(subtitle, 25, 61);

    list = lv_obj_create(alarm_panel);
    lv_obj_set_size(list, 342, 214);
    lv_obj_set_pos(list, 24, 84);
    alarm_ui_style_object(list, ALARM_PANEL, LV_OPA_TRANSP, 0);
    lv_obj_add_flag(list, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scroll_dir(list, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(list, LV_SCROLLBAR_MODE_AUTO);
    lv_obj_set_style_pad_bottom(list, 14, LV_PART_MAIN | LV_STATE_DEFAULT);

    if (count == 0U)
    {
        lv_obj_t *icon = alarm_ui_add_label(list, LV_SYMBOL_BELL,
                                            &lv_font_montserrat_48,
                                            ALARM_AMBER);
        lv_obj_t *empty = alarm_ui_add_label(list, "还没有闹钟",
                                             &hsp_font_cjk_22, ALARM_TEXT);
        lv_obj_t *hint = alarm_ui_add_label(list, "点击下方加号",
                                            &hsp_font_cjk_22, ALARM_MUTED);
        lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 14);
        lv_obj_align(empty, LV_ALIGN_TOP_MID, 0, 76);
        lv_obj_align(hint, LV_ALIGN_TOP_MID, 0, 119);
    }
    else
    {
        for (index = 0U; index < count; index++)
            alarm_ui_create_list_row(list, index, (lv_coord_t)index * 112);
    }

    add = alarm_ui_add_text_button(alarm_panel, 135, 310, 120, 120,
                                   "+", ALARM_AMBER, ALARM_AMBER,
                                   &lv_font_montserrat_48,
                                   alarm_ui_add_event);
    lv_obj_set_style_radius(add, 60, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(add, 0),
                                lv_color_hex(ALARM_BG),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    if (count >= ALARM_SERVICE_MAX_ALARMS)
    {
        lv_obj_add_state(add, LV_STATE_DISABLED);
        lv_obj_set_style_bg_color(add, lv_color_hex(ALARM_QUIET),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    }
}

static const char alarm_hour_options[] =
    "00\n01\n02\n03\n04\n05\n06\n07\n08\n09\n10\n11\n"
    "12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23";

static const char alarm_minute_options[] =
    "00\n01\n02\n03\n04\n05\n06\n07\n08\n09\n"
    "10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n"
    "20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n"
    "30\n31\n32\n33\n34\n35\n36\n37\n38\n39\n"
    "40\n41\n42\n43\n44\n45\n46\n47\n48\n49\n"
    "50\n51\n52\n53\n54\n55\n56\n57\n58\n59";

static void alarm_ui_roller_event(lv_event_t *event)
{
    lv_obj_t *roller;
    alarm_roller_field_t field;

    if (lv_event_get_code(event) != LV_EVENT_VALUE_CHANGED)
        return;

    roller = lv_event_get_target(event);
    field = (alarm_roller_field_t)(uintptr_t)lv_event_get_user_data(event);
    if (field == ALARM_ROLLER_HOUR)
        editor_entry.hour = (uint8_t)lv_roller_get_selected(roller);
    else
        editor_entry.minute = (uint8_t)lv_roller_get_selected(roller);
}

static lv_obj_t *alarm_ui_add_time_roller(lv_obj_t *parent,
                                                 lv_coord_t x_offset,
                                                 alarm_roller_field_t field)
{
    lv_obj_t *roller = lv_roller_create(parent);

    lv_roller_set_options(roller,
                          field == ALARM_ROLLER_HOUR ? alarm_hour_options :
                                                       alarm_minute_options,
                          LV_ROLLER_MODE_NORMAL);
    lv_obj_set_style_text_font(roller, &lv_font_montserrat_48,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(roller, &lv_font_montserrat_48,
                               LV_PART_SELECTED | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(roller, lv_color_hex(ALARM_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(roller, lv_color_hex(ALARM_TEXT),
                                LV_PART_SELECTED | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(roller, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(roller, LV_OPA_TRANSP,
                            LV_PART_SELECTED | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(roller, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_align(roller, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_line_space(roller, 0,
                                     LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_line_space(roller, 0,
                                     LV_PART_SELECTED | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(roller, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_scrollbar_mode(roller, LV_SCROLLBAR_MODE_OFF);
    lv_roller_set_visible_row_count(roller, 3);
    lv_obj_set_width(roller, 140);
    lv_obj_align(roller, LV_ALIGN_CENTER, x_offset, 0);
    lv_roller_set_selected(roller,
                           field == ALARM_ROLLER_HOUR ? editor_entry.hour :
                                                        editor_entry.minute,
                           LV_ANIM_OFF);
    lv_obj_add_event_cb(roller, alarm_ui_roller_event,
                        LV_EVENT_VALUE_CHANGED, (void *)(uintptr_t)field);
    return roller;
}

static void alarm_ui_style_day_button(lv_obj_t *button, uint8_t selected)
{
    lv_obj_set_style_bg_color(button,
                              lv_color_hex(selected ? ALARM_AMBER_DARK :
                                                   ALARM_CARD),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(button, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(button, 0),
                                lv_color_hex(selected ? ALARM_AMBER :
                                                     ALARM_MUTED),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void alarm_ui_day_event(lv_event_t *event)
{
    char repeat_text[48];
    uint8_t day;
    uint8_t mask;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    day = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    mask = (uint8_t)(1U << day);
    editor_entry.repeat_mask ^= mask;
    alarm_ui_style_day_button(editor_day_buttons[day],
                              (editor_entry.repeat_mask & mask) != 0U);
    if (editor_repeat_summary != NULL)
    {
        alarm_ui_format_repeat(editor_entry.repeat_mask, repeat_text,
                               sizeof(repeat_text));
        lv_label_set_text(editor_repeat_summary, repeat_text);
    }
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
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (editor_index == ALARM_MAX_INDEX)
    {
        alarm_ui_show_list();
        return;
    }
    if (alarm_service_remove(editor_index) == RT_EOK)
        alarm_ui_show_list();
}

static void alarm_ui_time_open_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        alarm_ui_show_time();
}

static void alarm_ui_time_done_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (editor_hour_roller != NULL && editor_minute_roller != NULL)
    {
        editor_entry.hour = (uint8_t)lv_roller_get_selected(editor_hour_roller);
        editor_entry.minute = (uint8_t)lv_roller_get_selected(editor_minute_roller);
    }
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_EDITOR;
    alarm_ui_build_current();
}

static void alarm_ui_repeat_open_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        alarm_ui_show_repeat();
}

static void alarm_ui_repeat_choice_event(lv_event_t *event)
{
    alarm_repeat_choice_t choice;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    choice = (alarm_repeat_choice_t)(uintptr_t)lv_event_get_user_data(event);
    if (choice == ALARM_REPEAT_CHOICE_CUSTOM)
    {
        alarm_ui_show_custom_repeat();
        return;
    }

    editor_entry.repeat_mask = choice == ALARM_REPEAT_CHOICE_EVERY_DAY ?
                               ALARM_REPEAT_EVERY_DAY :
                               (ALARM_REPEAT_MONDAY | ALARM_REPEAT_TUESDAY |
                                ALARM_REPEAT_WEDNESDAY | ALARM_REPEAT_THURSDAY |
                                ALARM_REPEAT_FRIDAY);
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_EDITOR;
    alarm_ui_build_current();
}

static void alarm_ui_custom_done_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_EDITOR;
    alarm_ui_build_current();
}

static void alarm_ui_build_editor(void)
{
    lv_obj_t *time_button;
    lv_obj_t *time_title;
    lv_obj_t *time_value;
    lv_obj_t *time_arrow;
    lv_obj_t *repeat_button;
    lv_obj_t *repeat_label;
    lv_obj_t *repeat_value;
    lv_obj_t *repeat_arrow;
    lv_obj_t *confirm_button;
    lv_obj_t *delete_button;
    char time_text[8];
    char repeat_text[48];

    alarm_ui_add_header("编辑闹钟", 0U);

    time_button = lv_btn_create(alarm_panel);
    lv_obj_set_size(time_button, 342, 110);
    lv_obj_set_pos(time_button, 24, 72);
    alarm_ui_style_button(time_button, ALARM_CARD, ALARM_CARD_PRESSED,
                          ALARM_CARD, 32);
    lv_obj_add_event_cb(time_button, alarm_ui_time_open_event,
                        LV_EVENT_CLICKED, NULL);
    time_title = alarm_ui_add_label(time_button, "时间", &hsp_font_cjk_22,
                                    ALARM_MUTED);
    lv_obj_set_pos(time_title, 18, 10);
    snprintf(time_text, sizeof(time_text), "%02u:%02u",
             editor_entry.hour, editor_entry.minute);
    time_value = alarm_ui_add_label(time_button, time_text,
                                    &lv_font_montserrat_48, ALARM_TEXT);
    lv_obj_set_pos(time_value, 18, 43);
    time_arrow = alarm_ui_add_label(time_button, LV_SYMBOL_RIGHT,
                                    &lv_font_montserrat_20, ALARM_AMBER);
    lv_obj_set_pos(time_arrow, 307, 53);

    repeat_button = lv_btn_create(alarm_panel);
    lv_obj_set_size(repeat_button, 342, 110);
    lv_obj_set_pos(repeat_button, 24, 194);
    alarm_ui_style_button(repeat_button, ALARM_CARD, ALARM_CARD_PRESSED,
                          ALARM_CARD, 30);
    lv_obj_add_event_cb(repeat_button, alarm_ui_repeat_open_event,
                        LV_EVENT_CLICKED, NULL);
    repeat_label = alarm_ui_add_label(repeat_button, "重复",
                                      &hsp_font_cjk_22, ALARM_MUTED);
    lv_obj_set_pos(repeat_label, 18, 10);
    alarm_ui_format_repeat(editor_entry.repeat_mask, repeat_text,
                           sizeof(repeat_text));
    repeat_value = alarm_ui_add_label(repeat_button, repeat_text,
                                      &hsp_font_cjk_22, ALARM_AMBER);
    lv_obj_set_pos(repeat_value, 18, 59);
    repeat_arrow = alarm_ui_add_label(repeat_button, LV_SYMBOL_RIGHT,
                                      &lv_font_montserrat_20, ALARM_AMBER);
    lv_obj_set_pos(repeat_arrow, 307, 48);

    confirm_button = alarm_ui_add_text_button(
        alarm_panel, 61, 316, 110, 110, LV_SYMBOL_OK,
        ALARM_BLUE, ALARM_BLUE,
        &lv_font_montserrat_36, alarm_ui_save_event);
    lv_obj_set_style_radius(confirm_button, 55,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(confirm_button, 0),
                                lv_color_hex(ALARM_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    delete_button = alarm_ui_add_text_button(
        alarm_panel, 219, 316, 110, 110, LV_SYMBOL_TRASH,
        ALARM_RED, ALARM_RED,
        &lv_font_montserrat_36, alarm_ui_delete_event);
    lv_obj_set_style_radius(delete_button, 55,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(delete_button, 0),
                                lv_color_hex(ALARM_TEXT),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void alarm_ui_build_time(void)
{
    lv_obj_t *time_area;
    lv_obj_t *colon;
    lv_obj_t *done;

    alarm_ui_add_header("设置时间", 0U);
    time_area = lv_obj_create(alarm_panel);
    lv_obj_set_size(time_area, 342, 298);
    lv_obj_set_pos(time_area, 24, 60);
    alarm_ui_style_object(time_area, ALARM_PANEL, LV_OPA_TRANSP, 0);
    editor_hour_roller = alarm_ui_add_time_roller(
        time_area, -86, ALARM_ROLLER_HOUR);
    editor_minute_roller = alarm_ui_add_time_roller(
        time_area, 86, ALARM_ROLLER_MINUTE);
    colon = alarm_ui_add_label(time_area, ":", &lv_font_montserrat_48,
                               ALARM_AMBER);
    lv_obj_align(colon, LV_ALIGN_CENTER, 0, -2);

    done = alarm_ui_add_text_button(alarm_panel, 24, 370, 342, 64,
                                    "完成", ALARM_AMBER_DARK, ALARM_AMBER,
                                    &hsp_font_cjk_22,
                                    alarm_ui_time_done_event);
    lv_obj_set_style_radius(done, 32, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(lv_obj_get_child(done, 0),
                                lv_color_hex(ALARM_AMBER),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *alarm_ui_add_repeat_choice(lv_coord_t y, const char *text,
                                             alarm_repeat_choice_t choice,
                                             uint8_t selected)
{
    lv_obj_t *button = alarm_ui_add_text_button(alarm_panel, 24, y, 342, 82,
                                                 text, ALARM_CARD,
                                                 ALARM_BORDER,
                                                 &hsp_font_cjk_22, NULL);

    lv_obj_add_event_cb(button, alarm_ui_repeat_choice_event,
                        LV_EVENT_CLICKED, (void *)(uintptr_t)choice);
    lv_obj_set_style_radius(button, 30,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    alarm_ui_style_day_button(button, selected);
    return button;
}

static void alarm_ui_build_repeat(void)
{
    const uint8_t workday_mask = ALARM_REPEAT_MONDAY |
                                 ALARM_REPEAT_TUESDAY |
                                 ALARM_REPEAT_WEDNESDAY |
                                 ALARM_REPEAT_THURSDAY |
                                 ALARM_REPEAT_FRIDAY;
    uint8_t is_daily = editor_entry.repeat_mask == ALARM_REPEAT_EVERY_DAY;
    uint8_t is_workday = editor_entry.repeat_mask == workday_mask;

    alarm_ui_add_header("重复", 0U);
    alarm_ui_add_repeat_choice(72, "每天", ALARM_REPEAT_CHOICE_EVERY_DAY,
                               is_daily);
    alarm_ui_add_repeat_choice(166, "工作日", ALARM_REPEAT_CHOICE_WORKDAY,
                               is_workday);
    alarm_ui_add_repeat_choice(260, "自定义", ALARM_REPEAT_CHOICE_CUSTOM,
                               !is_daily && !is_workday);
}

static void alarm_ui_build_custom_repeat(void)
{
    static const char *day_names[7] = {"一", "二", "三", "四",
                                       "五", "六", "日"};
    lv_obj_t *title;
    lv_obj_t *button;
    char repeat_text[48];
    uint8_t day;

    alarm_ui_add_header("自定义", 0U);
    title = alarm_ui_add_label(alarm_panel, "选择重复日期",
                               &hsp_font_cjk_22, ALARM_MUTED);
    lv_obj_set_pos(title, 24, 70);
    for (day = 0U; day < 7U; day++)
    {
        lv_coord_t x = day < 4U ? 24 + (lv_coord_t)day * 85 :
                                 67 + (lv_coord_t)(day - 4U) * 85;
        lv_coord_t y = day < 4U ? 105 : 185;

        button = alarm_ui_add_text_button(alarm_panel, x, y, 76, 68,
                                          day_names[day], ALARM_CARD,
                                          ALARM_BORDER, &hsp_font_cjk_22,
                                          NULL);
        lv_obj_add_event_cb(button, alarm_ui_day_event, LV_EVENT_CLICKED,
                            (void *)(uintptr_t)day);
        editor_day_buttons[day] = button;
        alarm_ui_style_day_button(button,
                                  (editor_entry.repeat_mask &
                                   (1U << day)) != 0U);
    }

    alarm_ui_format_repeat(editor_entry.repeat_mask, repeat_text,
                           sizeof(repeat_text));
    editor_repeat_summary = alarm_ui_add_label(alarm_panel, repeat_text,
                                               &hsp_font_cjk_22,
                                               ALARM_AMBER);
    lv_obj_align(editor_repeat_summary, LV_ALIGN_TOP_MID, 0, 279);
    button = alarm_ui_add_text_button(alarm_panel, 24, 370, 342, 64,
                                      "完成", ALARM_AMBER_DARK, ALARM_AMBER,
                                      &hsp_font_cjk_22,
                                      alarm_ui_custom_done_event);
    lv_obj_set_style_radius(button, 32,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
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

    icon = alarm_ui_add_label(alarm_panel, LV_SYMBOL_BELL,
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

    editor_hour_roller = NULL;
    editor_minute_roller = NULL;
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

    editor_repeat_summary = NULL;
    rt_memset(editor_day_buttons, 0, sizeof(editor_day_buttons));
    if (alarm_ui_state == ALARM_UI_EDITOR)
        alarm_ui_build_editor();
    else if (alarm_ui_state == ALARM_UI_TIME)
        alarm_ui_build_time();
    else if (alarm_ui_state == ALARM_UI_REPEAT)
        alarm_ui_build_repeat();
    else if (alarm_ui_state == ALARM_UI_CUSTOM_REPEAT)
        alarm_ui_build_custom_repeat();
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

static void alarm_ui_show_time(void)
{
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_TIME;
    alarm_ui_build_current();
}

static void alarm_ui_show_repeat(void)
{
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_REPEAT;
    alarm_ui_build_current();
}

static void alarm_ui_show_custom_repeat(void)
{
    alarm_ui_wait_release();
    alarm_ui_state = ALARM_UI_CUSTOM_REPEAT;
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
    editor_repeat_summary = NULL;
    editor_hour_roller = NULL;
    editor_minute_roller = NULL;
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
    if (alarm_ui_state == ALARM_UI_CUSTOM_REPEAT)
        alarm_ui_show_repeat();
    else if (alarm_ui_state == ALARM_UI_TIME ||
             alarm_ui_state == ALARM_UI_REPEAT)
    {
        alarm_ui_wait_release();
        alarm_ui_state = ALARM_UI_EDITOR;
        alarm_ui_build_current();
    }
    else if (alarm_ui_state == ALARM_UI_EDITOR)
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
