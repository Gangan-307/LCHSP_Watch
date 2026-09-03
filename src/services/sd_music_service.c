#include "sd_music_service.h"

#include <stdint.h>
#include <string.h>

#include "audio_mp3ctrl.h"
#include "audio_server.h"
#include "dfs_file.h"
#include "dfs_posix.h"
#include "services/local_audio_arbiter.h"
#include "services/tf_card.h"

#define SD_MUSIC_MAX_TRACKS       64U
#define SD_MUSIC_PATH_LEN         192U
#define SD_MUSIC_QUEUE_DEPTH      12U
#define SD_MUSIC_WORKER_STACK     4096U
#define SD_MUSIC_MP3_SCAN_LIMIT   (64U * 1024U)
#define SD_MUSIC_MP3_READ_SIZE    512U

typedef struct
{
    char name[SD_MUSIC_TITLE_LEN];
    char path[SD_MUSIC_PATH_LEN];
} sd_music_track_t;

typedef enum
{
    SD_MUSIC_COMMAND_REFRESH,
    SD_MUSIC_COMMAND_TOGGLE,
    SD_MUSIC_COMMAND_PREVIOUS,
    SD_MUSIC_COMMAND_NEXT,
    SD_MUSIC_COMMAND_STOP,
    SD_MUSIC_COMMAND_AUTO_NEXT,
} sd_music_command_type_t;

typedef struct
{
    sd_music_command_type_t type;
    uint32_t session;
} sd_music_command_t;

typedef struct
{
    struct rt_mutex lock;
    struct rt_mutex operation_lock;
    rt_mq_t command_queue;
    rt_thread_t worker;
    mp3ctrl_handle player;
    sd_music_snapshot_t snapshot;
    sd_music_track_t tracks[SD_MUSIC_MAX_TRACKS];
    uint32_t active_session;
    char music_directory[SD_MUSIC_PATH_LEN];
    uint8_t owns_audio;
} sd_music_context_t;

static sd_music_context_t sd_music_ctx;
static uint8_t sd_music_initialized;

static void sd_music_set_status_locked(const char *status)
{
    strncpy(sd_music_ctx.snapshot.status, status,
            sizeof(sd_music_ctx.snapshot.status) - 1U);
    sd_music_ctx.snapshot.status[sizeof(sd_music_ctx.snapshot.status) - 1U] =
        '\0';
    sd_music_ctx.snapshot.generation++;
}

static void sd_music_set_error(const char *status)
{
    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_ERROR;
    sd_music_set_status_locked(status);
    rt_mutex_release(&sd_music_ctx.lock);
}

static char sd_music_ascii_lower(char value)
{
    if (value >= 'A' && value <= 'Z')
        return (char)(value + ('a' - 'A'));
    return value;
}

static uint8_t sd_music_has_extension(const char *name, const char *extension)
{
    size_t name_length = strlen(name);
    size_t extension_length = strlen(extension);
    size_t index;

    if (name_length <= extension_length)
        return 0U;
    for (index = 0U; index < extension_length; index++)
    {
        if (sd_music_ascii_lower(name[name_length - extension_length + index]) !=
            extension[index])
            return 0U;
    }
    return 1U;
}

static uint8_t sd_music_is_audio_file(const char *name)
{
    if (name[0] == '.' || strncmp(name, "._", 2U) == 0)
        return 0U;
    return sd_music_has_extension(name, ".mp3") ||
           sd_music_has_extension(name, ".wav");
}

static uint32_t sd_music_mp3_bitrate(uint32_t header)
{
    static const uint16_t mpeg1_layer3_kbps[16] =
    {
        0U, 32U, 40U, 48U, 56U, 64U, 80U, 96U,
        112U, 128U, 160U, 192U, 224U, 256U, 320U, 0U
    };
    static const uint16_t mpeg2_layer3_kbps[16] =
    {
        0U, 8U, 16U, 24U, 32U, 40U, 48U, 56U,
        64U, 80U, 96U, 112U, 128U, 144U, 160U, 0U
    };
    uint8_t version = (uint8_t)((header >> 19) & 0x03U);
    uint8_t layer = (uint8_t)((header >> 17) & 0x03U);
    uint8_t bitrate_index = (uint8_t)((header >> 12) & 0x0FU);
    uint8_t sample_rate_index = (uint8_t)((header >> 10) & 0x03U);

    if ((header & 0xFFE00000UL) != 0xFFE00000UL ||
        version == 1U || layer != 1U || sample_rate_index == 3U ||
        bitrate_index == 0U || bitrate_index == 15U)
        return 0U;
    return (version == 3U ? mpeg1_layer3_kbps[bitrate_index] :
                            mpeg2_layer3_kbps[bitrate_index]) * 1000U;
}

