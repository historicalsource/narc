
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
;****************************************************************************
;* UTILITIES.ASM: FILE CONTAINS FREQUENTLY USED GENERAL PURPOSE FUNCTIONS.  *
;****************************************************************************

        .include \VIDEO\SYS.INC
        .include \VIDEO\GSP.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include UTILITIE.MAC

        .TEXT
        .EVEN

;****************************************************************************
;* INITCOLR: INITIALIZE COLORS; ROUTINE LOADS PALETTE 0 WITH THE COLOR      *
;*           PALETTE USED BY DIAGNOSTIC TESTS.                              *
;****************************************************************************

INITCOLR:

;       ===============================
;       | ZAP COLOR PALETTES          |
;       ===============================

        MOVI (PALETTE15_END-PALETTE00_START)/16+1, A14, L
        MOVI PALETTE00_START, A13, L
        CLR  A12

$001:   MOVE A12, *A13+
        DSJS A14, $001

;       ===============================
;       | LOAD/SELECT PALETTE ZERO    |
;       ===============================

        MOVI COLOR_TABLE_START, A14, L
        MOVI COLOR_TABLE_END, A13, L

        SUB A14, A13
        SRL  4H, A13
        INC A13

        MOVI PALETTE00_START, A12, L

$002:   MOVE *A14+, *A12+
        DSJS A13, $002

        CLR  A14
        MOVE A14, @CMAPSEL

        FRET B5

        .PAGE

;****************************************************************************
;* POINT: FUNCTION DISPLAYS A POINT OF ANY COLOR.                           *
;*                                                                          *
;*            ENTRY: A0 = XY SCREEN ADDRESS OF THE POINT                    *
;*                   A1 = COLOR VALUE                                       *
;*                   B6 = RETURN ADDRESS                                    *
;*                                                                          *
;*            USES:  A0, A1, B2, B3, B4, B6, B10                            *
;****************************************************************************

POINT:

        MOVI SCRN_PTCH, DPTCH
        CLR  OFFSET

        LMO  DPTCH, B10
        MOVE B10, @CONVDP

        PIXT A1, *A0.XY
  
        FRET B6

        .PAGE

;****************************************************************************
;* RECTANGLE: FUNCTION DISPLAYS A RECTANGLE OF ANY COLOR.                   *
;*                                                                          *
;*            ENTRY: A0 = XY SCREEN ADDRESS OF UPPER LEFT CORNER            *
;*                   A1 = XY RECTANGLE DIMENSIONS                           *
;*                   A2 = COLOR VALUE                                       *
;*                                                                          *
;*                   B6 = RETURN ADDRESS                                    *
;*                                                                          *
;*            USES:  A0, A1, A2, B2, B3, B4, B6, B7, B9, B10                *
;****************************************************************************

RECTANGLE:

        MOVI SCRN_PTCH, DPTCH
        CLR  OFFSET

        LMO  DPTCH, B10
        MOVE B10, @CONVDP

        MOVE A2, COLOR1
        MOVE A0, DADDR
        MOVE A1, DYDX

        FILL  XY

        FRET B6

        .PAGE

;****************************************************************************
;* LINE: FUNCTION DRAWS HORIZONTAL OR VERTICAL LINES OF ANY COLOR.          *
;*                                                                          *
;*            ENTRY: A0 = BEGINNING XY SCREEN ADDRESS                       *
;*                   A1 = ENDING XY SCREEN ADDRESS                          *
;*                   A2 = COLOR VALUE                                       *
;*                                                                          *
;*                   B6 = RETURN ADDRESS                                    *
;*                                                                          *
;*            USES:  A0, A1, A2, A3, A4, B3, B4, B6, B9, B10                *
;****************************************************************************

HVLINE:

        MOVI SCRN_PTCH, DPTCH
        CLR  OFFSET

        LMO  DPTCH, B10
        MOVE B10, @CONVDP

        MOVE A2, COLOR1

        MOVK  1H, A2                    ; DRAV DX: ASSUME HORIZONTAL LINE

        MOVE  A0, A3                    ; DETERMINE (P2 > P1) OR (P2 < P1)
        CVXYL A3, A3

        MOVE  A1, A4
        CVXYL A4, A4

        CMP  A3, A4                     ; IF (P2 < P1) ~(INCREMENT)
        JRP  $100

        NEG  A2                         ; INCREMENT IS A SIGNED WORD
        ZEXT A2, 0

