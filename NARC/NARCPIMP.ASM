 	.FILE	'NARCPIMP.ASM'
	.TITLE	" <<< N  A  R  C  -- P I M P >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\mprocEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCTEQU.ASM"
****	.INCLUDE	"imgtbl.glo"
	.INCLUDE	"NARCFRAG.GLO"

	.globl	PIMPpal,NARCS
	.globl	PIMPCRM1
*
*EXTERNALS
	.GLOBAL	LOFDEXP,LOFDEXP1,LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,LOFDFLA
	.GLOBAL	LOFDROCK,LDEXP1

	.include	"narcpimp.tbl"

BUCKHGHT	.set	5	;add to Zdest when chasing bucks

********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in GVARINIT
;	.BSS	pimpmax,16,16		;U - max # of active pimpmen
;	.BSS	pimpbuck,16,16		;U - chance/1000 of pimpman having money
;	.BSS	pimpbrain,16,16 	;U - tiks between brain funcs
	 	;U - chance/1000 of pimp throwing every brain cycle when walking
;	.BSS	pimpthr1,16,16
	 	;U - chance/1000 of pimp throwing every brain cycle when hiding
;	.BSS	pimpthr2,16,16
	 	;U - each throw chance/1000 of pimp throwing a fast ball
;	.BSS	pimpfbal,16,16

	.TEXT
VARINIT:
	rets		   ;* <---------------------- remove ;
	movi	12,A1
	movb	A1,@pimpbrain
	movi	90,A1
	movb	A1,@pimpthr1
	movi	90,A1
	movb	A1,@pimpthr2
	movi	350,A1
	movb	A1,@pimpfbal
	movi	5,A1
	move	A1,@pimpmax,W
	movi	350,A1
	move	A1,@pimpbuck,W
	rets
**********************************************************

***************************************************************************
; PIMP SUB_TYPES
; 0 - w/ no coors starts at PLZMIN and 1 to 2 full screens away from
;	players in X.  90% chance of coming up to the right.
; 1 - w/ no coors comes out any available door, else it reverts to type 0
DTBL:
	.long	D0,D1
	.long	D1,D1,D1,D1,D1,D1,D1
	.long	D1,D1,D1,D1,D1,D1,D1
***************************************************************************


************************* FUNCTION TABLE ***************************
PIMP_FUNCS:
	.long	BOOF
	.long	GoDestV
	.long	GetXVel
	.long	>C000	;MaxXZAngle
	.long	25	;FlipTiks
********************************************************************

********************************************************************
;To catch a nulled dereference through JR_FUNCS
BOOF:	jruc	$
********************************************************************

**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
PIMPINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	prun1t,PIMPZSIZ,PIMPCOLL
	.WORD	DMAWNZ,PIMPEOID
	.LONG	PIMPBLIP
**************************************************************************

**************************************************************************
PIMPCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT
	
	move	@SLPPIMPS,A0,W
	cmpi	5,A0
	jrge	ColdX
	
	move	A5,A9		;Y:X in A9
	move	A6,A10		;0:Z in A10
	move	A14,A11		;ID in A11

	move	A14,A0
	sll	12,A0
	srl	28,A0
	jrz	SkRndCnt
	calla	RANDU
SkRndCnt:
	move	A14,A2
	sll	8,A2
	srl	28,A2
	add	A0,A2
ColdLp:	
	CREATE	PIMPEPID,PIMP	;allocate process?	(bashes A1,A7)
	jrz	ColdX
	dsjs	A2,ColdLp
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

*********************  START OF PIMP PROCESS  ****************************
PIMP:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

	INCW	@SLPPIMPS
MaxWait:
	move	@pimpmax,A0,W
	move	@PIMPCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	DECW	@SLPPIMPS
	INCW	@PIMPCNT

	move	A11,A0
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	DTBL,A0
	move	*A0,A0,L
	jump	A0


**************************************************************************
D1:
;DISPATCH FROM A DOOR	
	move	A9,A0
	or	A10,A0
	jrnz	GotCoors

	movi	5,A0
DoorWait:
	calla	GETDOOR
	jrnz	GotDoor
	PUSHP	A0
	movi	60,A0
	calla	RANDU
	calla	PRCSLP
	PULLP	A0
	dec	A0
	jrp	DoorWait
	jruc	D0
GotDoor:
	JSRP	DOOROPEN		;OPEN SEZ-A-ME
	CREATE 	INDPID,CLOZDOOR		;CLOSE THE DOOR
	movi	PIMPINIT,A14
	calla	DOORRITE	;rets upper Y,X start pos in A1
	movi	PIMPTAB,A6
	mmtm	SP,A11
	calla	ESINITUL	;CREATE PIMP
	mmfm	SP,A11
	jrz	PIMP_DIE	;create failed

	move	A11,*A8(OID),W
	movi	->10000,A2	;X VELOCITY
	movi	WALKOUT,A9     	;GET ANIMATION SCRIPT
	JSRP	OUTDOOR
	jruc	InitEnmy


**************************************************************************
D0:	
	move	A9,A0
	or	A10,A0
	jrnz	GotCoors

*Enemy object initialization
	move	@(WORLDTLX+16),A9,W				 
	subi	250,A9
	movi	950,A0
	calla	RANDPER
	jrnc	StrtLft
	addi	1012,A9
StrtLft:
	movi	15,A0
	calla	SRAND
	add	A0,A9
	move	@PLZMIN,A10,W									 
	movi	35,A0
	calla	RANDU
	add	A0,A10

GotCoors:
	move	A9,A1
	movi	PIMPTAB,A6
	movi	PIMPINIT,A14	
	mmtm	SP,A9,A10,A11
	calla	ESINITLL		;CREATE PIMP
	mmfm	SP,A9,A10,A11
	jrz	PIMP_DIE
;Y:X in A9
;0:Z in A10
	move	A10,A10
	jrnz	GotZC
	movy	A9,A10
	srl	16,A10
	subi	ZORIGIN,A10
GotZC:
	move	A9,*A8(OXPOS),W
	move	A10,*A8(OZPOS),W
	addi	ZORIGIN,A10
	move	*A8(OSIZEY),A0,W
	sub	A0,A10
	move	A10,*A8(OYPOS),W
	move	A11,*A8(OID),W
;	jruc	InitEnmy


****************************************************************************
InitEnmy:
	calla	ClrVel

	clr	A0
	move	A0,*A13(DEST),L
	move	A0,*A13(TEMPDEST),L
	movb	A0,*A13(DEST_TAG)
;	movb	A0,*A13(ZPER)
	movb	A0,*A13(SNOOZE)
	movb	A0,*A13(FLIPTIKS)
	move	A0,*A13(WANTOBJ),L
	move	A0,*A13(TIKCTRS),L
	move	A0,*A13(EBYTES),L
	movi	PIMP_FUNCS,A0
	move	A0,*A13(FUNCS),L

	clr	A1
BckLp:
	move	@pimpbuck,A0,W
	calla	RANDPER
	jrnc	BckX
	inc	A1
	cmpi	5,A1
	jrlt	BckLp
BckX:
	move	A1,A0
	jrz	NoBck
	calla	ADDBUCKS
NoBck:
	move	A8,A0
	calla	SETZPOS
	callr	ZFIX
	jruc	PIMP_MV
****************************************************************************

****************************************************************************
ZFIX:
	move	*A8(OZPOS),A0,W
	subi	3,A0
	move	A0,*A8(OZPOS),W
	rets
****************************************************************************

**************************************************************************
ZCHECK:
	move	*A8(OZPOS),A1,W
	move	@PLZMIN,A0,W
	addk	5,A0
	sub	A0,A1
	jrnn	ZMinOK
	move	A0,*A8(OZPOS),W
	move	*A8(OYPOS),A0,W
	sub	A1,A0
	move	A0,*A8(OYPOS),W
	move	*A8(OZVEL),A0,L	;* want to check sign
	jrnn	ZMaxOK
	jruc	SETZV
ZMinOK:
	move	*A8(OZPOS),A1,W
	move	@PLZMAX,A0,W
	subk	3,A0
	sub	A0,A1
	jrn	ZMaxOK
	move	A0,*A8(OZPOS),W
	move	*A8(OYPOS),A0,W
	sub	A1,A0
	move	A0,*A8(OYPOS),W
	move	*A8(OZVEL),A0,L	;* want to check sign
	jrn	ZMaxOK
	jrz	ZMaxOK
SETZV:
	move	*A8(OYVEL),A1,L
	sub	A0,A1
	move	A1,*A8(OYVEL),L
	clr	A0
	move	A0,*A8(OZVEL),L	;set Z velocity
ZMaxOK:
	rets
**************************************************************************


**************************** GetXVel *************************************
GetXVel:
	cmpi	MOVETBL,A9
	jrlt	NoXvel
	cmpi	MOVEEND,A9
	jrge	NoXvel

	cmpi	PWX,A9
	jrgt	NotWk
	movi	WALKVEL+>1000,A0
	jruc	GotXvel
NotWk:
	cmpi	PMWKX,A9
	jrgt	NotMwk
	movi	MWALKVEL->1000,A0
	jruc	GotXvel
NotMwk:
	movi	RUNVEL+>1000,A0
	jruc	GotXvel
NoXvel:
	clr	A0
GotXvel:
	rets
**************************************************************************

*****************************  GO WALK  ************************************
GoWalk:
	mmtm	SP,A0
	cmpi	PW,A9
	jrlt	DoWlk
	cmpi	PWX,A9
	jrge	DoWlk

	jruc	GoWalkX
DoWlk:
	clr	A0
	movb	A0,*A13(HIDING)
	movi	PW,A9
	move	A9,*A13(ANIMPTR),L

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos0
	movi	-WALKVEL,A0
	jruc	SetXV0
VelPos0:
	movi	WALKVEL,A0
SetXV0:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV
	
GoWalkX:
	mmfm	SP,A0
	rets
****************************************************************************

**************************  GO MOON WALK  **********************************
GoMWalk:
	mmtm	SP,A0
	cmpi	PMWK,A9
	jrlt	DoMWlk
	cmpi	PMWKX,A9
	jrge	DoMWlk

	jruc	GoMWalkX
DoMWlk:
	clr	A0
	movb	A0,*A13(HIDING)
	movi	PMWK,A9
	move	A9,*A13(ANIMPTR),L

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos1
	movi	-MWALKVEL,A0
	jruc	SetXV1
VelPos1:
	movi	MWALKVEL,A0
SetXV1:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV
	
GoMWalkX:
	mmfm	SP,A0
	rets
