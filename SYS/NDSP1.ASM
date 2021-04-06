	.FILE	'NDSP1.ASM'
	.TITLE	"GSP DISPLAY PROCESSOR VER. 3.1"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*
*GSP DMA OBJECT HANDLER
*VERSION 1.0 BY WARREN DAVIS 9/1/87
*VERSION 2.01 BY EUGENE JARVIS 10/25/87 
*VERSION 3.0 BY EUGENE JARVIS 12/20/87
*VERSION 3.1 BY EUGENE JARVIS 7/4/88
*VERSION 3.2 BY EUGENE JARVIS 8/8/88	
****************************************
*FILES REQUIRED FOR ASSEMBLY
        .INCLUDE	\VIDEO\GSP.INC
        .INCLUDE	\VIDEO\SYS.INC
	.INCLUDE	\VIDEO\MACROS.HDR
	.INCLUDE	\VIDEO\MPROCEQU.ASM
	.INCLUDE	\VIDEO\DISPEQU.ASM
*
*BULLET OBJECTS
B1OID		EQU	>0B10		;OBJECT ID FOR PLAYER 1 BULLETS
B2OID		EQU	>0B20		;OBJECT ID FOR PLAYER 2 BULLETS
BEOID		EQU	>0BE0		;OBJECT ID FOR ENEMY BULLETS
BUCKOID		EQU	>8010		;MONEY LOOT
DRUGOID		EQU	>0011	       	;DRUG LOOT
ROCKOID		EQU	>8012		;ROCKET LOOT
CLIPOID		EQU	>8013		;CLIP LOOT

*
*	GLOBAL VARIABLES
*
	.GLOBAL		PLZMIN
	.sect	"OFIXED"

OBJLST	.long	0	;POINTER TO ACTIVE OBJECT LIST
OFREE	.long	0	; pointer to free object block
BAKLST	.LONG	0	;BACKGROUND LIST
BAK2LST .LONG	0	;SLOW SCROLL BACKGROUND PLANE

	.SECT	"DISPTEXT"
*
	.BSS	SCROLLX,32		;X SCROLL VALUE
	.BSS	SCROLLY,32		;Y SCROLL VALUE
	.BSS	WORLDTLX,32		;TOP LEFT X SCREEN COORD (WORLD)
	.BSS	WORLDTLY,32		;TOP LEFT Y SCREEN COORD (WORLD)
	.BSS	WORLDTL,32		;PACKED TOP LEFT WORLD COORD
	.BSS	SCRNTL,32		;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.BSS	SCRNLR,32		;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)
	.BSS	BAK2TLY,32		;TOP LFT Y SLOW SCROLL BACKGROUND
	.BSS	BAK2TLX,32		;TOP LFT X SLOW SCROLL BACKGROUND
	.BSS	QSYNC,16		;SIGNALS ACTIVE Q
	.BSS	DMAQCUR,32		;CURRENT DMAQ
	.BSS	DMAQCNT,16		;CURRENT DMAQ COUNT
	.BSS	BOTQ0CNT,16		;BOTTOM QUEUE COUNT #0
	.BSS	BOTQ1CNT,16		;BOTTOM QUEUE COUNT #1
	.BSS	TOPQ0CNT,16		;TOP QUEUE COUNT #0
	.BSS	TOPQ1CNT,16		;TOP QUEUE COUNT #1
	.BSS	BOTQ0FLG,16	     	;BOTTOM Q0 VALID FLAG  VALID=NE
	.BSS	BOTQ1FLG,16		;BOTTOM Q1 VALID FLAG  VALID=NE
	.BSS	TOPQ0FLG,16		;TOP Q0 VALID FLAG  VALID=NE
	.BSS	TOPQ1FLG,16		;TOP Q1 VALID FLAG  VALID=NE
  	.BSS	OBJSTR,NOBJ*OBSIZ	;OBJECT STRUCTURE LIST START
	.BSS	OBJLSTND,0		;OBJECT LIST END
QSIZE	.SET	NOBJ*BQCELL		;SIZE OF QUEUES
	.BSS	BOTQ0,QSIZE		;BOTTOM OBJECT DMA Q #0
	.BSS	BOTQ1,QSIZE   		;BOTTOM OBJECT DMA Q #1
	.BSS	TOPQ0,QSIZE		;TOP OBJECT DMA Q #0
	.BSS	TOPQ1,QSIZE		;TOP OBJECT DMA Q #1
	.BSS	DMAQ,QSIZE		;MISC. NON-SYNC DMA QUEUE	
	.BSS	DISPLAYON,16		;DO DISPLAY PROCESSING WHEN != 0
	.BSS	SKIPDMA,16		;SKIP DMA RESTART IF != 0
	.BSS	QDMAFLG,16		;SPECIAL DMAQ BEING UPDATED=1
***************overload
****>	.BSS	OVTOP,16		;TOP SCREEN OVERLOAD
****>	.BSS	OVBOT,16		;BOTTOM SCREEN OVERLOAD

**************************************************************************
*                                                                        *
* STOPOBJS - ZEROS VELOCITIES FOR ALL OBJECTS ON OBJLST.		 *
*                                                                        *
**************************************************************************
STOPOBJS
	MMTM	SP,A0,A1
	CLR	A0
	MOVI	OBJLST,A1
SOBJS1
	MOVE	*A1,A1,L
	JREQ	SOBJSX
	MOVE	A0,*A1(OXVEL),L
	MOVE	A0,*A1(OYVEL),L
	MOVE	A0,*A1(OZVEL),L
	JRUC	SOBJS1
SOBJSX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* SHADOW STUFF								 *
*                                                                        *
**************************************************************************
*START A PART 2 SHADOW
*A8 = OBJECT TO SHADOW
SHADST2
	MMTM	SP,A1
	CALLR	GETOBJ
	JREQ	SHADSTX			;NONE AVAIL
	CALLR	SHADCPY2	
	JRUC	SHADSTG
*START A SHADOW
*INPUTS
*A8=OBJECT TO SHADOW
*RETURNS:
*A0=PTR TO SHADOW, OR 0 IF NO SHADOW WAS CREATED
*
SHADST:
	MMTM	SP,A1
	CALLR	GETOBJ
	JREQ	SHADSTX			;NONE AVAIL
	CALLR	SHADCPY	
SHADSTG
	MOVI	DUMCOLL,A1
	MOVE	A1,*A0(OCVECT),L	;DUMMY COLLISION
	CALLR	INSOBJ
	MOVI	SHADID,A1,W
	MOVE	A1,*A0(OID),W		;SET ID
	MOVI	>66660000,A1
	MOVE	A1,*A0(OPAL),L		;SET PALLETTE,COLOR
	MOVE	A8,*A0(OSHAD),L		;LINK TO SHADOWED OBJECT
	MOVE	A0,*A8(OSHAD),L		;LINK TO SHADOW
SHADSTX:
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
* SHADUPD - SHADOW UPDATE						 *
* A8 = OBJECT								 *
*                                                                        *
**************************************************************************
SHADUPD
	PUSH	A0
	MOVE	*A8(OSHAD),A0,L
	JRZ	SHADUPDX
	CALLR	SHADCPY
SHADUPDX
	PULL	A0
	RETS
	
**************************************************************************
*                                                                        *
* SHADUPD2 - SHADOW UPDATE MULTI PART OBJECT				 *
* A8 = OBJECT								 *
*                                                                        *
**************************************************************************
SHADUPD2
	PUSH	A0
	MOVE	*A8(OSHAD),A0,L
	JRZ	SHADUP2X
	CALLR	SHADCPY2
SHADUP2X
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* SHADCPY - COPIES OSAG,OIMG,OXVEL,OYVEL,OXVAL				 *
* 	  ADJUSTS OSIZE,OFSET,OYVAL,OXCLIP				 *
* A0 = PTR TO SHADOW OBJECT						 *
* A8 = PTR TO OBJECT BEING SHADOWED					 *
*                                                                        *
**************************************************************************
SHADCPY:
   	MMTM	SP,A1,A2,A3
	CALLR	SHADCPYG
SHADC1
	MOVE	A2,*A0(OYVAL),L
	MOVE	*A8(OIMG),*A0(OIMG),L
	MOVE	*A8(OZVAL),A1,L		;ADJUST Z IN BACK OF OBJECT
	SUBK	2,A1
	MOVE	A1,*A0(OZVAL),L
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* SHADCPY2 - COPIES OSAG,OIMG,OXVEL,OYVEL,OXVAL				 *
* 	   ADJUSTS OSIZE,OFSET,OYVAL,OXCLIP				 *
* 	   THIS CALL IS FOR A TORSO OBJECT, I.E. TWO OBJECT THIS	 *
* 	   ONE MOUNTED ON TOP OF THE OTHER, PLAYER ONLY.		 *
* A0 = PTR TO SHADOW OBJECT						 *
* A8 = PTR TO OBJECT BEING SHADOWED					 *
*                                                                        *
**************************************************************************
SHADCPY2
	MMTM	SP,A1,A2,A3,A4,A5
	CALLR	SHADCPYG

	SRA	2,A1			;A1 = DISTANCE_FROM_GROUND/4
	SUBI	20000H,A1		;FUDGE FACTOR
	SUB	A1,A2			;ADJUST Y POSITION OF SHADOW
SHADC22
	MOVE	A2,*A0(OYVAL),L
	MOVE	*A8(OIMG),*A0(OIMG),L
	MOVE	*A8(OZVAL),A1,L		;ADJUST Z IN BACK OF OBJECT
	SUBK	2,A1
	MOVE	A1,*A0(OZVAL),L
	MMFM	SP,A1,A2,A3,A4,A5
	RETS

