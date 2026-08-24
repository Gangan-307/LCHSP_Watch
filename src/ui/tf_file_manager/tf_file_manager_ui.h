#ifndef LCHSPI_TF_FILE_MANAGER_UI_H_INCLUDED
#define LCHSPI_TF_FILE_MANAGER_UI_H_INCLUDED

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

extern lv_obj_t *ui_TfFileManager;

void ui_TfFileManager_screen_init(void);
void ui_TfFileManager_screen_destroy(void);
void ui_TfFileManager_open_from_app_grid(void);
void ui_TfFileManager_return(void);

#ifdef __cplusplus
}
#endif

#endif
