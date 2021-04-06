	.FILE	'SYSCHECK.ASM'
;****************************************************************************
;* SYSCHECK: SYSTEM CHECK; 
;****************************************************************************

          .TITLE "SYSCHECK"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

          .INCLUDE \VIDEO\SYS.INC
          .INCLUDE \VIDEO\GSP.INC

          .INCLUDE "SYSCHECK.SET"
          .INCLUDE "SYSCHECK.GBL"

          .INCLUDE "UTILITIE.MAC"
          .INCLUDE "LAYOUT.MAC"

NON_STOP_BURN	EQU	1	;IF P2 START PRESSED, DON'T STOP
*				;BURN-IN ON ERRORS!

*
*NARC JUMP VECTOR EQUATES
	.IF	ROM512
NARCMAIN .EQU	0FF900000H	;HARD NARC CODE ADDRESS
	.ELSE
NARCMAIN .EQU	0FFC00000H	;HARD NARC CODE ADDRESS
	.ENDIF
ROMTRET	.EQU	NARCMAIN+0
CPUTRET	.EQU	NARCMAIN+30H
SWTRET	.EQU	NARCMAIN+60H
CBTRET	.EQU	NARCMAIN+90H
CHTRET	.EQU	NARCMAIN+0C0H
POWERRET .EQU	NARCMAIN+0F0H

          .TEXT
          .EVEN

POWERUP:
*
*JUMP VECTOR TABLE TO INTERFACE WITH NARC
*
	JAUC	ROMTEST
	JAUC	CPUTEST
	JAUC	SWTEST
	JAUC	COLORBR
	JAUC	CROSSHCH
	JAUC	TRADEMRK
	JAUC	BURNIN
	JAUC	POWERTST

**************************************************************************
*                                                                        *
* POWERTST - RUN THE POWER UP DIAGNOSTICS, THEN START THE SYSTEM	 *
*                                                                        *
**************************************************************************
POWERTST
        DINT
        SETF 16, 0, 0
        SETF 32, 0, 1
;       ===============================
;       | HALT DMA AND ENABLE CACHE   |
;       ===============================
        CLR  A14
        MOVE A14, @DMACTRL
        MOVE A14, @CONTROL
;       ===============================
;       | RESET SOUND BOARD.          |
;       ===============================
        MOVI 0FB00H, A14
        MOVE A14, @SOUND_BOARD
        CLR  A14
        NOT  A14
        MOVE A14, @SOUND_BOARD
;       ===============================
;       | DISABLE VIDEO PALETTE RAMS, |
;       | AUTOERASE, AND ERROR LED    |
;       ===============================
***        CLR  A13
***        NOT  A13
	MOVI 0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W

**************************************************************************
*                                                                        *
* WDOGDIS - WATCH DOG DISABLE						 *
*                                                                        *
**************************************************************************
        SETF 16,1,0			;SIGN EXTENSION ON FOR THIS

	MOVI	WDISTAB,A1	
	MOVK	1,A3
	MOVI	0FFFCH,A2
	MOVE	*A1+,A0,W		
WDOGSL
	OR	A2,A0	
        MOVE	A0,@SYS_REGISTER_00,W
	XOR	A3,A0
        MOVE	A0,@SYS_REGISTER_00,W
	MOVE	*A1+,A0,W
	JRNN	WDOGSL

        SETF 16,0,0			;BACK OFF FOR BEGLEMAN SHIT

;       ===============================
;       | INITIALIZE IO REGISTERS.    |
;       ===============================
        MOVI IOREG_TABLE_START, A14, L
        MOVI IOREG_TABLE_END,   A13, L
        SUB A14, A13
        SRL  4H, A13
        INC A13
        MOVI HESYNC, A12, L
$300:   MOVE *A14+, *A12+
        DSJS A13, $300