****************************************************************************

******************************  GO RUN  ************************************
GoRun:
	mmtm	SP,A0
	cmpi	PRUN,A9
	jrlt	DoRun
	cmpi	PRUNX,A9
	jrge	DoRun

	jruc	GoRunX
DoRun:
	clr	A0
	movb	A0,*A13(HIDING)
	movi	PRUN,A9
	move	A9,*A13(ANIMPTR),L

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos2
	movi	-RUNVEL,A0
	jruc	SetXV2
VelPos2:
	movi	RUNVEL,A0
SetXV2:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV
	
GoRunX:
	mmfm	SP,A0
	rets
****************************************************************************

****************************  Is MoonWalk?  ********************************
IsMwk:
;* is PIMP Moon Walking?
	cmpi	PMWK,A9
	jrlt	NoMwk
	cmpi	PMWKX,A9
	jrgt	NoMwk
YesMwk:
	setc
	rets
NoMwk:
	clrc
	rets
****************************************************************************

****************************************************************************
TRYBUST:
	movb	*A13(SNOOZE),A0
	jrnz	NOBUST
	movb	*A13(BUSTTIKS),A0
	jrnz	NOBUST
	calla	CKBUST
	jrnc	NOBUST
	movi	60,A0
	movb	A0,*A13(BUSTTIKS)
	calla	ClrVel
	movi	20,A2
	movi	PIMPBUST,A9
	jsrp	GBUST
	jrc	BUSTED
Foolem:
	cmpi	PCUFF,A9
	jrge	EscBst
	clr	A1			;* one frame w/ sleepin
	jsrp	FRANIM
	jruc	Foolem
EscBst:
	clr	A0													
	movb	A0,*A13(BRAINTIKS)
	movb	A0,*A13(DEST_TAG)
	setc
	retp
NOBUST:
	clrc
	retp
**************************************************************************


**************************************************************************
CkXDIST:
	move	@(WORLDTLX+16),A1,W
	addi	256,A1
	calla	GETANIX
	sub	A1,A0
	cmpi	600,A0
	jrgt	DeepRght
	cmpi	300,A0
	jrgt	NearRght
	cmpi	-600,A0
	jrlt	DeepLeft
	cmpi	-300,A0
	jrlt	NearLeft

	;* on screen
	clr	A0
	movb	A0,*A13(SNOOZE)
	jruc	CkXDISTX

DeepLeft:
	jsrp	CkQuit
	movb	*A13(SNOOZE),A0
	jrnz	CkXDISTX
	movk	1,A0
	movb	A0,*A13(SNOOZE)
	clr	A0
	movb	A0,*A13(HIDING)
	jruc	CkXDISTX
DeepRght:
	movb	*A13(SNOOZE),A0
	jrnz	CkXDISTX
	movk	1,A0
	movb	A0,*A13(SNOOZE)
	jruc	CkXDISTX
NearRght:
	clr	A0
	movb	A0,*A13(SNOOZE)
	jruc	CkXDISTX
NearLeft:
	clr	A0
	movb	A0,*A13(SNOOZE)
;	jruc	CkXDISTX
CkXDISTX:
	RETP
**************************************************************************

**************************************************************************
CkQuit:
	move	@SLPPIMPS,A0,W
	jrz	CkQuitX
	jruc	PIMP_DONE
CkQuitX:
	RETP
**************************************************************************

****************************  PIMP MOVE  ***********************************
PIMP_MV:
	callr	ZCHECK
	movb	*A13(HIDING),A0
	jrz	SkCkHidd
	callr	P_HIDDEN	;is pimp hidden
	jrc	SkCkDest
SkCkHidd:

;********  CHECK if a DESTINATION has been reached, and what to do if so..
	movb	*A13(DEST_TAG),A0
	jrz	SkCkDest
	movb	*A13(DESTTIKS),A0
	jrnz	SkCkDest
	calla	CkDest
	jrnc	NotYet

	;* we have reached our destination, what to do??
	movb	*A13(DEST_TAG),A0
	cmpi	BULL_T,A0
	jrnz	SkBULL_D
	jruc	DestDone
SkBULL_D:
	cmpi	BUST_T,A0
	jrnz	SkBUST_D
	jruc	DestDone
SkBUST_D:
	cmpi	ESCAPE_T,A0
	jrnz	SkESC_D
	jsrp	AtEscape
	jruc	DestDone
SkESC_D:
	cmpi	CHASE_T,A0
	jrnz	SkCHS_D
	jruc	DestDone
SkCHS_D:
	cmpi	BUCK_T,A0
	jrnz	SkBUCK_D
	jsrp	GrabBuck
	jruc	DestDone
SkBUCK_D:
	cmpi	HIDE_T,A0
	jrnz	SkHIDE_D
	callr	AtHide
	jruc	DestDone
SkHIDE_D:
	cmpi	DFLT_T,A0
	jrnz	SkDFLT_D
	callr	AtDflt
	jruc	DestDone
SkDFLT_D:

	jruc	SkCkDest
DestDone:
	clr	A0
	movb	A0,*A13(BRAINTIKS)	;Allow new course of action
	movb	A0,*A13(DEST_TAG)
NotYet:
SkCkDest:

**** BRAIN functions *****
	movb	*A13(BRAINTIKS),A0
	jrnz	BrainX

	jsrp	TRYBUST
	jrc	PIMP_MV

	movk	15,A0
	movb	*A13(SNOOZE),A1
	jrnz	SetBTiks
	move	@pimpbrain,A0,W
SetBTiks:
	movb	A0,*A13(BRAINTIKS)	;reset brain wait

	jsrp	CkXDIST			;routine can DIE

	movb	*A13(SNOOZE),A1
	jrnz	BSnooze
	jsrp	Pfire

	movb	*A13(DEST_TAG),A0
	cmpi	BULL_T,A0
	jrge	BrainX
	jsrp	CkDngr

	movb	*A13(DEST_TAG),A0
	cmpi	BUST_T,A0
	jrge	BrainX
	jsrp	CkEvade
BSnooze:

;	movb	*A13(DEST_TAG),A0
;	cmpi	ESCAPE_T,A0
;	jrge	BrainX
;	callr	CkEscape

	movb	*A13(DEST_TAG),A0
	cmpi	CHASE_T,A0
	jrge	BrainX
	callr	Chase

	movb	*A13(HIDING),A0
	jrnz	BrainX

	movb	*A13(DEST_TAG),A0
	cmpi	BUCK_T,A0
	jrge	BrainX
	callr	CkBuck

	movb	*A13(DEST_TAG),A0
	cmpi	HIDE_T,A0
	jrge	BrainX
	callr	CkHide

	movb	*A13(DEST_TAG),A0
	cmpi	DFLT_T,A0
	jrge	BrainX
	callr	DfltDest
BrainX:


**** Animation check ****
	movb	*A13(SNOOZE),A0
	jrnz	AnimX
	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX

	movb	*A13(HIDING),A0
	jrz	NotHidin
	;* Do hiding specific stuff.
	jruc	Animate

NotHidin:
;	movb	*A13(DEST_TAG),A0
;	cmpi	BUST_T,A0
;	jreq	SkDestOk
;	cmpi	BUCK_T,A0
;	jreq	SkDestOk
;	calla	DestOk
;	jrc	PIMP_MV
SkDestOk:

;	calla	ZOFF

Animate:
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrnz	ListLeft
	callr	AnimCycle
ListLeft:
	movb	A0,*A13(ANIMTIKS)
AnimX:


**** Find Next Event ****
	movb	*A13(BRAINTIKS),A0
	jrp	SkBrain1
	movk	1,A0
SkBrain1:
	move	A0,A5			;current min
	
	movb	*A13(DEST_TAG),A1
	jrz	SkMin1
	movb	*A13(DESTTIKS),A1
	sll	24,A1
	srl	24,A1
	jrnz	SkDest1
	movk	1,A1
SkDest1:
	cmp	A5,A1
	jrge	SkMin1
	move	A1,A5
SkMin1:

	;**** The following are only done when not snoozing
	movb	*A13(SNOOZE),A7
	jrnz	GotMin

	movb	*A13(ANIMTIKS),A2
	cmp	A5,A2
	jrge	SkMin2
	move	A2,A5
SkMin2:

GotMin:
	sub	A5,A0
	movb	A0,*A13(BRAINTIKS)
	move	A1,A1
	jrz	SkDestDc
	sub	A5,A1
	movb	A1,*A13(DESTTIKS)
SkDestDc:
	move	A7,A7	;ck snooze
	jrnz	MoveSlp
	sub	A5,A2
	movb	A2,*A13(ANIMTIKS)

	movb	*A13(BUSTTIKS),A1
	jrz	SkBustDc
	andi	>FF,A1	;No o' this sign extended byte shit
	cmp	A5,A1
	jrge	SkClrBst
	move	A5,A1
SkClrBst:
	sub	A5,A1
	movb	A1,*A13(BUSTTIKS)
SkBustDc:

MoveSlp:
	movb	*A13(FLIPTIKS),A1
	jrz	SkFlipDc
	andi	>FF,A1	;No o' this sign extended byte shit
	cmp	A5,A1
	jrge	SkClrFlp
	move	A5,A1
SkClrFlp:
	sub	A5,A1
	movb	A1,*A13(FLIPTIKS)
SkFlipDc:

	move	A5,A0
	jrp	Slp
	movk	2,A0		;in case of something fucked
Slp:
	calla	PRCSLP
	jruc	PIMP_MV
****************************************************************************

******************************  CHASE  *************************************
Chase:
	movb	*A13(HIDING),A0
	jrnz	ChaseX
	movb	*A13(DEST_TAG),A0
	cmpi	HIDE_T,A0
	jreq	ChaseX

	movi	>FFFF,A1		;A1 will be X coor of leftmost player.
	move	A1,A2			;A2 will be Z coor of leftmost player.
	movi	>7FFF,A3		;A3 is X coor of rghtmost player
	move	A3,A4			;A4 is Z coor of rghtmost player
	clr	A6			;A6 velocity of leftmost pl
	clr	A7			;A7 velocity of rghtmost pl

	move	A8,A10

	movi	P1DATA,A5
	move	*A5(POBJ),A5,L
	jrz	SkChseP1
	move	A5,A8
	calla	GETANIX
	move	A0,A1			;A1 xpos
	move	*A5(OZPOS),A2,W
	move	*A5(OXVEL+16),A6,W
	move	A1,A3
	move	A2,A4
	move	A6,A7
