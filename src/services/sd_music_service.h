#ifndef LCHSPI_SD_MUSIC_SERVICE_H_INCLUDED
#define LCHSPI_SD_MUSIC_SERVICE_H_INCLUDED

#include <stdint.h>

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SD_MUSIC_TITLE_LEN  128U
#define SD_MUSIC_STATUS_LEN 96U

typedef enum
{
    SD_MUSIC_STATE_IDLE,
    SD_MUSIC_STATE_LOADING,
    SD_MUSIC_STATE_PLAYING,
    SD_MUSIC_STATE_PAUSED,
    SD_MUSIC_STATE_ERROR,
} sd_music_state_t;

typedef struct
{
    sd_music_state_t state;
    uint16_t track_count;
    uint16_t track_index;
    uint32_t position_seconds;
    uint32_t duration_seconds;
    uint32_t generation;
    uint8_t volume_percent;
    char title[SD_MUSIC_TITLE_LEN];
    char status[SD_MUSIC_STATUS_LEN];
} sd_music_snapshot_t;

void sd_music_service_init(void);
void sd_music_service_get_snapshot(sd_music_snapshot_t *snapshot);
rt_err_t sd_music_service_refresh(void);
rt_err_t sd_music_service_toggle_playback(void);
rt_err_t sd_music_service_previous(void);
rt_err_t sd_music_service_next(void);
rt_err_t sd_music_service_stop(void);
void sd_music_service_adjust_volume(int delta);

#ifdef __cplusplus
}
#endif

#endif
