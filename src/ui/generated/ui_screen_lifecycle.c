#include "ui_screen_lifecycle.h"

#include <rtthread.h>

void ui_screen_log_memory(const char *stage)
{
#ifdef RT_USING_HEAP
    rt_uint32_t total, used, peak;

    rt_memory_info(&total, &used, &peak);
    rt_kprintf("ui_mem: %s free=%u used=%u peak=%u\n", stage,
               (unsigned int)(total - used), (unsigned int)used,
               (unsigned int)peak);
#else
    (void)stage;
#endif
}

static void ui_screen_unloaded(lv_event_t *event)
{
    void (*destroy)(void) = lv_event_get_user_data(event);

    if (lv_event_get_target(event) != lv_event_get_current_target(event))
        return;
    /* Reminder pages may reload themselves while already on screen. */
    if (lv_event_get_target(event) == lv_scr_act())
        return;
    /* LVGL has finished drawing the outgoing screen at SCREEN_UNLOADED. */
    destroy();
    ui_screen_log_memory("screen released");
}

void ui_screen_release_on_unload(lv_obj_t *screen, void (*destroy)(void))
{
    if (screen == NULL || destroy == NULL)
        return;
    /* A repeated back gesture must not register the destructor twice. */
    lv_obj_remove_event_cb(screen, ui_screen_unloaded);
    lv_obj_add_event_cb(screen, ui_screen_unloaded, LV_EVENT_SCREEN_UNLOADED,
                        destroy);
}
