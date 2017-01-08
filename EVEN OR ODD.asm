.MODEL SMALL
.STACK 100H

.DATA
MSG DB "Enter a number : $"
MSG1 DB "NUMBER IS EVEN $"
MSG2 DB "NUMBER IS ODD $"

.CODE
MAIN PROC
    
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,MSG;
    MOV AH,9
    INT 21H 
    
    MOV AH,1;INPUT FUNCTION
    INT 21H
    MOV BL,AL
    
    
    CMP BL,'1'
    JE ODD
    
    CMP BL,'3'
    JE ODD
    
    CMP BL,'5'
    JE ODD
    
    CMP BL,'7'
    JE ODD  
    
    CMP BL,'9'
    JE ODD
    
    LEA DX,MSG1;
    MOV AH,9
    INT 21H  
    
    JMP EXIT
    
    
    ODD:
    LEA DX,MSG2;
    MOV AH,9
    INT 21H
    
    
    
    EXIT: 
    
    MOV AH,2;NEWLINE
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    MOV AH,4CH   ;EXIT TO DOS
    INT 21H
    MAIN ENDP
END MAIN
