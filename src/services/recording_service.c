#include "recording_service.h"

#include <stdint.h>
#include <string.h>

#include "audio_server.h"
#include "bf0_hal.h"
#include "dfs_file.h"
#include "dfs_posix.h"
#include "services/local_audio_arbiter.h"
#include "services/tf_card.h"

#define RECORDING_SAMPLE_RATE       16000UL
#define RECORDING_CHANNELS          1U
#define RECORDING_BITS_PER_SAMPLE   16U
#define RECORDING_WAV_HEADER_SIZE   44U
#define RECORDING_AUDIO_CACHE_SIZE  4096U
#define RECORDING_PLAY_CHUNK_SIZE   2048U
#define RECORDING_PLAY_STACK_SIZE   4096U
#define RECORDING_PLAY_SLICE_MS     10U
#define RECORDING_REMOVE_WAIT_MS    3000U

extern RTC_HandleTypeDef RTC_Handler;

typedef struct
{
    struct rt_mutex lock;
    struct rt_mutex operation_lock;
    recording_state_t state;
    audio_client_t record_client;
    int record_fd;
    volatile uint32_t record_data_bytes;
    volatile uint8_t record_write_failed;
    volatile uint8_t playback_stop_requested;
    rt_tick_t state_started_tick;
    uint32_t generation;
    char record_directory[RECORDING_PATH_LEN];
    char active_name[RECORDING_NAME_LEN];
    char active_path[RECORDING_PATH_LEN];
    char status[RECORDING_STATUS_LEN];
    rt_thread_t playback_thread;
    uint32_t playback_card_generation;
} recording_context_t;

static recording_context_t recording_ctx;
static uint8_t recording_initialized;
static uint8_t recording_play_buffer[RECORDING_AUDIO_CACHE_SIZE];

static void recording_tf_card_event(tf_card_event_t event, void *user_data);

static void recording_put_u16(uint8_t *buffer, uint16_t value)
{
    buffer[0] = (uint8_t)value;
    buffer[1] = (uint8_t)(value >> 8);
}

static void recording_put_u32(uint8_t *buffer, uint32_t value)
{
    buffer[0] = (uint8_t)value;
    buffer[1] = (uint8_t)(value >> 8);
    buffer[2] = (uint8_t)(value >> 16);
    buffer[3] = (uint8_t)(value >> 24);
}

static uint16_t recording_get_u16(const uint8_t *buffer)
{
    return (uint16_t)((uint16_t)buffer[0] | ((uint16_t)buffer[1] << 8));
}

static uint32_t recording_get_u32(const uint8_t *buffer)
{
    return (uint32_t)buffer[0] | ((uint32_t)buffer[1] << 8) |
           ((uint32_t)buffer[2] << 16) | ((uint32_t)buffer[3] << 24);
}

static void recording_make_wav_header(uint8_t *header, uint32_t data_bytes)
{
    uint32_t byte_rate = RECORDING_SAMPLE_RATE * RECORDING_CHANNELS *
                         (RECORDING_BITS_PER_SAMPLE / 8U);
    uint16_t block_align = RECORDING_CHANNELS *
                           (RECORDING_BITS_PER_SAMPLE / 8U);

    rt_memset(header, 0, RECORDING_WAV_HEADER_SIZE);
    rt_memcpy(&header[0], "RIFF", 4U);
    recording_put_u32(&header[4], 36U + data_bytes);
    rt_memcpy(&header[8], "WAVE", 4U);
    rt_memcpy(&header[12], "fmt ", 4U);
    recording_put_u32(&header[16], 16U);
    recording_put_u16(&header[20], 1U);
    recording_put_u16(&header[22], RECORDING_CHANNELS);
    recording_put_u32(&header[24], RECORDING_SAMPLE_RATE);
    recording_put_u32(&header[28], byte_rate);
    recording_put_u16(&header[32], block_align);
    recording_put_u16(&header[34], RECORDING_BITS_PER_SAMPLE);
    rt_memcpy(&header[36], "data", 4U);
    recording_put_u32(&header[40], data_bytes);
}

