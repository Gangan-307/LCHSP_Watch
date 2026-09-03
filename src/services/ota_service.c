#include "ota_service.h"

#include <stdio.h>
#include <string.h>

#include "bluetooth/find_phone_ble.h"
#include "bluetooth/pan.h"

#ifdef HSP_USING_OTA
#include "bf0_hal.h"
#include "bt_pan_ota.h"
#include "bts2_app_pan.h"
#include "drivers/pm.h"
#include "ptab.h"
#include "services/battery_ui.h"
#include "services/local_audio_arbiter.h"
#endif

#define OTA_WORKER_STACK_SIZE (8192U)
#define OTA_WORKER_PRIORITY   (24U)
#define OTA_WORKER_TICK       (10U)
#define OTA_COMMAND_DEPTH     (2U)
#define OTA_MIN_BATTERY       (40U)

#ifndef HSP_OTA_SERVER_BASE_URL
#define HSP_OTA_SERVER_BASE_URL ""
#endif

#ifndef HSP_OTA_QUERY_URL_FORMAT
#define HSP_OTA_QUERY_URL_FORMAT                                             \
    HSP_OTA_SERVER_BASE_URL                                                  \
    "/v2/example/pan_ota/SF32LB52_ULP_NOR_TFT_CO5300/"                      \
    "sf32lb52-lchspi-ulp?chip_id=%s&version=latest"
#endif

#define HSP_OTA_MODEL          "sf32lb52-lchspi-ulp"
#define HSP_OTA_SOLUTION       "SF32LB52_ULP_NOR_TFT_CO5300"
#define HSP_OTA_CURRENT_VERSION "v" HSP_WATCH_FIRMWARE_VERSION

typedef enum
{
    OTA_COMMAND_CHECK,
    OTA_COMMAND_INSTALL,
} ota_command_t;

#ifdef HSP_USING_OTA
typedef struct
{
    struct rt_mutex lock;
    rt_mq_t command_queue;
    rt_thread_t worker;
    ota_snapshot_t snapshot;
} ota_context_t;

static ota_context_t ota_context;
static uint8_t ota_initialized;
static char ota_mac[20];
static char ota_client_id[40];
ALIGN(4) static uint8_t ota_sha256[32];

static uint8_t ota_state_progress(ota_state_t state)
{
    switch (state)
    {
    case OTA_STATE_CHECKING:
        return 10U;
    case OTA_STATE_UPDATE_AVAILABLE:
    case OTA_STATE_UP_TO_DATE:
        return 100U;
    case OTA_STATE_PREPARING:
        return 25U;
    case OTA_STATE_REBOOTING:
        return 100U;
    default:
        return 0U;
    }
}

static void ota_publish_state(ota_state_t state, uint8_t progress)
{
    find_phone_ble_publish_ota_status((uint8_t)state, progress);
}

static void ota_set_state(ota_state_t state, ota_error_t error,
                          const char *status)
{
    uint8_t progress = ota_state_progress(state);

    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    ota_context.snapshot.state = state;
    ota_context.snapshot.error = error;
    ota_context.snapshot.progress_percent = progress;
    if (status != RT_NULL)
    {
        rt_strncpy(ota_context.snapshot.status, status,
                   sizeof(ota_context.snapshot.status) - 1U);
        ota_context.snapshot.status[sizeof(ota_context.snapshot.status) - 1U] =
            '\0';
    }
    ota_context.snapshot.generation++;
    rt_mutex_release(&ota_context.lock);

    ota_publish_state(state, progress);
}

static void ota_hash_mac(const BTS2S_ETHER_ADDR *address)
{
    HAL_HASH_reset();
    HAL_HASH_init(RT_NULL, HASH_ALGO_SHA256, 0U);
    HAL_HASH_run((uint8_t *)address, sizeof(*address), 1U);
    HAL_HASH_result(ota_sha256);
}

static char ota_hex_digit(uint8_t value)
{
    value &= 0x0FU;
    return (char)(value < 10U ? ('0' + value) : ('a' + value - 10U));
}

static void ota_build_device_identity(void)
{
    BTS2S_ETHER_ADDR address;
    const uint8_t *bytes;
    uint8_t source_index;
    uint8_t output_index = 0U;

    if (ota_client_id[0] != '\0')
        return;

    address = bt_pan_get_mac_address();
    bytes = (const uint8_t *)&address;
    rt_snprintf(ota_mac, sizeof(ota_mac), "%02x:%02x:%02x:%02x:%02x:%02x",
                bytes[1], bytes[0], bytes[3], bytes[2], bytes[5], bytes[4]);

    ota_hash_mac(&address);
    for (source_index = 0U; source_index < 16U; source_index++)
    {
        if (source_index == 4U || source_index == 6U || source_index == 8U ||
            source_index == 10U)
            ota_client_id[output_index++] = '-';
        ota_client_id[output_index++] = ota_hex_digit(ota_sha256[source_index] >> 4U);
        ota_client_id[output_index++] = ota_hex_digit(ota_sha256[source_index]);
    }
    ota_client_id[output_index] = '\0';
}