$100:   CMPXY A0, A1                    ; IF VERTICAL LINE
        JRZ   $110                      ; DRAV DX -> DRAV DY
        SLL   16, A2
        
$110:   DRAV  A2, A0                    ; DRAW LINE
        CMPXY A0, A1
        JRNN  $110
        JRNZ  $110

        FRET B6

        .PAGE

;****************************************************************************
;* STRING: FUNCTION DISPLAYS AN ASCIZ STRING OF ANY COLOR EITHER VERTICALLY *
;*         OR HORIZONTALLY.                                                 *
;*                                                                          *
;*            ENTRY: A0 = STARTING STRING ADDRESS                           *
;*                   A1 = XY SCREEN ADDRESS                                 *
;*                   A2 = DIRECTION                                         *
;*                   A3 = COLOR                                             *
;*                                                                          *
;*                   B6 = RETURN ADDRESS                                    *
;*                                                                          *
;*            USES: A0 - A6, B0 - B4, B6 - B14                              *
;****************************************************************************

STRING:

        MOVI SCRN_PTCH, DPTCH
        CLR  OFFSET

        LMO  DPTCH, B10
        MOVE B10, @CONVDP

        MOVE A3, COLOR1        
        CLR  COLOR0

        SETF 8, 0, 0

$200:   MOVE *A0+, A4                   ; GET CHARACTER
        JRZ  $230                       ; QUIT IFF NULL

        SUBK 32, A4                     ; GET POINTER TO CHARACTER HEADER
        SLL  5H, A4
        ADDI SYSFONT, A4, L
        MOVE *A4, A4, 1

        MOVE *A4+, A5, 1                ; CHAR DIMENSIONS
        MOVE  A5, DYDX

        CLR  A6                         ; A6 = CHAR WIDTH
        MOVX A5, A6

        ADDK 7, A6                      ; ROUND UP WIDTH TO INTEGRAL NUMBER
        SRL  3, A6                      ; OF BYTES = SOURCE PITCH
        SLL  3, A6
        MOVE A6, SPTCH

        MOVE *A4, A6, 1                 ; CHAR DATA
        MOVE  A6, SADDR
        
        MOVE A1, DADDR

        PIXBLT B,XY

        CLR  A6
        MOVE A2, A2
        JRZ  $210

        MOVY A5, A6                      ; A1 += (CHAR HEIGHT + SPACING)
        SRL  16, A6                      ; DIRECTION = DOWN
        ADDK 1H, A6
        SLL  16, A6
        ADD  A6, A1
        JRUC $200
        
$210:   MOVX A5, A6                      ; A1 += (CHAR WIDTH + SPACING)
        ADDK 2H, A6                      ; DIRECTION = RIGHT
        ADD  A6, A1
        JRUC $200

$230:   SETF 16, 1, 0
        FRET B6

        .PAGE

;****************************************************************************
;* CIRCLE: FUNCTION DRAWS OUTLINE OR FILLED CIRCLES.                        *
;*                                                                          *
;*       ENTRY: A0 = radius                                                 *
;*              A1 = center  (Y:X)                                          *
;*              A6 = <00:15> = color                                        *
;*              A6 = <15:31> = fill: 0=no fill, 1=fill                      *
;*                                                                          *
;*       USES:  A0 - A8, B0, B10                                            *
;**************************************************************************** 

CIRCLE:

        movi  plot8,a7               ; assume no fill
        btst  16,a6
        jrz   CIRC0
        movi  fill4,a7
CIRC0:
        movi  SCRN_PTCH,DPTCH        ; Restore screen pitch and convdp
        MOVI  13h,B10                ; THIS IS FASTER
        MOVE  B10,@CONVDP
        MOVE  A6,COLOR1
        movi  [1,0],DYDX                 ; Y width always 1

        clr   a2                      ; x = 0
        move  a0,a3                   ; y = r
        move  a0,a4
        sll   1,a4
        subk  3,a4
        neg   a4                     ; d = 3 - 2*r
cloop:
        cmp   a3,a2                  ; if x > y, we are done
        jrgt  done

        MOVE  A7, B0                 ; PLOT ROUTINE
        EXGPC B0

        move  a2,a5                  ; x -> a5
        btst  31,a4
        jrz   dpos                   ; branch if d is positive

;             d negative

        sll   2,a5                   ; 4*x -> a5
        addk  6,a5                   ; 4*x+6 -> a5
        jruc  cont

;             d positive

dpos:                

        sub   a3,a5                  ; x-y -> a5
        sll   2,a5                   ; 4*(x-y) -> a5
        addk  10,a5                  ; 4*(x-y)+10 -> a5
        subk  1,a3                   ; y = y - 1

