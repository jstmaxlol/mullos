#ifndef MÜLL_KERN
#define MÜLL_KERN

/*
 *    müll_kernel
 */

// C includes
#include <stddef.h>

// external includes
#include "limine.h"

// API includes
#include "api/io.h"

__attribute__((used, section(".limine_requests")))
static volatile LIMINE_BASE_REVISION(2);

static volatile struct limine_framebuffer_request fb_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};

void kmain(void) __attribute__((noreturn));
void _start(void) {
    if (!fb_request.response) {
        for (;;) __asm__("hlt");
    }

    struct limine_framebuffer *fb =
        fb_request.response->framebuffers[0];

    uint32_t *pix = fb->address;
    pix[0] = 0x00FFFFFF;                        // white pixel

    //return kernel_main();
    for (;;) __asm__("hlt");
}

#endif