static rt_err_t sd_music_probe_mp3(const char *path, uint32_t *duration)
{
    struct stat file_stat;
    uint8_t buffer[SD_MUSIC_MP3_READ_SIZE];
    uint32_t data_offset = 0U;
    uint32_t header = 0U;
    uint32_t scanned = 0U;
    uint32_t bitrate = 0U;
    int file;
    int bytes_read;
    uint16_t index;

    *duration = 0U;
    if (stat(path, &file_stat) != 0 || file_stat.st_size < 4)
        return -RT_EINVAL;

    file = open(path, O_RDONLY | O_BINARY);
    if (file < 0)
        return -RT_EIO;

    bytes_read = read(file, buffer, 10U);
    if (bytes_read >= 3 && memcmp(buffer, "ID3", 3U) == 0)
    {
        if (bytes_read != 10 || (buffer[6] & 0x80U) != 0U ||
            (buffer[7] & 0x80U) != 0U || (buffer[8] & 0x80U) != 0U ||
            (buffer[9] & 0x80U) != 0U)
            goto invalid_file;
        data_offset = 10U + ((uint32_t)buffer[6] << 21) +
                      ((uint32_t)buffer[7] << 14) +
                      ((uint32_t)buffer[8] << 7) + buffer[9];
        if (data_offset > (uint32_t)file_stat.st_size - 4U)
            goto invalid_file;
    }

    if (lseek(file, (off_t)data_offset, SEEK_SET) < 0)
        goto read_error;

    while (scanned < SD_MUSIC_MP3_SCAN_LIMIT &&
           (bytes_read = read(file, buffer, sizeof(buffer))) > 0)
    {
        for (index = 0U; index < (uint16_t)bytes_read; index++)
        {
            header = (header << 8) | buffer[index];
            if (scanned + index >= 3U)
            {
                bitrate = sd_music_mp3_bitrate(header);
                if (bitrate != 0U)
                {
                    uint32_t audio_bytes = (uint32_t)file_stat.st_size -
                                           data_offset;
                    *duration = (uint32_t)(((uint64_t)audio_bytes * 8U) /
                                           bitrate);
                    close(file);
                    rt_kprintf("sd_music: MP3 checked, size=%u, id3=%u, "
                               "bitrate=%u, duration=%us\n",
                               (unsigned int)file_stat.st_size,
                               (unsigned int)data_offset,
                               (unsigned int)bitrate,
                               (unsigned int)*duration);
                    return RT_EOK;
                }
            }
        }
        scanned += (uint32_t)bytes_read;
    }
    if (bytes_read < 0)
        goto read_error;

invalid_file:
    close(file);
    rt_kprintf("sd_music: invalid MP3 or MPEG frame not found: %s\n", path);
    return -RT_EINVAL;

read_error:
    close(file);
    rt_kprintf("sd_music: MP3 read failed, errno=%d: %s\n",
               rt_get_errno(), path);
    return -RT_EIO;
}

static rt_err_t sd_music_prepare_directory(void)
{
    const char *root_path;
    struct stat st;
    char status[SD_MUSIC_STATUS_LEN];

    if (tf_card_mount() != RT_EOK)
    {
        sd_music_set_error(tf_card_status_text());
        return -RT_ERROR;
    }

    root_path = tf_card_root_path();
    if (strcmp(root_path, "/") == 0)
        rt_snprintf(sd_music_ctx.music_directory,
                    sizeof(sd_music_ctx.music_directory), "/music");
    else
        rt_snprintf(sd_music_ctx.music_directory,
                    sizeof(sd_music_ctx.music_directory), "%s/music",
                    root_path);

    if (stat(sd_music_ctx.music_directory, &st) == 0)
    {
        if (S_ISDIR(st.st_mode))
            return RT_EOK;
        sd_music_set_error("music路径不是文件夹");
        return -RT_ERROR;
    }

    if (mkdir(sd_music_ctx.music_directory, 0) != 0)
    {
        rt_snprintf(status, sizeof(status), "创建music文件夹失败: %d",
                    rt_get_errno());
        sd_music_set_error(status);
        return -RT_ERROR;
    }
    return RT_EOK;
}

