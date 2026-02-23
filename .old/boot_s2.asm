; boot_stage2.asm - stage2
[bits 32]

global _start
extern kmain

section .text

_start:
        ; reload segments
        mov ax, 0x10
        mov ds, ax
        mov es, ax
        mov ss, ax
        mov fs, ax
        mov gs, ax
        mov esp, 0x90000                ; stack

        mov dword [0xB8000], 0x07410741
        call kmain

        hlt