*A SUBROUTINE OF SHADCPY AND SHADCPY2
*RETURNS
*A1 = DISTANCE OF THIS SHADOW FROM THE GROUND (32 BITS)
*A2 = SHADOW Y POSITION ON THE GROUND (32 BITS)
*A3 = 3/4 HEIGHT OF THE SHADOW
SHADCPYG
	MOVE	*A8(OZVEL),*A0(OYVEL),L
	MOVE	*A8(OZVEL),*A0(OZVEL),L
	MOVE	*A8(OSAG),*A0(OSAG),L
	MOVE	*A8(OXVEL),*A0(OXVEL),L
	MOVE	*A8(OXVAL),*A0(OXVAL),L
	MOVE	*A8(OSIZE),A1,L
	MOVY	A1,A2			;GET H/4
	CLR	A3			;SAVE H
	MOVY	A1,A3
	SRL	16,A2			;RUB-OUT OTHER GARBAGE
	CMPI	2,A2
	JRLE	SHDCPYG1
	SUBK	2,A2			;FUDGE-O-MATIC
SHDCPYG1
	CMPI	>A,A2
	JRHS	SHDCPYG2		;BR = BIG OBJECT
	MOVE	A1,*A0(OSIZE),L		;SMALL OBJECT, DONT REDUCE
*	SRL	2,A2			;NOW DIVIDE BY FOUR
*	SLL	16,A2			;BRING BACK TO PROPER SPOT
*	SUBXY	A2,A3			;3/4 H
	CLR	A3
	CLR	A2
	JRUC	SHDCPYG3
SHDCPYG2
	SRL	2,A2			;NOW DIVIDE BY FOUR
	SLL	16,A2			;BRING BACK TO PROPER SPOT
	SUBXY	A2,A3			;3/4 H
	MOVY	A2,A1			
	MOVE	A1,*A0(OSIZE),L		;STORE OUT NEW SIZE
	MOVE	A1,A2			;GET WIDTH
	ADDXY	A1,A2
	ADDXY	A1,A2			;MULTIPLY BY 3
SHDCPYG3
	ZEXT	A2,W			;WIPE OUT Y JIVE
	MOVE	A2,*A0(OXCLIP),W	;ADDITIONAL CLIPPING FACTOR
	PUSH	A4
	MOVE	*A8(OFLAGS),A1,L
	MOVE	A1,A4	
	SRL	4,A1			;SHIFT OFF FLAGS
	SLL	4,A1
	SLL	28,A4
	JRZ	SHAD1A			;BR = THIS DUDE'S NOT ON
	ADDK	8,A1			;SET CONSTANT WRITE NON-ZERO
SHAD1A
	PULL	A4
	BTST	B_FLIPV,A1
	JREQ	SHAD1
	NEG	A2			;NEGATE OFFSET
SHAD1:	SLL	16,A2	
	ADDXY	A2,A1			;ADD IN OFFSET
	MOVE	A1,*A0(OFLAGS),L
	MOVE	*A8(OYVAL),A2,L
	ADD	A3,A2
	CALLA	DFRMGRND
	SLL	16,A1
	ADD	A1,A2			;NOW ADD THE SHADOW TO GROUND ADJUSTMENT
	RETS

*
*SORT OBJECT LIST IN Z:Y PRIORITY
*
YZSORT:
	MMTM	SP,A0,A1,A2,A4,A5,A7,A8
	MOVI	080000000H,A1	;LOWEST POSSIBLE Z
	MOVI	080000000H,A5	;LOWEST POSSIBLE Y
	MOVI	OBJLST,A0
	JRUC	YZLP
YZLP0:
	MOVE	*A2(OZVAL),A8,L		;TEST Z
	MOVE	*A2(OYVAL),A7,L		;TEST Y
	CMP   	A1,A8
	jrgt  	priok
	JRLT	PRISWAP

	CMP	A5,A7
	JRGE	priok
PRISWAP:
	PUSHST
	dint
	move  	a2,*A4,L
	move  	*a2,*a0,L
	move  	a0,*a2,L
	POPST
	move  	a2,A4
	JRUC	YZLP
priok:
	move  	a0,A4
	move  	a2,a0
	move  	a8,a1
	MOVE	A7,A5
YZLP:
	move	*a0,a2,L     	; current link in a2, prev in A4
	jrne  	YZLP0
	MMFM	SP,A0,A1,A2,A4,A5,A7,A8
	RETS
**************************************************************************
*                                                                        *
* *									 *
* *SORT OBJECT LIST IN Z:Y PRIORITY					 *
* *A1=INDEX TO SHELL SORT						 *
* *									 *
* YZNSORT:								 *
* 	MMTM	SP,A0,A1,A2,A4,A8					 *
* 	MOVI	OBJLST,A4	;REAR BACKLINK				 *
* 	MOVE	*A4,A0,L	;REAR ELEMENT				 *
* 	JREQ	YZNSRTX		;NULL LIST, BAG IT...			 *
* 	MOVE	A0,A6		;FRONT ELEMENT				 *
* YZNDEX:								 *
* 	MOVE	*A6,A2,L						 *
* 	JREQ	YZNSRTX		;REACHED THE END BEFORE INDEX COUNT	 *
* 	DSJS	A1,YZNDEX						 *
* 									 *
* YZNLP0:								 *
* 	MOVE	*A2(OZPOS),A8,W	;GET FORWARD VALUE			 *
* 	MOVE	*A0(OZPOS),A1,W	;GET BACKWARD VALUE			 *
* 	cmp   	a1,a8							 *
* 	JRGT  	YZNLP		;DONT SWAP, PRIORITY O.K.		 *
* 	JRLT	YZNSWAP							 *
* 									 *
* 	MOVE	*A2(OYPOS),A8,W	;GET FORWARD VALUE			 *
* 	MOVE	*A0(OYPOS),A1,W	;GET BACKWARD VALUE			 *
* 	cmp   	a1,a8							 *
* 	jrge  	YZNLP		;DONT SWAP, PRIORITY O.K.		 *
* 									 *
* YZNSWAP:								 *
* 	MOVE	*A0,A1,L						 *
* 	MOVE	*A2,A8,L						 *
* 	PUSHST								 *
* 	DINT								 *
* 	MOVE	A8,*A0,L		;SWAP 'EM DONT LET IN INTERRUPTS *
* 	MOVE	A0,*A6,L						 *
* 	MOVE	A1,*A2,L						 *
* 	MOVE	A2,*A4,L						 *
* 	POPST								 *
* 									 *
* 	MOVE	A2,A4							 *
* 	MOVE	A0,A6							 *
* 	MOVE	A1,A0							 *
* 	MOVE	A8,A2							 *
* 	JRNE	YZNLP0							 *
* 									 *
* YZNLP:								 *
* 	MOVE	A0,A4		;ADVANCE REAR ELEMENT			 *
* 	MOVE	*A4,A0,L						 *
* 	MOVE	A2,A6		;ADVANCE FRONT ELEMENT			 *
* 	MOVE	*A6,A2,L						 *
* 	JRNE	YZNLP0							 *
* YZNSRTX:								 *
* 	MMFM	SP,A0,A1,A2,A4,A8					 *
* 	RETS								 *
*                                                                        *
**************************************************************************
*
*TEST IF OBJECT ON SCREEN
*A8=OBJECT
*RETURNS EQ IF ON SCREEN
*
*ENTER HERE AND PROVIDE YOUR OWN SCREEN BOUNDRIES
SCRTSTG
	MMTM	SP,A0,A1,A2,A3
	JRUC	SCRTST1
*NORMAL SCREEN BOUNDRIES
SCRTST:
	MMTM	SP,A0,A1,A2,A3	

	MOVE	@SCRNTL,A2,L		;GET SCREEN TOP LEFT
	MOVE	@SCRNLR,A3,L		;GET SCREEN LOWER RT.
SCRTST1
	MOVE	*A8(OYPOS),A0,W
	MOVE	*A8(OXPOS),A1,W
	SLL	16,A0
	MOVX	A1,A0	       		;GET TOP LEFT OF OBJECT
	MOVE	@WORLDTL,A1,L
	SUBXY	A1,A0			;SUBTRACT OUT WORLD BASE
	MOVE	*A8(OSIZE),A1,L
	ADDXY	A0,A1			;GET LOWER RT OF OBJECT

	CMPXY	A3,A0			;IS IT LOWER THAN LOWER RT?
	JRYGE	SCRTF			;LOWER
	JRXGE	SCRTF			;TO THE RIGHT

	CMPXY	A2,A1
	JRYLE	SCRTF			;ABOVE...
	JRXLE	SCRTF			;TO THE LEFT..

	CLR	A0
	JRUC	SCRTX		;RETRUN EQ (ON SCREEN)
SCRTF:
	MOVK	1,A0
	MOVE	A0,A0		;RETURN NE (NOT ON SCREEN)
SCRTX:
	MMFM	SP,A0,A1,A2,A3
	RETS
*
*CLIP AN OBJECT
*INPUTS:
*A2=BOTTOM:RIGHT CLIP (RELATIVE TO CURRENT SIZE)
*A3=TOP:LEFT CLIP (RELATIVE TO CURRENT SIZE)
*A8=OBJECT BLOCK
*RETURNS
*NEW SAG,H,W,OFFSET,XCLIP IN OBJECT STRUCTURE
*ALL REGISTERS PRESERVED
*
CLIPOBJ:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	MOVE	A8,A0
	MOVE	*A8(OXPOS),A4,W
	MOVE	*A8(OYPOS),A5,W
	ADDI	OFLAGS,A0  	;GET INDEX INTO OBJECT STRUCTURE

* 	a1 becomes OFFSET
*	a6= TOTAL HORIZ. SIZE
*	A9= VS:HS
*	A11= SAG
*	A12= OFFSET:FLAGS

	MMFM	A0,A9,A11,A12
	MOVE	*A8(OXCLIP),A7
	CLR	A6
	MOVX	A9,A6		;GET TOTAL HORIZ SIZE
	ADD	A3,A2		;LC+RC
	SUBXY	A2,A9		;DECREASE H,W BY XCLIP,YCLIP
