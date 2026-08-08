/*
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "stdio.h"
#include "string.h"
#include "bts2_app_inc.h"
#include "music_app.h"

#ifdef AUDIO_USING_MANAGER
#include "audio_server.h"
#endif

#define MUSIC_COVER_FILE "cover.jpg"
#define MUSIC_PHONE_COVER_TEMP_FILE "cvphone.tmp"
#define MUSIC_COVER_BACKUP_FILE "cvbak.jpg"
#define MUSIC_COVER_RETRY_MS (800U)
#define MUSIC_COVER_RETRY_MAX (10U)
#define MUSIC_VOLUME_ECHO_HISTORY_SIZE (4U)
#define MUSIC_VOLUME_ECHO_WINDOW_MS (1500U)
#define AVRCP_CHARSET_UTF8 (0x006AU)
#define AVRCP_CHARSET_UCS2 (0x03E8U)
#define AVRCP_CHARSET_UTF16BE (0x03F5U)
#define AVRCP_CHARSET_UTF16LE (0x03F6U)
#define AVRCP_CHARSET_UTF16 (0x03F7U)

typedef struct
{
    uint8_t volume;
    uint8_t valid;
    rt_tick_t expires_at;
} music_volume_echo_t;

typedef struct
{
    music_app_snapshot_t snapshot;
    bt_notify_device_mac_t remote_addr;
    uint8_t remote_addr_valid;
    uint8_t cover_request_attempts;
    rt_tick_t cover_next_request_tick;
    music_volume_echo_t volume_echoes[MUSIC_VOLUME_ECHO_HISTORY_SIZE];
    uint8_t next_volume_echo;
} music_app_state_t;

static music_app_state_t music_state;
static struct rt_mutex music_state_lock;
static FILE *cover_file;
static uint32_t cover_received_bytes;
static FILE *phone_cover_file;
static uint16_t phone_cover_generation;
static uint32_t phone_cover_expected_bytes;
static uint32_t phone_cover_received_bytes;
static uint32_t phone_cover_expected_crc32;
static uint32_t phone_cover_crc32;
#ifndef AUDIO_USING_MANAGER
static uint8_t speaker_muted;
#endif

static int music_copy_remote_addr(bt_notify_device_mac_t *address);

static void music_update_volume_snapshot(uint8_t volume)
{
    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.volume = volume;
    music_state.snapshot.volume_valid = 1;
    rt_mutex_release(&music_state_lock);
}

static void music_track_volume_echo(uint8_t volume)
{
    music_volume_echo_t *echo;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    echo = &music_state.volume_echoes[music_state.next_volume_echo];
    echo->volume = volume;
    echo->expires_at = rt_tick_get() +
                        rt_tick_from_millisecond(MUSIC_VOLUME_ECHO_WINDOW_MS);
    echo->valid = 1U;
    music_state.next_volume_echo =
        (music_state.next_volume_echo + 1U) % MUSIC_VOLUME_ECHO_HISTORY_SIZE;
    rt_mutex_release(&music_state_lock);
}

static int music_consume_volume_echo(uint8_t volume)
{
    rt_tick_t now = rt_tick_get();
    uint32_t index;
    int matched = 0;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    for (index = 0; index < MUSIC_VOLUME_ECHO_HISTORY_SIZE; index++)
    {
        music_volume_echo_t *echo = &music_state.volume_echoes[index];

        if (!echo->valid)
            continue;

        if ((rt_int32_t)(now - echo->expires_at) > 0)
        {
            echo->valid = 0U;
            continue;
        }

        if (echo->volume == volume)
        {
            echo->valid = 0U;
            matched = 1;
            break;
        }
    }
    rt_mutex_release(&music_state_lock);

    return matched;
}

static uint32_t music_append_utf8(char *destination, uint32_t length,
                                  uint32_t codepoint)
{
    uint32_t byte_count;

    if (codepoint <= 0x7FU)
        byte_count = 1;
    else if (codepoint <= 0x7FFU)
        byte_count = 2;
    else if (codepoint <= 0xFFFFU)
        byte_count = 3;
    else if (codepoint <= 0x10FFFFU)
        byte_count = 4;
    else
        return length;

    if (length + byte_count >= MUSIC_APP_TEXT_MAX_LEN)
        return length;

    if (byte_count == 1)
        destination[length++] = (char)codepoint;
    else if (byte_count == 2)
    {
        destination[length++] = (char)(0xC0U | (codepoint >> 6));
        destination[length++] = (char)(0x80U | (codepoint & 0x3FU));
    }
    else if (byte_count == 3)
    {
        destination[length++] = (char)(0xE0U | (codepoint >> 12));
        destination[length++] = (char)(0x80U | ((codepoint >> 6) & 0x3FU));
        destination[length++] = (char)(0x80U | (codepoint & 0x3FU));
    }
    else
    {
        destination[length++] = (char)(0xF0U | (codepoint >> 18));
        destination[length++] = (char)(0x80U | ((codepoint >> 12) & 0x3FU));
        destination[length++] = (char)(0x80U | ((codepoint >> 6) & 0x3FU));
        destination[length++] = (char)(0x80U | (codepoint & 0x3FU));
    }

    return length;
}

static void music_copy_utf8_text(char *destination, const uint8_t *source,
                                 uint32_t source_length)
{
    uint32_t source_index = 0;
    uint32_t destination_length = 0;

    while (source_index < source_length &&
           destination_length < MUSIC_APP_TEXT_MAX_LEN - 1)
    {
        uint8_t first = source[source_index];
        uint32_t codepoint;
        uint32_t byte_count;

        if (first < 0x80U)
        {
            destination[destination_length++] =
                (first >= 0x20U) ? (char)first : ' ';
            source_index++;
            continue;
        }

        if ((first & 0xE0U) == 0xC0U)
        {
            codepoint = first & 0x1FU;
            byte_count = 2;
        }
        else if ((first & 0xF0U) == 0xE0U)
        {
            codepoint = first & 0x0FU;
            byte_count = 3;
        }
        else if ((first & 0xF8U) == 0xF0U)
        {
            codepoint = first & 0x07U;
            byte_count = 4;
        }
        else
        {
            destination[destination_length++] = '?';
            source_index++;
            continue;
        }

        if (source_index + byte_count > source_length)
        {
            destination[destination_length++] = '?';
            break;
        }

        for (uint32_t index = 1; index < byte_count; index++)
        {
            if ((source[source_index + index] & 0xC0U) != 0x80U)
                break;
            codepoint = (codepoint << 6) | (source[source_index + index] & 0x3FU);
            if (index == byte_count - 1)
            {
                uint32_t minimum = byte_count == 2 ? 0x80U :
                                   byte_count == 3 ? 0x800U : 0x10000U;

                if (codepoint >= minimum && codepoint <= 0xFFFFU &&
                    (codepoint < 0xD800U || codepoint > 0xDFFFU))
                {
                    uint32_t old_length = destination_length;
                    destination_length = music_append_utf8(destination,
                                                           destination_length,
                                                           codepoint);
                    if (destination_length == old_length)
                        source_index = source_length;
                }
                else
                {
                    destination[destination_length++] = '?';
                }
                source_index += byte_count;
                goto next_character;
            }
        }

        destination[destination_length++] = '?';
        source_index++;
next_character:
        ;
    }

    destination[destination_length] = '\0';
}

static void music_copy_utf16_text(char *destination, const uint8_t *source,
                                  uint32_t source_length, int little_endian)
{
    uint32_t source_index = 0;
    uint32_t destination_length = 0;

    while (source_index + 1 < source_length &&
           destination_length < MUSIC_APP_TEXT_MAX_LEN - 1)
    {
        uint32_t codepoint;
        uint16_t unit = little_endian ?
                        ((uint16_t)source[source_index] |
                         ((uint16_t)source[source_index + 1] << 8)) :
                        (((uint16_t)source[source_index] << 8) |
                         (uint16_t)source[source_index + 1]);

        source_index += 2;
        if (unit >= 0xD800U && unit <= 0xDBFFU && source_index + 1 < source_length)
        {
            uint16_t low = little_endian ?
                           ((uint16_t)source[source_index] |
                            ((uint16_t)source[source_index + 1] << 8)) :
                           (((uint16_t)source[source_index] << 8) |
                            (uint16_t)source[source_index + 1]);

            if (low >= 0xDC00U && low <= 0xDFFFU)
            {
                codepoint = 0x10000U + (((uint32_t)unit - 0xD800U) << 10) +
                            ((uint32_t)low - 0xDC00U);
                source_index += 2;
            }
            else
            {
                codepoint = '?';
            }
        }
        else if (unit >= 0xDC00U && unit <= 0xDFFFU)
        {
            codepoint = '?';
        }
        else
        {
            codepoint = unit;
        }

        destination_length = music_append_utf8(destination, destination_length,
                                               codepoint);
    }

    destination[destination_length] = '\0';
}

static void music_copy_text(char *destination, const uint8_t *source,
                            uint32_t source_length, uint16_t character_set)
{
    uint32_t zero_even = 0;
    uint32_t zero_odd = 0;

    if (source == NULL || source_length == 0)
    {
        destination[0] = '\0';
        return;
    }

    if (character_set == AVRCP_CHARSET_UCS2 ||
        character_set == AVRCP_CHARSET_UTF16BE ||
        character_set == AVRCP_CHARSET_UTF16LE ||
        character_set == AVRCP_CHARSET_UTF16)
    {
        int little_endian = character_set == AVRCP_CHARSET_UTF16LE;

        if (character_set == AVRCP_CHARSET_UTF16 && source_length >= 2)
        {
            if (source[0] == 0xFFU && source[1] == 0xFEU)
            {
                little_endian = 1;
                source += 2;
                source_length -= 2;
            }
            else if (source[0] == 0xFEU && source[1] == 0xFFU)
            {
                source += 2;
                source_length -= 2;
            }
        }
        music_copy_utf16_text(destination, source, source_length, little_endian);
        return;
    }

    if (character_set != AVRCP_CHARSET_UTF8 && source_length >= 4)
    {
        for (uint32_t index = 0; index < source_length; index += 2)
        {
            if (source[index] == 0)
                zero_even++;
            if (index + 1 < source_length && source[index + 1] == 0)
                zero_odd++;
        }

        if (zero_even > source_length / 4 || zero_odd > source_length / 4)
        {
            music_copy_utf16_text(destination, source, source_length,
                                  zero_even > zero_odd);
            return;
        }
    }

    music_copy_utf8_text(destination, source, source_length);
}

static int music_song_changed(const bt_notify_avrcp_music_detail_info_t *detail)
{
    char title[MUSIC_APP_TEXT_MAX_LEN];
    char artist[MUSIC_APP_TEXT_MAX_LEN];
    char album[MUSIC_APP_TEXT_MAX_LEN];
    int changed;

    music_copy_text(title, detail->song_name.song_name, detail->song_name.size,
                    detail->character_set_id);
    music_copy_text(artist, detail->singer_name.singer_name,
                    detail->singer_name.size, detail->character_set_id);
    music_copy_text(album, detail->album_info.album_name,
                    detail->album_info.size, detail->character_set_id);

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    changed = strcmp(title, music_state.snapshot.title) != 0 ||
              strcmp(artist, music_state.snapshot.artist) != 0 ||
              strcmp(album, music_state.snapshot.album) != 0;
    rt_strncpy(music_state.snapshot.title, title, MUSIC_APP_TEXT_MAX_LEN);
    rt_strncpy(music_state.snapshot.artist, artist, MUSIC_APP_TEXT_MAX_LEN);
    rt_strncpy(music_state.snapshot.album, album, MUSIC_APP_TEXT_MAX_LEN);
    if (changed)
    {
        music_state.snapshot.metadata_generation++;
        music_state.snapshot.lyric[0] = '\0';
        music_state.snapshot.lyric_generation++;
    }
    rt_mutex_release(&music_state_lock);

    return changed;
}

static void music_set_connection(const bt_notify_device_mac_t *address, int connected)
{
    uint8_t volume = 64;
    uint8_t volume_valid = 0;

#ifdef AUDIO_USING_MANAGER
    uint8_t local_volume = audio_server_get_private_volume(AUDIO_TYPE_BT_MUSIC);
    uint8_t max_volume = audio_server_get_max_volume();

    volume = bt_interface_avrcp_local_vol_2_abs_vol(local_volume, max_volume);
    volume_valid = 1;
#endif

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.connected = connected ? 1 : 0;
    music_state.snapshot.playing = 0;
    music_state.snapshot.volume = volume;
    music_state.snapshot.volume_valid = volume_valid;
    if (connected)
    {
        music_state.remote_addr = *address;
        music_state.remote_addr_valid = 1;
    }
    else
    {
        music_state.remote_addr_valid = 0;
    }
    rt_mutex_release(&music_state_lock);
}

static void music_finish_cover_file(void)
{
    if (cover_file == NULL)
        return;

    fclose(cover_file);
    cover_file = NULL;

    if (cover_received_bytes == 0)
    {
        rt_kprintf("music: received an empty cover file\n");
        return;
    }

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.cover_generation++;
    music_state.snapshot.cover_available = 1;
    rt_mutex_release(&music_state_lock);

    rt_kprintf("music: cover saved, %u bytes\n", cover_received_bytes);
}

static void music_discard_cover_file(void)
{
    if (cover_file != NULL)
    {
        fclose(cover_file);
        cover_file = NULL;
    }
    cover_received_bytes = 0;
}

static void music_clear_cover(void)
{
    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.cover_available = 0;
    rt_mutex_release(&music_state_lock);
}

static void music_request_cover(void)
{
#ifdef CFG_AVRCP_COVER_ART
    bt_notify_device_mac_t remote_addr;
    int request_cover = 0;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    if (music_state.remote_addr_valid &&
        music_state.cover_request_attempts < MUSIC_COVER_RETRY_MAX)
    {
        remote_addr = music_state.remote_addr;
        music_state.cover_request_attempts++;
        music_state.cover_next_request_tick = rt_tick_get() +
            rt_tick_from_millisecond(MUSIC_COVER_RETRY_MS);
        request_cover = 1;
    }
    rt_mutex_release(&music_state_lock);

    if (request_cover)
    {
        bt_err_t result = bt_interface_avrcp_get_cover_art(&remote_addr);

        rt_kprintf("music: request cover %u/%u, result %d\n",
                   music_state.cover_request_attempts, MUSIC_COVER_RETRY_MAX,
                   result);
    }
#endif
}

void music_app_init(void)
{
    rt_memset(&music_state, 0, sizeof(music_state));
    rt_mutex_init(&music_state_lock, "music", RT_IPC_FLAG_PRIO);
}

void music_app_set_lyric(const uint8_t *text, uint16_t length)
{
    if (text == RT_NULL)
        length = 0U;
    if (length > MUSIC_APP_LYRIC_MAX_LEN)
    {
        length = MUSIC_APP_LYRIC_MAX_LEN;
        while (length > 0U && (text[length] & 0xC0U) == 0x80U)
            length--;
    }

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    if (strlen(music_state.snapshot.lyric) != length ||
        (length != 0U && memcmp(music_state.snapshot.lyric, text, length) != 0))
    {
        if (length != 0U)
            rt_memcpy(music_state.snapshot.lyric, text, length);
        music_state.snapshot.lyric[length] = '\0';
        music_state.snapshot.lyric_generation++;
    }
    rt_mutex_release(&music_state_lock);
}

static uint32_t music_cover_crc32_update(uint32_t crc, const uint8_t *data,
                                         uint16_t length)
{
    uint16_t index;

    for (index = 0U; index < length; index++)
    {
        uint8_t bit;

        crc ^= data[index];
        for (bit = 0U; bit < 8U; bit++)
            crc = (crc >> 1U) ^ ((crc & 1U) ? 0xEDB88320UL : 0U);
    }
    return crc;
}

void music_app_phone_cover_cancel(void)
{
    if (phone_cover_file != RT_NULL)
    {
        fclose(phone_cover_file);
        phone_cover_file = RT_NULL;
    }
    (void)remove(MUSIC_PHONE_COVER_TEMP_FILE);
    phone_cover_generation = 0U;
    phone_cover_expected_bytes = 0U;
    phone_cover_received_bytes = 0U;
    phone_cover_expected_crc32 = 0U;
    phone_cover_crc32 = 0xFFFFFFFFUL;
}

int music_app_phone_cover_begin(uint16_t generation, uint32_t total_length,
                                uint32_t expected_crc32)
{
    if (generation == 0U || total_length < 4U ||
        total_length > MUSIC_APP_PHONE_COVER_MAX_LEN)
        return -1;

    music_app_phone_cover_cancel();
    phone_cover_file = fopen(MUSIC_PHONE_COVER_TEMP_FILE, "wb");
    if (phone_cover_file == RT_NULL)
    {
        rt_kprintf("music: cannot open phone cover temporary file\n");
        return -1;
    }

    phone_cover_generation = generation;
    phone_cover_expected_bytes = total_length;
    phone_cover_expected_crc32 = expected_crc32;
    phone_cover_crc32 = 0xFFFFFFFFUL;
    rt_kprintf("music: receiving phone cover, %u bytes\n", total_length);
    return 0;
}

static int music_app_phone_cover_finish(void)
{
    uint32_t actual_crc32;
    int had_previous_cover;

    if (phone_cover_file == RT_NULL)
        return -1;
    fclose(phone_cover_file);
    phone_cover_file = RT_NULL;
    actual_crc32 = phone_cover_crc32 ^ 0xFFFFFFFFUL;
    if (phone_cover_received_bytes != phone_cover_expected_bytes ||
        actual_crc32 != phone_cover_expected_crc32)
    {
        rt_kprintf("music: rejected phone cover (%u/%u bytes, crc %08x/%08x)\n",
                   phone_cover_received_bytes, phone_cover_expected_bytes,
                   actual_crc32, phone_cover_expected_crc32);
        music_app_phone_cover_cancel();
        return -1;
    }

    (void)remove(MUSIC_COVER_BACKUP_FILE);
    had_previous_cover = rename(MUSIC_COVER_FILE, MUSIC_COVER_BACKUP_FILE) == 0;
    if (rename(MUSIC_PHONE_COVER_TEMP_FILE, MUSIC_COVER_FILE) != 0)
    {
        if (had_previous_cover)
            (void)rename(MUSIC_COVER_BACKUP_FILE, MUSIC_COVER_FILE);
        music_app_phone_cover_cancel();
        rt_kprintf("music: cannot install phone cover\n");
        return -1;
    }
    if (had_previous_cover)
        (void)remove(MUSIC_COVER_BACKUP_FILE);

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.cover_generation++;
    music_state.snapshot.cover_available = 1U;
    rt_mutex_release(&music_state_lock);
    rt_kprintf("music: phone cover saved, %u bytes\n",
               phone_cover_received_bytes);

    phone_cover_generation = 0U;
    phone_cover_expected_bytes = 0U;
    phone_cover_received_bytes = 0U;
    phone_cover_expected_crc32 = 0U;
    phone_cover_crc32 = 0xFFFFFFFFUL;
    return 0;
}

int music_app_phone_cover_data(uint16_t generation, uint32_t offset,
                               const uint8_t *data, uint16_t length)
{
    size_t written;

    if (phone_cover_file == RT_NULL || data == RT_NULL || length == 0U ||
        generation != phone_cover_generation ||
        offset != phone_cover_received_bytes ||
        offset + length > phone_cover_expected_bytes)
    {
        music_app_phone_cover_cancel();
        return -1;
    }

    written = fwrite(data, sizeof(uint8_t), length, phone_cover_file);
    if (written != length)
    {
        music_app_phone_cover_cancel();
        return -1;
    }
    phone_cover_crc32 = music_cover_crc32_update(phone_cover_crc32, data, length);
    phone_cover_received_bytes += length;
    if (phone_cover_received_bytes == phone_cover_expected_bytes)
        return music_app_phone_cover_finish();
    return 0;
}

void music_app_handle_bt_event(uint16_t type, uint16_t event_id,
                               uint8_t *data, uint16_t data_len)
{
    (void)data_len;

    if (type == BT_NOTIFY_A2DP)
    {
        if (event_id == BT_NOTIFY_A2DP_PROFILE_CONNECTED)
        {
            bt_notify_profile_state_info_t *info =
                (bt_notify_profile_state_info_t *)data;

            if (info != NULL && info->res == BTS2_SUCC)
                music_set_connection(&info->mac, 1);
        }
        else if (event_id == BT_NOTIFY_A2DP_PROFILE_DISCONNECTED)
        {
            music_set_connection(NULL, 0);
        }
        else if (event_id == BT_NOTIFY_A2DP_START_IND ||
                 event_id == BT_NOTIFY_A2DP_START_CFM)
        {
            rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
            music_state.snapshot.playing = 1;
            rt_mutex_release(&music_state_lock);
        }
        else if (event_id == BT_NOTIFY_A2DP_SUSPEND_IND ||
                 event_id == BT_NOTIFY_A2DP_SUSPEND_CFM)
        {
            rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
            music_state.snapshot.playing = 0;
            rt_mutex_release(&music_state_lock);
        }
        return;
    }

    if (type != BT_NOTIFY_AVRCP)
        return;

    if (event_id == BT_NOTIFY_AVRCP_PROFILE_CONNECTED)
    {
        bt_notify_profile_state_info_t *info =
            (bt_notify_profile_state_info_t *)data;

        if (info != NULL && info->res == BTS2_SUCC)
        {
            music_set_connection(&info->mac, 1);
            bt_interface_set_avrcp_role_ext(&info->mac, AVRCP_CT);
            rt_kprintf("music: AVRCP connected\n");
        }
    }
    else if (event_id == BT_NOTIFY_AVRCP_PROFILE_DISCONNECTED)
    {
        rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
        music_state.snapshot.playing = 0;
        rt_mutex_release(&music_state_lock);
    }
    else if (event_id == BT_NOTIFY_AVRCP_MUSIC_DETAIL_INFO)
    {
        bt_notify_avrcp_music_detail_t *detail =
            (bt_notify_avrcp_music_detail_t *)data;

        if (detail != NULL && music_song_changed(&detail->detail_info))
        {
            music_discard_cover_file();
            music_app_phone_cover_cancel();
            music_clear_cover();
            rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
            music_state.cover_request_attempts = 0;
            music_state.cover_next_request_tick = 0;
            rt_mutex_release(&music_state_lock);
            music_request_cover();
        }
    }
    else if (event_id == BT_NOTIFY_AVRCP_PLAY_STATUS && data != NULL)
    {
        rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
        music_state.snapshot.playing = (*(uint8_t *)data == 0);
        rt_mutex_release(&music_state_lock);
    }
    else if (event_id == BT_NOTIFY_AVRCP_ABSOLUTE_VOLUME && data != NULL)
    {
        uint8_t volume = *data;

#ifdef AUDIO_USING_MANAGER
        uint8_t max_volume = audio_server_get_max_volume();
        uint8_t local_volume;

        if (music_consume_volume_echo(volume))
        {
            local_volume = audio_server_get_private_volume(AUDIO_TYPE_BT_MUSIC);
            volume = bt_interface_avrcp_local_vol_2_abs_vol(local_volume,
                                                             max_volume);
            music_update_volume_snapshot(volume);
            return;
        }

        local_volume = bt_interface_avrcp_abs_vol_2_local_vol(volume,
                                                                max_volume);

        if (local_volume != audio_server_get_private_volume(AUDIO_TYPE_BT_MUSIC))
            audio_server_set_private_volume(AUDIO_TYPE_BT_MUSIC, local_volume);

        /* The local amplifier has discrete steps; show the effective local level. */
        volume = bt_interface_avrcp_local_vol_2_abs_vol(local_volume, max_volume);
