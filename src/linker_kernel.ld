ENTRY(kmain)
SECTIONS {
    . = 0x2000;             /* load kernel at 0x2000 */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}
