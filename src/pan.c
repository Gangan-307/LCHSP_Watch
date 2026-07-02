// /*
//  * SPDX-FileCopyrightText: 2024-2025 SiFli Technologies(Nanjing) Co., Ltd
//  *
//  * SPDX-License-Identifier: Apache-2.0
//  */

// #include "rtthread.h"
// #include "bf0_hal.h"
// #include "drv_io.h"
// #include "stdio.h"
// #include "string.h"

// #include "bts2_app_inc.h"
// #include "ble_connection_manager.h"
// #include "bt_connection_manager.h"

// #ifdef OTA_55X
//     #include "dfu_service.h"
// #endif

// #include "ulog.h"

// #define BT_APP_READY 1
// #define BT_APP_CONNECT_PAN  1
// #define PAN_TIMER_MS        3000

// #define URL "http://113.204.105.154:19000/ota-file/sdk/offline_install_h.bin"

// typedef struct
// {
//     BOOL bt_connected;
//     bt_notify_device_mac_t bd_addr;
//     rt_timer_t pan_connect_timer;
//     uint8_t pan_connected;
//     uint8_t retry_flag;
//     uint8_t retry_times;
//     uint8_t retry_max_times;
// } bt_app_t;

// static bt_app_t g_bt_app_env;
// static rt_mailbox_t g_bt_app_mb;

// #ifdef BT_DEVICE_NAME
//     static const char *local_name = BT_DEVICE_NAME;
// #else
//     static const char *local_name = "sifli_pan";
// #endif

// void bt_pan_set_retry_flag(uint8_t enable)
// {
//     g_bt_app_env.retry_flag = enable;
// }

// uint8_t bt_pan_get_retry_flag(void)
// {
//     return g_bt_app_env.retry_flag;
// }

// void bt_pan_set_retry_times(uint8_t times)
// {
//     g_bt_app_env.retry_max_times = times;
// }

// uint8_t bt_pan_get_retry_time(void)
// {
//     return g_bt_app_env.retry_max_times;
// }

// void bt_app_connect_pan_timeout_handle(void *parameter)
// {
//     if ((g_bt_app_mb != NULL) && (g_bt_app_env.bt_connected))
//         rt_mb_send(g_bt_app_mb, BT_APP_CONNECT_PAN);
// }

// void pan_reconnect(void)
// {
//     const int reconnect_interval_ms = 10000; // 10秒
//     while (g_bt_app_env.retry_times < g_bt_app_env.retry_max_times)
//     {
//         LOG_I("Attempting to reconnect PAN, attempt %d", g_bt_app_env.retry_times + 1);
//         if (!g_bt_app_env.retry_flag)
//         {
//             return;
//         }

//         if (g_bt_app_env.pan_connect_timer)
//         {
//             rt_timer_stop(g_bt_app_env.pan_connect_timer);
//         }

//         bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_HID);
//         g_bt_app_env.retry_times++;
//         rt_thread_mdelay(reconnect_interval_ms);
        
//         if (g_bt_app_env.pan_connected)
//         {
//             LOG_I("PAN reconnected successfully%d\n", g_bt_app_env.pan_connected);
//             g_bt_app_env.retry_times = 0;
//             return;
//         }
//     }
//     g_bt_app_env.retry_times = 0;
// }

// static int bt_app_interface_event_handle(uint16_t type, uint16_t event_id, uint8_t *data, uint16_t data_len)
// {
//     if (type == BT_NOTIFY_COMMON)
//     {
//         int pan_conn = 0;