#endif
        music_update_volume_snapshot(volume);
    }
#if defined(RT_USING_DFS) && defined(CFG_AVRCP_COVER_ART)
    else if (event_id == BTS2MU_AVRCP_COVER_ART_CONN_CFM)
    {
        BTS2S_AVRCP_COVER_ART_CONN_CFM *confirm =
            (BTS2S_AVRCP_COVER_ART_CONN_CFM *)data;

        if (confirm != NULL)
            rt_kprintf("music: cover art channel result %u\n", confirm->res);
    }
    else if (event_id == BTS2MU_AVRCP_GET_COVER_ART_BEGIN_IND)
    {
        BTS2S_AVRCPGET_COVER_ART_BEGIN_IND *packet =
            (BTS2S_AVRCPGET_COVER_ART_BEGIN_IND *)data;

        if (packet == NULL)
            return;

        if (packet->total_length != 0)
            rt_kprintf("music: receiving cover, total %u bytes\n",
                       packet->total_length);

        if (cover_file == NULL)
            cover_file = fopen(MUSIC_COVER_FILE, "wb");
        if (cover_file == NULL)
        {
            rt_kprintf("music: cannot open %s for writing\n", MUSIC_COVER_FILE);
            return;
        }

        if (packet->body_data_length != 0)
        {
            size_t written = fwrite(packet->body_data, sizeof(uint8_t),
                                    packet->body_data_length, cover_file);

            cover_received_bytes += written;
            if (written != packet->body_data_length)
            {
                rt_kprintf("music: cover write failed (%u/%u bytes)\n",
                           (unsigned int)written, packet->body_data_length);
                music_discard_cover_file();
                return;
            }
        }
        if (packet->is_final_packet)
            music_finish_cover_file();
    }
    else if (event_id == BTS2MU_AVRCP_GET_COVER_ART_ABORT_IND)
    {
        music_discard_cover_file();
    }
