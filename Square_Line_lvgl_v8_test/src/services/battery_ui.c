/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "rtdevice.h"
#include "lvgl.h"
#include "drivers/adc.h"
#include "drivers/display_power.h"
#include "services/power_manager.h"
#include "bluetooth/battery_ble.h"
#include "battery_calculator.h"
#include "battery_ui.h"

#define BATTERY_SAMPLE_ACTIVE_MS       (10000U)
#define BATTERY_SAMPLE_IDLE_MS         (60000U)
#define BATTERY_UI_REFRESH_PERIOD_MS   (250U)
#define BATTERY_THREAD_STACK_SIZE      (1536U)
#define BATTERY_THREAD_PRIORITY        (28U)
#define BATTERY_THREAD_TICK            (10U)
#define VBUS_DET_PIN                   (44)
#define BATTERY_CURVE_VOLTAGE_SCALE    (10.0f)
#define BATTERY_FILTER_PREV_WEIGHT     (4.0f)
#define BATTERY_FILTER_CURRENT_WEIGHT  (1.0f)
#define BATTERY_MAX_PERCENT_STEP       (1)
#define BATTERY_MIN_VALID_MV           (2800.0f)
#define BATTERY_MAX_VALID_MV           (4500.0f)
#define BATTERY_LOW_PERCENT            (15U)
#define BATTERY_CRITICAL_PERCENT       (5U)
#define BATTERY_CRITICAL_SAMPLE_COUNT  (3U)
#define BATTERY_LOW_NOTICE_DURATION_MS (5000U)
#define BATTERY_SHUTDOWN_TIMEOUT_MS    (15000U)
#define BATTERY_VBUS_DEBOUNCE_MS       (60U)

static lv_obj_t *battery_status_label;
static struct rt_mutex battery_status_lock;
static battery_status_t battery_status;
static float filtered_battery_mv;
static int filter_initialized;
static int last_external_power = -1;
static int battery_percent;
static int battery_percent_valid;
static int battery_service_ready;
static uint8_t critical_sample_count;
static struct rt_semaphore battery_sample_sem;
static lv_obj_t *low_battery_notice;
static lv_obj_t *critical_battery_dialog;
static lv_obj_t *critical_battery_countdown;
static uint32_t low_notice_started_ms;
static uint32_t critical_dialog_started_ms;
static int low_notice_latched;
static int displayed_battery_percent = -1;
static int displayed_battery_valid = -1;
static int displayed_external_power = -1;
static int displayed_low_battery = -1;

static int battery_percent_from_curve(float mv, int external_power)
{
    const battery_lookup_point_t *table;
    uint32_t table_size;
    uint32_t curve_voltage;
    uint32_t percent;

    if (!(mv >= BATTERY_MIN_VALID_MV) || mv > BATTERY_MAX_VALID_MV)
        return -1;

    table = external_power ? charging_curve_table : discharge_curve_table;
    table_size = external_power ? charging_curve_table_size : discharge_curve_table_size;

    if (table == NULL || table_size < 2)
        return -1;

    /* The 52X board table stores voltage in 0.1 mV units. */
    curve_voltage = (uint32_t)(mv * BATTERY_CURVE_VOLTAGE_SCALE + 0.5f);
    percent = battery_percent_from_curve_table(table, table_size, curve_voltage);

    return percent > 100U ? 100 : (int)percent;
}

static float filter_battery_voltage(float mv, int external_power)
{
    if (!filter_initialized || last_external_power != external_power)
    {
        filtered_battery_mv = mv;
        filter_initialized = 1;
        last_external_power = external_power;
        return filtered_battery_mv;
    }

    filtered_battery_mv = (filtered_battery_mv * BATTERY_FILTER_PREV_WEIGHT +
                           mv * BATTERY_FILTER_CURRENT_WEIGHT) /
                          (BATTERY_FILTER_PREV_WEIGHT + BATTERY_FILTER_CURRENT_WEIGHT);
    return filtered_battery_mv;
}

