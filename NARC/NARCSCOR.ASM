	.FILE	'NARCSCOR.ASM'
	.TITLE	" <<< N  A  R  C  -- SCORE AREA MAINTENANCE >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCAUDN.ASM"		;NARC Audit Equates
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates

*
*GLOBALS IN THIS FILE
	.GLOBAL		ADDMRBIG,P_MBIGS,P_GOLD,OUTMBIGS,CRCMESS,CLRMESS
	.GLOBAL		PICKMESS,OUTNEXTR,PIXQINIT
*
*EXTERNALS
	.GLOBAL		GET_ADJ,AUD1,CR_STRTP,CR_CONTP,G_CRED,GET_CSTR
	.GLOBAL		STR_OBJ,STRCAT,STR_FREE,BCDBIN,BTIME

	.EVEN
	.TEXT

**************************************************************************
*                                                                        *
* SCANNER - SCANNER AREA PROCESS					 *
*                                                                        *
**************************************************************************
SCANNER
	MOVE	@UNIVENDX,A0,W
	MOVI	SCANXSIZ-15,A9		;GET THE SCANNER X DIMENSION
	SLL	16,A9
	DIVU	A0,A9			;A9 = SCANNER X RATIO
	MOVE	@UNIVENDY,A0,W
***	CMPI	800,A0
***	JRLO	SCANM400		;BR = BONUS AREA NOT APPARENT
***	SUBI	400,A0			;SUBTRACT OFF THE BONUS AREA
SCANM400
	MOVI	SCANYSIZ-15,A11		;GET THE SCANNER Y DIMENSION
	SLL	16,A11
	DIVU	A0,A11			;A11 = SCANNER Y RATIO
	MOVI	SCANOFST,A10		;GET THE SCANNER UPPER LEFT OFFSET
SCANLP
	CALLA	PIXQINIT
	MOVI	OBJLST,A8		;GET THE OBJECT LIST
	CLR	A2			;AND CONSTANT PALETTE
	CLR	A14			;BOUNDRY COMPARISON
	MOVI	[SCANYSIZ,SCANXSIZ],A6
SCANOLP
	MOVE	*A8,A8,L		;GET THE NEXT OBJECT
	JREQ	SCANNLST		;BR = DONE
	MOVE	*A8(OBLIPIMG),A3,L
	JREQ	SCANOLP			;BR = NO BLIP FOR THIS DUDE
	CALLR	SCANSUB
	JRHS	SCANUPD			;QUEUE IS LOADED
	JRUC	SCANOLP
SCANNLST
	MOVE	A12,B0
	MOVI	BBACTIVE,A12
SCANNLP
	MOVE	*A12,A12,L
	JRZ	SCANNDN
	MOVE	*A12(NDATA),A0,W
	JRNZ	SCANNLP			;BR = THIS THING GOT CAUGHT LAST TIME
	MOVE	*A12(NPTR),A8,L
	MOVE	*A8(OBLIPIMG),A3,L
	JREQ	SCANNLP			;NOBODY WANTS HIM
	CALLR	SCANSUB	
	JRLO	SCANNLP
SCANNDN
	MOVE	B0,A12
SCANUPD
	MOVK	1,A0
	MOVE	A0,@PIXQVAL,W		;LET THEM BE
SCANSLP
	MOVE	@PIXQVAL,A0,W
	JREQ	SCANLP
	SLOOP	10,SCANSLP
*	
*SCANNER SETUP SUBROUTINE
*A3 = PTR TO THE BLIP IMAGE TABLE
*RETURNS: C CLR QUEUE IS LOADED
SCANSUB
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRNE	SCANSUB1		;BR = HE'S FLIPPED, LOAD FLIPPED IMAGE
	MOVE	*A3,A3,L		;OTHERWISE LOAD UNFLIPPED
	JRUC	SCANSUB2
SCANSUB1
	MOVE	*A3(20H),A3,L		;FLIPPED
SCANSUB2
	CALLA	GETCPNT
	MOVY	A1,A5
	SRL	16,A5
	ZEXT	A1
	MPYU	A9,A1
	SRL	16,A1
	MOVX	A1,A0
	MPYU	A11,A5
	MOVY	A5,A0
	CMPXY	A14,A0
	JRXLT	SCANOFF			;BR = TOO FAR LEFT
	JRYLT	SCANOFF			;BR = TOO HIGH?
	MOVE	*A3,A7,L
	ADDXY	A0,A7			;A7 = [LOWER RIGHT Y,LOWER RIGHT X]
	CMPXY	A6,A7
	JRXGT	SCANOFF			;BR = TOO FAR RIGHT
	JRYGT	SCANOFF			;BR = TOO LOW
	ADD	A10,A0			;ADD IN SCANNER UPPER LEFT OFFSET
	JRUC	SCANOK
SCANOFF
	CLR	A0
SCANOK
	CALLA	PIXQADD
	RETS

**************************************************************************
*                                                                        *
* PIXQINIT - PIXEL QUEUE INITIALIZATION					 *
*                                                                        *
**************************************************************************
PIXQINIT
	PUSH	A0
	CLR	A0
	MOVE	A0,@PIXQVAL,W
	MOVI	PIXQUEUE,A0		;INITIALIZE THE PIXEL XFER QUEUE
	MOVE	A0,@PIXQHEAD,L
	MOVE	A0,@PIXQTAIL,L
	PULL	A0
	RETS
**************************************************************************
*                                                                        *
* PIXQADD - ADD THESE ELEMENTS TO THE PIXEL QUEUE			 *
* A0 = [Y,X] POSITION							 *
* A2 = PALETTE								 *
* A3 = PTR TO BLIP IMAGE TABLE						 *
* A8 = PTR TO OBJECT BEING REPRESENTED					 *
* RETURNS:								 *
* 	C BIT CLR = QUEUE FULL						 *
* 	C BIT SET = SUCCESS						 *
*                                                                        *
**************************************************************************
PIXQADD
	PUSH	A4
	MOVE	@PIXQTAIL,A4,L
	CMPI	PIXQEND,A4
	JRHS	PIXQXXX
	MOVE	A2,*A4+,W
	MOVE	A3,*A4+,L
	MOVE	*A8(OEBLIP),*A4+,L
	MOVE	A0,*A8(OEBLIP),L		;STORE AS AN ERASE LOCATION
	MOVE	A0,*A4+,L
	MOVE	A4,@PIXQTAIL,L
PIXQXXX
	PULL	A4
	RETS

**************************************************************************
*                                                                        *
* BLIPOFF - TURN AN OBJECTS SCANNER BLIP OFF				 *
* A8 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
BLIPOFF
	MMTM	SP,A0,A2,A3
	MOVE	*A8(OBLIPIMG),A3,L
	JREQ	NOBLIP			;BR = NO SCANNER BLIP
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRNE	BLIPOFF1		
	MOVE	*A3,A3,L
	JRUC	BLIPOFF2
BLIPOFF1
	MOVE	*A3(20H),A3,L
BLIPOFF2
	CLR	A2			;AND CONSTANT PALETTE
	CLR	A0			;ERASE LAST PLOT
	MOVE	A0,@PIXQVAL,W		;QUEUE IS INVALID WHILE UPDATING
	CALLA	PIXQADD			;ERASE THE LAST BLIP
	MOVE	A0,*A8(OBLIPIMG),L
	MOVK	1,A0
	MOVE	A0,@PIXQVAL,W		;MAKE SURE THIS GETS WRITTEN
NOBLIP
	MMFM	SP,A0,A2,A3
	RETS	

**************************************************************************
*                                                                        *
* BLIPON - TURN OBJECTS SCANNER BLIP ON					 *
* A8 = PTR TO OBJECT							 *
* A3 = PTR TO BLIP TABLE						 *
*                                                                        *
**************************************************************************
BLIPON
	MOVE	A3,*A8(OBLIPIMG),L
	RETS
**************************************************************************
*                                                                        *
* SCORAREA - OUTPUT THE SCORE AREA AND UPDATE ALL PLAYER STATUS		 *
*                                                                        *
**************************************************************************
SCORAREA
	CALLR	SSAREA			;PUT OUT THE SCORE AREA
	CALLR	UPSTAT			;UPDATE PLAYERS STATUS
	CALLR	WAVENUM			;AND OUTPUT THE WAVE # (TITLE)
	CALLA	G_CREDONLY
	RETS
*
*OUTPUT THE WHOLE SCORE/STATUS AREA, P1 AND P2, PLUS THE NARQUEE
*
SSAREA	CALLR	P1SSAREA
	CALLR	NARQUEE
	JRUC	P2SSAREA

