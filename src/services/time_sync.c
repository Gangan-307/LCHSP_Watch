#include <rtthread.h>
#include <sys/socket.h> // 包含套接字 API
#include <netdb.h>      // 包含 gethostbyname
#include <string.h>
#include <time.h>       // 包含时间转换函数

#define NTP_SERVER "ntp.aliyun.com"  // 阿里云公共 NTP 服务器
#define NTP_PORT   123               // NTP 默认端口

// 外部硬件 RTC 同步函数声明
extern rt_err_t set_rtc_time_by_timestamp(time_t stamp);

/* 修改返回值为 rt_err_t */
rt_err_t sync_network_time(void)
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
        return -RT_ERROR;  /* 修改处：不能使用空 return; 必须返回错误码 */
    }

    // 2. 创建 UDP 套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        rt_kprintf("Error: Create UDP socket failed!\n");
        return -RT_ERROR;  /* 修改处：返回错误码 */
    }

    // 3. 设置接收超时时间为 5 秒
    struct timeval timeout;
    timeout.tv_sec = 5;
    timeout.tv_usec = 0;
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

    // 4. 配置服务器 network 地址
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
        return -RT_ERROR;  /* 修改处：返回错误码 */
    }

    // 7. 接收返回的时间包
    rc = recvfrom(sockfd, buf, sizeof(buf), 0, RT_NULL, RT_NULL);
    if (rc < 0)
    {
        rt_kprintf("Error: Receive NTP response timeout or failed!\n");
        closesocket(sockfd);
        return -RT_ERROR;  /* 修改处：返回错误码 */
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
        
        // 9. 更新芯片的硬件 RTC
        set_rtc_time_by_timestamp(stamp);
        return RT_EOK; // 成功时返回 RT_EOK (通常定义为 0)
    }
    else
    {
        rt_kprintf("Error: Parsed timestamp is invalid!\n");
        return -RT_ERROR;  /* 修改处：返回错误码 */
    }
}