*
*CLIP THE SAG, HS, VS, AND ADJUST OFFSET
*	
	MOVX	A3,A1		;GET LEFT CLIP
	SEXT	A1,W
	ADD	A1,A4		;ADJUST OXPOS
	SRA	16,A3		;GET TOP CLIP
	ADD	A3,A5		;ADJUST OYPOS
	JREQ	OCLIP1
	ADD	A7,A6		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A6,A3		;TOP CLIP X TOTAL HORIZ SIZE
OCLIP1:
	ADDXY	A2,A7
	ZEXT	A7,W		;NEW OXCLIP
	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	OCLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC
OCLIP2:
	BTST	B_FLIPV,A12
	JREQ	OCLIP3
	NEG	A3		;NEGATE	THS*TC
OCLIP3:
	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET
	PUSHST
	DINT
	MMTM	A0,A9,A11,A12
	MOVE	A4,*A8(OXPOS),W
	MOVE	A5,*A8(OYPOS),W
	MOVE	A7,*A8(OXCLIP),W	;NEW OXCLIP
	POPST
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	RETS
	
**************************************************************************
*                                                                        *
* OBJECT BLOCK INITIALIZATION ROUTINES					 *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* OINIT - INITIALIZE FREE LIST						 *
*                                                                        *
**************************************************************************
OINIT:
	MMTM	SP,A0,A1,A2,A3	;SAVE REG		
	CLR	B13			;CLEAR OUT DMA DEDICATED REGISTERS
	CLR	B14	
	MOVI	NOBJ,A3,W		;# OF OBJECT BLOCKS TO INIT

	MOVI	SCRNST,A0,L	;INIT SCREEN TOP LEFT [Y,X]
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0,L	;INIT SCREEN LOWER RIGHT [Y,X]
	MOVE	A0,@SCRNLR,L

	PUSHST
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0		;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST

	CLR     A0
	MOVE	A0,@SKIPDMA,W
	MOVE	A0,@WORLDTLY,L
	MOVE	A0,@BAK2TLY,L
	MOVE	A0,@WORLDTLX,L
	MOVE	A0,@BAK2TLX,L
	MOVE	A0,@WORLDTL,L
	MOVE	A0,@DMAQCNT,W		;CLEAR CURRENT DMAQ COUNT
        MOVE	A0,@BOTQ0CNT,W		;CLEAR BOTTOM QUEUE COUNT #0
	MOVE	A0,@BOTQ1CNT,W		;CLEAR BOTTOM QUEUE COUNT #1
	MOVE	A0,@TOPQ0CNT,W		;CLEAR TOP QUEUE COUNT #0
	MOVE	A0,@TOPQ1CNT,W		;CLEAR TOP QUEUE COUNT #1

	MOVI	DMAQ+QSIZE,A1
	MOVE	A1,@DMAQCUR,L		;INIT MISC DMA QUEUE
	
	MOVE	A0,@SCROLLX,L	;CLEAR SCROLLX
	MOVE	A0,@SCROLLY,L	;CLEAR SCROLLX

	MOVE	A0,@BAK2LST,L	;NULL BACKGROUND 2 OBJECT LIST
	MOVE	A0,@BAKLST,L	;NULL BACKGROUND OBJECT LIST
	MOVE	A0,@OBJLST,L	;NULL OBJECT LIST
	MOVI	OBJSTR,A1,L
	MOVE	A1,@OFREE,L	;SETUP FREE LIST
oinitl: 
	MOVE	A1,A2
	ADDI	OBSIZ,A1,W
	MOVE	A1,*A2,L		;LINK EM UP
	DSJS	A3,oinitl		;CONTINUE FOR NPROC
    	MOVE	A0,*A2,L		;ZERO LAST LINK
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS

**************************************************************************
*                                                                        *
* GETOBJ - GET A FREE OBJECT BLOCK FOR USE				 *
* RETURNS								 *
* A0 = PTR TO OBJECT BLOCK						 *
* IF NO BLOCKS WERE AVAILABLE THEN THE Z FLAG IS SET			 *
*                                                                        *
**************************************************************************
GETOBJ:
	move  	a2,*-SP,1 
 	MOVE  	@OFREE,A0,L	; pointer to next available obj block
	jreq  	getox
	move  	*A0,A2,L
	move  	A2,@OFREE,L	; adjust pointer to free list
	CLR	A2
	MOVE	A2,*A0(OSHAD),L	;CLEAR SHADOW LINK
	MOVE	A2,*A0(OXCLIP),W	;CLEAR CLIP
	MOVE	A2,*A0(ODMAXY),L	;CLEAR DMA XY POSITION
	MOVE	A2,*A0(OPLINK),L	;CLEAR LINK
	MOVE	A2,*A0(OSLINK),L	;CLEAR SUPPLEMENTAL LINK
	MOVE	A2,*A0(OBLIPIMG),L	;CLEAR SCANNER BLIP STUFF
	MOVE	A2,*A0(OEBLIP),L
	MOVE	A2,*A0(OFLAGS),W
	MOVE	A0,A0		; clear Z flag	
getox:		
	MMFM	SP,A2	  	;DONT SCREW UP Z-FLAG
	rets

**************************************************************************
*                                                                        *
* FREEOBJ - PUT AN OBJECT BLOCK BACK ON THE FREE LIST			 *
* A0 = POINTER TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
*
*FREE OBJECT AND SHADOW OBJECT
*
FREESOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	FREENSHD
	CALLR	FREEOBJ
FREENSHD
	PULL	A0
	JRUC	FREEOBJ
*
*FREE OBJECT WITH ERROR CHECKING
*
FREEOBJE
	MMTM	SP,A1,A2
	CMPI	OBJSTR,A0
	JRHS	FREEE1
	CALLERR	2		        ;PTR TOO LOW
	JRUC	FREERRX
FREEE1
	CMPI	OBJLSTND,A0
	JRLO	FREEE2
      	CALLERR	2			;PTR TOO HIGH
	JRUC	FREERRX
FREEE2
	MOVE	A0,A2
	SUBI	OBJSTR,A2
	MOVI	OBSIZ,A1
	MODU	A1,A2
	JRZ	FREEE3
	CALLERR	2			;PTR NOT VALID
	JRUC	FREERRX	
FREEE3
	CALLR	ISOBJ
	JREQ	FREEE4
	CALLERR	2			;OBJECT IS ON THE ACTIVE LIST
	JRUC	FREERRX
FREEE4
	CALLR	ISFREE
	JREQ	FREEEC
	CALLERR	2			;OBJECT IS ALREADY ON THE FREE LIST
FREERRX
	MMFM	SP,A1,A2		;EXIT WITH ERROR
	RETS
FREEEC
	MMFM	SP,A1,A2		;EVERYTHING IS O.K. CONTINUE TO FREEOBJ
*
*MAIN FREE OBJECT ENTRY
FREEOBJ
	PUSH	A2
	MOVE	@OFREE,A2,L				
	MOVE	A2,*A0,L
	MOVE	A0,@OFREE,L		;BLOCK IS ON FREE LIST NOW
	PULL	A2
	RETS


*
*	INSERT AN OBJECT BLOCK INTO AN OBJECT LIST
*	List is sorted by increasing Z and increasing Y within constant Z
*
*	Block to be inserted in A0
*
*INSERT BACKGROUND 2 OBJECT (SORTED)
INSB2OBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	BAK2LST,a4
	JRUC	INSOBJ0
*INSERT BACKGROUND OBJECT (SORTED)
INSBOBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	BAKLST,a4
	JRUC	INSOBJ0
*INSERT OBJECT AND SHADOW
INSSOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	INSNSHD
       	CALLR	INSOBJ
INSNSHD
	PULL	A0
*INSERT FOREGROUND OBJECT
INSOBJ:
	mmtm 	sp,a1,a2,a3,a4,a5
	movi  	OBJLST,a4
INSOBJ0:
	move 	*A0(OZVAL),A1,L		; GET Z POSITION
	MOVE	*A0(OYVAL),A5,L		; GET Y POSITION
ins_loop:
	move 	a4,a2			; ptr to PREV in a2
	move 	*a2,a4,L		; ptr to NEXT in a4
	jreq 	INS_AT_END		; bra if at end of list
	MOVE 	*A4(OZVAL),A3,L		; ZPOS in A3
	CMP  	A3,A1
	jrgt 	ins_loop
	JRLT	INS_AT_END

	MOVE	*A4(OYVAL),A3,L		;TEST Y POSITION
	CMP	A3,A5
	JRGT	ins_loop
INS_AT_END:
	move 	a4,*a0,L		; put NEXT link in new block
	move 	a0,*a2,L		; put link to new in PREV block
	mmfm 	sp,a1,a2,a3,a4,a5
	rets
*
*	DELETE AN OBJECT BLOCK FROM THE OBJECT LIST
*
*	Block to be deleted in A0
*
*DELETE BACKGROUND OBJECT
DELB2OBJ:
	mmtm	sp,a2,a4
	movi	BAK2LST,a4
	JRUC	del_loop
*DELETE BACKGROUND OBJECT
DELBOBJ:
	mmtm	sp,a2,a4
	movi	BAKLST,a4
	JRUC	del_loop
*DELETE SHADOW
*A0 = PTR TO OBJECT THAT CREATED THE SHADOW
DELSHAD
	MMTM	SP,A0,A1,A2
	MOVE	*A0(OSHAD),A1,L
	JREQ	DELSHADX 		;BR = NO SHADOW EXISTS
	CLR	A2
	MOVE	A2,*A0(OSHAD),L		;NO MORE SHADOW RECOG.
	MOVE	A1,A0
	CALLR	DELOBJ
DELSHADX
	MMFM	SP,A0,A1,A2
	RETS

