; Code to read from disk using BIOS

disk_load:
    pusha ; push all general purpose registers 
    push dx

    mov ah, 0x02 ; Read mode
    mov al, dh ; REadh dh number of sectors
    mov cl, 0x02 ; start from sector 2 ; sector 1 is the boot sector
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13 ; BIOS interrupt
    jc disk_error ; Check carry bit for error

    pop dx ; Get back original number of sectors to read
    cmp al, dh ; BIOS set 'al' ti the # of sectors actually read ; compare it to 'dh' and error out if they are !=
    jne sectors_error
    
    popa
    ret

disk_error: ; Need to write code to show error code to user
    jmp disk_loop

sectors_error: ; Need to write code to show error code to user
    jmp disk_loop

disk_loop:
    jmp $