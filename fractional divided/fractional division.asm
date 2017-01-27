.MODEL SMALL
.STACK 100H
.DATA

A DW ?
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
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H 
    
    MOV AH,2
    MOV DL,'0'
    INT 21H
    
    MOV AH,2
    MOV DL,'.'
    INT 21H 
    
    POP AX
    MOV BX,AX
    
    POP AX 
    MOV CX,3D 
    MOV A,10D
    
TOP:
    MUL A
    DIV BX
    ;PUSH AX
    CALL OUTDEC 
    MOV AX,DX  
    
    LOOP TOP
    
    
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP

INCLUDE outdec.asm
INCLUDE indec.asm
END MAIN