SkChseP1:
	movi	P2DATA,A5
	move	*A5(POBJ),A5,L
	jrz	GotPs
	move	A5,A8
	calla	GETANIX
	cmp	A1,A0
	jrgt	SkP2Lft
;* P2 is on Left
	move	A0,A1
	move	*A5(OZPOS),A2,W
	move	*A5(OXVEL+16),A6,W
SkP2Lft:
	cmp	A3,A0
	jrlt	GotPs
	move	A0,A3
	move	*A5(OZPOS),A4,W
	move	*A5(OXVEL+16),A7,W

GotPs:
	move	A10,A8
	calla	GETANIX
	;* check if we can chase leftmost player
	move	A6,A6
	jrz	TryCRgt
	jrn	TryCRgt
	subi	100,A1
	cmp	A1,A0
	jrge	TryCRgt
	addi	20,A1
	jruc	DoChase
	
TryCRgt:
	;* check if we can chase rgtmost player
	move	A7,A7
	jrnn	ChaseX
	addi	150,A3
	cmp	A3,A0
	jrle	ChaseX
	subi	30,A3
	move	A3,A1
	move	A4,A2

DoChase:
	callr	GoRun
	;Generate new DEST
	movk	30,A0
	calla	RANDU
	subk	15,A0
	add	A0,A2
	sll	16,A2
	movx	A1,A2
	move	A2,*A13(DEST),L
	calla	ClipZDst
	calla	GoDestV

	movk	CHASE_T,A0
	movb	A0,*A13(DEST_TAG)
ChaseX:
	rets
****************************************************************************

*************************  Sleep It Off  ***********************************
SlpItOff:
; Finish off sleep for current animation frame to eliminate the flashes..
; Puts sleep time in A0, caller must call PRCSLP
	movi	>FF,A7
	movb	*A13(ANIMTIKS),A0
	and	A7,A0
	jrnz	SkIncSlp
	inc	A0
SkIncSlp:
	movb	*A13(DEST_TAG),A1
	jrz	SkDst
	movb	*A13(DESTTIKS),A1
	and	A7,A1
	sub	A0,A1
	jrnn	SkClrDT
	clr	A1
SkClrDT:
	movb	A1,*A13(DESTTIKS)

SkDst:
	clr	A1
	movb	A1,*A13(ANIMTIKS)
SlpItX:
	rets
****************************************************************************


*********************************  Pfire  **********************************
Pfire:
	movb	*A13(DEST_TAG),A0
	cmpi	CHASE_T,A0
	jrnz	SkScrTst
	MOVE	@SCRNTL,A2,L		;GET SCREEN TOP LEFT
	addi	60,A2
	MOVE	@SCRNLR,A3,L		;GET SCREEN LOWER RT.
	calla	SCRTSTG
	jrnz	PfireX
SkScrTst:

;* check if either player is on same Z in direction being faced.
	clr	B1	   		;set to P1's obj if he can be thrown at
	clr	B2			;set to P2's obj if he can be thrown at

	;* get PIMPs Z and FACING
	move	*A8(OZPOS),A2,W			;A2 - pimps Z
	calla	GETANIX
	move	A0,A5					;A5 - pimps X
	move	*A8(OFLAGS),A3,W			
	movi	M_FLIPH,A4				;A4 - M_FLIPH
	and	A4,A3					;A3 - pimps facing

	move	A3,A6					;A6 - Temp of pimps facing
	movi	P1DATA,A14
	move	*A14(POBJ),A7,L				;A7 - Player 1 Obj
	jrz	PFire2
	move	A8,A10
	move	A7,A8
	calla	GETANIX
	move	A0,A1					;A1 - P1 X
	move	A8,A7
	move	A10,A8
	sub	A5,A1					;A1 - P1 X - Pimp X
	jrp	SkNFace1
	xor	A4,A6	
SkNFace1:
	xor	A4,A6
	jrz	PFire2	;Facing wrong way, can't shoot or throw at P1.

	abs	A1						;A1 - abs X delta
	cmpi	25,A1
	jrlt	PFire2	;Too close, can't shoot at P1

	cmpi	50,A1
	jrlt	SkSetT1	;Too close, can't throw at P1
	move	A7,B1
SkSetT1:

	srl	2,A1
	move	*A7(OZPOS),A6,W	;Check Range in Z for firing
	move	*A14(PSWTCH),A0,W
	move	A0,B3
	andi	PUP,A0
	jrz	SkDecZV1
	sub	A1,A6
	jruc	SkIncZV1
SkDecZV1:
	andi	PDOWN,B3
	jrz	SkIncZV1
	add	A1,A6
SkIncZV1:
	sub	A2,A6
	abs	A6
	cmpi	15,A6
	jrle	LetErRip		;Within Z, so shoot.

PFire2:
	move	A3,A6					;A6 - Temp of pimps facing
	movi	P2DATA,A14
	move	*A14(POBJ),A7,L				;A7 - Player 2 Obj
	jrz	NoFire
	move	A8,A10
	move	A7,A8
	calla	GETANIX
	move	A0,A1					;A1 - P2 X
	move	A8,A7
	move	A10,A8
	sub	A5,A1					;A1 - P2 X - Pimp X
	jrp	SkNFace2
	xor	A4,A6	
SkNFace2:
	xor	A4,A6
	jrz	NoFire	;Facing wrong way, can't shoot or throw at P1.

	abs	A1						;A1 - abs X delta
	cmpi	25,A1
	jrlt	NoFire	;Too close, can't shoot at P2

	cmpi	50,A1
	jrlt	SkSetT2	;Too close, can't throw at P2
	move	A7,B2
SkSetT2:

	srl	2,A1
	move	*A7(OZPOS),A6,W	;Check Range in Z for firing
	move	*A14(PSWTCH),A0,W
	move	A0,B3
	andi	PUP,A0
	jrz	SkDecZV
	sub	A1,A6
SkDecZV:
	andi	PDOWN,B3
	jrz	SkIncZV
	add	A1,A6
SkIncZV:

	sub	A2,A6
	abs	A6
	cmpi	15,A6
	jrle	LetErRip		;Within Z, so shoot.

NoFire:
;* do we feel like throwing something?
	movb	@RAND,A0
	jrn	SkSwPs
	SWAP	B1,B2
SkSwPs:
	move	B1,A3
	jrnz	GotP
	move	B2,A3
	jrz	NoThrow

GotP:
	move	@pimpthr1,A0,W
	movb	*A13(HIDING),A1
	jrz	TryThrw
	move	@pimpthr2,A0,W
TryThrw:
	calla	RANDPER
	jrnc	NoThrow

	;** Throw a stick of dynamite ******
	PUSHP	A3			;Push Player to throw at

	callr	SlpItOff
	calla	PRCSLP

	move	*A8(OXVEL+8),A10,W	   ;save velocities to be restored
	move	*A8(OYVEL+8),A11,W
	sll	16,A11
	movy	A11,A10
	calla	ClrVel
	move	A9,A11

	movb	*A13(DEST_TAG),A0
	cmpi	CHASE_T,A0
	jrnz	NotChs1
	movi	PRUNTW1,A9
	jruc	GotTF1
NotChs1:
	movi	PTW1,A9	
GotTF1:
	movk	1,A1
	jsrp	FRANIM
	PULLP	A4		;Retrieve Player to Throw At
	movi	>00380000,A0	;y:x offsets
	callr	ThrowD
	movb	*A13(DEST_TAG),A0
	cmpi	CHASE_T,A0
	jrnz	NotChs2
	movi	PRUNTW2,A9
	jruc	GotTF2
NotChs2:
	movi	PTW2,A9	
GotTF2:
	movk	1,A1
	jsrp	FRANIM

	move	A11,A9
	movy	A10,A11
	sra	8,A11
	sll	16,A10
	sra	8,A10
	move	A11,*A8(OYVEL),L
	move	A11,*A8(OZVEL),L
	move	A10,*A8(OXVEL),L
	
NoThrow:
	jruc	PfireX

LetErRip:
	callr	SlpItOff
	calla	PRCSLP
;* we are facing someone, so let's shoot em!
	clr	A7			;Z delta
	move	*A8(OXVEL+8),A10,W
	move	*A8(OYVEL+8),A11,W
	sll	16,A11
	movy	A11,A10
	calla	ClrVel

	move	A9,A11
	
	movb	*A13(HIDING),A0
	jrz	SkFirHid
	move	*A13(WANTOBJ),A0,L
	jrz	SkFirHid		;used to be $
	move	*A0(OSIZEY),A0,W
	cmpi	40,A0
	jrlt	LowS
	cmpi	60,A0
	jrlt	MedS
	;* Shooting from tall obstacle (i.e. Dumpster)
	movi	PSHOOT,A9
	movb	@RAND,A0
	movk	17,A7
	jrn	SLft
	neg	A7
SLft:
	move	*A8(OZPOS),A1,W
	add	A7,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OYPOS),A1,W
	add	A7,A1
	move	A1,*A8(OYPOS),W
	move	*A8(OSHAD),A2,L
	jrz	GotFF
	move	*A2(OYPOS),A1,W
	add	A7,A1
	move	A1,*A2(OYPOS),W
	jruc	GotFF
LowS:
	movi	PHSQSHT,A9
	jruc	GotFF
MedS:
	movi	PHSHOOT,A9
	jruc	GotFF
SkFirHid:

	movb	*A13(DEST_TAG),A0
	cmpi	CHASE_T,A0
	jrnz	NotChase
	movi	PRUNSHT,A9
	jruc	GotFF
NotChase:
	movb	@RAND,A0
	jrn	SqFire
	movi	PSHOOT,A9
	jruc	GotFF
SqFire:
	movi	PSQSHT,A9
GotFF:
	PUSHP	A7			;Z delta
	movk	1,A1
	jsrp	FRANIM

	move	A11,A9
	movy	A10,A11
	sra	8,A11
	sll	16,A10
	sra	8,A10
	move	A11,*A8(OYVEL),L
	move	A11,*A8(OZVEL),L
	move	A10,*A8(OXVEL),L
	PULLP	A7			;Z delta
	neg	A7
	jrz	SkFRePos
	move	*A8(OZPOS),A1,W
	add	A7,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OYPOS),A1,W
	add	A7,A1
	move	A1,*A8(OYPOS),W
	move	*A8(OSHAD),A2,L
	jrz	SkFRePos
	move	*A2(OYPOS),A1,W
	add	A7,A1
	move	A1,*A2(OYPOS),W
SkFRePos:

PfireX:
	retp
****************************************************************************

