#ifndef TEST_MEMORY_H
#define TEST_MEMORY_H
#include <stddef.h>
void *test_alloc(size_t size);
void *test_realloc(void *pointer, size_t size);
void test_free(void *pointer);
#endif