**************************************************************************
*                                                                        *
* WAVENUM - OUTPUT THE WAVE # IN IT'S AREA				 *
*                                                                        *
**************************************************************************
WAVENUM
	MMTM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	MOVI	[5,225],A3
	MOVI	[10,108],A4
	CALLA	BLNKAREA
	CLR	A0
	MOVI	0F9F9H,A6

	MOVE	@BGNAME,A8,L	;GET THE NAME OF THIS BACKGROUND

	MOVI	[5,226],A9	;POSITION
	MOVI	RD7FONT,A11	;VERY SMALL LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM		;AND STICK IT OUT THERE
	MMFM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	RETS
	
*
*OUTPUT PLAYER 1'S SCORE/STATUS AREA
*
P1SSAREA:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A14
	MOVI	P1SSTAB,A0
	JRUC	SSOUT1
*
*OUTPUT PLAYER 2'S SCORE/STATUS AREA
*
P2SSAREA:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A14
	MOVI	P2SSTAB,A0
	JRUC	SSOUT1
*
*OUTPUT THE MARQUEE(SCANNER) BETWEEN P1 AND P2 SSAREAS
*
NARQUEE	MMTM	SP,A0,A1,A2,A3,A4,A5,A14
	MOVI	NARQTAB,A0
	JRUC	SSOUT1
**************************************************************************
*                                                                        *
* SSOUT - OUTPUT SOME SCORE/STATUS AREA PIECES VIA A TABLE.		 *
* 	FIRST ENTRY IS AREA TO BLANK					 *
* A0 = PTR TO TABLE							 *
* RETURNS								 *
* A0 = PTING TO NEXT WORD AFTER THE TABLE				 *
*                                                                        *
**************************************************************************
SSOUT
	MMTM	SP,A0,A1,A2,A3,A4,A5,A14
SSOUT1
	MOVE	*A0+,A3,L
	MOVE	*A0+,A4,L
	CALLA	BLNKAREA
	CLR	A1			;CONSTANT:PALETTE
	MOVI	DMAWNZ,A5		;DRAW
	MOVE	*A0+,A14,L		;KICK IT OFF COUSIN
SSOUTL
	MOVE	*A0+,A3,L
	CALLA	DTIME			;DO IT
	MOVE	*A0+,A14,L		;GET THE NEXT
	JRNZ	SSOUTL			;BR = DO IT AGAIN
	MMFM	SP,A0,A1,A2,A3,A4,A5,A14
	RETS
*
*SCORE AREA TABS
*	.LONG	BLANK [Y,X] DAG
*	.LONG	BLANK [Y,X] SIZE
*	.LONG	PIECE 1 HEADER
*	.LONG	PIECE 1 [Y,X] DAG
*	.
*	.
*	.LONG	PIECE N HEADER
*	.LONG	PIECE N [Y,X] DAG
*	.LONG	0
P1SSTAB
	.LONG	(0*10000H)+1
	.LONG	(80*10000H)+169
	.LONG	SCORESIDE
	.LONG	(0*10000H)+1
	.LONG	0
P2SSTAB
	.LONG	(0*10000H)+342
	.LONG	(80*10000H)+169
	.LONG	SCORESIDE
	.LONG	(0*10000H)+342
	.LONG	0
NARQTAB	
	.LONG	(0*10000H)+170
	.LONG	(80*10000H)+172
	.LONG	SCORETOP
	.LONG	(0*10000H)+170
	.LONG	SCOREBOT
	.LONG	(67*10000H)+170
	.LONG	0
		  
*
*UPDATE BOTH PLAYER 1 AND PLAYER 2'S STATUS
UPSTAT	MOVE	A2,-*SP,L
	MOVI	P1DATA,A2		;UPDATE PLAYER ONE
	CALLR	UPDSL
	MOVI	P2DATA,A2		;NOW PLAYER TWO
	CALLR	UPDSL
	MOVE	*SP+,A2,L
	RETS

*
*UPDATE THE PLAYERS SCORE,LIVES & ROCKETS
*A2 = PLAYER DATA STRUCTURE
UPDSL
*FIRST OUTPUT THE AREA
	CMPI	P1DATA,A2
	JRNE	UPDSLP2
	CALLR	P1SSAREA
	JRUC	UPDSL1
UPDSLP2
	CALLR	P2SSAREA
UPDSL1
	PUSH	A0
	MOVE	*A2(PSCORE),A0,L	;GET THE SCORE IN A0
	CALLA	OUTSCR			;AND OUTPUT IT
	CALLA	OUTLIVES
	CALLA	OUTENRGY
	CALLA	OUTROCKS
	CALLA	OUTBULLS
	CALLA	OUTDRUGS
	CALLA	OUTBUCKS
	CALLA	OUTBUSTS
	CALLA	OUTCARDS
	CALLA	OUTMBIGS
	CALLR	OUTNEXTR
UPDSX
	PULL	A0
	RETS

*EUGENE'S SCORE ROUTINES
*
*BCD ADD ROUTINE
*A0=SCORE (8 DIGIT BCD) 32 BITS
*A1=NUMBER TO ADD TO A0	(8 DIGIT BCD)
*PACKED BCD FORMAT 4-BITS/ DIGIT
BCDADD:	
	MMTM	SP,A1,A3,A4,A5,A6
	MOVK	8,A5  		;DO 8 DIGITS
	CLRC			;CLEAR THE CARRY
	MOVK	0Ah,A6
BCDLP:
	MOVK	0Fh,A3
	MOVK	0Fh,A4
	AND	A1,A3		;MASK GARBAGE
	AND	A0,A4
	ADDC	A3,A4
	CMP	A6,A4		;NEED TO ADJUST?
	JRLO	BCDAD1
	ADDK	6,A4
	SRL	4,A0
	SLL	28,A4
	ADD	A4,A0
	SRL	4,A1
	SETC
	DSJS	A5,BCDLP
	JRUC	BCDADX
BCDAD1:	
	SRL	4,A0	
	SLL	28,A4
	ADD	A4,A0
	SRL	4,A1
	CLRC
	DSJS	A5,BCDLP
BCDADX:	
	MMFM	SP,A1,A3,A4,A5,A6	
	RETS
	
**************************************************************************
*                                                                        *
* SCORE2P - ADD THE SAME SCORE VALUE TO BOTH PLAYERS, IF ACTIVE		 *
* 		AND IN A VEHICLE.					 *
* A1 = SCORE VALUE							 *
*                                                                        *
**************************************************************************
SCORE2P
	MMTM	SP,A0,A2
	MOVI	P1DATA,A2
	MOVE	*A2(POBJ),A0,L
	JRZ	SCOREP2			;BR = NO PLAYER ONE
	MOVE	*A2(PIRQFLAG),A0,W	
	ANDI	MDRIVER|MPASSEN,A0
	JREQ	SCOREP2			;BR = NOT IN THE CAR
	CALLR	SCORE
SCOREP2
	MOVI	P2DATA,A2
	MOVE	*A2(POBJ),A0,L
	JRZ	SCORE2PX		;BR = NO PLAYER TWO
	MOVE	*A2(PIRQFLAG),A0,W	
	ANDI	MDRIVER|MPASSEN,A0
	JREQ	SCORE2PX		;BR = NOT IN THE CAR
	CALLR	SCORE
SCORE2PX
	MMFM	SP,A0,A2
	RETS
*	
*PLAYER SCORE ROUTINE
*A1=SCORE VALUE
*A2=PLAYER INDEX
SCORE:
	MMTM	SP,A0,A2
	MOVE	@GAMSTATE,A0,W
	CMPI	INAMODE,A0
	JREQ	SCOREX			;NO SCORING IN ATTRACT MODE
	MOVE	*A2(PSCORE),A0,L	;GET SCORE
	CALLR	BCDADD			;ADD IN NEW VALUE
	CALLR	REPCK			;CHECK REPLAY
	MOVE	A0,*A2(PSCORE),L	;STORE SCORE
*	CALLR	OUTSCR			;OUTPUT CURRENT PLAYER SCORE
SCOREX
	MMFM	SP,A0,A2
	RETS

