#include "compass_ui.h"

#include <stdint.h>
#include <stdio.h>

#include "services/compass_service.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"

#define COMPASS_BG                    0x050608
#define COMPASS_PANEL                 0x080A0E
#define COMPASS_BORDER                0x26313D
#define COMPASS_TEXT                  0xF5F7FA
#define COMPASS_MUTED                 0x8E98A6
#define COMPASS_RED                   0xFF4D57
#define COMPASS_BLUE                  0x3B9DFF
#define COMPASS_BLUE_DARK             0x18324B
#define COMPASS_GREEN                 0x56D48A
#define COMPASS_AMBER                 0xF4BE4F
#define COMPASS_DIAL_SIZE             (228)
#define COMPASS_DIAL_CENTER           (COMPASS_DIAL_SIZE / 2)
#define COMPASS_DIAL_OUTER_RADIUS     (106)
#define COMPASS_NEEDLE_RADIUS         (72)
#define COMPASS_TICK_COUNT            (36U)
#define COMPASS_REFRESH_PERIOD_MS     (80U)

lv_obj_t *ui_Compass = NULL;

static lv_obj_t *compass_panel;
static lv_obj_t *compass_heading_label;
static lv_obj_t *compass_direction_label;
static lv_obj_t *compass_quality_label;
static lv_obj_t *compass_north_line;
static lv_obj_t *compass_south_line;
static lv_obj_t *compass_calibrate_button;
static lv_obj_t *compass_calibrate_label;
static lv_timer_t *compass_refresh_timer;
static lv_point_t compass_tick_points[COMPASS_TICK_COUNT][2];
static lv_point_t compass_north_points[2];
static lv_point_t compass_south_points[2];

static void compass_ui_refresh(void);

static void compass_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void compass_ui_style_plain(lv_obj_t *object, uint32_t background,
                                   lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, radius, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(object, lv_color_hex(background),
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

static lv_obj_t *compass_ui_add_label(lv_obj_t *parent, const char *text,
                                      const lv_font_t *font, uint32_t color)
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

static void compass_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Compass_return();
}

static void compass_ui_calibrate_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;

    compass_service_reset_calibration();
    compass_ui_refresh();
}

static void compass_ui_screen_event(lv_event_t *event)
{
    lv_event_code_t code = lv_event_get_code(event);

    if (code == LV_EVENT_SCREEN_LOADED)
    {
        compass_service_set_active(1U);
        if (compass_refresh_timer != NULL)
            lv_timer_resume(compass_refresh_timer);
        compass_ui_refresh();
    }
    else if (code == LV_EVENT_SCREEN_UNLOADED)
    {
        compass_service_set_active(0U);
        if (compass_refresh_timer != NULL)
            lv_timer_pause(compass_refresh_timer);
    }
}

