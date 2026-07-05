#include <rtthread.h>
#include <webclient.h>  // 包含 webclient 头文件
#include <cJSON.h>
#include <string.h>

#include <sys/socket.h> // 包含 setsockopt 和 SOL_SOCKET
#include <sys/time.h>   // 包含 struct timeval

#define API_URL "https://ark.cn-beijing.volces.com/api/v3/chat/completions"  // 豆包 API 地址
#define API_KEY "ark-f79415c6-6289-46ae-afce-8fa28bdd7f14-d9daa"  // 替换为你的 API Key

#define BUF_SIZE 512

void webclient_post_request(void)
{
    char *request_data = NULL;
    struct webclient_session *session = NULL;
    int resp_status = 0;
    int rc = 0;

    // 1. 构造请求体
    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "model", "ep-m-20260626204108-hlqx2");  // 模型名称
    cJSON *messages = cJSON_AddArrayToObject(root, "messages");
    cJSON *message = cJSON_CreateObject();
    cJSON_AddStringToObject(message, "role", "user");
    cJSON_AddStringToObject(message, "content", "你好，请介绍一下你自己。"); 
    cJSON_AddItemToArray(messages, message);
    request_data = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);

    if (request_data == NULL)
    {
        rt_kprintf("JSON formatting failed!\n");
        return;
    }

    // 2. 创建 webclient 会话
    session = webclient_session_create(1024);
    if (session == NULL)
    {
        rt_kprintf("Create webclient session failed!\n");
        cJSON_free(request_data);
        return;
    }

    // 3. 添加自定义请求头 (手动补充 Content-Length 请求头)
    webclient_header_fields_add(session, "Content-Type: application/json\r\n");
    webclient_header_fields_add(session, "Authorization: Bearer " API_KEY "\r\n");
    webclient_header_fields_add(session, "Content-Length: %d\r\n", strlen(request_data));

    // 4. 手动发起连接 (建立 TCP 链路并完成 TLS 握手)
    rc = webclient_connect(session, API_URL);
    if (rc < 0)
    {
        rt_kprintf("Connect to server failed! Error code: %d\n", rc);
        goto __exit;
    }

    // 5. 核心魔法步骤：直接修改套接字超时时间
    struct timeval timeout;
    timeout.tv_sec = 20; // 20 秒
    timeout.tv_usec = 0;
    if (setsockopt(session->socket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout)) < 0)
    {
        rt_kprintf("Warning: Set socket timeout failed!\n");
    }
    else
    {
        rt_kprintf("Successfully set socket timeout to 20s at kernel level.\n");
    }

    // 6. 调用 webclient_post 发送数据
    resp_status = webclient_post(session, API_URL, request_data, strlen(request_data));

    if (resp_status == 200)
    {
        char *response_buf = NULL;
        size_t response_len = 0;
        char temp_buf[BUF_SIZE];
        int bytes_read = 0;

        // 7. 循环读取响应数据（支持分块传输）
        while ((bytes_read = webclient_read(session, temp_buf, BUF_SIZE - 1)) > 0)
        {
            char *new_buf = rt_realloc(response_buf, response_len + bytes_read + 1);
            if (new_buf == NULL)
            {
                rt_kprintf("Out of memory during response read!\n");
                break;
            }
            response_buf = new_buf;
            rt_memcpy(response_buf + response_len, temp_buf, bytes_read);
            response_len += bytes_read;
            response_buf[response_len] = '\0';
        }

        if (response_len > 0 && response_buf != NULL)
        {
            rt_kprintf("Response: %s\n", response_buf);

            // 8. 解析响应 JSON
            cJSON *response_json = cJSON_Parse(response_buf);
            if (response_json != NULL)
            {
                cJSON *choices = cJSON_GetObjectItem(response_json, "choices");
                if (choices != NULL)
                {
                    cJSON *first_choice = cJSON_GetArrayItem(choices, 0);
                    if (first_choice != NULL)
                    {
                        cJSON *msg_obj = cJSON_GetObjectItem(first_choice, "message");
                        if (msg_obj != NULL)
                        {
                            cJSON *content_obj = cJSON_GetObjectItem(msg_obj, "content");
                            if (content_obj != NULL && content_obj->valuestring != NULL)
                            {
                                rt_kprintf("AI 回复: %s\n", content_obj->valuestring);
                            }
                        }
                    }
                }
                cJSON_Delete(response_json);
            }
            rt_free(response_buf);
        }
        else
        {
            rt_kprintf("Read response data failed or empty response!\n");
        }
    }
    else
    {
        rt_kprintf("HTTP POST request failed! Status code: %d\n", resp_status);
    }

__exit:
    // 9. 释放资源
    if (session)
    {
        webclient_close(session);
    }
    if (request_data)
    {
        cJSON_free(request_data);
    }
}

__ROM_USED void doubao(int argc, char **argv)
{
    webclient_post_request();
}
MSH_CMD_EXPORT(doubao, doubao AI application) 