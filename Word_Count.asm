.MODEL SMALL
.STACK 100H

.DATA 

SUM DB 0


.CODE   

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    
    INPUT:
     MOV AH,1
     INT 21H
     
     CMP AL,20H
    JE WORD
    
    CMP AL,0DH
    JNE INPUT 
    
    INC SUM
    JMP OUTPUT
    
    WORD:
    INC SUM
    JMP INPUT

   OUTPUT:
   ADD SUM,48 
   
   MOV AH,2 
   MOV DL,0DH
   INT 21H
   MOV DL,0AH 
   INT 21H
   
   MOV AH,2 
   MOV DL,SUM
   INT 21H
   
   
   
  
   MOV AH,4CH
   INT 21H
   
   MAIN ENDP 
;INCLUDE READ_STR.ASM
;INCLUDE OUTDEC.ASM
END MAIN
