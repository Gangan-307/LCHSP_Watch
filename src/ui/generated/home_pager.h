#ifndef LCHSPI_HOME_PAGER_H_INCLUDED
#define LCHSPI_HOME_PAGER_H_INCLUDED

#include <stdint.h>
#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
    HOME_PAGER_PAGE_HOME,
    HOME_PAGER_PAGE_MUSIC,
    HOME_PAGER_PAGE_APP_GRID,
    HOME_PAGER_PAGE_CONTROLS,
    HOME_PAGER_PAGE_NOTIFICATIONS,
} home_pager_page_t;

void home_pager_init(void);
void home_pager_destroy(void);
void home_pager_set_page(home_pager_page_t page, lv_anim_enable_t animation);
void home_pager_load_page(home_pager_page_t page,
                          lv_scr_load_anim_t animation,
                          uint32_t duration);
void home_pager_open_music_from_app_grid(void);
uint8_t home_pager_is_active(home_pager_page_t page);
lv_obj_t *home_pager_get_screen(void);

#ifdef __cplusplus
}
#endif

#endif
