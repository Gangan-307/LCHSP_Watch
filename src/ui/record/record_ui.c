#include "record_ui.h"

#include <stdint.h>
#include <string.h>

#include "services/recording_service.h"
#include "services/tf_card.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/ui_swipe_back.h"

#define RECORD_UI_BG              0x050608
#define RECORD_UI_PANEL           0x090B0F
#define RECORD_UI_ROW             0x171B22
#define RECORD_UI_ROW_PRESSED     0x29313B
#define RECORD_UI_TEXT            0xF5F7FA
#define RECORD_UI_MUTED           0x929AA5
#define RECORD_UI_GREEN           0x55D985
#define RECORD_UI_RED             0xF04455
#define RECORD_UI_BLUE            0x4DA3FF
#define RECORD_UI_MAX_ENTRIES     12U

lv_obj_t *ui_Record;

static lv_obj_t *record_panel;
static lv_obj_t *record_status_label;
static lv_obj_t *record_time_label;
static lv_obj_t *record_action_button;
static lv_obj_t *record_action_indicator;
static lv_obj_t *record_list;
static lv_obj_t *record_play_labels[RECORD_UI_MAX_ENTRIES];
static lv_obj_t *record_delete_buttons[RECORD_UI_MAX_ENTRIES];
static lv_obj_t *record_delete_dialog;
static recording_entry_t record_entries[RECORD_UI_MAX_ENTRIES];
static uint16_t record_entry_count;
static lv_timer_t *record_timer;
static uint8_t record_refresh_after_save;
static uint32_t record_tf_generation;
static char record_delete_path[RECORDING_PATH_LEN];

static void record_ui_refresh(void);
static void record_ui_refresh_list(void);

static void record_ui_close_delete_dialog(void)
{
    if (record_delete_dialog != NULL)
        lv_obj_del(record_delete_dialog);
    record_delete_dialog = NULL;
    record_delete_path[0] = '\0';
}

static void record_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void record_ui_style_object(lv_obj_t *object, uint32_t color,
                                   lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_set_style_radius(object, radius, LV_PART_MAIN);
    lv_obj_set_style_bg_color(object, lv_color_hex(color), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(object, opacity, LV_PART_MAIN);
    lv_obj_set_style_border_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_outline_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_shadow_width(object, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(object, 0, LV_PART_MAIN);
}

static lv_obj_t *record_ui_add_label(lv_obj_t *parent, const char *text,
                                     const lv_font_t *font, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font, LV_PART_MAIN);
    lv_obj_set_style_text_color(label, lv_color_hex(color), LV_PART_MAIN);
    lv_obj_set_style_text_letter_space(label, 0, LV_PART_MAIN);
    return label;
}

static lv_obj_t *record_ui_add_button(lv_obj_t *parent, lv_coord_t x,
                                      lv_coord_t y, lv_coord_t width,
                                      lv_coord_t height,
                                      lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(parent);

    lv_obj_set_pos(button, x, y);
    lv_obj_set_size(button, width, height);
    record_ui_style_object(button, RECORD_UI_ROW, LV_OPA_COVER,
                           height / 2);
    lv_obj_set_style_bg_color(button, lv_color_hex(RECORD_UI_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    if (callback != NULL)
        lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);
    return button;
}

static void record_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Record_return();
}

static void record_ui_record_event(lv_event_t *event)
{
    recording_snapshot_t snapshot;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    recording_service_get_snapshot(&snapshot);
    if (snapshot.state == RECORDING_STATE_IDLE)
        (void)recording_service_start();
    else if (snapshot.state == RECORDING_STATE_RECORDING)
    {
        record_refresh_after_save = 1U;
        (void)recording_service_stop();
    }
    record_ui_refresh();
}

static void record_ui_play_event(lv_event_t *event)
{
    recording_entry_t *entry = lv_event_get_user_data(event);
    recording_snapshot_t snapshot;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED || entry == NULL)
        return;
    recording_service_get_snapshot(&snapshot);
    if (snapshot.state == RECORDING_STATE_PLAYING)
    {
        if (strcmp(snapshot.active_name, entry->name) == 0)
            (void)recording_service_stop();
    }
    else if (snapshot.state == RECORDING_STATE_IDLE)
    {
        (void)recording_service_play(entry->path);
    }
    record_ui_refresh();
}

