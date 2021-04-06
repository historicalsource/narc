 	.FILE	'NARCHOOK.ASM'
	.TITLE	" <<< N  A  R  C  -- HOOKER >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

OOHSND1	.WORD	>F020|NINTEQ,>40,>80bA,0 ;Marilyn ooh
OOHSND2	.WORD	>F020|NINTEQ,>40,>80bb,0 ;Slow ooh
HELPSND	.WORD	>F021|NINTEQ,>60,>8037,0 ;SCREAM
MOAN	.WORD	>F060,>60,>80CF,0	 ;death by bullet

*
*EXTERNALS
	.GLOBL	HEADBUTT
	.GLOBAL	LOFDEXP,LOFDEXP1,LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,LOFDFLA
	.GLOBAL	LOFDROCK,LDEXP1

; To change from Delta movement to skaters, check the following
;	call to Zoff
;	animation scripts for walkslow, walkmed, walkfast
;	velocity set in functions goslow, gomed, gofast

***************************************************************************
; HOOK SUB_TYPES
; 0 - w/ no coors starts at PLZMIN and 1 to 2 full screens away from
;	players in X.  90% chance of coming up to the right.
; 1 - w/ no coors comes out any available door, else it reverts to type 0
;15 - type 0, but has no collision vector for 1 second
DTBL:
	.long	D0,D1
	.long	D1,D1,D1,D1,D1,D1,D1
	.long	D1,D1,D1,D1,D1,D1,D15
***************************************************************************

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\mprocEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCTEQU.ASM"
	.include	"imgtbl.glo"
   	.INCLUDE	"NARCFRAG.GLO"

	.include	"narchook.tbl"

************************* FUNCTION TABLE ***************************
HK_FUNCS:
	.long	BOOF
	.long	GoDestD
	.long	GetXVel
	.long	>6000	;MaxXZAngle
	.long	60	;FlipTiks
********************************************************************

********************************************************************
;To catch a nulled dereference through HK_FUNCS
BOOF:	jruc	$
********************************************************************

********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in GVARINIT
	.BSS	hookmax,16,16		;U - max # of active hookmen
	.BSS	hookbrain,16,16	;U - tiks between brain funcs
	.BSS	hookflirt,16,16	;U - tiks between flirt funcs

VARINIT:
	movi	120,A1
	move	A1,@hookflirt,W
	movk	30,A1
	move	A1,@hookmax,W
	movi	15,A1
	move	A1,@hookbrain,W
	rets
**********************************************************

**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
HOOKINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	hkwlk1,HOOKZSIZ,HKCOLL
	.WORD	DMAWNZ,HOOKEOID
	.LONG	HOOKBLIP
**************************************************************************

**************************************************************************
HOOKCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT
	
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
	CREATE	HOOKEPID,HOOKER	;allocate process?	(bashes A1,A7)
	jrz	ColdX
	dsjs	A2,ColdLp
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

*********************  START OF HOOKER PROCESS  *************************
HOOKER:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

MaxWait:
	;* clown drops must come out..
	move	A11,A0
	sll	28,A0
	srl	28,A0
	cmpi	15,A0
	jrz	MaxWaitX

	move	@hookmax,A0,W
	move	@HOOKCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	INCW	@HOOKCNT

	move	A11,A0
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	DTBL,A0
	move	*A0,A0,L
	jump	A0

**************************************************************************
D15:
;indestructible hooker
	CREATE	HOOKEPID,HkSetCol	;(bashes A1,A7)
	move	A13,*A0(ETEMP1),L
	jruc	D0

HkSetCol:
;* Process to wait before setting hookers collision vector
	SLEEP	36
	move	*A13(ETEMP1),A0,L
	calla	GETA8
	jrz	NoHk
	move	*A8(OID),A0,W
	zext	A0,W
	cmpi	HOOKEOID|15,A0
	jrnz	NoHk
	movi	HKCOLL,A0
	move	A0,*A8(OCVECT),L
NoHk:
	DIE
**************************************************************************

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
	CREATE 	0E1H,CLOZDOOR		;CLOSE THE DOOR
	movi	HOOKINIT,A14
	calla	DOORRITE	;rets upper Y,X start pos in A1
	movi	HKTAB,A6
	mmtm	SP,A11
	calla	ESINITUL	;CREATE HOOK
	mmfm	SP,A11
	jrz	HOOK_DIE	;CREATE BOMBED

	move	A11,*A8(OID),W
	move	A8,A0
