#include "tomato_ui.h"

#include <stdint.h>
#include <stdio.h>

#include "lv_ext_resource_manager.h"
#include "services/tomato_service.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/ui_swipe_back.h"

LV_IMG_DECLARE(tomato_num0);
LV_IMG_DECLARE(tomato_num1);
LV_IMG_DECLARE(tomato_num2);
LV_IMG_DECLARE(tomato_num3);
LV_IMG_DECLARE(tomato_num4);
LV_IMG_DECLARE(tomato_num5);
LV_IMG_DECLARE(tomato_num6);
LV_IMG_DECLARE(tomato_num7);
LV_IMG_DECLARE(tomato_num8);
LV_IMG_DECLARE(tomato_num9);
LV_IMG_DECLARE(tomato_twopoints);

#define TOMATO_BG             0x050608
#define TOMATO_PANEL          0x090B0F
#define TOMATO_CARD           0x171B22
#define TOMATO_CARD_PRESSED   0x28303A
#define TOMATO_TEXT           0xF5F7FA
#define TOMATO_MUTED          0x8E98A6
#define TOMATO_RED            0xFF625F
#define TOMATO_RED_DARK       0x481D20
#define TOMATO_GREEN          0x55D985
#define TOMATO_GREEN_DARK     0x183A29
#define TOMATO_BLUE           0x3B9DFF
#define TOMATO_BLUE_DARK      0x17334C
#define TOMATO_IMAGE_ZOOM     (176U)
#define TOMATO_IMAGE_CENTER_Y (145)

typedef enum
{
    TOMATO_UI_MAIN,
    TOMATO_UI_SETTINGS,
    TOMATO_UI_END_CONFIRM,
} tomato_ui_state_t;

typedef enum
{
    TOMATO_SETTING_FOCUS,
    TOMATO_SETTING_SHORT_BREAK,
    TOMATO_SETTING_LONG_BREAK,
} tomato_setting_field_t;

lv_obj_t *ui_Tomato = NULL;

static lv_obj_t *tomato_panel;
static lv_obj_t *tomato_digit_images[4];
static lv_obj_t *tomato_colon_image;
static lv_obj_t *tomato_stage_label;
static lv_obj_t *tomato_cycle_label;
static lv_obj_t *tomato_progress;
static lv_obj_t *tomato_primary_label;
static lv_obj_t *tomato_stats_label;
static lv_obj_t *tomato_settings_content;
static lv_obj_t *tomato_settings_value_labels[3];
static lv_timer_t *tomato_ui_timer;
static tomato_ui_state_t tomato_ui_state = TOMATO_UI_MAIN;
static uint8_t tomato_refresh_queued;
static uint8_t tomato_state_queued;
static tomato_ui_state_t tomato_pending_state;

static const void * const tomato_digit_sources[] =
{
    LV_EXT_IMG_GET(tomato_num0),
    LV_EXT_IMG_GET(tomato_num1),
    LV_EXT_IMG_GET(tomato_num2),
    LV_EXT_IMG_GET(tomato_num3),
    LV_EXT_IMG_GET(tomato_num4),
    LV_EXT_IMG_GET(tomato_num5),
    LV_EXT_IMG_GET(tomato_num6),
    LV_EXT_IMG_GET(tomato_num7),
    LV_EXT_IMG_GET(tomato_num8),
    LV_EXT_IMG_GET(tomato_num9),
};

static void tomato_ui_build_current(void);

