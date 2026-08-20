#include "water_ui.h"

#include <stdint.h>
#include <stdio.h>

#include "lv_ext_resource_manager.h"
#include "drivers/display_power.h"
#include "services/alarm_service.h"
#include "services/water_reminder_service.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/screens/ui_ScreenHome.h"
#include "ui/generated/home_pager.h"
#include "ui/generated/ui_helpers.h"
#include "ui/generated/ui_swipe_back.h"
#include "ui/system/system_power_ui.h"

LV_IMG_DECLARE(water);

#define WATER_BG             0x050608
#define WATER_PANEL          0x090B0F
#define WATER_CARD           0x171B22
#define WATER_CARD_PRESSED   0x262D37
#define WATER_TEXT           0xF5F7FA
#define WATER_MUTED          0x8E98A6
#define WATER_BLUE           0x3B9DFF
#define WATER_GREEN          0x55D985
#define WATER_RED            0xF05C63

typedef enum
{
    WATER_UI_MAIN,
    WATER_UI_TIME_EDITOR,
    WATER_UI_INTERVAL_EDITOR,
    WATER_UI_REMINDER,
} water_ui_state_t;

typedef enum
{
    WATER_RETURN_HOME,
    WATER_RETURN_APP_GRID,
    WATER_RETURN_WATER,
} water_return_target_t;

lv_obj_t *ui_Water = NULL;

static lv_obj_t *water_panel;
static lv_obj_t *water_start_hour_roller;
static lv_obj_t *water_start_minute_roller;
static lv_obj_t *water_end_hour_roller;
static lv_obj_t *water_end_minute_roller;
static lv_obj_t *water_time_error;
static water_ui_state_t water_ui_state = WATER_UI_MAIN;
static water_return_target_t water_return_target = WATER_RETURN_HOME;
static uint8_t water_finish_queued;
static uint8_t water_refresh_queued;

static const char water_hour_options[] =
    "00\n01\n02\n03\n04\n05\n06\n07\n08\n09\n10\n11\n"
    "12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23";
static const char water_minute_options[] =
    "00\n01\n02\n03\n04\n05\n06\n07\n08\n09\n10\n11\n"
    "12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n"
    "24\n25\n26\n27\n28\n29\n30\n31\n32\n33\n34\n35\n"
    "36\n37\n38\n39\n40\n41\n42\n43\n44\n45\n46\n47\n"
    "48\n49\n50\n51\n52\n53\n54\n55\n56\n57\n58\n59";

static void water_ui_build_current(void);

static void water_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void water_ui_style_object(lv_obj_t *object, uint32_t color,
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

static lv_obj_t *water_ui_add_label(lv_obj_t *parent, const char *text,
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

static lv_obj_t *water_ui_add_button(lv_obj_t *parent, lv_coord_t x,
                                     lv_coord_t y, lv_coord_t width,
                                     lv_coord_t height, const char *text,
                                     uint32_t color, const lv_font_t *font,
                                     lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label;

    lv_obj_set_pos(button, x, y);
    lv_obj_set_size(button, width, height);
    water_ui_style_object(button, color, LV_OPA_COVER, height / 2);
    lv_obj_set_style_bg_color(button, lv_color_hex(WATER_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    label = water_ui_add_label(button, text, font, WATER_TEXT);
    lv_obj_center(label);
    if (callback != NULL)
        lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);
    return button;
}

static void water_ui_async_refresh(void *user_data)
{
    (void)user_data;
    water_refresh_queued = 0U;
    if (ui_Water != NULL && lv_scr_act() == ui_Water &&
        water_ui_state == WATER_UI_MAIN)
        water_ui_build_current();
}

static void water_ui_schedule_refresh(void)
{
    if (!water_refresh_queued)
    {
        water_refresh_queued = 1U;
        lv_async_call(water_ui_async_refresh, NULL);
    }
}

static void water_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Water_return();
}

static void water_ui_add_real_header(const char *title)
{
    lv_obj_t *back;
    lv_obj_t *label;

    back = water_ui_add_button(water_panel, 22, 14, 48, 48,
                               LV_SYMBOL_LEFT, WATER_CARD,
                               &lv_font_montserrat_20,
                               water_ui_back_event);
    label = water_ui_add_label(water_panel, title, &hsp_font_cjk_22,
                               WATER_TEXT);
    lv_obj_set_pos(label, 82, 25);
}

static void water_ui_toggle_event(lv_event_t *event)
{
    water_reminder_snapshot_t snapshot;

    if (lv_event_get_code(event) != LV_EVENT_VALUE_CHANGED)
        return;
    water_reminder_service_get_snapshot(&snapshot);
    snapshot.settings.enabled =
        lv_obj_has_state(lv_event_get_target(event), LV_STATE_CHECKED) ?
        1U : 0U;
    (void)water_reminder_service_update_settings(&snapshot.settings);
}

static void water_ui_open_time_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    water_ui_wait_release();
    water_ui_state = WATER_UI_TIME_EDITOR;
    water_ui_build_current();
}

static void water_ui_interval_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    water_ui_wait_release();
    water_ui_state = WATER_UI_INTERVAL_EDITOR;
    water_ui_build_current();
}