*	
*PLAYER SCORE IMMEADIATE ROUTINE, DOESN'T WAIT FOR SCORE REFRESH
*DO NOT USE THIS DURING HEAVY GAME ACTION PLEASE
*A1=SCORE VALUE
*A2=PLAYER INDEX
SCRIMM:
	MMTM	SP,A0,A2
	MOVE	@GAMSTATE,A0,W
	CMPI	INAMODE,A0
	JREQ	SCRIMMX			;NO SCORING IN ATTRACT MODE
	MOVE	*A2(PSCORE),A0,L	;GET SCORE
	CALLR	BCDADD			;ADD IN NEW VALUE
	CALLR	REPCK			;CHECK REPLAY
	MOVE	A0,*A2(PSCORE),L	;STORE SCORE
	CALLR	OUTSCR			;OUTPUT CURRENT PLAYER SCORE
SCRIMMX
	MMFM	SP,A0,A2
	RETS

*
*CHECK FOR SCORE REPLAY
*A0 = CURRENT BCD SCORE
*A2 = PLAYER INDEX
REPCK
	MMTM	SP,A0,A1
	MOVE	*A2(PNEXTREP),A1,L
	JRZ	REPCKX			;0 = NO EXTRA DUDES
	CMP	A1,A0
	JRLO	REPCKX			;BR = BOZO DIDN'T ACHIEVE

***	MOVE	A1,A0
***	MOVI	IREPLAY,A1
	ADJUST	ADJEXTRA		;GET EXTRA MAN EVERY ADJUSTMENT
	CALLR	BCDADD		
	MOVE	A0,A1
	ADJUST	ADJLAST
	JRZ	REPCK1			;BR = NO EXTRA MAN LIMIT	
      	CMP	A0,A1
	JRLS	REPCK1			;HAVE NOT REACHED THE LIMIT
	CLR	A1			;NO MORE REPLAYS JOE
REPCK1
	MOVE	A1,*A2(PNEXTREP),L	;NEW REPLAY LEVEL
	CALLR	OUTNEXTR

	MOVE	*A2(PPID),A0,W
	ADDI	PMPID,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRZ	REPNOPC			;NO "PRESS CONTINUE" PROC
	MOVE	*A2(PPID),A0,W
	ADDI	PMPID,A0
	CALLA	KILALL			;KILL THE "PRESS CONTINUE" PROCESS
	CALLR	BLANKB1
	CALLR	BLANKB2			;CLEAR THE AREA
REPNOPC
	CALLR	ADDLIFE			;ADD A LIFE
	CALLR	ADDROCK			;GIVE A FREE ROCKET, WHAT THE HELL
	SOUND1	FREESND
*EXTRA MAN AUDITS
	CMPI	P1DATA,A2
	JRNE	REPTAL2
	AUDIT	AUDEXTRA
	JRUC	REPCKX
REPTAL2
	AUDIT	AUDEXTRA
REPCKX
	MMFM	SP,A0,A1
	RETS
*
*OUTPUT SCORE TO SCREEN
*A0=CURRENT PLAYER SCORE
*A2=PLINDX=PLAYER DATA AREA
OUTSCR:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
	MOVK	8,A6			;DIGIT COUNT
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS
	MOVI	SCRSPC,A4		;SPACING BETWEEN DIGITS	
	CLR	A7			;INIT BLANKING FLAG
	MOVI	9|8000H,A5		;CONTROL REGISTER

OUTSCL:
	MOVE	A0,A1
	SRL	28,A1
	JRNE	OUTSC1			;NON-ZERO DIGIT
	CMPI	2,A6
	JRLS	OUTSC1			;LAST DIGITS - OUTPUT ANYWAY
	MOVE	A7,A7	   		;BLANKING OVER?
	JREQ	OUTSC2			;NO
OUTSC1:	
	INC	A7			;BLANKING IS OVER
	SLL	7,A1			;MULTIPLY BY 128
	MOVE	A1,A14
	ADDI	RRD0,A14		;ADDRESS OF IMAGE HEADER

	MOVE	@GAMSTATE,A1,W
	CMPI	INAMODE,A1
	JREQ	OUTSC10			;BR = NO FLASH SCORE DURING AMODE
	
	MOVE	*A2(POBJ),A1,L		;IS THE PLAYER ACTIVE
	JRNE	OUTSC1A			;BR = YES, DO A FLASHY SCORE
OUTSC10
	MOVI	0F9F90000H,A1		;CONSTANT COLOR:PALETTE SELECT
	JRUC	OUTSC1B
OUTSC1A
	MOVI	0F5F50000H,A1		;CONSTANT COLOR:PALETTE SELECT
OUTSC1B
	CALLA	DTIME			;OUTPUT THE SUCKER
OUTSC2:
	ADDXY	A4,A3			;SPACE TO NEXT DIGIT
	SLL	4,A0
	DSJ	A6,OUTSCL
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
	RETS
*
*REFRESH SCORE PROCESS
*
SCRREF:
	CLR	A8			;LAST SCORE OUTPUT FOR P1
	CLR	A9			;LAST SCORE OUTPUT FOR P2
SCRREFL
	MOVI	P1DATA,A2	  	;DO PLAYER 1
	MOVE	*A2(PSCORE),A0,L
	CMP	A0,A8
	JRNE	SCRREF1			;BR = SCORE HAS CHANGED, REFRESH
	SLOOP	8,SCRREF2
SCRREF1
	MOVE	A0,A8
	JSRP	PSCREF
SCRREF2
	MOVI	P2DATA,A2		;DO PLAYER 2
	MOVE	*A2(PSCORE),A0,L
	CMP	A0,A9
	JRNE	SCRREF3			;BR = SCORE HAS CHANGED, REFRESH
	SLOOP	8,SCRREFL
SCRREF3
	MOVE	A0,A9
	JSRP	PSCREF
	JRUC	SCRREFL
*
*A0=CURRENT SCORE
*A2=PLINDX=PLAYER DATA AREA
PSCREF:
	MOVE	*A2(POBJ),A1,L
	JRNZ	PSCREF1			;BR = PLAYER ACTIVE, DO IT
	SLEEP	8
	RETP
PSCREF1
	MOVK	8,A6			;DIGIT COUNT
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS
	CLR	A7			;INIT BLANKING FLAG
PSCRL:
	MOVE	A0,A1
	SRL	28,A1
	JRNE	PSCR1			;NON-ZERO DIGIT
	CMPI	2,A6
	JRLS	PSCR1			;LAST DIGITS - OUTPUT ANYWAY
	MOVE	A7,A7	   		;BLANKING OVER?
	JREQ	PSCR2			;NO
PSCR1:	
	INC	A7			;BLANKING IS OVER
	SLL	7,A1			;MULTIPLY BY 128
	MOVE	A1,A14
	ADDI	RRD0,A14		;ADDRESS OF IMAGE HEADER

	MOVI	0F5F50000H,A1		;CONSTANT COLOR:PALETTE SELECT
	MOVI	9|8000H,A5		;CONTROL REGISTER
	CALLA	DTIME			;OUTPUT THE SUCKER
PSCR2:
	ADDI	SCRSPC,A3
	SLL	4,A0
	MMTM	A12,A0,A2,A3,A6,A7	;STORE SHIT ON STACK
	SLEEP	1			;SLEEP
	MMFM	A12,A0,A2,A3,A6,A7	;GET BACK YOUR STUFF
	DSJ	A6,PSCRL
	RETP
**************************************************************************
*                                                                        *
* ADD LIFE								 *
* A0 = # OF LIVES TO ADD						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
*
*ADD ONE LIFE
ADDLIFE:
	MOVK	1,A0
*
*ADD N LIFE(VES)
ADDNLIFE
	MMTM	SP,A0,A1,A3
	MOVE	*A2(PLIVES),A1,W	;CURRENT # OF LIVES
	JRGT	ADDL1
	MOVE	*A2(PENERGY),A3,L
	JRGT	ADDL1			;ENERGY IS STILL THERE
	MOVI	IENERGY,A3
	SLL	16,A3
	MOVE	A3,*A2(PENERGY),L
	CALLR	OUTENRGY		;RE-INSTATE ENERGY INSTEAD OF HEAD
****	DEC	A0
ADDL1
	ADD	A0,A1
	MOVE	A1,*A2(PLIVES),W
	CALLR	OUTLIVES
	MMFM	SP,A0,A1,A3
	RETS

**************************************************************************
*                                                                        *
* ADDMRBIG - ADD MR. BIG KILL						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
*
*ADD ONE MR. BIG
ADDMRBIG
	MMTM	SP,A0,A1,A3
	MOVK	1,A0
	MOVE	*A2(PMBIGS),A1,W	;CURRENT # OF MR. BIGS
	ADD	A0,A1
	MOVE	A1,*A2(PMBIGS),W
	CALLR	OUTMBIGS
	MMFM	SP,A0,A1,A3
	RETS