static void tomato_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void tomato_ui_style_object(lv_obj_t *object, uint32_t color,
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

static lv_obj_t *tomato_ui_add_label(lv_obj_t *parent, const char *text,
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

static lv_obj_t *tomato_ui_add_button(lv_obj_t *parent, lv_coord_t x,
                                      lv_coord_t y, lv_coord_t width,
                                      lv_coord_t height, const char *text,
                                      uint32_t color, uint32_t text_color,
                                      const lv_font_t *font,
                                      lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label;

    lv_obj_set_pos(button, x, y);
    lv_obj_set_size(button, width, height);
    tomato_ui_style_object(button, color, LV_OPA_COVER, height / 2);
    lv_obj_set_style_bg_color(button, lv_color_hex(TOMATO_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    label = tomato_ui_add_label(button, text, font, text_color);
    lv_obj_center(label);
    if (callback != NULL)
        lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);
    return button;
}

static void tomato_ui_async_state(void *user_data)
{
    (void)user_data;
    tomato_state_queued = 0U;
    tomato_ui_state = tomato_pending_state;
    if (ui_Tomato != NULL && lv_scr_act() == ui_Tomato)
        tomato_ui_build_current();
}

static void tomato_ui_queue_state(tomato_ui_state_t state)
{
    tomato_pending_state = state;
    if (tomato_state_queued)
        return;
    tomato_state_queued = 1U;
    if (lv_async_call(tomato_ui_async_state, NULL) != LV_RES_OK)
        tomato_state_queued = 0U;
}

static void tomato_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    tomato_ui_wait_release();
    if (tomato_ui_state == TOMATO_UI_MAIN)
        ui_AppGrid_open();
    else
        tomato_ui_queue_state(TOMATO_UI_MAIN);
}

static void tomato_ui_settings_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
    {
        tomato_ui_wait_release();
        tomato_ui_queue_state(TOMATO_UI_SETTINGS);
    }
}

static void tomato_ui_add_header(const char *title, uint8_t show_settings)
{
    lv_obj_t *back;
    lv_obj_t *label;

    back = tomato_ui_add_button(tomato_panel, 20, 13, 48, 48,
                                LV_SYMBOL_LEFT, TOMATO_CARD, TOMATO_TEXT,
                                &lv_font_montserrat_20,
                                tomato_ui_back_event);
    (void)back;
    label = tomato_ui_add_label(tomato_panel, title, &hsp_font_cjk_22,
                                TOMATO_TEXT);
    lv_obj_set_pos(label, 80, 25);
    if (show_settings)
    {
        tomato_ui_add_button(tomato_panel, 304, 10, 54, 54,
                             LV_SYMBOL_SETTINGS, TOMATO_CARD, TOMATO_BLUE,
                             &lv_font_montserrat_20,
                             tomato_ui_settings_event);
    }
}

static const char *tomato_ui_stage_text(const tomato_snapshot_t *snapshot)
{
    if (snapshot->run_state == TOMATO_RUN_PAUSED)
        return "已暂停";
    if (snapshot->phase == TOMATO_PHASE_SHORT_BREAK)
        return snapshot->run_state == TOMATO_RUN_IDLE ?
               "准备短休息" : "短休息中";
    if (snapshot->phase == TOMATO_PHASE_LONG_BREAK)
        return snapshot->run_state == TOMATO_RUN_IDLE ?
               "准备长休息" : "长休息中";
    return snapshot->run_state == TOMATO_RUN_IDLE ?
           "准备专注" : "专注中";
}

static uint32_t tomato_ui_phase_color(const tomato_snapshot_t *snapshot)
{
    return snapshot->phase == TOMATO_PHASE_FOCUS ?
           TOMATO_RED : TOMATO_GREEN;
}

static void tomato_ui_set_countdown(uint32_t remaining_seconds)
{
    uint32_t minutes = remaining_seconds / 60U;
    uint32_t seconds = remaining_seconds % 60U;
    uint8_t digits[4];

    if (minutes > 99U)
        minutes = 99U;
    digits[0] = (uint8_t)(minutes / 10U);
    digits[1] = (uint8_t)(minutes % 10U);
    digits[2] = (uint8_t)(seconds / 10U);
    digits[3] = (uint8_t)(seconds % 10U);
    if (tomato_digit_images[0] == NULL)
        return;

    lv_img_set_src(tomato_digit_images[0], tomato_digit_sources[digits[0]]);
    lv_img_set_src(tomato_digit_images[1], tomato_digit_sources[digits[1]]);
    lv_img_set_src(tomato_digit_images[2], tomato_digit_sources[digits[2]]);
    lv_img_set_src(tomato_digit_images[3], tomato_digit_sources[digits[3]]);
}

static lv_obj_t *tomato_ui_add_time_image(const void *source,
                                          lv_coord_t center_x)
{
    lv_obj_t *image = lv_img_create(tomato_panel);

    lv_img_set_src(image, source);
    lv_obj_set_size(image, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
    lv_img_set_pivot(image, 64, 64);
    lv_img_set_zoom(image, TOMATO_IMAGE_ZOOM);
    lv_obj_set_pos(image, center_x - 64, TOMATO_IMAGE_CENTER_Y - 64);
    lv_obj_clear_flag(image, LV_OBJ_FLAG_SCROLLABLE);
    return image;
}

static void tomato_ui_refresh_main(void)
{
    tomato_snapshot_t snapshot;
    uint32_t elapsed;
    uint16_t progress_value;
    char cycle_text[48];
    char stats_text[64];

    if (tomato_ui_state != TOMATO_UI_MAIN ||
        tomato_stage_label == NULL)
        return;

    tomato_service_get_snapshot(&snapshot);
    lv_label_set_text(tomato_stage_label, tomato_ui_stage_text(&snapshot));
    lv_obj_set_style_text_color(tomato_stage_label,
                                lv_color_hex(tomato_ui_phase_color(&snapshot)),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    tomato_ui_set_countdown(snapshot.remaining_seconds);

    elapsed = snapshot.phase_total_seconds > snapshot.remaining_seconds ?
              snapshot.phase_total_seconds - snapshot.remaining_seconds : 0U;
    progress_value = snapshot.phase_total_seconds == 0U ? 0U :
        (uint16_t)((elapsed * 100U) / snapshot.phase_total_seconds);
    if (progress_value > 100U)
        progress_value = 100U;
    lv_bar_set_value(tomato_progress, progress_value, LV_ANIM_OFF);
    lv_obj_set_style_bg_color(tomato_progress,
                              lv_color_hex(tomato_ui_phase_color(&snapshot)),
                              LV_PART_INDICATOR);

    (void)snprintf(cycle_text, sizeof(cycle_text), "本轮 %u / %u",
                   (unsigned int)snapshot.cycle_pomodoros,
                   (unsigned int)TOMATO_LONG_BREAK_AFTER_COUNT);
    lv_label_set_text(tomato_cycle_label, cycle_text);
    lv_label_set_text(tomato_primary_label,
                      snapshot.run_state == TOMATO_RUN_IDLE ? "开始" :
                      snapshot.run_state == TOMATO_RUN_RUNNING ? "暂停" :
                                                                "继续");
    (void)snprintf(stats_text, sizeof(stats_text),
                   "今日 %u 个 · 专注 %lu 分钟",
                   (unsigned int)snapshot.today_pomodoros,
                   (unsigned long)snapshot.today_focus_minutes);
    lv_label_set_text(tomato_stats_label, stats_text);
}

static void tomato_ui_primary_event(lv_event_t *event)
{
    tomato_snapshot_t snapshot;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    tomato_service_get_snapshot(&snapshot);
    if (snapshot.run_state == TOMATO_RUN_IDLE)
        (void)tomato_service_start();
    else if (snapshot.run_state == TOMATO_RUN_RUNNING)
        (void)tomato_service_pause();
    else
        (void)tomato_service_resume();
}

static void tomato_ui_skip_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        (void)tomato_service_skip();
}

static void tomato_ui_end_open_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
    {
        tomato_ui_wait_release();
        tomato_ui_queue_state(TOMATO_UI_END_CONFIRM);
    }
}

static void tomato_ui_build_main(void)
{
    tomato_snapshot_t snapshot;
    lv_obj_t *primary;
    lv_obj_t *skip;
    lv_obj_t *end;
    static const lv_coord_t centers[5] = {58, 127, 195, 263, 332};

    tomato_service_get_snapshot(&snapshot);
    tomato_ui_add_header("番茄钟", 1U);
    tomato_stage_label = tomato_ui_add_label(tomato_panel, "",
                                             &hsp_font_cjk_22, TOMATO_RED);
    lv_obj_align(tomato_stage_label, LV_ALIGN_TOP_MID, 0, 67);

    tomato_digit_images[0] = tomato_ui_add_time_image(
        tomato_digit_sources[0], centers[0]);
    tomato_digit_images[1] = tomato_ui_add_time_image(
        tomato_digit_sources[0], centers[1]);
    tomato_colon_image = tomato_ui_add_time_image(
        LV_EXT_IMG_GET(tomato_twopoints), centers[2]);
    tomato_digit_images[2] = tomato_ui_add_time_image(
        tomato_digit_sources[0], centers[3]);
    tomato_digit_images[3] = tomato_ui_add_time_image(
        tomato_digit_sources[0], centers[4]);
    (void)tomato_colon_image;

    tomato_progress = lv_bar_create(tomato_panel);
    lv_obj_set_pos(tomato_progress, 42, 205);
    lv_obj_set_size(tomato_progress, 306, 10);
    lv_bar_set_range(tomato_progress, 0, 100);
    lv_obj_set_style_radius(tomato_progress, 5, LV_PART_MAIN);
    lv_obj_set_style_bg_color(tomato_progress, lv_color_hex(0x252B34),
                              LV_PART_MAIN);
    lv_obj_set_style_radius(tomato_progress, 5, LV_PART_INDICATOR);

    tomato_cycle_label = tomato_ui_add_label(tomato_panel, "",
                                             &hsp_font_cjk_22,
                                             TOMATO_MUTED);
    lv_obj_align(tomato_cycle_label, LV_ALIGN_TOP_MID, 0, 221);

    primary = tomato_ui_add_button(tomato_panel, 24, 253, 342, 62, "",
                                   snapshot.phase == TOMATO_PHASE_FOCUS ?
                                   TOMATO_RED_DARK : TOMATO_GREEN_DARK,
                                   snapshot.phase == TOMATO_PHASE_FOCUS ?
                                   TOMATO_RED : TOMATO_GREEN,
                                   &hsp_font_cjk_22,
                                   tomato_ui_primary_event);
    tomato_primary_label = lv_obj_get_child(primary, 0);

    skip = tomato_ui_add_button(tomato_panel, 24, 327, 164, 58, "跳过",
                                TOMATO_CARD, TOMATO_BLUE,
                                &hsp_font_cjk_22, tomato_ui_skip_event);
    end = tomato_ui_add_button(tomato_panel, 202, 327, 164, 58, "结束",
                               TOMATO_CARD, TOMATO_RED,
                               &hsp_font_cjk_22, tomato_ui_end_open_event);
    if (snapshot.run_state == TOMATO_RUN_IDLE)
    {
        lv_obj_add_state(skip, LV_STATE_DISABLED);
        lv_obj_add_state(end, LV_STATE_DISABLED);
        lv_obj_set_style_opa(skip, LV_OPA_40,
                             LV_PART_MAIN | LV_STATE_DISABLED);
        lv_obj_set_style_opa(end, LV_OPA_40,
                             LV_PART_MAIN | LV_STATE_DISABLED);
    }

    tomato_stats_label = tomato_ui_add_label(tomato_panel, "",
                                             &hsp_font_cjk_22,
                                             TOMATO_MUTED);
    lv_obj_align(tomato_stats_label, LV_ALIGN_BOTTOM_MID, 0, -12);
    tomato_ui_refresh_main();
}

static void tomato_ui_adjust_event(lv_event_t *event)
{
    uintptr_t command;
    tomato_setting_field_t field;
    uint8_t increase;
    tomato_snapshot_t snapshot;
    uint16_t *value;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    command = (uintptr_t)lv_event_get_user_data(event);
    field = (tomato_setting_field_t)(command >> 1);
    increase = (uint8_t)(command & 1U);
    tomato_service_get_snapshot(&snapshot);
    if (field == TOMATO_SETTING_SHORT_BREAK)
        value = &snapshot.settings.short_break_minutes;
    else if (field == TOMATO_SETTING_LONG_BREAK)
        value = &snapshot.settings.long_break_minutes;
    else
        value = &snapshot.settings.focus_minutes;

    if (increase && *value < 99U)
        (*value)++;
    else if (!increase && *value > 1U)
        (*value)--;
    (void)tomato_service_update_settings(&snapshot.settings);
    if (field <= TOMATO_SETTING_LONG_BREAK &&
        tomato_settings_value_labels[field] != NULL)
    {
        char value_text[8];

        (void)snprintf(value_text, sizeof(value_text), "%u",
                       (unsigned int)*value);
        lv_label_set_text(tomato_settings_value_labels[field], value_text);
    }
}

static void tomato_ui_add_duration_row(lv_coord_t y, const char *title,
                                       uint16_t value,
                                       tomato_setting_field_t field)
{
    lv_obj_t *row = lv_obj_create(tomato_settings_content);
    lv_obj_t *label;
    lv_obj_t *value_label;
    lv_obj_t *minus;
    lv_obj_t *plus;
    char value_text[16];

    lv_obj_set_pos(row, 20, y);
    lv_obj_set_size(row, 350, 84);
    tomato_ui_style_object(row, TOMATO_CARD, LV_OPA_COVER, 34);
    label = tomato_ui_add_label(row, title, &hsp_font_cjk_22, TOMATO_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 18, 0);

    minus = tomato_ui_add_button(row, 150, 12, 60, 60, "-",
                                 TOMATO_BLUE_DARK, TOMATO_BLUE,
                                 &lv_font_montserrat_30, NULL);
    lv_obj_add_event_cb(minus, tomato_ui_adjust_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)((uint32_t)field << 1));
    (void)snprintf(value_text, sizeof(value_text), "%u",
                   (unsigned int)value);
    value_label = tomato_ui_add_label(row, value_text,
                                      &lv_font_montserrat_30, TOMATO_TEXT);
    lv_obj_align(value_label, LV_ALIGN_CENTER, 70, 0);
    tomato_settings_value_labels[field] = value_label;
    plus = tomato_ui_add_button(row, 280, 12, 60, 60, LV_SYMBOL_PLUS,
                                TOMATO_BLUE_DARK, TOMATO_BLUE,
                                &lv_font_montserrat_30, NULL);
    lv_obj_add_event_cb(plus, tomato_ui_adjust_event, LV_EVENT_CLICKED,
                        (void *)(uintptr_t)(((uint32_t)field << 1) | 1U));
}