*DELETE OBJECT WITH SHADOW
DELSOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	DELNSOBJ
	CALLR	DELOBJ
DELNSOBJ
	PULL	A0
*DELETE FOREGROUND OBJECT
DELOBJ:
	MMTM	SP,A0,A2,A3,A4,A8
	MOVI	OBJLST,A4
del_loop:
	move	a4,a2	   	; ptr to PREV in a2
	move	*a2,a4,L   	; ptr to NEXT in a4
	JRNZ	DEL_CHK

	CALLERR	5		;REPORT THE PROBLEM
	JRUC	DELOBJX
***no_del:
***	jreq	no_del	   	; ERROR if at end of list (HANG UP)
DEL_CHK
	cmp	a4,a0
	jrne	del_loop
	
	move	*a0,*a2,L  	; put NEXT link in PREV block
	move	@OFREE,a2,L				
	move	a2,*a0,L
	move	a0,@OFREE,L	; Return deleted block to free stack

	MOVE	*A0(OBLIPIMG),A3,L
	JREQ	DELNOSC			;BR = NO SCANNER BLIP

	MOVE	A0,A8
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRNE	DELSCB1
	MOVE	*A3,A3,L
	JRUC	DELSCB2
DELSCB1
	MOVE	*A3(20H),A3,L
DELSCB2
	CLR	A2			;AND CONSTANT PALETTE
	CLR	A0	    		;JUST ERASE THE OLD BLIP
	MOVE	A0,@PIXQVAL,W
	CALLA	PIXQADD			;CLEAR HIS SCANNER BLIP
	MOVK	1,A0
	MOVE	A0,@PIXQVAL,W
DELNOSC
DELOBJX
	MMFM	SP,A0,A2,A3,A4,A8
	RETS

**************************************************************************
*                                                                        *
* PULLOBJ - PULL AN OBJECT BLOCK FROM AN OBJECT LIST, BUT,		 *
*	    DO NOT PUT IT BACK ON THE FREE LIST				 *
* A0 = PTR TO BLOCK TO BE PULLED					 *
*                                                                        *
**************************************************************************
*PULL FROM THE BACKGROUND
PULLB2OBJ
	MMTM	SP,A2,A4
	MOVI	BAK2LST,A4
	JRUC	PULLLOOP
*PULL FROM THE BACKGROUND
PULLBOBJ
	MMTM	SP,A2,A4
	MOVI	BAKLST,A4
	JRUC	PULLLOOP
*PULL OBJECT AND IT'S SHADOW FROM THE OBJECT LIST
PULLSOBJ
	PUSH	A0
	MOVE	*A0(OSHAD),A0,L
	JREQ	PULLNSHD
	CALLR	PULLOBJ
PULLNSHD
	PULL	A0
*PULL FROM THE OBJECT LIST
PULLOBJ
	MMTM 	SP,A0,A2,A3,A4,A8
	MOVI 	OBJLST,A4
PULLLOOP
	MOVE 	A4,A2			;PTR TO PREVIOUS IN A2
	MOVE 	*A2,A4,L		;PTR TO NEXT IN A4
	JREQ 	NOPULL			;BR = END OF LIST
	CMP  	A4,A0			;IS THIS THE GUY?
	JRNE 	PULLLOOP		;BR = NO
	MOVE 	*A0,*A2,L		;LINK AROUND THIS OBJECT
	MOVE	*A0(OBLIPIMG),A3,L
	JREQ	NOPULL			;BR = NO SCANNER BLIP
	MOVE	A0,A8			;PASS OBLK
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRNE	PULSCB1
	MOVE	*A3,A3,L
	JRUC	PULSCB2
PULSCB1
	MOVE	*A3(20H),A3,L
PULSCB2
	CLR	A2			;AND CONSTANT PALETTE
	CLR	A0			;JUST ERASE OLD BLIP
	MOVE	A0,@PIXQVAL,W
	CALLA	PIXQADD			;CLEAR HIS SCANNER BLIP
	MOVK	1,A0
	MOVE	A0,@PIXQVAL,W
NOPULL
	MMFM 	SP,A0,A2,A3,A4,A8
	RETS

**************************************************************************
*                                                                        *
* KILL A CLASS OF OBJECTS						 *
* A0=OID (16 BITS) ,A1=MASK (16 BITS)					 *
* MASK BITS OF ZERO ARE DONT CARES					 *
*                                                                        *
**************************************************************************
*KILL A CLASS FROM THE BACKGROUND
KILB2OBJ
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	BAK2LST,A2,L
	JRUC	KILGEN
*KILL A CLASS FROM THE BACKGROUND
KILBOBJ
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	BAKLST,A2,L
	JRUC	KILGEN
*KILL A CLASS FROM THE OBJECT LIST
KILOBJ:	
	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	OBJLST,A2,L

KILGEN
	AND	A1,A0		;FORM MATCH

KILOBP:	
	MOVE	A2,A3		;SAVE PREVIOUS
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	KILOBX		;ALL DONE
	MOVE	*A2(OID),A4
	AND	A1,A4		;CAN DONT CARE BITS
	CMP	A0,A4		;MATCH?
	JRNE	KILOBP		;NO

	MOVE	*A2,*A3,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	@OFREE,A5,L	;LINK INTO FREE LIST AT START
	MOVE	A5,*A2,L
	MOVE	A2,@OFREE,L	;POINT FREE TO CELL
	MOVE	A3,A2
	JRUC	KILOBP		;KILL THE REST
KILOBX:	
	MMFM	SP,A0,A2,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* EXISTOBJ - DOES AN OBJECT FROM A CERTAIN CLASS EXIST?			 *
* A0 = OID								 *
* A1 = MASK(0'S DON'T CARE)						 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*                                                                        *
**************************************************************************
EXISTOBJ:	
	MMTM	SP,A2,A3
	MOVI	OBJLST,A2,L
	AND	A1,A0		;FORM MATCH
EXISTOBP:	
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	EXISTOBX	;ALL DONE
	MOVE	*A2(OID),A3
	AND	A1,A3		;CAN DONT CARE BITS
	CMP	A0,A3		;MATCH?
	JRNE	EXISTOBP	;NO
EXISTOBX:
	MOVE	A2,A0
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* ISOBJ - IS AN OBJECT ON THE OBJECT LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*                                                                        *
**************************************************************************
ISOBJ:	
	PUSH	A2
	MOVI	OBJLST,A2,L
	JRUC	ISOBP
**************************************************************************
*                                                                        *
* ISFREE - IS AN OBJECT ON THE FREE LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
* 	Z BIT SET = NO OBJECT, A0 = 0					 *
* 	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*                                                                        *
**************************************************************************
ISFREE:	
	PUSH	A2
	MOVI	OFREE,A2,L
	JRUC	ISOBP
ISOBP:	
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	ISOBX		;ALL DONE
	CMP	A0,A2		;OBJECT?
	JRNE	ISOBP		;NO
	MOVE	A0,A0		;CLR Z BIT
ISOBX:
	PULL	A2
	RETS

*
*MAKE AN OBJECT
*RETURN(S)
*A0 = OBJECT BLOCK PTR
*A14 = POINTS TO THE INITIALIZATION TABLE
*
MAKOBJ	CALLA	GETOBJ
	JRZ	MAKOBX		;NONE LEFT
	CALLR	STFOBJ	
	CALLR	INSOBJ
	MOVE	A0,A0		;RETURN NON-ZERO
MAKOBX	RETS

**************************************************************************
*                                                                        *
* ADJSTWTL - ADJUST THE OBJECT'S COORDINATES IN RELATION TO THE		 *
* 	   WORLD. IT IS ASSUMED THAT THE CURRENT COORDINATES		 *
* 	   ARE SCREEN RELATIVE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
ADJSTWTL
	MMTM	SP,A3,A5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OXVAL),L
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OYVAL),L
	MMFM	SP,A3,A5
	RETS
**************************************************************************
*                                                                        *
* ADJNEWTL - ADJUST AN OBJECT TO A NEW SET OF X,Y WORLD COORDINATES	 *
* 	   BEFORE THEY ARE STORED(TAKE EFFECT).				 *
* NOTE: CURRENT OBJECT COORDS. MUST BE ABSOLUTE WORLD.			 *
* A0 = PTR TO OBJECT							 *
* A4 = NEW WTLX, 32 BITS						 *
* A5 = NEW WTLY, 32 BITS						 *
*                                                                        *
**************************************************************************
ADJNEWTL
	MMTM	SP,A1,A2
	CALLR	GSCRNREL		;SCREEN RELATIVE PLEASE
	ADD	A4,A1
	ADD	A5,A2			;ADJUST
	MOVE	A1,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L		;STORE
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* GSCRNREL - GET THE SCREEN RELATIVE X,Y COORDINATES OF AN OBJECT	 *
* 	   IT IS ASSUMED THATE THE CURRENT X,Y COORDINATES ARE		 *
* 	   WORLD ABSOLUTE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
* RETURNS								 *
* A1 = X SCREEN RELATIVE, 32 BITS					 *
* A2 = Y SCREEN RELATIVE, 32 BITS					 *
*                                                                        *
**************************************************************************
GSCRNREL
	PUSH	A5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A1,L
	SUB	A5,A1
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A2,L
	SUB	A5,A2
	PULL	A5
	RETS