static void recording_set_status_locked(const char *status)
{
    strncpy(recording_ctx.status, status, sizeof(recording_ctx.status) - 1U);
    recording_ctx.status[sizeof(recording_ctx.status) - 1U] = '\0';
    recording_ctx.generation++;
}

static rt_err_t recording_prepare_directory(void)
{
    struct stat st;
    const char *root_path;

    if (tf_card_mount() != RT_EOK)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_set_status_locked(tf_card_status_text());
        rt_mutex_release(&recording_ctx.lock);
        return -RT_ERROR;
    }

    root_path = tf_card_root_path();
    if (strcmp(root_path, "/") == 0)
        rt_snprintf(recording_ctx.record_directory,
                    sizeof(recording_ctx.record_directory), "/record");
    else
        rt_snprintf(recording_ctx.record_directory,
                    sizeof(recording_ctx.record_directory), "%s/record",
                    root_path);

    if (stat(recording_ctx.record_directory, &st) == 0)
    {
        if (S_ISDIR(st.st_mode))
            return RT_EOK;
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_set_status_locked("Record path is not a folder");
        rt_mutex_release(&recording_ctx.lock);
        return -RT_ERROR;
    }

    if (mkdir(recording_ctx.record_directory, 0) != 0)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        rt_snprintf(recording_ctx.status, sizeof(recording_ctx.status),
                    "Create record folder failed: %d", rt_get_errno());
        recording_ctx.generation++;
        rt_mutex_release(&recording_ctx.lock);
        return -RT_ERROR;
    }
    return RT_EOK;
}

static void recording_make_file_name(char *name, size_t name_size,
                                     char *path, size_t path_size)
{
    RTC_TimeTypeDef time = {0};
    RTC_DateTypeDef date = {0};
    uint16_t suffix = 0U;

    (void)HAL_RTC_GetTime(&RTC_Handler, &time, RTC_FORMAT_BIN);
    (void)HAL_RTC_GetDate(&RTC_Handler, &date, RTC_FORMAT_BIN);
    do
    {
        if (suffix == 0U)
        {
            rt_snprintf(name, name_size, "REC_%04u%02u%02u_%02u%02u%02u.wav",
                        (unsigned int)(2000U + date.Year),
                        (unsigned int)date.Month, (unsigned int)date.Date,
                        (unsigned int)time.Hours, (unsigned int)time.Minutes,
                        (unsigned int)time.Seconds);
        }
        else
        {
            rt_snprintf(name, name_size,
                        "REC_%04u%02u%02u_%02u%02u%02u_%02u.wav",
                        (unsigned int)(2000U + date.Year),
                        (unsigned int)date.Month, (unsigned int)date.Date,
                        (unsigned int)time.Hours, (unsigned int)time.Minutes,
                        (unsigned int)time.Seconds, (unsigned int)suffix);
        }
        rt_snprintf(path, path_size, "%s/%s",
                    recording_ctx.record_directory, name);
        suffix++;
    } while (access(path, 0) == 0 && suffix < 100U);
}

static int recording_audio_callback(audio_server_callback_cmt_t cmd,
                                    void *callback_userdata,
                                    uint32_t reserved)
{
    (void)callback_userdata;

    if (cmd == as_callback_cmd_data_coming && recording_ctx.record_fd >= 0)
    {
        audio_server_coming_data_t *data =
            (audio_server_coming_data_t *)reserved;
        int written;

        if (!tf_card_is_mounted())
        {
            recording_ctx.record_write_failed = 1U;
            return 0;
        }
        written = write(recording_ctx.record_fd, data->data, data->data_len);

        if (written > 0)
            recording_ctx.record_data_bytes += (uint32_t)written;
        if (written != (int)data->data_len)
            recording_ctx.record_write_failed = 1U;
    }
    return 0;
}

