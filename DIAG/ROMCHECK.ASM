
;****************************************************************************
;* ROMCHECK.ASM: ROM CHECK; MODULE VERIFIES THAT ALL SYSTEM ROMS FUNCTION.  *
;****************************************************************************

        .TITLE 'ROMCHECK'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

        .include \VIDEO\GSP.INC
        .include \VIDEO\SYS.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include UTILITIE.MAC
        .include ROMCHIPS.MAC
        .include LAYOUT.MAC

        .TEXT
        .EVEN

ONE_BIT_OK	EQU	0	;THIS SAYS 1 BIT ERROR OK IN IMAGE ROMS!

*
*THESE EQUATES ASSUME THAT THE DESTINATION ADDRESS IS ALL THE WAY TO THE
* LEFT.
ROMSIZE	.EQU	(512*1024)*4
**********************************************
*NOTE: IF YOU CHANGE RAMWIDTH, YOU MUST CHANGE LOGWIDTH TO AGREE
*	ALSO, KEEP RAMWIDTH A POWER OF 2, AND ONLY DECREASE IT VALUE BECAUSE
*	THE DMA CAN ONLY DO 511 PIXELS WIDE.
**********************************************
RAMWIDTH .EQU	256*8
LOGWIDTH .EQU	11	
**********************************************
RAMHEIGHT .EQU	64
RAMAREA	.EQU	RAMWIDTH*RAMHEIGHT
ROMBLOCKS .EQU	ROMSIZE/RAMAREA	
RAMSTARTY .EQU	400
RAMDMAY	.EQU	RAMSTARTY
RAMDMAX	.EQU	0
RAMMEM_PTR .EQU	RAMSTARTY*1000H
RAMMEM_END .EQU	RAMMEM_PTR+(RAMHEIGHT*1000H)
*
*RETURNS B0 <> 0 IF AN ERROR WAS FOUND
ROMCHECK:
	CLR	B0
        SETF 16, 0, 0
        SETF 32, 0, 1

        MOVI P_MAX, A0                     ; PIXEL PROCESSING = MAX 
        MOVE A0, @CONTROL

;       ==================================
;       | LOAD NEXT CHIP RECORD.         |
;       ==================================

$010:   ROMCHKSM A14, A13                  ; DATAIO CHECK SUM: ASSUME EMPTY
        JRZ $040                           ; SOCKET IFF CHECKSUM = ZERO

        ROMSADDR A14, A12                  ; CHIP STARTING ADDRESS
        ROMEADDR A14, A11                  ; CHIP ENDING ADDRESS
        ROMINTLV A14, A10                  ; CHIP INTERLEAVE
        ROMWIDTH A14, A9                   ; CHIP WIDTH
 
	CMPI	32,A10
	JRNE	PROG_ROM

*	
*HERE COMES THE BRANE DAMIJ
	MOVE	A12,A11
	SLL	27,A11
	SRL	27,A11			;A11 = FLAVOR FOR DESTINATION

	SRL	5,A12			;A12 = DMA SAG
	SLL	5,A12			;STRIP THE FLAVOR FOR THE DMA SAG
	
	CLR	A8			;ZERO RUNNING CHECKSUM
	MOVI	ROMBLOCKS,A9		;ITERATION COUNT
IMGROMLP
	MOVE	A12,@DMASAD,L
	MOVI	[RAMHEIGHT,RAMWIDTH/8],A7
	MOVE	A7,@DMASIZ,L
       	MOVI	[RAMDMAY,RAMDMAX],A7
	MOVE	A7,@DMADAD,L
	CLR	A7
	MOVE	A7,@DMAOFF,W
	MOVE	A7,@DMACON,W
	MOVE	A7,@DMAMAP,W
;	MOVI	DMAWAL,A7,W		    ;***LED
	MOVI	DMAWAL,A7		    ;***LED
	MOVE	A7,@DMACTL,W
DMAWAIT
	MOVE	@DMACTL,A7,W
	BTST	15,A7
	JRNE	DMAWAIT
*
*NOW LET'S ADD THEM UP
	
	MOVI	RAMMEM_PTR,A10
	ADD	A11,A10			;ADD FLAVOR
IMGCKLP
	MOVB	*A10,A7			;LARRY SAYS: "WE ONLY DO BYTES."
	SLL	24,A7
	SRL	24,A7
	ADD	A7,A8
	ADDK	32,A10
	BTST	LOGWIDTH,A10
	JRZ	IMGCKLP
	ADDI	(512*8)-RAMWIDTH,A10
	CMPI	RAMMEM_END,A10	
	JRLO	IMGCKLP

	ADDI	RAMAREA,A12
	DSJ	A9,IMGROMLP
	JRUC	CMPCKSUM		;SEE WHAT WE'VE ACCOMPLISHED
*
*CHECK IT WITH THE CPU IT'S READABLE
PROG_ROM
;       =================================
;       | SET FIELD WIDTHS.             |
;       =================================

        MOVE A10, A0                       ; FS1 = INTERLEAVE
        ANDI ZERO_EXTEND, A0
        EXGF A0, 1

        MOVE A9, A0                        ; FS0 = WIDTH
        ANDI ZERO_EXTEND, A0
        EXGF A0, 0