***	calla	DELSHAD
	movi	->10000,A2	;X VELOCITY
	movi	WALKOUT,A9     	;GET ANIMATION SCRIPT
	JSRP	OUTDOOR
	move	A8,A0
***	calla	SHADST
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
	move	@PLYMIN,A0,W									 
	sll	16,A0
	movy	A0,A9	;* initial position							 
	clr	A10

GotCoors:
	move	A9,A1
	movi	HKTAB,A6
	movi	HOOKINIT,A14	
	mmtm	SP,A9,A10,A11
	calla	ESINITLL		;CREATE HOOK
	mmfm	SP,A9,A10,A11
	jrz	HOOK_DIE
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
	sll	28,A11
	srl	28,A11
	cmpi	15,A11
	jrnz	SkNilCol
	movi	DUMCOLL,A0
	move	A0,*A8(OCVECT),L
SkNilCol:
;	jruc	InitEnmy


****************************************************************************
InitEnmy:
	calla	ClrVel
	clr	A0
	move	A0,*A13(FLIRTING),W
	move	A0,*A13(DEST),L
	move	A0,*A13(TEMPDEST),L
	movb	A0,*A13(DEST_TAG)
	movb	A0,*A13(ZPER)
	move	A0,*A13(WANTOBJ),L
	move	A0,*A13(TIKCTRS),L
	move	A0,*A13(EBYTES),L
	movb	A0,*A13(GOOSETIK)
	movk	6,A0
	calla	RANDU
	addk	2,A0
	movb	A0,*A13(GOOSECNT)

	movi	HK_FUNCS,A0
	move	A0,*A13(FUNCS),L

	move	*A8(OID),A0,W
	andi	>F,A0
	cmpi	>F,A0
	jrnz	SkTits
	callr	ZCHECK
	movi	HK_TITS,A9
	movk	1,A1
	jsrp	FRANIM
SkTits:

	movi	HK_WALK,A0
	move	A0,*A13(ANIMPTR),L

	jruc	HK_MOVE
**************************************************************************

**************************************************************************
HK_XCHECK:
	move	@SCRNLR,A2,W		;GET SCREEN RT.
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

	cmp	A2,A0			;IS IT PAST THE RT?
	jrgt	OffRite

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	move	*A8(OSIZE),A1,W
	add	A0,A1			;RIGHT EDGE OF OBJECT
	cmp	A2,A1
	jrlt	OffLeft
	clrc
	rets

OffRite:
	calla	T_YFLP
	setc
	rets

OffLeft:
	calla	T_NOYFLP
	setc
	rets
**************************************************************************


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
	movb	A0,*A13(ZPER)
ZMaxOK:
	rets
**************************************************************************

**************************************************************************
HK_MOVE:
;********  CHECK if a DESTINATION has been reached, and what to do if so..
	callr	ZCHECK

	movb	*A13(GOOSETIK),A1
	jrz	SkGoose
	movb	A1,*A13(BRAINTIKS)
	movb	A1,*A13(FLIRTTIKS)		;reset flirt wait
	calla	ClosestP
	calla	FACEOBJ
	clr	A0
	movb	A0,*A13(DEST_TAG)
	move	A0,*A13(FLIRTING),W
	jruc	AniCk
SkGoose:

	move	*A13(FLIRTING),A1,W
	jrz	SkFlirt
	cmpi	100,A1
	jrlt	SetBT
	movi	100,A1
SetBT:
	movb	A1,*A13(BRAINTIKS)
	clr	A0
	movb	A0,*A13(DEST_TAG)
	jruc	AniCk
SkFlirt:

	movb	*A13(DEST_TAG),A0
	jrz	SkCkDest			;* No Destination

	movb	*A13(DESTTIKS),A0
	jrnz	SkCkDest
	calla	CkDest
	jrnc	NotYet

	;* we have reached our destination, what to do??

	cmpi	BULL_T,A0
	jrnz	SkBULL_D
	jruc	DestDone
SkBULL_D:
	cmpi	LEAN_T,A0
	jrnz	SkBUST_D
	callr	DoLean
	jruc	DestDone
SkBUST_D:
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
	move	@hookbrain,A0,W
	movb	A0,*A13(BRAINTIKS)		;reset brain wait

