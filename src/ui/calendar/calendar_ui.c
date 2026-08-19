#include "calendar_ui.h"
#include "calendar_lunar.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "bf0_hal.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/hsp_font_cjk_22.h"

#define CALENDAR_BG             0x050608
#define CALENDAR_PANEL          0x090B0F
#define CALENDAR_CARD           0x171B22
#define CALENDAR_CARD_PRESSED   0x28303A
#define CALENDAR_TEXT           0xF5F7FA
#define CALENDAR_MUTED          0x8E98A6
#define CALENDAR_BLUE           0x3B9DFF
#define CALENDAR_BLUE_DARK      0x17334C
#define CALENDAR_AMBER          0xF4BE4F
#define CALENDAR_AMBER_DARK     0x493915
#define CALENDAR_RED            0xFF625F
#define CALENDAR_FIRST_YEAR     2000U
#define CALENDAR_LAST_YEAR      2099U
#define CALENDAR_CELL_COUNT     42U
#define CALENDAR_REFRESH_MS     30000U

typedef struct
{
    lv_obj_t *button;
    lv_obj_t *label;
    uint8_t day;
} calendar_cell_t;

typedef enum
{
    CALENDAR_UI_MONTH,
    CALENDAR_UI_DETAIL,
} calendar_ui_state_t;

extern RTC_HandleTypeDef RTC_Handler;

lv_obj_t *ui_Calendar = NULL;

static lv_obj_t *calendar_panel;
static lv_obj_t *calendar_month_label;
static calendar_cell_t calendar_cells[CALENDAR_CELL_COUNT];
static lv_timer_t *calendar_timer;
static uint16_t calendar_view_year;
static uint8_t calendar_view_month;
static uint16_t calendar_today_year;
static uint8_t calendar_today_month;
static uint8_t calendar_today_day;
static uint8_t calendar_selected_day;
static uint8_t calendar_date_valid;
static uint8_t calendar_build_queued;
static calendar_ui_state_t calendar_ui_state = CALENDAR_UI_MONTH;

static void calendar_ui_build(void);
static void calendar_ui_back_event(lv_event_t *event);

static void calendar_ui_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void calendar_ui_async_build(void *user_data)
{
    (void)user_data;
    calendar_build_queued = 0U;
    if (ui_Calendar != NULL)
        calendar_ui_build();
}

static void calendar_ui_queue_build(void)
{
    if (calendar_build_queued)
        return;
    calendar_build_queued = 1U;
    if (lv_async_call(calendar_ui_async_build, NULL) != LV_RES_OK)
        calendar_build_queued = 0U;
}

