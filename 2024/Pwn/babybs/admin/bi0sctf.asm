[org 0x7c00]  ; Boot sector origin
[bits 16]     ; 16-bit real mode

targetPassword dd 0x13371337  ; Target password
userPassword dd 0x00000000    ; User-entered password
currentIndex db 0             ; Current byte index for adjustment

start:
    cli                         ; Clear interrupts
    xor ax, ax                  ; Clear AX register
    mov ds, ax                  ; Set DS to 0
    mov es, ax                  ; Set ES to 0
    mov ss, ax                  ; Set SS to 0
    mov sp, 0xFFFF              ; Set SP to 0xFFFF
    sti                         ; Set interrupts

main_loop:
    call getInput               ; Get input for byte selection

    cmp al, 0x1B                ; Check if ESC key was pressed (ESC scan code is 0x1B)
    je exit                     ; Exit if ESC is pressed
    ; subtract 0x30 from the input to get the index
    sub al, 0x30                ; Convert ASCII to integer
    mov [currentIndex], al      ; Store the current index for adjustment

adjust_loop:
    call adjust_byte            ; Adjust the selected byte
    ; check if the user password is equal to the target password
    mov eax, [userPassword]     ; Load the user password into EAX
    cmp eax, [targetPassword]   ; Compare the user password with the target password
    jne main_loop               ; Continue main loop if not equal
    ; check if the user password is equal to the target password

exit:
    jmp $                        ; Infinite loop to halt execution

; Subroutine to get input for byte selection
getInput:
    mov ah, 0x00
    int 0x16                    ; Wait for a key press
    ret

; Subroutine for adjusting the selected byte
adjust_byte:
    mov ah, 0x00
    int 0x16                    ; Wait for a key press for adjustment

    cmp ah, 0x48                ; Check if up arrow key (scan code)
    je increment_byte
    cmp ah, 0x50                ; Check if down arrow key (scan code)
    je decrement_byte
    cmp al, 0x1C                ; Check if Enter key (scan code for Enter)
    je main_loop                ; Go back to selecting index if Enter is pressed
    jmp adjust_byte             ; Stay in adjustment loop for more adjustments

increment_byte:
    xor ah, ah          ; Clear AH to zero-extend AL to AX
    mov al, [currentIndex]  ; Load the current index into AL
    add ax, userPassword    ; Adjust AX by the address of userPassword (assuming userPassword is an immediate value)
    mov bx, ax          ; Move the result to BX for addressing
    add byte [bx], 1    ; Alternative way to increment the byte
    ret

decrement_byte:
    xor ah, ah          ; Clear AH to zero-extend AL to AX
    mov al, [currentIndex]  ; Load the current index into AL
    add ax, userPassword    ; Adjust AX by the address of userPassword (assuming userPassword is an immediate value)
    mov bx, ax          ; Move the result to BX for addressing
    sub byte [bx], 1    ; Alternative way to decrement the byte
    ret

times (510-56)-($-$$) db 0  ; Pad remainder of boot sector with zeros
flag db "bi0sctf{g4s_g4s_g4s_1m_g0nna_st3p_0n_th3_g4s_773048f384}"
dw 0xAA55              ; Boot signature