static void tomato_ui_toggle_event(lv_event_t *event)
{
    tomato_snapshot_t snapshot;
    uintptr_t field;
    uint8_t checked;

    if (lv_event_get_code(event) != LV_EVENT_VALUE_CHANGED)
        return;
    tomato_service_get_snapshot(&snapshot);
    field = (uintptr_t)lv_event_get_user_data(event);
    checked = lv_obj_has_state(lv_event_get_target(event),
                               LV_STATE_CHECKED) ? 1U : 0U;
    if (field == 0U)
        snapshot.settings.vibration_enabled = checked;
    else
        snapshot.settings.sound_enabled = checked;
    (void)tomato_service_update_settings(&snapshot.settings);
}

static void tomato_ui_add_toggle_row(lv_coord_t y, const char *title,
                                     uint8_t checked, uintptr_t field)
{
    lv_obj_t *row = lv_obj_create(tomato_settings_content);
    lv_obj_t *label;
    lv_obj_t *toggle;

    lv_obj_set_pos(row, 20, y);
    lv_obj_set_size(row, 350, 76);
    tomato_ui_style_object(row, TOMATO_CARD, LV_OPA_COVER, 32);
    label = tomato_ui_add_label(row, title, &hsp_font_cjk_22, TOMATO_TEXT);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 18, 0);
    toggle = lv_switch_create(row);
    lv_obj_set_size(toggle, 78, 44);
    lv_obj_align(toggle, LV_ALIGN_RIGHT_MID, -16, 0);
    lv_obj_set_style_bg_color(toggle, lv_color_hex(TOMATO_BLUE),
                              LV_PART_INDICATOR | LV_STATE_CHECKED);
    if (checked)
        lv_obj_add_state(toggle, LV_STATE_CHECKED);
    lv_obj_add_event_cb(toggle, tomato_ui_toggle_event,
                        LV_EVENT_VALUE_CHANGED, (void *)field);
}

