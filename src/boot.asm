; well this is the only bit of code.

; system variables = 0x700 to 0x7ff
; kernel variables = 0x500 to 0x6ff
; command variables = 0x800 to 0x830 - commands can only be up to 48 letters - then 0x831 to 0x8ff for extra screen data like colour.
; stack = 0x9000
bits 16
org 0x7C00

%define command 0x800
%define command_length 48
%define newline 0xD, 0xA

main:
    cli
    mov [0x0700], dl
    mov bp, 0x9000
    mov sp, bp
    sti
start:
    mov bx, welcome_msg
    call print
    jmp prompt

prompt:
    mov bx, prompt_txt
    call print
    mov di, command
.loop:
    mov ah, 0x00
    int 0x16
    cmp al,0x0D
    je .return
    cmp al,0x08
    je .backspace
    cmp di, command+command_length-1
    jne .print
    jmp .loop
.print:
    mov [di], al
    inc di
    mov ah,0x0e
    int 0x10
    jmp .loop
.backspace:
    cmp di, command
    je .loop
    dec di
    mov byte [di], 0x00
    mov ah,0x0e
    ; we already have backspace in our buffer because of the readkey function! bytes saved = 3!
    int 0x10
    mov al, " "
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .loop
.return:
    mov bx, nl
    call print
    mov byte [di], 0
    mov dx, prompt
    push dx
    mov al,[command]
    cmp al,"h"
    je help
    cmp al,"p"
    je prt
    cmp al,"v"
    je ver
    cmp al,"s"
    je shutdown
    cmp al,"r"
    je reboot
    cmp al,"c"
    je cls
    mov bx, err_str
    call print
    ret
.end:
    ; should never happen
    cli
    hlt
; PRINT
; bx : string address
print:
    pusha
    mov ah, 0x0e
    jmp .letter

.letter:
    mov al,[bx]
    cmp al,0
    je .end
    int 0x10
    inc bx
    jmp .letter

.end:
    popa
    ret

help:
    mov bx, help_txt
    call print
    ret

prt:
    mov bl, [command+2]
    cmp bl,"i"
    je lprt
    mov bx, command+4
    call print
    ret

lprt:
    mov bx, command+6
    call print
    ret

shutdown:
    jmp $

reboot:
    int 0x19

ver:
    pop ax ; we don't care about ax anyways
    jmp start

cls:
    ; also handles colour
    mov bl, [command+2]
    cmp bl,"l"
    je colour
    mov ah, 0
    mov al, 0x03
    int 0x10
    mov bl, [0x831]
    call colour.finish
    ret

colour:
    mov bl, [command+4]
    sub bl, 0x30
    cmp bl, 0x10
    jg .hex_letter
    jmp .finish
.hex_letter:
    sub bl, 7
.finish:
    mov [0x831], bl
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 184FH
    mov bh, bl
    int 0x10
    mov bl, [command+2]
    cmp bl,"l"
    je .colfinish
    ret
.colfinish
    mov di, command+2
    mov byte [di],'s'
    jmp cls

welcome_msg: db  " /_  __  __  /_  /'\  /''/  /'", newline, "/_/ /_/ /_/ /_  /_,/ /__/  _/ 0.4.1 : Mimmeer 2026",newline,0

prompt_txt: db newline, "> ",0

nl: db newline,0

err_str: db "Not found.",0

help_txt: db "Help:https://github.com/mimmeer-dev/bootdos/blob/main/HELP.md.",0

;comment out below if you want to see size in bytes (uncomment them if you want to boot!)
times 510-($-$$) db 0
dw 0xAA55
