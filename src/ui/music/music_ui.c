/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include <string.h>
#include "mem_section.h"
#include "ui/generated/ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/home_pager.h"
#include "ui/app_grid/app_grid_ui.h"
#include "bluetooth/music_app.h"
#include "music_ui.h"

#define MUSIC_COVER_PATH "/cover.jpg"
#define MUSIC_COVER_SIZE (220)
#define MUSIC_COVER_FRAME_SIZE (MUSIC_COVER_SIZE + 4)
#define MUSIC_COVER_SOURCE_MAX_EDGE (128U)
#define MUSIC_COVER_DECODE_RETRY_MAX (6U)

lv_obj_t *ui_ScreenMusic;
static lv_obj_t *music_cover;
static lv_obj_t *music_cover_placeholder;
static lv_obj_t *music_title;
static lv_obj_t *music_lyric;
static lv_obj_t *music_progress;
static lv_obj_t *music_play_button;
static lv_obj_t *music_volume;
L2_NON_RET_BSS_SECT_BEGIN(music_cover)
L2_NON_RET_BSS_SECT(
    music_cover,
    ALIGN(64) static uint8_t music_cover_pixels[
        MUSIC_COVER_SOURCE_MAX_EDGE * MUSIC_COVER_SOURCE_MAX_EDGE *
        sizeof(lv_color_t)]);
L2_NON_RET_BSS_SECT_END
static lv_img_dsc_t music_cover_dsc;
static uint32_t displayed_cover_generation;
static uint32_t failed_cover_generation;
static uint8_t failed_cover_attempts;
static uint32_t displayed_metadata_generation;
static uint32_t displayed_lyric_generation;
static uint32_t displayed_progress_generation;
static music_app_snapshot_t music_ui_snapshot;
static uint8_t displayed_playing;
static uint8_t displayed_volume;
static uint8_t displayed_cover_available;
static lv_timer_t *music_ui_timer;
static char music_title_text[MUSIC_APP_TEXT_MAX_LEN];
static char music_lyric_text[MUSIC_APP_LYRIC_MAX_LEN + 1U];

typedef enum
{
    MUSIC_UI_SOURCE_HOME,
    MUSIC_UI_SOURCE_APP_GRID,
} music_ui_source_t;

static music_ui_source_t music_ui_source = MUSIC_UI_SOURCE_HOME;

static void music_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

void ui_ScreenMusic_open_from_home(void)
{
    music_ui_source = MUSIC_UI_SOURCE_HOME;
    music_ui_wait_release();
    home_pager_load_page(HOME_PAGER_PAGE_MUSIC,
                         LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180);
}

void ui_ScreenMusic_open_from_app_grid(void)
{
    music_ui_source = MUSIC_UI_SOURCE_APP_GRID;
    music_ui_wait_release();
    home_pager_open_music_from_app_grid();
}

void ui_ScreenMusic_return(void)
{
    music_ui_wait_release();

    if (music_ui_source == MUSIC_UI_SOURCE_APP_GRID)
        home_pager_set_page(HOME_PAGER_PAGE_APP_GRID, LV_ANIM_ON);
    else
        home_pager_set_page(HOME_PAGER_PAGE_HOME, LV_ANIM_ON);
}

void ui_ScreenMusic_set_app_grid_source(uint8_t from_app_grid)
{
    music_ui_source = from_app_grid ? MUSIC_UI_SOURCE_APP_GRID :
                                      MUSIC_UI_SOURCE_HOME;
}

static void music_ui_refresh_title(void)
{
    lv_label_set_text(music_title, music_title_text);
}

static void music_ui_refresh_lyric(void)
{
    const char *source;
    uint16_t length = 0U;

    if (music_ui_snapshot.lyric[0] != '\0')
    {
        source = music_ui_snapshot.lyric;
        while (*source == '\r' || *source == '\n')
            source++;
        while (*source != '\0' && *source != '\r' && *source != '\n' &&
               length < MUSIC_APP_LYRIC_MAX_LEN)
            music_lyric_text[length++] = *source++;
    }
    music_lyric_text[length] = '\0';
    lv_label_set_text(music_lyric, music_lyric_text);
}