;	movb	*A13(DEST_TAG),A0
;	cmpi	BULL_T,A0
;	jrge	BrainX
;	callr	CkDngr

	movb	*A13(DEST_TAG),A0
	cmpi	LEAN_T,A0
	jrge	BrainX
	callr	LeanHunt

	movb	*A13(DEST_TAG),A0
	cmpi	DFLT_T,A0
	jrge	BrainX
	callr	GoWalk
	callr	DfltDest
BrainX:


**** FLIRT functions *****
	movb	*A13(FLIRTTIKS),A0
	jrnz	FlirtX
	move	@hookflirt,A0,W
	movb	A0,*A13(FLIRTTIKS)		;reset flirt wait

	callr	HK_XCHECK
	jrc	FlirtX

	movi	400,A0
	calla	RANDPER
	jrnc	FlirtX

	movb	@RAND,A0
	jrn	SkBeck
	callr	Beckon
    	jruc	FlirtX
SkBeck:
	callr	Loiter
FlirtX:


**** Animation check ****
AniCk:
	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX

	calla	ZOFF
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrnz	ListLeft
	callr	AnimCycle
ListLeft:
	movb	A0,*A13(ANIMTIKS)
AnimX:

**** Find Next Event ****
	movi	>FF,A7
	movb	*A13(BRAINTIKS),A1
	and	A7,A1
	jrnz	BTok
;	jruc	$
	movk	2,A1
	movb	A1,*A13(BRAINTIKS)
BTok:
	movb	*A13(ANIMTIKS),A3
	and	A7,A3
	jrnz	ATok
;	jruc	$
	movk	2,A3
	movb	A3,*A13(ANIMTIKS)
ATok:
	movb	*A13(FLIRTTIKS),A4
	and	A7,A4
	jrnz	FTok
;	jruc	$
	movk	2,A4
	movb	A4,*A13(FLIRTTIKS)
FTok:
	movb	*A13(DEST_TAG),A0
	jrnz	SkNoDest
	move	A1,A6
	jruc	SkMin1
SkNoDest:
	movb	*A13(DESTTIKS),A2
	and	A7,A2
	jrnz	SkMinDst
	movk	1,A2
SkMinDst:

	move	A2,A6
	cmp	A6,A1
	jrge	SkMin1
	move	A1,A6
SkMin1:
	cmp	A6,A3
	jrge	SkMin3
	move	A3,A6
SkMin3:
	cmp	A6,A4
	jrge	SkMin4
	move	A4,A6
SkMin4:

	movb	*A13(DEST_TAG),A0
	jrz	SkDestDc
	sub	A6,A2
	movb	A2,*A13(DESTTIKS)
SkDestDc:
	sub	A6,A1
	movb	A1,*A13(BRAINTIKS)
	sub	A6,A3
	movb	A3,*A13(ANIMTIKS)
	sub	A6,A4
	movb	A4,*A13(FLIRTTIKS)

	movb	*A13(FLIPTIKS),A1
	jrz	SkFlipDc
	and	A7,A1	;No o' this sign extended byte shit
	cmp	A6,A1
	jrge	SkClrFlp
	move	A6,A1
SkClrFlp:
	sub	A6,A1
	movb	A1,*A13(FLIPTIKS)
SkFlipDc:

	movb	*A13(GOOSETIK),A1
	jrz	SkGoosDc
	cmp	A6,A1
	jrge	SkClrGse
	move	A6,A1
SkClrGse:
	sub	A6,A1
	movb	A1,*A13(GOOSETIK)
SkGoosDc:

	move	*A13(FLIRTING),A1,W
	jrz	SkFlrtDc
	cmp	A6,A1
	jrge	SkClrFlrt
	move	A6,A1
SkClrFlrt:
	sub	A6,A1
	move	A1,*A13(FLIRTING),W
SkFlrtDc:

	move	A6,A0
	jrp	Slp
;	jruc	$
	movk	2,A0
Slp:
	calla	PRCSLP

	jruc	HK_MOVE
**************************************************************************

************************** Animation Cycler ******************************
AnimCycle:
;Resets animation loop
	move	*A13(ANIMPTR),A9,L
	rets
**************************************************************************

**************************** GetXVel *************************************
GetXVel:
	move	*A13(ANIMPTR),A0,L
	cmpi	HK_WALK,A0
	jrnz	NoXvel
	movi	>8000,A0
	zext	A0,W
	jruc	GotXvel
NoXvel:
	clr	A0