static lv_obj_t *water_ui_add_setting_card(lv_coord_t y,
                                           const char *title,
                                           const char *value,
                                           lv_event_cb_t callback)
{
    lv_obj_t *card = lv_btn_create(water_panel);
    lv_obj_t *title_label;
    lv_obj_t *value_label;

    lv_obj_set_pos(card, 24, y);
    lv_obj_set_size(card, 342, 72);
    water_ui_style_object(card, WATER_CARD, LV_OPA_COVER, 32);
    lv_obj_set_style_bg_color(card, lv_color_hex(WATER_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    title_label = water_ui_add_label(card, title, &hsp_font_cjk_22,
                                     WATER_TEXT);
    lv_obj_align(title_label, LV_ALIGN_LEFT_MID, 22, 0);
    value_label = water_ui_add_label(card, value, &hsp_font_cjk_22,
                                     WATER_BLUE);
    lv_obj_align(value_label, LV_ALIGN_RIGHT_MID, -22, 0);
    lv_obj_add_event_cb(card, callback, LV_EVENT_CLICKED, NULL);
    return card;
}

static void water_ui_build_main(void)
{
    water_reminder_snapshot_t snapshot;
    lv_obj_t *icon;
    lv_obj_t *amount;
    lv_obj_t *progress;
    lv_obj_t *toggle_card;
    lv_obj_t *toggle_label;
    lv_obj_t *toggle;
    lv_obj_t *next_label;
    char amount_text[32];
    char time_text[24];
    char interval_text[16];
    char next_text[32];
    uint16_t progress_value;

    water_reminder_service_get_snapshot(&snapshot);
    water_ui_add_real_header("喝水提醒");

    icon = lv_img_create(water_panel);
    lv_img_set_src(icon, LV_EXT_IMG_GET(water));
    lv_obj_set_size(icon, 64, 64);
    lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 55);

    (void)snprintf(amount_text, sizeof(amount_text), "%u / %u ml",
                   (unsigned int)snapshot.today_ml,
                   (unsigned int)snapshot.settings.target_ml);
    amount = water_ui_add_label(water_panel, amount_text,
                                &lv_font_montserrat_30, WATER_TEXT);
    lv_obj_align(amount, LV_ALIGN_TOP_MID, 0, 122);

    progress = lv_bar_create(water_panel);
    lv_obj_set_pos(progress, 40, 165);
    lv_obj_set_size(progress, 310, 12);
    lv_bar_set_range(progress, 0, 100);
    progress_value = snapshot.settings.target_ml == 0U ? 0U :
        (uint16_t)(((uint32_t)snapshot.today_ml * 100U) /
                   snapshot.settings.target_ml);
    if (progress_value > 100U)
        progress_value = 100U;
    lv_bar_set_value(progress, progress_value, LV_ANIM_OFF);
    lv_obj_set_style_radius(progress, 6, LV_PART_MAIN);
    lv_obj_set_style_bg_color(progress, lv_color_hex(0x252B34), LV_PART_MAIN);
    lv_obj_set_style_bg_color(progress, lv_color_hex(WATER_BLUE),
                              LV_PART_INDICATOR);

    toggle_card = lv_obj_create(water_panel);
    lv_obj_set_pos(toggle_card, 24, 187);
    lv_obj_set_size(toggle_card, 342, 64);
    water_ui_style_object(toggle_card, WATER_CARD, LV_OPA_COVER, 30);
    toggle_label = water_ui_add_label(toggle_card, "提醒开关",
                                      &hsp_font_cjk_22, WATER_TEXT);
    lv_obj_align(toggle_label, LV_ALIGN_LEFT_MID, 22, 0);
    toggle = lv_switch_create(toggle_card);
    lv_obj_set_size(toggle, 68, 38);
    lv_obj_align(toggle, LV_ALIGN_RIGHT_MID, -18, 0);
    lv_obj_set_style_bg_color(toggle, lv_color_hex(WATER_BLUE),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    if (snapshot.settings.enabled)
        lv_obj_add_state(toggle, LV_STATE_CHECKED);
    lv_obj_add_event_cb(toggle, water_ui_toggle_event,
                        LV_EVENT_VALUE_CHANGED, NULL);

    (void)snprintf(time_text, sizeof(time_text), "%02u:%02u - %02u:%02u",
                   (unsigned int)snapshot.settings.start_hour,
                   (unsigned int)snapshot.settings.start_minute,
                   (unsigned int)snapshot.settings.end_hour,
                   (unsigned int)snapshot.settings.end_minute);
    water_ui_add_setting_card(259, "提醒时段", time_text,
                              water_ui_open_time_event);

    (void)snprintf(interval_text, sizeof(interval_text), "%u 小时",
                   (unsigned int)(snapshot.settings.interval_minutes / 60U));
    water_ui_add_setting_card(339, "提醒间隔", interval_text,
                              water_ui_interval_event);

    if (!snapshot.settings.enabled)
        (void)snprintf(next_text, sizeof(next_text), "提醒已关闭");
    else if (snapshot.next_valid_today)
        (void)snprintf(next_text, sizeof(next_text), "下次 %02u:%02u",
                       (unsigned int)snapshot.next_hour,
                       (unsigned int)snapshot.next_minute);
    else
        (void)snprintf(next_text, sizeof(next_text), "下次 明日 %02u:%02u",
                       (unsigned int)snapshot.settings.start_hour,
                       (unsigned int)snapshot.settings.start_minute);
    next_label = water_ui_add_label(water_panel, next_text,
                                    &hsp_font_cjk_22, WATER_MUTED);
    lv_obj_align(next_label, LV_ALIGN_BOTTOM_MID, 0, -3);
}

static lv_obj_t *water_ui_create_roller(lv_coord_t x, lv_coord_t y,
                                        const char *options,
                                        uint16_t selected)
{
    lv_obj_t *roller = lv_roller_create(water_panel);

    lv_obj_set_pos(roller, x, y);
    lv_roller_set_options(roller, options, LV_ROLLER_MODE_NORMAL);
    lv_roller_set_visible_row_count(roller, 3);
    lv_obj_set_size(roller, 118, 126);
    lv_roller_set_selected(roller, selected, LV_ANIM_OFF);
    lv_obj_set_style_bg_opa(roller, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_bg_opa(roller, LV_OPA_TRANSP, LV_PART_SELECTED);
    lv_obj_set_style_border_width(roller, 0, LV_PART_MAIN);
    lv_obj_set_style_text_font(roller, &lv_font_montserrat_48, LV_PART_MAIN);
    lv_obj_set_style_text_color(roller, lv_color_hex(WATER_MUTED),
                                LV_PART_MAIN);
    lv_obj_set_style_text_opa(roller, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_text_color(roller, lv_color_hex(WATER_TEXT),
                                LV_PART_SELECTED);
    lv_obj_set_style_text_opa(roller, LV_OPA_COVER, LV_PART_SELECTED);
    lv_obj_set_style_text_font(roller, &lv_font_montserrat_48,
                               LV_PART_SELECTED);
    lv_obj_set_style_text_align(roller, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_line_space(roller, 0, LV_PART_MAIN);
    lv_obj_set_style_text_line_space(roller, 0, LV_PART_SELECTED);
    lv_obj_set_style_pad_all(roller, 0, LV_PART_MAIN);
    lv_obj_set_scrollbar_mode(roller, LV_SCROLLBAR_MODE_OFF);
    return roller;
}

static void water_ui_save_time_event(lv_event_t *event)
{
    water_reminder_snapshot_t snapshot;
    uint16_t start;
    uint16_t end;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    water_reminder_service_get_snapshot(&snapshot);
    snapshot.settings.start_hour =
        (uint8_t)lv_roller_get_selected(water_start_hour_roller);
    snapshot.settings.start_minute =
        (uint8_t)lv_roller_get_selected(water_start_minute_roller);
    snapshot.settings.end_hour =
        (uint8_t)lv_roller_get_selected(water_end_hour_roller);
    snapshot.settings.end_minute =
        (uint8_t)lv_roller_get_selected(water_end_minute_roller);
    start = (uint16_t)snapshot.settings.start_hour * 60U +
            snapshot.settings.start_minute;
    end = (uint16_t)snapshot.settings.end_hour * 60U +
          snapshot.settings.end_minute;
    if (start >= end)
    {
        lv_label_set_text(water_time_error, "结束时间应晚于开始时间");
        return;
    }
    (void)water_reminder_service_update_settings(&snapshot.settings);
    water_ui_wait_release();
    water_ui_state = WATER_UI_MAIN;
    water_ui_build_current();
}

static void water_ui_build_time_editor(void)
{
    water_reminder_snapshot_t snapshot;
    lv_obj_t *label;
    lv_obj_t *colon;

    water_reminder_service_get_snapshot(&snapshot);
    water_ui_add_real_header("提醒时段");

    label = water_ui_add_label(water_panel, "开始", &hsp_font_cjk_22,
                               WATER_MUTED);
    lv_obj_set_pos(label, 20, 105);
    water_start_hour_roller = water_ui_create_roller(
        66, 61, water_hour_options, snapshot.settings.start_hour);
    colon = water_ui_add_label(water_panel, ":", &lv_font_montserrat_48,
                               WATER_BLUE);
    lv_obj_set_pos(colon, 188, 93);
    water_start_minute_roller = water_ui_create_roller(
        206, 61, water_minute_options, snapshot.settings.start_minute);

    label = water_ui_add_label(water_panel, "结束", &hsp_font_cjk_22,
                               WATER_MUTED);
    lv_obj_set_pos(label, 20, 231);
    water_end_hour_roller = water_ui_create_roller(
        66, 187, water_hour_options, snapshot.settings.end_hour);
    colon = water_ui_add_label(water_panel, ":", &lv_font_montserrat_48,
                               WATER_BLUE);
    lv_obj_set_pos(colon, 188, 219);
    water_end_minute_roller = water_ui_create_roller(
        206, 187, water_minute_options, snapshot.settings.end_minute);

    water_time_error = water_ui_add_label(water_panel, "",
                                          &hsp_font_cjk_22, WATER_RED);
    lv_obj_align(water_time_error, LV_ALIGN_TOP_MID, 0, 323);
    water_ui_add_button(water_panel, 24, 364, 342, 68, "保存",
                        WATER_BLUE, &hsp_font_cjk_22,
                        water_ui_save_time_event);
}

static void water_ui_select_interval_event(lv_event_t *event)
{
    water_reminder_snapshot_t snapshot;
    uint16_t minutes;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    minutes = (uint16_t)(uintptr_t)lv_event_get_user_data(event);
    water_reminder_service_get_snapshot(&snapshot);
    snapshot.settings.interval_minutes = minutes;
    if (water_reminder_service_update_settings(&snapshot.settings) != RT_EOK)
        return;
    water_ui_wait_release();
    water_ui_state = WATER_UI_MAIN;
    water_ui_build_current();
}

static void water_ui_build_interval_editor(void)
{
    static const uint16_t intervals[] = {60U, 120U, 180U};
    static const char * const labels[] = {"每 1 小时", "每 2 小时",
                                          "每 3 小时"};
    water_reminder_snapshot_t snapshot;
    lv_obj_t *hint;
    uint8_t index;

    water_reminder_service_get_snapshot(&snapshot);
    water_ui_add_real_header("提醒间隔");
    hint = water_ui_add_label(water_panel, "选择两次提醒之间的时间",
                              &hsp_font_cjk_22, WATER_MUTED);
    lv_obj_align(hint, LV_ALIGN_TOP_MID, 0, 78);

    for (index = 0U; index < 3U; index++)
    {
        lv_obj_t *button = water_ui_add_button(
            water_panel, 45, (lv_coord_t)(118 + index * 92), 300, 72,
            labels[index],
            snapshot.settings.interval_minutes == intervals[index] ?
                WATER_BLUE : WATER_CARD,
            &hsp_font_cjk_22, NULL);
        lv_obj_add_event_cb(button, water_ui_select_interval_event,
                            LV_EVENT_CLICKED,
                            (void *)(uintptr_t)intervals[index]);
    }
}

static void water_ui_drink_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        water_reminder_service_drink();
}

static void water_ui_snooze_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        water_reminder_service_snooze();
}

static void water_ui_skip_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        water_reminder_service_skip();
}

static void water_ui_build_reminder(void)
{
    water_reminder_snapshot_t snapshot;
    lv_obj_t *icon;
    lv_obj_t *title;
    lv_obj_t *detail;
    char detail_text[32];

    water_reminder_service_get_snapshot(&snapshot);
    icon = lv_img_create(water_panel);
    lv_img_set_src(icon, LV_EXT_IMG_GET(water));
    lv_obj_set_size(icon, 64, 64);
    lv_obj_align(icon, LV_ALIGN_TOP_MID, 0, 48);

    title = water_ui_add_label(water_panel, "该喝水啦",
                               &hsp_font_cjk_22, WATER_TEXT);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 130);
    (void)snprintf(detail_text, sizeof(detail_text), "本次 %u ml",
                   (unsigned int)snapshot.settings.serving_ml);
    detail = water_ui_add_label(water_panel, detail_text,
                                &hsp_font_cjk_22, WATER_MUTED);
    lv_obj_align(detail, LV_ALIGN_TOP_MID, 0, 170);

    water_ui_add_button(water_panel, 45, 230, 300, 58, "喝了",
                        WATER_GREEN, &hsp_font_cjk_22,
                        water_ui_drink_event);
    water_ui_add_button(water_panel, 45, 303, 300, 58, "稍后",
                        WATER_BLUE, &hsp_font_cjk_22,
                        water_ui_snooze_event);
    water_ui_add_button(water_panel, 45, 376, 300, 58, "跳过",
                        WATER_CARD, &hsp_font_cjk_22,
                        water_ui_skip_event);
}

static void water_ui_build_current(void)
{
    if (ui_Water == NULL)
        return;

    water_start_hour_roller = NULL;
    water_start_minute_roller = NULL;
    water_end_hour_roller = NULL;
    water_end_minute_roller = NULL;
    water_time_error = NULL;
    lv_obj_clean(ui_Water);
    water_panel = lv_obj_create(ui_Water);
    lv_obj_set_size(water_panel, 390, 450);
    lv_obj_center(water_panel);
    water_ui_style_object(water_panel, WATER_PANEL, LV_OPA_COVER, 45);
    lv_obj_set_style_clip_corner(water_panel, true, LV_PART_MAIN);

    if (water_ui_state == WATER_UI_TIME_EDITOR)
        water_ui_build_time_editor();
    else if (water_ui_state == WATER_UI_INTERVAL_EDITOR)
        water_ui_build_interval_editor();
    else if (water_ui_state == WATER_UI_REMINDER)
        water_ui_build_reminder();
    else
        water_ui_build_main();
}

static uint8_t water_ui_can_present(void)
{
    lv_obj_t *active = lv_scr_act();

    if (alarm_service_is_ringing() || system_power_ui_is_open())
    {
        return 0U;
    }
    if (display_power_is_off())
        return 1U;
    if (active == ui_ScreenHome)
        return 1U;
    return active == ui_Water && water_ui_state == WATER_UI_MAIN;
}

static void water_ui_show_reminder(void)
{
    lv_obj_t *active = lv_scr_act();

    if (home_pager_is_active(HOME_PAGER_PAGE_APP_GRID))
        water_return_target = WATER_RETURN_APP_GRID;
    else if (active == ui_Water)
        water_return_target = WATER_RETURN_WATER;
    else
        water_return_target = WATER_RETURN_HOME;
    water_ui_state = WATER_UI_REMINDER;
    if (ui_Water == NULL)
        ui_Water_screen_init();
    else
        water_ui_build_current();
    lv_scr_load_anim(ui_Water, LV_SCR_LOAD_ANIM_FADE_ON, 160, 0, false);
}

static void water_ui_finish_reminder(void)
{
    water_ui_wait_release();
    if (lv_scr_act() != ui_Water)
    {
        water_ui_state = WATER_UI_MAIN;
        return;
    }
    water_ui_state = WATER_UI_MAIN;
    if (water_return_target == WATER_RETURN_APP_GRID)
        ui_AppGrid_open();
    else if (water_return_target == WATER_RETURN_WATER)
    {
        water_ui_build_current();
        lv_scr_load_anim(ui_Water, LV_SCR_LOAD_ANIM_FADE_ON, 120, 0, false);
    }
    else
    {
        home_pager_load_page(HOME_PAGER_PAGE_HOME,
                             LV_SCR_LOAD_ANIM_FADE_ON, 160);
    }
}

static void water_ui_finish_async(void *user_data)
{
    (void)user_data;
    water_finish_queued = 0U;
    if (water_ui_state == WATER_UI_REMINDER)
        water_ui_finish_reminder();
}

static void water_ui_service_event(water_reminder_event_t event)
{
    if (event == WATER_REMINDER_EVENT_CHANGED)
        water_ui_schedule_refresh();
    else if (event == WATER_REMINDER_EVENT_STARTED)
        water_ui_show_reminder();
    else if (event == WATER_REMINDER_EVENT_STOPPED &&
             water_ui_state == WATER_UI_REMINDER && !water_finish_queued)
    {
        water_finish_queued = 1U;
        if (lv_async_call(water_ui_finish_async, NULL) != LV_RES_OK)
            water_finish_queued = 0U;
    }
}

void ui_Water_init(void)
{
    water_reminder_service_set_event_handler(water_ui_service_event);
    water_reminder_service_set_present_guard(water_ui_can_present);
}

void ui_Water_screen_init(void)
{
    if (ui_Water != NULL)
        return;
    ui_Water = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Water, ui_Water_return);
    lv_obj_clear_flag(ui_Water, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Water, lv_color_hex(WATER_BG), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Water, LV_OPA_COVER, LV_PART_MAIN);
    water_ui_build_current();
}