static void record_ui_delete_cancel_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        record_ui_close_delete_dialog();
}

static void record_ui_delete_confirm_event(lv_event_t *event)
{
    rt_err_t result;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    result = recording_service_delete(record_delete_path);
    record_ui_close_delete_dialog();
    if (result == RT_EOK)
        record_ui_refresh_list();
    record_ui_refresh();
}

static void record_ui_delete_event(lv_event_t *event)
{
    recording_entry_t *entry = lv_event_get_user_data(event);
    lv_obj_t *dialog_panel;
    lv_obj_t *label;
    lv_obj_t *button;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED || entry == NULL ||
        record_delete_dialog != NULL)
        return;

    strncpy(record_delete_path, entry->path, sizeof(record_delete_path) - 1U);
    record_delete_path[sizeof(record_delete_path) - 1U] = '\0';
    record_delete_dialog = lv_obj_create(record_panel);
    lv_obj_set_size(record_delete_dialog, LV_HOR_RES_MAX, LV_VER_RES_MAX);
    lv_obj_center(record_delete_dialog);
    record_ui_style_object(record_delete_dialog, RECORD_UI_BG, LV_OPA_70, 0);

    dialog_panel = lv_obj_create(record_delete_dialog);
    lv_obj_set_size(dialog_panel, 330, 176);
    lv_obj_center(dialog_panel);
    record_ui_style_object(dialog_panel, RECORD_UI_ROW, LV_OPA_COVER, 8);

    label = record_ui_add_label(dialog_panel, "删除这条录音？",
                                &hsp_font_cjk_22, RECORD_UI_TEXT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 20);
    label = record_ui_add_label(dialog_panel, entry->name,
                                &lv_font_montserrat_16, RECORD_UI_MUTED);
    lv_obj_set_width(label, 286);
    lv_label_set_long_mode(label, LV_LABEL_LONG_DOT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 58);

    button = record_ui_add_button(dialog_panel, 20, 108, 132, 48,
                                  record_ui_delete_cancel_event);
    label = record_ui_add_label(button, "取消", &hsp_font_cjk_22,
                                RECORD_UI_TEXT);
    lv_obj_center(label);
    button = record_ui_add_button(dialog_panel, 178, 108, 132, 48,
                                  record_ui_delete_confirm_event);
    lv_obj_set_style_bg_color(button, lv_color_hex(RECORD_UI_RED),
                              LV_PART_MAIN);
    label = record_ui_add_label(button, "删除", &hsp_font_cjk_22,
                                RECORD_UI_TEXT);
    lv_obj_center(label);
}

static void record_ui_format_duration(uint32_t seconds, char *buffer,
                                      size_t size)
{
    uint32_t minutes = seconds / 60U;

    rt_snprintf(buffer, size, "%02lu:%02lu",
                (unsigned long)minutes,
                (unsigned long)(seconds % 60U));
}

