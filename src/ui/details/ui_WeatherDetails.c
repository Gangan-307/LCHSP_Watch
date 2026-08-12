#include "ui_WeatherDetails.h"

#include "rtthread.h"
#include "services/phone_sync.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/ui_helpers.h"

#define WEATHER_BG              0x050608
#define WEATHER_BORDER          0x293340
#define WEATHER_CARD            0x151A21
#define WEATHER_CARD_BORDER     0x303A47
#define WEATHER_CARD_PRESSED    0x232A35
#define WEATHER_TEXT            0xF5F7FA
#define WEATHER_SECONDARY       0xA0AAB9
#define WEATHER_MUTED           0x778291
#define WEATHER_SUN             0xF4BE4F
#define WEATHER_CLOUD           0xC8D1DC
#define WEATHER_RAIN            0x3B9BFF
#define WEATHER_SNOW            0xB9E6FF
#define WEATHER_STORM           0xAE7BFF
#define WEATHER_HUMIDITY        0x52D4FF

typedef enum
{
    WEATHER_ICON_UNKNOWN,
    WEATHER_ICON_CLEAR,
    WEATHER_ICON_CLOUDY,
    WEATHER_ICON_FOG,
    WEATHER_ICON_RAIN,
    WEATHER_ICON_SNOW,
    WEATHER_ICON_STORM,
} weather_icon_kind_t;

lv_obj_t *ui_WeatherDetails = NULL;

static lv_obj_t *weather_city_label;
static lv_obj_t *weather_coordinates_label;
static lv_obj_t *weather_icon_canvas;
static lv_obj_t *weather_condition_label;
static lv_obj_t *weather_temperature_label;
static lv_obj_t *weather_humidity_value;
static lv_obj_t *weather_high_low_value;
static lv_timer_t *weather_refresh_timer;
static weather_icon_kind_t weather_drawn_icon = WEATHER_ICON_UNKNOWN;
static uint8_t weather_icon_initialized;

static void weather_details_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

static void weather_details_stop_timer(void)
{
    if (weather_refresh_timer != NULL)
    {
        lv_timer_del(weather_refresh_timer);
        weather_refresh_timer = NULL;
    }
}

