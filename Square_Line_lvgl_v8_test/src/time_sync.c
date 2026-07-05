// #include <rtthread.h>
// #include <time.h>
// #include <string.h>

// /* 
//  * 关键修正：必须在网络套接字头文件之前引入 LVGL 与 UI 头文件！
//  * 这样可以避免 lwIP 底层 read/write 宏对 RT-Thread 底层驱动头文件（mtd_nor.h）的污染。
//  */
// #include "lvgl.h"
// #include "ui.h"         // 引入 SquareLine 导出的 UI 头文件

// /* 
//  * 随后再引入网络与套接字相关的头文件
//  */
// #include <sys/socket.h> // 包含套接字 API
// #include <netdb.h>      // 包含 gethostbyname

// #define NTP_SERVER "ntp.aliyun.com"  // 阿里云公共 NTP 服务器
// #define NTP_PORT   123               // NTP 默认端口

// // 外部硬件 RTC 驱动接口声明
// extern rt_err_t set_rtc_time_by_timestamp(time_t stamp);
// extern void get_rtc_tm(struct tm *tm_new);

// /**
//  * @brief  LVGL 刷新定时器回调函数 (接管 ui_Label6 和 ui_Label7)
//  */
// static void time_update_timer_cb(lv_timer_t * timer)
// {
//     struct tm current_tm;
//     char time_str[16];  // 用于存储 "HH:MM"
//     char date_str[32];  // 用于存储 "Weekday, Mon DD"

//     // 星期与月份的英文文本映射数组
//     static const char *weekdays[] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
//     static const char *months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

//     // 1. 获取当前硬件 RTC 结构体数据
//     get_rtc_tm(&current_tm);

//     // 2. 格式化时间 (用于 ui_Label6)，对应格式为: "12:00"
//     rt_snprintf(time_str, sizeof(time_str), "%02d:%02d", 
//                 current_tm.tm_hour, 
//                 current_tm.tm_min);

//     // 3. 格式化日期 (用于 ui_Label7)，对应格式为: "Sunday, Jun 28"
//     rt_snprintf(date_str, sizeof(date_str), "%s, %s %02d", 
//                 weekdays[current_tm.tm_wday], 
//                 months[current_tm.tm_mon], 
//                 current_tm.tm_mday);

//     // 4. 将格式化后的字符串更新写入 SquareLine 的控件中
//     if (ui_Label6 != NULL)
//     {
//         lv_label_set_text(ui_Label6, time_str);
//     }
//     if (ui_Label7 != NULL)
//     {
//         lv_label_set_text(ui_Label7, date_str);
//     }
// }

// /**
//  * @brief  初始化 UI 刷新器（无需再创建控件，直接关联定时器即可）
//  */
// void lvgl_time_display_init(lv_obj_t * parent)
// {
//     // 由于 ui_init() 已经将 ui_Label6 和 ui_Label7 渲染好了
//     // 我们在这里仅启动一个 1 秒（1000 毫秒）的周期性定时器对它们进行刷新
//     lv_timer_create(time_update_timer_cb, 1000, NULL);
// }

// // ---------------- 终极免证书、免重定向的 UDP NTP 对时逻辑 ----------------
// void sync_network_time(void)
// {
//     int sockfd = -1;
//     struct sockaddr_in server_addr;
//     struct hostent *host = RT_NULL;
//     unsigned char buf[48];
//     int rc = 0;

//     rt_kprintf("Fetching network time via NTP (UDP Port 123)...\n");

//     // 1. 解析 NTP 服务器域名
//     host = gethostbyname(NTP_SERVER);
//     if (host == RT_NULL)
//     {
//         rt_kprintf("Error: NTP host DNS resolve failed!\n");
//         return;
//     }

//     // 2. 创建 UDP 套接字
//     sockfd = socket(AF_INET, SOCK_DGRAM, 0);
//     if (sockfd < 0)
//     {
//         rt_kprintf("Error: Create UDP socket failed!\n");
//         return;
//     }

//     // 3. 设置接收超时时间为 5 秒
//     struct timeval timeout;
//     timeout.tv_sec = 5;
//     timeout.tv_usec = 0;
//     setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

//     // 4. 配置服务器网络地址
//     rt_memset(&server_addr, 0, sizeof(server_addr));
//     server_addr.sin_family = AF_INET;
//     server_addr.sin_port = htons(NTP_PORT);
//     server_addr.sin_addr = *((struct in_addr *)host->h_addr);

//     // 5. 拼装 NTP 协议请求包
//     rt_memset(buf, 0, sizeof(buf));
//     buf[0] = 0x1B; // LI = 0, VN = 3, Mode = 3