static int ota_register_device(void)
{
    device_register_params_t parameters;

    rt_memset(&parameters, 0, sizeof(parameters));
    parameters.mac = ota_mac;
    parameters.model = HSP_OTA_MODEL;
    parameters.solution = HSP_OTA_SOLUTION;
    parameters.version = HSP_OTA_CURRENT_VERSION;
    parameters.ota_version = HSP_OTA_CURRENT_VERSION;
    parameters.screen_width = "390";
    parameters.screen_height = "450";
    parameters.flash_type = "NOR";
    parameters.chip_id = ota_client_id;
    return dfu_pan_register_device(HSP_OTA_SERVER_BASE_URL, &parameters);
}

static uint8_t ota_server_configured(void)
{
    const char *server_url = HSP_OTA_SERVER_BASE_URL;

    return strlen(server_url) > 8U &&
           strncmp(server_url, "https://", 8U) == 0;
}

static uint8_t ota_manifest_file_valid(const struct firmware_file_info *file)
{
    if (strncmp(file->name, "main.bin", sizeof(file->name)) != 0)
        return 0U;
    if (strncmp(file->url, "https://", 8U) != 0)
        return 0U;
    if (file->addr != HCPU_FLASH_CODE_START_ADDR)
        return 0U;
    if (file->region_size == 0U ||
        file->region_size > HCPU_FLASH_CODE_SIZE)
        return 0U;
    if (file->size == 0U || file->size > file->region_size)
        return 0U;
    return 1U;
}

static int ota_validate_manifest(uint32_t *total_bytes)
{
    struct firmware_file_info file;
    uint64_t total = 0U;
    int index;
    int valid_files = 0;

    for (index = 0; index < MAX_FIRMWARE_FILES; index++)
    {
        rt_memset(&file, 0, sizeof(file));
        if (dfu_pan_get_firmware_file_info(index, &file) != 0)
            continue;
        if (file.name[0] == '\0' || (uint8_t)file.name[0] == 0xFFU)
            continue;
        if (!ota_manifest_file_valid(&file))
        {
            rt_kprintf("ota: invalid manifest file %d (%s), addr=0x%08x, "
                       "size=%u, region=%u\n",
                       index, file.name, file.addr, file.size, file.region_size);
            return -1;
        }
        total += file.size;
        if (total > UINT32_MAX)
            return -1;
        valid_files++;
        if (valid_files > 1)
        {
            rt_kprintf("ota: manifest must contain exactly one main.bin\n");
            return -1;
        }
    }

    if (valid_files != 1)
        return -1;
    *total_bytes = (uint32_t)total;
    return 0;
}

static void ota_check_internal(void)
{
    char query_url[512];
    char latest_version[OTA_VERSION_LEN] = {0};
    uint32_t total_bytes = 0U;
    int result;

    if (!ota_server_configured())
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_SERVER_NOT_CONFIGURED,
                      "OTA 服务器未配置");
        return;
    }
    if (!bt_pan_prepare_ota_link())
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_PAN_DISCONNECTED,
                      "请先连接手机并开启蓝牙网络共享");
        return;
    }

#ifdef RT_USING_PM
    rt_pm_request(PM_SLEEP_MODE_IDLE);
#endif
    ota_build_device_identity();
    if (ota_register_device() != 0)
        rt_kprintf("ota: device registration failed; continuing version query\n");

    rt_snprintf(query_url, sizeof(query_url), HSP_OTA_QUERY_URL_FORMAT,
                ota_client_id);
    result = dfu_pan_query_latest_version(query_url, HSP_OTA_CURRENT_VERSION,
                                          latest_version,
                                          sizeof(latest_version));
#ifdef RT_USING_PM
    rt_pm_release(PM_SLEEP_MODE_IDLE);
