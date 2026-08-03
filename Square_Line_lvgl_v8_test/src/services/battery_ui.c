/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "lvgl.h"
#include "ui/generated/ui.h"
#include "drivers/adc.h"
#include "rtdevice.h"
#include "battery_calculator.h"

#define BATTERY_UI_UPDATE_PERIOD_MS    (10000U)
#define VBUS_DET_PIN                   (44)
#define BATTERY_CURVE_VOLTAGE_SCALE    (10.0f)
#define BATTERY_FILTER_PREV_WEIGHT     (4.0f)
#define BATTERY_FILTER_CURRENT_WEIGHT  (1.0f)
#define BATTERY_MAX_PERCENT_STEP       (1)
#define BATTERY_MIN_VALID_MV           (2800.0f)
#define BATTERY_MAX_VALID_MV           (4500.0f)

static lv_obj_t *battery_status_label;
static float filtered_battery_mv;
static int filter_initialized;
static int last_charging = -1;
static int battery_percent;
static int battery_percent_valid;

static int battery_percent_from_curve(float mv, int charging)
{
    const battery_lookup_point_t *table;
    uint32_t table_size;
    uint32_t curve_voltage;
    uint32_t percent;

    if (!(mv >= BATTERY_MIN_VALID_MV) || mv > BATTERY_MAX_VALID_MV)
        return -1;

    table = charging ? charging_curve_table : discharge_curve_table;
    table_size = charging ? charging_curve_table_size : discharge_curve_table_size;

    if (table == NULL || table_size < 2)
        return -1;

    /* The 52X board table stores voltage in 0.1 mV units. */
    curve_voltage = (uint32_t)(mv * BATTERY_CURVE_VOLTAGE_SCALE + 0.5f);
    percent = battery_percent_from_curve_table(table, table_size, curve_voltage);

    if (percent > 100)
        percent = 100;

    return (int)percent;
}

static float filter_battery_voltage(float mv, int charging)
{
    if (!filter_initialized || last_charging != charging)
    {
        filtered_battery_mv = mv;
        filter_initialized = 1;
        last_charging = charging;
        return filtered_battery_mv;
    }

    filtered_battery_mv = (filtered_battery_mv * BATTERY_FILTER_PREV_WEIGHT +
                           mv * BATTERY_FILTER_CURRENT_WEIGHT) /
                          (BATTERY_FILTER_PREV_WEIGHT + BATTERY_FILTER_CURRENT_WEIGHT);
    return filtered_battery_mv;
}

static int limit_percent_step(int percent, int charging)
{
    int difference;

    if (!battery_percent_valid)
        return percent;

    /* Ignore an impossible direction caused by ADC noise. */
    if (charging && percent < battery_percent)
        return battery_percent;
    if (!charging && percent > battery_percent)
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
    if (percent >= 15)
        return LV_SYMBOL_BATTERY_1;
    return LV_SYMBOL_BATTERY_EMPTY;
}

static int battery_charger_inserted(void)
{
    /* PA44 is the board VBUS_DET signal and is active high. */
    return rt_pin_read(VBUS_DET_PIN) != 0;
}

static void battery_ui_update(lv_timer_t *timer)
{
    float mv;
    float filtered_mv;
    int percent;
    int charging;
    const char *battery_symbol;

    (void)timer;

    if (battery_status_label == NULL || ui_MainPanel1 == NULL)
        return;

    charging = battery_charger_inserted();
    mv = adc_read_battery_mv();
    if (mv >= BATTERY_MIN_VALID_MV && mv <= BATTERY_MAX_VALID_MV)
    {
        filtered_mv = filter_battery_voltage(mv, charging);
        percent = battery_percent_from_curve(filtered_mv, charging);
        if (percent >= 0)
        {
            battery_percent = limit_percent_step(percent, charging);
            battery_percent_valid = 1;
        }
    }

    battery_symbol = battery_symbol_from_percent(battery_percent_valid ?
                                                 battery_percent : 0);

    if (battery_percent_valid)
    {
        lv_label_set_text_fmt(battery_status_label, "%s%s %d%%",
                              battery_symbol,
                              charging ? LV_SYMBOL_CHARGE : "",
                              battery_percent);
    }
    else
    {
        lv_label_set_text_fmt(battery_status_label, "%s%s --%%",
                              battery_symbol,
                              charging ? LV_SYMBOL_CHARGE : "");
    }

    lv_obj_set_style_text_color(battery_status_label,
                                charging ? lv_color_hex(0x55E391) :
                                (battery_percent_valid && battery_percent <= 15 ?
                                 lv_color_hex(0xFF5C5C) :
                                 lv_color_hex(0xFFFFFF)),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
}

void battery_ui_init(void)
{
    if (ui_MainPanel1 == NULL)
        return;

    rt_pin_mode(VBUS_DET_PIN, PIN_MODE_INPUT);
    battery_status_label = lv_label_create(ui_MainPanel1);
    lv_obj_set_width(battery_status_label, LV_SIZE_CONTENT);
    lv_obj_set_height(battery_status_label, LV_SIZE_CONTENT);
    lv_obj_align(battery_status_label, LV_ALIGN_TOP_RIGHT, -18, 18);
    lv_obj_set_style_text_font(battery_status_label, &lv_font_montserrat_20,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_opa(battery_status_label, LV_OPA_COVER,
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_letter_space(battery_status_label, 0,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);

    battery_ui_update(NULL);
    lv_timer_create(battery_ui_update, BATTERY_UI_UPDATE_PERIOD_MS, NULL);
}
