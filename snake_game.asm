LEFT EQU 0
TOP EQU 2
ROW EQU 20
COL EQU 70
RIGHT EQU LEFT+COL
BOTTOM EQU ROW+TOP
.MODEL SMALL
.STACK 100H
.DATA
    ;welcome
    T1 DB  "  _______ _             _____             _         ",0
    T2 DB  " |__   __| |           / ____|           | |        ",0
    T3 DB  "    | |  | |__   ___  | (___  _ __   __ _| | _____  ",0
    T4 DB  "    | |  | '_ \ / _ \  \___ \| '_ \ / _` | |/ / _ \ ",0
    T5 DB  "    | |  | | | |  __/  ____) | | | | (_| |   <  __/ ",0
    T6 DB  "   _|_|_ |_| |_|\___| |_____/|_| |_|\__,_|_|\_\___| ",0
    T7 DB  "  / ____|                    | |                    ",0
    T8 DB  " | |  __  __ _ _ __ ___   ___| |                    ",0
    T9 DB  " | | |_ |/ _` | '_ ` _ \ / _ \ |                    ",0
    T10 DB " | |__| | (_| | | | | | |  __/_|                    ",0
    T11 DB "  \_____|\__,_|_| |_| |_|\___(_)                    ",0
    
    ;GAME OVER MSG:
    MSG_GameOver1 DB "  ___   __   _  _  ____     __   _  _  ____  ____ ",0 
    MSG_GameOver2 DB " / __) / _\ ( \/ )(  __)   /  \ / )( \(  __)(  _ \",0
    MSG_GameOver3 DB "( (_ \/    \/ \/ \ ) _)   (  O )\ \/ / ) _)  )   /",0
    MSG_GameOver4 DB " \___/\_/\_/\_)(_/(____)   \__/  \__/ (____)(__\_)",0
    
    ;INSTRUCTION
    INS1 DB "Instructions:",0
    INS2 DB "Press A For Turning Left",0
    INS3 DB "Press S For Moving Down",0
    INS4 DB "Press D For Turning Right",0
    INS5 DB "Press W For Moving Up",0
    INS6 DB "Press Any Key To Continue...",0
    
    ;WELCOME LINE
    WCL DB "Welcome To My Snake Game",0
    
    ;the snake body
    SNAKEHEAD DB '^',10,10
    SNAKEBODY DB '*',10,11,300 DUP(0)
    GAMEOVER DB 0
    SEGMENTCOUNT DB 1
    FRUITX DB 8
    FRUITY DB 8
    FRUITACTIVE DB 1
    QUIT DB 0
    
    
    ;DELEY TIME
    DELAYTIME DB 10
    SCORE DB "Score: ",0
    QUITMSG DB "Thanks For Playing...",0
    
.CODE
MAIN PROC FAR
    ;initializa data segment
    MOV AX,@DATA
    MOV DS,AX
    
    ;initialize memory
    MOV AX,0B800H
    MOV ES,AX
    
    ;clear the screen
    MOV AX,0003H
    INT 10H
    
    ;printing welcome note
    CALL WelcomeScreen
    CALL InstructionPrint
    
    ;WAIT FOR KEY PRESS
    MOV AH, 07H
    INT 21H
    
    ;CLEAR SCREEN
    MOV AX, 0003H
    INT 10H
    
    CALL PrintBoard
    
GAME_LOOP:
    CALL Delay
    ;printing welcome message
    MOV DX,0016h
    LEA BX,WCL
    CALL WriteStringAt
    CALL GoSnakeGo
    
    CMP GAMEOVER,1
    JE OK_ITS_OVER
    
    CALL KeyboardCTR
    CMP QUIT,1
    JE QUIT_PRESSED
    call FruitGeneration
    CALL DRAW
    
    JMP GAME_LOOP
    
OK_ITS_OVER:
    ;CLEAR SCREEN
    MOV AX, 0003H
    INT 10H
    
    MOV DELAYTIME,70
    MOV DX,0
    
    CALL GameOverPrint
    
    CALL DELAY
    JMP EXIT
    
QUIT_PRESSED:
    ;CLEAR SCREEN
    MOV AX, 0003H
    INT 10H
    
    MOV DELAYTIME,70
    MOV DX,0
    
    LEA BX,QUITMSG
    CALL WriteStringAt
    CALL Delay
    
EXIT:
    ;CLEAR SCREEN
    MOV AX, 0003H
    INT 10H
    
    ;TERMINATE
    MOV AH,4CH
    INT 21H
    
    MAIN ENDP
    