static void record_ui_refresh_list(void)
{
    int count;
    uint16_t index;
    lv_coord_t y = 4;

    if (record_list == NULL)
        return;
    lv_obj_clean(record_list);
    rt_memset(record_play_labels, 0, sizeof(record_play_labels));
    rt_memset(record_delete_buttons, 0, sizeof(record_delete_buttons));
    count = recording_service_list(record_entries, RECORD_UI_MAX_ENTRIES);
    record_entry_count = count > 0 ? (uint16_t)count : 0U;
    if (count < 0)
    {
        lv_obj_t *label = record_ui_add_label(record_list, "TF存储不可用",
                                              &hsp_font_cjk_22,
                                              RECORD_UI_MUTED);
        lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 28);
        return;
    }
    if (record_entry_count == 0U)
    {
        lv_obj_t *label = record_ui_add_label(record_list, "暂无录音",
                                              &hsp_font_cjk_22,
                                              RECORD_UI_MUTED);
        lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 28);
        return;
    }

    for (index = 0U; index < record_entry_count; index++)
    {
        lv_obj_t *row = lv_btn_create(record_list);
        lv_obj_t *name;
        lv_obj_t *duration;
        lv_obj_t *play;
        lv_obj_t *delete_button;
        lv_obj_t *delete_icon;
        char duration_text[20];

        lv_obj_set_pos(row, 20, y);
        lv_obj_set_size(row, 350, 64);
        record_ui_style_object(row, RECORD_UI_ROW, LV_OPA_COVER, 8);
        lv_obj_set_style_bg_color(row, lv_color_hex(RECORD_UI_ROW_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_add_event_cb(row, record_ui_play_event, LV_EVENT_CLICKED,
                            &record_entries[index]);

        name = record_ui_add_label(row, record_entries[index].name,
                                   &lv_font_montserrat_16, RECORD_UI_TEXT);
        lv_obj_set_pos(name, 16, 10);
        lv_obj_set_width(name, 218);
        lv_label_set_long_mode(name, LV_LABEL_LONG_DOT);
        record_ui_format_duration(record_entries[index].duration_seconds,
                                  duration_text, sizeof(duration_text));
        duration = record_ui_add_label(row, duration_text,
                                       &lv_font_montserrat_16,
                                       RECORD_UI_MUTED);
        lv_obj_set_pos(duration, 16, 37);
        play = record_ui_add_label(row, LV_SYMBOL_PLAY,
                                   &lv_font_montserrat_20, RECORD_UI_BLUE);
        lv_obj_align(play, LV_ALIGN_RIGHT_MID, -66, 0);
        delete_button = lv_btn_create(row);
        lv_obj_set_size(delete_button, 48, 48);
        lv_obj_align(delete_button, LV_ALIGN_RIGHT_MID, -8, 0);
        record_ui_style_object(delete_button, RECORD_UI_ROW, LV_OPA_COVER, 6);
        lv_obj_set_style_bg_color(delete_button,
                                  lv_color_hex(RECORD_UI_ROW_PRESSED),
                                  LV_PART_MAIN | LV_STATE_PRESSED);
        lv_obj_add_event_cb(delete_button, record_ui_delete_event,
                            LV_EVENT_CLICKED, &record_entries[index]);
        delete_icon = record_ui_add_label(delete_button, LV_SYMBOL_TRASH,
                                          &lv_font_montserrat_20,
                                          RECORD_UI_RED);
        lv_obj_center(delete_icon);
        record_play_labels[index] = play;
        record_delete_buttons[index] = delete_button;
        y += 72;
    }
}

static const char *record_ui_status_text(const recording_snapshot_t *snapshot)
{
    switch (snapshot->state)
    {
    case RECORDING_STATE_STARTING: return "正在准备";
    case RECORDING_STATE_RECORDING: return "正在录音";
    case RECORDING_STATE_PLAYING: return "正在播放";
    case RECORDING_STATE_STOPPING:
        return strcmp(snapshot->status, "Stopping playback") == 0 ?
               "正在停止" : "正在保存";
    default:
        if (strcmp(snapshot->status, "Recording saved") == 0)
            return "录音已保存";
        if (strcmp(snapshot->status, "Playback complete") == 0)
            return "播放完成";
        if (strcmp(snapshot->status, "Playback stopped") == 0)
            return "播放已停止";
        if (strcmp(snapshot->status, "Recording deleted") == 0)
            return "录音已删除";
        if (strcmp(snapshot->status, "TF card removed") == 0)
            return "TF卡已拔出";
        if (strcmp(snapshot->status, "Music playback is active") == 0)
            return "请先停止音乐播放";
        if (strcmp(snapshot->status, "Stop recording or playback first") == 0)
            return "请先停止录音或播放";
        if (strcmp(snapshot->status, "Ready") == 0)
            return "点击开始录音";
        return snapshot->status;
    }
}

static void record_ui_refresh(void)
{
    recording_snapshot_t snapshot;
    char time_text[20];
    uint16_t index;
    uint32_t tf_generation;

    if (record_panel == NULL)
        return;
    tf_generation = tf_card_generation();
    if (tf_generation != record_tf_generation)
    {
        record_tf_generation = tf_generation;
        record_ui_close_delete_dialog();
        if (tf_card_state() != TF_CARD_STATE_REMOVING)
            record_ui_refresh_list();
        record_tf_generation = tf_card_generation();
    }
    recording_service_get_snapshot(&snapshot);
    rt_snprintf(time_text, sizeof(time_text), "%02lu:%02lu:%02lu",
                (unsigned long)(snapshot.elapsed_seconds / 3600U),
                (unsigned long)((snapshot.elapsed_seconds / 60U) % 60U),
                (unsigned long)(snapshot.elapsed_seconds % 60U));
    lv_label_set_text(record_time_label, time_text);
    lv_label_set_text(record_status_label,
                      !tf_card_is_mounted() &&
                      snapshot.state == RECORDING_STATE_IDLE ?
                      "TF卡未插入" : record_ui_status_text(&snapshot));

    if (snapshot.state == RECORDING_STATE_RECORDING)
    {
        lv_obj_clear_state(record_action_button, LV_STATE_DISABLED);
        lv_obj_set_size(record_action_indicator, 34, 34);
        lv_obj_set_style_radius(record_action_indicator, 5, LV_PART_MAIN);
    }
    else
    {
        lv_obj_set_size(record_action_indicator, 46, 46);
        lv_obj_set_style_radius(record_action_indicator, 23, LV_PART_MAIN);
        if (snapshot.state == RECORDING_STATE_IDLE && tf_card_is_mounted())
            lv_obj_clear_state(record_action_button, LV_STATE_DISABLED);
        else
            lv_obj_add_state(record_action_button, LV_STATE_DISABLED);
    }
    lv_obj_center(record_action_indicator);

    for (index = 0U; index < record_entry_count; index++)
    {
        if (record_play_labels[index] != NULL)
        {
            uint8_t active = snapshot.state == RECORDING_STATE_PLAYING &&
                             strcmp(snapshot.active_name,
                                    record_entries[index].name) == 0;
            lv_label_set_text(record_play_labels[index],
                              active ? LV_SYMBOL_PAUSE : LV_SYMBOL_PLAY);
            lv_obj_set_style_text_color(record_play_labels[index],
                lv_color_hex(active ? RECORD_UI_GREEN : RECORD_UI_BLUE),
                LV_PART_MAIN);
        }
        if (record_delete_buttons[index] != NULL)
        {
            if (snapshot.state == RECORDING_STATE_IDLE &&
                tf_card_is_mounted())
                lv_obj_clear_state(record_delete_buttons[index],
                                   LV_STATE_DISABLED);
            else
                lv_obj_add_state(record_delete_buttons[index],
                                 LV_STATE_DISABLED);
        }
    }

    if (record_refresh_after_save && snapshot.state == RECORDING_STATE_IDLE)
    {
        record_refresh_after_save = 0U;
        record_ui_refresh_list();
    }
}

static void record_ui_timer_event(lv_timer_t *timer)
{
    (void)timer;
    if (ui_Record != NULL && lv_scr_act() == ui_Record)
        record_ui_refresh();
}

void ui_Record_screen_init(void)
{
    lv_obj_t *back;
    lv_obj_t *label;
    lv_obj_t *list_title;

    if (ui_Record != NULL)
        return;
    ui_Record = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Record, ui_Record_return);
    lv_obj_clear_flag(ui_Record, LV_OBJ_FLAG_SCROLLABLE);
    record_ui_style_object(ui_Record, RECORD_UI_BG, LV_OPA_COVER, 0);

    record_panel = lv_obj_create(ui_Record);
    lv_obj_set_size(record_panel, LV_HOR_RES_MAX, LV_VER_RES_MAX);
    lv_obj_center(record_panel);
    lv_obj_clear_flag(record_panel, LV_OBJ_FLAG_SCROLLABLE);
    record_ui_style_object(record_panel, RECORD_UI_PANEL, LV_OPA_COVER, 0);

    back = record_ui_add_button(record_panel, 20, 14, 46, 46,
                                record_ui_back_event);
    label = record_ui_add_label(back, LV_SYMBOL_LEFT,
                                &lv_font_montserrat_20, RECORD_UI_TEXT);
    lv_obj_center(label);
    label = record_ui_add_label(record_panel, "录音",
                                &hsp_font_cjk_22, RECORD_UI_TEXT);
    lv_obj_set_pos(label, 82, 25);

    record_status_label = record_ui_add_label(record_panel, "点击开始录音",
                                               &hsp_font_cjk_22,
                                               RECORD_UI_MUTED);
    lv_obj_set_width(record_status_label, 340);
    lv_obj_set_style_text_align(record_status_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN);
    lv_obj_align(record_status_label, LV_ALIGN_TOP_MID, 0, 76);
    record_time_label = record_ui_add_label(record_panel, "00:00:00",
                                             &lv_font_montserrat_48,
                                             RECORD_UI_TEXT);
    lv_obj_align(record_time_label, LV_ALIGN_TOP_MID, 0, 108);

    record_action_button = record_ui_add_button(record_panel, 151, 170,
                                                 88, 88,
                                                 record_ui_record_event);
    record_action_indicator = lv_obj_create(record_action_button);
    lv_obj_clear_flag(record_action_indicator, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_clear_flag(record_action_indicator, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_size(record_action_indicator, 46, 46);
    record_ui_style_object(record_action_indicator, RECORD_UI_RED,
                           LV_OPA_COVER, 23);
    lv_obj_center(record_action_indicator);

    list_title = record_ui_add_label(record_panel, "录音记录",
                                     &hsp_font_cjk_22, RECORD_UI_TEXT);
    lv_obj_set_pos(list_title, 22, 274);
    record_list = lv_obj_create(record_panel);
    lv_obj_set_pos(record_list, 0, 308);
    lv_obj_set_size(record_list, 390, 142);
    record_ui_style_object(record_list, RECORD_UI_BG, LV_OPA_TRANSP, 0);
    lv_obj_add_flag(record_list, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scroll_dir(record_list, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(record_list, LV_SCROLLBAR_MODE_AUTO);
    lv_obj_set_style_pad_bottom(record_list, 12, LV_PART_MAIN);
}

void ui_Record_init(void)
{
    recording_service_init();
    ui_Record_screen_init();
    if (record_timer == NULL)
        record_timer = lv_timer_create(record_ui_timer_event, 250U, NULL);
}

void ui_Record_screen_destroy(void)
{
    recording_snapshot_t snapshot;

    recording_service_get_snapshot(&snapshot);
    if (snapshot.state == RECORDING_STATE_RECORDING ||
        snapshot.state == RECORDING_STATE_PLAYING)
        (void)recording_service_stop();
    if (record_timer != NULL)
        lv_timer_del(record_timer);
    record_timer = NULL;
    if (ui_Record != NULL)
        lv_obj_del(ui_Record);
    ui_Record = NULL;
    record_panel = NULL;
    record_status_label = NULL;
    record_time_label = NULL;
    record_action_button = NULL;
    record_action_indicator = NULL;
    record_list = NULL;
    record_delete_dialog = NULL;
    record_entry_count = 0U;
}

void ui_Record_open_from_app_grid(void)
{
    record_ui_wait_release();
    if (ui_Record == NULL)
        ui_Record_init();
    record_ui_refresh_list();
    record_tf_generation = tf_card_generation();
    record_ui_refresh();
    lv_scr_load_anim(ui_Record, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Record_return(void)
{
    recording_snapshot_t snapshot;

    record_ui_wait_release();
    recording_service_get_snapshot(&snapshot);
    if (snapshot.state == RECORDING_STATE_RECORDING ||
        snapshot.state == RECORDING_STATE_PLAYING)
        (void)recording_service_stop();
    ui_AppGrid_open();
}
