#include "ui_MapDetails.h"

#include "rtthread.h"
#include "services/phone_sync.h"
#include "ui/generated/screens/ui_BluetoothSettings.h"
#include "ui/generated/ui_helpers.h"

#define MAP_BG              0x050608
#define MAP_BORDER          0x293340
#define MAP_CARD            0x151A21
#define MAP_CARD_BORDER     0x303A47
#define MAP_CARD_PRESSED    0x232A35
#define MAP_TEXT            0xF5F7FA
#define MAP_SECONDARY       0xA0AAB9
#define MAP_MUTED           0x778291
#define MAP_ROAD            0x3A4654
#define MAP_MINOR_ROAD      0x26313D
#define MAP_ROUTE           0x3B9BFF
#define MAP_ROUTE_SOFT      0x183A5B
#define MAP_LOCATION        0x65CE8C

lv_obj_t *ui_MapDetails = NULL;

static lv_obj_t *map_city_label;
static lv_obj_t *map_status_label;
static lv_obj_t *map_latitude_value;
static lv_obj_t *map_longitude_value;
static lv_obj_t *map_accuracy_value;
static lv_obj_t *map_marker_outer;
static lv_obj_t *map_marker_middle;
static lv_obj_t *map_marker_inner;
static lv_timer_t *map_refresh_timer;

static void map_details_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void map_details_stop_timer(void)
{
    if (map_refresh_timer != NULL)
    {
        lv_timer_del(map_refresh_timer);
        map_refresh_timer = NULL;
    }
}

