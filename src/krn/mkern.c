#define MÜLL_KERN

/*
 *    müll_kernel
 */

#include "api/io.h"

void kmain(void) __attribute__((noreturn));
void kmain(void) {
    RealPrint("the kernel says hii!");
    while (1);
}