Delay PROC
    MOV AH,0
    INT 1AH
    
    MOV BX,DX
LP_:
    INT 1AH
    SUB DX,BX
    CMP DL,DELAYTIME
    JL LP_
    
    RET
Delay ENDP
DisplayDigit PROC
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    
    RET
DisplayDigit ENDP
DisplayNumber PROC
    TEST AX,AX
    JZ RETZERO
    
    XOR DX,DX
    ;AX CONTAIN NUMBER TO BE DISPLAYED
    MOV BX,10
    DIV BX
    
    PUSH DX
    CALL DisplayNumber
    
    POP DX
    CALL DisplayDigit
    RET
RETZERO:
    MOV AH,2
    RET
DisplayNumber ENDP
Draw PROC
    ;score field show
    LEA BX,SCORE
    MOV DX,011DH
    CALL WriteStringAt
    
    ;set cursor position
    ADD DX,7
    CALL MovCursor
    
    MOV AL,SEGMENTCOUNT
    DEC AL
    XOR AH,AH
    CALL DisplayNumber
    
    LEA SI,SNAKEHEAD
DRAW_LP:
    MOV BL,DS:[SI]
    TEST BL,BL  ;CHECK IF NOT EMPTY
    JZ OUT_DRAW
    MOV DX,DS:[SI+1]
    CALL WriteCharAt
    ADD SI,3
    JMP DRAW_LP
    
OUT_DRAW:
    ;DRAW FRUIT
    MOV BL,'F'
    MOV DH,FRUITY
    MOV DL,FRUITX
    CALL WriteCharAt
    MOV FRUITACTIVE,1
    
    RET
Draw ENDP
KeyboardCTR PROC
    ;READ A CHARACTER
    CALL ReadChar
    CMP DL,0
    JE NXT_4
    
    ;FIND THE OUT
    CMP DL,'w'
    JNE NXT_1
    CMP SNAKEHEAD,'V'
    JE NXT_4
    MOV SNAKEHEAD,'^'
    
    RET
NXT_1:
    CMP DL,'s'
    JNE NXT_2
    CMP SNAKEHEAD,'^'
    JE NXT_4
    MOV SNAKEHEAD,'V'
    
    RET
NXT_2:
    CMP DL,'a'
    JNE NXT_3
    CMP SNAKEHEAD,'>'
    JE NXT_4
    MOV SNAKEHEAD,'<'
    
    RET
NXT_3:
    CMP DL,'d'
    JNE NXT_4
    CMP SNAKEHEAD,'<'
    JE NXT_4
    MOV SNAKEHEAD,'>'
NXT_4:
    CMP DL,'q'
    JE QUIT_
    RET
QUIT_:
    INC QUIT
    RET
    
KeyboardCTR ENDP
    
WriteStringAt PROC
    ;dx contain row and column
    ;bx contain offset of the string
    
    PUSH DX
    MOV AX,DX
    AND AX,0FF00H
    SHR AX,8
    
    PUSH BX
    MOV BH,160
    MUL BH
    
    POP BX
    AND DX,0FFH
    SHL DX,1
    ADD AX,DX
    MOV DI,AX
LOOP_WRITE:
    MOV AL,[BX]
    TEST AL,AL
    JZ EXIT_WRITE
    MOV ES:[DI],AL
    ADD DI,2
    INC BX
    JMP LOOP_WRITE
    
EXIT_WRITE:
    POP DX
    RET
    
WriteStringAt ENDP
MovCursor PROC
    ;DH=ROW DL=COL
    MOV AH,2
    PUSH BX
    MOV BH,0
    INT 10H
    POP BX
    RET
MovCursor ENDP
ReadChar PROC
    ;DL HAS ASSCII CODE IF KEY PRESSED
    ;ELSE DL = 0
    MOV AH,1
    INT 16H
    JNZ PRESSED
    
    XOR DL,DL
    RET
    
PRESSED:
;EXTRACT KEY VAL FROM BUFFER
    MOV AH,0
    INT 16H
    MOV DL,AL
    RET
