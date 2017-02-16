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
   INC SUM
   CMP AL,20H
   JE SPACE
   
   CMP AL,0DH
   JNE INPUT 
   DEC SUM
  JMP OUTPUT 
    
    SPACE:
    DEC SUM
    JMP INPUT
    
    
    
   OUTPUT:
   MOV AH,2
   MOV DL,0DH
   INT 21H
   MOV DL,0AH
   INT 21H
   
   ADD SUM,48
   
   MOV AH,2
   MOV DL,SUM
   INT 21H
   
    
    
    
    
    MOV AH,4CH
    INT 21H
    MAIN ENDP
  END MAIN