//         switch (event_id)
//         {
//         case BT_NOTIFY_COMMON_BT_STACK_READY:
//         {
//             rt_mb_send(g_bt_app_mb, BT_APP_READY);
//         }
//         break;
//         case BT_NOTIFY_COMMON_ACL_DISCONNECTED:
//         {
//             bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
//             LOG_I("disconnected(0x%.2x:%.2x:%.2x:%.2x:%.2x:%.2x) res %d", info->mac.addr[5],
//                   info->mac.addr[4], info->mac.addr[3], info->mac.addr[2],
//                   info->mac.addr[1], info->mac.addr[0], info->res);
//             g_bt_app_env.bt_connected = FALSE;
//             if (g_bt_app_env.pan_connect_timer)
//                 rt_timer_stop(g_bt_app_env.pan_connect_timer);
//         }
//         break;
//         case BT_NOTIFY_COMMON_ENCRYPTION:
//         {
//             bt_notify_device_mac_t *mac = (bt_notify_device_mac_t *)data;
//             LOG_I("Encryption competed");
//             g_bt_app_env.bd_addr = *mac;
//             //pan_conn = 1;
//         }
//         break;
//         case BT_NOTIFY_COMMON_PAIR_IND:
//         {
//             bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
//             LOG_I("Pairing completed %d", info->res);
//             if (info->res == BTS2_SUCC)
//             {
//                 g_bt_app_env.bd_addr = info->mac;
//                 // pan_conn = 1;
//             }
//             break;
//         }
//         case BT_NOTIFY_COMMON_KEY_MISSING:
//         {
//             bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
//             LOG_I("Key missing %d", info->res);
//             memset(&g_bt_app_env.bd_addr, 0xFF, sizeof(g_bt_app_env.bd_addr));
//             bt_cm_delete_bonded_devs_and_linkkey(info->mac.addr);
//         }
//         break;
//         default:
//             break;
//         }

//         if (pan_conn)
//         {
//             LOG_I("bd addr 0x%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n", g_bt_app_env.bd_addr.addr[5],
//                   g_bt_app_env.bd_addr.addr[4], g_bt_app_env.bd_addr.addr[3],
//                   g_bt_app_env.bd_addr.addr[2], g_bt_app_env.bd_addr.addr[1],
//                   g_bt_app_env.bd_addr.addr[0]);
//             g_bt_app_env.bt_connected = TRUE;
//             if (!g_bt_app_env.pan_connect_timer)
//                 g_bt_app_env.pan_connect_timer = rt_timer_create("connect_pan", bt_app_connect_pan_timeout_handle, (void *)&g_bt_app_env,
//                                                  rt_tick_from_millisecond(PAN_TIMER_MS), RT_TIMER_FLAG_SOFT_TIMER);
//             else
//                 rt_timer_stop(g_bt_app_env.pan_connect_timer);
//             rt_timer_start(g_bt_app_env.pan_connect_timer);
//         }
//     }
//     else if (type == BT_NOTIFY_PAN)
//     {
//         switch (event_id)
//         {
//         case BT_NOTIFY_PAN_PROFILE_CONNECTED:
//         {
//             LOG_I("pan connect successed \n");
//             if (g_bt_app_env.pan_connect_timer)
//             {
//                 rt_timer_stop(g_bt_app_env.pan_connect_timer);
//             }
//             g_bt_app_env.pan_connected = 1;
//         }
//         break;
//         case BT_NOTIFY_PAN_PROFILE_DISCONNECTED:
//         {
//             LOG_I("pan disconnect with remote device\n");
//             g_bt_app_env.pan_connected = 0;
//         }
//         break;
//         default:
//             break;
//         }
//     }
//     else if (type == BT_NOTIFY_HID)
//     {
//         switch (event_id)
//         {
//         case BT_NOTIFY_HID_PROFILE_CONNECTED:
//         {
//             LOG_I("HID connected\n");
//             if (!g_bt_app_env.pan_connected)
//             {
//                 if (g_bt_app_env.pan_connect_timer)
//                 {
//                     rt_timer_stop(g_bt_app_env.pan_connect_timer);
//                 }
//                 bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_PAN);
//             }
//         }
//         break;
//         case BT_NOTIFY_HID_PROFILE_DISCONNECTED:
//         {
//             LOG_I("HID disconnected\n");
//         }
//         break;
//         default:
//             break;
//         }
//     }

//     return 0;
// }

// uint32_t bt_get_class_of_device()
// {
//     return (uint32_t)BT_SRVCLS_NETWORK | BT_DEVCLS_LAP | BT_LAP_FULLY;
// }

// /* 蓝牙网络管理专属线程入口 */
// static void bt_app_thread_entry(void *parameter)
// {
//     g_bt_app_mb = rt_mb_create("bt_app", 8, RT_IPC_FLAG_FIFO);
// #ifdef BSP_BT_CONNECTION_MANAGER
//     bt_cm_set_profile_target(BT_CM_HID, BT_LINK_PHONE, 1);
// #endif // BSP_BT_CONNECTION_MANAGER