**************************************************************************
*                                                                        *
* P_MBIGS - HOW MANY MR. BIGS HAVE BEEN KILLED IN TOTAL			 *
* RETURNS:								 *
* A1 = COUNT								 *
*                                                                        *
**************************************************************************
P_MBIGS
	PUSH	A0
	MOVE	@P1DATA+PMBIGS,A1,W
	MOVE	@P2DATA+PMBIGS,A0,W
	ADD	A0,A1
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* P_GOLD - DOES A PLAYER HAVE A GOLD CARD				 *
* RETURNS:								 *
* 	Z BIT SET = NOBODY HAS ONE					 *
* 	Z BIT CLR = SOMEBODY HAS ONE					 *
*                                                                        *
**************************************************************************
P_GOLD
	PUSH	A0
	MOVB	@P1DATA+PGCARD,A0
	JRNE	P_GOLDX
	MOVB	@P2DATA+PGCARD,A0
P_GOLDX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* ADD SOME ENERGY							 *
* A0 = # OF UNITS TO ADD						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
*
*ADD ONE ENERGY UNIT
ADDNRGY:
	MOVK	1,A0
*
*ADD N ENERGY UNIT(S)
ADDNNRGY
	MMTM	SP,A0,A1
	MOVE	*A2(PENERGY),A1,L	;CURRENT # OF LIVES
	SLL	16,A0
	ADD	A0,A1
	MOVE	A1,*A2(PENERGY),L
	CALLR	OUTENRGY
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* ADD A ROCKET BOMB							 *								 *
* A0 = # OF ROCKET BOMBS TO ADD						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
*
*ADD ONE ROCKET BOMB
ADDROCK:
	MOVK	1,A0
*
*ADD N ROCKET(S)
ADDNROCK
	PUSH	A1
	MOVE	*A2(PROCKETS),A1,W	;CURRENT # OF ROCKETS
	ADD	A0,A1
	MOVE	A1,*A2(PROCKETS),W
	CALLR	OUTROCKS
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* ADD SOME BULLETS							 *								 *
* A0 = # OF BULLETS TO ADD						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
*
*ADD ONE BULLET
ADDBULL:
	MOVK	1,A0
*
*ADD N BULLETS
ADDNBULL
	PUSH	A1
	MOVE	*A2(PBULLETS),A1,W	;CURRENT # OF ROCKETS
	ADD	A0,A1
	MOVE	A1,*A2(PBULLETS),W
	CALLR	OUTBULLS
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* ADD A BUST								 *								 *
* A0 = # OF BULLETS TO ADD						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
* DESTROYS A0                                                            *
**************************************************************************
*
*ADD ONE BUST
ADDBUST:
	MOVK	1,A0
*
*ADD N BUSTS
ADDNBUST
	PUSH	A1
	MOVE	*A2(PBUSTS),A1,W	;CURRENT # OF BUSTS
	ADD	A0,A1
	MOVE	A1,*A2(PBUSTS),W
	CALLR	OUTBUSTS
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* SUBxLIFE SUBTRACT LIFE(VES)						 *
* A0 = # OF LIVES TO SUBTRACT						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
* RETURN(S):								 *
* CARRY SET=NO MORE LIVES						 *
*                                                                        *
**************************************************************************
*
*SUBTRACT ONE LIFE
SUBLIFE:
	MOVK	1,A0
*
*SUBTRACT N LIFE(VES)
SUBNLIFE
	MMTM	SP,A0,A1
	MOVE	*A2(PLIVES),A1,W	;GET REMAINING # OF LIVES
	JRLE	SUBLF2			;WE'VE HIT BOTTOM
	SUB	A0,A1
	MOVE	A1,*A2(PLIVES),W
	CALLR	OUTLIVES		;AND DISPLAY THE REST
	MOVE	A1,A1
	JREQ	SUBLF2
	CLRC
	MMFM	SP,A0,A1
	RETS
SUBLF2	SETC
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* SUBNRGY SUBTRACT ONE ENERGY UNIT					 *
* A0 = # OF ENERGY UNITS TO SUBTRACT					 *
* A2 = PLINDX=PLAYER DATA AREA						 *
* RETURN(S):								 *
* CARRY SET=NO MORE ENERGY						 *
*                                                                        *
**************************************************************************

*
*SUBTRACT ONE ENERGY UNIT
SUBNRGY:
	MOVK	1,A0
*
*SUBTRACT N ENERGY UNIT(S)
SUBNNRGY
	MMTM	SP,A0,A1
	SLL	16,A0
	JRUC	SUBGNRGY
*
*SUBTRACT A FRACTIONAL PORTION OF ENERGY
*A0 = INTEGER:FRACTION OF ENERGY TO SUBTRACT
SUBFNRGY
	MMTM	SP,A0,A1
SUBGNRGY
	MOVE	*A2(PENERGY),A1,L	;GET REMAINING ENERGY LEVEL
	JRLE	SUBEN2			;JUST IN CASE BOZO CALLED WITH ZERO
	SUB	A0,A1
	MOVE	A1,*A2(PENERGY),L
	CALLR	OUTENRGY		;AND DISPLAY THE REST
	MOVE	A1,A1
	JRLE	SUBEN2			;FLAG IF WE'VE HIT ZERO ENERGY
	CLRC
	JRUC	SUBENX
SUBEN2	SETC
SUBENX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* SUBTRACT A ROCKET BOMB						 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
SUBROCK
	PUSH	A0

	MOVE	*A2(PFLAGS),A0,L
	BTST	BUNLIMIT,A0
	JRNE	SUBROCKX		;HE'S IN FREE MODE, NO SUBTRACTION

	MOVE	*A2(PROCKETS),A0,W	;GET REMAINING # OF ROCKETS
	JRLE	SUBROCKX		;JUST IN CASE BOZO CALLED WITH ZERO

SUBROCK1
	DEC	A0	    		;KNOCK OFF A ROCKET
	MOVE	A0,*A2(PROCKETS),W
	CALLR	OUTROCKS		;AND DISPLAY THE REST

SUBROCKX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* SUBTRACT A BULLET							 *
* A2 = PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
SUBBULL
	PUSH	A0
	MOVE	*A2(PBULLETS),A0,W	;GET REMAINING # OF ROCKETS
	JRLE	SUBBULLX		;JUST IN CASE BOZO CALLED WITH ZERO

SUBBULL1
	DEC	A0	    		;KNOCK OFF A BULLET
	MOVE	A0,*A2(PBULLETS),W
	CALLR	OUTBULLS		;AND DISPLAY THE REST

SUBBULLX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* OUTPUT AMOUNT OF ENERGY						 *
* A2=PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
OUTENRGY:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14

	MOVE	@GAMSTATE,A3,W
	CMPI	INAMODE,A3
	JREQ	OUTENX			;NO ENERGY OUTPUT DURING ATTRACT MODE

	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS
	MOVE	*A2(PENRGSIZ),A9,L	;GET # OF LIFE UNITS/ENERGY UNIT
	MOVE	A2,A14			;STORE HERE

	MOVI	PENRGYOF,A0
	ADDXY	A0,A3			;ADD OFFSET FOR RIGHT END OF ENERGY
	MOVE	A3,A8			;TEMP STORAGE OF SCREEN ADDRESS
	MOVI	ENRGYSPC,A4		;SPACING BETWEEN DIGITS	

*BLANK THE LIFE DISPLAY AREA
OUTEN	CLR	A1   			;CONSTANT:PALETTE
	MOVK	NNRGBLKS,A6		;MAX # OF DISPLAYABLE LIFE BLOCKS
	MOVI	[NNRGBLKW,NNRGUNIP],A2	;AHH THE SIZE OF A LIFE BLOCK	

OUTEN1	CALLR	DMAENRGY			;BLANK OUT THE CURRENT ENERGY METER
	ADDXY	A4,A3			;MOVE TO NEXT PIECE OF ENERGY
	DSJS	A6,OUTEN1		;BR = CONTINUE BLANKING LIFE AREA

*OUTPUT THE CURRENT # OF LIVES
	MOVE	A14,A2
	MOVE	*A2(PENERGY),A7,L	;CURRENT # OF LIVES
	JRLE	OUTENX			;BR = NO LIVES

	MOVE	A7,A11
	DIVU	A9,A11			;A11 = LIVES/(LIVES/UNIT) = UNITS
	CMPI	NNRGUNIP,A11		;LAST BLOCK OF ENERGY
	JRLE	OUTEN2			;BR = YES, ISSUE WARNING COLOR 

	MOVI	0FCFC0000H,A1		;CONSTANT COLOR:PALETTE	(GREEN)
      	JRUC	OUTEN3