;       ===============================
;       | RUN POWER UP DIAGNOSTICS.   |
;       ===============================
TEST_RAM:
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        MOVI  RAMCHIPS, A14             ; VERIFY SYSTEM RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A0                    ; SAVE MUST BE TO A7
;       ===============================
;       | ENABLE VIDEO PALETTE MAP    |
;       | ACCESS.                     |
;       ===============================
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY VIDEO PALETTE MAP RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVE	A0,A8
;       ===============================
;       | DISABLE VIDEO PALETTE MAP   |
;       | ACCESS.                     |
;       ===============================
***        CLR  A13
***        NOT  A13
	MOVI	0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS
        PAUSE  100000H,A14              ; LET'EM SEE IT
	MOVE	A8,A8
	JRNZ	TEST_DMA		;SKIP ROM TEST ON BIT MAP RAM ERROR
TEST_ROM:
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5
        FCALL VIEWROMS, B5              ; DISPLAY ROM BOARD
        MOVI  ROMCHIPS, A14 
        FCALL ROMCHECK, B5              ; VERIFY SYSTEM ROMS
;       ===============================
;       | STACK MAY BE USED AFTER     |
;       | THIS POINT...               |
;       ===============================
TEST_DMA:
        MOVI  STACK_ST, SP, L
****        CALLA DMACHECK
*STAMP THE CPU AS GOOD
        MOVI P_MAX, A14
        MOVE A14, @CONTROL
        MOVI CPU_CHIP, A14, L
        R_XYADR A14, A0
        R_DIMEN A14, A1
        MOVI (GREEN * 256) + GREEN, A2
        FCALL RECTANGLE, B6
        PAUSE  200000H, A14              ; LET'EM SEE IT
	JAUC	POWERRET	;HARD JUMP TO THE BEGINNING OF IT ALL

*
*WATCH DOG DISABLE TABLE
WDISTAB
	.WORD	0
	.WORD	0
	.WORD	0
	.WORD	0

	.WORD	2
	.WORD	0
	.WORD	2
	.WORD	0
	.WORD	0FFFFH

**************************************************************************
*                                                                        *
* ROMTEST - ROM BOARD TEST						 *
*                                                                        *
**************************************************************************
ROMTEST
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        MOVI  RAMCHIPS, A14             ; VERIFY BITMAP AND SCRATCH RAMS
        FCALL RAMCHECK, B5

        MOVE  B0, A0                    ; SAVE MUST BE TO A7
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY PALETTE RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVI 0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W
	MOVE	A0,A8
	JRZ	ROMBRAM			;TEST ROM BECAUSE RAM IS GOOD

        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS

        MOVI	RAMERRL,A14,L
ROMRAMMESS
	L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3
        FCALL STRING, B6
        L_END A14, ROMRAMMESS
*CAN'T CHECK THE ROMS WHEN THERE'S BAD RAM
	JAUC	ROMTRET
ROMBRAM
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5
        FCALL VIEWROMS, B5              ; DISPLAY ROM BOARD
        MOVI  ROMCHIPS, A14 
        FCALL ROMCHECK, B5              ; VERIFY SYSTEM ROMS

	MOVE	B0,B0
	JREQ	ROMGOOD
        MOVI	ROMERRL,A14,L
	JRUC	ROMMESS
ROMGOOD
        MOVI	ROMCOMPL,A14,L
ROMMESS
	L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3
        FCALL STRING, B6
        L_END A14, ROMMESS

	JAUC	ROMTRET

**************************************************************************
*                                                                        *
* CPUTEST - CPU BOARD TEST						 *
*                                                                        *
**************************************************************************
CPUTEST
	FCALL	SCRCLR,B6
        MOVI  RAMCHIPS, A14             ; VERIFY BITMAP AND SCRATCH RAMS
        FCALL RAMCHECK, B5

        MOVE  B0, A0                    ; SAVE MUST BE TO A7
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY PALETTE RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVE	A0,A8
***        CLR  A13
***        NOT  A13
	MOVI	0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W

        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS

	OR	A7,A8
	JREQ	RAMGOOD
        MOVI	RAMERRL,A14,L
	JRUC	RAMMESS
RAMGOOD
        MOVI	RAMCOMPL,A14,L
RAMMESS
	L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3
        FCALL STRING, B6
        L_END A14, RAMMESS

