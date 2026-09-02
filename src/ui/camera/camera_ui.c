#include "camera_ui.h"

#include <stdint.h>
#include <stdio.h>

#include "bluetooth/find_phone_ble.h"
#include "bluetooth/pan.h"
#include "drivers/vibrator.h"
#include "lv_ext_resource_manager.h"
#include "mem_section.h"
#include "services/camera_photo_service.h"
#include "tjpgd.h"
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
#define CAMERA_PHOTO_MAX_EDGE        (160U)
#define CAMERA_JPEG_WORK_SIZE         (4096U)
#define CAMERA_PREVIEW_FIT_WIDTH     (360U)
#define CAMERA_PREVIEW_FIT_HEIGHT    (360U)
#define CAMERA_PREVIEW_ZOOM_STEP     (96U)
#define CAMERA_PREVIEW_ZOOM_LIMIT    (1024U)

lv_obj_t *ui_Camera = NULL;

static lv_obj_t *camera_panel;
static lv_obj_t *camera_delay_buttons[3];
static lv_obj_t *camera_status_label;
static lv_timer_t *camera_countdown_timer;
static uint8_t camera_delay_seconds;
static uint8_t camera_countdown_remaining;
L2_NON_RET_BSS_SECT_BEGIN(camera_preview)
L2_NON_RET_BSS_SECT(
    camera_preview,
    ALIGN(64) static lv_color_t camera_preview_pixels[
        CAMERA_PHOTO_MAX_EDGE * CAMERA_PHOTO_MAX_EDGE]);
L2_NON_RET_BSS_SECT(
    camera_preview,
    ALIGN(64) static uint8_t camera_jpeg_work[CAMERA_JPEG_WORK_SIZE]);
L2_NON_RET_BSS_SECT_END
static lv_img_dsc_t camera_preview_dsc;
static lv_img_dsc_t *camera_preview_buffer;
static lv_obj_t *camera_preview_image;
static lv_obj_t *camera_preview_zoom_label;
static uint16_t camera_preview_fit_zoom;
static uint16_t camera_preview_zoom;
static uint16_t camera_preview_max_zoom;
static lv_coord_t camera_preview_pan_x;
static lv_coord_t camera_preview_pan_y;

typedef enum
{
    CAMERA_UI_MAIN,
    CAMERA_UI_PREVIEW,
} camera_ui_state_t;

typedef enum
{
    CAMERA_DECODE_OK,
    CAMERA_DECODE_FILE_ERROR,
    CAMERA_DECODE_FORMAT_ERROR,
    CAMERA_DECODE_MEMORY_ERROR,
    CAMERA_DECODE_SIZE_ERROR,
    CAMERA_DECODE_INPUT_ERROR,
    CAMERA_DECODE_OUTPUT_ERROR,
} camera_decode_result_t;

typedef struct
{
    FILE *file;
    lv_color_t *pixels;
    uint16_t width;
    uint16_t height;
    uint8_t io_failed;
    uint8_t output_failed;
} camera_jpeg_context_t;

static camera_ui_state_t camera_ui_state = CAMERA_UI_MAIN;

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
static void camera_ui_build_preview(void);

static void camera_ui_release_preview(void)
{
    if (camera_preview_buffer != NULL)
    {
        lv_img_cache_invalidate_src(camera_preview_buffer);
        camera_preview_buffer = NULL;
    }
    camera_preview_image = NULL;
    camera_preview_zoom_label = NULL;
    camera_preview_fit_zoom = LV_IMG_ZOOM_NONE;
    camera_preview_zoom = LV_IMG_ZOOM_NONE;
    camera_preview_max_zoom = LV_IMG_ZOOM_NONE;
    camera_preview_pan_x = 0;
    camera_preview_pan_y = 0;
}

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
    if (!bt_pan_take_picture())
        camera_ui_show_status("请先完成手机蓝牙配对");
    else
        camera_ui_show_status("已发送拍照命令");
}

static void camera_ui_preview_request_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (!find_phone_ble_request_photo_preview())
        camera_ui_show_status("App 未连接");
    else
        camera_ui_show_status("正在获取最新照片");
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

