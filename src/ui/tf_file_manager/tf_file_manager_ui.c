#include "tf_file_manager_ui.h"

#include <stdint.h>
#include <string.h>

#include "dfs_file.h"
#include "dfs_posix.h"
#include "services/tf_card.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/ui_swipe_back.h"

#define TF_FM_BG              0x050608
#define TF_FM_ROW             0x171B22
#define TF_FM_ROW_PRESSED     0x26303B
#define TF_FM_TEXT            0xF4F7FA
#define TF_FM_MUTED           0x97A1AD
#define TF_FM_ACCENT          0x55D985
#define TF_FM_BLUE            0x4DA3FF
#define TF_FM_MAX_ENTRIES     80U
#define TF_FM_NAME_LEN        64U
#define TF_FM_PATH_LEN        160U
#define TF_FM_PREVIEW_BYTES   2048U

typedef struct
{
    char name[TF_FM_NAME_LEN];
    char path[TF_FM_PATH_LEN];
    uint32_t size;
    uint8_t is_dir;
} tf_file_entry_t;

lv_obj_t *ui_TfFileManager;

static lv_obj_t *tf_fm_panel;
static lv_obj_t *tf_fm_title;
static lv_obj_t *tf_fm_path_label;
static lv_obj_t *tf_fm_content;
static lv_obj_t *tf_fm_status;
static tf_file_entry_t tf_fm_entries[TF_FM_MAX_ENTRIES];
static uint16_t tf_fm_entry_count;
static char tf_fm_current_path[TF_FM_PATH_LEN] = TF_CARD_ROOT_PATH;
static char tf_fm_preview_text[TF_FM_PREVIEW_BYTES + 1U];
static uint8_t tf_fm_preview_open;

static void tf_fm_build_list(void);

static void tf_fm_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void tf_fm_style_object(lv_obj_t *object, uint32_t color,
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

static lv_obj_t *tf_fm_add_label(lv_obj_t *parent, const char *text,
                                 const lv_font_t *font, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_letter_space(label, 0,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);
    return label;
}

static void tf_fm_format_size(uint32_t size, char *buffer, size_t length)
{
    if (size >= 1024UL * 1024UL)
    {
        rt_snprintf(buffer, length, "%lu.%lu MB", size / (1024UL * 1024UL),
                    (size % (1024UL * 1024UL)) / (1024UL * 102UL));
    }
    else if (size >= 1024UL)
    {
        rt_snprintf(buffer, length, "%lu.%lu KB", size / 1024UL,
                    (size % 1024UL) / 102UL);
    }
    else
    {
        rt_snprintf(buffer, length, "%lu B", size);
    }
}

static void tf_fm_join_path(const char *dir, const char *name, char *buffer,
                            size_t length)
{
    if (strcmp(dir, "/") == 0)
        rt_snprintf(buffer, length, "/%s", name);
    else
        rt_snprintf(buffer, length, "%s/%s", dir, name);
}

static uint8_t tf_fm_is_root_path(const char *path)
{
    return strcmp(path, tf_card_root_path()) == 0;
}

static void tf_fm_parent_path(char *path)
{
    const char *root_path = tf_card_root_path();
    char *slash;

    if (tf_fm_is_root_path(path))
        return;

    slash = strrchr(path, '/');
    if (slash == NULL || slash <= path + strlen(root_path))
    {
        strcpy(path, root_path);
        return;
    }
    *slash = '\0';
}

static uint8_t tf_fm_stat_path(tf_file_entry_t *entry)
{
    struct stat st;

    entry->size = 0U;
    entry->is_dir = 0U;
    if (stat(entry->path, &st) != 0)
    {
        DIR *dir = opendir(entry->path);
        if (dir != NULL)
        {
            closedir(dir);
            entry->is_dir = 1U;
            return 1U;
        }
        return 0U;
    }

    entry->size = (uint32_t)st.st_size;
    if (S_ISDIR(st.st_mode))
        entry->is_dir = 1U;
    return 1U;
}

static int tf_fm_entry_compare(const tf_file_entry_t *left,
                               const tf_file_entry_t *right)
{
    if (left->is_dir != right->is_dir)
        return right->is_dir - left->is_dir;
    return strcmp(left->name, right->name);
}

static void tf_fm_sort_entries(void)
{
    uint16_t i;
    uint16_t j;

    for (i = 0U; i < tf_fm_entry_count; i++)
    {
        for (j = (uint16_t)(i + 1U); j < tf_fm_entry_count; j++)
        {
            if (tf_fm_entry_compare(&tf_fm_entries[i], &tf_fm_entries[j]) > 0)
            {
                tf_file_entry_t tmp = tf_fm_entries[i];
                tf_fm_entries[i] = tf_fm_entries[j];
                tf_fm_entries[j] = tmp;
            }
        }
    }
}

static void tf_fm_load_entries(void)
{
    DIR *dir;
    struct dirent *dirent;

    tf_fm_entry_count = 0U;
    dir = opendir(tf_fm_current_path);
    if (dir == NULL)
        return;

    while ((dirent = readdir(dir)) != NULL &&
           tf_fm_entry_count < TF_FM_MAX_ENTRIES)
    {
        tf_file_entry_t *entry;

        if (strcmp(dirent->d_name, ".") == 0 ||
            strcmp(dirent->d_name, "..") == 0)
            continue;

        entry = &tf_fm_entries[tf_fm_entry_count];
        rt_memset(entry, 0, sizeof(*entry));
        strncpy(entry->name, dirent->d_name, sizeof(entry->name) - 1U);
        tf_fm_join_path(tf_fm_current_path, entry->name, entry->path,
                        sizeof(entry->path));
        (void)tf_fm_stat_path(entry);
        tf_fm_entry_count++;
    }

    closedir(dir);
    tf_fm_sort_entries();
}

static void tf_fm_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_TfFileManager_return();
}