//     // 6. 发送数据包
//     rc = sendto(sockfd, buf, sizeof(buf), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
//     if (rc < 0)
//     {
//         rt_kprintf("Error: Send NTP request failed!\n");
//         closesocket(sockfd);
//         return;
//     }

//     // 7. 接收返回的时间包
//     rc = recvfrom(sockfd, buf, sizeof(buf), 0, RT_NULL, RT_NULL);
//     if (rc < 0)
//     {
//         rt_kprintf("Error: Receive NTP response timeout or failed!\n");
//         closesocket(sockfd);
//         return;
//     }

//     closesocket(sockfd);

//     // 8. 解析 Transmit Timestamp（发送时间戳）
//     unsigned long seconds = 0;
//     seconds = ((unsigned long)buf[40] << 24) |
//               ((unsigned long)buf[41] << 16) |
//               ((unsigned long)buf[42] << 8)  |
//               ((unsigned long)buf[43]);

//     if (seconds > 0)
//     {
//         // 转换为 Unix 时间戳（减去 70 年对应的秒数）
//         time_t stamp = seconds - 2208988800U;

//         rt_kprintf("NTP Time Sync Success!\n");
//         rt_kprintf("Timestamp (UTC): %ld\n", (long)stamp);
        
//         // 9. 调用外部 RTC 驱动函数，更新芯片的硬件 RTC
//         set_rtc_time_by_timestamp(stamp);
//     }
//     else
//     {
//         rt_kprintf("Error: Parsed timestamp is invalid!\n");
//     }
// }
// MSH_CMD_EXPORT(sync_network_time, sync Beijing real-time via NTP UDP protocol); 

#include <rtthread.h>
#include <sys/socket.h> // 包含套接字 API
#include <netdb.h>      // 包含 gethostbyname
#include <string.h>
#include <time.h>       // 包含时间转换函数

#define NTP_SERVER "ntp.aliyun.com"  // 阿里云公共 NTP 服务器
#define NTP_PORT   123               // NTP 默认端口

// 外部硬件 RTC 同步函数声明
extern rt_err_t set_rtc_time_by_timestamp(time_t stamp);

void sync_network_time(void)
{
    int sockfd = -1;
    struct sockaddr_in server_addr;
    struct hostent *host = RT_NULL;
    unsigned char buf[48];
    int rc = 0;

    rt_kprintf("Fetching network time via NTP (UDP Port 123)...\n");

    // 1. 解析 NTP 服务器域名
    host = gethostbyname(NTP_SERVER);
    if (host == RT_NULL)
    {
        rt_kprintf("Error: NTP host DNS resolve failed!\n");
        return;
    }

    // 2. 创建 UDP 套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        rt_kprintf("Error: Create UDP socket failed!\n");
        return;
    }

    // 3. 设置接收超时时间为 5 秒
    struct timeval timeout;
    timeout.tv_sec = 5;
    timeout.tv_usec = 0;
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

    // 4. 配置服务器网络地址
    rt_memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(NTP_PORT);
    server_addr.sin_addr = *((struct in_addr *)host->h_addr);

    // 5. 拼装 NTP 协议请求包
    rt_memset(buf, 0, sizeof(buf));
    buf[0] = 0x1B; // LI = 0, VN = 3, Mode = 3

    // 6. 发送数据包
    rc = sendto(sockfd, buf, sizeof(buf), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (rc < 0)
    {
        rt_kprintf("Error: Send NTP request failed!\n");
        closesocket(sockfd);
        return;
    }

    // 7. 接收返回的时间包
    rc = recvfrom(sockfd, buf, sizeof(buf), 0, RT_NULL, RT_NULL);
    if (rc < 0)
    {
        rt_kprintf("Error: Receive NTP response timeout or failed!\n");
        closesocket(sockfd);
        return;
    }

    closesocket(sockfd);

    // 8. 解析 Transmit Timestamp（发送时间戳）
    unsigned long seconds = 0;
    seconds = ((unsigned long)buf[40] << 24) |
              ((unsigned long)buf[41] << 16) |
              ((unsigned long)buf[42] << 8)  |
              ((unsigned long)buf[43]);

    if (seconds > 0)
    {
        // 转换为 Unix 时间戳（减去 70 年对应的秒数）
        time_t stamp = seconds - 2208988800U;

        rt_kprintf("NTP Time Sync Success!\n");
        rt_kprintf("Timestamp (UTC): %ld\n", (long)stamp);
        
        // 9. 关键集成点：调用第一步中实现的 RTC 驱动函数，更新芯片的硬件 RTC
        set_rtc_time_by_timestamp(stamp);
    }
    else
    {
        rt_kprintf("Error: Parsed timestamp is invalid!\n");
    }
}

// 导出命令到 MSH 终端
MSH_CMD_EXPORT(sync_network_time, sync Beijing real-time to Hardware RTC);