**************************** Animation Cycler ******************************
AnimCycle:
;Resets animation loop
	mmtm	SP,A0
	movb	*A13(HIDING),A0
	jrz	SkHiding

	;* Do hiding specific stuff.
	callr	HideXCk
	jrc	SkHiding

	move	*A13(WANTOBJ),A0,L
	move	*A0(OSIZEY),A0,W
	cmpi	40,A0
	jrlt	LowH
	cmpi	60,A0
	jrlt	MedH

	;* Hiding Behind a tall obstacle (i.e. Dumpster)
	movi	800,A0
	calla	RANDPER
	jrnc	TalAct
	movi	PTALHIDE,A9
	jruc	GotScr
TalAct:
	movi	PTALLOOK,A9
	jruc	GotScr
	
MedH:
	;* Hiding Behind a tall obstacle (i.e. cans standing)
	movi	800,A0
	calla	RANDPER
	jrnc	MedAct
	movi	PLOWHIDE,A9
	jruc	GotScr
MedAct:
	movi	PLOWLOOK,A9
	jruc	GotScr

LowH:
	;* Hiding Behind a low obstacle (i.e. can on side)
	movi	700,A0
	calla	RANDPER
	jrnc	LowAct
	movi	PKNEEL,A9
	jruc	GotScr
LowAct:
	movb	@RAND,A0
	jrn	Lk2	
	movi	PKNEELK,A9
	jruc	GotScr
Lk2:
	movi	PKLOOK,A9

GotScr:
	move	A9,*A13(ANIMPTR),L
	jruc	ACycleX

SkHiding:
	move	*A13(ANIMPTR),A9,L
ACycleX:
	mmfm	SP,A0
	rets
****************************************************************************

******************************  AT ESCAPE  *********************************
AtEscape:
;* If off screen, we have escaped..
	calla	SCRTST			;OFFSCREEN?
	jrnz	PIMP_DONE
	retp
****************************************************************************

******************************  AT HIDE  ***********************************
AtHide:
;* Check if we are now hidden
	callr	P_HIDDEN
	jrnc	AtHideX
	calla	ClrVel
	move	*A13(WANTOBJ),A0,L
	calla	FACEOBJ
	movi	PKNEELK,A9	
	move	A9,*A13(ANIMPTR),L
AtHideX:
	rets
****************************************************************************

******************************  AT DEFAULT  ********************************
AtDflt:
;* If off screen, turn around and go other way
	callr	P_XCHECK
	rets
****************************************************************************

******************************  Check Evade  *******************************
CkEvade:
	;* If too far off screen don't bother evading..
	MOVE	@SCRNTL,A2,L		;GET SCREEN TOP LEFT
	addi	40,A2
	MOVE	@SCRNLR,A3,L		;GET SCREEN LOWER RT.
	addi	40,A3
	calla	SCRTSTG
	jrnz	EvadeX

	calla	ClosestP
	move	A8,A1
	move	A0,A8
	calla	GETANIX
	move	A0,A2
	SWAP	A8,A1
	calla	GETANIX
	sub	A0,A2
	abs	A2
	cmpi	60,A2
	jrgt	EvadeX

	move	*A1(OZPOS),A0		;if too far away in Z don't evade
	move	*A8(OZPOS),A3
	sub	A0,A3
	abs	A3
	cmpi	45,A3
	jrgt	EvadeX
	cmpi	12,A3
	jrgt	SkMwk
	cmpi	45,A2
	jrlt	SkMwk
	callr	GoMWalk
	jruc	FleeDir
SkMwk:
	cmpi	35,A2
	jrgt	SkJump
	cmpi	25,A2
	jrlt	SkJump
	cmpi	25,A3
	jrgt	SkJump
	movb	*A13(BUSTTIKS),A0
	jrnz	SkJump
;	PUSHP	A1
	jsrp	JmpAway
;	PULLP	A1
SkJump:

	;* player is too close - RUN AWAY!!
FleeDir:
	callr	GoRun
	calla	Flee
	movk	BUST_T,A0
	movb	A0,*A13(DEST_TAG)
	clr	A0
	move	A0,*A13(WANTOBJ),L
	movb	A0,*A13(ANIMTIKS)
EvadeX:
	retp
**************************************************************************

***************************  CHECK ESCAPE  *********************************
CkEscape:
;* If Pimp has 3 or more dollars, he will try to run away...
	movb	*A13(EBUCK),A0
	cmpi	3,A0
	jrlt	NoEsc
	callr	GoRun
	move	@(WORLDTLX+16),A1,W
	move	A1,A3
	subi	100,A3
	move	*A8(OXPOS),A2,W
	sub	A1,A2
	cmpi	255,A2
	jrlt	RunAway
	addi	612,A3
RunAway:
	move	*A8(OZPOS),A1,W	
	sll	16,A1
	movx	A3,A1
	move	A1,*A13(DEST),L
	calla	GoDestV
	
	movi	ESCAPE_T,A0
	movb	A0,*A13(DEST_TAG)
NoEsc:
	rets
****************************************************************************

*****************************  CHECK Buck  *********************************
;* look and see if any bucks are available for grabbing.
CkBuck:
	movi	BUCKOID,A0
	calla	NEAR_BTY
	jrnc	NoBuck

	mmtm	SP,A8   
	move	A0,A8
	calla	SCRTST	
	mmfm	SP,A8
	jrnz	NoBuck

	callr	GoRun
	move	A0,*A13(WANTOBJ),L
	calla	HuntObj
	move	*A13(DEST+16),A0,W	 ;* need to inc z dest
	addk	BUCKHGHT,A0
	move	A0,*A13(DEST+16),W
	
	movk	25,A0
	calla	ShortXDest

	calla	GoDestV

	movk	BUCK_T,A0
	movb	A0,*A13(DEST_TAG)
NoBuck:
	rets
****************************************************************************

*****************************  CHECK Hide  *********************************
;* look and see if any objects are available to hide behind
CkHide:
;* Check if any obstacle is suitable for hiding behind,
;*   both Players X coors are on opposite side of Obj from the enemy
;*	Try and use object in WANTOBJ first
;* If there is a suitable object,
;*	set WANTOBJ to be the object
;*	set DEST to be coors of object
;*	call	GoDest to set Path
;*	set animation script to PRUN
;*	set	the carry bit

	mmtm	SP,A8
	calla	GETANIX
	move	A0,A1			;A1 - PIMPx

	;* If not on scr, don't try to hide
	move	@WORLDTL,A2,W
	sub	A2,A0			;SUBTRACT OUT WORLD BASE

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	cmp	A2,A0			;OFF Left Edge?
	jrlt	NO_HIDE
;	move	@SCRNLR,A2,W		;GET SCREEN RT.
;	cmp	A2,A0			;OFF RT Edge?
;	jrgt	NO_HIDE

	move	A1,A7			;A7 - Also PIMPx

;* if between players goto NO_HIDE
	movi	P1DATA,A0
	move	*A0(POBJ),A8,L
	jrz	NO_P1
	move	*A8(OZPOS),A5,W
	calla	GETANIX
	move	A0,A2			;A2 - P1x
	movi	P2DATA,A0
	move	*A0(POBJ),A8,L
	jrz	HScanObj
	move	*A8(OZPOS),A6,W
	calla	GETANIX
	move	A0,A3			;A3 - P2x

;* Got Both players X, if between them goto NO_HIDE
	cmp	A1,A2
	jrlt	P1ONLEFT	

	;* P1 is on the right, if P2 on left goto NO_HIDE
	cmp	A1,A3
	jrle	NO_HIDE
	jruc	CAN_HIDE	  ;* both players on the right

P1ONLEFT:
	;* P1 is on the left, if P2 on right goto NO_HIDE
	cmp	A1,A3
	jrge	NO_HIDE

;* both players on same side pick closest - put X in A2, Z in A5
CAN_HIDE:
	cmp	A1,A3
	jrlt	P2ONLEFT
	;* players on right, which has smaller X
	cmp	A2,A3
	jrgt	HScanObj
	move	A3,A2	
	move	A6,A5
	jruc	HScanObj
P2ONLEFT:
	;* players on left, which has greater X
	cmp	A2,A3
	jrlt	HScanObj
	move	A3,A2	
	move	A6,A5
	jruc	HScanObj

NO_P1:
;* no player1, if player2 scan against him
	movi	P2DATA,A0
	move	*A0(POBJ),A8,L
	jrz	NO_HIDE
	move	*A8(OZPOS),A5,W
	calla	GETANIX
	move	A0,A2			;A2 - P2x

HScanObj:
;* playerX in A2, PIMPx in A1, want bigger X in A2
	cmp	A2,A1
	jreq	NO_HIDE
	jrlt	HNOSWAP
	move	A2,A1
	move	A7,A2
HNOSWAP:
	move	*A13(WANTOBJ),A0,L
	jrz	HLoadLst
	callr	HIDEOBJ
	jrnc	HLoadLst

	move	A0,A4		;* GotHobj will look for Obj in A4
;* check if A1 < ObjX < A2
	move	*A4(OXPOS),A0,W	;A0 - OBJx
	move	*A4(OSIZEX),A6,W
	srl	1,A6
	add	A0,A6

	cmp	A1,A6
	jrle	HLoadLst
	cmp	A2,A6
	jrge	HLoadLst

	move	A4,A8
	calla	SCRTST	
	jreq	GotHObj

HLoadLst:
	move	@BACKSLST,A4,L
	jrz	NO_HIDE
HScanLp:
;* check if A1 < ObjX < A2
	move	*A4(OXPOS),A0,W	;A0 - OBJx
	move	*A4(OSIZEX),A6,W
	srl	1,A6
	add	A0,A6
	cmp	A1,A6
	jrle	HScanX
	cmp	A2,A6
	jrgt	HScanX
	movk	3,A0
	calla	RANDU
	dec	A0
	jrnz	HScanX
	move	A4,A0
	callr	HIDEOBJ
	jrnc	HScanX
	move	A4,A8
	calla	SCRTST	
	jreq	GotHObj
HScanX:
	move	*A4(OSLINK),A4,L
	jrnz	HScanLp
	
	move	A4,*A13(WANTOBJ),L
NO_HIDE:
	mmfm	SP,A8
	clrc
	rets

GotHObj:
	mmfm	SP,A8
	callr	GoRun
	move	A4,*A13(WANTOBJ),L

	;* set COORS of Dest.
	move	*A4(OSIZEX),A1,W
	srl	1,A1
	addk	15,A1
	sub	A6,A7			;A7 should still be x coor of pimp
	jrn	LeftSide
	;** Approaching right side of object
	add	A1,A6
	jruc	SkLftS
