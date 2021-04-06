;****************************************************************************
;* TVMCHECK.ASM: TV MONITOR CHECK; FILE CONTAINS ALL MONITOR TESTS.         *
;****************************************************************************

       .TITLE 'TVMCHECK'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

       .include \VIDEO\GSP.INC
       .include \VIDEO\SYS.INC

       .include SYSCHECK.SET
       .include SYSCHECK.GBL

       .include UTILITIE.MAC
       .include LAYOUT.MAC

       .TEXT
       .EVEN

;****************************************************************************
;* CNVCHECK.ASM: CONVERGENCE CHECK; FILE DISPLAYS A TEST PATTERN ON THE     *
;*               MONITOR USED TO ADJUST ITS CONVERGENCE.                    *
;****************************************************************************

CNVCHECK:

        CLEARSCR

;       ==============================
;       | DISPLAY VECTORS            |
;       ==============================

        MOVI CONVERGENCE_VECTS, A14, L

$100:   V_SADDR A14, A0                 ; LOAD VECTOR PARAMETERS
        V_EADDR A14, A1
        V_COLOR A14, A2

        FCALL HVLINE, B6

        V_END A14, $100

;       ==============================
;       | DISPLAY POINTS             |
;       ==============================

        MOVI CONVERGENCE_POINTS, A14, L
        MOVI [1,0], A2, L
        MOVI [0,1], A3, L

$200:   P_XYADR A14, A0                 ; UPPER LEFT
        P_COLOR A14, A1
        FCALL POINT, B6

        ADDXY A3, A0                    ; UPPER RIGHT
        FCALL POINT, B6

        ADDXY A2, A0                    ; LOWER RIGHT
        FCALL POINT, B6, L

        SUBXY A3, A0                    ; LOWER LEFT
        FCALL POINT, B6, L

        P_END A14, $200

        FRET B5

        .PAGE

;****************************************************************************
;* CLRCHECK.ASM: COLOR CHECK; FILE DISPLAYS TEST PATTERNS ON THE MONITOR    *
;*               USED TO CHECK COLOR PURITY.                                *
;****************************************************************************

CLRCHECK:

;       =========================
;       | DISPLAY PRIMARIES     |
;       =========================

        MOVI PRIMARY_COLORS, A14, L

$300:   R_XYADR A14, A0
        R_DIMEN A14, A1
        R_COLOR A14, A2

        FCALL RECTANGLE, B6

        R_END A14, $300

;       =========================
;       | SET PALETTE 0 FOR     |
;       | COLOR BARS.           |
;       =========================

        MOVI INTENSITIES_START, A0, L
        MOVI PALETTE01_START,   A1, L

        MOVK 32, A2                     ; 5 BITS / COLOR
        MOVK  8, A6                     ; # COLOR BARS

$400:   MOVE *A0+, A3                   ; STARTING COLOR
        MOVE *A0+, A4                   ; COLOR DECREMENT

        MOVE A2, A5

$500:   MOVE A3, *A1+
        SUB  A4, A3
        DSJS A5, $500

        DSJS A6, $400

;       =========================
;       | DISPLAY COLOR BARS    |
;       =========================

        CLR	A14
        MOVE	A14,@DMACTL		; HALT THE DMA
	MOVI	0101H,A14
	MOVE	A14,@DMACMAP,W

        MOVI COLOR_BARS,  A14, L        ; COLOR BAR TABLE
        MOVI [13,0], A13, L             ; POSITION INCRMENT
        MOVI 101H,  A12                 ; COLOR INCREMENT
        MOVK   32,  A11                 ; # INTENSITIES / BAR

        CLR A2                          ; STARTING COLOR

$600:   R_XYADR A14, A0
        R_DIMEN A14, A1

        MOVE A11, A10

$700:   FCALL RECTANGLE, B6
        ADD   A13, A0
        ADD   A12, A2
        DSJS  A10, $700

        R_END A14, $600

	CLR	A14
	MOVE	A14,@DMACMAP,W

        FRET B5

INTENSITIES_START:

        .WORD 03E0H                ; GREEN
        .WORD 0020H                ; BUMP GREEN

        .WORD 7C00H                ; RED
        .WORD 0400H                ; BUMP RED

        .WORD 001FH                ; BLUE
        .WORD 0001H                ; BUMP BLUE

        .WORD 0000H                ; BLACK
        .WORD 0000H                ; BUMP BLACK

        .WORD 7FFFH                ; WHITE
        .WORD 0421H                ; BUMP WHITE

        .WORD 7FE0H                ; YELLOW
        .WORD 0420H                ; BUMP YELLOW

        .WORD 7C1FH                ; PURPLE
        .WORD 0401H                ; BUMP PURPLE

        .WORD 03FFH                ; CYAN
        .WORD 0021H                ; BUMP CYAN

INTENSITIES_END:

        .END