static int limit_percent_step(int percent, int external_power)
{
    int difference;

    if (!battery_percent_valid)
        return percent;

    /* Ignore a direction reversal caused by transient load or ADC noise. */
    if (external_power && percent < battery_percent)
        return battery_percent;
    if (!external_power && percent > battery_percent)
        return battery_percent;

    difference = percent - battery_percent;
    if (difference > BATTERY_MAX_PERCENT_STEP)
        return battery_percent + BATTERY_MAX_PERCENT_STEP;
    if (difference < -BATTERY_MAX_PERCENT_STEP)
        return battery_percent - BATTERY_MAX_PERCENT_STEP;

    return percent;
}

static const char *battery_symbol_from_percent(int percent)
{
    if (percent >= 90)
        return LV_SYMBOL_BATTERY_FULL;
    if (percent >= 65)
        return LV_SYMBOL_BATTERY_3;
    if (percent >= 40)
        return LV_SYMBOL_BATTERY_2;
    if (percent >= BATTERY_LOW_PERCENT)
        return LV_SYMBOL_BATTERY_1;
    return LV_SYMBOL_BATTERY_EMPTY;
}

static int battery_external_power_present(void)
{
    /* PA44 is the board VBUS_DET signal and is active high. */
    return rt_pin_read(VBUS_DET_PIN) != 0;
}

static void battery_vbus_irq_callback(void *parameter)
{
    (void)parameter;

    if (battery_service_ready)
        rt_sem_release(&battery_sample_sem);
}

static void battery_service_sample(void)
{
    float mv;
    float filtered_mv;
    int percent;
    int external_power;

    external_power = battery_external_power_present();
    mv = adc_read_battery_mv();
    if (mv >= BATTERY_MIN_VALID_MV && mv <= BATTERY_MAX_VALID_MV)
    {
        filtered_mv = filter_battery_voltage(mv, external_power);
        percent = battery_percent_from_curve(filtered_mv, external_power);
        if (percent >= 0)
        {
            battery_percent = limit_percent_step(percent, external_power);
            battery_percent_valid = 1;
        }
    }

    if (battery_percent_valid && !external_power &&
        battery_percent <= BATTERY_CRITICAL_PERCENT)
    {
        if (critical_sample_count < BATTERY_CRITICAL_SAMPLE_COUNT)
            critical_sample_count++;
    }
    else
    {
        critical_sample_count = 0;
    }

    rt_mutex_take(&battery_status_lock, RT_WAITING_FOREVER);
    battery_status.external_power_present = external_power ? 1U : 0U;
    battery_status.valid = battery_percent_valid ? 1U : 0U;
    battery_status.low_battery = 0U;
    battery_status.critical_battery = 0U;
    battery_status.critical_confirmed = 0U;
    if (battery_percent_valid)
    {
        battery_status.percent = (uint8_t)battery_percent;
        battery_status.low_battery = battery_percent <= BATTERY_LOW_PERCENT;
        battery_status.critical_battery = battery_percent <= BATTERY_CRITICAL_PERCENT;
        battery_status.critical_confirmed =
            critical_sample_count >= BATTERY_CRITICAL_SAMPLE_COUNT;
    }
    if (mv >= BATTERY_MIN_VALID_MV && mv <= BATTERY_MAX_VALID_MV)
        battery_status.voltage_mv = (uint16_t)(filtered_battery_mv + 0.5f);
    rt_mutex_release(&battery_status_lock);

    if (battery_percent_valid)
        battery_ble_publish_level((uint8_t)battery_percent);
}

static void battery_sample_thread_entry(void *parameter)
{
    (void)parameter;

    while (1)
    {
        battery_service_sample();
        if (rt_sem_take(&battery_sample_sem,
                        rt_tick_from_millisecond(display_power_is_off() ?
                                                 BATTERY_SAMPLE_IDLE_MS :
                                                 BATTERY_SAMPLE_ACTIVE_MS)) == RT_EOK)
        {
            rt_thread_mdelay(BATTERY_VBUS_DEBOUNCE_MS);
        }
    }
}

void battery_ui_get_status(battery_status_t *status)
{
    if (status == NULL)
        return;

    if (!battery_service_ready)
    {
        rt_memset(status, 0, sizeof(*status));
        return;
    }

    rt_mutex_take(&battery_status_lock, RT_WAITING_FOREVER);
    *status = battery_status;
    rt_mutex_release(&battery_status_lock);
}

