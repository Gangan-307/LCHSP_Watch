#include "activity_ui.h"

#include <stdint.h>

#include "lv_ext_resource_manager.h"
#include "services/activity_tracker.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/ui_helpers.h"
#include "ui/generated/ui_swipe_back.h"

#define ACTIVITY_UI_BG             0x050608
#define ACTIVITY_UI_CARD           0x14191F
#define ACTIVITY_UI_CARD_BORDER    0x2A323C
#define ACTIVITY_UI_CARD_PRESSED   0x202731
#define ACTIVITY_UI_TEXT           0xF5F7FA
#define ACTIVITY_UI_MUTED          0x8994A2
#define ACTIVITY_UI_STEPS          0x4CB6FF
#define ACTIVITY_UI_CALORIES       0xFF6672
#define ACTIVITY_UI_DISTANCE       0x65DF8A
#define ACTIVITY_UI_CARD_X         28
#define ACTIVITY_UI_CARD_WIDTH     334
#define ACTIVITY_UI_CARD_HEIGHT    96
#define ACTIVITY_UI_REFRESH_MS     1000U

LV_IMG_DECLARE(steps);
LV_IMG_DECLARE(cal);
LV_IMG_DECLARE(km);

lv_obj_t *ui_Activity = NULL;

static lv_obj_t *activity_steps_value;
static lv_obj_t *activity_calories_value;
static lv_obj_t *activity_distance_value;
static lv_obj_t *activity_status_label;
static lv_timer_t *activity_refresh_timer;

static void activity_ui_refresh(void);

