.MODEL SMALL
.STACK 100H 
.DATA

.CODE
MAIN PROC 
    
    MOV AX,@DATA
    MOV DS,AX 
    
    XOR BX,BX  ;CLEAR BX
    MOV CL,4  ;COUNTER FOR 4 SHIFTS
    MOV AH,1
    INT 21H
    
    
    WHILE_:
    CMP AL,0DH  ;CR? 
    JE PRINT  ; YES,EXIT
    
    
    ;CONVERT CHARACTER TO BINARY VALUE
    CMP AL,39H  ;A DIGIT?
    JG LETTER  ; NO, A LETTER
    
    
    ;INPUT IS A DIGIT
    AND AL,0FH  ;CONVERT DIGIT TO BINARY VALUE
    JMP SHIFT   ;GO TO INSERT IN BX
    
    
    
    LETTER:
    SUB AL,37H  ;convert letter to binary
    
    SHIFT:
    SHL BX,CL  
    
    ;insert value into BX
    OR BL,AL ; put value into low 4 bits
    
    INT 21H
    JMP WHILE_
    
    
    
    PRINT:
    MOV CX,16
    
    L1:
    ROL BX,1
    ;JNC L2
    JC L3
    
    MOV AH,2
    MOV DL,'0'
    INT 21H
    LOOP L1 
    
    JMP EXIT
    
    L3:
    MOV AH,2
    MOV DL,'1'
    INT 21H
    LOOP L1
    
    
    EXIT:
    MOV AH,4CH
    INT 21H
    MAIN ENDP
END MAIN