static lv_obj_t *map_details_add_shape(lv_obj_t *parent, lv_coord_t x,
                                       lv_coord_t y, lv_coord_t width,
                                       lv_coord_t height, uint32_t color,
                                       lv_coord_t radius)
{
    lv_obj_t *shape = lv_obj_create(parent);

    lv_obj_set_size(shape, width, height);
    lv_obj_set_pos(shape, x, y);
    lv_obj_clear_flag(shape, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(shape, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_radius(shape, radius, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(shape, lv_color_hex(color),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(shape, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(shape, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(shape, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(shape, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_outline_width(shape, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    return shape;
}

static lv_obj_t *map_details_add_label(lv_obj_t *parent, const char *text,
                                       const lv_font_t *font, uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_flag(label, LV_OBJ_FLAG_GESTURE_BUBBLE);
    return label;
}

static void map_details_style_card(lv_obj_t *card)
{
    lv_obj_set_style_bg_color(card, lv_color_hex(MAP_CARD),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(card, lv_color_hex(MAP_CARD_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(card, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(card, 8, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(card, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(card, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void map_details_format_coordinate(char *buffer, size_t size,
                                          int32_t value_e7)
{
    uint32_t magnitude = value_e7 < 0 ?
                         (uint32_t)(-(int64_t)value_e7) : (uint32_t)value_e7;

    rt_snprintf(buffer, size, "%s%lu.%07lu", value_e7 < 0 ? "-" : "",
                (unsigned long)(magnitude / 10000000UL),
                (unsigned long)(magnitude % 10000000UL));
}

void ui_MapDetails_refresh(void)
{
    phone_location_t location;
    char latitude[20];
    char longitude[20];

    if (ui_MapDetails == NULL)
        return;

    phone_sync_get_location(&location);
    lv_label_set_text(map_city_label,
                      location.city_valid ? location.city : "CITY UNAVAILABLE");

    if (!location.valid)
    {
        lv_label_set_text(map_status_label, "WAITING FOR PHONE LOCATION");
        lv_label_set_text(map_latitude_value, "--.-------");
        lv_label_set_text(map_longitude_value, "--.-------");
        lv_label_set_text(map_accuracy_value, "ACCURACY UNAVAILABLE");
        lv_obj_set_style_border_color(map_marker_outer, lv_color_hex(MAP_MUTED),
                                      LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_bg_color(map_marker_middle, lv_color_hex(0x28323E),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_bg_color(map_marker_inner, lv_color_hex(MAP_MUTED),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
        return;
    }

    map_details_format_coordinate(latitude, sizeof(latitude), location.latitude_e7);
    map_details_format_coordinate(longitude, sizeof(longitude), location.longitude_e7);
    lv_label_set_text(map_status_label, "SYNCED FROM PHONE");
    lv_label_set_text(map_latitude_value, latitude);
    lv_label_set_text(map_longitude_value, longitude);
    lv_label_set_text_fmt(map_accuracy_value, "ACCURACY +/- %u M",
                          (unsigned int)location.accuracy_meters);
    lv_obj_set_style_border_color(map_marker_outer, lv_color_hex(MAP_ROUTE),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(map_marker_middle, lv_color_hex(MAP_ROUTE_SOFT),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(map_marker_inner, lv_color_hex(MAP_LOCATION),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
}

static void map_details_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    ui_MapDetails_refresh();
}

static void map_details_return(void)
{
    map_details_stop_timer();
    map_details_wait_release();
    ui_BluetoothSettings_open_from_details();
}

static void map_details_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        map_details_return();
}

static void map_details_screen_event(lv_event_t *event)
{
    lv_indev_t *indev;

    if (lv_event_get_code(event) != LV_EVENT_GESTURE)
        return;

    indev = lv_indev_get_act();
    if (indev != NULL && lv_indev_get_gesture_dir(indev) == LV_DIR_RIGHT)
        map_details_return();
}

static void map_details_add_coordinate_row(lv_obj_t *parent, lv_coord_t y,
                                           const char *title,
                                           lv_obj_t **value_out)
{
    lv_obj_t *title_label = map_details_add_label(parent, title,
                                                  &lv_font_montserrat_12,
                                                  MAP_MUTED);
    lv_obj_t *value_label = map_details_add_label(parent, "--.-------",
                                                  &lv_font_montserrat_18,
                                                  MAP_TEXT);

    lv_obj_set_pos(title_label, 16, y);
    lv_obj_set_width(value_label, 235);
    lv_obj_set_pos(value_label, 103, y - 4);
    lv_obj_set_style_text_align(value_label, LV_TEXT_ALIGN_RIGHT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    *value_out = value_label;
}

static void map_details_build_visual(lv_obj_t *parent)
{
    lv_obj_t *visual = lv_obj_create(parent);
    lv_coord_t verticals[4] = {46, 118, 206, 286};
    lv_coord_t horizontals[3] = {31, 65, 101};
    uint8_t index;

    lv_obj_set_size(visual, 330, 128);
    lv_obj_set_pos(visual, 30, 127);
    lv_obj_clear_flag(visual, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(visual, LV_OBJ_FLAG_GESTURE_BUBBLE);
    map_details_style_card(visual);
    lv_obj_set_style_clip_corner(visual, true, LV_PART_MAIN | LV_STATE_DEFAULT);

    for (index = 0U; index < 4U; index++)
        map_details_add_shape(visual, verticals[index], 0, 2, 128,
                              MAP_MINOR_ROAD, 0);
    for (index = 0U; index < 3U; index++)
        map_details_add_shape(visual, 0, horizontals[index], 330, 2,
                              MAP_MINOR_ROAD, 0);

    map_details_add_shape(visual, 0, 48, 138, 7, MAP_ROAD, LV_RADIUS_CIRCLE);
    map_details_add_shape(visual, 132, 48, 7, 80, MAP_ROAD, LV_RADIUS_CIRCLE);
    map_details_add_shape(visual, 132, 94, 198, 7, MAP_ROAD, LV_RADIUS_CIRCLE);
    map_details_add_shape(visual, 246, 0, 7, 100, MAP_ROAD, LV_RADIUS_CIRCLE);

    map_details_add_shape(visual, 15, 76, 118, 7, MAP_ROUTE, LV_RADIUS_CIRCLE);
    map_details_add_shape(visual, 126, 76, 7, 35, MAP_ROUTE, LV_RADIUS_CIRCLE);
    map_details_add_shape(visual, 126, 104, 82, 7, MAP_ROUTE, LV_RADIUS_CIRCLE);

    map_marker_outer = map_details_add_shape(visual, 183, 73, 52, 52,
                                             MAP_CARD, LV_RADIUS_CIRCLE);
    lv_obj_set_style_border_color(map_marker_outer, lv_color_hex(MAP_ROUTE),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(map_marker_outer, 3,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    map_marker_middle = map_details_add_shape(map_marker_outer, 8, 8, 30, 30,
                                              MAP_ROUTE_SOFT, LV_RADIUS_CIRCLE);
    map_marker_inner = map_details_add_shape(map_marker_middle, 8, 8, 10, 10,
                                             MAP_LOCATION, LV_RADIUS_CIRCLE);
}

void ui_MapDetails_screen_init(void)
{
    lv_obj_t *frame;
    lv_obj_t *header;
    lv_obj_t *back_button;
    lv_obj_t *back_icon;
    lv_obj_t *title;
    lv_obj_t *coordinates_card;
    lv_obj_t *divider;

    ui_MapDetails = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_MapDetails, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_MapDetails, lv_color_hex(0x000000),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_MapDetails, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    frame = lv_obj_create(ui_MapDetails);
    lv_obj_set_size(frame, 390, 450);
    lv_obj_align(frame, LV_ALIGN_CENTER, 0, 0);
    lv_obj_clear_flag(frame, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(frame, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_radius(frame, 45, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(frame, lv_color_hex(MAP_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(frame, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(frame, lv_color_hex(MAP_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(frame, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(frame, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_clip_corner(frame, true, LV_PART_MAIN | LV_STATE_DEFAULT);

    header = lv_obj_create(frame);
    lv_obj_set_size(header, 390, 68);
    lv_obj_set_pos(header, 0, 0);
    lv_obj_clear_flag(header, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(header, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_bg_opa(header, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(header, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(header, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    back_button = lv_btn_create(header);
    lv_obj_set_size(back_button, 50, 50);
    lv_obj_set_pos(back_button, 18, 9);
    lv_obj_clear_flag(back_button, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(back_button, LV_RADIUS_CIRCLE,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(back_button, lv_color_hex(MAP_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    back_icon = map_details_add_label(back_button, LV_SYMBOL_LEFT,
                                      &lv_font_montserrat_24, MAP_TEXT);
    lv_obj_center(back_icon);

    title = map_details_add_label(header, "MAP & LOCATION",
                                  &lv_font_montserrat_18, MAP_TEXT);
    lv_obj_set_pos(title, 82, 21);

    divider = map_details_add_shape(frame, 14, 68, 362, 1, MAP_BORDER, 0);
    (void)divider;

    map_city_label = map_details_add_label(frame, "CITY UNAVAILABLE",
                                           &lv_font_montserrat_20, MAP_TEXT);
    lv_obj_set_width(map_city_label, 340);
    lv_obj_set_pos(map_city_label, 25, 82);
    lv_obj_set_style_text_align(map_city_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_long_mode(map_city_label, LV_LABEL_LONG_DOT);

    map_status_label = map_details_add_label(frame, "WAITING FOR PHONE LOCATION",
                                             &lv_font_montserrat_12, MAP_MUTED);
    lv_obj_set_width(map_status_label, 354);
    lv_obj_set_pos(map_status_label, 18, 110);
    lv_obj_set_style_text_align(map_status_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    map_details_build_visual(frame);

    coordinates_card = lv_obj_create(frame);
    lv_obj_set_size(coordinates_card, 354, 108);
    lv_obj_set_pos(coordinates_card, 18, 271);
    lv_obj_clear_flag(coordinates_card, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(coordinates_card, LV_OBJ_FLAG_GESTURE_BUBBLE);
    map_details_style_card(coordinates_card);

    map_details_add_coordinate_row(coordinates_card, 20, "LATITUDE",
                                   &map_latitude_value);
    divider = map_details_add_shape(coordinates_card, 16, 53, 322, 1,
                                    MAP_CARD_BORDER, 0);
    (void)divider;
    map_details_add_coordinate_row(coordinates_card, 72, "LONGITUDE",
                                   &map_longitude_value);

    map_accuracy_value = map_details_add_label(frame, "ACCURACY UNAVAILABLE",
                                               &lv_font_montserrat_16,
                                               MAP_SECONDARY);
    lv_obj_set_width(map_accuracy_value, 354);
    lv_obj_set_pos(map_accuracy_value, 18, 397);
    lv_obj_set_style_text_align(map_accuracy_value, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(back_button, map_details_back_event,
                        LV_EVENT_CLICKED, NULL);
    lv_obj_add_event_cb(ui_MapDetails, map_details_screen_event,
                        LV_EVENT_GESTURE, NULL);

    ui_MapDetails_refresh();
}

void ui_MapDetails_open(void)
{
    map_details_wait_release();
    _ui_screen_change(&ui_MapDetails, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0,
                      &ui_MapDetails_screen_init);
    ui_MapDetails_refresh();
    if (map_refresh_timer == NULL)
        map_refresh_timer = lv_timer_create(map_details_timer_cb, 1000, NULL);
}

void ui_MapDetails_screen_destroy(void)
{
    map_details_stop_timer();
    if (ui_MapDetails != NULL)
        lv_obj_del(ui_MapDetails);

    ui_MapDetails = NULL;
    map_city_label = NULL;
    map_status_label = NULL;
    map_latitude_value = NULL;
    map_longitude_value = NULL;
    map_accuracy_value = NULL;
    map_marker_outer = NULL;
    map_marker_middle = NULL;
    map_marker_inner = NULL;
}