***        CALLA DMACHECK
*STAMP THE CPU AS GOOD
        MOVI P_MAX, A14
        MOVE A14, @CONTROL
        MOVI CPU_CHIP, A14, L
        R_XYADR A14, A0
        R_DIMEN A14, A1
        MOVI (GREEN * 256) + GREEN, A2
        FCALL RECTANGLE, B6
	JAUC	CPUTRET

**************************************************************************
*                                                                        *
* BURNIN - BURIN TEST							 *
*                                                                        *
**************************************************************************
BURNIN
        PAUSE  80000H,A14              ; LET'EM SEE IT
*NOW RAMS
	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        MOVI  RAMCHIPS, A14             ; VERIFY BITMAP AND SCRATCH RAMS
        FCALL RAMCHECK, B5

        MOVE  B0, A0                    ; SAVE MUST BE TO A7
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY PALETTE RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVE	A0,A8
	MOVI	0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W

	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS

	OR	A7,A8
	JRNE	BRAMERRM

*RAM CHECK #2
	FCALL	SCRCLR,B6
        MOVI  RAMCHIPS, A14             ; VERIFY BITMAP AND SCRATCH RAMS
        FCALL RAMCHECK, B5

        MOVE  B0, A0                    ; SAVE MUST BE TO A7
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY PALETTE RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVE	A0,A8
	MOVI	0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W

	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS

	OR	A7,A8
	JRNE	BRAMERRM
*RAM CHECK #3
	FCALL	SCRCLR,B6
        MOVI  RAMCHIPS, A14             ; VERIFY BITMAP AND SCRATCH RAMS
        FCALL RAMCHECK, B5

        MOVE  B0, A0                    ; SAVE MUST BE TO A7
        MOVI  PAL_SELECT, A13
        MOVE  A13,@SYS_REGISTER_00,W
        MOVI  PALCHIPS, A14             ; VERIFY PALETTE RAMS
        FCALL RAMCHECK, B5
        MOVE  B0, A7
	MOVE	A0,A8
	MOVI	0FFFCH,A13
        MOVE A13,@SYS_REGISTER_00,W

	FCALL	SCRCLR,B6
        FCALL INITCOLR, B5              ; DISPLAY CPU BOARD
        FCALL VIEWRAMS, B5
        MOVI  RAMCHIPS, A14             ; DISPLAY VIDEO & SCRATCH ERRORS.
        MOVE  A8, B0
        FCALL RAMSTATE, B5
        MOVI  PALCHIPS, A14
        MOVE  A7, B0
        FCALL RAMSTATE, B5              ; DISPLAY PALETTE ERRORS

	OR	A7,A8
	JREQ	BURNROMT
*RAM ERROR LOOP
BRAMERRM

*
*	IF PLAYER 2 START PRESSED, WE DON'T STOP
*	BURN-IN ON ERRORS
*
	.IF	NON_STOP_BURN
	MOVE	@SWITCH_REGISTER_1,A14,L
	BTST	25,A14			;PLAYER TWO START PRESSED
	JREQ	BURNROMT		;YES, NO ERROR MESS..OFF TO ROM TEST	
	.ENDIF

        MOVI	BRAMERRL,A14,L
BRAMMESS
	L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3
        FCALL STRING, B6
        L_END A14, BRAMMESS

	JRUC	$			;BAD RAM DUDE

*CHECK ROMS AFTER BIT MAP
BURNROMT
	FCALL	SCRCLR,B6
        FCALL	INITCOLR,B5
        FCALL	VIEWROMS,B5		;DISPLAY ROM BOARD
        MOVI	ROMCHIPS,A14 
	MOVE	@SWITCH_REGISTER_1,B5,L
	BTST	24,B5			;PLAYER ONE START PRESSED
	JREQ	BURNNROM		;YES, DO BURN IN WITH NORMAL ROM TEST	
	FCALL	ROMCHECK,B5		;DO SPECIAL ROM CHECK
	JRUC	BURNROMD
BURNNROM
        FCALL	ROMCHECK,B5		;VERIFY SYSTEM ROMS