OUTEN2
	MOVI	0F3F30000H,A1		;CONSTANT COLOR:PALETTE (RED)
OUTEN3
	MOVK	NNRGBLKS,A6
	MOVE	A8,A3			;RESTORE STARTING SCREEN ADDRESS
OUTEN4
	CLR	A2
	MOVK	NNRGUNIP,A11		;# OF UNITS/BLOCK
OUTEN5		
	INC	A2
	SUB	A9,A7
	JRLE	OUTEN6			;BR = LAST ONE CHUM
	DSJS	A11,OUTEN5

	ADDI	[NNRGBLKW,0],A2		;ADD WIDTH
	CALLR	DMAENRGY
	ADDXY	A4,A3			;ADD SPACING
	DSJ	A6,OUTEN4
	JRUC	OUTENX			;MAX'D OUT
OUTEN6
	ADDI	[NNRGBLKW,0],A2
	CALLR	DMAENRGY			;DMA THE LAST ONE

OUTENX
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

**************************************************************************
*                                                                        *
* DMAENRGY - DMA'S 1 ENERGY UNIT OF CONSTANT SIZE AND COLOR		 *
*	    THE LIFE BLOCK IS RIGHT JUSTIFIED HERE.			 *
* A1 = CONSTANT:PALETTE							 *
* A2 = Y:X SIZE OF LIFE UNIT						 *
* A3 = DAG YPOS:XPOS							 * 
*                                                                        *
**************************************************************************
DMAENRGY	
	MMTM	SP,A4,A5,A10
	MOVE	A2,A10
	ZEXT	A10			;CLEAR WIDTH
	SUBI	[0,NNRGUNIP],A10
	JREQ	DMAENRG1		;NO JUSTIFY
	NEG	A10
	ADDXY	A10,A3			;ADJUST THE X POSITION		
DMAENRG1
	MOVI	2000000H,A4		;SOMEWHERE IN IMAGE ROM
	MOVI	DMACAL,A5		;WRITE CONSTANT COLOR ALWAYS
	CALLA	DMAN
	MMFM	SP,A4,A5,A10
	RETS

**************************************************************************
*                                                                        *
* OUTPUT NUMBER OF PLAYER LIVES						 *
* A2=PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
OUTLIVES:								 
	MMTM	SP,A0,A3,A4,A5,A6,A7,A14	 

	MOVE	@GAMSTATE,A3,W
	CMPI	INAMODE,A3
	JREQ	OUTLIVEX		;NO LIFE OUTPUT DURING ATTRACT MODE
									 
	MOVI	P1LIFE,A14		;DEFAULT PLAYER 1 IMAGE
	CMPI	P1DATA,A2
	JREQ	OUTLIVE1
	MOVI	P2LIFE,A14		;NOPE, WE WANT P2
OUTLIVE1
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS		 
	MOVI	PLIFECOF,A0						 
	ADDXY	A0,A3			;ADD OFFSET FOR ACCOUNT CLEAR	 
	MOVI	PLIFESIZ,A4		;SIZE OF LIFE ACCOUNTING AREA	 
	CALLA	BLNKAREA		;ZAP IT				 
									 
*OUTPUT THE CURRENT # OF LIVES					 
	MOVE	*A2(PLIVES),A7,W	;CURRENT # OF LIVES		 
	SUBK	1,A7			;ACCOUNT FOR CURRENT ENERGY
	JRLE	OUTLIVEX		;BR = NO LIVES			 
									 
	MOVE	*A14(ICMAP),A0,L
	CALLA	FINDPAL			;MAKE SURE IT HAS A PALETTE
	JRNZ	OUTLIVPL		;BR = THERE EXISTS A PALETTE
	MOVE	*A14(ICMAP),A0,L
	CALLA	GETFPAL			;MAKE A PALETTE EXIST	
OUTLIVPL
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS		 
	MOVI	PLIFEOF,A0						 
	ADDXY	A0,A3			;A3 = STARTING SCREEN ADDRESS OF LIVES

	MOVI	LIFESPC,A4		;SPACING BETWEEN LIVES	 
	MOVK	NLIVES,A6						 
	MOVI	DMAWNZ,A5						 
OUTLIVE5								 
	CALLA	DTIME			;DMA THE NEW LIFE COUNT	 
	ADDXY	A4,A3							 
	DEC	A6			;MAX ROCKET COUNT		 
	DSJNE	A7,OUTLIVE5						 
									 
OUTLIVEX								 
	MMFM	SP,A0,A3,A4,A5,A6,A7,A14	 
	RETS								 

**************************************************************************
*                                                                        *
* OUTMBIGS - OUTPUT NUMBER OF PLAYER MR. BIG KILLS			 *
* A2=PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
OUTMBIGS:								 
	MMTM	SP,A0,A3,A4,A5,A6,A7,A14	 

	MOVE	@GAMSTATE,A3,W
	CMPI	INAMODE,A3
	JREQ	OUTMBEX		;NO LIFE OUTPUT DURING ATTRACT MODE
									 
	MOVI	mbigblp1a,A14
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS		 
	MOVI	PMBIGCOF,A0						 
	ADDXY	A0,A3			;ADD OFFSET FOR ACCOUNT CLEAR	 
	MOVI	PMBIGSIZ,A4		;SIZE OF MR. BIG ACCOUNTING AREA	 
	CALLA	BLNKAREA		;ZAP IT				 
*OUTPUT THE CURRENT # OF LIVES					 
	MOVE	*A2(PMBIGS),A7,W	;CURRENT # OF MR. BIG KILLS		 
	JRLE	OUTMBEX			;BR = NO MR. BIGS			 
									 
	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS		 
	MOVI	PMBIGOF,A0						 
	ADDXY	A0,A3			;A3 = STARTING SCREEN ADDRESS OF MR. BIGS

	MOVI	MBIGSPC,A4		;SPACING BETWEEN MR. BIG ICONS
	MOVK	MAXMBIG,A6						 
	MOVI	DMAWNZ,A5						 
OUTMBE5								 
	CALLA	DTIME			;DMA THE NEW ICON 
	ADDXY	A4,A3							 
	DEC	A6			;MAX ICON COUNT		 
	DSJNE	A7,OUTMBE5						 
OUTMBEX								 
	MMFM	SP,A0,A3,A4,A5,A6,A7,A14	 
	RETS								 

**************************************************************************
*                                                                        *
* ADDCARDS - ADD SILVER SAFE CARD					 *
*                                                                        *
**************************************************************************
ADDCARDS
	PUSH	A0
	MOVI	PSCARD,A1
	JRUC	ADDCARD

**************************************************************************
*                                                                        *
* ADDCARDB - ADD BLUE SAFE CARD						 *
*                                                                        *
**************************************************************************
ADDCARDB
	PUSH	A0
	MOVI	PBCARD,A1
	JRUC	ADDCARD

**************************************************************************
*                                                                        *
* ADDCARDR - ADD RED SAFE CARD						 *
*                                                                        *
**************************************************************************
ADDCARDR
	PUSH	A0
	MOVI	PRCARD,A1
	JRUC	ADDCARD

**************************************************************************
*                                                                        *
* ADDCARDG - ADD GOLD SAFE CARD						 *
*                                                                        *
**************************************************************************
ADDCARDG
	PUSH	A0
	MOVI	PGCARD,A1
	JRUC	ADDCARD

**************************************************************************
*                                                                        *
* ADDCRDGR - ADD GREEN SAFE CARD					 *
*                                                                        *
**************************************************************************
ADDCRDGR
	PUSH	A0
	MOVI	PGRCARD,A1
	JRUC	ADDCARD

**************************************************************************
*                                                                        *
* ADDCARD - GENERIC ADD CARD						 *
* A1=OFFSET								 *
* A2=PLINDX								 *
* A1 PUSHED								 *
*                                                                        *
**************************************************************************
ADDCARD
	MMTM	SP,A2,A3
	ADD	A2,A1
	MOVB	*A1,A3
	INC	A3
	MOVB	A3,*A1
	CALLR	OUTCARDS
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* SUBCARDS - SUB SILVER SAFE CARD					 *
*                                                                        *
**************************************************************************
SUBCARDS
	PUSH	A0
	MOVI	PSCARD,A1
	JRUC	SUBCARD

**************************************************************************
*                                                                        *
* SUBCARDB - SUB BLUE SAFE CARD						 *
*                                                                        *
**************************************************************************
SUBCARDB
	PUSH	A0
	MOVI	PBCARD,A1
	JRUC	SUBCARD