;       =================================
;       | COMPUTE CELL COUNT FOR CHIP   |
;       =================================

        SUB  A12, A11                      ; (END - START) / INTERLEAVE + 1
        DIVU A10, A11
        INC  A11

;	=================================
;	| COMPUTE DATAIO CHECKSUM       |
;	=================================

        CLR  A8                           ; A8 = COMPUTED CHECKSUM

$020:   MOVE *A12+, A7, 1
        ZEXT  A7
        ADD   A7, A8
        DSJS  A11, $020

CMPCKSUM
        SETF 32, 0, 1                      ; DATAIO WIDTH = DEFAULT FS0
        SETF 16, 0, 0                      ; WIDTH
        ZEXT A8

;       =================================
;       | LOAD ICON PARAMETERS.         |
;       =================================

        ROMRLINK A14, A12                  ; LINK TO CHIP ICON
        R_XYADR  A12, A0                   ; XY SCREEN ADDRESS
        R_DIMEN  A12, A1                   ; XY DIMENSIONS

        CMP  A13, A8
        JRNZ $030

PRETEND_CKSUMS_ARE_OK:			   ;**** LED
        MOVK  GREEN, A2                    ; GREEN: CHIP PASSES TEST
        SLL  PXSIZE, A2
        ADDK  GREEN, A2

        FCALL RECTANGLE, B6

        JRUC $040
*
*	CONTROL COMES HERE WHEN ROM CHECKSUMS DON'T MATCH!
*
$030: 
*************************************************
*************************************************
******
******	   BEGIN CONDITIONAL CODE TO LET SINGLE BITS 0->1 CHANGE
******     THROUGH!
******
*************************************************
*************************************************
*
*	A8 = THE CALCULATION
*	A13 = WHAT WE WANT TO GET
*
	.IF	ONE_BIT_OK
	CMPI	IMAGE_ROMS,A14			;ARE WE INTO THE IMAGE AREA?
	JRLO	STILL_IN_P_ROMS
*
*	WE'RE IN IMAGE ROMS!!! LETS LET A BIT GO BY HERE 
*	AND THERE!
*
	SUB	A13,A8				;OURS MUST BE LARGER
	CMPI	255,A8				;SUM MUST BE 255 OR LESS LARGER
	JRHI	GIVE_ROM_ERROR 			;IT AINT 1 BIT!
*
*	NOW...WE HAVE A NON ZERO NUMBER 1-255 IN A8....IF ITS
*	A SINGLE BIT, WE'LL LET IT GO.
*
KEEP_SHIFTING
	SRL	1,A8				;SHIFT TILL CARRY IS SET
	JRNC	KEEP_SHIFTING

	JRNZ	GIVE_ROM_ERROR			;BIT IN CARRY AND REG...BYE	
*
*	NOW SEE IF SWITCH IS PRESSED TO OVERRIDE OUR GRACES!
*
	MOVE	@SWITCH_REGISTER_1,A8,1	   ;DON'T WORRY..FIELDS ARE SET!
	BTST	24,A8		           ;PLAYER ONE START PRESSED
	JRNZ	PRETEND_CKSUMS_ARE_OK      ;NO....PRETEND ITS GOOD!	

STILL_IN_P_ROMS
GIVE_ROM_ERROR
	.ENDIF

*************************************************
*************************************************
******
******	   END CONDITIONAL CODE TO LET SINGLE BITS 0->1 CHANGE
******     THROUGH!
******
*************************************************
*************************************************

*
*	CONTROL COMES HERE WHEN THERE IS A ROM ERROR THAT
*	WILL BE DISPLAYED
*
        MOVK    RED, A2                    ; RED: PANIC
        SLL  PXSIZE, A2
        ADDK    RED, A2

        FCALL RECTANGLE, B6

	MOVE	B0,B0
	JRNE	$040
	INC	B0
        ROMNUMBR A14, A0
        FCALL ERROR_LED, B6
****        JRC $041

$040:   ROMEND A14, $010

$041:   CLR  A14                            ; RESET PPOP
        MOVE A14, @CONTROL

        FRET B5

;****************************************************************************
;* VIEWROMS: MODULE DRAWS THE ROM BOARD.                                    *
;****************************************************************************

VIEWROMS:

        CLR  A0                         ; PPOP = REPLACE
        MOVE A0, @CONTROL

        CLEARSCR

;       ==============================
;       | DISPLAY VECTORS            |
;       ==============================

        MOVI ROMBOARD_VECTS, A14, L

$100:   V_SADDR A14, A0                 ; LOAD VECTOR PARAMETERS
        V_EADDR A14, A1
        V_COLOR A14, A2

        FCALL HVLINE, B6

        V_END A14, $100

;       ==============================
;       | DISPLAY RECTANGLES         |
;       ==============================

        MOVI ROMBOARD_RECTS, A14, L

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

        MOVI ROMBOARD_LABELS, A14, L

$300:   L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3

        FCALL STRING, B6

        L_END A14, $300

        FRET B5

         .END


