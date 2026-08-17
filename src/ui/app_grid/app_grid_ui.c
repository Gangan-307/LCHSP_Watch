/*
 * Honeycomb launcher ported from watch/src/gui_apps/main/app_mainmenu.c.
 *
 * The source demo hosts this engine in gui_app_fwk.  This port keeps its
 * hexagonal placement, cell_transform projection, raw-drag handling and
 * nearest-icon snapping inside the existing SquareLine screen lifecycle.
 */

#include <stdint.h>
#include <rtthread.h>
#include "lvgl.h"
#include "lvsf.h"
#include "gui_app_fwk.h"
#include "lv_ext_resource_manager.h"
#include "cell_transform.h"
#include "ui/generated/ui.h"
#include "ui/generated/ui_helpers.h"
#include "app_grid_ui.h"

LV_IMG_DECLARE(img_bikestopwatch);
LV_IMG_DECLARE(img_activity);
LV_IMG_DECLARE(img_alarm);
LV_IMG_DECLARE(img_bluetooth);
LV_IMG_DECLARE(img_calculator);
LV_IMG_DECLARE(img_calendar);
LV_IMG_DECLARE(img_camera);
LV_IMG_DECLARE(img_compass);
LV_IMG_DECLARE(img_dringk);
LV_IMG_DECLARE(img_ebook);
LV_IMG_DECLARE(img_light);
LV_IMG_DECLARE(img_maps);
LV_IMG_DECLARE(img_music);
LV_IMG_DECLARE(img_muyu);
LV_IMG_DECLARE(img_notebook);
LV_IMG_DECLARE(img_photos);
LV_IMG_DECLARE(img_record);
LV_IMG_DECLARE(img_safe);
LV_IMG_DECLARE(img_settings);
LV_IMG_DECLARE(img_sos);
LV_IMG_DECLARE(img_tomato);
LV_IMG_DECLARE(img_weather);
LV_IMG_DECLARE(img_world_clock);

#define APP_GRID_ID                 "Main"
#define APP_GRID_ROWS               16U
#define APP_GRID_COLS               16U
#define APP_GRID_MAX_ICONS          (APP_GRID_ROWS * APP_GRID_COLS)
#define APP_GRID_ICON_RADIUS        (LV_VER_RES_MAX / 9)
#define APP_GRID_ICON_DIAMETER      (APP_GRID_ICON_RADIUS * 2)
#define APP_GRID_INNER_RADIUS       ((APP_GRID_ICON_RADIUS * 8) / 9)
#define APP_GRID_SCROLL_WIDTH       \
    ((APP_GRID_ICON_DIAMETER * (APP_GRID_ROWS - 1U)) + LV_HOR_RES_MAX)
#define APP_GRID_C0R0_X             (APP_GRID_SCROLL_WIDTH >> 1)
#define APP_GRID_C0R0_Y             0
#define APP_GRID_LIMIT_WIDTH         (LV_HOR_RES_MAX - 16)
#define APP_GRID_LIMIT_HEIGHT        (LV_VER_RES_MAX - 20)
#define APP_GRID_LIMIT_RADIUS        (LV_VER_RES_MAX >> 1)
#define APP_GRID_DRAG_LIMIT          8
typedef struct
{
    app_grid_app_id_t id;
    uint8_t image_id;
} app_grid_app_desc_t;

typedef enum
{
    APP_GRID_IMAGE_BIKE_STOPWATCH,
    APP_GRID_IMAGE_ACTIVITY,
    APP_GRID_IMAGE_ALARM,
    APP_GRID_IMAGE_BLUETOOTH,
    APP_GRID_IMAGE_CALCULATOR,
    APP_GRID_IMAGE_CALENDAR,
    APP_GRID_IMAGE_CAMERA,
    APP_GRID_IMAGE_COMPASS,
    APP_GRID_IMAGE_DRINK,
    APP_GRID_IMAGE_EBOOK,
    APP_GRID_IMAGE_LIGHT,
    APP_GRID_IMAGE_MAPS,
    APP_GRID_IMAGE_MUSIC,
    APP_GRID_IMAGE_MUYU,
    APP_GRID_IMAGE_NOTEBOOK,
    APP_GRID_IMAGE_PHOTOS,
    APP_GRID_IMAGE_RECORD,
    APP_GRID_IMAGE_SAFE,
    APP_GRID_IMAGE_SETTINGS,
    APP_GRID_IMAGE_SOS,
    APP_GRID_IMAGE_TOMATO,
    APP_GRID_IMAGE_WEATHER,
    APP_GRID_IMAGE_WORLD_CLOCK,
} app_grid_image_id_t;

