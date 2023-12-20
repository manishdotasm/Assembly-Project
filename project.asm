.MODEL SMALL
.STACK 100h

.DATA
    nums DW 11, 21, 31, 41, 51  ; list of numbers
    squares DW 5 DUP(?)        ; Array to store their squares
    result1 DB "The square of "
    result2 DB " is $"

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Calculate the squares and store them
    MOV CX, 5
    MOV SI, 0
SQUARE_LOOP:
    MOV AX, nums[SI]
    MUL AX      ; AX = AX * AX (square the number)
    MOV squares[SI], AX
    ADD SI, 2  ; Move to the next word in the array
    LOOP SQUARE_LOOP

    ; Print the squares
    MOV CX, 5
    MOV SI, 0
PRINT_SQUARES:
    LEA DX, result1
    MOV AH, 9
    INT 21h
    MOV AX, nums[SI]
    CALL PRINT_DEC  ; Print the original number
    LEA DX, result2
    MOV AH, 9
    INT 21h
    MOV AX, squares[SI]
    CALL PRINT_DEC  ; Print the square
    MOV DL, 10      ; Print a newline
    MOV AH, 2
    INT 21h
    ADD SI, 2  ; Move to the next word in the array
    LOOP PRINT_SQUARES

    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; Procedure for decimal output
PRINT_DEC PROC
    PUSH AX      ; Save registers
    PUSH DX
    PUSH CX

    MOV CX, 0      ; Initialize digit counter
    MOV BX, 10     ; Divisor for decimal conversion

NEXT_DIGIT:
    MOV DX, 0      ; Clear DX for division
    DIV BX         ; Divide AX by 10
    ADD DX, 30H    ; Convert remainder to ASCII
    PUSH DX        ; Push digit onto stack
    INC CX         ; Increment digit counter
    CMP AX, 0      ; Check if quotient is zero
    JNE NEXT_DIGIT ; If not, continue dividing

PRINT_LOOP:
    POP DX         ; Pop digits from stack
    MOV AH, 2      ; INT 21h function for character output
    INT 21h
    LOOP PRINT_LOOP

    POP CX      ; Restore registers
    POP DX
    POP AX
    RET
PRINT_DEC ENDP

END MAIN