#endif
}

void music_app_get_snapshot(music_app_snapshot_t *snapshot)
{
    if (snapshot == NULL)
        return;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    *snapshot = music_state.snapshot;
    rt_mutex_release(&music_state_lock);
}

void music_app_reject_cover(uint32_t generation)
{
    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    if (music_state.snapshot.cover_generation == generation)
        music_state.snapshot.cover_available = 0U;
    rt_mutex_release(&music_state_lock);
}

void music_app_retry_cover_request(void)
{
#ifdef CFG_AVRCP_COVER_ART
    int request_cover;
    rt_tick_t now = rt_tick_get();

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    request_cover = !music_state.snapshot.cover_available &&
                    music_state.remote_addr_valid &&
                    music_state.cover_request_attempts < MUSIC_COVER_RETRY_MAX &&
                    (rt_int32_t)(now - music_state.cover_next_request_tick) >= 0;
    rt_mutex_release(&music_state_lock);

    if (request_cover)
        music_request_cover();
#endif
}

static int music_copy_remote_addr(bt_notify_device_mac_t *address)
{
    int has_remote_addr;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    has_remote_addr = music_state.remote_addr_valid;
    if (has_remote_addr)
        *address = music_state.remote_addr;
    rt_mutex_release(&music_state_lock);

    return has_remote_addr;
}