ReadChar ENDP
WelcomeScreen PROC
    ;prints welcome page
    LEA BX,T1
    MOV DX,000DH
    CALL WriteStringAt
    
    LEA BX,T2
    MOV DX,010DH
    CALL WriteStringAt
    
    LEA BX,T3
    MOV DX,020DH
    CALL WriteStringAt
    
    LEA BX,T4
    MOV DX,030DH
    CALL WriteStringAt
    
    LEA BX,T5
    MOV DX,040DH
    CALL WriteStringAt
    
    LEA BX,T6
    MOV DX,050DH
    CALL WriteStringAt
    
    LEA BX,T7
    MOV DX,060DH
    CALL WriteStringAt
    
    LEA BX,T8
    MOV DX,070DH
    CALL WriteStringAt
    
    LEA BX,T9
    MOV DX,080DH
    CALL WriteStringAt
    
    LEA BX,T10
    MOV DX,090DH
    CALL WriteStringAt
    
    LEA BX,T11
    MOV DX,0A0DH
    CALL WriteStringAt
    
    RET
    
WelcomeScreen ENDP
InstructionPrint PROC
    ;PRINTS INSTRUCTION TO PLAY THE GAME
    
    LEA BX,INS1
    MOV DX,0E0DH
    CALL WriteStringAt
    
    LEA BX,INS2
    MOV DX,0F0DH
    CALL WriteStringAt
    
    LEA BX,INS3
    MOV DX,100DH
    CALL WriteStringAt
    
    LEA BX,INS4
    MOV DX,110DH
    CALL WriteStringAt
    
    LEA BX,INS5
    MOV DX,120DH
    CALL WriteStringAt
    
    LEA BX,INS6
    MOV DX,140DH
    CALL WriteStringAt
    
    RET
    
InstructionPrint ENDP
GameOverPrint PROC
    ;PRINTS GAME OVER MESSAGE
    LEA BX,MSG_GameOver1
    MOV DX,0A0FH
    CALL WriteStringAt
    
    LEA BX,MSG_GameOver2
    MOV DX,0B0FH
    CALL WriteStringAt
    
    LEA BX,MSG_GameOver3
    MOV DX,0C0FH
    CALL WriteStringAt
    
    LEA BX,MSG_GameOver4
    MOV DX,0D0FH
    CALL WriteStringAt
    RET
    
GameOverPrint ENDP
PrintBoard proc
    ;prints game board
    MOV DH,TOP
    MOV DL,LEFT
    MOV CX,COL
    MOV BL,178
LP1:
    CALL WriteCharAt
    INC DL
    LOOP LP1
    
    MOV CX,ROW
LP2:
    CALL WriteCharAt
    INC DH
    LOOP LP2
    
    MOV CX,COL
LP3:
    CALL WriteCharAt
    DEC DL
    LOOP LP3
    
    MOV CX,ROW
LP4:
    CALL WriteCharAt
    DEC DH
    LOOP LP4
    
    RET
PrintBoard endp   
WriteCharAt PROC
    ;writes character at any position
    ;dx contain row,col
    ;bl contain char to write
    ;uses DI
    PUSH DX
    MOV AX,DX
    AND AX,0FF00H
    SHR AX,8
    
    PUSH BX
    MOV BH,160
    MUL BH
    
    POP BX
    
    AND DX,0FFH
    ;multiply by 2
    SHL DX,1
    ADD AX,DX
    MOV DI,AX
    MOV ES:[DI],BL
    POP DX
    
    RET
    
WriteCharAt ENDP
ReadCharAt PROC
    ;reads character at any position
    ;dx contain row,col
    ;bl contain char read
    ;uses DI
    PUSH DX
    MOV AX,DX
    AND AX,0FF00H
    SHR AX,8
    
    PUSH BX
    MOV BH,160
    MUL BH
    
    POP BX
    
    AND DX,0FFH
    ;multiply by 2
    SHL DX,1
    ADD AX,DX
    MOV DI,AX
    MOV BL,ES:[DI]
    POP DX
    
    RET
    
ReadCharAt ENDP
GoSnakeGo PROC
    ;draws the snake and moves it
    MOV BX,OFFSET SNAKEHEAD
    
    XOR AX,AX   ;CLEAR AX
    MOV AL,[BX] ;AL CONTAINS HEAD
    PUSH AX     ;PESERVE THE HEAD
    INC BX
    MOV AX,[BX]
    ADD BX,2
    
    XOR CX,CX   ;CLEAR CX
LOOP_:
    MOV SI,[BX]
    TEST SI,[BX]    ;TEST IF BX HAS A CHARACTER??
    JZ GETOUT
    
    INC CX
    INC BX
    MOV DX,[BX]
    MOV [BX],AX
    MOV AX,DX
    
    ADD BX,2
    JMP LOOP_ 
    