typedef struct
{
    lv_obj_t *screen;
    lv_obj_t *page;
    lv_obj_t *icons[APP_GRID_MAX_ICONS];
    lv_point_t pivots[APP_GRID_MAX_ICONS];
    lv_obj_t *center_icon;
    lv_obj_t *pending_icon;
    lv_point_t scroll_sum;
    lv_coord_t last_c0r0_x;
    lv_coord_t last_c0r0_y;
    float zoom;
    float last_zoom;
    uint8_t transform_valid;
    uint8_t dragging;
} app_grid_context_t;

/* Every entry corresponds to one PNG in image/app_grid. */
static const app_grid_app_desc_t app_grid_apps[] =
{
    {APP_GRID_APP_WORLD_CLOCK, APP_GRID_IMAGE_WORLD_CLOCK},
    {APP_GRID_APP_MUSIC, APP_GRID_IMAGE_MUSIC},
    {APP_GRID_APP_LIGHT, APP_GRID_IMAGE_LIGHT},
    {APP_GRID_APP_BLUETOOTH, APP_GRID_IMAGE_BLUETOOTH},
    {APP_GRID_APP_WEATHER, APP_GRID_IMAGE_WEATHER},
    {APP_GRID_APP_MAP, APP_GRID_IMAGE_MAPS},
    {APP_GRID_APP_ACTIVITY, APP_GRID_IMAGE_ACTIVITY},
    {APP_GRID_APP_MUYU, APP_GRID_IMAGE_MUYU},
    {APP_GRID_APP_SETTINGS, APP_GRID_IMAGE_SETTINGS},
    {APP_GRID_APP_CALENDAR, APP_GRID_IMAGE_CALENDAR},
    {APP_GRID_APP_EBOOK, APP_GRID_IMAGE_EBOOK},
    {APP_GRID_APP_TOMATO, APP_GRID_IMAGE_TOMATO},
    {APP_GRID_APP_BIKE_STOPWATCH, APP_GRID_IMAGE_BIKE_STOPWATCH},
    {APP_GRID_APP_ALARM, APP_GRID_IMAGE_ALARM},
    {APP_GRID_APP_CALCULATOR, APP_GRID_IMAGE_CALCULATOR},
    {APP_GRID_APP_COMPASS, APP_GRID_IMAGE_COMPASS},
    {APP_GRID_APP_DRINK, APP_GRID_IMAGE_DRINK},
    {APP_GRID_APP_CAMERA, APP_GRID_IMAGE_CAMERA},
    {APP_GRID_APP_NOTEBOOK, APP_GRID_IMAGE_NOTEBOOK},
    {APP_GRID_APP_PHOTOS, APP_GRID_IMAGE_PHOTOS},
    {APP_GRID_APP_RECORD, APP_GRID_IMAGE_RECORD},
    {APP_GRID_APP_SAFE, APP_GRID_IMAGE_SAFE},
    {APP_GRID_APP_SOS, APP_GRID_IMAGE_SOS},
   
};

lv_obj_t *ui_AppGrid;
static app_grid_context_t app_grid;
static app_grid_app_open_cb_t app_grid_open_handler;

static void app_grid_transform_icons(uint8_t force_refresh);
static void app_grid_page_event(lv_event_t *event);

