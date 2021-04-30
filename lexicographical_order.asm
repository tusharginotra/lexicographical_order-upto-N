DATA SEGMENT

 MSGH1 DB 0DH, 0AH, "PRINTING OF N NUMBERS IN LEXICOGRAPHICAL ORDER $" 
 
 MSG3 DB 0DH, 0AH, "ENTER THE NUMBER : $"
 MSG4 DB 0DH, 0AH, " :$"
 MSG5 DB 0DH,0AH, "THE NUMBERS IN LEXICOGRAPHICAL ORDER IS :$"
 
 ARRN DB 99 DUP (00H)
 LEN DB ?
 
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX
                  
                    
        MOV AH,09H
        LEA DX,MSGH1
        INT 21H
        
        CALL GET8
        MOV LEN,AL
        
        
        
        LEA SI,ARRN
        MOV CL,LEN
        MOV BL,01H
BK1:    
        
        MOV [SI],BL
        INC SI
        
        MOV AL,BL
        ADD AL,01H
        DAA
        MOV BL,AL
        
        MOV AL,CL
        SUB AL,01H
        DAS
        MOV CL,AL
        CMP CL,00H
        
        JNZ BK1
        
        MOV CH,LEN
        DEC CH
        
BACK2:  LEA SI,ARRN
        MOV CL,LEN
        MOV AL,CL
        SUB AL,01H
        DAS
        MOV CL,AL
BACK1:  MOV AL,[SI]
        MOV AH,[SI+1]
        
        AND AL,0F0H
        CMP AL,00H
        JE  FIRST0
        MOV AL,[SI]
        AND AL,0F0H
        MOV DL,CL
        MOV CL,04H
        ROL AL,CL
        MOV CL,DL
        JMP L
        
        
FIRST0: 
        MOV AL,[SI]
        AND AL,0FH        
        
L:      AND AH,0F0H
        JE SECOND0
        MOV AH,[SI+1]
        AND AH,0F0H
        MOV DL,CL
        MOV CL,04H
        ROL AH,CL
        MOV CL,DL
        
        JMP L2
        
SECOND0:
        MOV AH,[SI+1]
        AND AH,0FH        

L2:  
        CMP AL,AH
        JC SKIP
        JZ SKIP
        
        MOV AL,[SI]
        MOV AH,[SI+1]
        
        MOV [SI],AH
        MOV [SI+1],AL

SKIP:   INC SI
        
        MOV AL,CL
        SUB AL,01H
        DAS
        MOV CL,AL
        CMP CL,00H
       
        JNZ BACK1
        MOV AL,CH
        SUB AL,01H
        DAS
        MOV CH,AL
        CMP CH,00H
        JNZ BACK2
        
        MOV AH,09H
        LEA DX,MSG5
        INT 21H
        
        LEA SI,ARRN
        MOV CL,LEN
PRINT:  MOV AH,09H
        LEA DX,MSG4
        INT 21H      
        CALL PUT8
        INC SI
        MOV AL,CL
        SUB AL,01H
        DAS
        MOV CL,AL
        CMP CL,00H
        JNZ PRINT
        
    
         
         MOV AH,4CH
         INT 21H
         
PROC GET8
        PUSH CX
        MOV AH,01H
        INT 21H
        SUB AL,30H
        CMP AL,09H
        JLE G1
        SUB AL,07H
G1:     MOV CL,04H
        ROL AL,CL
        MOV CH,AL
        MOV AH,01H
        INT 21H
        SUB AL,30H
        CMP AL,09H
        JLE G2
        SUB AL,07H
G2:     ADD AL,CH
        POP CX
        RET
    
ENDP GET8

PROC PUT8 ; DISPLAYS 8 BIT NUMBER ON THE SCREEN
         PUSH CX
         MOV AL, [SI]
         AND AL, 0F0H 
         MOV CL, 04H
         ROL AL, CL
         ADD AL, 30H
         CMP AL, 39H
         JLE P1
         ADD AL, 07H
P1: MOV AH, 02H
         MOV DL, AL
         INT 21H 
         MOV AL, [SI]
         AND AL, 0FH 
         ADD AL, 30H
         CMP AL, 39H
         JLE P2
         ADD AL, 07H
P2:      MOV AH, 02H
         MOV DL, AL
         INT 21H 
         POP CX
         RET
ENDP PUT8
         
CODE ENDS
END START