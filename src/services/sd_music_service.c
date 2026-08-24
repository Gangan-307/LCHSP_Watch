#include "sd_music_service.h"

#include <stdint.h>
#include <string.h>

#include "audio_mp3ctrl.h"
#include "audio_server.h"
#include "dfs_file.h"
#include "dfs_posix.h"
#include "services/tf_card.h"

#define SD_MUSIC_MAX_TRACKS       64U
#define SD_MUSIC_PATH_LEN         192U
#define SD_MUSIC_QUEUE_DEPTH      12U
#define SD_MUSIC_WORKER_STACK     4096U

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
    rt_mq_t command_queue;
    rt_thread_t worker;
    mp3ctrl_handle player;
    sd_music_snapshot_t snapshot;
    sd_music_track_t tracks[SD_MUSIC_MAX_TRACKS];
    uint32_t active_session;
    char music_directory[SD_MUSIC_PATH_LEN];
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

    rt_mutex_take(&sd_music_ctx.lock, RT_WAITING_FOREVER);
    player = sd_music_ctx.player;
    sd_music_ctx.player = RT_NULL;
    sd_music_ctx.active_session++;
    sd_music_ctx.snapshot.position_seconds = 0U;
    rt_mutex_release(&sd_music_ctx.lock);

    if (player != RT_NULL)
        (void)mp3ctrl_close(player);
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
    (void)mp3ctrl_getinfo(sd_music_ctx.tracks[index].path, &info);

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

    player = mp3ctrl_open(AUDIO_TYPE_LOCAL_MUSIC,
                          sd_music_ctx.tracks[index].path,
                          sd_music_player_callback,
                          (void *)(uintptr_t)session);
    if (player == RT_NULL)
    {
        sd_music_set_error("音乐文件无法解码");
        return -RT_ERROR;
    }

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