static rt_err_t recording_read_wav_header(int fd, audio_parameter_t *params,
                                          uint32_t *data_bytes)
{
    uint8_t header[RECORDING_WAV_HEADER_SIZE];

    if (read(fd, header, sizeof(header)) != (int)sizeof(header) ||
        memcmp(&header[0], "RIFF", 4U) != 0 ||
        memcmp(&header[8], "WAVE", 4U) != 0 ||
        memcmp(&header[12], "fmt ", 4U) != 0 ||
        memcmp(&header[36], "data", 4U) != 0 ||
        recording_get_u16(&header[20]) != 1U)
        return -RT_ERROR;

    rt_memset(params, 0, sizeof(*params));
    params->write_channnel_num = (uint8_t)recording_get_u16(&header[22]);
    params->write_samplerate = recording_get_u32(&header[24]);
    params->write_bits_per_sample =
        (uint8_t)recording_get_u16(&header[34]);
    params->write_cache_size = RECORDING_AUDIO_CACHE_SIZE;
    params->read_channnel_num = params->write_channnel_num;
    params->read_samplerate = params->write_samplerate;
    params->read_bits_per_sample = params->write_bits_per_sample;
    params->read_cache_size = RECORDING_PLAY_CHUNK_SIZE;
    *data_bytes = recording_get_u32(&header[40]);

    if (params->write_channnel_num == 0U ||
        params->write_channnel_num > 2U ||
        params->write_samplerate < 8000U ||
        params->write_samplerate > 48000U ||
        params->write_bits_per_sample != 16U)
        return -RT_ERROR;
    return RT_EOK;
}

static void recording_playback_entry(void *parameter)
{
    audio_parameter_t params;
    audio_client_t client = RT_NULL;
    uint32_t data_remaining = 0U;
    uint32_t flush_ms = 0U;
    int fd = -1;
    uint8_t failed = 0U;
    uint8_t card_removed = 0U;

    (void)parameter;
    if (!tf_card_is_mounted() ||
        tf_card_generation() != recording_ctx.playback_card_generation)
    {
        card_removed = 1U;
        goto playback_done;
    }
    fd = open(recording_ctx.active_path, O_RDONLY | O_BINARY, 0);
    if (fd < 0 ||
        recording_read_wav_header(fd, &params, &data_remaining) != RT_EOK)
    {
        failed = 1U;
        goto playback_done;
    }

    client = audio_open(AUDIO_TYPE_LOCAL_MUSIC, AUDIO_TX, &params, RT_NULL,
                        RT_NULL);
    if (client == RT_NULL)
    {
        failed = 1U;
        goto playback_done;
    }

    while (data_remaining > 0U && !recording_ctx.playback_stop_requested)
    {
        uint32_t requested = data_remaining > RECORDING_PLAY_CHUNK_SIZE ?
                             RECORDING_PLAY_CHUNK_SIZE : data_remaining;
        int bytes;
        uint32_t offset = 0U;

        if (!tf_card_is_mounted() ||
            tf_card_generation() != recording_ctx.playback_card_generation)
        {
            card_removed = 1U;
            break;
        }
        bytes = read(fd, recording_play_buffer, requested);

        if (bytes <= 0)
        {
            failed = 1U;
            break;
        }
        data_remaining -= (uint32_t)bytes;
        while (offset < (uint32_t)bytes &&
               !recording_ctx.playback_stop_requested)
        {
            int written = audio_write(client, &recording_play_buffer[offset],
                                      (uint32_t)bytes - offset);

            if (written > 0)
                offset += (uint32_t)written;
            else if (written < -1)
            {
                failed = 1U;
                break;
            }
            else
                rt_thread_mdelay(RECORDING_PLAY_SLICE_MS);
        }
        if (failed)
            break;
    }

    if (!recording_ctx.playback_stop_requested && !failed && !card_removed)
    {
        (void)audio_ioctl(client, AUDIO_IOCTL_FLUSH_TIME_MS, &flush_ms);
        while (flush_ms > 0U && !recording_ctx.playback_stop_requested)
        {
            uint32_t wait_ms = flush_ms > 20U ? 20U : flush_ms;
            rt_thread_mdelay(wait_ms);
            flush_ms -= wait_ms;
        }
    }

playback_done:
    if (client != RT_NULL)
        audio_close(client);
    if (fd >= 0)
        close(fd);

    local_audio_arbiter_release(LOCAL_AUDIO_OWNER_RECORDING_PLAYBACK);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    recording_ctx.playback_thread = RT_NULL;
    recording_ctx.state = RECORDING_STATE_IDLE;
    recording_set_status_locked(card_removed ? "TF card removed" :
        (failed ? "Playback failed" :
        (recording_ctx.playback_stop_requested ? "Playback stopped" :
                                                 "Playback complete")));
    rt_mutex_release(&recording_ctx.lock);
}