GETOUT:
    ;shift the head in proper direction
    ;clear the last segment
    ;if eaten fruit don't clear the last segment
        
    POP AX  ;AX NOW HAS THE SNAKE DIRECTION
    PUSH DX ;DX HAS THE COORDINATE OF LAST SEGMENT,WE WILL CLEAR IT
        
    LEA BX,SNAKEHEAD
    INC BX
    MOV DX,[BX]
    
    CMP AL,'<'
    JNE TEST_1
    
    SUB DL,2
    JMP HEAD_CHECKING_DONE
TEST_1:
    CMP AL,'>'
    JNE TEST_2
    
    ADD DL,2
    JMP HEAD_CHECKING_DONE
    
TEST_2:
    CMP AL,'^'
    JNE TEST_3
    
    DEC DH
    JMP HEAD_CHECKING_DONE
    
TEST_3:
    ;ONE OPTION LEFT 'V'
    INC DH
    
HEAD_CHECKING_DONE:
    MOV [BX],DX
    ;DX HAS THE NEW HEAD POSITION
    ;CHECK WHAT IS IN THAT POSITION
    
    CALL ReadCharAt
    
    CMP BL,'F'  ;CHECK IF FRUITE
    JE AH_FOOD
    
    ;IF NOT EATEN,CLEAR THE LAST SEGMENT
    MOV CX,DX
    POP DX
    CMP BL,'*'  ;BIT ITSELF!!
    JE U_R_FINISHED
    
    MOV BL,0
    CALL WriteCharAt
    MOV DX,CX
    
    ;CHECK BOUNDARY
    CMP DH,TOP
    JE U_R_FINISHED
    
    CMP DH,BOTTOM
    JE U_R_FINISHED
    
    CMP DL,RIGHT
    JE U_R_FINISHED
    
    CMP DL,LEFT
    JE U_R_FINISHED
    
    RET
U_R_FINISHED:
    INC GAMEOVER
    RET
    
AH_FOOD:
    ;ADD NEW SEGMENT AT LAST
    MOV AL,SEGMENTCOUNT
    XOR AH,AH   ;CLEAR AH
    
    ;GET TOTAL LENGTH
    LEA BX,SNAKEBODY
    MOV CX,3
    MUL CX
    
    POP DX
    ADD BX,AX
    MOV BYTE PTR DS:[BX],'*'
    MOV [BX+1],DX
    INC SEGMENTCOUNT    ;ADD ONE SEGMENT
    
    ;LETS EAT
    MOV DH,FRUITY
    MOV DL,FRUITX
    MOV BL,0
    CALL WriteCharAt
    MOV FRUITACTIVE,0
    
    RET
GoSnakeGo ENDP
FruitGeneration PROC
    MOV CH,FRUITY
    MOV CL,FRUITX
REGEN:
    CMP FRUITACTIVE,1
    JE RET_FRIUTACTIVE
    MOV AH,00
    INT 1AH
    ;DX CONTAINS THE TICS
    PUSH DX
    
    ;GENERATE Y CO-ORDINATE
    MOV AX,DX
    XOR DX,DX
    XOR BH,BH
    MOV BL,ROW
    DEC BL
    DIV BX
    MOV FRUITY,DL
    INC FRUITY
    
    ;GENERATE X CO-ORDINATE
    POP AX
    MOV BL,COL
    DEC DL
    XOR BH,BH
    XOR DX,DX
    DIV BX
    MOV FRUITX,DL
    INC FRUITX
    
    ;CHECK IF FRUIT IS IN IT'S PRESENT POINT
    CMP FRUITX,CL
    JNE FINE
    CMP FRUITY,CH
    JNE FINE
    JMP REGEN
    
FINE:
    MOV AL,FRUITX
    ROR AL,1
    JC REGEN
    
    ADD FRUITY,TOP
    ADD FRUITX,LEFT
    
    MOV DH,FRUITY
    MOV DL,FRUITX
    CALL ReadCharAt
    ;CHECK IF SNAKE IS ON THAT POINT
    CMP BL,'*'
    JE REGEN
    CMP BL,'>'
    JE REGEN
    CMP BL,'<'
    JE REGEN
    CMP BL,'^'
    JE REGEN
    CMP BL,'V'
    JE REGEN
    
RET_FRIUTACTIVE:
    RET
    
FruitGeneration ENDP    
  
END MAIN