static void camera_ui_update_zoom_label(void)
{
    char text[12];
    uint32_t percent;

    if (camera_preview_zoom_label == NULL || camera_preview_fit_zoom == 0U)
        return;
    percent = ((uint32_t)camera_preview_zoom * 100U +
               camera_preview_fit_zoom / 2U) / camera_preview_fit_zoom;
    lv_snprintf(text, sizeof(text), "%u%%", percent);
    lv_label_set_text(camera_preview_zoom_label, text);
}

static void camera_ui_apply_preview_transform(void)
{
    int32_t scaled_width;
    int32_t scaled_height;
    int32_t max_pan_x;
    int32_t max_pan_y;
    lv_coord_t x;
    lv_coord_t y;

    if (camera_preview_image == NULL || camera_preview_buffer == NULL)
        return;

    scaled_width = (int32_t)camera_preview_buffer->header.w *
                   camera_preview_zoom / LV_IMG_ZOOM_NONE;
    scaled_height = (int32_t)camera_preview_buffer->header.h *
                    camera_preview_zoom / LV_IMG_ZOOM_NONE;
    max_pan_x = scaled_width > 390 ? (scaled_width - 390) / 2 : 0;
    max_pan_y = scaled_height > 450 ? (scaled_height - 450) / 2 : 0;
    camera_preview_pan_x = LV_CLAMP(-max_pan_x, camera_preview_pan_x,
                                    max_pan_x);
    camera_preview_pan_y = LV_CLAMP(-max_pan_y, camera_preview_pan_y,
                                    max_pan_y);

    x = (lv_coord_t)((390 - camera_preview_buffer->header.w) / 2) +
        camera_preview_pan_x;
    y = (lv_coord_t)((450 - camera_preview_buffer->header.h) / 2) +
        camera_preview_pan_y;
    lv_obj_set_pos(camera_preview_image, x, y);
    lv_img_set_zoom(camera_preview_image, camera_preview_zoom);
    camera_ui_update_zoom_label();
}

static void camera_ui_preview_drag_event(lv_event_t *event)
{
    lv_indev_t *indev;
    lv_point_t vector;

    if (lv_event_get_code(event) != LV_EVENT_PRESSING)
        return;
    indev = lv_indev_get_act();
    if (indev == NULL)
        return;
    lv_indev_get_vect(indev, &vector);
    camera_preview_pan_x += vector.x;
    camera_preview_pan_y += vector.y;
    camera_ui_apply_preview_transform();
}

static void camera_ui_preview_zoom_event(lv_event_t *event)
{
    uint8_t zoom_in = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    uint16_t next_zoom;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    if (zoom_in)
    {
        next_zoom = camera_preview_zoom >
                    camera_preview_max_zoom - CAMERA_PREVIEW_ZOOM_STEP ?
                    camera_preview_max_zoom :
                    camera_preview_zoom + CAMERA_PREVIEW_ZOOM_STEP;
    }
    else
    {
        next_zoom = camera_preview_zoom <
                    camera_preview_fit_zoom + CAMERA_PREVIEW_ZOOM_STEP ?
                    camera_preview_fit_zoom :
                    camera_preview_zoom - CAMERA_PREVIEW_ZOOM_STEP;
    }
    camera_preview_zoom = next_zoom;
    camera_ui_apply_preview_transform();
}

static void camera_ui_build_main(void)
{
    lv_obj_t *back;
    lv_obj_t *title;
    lv_obj_t *pill;
    lv_obj_t *shutter;
    lv_obj_t *inner;
    lv_obj_t *preview;
    uint8_t index;

    if (camera_panel == NULL)
        return;
    camera_ui_state = CAMERA_UI_MAIN;
    lv_obj_clean(camera_panel);
    camera_ui_release_preview();
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
        bt_pan_hid_is_connected() ? "原生相机快门已连接" : "等待 HID 配对",
        &hsp_font_cjk_22, CAMERA_MUTED);
    lv_obj_align(camera_status_label, LV_ALIGN_TOP_MID, 0, 174);

    preview = camera_ui_add_button(camera_panel, 129, 374, 132, 54, 27);
    title = camera_ui_add_label(preview, "预览", &hsp_font_cjk_22,
                                CAMERA_TEXT);
    lv_obj_center(title);
    lv_obj_add_event_cb(preview, camera_ui_preview_request_event,
                        LV_EVENT_CLICKED, NULL);
}

