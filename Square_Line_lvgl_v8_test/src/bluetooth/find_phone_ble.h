#ifndef LCHSPI_FIND_PHONE_BLE_H_INCLUDED
#define LCHSPI_FIND_PHONE_BLE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Call after the Bluetooth stack has brought BLE up. Registers and advertises
 * the watch-owned companion GATT service. */
void find_phone_ble_stack_ready(void);

/* Start or stop the watch-to-phone alert. Calls are asynchronous. */
void find_phone_ble_start(void);
void find_phone_ble_stop(void);

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