static void tomato_ui_build_settings(void)
{
    tomato_snapshot_t snapshot;

    tomato_service_get_snapshot(&snapshot);
    tomato_ui_add_header("番茄设置", 0U);
    tomato_settings_content = lv_obj_create(tomato_panel);
    lv_obj_set_pos(tomato_settings_content, 0, 72);
    lv_obj_set_size(tomato_settings_content, 390, 378);
    tomato_ui_style_object(tomato_settings_content, TOMATO_PANEL,
                           LV_OPA_TRANSP, 0);
    lv_obj_add_flag(tomato_settings_content, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scroll_dir(tomato_settings_content, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(tomato_settings_content,
                              LV_SCROLLBAR_MODE_AUTO);
    lv_obj_set_style_pad_bottom(tomato_settings_content, 22,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    tomato_ui_add_duration_row(4, "专注时间",
                               snapshot.settings.focus_minutes,
                               TOMATO_SETTING_FOCUS);
    tomato_ui_add_duration_row(100, "短休息",
                               snapshot.settings.short_break_minutes,
                               TOMATO_SETTING_SHORT_BREAK);
    tomato_ui_add_duration_row(196, "长休息",
                               snapshot.settings.long_break_minutes,
                               TOMATO_SETTING_LONG_BREAK);
    tomato_ui_add_toggle_row(292, "震动提醒",
                             snapshot.settings.vibration_enabled, 0U);
    tomato_ui_add_toggle_row(380, "提示音",
                             snapshot.settings.sound_enabled, 1U);
}

static void tomato_ui_confirm_cancel_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
    {
        tomato_ui_wait_release();
        tomato_ui_queue_state(TOMATO_UI_MAIN);
    }
}

static void tomato_ui_confirm_end_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    (void)tomato_service_end();
    tomato_ui_wait_release();
    tomato_ui_queue_state(TOMATO_UI_MAIN);
}

static void tomato_ui_build_end_confirm(void)
{
    tomato_snapshot_t snapshot;
    lv_obj_t *mark;
    lv_obj_t *title;
    lv_obj_t *detail;
    lv_obj_t *stage;

    tomato_service_get_snapshot(&snapshot);
    tomato_ui_add_header("结束番茄钟", 0U);
    mark = tomato_ui_add_label(tomato_panel, "!", &lv_font_montserrat_48,
                               TOMATO_RED);
    lv_obj_align(mark, LV_ALIGN_TOP_MID, 0, 88);
    title = tomato_ui_add_label(tomato_panel, "确定结束当前计时？",
                                &hsp_font_cjk_22, TOMATO_TEXT);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 162);
    detail = tomato_ui_add_label(tomato_panel, "当前进度不会计入今日统计",
                                 &hsp_font_cjk_22, TOMATO_MUTED);
    lv_obj_align(detail, LV_ALIGN_TOP_MID, 0, 207);
    stage = tomato_ui_add_label(tomato_panel,
                                tomato_ui_stage_text(&snapshot),
                                &hsp_font_cjk_22,
                                tomato_ui_phase_color(&snapshot));
    lv_obj_align(stage, LV_ALIGN_TOP_MID, 0, 252);
    tomato_ui_add_button(tomato_panel, 24, 334, 164, 66, "取消",
                         TOMATO_CARD, TOMATO_TEXT, &hsp_font_cjk_22,
                         tomato_ui_confirm_cancel_event);
    tomato_ui_add_button(tomato_panel, 202, 334, 164, 66, "结束",
                         TOMATO_RED_DARK, TOMATO_RED, &hsp_font_cjk_22,
                         tomato_ui_confirm_end_event);
}