GotXvel:
	rets
**************************************************************************

***************************** GoWalk *************************************
GoWalk:
	mmtm	SP,A0
	cmpi	MOVETBL,A9
	jrlt	StrtWalk
	cmpi	MOVEEND,A9
	jrge	StrtWalk
	
	jruc	GoWalkX

StrtWalk:
	movi	HK_WALK,A0
	move	A0,*A13(ANIMPTR),L
	move	A0,A9

	;* set veloctiy for skaters
;	move	*A8(OFLAGS),A0,W
;	btst	B_FLIPH,A0
;	jrz	VelPos2
;	movi	-WALKVEL,A0
;	jruc	SetXV2
;VelPos2:
;	movi	WALKVEL,A0
;SetXV2:
;	move	A0,*A8(OXVEL),L

GoWalkX:
	mmfm	SP,A0
	rets
**************************************************************************

*****************************  Evade Bust  *******************************
EvadeBust:
	calla	ClosestP

	move	*A0(OXPOS),A1		;if too far away in X don't evade
	move	*A8(OXPOS),A2
	sub	A1,A2
	abs	A2
	cmpi	100,A2
	jrgt	EvadeX

	move	*A0(OZPOS),A1		;if too far away in Z don't evade
	move	*A8(OZPOS),A2
	sub	A1,A2
	abs	A2
	cmpi	50,A2
	jrgt	EvadeX

	;* player is too close - RUN AWAY!!
	callr	GoWalk
	calla	FleeObj
	movk	BUST_T,A0
	movb	A0,*A13(DEST_TAG)
EvadeX:
	rets
**************************************************************************


************************  Default Destination  ***************************
DfltDest:
	;* generate random x position on screen
	move	@SCRNTL,B0,W		;GET SCREEN LEFT
	move	@SCRNLR,B1,W		;GET SCREEN RT.
	calla	RANGRAND
	move	@WORLDTL,A1,W
	add	A0,A1			;ADD TO WORLD BASE

	;* generate random y position on playfield
	move	@PLZMIN,B0,W		;GET top
	move	@PLZMAX,B1,W		;GET bot
	add	B0,B1
	srl	1,B1				;only on top half
	calla	RANGRAND

	sll	16,A0
	movy	A0,A1
	move	A1,*A13(DEST),L

	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	rets
**************************************************************************

*************************  Lean Hunt  ************************************
LeanHunt:
	move	@BACKSLST,A4,L
	jrz	NO_LEAN
	movi	BGLID,A1
LScanLp:
	move	*A4(OID),A0,W
	cmp	A1,A0
	jrnz	LScanX
	movk	3,A0
	calla	RANDU
	dec	A0
	jrnz	LScanX
	jreq	GotLObj
LScanX:
	move *A4(OSLINK),A4,L
	jrnz	LScanLp
	jruc	NO_LEAN

GotLObj:
	move	A4,A0
	move	A0,*A13(WANTOBJ),L
	calla	HuntObj
	callr	GoWalk
	movk	5,A0
	movb	@RAND,A1		;select side to lean on
	jrn	SKnegD
	subk	15,A0
SKnegD:
	calla	ShortXDest
	move	*A13(DEST+16),A1,W		;Get Z part of Dest - go in front of Pole
	addk	2,A1
	move	A1,*A13(DEST+16),W

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	LEAN_T,A0
	movb	A0,*A13(DEST_TAG)
NO_LEAN:
	rets
**************************************************************************

***************************** Do Lean ************************************
DoLean:
	move	*A13(WANTOBJ),A0,L
	calla	FACEAWAY
	movi	HK_LEAN1,A9
	move	A9,*A13(ANIMPTR),L
	movi	281,A0
	move	A0,*A13(FLIRTING),W
	movi	100,A0
	movb	A0,*A13(BRAINTIKS)
	rets
**************************************************************************

***************************** Loiter ************************************
Loiter:
	movi	180,A0
	calla	RANDU
	addi	90,A0
	move	A0,*A13(FLIRTING),W
	movi	HK_STAND1,A9
	movb	@RAND,A0
	jrn	SkHair
	movi	HK_HAIR1,A9
SkHair
	move	A9,*A13(ANIMPTR),L
	rets
**************************************************************************

***************************  Beckon  *************************************
Beckon:
	movi	180,A0
	calla	RANDU
	addi	90,A0
	move	A0,*A13(FLIRTING),W
	movi	HK_CALL,A9
	move	A9,*A13(ANIMPTR),L
	rets
