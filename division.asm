.MODEL SMALL
.STACK 64
.DATA 
    A DW ?
    B DW ?
.CODE
MAIN PROC  
    
    CALL INDEC  ; 1ST INPUT
    
    MOV DX,0 ;make sure no thing in DX
    
    MOV A,AX 
    PUSH AX  
    
    MOV AH,2     ;NEW LINE
    MOV DL,0DH
    INT 21H
    
    MOV DL,0AH
    INT 21H 
    
    CALL INDEC  ; 2ND INPUT
    
    MOV DX,0 ;make sure no thing in DX
    
    MOV B,AX
    PUSH AX  
    
    MULTIPLY:
        POP BX
        POP AX 
        
        DIV BX
     
        PUSH DX
        PUSH AX
                           
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV DL,0AH
    INT 21H  
    
    POP AX
    
    CALL OUTDEC 
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV DL,0AH
    INT 21H
    
    POP AX
    
    CALL OUTDEC   
             
    
    MOV AH,4CH ;return to DOS
    INT 21H 
    
MAIN ENDP   

INCLUDE OUTDEC_FILE.ASM
INCLUDE INDEC_FILE.ASM
END MAIN