static const void *app_grid_image_get(app_grid_image_id_t image_id)
{
    switch (image_id)
    {
    case APP_GRID_IMAGE_BIKE_STOPWATCH: return LV_EXT_IMG_GET(img_bikestopwatch);
    case APP_GRID_IMAGE_ACTIVITY: return LV_EXT_IMG_GET(img_activity);
    case APP_GRID_IMAGE_ALARM: return LV_EXT_IMG_GET(img_alarm);
    case APP_GRID_IMAGE_BLUETOOTH: return LV_EXT_IMG_GET(img_bluetooth);
    case APP_GRID_IMAGE_CALCULATOR: return LV_EXT_IMG_GET(img_calculator);
    case APP_GRID_IMAGE_CALENDAR: return LV_EXT_IMG_GET(img_calendar);
    case APP_GRID_IMAGE_CAMERA: return LV_EXT_IMG_GET(img_camera);
    case APP_GRID_IMAGE_COMPASS: return LV_EXT_IMG_GET(img_compass);
    case APP_GRID_IMAGE_DRINK: return LV_EXT_IMG_GET(img_dringk);
    case APP_GRID_IMAGE_EBOOK: return LV_EXT_IMG_GET(img_ebook);
    case APP_GRID_IMAGE_LIGHT: return LV_EXT_IMG_GET(img_light);
    case APP_GRID_IMAGE_MAPS: return LV_EXT_IMG_GET(img_maps);
    case APP_GRID_IMAGE_MUSIC: return LV_EXT_IMG_GET(img_music);
    case APP_GRID_IMAGE_MUYU: return LV_EXT_IMG_GET(img_muyu);
    case APP_GRID_IMAGE_NOTEBOOK: return LV_EXT_IMG_GET(img_notebook);
    case APP_GRID_IMAGE_PHOTOS: return LV_EXT_IMG_GET(img_photos);
    case APP_GRID_IMAGE_RECORD: return LV_EXT_IMG_GET(img_record);
    case APP_GRID_IMAGE_SAFE: return LV_EXT_IMG_GET(img_safe);
    case APP_GRID_IMAGE_SETTINGS: return LV_EXT_IMG_GET(img_settings);
    case APP_GRID_IMAGE_SOS: return LV_EXT_IMG_GET(img_sos);
    case APP_GRID_IMAGE_TOMATO: return LV_EXT_IMG_GET(img_tomato);
    case APP_GRID_IMAGE_WEATHER: return LV_EXT_IMG_GET(img_weather);
    case APP_GRID_IMAGE_WORLD_CLOCK: return LV_EXT_IMG_GET(img_world_clock);
    default: return LV_EXT_IMG_GET(img_settings);
    }
}

static uint16_t app_grid_slot(uint16_t row, uint16_t col)
{
    return (uint16_t)(col * APP_GRID_ROWS + row);
}

static lv_obj_t **app_grid_icon_at(uint16_t row, uint16_t col)
{
    if (row >= APP_GRID_ROWS || col >= APP_GRID_COLS)
        return NULL;

    return &app_grid.icons[app_grid_slot(row, col)];
}

static lv_point_t *app_grid_pivot_at(uint16_t row, uint16_t col)
{
    if (row >= APP_GRID_ROWS || col >= APP_GRID_COLS)
        return NULL;

    return &app_grid.pivots[app_grid_slot(row, col)];
}

/* Original spiral ordering: 0 is centered and each following ring is hexagonal. */
static void app_grid_index_to_cell(uint16_t index, uint16_t *col_out,
                                   uint16_t *row_out)
{
    int16_t col = 0;
    int16_t row = 0;
    uint16_t total = 0U;
    uint16_t ring = 0U;
    uint16_t ring_icons = 1U;
    uint16_t edge_icons;
    uint16_t step;

    if (index != 0U)
    {
        while (total + ring_icons - 1U < index)
        {
            total += ring_icons;
            ring++;
            ring_icons = (uint16_t)(ring * 6U);
        }

        edge_icons = (uint16_t)(ring + 1U);
        col = (int16_t)-ring;
        for (step = 0U; step < ring_icons && total + step != index; step++)
        {
            switch (step / (edge_icons - 1U))
            {
            case 0U: col++; row--; break;
            case 1U: col++; break;
            case 2U: row++; break;
            case 3U: col--; row++; break;
            case 4U: col--; break;
            default: row--; break;
            }
        }
    }

    *col_out = (uint16_t)(col + (APP_GRID_COLS >> 1));
    *row_out = (uint16_t)(row + (APP_GRID_ROWS >> 1));
}