//     bt_interface_register_bt_event_notify_callback(bt_app_interface_event_handle);
//     // for auto connect
//     bt_pan_set_retry_flag(1);
//     bt_pan_set_retry_times(5);

//     sifli_ble_enable();

//     while (1)
//     {
//         uint32_t value;
//         // Wait for stack/profile ready.
//         if (RT_EOK == rt_mb_recv(g_bt_app_mb, (rt_uint32_t *)&value, 8000) && value == BT_APP_READY)
//             LOG_I("BT/BLE stack and profile ready");
//         else
//             LOG_I("BT/BLE stack and profile init failed");

//         // Update Bluetooth name
//         bt_interface_set_local_name(strlen(local_name), (void *)local_name);

//         // handle pan connect event
//         rt_mb_recv(g_bt_app_mb, (rt_uint32_t *)&value, RT_WAITING_FOREVER);
//         if (value == BT_APP_CONNECT_PAN)
//         {
//             if (g_bt_app_env.bt_connected)
//                 bt_interface_conn_ext((char *)&g_bt_app_env.bd_addr, BT_PROFILE_PAN);
//         }
//     }
// }

// /**
//   * @brief  对外的蓝牙网络服务初始化接口
//   */
// /**
//   * @brief  对外的蓝牙网络服务初始化接口 (重命名避免命名冲突)
//   */
// void bt_pan_app_init(void)
// {
//     rt_kprintf("--- bt_pan_app_init: creating thread ---\n");
//     rt_thread_t tid = rt_thread_create("bt_app",
//                                        bt_app_thread_entry,
//                                        RT_NULL,
//                                        2048,  // 蓝牙栈线程建议栈分配 2KB
//                                        15,    // 优先级设定较高
//                                        10);
//     if (tid != RT_NULL)
//     {
//         rt_kprintf("--- bt_pan_app_init: thread created successfully, starting... ---\n");
//         rt_thread_startup(tid);
//     }else
//     {
//        rt_kprintf("\n[ERROR] Failed to create bt_app thread! Out of memory!\n\n");
//     }
// }

// static void pan_cmd(int argc, char **argv)
// {
//     if (strcmp(argv[1], "del_bond") == 0)
//     {
// #ifdef BSP_BT_CONNECTION_MANAGER
//         bt_cm_delete_bonded_devs();
//         LOG_D("Delete bond");
// #endif // BSP_BT_CONNECTION_MANAGER
//     }
//     else if (strcmp(argv[1], "conn_pan") == 0)
//         bt_app_connect_pan_timeout_handle(NULL);
//     else if (strcmp(argv[1], "ota_pan") == 0)
//     {
// #ifdef OTA_55X
//         bt_dfu_pan_download(URL);
// #endif
//     }
//     else if (strcmp(argv[1], "set_retry_flag") == 0)
//     {
//         uint8_t flag = atoi(argv[2]);
//         bt_pan_set_retry_flag(flag);
//     }
//     else if (strcmp(argv[1], "set_retry_time") == 0)
//     {
//         uint8_t times = atoi(argv[2]);
//         bt_pan_set_retry_times(times);
//     }
//     else if (strcmp(argv[1], "autoconnect") == 0)
//     {
//         pan_reconnect();
//     }
// }
// MSH_CMD_EXPORT(pan_cmd, Connect PAN to last paired device);

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

#include "ulog.h"

#define BT_APP_READY 1

#ifdef BT_DEVICE_NAME
    static const char *local_name = BT_DEVICE_NAME;
#else
    static const char *local_name = "sifli_bt_test";
#endif

typedef struct
{
    BOOL bt_connected;
    bt_notify_device_mac_t bd_addr;
} bt_app_t;

static bt_app_t g_bt_app_env;
static rt_mailbox_t g_bt_app_mb;

/**
  * @brief 蓝牙事件回调处理（简化版，仅处理基础连接）
  */