**************************************************************************
*                                                                        *
* SUBCARDR - SUB RED SAFE CARD						 *
*                                                                        *
**************************************************************************
SUBCARDR
	PUSH	A0
	MOVI	PRCARD,A1
	JRUC	SUBCARD

**************************************************************************
*                                                                        *
* SUBCARDG - SUB GOLD SAFE CARD						 *
*                                                                        *
**************************************************************************
SUBCARDG
	PUSH	A0
	MOVI	PGCARD,A1
	JRUC	SUBCARD

**************************************************************************
*                                                                        *
* SUBCRDGR - SUB GREEN SAFE CARD					 *
*                                                                        *
**************************************************************************
SUBCRDGR
	PUSH	A0
	MOVI	PGRCARD,A1
	JRUC	SUBCARD

**************************************************************************
*                                                                        *
* SUBCARD - GENERIC SUB CARD						 *
* A1=OFFSET								 *
* A2=PLINDX								 *
* A1 PUSHED								 *
*                                                                        *
**************************************************************************
SUBCARD
	MMTM	SP,A2,A3
	ADD	A2,A1
	MOVB	*A1,A3
	JRZ	SUBCOUT			;BR = ALREADY OUT
	DEC	A3
	MOVB	A3,*A1
	CALLR	OUTCARDS
SUBCOUT
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* OUTPUT PLAYERS SAFE CARDS						 *
* A2=PLINDX=PLAYER DATA AREA						 *
*                                                                        *
**************************************************************************
OUTCARDS:								 
	MMTM	SP,A0,A1,A2,A3,A4,A5,A7,A14	 

	MOVE	@GAMSTATE,A3,W
	CMPI	INAMODE,A3
	JREQ	OUTCARDX1		;NO CARD OUTPUT DURING ATTRACT MODE

	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS		 
	MOVE	*A2(PCARDS),A7,L	;GET THE CARD ACCOUNTING
	MOVI	PCARDOF,A0						 
	ADDXY	A0,A3			;ADD OFFSET FOR ACCOUNT CLEAR	 
	MOVI	PCARDSIZ,A4		;SIZE OF SAFE CARD ACCOUNTING AREA	 
	CALLA	BLNKAREA		;ZAP IT			 
	MOVI	DMAWNZ,A5		;IT DOESN'T MATTER, IT'S A CONSTANT
	CLR	A1
	MOVI	PCARDSPC,A0		;HOLD SPACING HERE	

	MOVE	A7,A4
	SLL	24,A4
	JRZ	OUTCARDB
	MOVI	SMsilvcrd,A14
	CALLA	DTIME
	ADDXY	A0,A3
OUTCARDB
	MOVE	A7,A4
	SRL	8,A4
	SLL	24,A4
	JRZ	OUTCARDR
	MOVI	SMblucrd,A14
	CALLA	DTIME
	ADDXY	A0,A3
OUTCARDR
	MOVE	A7,A4
	SRL	16,A4	
	SLL	24,A4
	JRZ	OUTCARDG
	MOVI	SMredcrd,A14
	CALLA	DTIME
	ADDXY	A0,A3
OUTCARDG
	SRL	24,A7
	JRZ	OUTCARDX
	MOVI	SMgldcrd,A14
	CALLA	DTIME
	ADDXY	A0,A3
OUTCARDX								 
	MOVE	*A2(PCARDS1),A7,L
	SLL	24,A7
	JRZ	OUTCARDX1
	MOVI	SMgrncrd,A14
	CALLA	DTIME
	ADDXY	A0,A3
OUTCARDX1
	MMFM	SP,A0,A1,A2,A3,A4,A5,A7,A14	 
	RETS

**************************************************************************
*                                                                        *
* OUTICONS - OUTPUT THE DRUG, BULLET AND BUCK ICONS			 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTICONS
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6
	MOVE	*A2(PSCRAD),A6,L	;PLAYER SCORE ADDRESS

	MOVI	DMACNZ,A5
	MOVI	0F9F90000H,A1
	MOVI	PBUSTOF,A0
	MOVE	A6,A3
	ADDXY	A0,A3
	MOVI	BUSTICON,A14
	CALLA	DTIME

	MOVI	DMAWNZ,A5

	MOVI	PBULLOF,A0
	MOVE	A6,A3
	ADDXY	A0,A3			;ADD OFFSET FOR BULLET
	MOVI	GETCLIP,A14		;BULLET IMAGE	
	CALLA	DTIME

	MOVI	PROCKOF,A0
	MOVE	A6,A3
	ADDXY	A0,A3			;ADD OFFSET FOR BULLET
	MOVI	ROCKBIG,A14		;BULLET IMAGE	
	CALLA	DTIME

	MOVI	PDRUGOF,A0
	MOVE	A6,A3
	ADDXY	A0,A3			;ADD OFFSET FOR DRUGS
***	MOVI	GETDOPE,A14
	MOVE	@DOPESYM,A14,L
	CALLA	DTIME

	MOVI	PBUCKOF,A0
	MOVE	A6,A3
	ADDXY	A0,A3			;ADD OFFSET FOR CASH-OLA
	MOVI	GETCASH1,A14
	CALLA	DTIME
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6
	RETS

**************************************************************************
*                                                                        *
* OUTBULLS - OUTPUT THE # OF BULLETS					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTBULLS
	MMTM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A2(PBULLETS),A8,W	;GET THE BULLET COUNT	
	MOVI	0F9F9H,A6
	MOVI	PBULLCNT,A7
	MOVI	PBOOTSIZ,A4
	MOVI	PBULLOF,A5
	MOVI	GETCLIP,A14		;BULLET IMAGE	
	JRUC	OUTPCNT

**************************************************************************
*                                                                        *
* OUTROCKS - OUTPUT THE # OF ROCKETS					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTROCKS
	MMTM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A2(PROCKETS),A8,W	;GET THE ROCKET COUNT	
	MOVI	0F9F9H,A6
	MOVI	PROCKCNT,A7
	MOVI	PBOOTSIZ,A4
	MOVI	PROCKOF,A5	
	MOVI	ROCKBIG,A14
	JRUC	OUTPCNT

**************************************************************************
*                                                                        *
* OUTDRUGS - OUTPUT THE # OF DRUGS					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTDRUGS
	MMTM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A2(PDRUGS),A8,W	;GET THE BULLET COUNT	
	MOVI	0F9F9H,A6
	MOVI	PDRUGCNT,A7
	MOVI	PBOOTSIZ,A4
	MOVI	PDRUGOF,A5
***	MOVI	GETDOPE,A14
	MOVE	@DOPESYM,A14,L
	JRUC	OUTPCNT

**************************************************************************
*                                                                        *
* OUTBUCKS - OUTPUT THE # OF BUCKS					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTBUCKS
	MMTM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A2(PMONEY),A8,W	;GET THE BULLET COUNT	
	MOVI	0F9F9H,A6
	MOVI	PBUCKCNT,A7
	MOVI	PBOOTSIZ,A4
	MOVI	PBUCKOF,A5
	MOVI	GETCASH1,A14
	JRUC	OUTPCNT

**************************************************************************
*                                                                        *
* OUTBUSTS - OUTPUT THE # OF BUSTS					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
OUTBUSTS
	MMTM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A2(PBUSTS),A8,W	;GET THE BULLET COUNT	
	MOVI	0F9F9H,A6
	MOVI	PBUSTCNT,A7
	MOVI	PBOOTSIZ,A4
	MOVI	PBUSTOF,A5
	MOVI	BUSTICON,A14
	JRUC	OUTPCNT

**************************************************************************
*                                                                        *
* OUTPCNT - OUTPUT A DECIMAL COUNT(RIGHT JUSTIFIED) UP TO 99		 *
* 	  TO A PLAYER STATUS AREA					 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A4 = [Y,X] SIZE OF AREA						 *
* A5 = ICON OFFSET							 *
* A6 = COLOR								 *
* A7 = [Y,X] OFFSET TO LEFT END 					 *
* A8 = COUNT								 *
* A14 = PTR TO ICON							 *
*                                                                        *
**************************************************************************
OUTPCNT
	MOVE	*A2(PSCRAD),A11,L	;GET THE ADDRESS
	MOVE	A11,A3
	ADDXY	A5,A3
	CLR	A1
	MOVI	DMACAL,A5
	CALLA	DTIME			;CLEAR ICON
	MOVE	A8,A8
	JREQ	OUTPCNT0		;NO COUNT, NO ICON
	MOVI	DMAWNZ,A5
	CALLA	DTIME
