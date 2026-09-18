#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lvgl.h"
#include "rtthread.h"
#include "test_memory.h"
#include "ui/generated/screens/ui_BluetoothSettings.h"
#include "ui/generated/hsp_font_cjk_22.h"
#include "ui/generated/ui_screen_lifecycle.h"

typedef union { size_t size; max_align_t alignment; } allocation_t;
static size_t used_bytes, peak_bytes;
static uint8_t radio = 1, classic, companion, network, requested;
static unsigned grid_returns, controls_returns;
static lv_obj_t *home_screen;
static lv_color_t pixels[390 * 450];

/* The headless display has no SDK input bridge or LCD error recovery. */
void lv_ex_process_data(void) {}
bool lv_lcd_draw_error(void) { return false; }

void *test_alloc(size_t size)
{
    allocation_t *block = malloc(sizeof(*block) + size);
    assert(block != NULL);
    block->size = size;
    used_bytes += size;
    if (used_bytes > peak_bytes) peak_bytes = used_bytes;
    return block + 1;
}

void test_free(void *pointer)
{
    if (pointer == NULL) return;
    allocation_t *block = (allocation_t *)pointer - 1;
    used_bytes -= block->size;
    free(block);
}

void *test_realloc(void *pointer, size_t size)
{
    if (pointer == NULL) return test_alloc(size);
    allocation_t *block = (allocation_t *)pointer - 1;
    void *result = test_alloc(size);
    memcpy(result, pointer, size < block->size ? size : block->size);
    test_free(pointer);
    return result;
}

void rt_memory_info(rt_uint32_t *total, rt_uint32_t *used, rt_uint32_t *peak)
{
    *total = 247488;
    *used = used_bytes;
    *peak = peak_bytes;
}

int rt_kprintf(const char *format, ...) { (void)format; return 0; }
uint8_t bt_pan_is_enabled(void) { return radio; }
uint8_t bt_pan_is_connected(void) { return classic; }
uint8_t bt_pan_network_is_connected(void) { return network; }
void bt_pan_set_enabled(uint8_t value) { radio = value; }
uint8_t find_phone_ble_is_connected(void) { return companion; }
uint8_t find_phone_ble_is_requested(void) { return requested; }
void find_phone_ble_start(void) { requested = 1; }
void find_phone_ble_stop(void) { requested = 0; }
void home_gestures_refresh_controls_state(void) {}

void ui_AppGrid_open(void)
{
    grid_returns++;
    lv_scr_load_anim(home_screen, LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180, 0, false);
}

void home_gestures_open_controls(void)
{
    controls_returns++;
    lv_scr_load_anim(home_screen, LV_SCR_LOAD_ANIM_MOVE_RIGHT, 180, 0, false);
}

static void flush(lv_disp_drv_t *driver, const lv_area_t *area, lv_color_t *colors)
{
    for (int y = area->y1; y <= area->y2; y++)
        for (int x = area->x1; x <= area->x2; x++)
            pixels[y * 390 + x] = *colors++;
    lv_disp_flush_ready(driver);
}

static void advance(unsigned milliseconds)
{
    for (unsigned i = 0; i < milliseconds; i += 10)
    {
        lv_tick_inc(10);
        lv_timer_handler();
    }
}

static lv_obj_t *find_label(lv_obj_t *root, const char *text)
{
    if (lv_obj_check_type(root, &lv_label_class) &&
        strcmp(lv_label_get_text(root), text) == 0) return root;
    for (uint32_t i = 0; i < lv_obj_get_child_cnt(root); i++)
    {
        lv_obj_t *found = find_label(lv_obj_get_child(root, i), text);
        if (found != NULL) return found;
    }
    return NULL;
}

static void check_bounds(lv_obj_t *root)
{
    lv_area_t area;
    lv_obj_get_coords(root, &area);
    assert(area.x1 >= 0 && area.x2 < 390 && area.y1 >= 0 && area.y2 < 450);
    for (uint32_t i = 0; i < lv_obj_get_child_cnt(root); i++)
        check_bounds(lv_obj_get_child(root, i));
}

static unsigned timer_count(void)
{
    unsigned count = 0;
    lv_timer_t *timer = NULL;
    while ((timer = lv_timer_get_next(timer)) != NULL) count++;
    return count;
}

