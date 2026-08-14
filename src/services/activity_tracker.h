#ifndef LCHSPI_ACTIVITY_TRACKER_H_INCLUDED
#define LCHSPI_ACTIVITY_TRACKER_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    uint32_t steps;
    uint16_t calories_kcal;
    uint32_t distance_meters;
    uint8_t valid;
} activity_metrics_t;

/* Start the LSM6DSL-compatible hardware step counter after the IMU is ready. */
void activity_tracker_init(void);

/* Returns the current, date-scoped activity totals. */
void activity_tracker_get_metrics(activity_metrics_t *metrics);
uint8_t activity_tracker_is_available(void);

#ifdef __cplusplus
}
#endif

#endif