LeftSide:
	sub	A1,A6
SkLftS:
	move	A4,A0
	calla	GetMidZ
	sll	16,A0
	movx	A6,A0
	move	A0,*A13(DEST),L

	calla	GoDestV
	
	movi	HIDE_T,A0
	movb	A0,*A13(DEST_TAG)

	setc
	rets
****************************************************************************


***********************  DEFAULT DESTINATION  ******************************
DfltDest:
;* Head for far edge of screen

	;* check if Pimp is off screen
;	callr	P_XCHECK
;	jrnc	SkOffScr
;	callr	GoRun
;	jruc	GotSpeed
;SkOffScr:
	callr	GoWalk
GotSpeed:
	calla	GETANIX
	move	@(WORLDTLX+16),A2,W				 
	move	A2,A3
	addi	50,A3
	cmp	A3,A0
	jrlt	GoRgt
	addi	462,A3
	cmp	A3,A0
	jrgt	GoLft

	move	*A8(OFLAGS),A1,W
	movi	400,A0
	calla	RANDPER
	jrnc	SkChngD
	not	A1
SkChngD:
	btst	B_FLIPH,A1
	jrnz	GoLft
GoRgt:
	addi	482,A2
	jruc	GotDfltX
GoLft:
	addk	30,A2	
	
GotDfltX:
	move	@PLZMIN,B0
	move	@PLZMAX,B1
	calla	RANGRAND
	sll	16,A0
	movx	A2,A0
	move	A0,*A13(DEST),L
	calla	GoDestV

	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)

	rets
****************************************************************************

**************************************************************************
P_XCHECK:
;* returns dist off screen in A0
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	cmp	A2,A0			;IS IT PAST THE RT?
	jrgt	OffRite

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	move	*A8(OSIZE),A1,W
	add	A1,A0			;RIGHT EDGE OF OBJECT
	cmp	A2,A0
	jrlt	OffLeft
	clrc
	rets

OffRite:
	sub	A2,A0
	calla	T_YFLP
	setc
	rets

OffLeft:
	sub	A2,A0
	calla	T_NOYFLP
	setc
	rets
**************************************************************************

**************************************************************************
HideXCk:
;* called when pimp is hiding. 
;* If pimp gets to far off the screen, he will quit hiding.
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

;	move	@SCRNLR,A2,W		;GET SCREEN RT.
;	addi	100,A2
;	cmp	A2,A0			;IS IT PAST THE RT?
;	jrgt	OffScr

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	subi	100,A2
	move	*A8(OSIZE),A1,W
	add	A0,A1			;RIGHT EDGE OF OBJECT
	cmp	A2,A1
	jrlt	OffScr
	clrc
	rets

OffScr:
	clr	A0
	move	A0,*A13(WANTOBJ),L
	setc
	rets
**************************************************************************

****************************  Grab Buck  *********************************
GrabBuck:
	move	*A13(WANTOBJ),A0,L
	jrz	GRABX
;* If ENEMY Z and OBJ Z don't match, can't grab
GrabLp:
	jsrp	TRYBUST
	jrc	GRABX
	move	*A13(WANTOBJ),A0,L
	callr	GrabPOk
	jrnc	NOGRAB

GRABIT:
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrc	DOGRAB
	jruc	GRABX
DOGRAB:
	move	A0,A10
	calla	FACEOBJ
	movi	PREACH1,A9
	calla	ClrVel
	movk	1,A1
	jsrp	FRANIM
	
	move	A10,A0
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrnc	GRABX
	callr	GrabPOk
	jrnc	GRABX
	move	*A10(OPLINK),A0,L
	jrz	NoBtyPrc
	calla	KILL
	clr	A0
	move	A0,*A10(OPLINK),L
NoBtyPrc:
	move	A10,A0
	movi	BOOTY,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	calla	DELOBJ			;ZAP IT
	movb	*A13(EBUCK),A0
	inc	A0
	movb	A0,*A13(EBUCK)

	movi	PREACH2,A9
	movk	1,A1
	jsrp	FRANIM

	movi	BUCKOID,A0
	calla	NEAR_BTY
	jrc	GrabLp

GRABX:
	clr	A0
	move	A0,*A13(WANTOBJ),L
	setc
	retp
NOGRAB:
	clrc
	retp
**************************************************************************

**************************************************************************
GrabPOk:
;are coors of obj-A0 close enough to obj-A8 for grabbin
;return setc if so, else clrc
	move	*A0(OZPOS),A1,W
	addk	BUCKHGHT,A1
	move	*A8(OZPOS),A2,W
	move	A1,A3
	sub	A2,A3
	abs	A3
	cmpi	6,A3
	jrgt	FARGRAB

;* Check X distance
	move	*A0(OXPOS),A2,W  
	move	*A0(OSIZEX),A3,W 
	srl	1,A3
	add	A3,A2	;A2 - objx
	move	A0,A1
	calla	GETANIX
	SWAP	A1,A0	;A1 - enemyx
	sub	A1,A2	;A2 - distance apart
	abs	A2
	cmpi	5,A2
	jrlt	FARGRAB
	cmpi	35,A2
	jrgt	FARGRAB

	setc
	rets

FARGRAB:
	clrc
	rets
**************************************************************************


**************************************************************************
ThrowD:
;* Parms
;	A0 - packed Y:X offsets from throw frame anim pt
;	A4 - ptr to targets obj.
	move	A0,B0
	move	@pimpfbal,A0,W
	calla	RANDPER
	jrc	ThrowD2		;throw a fast ball

	;* dispatch a dynamite stick
	MOVI	0EDh,A1
	MOVI	dynamite,A7
	CALLA	GETPRC
	jrz	SkDyn
	move	A0,A7

	move	*A8(OXPOS),A0,W
	move	*A4(OXPOS),A1,W
	sub	A0,A1
	move	A1,A5
	abs	A1
	andi	>1FF,A1	;* max range of 512
	move	A1,A2
	move	A1,A3
	movi	>280,A0
	CALLA	RANDU
	addi	>130,A0
	mpys	A0,A3
	sll	11,A1	;* Yvel is 16.16 but dividing Xdelta by 32 to give YVel
	sub	A3,A1
	neg	A1

	;* determine X velocity
	move	A2,A0
	addi	170,A0
	sll	9,A0
	clr	A6
	move	A5,A5
	jrp	FlySetXv
	inc	A6
	neg	A0
FlySetXv:	
	movb	A6,*A7(rotdir)
	movi	P1DATA,A6
	move	*A6(POBJ),A14,L
	cmp	A14,A4
	jreq	GotPD
	movi	P2DATA,A6
	move	*A6(POBJ),A14,L
	cmp	A14,A4
	jrnz	SkDeltXV

GotPD:
	move	*A6(PSWTCH),A6,W
	andi	PRYTE|PLEFT,A6
	jrz	SkDeltXV
	move	A0,B3
	movi	5,B4
	mpys	B4,B3
	sra	2,B3
	move	B3,A0
SkDeltXV:

	move	A0,*A7(ETEMP1),L	;X vel

	move	*A8(OZPOS),A0,W
	move	*A4(OZPOS),A5,W
	sub	A0,A5
	sll	24,A5
	sra	7,A5
	move	A2,A4
	srl	2,A4
	sub	A4,A2
	divs	A2,A5
	movi	>10000,A0
	sll	5,A2
	sub	A2,A0
	move	A0,A2
	CALLA	RANDU
	srl	1,A2
	sub	A2,A0
	add	A0,A5
	move	A5,*A7(ETEMP3),L	;Z vel
	add	A5,A1
	move	A1,*A7(ETEMP2),L	;Y vel

	movk	9,A1
	movk	12,A0
	calla	RANDU
	sub	A0,A1
	movb	A1,*A7(fuselen)

	;* Get animation point of the stick X,Y in A2,A3
	calla	GETANIXY
	srl	16,A2	;A2 was APOINT OYVAL, 32 BITS
	sra	16,A3	;A3 was APOINT OXVAL, 32 BITS

	move	B0,A0  ;B0 has offsets from frame center
	move	A0,A1
	zext	A0,W
	add	A0,A3
	srl	16,A1
	add	A1,A2
	sll	16,A2
	add	A3,A2

	move	A2,*A7(ETEMP4),L	;packed Y:X pos
SkDyn:
	rets
**************************************************************************


**************************************************************************
ThrowD2:
;* Throw a fastball which is timed to blow in the players face without
;	bouncing.
;* Parms
;	B0 - packed Y:X offsets from throw frame anim pt
;	A4 - ptr to targets obj.

	;* dispatch a dynamite stick
	MOVI	0EDh,A1
	MOVI	dynamite,A7
	calla	GETPRC
	jrz	SkDyn2
	move	A0,A7

	;determine distance stick must fly
	calla	GETANIX
	move	A0,A1
	move	A8,A6
	move	A4,A8
	calla	GETANIX
	move	A6,A8
	sub	A0,A1		;A1 = ThrowerX-PlX

	;* determine X velocity
	movi	>50000,A5
	clr	A6		;rotate CW
	move	A1,A1
	jrn	SkNgXv
	neg	A5		;A5 Xvelocity
	movk	1,A6		;rotate CCW
SkNgXv:	
	move	A5,*A7(ETEMP1),L	;X vel
	movb	A6,*A7(rotdir)

	;* determine Z & Y vels.
	;	Time = Xdelt / Xv
	;	Zv = Zdelt / Time
	;	Yv = Zv + >4000 * Time/2
	abs	A5
	abs	A1
	sll	16,A1
	divu	A5,A1			;A1 = Time
	;* get Zv
	move	*A8(OZPOS),A0,W
	move	*A4(OZPOS),A5,W
	sub	A0,A5
	sll	16,A5
	divs	A1,A5			;A5 = Zv
	move	A5,*A7(ETEMP3),L	;set Z vel
	;set fuse length
	move	A1,A3
	movi	FUSETIKS,A2
	divu	A2,A3
	cmpi	1,A3
	jrge	MinFLOK
	movk	1,A3
MinFLOK:
	cmpi	15,A3
	jrle	MaxFLOK
	movk	15,A3
