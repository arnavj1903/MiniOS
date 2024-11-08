org 0x7C00                 ; origin (directive), tells the assembler where bootloader is loaded in the memory - to calculate memory offsets
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;
; Prints a string to the screen.
; Params:
;    - ds:si points to string
;

puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb                  ; loads next character in al register
    or al, al              ; verify if next char is null
    jz .done               ; jumps to .done label if 0 flag is set

    mov ah, 0x0e           ; calls bios interrupt
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret 

main:
    ; setup data segments
    mov ax, 0              ; cant write to es/ds directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00         ; downwards growing stack

    ; print message
    mov si, os_name
    call puts

    hlt

.halt:
    jmp .halt

os_name: db 'SkibidiOS', ENDL, 0

times 510-($-$$) db 0      ; to fill rest of the memory (512 bytes) with 0's $ for current line and $$ code start address

DW 0xAA55                  ; dw is a directive stands for define word used to encode to the binary file