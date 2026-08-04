/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "ui/generated/ui.h"
#include "services/input_wake.h"
#include "bluetooth/music_app.h"
#include "music_ui.h"

#define MUSIC_COVER_PATH "/cover.jpg"
#define MUSIC_COVER_SIZE (104)

lv_obj_t *ui_ScreenMusic;
static lv_obj_t *music_cover;
static lv_obj_t *music_cover_placeholder;
static lv_obj_t *music_title;
static lv_obj_t *music_artist;
static lv_obj_t *music_album;
static lv_obj_t *music_status;
static lv_obj_t *music_play_button;
static lv_obj_t *music_volume;
static lv_obj_t *music_volume_bar;
static uint32_t displayed_cover_generation;
static uint32_t failed_cover_generation;
static lv_timer_t *music_ui_timer;

static void music_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        _ui_screen_change(&ui_ScreenHome, LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180, 0,
                          &ui_ScreenHome_screen_init);
}

static void music_ui_gesture_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_GESTURE &&
        lv_indev_get_gesture_dir(lv_indev_get_act()) == LV_DIR_RIGHT)
    {
        lv_indev_wait_release(lv_indev_get_act());
        _ui_screen_change(&ui_ScreenHome, LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180, 0,
                          &ui_ScreenHome_screen_init);
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

static void music_ui_physical_key_event(uint32_t key_index)
{
    if (lv_scr_act() != ui_ScreenMusic)
        return;

    if (key_index == 0)
        music_app_adjust_volume(1);
    else if (key_index == 1)
        music_app_adjust_volume(-1);
}

static lv_obj_t *music_ui_create_button(lv_obj_t *parent, const char *symbol,
                                        int x, lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);
    lv_obj_t *label = lv_label_create(button);
    int is_play_button = (x == 0);

    lv_obj_set_size(button, is_play_button ? 76 : 64,
                    is_play_button ? 76 : 64);
    lv_obj_set_x(button, x);
    lv_obj_set_y(button, 145);
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

static void music_ui_refresh_cover(uint32_t generation)
{
    lv_img_header_t header;
    int zoom;

    if (generation == displayed_cover_generation)
        return;

    lv_img_cache_invalidate_src(MUSIC_COVER_PATH);
    if (lv_img_decoder_get_info(MUSIC_COVER_PATH, &header) != LV_RES_OK ||
        header.w == 0 || header.h == 0)
    {
        if (failed_cover_generation != generation)
        {
            failed_cover_generation = generation;
            rt_kprintf("music: LVGL cannot decode %s\n", MUSIC_COVER_PATH);
        }
        return;
    }

    zoom = (MUSIC_COVER_SIZE * LV_IMG_ZOOM_NONE) / header.w;
    if ((MUSIC_COVER_SIZE * LV_IMG_ZOOM_NONE) / header.h < zoom)
        zoom = (MUSIC_COVER_SIZE * LV_IMG_ZOOM_NONE) / header.h;
    if (zoom <= 0)
        return;

    displayed_cover_generation = generation;
    failed_cover_generation = 0;
    lv_img_set_src(music_cover, MUSIC_COVER_PATH);
    lv_img_set_zoom(music_cover, zoom);
    lv_obj_clear_flag(music_cover, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(music_cover_placeholder, LV_OBJ_FLAG_HIDDEN);
}

static void music_ui_refresh_timer(lv_timer_t *timer)
{
    music_app_snapshot_t snapshot;

    (void)timer;
    if (ui_ScreenMusic == NULL)
        return;

    music_app_get_snapshot(&snapshot);
    lv_label_set_text(music_title, snapshot.title[0] ? snapshot.title : "No music");
    lv_label_set_text(music_artist, snapshot.artist[0] ? snapshot.artist : "Bluetooth audio");
    lv_label_set_text(music_album, snapshot.album[0] ? snapshot.album : "");
    lv_label_set_text(music_status, snapshot.connected ?
                      (snapshot.playing ? "PLAYING" : "PAUSED") : "NOT CONNECTED");
    lv_label_set_text(lv_obj_get_child(music_play_button, 0),
                      snapshot.playing ? LV_SYMBOL_PAUSE : LV_SYMBOL_PLAY);
    lv_bar_set_value(music_volume_bar, (snapshot.volume * 100 + 63) / 127,
                     LV_ANIM_ON);
    lv_label_set_text_fmt(music_volume, LV_SYMBOL_VOLUME_MAX " %d%%",
                          (snapshot.volume * 100 + 63) / 127);
    if (snapshot.cover_available)
    {
        music_ui_refresh_cover(snapshot.cover_generation);
    }
    else
    {
        lv_obj_add_flag(music_cover, LV_OBJ_FLAG_HIDDEN);
        lv_obj_clear_flag(music_cover_placeholder, LV_OBJ_FLAG_HIDDEN);
        music_app_retry_cover_request();
    }
}

void ui_ScreenMusic_screen_init(void)
{
    lv_obj_t *header;
    lv_obj_t *back_button;
    lv_obj_t *cover_frame;
    lv_obj_t *title_label;

    ui_ScreenMusic = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_ScreenMusic, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_ScreenMusic, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_ScreenMusic, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_add_event_cb(ui_ScreenMusic, music_ui_gesture_event, LV_EVENT_GESTURE,
                        NULL);

    header = lv_obj_create(ui_ScreenMusic);
    lv_obj_set_size(header, 390, 54);
    lv_obj_align(header, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_clear_flag(header, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(header, 0, LV_PART_MAIN);
    lv_obj_set_style_bg_color(header, lv_color_hex(0x080808), LV_PART_MAIN);
    lv_obj_set_style_border_width(header, 0, LV_PART_MAIN);

    back_button = lv_btn_create(header);
    lv_obj_set_size(back_button, 42, 42);
    lv_obj_align(back_button, LV_ALIGN_LEFT_MID, 8, 0);
    lv_obj_set_style_radius(back_button, LV_RADIUS_CIRCLE, LV_PART_MAIN);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_label_set_text(lv_label_create(back_button), LV_SYMBOL_LEFT);
    lv_obj_center(lv_obj_get_child(back_button, 0));
    lv_obj_add_event_cb(back_button, music_ui_back_event, LV_EVENT_CLICKED, NULL);

    title_label = lv_label_create(header);
    lv_label_set_text(title_label, LV_SYMBOL_AUDIO "  MUSIC");
    lv_obj_align(title_label, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_20, LV_PART_MAIN);
    lv_obj_set_style_text_color(title_label, lv_color_hex(0xF2C14E), LV_PART_MAIN);

    cover_frame = lv_obj_create(ui_ScreenMusic);
    lv_obj_set_size(cover_frame, MUSIC_COVER_SIZE, MUSIC_COVER_SIZE);
    lv_obj_align(cover_frame, LV_ALIGN_TOP_MID, 0, 62);
    lv_obj_clear_flag(cover_frame, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(cover_frame, 8, LV_PART_MAIN);
    lv_obj_set_style_bg_color(cover_frame, lv_color_hex(0x0B0B0D), LV_PART_MAIN);
    lv_obj_set_style_border_color(cover_frame, lv_color_hex(0x36363C), LV_PART_MAIN);
    lv_obj_set_style_border_width(cover_frame, 2, LV_PART_MAIN);
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
    lv_obj_set_width(music_title, 350);
    lv_obj_align(music_title, LV_ALIGN_TOP_MID, 0, 180);
    lv_label_set_long_mode(music_title, LV_LABEL_LONG_DOT);
    lv_label_set_text(music_title, "No music");
    lv_obj_set_style_text_align(music_title, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_title, LV_FONT_DEFAULT, LV_PART_MAIN);
    lv_obj_set_style_transform_zoom(music_title, 150, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_title, lv_color_hex(0xFFFFFF), LV_PART_MAIN);

    music_artist = lv_label_create(ui_ScreenMusic);
    lv_obj_set_width(music_artist, 350);
    lv_obj_align(music_artist, LV_ALIGN_TOP_MID, 0, 215);
    lv_label_set_long_mode(music_artist, LV_LABEL_LONG_DOT);
    lv_label_set_text(music_artist, "Bluetooth audio");
    lv_obj_set_style_text_align(music_artist, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_artist, LV_FONT_DEFAULT, LV_PART_MAIN);
    lv_obj_set_style_transform_zoom(music_artist, 125, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_artist, lv_color_hex(0xB4B4BA), LV_PART_MAIN);

    music_album = lv_label_create(ui_ScreenMusic);
    lv_obj_set_width(music_album, 350);
    lv_obj_align(music_album, LV_ALIGN_TOP_MID, 0, 242);
    lv_label_set_long_mode(music_album, LV_LABEL_LONG_DOT);
    lv_obj_set_style_text_align(music_album, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(music_album, LV_FONT_DEFAULT, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_album, lv_color_hex(0x85858C), LV_PART_MAIN);

    music_status = lv_label_create(ui_ScreenMusic);
    lv_obj_align(music_status, LV_ALIGN_TOP_MID, 0, 270);
    lv_label_set_text(music_status, "NOT CONNECTED");
    lv_obj_set_style_text_font(music_status, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_status, lv_color_hex(0xE0B400), LV_PART_MAIN);

    music_volume = lv_label_create(ui_ScreenMusic);
    lv_obj_align(music_volume, LV_ALIGN_TOP_MID, -122, 292);
    lv_label_set_text(music_volume, LV_SYMBOL_VOLUME_MAX " 50%");
    lv_obj_set_style_text_font(music_volume, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_style_text_color(music_volume, lv_color_hex(0xC7C7CC), LV_PART_MAIN);

    music_volume_bar = lv_bar_create(ui_ScreenMusic);
    lv_obj_set_size(music_volume_bar, 148, 6);
    lv_obj_align(music_volume_bar, LV_ALIGN_TOP_MID, 72, 297);
    lv_bar_set_range(music_volume_bar, 0, 100);
    lv_bar_set_value(music_volume_bar, 50, LV_ANIM_OFF);
    lv_obj_set_style_radius(music_volume_bar, LV_RADIUS_CIRCLE, LV_PART_MAIN);
    lv_obj_set_style_bg_color(music_volume_bar, lv_color_hex(0x28282D), LV_PART_MAIN);
    lv_obj_set_style_radius(music_volume_bar, LV_RADIUS_CIRCLE, LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(music_volume_bar, lv_color_hex(0xE0B400),
                               LV_PART_INDICATOR);

    music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_PREV, -100,
                           music_ui_previous_event);
    music_play_button = music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_PLAY, 0,
                                                music_ui_play_event);
    music_ui_create_button(ui_ScreenMusic, LV_SYMBOL_NEXT, 100,
                           music_ui_next_event);

    displayed_cover_generation = 0;
    failed_cover_generation = 0;
    music_ui_timer = lv_timer_create(music_ui_refresh_timer, 300, NULL);
    input_wake_set_key_press_handler(music_ui_physical_key_event);
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
    music_artist = NULL;
    music_album = NULL;
    music_status = NULL;
    music_play_button = NULL;
    music_volume = NULL;
    music_volume_bar = NULL;
    input_wake_set_key_press_handler(NULL);
}