void ui_Water_screen_destroy(void)
{
    if (ui_Water != NULL)
        lv_obj_del(ui_Water);
    ui_Water = NULL;
    water_panel = NULL;
    water_start_hour_roller = NULL;
    water_start_minute_roller = NULL;
    water_end_hour_roller = NULL;
    water_end_minute_roller = NULL;
    water_time_error = NULL;
}

void ui_Water_open_from_app_grid(void)
{
    water_ui_wait_release();
    water_ui_state = WATER_UI_MAIN;
    if (ui_Water == NULL)
        ui_Water_screen_init();
    else
        water_ui_build_current();
    lv_scr_load_anim(ui_Water, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Water_return(void)
{
    if (water_ui_state == WATER_UI_REMINDER)
    {
        water_reminder_service_skip();
        return;
    }
    if (water_ui_state == WATER_UI_TIME_EDITOR ||
        water_ui_state == WATER_UI_INTERVAL_EDITOR)
    {
        water_ui_wait_release();
        water_ui_state = WATER_UI_MAIN;
        water_ui_build_current();
        return;
    }
    water_ui_wait_release();
    ui_AppGrid_open();
}

uint8_t ui_Water_handle_key(input_wake_key_t key,
                            input_wake_event_t event)
{
    if (ui_Water == NULL || lv_scr_act() != ui_Water)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Water_return();
        return 1U;
    }
    return water_ui_state == WATER_UI_REMINDER ? 1U : 0U;
}