#endif

    if (result < 0)
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_NETWORK,
                      "版本查询失败，请检查手机网络");
        return;
    }
    if (result == 0)
    {
        rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
        rt_strncpy(ota_context.snapshot.latest_version,
                   HSP_OTA_CURRENT_VERSION,
                   sizeof(ota_context.snapshot.latest_version) - 1U);
        rt_mutex_release(&ota_context.lock);
        ota_set_state(OTA_STATE_UP_TO_DATE, OTA_ERROR_NONE,
                      "当前已是最新版本");
        return;
    }
    if (ota_validate_manifest(&total_bytes) != 0)
    {
        dfu_pan_clear_files();
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_INVALID_MANIFEST,
                      "服务器升级清单无效");
        return;
    }

    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    rt_strncpy(ota_context.snapshot.latest_version, latest_version,
               sizeof(ota_context.snapshot.latest_version) - 1U);
    ota_context.snapshot.latest_version[
        sizeof(ota_context.snapshot.latest_version) - 1U] = '\0';
    ota_context.snapshot.total_bytes = total_bytes;
    rt_mutex_release(&ota_context.lock);
    ota_set_state(OTA_STATE_UPDATE_AVAILABLE, OTA_ERROR_NONE,
                  "发现新版本，可以下载并安装");
}

static void ota_install_internal(void)
{
    battery_status_t battery;
    uint32_t total_bytes;

    if (!bt_pan_prepare_ota_link())
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_PAN_DISCONNECTED,
                      "蓝牙网络共享已断开");
        return;
    }
    battery_ui_get_status(&battery);
    if (!battery.valid)
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_BATTERY_UNAVAILABLE,
                      "暂时无法读取电量，请稍后重试");
        return;
    }
    if (!battery.external_power_present && battery.percent < OTA_MIN_BATTERY)
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_LOW_BATTERY,
                      "电量需达到 40% 或连接充电器");
        return;
    }
    if (local_audio_arbiter_owner() != LOCAL_AUDIO_OWNER_NONE)
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_AUDIO_BUSY,
                      "请先停止音乐播放或录音");
        return;
    }
    if (ota_validate_manifest(&total_bytes) != 0)
    {
        dfu_pan_clear_files();
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_INVALID_MANIFEST,
                      "升级清单已失效，请重新检查");
        return;
    }
    if (dfu_pan_set_update_flags() != 0)
    {
        ota_set_state(OTA_STATE_FAILED, OTA_ERROR_FLASH,
                      "写入升级标志失败");
        return;
    }

    ota_set_state(OTA_STATE_REBOOTING, OTA_ERROR_NONE,
                  "即将重启并进入升级模式");
    rt_thread_mdelay(800U);
    HAL_PMU_Reboot();
}

static void ota_worker_entry(void *parameter)
{
    ota_command_t command;

    (void)parameter;
    while (1)
    {
        if (rt_mq_recv(ota_context.command_queue, &command, sizeof(command),
                       RT_WAITING_FOREVER) != RT_EOK)
            continue;
        if (command == OTA_COMMAND_CHECK)
            ota_check_internal();
        else if (command == OTA_COMMAND_INSTALL)
            ota_install_internal();
    }
}

void ota_service_init(void)
{
    if (ota_initialized)
        return;

    rt_memset(&ota_context, 0, sizeof(ota_context));
    if (rt_mutex_init(&ota_context.lock, "ota", RT_IPC_FLAG_PRIO) != RT_EOK)
        return;

    ota_context.snapshot.state = OTA_STATE_IDLE;
    ota_context.snapshot.error = OTA_ERROR_NONE;
    rt_strncpy(ota_context.snapshot.current_version,
               HSP_WATCH_FIRMWARE_VERSION,
               sizeof(ota_context.snapshot.current_version) - 1U);
    rt_strncpy(ota_context.snapshot.status, "点击检查新版本",
               sizeof(ota_context.snapshot.status) - 1U);
    ota_context.snapshot.generation = 1U;
    ota_context.command_queue = rt_mq_create("ota_cmd", sizeof(ota_command_t),
                                              OTA_COMMAND_DEPTH,
                                              RT_IPC_FLAG_FIFO);
    if (ota_context.command_queue == RT_NULL)
    {
        ota_context.snapshot.state = OTA_STATE_FAILED;
        ota_context.snapshot.error = OTA_ERROR_INTERNAL;
        rt_strncpy(ota_context.snapshot.status, "OTA 命令队列创建失败",
                   sizeof(ota_context.snapshot.status) - 1U);
        ota_initialized = 1U;
        return;
    }

    ota_context.worker = rt_thread_create("ota", ota_worker_entry, RT_NULL,
                                           OTA_WORKER_STACK_SIZE,
                                           OTA_WORKER_PRIORITY,
                                           OTA_WORKER_TICK);
    if (ota_context.worker == RT_NULL)
    {
        ota_context.snapshot.state = OTA_STATE_FAILED;
        ota_context.snapshot.error = OTA_ERROR_INTERNAL;
        rt_strncpy(ota_context.snapshot.status, "OTA 工作线程创建失败",
                   sizeof(ota_context.snapshot.status) - 1U);
        ota_initialized = 1U;
        return;
    }

    ota_initialized = 1U;
    rt_thread_startup(ota_context.worker);
    ota_publish_state(OTA_STATE_IDLE, 0U);
}

