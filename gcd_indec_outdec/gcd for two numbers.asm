.MODEL SMALL
.DATA
M1 DB 0AH,0DH,'ENTER M $'
M2 DB 0AH,0DH,'ENTER N $'
M3 DB 0AH,0DH,'GCD IS $'
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,9
    LEA DX,M1
    INT 21H
    CALL INDEC ;read M
    PUSH AX ;save M
    MOV AH,9
    LEA DX,M2
    INT 21H
    CALL INDEC ;read N
    PUSH AX ;save N
    
    POP BX
    POP AX
    L1: MOV DX,0
    DIV BX ;M/N
    CMP DX,0
    JE GCD_FOUND ;BX IS N
    
    MOV AX,BX ;replace M by N
    MOV BX,DX ;replace N by R
    JMP L1
    GCD_FOUND:
    MOV AH,9
    LEA DX,M3
    INT 21H
    MOV AX,BX
    CALL OUTDEC

    MOV AH,4CH
    INT 21H
MAIN ENDP
INCLUDE outdec.asm
INCLUDE indec.asm
END MAIN
