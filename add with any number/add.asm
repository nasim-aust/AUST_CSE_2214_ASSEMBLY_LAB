.MODEL SMALL
.STACK 100H
.CODE
MAIN PROC
    CALL INDEC
    PUSH AX
    
    
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    CALL INDEC
    PUSH AX
    
    
    POP AX
    MOV BX,AX
    POP AX
    ADD AX,BX
    PUSH AX
    
    
    
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    
    POP AX
    CALL OUTDEC
    ;POP AX
    ;CALL OUTDEC 
    
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP

INCLUDE outdec.asm
INCLUDE indec.asm
END MAIN
