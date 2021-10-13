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

mov si, message ; Point SI register to message
mov ah, 0x0e    ; Set higher bits to the display character command

.loop:
    lodsb       ; Load the character within the AL register, and increment SI
    cmp al, 0   ; Is the AL register a null byte?
    je halt     ; Jump to halt
    int 0x10    ; Trigger video services interrupt
    jmp .loop   ; Loop again

halt:
    hlt         ; Stop

message:
    db "Call load_kernel", 0



; Boot drive variable
BOOT_DRIVE db 0

; Mark the device as bootable
times 510-($-$$) db 0 ; Add any additional zeroes to make 510 bytes in total
dw 0xAA55 ; Write the final 2 bytes as the magic number 0x55aa, remembering x86 little endian