static void sd_music_close_player(void)
{
    mp3ctrl_handle player;
    uint8_t owns_audio;

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    player = sd_music_ctx.player;
    sd_music_ctx.player = RT_NULL;
    owns_audio = sd_music_ctx.owns_audio;
    sd_music_ctx.owns_audio = 0U;
    sd_music_ctx.active_session++;
    sd_music_ctx.snapshot.position_seconds = 0U;
    rt_mutex_release(&sd_music_ctx.lock);

    if (player != RT_NULL)
        (void)mp3ctrl_close(player);
    if (owns_audio)
        local_audio_arbiter_release(LOCAL_AUDIO_OWNER_SD_MUSIC);
}

static void sd_music_sort_tracks(uint16_t count)
{
    uint16_t i;
    uint16_t j;

    for (i = 0U; i < count; i++)
    {
        for (j = (uint16_t)(i + 1U); j < count; j++)
        {
            if (strcmp(sd_music_ctx.tracks[i].name,
                       sd_music_ctx.tracks[j].name) > 0)
            {
                sd_music_track_t temporary = sd_music_ctx.tracks[i];
                sd_music_ctx.tracks[i] = sd_music_ctx.tracks[j];
                sd_music_ctx.tracks[j] = temporary;
            }
        }
    }
}

static rt_err_t sd_music_scan_tracks(void)
{
    DIR *directory;
    struct dirent *item;
    uint16_t count = 0U;

    sd_music_close_player();
    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_LOADING;
    sd_music_set_status_locked("正在扫描TF卡");
    rt_mutex_release(&sd_music_ctx.lock);

    if (sd_music_prepare_directory() != RT_EOK)
        return -RT_ERROR;

    directory = opendir(sd_music_ctx.music_directory);
    if (directory == RT_NULL)
    {
        sd_music_set_error("无法打开music文件夹");
        return -RT_ERROR;
    }

    while ((item = readdir(directory)) != RT_NULL &&
           count < SD_MUSIC_MAX_TRACKS)
    {
        struct stat st;
        sd_music_track_t *track;

        if (!sd_music_is_audio_file(item->d_name))
            continue;
        track = &sd_music_ctx.tracks[count];
        rt_memset(track, 0, sizeof(*track));
        strncpy(track->name, item->d_name, sizeof(track->name) - 1U);
        rt_snprintf(track->path, sizeof(track->path), "%s/%s",
                    sd_music_ctx.music_directory, track->name);
        if (stat(track->path, &st) != 0 || S_ISDIR(st.st_mode))
            continue;
        count++;
    }
    closedir(directory);
    sd_music_sort_tracks(count);

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.snapshot.track_count = count;
    sd_music_ctx.snapshot.track_index = 0U;
    sd_music_ctx.snapshot.position_seconds = 0U;
    sd_music_ctx.snapshot.duration_seconds = 0U;
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_IDLE;
    if (count == 0U)
    {
        strcpy(sd_music_ctx.snapshot.title, "TF卡音乐");
        sd_music_set_status_locked("music文件夹中没有MP3/WAV");
    }
    else
    {
        strncpy(sd_music_ctx.snapshot.title, sd_music_ctx.tracks[0].name,
                sizeof(sd_music_ctx.snapshot.title) - 1U);
        sd_music_ctx.snapshot.title[
            sizeof(sd_music_ctx.snapshot.title) - 1U] = '\0';
        rt_snprintf(sd_music_ctx.snapshot.status,
                    sizeof(sd_music_ctx.snapshot.status),
                    "已找到 %u 首音乐", (unsigned int)count);
        sd_music_ctx.snapshot.generation++;
    }
    rt_mutex_release(&sd_music_ctx.lock);
    return RT_EOK;
}

static int sd_music_player_callback(audio_server_callback_cmt_t command,
                                    void *callback_userdata,
                                    uint32_t reserved)
{
    uint32_t session = (uint32_t)(uintptr_t)callback_userdata;

    if (command == as_callback_cmd_play_to_end)
    {
        sd_music_command_t event = {SD_MUSIC_COMMAND_AUTO_NEXT, session};

        if (sd_music_ctx.command_queue != RT_NULL &&
            rt_mq_send(sd_music_ctx.command_queue, &event,
                       sizeof(event)) != RT_EOK)
            rt_kprintf("sd_music: auto-next queue is full\n");
    }
    else if (command == as_callback_cmd_user)
    {
        rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
        if (session == sd_music_ctx.active_session)
        {
            sd_music_ctx.snapshot.position_seconds = reserved;
            sd_music_ctx.snapshot.generation++;
        }
        rt_mutex_release(&sd_music_ctx.lock);
    }
    else if (command == as_callback_cmd_suspended ||
             command == as_callback_cmd_resumed)
    {
        rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
        if (session == sd_music_ctx.active_session)
            sd_music_set_status_locked(command == as_callback_cmd_suspended ?
                                       "音频通道暂时被占用" : "继续播放");
        rt_mutex_release(&sd_music_ctx.lock);
    }
    return 0;
}

