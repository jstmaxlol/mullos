#include "api/io.h"

/*
 *    Minimal API for kernel I/O basics
 */

volatile uint16_t* VGA = (volatile uint16_t*)0xB8000;
uint16_t cursor = 0;

void RealPrint(const char* str) {
    while(*str) {
        VGA[cursor++] = (uint8_t)(*str) | 0x0700; // white on black
        str++;
    }
} 