**************************************************************************

***************************** CHECK DANGER *******************************
* if Hooker is in danger of being shot, dodge
CkDngr:
	calla	NEAR_BUL
	move	A5,A5	;is there a closest bullet
	jrz	NoDngr

	move	*A8(OYPOS),A1,W
	move	*A8(OSIZEY),A2,W
	srl	1,A2		;want to find belly
	subk	20,A2	;* encourage jumping
	add	A2,A1
	move	*A5(OYPOS),A3,W
	sub	A3,A1
	jrn	BULL_LOW
	;* bullet heading at head
	cmpi	400,A6	;is bullet near?
	jrgt	JRDNGRX

	;* bullet is near - move down, down and away!
	callr	GoWalk

	;* find Z destination
	move	*A8(OZPOS),A1,W
	movk	30,A0
	calla	RANDU
	addk	15,A0
	add	A1,A0
	move	@PLZMAX,A1,W
	cmp	A0,A1
	jrlt	ZisGood
	move	@PLZMIN,A0,W
	sub	A0,A1
	srl	1,A1
	add	A1,A0
ZisGood:
	move	A0,A1
	sll	16,A1	;A1 is z portion of destination

	;* generate X destination
	movk	30,A0
	calla	RANDU
	addk	30,A0		;A0 is magnitude of X distance to run away
	move	*A5(OXVEL+16),A2,W		;Get sign of Bullets velocity
	jrp	XdirOK
	neg	A0
XdirOK:
	move	*A8(OXPOS),A2,W
	add	A0,A2
	movy	A1,A2
	move	A2,*A13(DEST),L

	movk	BULL_T,A0
	movb	A0,*A13(DEST_TAG)

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	jruc	JRDNGRX

BULL_LOW:
	;* bullet heading at feet
	cmpi	400,A6	;is bullet near?
	jrgt	JRDNGRX

	;* bullet is near - move up, up and away
	callr	GoWalk

	;* find Z destination
	move	*A8(OZPOS),A1,W
	movk	30,A0
	calla	RANDU
	addk	15,A0
	sub	A0,A1
	move	@PLZMIN,A0,W
	cmp	A0,A1
	jrgt	ZisGood2
	move	@PLZMAX,A1,W
	sub	A0,A1
	srl	1,A1
	add	A0,A1
ZisGood2:
	sll	16,A1	;A1 is z portion of destination

	;* generate X destination
	movk	30,A0
	calla	RANDU
	addk	30,A0		;A0 is magnitude of X distance to run away
	move	*A5(OXVEL+16),A2,W		;Get sign of Bullets velocity
	jrp	XdirOK2
	neg	A0
XdirOK2:
	move	*A8(OXPOS),A2,W
	add	A0,A2
	movy	A1,A2
	move	A2,*A13(DEST),L

	movk	BULL_T,A0
	movb	A0,*A13(DEST_TAG)

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

JRDNGRX:
NoDngr:
	rets
**************************************************************************

**************************************************************************
HK_DONE:
	MOVE	A8,A0		;GET THE POINTER TO THE OBJECT
	calla	DELENEMY			;DELETE THE ENEMY
HOOK_DIE:
	DECW	@HOOKCNT
	DIE
**************************************************************************


**************************************************************************
*WALKING HOOK, AS OBJECT 0, COLLSION ROUTINE
*A0 = PTR TO JR OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
HKCOL0
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
	
	MOVI	0EDh,A1
	MOVI	WENDIE,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	jrz	SkDie
	MOVE	*A6(ODMAXY),*A0(PDATA),L	;PASS KILLERS DMA XY POSITION
	MOVE	*A6(OSIZE),*A0(PDATA+20H),L	;AND KILLERS XY SIZE
	move	*A14(EBCNTRS),*A0(EBCNTRS),L	;and the booty counters
	MOVE	*A14(EMAINT),*A0(EMAINT),L

	move	*A6(OYPOS),A9,W
	MOVI	0EDh,A1
	movi	SPLATANI,A7
	CALLA	GETPRC

	movi	MOAN,A0
	calla	ONESND

SkDie:
	DECW	@HOOKCNT

	CLRC		;Don't delete in Coll routine
	RETS
*************************************************************************