static void battery_delete_low_notice(void)
{
    if (low_battery_notice != NULL)
    {
        lv_obj_del(low_battery_notice);
        low_battery_notice = NULL;
    }
}

static void battery_delete_critical_dialog(void)
{
    if (critical_battery_dialog != NULL)
    {
        lv_obj_del(critical_battery_dialog);
        critical_battery_dialog = NULL;
    }
    critical_battery_countdown = NULL;
}

static void battery_show_low_notice(const battery_status_t *status)
{
    lv_obj_t *label;

    low_battery_notice = lv_obj_create(lv_layer_top());
    lv_obj_set_size(low_battery_notice, 200, 44);
    lv_obj_align(low_battery_notice, LV_ALIGN_TOP_MID, 0, 18);
    lv_obj_clear_flag(low_battery_notice, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(low_battery_notice, 6, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(low_battery_notice, lv_color_hex(0x2B1717),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(low_battery_notice, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(low_battery_notice, lv_color_hex(0xFF5C5C),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(low_battery_notice, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);

    label = lv_label_create(low_battery_notice);
    lv_label_set_text_fmt(label, LV_SYMBOL_BATTERY_EMPTY "  LOW BATTERY %u%%",
                          (unsigned int)status->percent);
    lv_obj_center(label);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(label, lv_color_hex(0xFF8A8A),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    low_notice_started_ms = lv_tick_get();
}

static void battery_update_low_notice(const battery_status_t *status)
{
    if (!status->valid || status->external_power_present || !status->low_battery)
    {
        battery_delete_low_notice();
        low_notice_latched = 0;
        return;
    }

    if (status->critical_confirmed)
    {
        battery_delete_low_notice();
        return;
    }

    if (!low_notice_latched)
    {
        battery_show_low_notice(status);
        low_notice_latched = 1;
    }
    else if (low_battery_notice != NULL &&
             lv_tick_elaps(low_notice_started_ms) >= BATTERY_LOW_NOTICE_DURATION_MS)
    {
        battery_delete_low_notice();
    }
}

static void battery_show_critical_dialog(const battery_status_t *status)
{
    lv_obj_t *title;

    critical_battery_dialog = lv_obj_create(lv_layer_top());
    lv_obj_set_size(critical_battery_dialog, 270, 145);
    lv_obj_center(critical_battery_dialog);
    lv_obj_clear_flag(critical_battery_dialog, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(critical_battery_dialog, 8,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(critical_battery_dialog, lv_color_hex(0x201313),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(critical_battery_dialog, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(critical_battery_dialog, lv_color_hex(0xFF5C5C),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(critical_battery_dialog, 2,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);

    title = lv_label_create(critical_battery_dialog);
    lv_label_set_text_fmt(title, LV_SYMBOL_BATTERY_EMPTY "  %u%%",
                          (unsigned int)status->percent);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 24);
    lv_obj_set_style_text_font(title, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(title, lv_color_hex(0xFF6B6B),
                                LV_PART_MAIN | LV_STATE_DEFAULT);

    critical_battery_countdown = lv_label_create(critical_battery_dialog);
    lv_obj_align(critical_battery_countdown, LV_ALIGN_BOTTOM_MID, 0, -26);
    lv_obj_set_style_text_font(critical_battery_countdown, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(critical_battery_countdown, lv_color_hex(0xFFFFFF),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    critical_dialog_started_ms = lv_tick_get();
}

static void battery_update_critical_dialog(const battery_status_t *status)
{
    uint32_t elapsed;
    uint32_t remaining_seconds;

    if (!status->critical_confirmed || status->external_power_present)
    {
        battery_delete_critical_dialog();
        return;
    }

    if (critical_battery_dialog == NULL)
    {
        battery_show_critical_dialog(status);
        display_power_wake();
    }

    elapsed = lv_tick_elaps(critical_dialog_started_ms);
    if (elapsed >= BATTERY_SHUTDOWN_TIMEOUT_MS)
    {
        (void)power_manager_shutdown();
        return;
    }

    remaining_seconds = (BATTERY_SHUTDOWN_TIMEOUT_MS - elapsed + 999U) / 1000U;
    lv_label_set_text_fmt(critical_battery_countdown,
                          "POWER OFF IN %u S", (unsigned int)remaining_seconds);
}

static void battery_ui_refresh(void)
{
    battery_status_t status;
    const char *battery_symbol;

    battery_ui_get_status(&status);
    if (battery_service_ready)
        status.external_power_present = battery_external_power_present() ? 1U : 0U;

    battery_update_low_notice(&status);
    battery_update_critical_dialog(&status);

    if (battery_status_label == NULL)
        return;

    if (displayed_battery_percent == status.percent &&
        displayed_battery_valid == status.valid &&
        displayed_external_power == status.external_power_present &&
        displayed_low_battery == status.low_battery)
    {
        return;
    }

    battery_symbol = battery_symbol_from_percent(status.valid ? status.percent : 0);

    if (status.valid)
    {
        lv_label_set_text_fmt(battery_status_label, "%s%s %d%%",
                              battery_symbol,
                              status.external_power_present ? LV_SYMBOL_CHARGE : "",
                              status.percent);
    }
    else
    {
        lv_label_set_text_fmt(battery_status_label, "%s%s --%%",
                              battery_symbol,
                              status.external_power_present ? LV_SYMBOL_CHARGE : "");
    }

    lv_obj_set_style_text_color(battery_status_label,
                                status.external_power_present ? lv_color_hex(0x55E391) :
                                (status.low_battery ? lv_color_hex(0xFF5C5C) :
                                 lv_color_hex(0xF4C86A)),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    displayed_battery_percent = status.percent;
    displayed_battery_valid = status.valid;
    displayed_external_power = status.external_power_present;
    displayed_low_battery = status.low_battery;
}

static void battery_ui_refresh_timer_cb(lv_timer_t *timer)
{
    (void)timer;
    battery_ui_refresh();
}

void battery_ui_bind_home(lv_obj_t *parent)
{
    if (parent == NULL)
        return;

    displayed_battery_percent = -1;
    displayed_battery_valid = -1;
    displayed_external_power = -1;
    displayed_low_battery = -1;
    battery_status_label = lv_label_create(parent);
    lv_obj_set_width(battery_status_label, LV_SIZE_CONTENT);
    lv_obj_set_height(battery_status_label, LV_SIZE_CONTENT);
    lv_obj_align(battery_status_label, LV_ALIGN_TOP_RIGHT, -24, 20);
    lv_obj_set_style_text_font(battery_status_label, &lv_font_montserrat_16,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_opa(battery_status_label, LV_OPA_COVER,
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_letter_space(battery_status_label, 0,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);
    battery_ui_refresh();
}

void battery_ui_unbind_home(void)
{
    battery_status_label = NULL;
    displayed_battery_percent = -1;
    displayed_battery_valid = -1;
    displayed_external_power = -1;
    displayed_low_battery = -1;
}

void battery_ui_init(void)
{
    rt_thread_t battery_thread;

    if (battery_service_ready)
        return;

    rt_pin_mode(VBUS_DET_PIN, PIN_MODE_INPUT);
    rt_memset(&battery_status, 0, sizeof(battery_status));
    if (rt_mutex_init(&battery_status_lock, "battery", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;
    if (rt_sem_init(&battery_sample_sem, "battery_s", 0, RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    battery_service_ready = 1;
    if (rt_pin_attach_irq(VBUS_DET_PIN, PIN_IRQ_MODE_RISING_FALLING,
                          battery_vbus_irq_callback, RT_NULL) == RT_EOK)
    {
        rt_pin_irq_enable(VBUS_DET_PIN, PIN_IRQ_ENABLE);
    }
    lv_timer_create(battery_ui_refresh_timer_cb, BATTERY_UI_REFRESH_PERIOD_MS,
                    NULL);

    battery_thread = rt_thread_create("battery", battery_sample_thread_entry,
                                      RT_NULL, BATTERY_THREAD_STACK_SIZE,
                                      BATTERY_THREAD_PRIORITY, BATTERY_THREAD_TICK);
    if (battery_thread != RT_NULL)
        rt_thread_startup(battery_thread);
}
