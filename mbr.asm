; Master boot record

[bits 16]
[org 0x7c00] ; copy the first sector from the device into physical memory at memory address 0x7C00

; Where to load kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

; Setup stack
mov bp, 0x9000
mov sp, bp

call load_kernel
call switch_to_32bit

jmp $

%include "disk.asm"
%include "gdt.asm"
%include "switch-to-32bit.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 2 ; dh -> num ssectors
    mov dl, [BOOT_DRIVE] ; dl -> disk
    call disk_load
    ret

[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET ; give control to kernel
    jmp $ ; loop in case kernel returns

; Boot drive variable
BOOT_DRIVE db 0

; Padding
time 410 - ($-$$) db  0

; Magic number
dw 0xaa55




