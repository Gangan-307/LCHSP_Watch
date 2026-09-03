#ifndef LCHSPI_LOCAL_AUDIO_ARBITER_H_INCLUDED
#define LCHSPI_LOCAL_AUDIO_ARBITER_H_INCLUDED

#include "rtthread.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
    LOCAL_AUDIO_OWNER_NONE,
    LOCAL_AUDIO_OWNER_SD_MUSIC,
    LOCAL_AUDIO_OWNER_RECORDING,
    LOCAL_AUDIO_OWNER_RECORDING_PLAYBACK,
} local_audio_owner_t;

void local_audio_arbiter_init(void);
rt_err_t local_audio_arbiter_acquire(local_audio_owner_t owner);
void local_audio_arbiter_release(local_audio_owner_t owner);
local_audio_owner_t local_audio_arbiter_owner(void);

#ifdef __cplusplus
}
#endif

#endif
