/*
 * SPDX-FileCopyrightText: 2024-2025 SiFli Technologies(Nanjing) Co., Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "rtthread.h"
#include "bf0_hal.h"
#include "drv_io.h"
#include "stdio.h"
#include "string.h"

#include "bts2_app_inc.h"
#include "ble_connection_manager.h"
#include "bt_connection_manager.h"
#include "music_app.h"
#include "pan.h"
#include "battery_ble.h"

#ifdef OTA_55X
#include "dfu_service.h"
#endif

#include "ulog.h"

/* 声明您之前的 NTP 同步函数 */
extern rt_err_t sync_network_time(void);

#define BT_APP_READY 1
#define BT_APP_CONNECT_PAN  1
#define PAN_TIMER_MS        3000

#define URL "http://113.204.105.154:19000/ota-file/sdk/offline_install_h.bin"

typedef struct
{
    BOOL bt_connected;
    bt_notify_device_mac_t bd_addr;
    rt_timer_t pan_connect_timer;
    uint8_t pan_connected;
    uint8_t retry_flag;
    uint8_t retry_times;
    uint8_t retry_max_times;
} bt_app_t;

static bt_app_t g_bt_app_env;
static rt_mailbox_t g_bt_app_mb;

#ifdef BT_DEVICE_NAME
    static const char *local_name = BT_DEVICE_NAME;
#else
    static const char *local_name = "铠甲勇士召唤器";
#endif

void bt_pan_set_retry_flag(uint8_t enable)
{
    g_bt_app_env.retry_flag = enable;
}

uint8_t bt_pan_get_retry_flag(void)
{
    return g_bt_app_env.retry_flag;
}

void bt_pan_set_retry_times(uint8_t times)
{
    g_bt_app_env.retry_max_times = times;
}

uint8_t bt_pan_get_retry_time(void)
{
    return g_bt_app_env.retry_max_times;
}

uint8_t bt_pan_is_connected(void)
{
    return g_bt_app_env.bt_connected ? 1U : 0U;
}

void bt_app_connect_pan_timeout_handle(void *parameter)
{
    if ((g_bt_app_mb != NULL) && (g_bt_app_env.bt_connected))
        rt_mb_send(g_bt_app_mb, BT_APP_CONNECT_PAN);
}

void pan_reconnect(void)
{
    const int reconnect_interval_ms = 10000; // 10秒
    while (g_bt_app_env.retry_times < g_bt_app_env.retry_max_times)
    {
        LOG_I("Attempting to reconnect PAN, attempt %d", g_bt_app_env.retry_times + 1);
        if (!g_bt_app_env.retry_flag)
        {
            return;
        }

        if (g_bt_app_env.pan_connect_timer)
        {
            rt_timer_stop(g_bt_app_env.pan_connect_timer);
        }

        bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_HID);
        g_bt_app_env.retry_times++;
        rt_thread_mdelay(reconnect_interval_ms);
        
        if (g_bt_app_env.pan_connected)
        {
            LOG_I("PAN reconnected successfully%d\n", g_bt_app_env.pan_connected);
            g_bt_app_env.retry_times = 0;
            return;
        }
    }
    g_bt_app_env.retry_times = 0;
}