*************************************************************************
HKCOLL:
	.WORD	B1OID|BULLETID
	.LONG	HKCOL0
	.WORD	B2OID|BULLETID
	.LONG	HKCOL0
	.WORD	P1OID
	.LONG	PlyrCol1
	.WORD	P2OID
	.LONG	PlyrCol2

	.WORD	0
	.LONG	DUMRTSG			;THE BUCK STOPS HERE BUDDY!

	.WORD	B1OID|EXPLODID
	.LONG	HKCOL0
	.WORD	B1OID|ROCKETID
	.LONG	HKCOL0
	.WORD	B2OID|BULLETID
	.LONG	HKCOL0
	.WORD	B2OID|EXPLODID
	.LONG	HKCOL0
	.WORD	B2OID|ROCKETID
	.LONG	HKCOL0
	.WORD	0
	.LONG	DUMRTSG

;WALKING JUMPING DEATH FRAGMENT STANDING-SHOOT KNEELING-SHOOT
;STANDING KNEELING

HKOFF	.WORD	1,3,4,9,18,34,50,50
*THE JR ENEMY, ANIMATION PTR TABLE, FIRST LONG WORD IS THE OFFSET PTR
*
HKTAB	.LONG	HKOFF
	.LONG	HK_WALK,HK_WALK,JRJLR,HK_DIE,HK_DIE,LOFDEXP,LOFDEXP1,LOFDROCK

	.LONG	LOFRAG1,LOFRAG2,LOFRAG2,LOFRAG3
	.LONG	LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,0
*************************************************************************

*************************************************************************
;* A0 ptr to hooker obj
PlyrCol1:
	movi	P1DATA,A2
	jruc	PlyrCol
PlyrCol2:
	movi	P2DATA,A2
PlyrCol:
	move	*A2(PFLAGS),A1,L
	btst	BDEAD,A1
	jrnz	NoGoose

	move	*A0(OPLINK),A7,L

	movb	*A7(GOOSECNT),A1
	jrp	GooseLft

	;*** HOOKER IS GOOSED OUT
	movb	*A7(GOOSETIK),A0
	cmpi	10,A0
	jrgt	NoDam

	move	@PIMPCNT,A0
	jrnz	SkHelp
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
	clr	A5
	clr	A6
	movi	>00100000|PIMPEOID|1,A14
	calla	PIMPCOLD
	movi	HELPSND,A0
	calla	ONESND
SkHelp:

	move	A7,A0
	calla	GETA9
	cmpi	HK_FIGHT,A9
	jrlt	StrtFght
	cmpi	HK_FIGHTX,A9
	jrgt	StrtFght

;	movi	30,A0
;	calla	RANDPER
;	jrnc	NoDam
;	calla	HEADBUTT

	jruc	NoDam

StrtFght:
	movi	HK_FIGHT,A9
	move	A9,*A7(ANIMPTR),L
	move	A7,A0
	calla	PUTA9

	movi	30,A0
	movb	A0,*A7(GOOSETIK)
NoDam:	
	rets


GooseLft:
	movb	*A7(GOOSETIK),A0
	jrp	NoGoose
	dec	A1
	movb	A1,*A7(GOOSECNT)
	jrz	Snd2
	movi	OOHSND1,A0
	jruc	GotSnd
Snd2:
	movi	OOHSND2,A0
GotSnd:
	calla	ONESND

	move	A7,A0
	calla	GETA9
	cmpi	HK_GOOSE,A9
	jrlt	StrtGoos
	cmpi	HK_GOOSEX,A9
	jrgt	StrtGoos
	jruc	SkGoos

StrtGoos:
	movi	HK_GOOSE,A9
	move	A9,*A7(ANIMPTR),L
	move	A7,A0
	calla	PUTA9
SkGoos:
	movi	>250,A1
	calla	SCORE
	movi	90,A0
	movb	A0,*A7(GOOSETIK)
NoGoose:
	rets
*************************************************************************

**************************************************************************
* HOOKER FRAME TABLES	
* NORMAL TABLE ENTRY:
* 	AFRAME	FRAME,SLEEPT,CONTROL_WORD
* FIRE FRAME TABLE ENTRY:		    
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW

