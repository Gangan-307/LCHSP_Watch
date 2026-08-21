#ifndef LCHSPI_MUSIC_APP_H_INCLUDED
#define LCHSPI_MUSIC_APP_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define MUSIC_APP_TEXT_MAX_LEN (128U)
#define MUSIC_APP_LYRIC_MAX_LEN (192U)
#define MUSIC_APP_PHONE_COVER_MAX_LEN (8U * 1024U)

typedef struct
{
    char title[MUSIC_APP_TEXT_MAX_LEN];
    char artist[MUSIC_APP_TEXT_MAX_LEN];
    char album[MUSIC_APP_TEXT_MAX_LEN];
    char lyric[MUSIC_APP_LYRIC_MAX_LEN + 1U];
    uint32_t metadata_generation;
    uint32_t lyric_generation;
    uint32_t cover_generation;
    uint32_t progress_generation;
    uint32_t playback_position_ms;
    uint32_t track_duration_ms;
    uint8_t connected;
    uint8_t playing;
    uint8_t cover_available;
    uint8_t volume;
    uint8_t volume_valid;
    uint8_t playback_position_valid;
    uint8_t track_duration_valid;
} music_app_snapshot_t;

void music_app_init(void);
void music_app_handle_bt_event(uint16_t type, uint16_t event_id,
                               uint8_t *data, uint16_t data_len);
void music_app_get_snapshot(music_app_snapshot_t *snapshot);
void music_app_set_lyric(const uint8_t *text, uint16_t length);
int music_app_phone_cover_begin(uint16_t generation, uint32_t total_length,
                                uint32_t expected_crc32);
int music_app_phone_cover_data(uint16_t generation, uint32_t offset,
                               const uint8_t *data, uint16_t length);
void music_app_phone_cover_cancel(void);
/* Prefer the companion application's checked cover stream while it is ready. */
void music_app_set_companion_connected(int connected);
void music_app_reject_cover(uint32_t generation);
void music_app_retry_cover_request(void);
void music_app_previous(void);
void music_app_toggle_playback(void);
void music_app_next(void);
/* Adjust the local amplifier and synchronize its mapped AVRCP volume. */
void music_app_adjust_volume(int delta);
void music_app_set_volume(uint8_t volume);
int music_app_is_speaker_muted(void);
void music_app_set_speaker_muted(int muted);

#ifdef __cplusplus
}
#endif

#endif
