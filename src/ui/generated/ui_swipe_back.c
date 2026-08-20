#include "ui_swipe_back.h"

typedef struct
{
    ui_swipe_back_action_t action;
} ui_swipe_back_binding_t;

static void ui_swipe_back_event(lv_event_t *event)
{
    ui_swipe_back_binding_t *binding = lv_event_get_user_data(event);
    lv_event_code_t code = lv_event_get_code(event);

    if (code == LV_EVENT_DELETE)
    {
        lv_mem_free(binding);
        return;
    }

    if (code == LV_EVENT_GESTURE)
    {
        lv_indev_t *indev = lv_indev_get_act();

        if (indev != NULL &&
            lv_indev_get_gesture_dir(indev) == LV_DIR_RIGHT)
        {
            binding->action();
        }
    }
}

void ui_swipe_back_register(lv_obj_t *screen,
                            ui_swipe_back_action_t action)
{
    ui_swipe_back_binding_t *binding;

    if (screen == NULL || action == NULL)
        return;

    binding = lv_mem_alloc(sizeof(*binding));
    if (binding == NULL)
        return;

    binding->action = action;
    lv_obj_add_event_cb(screen, ui_swipe_back_event, LV_EVENT_ALL, binding);
}