static void tf_fm_refresh_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        tf_fm_build_list();
}

static lv_obj_t *tf_fm_add_header_button(lv_coord_t x, const char *symbol,
                                         lv_event_cb_t callback)
{
    lv_obj_t *button = lv_btn_create(tf_fm_panel);
    lv_obj_t *label;

    lv_obj_set_pos(button, x, 12);
    lv_obj_set_size(button, 44, 44);
    tf_fm_style_object(button, TF_FM_BG, LV_OPA_COVER, 22);
    lv_obj_set_style_bg_color(button, lv_color_hex(TF_FM_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);

    label = tf_fm_add_label(button, symbol, &lv_font_montserrat_20,
                            TF_FM_ACCENT);
    lv_obj_center(label);
    return button;
}

static void tf_fm_add_header(const char *title)
{
    tf_fm_add_header_button(20, LV_SYMBOL_LEFT, tf_fm_back_event);
    tf_fm_add_header_button((lv_coord_t)(LV_HOR_RES_MAX - 64),
                            LV_SYMBOL_REFRESH, tf_fm_refresh_event);

    tf_fm_title = tf_fm_add_label(tf_fm_panel, title, &hsp_font_cjk_22,
                                  TF_FM_TEXT);
    lv_obj_set_pos(tf_fm_title, 76, 17);
    lv_obj_set_width(tf_fm_title, (lv_coord_t)(LV_HOR_RES_MAX - 152));
    lv_label_set_long_mode(tf_fm_title, LV_LABEL_LONG_DOT);

    tf_fm_path_label = tf_fm_add_label(tf_fm_panel, TF_CARD_ROOT_PATH,
                                       &lv_font_montserrat_16, TF_FM_MUTED);
    lv_obj_set_pos(tf_fm_path_label, 24, 62);
    lv_obj_set_width(tf_fm_path_label, (lv_coord_t)(LV_HOR_RES_MAX - 48));
    lv_label_set_long_mode(tf_fm_path_label, LV_LABEL_LONG_DOT);
}

static lv_obj_t *tf_fm_add_row(const char *symbol, const char *name,
                               const char *meta, lv_coord_t y,
                               lv_event_cb_t callback, void *user_data)
{
    lv_obj_t *row = lv_btn_create(tf_fm_content);
    lv_obj_t *icon;
    lv_obj_t *label;
    lv_obj_t *sub;

    lv_obj_set_pos(row, 22, y);
    lv_obj_set_size(row, (lv_coord_t)(LV_HOR_RES_MAX - 44), 66);
    tf_fm_style_object(row, TF_FM_ROW, LV_OPA_COVER, 18);
    lv_obj_set_style_bg_color(row, lv_color_hex(TF_FM_ROW_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_add_event_cb(row, callback, LV_EVENT_CLICKED, user_data);

    icon = tf_fm_add_label(row, symbol, &lv_font_montserrat_24, TF_FM_BLUE);
    lv_obj_set_pos(icon, 18, 20);

    label = tf_fm_add_label(row, name, &hsp_font_cjk_22, TF_FM_TEXT);
    lv_obj_set_pos(label, 58, 11);
    lv_obj_set_width(label, (lv_coord_t)(LV_HOR_RES_MAX - 148));
    lv_label_set_long_mode(label, LV_LABEL_LONG_DOT);

    sub = tf_fm_add_label(row, meta, &lv_font_montserrat_16, TF_FM_MUTED);
    lv_obj_set_pos(sub, 58, 40);
    lv_obj_set_width(sub, (lv_coord_t)(LV_HOR_RES_MAX - 148));
    lv_label_set_long_mode(sub, LV_LABEL_LONG_DOT);

    return row;
}

static void tf_fm_parent_event(lv_event_t *event)
{
    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;

    tf_fm_parent_path(tf_fm_current_path);
    tf_fm_build_list();
}

static void tf_fm_open_file(const tf_file_entry_t *entry)
{
    int fd;
    int bytes;
    uint16_t i;
    uint16_t binary_score = 0U;
    char size_text[24];
    char meta_text[96];
    lv_obj_t *preview;
    lv_obj_t *title;
    lv_obj_t *meta;

    lv_obj_clean(tf_fm_content);
    tf_fm_preview_open = 1U;
    lv_label_set_text(tf_fm_title, "文件预览");
    lv_label_set_text(tf_fm_path_label, entry->path);

    fd = open(entry->path, O_RDONLY, 0);
    if (fd < 0)
    {
        rt_snprintf(tf_fm_preview_text, sizeof(tf_fm_preview_text),
                    "无法打开文件: %s", entry->name);
    }
    else
    {
        bytes = read(fd, tf_fm_preview_text, TF_FM_PREVIEW_BYTES);
        close(fd);
        if (bytes < 0)
            bytes = 0;
        tf_fm_preview_text[bytes] = '\0';
        for (i = 0U; i < (uint16_t)bytes; i++)
        {
            unsigned char ch = (unsigned char)tf_fm_preview_text[i];

            if (ch == '\0')
            {
                binary_score++;
                tf_fm_preview_text[i] = '.';
            }
            else if (ch < 0x20U && ch != '\n' && ch != '\r' && ch != '\t')
            {
                binary_score++;
                tf_fm_preview_text[i] = '.';
            }
        }
        if (binary_score > 8U)
        {
            rt_snprintf(tf_fm_preview_text, sizeof(tf_fm_preview_text),
                        "二进制文件，暂不预览内容。");
        }
        else if (bytes == 0)
        {
            rt_snprintf(tf_fm_preview_text, sizeof(tf_fm_preview_text),
                        "空文件");
        }
    }

    tf_fm_format_size(entry->size, size_text, sizeof(size_text));
    rt_snprintf(meta_text, sizeof(meta_text), "%s  |  %s", size_text,
                entry->name);

    title = tf_fm_add_label(tf_fm_content, entry->name, &hsp_font_cjk_22,
                            TF_FM_TEXT);
    lv_obj_set_pos(title, 24, 12);
    lv_obj_set_width(title, (lv_coord_t)(LV_HOR_RES_MAX - 48));
    lv_label_set_long_mode(title, LV_LABEL_LONG_DOT);

    meta = tf_fm_add_label(tf_fm_content, meta_text, &lv_font_montserrat_16,
                           TF_FM_MUTED);
    lv_obj_set_pos(meta, 24, 44);
    lv_obj_set_width(meta, (lv_coord_t)(LV_HOR_RES_MAX - 48));
    lv_label_set_long_mode(meta, LV_LABEL_LONG_DOT);

    preview = tf_fm_add_label(tf_fm_content, tf_fm_preview_text,
                              &lv_font_montserrat_16, TF_FM_TEXT);
    lv_obj_set_pos(preview, 24, 84);
    lv_obj_set_width(preview, (lv_coord_t)(LV_HOR_RES_MAX - 48));
    lv_label_set_long_mode(preview, LV_LABEL_LONG_WRAP);
}

static void tf_fm_entry_event(lv_event_t *event)
{
    tf_file_entry_t *entry = lv_event_get_user_data(event);

    if (lv_event_get_code(event) != LV_EVENT_CLICKED || entry == NULL)
        return;

    if (entry->is_dir)
    {
        strncpy(tf_fm_current_path, entry->path,
                sizeof(tf_fm_current_path) - 1U);
        tf_fm_current_path[sizeof(tf_fm_current_path) - 1U] = '\0';
        tf_fm_build_list();
    }
    else
    {
        tf_fm_open_file(entry);
    }
}

static void tf_fm_show_status(const char *text)
{
    tf_fm_status = tf_fm_add_label(tf_fm_content, text, &hsp_font_cjk_22,
                                   TF_FM_MUTED);
    lv_obj_set_width(tf_fm_status, (lv_coord_t)(LV_HOR_RES_MAX - 56));
    lv_label_set_long_mode(tf_fm_status, LV_LABEL_LONG_WRAP);
    lv_obj_align(tf_fm_status, LV_ALIGN_TOP_MID, 0, 92);
}

static void tf_fm_build_list(void)
{
    lv_coord_t y = 8;
    uint16_t i;

    tf_fm_preview_open = 0U;
    lv_obj_clean(tf_fm_content);
    lv_label_set_text(tf_fm_title, "TF文件");
    lv_label_set_text(tf_fm_path_label, tf_fm_current_path);

    if (tf_card_mount() != RT_EOK)
    {
        tf_fm_show_status(tf_card_status_text());
        return;
    }

    if (strcmp(tf_fm_current_path, TF_CARD_ROOT_PATH) == 0 &&
        strcmp(tf_card_root_path(), TF_CARD_ROOT_PATH) != 0)
    {
        strncpy(tf_fm_current_path, tf_card_root_path(),
                sizeof(tf_fm_current_path) - 1U);
        tf_fm_current_path[sizeof(tf_fm_current_path) - 1U] = '\0';
        lv_label_set_text(tf_fm_path_label, tf_fm_current_path);
    }

    tf_fm_load_entries();
    if (!tf_fm_is_root_path(tf_fm_current_path))
    {
        tf_fm_add_row(LV_SYMBOL_LEFT, "..", "上一级", y, tf_fm_parent_event,
                      NULL);
        y += 76;
    }

    for (i = 0U; i < tf_fm_entry_count; i++)
    {
        char meta[32];

        if (tf_fm_entries[i].is_dir)
            rt_snprintf(meta, sizeof(meta), "文件夹");
        else
            tf_fm_format_size(tf_fm_entries[i].size, meta, sizeof(meta));

        tf_fm_add_row(tf_fm_entries[i].is_dir ? LV_SYMBOL_DIRECTORY :
                      LV_SYMBOL_FILE, tf_fm_entries[i].name, meta, y,
                      tf_fm_entry_event, &tf_fm_entries[i]);
        y += 76;
    }

    if (tf_fm_entry_count == 0U && tf_fm_is_root_path(tf_fm_current_path))
        tf_fm_show_status("TF卡为空");
}

void ui_TfFileManager_screen_init(void)
{
    if (ui_TfFileManager != NULL)
        return;

    ui_TfFileManager = lv_obj_create(NULL);
    ui_swipe_back_register(ui_TfFileManager, ui_TfFileManager_return);
    lv_obj_clear_flag(ui_TfFileManager, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_TfFileManager, lv_color_hex(TF_FM_BG),
                              LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_TfFileManager, LV_OPA_COVER, LV_PART_MAIN);

    tf_fm_panel = lv_obj_create(ui_TfFileManager);
    lv_obj_set_size(tf_fm_panel, LV_HOR_RES_MAX, LV_VER_RES_MAX);
    lv_obj_center(tf_fm_panel);
    tf_fm_style_object(tf_fm_panel, TF_FM_BG, LV_OPA_COVER, 0);

    tf_fm_add_header("TF文件");

    tf_fm_content = lv_obj_create(tf_fm_panel);
    lv_obj_set_pos(tf_fm_content, 0, 92);
    lv_obj_set_size(tf_fm_content, LV_HOR_RES_MAX,
                    (lv_coord_t)(LV_VER_RES_MAX - 92));
    lv_obj_set_style_bg_opa(tf_fm_content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(tf_fm_content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(tf_fm_content, 0, LV_PART_MAIN);
    lv_obj_set_scroll_dir(tf_fm_content, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(tf_fm_content, LV_SCROLLBAR_MODE_AUTO);
}

void ui_TfFileManager_screen_destroy(void)
{
    if (ui_TfFileManager != NULL)
        lv_obj_del(ui_TfFileManager);

    ui_TfFileManager = NULL;
    tf_fm_panel = NULL;
    tf_fm_title = NULL;
    tf_fm_path_label = NULL;
    tf_fm_content = NULL;
    tf_fm_status = NULL;
}

void ui_TfFileManager_open_from_app_grid(void)
{
    tf_fm_wait_release();
    if (ui_TfFileManager == NULL)
        ui_TfFileManager_screen_init();

    strcpy(tf_fm_current_path, TF_CARD_ROOT_PATH);
    tf_fm_build_list();
    lv_scr_load_anim(ui_TfFileManager, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0,
                     false);
}

void ui_TfFileManager_return(void)
{
    tf_fm_wait_release();
    if (tf_fm_preview_open)
    {
        tf_fm_build_list();
        return;
    }

    if (!tf_fm_is_root_path(tf_fm_current_path))
    {
        tf_fm_parent_path(tf_fm_current_path);
        tf_fm_build_list();
        return;
    }

    ui_AppGrid_open();
}