WALKVEL	.set	>8000
MOVETBL:
HK_WALK:	  ;* sleep is 200% of delta
	.long	hkwlk1
	.word	DELTAXZ|10,5
	.long	hkwlk2
	.word	DELTAXZ|9,3
	.long	hkwlk3
	.word	DELTAXZ|10,5
	.long	hkwlk4
	.word	DELTAXZ|9,4
	.long	hkwlk5
	.word	DELTAXZ|10,5
	.long	hkwlk6
	.word	DELTAXZ|9,3
	.long	hkwlk7
	.word	DELTAXZ|11,7
	.long	hkwlk8
	.word	DELTAXZ|11,7
	.long	hkwlk9
	.word	DELTAXZ|9,5
	LONGNULL
MOVEEND:

WALKOUT:
	.long	hkwlk1
	.word	10
	.long	hkwlk2
	.word	9
	.long	hkwlk3
	.word	10
	.long	hkwlk4
	.word	9
	.long	hkwlk5
	.word	10
	.long	hkwlk6
	.word	9
	.long	hkwlk7
	.word	11
	.long	hkwlk8
	.word	11
	.long	hkwlk9
	.word	9
	LONGNULL

HK_STAND1:
	.long	hkpose1
	.word	15
	.long	hkpose2
	.word	15
	.long	hkpose3
	.word	20
	.long	hkpose2
	.word	15
HK_HAIR1:
	.long	hkpose9
	.word	10
	.long	hkpose8
	.word	10
	.long	hkpose7
	.word	10
	.long	hkpose6
	.word	20
	.long	hkpose7
	.word	10
	.long	hkpose6
	.word	10
	.long	hkpose7
	.word	10
	.long	hkpose8
	.word	10
	LONGNULL

HK_CALL:
	.long	seduc7
	.word	12
	.long	seduc3
	.word	12
	.long	seduc4
	.word	12
	.long	seduc5
	.word	18
	.long	seduc4
	.word	12
	.long	seduc5
	.word	25
	.long	seduc6
	.word	12
	LONGNULL

HK_REACH:
	.long	seduc7
	.word	20
	.long	seduc2
	.word	40
	.long	seduc7
	.word	20
	LONGNULL

HK_TITS:
	.long	seduc8
	.word	12
	.long	seduc9
	.word	12
	.long	seduc8
	.word	12
	.long	seduc9
	.word	12
	.long	seduc11
	.word	12
	.long	seduc9
	.word	12
	.long	seduc11
	.word	12
	.long	seduc13
	.word	12
	.long	seduc14
	.word	12
	.long	seduc13
	.word	12
	.long	seduc14
	.word	12
	.long	seduc13
	.word	12
	.long	seduc14
	.word	12
	LONGNULL


HK_GOOSE:
	.long	seduc8
	.word	12
	.long	seduc9
	.word	12
	.long	seduc11
	.word	12
	.long	seduc9
	.word	12
	.long	seduc11
	.word	12
	.long	seduc13
	.word	12
	.long	seduc14
	.word	12
	LONGNULL
HK_GOOSEX:


HK_FIGHT:
	.long	hkfgt8
	.word	6
	.long	hkfgt7
	.word	6	
	.long	hkfgt8
	.word	6
	.long	hkfgt7
	.word	6
	.long	hkfgt5
	.word	6
	.long	hkfgt6
	.word	6
	.long	hkfgt4
	.word	6
	.long	hkfgt6
	.word	6
	.long	hkfgt5
	.word	6
	.long	hkfgt6
	.word	6
	.long	hkfgt4
	.word	6
	.long	hkfgt6
	.word	6
	.long	hkfgt5
	.word	6
	.long	hkfgt7
	.word	6
	.long	hkfgt8
	.word	6
	LONGNULL
HK_FIGHTX:

HK_DIE:
	.long	hkdie1
	.word	7
	.long	hkdie2
	.word	7
	.long	hkdie3
	.word	7
	.long	hkdie4
	.word	7
	.long	hkdie5
	.word	7
	.long	hkdie6
	.word	7
	LONGNULL

HK_LEAN1:
	.long	hook1
	.word	12
	.long	hook2
	.word	20
	.long	hook1
	.word	20
	.long	hook2
	.word	20
	.long	hook3
	.word	30
	.long	hook2
	.word	20
	.long	hook3
	.word	15
	.long	hook4
	.word	45
	.long	hook3
	.word	25
	.long	hook4
	.word	40
	.long	hook3
	.word	12
	.long	hook2
	.word	12
	.long	hook1
	.word	10
	LONGNULL

JRJLR
JRSD
JRSL
JRNUL
	.LONG	0