static size_t camera_ui_jpeg_input(JDEC *decoder, uint8_t *buffer,
                                   size_t length)
{
    camera_jpeg_context_t *context = decoder->device;
    size_t read_length;

    if (context == NULL || context->file == NULL)
        return 0U;
    if (buffer == NULL)
    {
        if (fseek(context->file, (long)length, SEEK_CUR) != 0)
        {
            context->io_failed = 1U;
            return 0U;
        }
        return length;
    }

    read_length = fread(buffer, 1U, length, context->file);
    if (read_length < length && ferror(context->file))
        context->io_failed = 1U;
    return read_length;
}

static int camera_ui_jpeg_output(JDEC *decoder, void *bitmap,
                                 JRECT *rectangle)
{
    camera_jpeg_context_t *context = decoder->device;
    const uint8_t *source = bitmap;
    uint16_t block_width;
    uint16_t x;
    uint16_t y;

    if (context == NULL || source == NULL || rectangle == NULL ||
        rectangle->left > rectangle->right ||
        rectangle->top > rectangle->bottom ||
        rectangle->right >= context->width ||
        rectangle->bottom >= context->height)
    {
        if (context != NULL)
            context->output_failed = 1U;
        return 0;
    }

    block_width = rectangle->right - rectangle->left + 1U;
    for (y = rectangle->top; y <= rectangle->bottom; y++)
    {
        lv_color_t *destination = context->pixels +
                                  (uint32_t)y * context->width +
                                  rectangle->left;

        for (x = 0U; x < block_width; x++)
        {
            destination[x] = lv_color_make(source[0], source[1], source[2]);
            source += 3;
        }
    }
    return 1;
}

static camera_decode_result_t camera_ui_jpeg_error(const char *stage,
                                                    JRESULT result,
                                                    uint8_t io_failed)
{
    if (io_failed || result == JDR_INP)
    {
        rt_kprintf("camera: JPEG %s input error/truncated, result=%d\n",
                   stage, result);
        return CAMERA_DECODE_INPUT_ERROR;
    }
    if (result == JDR_MEM1 || result == JDR_MEM2)
    {
        rt_kprintf("camera: JPEG %s memory insufficient, result=%d, "
                   "workspace=%u\n", stage, result,
                   (unsigned int)CAMERA_JPEG_WORK_SIZE);
        return CAMERA_DECODE_MEMORY_ERROR;
    }
    if (result == JDR_FMT1 || result == JDR_FMT2 || result == JDR_FMT3)
    {
        rt_kprintf("camera: JPEG %s format unsupported/corrupt, result=%d\n",
                   stage, result);
        return CAMERA_DECODE_FORMAT_ERROR;
    }

    rt_kprintf("camera: JPEG %s failed, result=%d\n", stage, result);
    return CAMERA_DECODE_OUTPUT_ERROR;
}

