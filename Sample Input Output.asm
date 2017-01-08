.MODEL SMALL
.STACK 100H 
.DATA
MSG1 DB "O $"
MSG2 DB "E $"


.CODE
MAIN PROC 
    
    MOV AX,@DATA;Initialization of data segment
    MOV DS,AX
    
    MOV AL,1
    INT 21H 
    MOV BL,AL
    
    CMP BL,'1'
    JE L1
    
    
    LEA DX, MSG2
    MOV AH,9
    INT 21H 
    
    
    
    JMP EXIT
    
    L1:
    LEA DX, MSG1
    MOV AH,9
    INT 21H
    
    
    EXIT:
    MOV AH,4CH   ;EXIT TO DOS
    INT 21H
    MAIN ENDP
END MAIN