static void screenshot(void)
{
    FILE *file = fopen("bluetooth.ppm", "wb");
    assert(file != NULL);
    fprintf(file, "P6\n390 450\n255\n");
    for (size_t i = 0; i < 390 * 450; i++)
    {
        lv_color32_t c = {.full = lv_color_to32(pixels[i])};
        unsigned char rgb[] = {c.ch.red, c.ch.green, c.ch.blue};
        fwrite(rgb, 1, 3, file);
    }
    fclose(file);
}

int main(void)
{
    static lv_color_t buffer[390 * 16];
    static lv_disp_draw_buf_t draw_buffer;
    static lv_disp_drv_t driver;
    lv_init();
    lv_disp_draw_buf_init(&draw_buffer, buffer, NULL, 390 * 16);
    lv_disp_drv_init(&driver);
    driver.hor_res = 390;
    driver.ver_res = 450;
    driver.draw_buf = &draw_buffer;
    driver.flush_cb = flush;
    lv_disp_t *display = lv_disp_drv_register(&driver);
    lv_disp_set_theme(display, lv_theme_default_init(display,
        lv_palette_main(LV_PALETTE_BLUE), lv_palette_main(LV_PALETTE_RED),
        false, LV_FONT_DEFAULT));
    home_screen = lv_scr_act();
    advance(300);
    size_t baseline = 0;
    unsigned baseline_timers = timer_count();
    size_t open_bytes = 0;

    for (unsigned i = 0; i < 101; i++)
    {
        radio = 1; classic = 0; companion = 0; network = 0; requested = 0;
        if (i % 2) ui_BluetoothSettings_open_from_controls();
        else ui_BluetoothSettings_open_from_app_grid();
        advance(300);
        assert(lv_scr_act() == ui_BluetoothSettings);
        assert(find_label(ui_BluetoothSettings, "蓝牙设置") != NULL);
        /* Alarm/reminder pages can reload their currently active screen. */
        lv_obj_t *same_screen = ui_BluetoothSettings;
        lv_scr_load_anim(same_screen, LV_SCR_LOAD_ANIM_FADE_ON, 160, 0, false);
        advance(300);
        assert(ui_BluetoothSettings == same_screen && lv_scr_act() == same_screen);
        lv_obj_t *find_button = lv_obj_get_parent(find_label(ui_BluetoothSettings, "查找手机"));
        assert(lv_obj_has_state(find_button, LV_STATE_DISABLED));
        classic = companion = network = 1;
        advance(1100);
        assert(find_label(ui_BluetoothSettings, "已连接手机应用") != NULL);
        assert(!lv_obj_has_state(find_button, LV_STATE_DISABLED));
        lv_event_send(find_button, LV_EVENT_CLICKED, NULL);
        assert(requested && find_label(ui_BluetoothSettings, "停止查找") != NULL);
        lv_event_send(find_button, LV_EVENT_CLICKED, NULL);
        assert(!requested);
        advance(300);
        check_bounds(ui_BluetoothSettings);
        if (i == 0) screenshot();
        open_bytes = used_bytes;
        for (unsigned j = 0; j < 1000; j++) ui_BluetoothSettings_refresh();
        assert(used_bytes == open_bytes);
        lv_obj_t *toggle = NULL;
        for (uint32_t j = 0; j < lv_obj_get_child_cnt(ui_BluetoothSettings); j++)
        {
            lv_obj_t *child = lv_obj_get_child(ui_BluetoothSettings, j);
            if (lv_obj_check_type(child, &lv_switch_class)) toggle = child;
        }
        assert(toggle != NULL);
        lv_obj_clear_state(toggle, LV_STATE_CHECKED);
        lv_event_send(toggle, LV_EVENT_VALUE_CHANGED, NULL);
        assert(!radio && find_label(ui_BluetoothSettings, "蓝牙已关闭") != NULL);
        assert(lv_obj_has_state(find_button, LV_STATE_DISABLED));
        /* Repeat registration and back during the same animated transition. */
        ui_screen_release_on_unload(ui_BluetoothSettings, ui_BluetoothSettings_screen_destroy);
        ui_BluetoothSettings_return();
        ui_BluetoothSettings_return();
        advance(400);
        assert(ui_BluetoothSettings == NULL);
        assert(lv_scr_act() == home_screen);
        assert(timer_count() == baseline_timers);
        if (i == 0) baseline = used_bytes;
        else assert(used_bytes == baseline);
    }
    printf("PASS: 101 open/close cycles, stable heap=%zu, page cost=%zu, timers=%u; both return paths exercised (%u/%u).\n",
           baseline, open_bytes - baseline, baseline_timers, grid_returns, controls_returns);
    return 0;
}