static void music_ui_refresh_progress(void)
{
    uint32_t position_seconds;
    uint32_t duration_seconds;

    if (!music_ui_snapshot.playback_position_valid &&
        !music_ui_snapshot.track_duration_valid)
    {
        lv_label_set_text(music_progress, "");
        return;
    }

    position_seconds = music_ui_snapshot.playback_position_valid ?
                       music_ui_snapshot.playback_position_ms / 1000U : 0U;
    duration_seconds = music_ui_snapshot.track_duration_valid ?
                       music_ui_snapshot.track_duration_ms / 1000U : 0U;
    if (music_ui_snapshot.track_duration_valid)
    {
        if (position_seconds > duration_seconds)
            position_seconds = duration_seconds;
        lv_label_set_text_fmt(music_progress, "%02u:%02u / %02u:%02u",
                              (unsigned int)(position_seconds / 60U),
                              (unsigned int)(position_seconds % 60U),
                              (unsigned int)(duration_seconds / 60U),
                              (unsigned int)(duration_seconds % 60U));
    }
    else
    {
        lv_label_set_text_fmt(music_progress, "%02u:%02u",
                              (unsigned int)(position_seconds / 60U),
                              (unsigned int)(position_seconds % 60U));
    }
}

static void music_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_ScreenMusic_return();
}

static void music_ui_gesture_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_GESTURE &&
        lv_indev_get_gesture_dir(lv_indev_get_act()) == LV_DIR_RIGHT)
    {
        ui_ScreenMusic_return();
    }
}

static void music_ui_previous_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        music_app_previous();
}

static void music_ui_play_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        music_app_toggle_playback();
}

static void music_ui_next_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        music_app_next();
}

