#include "camera_ui.h"

#include <stdint.h>

#include "bluetooth/find_phone_ble.h"
#include "drivers/vibrator.h"
#include "lv_ext_resource_manager.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"

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

#define CAMERA_BG                    0x050608
#define CAMERA_PANEL                 0x090B0F
#define CAMERA_PILL                  0x1B1E24
#define CAMERA_TEXT                  0xF5F7FA
#define CAMERA_MUTED                 0x8D949E
#define CAMERA_SHUTTER               0xFFFFFF
#define CAMERA_SHUTTER_PRESSED       0xC7CBD0
#define CAMERA_COUNTDOWN_ZOOM        (384U)
#define CAMERA_VIBRATION_LEVEL       (72U)
#define CAMERA_TICK_VIBRATION_MS     (65U)
#define CAMERA_CAPTURE_VIBRATION_MS  (110U)

lv_obj_t *ui_Camera = NULL;

static lv_obj_t *camera_panel;
static lv_obj_t *camera_delay_buttons[3];
static lv_obj_t *camera_status_label;
static lv_timer_t *camera_countdown_timer;
static uint8_t camera_delay_seconds;
static uint8_t camera_countdown_remaining;

static const uint8_t camera_delay_values[3] = {0U, 3U, 5U};
static const char *camera_delay_texts[3] = {"立刻", "3S", "5S"};
static const void *camera_digit_sources[10] =
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

static void camera_ui_build_main(void);

static void camera_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void camera_ui_style_object(lv_obj_t *object, uint32_t color,
                                   lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_set_style_bg_color(object, lv_color_hex(color), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(object, opacity, LV_PART_MAIN);
    lv_obj_set_style_radius(object, radius, LV_PART_MAIN);
    lv_obj_set_style_border_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_outline_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_shadow_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN);
}

static lv_obj_t *camera_ui_add_label(lv_obj_t *parent, const char *text,
                                     const lv_font_t *font, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font, LV_PART_MAIN);
    lv_obj_set_style_text_color(label, lv_color_hex(color), LV_PART_MAIN);
    return label;
}

static lv_obj_t *camera_ui_add_button(lv_obj_t *parent, lv_coord_t x,
                                      lv_coord_t y, lv_coord_t width,
                                      lv_coord_t height, lv_coord_t radius)
{
    lv_obj_t *button = lv_btn_create(parent);

    lv_obj_set_pos(button, x, y);
    lv_obj_set_size(button, width, height);
    camera_ui_style_object(button, CAMERA_PILL, LV_OPA_COVER, radius);
    lv_obj_set_style_bg_color(button, lv_color_hex(CAMERA_SHUTTER_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    return button;
}

static void camera_ui_refresh_delay_buttons(void)
{
    uint8_t index;

    for (index = 0U; index < 3U; index++)
    {
        lv_obj_t *button = camera_delay_buttons[index];
        lv_obj_t *label;
        uint8_t selected;

        if (button == NULL)
            continue;
        selected = camera_delay_seconds == camera_delay_values[index];
        lv_obj_set_style_bg_color(button,
            lv_color_hex(selected ? CAMERA_TEXT : CAMERA_PILL), LV_PART_MAIN);
        label = lv_obj_get_child(button, 0U);
        if (label != NULL)
            lv_obj_set_style_text_color(label,
                lv_color_hex(selected ? CAMERA_BG : CAMERA_MUTED),
                LV_PART_MAIN);
    }
}

static void camera_ui_delay_event(lv_event_t *event)
{
    uint8_t index = (uint8_t)(uintptr_t)lv_event_get_user_data(event);

    if (lv_event_get_code(event) != LV_EVENT_CLICKED || index >= 3U)
        return;
    camera_delay_seconds = camera_delay_values[index];
    camera_ui_refresh_delay_buttons();
}

static void camera_ui_show_status(const char *text)
{
    if (camera_status_label != NULL)
        lv_label_set_text(camera_status_label, text);
}

static void camera_ui_send_capture(void)
{
    (void)vibrator_vibrate(CAMERA_VIBRATION_LEVEL,
                           CAMERA_CAPTURE_VIBRATION_MS);
    if (!find_phone_ble_capture())
        camera_ui_show_status("手机未连接");
    else
        camera_ui_show_status("已发送拍照命令");
}

static void camera_ui_cancel_countdown(void)
{
    if (camera_countdown_timer != NULL)
    {
        lv_timer_del(camera_countdown_timer);
        camera_countdown_timer = NULL;
    }
    camera_countdown_remaining = 0U;
}

static void camera_ui_show_countdown_digit(void)
{
    lv_obj_t *image;

    if (camera_panel == NULL || camera_countdown_remaining > 9U)
        return;
    lv_obj_clean(camera_panel);
    image = lv_img_create(camera_panel);
    lv_img_set_src(image, camera_digit_sources[camera_countdown_remaining]);
    lv_obj_set_size(image, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
    lv_img_set_pivot(image, 64, 64);
    lv_img_set_zoom(image, CAMERA_COUNTDOWN_ZOOM);
    lv_obj_align(image, LV_ALIGN_CENTER, 0, 0);
    lv_obj_clear_flag(image, LV_OBJ_FLAG_SCROLLABLE);
    (void)vibrator_vibrate(CAMERA_VIBRATION_LEVEL,
                           CAMERA_TICK_VIBRATION_MS);
}

static void camera_ui_countdown_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    if (camera_countdown_remaining > 1U)
    {
        camera_countdown_remaining--;
        camera_ui_show_countdown_digit();
        return;
    }

    camera_countdown_timer = NULL;
    lv_timer_del(timer);
    camera_countdown_remaining = 0U;
    camera_ui_build_main();
    camera_ui_send_capture();
}

static void camera_ui_shutter_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (camera_delay_seconds == 0U)
    {
        camera_ui_send_capture();
        return;
    }

    camera_countdown_remaining = camera_delay_seconds;
    camera_ui_show_countdown_digit();
    camera_countdown_timer = lv_timer_create(camera_ui_countdown_timer_cb,
                                              1000U, NULL);
    if (camera_countdown_timer == NULL)
    {
        camera_countdown_remaining = 0U;
        camera_ui_build_main();
        camera_ui_show_status("倒计时启动失败");
    }
}

static void camera_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Camera_return();
}