void recording_service_init(void)
{
    if (recording_initialized)
        return;

    rt_memset(&recording_ctx, 0, sizeof(recording_ctx));
    rt_mutex_init(&recording_ctx.lock, "record", RT_IPC_FLAG_FIFO);
    rt_mutex_init(&recording_ctx.operation_lock, "record_op",
                  RT_IPC_FLAG_PRIO);
    recording_ctx.record_fd = -1;
    recording_ctx.state = RECORDING_STATE_IDLE;
    strcpy(recording_ctx.status, "Ready");
    recording_ctx.generation = 1U;
    recording_initialized = 1U;
    if (tf_card_register_listener(recording_tf_card_event, RT_NULL) != RT_EOK)
        rt_kprintf("recording: cannot register TF card listener\n");
}

void recording_service_get_snapshot(recording_snapshot_t *snapshot)
{
    rt_tick_t elapsed_ticks;

    if (snapshot == RT_NULL)
        return;
    recording_service_init();

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    rt_memset(snapshot, 0, sizeof(*snapshot));
    snapshot->state = recording_ctx.state;
    snapshot->data_bytes = recording_ctx.record_data_bytes;
    snapshot->generation = recording_ctx.generation;
    strncpy(snapshot->active_name, recording_ctx.active_name,
            sizeof(snapshot->active_name) - 1U);
    strncpy(snapshot->status, recording_ctx.status,
            sizeof(snapshot->status) - 1U);
    if (recording_ctx.state == RECORDING_STATE_RECORDING ||
        recording_ctx.state == RECORDING_STATE_PLAYING ||
        recording_ctx.state == RECORDING_STATE_STOPPING)
    {
        elapsed_ticks = rt_tick_get() - recording_ctx.state_started_tick;
        snapshot->elapsed_seconds = elapsed_ticks / RT_TICK_PER_SECOND;
    }
    rt_mutex_release(&recording_ctx.lock);
}