OUTPCNT0
	MOVE	A11,A3
	ADDXY	A7,A3			;HERE IT IS
	CALLA	BLNKAREA		;BLANK WHAT HE'S GOT	
	MOVE	A8,A8
	JREQ	OUTPCNTX		;BR = NO COUNT, NO OUTPUT
OUTPCNTA
	CMPI	99,A8
	JRLE	OUTPCNT1
	MOVI	99,A8			;MUST SAVE REAL ESTATE
OUTPCNT1
	CALLA	HEXTOASC		;CONVERT TO ASCII
	CLR	A0			;NO SLEEP
	MOVE	A3,A9
	ZEXT	A4
	ADDXY	A4,A9			;END FOR RIGHT JUSTIFY
	MOVK	1,A10			;SPACING
	MOVI	RD7FONT,A11		;FONT
	JSRP	STRRNRM			;RIGHT JUSTIFY OUTPUR
OUTPCNTX
	MMFM	SP,A0,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

GCREDUL	.EQU	[65,192]
GCREDSIZ .EQU	[10,129]
GCREDPNT .EQU	[67,256]

**************************************************************************
*                                                                        *
* G_CRED - OUTPUT "CREDITS: xx" IN THE SCANNER BOX DURING GAMEPLAY	 *
* A8 = PTR CREDITS STRING, READY FOR STRINGER				 *
* NOTE: CHECK TO MAKE SURE WE ARE IN GAMEPLAY				 *
*                                                                        *
**************************************************************************
*ENTRY TO JUST REFRESH THE CREDIT'S NOT THE BUY-IN TIMER
G_CREDONLY
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	JRUC	G_CREDG
*ENTRY CALLED EVERY TIME A COIN IS PUT IN
G_CRED
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVI	BUYINPID,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRZ	G_CRED1			;THERE IS NO BUY IN AT THIS TIME
	MOVI	BUYTIME,A14
	MOVE	A14,@BTIME,W		;RESET THE BUY-IN TIME
	MOVE	A0,A14
	MOVI	BTIMEOID,A0
	CALLA	EXISTOBJ
	JRZ	G_CRED1			;THERE'S NO PHYSICAL TIMER AS OF YET
	MOVE	A14,A0
	MOVI	BUYTICK,A11
	CALLA	PUTA11			;RESET THE TICK TIMER
G_CRED1
	MOVI	BUYCPID,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRZ	G_CREDG
	MOVI	BUYTICK*BUYTIME,A9	;RESET THE WAIT TIMER
	CALLA	PUTA9
*G_CREDG GENERIC ENTRY TO SKIP ALL THE BUY-IN STUFF, USE THIS TO SIMPLY
*	REFRESH THE CREDITS MESSAGE. MAKE SURE REGS ARE PUSHED
G_CREDG
	MOVE	@GAMSTATE,A3,W
	CMPI	INDIAG,A3	
	JREQ	G_CREDXX
	CMPI	INAMODE,A3	
	JRNE	G_CREDGO
	MOVE	@PLAYPAGE,A3,W
	JREQ	G_CREDXX		;IN ATTRACT MODE BUT NOT PLAYING
G_CREDGO
	CALLA	GET_CSTR		;GET THE CREDITS STRING IN A8
	MOVI	0C0C0H,A6
	CALLR	SCANMESS
G_CREDXX
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

**************************************************************************
*                                                                        *
* CRCMESS - PROCESS TO PUT "CROUCH REVERSES CAR" MESSAGE		 *
*                                                                        *
**************************************************************************
CRCMESS
	MOVI	CRCPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
	MOVI	CRCSTRING,A8
	MOVI	0F5F5H,A6	
	CALLR	SCANMESS
	SLEEP	60*4
	CALLR	G_CREDONLY		;RE-OUTPUT CREDIT MESSAGE
	DIE

**************************************************************************
*                                                                        *
* PICKMESS - PROCESS TO PUT "PICK UP SAFE CARD" MESSAGE			 *
*                                                                        *
**************************************************************************
PICKMESS
	MOVI	CRCPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
PICKMLP
	MOVI	PICKSTRING,A8
	MOVI	0F5F5H,A6	
	CALLR	SCANMESS
	SLEEP	30H
	MOVI	0F5F5H,A6	
	CALLR	SCANMESS
	SLOOP	30H,PICKMLP

**************************************************************************
*                                                                        *
* CLRMESS - CURRENT MESSAGE PROCESS AND PUT THE CREDITS MESSAGE BACK	 *
*                                                                        *
**************************************************************************
CLRMESS
	MMTM	SP,A0,A1
	MOVI	CRCPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
       	CALLA	G_CREDONLY
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* SCANMESS - SCANNER AREA MESSAGE.					 *
* A6 = COLOR								 *
* A8 = PTR TO STRING							 *
* RETURNS:								 *
* A8 = NEXT STRING							 *
*                                                                        *
**************************************************************************
SCANMESS
	MMTM	SP,A0,A1,A2,A3,A4,A6,A7,A9,A10,A11
	MOVI	GCREDUL,A3	
	MOVI	GCREDSIZ,A4
	CALLA	BLNKAREA
	CLR	A0
	MOVI	GCREDPNT,A9
	MOVK	1,A10
	MOVI	RD7FONT,A11
	JSRP	STRCNRM
	MMFM	SP,A0,A1,A2,A3,A4,A6,A7,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* OUTNEXTR - OUTPUT A PLAYER'S NEXT REPLAY LEVEL			 *
* A2 = PLAYER DATA AREA							 *
*                                                                        *
**************************************************************************
OUTNEXTR
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	@GAMSTATE,A0,W
	CMPI	INAMODE,A0
	JREQ	OUTNRNULL
	MOVE	*A2(POBJ),A0,L
	JRZ	OUTNRNULL		;GUY IS DEAD
  	MOVE	*A2(PNEXTREP),A0,L
	JRZ	OUTNRNULL
*
*	get an object for data
*
	CALLA	STR_OBJ			;ALLOCATE FOR A7
	JRC	OUTNRNULL		;CAN'T...TOO BAD

	MOVI	M_REPAT,A8	
	CALLA	STRCAT			;NOW A7 HAS "REPLAY AT"

	CALLA	BCDBIN
	MOVE	A0,A8
	CALLA	HEXTOASC
	
	CALLA	STRCAT
	MOVE	A7,A8			;FULL STRING AIN A8

	MOVI	0FBFBH,A6
	CALLR	PMESSAGE		;OUTPUT THE MESSAGE

	CALLA	STR_FREE		;FREE UP STRING SPACE
OUTNEXTX
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

OUTNRNULL
	MOVI	BLANKMSG,A8		;NULL STRING FOR NEXT REPLAY
	CALLR	PMESSAGE
	JRUC	OUTNEXTX
**************************************************************************
*                                                                        *
* PRESCONT - ALTERNATE BETWEEN "PRESS START" OR "INSERT COIN",		 *
*	     AND "TO CONTINUE" IN A PLAYER MESSAGE AREA.		 *
* A11 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
PRESCONT
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	KILALL			;KILL OTHER GUYS
	MOVI	0F6F6H,A10
	MOVE	A11,A2
	MOVI	BLANKMSG,A8
	CALLR	PMESSAGE		;CLEAR OUT THE BOTTOM MESSAGE
PRESSLP
	MOVE	*A11(PBUYINS),A0,W
	JRNZ	PRESSCGO
*
*OUTPUT PLAYER STANDBY MESSAGE
	MOVE	A11,A2
	CMPI	P1DATA,A11
	JRNE	PRESP2SB
	MOVI	PLAYER1M,A8
	JRUC	PRESSBM
PRESP2SB
	MOVI	PLAYER2M,A8
PRESSBM
	MOVI	0F7F7H,A6
	CALLR	PMESSB1
	MOVI	STANDBYM,A8
	CALLR	PMESSB2
	SLOOP	16,PRESSLP

PRESSCGO
	MOVE	*A11(PSCORE),A0,L
	JRZ	PRESSTRT		;NO SCORE, THIS IS A VIRGIN START
	MOVE	@GAMSTATE,A0,W
	CMPI	INGAMEOV,A0
	JREQ	PRESSTRT
	CMPI	INAMODE,A0
	JREQ	PRESSTRT

	CALLA	CR_CONTP	;CONTINUATION, UGH, CALL/CC
	JRLO	INSCONT		;NOT ENUFF FOR THE CONTINUE
	JRUC	PRESSTOC
PRESSTRT
	CALLA	CR_STRTP
	JRLO	INSCONT		;NOT ENUFF TO START THIS GUY
	JRUC	PRESSTOC