static void app_grid_initial_pivot(uint16_t row, uint16_t col,
                                   lv_coord_t *x_out, lv_coord_t *y_out)
{
    int32_t x;
    int32_t y;

    x = ((int32_t)(col - row) * lv_trigo_cos(60) * APP_GRID_ICON_RADIUS) >>
        (LV_TRIGO_SHIFT - 1);
    y = ((int32_t)(col + row) * lv_trigo_sin(60) * APP_GRID_ICON_RADIUS) >>
        (LV_TRIGO_SHIFT - 1);
    *x_out = (lv_coord_t)(x + APP_GRID_C0R0_X);
    *y_out = (lv_coord_t)(y + APP_GRID_C0R0_Y);
}

static uint8_t app_grid_limit_square(const lv_area_t *area, float *x,
                                     float *y, float *radius)
{
    float x1 = LV_MAX((float)area->x1, *x - *radius);
    float y1 = LV_MAX((float)area->y1, *y - *radius);
    float x2 = LV_MIN((float)area->x2, *x + *radius);
    float y2 = LV_MIN((float)area->y2, *y + *radius);
    float width;
    float height;

    if (x1 > x2 || y1 > y2)
    {
        *radius = 0.0f;
        return 0U;
    }

    width = x2 - x1 + 1.0f;
    height = y2 - y1 + 1.0f;
    *radius = LV_MIN(width / 2.0f, height / 2.0f);
    *x = x1 + width / 2.0f;
    *y = y1 + height / 2.0f;
    return 1U;
}

static void app_grid_limit_round(float limit_radius, const lv_point_t *center,
                                 float *x, float *y, float *icon_radius,
                                 float pivot_radius)
{
    if (pivot_radius + *icon_radius <= limit_radius)
        return;

    if (pivot_radius - *icon_radius >= limit_radius || pivot_radius == 0.0f)
    {
        *icon_radius = 0.0f;
        return;
    }

    {
        float new_icon_radius = (limit_radius - (pivot_radius - *icon_radius)) / 2.0f;
        float new_pivot_radius = limit_radius - new_icon_radius;
        float offset_x = *x - (float)center->x;
        float offset_y = *y - (float)center->y;

        *icon_radius = new_icon_radius;
        *x += (offset_x * new_pivot_radius / pivot_radius) - offset_x;
        *y += (offset_y * new_pivot_radius / pivot_radius) - offset_y;
    }
}

static uint8_t app_grid_layout_transform(float *x, float *y, float *width,
                                         float *pivot_radius_out)
{
    float icon_radius = *width / 2.0f;
    float pivot_radius = 0.0f;
    lv_point_t screen_center;
    lv_area_t safe_area;

    screen_center.x = LV_HOR_RES_MAX >> 1;
    screen_center.y = LV_VER_RES_MAX >> 1;
    safe_area.x1 = (LV_HOR_RES_MAX - APP_GRID_LIMIT_WIDTH) >> 1;
    safe_area.y1 = (LV_VER_RES_MAX - APP_GRID_LIMIT_HEIGHT) >> 1;
    safe_area.x2 = safe_area.x1 + APP_GRID_LIMIT_WIDTH - 1;
    safe_area.y2 = safe_area.y1 + APP_GRID_LIMIT_HEIGHT - 1;

    if (!get_icon_transform_param(*x, *y, icon_radius, x, y, &icon_radius,
                                  &pivot_radius, LV_HOR_RES_MAX, LV_VER_RES_MAX))
    {
        *width = 0.0f;
        *pivot_radius_out = 0.0f;
        return 0U;
    }

    app_grid_limit_round(APP_GRID_LIMIT_RADIUS, &screen_center, x, y,
                         &icon_radius, pivot_radius);
    app_grid_limit_square(&safe_area, x, y, &icon_radius);

    if (icon_radius >= (APP_GRID_ICON_RADIUS - APP_GRID_INNER_RADIUS))
        icon_radius -= (APP_GRID_ICON_RADIUS - APP_GRID_INNER_RADIUS);
    else
        icon_radius = 0.0f;

    *width = icon_radius * 2.0f;
    *pivot_radius_out = pivot_radius;
    return icon_radius > 0.0f;
}

