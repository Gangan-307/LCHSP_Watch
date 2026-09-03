#ifndef LCHSPI_OTA_SERVICE_H_INCLUDED
#define LCHSPI_OTA_SERVICE_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define OTA_VERSION_LEN 32U
#define OTA_STATUS_LEN  96U

typedef enum
{
    OTA_STATE_IDLE = 0,
    OTA_STATE_CHECKING,
    OTA_STATE_UPDATE_AVAILABLE,
    OTA_STATE_UP_TO_DATE,
    OTA_STATE_PREPARING,
    OTA_STATE_REBOOTING,
    OTA_STATE_FAILED,
} ota_state_t;

typedef enum
{
    OTA_ERROR_NONE = 0,
    OTA_ERROR_NOT_SUPPORTED,
    OTA_ERROR_BUSY,
    OTA_ERROR_SERVER_NOT_CONFIGURED,
    OTA_ERROR_PAN_DISCONNECTED,
    OTA_ERROR_NETWORK,
    OTA_ERROR_INVALID_MANIFEST,
    OTA_ERROR_LOW_BATTERY,
    OTA_ERROR_BATTERY_UNAVAILABLE,
    OTA_ERROR_AUDIO_BUSY,
    OTA_ERROR_FLASH,
    OTA_ERROR_INTERNAL,
} ota_error_t;

typedef struct
{
    ota_state_t state;
    ota_error_t error;
    uint32_t generation;
    uint32_t total_bytes;
    uint8_t pan_connected;
    uint8_t progress_percent;
    char current_version[OTA_VERSION_LEN];
    char latest_version[OTA_VERSION_LEN];
    char status[OTA_STATUS_LEN];
} ota_snapshot_t;

void ota_service_init(void);
void ota_service_get_snapshot(ota_snapshot_t *snapshot);
rt_err_t ota_service_check(void);
rt_err_t ota_service_install(void);
uint8_t ota_service_install_in_progress(void);

#ifdef __cplusplus
}
#endif

#endif
