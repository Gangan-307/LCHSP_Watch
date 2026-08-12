#ifndef LCHSPI_HOME_GESTURES_H_INCLUDED
#define LCHSPI_HOME_GESTURES_H_INCLUDED

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void home_gestures_open_controls(void);
void home_gestures_open_notifications(void);
uint8_t home_gestures_handle_back(void);
void home_gestures_refresh_controls_state(void);
void home_gestures_destroy(void);

#ifdef __cplusplus
}
#endif

#endif