cont:
        add   a5,a4                  ; d = d + a5
        addk  1,a2                   ; x = x + 1
        jruc  cloop

done:   FRET B6

plot8:
        move  a3,a5
        neg   a5                   ; -y into a5; +y in a3
        sll   16,a5
        sll   16,a3
        movx  a2,a5                ; a3 = (y:x)
        movx  a2,a3                ; a5 = (-y:x)

        movk  2,a8
put4:
        move  a1,a0                ; center (Y:X) in a0
        addxy a3,a0                ; (cx+x),(cy+y)
        pixt  a6,*a0.XY
        move  a1,a0                ; center (Y:X) in a0
        addxy a5,a0                ; (cx+x),(cy-y)
        pixt  a6,*a0.XY
        move  a1,a0                ; center (Y:X) in a0
        subxy a3,a0                ; (cx-x),(cy-y)
        pixt  a6,*a0.XY
        move  a1,a0                ; center (Y:X) in a0
        subxy a5,a0                ; (cx-x),(cy+y)
        pixt  A6,*a0.XY
        rl    16,a3
        rl    16,a5                ; transpose x and y        
        dsj   a8,put4
        sra   16,a3                ; restore y

        FRET B0

fill4:
        move  a2,b10               ; x
        sll   1,b10                ; 2x
        movx  b10,DYDX             ; delta x = 2x
        move  a3,a5
        neg   a5                   ; -y into a5      +y in a3
        sll   16,a5
        sll   16,a3
        movx  a2,a5                ; a3 = (y:x)
        movx  a2,a3                ; a5 = (-y:x)
        movk  2,a8
put2:        
        move  a1,a0
        subxy a5,a0
        move  a0,DADDR
        fill  XY

        move  a1,a0
        subxy a3,a0
        move  a0,DADDR
        fill  XY
        rl    16,a3                ; a3 = (x:y)
        rl    16,a5                ; transpose x and y        
        clr   a6
        subxy a5,a6
        move  a6,a5                ; a5 = (-x:y)
        move  a3,b10               ; y
        sll   1,b10                ; 2y
        movx  b10,DYDX             ; delta x = 2y
        dsj   a8,put2
        sra   16,a3                ; restore y

        FRET B0

        .PAGE

;****************************************************************************
;* ERROR_LED: MODULE DISPLAYS THE CURRENT BCD ERROR CODE ON THE DIAGNOSTIC  *
;*            LED (7 SEGMENT DISPLAY).                                      *
;*                                                                          *
;*            ENTRY: A0 = 4 DIGIT BCD ERROR CODE (MSD STARTS AT BIT 31)     *
;*            EXIT:  CARRY SET IFF ADVANCE BUTTON WAS PRESSED.              *
;*            USES:  A0, A1, A2, A3                                         *
;****************************************************************************

ERROR_LED:

        MOVK DIGIT_REPEAT, A1            ; NUMBER OF REPETITIONS

$300:   MOVI  LED_LETTER_E, A3           ; DISPLAY DELIMITER
        MOVE  A3, @SYS_REGISTER_00

        MOVI  DELIMITER_DISPLAY_TIME, A3, L
$301:   FCALL ADV_BUTTON_2, B3
        JRC   ERROR_LED_BREAK
        DSJS  A3, $301

        MOVI  LED_BLANK, A3              ; BLANK IT
        MOVE  A3, @SYS_REGISTER_00

        MOVI  DIGIT_BLANK_TIME, A3, L
$302:   FCALL ADV_BUTTON_2, B3 
        JRC   ERROR_LED_BREAK
        DSJS  A3, $302

        MOVK DIGIT_COUNT, A2             ; DIGIT COUNT
        RL   32-(4*DIGIT_COUNT), A0      ; LEFT JUSTIFY WITHIN REGISTER

$310:   RL   4H, A0                      ; GET NEXT MSD
        MOVE A0, A3

        ANDI 0FH, A3                     ; CONVERT DIGIT
        SLL  4H,  A3

        ADDI LED_TABLE_START, A3         ; GET DIGIT PATTERN
        MOVE *A3, A3
        
        MOVE  A3, @SYS_REGISTER_00       ; DISPLAY DIGIT
        MOVI  DIGIT_DISPLAY_TIME, A3, L