static int bt_app_interface_event_handle(uint16_t type, uint16_t event_id, uint8_t *data, uint16_t data_len)
{
    if (type == BT_NOTIFY_COMMON)
    {
        switch (event_id)
        {
        case BT_NOTIFY_COMMON_BT_STACK_READY:
        {
            rt_kprintf("[BT] Stack ready\n");
            rt_mb_send(g_bt_app_mb, BT_APP_READY);
        }
        break;
        
        case BT_NOTIFY_COMMON_ACL_DISCONNECTED:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            rt_kprintf("[BT] Disconnected from: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x, reason:%d\n", 
                       info->mac.addr[5], info->mac.addr[4], info->mac.addr[3],
                       info->mac.addr[2], info->mac.addr[1], info->mac.addr[0], 
                       info->res);
            g_bt_app_env.bt_connected = FALSE;
        }
        break;
        
        case BT_NOTIFY_COMMON_ENCRYPTION:
        {
            bt_notify_device_mac_t *mac = (bt_notify_device_mac_t *)data;
            g_bt_app_env.bd_addr = *mac;
            g_bt_app_env.bt_connected = TRUE;
            rt_kprintf("[BT] Encryption completed, connected to: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
                       mac->addr[5], mac->addr[4], mac->addr[3],
                       mac->addr[2], mac->addr[1], mac->addr[0]);
        }
        break;
        
        case BT_NOTIFY_COMMON_PAIR_IND:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            if (info->res == BTS2_SUCC)
            {
                g_bt_app_env.bd_addr = info->mac;
                g_bt_app_env.bt_connected = TRUE;
                rt_kprintf("[BT] Pairing completed successfully with: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
                           info->mac.addr[5], info->mac.addr[4], info->mac.addr[3],
                           info->mac.addr[2], info->mac.addr[1], info->mac.addr[0]);
            }
            else
            {
                rt_kprintf("[BT] Pairing failed with reason: %d\n", info->res);
            }
            break;
        }
        
        case BT_NOTIFY_COMMON_KEY_MISSING:
        {
            bt_notify_device_base_info_t *info = (bt_notify_device_base_info_t *)data;
            rt_kprintf("[BT] Key missing, deleting bond with: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
                       info->mac.addr[5], info->mac.addr[4], info->mac.addr[3],
                       info->mac.addr[2], info->mac.addr[1], info->mac.addr[0]);
            memset(&g_bt_app_env.bd_addr, 0xFF, sizeof(g_bt_app_env.bd_addr));
#ifdef BSP_BT_CONNECTION_MANAGER
            bt_cm_delete_bonded_devs_and_linkkey(info->mac.addr);
#endif
            g_bt_app_env.bt_connected = FALSE;
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
            rt_kprintf("[BT] HID Profile connected\n");
        }
        break;
        case BT_NOTIFY_HID_PROFILE_DISCONNECTED:
        {
            rt_kprintf("[BT] HID Profile disconnected\n");
        }
        break;
        default:
            break;
        }
    }

    return 0;
}

/**
  * @brief 获取设备Class of Device
  */

    // 设置为通用蓝牙设备
    uint32_t bt_get_class_of_device()
{
    return (uint32_t)BT_SRVCLS_NETWORK | BT_DEVCLS_LAP | BT_LAP_FULLY;
}



/**
  * @brief 蓝牙主线程入口
  */
