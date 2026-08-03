#ifndef LCHSPI_DISPLAY_POWER_H_INCLUDED
#define LCHSPI_DISPLAY_POWER_H_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif

void display_power_init(void);
void display_power_wake(void);
void display_power_notify_activity(void);
int display_power_is_off(void);

#ifdef __cplusplus
}
#endif

#endif