**************************************************************************
*                                                                        *
* SCRNRELV - MAKE THE X & Y VELOCITIES OF AN OBJECT RELATIVE TO THE	 *
* 	   SCREEN. IN OTHER WORDS, ADJUST THEM SO THAT THE CURRENT	 *
* 	   SCROLL RATE DOESN'T AFFECT THEM. 				 *
* A0 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
SCRNRELV
	MMTM	SP,A1,A5
	MOVE	@SCROLLX,A5,L
	MOVE	*A0(OXVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	@SCROLLY,A5,L
	MOVE	*A0(OYVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OYVEL),L
	MMFM	SP,A1,A5
	RETS

**************************************************************************
*                                                                        *
* GANISAG - ADJUST CURRENT OBJECT IMAGE WITH RESPECT TO IT'S		 *
* 	   ANIMATION PNT. AND FLIP FLAGS 				 *
* NOTE: CALL ONLY AFTER INITIALIZING WITH STFOBJ, OR SOMETHING.		 *
* A0 = PTR TO OBJECT BLOCK						 *
* A2 = NEW OYVAL							 *
* A3 = NEW OXVAL							 *
* A4 = NEW FLAGS							 *
* RETURNS								 *
* A2 = ADJUSTED OYVAL							 *
* A3 = ADJUSTED OXVAL							 *
*                                                                        *
**************************************************************************
GANISAG
	MMTM	SP,A1,A4,A6,A7
	MMTM	SP,A2,A3
	MOVE	*A0(OIMG),A1,L
	CALLR	GSAGOF
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	CALLR	GANIOF
	MMFM	SP,A2,A3
	SUB	A6,A3	
	SUB	A7,A2			;ADJUST UPPER LEFT CORNER
	MOVE	A3,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L
	MMFM	SP,A1,A4,A6,A7
	RETS
	
**************************************************************************
*                                                                        *
* STFOBJ - STUFF AN OBJECT USING AN INITIALIZATION TABLE		 *
* A0  = PTR TO THE IMAGE						 *
* A14 = PTR TO INIT. TABLE						 *
* INIT. TABLE:								 *
* 	.LONG	OXVEL,OYVEL,OXVAL,XYVAL					 *
* 	.WORD	OZVEL,OZPOS						 *
* 	.LONG	OIMG,OZSIZ,OCVECT					 *
* 	.WORD	OFLAGS,OID						 *
* 	.LONG	OBLIPIMG						 *
* RETURNS								 *
* A14 = POINTING TO WORD AFTER INIT TAB					 *
*                                                                        *
**************************************************************************
STFOBJ
	MMTM	SP,A1,A2,A3,A4,A6,A7,A9,A10

	MOVE	*A14+,A1,L	;XVEL
	MOVE	A1,*A0(OXVEL),L
	MOVE	*A14+,A1,L	;YVEL
	MOVE	A1,*A0(OYVEL),L

	MOVE	*A14+,A9,L	;XVAL
	MOVE	*A14+,A10,L	;YVAL

	MOVE	*A14+,A1,L	;ZVEL:ZPOS

	CLR	A2		;SPLIT UP OZPOS:OZVEL
	MOVY	A1,A2
	SLL	16,A1
	MOVE	A1,*A0(OZVEL),L
	MOVE	A2,*A0(OZVAL),L

	MOVE	*A14+,A1,L	;IMG
	MOVE	A1,*A0(OIMG),L
	MOVE	*A14+,A2,L	;ZSIZE
	MOVE	A2,*A0(OZSIZ),L
	MOVE	*A14+,A2,L	;CVECT
	MOVE	A2,*A0(OCVECT),L
	MOVE	*A14+,A4,W	;FLAGS
	MOVE	*A14+,A2,W	;OID
	MOVE	A2,*A0(OID),W
	MOVE	*A14+,A2,L	;GET THE SCANNER BLIP IMAGE
	MOVE	A2,*A0(OBLIPIMG),L
	
	MOVE	@CURPAL,A2,W		;OCONST:OPAL
	MOVE	A2,*A0(OPAL),W

	CALLR	GSAGOF
	CALLR	GANIOF		;ADJUST ANIMATION OFFSET
	SUB	A6,A9		;SUBTRACT X ANIOFF
	SUB	A7,A10		;SUBTRACT Y ANIOFF
	MOVE	A9,*A0(OXVAL),L
	MOVE	A10,*A0(OYVAL),L
	MOVE	A1,*A0(OIMG),L
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	MMFM	SP,A1,A2,A3,A4,A6,A7,A9,A10
	RETS
*
*GET SAG FOR OBJECT - ADJUSTS SAG FOR FLIP
*CALLING PARAMETERS:
*A1=PTR TO IMAGE HEADER (OIMG)
*A4=OBJECT FLAGS
*RETURNS:
*A2=RETURNED WITH NEW OSIZE
*A3=RETURNED WITH NEW SAG
*A4=RETURNED WITH NEW OFFSET:OFLAGS
*
GSAGOF:
	MMTM	SP,A5,A6,A7
	ZEXT	A4,W		;ZERO OFFSET IN A4
	MOVE	*A1(ISAG),A3,L	;GET TOP LEFT SAG
	MOVE	*A1(ISIZE),A2,L
	CLR	A5
	MOVX	A2,A5
	ADDK	3,A5		;ADJUST HOR SIZE FOR MORSEL
	SRL	2,A5
	SLL	2,A5
	MOVX	A5,A2
	SLL	3,A5		;ADJUST FOR BYTE ADDRESS

*HORIZONTAL FLIP CASE
GSAGH:
	BTST	B_FLIPH,A4
	JREQ	GSAGV		;NO H FLIP, TRY VERT FLIP
	MOVE	A5,A6
	SUBK	8,A6
	ADD	A6,A3		;ADD THS-1 TO SAG

	MOVX	A2,A6
	SLL	1,A6
	DEC	A6		;2*THS-1 TO OFFSET
	SLL	16,A6		;ADJUST FOR B16-31
	ADDXY	A6,A4
	
*VERTICAL FLIP CASE
GSAGV:
	BTST	B_FLIPV,A4
	JREQ	GSAGX		;NO VERT FLIP 
	MOVY	A2,A6		;GET HEIGHT
	SRL	16,A6
	DEC	A6		;FIRST ENTRY LAST ROW
	MOVE	A5,A7  		;GET THS
	MPYS	A6,A7		;THS*(TVS-1)
	ADD	A7,A3		;ADD TO SAG

	MOVX	A2,A6
	SLL	1,A6
	NEG	A6		;-2*THS
	SLL	16,A6		;ADJUST FOR B16-31
	ADDXY	A6,A4		;ADD TO OFFSET
GSAGX:
	MMFM	SP,A5,A6,A7
	RETS

**************************************************************************
*                                                                        *
* ANI2 - ANI ROUTINE FOR THE 2nd(TOP) PART OF A TWO PART OBJECT.	 *
*	 THIS IS FOR A TWO PART PLAYER ONLY!				 *
* 									 *
* A1 = NEW IMAGE POINTER						 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A4 = NEW FLAGS							 *
* A8 = OBJECT STRUCTURE TO BE UPDATED					 *
* A14 = POINTER TO PART 1'S SHADOW					 *
*                                                                        *
**************************************************************************
ANI2
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	MOVK	1,A11			;FLAG FOR SPECIAL SHADOW ROUTINE
	JRUC	ANIG
**************************************************************************
*                                                                        *
* ANI - ANIMATION SUBROUTINE						 *
* A1=NEW IMAGE POINTER							 *
* A4=NEW OFLAGS								 *
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED				 *
* A11 = SHADOW ROUTINE FLAG. 0 = USE SHADCPY, 1 = USE SHADCPY2		 *
* IF A11 = 1 THEN A14 = PTR TO PART 1'S SHADOW				 *
*                                                                        *
**************************************************************************
*ANI0:				      	;ENTRY FOR NO REPEAT CHECK	     				
*	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
*	CLR	A11
*	MOVE	*A8(OFLAGS),A5,W
*	MOVE	*A8(OIMG),A2,L
*	JRUC	ANIG1
ANI: 
	MMTM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	CLR	A11
ANIG

	MOVE	*A8(OFLAGS),A5,W
	MOVE	*A8(OIMG),A3,L
	CMP	A1,A3
	JRNE	ANIG1		;BR = NOT THE SAME IMAGE AS LAST TIME

	ZEXT	A4
	ZEXT	A5
	CMP	A4,A5
	JREQ	ANIG2		;BR = EVERY THING IS THE SAME
ANIG1
	SWAP	A4,A5
	SWAP	A1,A3
	MOVE	*A8(OSIZE),A2,L
	CALLR	GANIOF		;GET OLD ANIMATION OFFSET
	MMTM	SP,A6,A7
	MOVE	A5,A4		;NEW OFLAGS
	MOVE	A3,A1		;NEW OIMG

	CALLR	GSAGOF		;GET SAG, OFFSET, HW
	CALLR	GANIOF		;GET NEW ANIMATION OFFSET
	MMFM	SP,A0,A5	;BRING BACK OLD ANIMATION DELTA
	SUB	A6,A0		;SUBTRACT NEW FROM OLD
	SUB	A7,A5

	MOVE	A8,A9	   		;GET PUSH ADDRESS OF OFLAGS,OSAG,OSIZE
	ADDI	OFLAGS+>60,A9
	CLR	A7
	MOVE	A7,*A8(OXCLIP),W	;CLEAR PRECLIP
	MMTM	A9,A2,A3,A4		;BLOW THIS STUFF OUT
	MOVE	A1,*A8(OIMG),L

	MOVE	*A8(OYVAL),A6,L
	ADD	A5,A6	       		;ADJUST OYVAL, OXVAL FOR DELTA X
	MOVE	A6,*A8(OYVAL),L
	MOVE	*A8(OXVAL),A7,L
	ADD	A0,A7
	MOVE	A7,*A8(OXVAL),L

	MOVE	*A8(OSHAD),A0,L
	JREQ	ANINSHD			;BR = NO SHADOWS HERE

	MOVE	A11,A11			;CHECK A11
	JREQ	ANISHAD
	CALLR	SHADCPY2		;SHADOW FOR PART 2	
	JRUC	ANINSHD
ANISHAD
	CALLR	SHADCPY			;SHADOW FOR PART 1	 
ANINSHD
ANIGX
	MMFM	SP,A0,A2,A3,A4,A5,A6,A7,A9,A11
	RETS

ANIG2
	MOVE	*A8(OSHAD),A0,L
	JREQ	ANINSHD			;BR = NO SHADOWS HERE

	MOVE	*A8(OZVEL),*A0(OYVEL),L
	MOVE	*A8(OZVEL),*A0(OZVEL),L
	MOVE	*A8(OXVEL),*A0(OXVEL),L	;COPY JUST THE VELOCITIES

	JRUC	ANIGX

**************************************************************************
*                                                                        *
* GETANIXY - GET THE X AND Y POSITIONS OF AN OBJECTS ANIMATION		 *
* 	   POINT.							 *
* A8 = OBLOCK PTR.							 *
* RETURNS								 *
* A2 = APOINT OYVAL, 32 BITS						 *
* A3 = APOINT OXVAL, 32 BITS						 *
*                                                                        *
**************************************************************************
GETANIXY
	MMTM	SP,A1,A4,A6,A7
	MOVE	*A8(OIMG),A1,L
	MOVE	*A8(OSIZE),A2,L
	MOVE	*A8(OFLAGS),A4,W
	CALLR	GANIOF
	MOVE	*A8(OXVAL),A3,L
	MOVE	*A8(OYVAL),A2,L
	ADD	A6,A3
	ADD	A7,A2
	MMFM	SP,A1,A4,A6,A7
	RETS
*
*GET ANIMATION OFFSET
*A1=OIMG, A2=H:W, A4=OFLAGS
*
*OUTPUT: 
*A6=X ANIMATION OFFSET X 64K
*A7=Y ANIMATION OFFSET X 64K
GANIOF:	
	MMTM	SP,A2,A3
	MOVE	*A1(IANIOFF),A6,L		
	CLR	A7		;MAKE SURE A7 IS 0
	MOVY	A6,A7
	SLL	16,A6		;MOVE TO UPPER WORD		
	SUBI	>00010001,A2	;ADJUST FOR -1
	CLR	A3
	MOVY	A2,A3
	SLL	16,A2		;MOVE TO UPPER WORD
	BTST	B_FLIPH,A4
        JRZ	GANI1
	NEG	A6
	ADD	A2,A6		;SUB THS-1 FOR H-FLIP
GANI1:
	BTST	B_FLIPV,A4
	JRZ	GANI2
	NEG	A7
	ADD	A3,A7		;SUB TVS-1 FOR V-FLIP
GANI2:
	MMFM	SP,A2,A3
	RETS

*
*GET NEW DMA Q CALLED FROM DMA INTERRUPT
*
DMANUQ:
	CLR	B13
        MOVE	@TOPQ0FLG,B14,W	
	JREQ	DMANUQ1
	CLR	B14
	MOVE	B14,@TOPQ0FLG,W
	MOVE	@TOPQ0CNT,B13,W
	JREQ	DMANUQ1
	MOVE	B14,@TOPQ0CNT,W
	MOVI	TOPQ0+(QSIZE),B14
	JRUC	DMANUQL
DMANUQ1:
        MOVE	@TOPQ1FLG,B14,W	
	JREQ	DMANUQ2
	CLR	B14
	MOVE	B14,@TOPQ1FLG,W
	MOVE	@TOPQ1CNT,B13,W
	JREQ	DMANUQ2
	MOVE	B14,@TOPQ1CNT,W
	MOVI	TOPQ1+(QSIZE),B14
	JRUC	DMANUQL
DMANUQ2:
        MOVE	@BOTQ0FLG,B14,W	
	JREQ	DMANUQ3
	CLR	B14
	MOVE	B14,@BOTQ0FLG,W
	MOVE	@BOTQ0CNT,B13,W
	JREQ	DMANUQ3
	MOVE	B14,@BOTQ0CNT,W
	MOVI	BOTQ0+(QSIZE),B14
	JRUC	DMANUQL
DMANUQ3:
        MOVE	@BOTQ1FLG,B14 ,W	
	JREQ	DMANUQX
	CLR	B14
	MOVE	B14,@BOTQ1FLG,W
	MOVE	@BOTQ1CNT,B13,W
	JREQ	DMANUQX
	MOVE	B14,@BOTQ1CNT,W
	MOVI	BOTQ1+(QSIZE),B14
DMANUQL:
	SUBI	>A0,B14
	MMFM	B14,B6,B7,B8,B9,B10	;LOAD HER UP
	MOVE	B10,B11
	SRL	16,B10
	RETS
DMANUQX:
	MOVE	@INTENB,B14,W		;DISABLE DMA INTERRUPT
	ANDI	>FFFD,B14
	MOVE	B14,@INTENB,W
	RETS
*
*DO A CPU PIXEL XFER
*
*DMA DONE, MOVE SOME PIXELS MAAHN.
DMAPIXFR
	PUSH	A0
	MOVE	@PIXQVAL,A0,W		;IS THE PIXEL QUEUE HAPPENING?
	JREQ	DMAIPXA0		;NO, GET OUT

	MOVK	1,A0
	MOVE	A0,@SKIPDMA,W
	EINT				;RE-ENABLE INTERRUPTS

DMAIDMAW
	MOVE	@DMACTRL,A0,W
	SEXT	A0			;CHECK DMA STATUS
	JRN	DMAIDMAW		;BR = DMA IS BUSY, SO WAIT

	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	MOVE	@PIXQHEAD,A0,L		;GET THE QUEUE HEAD	
	MOVE	@PIXQTAIL,A1,L		;AND TAIL.
	CMP	A0,A1
	JREQ	DMAIPXC			;BR = QUEUE IS EMPTY!
	MOVI	1000H,A4,W		;THIS IS THE SCREEN OFFSET
DMAIPXN
	MOVE	B13,B13
	JREQ	DMAIPXN1
	MOVE	A0,@PIXQHEAD,L		;RETURN THE QUEUE HEAD	
	MOVE	A1,@PIXQTAIL,L		;AND TAIL.
	DINT				;DISABLE INTERRUPTS TO MATCH
	CLR	A0
	MOVE	A0,@SKIPDMA,W		;DOWN FLAG
DMAPXINT
	MOVE	@INTENB,A0,W
	ORI	>2,A0			;ENABLE THIS INTERRUPT
	MOVE	A0,@INTENB,W
	MOVI	DMAREGS,B12		;MAKE SURE B12 SETUP
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	JRUC	DMAINT			;AND DO THE INTERRUPT
DMAIPXN1
	MOVE	*A0+,A9,W
	MOVE	A9,@CMAPSEL,W		;SELECT THE CORRECT COLOR MAP

	MOVE	*A0+,A8,L		;GET THE IMAGE
	MOVE	*A8+,A5,L		;GET THE [V,H] SIZE		
	CLR	A7
	MOVX	A5,A7			;HORIZONTAL COUNT
	SRL	16,A5			;VERTICAL COUNT

	MOVE	*A0+,A2,L		;GET ERASE [Y,X] ADDRESS
	JRZ	DMAINOE			;BR = NOTHING TO ERASE
	CLR	A3
	MOVX	A2,A3
	SRL	16,A2
	SLL	12,A2
	SLL	3,A3
	OR	A3,A2			;CONVERT [Y,X] TO LINEAR
	MOVE	A5,A9			;USABLE COPY
	CLR	A10
DMAIPXEO
	MOVE	A2,A3
	MOVE	A7,A6			;STORE HOR COUNT
DMAIPXEI
	MOVB	*A3,A11
	JRZ	DMAIPXEN
	MOVB	A10,*A3	
DMAIPXEN
	ADDK	8,A3
	DSJS	A6,DMAIPXEI
	ADD	A4,A2			;ADD OFFSET
	DSJS	A9,DMAIPXEO
DMAINOE
	MOVE	*A0+,A2,L
	JRZ	DMAINOI
	CLR	A3
	MOVX	A2,A3
	SRL	16,A2
	SLL	12,A2
	SLL	3,A3
	OR	A3,A2			;CONVERT [Y,X] TO LINEAR
DMAIPXO
	MOVE	A2,A3
	MOVE	A7,A6			;STORE HOR COUNT
DMAIPXI
	MOVB	*A8,A10
	JRZ	DMAIPXIS		;SKIP THE ZERO PIXEL
	MOVB	*A8,*A3	
DMAIPXIS
	ADDK	8,A3
	ADDK	8,A8
	DSJS	A6,DMAIPXI
	ADD	A4,A2			;ADD OFFSET
	DSJS	A5,DMAIPXO
DMAINOI
	CMP	A0,A1			;QUEUE MT?
	JRNE	DMAIPXN			;NO, DO SOME MORE

	MOVE	A0,@PIXQHEAD,L		;RETURN THE QUEUE HEAD	
	MOVE	A1,@PIXQTAIL,L		;AND TAIL.
DMAIPXC
	DINT
	CLR	A8
	MOVE	A8,@PIXQVAL,W		;MARK THE QUEUE INVALID
	MOVE	A8,@SKIPDMA,W		;AND LET IT ALL HAPPEN
	MOVE	B13,B13
	JRNE	DMAPXINT		;ESCAPE VIA THE INTERRUPT
	MMFM	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
DMAIPXA0
	PULL	A0
	RETI
*
*ENABLE TOP DISPLAY QUEUES
*
DISPQT:
	MOVK	1,A0	     	;ENABLE YOUR QUEUES
	MOVE	@QSYNC,A1,W
	NOT	A1
	MOVE	A1,@QSYNC,W
	JRNE	DISPQT1
	MOVE	A0,@TOPQ1FLG,W
	JRUC	DISPQT2
DISPQT1:	
	MOVE	A0,@TOPQ0FLG,W
DISPQT2:
****>	MOVK	1,A1
****>	MOVE	@DMACTRL,A0,W	;DMA BUSY?
****>	JRN	DISP3		
****>	CLR	A1		;NO OVERLOAD
DISP3:
****>	MOVE	A1,@OVBOT,W	;STORE OVERLOAD 
	CALLR	DMASTRT
	RETS
*
*	DISPLAY OBJECT LIST 
*	CALLED AT MIDSCREEN INTERRUPT		    
*
DISPLAY:
	MOVE	@QSYNC,A1,W
	JRNE	DISP1
	MOVI	BOTQ0+(QSIZE),A4   	;SETUP NEW INTERRUPT LOAD DMA QUEUES
	MOVI	TOPQ0+(QSIZE),A5
	JRUC	DISP2
DISP1:	
	MOVI	BOTQ1+(QSIZE),A4   	;SETUP NEW INTERRUPT LOAD DMA QUEUES
	MOVI	TOPQ1+(QSIZE),A5
DISP2:
	PUSHST
	DINT
	MOVE	@INTENB,A0,W	;ENABLE DISPLAY INTERRUPT
	ORI	DIE,A0
	MOVE	A0,@INTENB,W
	POPST
	MOVE	@DISPLAYON,A0,W
	JREQ	DISPRETS	;BR = STOP ALL NEW DISPLAY PROCESSING

*VELOCITY UPDATE
	MOVI	OXVEL,A1
	MOVI	OBJLST,A0
	CALLR	DVELP	

*CLIP AND LOAD DMA 
*A4=BOTTOM DMA Q TO LOAD
*A5=TOP DMA Q TO LOAD
*B1=HALF SCREEN ADDRESS
*B2=BOTTOM Q COUNT
*B3=TOP Q COUNT
*B4=WORLD TOP LEFT [Y,X]

DCLIP:
****	MOVI	(HSINT-27)*>10000,B1	;GET HALF SCREEN LINE NUMBER(Y ADJUSTED)
	MOVI	(MIDSCRN)*>10000,B1	;GET HALF SCREEN LINE NUMBER(Y ADJUSTED)

	CLR	B3		;TOP Q COUNT
	CLR	B2		;BOTTOM Q COUNT

	MOVE	@SCROLLX,A6,L	; get Y:X scroll values
	MOVE	@SCROLLY,A7,L
	SRA	1,A6
	SRA	1,A7		;SCROLL 1/2 AS FAST
	MOVE	@BAK2TLY,A14,L	;BACKGRD 2 SCREEN TL Y INTEGER:FRACTION
	MOVE	@BAK2TLX,A13,L	;BACKGRD 2 SCREEN TL X INTEGER:FRACTION
	ADD	A7,A14
	MOVE	A14,@BAK2TLY,L
	ADD	A6,A13
	MOVE	A13,@BAK2TLX,L
	SRL	16,A13
	MOVX	A13,A14		;COMBINE TO FORM TOP LEFT Y:X		
	MOVE	A14,B4		;SETUP WORLD TOP LEFT [Y,X]
	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNLR,A13,L

****>	MOVE	@OVTOP,A0,W	;IF OVERLOAD SKIP BAK2 UPDATE
****>	MOVE	@OVBOT,A1,W
****>	OR	A0,A1
****>	JRNE	DCLIP1

	MOVI	BAK2LST,A0,L
	CALLR	NODIS
DCLIP1:
	MOVE	@SCROLLX,A6,L	; get Y:X scroll values
	MOVE	@SCROLLY,A7,L
	MOVE	@WORLDTLY,A14,L	;SCROLL YOUR SCREEN FOLKS
	MOVE	@WORLDTLX,A13,L
	ADD	A6,A13
	ADD	A7,A14
	MOVE	A14,@WORLDTLY,L
	MOVE	A13,@WORLDTLX,L
	SRL	16,A13
	MOVX	A13,A14		;COMBINE TO FORM TOP LEFT Y:X		

	MOVE	A14,B4		;SETUP WORLD TOP LEFT [Y,X]
	MOVE	B4,@WORLDTL,L	;STORE THE WORLD TOP LEFT [Y,X]
	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNLR,A13,L

***********Z PLANE CHECK KLUDGE***********************************	

	MOVE	@PLZMIN,A1,W
	SUBI	10,A1			;FUDGE FACTOR
	MOVE	@OBJLST,A0,L
	JREQ	DISPBAK			;FORGET IT NULL LIST
	MOVE	*A0(OZPOS),A2,W	 	;FIND STUFF IN BACK
	CMP	A1,A2
	JRGE	DISPBAK			;TEST FIRST ONE, NOTHING IN BACK
DZCHL
	MOVE	*A0(OZPOS),A2,W	 	;FIND STUFF IN BACK
	CMP	A1,A2
	JRGE	DZCHK1
	MOVE	*A0,A0,L
	JRNE	DZCHL

	MOVI	OBJLST,A0,L		;EVERYTHINGS IN BACK
	CALLR	NODIS

	MOVI	BAKLST,A0,L		
	CALLR	NODIS
	JRUC	DISPX
	
DZCHK1:	
	MOVE	*A0,A1,L	       
	MMTM	SP,A0,A1		;SAVE OLD LIST POINTERS
	CLR	A1
	MOVE	A1,*A0,L		;ZERO OUT LIST (SPLIT IT UP)
	
	MOVI	OBJLST,A0,L		;OUTPUT BACK OBJECTS
	CALLR	NODIS

	MOVI	BAKLST,A0,L		;OUTPUT BACKGROUND PLANE
	CALLR	NODIS

	MMFM	SP,A0,A1
	MOVE	A1,*A0,L		;RESTORE LIST
	MOVE	A0,A0			
	CALLR	NODIS1			;PROCESS REST OF OBJECT LIST
	JRUC	DISPX
*****************************************************************************
	
DISPBAK:

	MOVI	BAKLST,A0,L
	CALLR	NODIS

	MOVI	OBJLST,A0,L
	CALLR	NODIS

DISPX:
	MOVE	@QDMAFLG,A2	;Q BEING MODIFIED?
	JRNE	DISPX0		;YES, DON'T SCREW WITH IT
	MOVE	@DMAQCUR,A2,L
	MOVI	DMAQ+QSIZE,A1
	CMP	A1,A2
	JREQ	DISPX0		;NONE 
	MOVE	A1,@DMAQCUR,L	;RESET TOP OF QUEUE
DISPXL:
	MOVE	-*A1,-*A5,L	;TRANSFER YOUR Q'S
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	INC	B3		;INCREMENT COUNT
	CMP	A2,A1
	JRHI	DISPXL
DISPX0:

*PUT NULL DMA ON DMA QUEUES	
	MOVI	NULLDMA,A0
	MMFM	A0,A8,A9,A10,A11,A12
	MMTM	A5,A8,A9,A10,A11,A12	;NULL DMA JUNK TOPQ
	MMTM	A4,A8,A9,A10,A11,A12	;NULL DMA JUNK BOTQ

	MOVE	@QSYNC,A0,W
	JRNE	DISPX1
	MOVE	B2,@BOTQ0CNT
	MOVE	B3,@TOPQ0CNT
	RETS
DISPX1:	
	MOVE	B2,@BOTQ1CNT
	MOVE	B3,@TOPQ1CNT
DISPRETS
	RETS			;YIP, SHOVE IT...

*NULL DMA DATA
NULLDMA:	.LONG	>8000,IROM,0,>00010001,0

*
*VELOCITY ADD LOOP
*
DVEL:
***	MOVE	*A0(OFLAGS),A3,W	;CHECK FOR NO VELOCITY BLOCKS
***	BTST	B_NOMOV,A3		
***	JRNE    DVELP			;NO VELOCITY, SKIP IT
DVEL1:
	MOVE	A0,A3
	ADD	A1,A3  			;ADD IN OXVEL
	MMFM	A3,A7,A8,A9,A10,A11,A12

*A12:OXVEL, A11:0YVEL, A10:OXPOS, A9:OYPOS, A8: OZPOS  A7:OZVEL
	ADD	A12,A10		;ADD X VELOCITY TO XVAL
	ADD	A11,A9		;ADD Y VELOCITY TO YVAL
	ADD	A7,A8		;ADD Z VELOCITY TO ZVAL
	SUBK	20H,A3
	MMTM	A3,A8,A9,A10
DVELP:
	move  	*a0,A0,L     	;GET NEXT ONE FOLKS
	JRNE  	DVEL
	RETS
*	.WORD	0,0,0
*
*DMA INTERRUPT
*
	.ALIGN
DMAINT:
	MMTM	B12,B6,B7,B8,B9		;EMPTY HER OUT
	MOVE	B10,-*B12,W
	MOVE	B11,-*B12,W
	MOVI	DMAREGS,B12
	DEC	B13
*	JRN	$			;ERROR, DMA QUEUE UNDERFLOW
	JRN	DMAINT1
	JRNZ	DMAINTX			;BR = MORE LEFT IN THIS QUEUE
DMAINT1:
	CALLR	DMANUQ			;LOOK TO START A NEW Q
	MOVE	B13,B13			;FOUND A NEW ONE?
	JRZ	DMAPIXFR		;NO, THEN LET'ER RIP
	RETI
DMAINTX:
	SUBI	>140,B14		;SETUP Q PULL
	MMFM	B14,B6,B7,B8,B9,B10	;LOAD HER UP
	MOVE	B10,B11
	SRL	16,B10
	RETI

DCLIPL:
	move   	*a0(OXPOS),a10		;
	move	*a0(OYPOS),a2		;
	sll	16,a2
	movy	a2,a10			; Y:X in a10	
	MOVE	A10,*A0(ODMAXY),L	;UPDATED XY POSITION
	MOVE	B4,A6			;SUBTRACT WORLD COORD TO GET SCREEN COORD.
	SUBXY	A6,A10
	MOVE	A0,A3
	ADDI	OFLAGS,A3		;GET PARAMETER LOCATION
	MMFM	A3,A12,A11,A9,A8

*	Check for flipping, necessity of clipping, adjust offset, SAG
*	a0 is the address of the object block
* 	a1 becomes OFFSET
*	A2=AMOUNT TO CLIP OFF BOTTOM, RIGHT	(BC,RC)
* 	A3=AMOUNT TO CLIP OFF TOP, LEFT	(TC,LC)
*	a6=SCREEN TOP LEFT (SCREEN COORDINATES); THEN TOTAL HORIZ. SIZE
*
*	a8 is CONST:PALETTE
*	a9 becomes VS : HS
*	a10 is DAG (Y : X)
*	a11 is the SAG
*	a12 is the control word b0-15; offset b16-31
*	a13 is the window BOTTOM RT
*	a14 is the window TOP LEFT
*
*  COMPUTE LC, RC, TC, BC	
*
	clr	a6		; UPPER LEFT SCREEN COORDINATES
	clr	a1     		; use for clearing now, becomes offset later
	move	a10,a2 		; PT in a2
	addxy	a9,a2 		; lower right in a2
	subxy	a13,a2		; PT - WEND -> a2  ( BC : RC )
	JRYGE	dis_clp0
	movy    a1,a2  		; clear BC if y negative
dis_clp0:	
	JRXGE	dis_clp1
	movx   	a1,a2  		; clear RC if x negative	
dis_clp1:
	move   	a14,a7 		; move WSTART
	clr    	a3				;
	subxy	a10,a7	    	; WSTART - PT -> a7 (TC : LC)
	JRYLT  	dis_clp2
	movy   	a7,a3	    	; TC in upper half of a3
	movy   	A14,a10	    	; adjust start position to window edge
dis_clp2:
	JRXLT  	dis_clp3
	movx   	a7,a3	    	; LC in lower half of a3
	movx   	A14,a10	    	; adjust start position to window edge
dis_clp3:
	movx	a9,a6		;GET TOTAL HORIZONTAL SIZE (MORSEL CORRECTED)
	add	a3,a2	    	; (TC+BC : LC+RC) in a2
	JREQ	NOCLIP		; TOTAL CLIP IS ZERO, NOCLIP
	SUBXY	A2,A9	    	; GET CLIPPED SIZE...TOTALLY CLIPPED?
	JRXLE	NODIS	 	; yes, don't display it
	JRYLE	NODIS		

*
*CLIP THE SAG, HS, VS, AND ADJUST OFFSET
*	
	MOVX	A3,A1		;GET LEFT CLIP
	SRL	16,A3		;GET TOP CLIP
	JREQ	CLIP1
	MOVE	*A0(OXCLIP),A7
	ADD	A6,A7		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A7,A3		;TOP CLIP X TOTAL HORIZ SIZE
CLIP1:
	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	CLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC
CLIP2:
	BTST	B_FLIPV,A12
	JREQ	CLIP3
	NEG	A3		;NEGATE	THS*TC
CLIP3:
	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET
NOCLIP:
*
*BEAM AVOIDANCE, AT HALF SCREEN, DMA TOP HALF
*		 AT FULL SCREEN, DMA BOTTOM HALF
*
*B1 = HALF SCREEN LINE COUNT
*B2=BOTTOM Q COUNT
*B3=TOP Q COUNT
*A4=BOTTOM DMA Q TO LOAD
*A5=TOP DMA Q TO LOAD
*A8 = CONST:PALETTE XLATE
*A9 = VSIZE:HSIZE
*A10 = DESTINATION Y:X
*A11 = IMAGE SAG
*A12 = OFFSET:CONTROL
	
	MOVE	B1,A2	       	;GET HALF SCREEN LINE NUMBER(Y ADJUSTED)
	CMPXY	A10,A2		;WHERE'S THE IMAGE?
	JRYLE	BEAM_STKIMG	;BR = ON THE OTHER SIDE, TOTALLY, STACK IT

	SUBXY	A10,A2		;DETERMINE HEIGHT ABOVE MID SCREEN
	CMPXY	A2,A9		;TOTALLY ABOVE?
	JRYLE	BEAM_DODMA	;BR = YES, DMA AS IS

	MOVE	A9,B0		;SAVE THE SIZES

	MOVY	A2,A9		;STUFF NEW VSIZE AND DO IT
*STACK THE SUCKER
*B1 = HALF SCREEN LINE COUNT
*B2= BOTTOM Q COUNT
*B3= TOP Q COUNT
*A4= BOTTOM DMA Q TO LOAD
*A5= TOP DMA Q TO LOAD
*A6= TOTAL HORIZONTAL SIZE
*A8 = CONST:PALETTE XLATE
*A9 = VSIZE:HSIZE
*A10 = DESTINATION Y:X
*A11 = IMAGE SAG
*A12 = OFFSET:CONTROL

	MMTM	A5,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B3

*SET UP DMA REGS FOR BOTTOM HALF AND STACK THEM

	MOVE	B0,A9
	SRL	16,A2		;SLIDE DOWN THE Y DIFFERENTIAL
	MOVE	*A0(OXCLIP),A3	;ADD PRECLIP TO WIDTH
	ADD	A6,A3		;WE NEED TS IN AN ODD REG. FOR 32 BIT MULT.

	SLL	3,A3		;TS = TS*8
	MPYU	A2,A3		;A3 = SAG OFFSET
	
	SLL	16,A2		;Y DIFF BACK TO Y POS
	SUBXY	A2,A9		;NEW VSIZE

	ADDXY	A2,A10		;NEW DMA POSITION

	BTST	B_FLIPV,A12
	JREQ	BEAM_ADDSAG	;BR = SUBTRACT FOR NEW SAG BECAUSE OF VFLIP

	NEG	A3		;SAG = -SAG

BEAM_ADDSAG:
	ADD	A3,A11		;SAG = SAG + OFFSET

BEAM_STKIMG:
	MMTM	A4,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B2
      	JRUC	NODIS
*STACK THE SUCKER
*B1 = HALF SCREEN LINE COUNT
*B2=BOTTOM Q COUNT
*B3=TOP Q COUNT
*A4=BOTTOM DMA Q TO LOAD
*A5=TOP DMA Q TO LOAD
*A8 = CONST:PALETTE XLATE
*A9 = VSIZE:HSIZE
*A10 = DESTINATION Y:X
*A11 = IMAGE SAG
*A12 = OFFSET:CONTROL
BEAM_DODMA:
	MMTM	A5,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B3
NODIS:
	MOVE	*A0,A0,L	;GET NEXT LINK
NODIS1:
	JRNE	DCLIPL		;DONE?
	RETS

	
*
*PRIME DMA INTERRUPT FOR BOTTOM QUEUE
*
DISPH:
	MOVK	1,A0	     	;ENABLE YOUR QUEUES
	MOVE	@QSYNC,A1,W
	JRNE	DISPH1
	MOVE	A0,@BOTQ1FLG,W
	JRUC	DISPH2
DISPH1:	
	MOVE	A0,@BOTQ0FLG,W
DISPH2:
****>	NOP
****>	MOVK	1,A1
****>	MOVE	@DMACTRL,A0,W	;DMA BUSY?
****>	JRN	DISPH3		;YES, DO NOT RESTART
****>	CLR	A1
DISPH3:
****>	MOVE	A1,@OVTOP,W	;OVERLOAD INDICATOR
	CALLR	DMASTRT		;START DMA IF APPROPRIATE
	RETS
*
*START DMA IF APPROPRIATE
*
DMASTRT:
	PUSHST
	DINT
	MOVE	B13,B13
	JRNE	DMASTRTX 	;IF COUNT > 0, DMA ALREADY GOING
	CALLR	DMANUQ		;GET NEW Q
	MOVE	B13,B13
	JREQ	DMASTRTX	;ZERO COUNT DONT RESTART
	MOVE	@SKIPDMA,A0,W
	JRNZ	DMASTRTX	;BR = DMA BLOCKED	
	MOVE	@INTENB,A0,W 	;ENABLE DMA INTERRUPT
	ORI	>2,A0
	MOVE	A0,@INTENB,W
	MOVE	@DMACTRL,A0,W	;DMA BUSY?
	JRN	DMASTRTX	;YES, DO NOT RESTART
	MOVI	DMAREGS,B12	;MAKE SURE B12 SETUP
	CLR	A0
	MOVE	A0,@DMACTRL,W	;KILL ANY PENDING
	TRAP	1
DMASTRTX:
	POPST
	RETS
*
*QDMA PUTS IMAGE ON DMA Q
*INPUTS:
*A1: CONSTANT COLOR:PALETTE
*A3: DESTINATION Y:X
*A5: OFFSET:CONTROL
*A14: ADDRESS OF IMAGE HEADER
*GETS: A2=H/W; A4=SAG
QDMA:
	MMTM	SP,A2,A4,A13
	MOVE	*A14,A2,L		;GET VSIZE:HSIZE
	MOVE	*A14(ISAG),A4,L		;GET SAG
QDMA1:
	MOVK	1,A13
	MOVE	A13,@QDMAFLG,W		;Q BEING MODIFIED
	MOVE	@DMAQCUR,A13,L
	CMPI	DMAQ,A13
	JRLS	QDMAX			;Q OVERLOAD, CAN IT
	MMTM	A13,A1,A2,A3,A4,A5
	MOVE	A13,@DMAQCUR,L
	CLR	A13
	MOVE	A13,@QDMAFLG,W
QDMAX:
	MMFM	SP,A2,A4,A13
	RETS
*MANUAL DMA (SETUP YOUR OWN REGS)
*INPUTS:
*A1: CONSTANT COLOR:PALETTE
*A2: VSIZE:HSIZE
*A3: DESTINATION Y:X
*A4: SAG
*A5: OFFSET:CONTROL
QDMAN:
	MMTM	SP,A2,A4,A13
	JRUC	QDMA1
*
*DMA INTERRUPT VECTOR
*
***	.SECT	"INT1V"
***	.LONG	DMAINT

	.END