static void activity_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void activity_ui_style_plain(lv_obj_t *object, uint32_t background,
                                    lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, radius,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(object, lv_color_hex(background),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(object, opacity,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(object, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(object, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(object, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(object, 0,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *activity_ui_add_label(lv_obj_t *parent, const char *text,
                                       const lv_font_t *font,
                                       uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_align(label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    return label;
}

static lv_obj_t *activity_ui_add_metric(lv_obj_t *parent, lv_coord_t y,
                                        const void *icon_source,
                                        const char *name, const char *unit,
                                        uint32_t accent)
{
    lv_obj_t *card = lv_obj_create(parent);
    lv_obj_t *accent_line;
    lv_obj_t *icon;
    lv_obj_t *name_label;
    lv_obj_t *value_label;
    lv_obj_t *unit_label;

    lv_obj_set_pos(card, ACTIVITY_UI_CARD_X, y);
    lv_obj_set_size(card, ACTIVITY_UI_CARD_WIDTH, ACTIVITY_UI_CARD_HEIGHT);
    activity_ui_style_plain(card, ACTIVITY_UI_CARD, LV_OPA_COVER, 8);
    lv_obj_set_style_border_color(card, lv_color_hex(ACTIVITY_UI_CARD_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(card, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);

    accent_line = lv_obj_create(card);
    lv_obj_set_pos(accent_line, 0, 18);
    lv_obj_set_size(accent_line, 4, 60);
    activity_ui_style_plain(accent_line, accent, LV_OPA_COVER, 2);

    icon = lv_img_create(card);
    lv_img_set_src(icon, icon_source);
    lv_obj_set_pos(icon, 22, 32);
    lv_obj_set_size(icon, 32, 32);
    lv_obj_clear_flag(icon, LV_OBJ_FLAG_SCROLLABLE);

    name_label = activity_ui_add_label(card, name, &hsp_font_cjk_22,
                                       ACTIVITY_UI_TEXT);
    lv_obj_set_pos(name_label, 72, 13);
    lv_obj_set_size(name_label, 120, 28);
    lv_obj_set_style_text_align(name_label, LV_TEXT_ALIGN_LEFT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    value_label = activity_ui_add_label(card, "--", &lv_font_montserrat_30,
                                        accent);
    lv_obj_set_pos(value_label, 72, 45);
    lv_obj_set_size(value_label, 180, 40);
    lv_label_set_long_mode(value_label, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_align(value_label, LV_TEXT_ALIGN_LEFT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    unit_label = activity_ui_add_label(card, unit, &lv_font_montserrat_16,
                                       ACTIVITY_UI_MUTED);
    lv_obj_set_pos(unit_label, 250, 57);
    lv_obj_set_size(unit_label, 62, 22);
    lv_obj_set_style_text_align(unit_label, LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    return value_label;
}

static void activity_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Activity_return();
}

static void activity_ui_screen_event(lv_event_t *event)
{
    lv_event_code_t code = lv_event_get_code(event);

    if (code == LV_EVENT_SCREEN_LOADED)
    {
        if (activity_refresh_timer != NULL)
            lv_timer_resume(activity_refresh_timer);
        activity_ui_refresh();
    }
    else if (code == LV_EVENT_SCREEN_UNLOADED &&
             activity_refresh_timer != NULL)
    {
        lv_timer_pause(activity_refresh_timer);
    }
}

static void activity_ui_refresh(void)
{
    activity_metrics_t metrics;
    uint64_t distance_hundredths;

    if (activity_steps_value == NULL || activity_calories_value == NULL ||
        activity_distance_value == NULL || activity_status_label == NULL)
        return;

    activity_tracker_get_metrics(&metrics);
    if (!metrics.valid)
    {
        lv_label_set_text(activity_steps_value, "--");
        lv_label_set_text(activity_calories_value, "--");
        lv_label_set_text(activity_distance_value, "--");
        lv_label_set_text(activity_status_label, "运动传感器不可用");
        return;
    }

    distance_hundredths = ((uint64_t)metrics.distance_meters + 5U) / 10U;
    lv_label_set_text_fmt(activity_steps_value, "%lu",
                          (unsigned long)metrics.steps);
    lv_label_set_text_fmt(activity_calories_value, "%u",
                          (unsigned int)metrics.calories_kcal);
    lv_label_set_text_fmt(activity_distance_value, "%lu.%02lu",
                          (unsigned long)(distance_hundredths / 100U),
                          (unsigned long)(distance_hundredths % 100U));
    lv_label_set_text(activity_status_label, "今日活动");
}

static void activity_ui_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    if (ui_Activity != NULL && lv_scr_act() == ui_Activity)
        activity_ui_refresh();
}

void ui_Activity_screen_init(void)
{
    lv_obj_t *back_button;
    lv_obj_t *label;

    if (ui_Activity != NULL)
        return;

    ui_Activity = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Activity, ui_Activity_return);
    activity_ui_style_plain(ui_Activity, ACTIVITY_UI_BG, LV_OPA_COVER, 0);
    lv_obj_add_event_cb(ui_Activity, activity_ui_screen_event,
                        LV_EVENT_ALL, NULL);

    back_button = lv_btn_create(ui_Activity);
    lv_obj_set_pos(back_button, 20, 12);
    lv_obj_set_size(back_button, 50, 50);
    activity_ui_style_plain(back_button, ACTIVITY_UI_CARD, LV_OPA_TRANSP,
                            LV_RADIUS_CIRCLE);
    lv_obj_set_style_bg_color(back_button,
                              lv_color_hex(ACTIVITY_UI_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(back_button, activity_ui_back_event,
                        LV_EVENT_CLICKED, NULL);
    label = activity_ui_add_label(back_button, LV_SYMBOL_LEFT,
                                  &lv_font_montserrat_20, ACTIVITY_UI_TEXT);
    lv_obj_center(label);

    label = activity_ui_add_label(ui_Activity, "运动", &hsp_font_cjk_22,
                                  ACTIVITY_UI_TEXT);
    lv_obj_set_pos(label, 115, 18);
    lv_obj_set_size(label, 160, 30);

    activity_status_label = activity_ui_add_label(
        ui_Activity, "今日活动", &hsp_font_cjk_22, ACTIVITY_UI_MUTED);
    lv_obj_set_pos(activity_status_label, 100, 52);
    lv_obj_set_size(activity_status_label, 190, 28);

    activity_steps_value = activity_ui_add_metric(
        ui_Activity, 86, LV_EXT_IMG_GET(steps), "步数", "步",
        ACTIVITY_UI_STEPS);
    activity_calories_value = activity_ui_add_metric(
        ui_Activity, 194, LV_EXT_IMG_GET(cal), "卡路里", "kcal",
        ACTIVITY_UI_CALORIES);
    activity_distance_value = activity_ui_add_metric(
        ui_Activity, 302, LV_EXT_IMG_GET(km), "距离", "km",
        ACTIVITY_UI_DISTANCE);

    activity_refresh_timer = lv_timer_create(activity_ui_refresh_timer_cb,
                                              ACTIVITY_UI_REFRESH_MS, NULL);
    lv_timer_pause(activity_refresh_timer);
    activity_ui_refresh();
}

void ui_Activity_screen_destroy(void)
{
    if (activity_refresh_timer != NULL)
        lv_timer_del(activity_refresh_timer);
    activity_refresh_timer = NULL;

    if (ui_Activity != NULL)
        lv_obj_del(ui_Activity);
    ui_Activity = NULL;
    activity_steps_value = NULL;
    activity_calories_value = NULL;
    activity_distance_value = NULL;
    activity_status_label = NULL;
}

void ui_Activity_open_from_app_grid(void)
{
    activity_ui_wait_release();
    if (ui_Activity == NULL)
        ui_Activity_screen_init();
    if (activity_refresh_timer != NULL)
        lv_timer_resume(activity_refresh_timer);
    activity_ui_refresh();
    lv_scr_load_anim(ui_Activity, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Activity_return(void)
{
    lv_obj_t *screen = ui_Activity;

    activity_ui_wait_release();
    if (activity_refresh_timer != NULL)
        lv_timer_pause(activity_refresh_timer);
    if (screen != NULL)
        lv_obj_add_event_cb(screen, scr_unloaded_delete_cb,
                            LV_EVENT_SCREEN_UNLOADED,
                            ui_Activity_screen_destroy);
    ui_AppGrid_open();
}