static void camera_ui_build_main(void)
{
    lv_obj_t *back;
    lv_obj_t *title;
    lv_obj_t *pill;
    lv_obj_t *shutter;
    lv_obj_t *inner;
    uint8_t index;

    if (camera_panel == NULL)
        return;
    lv_obj_clean(camera_panel);
    camera_status_label = NULL;
    for (index = 0U; index < 3U; index++)
        camera_delay_buttons[index] = NULL;

    back = camera_ui_add_button(camera_panel, 20, 14, 48, 48, 24);
    title = camera_ui_add_label(back, LV_SYMBOL_LEFT,
                                &lv_font_montserrat_20, CAMERA_TEXT);
    lv_obj_center(title);
    lv_obj_add_event_cb(back, camera_ui_back_event, LV_EVENT_CLICKED, NULL);

    title = camera_ui_add_label(camera_panel, "遥控拍照",
                                &hsp_font_cjk_22, CAMERA_TEXT);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 27);

    pill = lv_obj_create(camera_panel);
    lv_obj_set_pos(pill, 45, 92);
    lv_obj_set_size(pill, 300, 64);
    camera_ui_style_object(pill, CAMERA_PILL, LV_OPA_COVER, 32);
    lv_obj_set_style_pad_all(pill, 4, LV_PART_MAIN);

    for (index = 0U; index < 3U; index++)
    {
        lv_obj_t *label;
        lv_obj_t *button = lv_btn_create(pill);

        lv_obj_set_pos(button, (lv_coord_t)(index * 97), 0);
        lv_obj_set_size(button, 97, 56);
        camera_ui_style_object(button, CAMERA_PILL, LV_OPA_COVER, 28);
        label = camera_ui_add_label(button, camera_delay_texts[index],
                                    &hsp_font_cjk_22, CAMERA_MUTED);
        lv_obj_center(label);
        lv_obj_add_event_cb(button, camera_ui_delay_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)index);
        camera_delay_buttons[index] = button;
    }
    camera_ui_refresh_delay_buttons();

    shutter = camera_ui_add_button(camera_panel, 123, 211, 144, 144, 72);
    lv_obj_set_style_bg_color(shutter, lv_color_hex(CAMERA_SHUTTER),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_color(shutter,
                              lv_color_hex(CAMERA_SHUTTER_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(shutter, camera_ui_shutter_event,
                        LV_EVENT_CLICKED, NULL);

    inner = lv_obj_create(shutter);
    lv_obj_set_size(inner, 116, 116);
    lv_obj_center(inner);
    camera_ui_style_object(inner, CAMERA_SHUTTER, LV_OPA_COVER, 58);
    lv_obj_set_style_border_width(inner, 3, LV_PART_MAIN);
    lv_obj_set_style_border_color(inner, lv_color_hex(0xD8DCE1), LV_PART_MAIN);
    lv_obj_clear_flag(inner, LV_OBJ_FLAG_CLICKABLE);

    camera_status_label = camera_ui_add_label(camera_panel,
        find_phone_ble_is_connected() ? "手机已连接" : "等待手机连接",
        &hsp_font_cjk_22, CAMERA_MUTED);
    lv_obj_align(camera_status_label, LV_ALIGN_BOTTOM_MID, 0, -42);
}

void ui_Camera_init(void)
{
}

void ui_Camera_screen_init(void)
{
    if (ui_Camera != NULL)
        return;

    ui_Camera = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_Camera, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Camera, lv_color_hex(CAMERA_BG), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Camera, LV_OPA_COVER, LV_PART_MAIN);
    camera_panel = lv_obj_create(ui_Camera);
    lv_obj_set_size(camera_panel, 390, 450);
    lv_obj_center(camera_panel);
    camera_ui_style_object(camera_panel, CAMERA_PANEL, LV_OPA_COVER, 45);
    lv_obj_set_style_clip_corner(camera_panel, true, LV_PART_MAIN);
    camera_ui_build_main();
}

void ui_Camera_screen_destroy(void)
{
    camera_ui_cancel_countdown();
    if (ui_Camera != NULL)
        lv_obj_del(ui_Camera);
    ui_Camera = NULL;
    camera_panel = NULL;
    camera_status_label = NULL;
}

void ui_Camera_open_from_app_grid(void)
{
    camera_ui_wait_release();
    camera_ui_cancel_countdown();
    if (ui_Camera == NULL)
        ui_Camera_screen_init();
    else
        camera_ui_build_main();
    lv_scr_load_anim(ui_Camera, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Camera_return(void)
{
    camera_ui_wait_release();
    if (camera_countdown_remaining != 0U)
    {
        camera_ui_cancel_countdown();
        camera_ui_build_main();
        return;
    }
    ui_AppGrid_open();
}

uint8_t ui_Camera_handle_key(input_wake_key_t key,
                             input_wake_event_t event)
{
    if (ui_Camera == NULL || lv_scr_act() != ui_Camera)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Camera_return();
        return 1U;
    }
    return 0U;
}
