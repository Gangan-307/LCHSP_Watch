#include "home_pager.h"

#include "home_gestures.h"
#include "screens/ui_ScreenHome.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/music/music_ui.h"

#define HOME_PAGER_WIDTH  390
#define HOME_PAGER_HEIGHT 450

static lv_obj_t *home_pager_screen;
static lv_obj_t *home_pager_tileview;
static lv_obj_t *home_pager_home_tile;
static lv_obj_t *home_pager_music_tile;
static lv_obj_t *home_pager_grid_music_tile;
static lv_obj_t *home_pager_app_grid_tile;
static lv_obj_t *home_pager_controls_tile;
static lv_obj_t *home_pager_notifications_tile;
static uint8_t home_pager_music_is_grid_neighbor;
static uint8_t home_pager_initializing;

static void home_pager_style_tile(lv_obj_t *tile, uint8_t column, uint8_t row)
{
    /* remove_style_all also clears the position assigned by tileview. */
    lv_obj_remove_style_all(tile);
    lv_obj_set_size(tile, HOME_PAGER_WIDTH, HOME_PAGER_HEIGHT);
    lv_obj_set_pos(tile, column * HOME_PAGER_WIDTH,
                   row * HOME_PAGER_HEIGHT);
    lv_obj_clear_flag(tile, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(tile, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(tile, lv_color_black(),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(tile, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(tile, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(tile, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
}

static lv_obj_t *home_pager_tile_for_page(home_pager_page_t page)
{
    switch (page)
    {
    case HOME_PAGER_PAGE_HOME:
        return home_pager_home_tile;
    case HOME_PAGER_PAGE_MUSIC:
        return home_pager_music_tile;
    case HOME_PAGER_PAGE_APP_GRID:
        return home_pager_app_grid_tile;
    case HOME_PAGER_PAGE_CONTROLS:
        return home_pager_controls_tile;
    case HOME_PAGER_PAGE_NOTIFICATIONS:
        return home_pager_notifications_tile;
    default:
        return NULL;
    }
}

static void home_pager_restore_music_tile(void)
{
    if (!home_pager_music_is_grid_neighbor || home_pager_music_tile == NULL ||
        ui_ScreenMusic == NULL)
        return;

    lv_obj_set_parent(ui_ScreenMusic, home_pager_music_tile);
    lv_obj_center(ui_ScreenMusic);
    home_pager_music_is_grid_neighbor = 0U;
    ui_ScreenMusic_set_app_grid_source(0U);
}

static void home_pager_prepare_page(home_pager_page_t page)
{
    if (page == HOME_PAGER_PAGE_CONTROLS)
        home_gestures_prepare_controls();
    else if (page == HOME_PAGER_PAGE_NOTIFICATIONS)
        home_gestures_prepare_notifications();

    if (page == HOME_PAGER_PAGE_HOME &&
        (lv_scr_act() != home_pager_screen ||
         lv_tileview_get_tile_act(home_pager_tileview) !=
         home_pager_grid_music_tile))
    {
        home_pager_restore_music_tile();
    }
}

static void home_pager_event(lv_event_t *event)
{
    lv_event_code_t code = lv_event_get_code(event);

    if (code == LV_EVENT_SCROLL_BEGIN && !home_pager_initializing)
    {
        /* These pages depend on services initialized immediately after ui_init(). */
        home_gestures_prepare_controls();
        home_gestures_prepare_notifications();
    }
    else if (code == LV_EVENT_VALUE_CHANGED)
    {
        lv_obj_t *active_tile = lv_tileview_get_tile_act(home_pager_tileview);

        if (active_tile == home_pager_home_tile ||
            active_tile == home_pager_app_grid_tile)
        {
            home_pager_restore_music_tile();
        }
        else if (active_tile == home_pager_grid_music_tile)
        {
            lv_obj_set_scroll_dir(home_pager_tileview, LV_DIR_NONE);
        }
        else if (active_tile == home_pager_music_tile)
        {
            ui_ScreenMusic_set_app_grid_source(0U);
        }
    }
    else if (code == LV_EVENT_SCROLL_END &&
             home_pager_music_is_grid_neighbor &&
             lv_tileview_get_tile_act(home_pager_tileview) ==
             home_pager_grid_music_tile)
    {
        /* tileview restores the tile's default direction after VALUE_CHANGED. */
        lv_obj_set_scroll_dir(home_pager_tileview, LV_DIR_NONE);
    }
}

void home_pager_init(void)
{
    if (home_pager_screen != NULL)
        return;

    home_pager_screen = lv_obj_create(NULL);
    lv_obj_remove_style_all(home_pager_screen);
    lv_obj_set_size(home_pager_screen, HOME_PAGER_WIDTH, HOME_PAGER_HEIGHT);
    lv_obj_set_pos(home_pager_screen, 0, 0);
    lv_obj_clear_flag(home_pager_screen, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(home_pager_screen, lv_color_black(),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(home_pager_screen, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    home_pager_tileview = lv_tileview_create(home_pager_screen);
    lv_obj_remove_style_all(home_pager_tileview);
    lv_obj_set_size(home_pager_tileview, HOME_PAGER_WIDTH, HOME_PAGER_HEIGHT);
    lv_obj_center(home_pager_tileview);
    lv_obj_set_scrollbar_mode(home_pager_tileview, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_style_radius(home_pager_tileview, 0,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(home_pager_tileview, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(home_pager_tileview, lv_color_black(),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(home_pager_tileview, 0,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(home_pager_tileview, 0,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    home_pager_controls_tile = lv_tileview_add_tile(home_pager_tileview,
                                                     1, 0, LV_DIR_VER);
    home_pager_music_tile = lv_tileview_add_tile(home_pager_tileview,
                                                  0, 1, LV_DIR_HOR);
    home_pager_home_tile = lv_tileview_add_tile(home_pager_tileview,
                                                 1, 1, LV_DIR_ALL);
    home_pager_app_grid_tile = lv_tileview_add_tile(home_pager_tileview,
                                                     2, 1, LV_DIR_NONE);
    home_pager_grid_music_tile = lv_tileview_add_tile(home_pager_tileview,
                                                       3, 1, LV_DIR_NONE);
    home_pager_notifications_tile = lv_tileview_add_tile(home_pager_tileview,
                                                          1, 2, LV_DIR_VER);

    home_pager_style_tile(home_pager_controls_tile, 1, 0);
    home_pager_style_tile(home_pager_music_tile, 0, 1);
    home_pager_style_tile(home_pager_home_tile, 1, 1);
    home_pager_style_tile(home_pager_app_grid_tile, 2, 1);
    home_pager_style_tile(home_pager_grid_music_tile, 3, 1);
    home_pager_style_tile(home_pager_notifications_tile, 1, 2);

    ui_ScreenHome_content_init(home_pager_home_tile, home_pager_screen);
    ui_ScreenMusic_content_init(home_pager_music_tile);
    ui_AppGrid_content_init(home_pager_app_grid_tile);
    home_gestures_attach_tiles(home_pager_controls_tile,
                               home_pager_notifications_tile);

    lv_obj_add_event_cb(home_pager_tileview, home_pager_event,
                        LV_EVENT_ALL, NULL);
    home_pager_initializing = 1U;
    lv_obj_set_tile(home_pager_tileview, home_pager_home_tile, LV_ANIM_OFF);
    home_pager_initializing = 0U;
}

void home_pager_set_page(home_pager_page_t page, lv_anim_enable_t animation)
{
    lv_obj_t *tile;

    if (home_pager_screen == NULL)
        home_pager_init();

    home_pager_prepare_page(page);
    tile = home_pager_tile_for_page(page);
    if (tile == NULL)
        return;

    lv_obj_set_tile(home_pager_tileview, tile, animation);
}

void home_pager_load_page(home_pager_page_t page,
                          lv_scr_load_anim_t animation,
                          uint32_t duration)
{
    if (home_pager_screen == NULL)
        home_pager_init();

    if (lv_scr_act() == home_pager_screen)
    {
        home_pager_set_page(page, LV_ANIM_ON);
        return;
    }

    home_pager_set_page(page, LV_ANIM_OFF);
    lv_scr_load_anim(home_pager_screen, animation, duration, 0, false);
}

void home_pager_open_music_from_app_grid(void)
{
    if (home_pager_screen == NULL)
        home_pager_init();

    lv_obj_set_parent(ui_ScreenMusic, home_pager_grid_music_tile);
    lv_obj_center(ui_ScreenMusic);
    home_pager_music_is_grid_neighbor = 1U;
    lv_obj_set_tile(home_pager_tileview, home_pager_grid_music_tile,
                    LV_ANIM_ON);
    lv_obj_set_scroll_dir(home_pager_tileview, LV_DIR_NONE);
}

uint8_t home_pager_is_active(home_pager_page_t page)
{
    lv_obj_t *tile = home_pager_tile_for_page(page);
    lv_obj_t *active_tile;

    if (home_pager_screen == NULL || lv_scr_act() != home_pager_screen)
        return 0U;

    active_tile = lv_tileview_get_tile_act(home_pager_tileview);
    if (page == HOME_PAGER_PAGE_MUSIC)
        return active_tile == home_pager_music_tile ||
               active_tile == home_pager_grid_music_tile;

    return tile != NULL && active_tile == tile;
}

lv_obj_t *home_pager_get_screen(void)
{
    return home_pager_screen;
}

void home_pager_destroy(void)
{
    if (home_pager_screen == NULL)
        return;

    home_gestures_destroy();
    ui_ScreenMusic_screen_destroy();
    ui_AppGrid_screen_destroy();
    ui_ScreenHome_content_destroy();
    lv_obj_del(home_pager_screen);

    home_pager_screen = NULL;
    home_pager_tileview = NULL;
    home_pager_home_tile = NULL;
    home_pager_music_tile = NULL;
    home_pager_grid_music_tile = NULL;
    home_pager_app_grid_tile = NULL;
    home_pager_controls_tile = NULL;
    home_pager_notifications_tile = NULL;
    home_pager_music_is_grid_neighbor = 0U;
    home_pager_initializing = 0U;
}