static rt_err_t sd_music_play_current(void)
{
    mp3_info_t info = {0};
    mp3ctrl_handle player;
    uint16_t index;
    uint32_t session;

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    if (sd_music_ctx.snapshot.track_count == 0U)
    {
        sd_music_set_status_locked("music文件夹中没有MP3/WAV");
        rt_mutex_release(&sd_music_ctx.lock);
        return -RT_ERROR;
    }
    index = sd_music_ctx.snapshot.track_index;
    rt_mutex_release(&sd_music_ctx.lock);

    sd_music_close_player();
    if (!tf_card_is_mounted())
    {
        sd_music_set_error("TF卡未插入");
        return -RT_ERROR;
    }
    if (sd_music_has_extension(sd_music_ctx.tracks[index].name, ".mp3"))
    {
        if (sd_music_probe_mp3(sd_music_ctx.tracks[index].path,
                               &info.total_time_in_seconds) != RT_EOK)
        {
            sd_music_set_error("MP3文件格式错误");
            return -RT_EINVAL;
        }
    }
    else if (mp3ctrl_getinfo(sd_music_ctx.tracks[index].path, &info) != 0)
    {
        sd_music_set_error("WAV文件格式错误");
        return -RT_EINVAL;
    }

    if (local_audio_arbiter_acquire(LOCAL_AUDIO_OWNER_SD_MUSIC) != RT_EOK)
    {
        sd_music_set_error("录音正在使用音频");
        return -RT_EBUSY;
    }
    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.owns_audio = 1U;
    rt_mutex_release(&sd_music_ctx.lock);

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    session = ++sd_music_ctx.active_session;
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_LOADING;
    sd_music_ctx.snapshot.position_seconds = 0U;
    sd_music_ctx.snapshot.duration_seconds = info.total_time_in_seconds;
    strncpy(sd_music_ctx.snapshot.title, sd_music_ctx.tracks[index].name,
            sizeof(sd_music_ctx.snapshot.title) - 1U);
    sd_music_ctx.snapshot.title[sizeof(sd_music_ctx.snapshot.title) - 1U] =
        '\0';
    sd_music_set_status_locked("正在打开音乐");
    rt_mutex_release(&sd_music_ctx.lock);

    rt_kprintf("sd_music: opening decoder: %s\n",
               sd_music_ctx.tracks[index].path);

    player = mp3ctrl_open(AUDIO_TYPE_LOCAL_MUSIC,
                          sd_music_ctx.tracks[index].path,
                          sd_music_player_callback,
                          (void *)(uintptr_t)session);
    if (player == RT_NULL)
    {
        sd_music_close_player();
        sd_music_set_error("音乐文件无法解码");
        return -RT_ERROR;
    }

    rt_kprintf("sd_music: decoder opened\n");

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.player = player;
    rt_mutex_release(&sd_music_ctx.lock);
    if (mp3ctrl_play(player) != 0)
    {
        sd_music_close_player();
        sd_music_set_error("播放启动失败");
        return -RT_ERROR;
    }

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    if (session == sd_music_ctx.active_session)
    {
        sd_music_ctx.snapshot.state = SD_MUSIC_STATE_PLAYING;
        sd_music_set_status_locked("正在播放TF卡音乐");
    }
    rt_mutex_release(&sd_music_ctx.lock);
    return RT_EOK;
}

