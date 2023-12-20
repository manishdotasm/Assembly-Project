.MODEL SMALL
.STACK 100h

.DATA
    result1 DB "The number at 6800H: $"
    result2 DB 10, "The square of "
    result3 DB " is $"

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print the numbers at 6800H
    MOV CX, 5
    MOV SI, 6800H
PRINT_NUMBERS:
    LEA DX, result1
    MOV AH, 9
    INT 21h
    MOV AX, [SI]   ; Load the number from memory
    CALL PRINT_DEC
    MOV DL, 10      ; Print a newline
    MOV AH, 2
    INT 21h
    ADD SI, 2      ; Move to the next word
    LOOP PRINT_NUMBERS

    ; Calculate squares and store them in 8000H
    MOV SI, 6800H  ; Point SI back to input numbers
    MOV DI, 8000H  ; Point DI to output squares
    MOV CX, 5
SQUARE_LOOP:
    MOV AX, [SI]   ; Load the number from memory
    MUL AX         ; AX = AX * AX (square the number)
    MOV [DI], AX   ; Store the square in memory
    ADD SI, 2      ; Move to the next word in input
    ADD DI, 2      ; Move to the next word in output
    LOOP SQUARE_LOOP

    ; Print the squares
    MOV CX, 5
    MOV SI, 6800H  ; Reset SI to the beginning of the input numbers
PRINT_SQUARES:
    LEA DX, result2
    MOV AH, 9
    INT 21h
    MOV AX, [SI]   ; Load the original number from memory
    CALL PRINT_DEC
    LEA DX, result3
    MOV AH, 9
    INT 21h
    MOV AX, [DI]   ; Load the square from memory
    CALL PRINT_DEC
    MOV DL, 10     ; Print a newline
    MOV AH, 2
    INT 21h
    ADD SI, 2      ; Move to the next word in input
    ADD DI, 2      ; Move to the next word in output
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