static int bt_app_interface_event_handle(uint16_t type, uint16_t event_id, uint8_t *data, uint16_t data_len)
{
    music_app_handle_bt_event(type, event_id, data, data_len);

    if (type == BT_NOTIFY_COMMON)
    {
        int pan_conn = 0;

        switch (event_id)
        {
        case BT_NOTIFY_COMMON_BT_STACK_READY:
        {
            battery_ble_stack_ready();
            rt_mb_send(g_bt_app_mb, BT_APP_READY);
        }
        break;
        case BT_NOTIFY_COMMON_ACL_DISCONNECTED:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            LOG_I("disconnected(0x%.2x:%.2x:%.2x:%.2x:%.2x:%.2x) res %d", info->mac.addr[5],
                  info->mac.addr[4], info->mac.addr[3], info->mac.addr[2],
                  info->mac.addr[1], info->mac.addr[0], info->res);
            g_bt_app_env.bt_connected = FALSE;
            if (g_bt_app_env.pan_connect_timer)
                rt_timer_stop(g_bt_app_env.pan_connect_timer);
        }
        break;
        case BT_NOTIFY_COMMON_ENCRYPTION:
        {
            bt_notify_device_mac_t *mac = (bt_notify_device_mac_t *)data;
            LOG_I("Encryption competed");
            g_bt_app_env.bd_addr = *mac;
            pan_conn = 1;
        }
        break;
        case BT_NOTIFY_COMMON_PAIR_IND:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            LOG_I("Pairing completed %d", info->res);
            if (info->res == BTS2_SUCC)
            {
                g_bt_app_env.bd_addr = info->mac;
                pan_conn = 1;
            }
            break;
        }
        case BT_NOTIFY_COMMON_KEY_MISSING:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            LOG_I("Key missing %d", info->res);
            memset(&g_bt_app_env.bd_addr, 0xFF, sizeof(g_bt_app_env.bd_addr));
            bt_cm_delete_bonded_devs_and_linkkey(info->mac.addr);
        }
        break;
        default:
            break;
        }

        if (pan_conn)
        {
            LOG_I("bd addr 0x%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n", g_bt_app_env.bd_addr.addr[5],
                  g_bt_app_env.bd_addr.addr[4], g_bt_app_env.bd_addr.addr[3],
                  g_bt_app_env.bd_addr.addr[2], g_bt_app_env.bd_addr.addr[1],
                  g_bt_app_env.bd_addr.addr[0]);
            g_bt_app_env.bt_connected = TRUE;
            if (!g_bt_app_env.pan_connect_timer)
                g_bt_app_env.pan_connect_timer = rt_timer_create("connect_pan", bt_app_connect_pan_timeout_handle, (void *)&g_bt_app_env,
                                                 rt_tick_from_millisecond(PAN_TIMER_MS), RT_TIMER_FLAG_SOFT_TIMER);
            else
                rt_timer_stop(g_bt_app_env.pan_connect_timer);
            rt_timer_start(g_bt_app_env.pan_connect_timer);
        }
    }
    else if (type == BT_NOTIFY_PAN)
    {
        switch (event_id)
        {
        case BT_NOTIFY_PAN_PROFILE_CONNECTED:
        {
            LOG_I("pan connect successed \n");
            if (g_bt_app_env.pan_connect_timer)
            {
                rt_timer_stop(g_bt_app_env.pan_connect_timer);
            }
            g_bt_app_env.pan_connected = 1;

                        // 【集成点】在此处异步触发网络时间同步
            extern void trigger_ntp_sync(void);
            trigger_ntp_sync();
        }
        break;
        case BT_NOTIFY_PAN_PROFILE_DISCONNECTED:
        {
            LOG_I("pan disconnect with remote device\n");
            g_bt_app_env.pan_connected = 0;
        }
        break;
        default:
            break;
        }
    }
    else if (type == BT_NOTIFY_HID)
    {
        switch (event_id)
        {
        case BT_NOTIFY_HID_PROFILE_CONNECTED:
        {
            LOG_I("HID connected\n");
            if (!g_bt_app_env.pan_connected)
            {
                if (g_bt_app_env.pan_connect_timer)
                {
                    rt_timer_stop(g_bt_app_env.pan_connect_timer);
                }
                bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_PAN);
            }
        }
        break;
        case BT_NOTIFY_HID_PROFILE_DISCONNECTED:
        {
            LOG_I("HID disconnected\n");
        }
        break;
        default:
            break;
        }
    }

    return 0;
}

uint32_t bt_get_class_of_device()
{
    return (uint32_t)BT_SRVCLS_NETWORK | BT_DEVCLS_LAP | BT_LAP_FULLY;
}