$311:   FCALL ADV_BUTTON_2, B3
        JRC   ERROR_LED_BREAK
        DSJS  A3, $311

        MOVI  LED_BLANK, A3              ; BLANK IT
        MOVE  A3, @SYS_REGISTER_00
        MOVI  DIGIT_BLANK_TIME, A3, L              

$312:   FCALL ADV_BUTTON_2, B3 
        JRC   ERROR_LED_BREAK
        DSJS  A3, $312

        DSJ A2, $310
        DSJ A1, $300

        CLRC
        FRET B6

ERROR_LED_BREAK:

        MOVI  LED_BLANK, A3              ; BLANK IT
        MOVE  A3, @SYS_REGISTER_00

        SETC
        FRET B6

        .PAGE

;****************************************************************************
;* ADV_BUTTON: FUNCTION READS THE STATE OF THE ADVANCE BUTTON.              *
;*                                                                          *
;*          ENTRY -- B6 = RETURN ADDRESS.                                   *
;*          EXIT  -- C  = SET IFF BUTTON PRESSED.                           *
;*          USES  -- B2                                                     *
;****************************************************************************

ADV_BUTTON:

;       ===========================
;       | ENTRY WITH BUTTON DOWN  |
;       ===========================

        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVANCE_FALSE

        PAUSE ADV_UP_TIME, B2		;ELIMINATE NOISE POSSIBILITY	

        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVANCE_FALSE

ADVANCE_TRUE:

        SETC
        FRET B6

ADVANCE_FALSE:

        CLRC
        FRET B6

        .PAGE

;****************************************************************************
;* ADV_BUTTON_2: FUNCTION READS THE STATE OF THE ADVANCE BUTTON. ROUTINE IS *
;*               IDENTICAL TO ADV_BUTTON EXCEPT THAT IT MAY BE CALLED ONLY  *
;*               WITHIN THE ERROR LED ROUTINE.                              *
;*                                                                          *
;*               ENTRY -- B3 = RETURN ADDRESS.                              *
;*               EXIT  -- C  = SET IFF BUTTON PRESSED.                      *
;*               USES  -- B2                                                *
;****************************************************************************

ADV_BUTTON_2

        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVANCE_FALSE_2

        PAUSE ADV_UP_TIME, B2		;ELIMINATE NOISE POSSIBILITY	

        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVANCE_FALSE_2
        
ADVANCE_TRUE_2:

        SETC
        FRET B3

ADVANCE_FALSE_2:

        CLRC
        FRET B3

**************************************************************************
*                                                                        *
* ADVANCE_WAIT: FUNCTION RETURNS WHEN THE ADVANCE BUTTON HAS GONE FROM   *
*			OFF TO ON, WITH DEBOUNCE.			 *
* 	USE THIS WHEN WAITING ON THE ADVANCE BUTTON TO CONTINUE.         *
*          ENTRY -- B6 = RETURN ADDRESS.                                 *
*          EXIT  -- C  = SET IFF BUTTON PRESSED.                         *
*          USES  -- B2                                                   *
*                                                                        *
**************************************************************************
ADVANCE_WAIT:
        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRZ ADVANCE_WAIT     	;BR = SWITCH IS DOWN
        PAUSE ADV_UP_TIME, B2	;DEBOUNCE	
        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRZ ADVANCE_WAIT	;BR = SPURIOUS SWITCH UP
ADVW1
        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVW1		;BR = SWITCH IS UP 	
        PAUSE ADV_UP_TIME, B2	;DEBOUNCE	
        MOVE @SWITCH_REGISTER_2, B2
        BTST 04, B2
        JRNZ ADVW1		;BR = SWITCH IS UP 	
        FRET B6

        .PAGE
*SCRCLR - CLEAR ENTIRE BIT MAP
*	USES:B2,B3,B4	CALL WITH B6
SCRCLR
	CLR	B2
	MOVI	SCREEN,B3,L
	MOVI	(SCRNE-SCREEN)/32,B4,L
SCRLP	MOVE	B2,*B3+,L
	DSJS	B4,SCRLP
	FRET	B6


*
*SOUND CALL - YAMAHA SIDE
*A6=SOUND CODE B0-B7
*CALL WITH B6
*
YAMSND:
	SLL	24,A6
	SRL	24,A6		;STRIP OFF BITS
	ADDI	0FD00H,A6	;PULL MUSIC SECTION INTERRUPT
	MOVE	A6,@SOUND,W	;HIT SOUND
	ORI	0FF00h,A6	;PUT OUT 1'S
	MOVE	A6,@SOUND,W
	FRET	B6	

        .END