MaxFLOK:
	subk	7,A3
	movb	A3,*A7(fuselen)
	;* get Yv
	srl	1,A1
	movi	>4000,A3
	mpyu	A1,A3
	neg	A3
	add	A5,A3
	move	A3,*A7(ETEMP2),L	;Y vel
	

	;* Get animation point of the stick X,Y in A2,A3
	calla	GETANIXY
	srl	16,A2	;A2 was APOINT OYVAL, 32 BITS
	sra	16,A3	;A3 was APOINT OXVAL, 32 BITS

	move	B0,A0  ;B0 has offsets from frame center
	move	A0,A1
	zext	A0,W
	add	A0,A3
	srl	16,A1
	add	A1,A2
	sll	16,A2
	add	A3,A2

	move	A2,*A7(ETEMP4),L	;packed Y:X pos
SkDyn2:
	rets
**************************************************************************


**************************************************************************
P_FIRE:
;* A0 is Max # of times to FIRE
;* if ANIMPTR is not set, will have to choose one..
	movk	1,A10

	calla	NEARPLYR			;Get disp obj of someone to shoot at
	jrz	P_NO_SH
	move	A0,A4

	move	*A13(ANIMPTR),A1,L
	jrnz	PickX

	;* Pick a Firing script
F_GUN:
	move	@RAND,A1,W
	jrn	F_SQUAT
	movi	PSHOOT,A1
	jruc	GotPick
F_SQUAT:

	
	movi	PSQSHT,A1
GotPick:
	move	A1,*A13(ANIMPTR),L
PickX:

	calla	FACEOBJ
P_S_LP:
	move	*A13(ANIMPTR),A9,L


	movk	1,A1		;do whole script
	calla	ClrVel
	jsrp	FRANIM

	cmpi	PTW2,A9
	jrnz	SkThrow2
	callr	ThrowD

	movk	1,A1		;do whole script
	calla	ClrVel
	jsrp	FRANIM
SkThrow2:

	dsj	A10,P_S_LP
	setc
	retp

P_NO_SH:
	clrc
	retp
**************************************************************************

**************************************************************************
P_LOB:
	movi	4,A0
	calla	RANDU
	dec	A0
	jrnz	P_NO_LOB

	move	A11,A0
	calla	GETPLYR
	move	*A0(POBJ),A0,L
	move	A0,A4
	calla	FACEOBJ
	movk	1,A1		;do whole script
	calla	ClrVel
	jsrp	FRANIM
	setc
	retp

P_NO_LOB:
	clrc
	retp
**************************************************************************

**************************************************************************
P_DUCK:
	calla	NEAR_BUL
	move	A5,A5	;* is there a bullet headed our way??
	jrz	P_DUCKX
	cmpi	300,A6
	jrgt	P_DUCKX	;* bullet is too far away to worry about..
	move	*A13(WANTOBJ),A0,L
	move	*A0(OYPOS),A0,W
	move	*A5(OYPOS),A1,W
	cmp	A0,A1
	jrgt	P_DUCKX	;* object blocks bullet
	movi	PDUCK,A0
	move	@RAND,A1,W
	jrn	SetDAni
	movi	PKNEELK,A0
SetDAni:
	move	A0,*A13(ANIMPTR),L
	setc
	rets
P_DUCKX:
	clrc
	rets
**************************************************************************

****************************  CHECK DANGER  ******************************
* if PIMP is in danger of being shot, jump or duck or move away
CkDngr:
	calla	NEAR_BUL
	move	A5,A0	;* is there a bullet headed our way??
	jrz	P_NODNGR

	move	*A5(OYPOS),A2,W
	subi	ZORIGIN,A2
	move	*A5(OZPOS),A3,W
	sub	A2,A3
	cmpi	55,A3		;is bullet height < 55
	jrlt	BULL_LOW
;* BULLET IS HEADING TOWARDS HEAD -- DO SOMETHING !!!
	cmpi	350,A6		;is bullet real close?
	jrgt HGH_FAR
;* bullet is close - duck and fire.
	move	*A8(OXVEL+8),A10,W	   ;save velocities to be restored
	move	*A8(OYVEL+8),A11,W
	sll	16,A11
	movy	A11,A10
	calla	ClrVel
	move	A9,A11

	;* shoot toward where bullet came from 
	move	A5,A0
	calla	FACEBULL
	movi	PSQSHT,A9,L
	movk	1,A1		;execute script
	jsrp	FRANIM

	move	A11,A9
	movy	A10,A11
	sra	8,A11
	sll	16,A10
	sra	8,A10
	move	A11,*A8(OYVEL),L
	move	A11,*A8(OZVEL),L
	move	A10,*A8(OXVEL),L
	jruc	P_DNGRX
HGH_FAR:
;* bullet is far - run down and away
	;* move away from bullet on Z
	jruc	P_DNGRX

BULL_LOW:
;* BULLET IS HEADING TOWARDS FEET -- DO SOMETHING !!!
	movb	*A13(HIDING),A0
	jrnz	P_NODNGR
	cmpi	300,A6		;is bullet real close?
	jrgt LOW_FAR
;* bullet is very close - jump.
	move	A5,A0
	calla	FACEBULL
	jsrp	DO_PJUMP
	jruc	P_DNGRX
LOW_FAR:
;* bullet is far - run up and away
	;* move away from bullet on Z

P_DNGRX:
	setc
	RETP
P_NODNGR:
	clrc
	RETP
**************************************************************************

**************************************************************************
DO_PJUMP:
;* Entry Point for jumping bullets
	calla	ShadOn

	move	*A8(OXVEL+8),A10,W	   ;save velocities to be restored
	move	*A8(OYVEL+8),A11,W
	sll	16,A11
	movy	A11,A10
	move	A9,A11

	movk	1,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkJLeft
	neg	A0
SkJLeft:
	move	A0,*A8(OXVEL+16),W
	calla	UpdShadV
	jruc	DoJump

JmpAway:
;* Entry Point For Jumping from a bust
	calla	ShadOn

	move	*A8(OXVEL+8),A10,W	   ;save velocities to be restored
	move	*A8(OYVEL+8),A11,W
	sll	16,A11
	movy	A11,A10
	move	A9,A11

	;SET X VELOCITY AND FACING
	movi	>10000,A0
	calla	RANDU
	addi	>18000,A0
	move	A0,A3		;Xvel
	move	*A8(OXPOS),A1,W
	move	@(WORLDTLX+16),A2,W				 
	sub 	A2,A1
	cmpi	255,A1
	jrlt	JmpRt
	;* need to jump to the left
	calla	Ck_YFLP
	jrnc	GotF
	neg	A3			;set x velocity neg
	jruc	GotF
JmpRt:
	calla	Ck_NOYFLP
	jrc	GotF
	neg	A3
GotF:
	move	A3,*A8(OXVEL),L

	;SET Z VELOCITY AND FACING
	movi	>C000,A0
	calla	RANDU
	addi	>C000,A0
	move	A0,A3		;Zvel
	move	@PLZMIN,A1,W
	move	@PLZMAX,A2,W
	sub	A1,A2
	srl	1,A2
	add	A1,A2
	move	*A8(OZPOS),A1,W
	cmp	A2,A1
	jrlt	SkZin
	neg	A3
SkZin:
	move	A3,*A8(OZVEL),L

DoJump:
	movi	PJMP,A9,L
	movk	4,A1
	jsrp	FRANIM
	movk	3,A0
	calla	PRCSLP
	movk	4,A1
	jsrp	FRANIM

	movk	3,A0
	calla	RANDU
	addk	7,A0
	neg	A0
	move	*A8(OYVEL+16),A1,W
	add	A0,A1
	move	A1,*A8(OYVEL+16),W
	
PFLY0:
	callr	ZCHECK
	calla	UpdShadV
	movk	1,A0
	calla	PRCSLP
	calla	DFRMGRND
	cmpi	35,A1
	jrgt	PFLY1a
	move	*A8(OYVEL),A0,L
	addi	>C000,A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A1,L
	sub	A1,A0
	jrn	PFLY0

PFLY1a:
	movk	4,A1
	jsrp	FRANIM
PFLY1:
	callr	ZCHECK
	calla	UpdShadV
	movk	1,A0
	calla	PRCSLP
	jrlt	PFLY2a
	move	*A8(OYVEL),A0,L
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A1,L
	sub	A1,A0
	jrn	PFLY1

PFLY2a:
	movk	4,A1
	jsrp	FRANIM
PFLY2:
	callr	ZCHECK
	calla	UpdShadV
	movk	1,A0
	calla	PRCSLP
	move	*A8(OYVEL),A0,L
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	calla	DFRMGRND
	jrp	PFLY2

;* we have hit the ground..
	calla	ShadOff

	move	A8,A0
	calla	SETZPOS
	callr	ZFIX

	move	A11,A9
	movy	A10,A11
	sra	8,A11
	sll	16,A10
	sra	8,A10
	move	A11,*A8(OYVEL),L
	move	A11,*A8(OZVEL),L
	move	A10,*A8(OXVEL),L

	clr	A0
	movb	A0,*A13(DEST_TAG)
	move	A0,*A13(WANTOBJ),L

	move	A10,A9
	retp
**************************************************************************


**************************************************************************
P_HIDDEN:
;* return carry set if Enemy is protected by an obstacle

	mmtm	SP,A8
	move	*A13(WANTOBJ),A5,L
	jrz	NOT_HID
	calla	GETANIX		
	move	A0,A1			;A1 = Pimps Anim Pt.
	move	*A5(OXPOS),A3,W	
	move	*A5(OSIZEX),A4
	srl	1,A4				;A4 = 1/2 OBJ width
	add	A4,A3			;A3 - OBJx center

	movb	*A13(HIDING),A0
	jrnz	SkObjCk
	move	A5,A0
	callr	HIDEOBJ
	jrnc	NOT_HID

;* If ENEMY Z and OBJ Z don't match, not hidden
	move	A5,A0
	calla	GetMidZ
	move	*A8(OZPOS),A2,W
	sub	A0,A2
	abs	A2
	cmpi	5,A2
	jrgt	NOT_HID

;* Check X distance
	addi	40,A4
	move	A3,A2
	sub	A1,A2
	jrn	ObjLeft
	cmp	A4,A2
	jrgt	NOT_HID
ObjLeft:
	neg	A2
	cmp	A4,A2
	jrgt	NOT_HID

SkObjCk:
	
;* If Player1 is not obstructed by object goto NOT_HID
	movi	P1DATA,A0
	move	*A0(POBJ),A8,L
	jrz	HID_P2
	calla	GETANIX
	cmp	A1,A0
	jrgt	P1ONRITE
	;* check to make sure PlayerX < ObjX < EnemyX
	;* A1 - Enemy X,	A0 - Plyr X,	A3 - ObjX
	cmp	A3,A0
	jrge	NOT_HID
	cmp	A3,A1
	jrle	NOT_HID
	jruc	HID_P2
