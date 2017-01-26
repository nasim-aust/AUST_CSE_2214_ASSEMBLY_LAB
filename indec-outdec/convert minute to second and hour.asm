.MODEL SMALL
.STACK 100H
.CODE
MAIN PROC
    
    CALL INDEC
    
    
    MOV DX,0
    MOV BX,60
    MUL BX
    
    PUSH AX
    PUSH DX
    POP DX
    
    MOV AH,2
    MOV DL,0DH
    INT 21H     ;newline
    MOV DL,0AH
    INT 21H
    
    POP AX 
    CALL OUTDEC
    ;second finished
    
    
    ;hour
    MOV DX,0
    MOV BX,3600
    DIV BX
    
    ;MOV AH,2
    ;MOV DL,0DH
    ;INT 21H     ;newline
    ;MOV DL,0AH
    ;INT 21H
    
    CALL OUTDEC
    POP AX
    
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP

INCLUDE outdec.asm
INCLUDE indec.asm
END MAIN
