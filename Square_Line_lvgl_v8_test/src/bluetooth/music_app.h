#ifndef LCHSPI_MUSIC_APP_H_INCLUDED
#define LCHSPI_MUSIC_APP_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define MUSIC_APP_TEXT_MAX_LEN (128U)

typedef struct
{
    char title[MUSIC_APP_TEXT_MAX_LEN];
    char artist[MUSIC_APP_TEXT_MAX_LEN];
    char album[MUSIC_APP_TEXT_MAX_LEN];
    uint32_t cover_generation;
    uint8_t connected;
    uint8_t playing;
    uint8_t cover_available;
    uint8_t volume;
    uint8_t volume_valid;
} music_app_snapshot_t;

void music_app_init(void);
void music_app_handle_bt_event(uint16_t type, uint16_t event_id,
                               uint8_t *data, uint16_t data_len);
void music_app_get_snapshot(music_app_snapshot_t *snapshot);
void music_app_retry_cover_request(void);
void music_app_previous(void);
void music_app_toggle_playback(void);
void music_app_next(void);
void music_app_adjust_volume(int delta);

#ifdef __cplusplus
}
#endif

#endif
