.MODEL SMALL
.STACK 100H
.CODE
MAIN PROC
    
    MOV CX,0
    
  pushin:
    MOV AH,1
    INT 21H
    MOV BL, AL
    
    
    CMP BL,0DH
    JE newline
    PUSH BX
    INC CX
    JMP pushin
    
    
  newline:
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
  popout:
    POP DX
    INT 21H
    loop popout
    
  exit:
    MOV AH,4CH
    INT 21H
    MAIN ENDP
END MAIN