rt_err_t recording_service_start(void)
{
    audio_parameter_t params = {0};
    uint8_t header[RECORDING_WAV_HEADER_SIZE];
    char failure_status[RECORDING_STATUS_LEN] = "Start recording failed";
    audio_client_t client;
    int fd;
    rt_err_t result = -RT_ERROR;
    uint8_t audio_acquired = 0U;

    recording_service_init();
    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    if (recording_ctx.state != RECORDING_STATE_IDLE)
    {
        rt_mutex_release(&recording_ctx.lock);
        result = -RT_EBUSY;
        goto start_done;
    }
    recording_ctx.state = RECORDING_STATE_STARTING;
    recording_set_status_locked("Preparing TF storage");
    rt_mutex_release(&recording_ctx.lock);

    if (recording_prepare_directory() != RT_EOK)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_ctx.state = RECORDING_STATE_IDLE;
        recording_ctx.generation++;
        rt_mutex_release(&recording_ctx.lock);
        goto start_done;
    }

    if (local_audio_arbiter_acquire(LOCAL_AUDIO_OWNER_RECORDING) != RT_EOK)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_ctx.state = RECORDING_STATE_IDLE;
        recording_set_status_locked("Music playback is active");
        rt_mutex_release(&recording_ctx.lock);
        result = -RT_EBUSY;
        goto start_done;
    }
    audio_acquired = 1U;

    recording_make_file_name(recording_ctx.active_name,
                             sizeof(recording_ctx.active_name),
                             recording_ctx.active_path,
                             sizeof(recording_ctx.active_path));
    fd = open(recording_ctx.active_path,
              O_RDWR | O_CREAT | O_TRUNC | O_BINARY, 0);
    if (fd < 0)
    {
        rt_snprintf(failure_status, sizeof(failure_status),
                    "Create WAV failed: %d", rt_get_errno());
        goto start_failed;
    }

    recording_make_wav_header(header, 0U);
    if (write(fd, header, sizeof(header)) != (int)sizeof(header))
    {
        rt_snprintf(failure_status, sizeof(failure_status),
                    "Write WAV header failed: %d", rt_get_errno());
        close(fd);
        unlink(recording_ctx.active_path);
        goto start_failed;
    }

    recording_ctx.record_fd = fd;
    recording_ctx.record_data_bytes = 0U;
    recording_ctx.record_write_failed = 0U;
    params.write_bits_per_sample = RECORDING_BITS_PER_SAMPLE;
    params.write_channnel_num = RECORDING_CHANNELS;
    params.write_samplerate = RECORDING_SAMPLE_RATE;
    params.write_cache_size = RECORDING_AUDIO_CACHE_SIZE;
    params.read_bits_per_sample = RECORDING_BITS_PER_SAMPLE;
    params.read_channnel_num = RECORDING_CHANNELS;
    params.read_samplerate = RECORDING_SAMPLE_RATE;
    params.read_cache_size = RECORDING_PLAY_CHUNK_SIZE;
    client = audio_open(AUDIO_TYPE_LOCAL_RECORD, AUDIO_RX, &params,
                        recording_audio_callback, RT_NULL);
    if (client == RT_NULL)
    {
        rt_snprintf(failure_status, sizeof(failure_status),
                    "Open microphone failed");
        close(fd);
        recording_ctx.record_fd = -1;
        unlink(recording_ctx.active_path);
        goto start_failed;
    }

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    recording_ctx.record_client = client;
    recording_ctx.state_started_tick = rt_tick_get();
    recording_ctx.state = RECORDING_STATE_RECORDING;
    recording_set_status_locked("Recording");
    rt_mutex_release(&recording_ctx.lock);
    result = RT_EOK;
    goto start_done;

start_failed:
    if (audio_acquired)
        local_audio_arbiter_release(LOCAL_AUDIO_OWNER_RECORDING);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    recording_ctx.state = RECORDING_STATE_IDLE;
    recording_set_status_locked(failure_status);
    rt_mutex_release(&recording_ctx.lock);

start_done:
    rt_mutex_release(&recording_ctx.operation_lock);
    return result;
}

static rt_err_t recording_stop_capture(void)
{
    audio_client_t client;
    uint8_t header[RECORDING_WAV_HEADER_SIZE];
    uint32_t data_bytes;
    int fd;
    uint8_t failed;

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    if (recording_ctx.state != RECORDING_STATE_RECORDING)
    {
        rt_mutex_release(&recording_ctx.lock);
        return -RT_ERROR;
    }
    recording_ctx.state = RECORDING_STATE_STOPPING;
    recording_set_status_locked("Saving recording");
    client = recording_ctx.record_client;
    rt_mutex_release(&recording_ctx.lock);

    failed = audio_close(client) != 0 ? 1U : 0U;
    recording_ctx.record_client = RT_NULL;
    fd = recording_ctx.record_fd;
    recording_ctx.record_fd = -1;
    data_bytes = recording_ctx.record_data_bytes;
    if (recording_ctx.record_write_failed)
        failed = 1U;
    if (!tf_card_is_mounted() || fd < 0)
    {
        failed = 1U;
        if (fd >= 0)
            (void)close(fd);
    }
    else
    {
        recording_make_wav_header(header, data_bytes);
        if (lseek(fd, 0, SEEK_SET) < 0)
            failed = 1U;
        else if (write(fd, header, sizeof(header)) != (int)sizeof(header))
            failed = 1U;
        if (fsync(fd) != 0)
            failed = 1U;
        if (close(fd) != 0)
            failed = 1U;
    }

    if (data_bytes == 0U && tf_card_is_mounted())
    {
        unlink(recording_ctx.active_path);
        failed = 1U;
    }

    local_audio_arbiter_release(LOCAL_AUDIO_OWNER_RECORDING);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    recording_ctx.state = RECORDING_STATE_IDLE;
    recording_set_status_locked(failed ? "Recording save failed" :
                                          "Recording saved");
    rt_mutex_release(&recording_ctx.lock);
    return failed ? -RT_ERROR : RT_EOK;
}