void music_app_previous(void)
{
    bt_notify_device_mac_t address;

    if (music_copy_remote_addr(&address))
        bt_interface_avrcp_previous_ext(&address);
}

void music_app_toggle_playback(void)
{
    bt_notify_device_mac_t address;
    int playing;

    if (!music_copy_remote_addr(&address))
        return;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    playing = music_state.snapshot.playing;
    rt_mutex_release(&music_state_lock);

    if (playing)
        bt_interface_avrcp_pause_ext(&address);
    else
        bt_interface_avrcp_play_ext(&address);
}

void music_app_next(void)
{
    bt_notify_device_mac_t address;

    if (music_copy_remote_addr(&address))
        bt_interface_avrcp_next_ext(&address);
}

void music_app_set_volume(uint8_t volume)
{
    bt_notify_device_mac_t address;
    int has_remote_addr;

    if (volume > 127U)
        volume = 127U;

#ifdef AUDIO_USING_MANAGER
    uint8_t max_volume = audio_server_get_max_volume();
    uint8_t local_volume = bt_interface_avrcp_abs_vol_2_local_vol(volume,
                                                                    max_volume);

    audio_server_set_private_volume(AUDIO_TYPE_BT_MUSIC, local_volume);
    volume = bt_interface_avrcp_local_vol_2_abs_vol(local_volume, max_volume);
    music_update_volume_snapshot(volume);

    has_remote_addr = music_copy_remote_addr(&address);
    if (has_remote_addr)
    {
        music_track_volume_echo(volume);
        bt_interface_avrcp_set_absolute_volume_as_ct_role_ext(&address, volume);
    }
#else
    has_remote_addr = music_copy_remote_addr(&address);

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    music_state.snapshot.volume = volume;
    music_state.snapshot.volume_valid = 1U;
    rt_mutex_release(&music_state_lock);

    if (has_remote_addr)
        bt_interface_avrcp_set_absolute_volume_as_ct_role_ext(&address, volume);
#endif
}