static lv_obj_t *weather_details_add_shape(lv_obj_t *parent, lv_coord_t x,
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

static lv_obj_t *weather_details_add_label(lv_obj_t *parent, const char *text,
                                           const lv_font_t *font,
                                           uint32_t color)
{
    lv_obj_t *label = lv_label_create(parent);

    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, font, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(color),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_add_flag(label, LV_OBJ_FLAG_GESTURE_BUBBLE);
    return label;
}

static void weather_details_draw_sun(lv_obj_t *parent, lv_coord_t x,
                                     lv_coord_t y, uint8_t compact)
{
    lv_coord_t center_size = compact ? 38 : 54;
    lv_coord_t ray_offset = compact ? 7 : 4;
    lv_coord_t center_x = x + (compact ? 19 : 39);
    lv_coord_t center_y = y + (compact ? 19 : 29);
    lv_coord_t ray_length = compact ? 10 : 16;
    lv_coord_t ray_width = compact ? 4 : 5;

    weather_details_add_shape(parent, center_x, center_y, center_size, center_size,
                              WEATHER_SUN, LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, center_x + center_size / 2 - ray_width / 2,
                              center_y - ray_length - ray_offset, ray_width,
                              ray_length, WEATHER_SUN, LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, center_x + center_size / 2 - ray_width / 2,
                              center_y + center_size + ray_offset, ray_width,
                              ray_length, WEATHER_SUN, LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, center_x - ray_length - ray_offset,
                              center_y + center_size / 2 - ray_width / 2,
                              ray_length, ray_width, WEATHER_SUN, LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, center_x + center_size + ray_offset,
                              center_y + center_size / 2 - ray_width / 2,
                              ray_length, ray_width, WEATHER_SUN, LV_RADIUS_CIRCLE);
}

static void weather_details_draw_cloud(lv_obj_t *parent, lv_coord_t y,
                                       uint32_t color)
{
    weather_details_add_shape(parent, 37, y + 34, 108, 40, color,
                              LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, 49, y + 17, 52, 52, color,
                              LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, 86, y + 5, 66, 66, color,
                              LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, 126, y + 27, 38, 38, color,
                              LV_RADIUS_CIRCLE);
}

static void weather_details_draw_fog_lines(lv_obj_t *parent)
{
    weather_details_add_shape(parent, 43, 83, 96, 5, WEATHER_MUTED,
                              LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, 58, 96, 98, 5, WEATHER_MUTED,
                              LV_RADIUS_CIRCLE);
    weather_details_add_shape(parent, 37, 109, 86, 5, WEATHER_MUTED,
                              LV_RADIUS_CIRCLE);
}

static void weather_details_draw_precipitation(lv_obj_t *parent, uint32_t color,
                                               uint8_t snow)
{
    lv_coord_t positions[3] = {56, 89, 122};
    uint8_t index;

    for (index = 0U; index < 3U; index++)
    {
        if (snow)
        {
            lv_obj_t *flake = weather_details_add_label(parent, "*",
                                                        &lv_font_montserrat_24,
                                                        color);
            lv_obj_set_pos(flake, positions[index], 85 + (index % 2U) * 8);
        }
        else
        {
            weather_details_add_shape(parent, positions[index],
                                      88 + (index % 2U) * 8, 5, 21,
                                      color, LV_RADIUS_CIRCLE);
        }
    }
}

static void weather_details_draw_icon(weather_icon_kind_t kind)
{
    lv_obj_t *unknown;
    lv_obj_t *bolt;

    if (weather_icon_canvas == NULL ||
        (weather_icon_initialized && weather_drawn_icon == kind))
        return;

    lv_obj_clean(weather_icon_canvas);
    weather_icon_initialized = 1U;
    weather_drawn_icon = kind;

    switch (kind)
    {
    case WEATHER_ICON_CLEAR:
        weather_details_draw_sun(weather_icon_canvas, 29, 0, 0U);
        break;
    case WEATHER_ICON_CLOUDY:
        weather_details_draw_sun(weather_icon_canvas, 0, 0, 1U);
        weather_details_draw_cloud(weather_icon_canvas, 29, WEATHER_CLOUD);
        break;
    case WEATHER_ICON_FOG:
        weather_details_draw_cloud(weather_icon_canvas, 0, WEATHER_CLOUD);
        weather_details_draw_fog_lines(weather_icon_canvas);
        break;
    case WEATHER_ICON_RAIN:
        weather_details_draw_cloud(weather_icon_canvas, 0, WEATHER_CLOUD);
        weather_details_draw_precipitation(weather_icon_canvas, WEATHER_RAIN, 0U);
        break;
    case WEATHER_ICON_SNOW:
        weather_details_draw_cloud(weather_icon_canvas, 0, WEATHER_CLOUD);
        weather_details_draw_precipitation(weather_icon_canvas, WEATHER_SNOW, 1U);
        break;
    case WEATHER_ICON_STORM:
        weather_details_draw_cloud(weather_icon_canvas, 0, WEATHER_CLOUD);
        bolt = weather_details_add_label(weather_icon_canvas, LV_SYMBOL_CHARGE,
                                         &lv_font_montserrat_36, WEATHER_STORM);
        lv_obj_set_pos(bolt, 79, 72);
        break;
    default:
        unknown = weather_details_add_label(weather_icon_canvas, "?",
                                            &lv_font_montserrat_48,
                                            WEATHER_MUTED);
        lv_obj_center(unknown);
        break;
    }
}

static weather_icon_kind_t weather_details_icon_kind(uint8_t wmo_code)
{
    if (wmo_code == 0U)
        return WEATHER_ICON_CLEAR;
    if (wmo_code <= 3U)
        return WEATHER_ICON_CLOUDY;
    if (wmo_code == 45U || wmo_code == 48U)
        return WEATHER_ICON_FOG;
    if ((wmo_code >= 51U && wmo_code <= 67U) ||
        (wmo_code >= 80U && wmo_code <= 82U))
        return WEATHER_ICON_RAIN;
    if ((wmo_code >= 71U && wmo_code <= 77U) ||
        (wmo_code >= 85U && wmo_code <= 86U))
        return WEATHER_ICON_SNOW;
    if (wmo_code >= 95U && wmo_code <= 99U)
        return WEATHER_ICON_STORM;
    return WEATHER_ICON_UNKNOWN;
}

static const char *weather_details_condition(uint8_t wmo_code)
{
    if (wmo_code == 0U)
        return "CLEAR";
    if (wmo_code == 1U)
        return "MAINLY CLEAR";
    if (wmo_code == 2U)
        return "PARTLY CLOUDY";
    if (wmo_code == 3U)
        return "OVERCAST";
    if (wmo_code == 45U || wmo_code == 48U)
        return "FOG";
    if (wmo_code >= 51U && wmo_code <= 57U)
        return "DRIZZLE";
    if (wmo_code >= 61U && wmo_code <= 67U)
        return "RAIN";
    if (wmo_code >= 71U && wmo_code <= 77U)
        return "SNOW";
    if (wmo_code >= 80U && wmo_code <= 82U)
        return "RAIN SHOWERS";
    if (wmo_code >= 85U && wmo_code <= 86U)
        return "SNOW SHOWERS";
    if (wmo_code >= 95U && wmo_code <= 99U)
        return "THUNDERSTORM";
    return "WEATHER";
}

static void weather_details_format_coordinate(char *buffer, size_t size,
                                              int32_t value_e7)
{
    uint32_t magnitude = value_e7 < 0 ?
                         (uint32_t)(-(int64_t)value_e7) : (uint32_t)value_e7;

    rt_snprintf(buffer, size, "%s%lu.%07lu", value_e7 < 0 ? "-" : "",
                (unsigned long)(magnitude / 10000000UL),
                (unsigned long)(magnitude % 10000000UL));
}

static void weather_details_format_temperature(char *buffer, size_t size,
                                               int16_t deci_c)
{
    uint16_t magnitude = deci_c < 0 ?
                         (uint16_t)(-(int32_t)deci_c) : (uint16_t)deci_c;

    rt_snprintf(buffer, size, "%s%u.%u C", deci_c < 0 ? "-" : "",
                (unsigned int)(magnitude / 10U),
                (unsigned int)(magnitude % 10U));
}

void ui_WeatherDetails_refresh(void)
{
    phone_weather_t weather;
    phone_location_t location;
    char latitude[20];
    char longitude[20];
    char coordinates[48];
    char current[20];
    char high[20];
    char low[20];
    char high_low[48];

    if (ui_WeatherDetails == NULL)
        return;

    phone_sync_get_weather(&weather);
    phone_sync_get_location(&location);

    lv_label_set_text(weather_city_label,
                      location.city_valid ? location.city : "CITY UNAVAILABLE");
    if (location.valid)
    {
        weather_details_format_coordinate(latitude, sizeof(latitude),
                                          location.latitude_e7);
        weather_details_format_coordinate(longitude, sizeof(longitude),
                                          location.longitude_e7);
        rt_snprintf(coordinates, sizeof(coordinates), "%s, %s", latitude, longitude);
        lv_label_set_text(weather_coordinates_label, coordinates);
    }
    else
    {
        lv_label_set_text(weather_coordinates_label, "COORDINATES UNAVAILABLE");
    }

    if (!weather.valid)
    {
        weather_details_draw_icon(WEATHER_ICON_UNKNOWN);
        lv_label_set_text(weather_condition_label, "WAITING FOR WEATHER");
        lv_label_set_text(weather_temperature_label, "--.- C");
        lv_label_set_text(weather_humidity_value, "--%");
        lv_label_set_text(weather_high_low_value, "H --.- C  L --.- C");
        return;
    }

    weather_details_draw_icon(weather_details_icon_kind(weather.wmo_code));
    lv_label_set_text(weather_condition_label,
                      weather_details_condition(weather.wmo_code));
    weather_details_format_temperature(current, sizeof(current),
                                       weather.current_deci_c);
    weather_details_format_temperature(high, sizeof(high), weather.high_deci_c);
    weather_details_format_temperature(low, sizeof(low), weather.low_deci_c);
    rt_snprintf(high_low, sizeof(high_low), "H %s  L %s", high, low);
    lv_label_set_text(weather_temperature_label, current);
    lv_label_set_text_fmt(weather_humidity_value, "%u%%",
                          (unsigned int)weather.humidity_percent);
    lv_label_set_text(weather_high_low_value, high_low);
}

static void weather_details_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    ui_WeatherDetails_refresh();
}