static void app_grid_draw_icon(lv_obj_t *icon, float x, float y, float width)
{
    lv_coord_t image_width;
    lv_coord_t image_height;
    uint16_t zoom;
    int32_t x_10p8;
    int32_t y_10p8;

    if (width <= 0.0f)
    {
        lv_obj_add_flag(icon, LV_OBJ_FLAG_HIDDEN);
        return;
    }

    image_width = lv_obj_get_self_width(icon);
    image_height = lv_obj_get_self_height(icon);
    if (image_width == 0 || image_height == 0)
        return;

    lv_obj_clear_flag(icon, LV_OBJ_FLAG_HIDDEN);
    zoom = (uint16_t)(width * 256.0f / (float)image_width);

    /* This is the source launcher's direct LVGL v8 update path. */
#ifndef DISABLE_LVGL_V8
    ((lv_img_t *)icon)->zoom = zoom;
#else
    lv_img_set_zoom(icon, zoom);
#endif

    x_10p8 = (int32_t)(x * 256.0f) - ((image_width >> 1) << 8);
    y_10p8 = (int32_t)(y * 256.0f) - ((image_height >> 1) << 8);
    lv_obj_move_to(icon, (lv_coord_t)(x_10p8 >> 8) +
                   lv_obj_get_scroll_x(app_grid.page),
                   (lv_coord_t)(y_10p8 >> 8) +
                   lv_obj_get_scroll_y(app_grid.page));
#ifndef DISABLE_LVGL_V8
    lv_img_set_x_frac(icon, (uint16_t)((x_10p8 << 8) & 0xffff));
    lv_img_set_y_frac(icon, (uint16_t)((y_10p8 << 8) & 0xffff));
#endif
}

static lv_obj_t *app_grid_nearest_icon(const lv_point_t *target)
{
    lv_obj_t *nearest = NULL;
    uint32_t nearest_distance = UINT32_MAX;
    uint16_t row;
    uint16_t col;

    for (row = 0U; row < APP_GRID_ROWS; row++)
    {
        for (col = 0U; col < APP_GRID_COLS; col++)
        {
            lv_obj_t *icon = *app_grid_icon_at(row, col);
            lv_point_t *pivot = app_grid_pivot_at(row, col);
            int32_t dx;
            int32_t dy;
            uint32_t distance;

            if (icon == NULL)
                continue;

            dx = pivot->x - target->x;
            dy = pivot->y - target->y;
            distance = (uint32_t)(dx * dx + dy * dy);
            if (distance < nearest_distance)
            {
                nearest_distance = distance;
                nearest = icon;
            }
        }
    }

    return nearest;
}

static lv_obj_t *app_grid_predict_focus_icon(void)
{
    lv_point_t center;
    lv_point_t vector = {0, 0};
    lv_indev_t *indev = lv_indev_get_act();
    uint8_t scroll_throw = 0U;

    center.x = LV_HOR_RES_MAX >> 1;
    center.y = LV_VER_RES_MAX >> 1;
    if (indev != NULL)
    {
        lv_indev_get_vect(indev, &vector);
#ifndef DISABLE_LVGL_V8
        scroll_throw = indev->driver->scroll_throw;
#endif
    }

    while (vector.x != 0 || vector.y != 0)
    {
        vector.x = vector.x * (100 - scroll_throw) / 100;
        vector.y = vector.y * (100 - scroll_throw) / 100;
        center.x -= vector.x;
        center.y -= vector.y;
    }

    return app_grid_nearest_icon(&center);
}

