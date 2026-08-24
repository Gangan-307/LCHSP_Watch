#ifndef LCHSPI_RECORDING_SERVICE_H_INCLUDED
#define LCHSPI_RECORDING_SERVICE_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define RECORDING_NAME_LEN  48U
#define RECORDING_PATH_LEN  192U
#define RECORDING_STATUS_LEN 80U

typedef enum
{
    RECORDING_STATE_IDLE,
    RECORDING_STATE_STARTING,
    RECORDING_STATE_RECORDING,
    RECORDING_STATE_PLAYING,
    RECORDING_STATE_STOPPING,
} recording_state_t;

typedef struct
{
    char name[RECORDING_NAME_LEN];
    char path[RECORDING_PATH_LEN];
    uint32_t size_bytes;
    uint32_t duration_seconds;
} recording_entry_t;

typedef struct
{
    recording_state_t state;
    uint32_t elapsed_seconds;
    uint32_t data_bytes;
    uint32_t generation;
    char active_name[RECORDING_NAME_LEN];
    char status[RECORDING_STATUS_LEN];
} recording_snapshot_t;

void recording_service_init(void);
void recording_service_get_snapshot(recording_snapshot_t *snapshot);
rt_err_t recording_service_start(void);
rt_err_t recording_service_stop(void);
rt_err_t recording_service_play(const char *path);
int recording_service_list(recording_entry_t *entries, uint16_t max_entries);

#ifdef __cplusplus
}
#endif

#endif
