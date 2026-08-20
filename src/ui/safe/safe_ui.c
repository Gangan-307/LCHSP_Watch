#include <rtthread.h>

#include "safe_ui.h"
#include "agif.h"
#include "lv_ext_resource_manager.h"
#include "ui/app_grid/app_grid_ui.h"
#include "ui/generated/ui_swipe_back.h"

LV_IMG_DECLARE(agif_icon);

lv_obj_t *ui_Safe = NULL;

static lv_obj_t *safe_gif = NULL;

static void safe_fit_gif_to_screen(void)
{
    lv_coord_t gif_width = lv_obj_get_width(safe_gif);
    lv_coord_t gif_height = lv_obj_get_height(safe_gif);
    uint32_t horizontal_zoom;
    uint32_t vertical_zoom;
    uint16_t zoom;

    if (gif_width <= 0 || gif_height <= 0)
        return;

    horizontal_zoom = (uint32_t)LV_HOR_RES_MAX * LV_IMG_ZOOM_NONE /
                      (uint32_t)gif_width;
    vertical_zoom = (uint32_t)LV_VER_RES_MAX * LV_IMG_ZOOM_NONE /
                    (uint32_t)gif_height;
    zoom = (uint16_t)LV_MIN(horizontal_zoom, vertical_zoom);
    if (zoom < LV_IMG_ZOOM_NONE)
    {
        lv_img_set_pivot(safe_gif, gif_width / 2, gif_height / 2);
        lv_img_set_zoom(safe_gif, zoom);
    }
}

static void safe_wait_release(void)
{
    lv_indev_t *indev = lv_indev_get_act();

    if (indev != NULL)
        lv_indev_wait_release(indev);
}

void ui_Safe_screen_init(void)
{
    lv_color_t background_color;

    if (ui_Safe != NULL)
        return;

    ui_Safe = lv_obj_create(NULL);
    ui_swipe_back_register(ui_Safe, ui_Safe_return);
    lv_obj_clear_flag(ui_Safe, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Safe, lv_color_black(), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Safe, LV_OPA_COVER, LV_PART_MAIN);

    safe_gif = lv_gif_dec_create(ui_Safe, LV_EXT_IMG_GET(agif_icon),
                                 &background_color, LV_COLOR_DEPTH);
    RT_ASSERT(safe_gif != NULL);
    lv_obj_center(safe_gif);
    safe_fit_gif_to_screen();
    lv_gif_dec_loop(safe_gif, 1, 16);
}

void ui_Safe_screen_destroy(void)
{
    if (safe_gif != NULL)
    {
        lv_gif_dec_destroy(safe_gif);
        safe_gif = NULL;
    }

    if (ui_Safe != NULL)
        lv_obj_del(ui_Safe);
    ui_Safe = NULL;
}

void ui_Safe_open_from_app_grid(void)
{
    safe_wait_release();
    if (ui_Safe == NULL)
        ui_Safe_screen_init();

    lv_gif_dec_restart(safe_gif);
    lv_gif_dec_task_resume(safe_gif);

    lv_scr_load_anim(ui_Safe, LV_SCR_LOAD_ANIM_MOVE_LEFT, 180, 0, false);
}

void ui_Safe_return(void)
{
    safe_wait_release();
    if (safe_gif != NULL)
        lv_gif_dec_task_pause(safe_gif, 0);
    ui_AppGrid_open();
}