static void app_grid_open_selected_icon(void)
{
    const app_grid_app_desc_t *app;

    if (app_grid.pending_icon == NULL)
        return;

    app = lv_obj_get_user_data(app_grid.pending_icon);
    app_grid.pending_icon = NULL;
    if (app != NULL && app_grid_open_handler != NULL)
    {
        (void)app_grid_open_handler(app->id);
    }
}

static void app_grid_icon_event(lv_event_t *event)
{
    lv_event_code_t code = lv_event_get_code(event);
    lv_obj_t *icon = lv_event_get_target(event);

    if (code != LV_EVENT_SHORT_CLICKED || app_grid.dragging)
        return;

    lv_obj_add_flag(app_grid.page, LV_OBJ_FLAG_SCROLLABLE);
    app_grid.pending_icon = icon;
    lv_obj_scroll_to_view(icon, LV_ANIM_ON);
    if (lv_anim_get(app_grid.page, NULL) == NULL)
        app_grid_open_selected_icon();
}

static void app_grid_page_event(lv_event_t *event)
{
    lv_event_code_t code = lv_event_get_code(event);

    if (code == LV_EVENT_PRESSED)
    {
        app_grid.pending_icon = NULL;
        app_grid.dragging = 0U;
        app_grid.scroll_sum.x = 0;
        app_grid.scroll_sum.y = 0;
        lv_obj_clear_flag(app_grid.page, LV_OBJ_FLAG_SCROLLABLE);
        lv_anim_del(app_grid.page, NULL);
    }
    else if (code == LV_EVENT_PRESSING)
    {
        lv_indev_t *indev = lv_indev_get_act();
        lv_point_t vector;

        if (indev == NULL)
            return;

        lv_indev_get_vect(indev, &vector);
        app_grid.scroll_sum.x += vector.x;
        app_grid.scroll_sum.y += vector.y;
        if (LV_ABS(app_grid.scroll_sum.x) > APP_GRID_DRAG_LIMIT ||
            LV_ABS(app_grid.scroll_sum.y) > APP_GRID_DRAG_LIMIT ||
            app_grid.dragging)
        {
            app_grid.dragging = 1U;
            lv_obj_invalidate(app_grid.page);
        }
    }
    else if (code == LV_EVENT_DRAW_MAIN_BEGIN)
    {
        if (app_grid.dragging)
        {
            _lv_obj_scroll_by_raw(app_grid.page, app_grid.scroll_sum.x,
                                  app_grid.scroll_sum.y);
            app_grid.scroll_sum.x = 0;
            app_grid.scroll_sum.y = 0;
        }
        app_grid_transform_icons(0U);
    }
    else if (code == LV_EVENT_RELEASED || code == LV_EVENT_PRESS_LOST ||
             code == LV_EVENT_CLICKED)
    {
        lv_obj_add_flag(app_grid.page, LV_OBJ_FLAG_SCROLLABLE);
        if (app_grid.dragging)
        {
            lv_obj_t *focus = app_grid_predict_focus_icon();
            if (focus != NULL)
                lv_obj_scroll_to_view(focus, LV_ANIM_ON);
        }
        app_grid.dragging = 0U;
        app_grid.scroll_sum.x = 0;
        app_grid.scroll_sum.y = 0;
    }
    else if (code == LV_EVENT_SCROLL_END)
    {
        app_grid_open_selected_icon();
    }
}

