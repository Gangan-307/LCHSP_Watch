/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "battery_ble.h"

/* Provided by SiFli's standard BLE Battery Service (UUID 0x180F). */
typedef uint8_t (*ble_bass_callback_t)(uint8_t conn_idx, uint8_t event);

extern void ble_bass_init(ble_bass_callback_t callback, uint8_t battery_level);
extern int8_t ble_bass_notify_battery_lvl(uint8_t conn_idx,
                                           uint8_t battery_level);

#define BATTERY_BLE_PRIMARY_CONN_IDX  (0U)

static uint8_t battery_level;
static uint8_t battery_level_valid;
static uint8_t battery_ble_ready;

static uint8_t battery_ble_bass_callback(uint8_t conn_idx, uint8_t event)
{
    (void)conn_idx;
    (void)event;

    return battery_level;
}

void battery_ble_publish_level(uint8_t percent)
{
    if (percent > 100U)
        percent = 100U;

    if (battery_level_valid && battery_level == percent)
        return;

    battery_level = percent;
    battery_level_valid = 1U;

    if (battery_ble_ready)
        (void)ble_bass_notify_battery_lvl(BATTERY_BLE_PRIMARY_CONN_IDX,
                                           battery_level);
}

void battery_ble_stack_ready(void)
{
    if (battery_ble_ready)
        return;

    ble_bass_init(battery_ble_bass_callback, battery_level);
    battery_ble_ready = 1U;

    if (battery_level_valid)
        (void)ble_bass_notify_battery_lvl(BATTERY_BLE_PRIMARY_CONN_IDX,
                                           battery_level);
}