static lv_obj_t *music_ui_create_button(lv_obj_t *parent, const char *symbol,
                                        int x, lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label = lv_label_create(button);
    int is_play_button = (x == 0);

    lv_obj_set_size(button, is_play_button ? 68 : 58,
                    is_play_button ? 68 : 58);
    lv_obj_set_x(button, x);
    lv_obj_set_y(button, 177);
    lv_obj_set_align(button, LV_ALIGN_CENTER);
    lv_obj_set_style_radius(button, LV_RADIUS_CIRCLE, LV_PART_MAIN);
    lv_obj_set_style_bg_color(button, lv_color_hex(0x151519), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(button, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_bg_color(button, lv_color_hex(0x3A3A40),
                               LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_shadow_color(button, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_shadow_width(button, 10, LV_PART_MAIN);
    lv_obj_set_style_shadow_opa(button, LV_OPA_40, LV_PART_MAIN);
    lv_label_set_text(label, symbol);
    lv_obj_center(label);
    lv_obj_set_style_text_font(label, is_play_button ? &lv_font_montserrat_30 :
                               &lv_font_montserrat_24, LV_PART_MAIN);
    lv_obj_set_style_text_color(label, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);

    return button;
}

static uint8_t music_ui_decode_cover(const lv_img_header_t *header)
{
    lv_img_decoder_dsc_t decoder;
    uint16_t row;

    if (header->w > MUSIC_COVER_SOURCE_MAX_EDGE ||
        header->h > MUSIC_COVER_SOURCE_MAX_EDGE)
        return 0U;

    lv_memset_00(&music_cover_dsc, sizeof(music_cover_dsc));
    music_cover_dsc.header.always_zero = 0U;
    music_cover_dsc.header.w = header->w;
    music_cover_dsc.header.h = header->h;
    music_cover_dsc.header.cf = LV_IMG_CF_TRUE_COLOR;
    music_cover_dsc.data_size =
        (uint32_t)header->w * header->h * sizeof(lv_color_t);
    music_cover_dsc.data = music_cover_pixels;

    if (lv_img_decoder_open(&decoder, MUSIC_COVER_PATH,
                            lv_color_black(), 0) != LV_RES_OK)
        return 0U;

    for (row = 0U; row < header->h; row++)
    {
        uint8_t *line = music_cover_pixels +
                        (uint32_t)row * header->w * sizeof(lv_color_t);

        if (lv_img_decoder_read_line(&decoder, 0, row, header->w, line) !=
            LV_RES_OK)
        {
            lv_img_decoder_close(&decoder);
            return 0U;
        }
    }

    lv_img_decoder_close(&decoder);
    return 1U;
}

static void music_ui_refresh_cover(uint32_t generation)
{
    lv_img_header_t header;
    uint32_t fit_x;
    uint32_t fit_y;
    uint32_t fit_zoom;

    if (generation == displayed_cover_generation)
        return;

    lv_img_cache_invalidate_src(MUSIC_COVER_PATH);
    if (lv_img_decoder_get_info(MUSIC_COVER_PATH, &header) != LV_RES_OK ||
        header.w == 0 || header.h == 0)
    {
        if (failed_cover_generation != generation)
        {
            failed_cover_generation = generation;
            failed_cover_attempts = 0U;
        }
        failed_cover_attempts++;
        rt_kprintf("music: LVGL cover decode retry %u/%u\n",
                   failed_cover_attempts, MUSIC_COVER_DECODE_RETRY_MAX);
        if (failed_cover_attempts >= MUSIC_COVER_DECODE_RETRY_MAX)
        {
            rt_kprintf("music: LVGL cannot decode %s\n", MUSIC_COVER_PATH);
            music_app_reject_cover(generation);
        }
        return;
    }

    lv_obj_add_flag(music_cover, LV_OBJ_FLAG_HIDDEN);
    lv_img_cache_invalidate_src(&music_cover_dsc);
    if (music_ui_decode_cover(&header))
    {
        fit_x = MUSIC_COVER_SIZE * LV_IMG_ZOOM_NONE / header.w;
        fit_y = MUSIC_COVER_SIZE * LV_IMG_ZOOM_NONE / header.h;
        fit_zoom = fit_x < fit_y ? fit_x : fit_y;
        lv_img_set_src(music_cover, &music_cover_dsc);
        lv_img_set_pivot(music_cover, header.w / 2, header.h / 2);
        lv_img_set_zoom(music_cover, (uint16_t)fit_zoom);
    }
    else
    {
        rt_kprintf("music: cover is %ux%u; displaying without JPG zoom\n",
                   header.w, header.h);
        lv_img_set_src(music_cover, MUSIC_COVER_PATH);
        lv_img_set_zoom(music_cover, LV_IMG_ZOOM_NONE);
    }

    displayed_cover_generation = generation;
    failed_cover_generation = 0;
    failed_cover_attempts = 0U;
    lv_obj_center(music_cover);
    lv_obj_clear_flag(music_cover, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(music_cover_placeholder, LV_OBJ_FLAG_HIDDEN);
}

static void music_ui_refresh_timer(lv_timer_t *timer)
{
    (void)timer;
    if (ui_ScreenMusic == NULL)
        return;

    music_app_get_snapshot(&music_ui_snapshot);
    if (displayed_metadata_generation != music_ui_snapshot.metadata_generation)
    {
        displayed_metadata_generation = music_ui_snapshot.metadata_generation;
        rt_strncpy(music_title_text, music_ui_snapshot.title,
                   sizeof(music_title_text));
        music_title_text[sizeof(music_title_text) - 1U] = '\0';
        music_ui_refresh_title();
    }
    if (displayed_lyric_generation != music_ui_snapshot.lyric_generation)
    {
        displayed_lyric_generation = music_ui_snapshot.lyric_generation;
        music_ui_refresh_lyric();
    }
    if (displayed_progress_generation !=
        music_ui_snapshot.progress_generation)
    {
        displayed_progress_generation = music_ui_snapshot.progress_generation;
        music_ui_refresh_progress();
    }
    if (displayed_playing != music_ui_snapshot.playing)
    {
        displayed_playing = music_ui_snapshot.playing;
        lv_label_set_text(lv_obj_get_child(music_play_button, 0),
                          music_ui_snapshot.playing ? LV_SYMBOL_PAUSE : LV_SYMBOL_PLAY);
    }
    if (displayed_volume != music_ui_snapshot.volume)
    {
        displayed_volume = music_ui_snapshot.volume;
        lv_label_set_text_fmt(music_volume, "%d%%",
                              (music_ui_snapshot.volume * 100 + 63) / 127);
    }
    if (music_ui_snapshot.cover_available)
    {
        music_ui_refresh_cover(music_ui_snapshot.cover_generation);
    }
    else
    {
        if (displayed_cover_available)
        {
            lv_obj_add_flag(music_cover, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_flag(music_cover_placeholder, LV_OBJ_FLAG_HIDDEN);
        }
        music_app_retry_cover_request();
    }
    displayed_cover_available = music_ui_snapshot.cover_available;
}

void ui_ScreenMusic_screen_init(void)
{
    home_pager_init();
}

void ui_ScreenMusic_content_init(lv_obj_t *parent)
{
    lv_obj_t *header;
    lv_obj_t *back_button;
    lv_obj_t *cover_frame;
    lv_obj_t *title_label;

    if (ui_ScreenMusic != NULL)
        return;

    ui_ScreenMusic = lv_obj_create(parent);
    lv_obj_remove_style_all(ui_ScreenMusic);
    lv_obj_set_size(ui_ScreenMusic, 390, 450);
    lv_obj_center(ui_ScreenMusic);
    lv_obj_clear_flag(ui_ScreenMusic, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_clear_flag(ui_ScreenMusic, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_bg_color(ui_ScreenMusic, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_ScreenMusic, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(ui_ScreenMusic, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(ui_ScreenMusic, 0, LV_PART_MAIN);
    lv_obj_add_event_cb(ui_ScreenMusic, music_ui_gesture_event, LV_EVENT_GESTURE,
                        NULL);

    header = lv_obj_create(ui_ScreenMusic);
    lv_obj_remove_style_all(header);
    lv_obj_set_size(header, 390, 38);
    lv_obj_align(header, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_clear_flag(header, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(header, 0, LV_PART_MAIN);
    lv_obj_set_style_bg_color(header, lv_color_hex(0x080808), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(header, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(header, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(header, 0, LV_PART_MAIN);

    back_button = lv_btn_create(header);
    lv_obj_remove_style_all(back_button);
    lv_obj_set_size(back_button, 34, 34);
    lv_obj_align(back_button, LV_ALIGN_LEFT_MID, 6, 0);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(back_button, 0, LV_PART_MAIN);
    lv_obj_set_style_outline_width(back_button, 0, LV_PART_MAIN);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN);
    lv_label_set_text(lv_label_create(back_button), LV_SYMBOL_LEFT);
    lv_obj_center(lv_obj_get_child(back_button, 0));
    lv_obj_add_event_cb(back_button, music_ui_back_event, LV_EVENT_CLICKED, NULL);

    title_label = lv_label_create(header);
    lv_label_set_text(title_label, LV_SYMBOL_AUDIO "  MUSIC");
    lv_obj_align(title_label, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_20, LV_PART_MAIN);
    lv_obj_set_style_text_color(title_label, lv_color_hex(0xF2C14E), LV_PART_MAIN);

    music_volume = lv_label_create(header);
    lv_obj_set_width(music_volume, 52);
    lv_obj_align(music_volume, LV_ALIGN_RIGHT_MID, -50, 0);
    lv_label_set_text(music_volume, "50%");
    lv_obj_set_style_text_align(music_volume, LV_TEXT_ALIGN_RIGHT, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_volume, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_volume, lv_color_hex(0xC7C7CC), LV_PART_MAIN);

    cover_frame = lv_obj_create(ui_ScreenMusic);
    lv_obj_remove_style_all(cover_frame);
    lv_obj_set_size(cover_frame, MUSIC_COVER_FRAME_SIZE,
                    MUSIC_COVER_FRAME_SIZE);
    lv_obj_align(cover_frame, LV_ALIGN_TOP_MID, 0, 40);
    lv_obj_clear_flag(cover_frame, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(cover_frame, 8, LV_PART_MAIN);
    lv_obj_set_style_bg_color(cover_frame, lv_color_hex(0x0B0B0D), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(cover_frame, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(cover_frame, lv_color_hex(0x36363C),
                                  LV_PART_MAIN);
    lv_obj_set_style_border_width(cover_frame, 2, LV_PART_MAIN);
    lv_obj_set_style_pad_all(cover_frame, 0, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(cover_frame, true, LV_PART_MAIN);

    music_cover = lv_img_create(cover_frame);
    lv_obj_align(music_cover, LV_ALIGN_CENTER, 0, 0);
    lv_obj_add_flag(music_cover, LV_OBJ_FLAG_HIDDEN);

    music_cover_placeholder = lv_label_create(cover_frame);
    lv_label_set_text(music_cover_placeholder, LV_SYMBOL_AUDIO);
    lv_obj_center(music_cover_placeholder);
    lv_obj_set_style_text_font(music_cover_placeholder, &lv_font_montserrat_36,
                               LV_PART_MAIN);
    lv_obj_set_style_text_color(music_cover_placeholder, lv_color_hex(0xF2C14E),
                                LV_PART_MAIN);

    music_title = lv_label_create(ui_ScreenMusic);
    lv_obj_set_size(music_title, 354, 28);
    lv_obj_align(music_title, LV_ALIGN_TOP_MID, 0, 275);
    lv_label_set_long_mode(music_title, LV_LABEL_LONG_CLIP);
    lv_label_set_text(music_title, "");
    lv_obj_set_style_text_align(music_title, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_title, &hsp_font_cjk_22, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_title, lv_color_hex(0xFFFFFF), LV_PART_MAIN);

    music_lyric = lv_label_create(ui_ScreenMusic);
    lv_obj_set_size(music_lyric, 354, 28);
    lv_obj_align(music_lyric, LV_ALIGN_TOP_MID, 0, 305);
    lv_label_set_long_mode(music_lyric, LV_LABEL_LONG_CLIP);
    lv_label_set_text(music_lyric, "");
    lv_obj_set_style_text_align(music_lyric, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_lyric, &hsp_font_cjk_22, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_lyric, lv_color_hex(0xFFFFFF), LV_PART_MAIN);

    music_progress = lv_label_create(ui_ScreenMusic);
    lv_obj_set_size(music_progress, 220, 18);
    lv_obj_align(music_progress, LV_ALIGN_TOP_MID, 0, 340);
    lv_label_set_text(music_progress, "");
    lv_obj_set_style_text_align(music_progress, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_progress, &lv_font_montserrat_12,
                               LV_PART_MAIN);
    lv_obj_set_style_text_color(music_progress, lv_color_hex(0x85858C),
                                LV_PART_MAIN);

    music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_PREV, -100,
                           music_ui_previous_event);
    music_play_button = music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_PLAY, 0,
                                                music_ui_play_event);
    music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_NEXT, 100,
                           music_ui_next_event);

    displayed_cover_generation = 0;
    failed_cover_generation = 0;
    failed_cover_attempts = 0U;
    displayed_metadata_generation = UINT32_MAX;
    displayed_lyric_generation = UINT32_MAX;
    displayed_progress_generation = UINT32_MAX;
    displayed_playing = UINT8_MAX;
    displayed_volume = UINT8_MAX;
    displayed_cover_available = UINT8_MAX;
    music_title_text[0] = '\0';
    music_lyric_text[0] = '\0';
    rt_memset(&music_ui_snapshot, 0, sizeof(music_ui_snapshot));
    music_ui_timer = lv_timer_create(music_ui_refresh_timer, 300, NULL);
    music_ui_refresh_timer(music_ui_timer);
}

void ui_ScreenMusic_screen_destroy(void)
{
    if (music_ui_timer != NULL)
        lv_timer_del(music_ui_timer);

    music_ui_timer = NULL;
    if (ui_ScreenMusic != NULL)
        lv_obj_del(ui_ScreenMusic);

    ui_ScreenMusic = NULL;
    music_cover = NULL;
    music_cover_placeholder = NULL;
    music_title = NULL;
    music_lyric = NULL;
    music_progress = NULL;
    music_play_button = NULL;
    music_volume = NULL;
}