rt_err_t recording_service_stop(void)
{
    recording_state_t state;
    rt_err_t result;

    recording_service_init();
    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    state = recording_ctx.state;
    if (state == RECORDING_STATE_PLAYING)
    {
        recording_ctx.playback_stop_requested = 1U;
        recording_ctx.state = RECORDING_STATE_STOPPING;
        recording_set_status_locked("Stopping playback");
    }
    rt_mutex_release(&recording_ctx.lock);

    if (state == RECORDING_STATE_RECORDING)
        result = recording_stop_capture();
    else if (state == RECORDING_STATE_PLAYING ||
             state == RECORDING_STATE_STOPPING)
        result = RT_EOK;
    else
        result = -RT_ERROR;
    rt_mutex_release(&recording_ctx.operation_lock);
    return result;
}

rt_err_t recording_service_play(const char *path)
{
    const char *name;
    rt_err_t result = -RT_ERROR;

    if (path == RT_NULL)
        return -RT_EINVAL;
    recording_service_init();
    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    if (recording_prepare_directory() != RT_EOK ||
        strncmp(path, recording_ctx.record_directory,
                strlen(recording_ctx.record_directory)) != 0 ||
        path[strlen(recording_ctx.record_directory)] != '/')
        goto play_done;

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    if (recording_ctx.state != RECORDING_STATE_IDLE)
    {
        rt_mutex_release(&recording_ctx.lock);
        result = -RT_EBUSY;
        goto play_done;
    }
    rt_mutex_release(&recording_ctx.lock);
    if (local_audio_arbiter_acquire(
            LOCAL_AUDIO_OWNER_RECORDING_PLAYBACK) != RT_EOK)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_set_status_locked("Music playback is active");
        rt_mutex_release(&recording_ctx.lock);
        result = -RT_EBUSY;
        goto play_done;
    }

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    strncpy(recording_ctx.active_path, path,
            sizeof(recording_ctx.active_path) - 1U);
    recording_ctx.active_path[sizeof(recording_ctx.active_path) - 1U] = '\0';
    name = strrchr(recording_ctx.active_path, '/');
    strncpy(recording_ctx.active_name, name != RT_NULL ? name + 1 : path,
            sizeof(recording_ctx.active_name) - 1U);
    recording_ctx.active_name[sizeof(recording_ctx.active_name) - 1U] = '\0';
    recording_ctx.playback_stop_requested = 0U;
    recording_ctx.playback_card_generation = tf_card_generation();
    recording_ctx.state_started_tick = rt_tick_get();
    recording_ctx.state = RECORDING_STATE_PLAYING;
    recording_set_status_locked("Playing");
    recording_ctx.playback_thread =
        rt_thread_create("recplay", recording_playback_entry, RT_NULL,
                         RECORDING_PLAY_STACK_SIZE, RT_THREAD_PRIORITY_HIGH,
                         RT_THREAD_TICK_DEFAULT);
    if (recording_ctx.playback_thread == RT_NULL)
    {
        recording_ctx.state = RECORDING_STATE_IDLE;
        recording_set_status_locked("Playback thread failed");
        rt_mutex_release(&recording_ctx.lock);
        local_audio_arbiter_release(LOCAL_AUDIO_OWNER_RECORDING_PLAYBACK);
        result = -RT_ENOMEM;
        goto play_done;
    }
    rt_thread_startup(recording_ctx.playback_thread);
    rt_mutex_release(&recording_ctx.lock);
    result = RT_EOK;