/* 蓝牙网络管理专属线程入口 */
static void bt_app_thread_entry(void *parameter)
{
    g_bt_app_mb = rt_mb_create("bt_app", 8, RT_IPC_FLAG_FIFO);
#ifdef BSP_BT_CONNECTION_MANAGER
    bt_cm_set_profile_target(BT_CM_HID, BT_LINK_PHONE, 1);
#endif // BSP_BT_CONNECTION_MANAGER

    bt_interface_register_bt_event_notify_callback(bt_app_interface_event_handle);
    // for auto connect
    bt_pan_set_retry_flag(1);
    bt_pan_set_retry_times(5);

    sifli_ble_enable();

    while (1)
    {
        uint32_t value;
        // Wait for stack/profile ready.
        if (RT_EOK == rt_mb_recv(g_bt_app_mb, (rt_uint32_t *)&value, 8000) && value == BT_APP_READY)
            LOG_I("BT/BLE stack and profile ready");
        else
            LOG_I("BT/BLE stack and profile init failed");

        // Update Bluetooth name
        bt_interface_set_local_name(strlen(local_name), (void *)local_name);

        // handle pan connect event
        rt_mb_recv(g_bt_app_mb, (rt_uint32_t *)&value, RT_WAITING_FOREVER);
        if (value == BT_APP_CONNECT_PAN)
        {
            if (g_bt_app_env.bt_connected)
                bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_PAN);
        }
    }
}

/**
  * @brief  对外的蓝牙网络服务初始化接口
  */
/**
  * @brief  对外的蓝牙网络服务初始化接口 (重命名避免命名冲突)
  */
void bt_pan_app_init(void)
{
    rt_thread_t tid = rt_thread_create("bt_app",
                                       bt_app_thread_entry,
                                       RT_NULL,
                                       2048,  // 蓝牙栈线程建议栈分配 2KB
                                       15,    // 优先级设定较高
                                       10);
    if (tid != RT_NULL)
    {
        rt_thread_startup(tid);
    }
}

static void pan_cmd(int argc, char **argv)
{
    if (strcmp(argv[1], "del_bond") == 0)
    {
#ifdef BSP_BT_CONNECTION_MANAGER
        bt_cm_delete_bonded_devs();
        LOG_D("Delete bond");
#endif // BSP_BT_CONNECTION_MANAGER
    }
    else if (strcmp(argv[1], "conn_pan") == 0)
        bt_app_connect_pan_timeout_handle(NULL);
    else if (strcmp(argv[1], "ota_pan") == 0)
    {
#ifdef OTA_55X
        bt_dfu_pan_download(URL);
#endif
    }
    else if (strcmp(argv[1], "set_retry_flag") == 0)
    {
        uint8_t flag = atoi(argv[2]);
        bt_pan_set_retry_flag(flag);
    }
    else if (strcmp(argv[1], "set_retry_time") == 0)
    {
        uint8_t times = atoi(argv[2]);
        bt_pan_set_retry_times(times);
    }
    else if (strcmp(argv[1], "autoconnect") == 0)
    {
        pan_reconnect();
    }
}
static void ntp_sync_thread_entry(void *parameter)
{
    rt_err_t result = -RT_ERROR;
    uint32_t retry_count = 0;

    // 连接成功后，先等待 3 秒给协议栈一点准备时间
    rt_thread_mdelay(3000); 

    while (1)
    {
        // 健壮性检查：如果重试期间蓝牙 PAN 断开了，则无需继续重试，直接退出
        if (g_bt_app_env.pan_connected == 0)
        {
            rt_kprintf("[NTP] PAN disconnected. Stop retrying.\n");
            break;
        }

        retry_count++;
        rt_kprintf("[NTP] Attempting sync, try #%d...\n", retry_count);
        
        result = sync_network_time();
        if (result == RT_EOK)
        {
            rt_kprintf("[NTP] Successfully synchronized time after %d attempts!\n", retry_count);
            break; // 获取成功，退出循环，结束线程
        }

        // 获取失败，等待 5 秒后重试
        rt_thread_mdelay(5000); 
    }
}

void trigger_ntp_sync(void)
{
    rt_thread_t tid = rt_thread_create("ntp_sync",
                                       ntp_sync_thread_entry,
                                       RT_NULL,
                                       2048,
                                       20,   // 较低优先级
                                       10);
    if (tid != RT_NULL)
    {
        rt_thread_startup(tid);
    }
}
MSH_CMD_EXPORT(pan_cmd, Connect PAN to last paired device);
MSH_CMD_EXPORT(trigger_ntp_sync, Trigger NTP time synchronization);