static void calendar_ui_style_object(lv_obj_t *object, uint32_t color,
                                     lv_opa_t opacity, lv_coord_t radius)
{
    lv_obj_clear_flag(object, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(object, radius,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
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
    lv_obj_set_style_pad_all(object, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *calendar_ui_add_label(lv_obj_t *parent, const char *text,
                                       const lv_font_t *font,
                                       uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    return label;
}

static lv_obj_t *calendar_ui_add_button(lv_obj_t *parent, lv_coord_t x,
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
    calendar_ui_style_object(button, color, LV_OPA_COVER, height / 2);
    lv_obj_set_style_bg_color(button, lv_color_hex(CALENDAR_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    label = calendar_ui_add_label(button, text, font, text_color);
    lv_obj_center(label);
    if (callback != NULL)
        lv_obj_add_event_cb(button, callback, LV_EVENT_CLICKED, NULL);
    return button;
}

static uint8_t calendar_ui_is_leap_year(uint16_t year)
{
    return (uint8_t)(((year % 4U) == 0U && (year % 100U) != 0U) ||
                     (year % 400U) == 0U);
}

static uint8_t calendar_ui_days_in_month(uint16_t year, uint8_t month)
{
    static const uint8_t days[] =
        {31U, 28U, 31U, 30U, 31U, 30U,
         31U, 31U, 30U, 31U, 30U, 31U};

    if (month < 1U || month > 12U)
        return 30U;
    if (month == 2U && calendar_ui_is_leap_year(year))
        return 29U;
    return days[month - 1U];
}

/* Returns 0 for Sunday through 6 for Saturday. */
static uint8_t calendar_ui_weekday(uint16_t year, uint8_t month, uint8_t day)
{
    static const uint8_t offsets[] =
        {0U, 3U, 2U, 5U, 0U, 3U, 5U, 1U, 4U, 6U, 2U, 4U};
    uint32_t adjusted_year = year;

    if (month < 3U)
        adjusted_year--;
    return (uint8_t)((adjusted_year + adjusted_year / 4U -
                      adjusted_year / 100U + adjusted_year / 400U +
                      offsets[month - 1U] + day) % 7U);
}

static uint8_t calendar_ui_read_today(uint8_t update_view)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint8_t retries = 3U;
    uint16_t year;

    if (HAL_RTC_GetTime(&RTC_Handler, &time, RTC_FORMAT_BIN) != HAL_OK)
        return 0U;
    while (HAL_RTC_GetDate(&RTC_Handler, &date, RTC_FORMAT_BIN) != HAL_OK)
    {
        if (--retries == 0U)
            return 0U;
        if (HAL_RTC_GetTime(&RTC_Handler, &time, RTC_FORMAT_BIN) != HAL_OK)
            return 0U;
    }

    year = (uint16_t)(2000U + date.Year);
    if (year < CALENDAR_FIRST_YEAR || year > CALENDAR_LAST_YEAR ||
        date.Month < 1U || date.Month > 12U || date.Date < 1U ||
        date.Date > calendar_ui_days_in_month(year, date.Month))
        return 0U;

    calendar_today_year = year;
    calendar_today_month = date.Month;
    calendar_today_day = date.Date;
    calendar_date_valid = 1U;
    if (update_view)
    {
        calendar_view_year = year;
        calendar_view_month = date.Month;
        calendar_selected_day = date.Date;
    }
    return 1U;
}

static void calendar_ui_style_cell(calendar_cell_t *cell)
{
    uint8_t is_today;
    uint8_t is_selected;
    uint32_t background = CALENDAR_PANEL;
    uint32_t text_color = CALENDAR_TEXT;
    lv_opa_t opacity = LV_OPA_TRANSP;

    is_today = calendar_date_valid &&
               calendar_view_year == calendar_today_year &&
               calendar_view_month == calendar_today_month &&
               cell->day == calendar_today_day;
    is_selected = calendar_selected_day != 0U &&
                  cell->day == calendar_selected_day;

    if (is_today)
    {
        background = CALENDAR_BLUE;
        text_color = CALENDAR_TEXT;
        opacity = LV_OPA_COVER;
    }
    else if (is_selected)
    {
        background = CALENDAR_AMBER_DARK;
        text_color = CALENDAR_AMBER;
        opacity = LV_OPA_COVER;
    }

    lv_obj_set_style_bg_color(cell->button, lv_color_hex(background),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(cell->button, opacity,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(cell->label, lv_color_hex(text_color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void calendar_ui_render(void)
{
    uint8_t first_column;
    uint8_t days;
    uint8_t index;
    char text[16];

    if (calendar_month_label == NULL)
        return;

    (void)snprintf(text, sizeof(text), "%04u / %02u",
                   (unsigned int)calendar_view_year,
                   (unsigned int)calendar_view_month);
    lv_label_set_text(calendar_month_label, text);
    lv_obj_align(calendar_month_label, LV_ALIGN_TOP_MID, 0, 85);

    first_column = (uint8_t)((calendar_ui_weekday(calendar_view_year,
                                                   calendar_view_month,
                                                   1U) + 6U) % 7U);
    days = calendar_ui_days_in_month(calendar_view_year,
                                     calendar_view_month);
    for (index = 0U; index < CALENDAR_CELL_COUNT; index++)
    {
        calendar_cell_t *cell = &calendar_cells[index];
        int16_t day = (int16_t)index - first_column + 1;

        if (day < 1 || day > days)
        {
            cell->day = 0U;
            lv_obj_add_flag(cell->button, LV_OBJ_FLAG_HIDDEN);
            continue;
        }

        cell->day = (uint8_t)day;
        (void)snprintf(text, sizeof(text), "%u", (unsigned int)cell->day);
        lv_label_set_text(cell->label, text);
        lv_obj_clear_flag(cell->button, LV_OBJ_FLAG_HIDDEN);
        calendar_ui_style_cell(cell);
    }
}

static uint16_t calendar_ui_day_of_year(uint16_t year, uint8_t month,
                                        uint8_t day)
{
    uint16_t total = day;
    uint8_t current_month;

    for (current_month = 1U; current_month < month; current_month++)
        total += calendar_ui_days_in_month(year, current_month);
    return total;
}

static uint8_t calendar_ui_iso_weeks_in_year(uint16_t year)
{
    uint8_t january_first = calendar_ui_weekday(year, 1U, 1U);

    if (january_first == 4U ||
        (january_first == 3U && calendar_ui_is_leap_year(year)))
        return 53U;
    return 52U;
}

static uint8_t calendar_ui_week_number(uint16_t year, uint8_t month,
                                       uint8_t day)
{
    uint16_t day_of_year = calendar_ui_day_of_year(year, month, day);
    uint8_t weekday = calendar_ui_weekday(year, month, day);
    uint8_t monday_weekday = weekday == 0U ? 7U : weekday;
    int16_t week = (int16_t)(((int16_t)day_of_year -
                              (int16_t)monday_weekday + 10) / 7);

    if (week < 1)
        return calendar_ui_iso_weeks_in_year((uint16_t)(year - 1U));
    if (week > calendar_ui_iso_weeks_in_year(year))
        return 1U;
    return (uint8_t)week;
}

static void calendar_ui_shift_selected_day(int8_t direction)
{
    uint8_t days = calendar_ui_days_in_month(calendar_view_year,
                                              calendar_view_month);

    if (direction > 0)
    {
        if (calendar_selected_day < days)
            calendar_selected_day++;
        else if (calendar_view_month < 12U)
        {
            calendar_view_month++;
            calendar_selected_day = 1U;
        }
        else if (calendar_view_year < CALENDAR_LAST_YEAR)
        {
            calendar_view_year++;
            calendar_view_month = 1U;
            calendar_selected_day = 1U;
        }
    }
    else if (calendar_selected_day > 1U)
        calendar_selected_day--;
    else if (calendar_view_month > 1U)
    {
        calendar_view_month--;
        calendar_selected_day = calendar_ui_days_in_month(
            calendar_view_year, calendar_view_month);
    }
    else if (calendar_view_year > CALENDAR_FIRST_YEAR)
    {
        calendar_view_year--;
        calendar_view_month = 12U;
        calendar_selected_day = 31U;
    }
    calendar_ui_queue_build();
}

static void calendar_ui_detail_nav_event(lv_event_t *event)
{
    uint8_t next;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    next = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    calendar_ui_shift_selected_day(next ? 1 : -1);
}

static void calendar_ui_gesture_event(lv_event_t *event)
{
    lv_indev_t *indev;
    lv_dir_t direction;

    if (lv_event_get_code(event) != LV_EVENT_GESTURE ||
        calendar_ui_state != CALENDAR_UI_DETAIL)
        return;
    indev = lv_indev_get_act();
    if (indev == NULL)
        return;
    direction = lv_indev_get_gesture_dir(indev);
    if (direction == LV_DIR_TOP)
        calendar_ui_shift_selected_day(1);
    else if (direction == LV_DIR_BOTTOM)
        calendar_ui_shift_selected_day(-1);
}

static void calendar_ui_build_detail(void)
{
    static const char *weekdays[] =
        {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
    calendar_lunar_date_t lunar;
    lv_obj_t *label;
    lv_obj_t *festival_card;
    uint8_t lunar_valid;
    uint8_t weekday;
    uint8_t week;
    uint8_t is_today;
    char year_text[40];
    char lunar_text[48];
    char solar_text[24];
    char week_text[48];
    char festival_text[64];

    lunar_valid = calendar_lunar_from_solar(calendar_view_year,
                                             calendar_view_month,
                                             calendar_selected_day, &lunar);
    if (lunar_valid)
    {
        calendar_lunar_format_year(&lunar, year_text, sizeof(year_text));
        calendar_lunar_format_date(&lunar, lunar_text, sizeof(lunar_text));
        calendar_lunar_format_festival(calendar_view_year,
                                       calendar_view_month,
                                       calendar_selected_day, &lunar,
                                       festival_text, sizeof(festival_text));
    }
    else
    {
        (void)snprintf(year_text, sizeof(year_text), "农历日期");
        (void)snprintf(lunar_text, sizeof(lunar_text), "暂不可用");
        festival_text[0] = '\0';
    }

    weekday = calendar_ui_weekday(calendar_view_year,
                                   calendar_view_month,
                                   calendar_selected_day);
    week = calendar_ui_week_number(calendar_view_year,
                                   calendar_view_month,
                                   calendar_selected_day);
    is_today = calendar_date_valid &&
               calendar_view_year == calendar_today_year &&
               calendar_view_month == calendar_today_month &&
               calendar_selected_day == calendar_today_day;
    (void)snprintf(solar_text, sizeof(solar_text), "%02u / %02u",
                   (unsigned int)calendar_view_month,
                   (unsigned int)calendar_selected_day);
    (void)snprintf(week_text, sizeof(week_text), "第%u周  %s",
                   (unsigned int)week, weekdays[weekday]);

    lv_obj_clean(ui_Calendar);
    calendar_month_label = NULL;
    memset(calendar_cells, 0, sizeof(calendar_cells));
    calendar_panel = lv_obj_create(ui_Calendar);
    lv_obj_set_size(calendar_panel, 390, 450);
    lv_obj_center(calendar_panel);
    calendar_ui_style_object(calendar_panel, CALENDAR_PANEL,
                             LV_OPA_COVER, 45);
    lv_obj_set_style_clip_corner(calendar_panel, true, LV_PART_MAIN);

    calendar_ui_add_button(calendar_panel, 20, 12, 52, 52,
                           LV_SYMBOL_LEFT, CALENDAR_CARD, CALENDAR_TEXT,
                           &lv_font_montserrat_20, calendar_ui_back_event);
    label = calendar_ui_add_label(calendar_panel, "日期详情",
                                  &hsp_font_cjk_22, CALENDAR_TEXT);
    lv_obj_set_pos(label, 84, 26);

    {
        lv_obj_t *previous = calendar_ui_add_button(
            calendar_panel, 163, 68, 64, 48, LV_SYMBOL_UP,
            CALENDAR_CARD, CALENDAR_MUTED, &lv_font_montserrat_20, NULL);
        lv_obj_add_event_cb(previous, calendar_ui_detail_nav_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)0U);
    }

    label = calendar_ui_add_label(calendar_panel, year_text,
                                  &hsp_font_cjk_22, CALENDAR_MUTED);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 123);
    label = calendar_ui_add_label(calendar_panel, lunar_text,
                                  &hsp_font_cjk_22, CALENDAR_TEXT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 158);
    label = calendar_ui_add_label(calendar_panel,
                                  is_today ? "今天" : "",
                                  &hsp_font_cjk_22, CALENDAR_BLUE);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 193);
    label = calendar_ui_add_label(calendar_panel, solar_text,
                                  &lv_font_montserrat_48, CALENDAR_BLUE);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 218);
    label = calendar_ui_add_label(calendar_panel, week_text,
                                  &hsp_font_cjk_22, CALENDAR_TEXT);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 275);

    festival_card = lv_obj_create(calendar_panel);
    lv_obj_set_pos(festival_card, 76, 316);
    lv_obj_set_size(festival_card, 238, 58);
    calendar_ui_style_object(festival_card,
                             festival_text[0] != '\0' ?
                             CALENDAR_AMBER_DARK : CALENDAR_CARD,
                             LV_OPA_COVER, 29);
    label = calendar_ui_add_label(festival_card,
                                  festival_text[0] != '\0' ?
                                  festival_text : "今日无节日",
                                  &hsp_font_cjk_22,
                                  festival_text[0] != '\0' ?
                                  CALENDAR_AMBER : CALENDAR_MUTED);
    lv_obj_center(label);

    {
        lv_obj_t *next = calendar_ui_add_button(
            calendar_panel, 163, 386, 64, 48, LV_SYMBOL_DOWN,
            CALENDAR_CARD, CALENDAR_MUTED, &lv_font_montserrat_20, NULL);
        lv_obj_add_event_cb(next, calendar_ui_detail_nav_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)1U);
    }
}

static void calendar_ui_day_event(lv_event_t *event)
{
    uintptr_t index;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    index = (uintptr_t)lv_event_get_user_data(event);
    if (index >= CALENDAR_CELL_COUNT || calendar_cells[index].day == 0U)
        return;
    calendar_selected_day = calendar_cells[index].day;
    calendar_ui_state = CALENDAR_UI_DETAIL;
    calendar_ui_queue_build();
}

static void calendar_ui_month_event(lv_event_t *event)
{
    uint8_t next;

    if (lv_event_get_code(event) != LV_EVENT_CLICKED)
        return;
    next = (uint8_t)(uintptr_t)lv_event_get_user_data(event);
    if (next)
    {
        if (calendar_view_month < 12U)
            calendar_view_month++;
        else if (calendar_view_year < CALENDAR_LAST_YEAR)
        {
            calendar_view_year++;
            calendar_view_month = 1U;
        }
    }
    else if (calendar_view_month > 1U)
        calendar_view_month--;
    else if (calendar_view_year > CALENDAR_FIRST_YEAR)
    {
        calendar_view_year--;
        calendar_view_month = 12U;
    }
    calendar_selected_day = 0U;
    calendar_ui_render();
}

static void calendar_ui_today_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED &&
        calendar_ui_read_today(1U))
        calendar_ui_render();
}

static void calendar_ui_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_Calendar_return();
}

static void calendar_ui_build(void)
{
    static const char *weekdays[] = {"一", "二", "三", "四", "五", "六", "日"};
    uint8_t index;

    if (ui_Calendar == NULL)
        return;
    if (calendar_ui_state == CALENDAR_UI_DETAIL)
    {
        calendar_ui_build_detail();
        return;
    }

    lv_obj_clean(ui_Calendar);
    calendar_panel = lv_obj_create(ui_Calendar);
    lv_obj_set_size(calendar_panel, 390, 450);
    lv_obj_center(calendar_panel);
    calendar_ui_style_object(calendar_panel, CALENDAR_PANEL,
                             LV_OPA_COVER, 45);
    lv_obj_set_style_clip_corner(calendar_panel, true, LV_PART_MAIN);

    calendar_ui_add_button(calendar_panel, 20, 12, 52, 52,
                           LV_SYMBOL_LEFT, CALENDAR_CARD, CALENDAR_TEXT,
                           &lv_font_montserrat_20, calendar_ui_back_event);
    {
        lv_obj_t *title = calendar_ui_add_label(calendar_panel, "日历",
                                                &hsp_font_cjk_22,
                                                CALENDAR_TEXT);
        lv_obj_set_pos(title, 84, 26);
    }
    calendar_ui_add_button(calendar_panel, 286, 12, 84, 52,
                           "今天", CALENDAR_BLUE_DARK, CALENDAR_BLUE,
                           &hsp_font_cjk_22, calendar_ui_today_event);

    {
        lv_obj_t *previous = calendar_ui_add_button(
            calendar_panel, 22, 76, 58, 58, LV_SYMBOL_LEFT,
            CALENDAR_CARD, CALENDAR_TEXT, &lv_font_montserrat_20, NULL);
        lv_obj_t *next = calendar_ui_add_button(
            calendar_panel, 310, 76, 58, 58, LV_SYMBOL_RIGHT,
            CALENDAR_CARD, CALENDAR_TEXT, &lv_font_montserrat_20, NULL);

        lv_obj_add_event_cb(previous, calendar_ui_month_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)0U);
        lv_obj_add_event_cb(next, calendar_ui_month_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)1U);
    }
    calendar_month_label = calendar_ui_add_label(calendar_panel, "",
                                                  &lv_font_montserrat_30,
                                                  CALENDAR_TEXT);

    for (index = 0U; index < 7U; index++)
    {
        lv_obj_t *label = calendar_ui_add_label(
            calendar_panel, weekdays[index], &hsp_font_cjk_22,
            index >= 5U ? CALENDAR_RED : CALENDAR_MUTED);
        lv_obj_set_width(label, 44);
        lv_obj_set_style_text_align(label, LV_TEXT_ALIGN_CENTER,
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_pos(label, (lv_coord_t)(21 + index * 50U), 143);
    }

    for (index = 0U; index < CALENDAR_CELL_COUNT; index++)
    {
        lv_coord_t column = (lv_coord_t)(index % 7U);
        lv_coord_t row = (lv_coord_t)(index / 7U);
        lv_obj_t *button = calendar_ui_add_button(
            calendar_panel, (lv_coord_t)(21 + column * 50),
            (lv_coord_t)(174 + row * 42), 44, 38, "",
            CALENDAR_PANEL, CALENDAR_TEXT, &lv_font_montserrat_20, NULL);

        calendar_cells[index].button = button;
        calendar_cells[index].label = lv_obj_get_child(button, 0);
        calendar_cells[index].day = 0U;
        lv_obj_add_event_cb(button, calendar_ui_day_event,
                            LV_EVENT_CLICKED, (void *)(uintptr_t)index);
    }
    calendar_ui_render();
}

static void calendar_ui_timer_cb(lv_timer_t *timer)
{
    uint16_t previous_year = calendar_today_year;
    uint8_t previous_month = calendar_today_month;
    uint8_t previous_day = calendar_today_day;

    (void)timer;
    if (!calendar_ui_read_today(0U) || ui_Calendar == NULL ||
        lv_scr_act() != ui_Calendar)
        return;
    if ((previous_year != calendar_today_year ||
         previous_month != calendar_today_month ||
         previous_day != calendar_today_day) &&
        calendar_ui_state == CALENDAR_UI_MONTH)
        calendar_ui_render();
}

void ui_Calendar_init(void)
{
    if (calendar_timer == NULL)
        calendar_timer = lv_timer_create(calendar_ui_timer_cb,
                                         CALENDAR_REFRESH_MS, NULL);
}

void ui_Calendar_screen_init(void)
{
    if (ui_Calendar != NULL)
        return;

    calendar_ui_state = CALENDAR_UI_MONTH;
    if (!calendar_ui_read_today(1U))
    {
        calendar_view_year = CALENDAR_FIRST_YEAR;
        calendar_view_month = 1U;
        calendar_selected_day = 1U;
    }
    ui_Calendar = lv_obj_create(NULL);
    lv_obj_add_event_cb(ui_Calendar, calendar_ui_gesture_event,
                        LV_EVENT_GESTURE, NULL);
    lv_obj_clear_flag(ui_Calendar, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Calendar, lv_color_hex(CALENDAR_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_Calendar, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    calendar_ui_build();
}

void ui_Calendar_screen_destroy(void)
{
    if (ui_Calendar != NULL)
        lv_obj_del(ui_Calendar);
    ui_Calendar = NULL;
    calendar_panel = NULL;
    calendar_month_label = NULL;
    memset(calendar_cells, 0, sizeof(calendar_cells));
}

void ui_Calendar_open_from_app_grid(void)
{
    calendar_ui_wait_release();
    calendar_ui_state = CALENDAR_UI_MONTH;
    (void)calendar_ui_read_today(1U);
    if (ui_Calendar == NULL)
        ui_Calendar_screen_init();
    else
        calendar_ui_build();
    lv_scr_load_anim(ui_Calendar, LV_SCR_LOAD_ANIM_MOVE_LEFT,
                     180, 0, false);
}

void ui_Calendar_return(void)
{
    calendar_ui_wait_release();
    if (calendar_ui_state == CALENDAR_UI_DETAIL)
    {
        calendar_ui_state = CALENDAR_UI_MONTH;
        calendar_ui_queue_build();
        return;
    }
    ui_AppGrid_open();
}

uint8_t ui_Calendar_handle_key(input_wake_key_t key,
                               input_wake_event_t event)
{
    if (ui_Calendar == NULL || lv_scr_act() != ui_Calendar)
        return 0U;
    if (event == INPUT_WAKE_EVENT_SHORT_PRESS && key == INPUT_WAKE_KEY1)
    {
        ui_Calendar_return();
        return 1U;
    }
    return 0U;
}