void ota_service_get_snapshot(ota_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;
    ota_service_init();
    if (!ota_initialized)
    {
        rt_memset(snapshot, 0, sizeof(*snapshot));
        snapshot->state = OTA_STATE_FAILED;
        snapshot->error = OTA_ERROR_INTERNAL;
        rt_strncpy(snapshot->status, "OTA 服务初始化失败",
                   sizeof(snapshot->status) - 1U);
        return;
    }

    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    *snapshot = ota_context.snapshot;
    rt_mutex_release(&ota_context.lock);
    snapshot->pan_connected = bt_pan_network_is_connected();
}

rt_err_t ota_service_check(void)
{
    ota_command_t command = OTA_COMMAND_CHECK;
    ota_state_t previous_state;

    ota_service_init();
    if (!ota_initialized || ota_context.command_queue == RT_NULL)
        return -RT_ERROR;

    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    previous_state = ota_context.snapshot.state;
    if (previous_state == OTA_STATE_CHECKING ||
        previous_state == OTA_STATE_PREPARING ||
        previous_state == OTA_STATE_REBOOTING)
    {
        rt_mutex_release(&ota_context.lock);
        return -RT_EBUSY;
    }
    ota_context.snapshot.latest_version[0] = '\0';
    ota_context.snapshot.total_bytes = 0U;
    rt_mutex_release(&ota_context.lock);

    ota_set_state(OTA_STATE_CHECKING, OTA_ERROR_NONE,
                  "正在通过手机网络检查更新");
    if (rt_mq_send(ota_context.command_queue, &command, sizeof(command)) != RT_EOK)
    {
        ota_set_state(previous_state, OTA_ERROR_BUSY, "OTA 服务繁忙，请稍后重试");
        return -RT_EBUSY;
    }
    return RT_EOK;
}

rt_err_t ota_service_install(void)
{
    ota_command_t command = OTA_COMMAND_INSTALL;

    ota_service_init();
    if (!ota_initialized || ota_context.command_queue == RT_NULL)
        return -RT_ERROR;

    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    if (ota_context.snapshot.state != OTA_STATE_UPDATE_AVAILABLE)
    {
        rt_mutex_release(&ota_context.lock);
        return -RT_EINVAL;
    }
    rt_mutex_release(&ota_context.lock);

    ota_set_state(OTA_STATE_PREPARING, OTA_ERROR_NONE, "正在检查升级条件");
    if (rt_mq_send(ota_context.command_queue, &command, sizeof(command)) != RT_EOK)
    {
        ota_set_state(OTA_STATE_UPDATE_AVAILABLE, OTA_ERROR_BUSY,
                      "OTA 服务繁忙，请稍后重试");
        return -RT_EBUSY;
    }
    return RT_EOK;
}

uint8_t ota_service_install_in_progress(void)
{
    ota_state_t state;

    ota_service_init();
    if (!ota_initialized)
        return 0U;
    rt_mutex_take(&ota_context.lock, RT_WAITING_FOREVER);
    state = ota_context.snapshot.state;
    rt_mutex_release(&ota_context.lock);
    return state == OTA_STATE_PREPARING || state == OTA_STATE_REBOOTING;
}

#else

void ota_service_init(void)
{
}

void ota_service_get_snapshot(ota_snapshot_t *snapshot)
{
    if (snapshot == RT_NULL)
        return;
    rt_memset(snapshot, 0, sizeof(*snapshot));
    snapshot->state = OTA_STATE_FAILED;
    snapshot->error = OTA_ERROR_NOT_SUPPORTED;
    rt_strncpy(snapshot->current_version, HSP_WATCH_FIRMWARE_VERSION,
               sizeof(snapshot->current_version) - 1U);
    rt_strncpy(snapshot->status, "当前构建未启用 OTA",
               sizeof(snapshot->status) - 1U);
}

rt_err_t ota_service_check(void)
{
    return -RT_ERROR;
}

rt_err_t ota_service_install(void)
{
    return -RT_ERROR;
}

uint8_t ota_service_install_in_progress(void)
{
    return 0U;
}

#endif
