#ifndef TEST_RTCONFIG_H
#define TEST_RTCONFIG_H
#include <stdlib.h>
#define RT_ERROR 1
#define RT_EOK 0
#define LV_COLOR_DEPTH 16
#define LV_MEM_CUSTOM 1
#define LV_MEM_CUSTOM_INCLUDE "test_memory.h"
#define LV_MEM_CUSTOM_ALLOC test_alloc
#define LV_MEM_CUSTOM_FREE test_free
#define LV_MEM_CUSTOM_REALLOC test_realloc
#define LV_FONT_MONTSERRAT_20 1
#define LV_FONT_DEFAULT &lv_font_montserrat_20
#define LV_USE_THEME_DEFAULT 1
#define LV_USE_ASSERT_NULL 1
#define LV_USE_ASSERT_MALLOC 1
#define LV_USE_ASSERT_OBJ 1
#define LV_ASSERT_HANDLER abort();
#define LV_USE_LOG 0
#define LV_IMG_CACHE_DEF_SIZE 0
#define RT_USING_HEAP 1
#define LV_TICK_CUSTOM 0
#endif