static void sd_music_toggle(void)
{
    sd_music_state_t state;
    mp3ctrl_handle player;
    int result;

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    state = sd_music_ctx.snapshot.state;
    player = sd_music_ctx.player;
    rt_mutex_release(&sd_music_ctx.lock);

    if (state == SD_MUSIC_STATE_PLAYING && player != RT_NULL)
    {
        result = mp3ctrl_pause(player);
        rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
        if (result == 0)
        {
            sd_music_ctx.snapshot.state = SD_MUSIC_STATE_PAUSED;
            sd_music_set_status_locked("已暂停");
        }
        else
            sd_music_set_status_locked("暂停失败");
        rt_mutex_release(&sd_music_ctx.lock);
    }
    else if (state == SD_MUSIC_STATE_PAUSED && player != RT_NULL)
    {
        result = mp3ctrl_resume(player);
        rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
        if (result == 0)
        {
            sd_music_ctx.snapshot.state = SD_MUSIC_STATE_PLAYING;
            sd_music_set_status_locked("正在播放TF卡音乐");
        }
        else
            sd_music_set_status_locked("继续播放失败");
        rt_mutex_release(&sd_music_ctx.lock);
    }
    else if (state != SD_MUSIC_STATE_LOADING)
        (void)sd_music_play_current();
}

static void sd_music_change_track(int direction)
{
    uint16_t count;
    uint16_t index;

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    count = sd_music_ctx.snapshot.track_count;
    index = sd_music_ctx.snapshot.track_index;
    if (count > 0U)
    {
        if (direction > 0)
            index = (uint16_t)((index + 1U) % count);
        else
            index = index == 0U ? (uint16_t)(count - 1U) :
                                  (uint16_t)(index - 1U);
        sd_music_ctx.snapshot.track_index = index;
    }
    rt_mutex_release(&sd_music_ctx.lock);

    if (count > 0U)
        (void)sd_music_play_current();
}

static void sd_music_stop_internal(void)
{
    sd_music_close_player();
    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_IDLE;
    sd_music_set_status_locked("已停止");
    rt_mutex_release(&sd_music_ctx.lock);
}

static void sd_music_worker_entry(void *parameter)
{
    sd_music_command_t command;

    (void)parameter;
    while (1)
    {
        if (rt_mq_recv(sd_music_ctx.command_queue, &command, sizeof(command),
                       RT_WAITING_FOREVER) != RT_EOK)
            continue;

        rt_mutex_take(&sd_music_ctx.operation_lock, RT_WAITING_FOREVER);
        switch (command.type)
        {
        case SD_MUSIC_COMMAND_REFRESH:
            (void)sd_music_scan_tracks();
            break;
        case SD_MUSIC_COMMAND_TOGGLE:
            sd_music_toggle();
            break;
        case SD_MUSIC_COMMAND_PREVIOUS:
            sd_music_change_track(-1);
            break;
        case SD_MUSIC_COMMAND_NEXT:
            sd_music_change_track(1);
            break;
        case SD_MUSIC_COMMAND_STOP:
            sd_music_stop_internal();
            break;
        case SD_MUSIC_COMMAND_AUTO_NEXT:
            rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
            if (command.session != sd_music_ctx.active_session)
            {
                rt_mutex_release(&sd_music_ctx.lock);
                break;
            }
            rt_mutex_release(&sd_music_ctx.lock);
            sd_music_change_track(1);
            break;
        default:
            break;
        }
        rt_mutex_release(&sd_music_ctx.operation_lock);
    }
}

static void sd_music_tf_card_event(tf_card_event_t event, void *user_data)
{
    sd_music_command_t refresh = {SD_MUSIC_COMMAND_REFRESH, 0U};

    (void)user_data;
    if (!sd_music_initialized)
        return;

    if (event == TF_CARD_EVENT_REMOVING)
    {
        rt_mutex_take(&sd_music_ctx.operation_lock, RT_WAITING_FOREVER);
        sd_music_close_player();
        rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
        sd_music_ctx.snapshot.track_count = 0U;
        sd_music_ctx.snapshot.track_index = 0U;
        sd_music_ctx.snapshot.duration_seconds = 0U;
        sd_music_ctx.snapshot.state = SD_MUSIC_STATE_ERROR;
        strcpy(sd_music_ctx.snapshot.title, "TF卡音乐");
        sd_music_set_status_locked("TF卡已拔出，播放已停止");
        rt_mutex_release(&sd_music_ctx.lock);
        rt_mutex_release(&sd_music_ctx.operation_lock);
        rt_kprintf("sd_music: stopped for TF card removal\n");
    }
    else if (event == TF_CARD_EVENT_MOUNTED &&
             sd_music_ctx.command_queue != RT_NULL)
    {
        (void)rt_mq_send(sd_music_ctx.command_queue, &refresh,
                         sizeof(refresh));
    }
}