*OUTPUT "PRESS" ON TOP EITHER "START 1" OR "START 2" ON BOTTOM
PRESSTOC
	MOVE	A10,A6
	MOVE	A11,A2
	MOVI	PRESSMSG,A8
	CALLR	PMESSB1

	CMPI	P1DATA,A11
	JRNE	PRESCONA		;BR = PLAYER 2
	MOVI	STRT1MSG,A8		;SELECT "START 1"
	JRUC	PRESCON1
PRESCONA
	MOVI	STRT2MSG,A8		;SELECT "START 2"
PRESCON1
	CALLR	PMESSB2			;OUPUT WHAT TO DO
	JRUC	NEXT1

*OUTPUT "INSERT" ON TOP, "COIN" ON BOTTOM
INSCONT
	MOVE	A10,A6
	MOVE	A11,A2
	MOVI	INSRTMSG,A8
	CALLR	PMESSB1
	MOVI	COINMSG,A8
	CALLR	PMESSB2
	JRUC	NEXT1
*START OF NEXT MESSAGE
NEXT1
	SLEEP	1FH			;READABILITY FACTOR
*OUPUT "TO" ON THE TOP, AND EITHER "CONTINUE" OR "PLAY" ON THE BOTTOM
	MOVE	A10,A6
	MOVE	A11,A2
	MOVI	TOMSG,A8
	CALLR	PMESSB1

	MOVE	*A11(PSCORE),A0,L
	JRZ	TOPLAY			;NO SCORE, THIS IS A VIRGIN START
	MOVE	@GAMSTATE,A0,W
	CMPI	INGAMEOV,A0
	JREQ	TOPLAY
	CMPI	INAMODE,A0
	JREQ	TOPLAY

	MOVI	CONTMSG,A8
	CALLR	PMESSB2
	JRUC	NEXT2
TOPLAY
	MOVI	PLAYMSG,A8
	CALLR	PMESSB2
	JRUC	NEXT2
NEXT2
	SLOOP	1FH,PRESSLP

**************************************************************************
*                                                                        *
* PLAYMESS - PLAYER AREA MESSAGE HANDLER				 *
*                                                                        *
**************************************************************************
*
*DO THE CLOSE CALL MESSAGE
*A11 = PTR TO PLAYER DATA STRUCTURE
CLOSCALL
	MOVI	0F5F5H,A6

	CMPI	P1DATA,A11
	JRNE	CLOSCALA		;BR = PLAYER 2
	MOVI	CLOS1MSG,A8		;SELECT "CLOSE CALL PLAYER 1"
	JRUC	CLOSCAL1
CLOSCALA
	MOVI	CLOS2MSG,A8		;SELECT "CLOSE CALL PLAYER 2"
CLOSCAL1
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	KILALL			;KILL OTHER GUYS
	MOVE	A11,A2
	CALLR	PMESSAGE
	SLEEP	7FH
	MOVE	A11,A2
	CALLR	OUTNEXTR
	DIE

*
*OUTPUT A PLAYER ONE MESSAGE
P1MESSAG
	MOVI	P1DATA,A2
	JRUC	PMESSAGE
*
*OUTPUT A PLAYER TWO MESSAGE
P2MESSAG
	MOVI	P2DATA,A2
**************************************************************************
*                                                                        *
* PMESSAGE - OUTPUT A MESSAGE IN THE PLAYERS MESSAGE AREA		 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A6 = COLOR								 *
* A8 = PTR TO STRING							 *
* NOTE: CALL THIS ONLY FROM A PROCESS					 *
*                                                                        *
**************************************************************************
PMESSAGE
	MMTM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	MOVE	*A2(PSCRAD),A9,L
	ADDI	PMSGOF,A9		;GET DAG
	MOVE	A9,A3			;HERE FOR MESSAGE BLNK
	MOVI	PMSGSIZ,A4
	CALLA	BLNKAREA		;BLANK US FIRST
	ZEXT	A4
	SRL	1,A4			;X SIZE/2
	ADDXY	A4,A9			;CENTER THIS GUY
	CLR	A0
	MOVK	1,A10
	MOVI	RD7FONT,A11
	JSRP	STRCNRM
	MMFM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* PMESSB1 - OUTPUT A BIG MESSAGE IN THE STATUS AREA, TOP HALF		 *
*		BIG MESSAGES CONSUME AN AREA THE SAME WIDTH AS A	 *
*		NORMAL MESSAGE, BUT THE HEIGHT IS FROM THE BOTTOM OF	 *
*		THE SCORE TO THE BOTTOM OF THE STATUS AREA.		 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A6 = COLOR								 *
* A8 = PTR TO STRING							 *
* NOTE: CALL THIS ONLY FROM A PROCESS					 *
*                                                                        *
**************************************************************************
PMESSB1
	MMTM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	MOVE	*A2(PSCRAD),A9,L
	ADDI	PB1MSGOF,A9		;GET DAG
	MOVE	A9,A3			;HERE FOR MESSAGE BLNK
	MOVI	PB1MGSIZ,A4
	CALLA	BLNKAREA		;BLANK US FIRST
	ZEXT	A4
	SRL	1,A4			;X SIZE/2
	ADDXY	A4,A9			;CENTER THIS GUY
	CLR	A0
	MOVK	1,A10
	MOVI	RD15FONT,A11
	JSRP	STRCNRM
	MMFM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	RETS
**************************************************************************
*                                                                        *
* BLANKB1 - BLANK THE B1 MESSAGE AREA					 *
* A2 = PLINDX								 *
*                                                                        *
**************************************************************************
BLANKB1
	MMTM	SP,A3,A4
	MOVE	*A2(PSCRAD),A3,L
	ADDI	PB1MSGOF,A3		;GET DAG
	MOVI	PB1MGSIZ,A4
	CALLA	BLNKAREA		;BLANK US FIRST
	MMFM	SP,A3,A4
	RETS
**************************************************************************
*                                                                        *
* PMESSB2 - OUTPUT A BIG MESSAGE IN THE STATUS AREA, BOTTOM HALF.	 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A6 = COLOR								 *
* A8 = PTR TO STRING							 *
* NOTE: CALL THIS ONLY FROM A PROCESS					 *
*                                                                        *
**************************************************************************
PMESSB2
	MMTM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	MOVE	*A2(PSCRAD),A9,L
	ADDI	PB2MSGOF,A9		;GET DAG
	MOVE	A9,A3			;HERE FOR MESSAGE BLNK
	MOVI	PB2MGSIZ,A4
	CALLA	BLNKAREA		;BLANK US FIRST
	ZEXT	A4
	SRL	1,A4			;X SIZE/2
	ADDXY	A4,A9			;CENTER THIS GUY
	CLR	A0
	MOVK	1,A10
	MOVI	RD15FONT,A11
	JSRP	STRCNRM
	MMFM	SP,A0,A1,A2,A3,A4,A6,A7,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* BLANKB2 - BLANK THE B2 MESSAGE AREA					 *
* A2 = PLINDX								 *
*                                                                        *
**************************************************************************
BLANKB2
	MMTM	SP,A3,A4
	MOVE	*A2(PSCRAD),A3,L
	ADDI	PB2MSGOF,A3		;GET DAG
	MOVI	PB2MGSIZ,A4
	CALLA	BLNKAREA		;BLANK US FIRST
	MMFM	SP,A3,A4
	RETS

INSRTMSG
	.STRING "INSERT"
	.BYTE	0
COINMSG
	.STRING "COIN"
	.BYTE	0
PRESSMSG
	.STRING "PRESS"
	.BYTE	0
STRT1MSG
	.STRING "START 1"
	.BYTE	0
STRT2MSG
	.STRING "START 2"
	.BYTE	0
TOMSG
	.STRING "TO"
	.BYTE	0
CONTMSG
	.STRING "CONTINUE"
	.BYTE	0
PLAYMSG
	.STRING	"PLAY"
	.BYTE	0

PLAYER1M
	.STRING	"PLAYER 1"
	.BYTE	0
PLAYER2M
	.STRING	"PLAYER 2"
	.BYTE	0
STANDBYM
	.STRING	"STANDBY"
	.BYTE	0
M_REPAT
	.STRING	"FREE: "
	.BYTE	0

CRCSTRING
	.STRING "CROUCH SPINS CAR"
	.BYTE	0

PICKSTRING
	.STRING	"PICK UP SAFE CARD"
	.BYTE	0
	.STRING	"TO EXIT"
	.BYTE	0
	.EVEN

	.END
