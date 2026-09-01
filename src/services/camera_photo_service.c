#include "camera_photo_service.h"

#include <stdio.h>

#include "rtthread.h"
#include "services/internal_storage.h"

#define CAMERA_PHOTO_FILE        "/camera.jpg"
#define CAMERA_PHOTO_TEMP_FILE   "/camera.tmp"
#define CAMERA_PHOTO_BACKUP_FILE "/camera.bak"

static FILE *camera_photo_file;
static uint16_t camera_photo_generation;
static uint32_t camera_photo_expected_bytes;
static uint32_t camera_photo_received_bytes;
static uint32_t camera_photo_expected_crc32;
static uint32_t camera_photo_crc32 = 0xFFFFFFFFUL;
static uint32_t camera_photo_current_revision;
static camera_photo_event_cb_t camera_photo_event_handler;

static uint32_t camera_photo_crc32_update(uint32_t crc, const uint8_t *data,
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

static void camera_photo_notify(camera_photo_event_t event)
{
    if (camera_photo_event_handler != RT_NULL)
        camera_photo_event_handler(event);
}

void camera_photo_set_event_handler(camera_photo_event_cb_t handler)
{
    camera_photo_event_handler = handler;
}

void camera_photo_cancel(void)
{
    if (camera_photo_file != RT_NULL)
    {
        fclose(camera_photo_file);
        camera_photo_file = RT_NULL;
    }
    (void)remove(CAMERA_PHOTO_TEMP_FILE);
    camera_photo_generation = 0U;
    camera_photo_expected_bytes = 0U;
    camera_photo_received_bytes = 0U;
    camera_photo_expected_crc32 = 0U;
    camera_photo_crc32 = 0xFFFFFFFFUL;
}

int camera_photo_begin(uint16_t generation, uint32_t total_length,
                       uint32_t expected_crc32)
{
    if (generation == 0U || total_length < 4U ||
        total_length > CAMERA_PHOTO_MAX_BYTES)
    {
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }

    camera_photo_cancel();
    if (internal_storage_ensure_ready() != RT_EOK)
    {
        rt_kprintf("camera: internal storage is unavailable\n");
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }
    rt_set_errno(0);
    camera_photo_file = fopen(CAMERA_PHOTO_TEMP_FILE, "wb");
    if (camera_photo_file == RT_NULL)
    {
        rt_kprintf("camera: cannot open %s, errno=%d\n",
                   CAMERA_PHOTO_TEMP_FILE, rt_get_errno());
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }
    camera_photo_generation = generation;
    camera_photo_expected_bytes = total_length;
    camera_photo_expected_crc32 = expected_crc32;
    camera_photo_crc32 = 0xFFFFFFFFUL;
    rt_kprintf("camera: receiving preview, %u bytes\n", total_length);
    return 0;
}

static int camera_photo_finish(void)
{
    uint32_t actual_crc32;
    int had_previous_photo;

    if (camera_photo_file == RT_NULL)
        return -1;
    fclose(camera_photo_file);
    camera_photo_file = RT_NULL;
    actual_crc32 = camera_photo_crc32 ^ 0xFFFFFFFFUL;
    if (camera_photo_received_bytes != camera_photo_expected_bytes ||
        actual_crc32 != camera_photo_expected_crc32)
    {
        rt_kprintf("camera: rejected preview (%u/%u bytes, crc %08x/%08x)\n",
                   camera_photo_received_bytes, camera_photo_expected_bytes,
                   actual_crc32, camera_photo_expected_crc32);
        camera_photo_cancel();
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }

    (void)remove(CAMERA_PHOTO_BACKUP_FILE);
    had_previous_photo = rename(CAMERA_PHOTO_FILE,
                                CAMERA_PHOTO_BACKUP_FILE) == 0;
    if (rename(CAMERA_PHOTO_TEMP_FILE, CAMERA_PHOTO_FILE) != 0)
    {
        int error = rt_get_errno();

        if (had_previous_photo)
            (void)rename(CAMERA_PHOTO_BACKUP_FILE, CAMERA_PHOTO_FILE);
        camera_photo_cancel();
        rt_kprintf("camera: cannot install preview, errno=%d\n", error);
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }
    if (had_previous_photo)
        (void)remove(CAMERA_PHOTO_BACKUP_FILE);

    rt_kprintf("camera: preview saved, %u bytes\n",
               camera_photo_received_bytes);
    camera_photo_current_revision++;
    if (camera_photo_current_revision == 0U)
        camera_photo_current_revision = 1U;
    camera_photo_generation = 0U;
    camera_photo_expected_bytes = 0U;
    camera_photo_received_bytes = 0U;
    camera_photo_expected_crc32 = 0U;
    camera_photo_crc32 = 0xFFFFFFFFUL;
    camera_photo_notify(CAMERA_PHOTO_EVENT_READY);
    return 0;
}

int camera_photo_data(uint16_t generation, uint32_t offset,
                      const uint8_t *data, uint16_t length)
{
    size_t written;

    if (camera_photo_file == RT_NULL || data == RT_NULL || length == 0U ||
        generation != camera_photo_generation ||
        offset != camera_photo_received_bytes ||
        offset + length > camera_photo_expected_bytes)
    {
        rt_kprintf("camera: rejected packet (gen %u/%u, offset %u/%u, "
                   "len %u, total %u)\n",
                   generation, camera_photo_generation, offset,
                   camera_photo_received_bytes, length,
                   camera_photo_expected_bytes);
        camera_photo_cancel();
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }

    written = fwrite(data, sizeof(uint8_t), length, camera_photo_file);
    if (written != length)
    {
        int error = rt_get_errno();

        rt_kprintf("camera: preview write failed (%u/%u), errno=%d\n",
                   (unsigned int)written, (unsigned int)length, error);
        camera_photo_cancel();
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
        return -1;
    }
    camera_photo_crc32 = camera_photo_crc32_update(camera_photo_crc32,
                                                    data, length);
    camera_photo_received_bytes += length;
    if (camera_photo_received_bytes == camera_photo_expected_bytes)
        return camera_photo_finish();
    return 0;
}

void camera_photo_report_status(uint8_t status)
{
    camera_photo_cancel();
    if (status == 1U)
        camera_photo_notify(CAMERA_PHOTO_EVENT_PERMISSION_REQUIRED);
    else if (status == 2U)
        camera_photo_notify(CAMERA_PHOTO_EVENT_NOT_FOUND);
    else
        camera_photo_notify(CAMERA_PHOTO_EVENT_ERROR);
}

uint8_t camera_photo_has_image(void)
{
    FILE *file = fopen(CAMERA_PHOTO_FILE, "rb");

    if (file == RT_NULL)
        return 0U;
    fclose(file);
    return 1U;
}

uint32_t camera_photo_revision(void)
{
    return camera_photo_current_revision;
}