play_done:
    rt_mutex_release(&recording_ctx.operation_lock);
    return result;
}

static uint8_t recording_is_wav_name(const char *name)
{
    size_t length = strlen(name);

    return length > 4U && strcmp(&name[length - 4U], ".wav") == 0;
}

static uint32_t recording_file_duration(const char *path)
{
    audio_parameter_t params;
    uint32_t data_bytes = 0U;
    uint32_t byte_rate;
    int fd = open(path, O_RDONLY | O_BINARY, 0);

    if (fd < 0 || recording_read_wav_header(fd, &params, &data_bytes) != RT_EOK)
    {
        if (fd >= 0)
            close(fd);
        return 0U;
    }
    close(fd);
    byte_rate = params.write_samplerate * params.write_channnel_num *
                (params.write_bits_per_sample / 8U);
    return byte_rate == 0U ? 0U : data_bytes / byte_rate;
}

int recording_service_list(recording_entry_t *entries, uint16_t max_entries)
{
    DIR *directory;
    struct dirent *item;
    uint16_t count = 0U;
    uint16_t i;
    uint16_t j;

    if (entries == RT_NULL || max_entries == 0U)
        return 0;
    recording_service_init();
    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    if (recording_prepare_directory() != RT_EOK)
    {
        rt_mutex_release(&recording_ctx.operation_lock);
        return -1;
    }

    directory = opendir(recording_ctx.record_directory);
    if (directory == RT_NULL)
    {
        rt_mutex_release(&recording_ctx.operation_lock);
        return -1;
    }
    while (tf_card_is_mounted() &&
           (item = readdir(directory)) != RT_NULL && count < max_entries)
    {
        struct stat st;
        recording_entry_t *entry;

        if (!recording_is_wav_name(item->d_name))
            continue;
        entry = &entries[count];
        rt_memset(entry, 0, sizeof(*entry));
        strncpy(entry->name, item->d_name, sizeof(entry->name) - 1U);
        rt_snprintf(entry->path, sizeof(entry->path), "%s/%s",
                    recording_ctx.record_directory, entry->name);
        if (stat(entry->path, &st) == 0)
            entry->size_bytes = (uint32_t)st.st_size;
        entry->duration_seconds = recording_file_duration(entry->path);
        count++;
    }
    closedir(directory);

    if (!tf_card_is_mounted())
    {
        rt_mutex_release(&recording_ctx.operation_lock);
        return -1;
    }

    for (i = 0U; i < count; i++)
    {
        for (j = (uint16_t)(i + 1U); j < count; j++)
        {
            if (strcmp(entries[i].name, entries[j].name) < 0)
            {
                recording_entry_t temporary = entries[i];
                entries[i] = entries[j];
                entries[j] = temporary;
            }
        }
    }
    rt_mutex_release(&recording_ctx.operation_lock);
    return (int)count;
}