P1ONRITE
	;* check to make sure PlayerX > ObjX > EnemyX
	cmp	A3,A0
	jrle	NOT_HID
	cmp	A3,A1
	jrge	NOT_HID

;* If Player2 is not obstructed by object goto NOT_HID
HID_P2:
	movi	P2DATA,A0
	move	*A0(POBJ),A8,L
	jrz	IS_HID
	calla	GETANIX
	cmp	A1,A0
	jrgt	P2ONRITE
	;* check to make sure PlayerX < ObjX < EnemyX
	cmp	A3,A0
	jrge	NOT_HID
	cmp	A3,A1
	jrle	NOT_HID
	jruc	IS_HID
P2ONRITE
	;* check to make sure PlayerX > ObjX > EnemyX
	cmp	A3,A0
	jrle	NOT_HID
	cmp	A3,A1
	jrge	NOT_HID

IS_HID:
	mmfm	SP,A8
	movk	1,A1
	movb	A1,*A13(HIDING)
	setc
	rets
NOT_HID:
	mmfm	SP,A8
	clr	A1
	movb	A1,*A13(HIDING)
	clrc
	rets
**************************************************************************

**************************************************************************
HIDEOBJ:
	push	A1
	move	*A0(OID),A1,W
	zext	A1,W
	cmpi	BGGID,A1
	jrz	HObj	
	cmpi	BGDMPID,A1
	jrz	HObj	
	mmfm	SP,A1
	clrc
	rets
HObj:
	mmfm	SP,A1
	setc
	rets
**************************************************************************

**************************************************************************
GRABOBJ:
	push	A1
	move	*A0(OID),A1,W
	zext	A1,W
	cmpi	BUCKOID,A1
	mmfm	SP,A1
	jrz	GObj	
	clrc
	rets
GObj:
	setc
	rets
**************************************************************************

**************************************************************************
P_HIDE:
	rets
**************************************************************************

**************************************************************************
PIMP_DONE:
	MOVE	A8,A0		;GET THE POINTER TO THE OBJECT
	calla	DELENEMY			;DELETE THE ENEMY
PIMP_DIE:
	DECW	@PIMPCNT
	DIE
BUSTED:
	move	A11,A2
	movi	>2500,A1
	calla	SCORE
	calla	PUT2x5K
	move	@PIMPCNT,A0,W
	dec	A0
	move	A0,@PIMPCNT,W
	calla	CARDCHEK
	DIE
**************************************************************************


