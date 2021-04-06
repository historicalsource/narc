
;****************************************************************************
;* CTLCHECK.ASM: CONTROL CHECK; FILE TESTS PLAYER CONTROL FUNCTIONS.        *
;*		USES A10 & A13 FOR SURE!					    *
;****************************************************************************

        .TITLE 'CTLCHECK'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

        .include \VIDEO\GSP.INC
        .include \VIDEO\SYS.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include UTILITIE.MAC
        .include LAYOUT.MAC

	.BSS	PREVSW,32		;PREVIOUS SWITCH STATE
CTLCHECK:

        SETF	16, 0, 0
        SETF	32, 0, 1
	CLR	A13
        CLR	A14
        MOVE	A14,@CONTROL
	MOVE	A14,@PREVSW,L

;       ===============================
;       | READ CONTROL REGISTER       |
;       ===============================

READ1:   MOVE @SWITCH_REGISTER_1, A14,L
	CLR	A10
;       ===============================
;       | BIT00: LEFT JOY STICK UP    |
;       ===============================

BIT1_00:

        MOVI JOYSTICK2_UP, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

	SRL	1,A14
        JRC	$100
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$100:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT01: LEFT JOY STICK DOWN  |
;       ===============================

BIT1_01:

        MOVI JOYSTICK2_DOWN, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

	SRL	1,A14
	JRC	$110

	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$110:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT02: LEFT JOY STICK LEFT  |
;       ===============================

BIT1_02:

        MOVI JOYSTICK2_LEFT, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

        SRL	 1,A14
        JRC	 $120
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$120:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT03: LEFT JOY STICK RIGHT |
;       ===============================

BIT1_03:

        MOVI JOYSTICK2_RIGHT, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

	SRL	1,A14
	JRC	$130

	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$130:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT04: LEFT CROUCH PRESS    |
;       ===============================

BIT1_04:

        MOVI CROUCH2_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

	SRL	1,A14
	JRC	$140

	ADDK	1,A10
        MOVI (FILL* 10000H) + (GREEN* 256) + GREEN, A6

$140:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT05: LEFT GUN PRESS       |
;       ===============================

BIT1_05:

        MOVI GUN2_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$150

	ADDK	1,A10
        MOVI (FILL* 10000H) + (RED* 256) + RED, A6

$150:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT06: LEFT JUMP PRESS      |
;       ===============================

BIT1_06:

        MOVI JUMP2_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$160

	ADDK	1,A10
        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6

$160:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT07: LEFT ROCKET PRESS    |
;       ===============================

        MOVI ROCKET2_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

	SRL	1,A14
	JRC	$165

	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$165:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT08: RIGHT JOY STICK UP   |
;       ===============================
        MOVI JOYSTICK1_UP, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

        SRL	1,A14
        JRC	$170
	
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$170:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT09: RIGHT JOY STICK DOWN |
;       ===============================

        MOVI JOYSTICK1_DOWN, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

        SRL	1,A14
        JRC	$180
	
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$180:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT10: RIGHT JOY STICK LEFT |
;       ===============================

        MOVI JOYSTICK1_LEFT, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

        SRL	1,A14
        JRC	$190
	
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$190:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT11: RIGHT JOY STICK RIGHT|
;       ===============================

        MOVI JOYSTICK1_RIGHT, A9, L

        L_TXADR A9, A0
        L_XYADR A9, A1
        L_DIREC A9, A2
        L_COLOR A9, A3

        SRL	1,A14
        JRC	$200
	
	ADDK	1,A10
        MOVI (WHITE* 256) + WHITE, A3

$200:   FCALL STRING, B6        
	SLL	1,A10
;       ===============================
;       | BIT12: RIGHT CROUCH PRESS   |
;       ===============================

        MOVI CROUCH1_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$210
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (GREEN* 256) + GREEN, A6

$210:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT13: RIGHT GUN PRESS      |
;       ===============================

        MOVI GUN1_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$220
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (RED* 256) + RED, A6

$220:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT14: RIGHT JUMP PRESS     |
;       ===============================
        MOVI JUMP1_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$230
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6

$230:   FCALL CIRCLE, B6        
	SLL	1,A10
;       ===============================
;       | BIT15: RIGHT ROCKET PRESS   |
;       ===============================

        MOVI ROCKET1_PRESS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$235
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$235:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT16: LEFT COIN SLOT							 *
*                                                                        *
**************************************************************************
        MOVI LEFT_CS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$260
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$260:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT17: RIGHT COIN SLOT						 *
*                                                                        *
**************************************************************************
        MOVI RIHT_CS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$270
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$270:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT18: CENTER COIN SLOT						 *
*                                                                        *
**************************************************************************
        MOVI CNTR_CS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$280
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (GREEN* 256) + GREEN, A6

$280:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT19: SLAM TILT							 *
*                                                                        *
**************************************************************************
        MOVI SLAM_SW, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$290
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (RED* 256) + RED, A6

$290:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT20: ADVANCE							 *
*                                                                        *
**************************************************************************
        MOVI ADVANCE, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$300

	INC	A13			;INCREMENT TO EXIT
	ADDK	1,A10

        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6
$300:   FCALL CIRCLE, B6        
	SLL	1,A10