static camera_decode_result_t camera_ui_decode_preview(void)
{
    camera_jpeg_context_t context;
    JDEC decoder;
    JRESULT result;

    lv_memset_00(&context, sizeof(context));
    context.file = fopen(CAMERA_PHOTO_LVGL_PATH, "rb");
    context.pixels = camera_preview_pixels;
    if (context.file == NULL)
    {
        rt_kprintf("camera: cannot open preview %s, errno=%d\n",
                   CAMERA_PHOTO_LVGL_PATH, rt_get_errno());
        return CAMERA_DECODE_FILE_ERROR;
    }

    result = jd_prepare(&decoder, camera_ui_jpeg_input, camera_jpeg_work,
                        sizeof(camera_jpeg_work), &context);
    if (result != JDR_OK)
    {
        camera_decode_result_t error = camera_ui_jpeg_error(
            "prepare", result, context.io_failed);

        fclose(context.file);
        return error;
    }

    if (decoder.width == 0U || decoder.height == 0U)
    {
        rt_kprintf("camera: JPEG format error: empty image %ux%u\n",
                   (unsigned int)decoder.width,
                   (unsigned int)decoder.height);
        fclose(context.file);
        return CAMERA_DECODE_FORMAT_ERROR;
    }
    if (decoder.width > CAMERA_PHOTO_MAX_EDGE ||
        decoder.height > CAMERA_PHOTO_MAX_EDGE)
    {
        rt_kprintf("camera: preview size limit exceeded: %ux%u, max edge=%u\n",
                   (unsigned int)decoder.width,
                   (unsigned int)decoder.height,
                   (unsigned int)CAMERA_PHOTO_MAX_EDGE);
        fclose(context.file);
        return CAMERA_DECODE_SIZE_ERROR;
    }

    context.width = decoder.width;
    context.height = decoder.height;
    result = jd_decomp(&decoder, camera_ui_jpeg_output, 0U);
    fclose(context.file);
    if (result != JDR_OK || context.output_failed)
    {
        if (context.output_failed)
        {
            rt_kprintf("camera: JPEG output bounds error, result=%d\n",
                       result);
            return CAMERA_DECODE_OUTPUT_ERROR;
        }
        return camera_ui_jpeg_error("decode", result, context.io_failed);
    }

    lv_memset_00(&camera_preview_dsc, sizeof(camera_preview_dsc));
    camera_preview_dsc.header.always_zero = 0U;
    camera_preview_dsc.header.w = decoder.width;
    camera_preview_dsc.header.h = decoder.height;
    camera_preview_dsc.header.cf = LV_IMG_CF_TRUE_COLOR;
    camera_preview_dsc.data_size =
        (uint32_t)decoder.width * decoder.height * sizeof(lv_color_t);
    camera_preview_dsc.data = (const uint8_t *)camera_preview_pixels;
    rt_kprintf("camera: preview decoded to RGB565, %ux%u\n",
               (unsigned int)decoder.width, (unsigned int)decoder.height);
    return CAMERA_DECODE_OK;
}

static const char *camera_ui_decode_status(camera_decode_result_t result)
{
    switch (result)
    {
    case CAMERA_DECODE_FILE_ERROR:
        return "照片文件读取失败";
    case CAMERA_DECODE_FORMAT_ERROR:
        return "照片格式不支持";
    case CAMERA_DECODE_MEMORY_ERROR:
        return "照片解码内存不足";
    case CAMERA_DECODE_SIZE_ERROR:
        return "照片尺寸超过160px";
    case CAMERA_DECODE_INPUT_ERROR:
        return "照片数据损坏";
    case CAMERA_DECODE_OUTPUT_ERROR:
    default:
        return "照片解码失败";
    }
}

