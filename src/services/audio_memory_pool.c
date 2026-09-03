#include "rtthread.h"

#include <stdint.h>
#include <string.h>

#include "mem_section.h"

#if defined(BSP_USING_PSRAM) && !defined(_MSC_VER) && !PKG_USING_FFMPEG

#define AUDIO_PSRAM_POOL_SIZE (128U * 1024U)

L2_NON_RET_BSS_SECT_BEGIN(audio_pool)
L2_NON_RET_BSS_SECT(
    audio_pool,
    ALIGN(64) static uint8_t audio_psram_pool[AUDIO_PSRAM_POOL_SIZE]);
L2_NON_RET_BSS_SECT_END

static struct rt_memheap audio_psram_heap;
static rt_bool_t audio_psram_heap_ready;

static int audio_memory_pool_init(void)
{
    rt_err_t result;

    result = rt_memheap_init(&audio_psram_heap, "audpsram",
                             audio_psram_pool,
                             sizeof(audio_psram_pool));
    if (result == RT_EOK)
    {
        audio_psram_heap_ready = RT_TRUE;
        rt_kprintf("audio_mem: PSRAM pool ready, %u bytes\n",
                   (unsigned int)sizeof(audio_psram_pool));
    }
    else
    {
        rt_kprintf("audio_mem: PSRAM pool init failed: %d\n", result);
    }
    return result;
}
INIT_COMPONENT_EXPORT(audio_memory_pool_init);

static rt_bool_t audio_memory_is_in_psram_pool(const void *pointer)
{
    uintptr_t address = (uintptr_t)pointer;
    uintptr_t begin = (uintptr_t)audio_psram_pool;

    return address >= begin && address < begin + sizeof(audio_psram_pool);
}

/* These override the SDK weak hooks used by Helix and the audio resampler. */
void *audio_mem_malloc(uint32_t size)
{
    void *pointer = RT_NULL;

    if (audio_psram_heap_ready)
        pointer = rt_memheap_alloc(&audio_psram_heap, size);
    if (pointer == RT_NULL)
        pointer = rt_malloc(size);
    return pointer;
}

void audio_mem_free(void *pointer)
{
    if (pointer == RT_NULL)
        return;
    if (audio_memory_is_in_psram_pool(pointer))
        rt_memheap_free(pointer);
    else
        rt_free(pointer);
}

void *audio_mem_calloc(uint32_t count, uint32_t size)
{
    size_t total;
    void *pointer;

    if (count != 0U && size > SIZE_MAX / count)
        return RT_NULL;
    total = (size_t)count * size;
    pointer = audio_mem_malloc((uint32_t)total);
    if (pointer != RT_NULL)
        memset(pointer, 0, total);
    return pointer;
}

void *audio_mem_realloc(void *pointer, unsigned int new_size)
{
    if (pointer == RT_NULL)
        return audio_mem_malloc(new_size);
    if (new_size == 0U)
    {
        audio_mem_free(pointer);
        return RT_NULL;
    }
    if (audio_memory_is_in_psram_pool(pointer))
        return rt_memheap_realloc(&audio_psram_heap, pointer, new_size);
    return rt_realloc(pointer, new_size);
}

#endif