static void app_grid_transform_icons(uint8_t force_refresh)
{
    lv_coord_t c0r0_x;
    lv_coord_t c0r0_y;
    lv_coord_t x_offset;
    lv_coord_t y_offset;
    float nearest_distance = (float)LV_VER_RES_MAX;
    uint16_t row;
    uint16_t col;

    if (app_grid.page == NULL)
        return;

    c0r0_x = APP_GRID_C0R0_X - lv_obj_get_scroll_x(app_grid.page);
    c0r0_y = APP_GRID_C0R0_Y - lv_obj_get_scroll_y(app_grid.page);
    if (app_grid.transform_valid && app_grid.last_c0r0_x == c0r0_x &&
        app_grid.last_c0r0_y == c0r0_y && app_grid.last_zoom == app_grid.zoom &&
        !force_refresh)
        return;

    app_grid.transform_valid = 1U;
    app_grid.last_c0r0_x = c0r0_x;
    app_grid.last_c0r0_y = c0r0_y;
    app_grid.last_zoom = app_grid.zoom;
    x_offset = c0r0_x - app_grid_pivot_at(0U, 0U)->x;
    y_offset = c0r0_y - app_grid_pivot_at(0U, 0U)->y;

    for (row = 0U; row < APP_GRID_ROWS; row++)
    {
        for (col = 0U; col < APP_GRID_COLS; col++)
        {
            lv_obj_t *icon = *app_grid_icon_at(row, col);
            lv_point_t *pivot = app_grid_pivot_at(row, col);
            float x;
            float y;
            float width;
            float pivot_distance;

            pivot->x += x_offset;
            pivot->y += y_offset;
            if (icon == NULL)
                continue;

            x = (float)pivot->x;
            y = (float)pivot->y;
            width = (float)APP_GRID_ICON_DIAMETER;
            if (!app_grid_layout_transform(&x, &y, &width, &pivot_distance))
            {
                app_grid_draw_icon(icon, 0.0f, 0.0f, 0.0f);
                continue;
            }

            if (pivot_distance < nearest_distance)
            {
                nearest_distance = pivot_distance;
                app_grid.center_icon = icon;
            }
            app_grid_draw_icon(icon, x, y, width);
        }
    }
}

static lv_obj_t *app_grid_add_icon(lv_obj_t *parent, const void *image,
                                   const app_grid_app_desc_t *app,
                                   uint16_t row, uint16_t col)
{
    lv_obj_t *icon = lv_img_create(parent);
    lv_obj_t **slot = app_grid_icon_at(row, col);

    lv_img_set_src(icon, image);
    lv_obj_add_flag(icon, LV_OBJ_FLAG_CLICKABLE | LV_OBJ_FLAG_EVENT_BUBBLE);
    lv_obj_clear_flag(icon, LV_OBJ_FLAG_PRESS_LOCK);
    lv_obj_set_user_data(icon, (void *)app);
    lv_obj_add_event_cb(icon, app_grid_icon_event, LV_EVENT_ALL, NULL);
    if (slot != NULL)
        *slot = icon;
    return icon;
}

static void app_grid_create_icons(lv_obj_t *page)
{
    uint16_t index;
    uint16_t col;
    uint16_t row;
    uint16_t app_count = (uint16_t)(sizeof(app_grid_apps) / sizeof(app_grid_apps[0]));

    for (index = 0U; index < app_count; index++)
    {
        app_grid_index_to_cell(index, &col, &row);
        app_grid_add_icon(page, app_grid_image_get(app_grid_apps[index].image_id),
                          &app_grid_apps[index], row, col);
    }
}

static void app_grid_initialize_pivots(void)
{
    uint16_t row;
    uint16_t col;

    for (row = 0U; row < APP_GRID_ROWS; row++)
    {
        for (col = 0U; col < APP_GRID_COLS; col++)
        {
            lv_obj_t *icon = *app_grid_icon_at(row, col);
            lv_point_t *pivot = app_grid_pivot_at(row, col);

            app_grid_initial_pivot(row, col, &pivot->x, &pivot->y);
            if (icon != NULL)
            {
                lv_coord_t image_width = lv_obj_get_self_width(icon);
                lv_coord_t image_height = lv_obj_get_self_height(icon);

                if (image_width > 0 && image_height > 0)
                {
                    lv_obj_set_pos(icon, pivot->x - (image_width >> 1),
                                   pivot->y - (image_height >> 1));
                    lv_img_set_pivot(icon, image_width >> 1, image_height >> 1);
                    lv_img_set_zoom(icon,
                                    (uint16_t)(APP_GRID_ICON_DIAMETER * 256 /
                                               image_width));
                }
            }
        }
    }
}

