#ifndef TEST_RTTHREAD_H
#define TEST_RTTHREAD_H
#include <stdint.h>
#include <stdlib.h>
#define RT_ASSERT(expression) do { if (!(expression)) abort(); } while (0)
typedef uint32_t rt_uint32_t;
void rt_memory_info(rt_uint32_t *total, rt_uint32_t *used, rt_uint32_t *peak);
int rt_kprintf(const char *format, ...);
#endif
