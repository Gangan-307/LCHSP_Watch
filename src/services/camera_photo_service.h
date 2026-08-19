#ifndef LCHSPI_CAMERA_PHOTO_SERVICE_H_INCLUDED
#define LCHSPI_CAMERA_PHOTO_SERVICE_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CAMERA_PHOTO_MAX_BYTES (16U * 1024U)
#define CAMERA_PHOTO_LVGL_PATH  "/camera.jpg"

typedef enum
{
    CAMERA_PHOTO_EVENT_READY = 0,
    CAMERA_PHOTO_EVENT_PERMISSION_REQUIRED,
    CAMERA_PHOTO_EVENT_NOT_FOUND,
    CAMERA_PHOTO_EVENT_ERROR,
} camera_photo_event_t;

typedef void (*camera_photo_event_cb_t)(camera_photo_event_t event);

void camera_photo_set_event_handler(camera_photo_event_cb_t handler);
int camera_photo_begin(uint16_t generation, uint32_t total_length,
                       uint32_t expected_crc32);
int camera_photo_data(uint16_t generation, uint32_t offset,
                      const uint8_t *data, uint16_t length);
void camera_photo_report_status(uint8_t status);
void camera_photo_cancel(void);
uint8_t camera_photo_has_image(void);
uint32_t camera_photo_revision(void);

#ifdef __cplusplus
}
#endif

#endif
