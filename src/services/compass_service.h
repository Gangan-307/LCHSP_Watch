#ifndef LCHSPI_COMPASS_SERVICE_H_INCLUDED
#define LCHSPI_COMPASS_SERVICE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    int32_t magnetic_x_mgauss;
    int32_t magnetic_y_mgauss;
    int32_t magnetic_z_mgauss;
    uint16_t heading_degrees;
    uint16_t field_strength_mgauss;
    uint8_t available;
    uint8_t valid;
    uint8_t calibrated;
    uint8_t calibration_percent;
    uint8_t interference;
} compass_snapshot_t;

void compass_service_init(void);
void compass_service_set_active(uint8_t active);
void compass_service_reset_calibration(void);
void compass_service_get_snapshot(compass_snapshot_t *snapshot);

#ifdef __cplusplus
}
#endif

#endif