void sd_music_service_init(void)
{
    uint8_t max_volume;
    uint8_t volume;

    if (sd_music_initialized)
        return;
    rt_memset(&sd_music_ctx, 0, sizeof(sd_music_ctx));
    rt_mutex_init(&sd_music_ctx.lock, "sdmusic", RT_IPC_FLAG_FIFO);
    rt_mutex_init(&sd_music_ctx.operation_lock, "sdmusic_op",
                  RT_IPC_FLAG_PRIO);
    sd_music_ctx.snapshot.state = SD_MUSIC_STATE_IDLE;
    strcpy(sd_music_ctx.snapshot.title, "TF卡音乐");
    strcpy(sd_music_ctx.snapshot.status, "等待扫描TF卡");
    max_volume = audio_server_get_max_volume();
    volume = audio_server_get_private_volume(AUDIO_TYPE_LOCAL_MUSIC);
    sd_music_ctx.snapshot.volume_percent = max_volume == 0U ? 0U :
        (uint8_t)(((uint32_t)volume * 100U + max_volume / 2U) / max_volume);
    sd_music_ctx.snapshot.generation = 1U;
    sd_music_ctx.command_queue = rt_mq_create("sdmusic", sizeof(sd_music_command_t),
                                               SD_MUSIC_QUEUE_DEPTH,
                                               RT_IPC_FLAG_FIFO);
    if (sd_music_ctx.command_queue != RT_NULL)
    {
        sd_music_ctx.worker = rt_thread_create("sdmusic",
            sd_music_worker_entry, RT_NULL, SD_MUSIC_WORKER_STACK,
            RT_THREAD_PRIORITY_MIDDLE, RT_THREAD_TICK_DEFAULT);
    }
    if (sd_music_ctx.worker != RT_NULL)
        rt_thread_startup(sd_music_ctx.worker);
    else
    {
        sd_music_ctx.snapshot.state = SD_MUSIC_STATE_ERROR;
        strcpy(sd_music_ctx.snapshot.status, "音乐工作线程创建失败");
        sd_music_ctx.snapshot.generation++;
    }
    sd_music_initialized = 1U;
    if (tf_card_register_listener(sd_music_tf_card_event, RT_NULL) != RT_EOK)
        rt_kprintf("sd_music: cannot register TF card listener\n");
}

void sd_music_service_get_snapshot(sd_music_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;
    sd_music_service_init();
    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    *snapshot = sd_music_ctx.snapshot;
    rt_mutex_release(&sd_music_ctx.lock);
}

static rt_err_t sd_music_send_command(sd_music_command_type_t type)
{
    sd_music_command_t command = {type, 0U};

    sd_music_service_init();
    if (sd_music_ctx.command_queue == RT_NULL ||
        rt_mq_send(sd_music_ctx.command_queue, &command,
                   sizeof(command)) != RT_EOK)
    {
        sd_music_set_error("音乐命令队列忙");
        return -RT_ERROR;
    }
    return RT_EOK;
}

rt_err_t sd_music_service_refresh(void)
{
    return sd_music_send_command(SD_MUSIC_COMMAND_REFRESH);
}

rt_err_t sd_music_service_toggle_playback(void)
{
    return sd_music_send_command(SD_MUSIC_COMMAND_TOGGLE);
}

rt_err_t sd_music_service_previous(void)
{
    return sd_music_send_command(SD_MUSIC_COMMAND_PREVIOUS);
}

rt_err_t sd_music_service_next(void)
{
    return sd_music_send_command(SD_MUSIC_COMMAND_NEXT);
}

rt_err_t sd_music_service_stop(void)
{
    return sd_music_send_command(SD_MUSIC_COMMAND_STOP);
}

void sd_music_service_adjust_volume(int delta)
{
    int volume;
    uint8_t max_volume;

    sd_music_service_init();
    max_volume = audio_server_get_max_volume();
    volume = audio_server_get_private_volume(AUDIO_TYPE_LOCAL_MUSIC) + delta;
    if (volume < 0)
        volume = 0;
    else if (volume > max_volume)
        volume = max_volume;
    (void)audio_server_set_private_volume(AUDIO_TYPE_LOCAL_MUSIC,
                                           (uint8_t)volume);

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    sd_music_ctx.snapshot.volume_percent = max_volume == 0U ? 0U :
        (uint8_t)(((uint32_t)volume * 100U + max_volume / 2U) / max_volume);
    sd_music_ctx.snapshot.generation++;
    rt_mutex_release(&sd_music_ctx.lock);
}
