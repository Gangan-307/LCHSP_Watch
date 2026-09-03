#ifndef LCHSPI_FIND_PHONE_BLE_H_INCLUDED
#define LCHSPI_FIND_PHONE_BLE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define HSP_WATCH_FIRMWARE_VERSION "0.4.0"

/* Call after the Bluetooth stack has brought BLE up. Registers and advertises
 * the watch-owned companion GATT service. */
void find_phone_ble_stack_ready(void);

/* Start or stop the watch-to-phone alert. Calls are asynchronous. */
void find_phone_ble_start(void);
void find_phone_ble_stop(void);

/* Ask the Android companion to send the newest system-camera photo. */
uint8_t find_phone_ble_request_photo_preview(void);

/* Publish the latest local power state to a subscribed Android companion. */
void find_phone_ble_publish_device_status(uint8_t percent, uint8_t battery_valid,
                                          uint8_t charging);

/* Notify the Android companion after the local daily activity total changes. */
void find_phone_ble_publish_activity(void);

/* Publish the watch OTA state on the existing STATE notification channel. */
void find_phone_ble_publish_ota_status(uint8_t state, uint8_t progress_percent);

/* Keep notification deletion coherent with the Android-side reconnect cache. */
void find_phone_ble_delete_notification(uint16_t id);
void find_phone_ble_clear_notifications(void);

/* Stop companion advertising before the Bluetooth radio is turned off. */
void find_phone_ble_close(void);

/* UI state for the control centre. */
uint8_t find_phone_ble_is_requested(void);
uint8_t find_phone_ble_is_connected(void);
uint8_t find_phone_ble_is_scanning(void);

#ifdef __cplusplus
}
#endif

#endif