static void bt_app_thread_entry(void *parameter)
{
    // 创建邮箱用于线程间通信
    g_bt_app_mb = rt_mb_create("bt_app", 4, RT_IPC_FLAG_FIFO);
    if (g_bt_app_mb == RT_NULL)
    {
        rt_kprintf("[ERROR] Failed to create mailbox\n");
        return;
    }

    // 注册蓝牙事件回调
    bt_interface_register_bt_event_notify_callback(bt_app_interface_event_handle);

    // 使能BLE功能
    sifli_ble_enable();
    
    rt_kprintf("[BT] Waiting for stack ready...\n");

    while (1)
    {
        uint32_t value;
        
        // 等待协议栈就绪
        if (RT_EOK == rt_mb_recv(g_bt_app_mb, (rt_uint32_t *)&value, 8000) && value == BT_APP_READY)
        {
            rt_kprintf("[BT] Stack ready, setting device name...\n");
            
            // 设置蓝牙设备名称
            bt_interface_set_local_name(strlen(local_name), (void *)local_name);
            rt_kprintf("[BT] Device name: %s\n", local_name);
            rt_kprintf("[BT] Waiting for phone to connect...\n");
            rt_kprintf("[BT] You can search for '%s' from your phone\n", local_name);
        }
        else
        {
            rt_kprintf("[BT] Stack init failed or timeout\n");
        }

        // 主循环：每秒打印一次连接状态
        while (1)
        {
            if (g_bt_app_env.bt_connected)
            {
                rt_kprintf("[BT] Connected to: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
                           g_bt_app_env.bd_addr.addr[5], g_bt_app_env.bd_addr.addr[4],
                           g_bt_app_env.bd_addr.addr[3], g_bt_app_env.bd_addr.addr[2],
                           g_bt_app_env.bd_addr.addr[1], g_bt_app_env.bd_addr.addr[0]);
            }
            else
            {
                rt_kprintf("[BT] Waiting for connection...\n");
            }
            
            rt_thread_mdelay(5000); // 每5秒打印一次状态
        }
    }
}

/**
  * @brief 蓝牙测试服务初始化接口
  */
void bt_test_app_init(void)
{
    rt_kprintf("--- bt_test_app_init: creating thread ---\n");
    
    rt_thread_t tid = rt_thread_create("bt_test",
                                       bt_app_thread_entry,
                                       RT_NULL,
                                       2048,  // 栈大小 2KB
                                       15,    // 优先级
                                       10);
    if (tid != RT_NULL)
    {
        rt_kprintf("--- bt_test_app_init: thread created successfully, starting... ---\n");
        rt_thread_startup(tid);
    }
    else
    {
        rt_kprintf("\n[ERROR] Failed to create bt_test thread! Out of memory!\n\n");
    }
}

/**
  * @brief 蓝牙测试命令
  */
static void bt_test_cmd(int argc, char **argv)
{
    if (argc < 2)
    {
        rt_kprintf("Usage:\n");
        rt_kprintf("  bt_test del_bond       - Delete all bonded devices\n");
        rt_kprintf("  bt_test status         - Show current connection status\n");
        rt_kprintf("  bt_test name <name>    - Set device name (max 20 chars)\n");
        return;
    }
    
    if (strcmp(argv[1], "del_bond") == 0)
    {
#ifdef BSP_BT_CONNECTION_MANAGER
        bt_cm_delete_bonded_devs();
        memset(&g_bt_app_env.bd_addr, 0xFF, sizeof(g_bt_app_env.bd_addr));
        g_bt_app_env.bt_connected = FALSE;
        rt_kprintf("[BT] All bonded devices deleted\n");
#else
        rt_kprintf("[BT] Connection manager not enabled\n");
#endif
    }
    else if (strcmp(argv[1], "status") == 0)
    {
        rt_kprintf("[BT] Connection status: %s\n", 
                   g_bt_app_env.bt_connected ? "CONNECTED" : "DISCONNECTED");
        if (g_bt_app_env.bt_connected)
        {
            rt_kprintf("[BT] Connected to: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
                       g_bt_app_env.bd_addr.addr[5], g_bt_app_env.bd_addr.addr[4],
                       g_bt_app_env.bd_addr.addr[3], g_bt_app_env.bd_addr.addr[2],
                       g_bt_app_env.bd_addr.addr[1], g_bt_app_env.bd_addr.addr[0]);
        }
        rt_kprintf("[BT] Device name: %s\n", local_name);
    }
    else if (strcmp(argv[1], "name") == 0 && argc >= 3)
    {
        // 注意：动态修改名称需要重新初始化蓝牙栈
        rt_kprintf("[BT] Name change requested to: %s (requires restart)\n", argv[2]);
        rt_kprintf("[BT] Please modify BT_DEVICE_NAME macro and recompile\n");
    }
    else
    {
        rt_kprintf("[BT] Unknown command: %s\n", argv[1]);
    }
}
MSH_CMD_EXPORT(bt_test_cmd, Bluetooth test commands);

/**
  * @brief 自动初始化（可选）
  */
#ifdef BT_TEST_AUTO_INIT
INIT_APP_EXPORT(bt_test_app_init);
#endif