static void camera_ui_build_preview(void)
{
    lv_img_dsc_t *decoded;
    lv_obj_t *image;
    lv_obj_t *touch_layer;
    lv_obj_t *back;
    lv_obj_t *zoom_out;
    lv_obj_t *zoom_in;
    lv_obj_t *label;
    uint32_t fit_x;
    uint32_t fit_y;
    uint32_t fit_zoom;
    camera_decode_result_t decode_result;

    if (camera_panel == NULL)
        return;
    lv_img_cache_invalidate_src(&camera_preview_dsc);
    decode_result = camera_ui_decode_preview();
    if (decode_result != CAMERA_DECODE_OK)
    {
        camera_ui_build_main();
        camera_ui_show_status(camera_ui_decode_status(decode_result));
        return;
    }

    lv_obj_clean(camera_panel);
    camera_ui_release_preview();
    camera_status_label = NULL;
    decoded = &camera_preview_dsc;
    camera_ui_state = CAMERA_UI_PREVIEW;
    camera_preview_buffer = decoded;
    image = lv_img_create(camera_panel);
    lv_img_set_src(image, camera_preview_buffer);
    lv_obj_set_size(image, LV_SIZE_CONTENT, LV_SIZE_CONTENT);
    lv_img_set_pivot(image, decoded->header.w / 2, decoded->header.h / 2);
    lv_img_set_antialias(image, true);
    lv_obj_clear_flag(image, LV_OBJ_FLAG_SCROLLABLE);
    camera_preview_image = image;

    fit_x = CAMERA_PREVIEW_FIT_WIDTH * LV_IMG_ZOOM_NONE / decoded->header.w;
    fit_y = CAMERA_PREVIEW_FIT_HEIGHT * LV_IMG_ZOOM_NONE / decoded->header.h;
    fit_zoom = fit_x < fit_y ? fit_x : fit_y;
    if (fit_zoom < LV_IMG_ZOOM_NONE)
        fit_zoom = LV_IMG_ZOOM_NONE;
    if (fit_zoom > CAMERA_PREVIEW_ZOOM_LIMIT)
        fit_zoom = CAMERA_PREVIEW_ZOOM_LIMIT;
    camera_preview_fit_zoom = (uint16_t)fit_zoom;
    camera_preview_zoom = camera_preview_fit_zoom;
    fit_zoom *= 2U;
    camera_preview_max_zoom = (uint16_t)(
        fit_zoom > CAMERA_PREVIEW_ZOOM_LIMIT ?
        CAMERA_PREVIEW_ZOOM_LIMIT : fit_zoom);

    touch_layer = lv_obj_create(camera_panel);
    lv_obj_set_pos(touch_layer, 0, 0);
    lv_obj_set_size(touch_layer, 390, 450);
    camera_ui_style_object(touch_layer, CAMERA_BG, LV_OPA_TRANSP, 0);
    lv_obj_clear_flag(touch_layer, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(touch_layer, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(touch_layer, camera_ui_preview_drag_event,
                        LV_EVENT_PRESSING, NULL);

    back = camera_ui_add_button(camera_panel, 20, 18, 48, 48, 24);
    label = camera_ui_add_label(back, LV_SYMBOL_LEFT,
                                &lv_font_montserrat_20, CAMERA_TEXT);
    lv_obj_center(label);
    lv_obj_add_event_cb(back, camera_ui_back_event, LV_EVENT_CLICKED, NULL);

    zoom_out = camera_ui_add_button(camera_panel, 93, 370, 64, 64, 32);
    label = camera_ui_add_label(zoom_out, LV_SYMBOL_MINUS,
                                &lv_font_montserrat_24, CAMERA_TEXT);
    lv_obj_center(label);
    lv_obj_add_event_cb(zoom_out, camera_ui_preview_zoom_event,
                        LV_EVENT_CLICKED, (void *)(uintptr_t)0U);

    camera_preview_zoom_label = camera_ui_add_label(
        camera_panel, "100%", &lv_font_montserrat_20, CAMERA_TEXT);
    lv_obj_align(camera_preview_zoom_label, LV_ALIGN_BOTTOM_MID, 0, -29);

    zoom_in = camera_ui_add_button(camera_panel, 233, 370, 64, 64, 32);
    label = camera_ui_add_label(zoom_in, LV_SYMBOL_PLUS,
                                &lv_font_montserrat_24, CAMERA_TEXT);
    lv_obj_center(label);
    lv_obj_add_event_cb(zoom_in, camera_ui_preview_zoom_event,
                        LV_EVENT_CLICKED, (void *)(uintptr_t)1U);

    camera_ui_apply_preview_transform();
}

static void camera_ui_photo_async(void *user_data)
{
    camera_photo_event_t event = (camera_photo_event_t)(uintptr_t)user_data;

    if (ui_Camera == NULL || lv_scr_act() != ui_Camera)
        return;
    if (event == CAMERA_PHOTO_EVENT_READY && camera_countdown_remaining == 0U)
        camera_ui_build_preview();
    else if (event == CAMERA_PHOTO_EVENT_PERMISSION_REQUIRED)
        camera_ui_show_status("请在 App 授予照片权限");
    else if (event == CAMERA_PHOTO_EVENT_NOT_FOUND)
        camera_ui_show_status("没有找到手机照片");
    else if (event == CAMERA_PHOTO_EVENT_ERROR)
        camera_ui_show_status("照片传输失败");
}

static void camera_ui_photo_event(camera_photo_event_t event)
{
    (void)lv_async_call(camera_ui_photo_async, (void *)(uintptr_t)event);
}

void ui_Camera_init(void)
{
    camera_photo_set_event_handler(camera_ui_photo_event);
}

void ui_Camera_screen_init(void)
{
    if (ui_Camera != NULL)
        return;

    ui_Camera = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Camera, ui_Camera_return);
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
    camera_ui_release_preview();
    ui_Camera = NULL;
    camera_panel = NULL;
    camera_status_label = NULL;
}

void ui_Camera_open_from_app_grid(void)
{
    camera_ui_wait_release();
    camera_ui_cancel_countdown();
    camera_ui_state = CAMERA_UI_MAIN;
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
    if (camera_ui_state == CAMERA_UI_PREVIEW)
    {
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