int music_app_is_speaker_muted(void)
{
#ifdef AUDIO_USING_MANAGER
    return audio_server_get_public_speaker_mute() != 0;
#else
    return speaker_muted != 0U;
#endif
}

void music_app_set_speaker_muted(int muted)
{
#ifdef AUDIO_USING_MANAGER
    audio_server_set_public_speaker_mute(muted ? 1U : 0U);
#else
    speaker_muted = muted ? 1U : 0U;
#endif
}

void music_app_adjust_volume(int delta)
{
    bt_notify_device_mac_t address;
    int has_remote_addr;

#ifdef AUDIO_USING_MANAGER
    int local_volume;
    uint8_t max_volume = audio_server_get_max_volume();
    uint8_t volume;

    local_volume = audio_server_get_private_volume(AUDIO_TYPE_BT_MUSIC);
    local_volume += delta;
    if (local_volume < 0)
        local_volume = 0;
    else if (local_volume > max_volume)
        local_volume = max_volume;

    audio_server_set_private_volume(AUDIO_TYPE_BT_MUSIC, (uint8_t)local_volume);
    volume = bt_interface_avrcp_local_vol_2_abs_vol((uint8_t)local_volume,
                                                     max_volume);
    music_update_volume_snapshot(volume);

    has_remote_addr = music_copy_remote_addr(&address);
    if (has_remote_addr)
    {
        music_track_volume_echo(volume);
        bt_interface_avrcp_set_absolute_volume_as_ct_role_ext(&address, volume);
    }
#else
    int volume;

    has_remote_addr = music_copy_remote_addr(&address);
    if (!has_remote_addr)
        return;

    rt_mutex_take(&music_state_lock, RT_WAITING_FOREVER);
    volume = music_state.snapshot.volume_valid ? music_state.snapshot.volume : 64;
    volume += delta;
    if (volume < 0)
        volume = 0;
    else if (volume > 127)
        volume = 127;
    music_state.snapshot.volume = (uint8_t)volume;
    music_state.snapshot.volume_valid = 1;
    rt_mutex_release(&music_state_lock);

    bt_interface_avrcp_set_absolute_volume_as_ct_role_ext(&address,
                                                           (uint8_t)volume);
#endif
}
