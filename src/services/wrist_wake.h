#ifndef LCHSPI_WRIST_WAKE_H_INCLUDED
#define LCHSPI_WRIST_WAKE_H_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif

void wrist_wake_init(void);
int wrist_wake_is_enabled(void);
void wrist_wake_set_enabled(int enabled);

#ifdef __cplusplus
}
#endif

#endif