void ui_AppGrid_return_home(void)
{
    if (app_grid.page != NULL)
        lv_anim_del(app_grid.page, NULL);
    app_grid.pending_icon = NULL;
    app_grid.dragging = 0U;
    app_grid.scroll_sum.x = 0;
    app_grid.scroll_sum.y = 0;
    _ui_screen_change(&ui_ScreenHome, LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180, 0,
                      &ui_ScreenHome_screen_init);
}

void ui_AppGrid_screen_init(void)
{
    lv_obj_t *panel;
    lv_obj_t *center_icon;

    rt_memset(&app_grid, 0, sizeof(app_grid));
    app_grid.zoom = 1.0f;
    app_grid.last_zoom = -1.0f;

    ui_AppGrid = lv_obj_create(NULL);
    lv_obj_clear_flag(ui_AppGrid, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_AppGrid, lv_color_black(), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_AppGrid, LV_OPA_COVER, LV_PART_MAIN);

    panel = lv_obj_create(ui_AppGrid);
    lv_obj_set_size(panel, LV_HOR_RES_MAX, LV_VER_RES_MAX);
    lv_obj_center(panel);
    lv_obj_clear_flag(panel, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(panel, 45, LV_PART_MAIN);
    lv_obj_set_style_bg_color(panel, lv_color_hex(0x050608), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(panel, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(panel, lv_color_hex(0x202A36), LV_PART_MAIN);
    lv_obj_set_style_border_width(panel, 1, LV_PART_MAIN);
    lv_obj_set_style_pad_all(panel, 0, LV_PART_MAIN);
    lv_obj_set_style_clip_corner(panel, true, LV_PART_MAIN);

    app_grid.screen = ui_AppGrid;
    app_grid.page = lv_obj_create(panel);
    lv_obj_set_size(app_grid.page, LV_HOR_RES_MAX, LV_VER_RES_MAX);
    lv_obj_center(app_grid.page);
    lv_obj_set_style_bg_opa(app_grid.page, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(app_grid.page, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(app_grid.page, 0, LV_PART_MAIN);
    lv_obj_set_scrollbar_mode(app_grid.page, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_scroll_dir(app_grid.page, LV_DIR_ALL);
    lv_obj_set_scroll_snap_x(app_grid.page, LV_SCROLL_SNAP_CENTER);
    lv_obj_set_scroll_snap_y(app_grid.page, LV_SCROLL_SNAP_CENTER);
    lv_obj_add_event_cb(app_grid.page, app_grid_page_event, LV_EVENT_ALL, NULL);

    app_grid_create_icons(app_grid.page);
    app_grid_initialize_pivots();
    center_icon = app_grid.icons[app_grid_slot(APP_GRID_ROWS >> 1,
                                               APP_GRID_COLS >> 1)];
    if (center_icon != NULL)
        lv_obj_scroll_to_view(center_icon, LV_ANIM_OFF);
    app_grid_transform_icons(1U);
}

void ui_AppGrid_open(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (ui_AppGrid == NULL)
        ui_AppGrid_screen_init();
    if (indev != NULL)
        lv_indev_wait_release(indev);

    lv_scr_load_anim(ui_AppGrid, LV_SCR_LOAD_ANIM_MOVE_LEFT, 220, 0, false);
}

void ui_AppGrid_screen_destroy(void)
{
    if (ui_AppGrid != NULL)
        lv_obj_del(ui_AppGrid);
    ui_AppGrid = NULL;
    rt_memset(&app_grid, 0, sizeof(app_grid));
}

void app_grid_set_app_open_handler(app_grid_app_open_cb_t callback)
{
    app_grid_open_handler = callback;
}