**************************************************************************
*WALKING PIMP COLLSION ROUTINE
*A0 = PTR TO PIMP OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
PIMPCOL0
	MOVE	*A8(OXVEL),A9,L		;GET PROJECTILE DATA
	MOVE	*A8(OYVEL),A10,L
	MOVE	*A8(OID),A11,W		

	MOVE	A8,A6			;STORE KILLERS OBLOCK
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER

	MOVI	SPLTCOLANI,A14
	MOVE	A14,*A0(OCVECT),L	;COLLISION POINTER

	MOVE	*A0(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	MOVE	A0,A14			;STORE THIS RELIC
	
	calla	ShadOn

	MOVI	0EDh,A1
	MOVI	PDIE,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	MOVE	*A6(ODMAXY),*A0(PDATA),L	;PASS KILLERS DMA XY POSITION
	MOVE	*A6(OSIZE),*A0(PDATA+20H),L	;AND KILLERS XY SIZE
	move	*A14(EBCNTRS),*A0(EBCNTRS),L	;and the booty counters
	MOVE	*A14(EMAINT),*A0(EMAINT),L

	move	*A6(OYPOS),A9,W
	MOVI	0EDh,A1
	movi	SPLATANI,A7
	CALLA	GETPRC

	move	@PIMPCNT,A0,W
	dec	A0
	move	A0,@PIMPCNT,W
	calla	CARDCHEK

	CLRC		;Don't delete in Coll routine
	RETS
*************************************************************************

*************************************************************************
* WALKING ENEMY DIE PROCESS
* A8=OBJECT PTR OF ENEMY	  
* A9=XVEL OF KILLER		  
* A10=YVEL OF KILLER	  
* A11=OID OF KILLER		  
* PDATA	    = UPPER LEFT X OF KILLER 
* PDATA+10H = UPPER LEFT Y OF KILLER   
* PDATA+20H = CURRENT X SIZE OF KILLER 
* PDATA+30H = CURRENT Y SIZE OF KILLER		
* PDATA+A0H = ADDRESS OF MAIN ANIMATION TABLE
* I.D. = $ED                                 
PDIE
	CALLa	SCRKIL			;SCORE THE KILL								 

	MOVE	A11,A3		  	;COPY OF I.D.
	SLL	28,A3
	SRL	28,A3

	CMPI	ROCKETID,A3,W
	JAEQ	WROCK			;DEATH BY ROCKET

	CMPI	EXPLODID,A3,W
	JAEQ	WEXPD			;DEATH BY EXPLOSION
;	jrnz	BullDeath
;			;DEATH BY EXPLOSION
;	movi	>40000,A0
;	calla	RANDU
;	subi	>20000,A0
;	move	A0,*A8(OXVEL),L
;	movi	>40000,A0
;	calla	RANDU
;	addi	>50000,A0
;	neg	A0
;	move	A0,*A8(OYVEL),L
;	jauc	PDEXP

BullDeath:
	MOVE	*A8(OFLAGS),A0,W
	andi	M_FLIPH,A0
	jrnz	WEND1A			;BR = pimp facing left

	MOVE	A9,A9
	JRN	WEND1C			;BR = OBJECT HIT FROM FRONT

WEND1B	SRA	18,A9 			;OBJECT MOVING IS SAME DIRECTION
	SRA  18,A10			;DIVIDE VELS. BY 4
	movi	PDF,A11
	JRUC	WEND1D

WEND1A	MOVE	A9,A9
	JRN	WEND1B

WEND1C	SRA	19,A9			;OBJECTS MOVING IN OPPOSITE DIREC.
	SRA	19,A10			;DIVIDE INTEGER VELS. BY 8
	movi	PD,A11
	move	@RAND,A0,W
	jrn	SkPTD
	movi	PTD1,A11
SkPTD:

WEND1D
	MOVE	*A8(OXVEL+16),A0,W
	ADD	A9,A0
	MOVE	A0,*A8(OXVEL+16),W
	MOVE	*A8(OYVEL),A0,L
	MOVE	*A8(OZVEL),A1,L
	sub	A1,A0
	MOVE	A0,*A8(OYVEL),L
	clr	A1
	MOVE	A1,*A8(OZVEL),L

	CALLA	GRUNTRND		;MAKE A RANDOM GRUNT NOISE
	CALLA	DROPSTUF		;DROP THE BOOTY
			 	
	MOVE	*A8(OYVEL),A1,L
	MOVE	*A8(OZVEL),A0,L
	sub	A0,A1
	jrn	WENFALL
	calla	DFRMGRND
	cmpi	5,A1
	jrgt	WENFALL

WEND1:
	clr	A0
	move	A0,*A8(OYVEL),L
	move	A0,*A8(OZVEL),L
	move	A11,A9
GrndDth:
	MOVK	1,A1
	JSRP	FRANIM			;DO DEATH FRAMES
	cmpi	PTD1,A11
	jrnz	SkThrowD1
	calla	ClosestP
	move	A0,A4		;Player to throw at.
	movi	>00480000,A0	;y:x offsets
	callr	ThrowD
	movi	PTD2,A9
	MOVK	1,A1
	JSRP	FRANIM			;DO rest of Death
SkThrowD1:
	jruc	WEND2

WENFALL:
	clr	A10
	move	A11,A9
WFLp:
	move	A10,A10
	jrnz	SkAnim
	movk	4,A1			;* one frame, no sleepin
	PUSHP	A9
	jsrp	FRANIM
	PULLP	A3
	move	A0,A10
	move	*A9,A1,L
	jrnz	KpFallin
	cmpi	PTD1,A11
	jreq	DieToss
	move	A3,A9		;recycle last frame..
	jruc	KpFallin
DieToss:
	mmtm	SP,A10
	calla	ClosestP
	move	A0,A4		;Player to throw at.
	movi	>00480000,A0	;y:x offsets
	callr	ThrowD
	mmfm	SP,A10
	movi	PTD2,A9
	clr	A11
	jruc	WFLp
KpFallin:
SkAnim:
	movk	1,A0
	calla	PRCSLP
	dec	A10
	move	*A8(OYVEL),A0,L
	jrn	GOINGUP
	calla	DFRMGRND
	cmpi	5,A1
	jrlt	HitGRND
	move	*A8(OYVEL),A0,L
GOINGUP:
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	calla	UpdShadV
	jruc	WFLp
HitGRND:
	clr	A0
	move	A0,*A8(OYVEL),L
	move	A8,A0
	calla	SETZPOS
	move	*A8(OZPOS),A0,W
	subi	6,A0
	move	A0,*A8(OZPOS),W
	calla	SHADUPD
	move	A10,A0
	jrz	GrndDth
	calla	PRCSLP
	jruc	GrndDth
WEND2:
	calla	ClrVel
	move	A8,A0
	calla	DELSHAD
	SLEEP	10

	MOVI	[1,1],A9
	CREATE	0DFh,ESINK		;CREATE THE DEADMAN SINK	 
	DIE				;AND ME									 
*************************************************************************

*************************************************************************
PIMPCOLL:
	.WORD	B1OID|BULLETID
	.LONG	PIMPCOL0
	.WORD	B1OID|EXPLODID
	.LONG	PIMPCOL0
	.WORD	B1OID|ROCKETID
	.LONG	PIMPCOL0
	.WORD	B2OID|BULLETID
	.LONG	PIMPCOL0
	.WORD	B2OID|EXPLODID
	.LONG	PIMPCOL0
	.WORD	B2OID|ROCKETID
	.LONG	PIMPCOL0
	.WORD	BEOID|EXPLODID
	.LONG	PIMPCOL0
	.word	C1OID		;ENEMY CAR #1 "CADILLAC" OBJECT I.D.
	.LONG	PIMPCOL0
	.word	CAR2OID		;ENEMY CAR #2 "PORSCHE" OBJECT I.D.
	.LONG	PIMPCOL0
	.word	CAR3OID		;ENEMY CAR #3 "BELL-JET" OBJECT	I.D.
	.LONG	PIMPCOL0
	.word	TRAN1OID	;PLAYER TRANSPORT #1 "PORSCHE" OBJECT I.D.
	.LONG	PIMPCOL0
	.WORD	0
	.LONG	DUMRTSG

;WALKING JUMPING DEATH FRAGMENT STANDING-SHOOT KNEELING-SHOOT
;STANDING KNEELING

PIMPOFF	.WORD	1,3,4,9,18,34,50,50
*THE PIMP ENEMY, ANIMATION PTR TABLE, FIRST LONG WORD IS THE OFFSET PTR
*
PIMPTAB	.LONG	PIMPOFF
	.LONG	PW,PW,PJMP,PD,PD,LOFDEXP,LOFDEXP1,PDROCK

	.LONG	LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4
	.LONG	LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,0
*************************************************************************


**************************************************************************
* PIMP FRAME TABLES	
* NORMAL TABLE ENTRY:
* 	AFRAME	FRAME,SLEEPT,CONTROL_WORD
* FIRE FRAME TABLE ENTRY:		    
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW

********************************************************
*---> pd1,pd2,pd3,pd4,pd5,pd6,pd7
*---> pdf1a,pdf2a,pdf3a,pdf4a,pdf5a,pdf6a
*---> pjump1,pjump2,pjump3,pjump4
*---> pmwk1,pmwk2,pmwk3,pmwk4,pmwk5,pmwk6,pmwk7
*---> prun1r,prun2r,prun4r,prun5r,prun6r,prun7r
*---> pshoot9,pshoot10
*---> psqsht1,psqsht2
*---> ptd1,ptd2,ptd3,ptd4,ptd5,ptd6,ptd7,ptd8,ptd9,ptd10
*---> ptw1,ptw2,ptw3,ptw4,ptw5,ptw6
*---> pw1,pw2,pw4,pw5,pw6,pw8
*---> psp1,psp2,psp3,psp4,psp5,psp6,psp7,psp8,psp9,psp10
*---> psp11,psp12,psp13,psp14,psp15
***********************************************************
WALKVEL		.set	>18000
MWALKVEL	.set   ->13000
RUNVEL		.set	>2A000

MOVETBL:
PW:
	.long	pw1
	.word	9
	.long	pw2
	.word	5
	.long	pw4
	.word	9
	.long	pw5
	.word	6
	.long	pw6
	.word	4
	.long	pw8
	.word	7
PWX:
	LONGNULL

PMWK:
	.long	pw8
	.word	7
	.long	pw6
	.word	4
	.long	pw5
	.word	6
	.long	pw4
	.word	9
	.long	pw2
	.word	5
	.long	pw1
	.word	9
PMWKX:
	LONGNULL

PRUN:
	.long	prun1t
	.word	4
	.long	prun2t
	.word	4
	.long	prun3t
	.word	4
	.long	prun4t
	.word	4
	.long	prun5t
	.word	4
PRUNX:
	LONGNULL

;PW:
;	.long	pw1
;	.word	DELTAXZ|9,13
;	.long	pw2
;	.word	DELTAXZ|5,8
;	.long	pw4
;	.word	DELTAXZ|9,14
;	.long	pw5
;	.word	DELTAXZ|6,9
;	.long	pw6
;	.word	DELTAXZ|4,4
;	.long	pw8
;	.word	DELTAXZ|7,10
;PWX:
;	LONGNULL
;
;PMWK:
;	.long	pw8
;	.word	DELTAXZ|7
;	.byte	-4,0
;	.long	pw6
;	.word	DELTAXZ|4
;	.byte	-9,0
;	.long	pw5
;	.word	DELTAXZ|6
;	.byte	-14,0
;	.long	pw4
;	.word	DELTAXZ|9
;	.byte	-8,0
;	.long	pw2
;	.word	DELTAXZ|5
;	.byte	-13,0
;	.long	pw1
;	.word	DELTAXZ|9
;	.byte	-10,0
;PMWKX:
;	LONGNULL
;
;PRUN:
;	.long	prun1t
;	.word	DELTAXZ|4,10
;	.long	prun2t
;	.word	DELTAXZ|4,10
;	.long	prun3t
;	.word	DELTAXZ|4,9
;	.long	prun4t
;	.word	DELTAXZ|4,11
;	.long	prun5t
;	.word	DELTAXZ|4,9
;PRUNX:
;	LONGNULL
MOVEEND:

WALKOUT:
	.long	psp1a
	.word	20
	.long	psp2a
	.word	10
	.long	psp3a
	.word	10
	.long	prun1t
	.word	6
	.long	prun5t
	.word	6
	.long	prun2t
	.word	6
	.long	prun3t
	.word	6
	.long	prun4t
	.word	6
	LONGNULL

PDROCK:				;PIMP HIT BY ROCKET
	.long	LCREOSOTE
	.word	NEWPALET|5
	.LONG	NARCS
	LONGNULL
PD:
	.long	pd2
	.word	7
	.long	pd3
	.word	7
	.long	pd4
	.word	7
	.long	pd5
	.word	7
	.long	ptd10
	.word	7
	LONGNULL
PIMPBUST:
	.long	pbust2
	.word	8
	.long	pbust1
	.word	8
	.long	pbust2
	.word	8
PCUFF:
	.long	pbust3
	.word	8
	LONGNULL
PJMP:
	.long	pjump1n
	.word	5
	.long	pjump2n
	.word	5
	.long	pjump3n
	.word	5
	.long	pjump4n
	.word	5
	LONGNULL
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW
PHSQSHT:
	.long	psqsht1
	.word	7
	.long	psqsht2
	.word	SPAWNP|7,35,-13,0EBH
	.long	EBULLET
	LONGNULL
PSQSHT:
	.long	psqsht1
	.word	9
	.long	psqsht2
	.word	SPAWNP|9,21,-13,0EBH
	.long	EBULLET
	.long	psqsht1
	.word	4
	.long	psqsht2
	.word	4
	LONGNULL
PDF:
	.long	pdf2a
	.word	10
	.long	pdf3a
	.word	10
	.long	pdf4a
	.word	10
	LONGNULL
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW
PTD1:
	.long	ptd1
	.word	6
	.long	ptd2
	.word	6
	.long	ptd3
	.word	6
	.long	ptd4
	.word	6
	LONGNULL
PTD2:
	.long	ptd6
	.word	6
	.long	ptd7
	.word	6
	.long	ptd9
	.word	6
	.long	ptd10
	.word	6
	LONGNULL
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW
PSHOOT:
	.long	pshoot9
	.word	9
	.long	pshoot10
	.word	SPAWNP|9,21,-13,0EBH
	.long	EBULLET
	.long	pshoot9
	.word	4
	.long	pshoot10
	.word	4
	LONGNULL
PHSHOOT:
	.long	pshoot9
	.word	7
	.long	pshoot10
	.word	SPAWNP|7,40,-13,0EBH
	.long	EBULLET
	LONGNULL
PRUNSHT:
	.long	pshoot10
	.word	SPAWNP|DELTAXZ|5,21,-13,0EBH
	.long	EBULLET
	.word	8			;delta X
	LONGNULL
PTW1:				;PIMP THROW Part 1
	.long	ptw1
	.word	12
	LONGNULL
PTW2:				;PIMP THROW Part 2
	.long	ptw2
	.word	9
;	.word	SPAWNP|8,-30,-22,0EBH
;	.long	EBOMB
	.long	ptw3
	.word	9
	.long	ptw4
	.word	9
	LONGNULL
PRUNTW1:				;PIMP Running THROW Part 1
	.long	ptw1
	.word	DELTAXZ|9,9
	LONGNULL
PRUNTW2:				;PIMP Running THROW Part 2
	.long	ptw2
	.word	DELTAXZ|7,7
	.long	ptw3
	.word	DELTAXZ|7,5
	.long	ptw4
	.word	DELTAXZ|7,3
	LONGNULL
PDUCK:
PSQUAT:
	.long	psqsht1
	.word	9
	.long	psqsht2
	.word	9
	.long	psqsht1
	.word	5
	.long	psqsht2
	.word	5
	LONGNULL
PREACH1
	.long	psp1a
	.word	4
	.long	psp2a
	.word	8
	.long	psp3a
	.word	8
	.long	psp4a
	.word	5
	.long	psp5a
	.word	10
	LONGNULL
PREACH2:
	.long	psp6a
	.word	8
	.long	psp7a
	.word	5
	LONGNULL
PKNEEL:
	.long	pimphide1
	.word	6
	.long	pimphide1
	.word	6
	.long	pimphide1
	.word	6
	.long	pimphide1
	.word	6
	LONGNULL
PKLOOK:
	.long	pimphide2
	.word	7
	.long	pimphide3
	.word	8
	.long	pimphide4
	.word	10
	.long	pimphide3
	.word	8
	.long	pimphide2
	.word	7
	LONGNULL
PKNEELK:
	.long	pimphide1
	.word	9
	.long	pimphide2
	.word	7
	.long	pimphide2
	.word	7
	.long	pimphide2
	.word	7
	.long	pimphide1
	.word	9
	LONGNULL
PTALHIDE:
	.long	psp2a
	.word	7
	.long	psp2a
	.word	7
	.long	psp2a
	.word	7
	LONGNULL
PTALLOOK:
	.long	psp3a
	.word	10
	.long	psp3a
	.word	10
	.long	psp3a
	.word	10
	LONGNULL
PLOWHIDE:
	.long	psp6a
	.word	7
	.long	psp6a
	.word	7
	.long	psp6a
	.word	7
	LONGNULL
PLOWLOOK:
	.long	psp7a
	.word	8
	.long	psp7a
	.word	8
	.long	psp7a
	.word	8
	.long	psp7a
	.word	8
PIMPNUL:
	LONGNULL

****************************************************************************
PIMPCRM1:
	move	@(WORLDTLX+16),A0,W				 
	addi	230,A0
	move	@PLYMIN,A1,W									 
	addi	5,A1
	sll	16,A1
	movx	A0,A1
	clr	A6
	movi	PIMPINIT,A14	
	calla	ESINITLL
	clr	A0
	move	A0,*A8(OBLIPIMG),L

	calla	ClrVel
	calla	YFLP
	movi	PTALHIDE,A9	
	movk	1,A1
	jsrp	FRANIM
	SOUND1	CLENSND
	movi	PTALLOOK,A9	
	movk	1,A1
	jsrp	FRANIM

	SLEEP	20
CRM1X:
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELSUPP
	move	*A8(OPAL),A1,W
	move	A1,@CRIMEPAL,W
	CALLA	DELSOBJ
	retp
****************************************************************************