static void tomato_ui_build_current(void)
{
    uint8_t index;

    if (ui_Tomato == NULL)
        return;

    for (index = 0U; index < 4U; index++)
        tomato_digit_images[index] = NULL;
    tomato_colon_image = NULL;
    tomato_stage_label = NULL;
    tomato_cycle_label = NULL;
    tomato_progress = NULL;
    tomato_primary_label = NULL;
    tomato_stats_label = NULL;
    tomato_settings_content = NULL;
    for (index = 0U; index < 3U; index++)
        tomato_settings_value_labels[index] = NULL;

    lv_obj_clean(ui_Tomato);
    tomato_panel = lv_obj_create(ui_Tomato);
    lv_obj_set_size(tomato_panel, 390, 450);
    lv_obj_center(tomato_panel);
    tomato_ui_style_object(tomato_panel, TOMATO_PANEL, LV_OPA_COVER, 45);
    lv_obj_set_style_clip_corner(tomato_panel, true, LV_PART_MAIN);

    if (tomato_ui_state == TOMATO_UI_SETTINGS)
        tomato_ui_build_settings();
    else if (tomato_ui_state == TOMATO_UI_END_CONFIRM)
        tomato_ui_build_end_confirm();
    else
        tomato_ui_build_main();
}

static void tomato_ui_async_refresh(void *user_data)
{
    (void)user_data;
    tomato_refresh_queued = 0U;
    if (ui_Tomato != NULL && lv_scr_act() == ui_Tomato &&
        tomato_ui_state == TOMATO_UI_MAIN)
        tomato_ui_refresh_main();
    else if (ui_Tomato != NULL && lv_scr_act() == ui_Tomato &&
             tomato_ui_state == TOMATO_UI_END_CONFIRM)
        tomato_ui_build_current();
}