BURNROMD
	MOVE	B0,B0
	JREQ	BURNDMA
*
*	IF PLAYER 2 START PRESSED, WE DON'T STOP
*	BURN-IN ON ERRORS
*
	.IF	NON_STOP_BURN
	MOVE	@SWITCH_REGISTER_1,A14,L
	BTST	25,A14			;PLAYER TWO START PRESSED
	JREQ	BURNDMA	        	;YES, NO ERROR MESS..OFF TO "DMA" TEST	
	.ENDIF

        MOVI	BROMERRL,A14,L
BROMMESS
	L_TXADR A14, A0                 ; LOAD LABEL PARAMETERS
        L_XYADR A14, A1
        L_DIREC A14, A2
        L_COLOR A14, A3
        FCALL STRING, B6
        L_END A14, BROMMESS

	JRUC	$			;HANG ON ROM ERROR

BURNDMA
***        CALLA DMACHECK
*STAMP THE CPU AS GOOD
        MOVI P_MAX, A14
        MOVE A14, @CONTROL
        MOVI CPU_CHIP, A14, L
        R_XYADR A14, A0
        R_DIMEN A14, A1
        MOVI (GREEN * 256) + GREEN, A2
        FCALL RECTANGLE, B6
        PAUSE  80000H,A14              ; LET'EM SEE IT
	JRUC	BURNIN

**************************************************************************
*                                                                        *
* SWTEST - TEST I/O SWITCHES						 *
*                                                                        *
**************************************************************************
SWTEST
	FCALL	SCRCLR,B6
        FCALL	INITCOLR,B5
	FCALL	VIEWCNTL,B5
	FCALL	CTLCHECK,B5	;SWITCH TEST
	JAUC	SWTRET

**************************************************************************
*                                                                        *
* CROSSHCH - PUT UP THE CROSS HATCH PATTERN				 *
*                                                                        *
**************************************************************************
CROSSHCH
	FCALL	SCRCLR,B6
        FCALL	INITCOLR,B5
	FCALL	CNVCHECK,B5	;PUT OUT THE CROSSHATCH
	JAUC	CHTRET
**************************************************************************
*                                                                        *
* COLORBR - PUT UP THE COLOR BAR PATTERN				 *
*                                                                        *
**************************************************************************
COLORBR
	FCALL	SCRCLR,B6
        FCALL	INITCOLR,B5
	FCALL	CLRCHECK,B5	;COLOR BARS
	JAUC	CBTRET
**************************************************************************
*                                                                        *
* TRADEMRK - OUTPUT THE TRADEMARK SCREEN				 *
*                                                                        *
**************************************************************************
TRADEMRK
;       ===============================
;       | LOAD TRADEMARK PALETTE.     |
;       ===============================
        
        MOVI PALETTE00_START, A14, L    ; INIT UNUSED COLORS TO WHITE
        MOVI PALETTE00_END,   A13, L

        SUB  A14, A13                   ; PALETTE SIZE
        SRL  04H, A13

        CLR  A12                        ; FF HEX
        NOT  A12

$305:   MOVE A12, *A14+
        DSJS A13, $305

        MOVI TRADEMARK_COLORS_START, A13, L
        MOVI TRADEMARK_COLORS_END,   A12, L
        MOVI PALETTE00_START,        A14, L

        SUB  A13, A12
        SRL  04H, A12

$306:   MOVE *A13+, *A14+
        DSJS  A12, $306

;       ===============================
;       | DMA TRADEMARK FROM DMA INT- |
;       | ERNAL ROM.                  |
;       ===============================

        MOVI [400, 511], A14, L         ; BLOW OUT TRADEMARK
        MOVE A14, @DMAHSIZE, 1

        MOVI -483, A14, L
        MOVE A14, @DMAOFFST, 0

        CLR  A14
        MOVE A14, @DMACONST, 0
        MOVE A14, @DMAHORIZ, 1
        MOVE A14, @DMASAGL, 1
        MOVE A14, @DMACMAP, 0

        MOVI 8042H, A14
        MOVE A14, @DMACTRL, 0
	RETS

        .END

