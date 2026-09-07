#include <stdint.h>
#include <string.h>

#include "mbedtls/platform.h"
#include "mem_section.h"
#include "rtthread.h"

#if defined(BSP_USING_PSRAM) && defined(MBEDTLS_PLATFORM_MEMORY)

#define HSP_TLS_PSRAM_POOL_SIZE (96U * 1024U)

L2_NON_RET_BSS_SECT_BEGIN(hsp_tls_pool)
L2_NON_RET_BSS_SECT(
    hsp_tls_pool,
    ALIGN(64) static uint8_t hsp_tls_psram_pool[HSP_TLS_PSRAM_POOL_SIZE]);
L2_NON_RET_BSS_SECT_END

static struct rt_memheap hsp_tls_psram_heap;
static rt_bool_t hsp_tls_psram_heap_ready;

static rt_bool_t hsp_tls_pointer_is_in_pool(const void *pointer)
{
    uintptr_t address = (uintptr_t)pointer;
    uintptr_t begin = (uintptr_t)hsp_tls_psram_pool;

    return address >= begin && address < begin + sizeof(hsp_tls_psram_pool);
}

static void *hsp_tls_calloc(size_t count, size_t size)
{
    size_t total;
    void *pointer;

    if (count != 0U && size > SIZE_MAX / count)
        return RT_NULL;
    total = count * size;
    if (!hsp_tls_psram_heap_ready)
        return rt_calloc(count, size);

    pointer = rt_memheap_alloc(&hsp_tls_psram_heap, total);
    if (pointer == RT_NULL)
    {
        rt_kprintf("ota_tls: PSRAM allocation failed, %u bytes\n",
                   (unsigned int)total);
        return RT_NULL;
    }

    memset(pointer, 0, total);
    return pointer;
}

static void hsp_tls_free(void *pointer)
{
    if (pointer == RT_NULL)
        return;
    if (hsp_tls_pointer_is_in_pool(pointer))
        rt_memheap_free(pointer);
    else
        rt_free(pointer);
}

static int hsp_tls_memory_init(void)
{
    rt_err_t result;

    result = rt_memheap_init(&hsp_tls_psram_heap, "tlspsram",
                             hsp_tls_psram_pool,
                             sizeof(hsp_tls_psram_pool));
    if (result != RT_EOK)
    {
        rt_kprintf("ota_tls: PSRAM pool init failed: %d\n", result);
        return result;
    }

    hsp_tls_psram_heap_ready = RT_TRUE;
    if (mbedtls_platform_set_calloc_free(hsp_tls_calloc, hsp_tls_free) != 0)
    {
        hsp_tls_psram_heap_ready = RT_FALSE;
        rt_kprintf("ota_tls: cannot install MbedTLS allocator\n");
        return -RT_ERROR;
    }

    rt_kprintf("ota_tls: PSRAM pool ready, %u bytes\n",
               (unsigned int)sizeof(hsp_tls_psram_pool));
    return RT_EOK;
}
INIT_COMPONENT_EXPORT(hsp_tls_memory_init);

#endif