static void tomato_ui_service_event(tomato_event_t event)
{
    (void)event;
    if (tomato_refresh_queued)
        return;
    tomato_refresh_queued = 1U;
    if (lv_async_call(tomato_ui_async_refresh, NULL) != LV_RES_OK)
        tomato_refresh_queued = 0U;
}

static void tomato_ui_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    if (ui_Tomato != NULL && lv_scr_act() == ui_Tomato &&
        tomato_ui_state == TOMATO_UI_MAIN)
        tomato_ui_refresh_main();
}

void ui_Tomato_init(void)
{
    tomato_service_set_event_handler(tomato_ui_service_event);
    if (tomato_ui_timer == NULL)
        tomato_ui_timer = lv_timer_create(tomato_ui_timer_cb, 250U, NULL);
}

void ui_Tomato_screen_init(void)
{
    if (ui_Tomato != NULL)
        return;

    ui_Tomato = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Tomato, ui_Tomato_return);
    lv_obj_clear_flag(ui_Tomato, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Tomato, lv_color_hex(TOMATO_BG),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Tomato, LV_OPA_COVER, LV_PART_MAIN);
    tomato_ui_build_current();
}

void ui_Tomato_screen_destroy(void)
{
    if (ui_Tomato != NULL)
        lv_obj_del(ui_Tomato);
    ui_Tomato = NULL;
    tomato_panel = NULL;
}

void ui_Tomato_open_from_app_grid(void)
{
    tomato_ui_wait_release();
    tomato_ui_state = TOMATO_UI_MAIN;
    if (ui_Tomato == NULL)
        ui_Tomato_screen_init();
    else
        tomato_ui_build_current();
    lv_scr_load_anim(ui_Tomato, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Tomato_return(void)
{
    if (tomato_ui_state != TOMATO_UI_MAIN)
    {
        tomato_ui_wait_release();
        tomato_ui_state = TOMATO_UI_MAIN;
        tomato_ui_build_current();
        return;
    }
    tomato_ui_wait_release();
    ui_AppGrid_open();
}

uint8_t ui_Tomato_handle_key(input_wake_key_t key,
                             input_wake_event_t event)
{
    if (ui_Tomato == NULL || lv_scr_act() != ui_Tomato)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Tomato_return();
        return 1U;
    }
    return 0U;
}