void ui_WeatherDetails_return(void)
{
    weather_details_stop_timer();
    weather_details_wait_release();
    ui_AppGrid_open();
}

static void weather_details_back_event(lv_event_t *event)
{
    if (lv_event_get_code(event) == LV_EVENT_CLICKED)
        ui_WeatherDetails_return();
}

static void weather_details_screen_event(lv_event_t *event)
{
    lv_indev_t *indev;

    if (lv_event_get_code(event) != LV_EVENT_GESTURE)
        return;

    indev = lv_indev_get_act();
    if (indev != NULL && lv_indev_get_gesture_dir(indev) == LV_DIR_RIGHT)
        ui_WeatherDetails_return();
}

static lv_obj_t *weather_details_create_metric(lv_obj_t *parent, lv_coord_t x,
                                               lv_coord_t width,
                                               const char *title,
                                               lv_obj_t **value_out)
{
    lv_obj_t *card = weather_details_add_shape(parent, x, 352, width, 66,
                                               WEATHER_CARD, 8);
    lv_obj_t *title_label = weather_details_add_label(card, title,
                                                      &lv_font_montserrat_12,
                                                      WEATHER_MUTED);
    lv_obj_t *value_label = weather_details_add_label(card, "--",
                                                      &lv_font_montserrat_18,
                                                      WEATHER_TEXT);

    lv_obj_set_style_border_color(card, lv_color_hex(WEATHER_CARD_BORDER),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(card, 1, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_width(title_label, width - 20);
    lv_obj_set_pos(title_label, 10, 9);
    lv_obj_set_style_text_align(title_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_width(value_label, width - 16);
    lv_obj_set_pos(value_label, 8, 33);
    lv_obj_set_style_text_align(value_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    *value_out = value_label;
    return card;
}

void ui_WeatherDetails_screen_init(void)
{
    lv_obj_t *frame;
    lv_obj_t *header;
    lv_obj_t *back_button;
    lv_obj_t *back_icon;
    lv_obj_t *title;
    lv_obj_t *divider;

    ui_WeatherDetails = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_WeatherDetails, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_WeatherDetails, lv_color_hex(0x000000),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_WeatherDetails, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    frame = lv_obj_create(ui_WeatherDetails);
    lv_obj_set_size(frame, 390, 450);
    lv_obj_align(frame, LV_ALIGN_CENTER, 0, 0);
    lv_obj_clear_flag(frame, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(frame, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_radius(frame, 45, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(frame, lv_color_hex(WEATHER_BG),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(frame, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(frame, lv_color_hex(WEATHER_BORDER),
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
    lv_obj_set_style_bg_color(back_button, lv_color_hex(WEATHER_CARD_PRESSED),
                              LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_bg_opa(back_button, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_shadow_width(back_button, 0, LV_PART_MAIN | LV_STATE_DEFAULT);

    back_icon = weather_details_add_label(back_button, LV_SYMBOL_LEFT,
                                          &lv_font_montserrat_24, WEATHER_TEXT);
    lv_obj_center(back_icon);

    title = weather_details_add_label(header, "WEATHER", &lv_font_montserrat_18,
                                      WEATHER_TEXT);
    lv_obj_set_pos(title, 82, 21);

    divider = weather_details_add_shape(frame, 14, 68, 362, 1,
                                        WEATHER_BORDER, 0);
    (void)divider;

    weather_city_label = weather_details_add_label(frame, "CITY UNAVAILABLE",
                                                    &lv_font_montserrat_18,
                                                    WEATHER_TEXT);
    lv_obj_set_width(weather_city_label, 340);
    lv_obj_set_pos(weather_city_label, 25, 82);
    lv_obj_set_style_text_align(weather_city_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_long_mode(weather_city_label, LV_LABEL_LONG_DOT);

    weather_coordinates_label = weather_details_add_label(frame,
                                                           "COORDINATES UNAVAILABLE",
                                                           &lv_font_montserrat_12,
                                                           WEATHER_MUTED);
    lv_obj_set_width(weather_coordinates_label, 354);
    lv_obj_set_pos(weather_coordinates_label, 18, 110);
    lv_obj_set_style_text_align(weather_coordinates_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    weather_icon_canvas = lv_obj_create(frame);
    lv_obj_set_size(weather_icon_canvas, 190, 118);
    lv_obj_set_pos(weather_icon_canvas, 100, 128);
    lv_obj_clear_flag(weather_icon_canvas, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(weather_icon_canvas, LV_OBJ_FLAG_GESTURE_BUBBLE);
    lv_obj_set_style_bg_opa(weather_icon_canvas, LV_OPA_TRANSP,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(weather_icon_canvas, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(weather_icon_canvas, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    weather_condition_label = weather_details_add_label(frame,
                                                         "WAITING FOR WEATHER",
                                                         &lv_font_montserrat_16,
                                                         WEATHER_SECONDARY);
    lv_obj_set_width(weather_condition_label, 354);
    lv_obj_set_pos(weather_condition_label, 18, 250);
    lv_obj_set_style_text_align(weather_condition_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    weather_temperature_label = weather_details_add_label(frame, "--.- C",
                                                           &lv_font_montserrat_36,
                                                           WEATHER_TEXT);
    lv_obj_set_width(weather_temperature_label, 354);
    lv_obj_set_pos(weather_temperature_label, 18, 282);
    lv_obj_set_style_text_align(weather_temperature_label, LV_TEXT_ALIGN_CENTER,
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    weather_details_create_metric(frame, 42, 100, "HUMIDITY",
                                  &weather_humidity_value);
    weather_details_create_metric(frame, 149, 199, "TODAY",
                                  &weather_high_low_value);
    lv_obj_set_style_text_color(weather_humidity_value,
                                lv_color_hex(WEATHER_HUMIDITY),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(weather_high_low_value, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    lv_obj_add_event_cb(back_button, weather_details_back_event,
                        LV_EVENT_CLICKED, NULL);
    lv_obj_add_event_cb(ui_WeatherDetails, weather_details_screen_event,
                        LV_EVENT_GESTURE, NULL);

    weather_icon_initialized = 0U;
    ui_WeatherDetails_refresh();
}

void ui_WeatherDetails_open(void)
{
    weather_details_wait_release();
    _ui_screen_change(&ui_WeatherDetails, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0,
                      &ui_WeatherDetails_screen_init);
    ui_WeatherDetails_refresh();
    if (weather_refresh_timer == NULL)
        weather_refresh_timer = lv_timer_create(weather_details_timer_cb, 1000, NULL);
}

void ui_WeatherDetails_screen_destroy(void)
{
    weather_details_stop_timer();
    if (ui_WeatherDetails != NULL)
        lv_obj_del(ui_WeatherDetails);

    ui_WeatherDetails = NULL;
    weather_city_label = NULL;
    weather_coordinates_label = NULL;
    weather_icon_canvas = NULL;
    weather_condition_label = NULL;
    weather_temperature_label = NULL;
    weather_humidity_value = NULL;
    weather_high_low_value = NULL;
    weather_icon_initialized = 0U;
    weather_drawn_icon = WEATHER_ICON_UNKNOWN;
}