rt_err_t recording_service_delete(const char *path)
{
    const char *name;
    size_t directory_length;
    rt_err_t result = -RT_ERROR;

    if (path == RT_NULL)
        return -RT_EINVAL;
    recording_service_init();
    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    if (recording_prepare_directory() != RT_EOK)
        goto delete_done;

    directory_length = strlen(recording_ctx.record_directory);
    if (strncmp(path, recording_ctx.record_directory, directory_length) != 0 ||
        path[directory_length] != '/')
        goto delete_done;
    name = path + directory_length + 1U;
    if (name[0] == '\0' || strchr(name, '/') != RT_NULL ||
        strstr(name, "..") != RT_NULL || !recording_is_wav_name(name))
        goto delete_done;

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    if (recording_ctx.state != RECORDING_STATE_IDLE)
    {
        recording_set_status_locked("Stop recording or playback first");
        rt_mutex_release(&recording_ctx.lock);
        result = -RT_EBUSY;
        goto delete_done;
    }
    rt_mutex_release(&recording_ctx.lock);

    rt_set_errno(0);
    if (unlink(path) != 0)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        rt_snprintf(recording_ctx.status, sizeof(recording_ctx.status),
                    "Delete failed: %d", rt_get_errno());
        recording_ctx.generation++;
        rt_mutex_release(&recording_ctx.lock);
        goto delete_done;
    }

    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    recording_set_status_locked("Recording deleted");
    rt_mutex_release(&recording_ctx.lock);
    rt_kprintf("recording: deleted %s\n", path);
    result = RT_EOK;

delete_done:
    rt_mutex_release(&recording_ctx.operation_lock);
    return result;
}

static void recording_tf_card_event(tf_card_event_t event, void *user_data)
{
    recording_state_t state;
    audio_client_t client = RT_NULL;
    int fd = -1;
    uint32_t waited_ms = 0U;

    (void)user_data;
    if (!recording_initialized)
        return;

    if (event == TF_CARD_EVENT_MOUNTED)
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        if (recording_ctx.state == RECORDING_STATE_IDLE)
            recording_set_status_locked("Ready");
        rt_mutex_release(&recording_ctx.lock);
        return;
    }
    if (event != TF_CARD_EVENT_REMOVING)
        return;

    rt_mutex_take(&recording_ctx.operation_lock, RT_WAITING_FOREVER);
    rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
    state = recording_ctx.state;
    if (state == RECORDING_STATE_RECORDING)
    {
        recording_ctx.state = RECORDING_STATE_STOPPING;
        recording_set_status_locked("TF card removed");
        client = recording_ctx.record_client;
    }
    else if (state == RECORDING_STATE_PLAYING ||
             state == RECORDING_STATE_STOPPING)
    {
        recording_ctx.playback_stop_requested = 1U;
    }
    rt_mutex_release(&recording_ctx.lock);

    if (state == RECORDING_STATE_RECORDING)
    {
        if (client != RT_NULL)
            (void)audio_close(client);
        recording_ctx.record_client = RT_NULL;
        fd = recording_ctx.record_fd;
        recording_ctx.record_fd = -1;
        if (fd >= 0)
            (void)close(fd);
        local_audio_arbiter_release(LOCAL_AUDIO_OWNER_RECORDING);

        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_ctx.state = RECORDING_STATE_IDLE;
        recording_set_status_locked("TF card removed");
        rt_mutex_release(&recording_ctx.lock);
        rt_kprintf("recording: capture aborted after TF removal\n");
    }
    else if (state == RECORDING_STATE_PLAYING ||
             state == RECORDING_STATE_STOPPING)
    {
        while (waited_ms < RECORDING_REMOVE_WAIT_MS)
        {
            rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
            if (recording_ctx.playback_thread == RT_NULL)
            {
                rt_mutex_release(&recording_ctx.lock);
                break;
            }
            rt_mutex_release(&recording_ctx.lock);
            rt_thread_mdelay(RECORDING_PLAY_SLICE_MS);
            waited_ms += RECORDING_PLAY_SLICE_MS;
        }
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_set_status_locked("TF card removed");
        rt_mutex_release(&recording_ctx.lock);
        if (waited_ms >= RECORDING_REMOVE_WAIT_MS)
            rt_kprintf("recording: playback stop timed out on TF removal\n");
    }
    else
    {
        rt_mutex_take(&recording_ctx.lock, RT_WAITING_FOREVER);
        recording_set_status_locked("TF card removed");
        rt_mutex_release(&recording_ctx.lock);
    }
    rt_mutex_release(&recording_ctx.operation_lock);
}
