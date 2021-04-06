
;****************************************************************************
;* RAMCHECK: MODULE VERIFIES THAT SYSTEM RAMS FUNCTION. RAMCHECK SETS BITS  *
;*           IN B0 THAT INDICATE WHICH CHIPS IN THE CURRENT CHIP TABLE ARE  *
;*           NOT FUNCTIONING. BIT (k) SET INDICATES THAT THE kTH ENTRY IN   *
;*           THE TABLE DID NOT PASS THE RAM TEST.                           *
;*                                                                          *
;* N.B:      ANY CHIP TABLE DEFINING SYSTEM RAM MUST CONTAIN =< 32 ENTRIES. *
;*                                                                          *
;*           ENTRY: A14 = POINTER TO BEGINNING OF RAM CHIP TABLE.           *
;*           USES:  A4 - A14, B0, B1, B6                                    *
;****************************************************************************

        .TITLE 'RAMCHECK'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

        .include \VIDEO\SYS.INC
        .include \VIDEO\GSP.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include UTILITIE.MAC
	.include RAMCHIPS.MAC
        .include LAYOUT.MAC

        .TEXT		  	
        .EVEN

RAMCHECK:

        SETF 16, 0, 0
        SETF 32, 0, 1

        CLR B0                          ; INITIALIZE ERROR REGISTER
        CLR B1                          ; INITIALIZE BITSET MASK
        INC B1

;       ===============================  
;       | LOAD NEXT CHIP RECORD       |
;       ===============================

$010:   RAMSADDR A14, A12               ; CHIP STARTING ADDRESS
        RAMEADDR A14, A13               ; CHIP ENDING ADDRESS
        RAMINTLV A14, A11               ; CHIP INTERLEAVE
        RAMWIDTH A14, A10               ; CHIP WIDTH

;       ===============================  
;       | COMPUTE CELL COUNT          |
;       ===============================

        SUB  A12, A13                   ; (END-START)/INTERLEAVE+1
        DIVU A11, A13
        INC  A13

;       ===============================  
;       | SET FIELD SIZES             |
;       ===============================

        MOVE A11, A9                    ; FS1 = INTERLEAVE
        ANDI ZERO_EXTEND, A9
        EXGF A9, 1

        MOVE A10, A9                    ; FS0 = WIDTH
        ANDI ZERO_EXTEND, A9
        EXGF A9, 0

;       ===============================  
;       | FILL: ASCENDING ORDER       |
;       ===============================

        MOVE A13, A9                    ; XEROX COUNT
        MOVE A12, A8                    ; XEROX START

        MOVI RANDOM_SEED, A7, L
        CLR  A5

$020:   SLA  1, A7                      ; GENERATE A PSEUDO
        JRV  $030                       ; RANDOM NUMBER
        ORI  2, A7
$030:   MOVE A7, A6
        ADDC A5, A6

        MOVE A6, *A8+, 1                ; WRITE

        DSJS A9, $020

;       ===============================  
;       | READBACK: ASCENDING ORDER   |
;       ===============================

        MOVE A13, A9                    ; XEROX COUNT
        MOVE A12, A8                    ; XEROX START

        MOVI RANDOM_SEED, A7, L

$040:   SLA  1, A7                      ; GENERATE A PSEUDO
        JRV  $050                       ; RANDOM NUMBER
        ORI  2, A7
$050:   MOVE A7, A6
        ADDC A5, A6

        MOVE *A8+, A4, 1                ; READ

        ZEXT  A6
        ZEXT  A4

        CMP A6, A4
        JRZ $060

        OR B1, B0                       ; FLAG ERROR
        JRUC $070                       ; BREAK !!

$060:   DSJS A9, $040

$070:   SETF 16, 0, 0                   ; RESET FIELDS
        SETF 32, 0, 1

***        FCALL ADV_BUTTON, B6            ; SAMPLE ADVANCE BUTTON
***        JRC   $071

        SLL 1H, B1                      ; ADVANCE
        RAMEND A14, $010

$071    FRET B5

        .PAGE

;****************************************************************************
;* VIEWRAMS: MODULE DRAWS THE RAM (CPU) BOARD.                              *
;*                                                                          *
;*           ENTRY: N/A                                                     *
;*           USES:  A0, A1, A2, A3, A14, B6                                 *
;****************************************************************************

VIEWRAMS:

        CLR  A0                         ; PPOP = REPLACE
        MOVE A0, @CONTROL

        CLEARSCR

;       ==============================
;       | DISPLAY VECTORS            |
;       ==============================

        MOVI CPUBOARD_VECTS, A14, L

$100:   V_SADDR A14, A0                 ; LOAD VECTOR PARAMETERS
        V_EADDR A14, A1
        V_COLOR A14, A2

        FCALL HVLINE, B6

        V_END A14, $100

;       ==============================
;       | DISPLAY RECTANGLES         |
;       ==============================

        MOVI CPUBOARD_RECTS, A14, L

$200:   R_XYADR A14, A0                 ; LOAD RECTANGLE PARAMETERS
        R_DIMEN A14, A1
        R_COLOR A14, A2

        FCALL RECTANGLE, B6

        R_END A14, $200

;       ==============================
;       | DISPLAY LABELS.            |
;       ==============================

        MOVK T, A0                      ; PPOP = TRANSPARENCY
        MOVE A0, @CONTROL

        MOVI CPUBOARD_LABELS, A14, L

$300:   L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3

        FCALL STRING, B6

        L_END A14, $300

        FRET B5

        .PAGE

;****************************************************************************
;* RAMSTATE: RAM STATE; ROUTINE USES THE REGISTER PRODUCED BY RAMCHECK TO   *
;*           LIGHT RAM CHIP ICONS RED OR GREEN.                             *
;*                                                                          *
;*           ENTRY: B0  = "RAMCHECK" RESULT REGISTER                        *
;*                  A14 = POINTER TO BEGINNING OF RAMCHIP TABLE             *
;*           USES:  A0, A1, A2, A12, A13, A14, B1, B6                       *
;****************************************************************************

RAMSTATE:
	CLR	B1

        MOVI P_MAX, A0                     ; PIXEL PROCCESING = MAX
        MOVE A0, @CONTROL

$400:   RAMRLINK A14, A13                  ; LINK TO CHIP ICON
        R_XYADR  A13, A0                   ; XY SCREEN ADDRESS
        R_DIMEN  A13, A1                   ; XY DIMENSIONS

        BTST 0, B0                         ; BIT(i)=1 -> iTH TABLE ENTRY
        JRNZ $500                          ; FAILED RAM TEST

        MOVI (GREEN * 256) + GREEN, A2
        FCALL RECTANGLE, B6

        JRUC $600

$500:   MOVI (RED * 256) + RED, A2
        FCALL RECTANGLE, B6

	MOVE	B1,B1
	JRNE	$600

        RAMNUMBR A14, A0
	INC	B1
        FCALL ERROR_LED, B6
***        JRC $610

$600:   SRL 1, B0
        RAMEND A14, $400

$610:   CLR  A14
        MOVE A14, @CONTROL

        FRET B5

        .END





