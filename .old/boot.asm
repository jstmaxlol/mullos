; boot.asm - stage 1

[bits 16]
[org 0x7C00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

                                    ; clear screen by big scrollup
    mov ah, 0x06                    ; scrollup function
    mov al, 0                       ; al contains the n of lines to scroll (0 is clearall)
    mov bh, 0x07                    ; 'attribute byte' 0x07 is white on black
    mov cx, 0x0000                  ; upper-left corner
    mov dx, 0x184F                  ; bottom-right corner

    int 0x10                        ; call
                                    ; set cursor position back to default
    mov ah, 0x02                    ; set cur pos function
                                    ; position parameters:
    mov bh, 0x00                    ; page number (0)
    mov dh, 0x00                    ; row
    mov dl, 0x00                    ; col

    int 0x10                        ; call

    mov si, msg1                    ; print msg1
    call print_string

    mov ah, 0x02                    ; set cur pos function
                                    ; position parameters:
    mov bh, 0x00                    ; page number (0)
    mov dh, 0x01                    ; row
    mov dl, 0x00                    ; col

    int 0x10                        ; call

    mov si, msg2                    ; print msg2
    call print_string

    mov ah, 0x02                    ; set cur pos function
                                    ; position parameters:
    mov bh, 0x00                    ; page number (0)
    mov dh, 0x02                    ; row
    mov dl, 0x00                    ; col

    int 0x10                        ; call

    mov si, msg3
    call print_string

    mov ah, 0x02                    ; set cur pos function
                                    ; position parameters:
    mov bh, 0x00                    ; page number (0)
    mov dh, 0x03                    ; row
    mov dl, 0x00                    ; col

    int 0x10                        ; call

load_stage2:
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x1000
                                    ; load stage2 from disk - first sector at 0x1000
    mov bx, 0x1000                  ; load address
    mov dh, 0
    mov ch, 0
    mov cl, 2                        ; sector 2
    mov al, 20                       ; sectors to read
    mov ah, 0x02

    int 0x13
    jc halt

                                    ; GDT for protected mode
gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF           ; code
    dq 0x00CF92000000FFFF           ; data
    gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1
    dd gdt_start

                                    ; enable protected mode cleanly and transfer to 32-bit stub
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

                                    ; far jump reloads CS with selector 0x08 and enters protected mode
    jmp 0x08:pm_entry

                                    ; 32-bit entry point
    [bits 32]
pm_entry:
                                    ; reload data segment registers with data selector (0x10)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000                ; setup stack

    mov eax, 0x1000                 ; jump to linear address 0x1000 (which wloud be where s2.bin was loaded)
    jmp eax

halt:
    hlt
    jmp halt

print_string:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg1 db `mull_bootloader hath bespoken unto thee:\n`, 0
msg2 db `\"behold, \'O user! mull_kernel doth now commence its solemn journey!\"\n`, 0
msg3 db `trying to kernel kernel :3`, 0

times 510-($-$$) db 0
dw 0xAA55