*****************************************************************************
****                                                                        *
**** BIT21: AUTO-UP/MANUAL-DOWN						 *
****                                                                        *
*****************************************************************************
***        MOVI AUTOCYC, A9, L
***
***        C_RDIUS A9, A0
***        C_XYADR A9, A1
***        C_COLOR A9, A6

        SRL	1,A14		;SKIP AUTO/MANUAL SWITCH
***        JRC	$310
***	ADDK	1,A10
***        MOVI (FILL* 10000H) + (RED* 256) + RED, A6

***$310:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT22: HIGH SCORE RESET						 *
*                                                                        *
**************************************************************************
        MOVI COINVAULT, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$320
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6

$320:   FCALL CIRCLE, B6        
	SLL	1,A10

**************************************************************************
*                                                                        *
* BIT23: EXTRA COIN SWITCH INPUT					 *
*                                                                        *
**************************************************************************
        MOVI EXTRA_CS, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$330
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (GREEN* 256) + GREEN, A6

$330:   FCALL CIRCLE, B6        
	SLL	1,A10

**************************************************************************
*                                                                        *
* BIT24: PLAYER 1 START							 *
*                                                                        *
**************************************************************************
        MOVI P2_START, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$240

	ADDK	1,A10
       .IF	BLUEP1
        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6
       .ELSE
        MOVI (FILL* 10000H) + (RED* 256) + RED, A6
       .ENDIF

$240:   FCALL CIRCLE, B6        
	SLL	1,A10
**************************************************************************
*                                                                        *
* BIT25: PLAYER 2 START							 *
*                                                                        *
**************************************************************************
        MOVI P1_START, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$250
	ADDK	1,A10
       .IF	BLUEP1
        MOVI (FILL* 10000H) + (RED* 256) + RED, A6
       .ELSE
        MOVI (FILL* 10000H) + (BLUE* 256) + BLUE, A6
       .ENDIF

$250:   FCALL CIRCLE, B6        
	SLL	1,A10

	SRL	1,A14			;SKIP BIT26 (SOUND BOARD TALKBACK)

**************************************************************************
*                                                                        *
* BIT27: MEMORY PROTECT							 *
*                                                                        *
**************************************************************************
        MOVI MEMPROT, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$255
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (GREEN* 256) + GREEN, A6

$255:   FCALL CIRCLE, B6        
	SLL	1,A10

	SRL	1,A14		;SKIP BIT 28
	SRL	1,A14		;SKIP BIT 29

**************************************************************************
*                                                                        *
* BIT30: "CUT FOR" FRENCH JUMPER					 *
*                                                                        *
**************************************************************************
        MOVI CUTFRENCH, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$568
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$568:   FCALL CIRCLE, B6        
	SLL	1,A10

**************************************************************************
*                                                                        *
* BIT30: "CUT FOR" GERMAN JUMPER					 *
*                                                                        *
**************************************************************************
        MOVI CUTGERMAN, A9, L

        C_RDIUS A9, A0
        C_XYADR A9, A1
        C_COLOR A9, A6

        SRL	1,A14
        JRC	$569
	
	ADDK	1,A10
        MOVI (FILL* 10000H) + (YELLOW* 256) + YELLOW, A6

$569:   FCALL CIRCLE, B6        

	MOVE	@PREVSW,A14,L
	MOVE	A10,@PREVSW,L
	ANDN	A14,A10
	JRZ	ENDCHEK			;BR = NO CHANGE IN SWITCH STATE
	MOVI	0FDA2H,A0
	MOVE	A0,@SOUND,W
	MOVI	0FFA2H,A0
	MOVE	A0,@SOUND,W
ENDCHEK
	MOVE	A13,A13
	JREQ	READ1
CTLXXXX
	PAUSE	100000H,B6
        FRET B5

        .PAGE

;****************************************************************************
;* VIEWCNTL.ASM: ROUTINE DRAWS THE PLAYER CONTROLS.                         *
;****************************************************************************

VIEWCNTL:

        CLR  A0                         ; PPOP = REPLACE
        MOVE A0, @CONTROL

        CLEARSCR

;       ==============================
;       | DISPLAY CIRCLES            |
;       ==============================

        MOVI CONTROL_CIRCS, A14, L

$500:   C_COLOR A14, A6                 ; LOAD CIRCLE PARAMETERS
        C_XYADR A14, A1
        C_RDIUS A14, A0

        FCALL CIRCLE, B6

        C_END A14, $500

;       ==============================
;       | DISPLAY RECTANGLES         |
;       ==============================

**************************************************************************
*                                                                        *
*         MOVI CONTROL_RECTS, A14, L					 *
* 									 *
* $600:   R_XYADR A14, A0                 ; LOAD RECTANGLE PARAMETERS	 *
*         R_DIMEN A14, A1						 *
*         R_COLOR A14, A2						 *
* 									 *
*         FCALL RECTANGLE, B6						 *
* 									 *
*         R_END A14, $600						 *
*                                                                        *
**************************************************************************

;       ==============================
;       | DISPLAY LABELS.            |
;       ==============================

        MOVK T, A0                      ; PPOP = TRANSPARENCY
        MOVE A0, @CONTROL

        MOVI CONTROL_LABELS, A14, L

$700:   L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3

        FCALL STRING, B6

        L_END A14, $700

        FRET B5

        .END