static void compass_ui_set_line_style(lv_obj_t *line, uint32_t color,
                                      lv_coord_t width)
{
    lv_obj_set_style_line_color(line, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_line_width(line, width,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_line_rounded(line, true,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void compass_ui_add_ticks(lv_obj_t *dial)
{
    uint8_t index;

    for (index = 0U; index < COMPASS_TICK_COUNT; index++)
    {
        int16_t angle = (int16_t)(index * 10U);
        int32_t sine = lv_trigo_sin(angle);
        int32_t cosine = lv_trigo_sin((int16_t)(angle + 90));
        lv_coord_t inner_radius;
        lv_obj_t *tick;
        uint32_t color;
        lv_coord_t width;

        if ((index % 9U) == 0U)
        {
            inner_radius = 91;
            width = 4;
            color = index == 0U ? COMPASS_RED : COMPASS_TEXT;
        }
        else if ((index % 3U) == 0U)
        {
            inner_radius = 96;
            width = 3;
            color = COMPASS_MUTED;
        }
        else
        {
            inner_radius = 100;
            width = 2;
            color = COMPASS_BORDER;
        }

        compass_tick_points[index][0].x =
            (lv_coord_t)(COMPASS_DIAL_CENTER +
                         ((sine * COMPASS_DIAL_OUTER_RADIUS) >> LV_TRIGO_SHIFT));
        compass_tick_points[index][0].y =
            (lv_coord_t)(COMPASS_DIAL_CENTER -
                         ((cosine * COMPASS_DIAL_OUTER_RADIUS) >> LV_TRIGO_SHIFT));
        compass_tick_points[index][1].x =
            (lv_coord_t)(COMPASS_DIAL_CENTER +
                         ((sine * inner_radius) >> LV_TRIGO_SHIFT));
        compass_tick_points[index][1].y =
            (lv_coord_t)(COMPASS_DIAL_CENTER -
                         ((cosine * inner_radius) >> LV_TRIGO_SHIFT));

        tick = lv_line_create(dial);
        lv_line_set_points(tick, compass_tick_points[index], 2U);
        compass_ui_set_line_style(tick, color, width);
    }
}

static void compass_ui_add_cardinal(lv_obj_t *dial, const char *text,
                                    lv_coord_t x, lv_coord_t y,
                                    uint32_t color)
{
    lv_obj_t *label = compass_ui_add_label(dial, text,
                                           &lv_font_montserrat_20, color);

    lv_obj_set_size(label, 32, 26);
    lv_obj_set_pos(label, x, y);
}

static void compass_ui_build_dial(lv_obj_t *parent)
{
    lv_obj_t *dial = lv_obj_create(parent);
    lv_obj_t *center_dot;

    lv_obj_set_size(dial, COMPASS_DIAL_SIZE, COMPASS_DIAL_SIZE);
    lv_obj_set_pos(dial, 81, 154);
    compass_ui_style_plain(dial, COMPASS_PANEL, LV_OPA_COVER,
                           LV_RADIUS_CIRCLE);
    lv_obj_set_style_border_color(dial, lv_color_hex(COMPASS_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(dial, 2,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(dial, true,
                                 LV_PART_MAIN | LV_STATE_DEFAULT);

    compass_ui_add_ticks(dial);
    compass_ui_add_cardinal(dial, "N", 98, 19, COMPASS_RED);
    compass_ui_add_cardinal(dial, "E", 184, 101, COMPASS_MUTED);
    compass_ui_add_cardinal(dial, "S", 98, 184, COMPASS_MUTED);
    compass_ui_add_cardinal(dial, "W", 13, 101, COMPASS_MUTED);

    compass_south_line = lv_line_create(dial);
    lv_line_set_points(compass_south_line, compass_south_points, 2U);
    compass_ui_set_line_style(compass_south_line, COMPASS_MUTED, 6);

    compass_north_line = lv_line_create(dial);
    lv_line_set_points(compass_north_line, compass_north_points, 2U);
    compass_ui_set_line_style(compass_north_line, COMPASS_RED, 8);

    center_dot = lv_obj_create(dial);
    lv_obj_set_size(center_dot, 20, 20);
    lv_obj_align(center_dot, LV_ALIGN_CENTER, 0, 0);
    compass_ui_style_plain(center_dot, COMPASS_TEXT, LV_OPA_COVER,
                           LV_RADIUS_CIRCLE);
    lv_obj_set_style_border_color(center_dot, lv_color_hex(COMPASS_RED),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(center_dot, 5,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
}

static const char *compass_ui_direction(uint16_t heading)
{
    static const char *directions[8] =
        {"北", "东北", "东", "东南", "南", "西南", "西", "西北"};
    uint8_t index = (uint8_t)(((heading + 22U) / 45U) % 8U);

    return directions[index];
}

static void compass_ui_update_needle(uint16_t heading)
{
    int32_t sine = lv_trigo_sin((int16_t)heading);
    int32_t cosine = lv_trigo_sin((int16_t)(heading + 90U));
    lv_coord_t x_offset =
        (lv_coord_t)((sine * COMPASS_NEEDLE_RADIUS) >> LV_TRIGO_SHIFT);
    lv_coord_t y_offset =
        (lv_coord_t)((cosine * COMPASS_NEEDLE_RADIUS) >> LV_TRIGO_SHIFT);

    compass_north_points[0].x = COMPASS_DIAL_CENTER;
    compass_north_points[0].y = COMPASS_DIAL_CENTER;
    compass_north_points[1].x = COMPASS_DIAL_CENTER - x_offset;
    compass_north_points[1].y = COMPASS_DIAL_CENTER - y_offset;
    compass_south_points[0].x = COMPASS_DIAL_CENTER;
    compass_south_points[0].y = COMPASS_DIAL_CENTER;
    compass_south_points[1].x = COMPASS_DIAL_CENTER + x_offset;
    compass_south_points[1].y = COMPASS_DIAL_CENTER + y_offset;

    lv_line_set_points(compass_north_line, compass_north_points, 2U);
    lv_line_set_points(compass_south_line, compass_south_points, 2U);
}

static void compass_ui_refresh(void)
{
    compass_snapshot_t snapshot;
    char text[48];

    if (compass_heading_label == NULL)
        return;

    compass_service_get_snapshot(&snapshot);
    if (!snapshot.available)
    {
        lv_label_set_text(compass_heading_label, "---");
        lv_label_set_text(compass_direction_label, "传感器不可用");
        lv_label_set_text(compass_quality_label, "MMC56X3 / I2C3");
        lv_label_set_text(compass_calibrate_label, LV_SYMBOL_REFRESH);
        lv_obj_add_state(compass_calibrate_button, LV_STATE_DISABLED);
        lv_obj_add_flag(compass_north_line, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(compass_south_line, LV_OBJ_FLAG_HIDDEN);
        return;
    }

    lv_obj_clear_state(compass_calibrate_button, LV_STATE_DISABLED);
    if (!snapshot.valid)
    {
        lv_label_set_text(compass_heading_label, "---");
        lv_label_set_text(compass_direction_label, "正在读取磁场");
        lv_label_set_text(compass_quality_label, "请稍候");
        lv_label_set_text(compass_calibrate_label, "校准 0%");
        lv_obj_add_flag(compass_north_line, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(compass_south_line, LV_OBJ_FLAG_HIDDEN);
        return;
    }

    (void)snprintf(text, sizeof(text), "%03u°",
                   (unsigned int)snapshot.heading_degrees);
    lv_label_set_text(compass_heading_label, text);
    (void)snprintf(text, sizeof(text), "%s · 磁北",
                   compass_ui_direction(snapshot.heading_degrees));
    lv_label_set_text(compass_direction_label, text);

    if (!snapshot.calibrated)
    {
        (void)snprintf(text, sizeof(text), "画8字校准 · %u%%",
                       (unsigned int)snapshot.calibration_percent);
        lv_label_set_text(compass_quality_label, text);
        (void)snprintf(text, sizeof(text), "校准 %u%%",
                       (unsigned int)snapshot.calibration_percent);
        lv_label_set_text(compass_calibrate_label, text);
        lv_obj_set_style_text_color(compass_quality_label,
                                    lv_color_hex(COMPASS_AMBER),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
    }
    else if (snapshot.interference)
    {
        lv_label_set_text(compass_quality_label, "附近有磁场干扰");
        lv_label_set_text(compass_calibrate_label, LV_SYMBOL_REFRESH " 重新校准");
        lv_obj_set_style_text_color(compass_quality_label,
                                    lv_color_hex(COMPASS_RED),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
    }
    else
    {
        (void)snprintf(text, sizeof(text), "已校准 · %u.%u uT",
                       (unsigned int)(snapshot.field_strength_mgauss / 10U),
                       (unsigned int)(snapshot.field_strength_mgauss % 10U));
        lv_label_set_text(compass_quality_label, text);
        lv_label_set_text(compass_calibrate_label, LV_SYMBOL_REFRESH " 重新校准");
        lv_obj_set_style_text_color(compass_quality_label,
                                    lv_color_hex(COMPASS_GREEN),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
    }

    compass_ui_update_needle(snapshot.heading_degrees);
    lv_obj_clear_flag(compass_north_line, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(compass_south_line, LV_OBJ_FLAG_HIDDEN);
}

static void compass_ui_refresh_timer(lv_timer_t *timer)
{
    (void)timer;
    if (ui_Compass != NULL && lv_scr_act() == ui_Compass)
        compass_ui_refresh();
}

void ui_Compass_screen_init(void)
{
    lv_obj_t *back_button;
    lv_obj_t *label;

    if (ui_Compass != NULL)
        return;

    ui_Compass = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_Compass, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Compass, lv_color_hex(COMPASS_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_Compass, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_event_cb(ui_Compass, compass_ui_screen_event,
                        LV_EVENT_ALL, NULL);

    compass_panel = lv_obj_create(ui_Compass);
    lv_obj_set_size(compass_panel, 390, 450);
    lv_obj_center(compass_panel);
    compass_ui_style_plain(compass_panel, COMPASS_BG, LV_OPA_COVER, 45);
    lv_obj_set_style_border_color(compass_panel, lv_color_hex(COMPASS_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(compass_panel, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(compass_panel, true,
                                 LV_PART_MAIN | LV_STATE_DEFAULT);

    back_button = lv_btn_create(compass_panel);
    lv_obj_set_size(back_button, 50, 50);
    lv_obj_set_pos(back_button, 20, 12);
    compass_ui_style_plain(back_button, COMPASS_PANEL, LV_OPA_TRANSP,
                           LV_RADIUS_CIRCLE);
    lv_obj_set_style_bg_color(back_button, lv_color_hex(COMPASS_BORDER),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(back_button, compass_ui_back_event,
                        LV_EVENT_CLICKED, NULL);
    label = compass_ui_add_label(back_button, LV_SYMBOL_LEFT,
                                 &lv_font_montserrat_20, COMPASS_TEXT);
    lv_obj_center(label);

    label = compass_ui_add_label(compass_panel, "指南针",
                                 &hsp_font_cjk_22, COMPASS_TEXT);
    lv_obj_set_size(label, 160, 32);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 20);

    compass_heading_label = compass_ui_add_label(
        compass_panel, "---", &lv_font_montserrat_48, COMPASS_TEXT);
    lv_obj_set_size(compass_heading_label, 220, 58);
    lv_obj_align(compass_heading_label, LV_ALIGN_TOP_MID, 0, 52);

    compass_direction_label = compass_ui_add_label(
        compass_panel, "正在读取磁场", &hsp_font_cjk_22, COMPASS_TEXT);
    lv_obj_set_size(compass_direction_label, 260, 30);
    lv_obj_align(compass_direction_label, LV_ALIGN_TOP_MID, 0, 103);

    compass_quality_label = compass_ui_add_label(
        compass_panel, "请稍候", &hsp_font_cjk_22, COMPASS_MUTED);
    lv_obj_set_size(compass_quality_label, 300, 30);
    lv_obj_align(compass_quality_label, LV_ALIGN_TOP_MID, 0, 128);

    compass_ui_build_dial(compass_panel);

    compass_calibrate_button = lv_btn_create(compass_panel);
    lv_obj_set_size(compass_calibrate_button, 166, 50);
    lv_obj_align(compass_calibrate_button, LV_ALIGN_BOTTOM_MID, 0, -8);
    compass_ui_style_plain(compass_calibrate_button, COMPASS_BLUE_DARK,
                           LV_OPA_COVER, 25);
    lv_obj_set_style_bg_color(compass_calibrate_button,
                              lv_color_hex(COMPASS_BLUE),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_color(compass_calibrate_button,
                              lv_color_hex(COMPASS_PANEL),
                              LV_PART_MAIN | LV_STATE_DISABLED);
    lv_obj_add_event_cb(compass_calibrate_button,
                        compass_ui_calibrate_event,
                        LV_EVENT_CLICKED, NULL);
    compass_calibrate_label = compass_ui_add_label(
        compass_calibrate_button, "校准 0%", &hsp_font_cjk_22, COMPASS_TEXT);
    lv_obj_center(compass_calibrate_label);

    compass_refresh_timer = lv_timer_create(compass_ui_refresh_timer,
                                            COMPASS_REFRESH_PERIOD_MS, NULL);
    lv_timer_pause(compass_refresh_timer);
    compass_ui_refresh();
}

void ui_Compass_screen_destroy(void)
{
    compass_service_set_active(0U);
    if (compass_refresh_timer != NULL)
        lv_timer_del(compass_refresh_timer);
    compass_refresh_timer = NULL;

    if (ui_Compass != NULL)
        lv_obj_del(ui_Compass);
    ui_Compass = NULL;
    compass_panel = NULL;
    compass_heading_label = NULL;
    compass_direction_label = NULL;
    compass_quality_label = NULL;
    compass_north_line = NULL;
    compass_south_line = NULL;
    compass_calibrate_button = NULL;
    compass_calibrate_label = NULL;
}

void ui_Compass_open_from_app_grid(void)
{
    compass_ui_wait_release();
    if (ui_Compass == NULL)
        ui_Compass_screen_init();
    compass_service_set_active(1U);
    if (compass_refresh_timer != NULL)
        lv_timer_resume(compass_refresh_timer);
    lv_scr_load_anim(ui_Compass, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Compass_return(void)
{
    compass_ui_wait_release();
    compass_service_set_active(0U);
    if (compass_refresh_timer != NULL)
        lv_timer_pause(compass_refresh_timer);
    ui_AppGrid_open();
}

uint8_t ui_Compass_handle_key(input_wake_key_t key,
                              input_wake_event_t event)
{
    if (ui_Compass == NULL || lv_scr_act() != ui_Compass)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Compass_return();
        return 1U;
    }
    return 0U;
}
