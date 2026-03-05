/*
 *    müll_kernel
 */

// C includes
#include <stddef.h>

// external includes
#include "headers/limine.h"

// limine things
__attribute__((used, section(".limine_requests_start")))
static volatile uint64_t limine_requests_start_marker[] = LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[] = LIMINE_BASE_REVISION(3);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
    .revision = 0
};

__attribute__((used, section(".limine_requests_end")))
static volatile uint64_t limine_requests_end_marker[] = LIMINE_REQUESTS_END_MARKER;

// API includes
#include "api/io.h"

void kernel_main(void) __attribute__((noreturn));

void _start(void) {
    return kernel_main();
}

void kernel_main(void) {
    //
}
