 	.FILE	'NARCHYPO.ASM'
	.TITLE	" <<< N  A  R  C  -- J.R. HYPOMAN >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

; To change from Delta movement to skaters, check the following
;	funcs tbl GoDestD to GoDestV
;	call to Zoff
;	animation scripts for walkslow, walkmed, walkfast
;	velocity set in functions goslow, gomed, gofast


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
	.include	"narchypo.tbl"
	.include	"narchypo.glo"

	.GLOBL	HYPOCRM1

*
*EXTERNALS
	.GLOBAL	LOFDEXP,LOFDEXP1,LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,LOFDFLA
	.GLOBAL	LOFDROCK,LDEXP1

	.bss	hypocol,16,1

;EXTRA OBJECT VARS
HEADOBJ	.set	>0	;long, ptr to Head object block, 0->no Head
SFIRTIKS .set	>20	;"spinning fire" word ctr
MODE	.set	>30	;current Action - byte
LIFECTR	.set	>40	;WORD
sfirrate .set  	>50	;word
firerate .set	>60	;word

;* values for MODE field
NoMode	.set	0
MStop	.set	1
MStand	.set	2
MCharge	.set	3
MBkwrd	.set	4
MRun	.set	5
MThrow	.set	6
MDrug	.set	7


********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in GVARINIT
;	.BSS	hypomax,16,16		;U - max # of active hypomen
;	.BSS	hypodrug,16,16		;U - chance/1000 of hypoman having drugs
;	.BSS	hypobrain,16,16		;U - sleep between homing on players
;	.BSS	hypofire,16,16		;U - time between regular shots
;	.BSS	hyposfir,16,16		;U - time between spinners

	.TEXT
VARINIT:
	rets		   ;* <---------------------- remove ;
	movi	3,A0
	move	A0,@hypomax,W
	movi	350,A0
	move	A0,@hypodrug,W
	movi	9,A0
	move	A0,@hypobrain,W
	movi	393,A0
	move	A0,@hyposfir,W
	movi	125,A0
	move	A0,@hypofire,W
	rets
**********************************************************

***************************************************************************
; HYPO SUB_TYPES
; 0 - w/ no coors starts at PLZMIN and 1 to 2 full screens away from
;	players in X.  90% chance of coming up to the right.
; 1 - w/ no coors comes out any available door, else it reverts to type 0
;
; 2 - Type 0, but also can throw spinners
; 3 - Type 1, but also can throw spinners
; 4-7 same as types 0-3 but easier (don't duck or jump)
DTBL:
	.long	D0,D1,D2,D3
	.long	D0,D1,D2,D3
	.long	D1,D1,D1,D1,D1,D1,D1,D1
***************************************************************************

************************* FUNCTION TABLE ***************************
JR_FUNCS:
	.long	BOOF
	.long	GoDestV
	.long	GetXVel
	.long	>B000	;MaxXZAngle
	.long	30	;FlipTiks
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
JRINIT:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	JRW1,JRZSIZ,DUMCOLL
	.WORD	DMAWNZ,HYPOEOID
	.LONG	HYPOBLIP
HeadInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	JRHEAD1,JRZSIZ,JRCOLL
	.WORD	DMAWNZ,HYPOEOID
	.LONG	0
**************************************************************************

**************************************************************************
;FRANCHEK:
;	cmpi	FRANMIN,A9
;	jrlt	$
;	cmpi	FRANMAX,A9
;	jrgt	$
;	rets
**************************************************************************

**************************************************************************
HYPOCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT
	
	move	@SLPHYPOS,A0,W
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
	CREATE	HYPOEPID,HYPOMAN ;allocate process?	(bashes A1,A7)
	jrz	ColdX
	dsjs	A2,ColdLp
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

**************************************************************************
CkPal:
	move	@hypocol,A0,W
	jrz	CkPalX
	sll	5,A0
	addi	HYPOPALS,A0
	move	*A0,A0,L
	calla	GETFPAL
	jrz	CkPalX
	move	A0,A1
	move	*A8(OPAL),A0,W
	calla	FREEPAL
	move	A1,*A8(OPAL),W
CkPalX:
	rets
**************************************************************************

*********************  START OF HYPOMAN PROCESS  *************************
HYPOMAN:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

	INCW	@SLPHYPOS
MaxWait:
	move	@hypomax,A0,W
	move	@JRHYCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	DECW	@SLPHYPOS
	INCW	@JRHYCNT

	clr	A0
	move	A0,@hypocol,W

	move	A11,A0
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	DTBL,A0
	move	*A0,A0,L
	jump	A0

**************************************************************************
D3:
	movk	1,A0
	move	A0,@hypocol,W
D1:
;DISPATCH FROM A DOOR	
	move	A9,A0
	or	A10,A0
	jrnz	GotCoors
	movi	10,A0
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
	movi	JRINIT,A14
	calla	DOORRITE	;rets upper Y,X start pos in A1
	movi	[3,0],A6	;make sure hypo man is in front of door
	addxy	A6,A1
	movi	JRTAB,A6
	mmtm	SP,A11
	calla	ESINITUL	;CREATE HYPOMAN
	mmfm	SP,A11
	jrz	JR_DIE1		;CREATE BOMBED
	callr	CkPal

	move	A11,*A8(OID),W
	movi	->20000,A2	;X VELOCITY
	movi	WALKOUT,A9     	;GET ANIMATION SCRIPT
	JSRP	OUTDOOR
	jruc	InitEnmy


**************************************************************************
D2:
	movk	1,A0
	move	A0,@hypocol,W
D0:	
	move	A9,A0
	or	A10,A0
	jrnz	GotCoors

*Enemy object initialization
	move	@(WORLDTLX+16),A9,W				 
	subi	300,A9
	movi	950,A0
	calla	RANDPER
	jrnc	StrtLft
	addi	1000,A9
StrtLft:
	movi	150,A0
	calla	RANDU
	add	A0,A9

	move	@PLZMIN,A10,W									 
	move	@PLZMAX,A0,W									 
	sub	A10,A0
	calla	RANDU
	add	A0,A10	;* initial Z position							 

GotCoors:
	move	A9,A1
	movi	JRTAB,A6
	movi	JRINIT,A14	
	mmtm	SP,A9,A10,A11
	calla	ESINITLL		;CREATE HYPOMAN
	mmfm	SP,A9,A10,A11
	jrz	JR_DIE1		;create bombed
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

	callr	CkPal
;	jruc	InitEnmy


****************************************************************************
InitEnmy:
	;* allocate extra data space
	calla	GETOBJ
	jrz	JR_DIE2		
	move	A0,A10	;A10 will Always point to extra Data Space
	calla	CLROBJ

	calla	ClrVel
	clr	A0
	move	A0,*A13(COLLOBJ),L
	move	A0,*A13(DEST),L
	move	A0,*A13(TEMPDEST),L
	movb	A0,*A13(DEST_TAG)
;	movb	A0,*A13(ZPER)
	movb	A0,*A13(SNOOZE)
	movb	A0,*A13(FLIPTIKS)
	move	A0,*A13(WANTOBJ),L
	move	A0,*A13(TIKCTRS),L
	move	A0,*A13(EBYTES),L
	movi	JR_FUNCS,A0
	move	A0,*A13(FUNCS),L

	movk	3,A0
	calla	RANDU
	dec	A0
	sll	3,A0
	addi	StrtMode,A0
	movb	*A0,A0
	movb	A0,*A10(MODE)

	clr	A1
	move	*A8(OID),A0,W
	andi	2,A0
	jrz	DrgLp
	movk	3,A1
DrgLp:
	move	@hypodrug,A0,W
	calla	RANDPER
	jrnc	DrgX
	inc	A1
	cmpi	6,A1
	jrlt	DrgLp
DrgX:
	move	A1,A0
	jrz	NoDrg
	calla	ADDDRUGS
NoDrg:
	callr	SetFireR
	move	*A10(sfirrate),A0,W
	calla	RANDU
	move	A0,*A10(SFIRTIKS),W
	move	*A10(firerate),A0,W
	calla	RANDU
	move	A0,*A13(FIRETIKS),W
	
	movi	JRCOLL,A0
	move	A0,*A8(OCVECT),L

	clr	A9
	callr	GoMed

	jruc	HYPO_MV

StrtMode:
;	.byte	NoMode,NoMode,NoMode,NoMode
	.byte	NoMode,MStop,MCharge
;	.byte	MThrow
	.even
**************************************************************************

**************************************************************************
SetFireR:
	;* set rate of fire based on amt of drugs carried
	mmtm	SP,A0,A1
	movb	*A13(EDRUG),A1
	inc	A1
	move	@hyposfir,A0,W
	divu	A1,A0
	move	A0,*A10(sfirrate),W

	movb	*A13(EDRUG),A1
	inc	A1
	move	@hypofire,A0,W
	divu	A1,A0
	move	A0,*A10(firerate),W
	mmfm	SP,A0,A1
	rets
**************************************************************************


**************************************************************************
DelHead:
	mmtm	SP,A0,A1
	move	*A10(HEADOBJ),A0,L
	jrz	NoDelH
	movi	ENEMIES,A1
	calla	DELSUPP
	calla	DELSOBJ
	clr	A0
	move	A0,*A10(HEADOBJ),L
	setc
	jruc	DelHeadX
NoDelH:
	clrc
DelHeadX:
	mmfm	SP,A0,A1
	rets
**************************************************************************

**************************************************************************
GetHead:
;* rets CLRC if unable to get a Head.
	move	*A10(HEADOBJ),A0,L
	jrnz	GotHead
	movb	*A13(SNOOZE),A0		;don't need head to snooze
	jrnz	GotHead
	calla	GETOBJ
	jrz	NoHead
	move	A0,*A10(HEADOBJ),L
	movi	HeadInit,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	move	*A8(OPAL),*A0(OPAL),W

	;* Set coors of Head
	calla	GETANIXY
	move	*A0(OXVAL),A1,L	
	add	A3,A1
	move	A1,*A0(OXVAL),L
	move	*A0(OYVAL),A1,L	
	add	A2,A1
	move	A1,*A0(OYVAL),L
	move	*A8(OZVAL),*A0(OZVAL),L

	calla	INSOBJ
	movi	ENEMIES,A1
	calla	ADDSUPP
GotHead:
	setc
	rets
NoHead:
	clrc
	rets
**************************************************************************

**************************************************************************
GetHdF:
;select head frame
	calla	ClosestP
	move	*A0(OXPOS),A0,W
	move	*A8(OXPOS),A1,W
	movk	1,A2		;look frame selected
	sub	A1,A0
	cmpi	-150,A0
	jrle	GotHdF
	inc	A2
	cmpi	-50,A0
	jrle	GotHdF
	inc	A2
	cmpi	50,A0
	jrle	GotHdF
	inc	A2
	cmpi	150,A0
	jrle	GotHdF
	inc	A2
GotHdF:
	movk	3,A0
	calla	RANDU
	subk	2,A0
	add	A2,A0
	sll	6,A0
	movi	JRHEADS,A9
	add	A0,A9
;	callr	FRANCHEK
	rets
**************************************************************************

**************************************************************************
DoStop:
;* rets clrc if unable to stand
	movi	JRSTAND,A9
	movk	4,A1
	jsrp	FRANIM		;Put out Body

	callr	GetHead
	jrnc	NoStop
	calla	ClrVel
	calla	UpdShadV
	movk	30,A0
	movb	A0,*A13(DESTTIKS)

	move	*A10(HEADOBJ),A7,L
	jrz	SkHdAni
	callr	GetHdF
	movk	4,A1
	PUSHP	A8
	move	A7,A8
;	callr	FRANCHEK
	jsrp	FRANIM		;Put out Head
	PULLP	A8
SkHdAni:

	clr	A0
	movb	A0,*A13(DEST_TAG)
	movk	MStand,A0
	movb	A0,*A10(MODE)
	setc
	rets

NoStop:
	clrc
	rets
**************************************************************************

**************************************************************************
DoStand:
	movk	30,A0
	movb	A0,*A13(DESTTIKS)

	movi	100,A0
	calla	RANDPER
	jrnc	BeStill

	move	*A10(HEADOBJ),A7,L
	jrz	NoHdAni
	callr	GetHdF
	movk	4,A1
	PUSHP	A8
	move	A7,A8
;	callr	FRANCHEK
	jsrp	FRANIM		;Put out Head
	PULLP	A8
NoHdAni:

BeStill:
	rets
**************************************************************************

**************************************************************************
UnStand:
	mmtm	SP,A0
	calla	DelHead
	jrnc	UnStandX
	clr	A0
	movb	A0,*A13(ANIMTIKS)
UnStandX:
	mmfm	SP,A0
	rets
**************************************************************************

**************************************************************************
AnimRst:
	clr	A0
	movb	A0,*A10(MODE)
	movb	A0,*A13(DEST_TAG)
	movb	A0,*A13(BRAINTIKS)
	movb	A0,*A13(ANIMTIKS)
;	callr	FRANCHEK
	rets
**************************************************************************

**************************************************************************
CanFire:
;* rets setc if hypo can fire.
;* if ANIMPTR is not set, will have to choose one..
	mmtm	SP,A0,A1,A2,A3,A7
	calla	NEARPLYR	;Get disp obj of someone to shoot at
	jrnz	GotTarg
	calla	ClosestP
	jrz	CantFire
GotTarg:
	move	A0,A7
	move	*A7(OZPOS),A1,W
	move	*A8(OZPOS),A2,W
	sub	A2,A1
	abs	A1
	move	*A7(OXPOS),A3,W
	move	*A8(OXPOS),A2,W
	sub	A2,A3
	abs	A3
	srl	1,A3
	cmp	A3,A1
	jrgt	CantFire

	calla	CentDist
	cmpi	300,A0
	jrgt	CantFire

	move	A7,A0
	calla	FaceObj
	jrnc	CantFire

	move	A7,*A13(WANTOBJ),L
	mmfm	SP,A0,A1,A2,A3,A7
	setc
	rets

CantFire:
	mmfm	SP,A0,A1,A2,A3,A7
	clrc
	rets
**************************************************************************

**************************************************************************
Fire:
	callr	CanFire
	jrnc	FireX
	callr	UnStand
	movi	JRTH,A9
	movk	1,A1		;do whole script
	calla	ClrVel
	jsrp	FRANIM
	callr	AnimRst
FireX:
	retp
**************************************************************************

**************************************************************************
Sfire:
;* if ANIMPTR is not set, will have to choose one..
	calla	ClosestP	   	;Get disp obj of someone to shoot at
	move	*A0(OZPOS),A1,W
	move	*A8(OZPOS),A2,W
	sub	A2,A1
	abs	A1
	move	*A0(OXPOS),A3,W
	move	*A8(OXPOS),A2,W
	sub	A2,A3
	abs	A3
	srl	1,A3
	cmp	A3,A1
	jrgt	P_NO_SSH

	move	A0,*A13(WANTOBJ),L
	calla	FACEOBJ

	move	@RAND,A0,W		;SELECT way to fire
	jrn	DO_JUMP

	callr	UnStand

	movi	JRTH,A9,L
	move	*A8(OID),A1,W
	andi	2,A1
	jrz	SkSpn3
	movi	JRTHS,A9,L
SkSpn3:	

	movk	1,A1		;do whole script
	calla	ClrVel
	jsrp	FRANIM
	callr	AnimRst
P_NO_SSH:
	retp
**************************************************************************

**************************************************************************
DO_JUMP:
	calla	ShadOn

	calla	ClosestFP
	move	A0,*A13(WANTOBJ),L

	callr	UnStand
	calla	ClrVel
	movk	1,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkJLeft
	neg	A0
SkJLeft:
	move	A0,*A8(OXVEL+16),W
	calla	UpdShadV
	movi	->90000,A0
	move	A0,*A8(OYVEL),L

	move	*A13(COLLOBJ),A0,L
	jrz	SkXBump
	calla	FACEOBJ
	move	*A13(COLLOBJ),A0,L
	move	*A0(OXVEL),A0,L
	sra	1,A0
	move	*A8(OXVEL),A1,L
	add	A0,A1
	move	A1,*A8(OXVEL),L
SkXBump:

	movi	JRJMPTH,A9,L
	move	*A8(OID),A1,W
	andi	2,A1
	jrz	SkSpn2
	movi	JRJMPTHS,A9,L
SkSpn2:	

	movk	4,A1
	jsrp	FRANIM
JRFLY0:
	movk	1,A0
	calla	PRCSLP
	calla	DFRMGRND
	cmpi	30,A1
	jrgt	JRFLY1a
	move	*A8(OYVEL),A0,L
	jrp	JRFLY1a
	addi	>C000,A0
	move	A0,*A8(OYVEL),L
	jruc	JRFLY0
JRFLY1a:
	movk	4,A1
	jsrp	FRANIM	   ;* throw it
JRFLY1:
	movk	1,A0
	calla	PRCSLP
	calla	DFRMGRND
	cmpi	55,A1
	jrgt	JRFLY2a
	move	*A8(OYVEL),A0,L
	jrp	JRFLY2a
	addi	>A000,A0
	move	A0,*A8(OYVEL),L
	jruc	JRFLY1
JRFLY2a:
	movk	4,A1
	jsrp	FRANIM
JRFLY2:
	movk	1,A0
	calla	PRCSLP
	move	*A8(OYVEL),A0,L
	addi	>A000,A0
	move	A0,*A8(OYVEL),L
	jrn	JRFLY2
;* Peak altitude hit
JRFLY3a:
	movk	4,A1
	jsrp	FRANIM
JRFLY3:
	movk	1,A0
	calla	PRCSLP
	calla	DFRMGRND
	cmpi	50,A1
	jrlt	JRFLY4a
	move	*A8(OYVEL),A0,L
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	jruc	JRFLY3
JRFLY4a:
	movk	4,A1
	jsrp	FRANIM
JRFLY4:
	movk	1,A0
	calla	PRCSLP
	move	*A8(OYVEL),A0,L
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	calla	DFRMGRND
;	subk	5,A1
	jrp	JRFLY4

;* we have hit the ground..
	calla	ShadOff
	calla	ClrVel
	move	A8,A0
	calla	SETZPOS
	callr	AnimRst
	clr	A0
	move	A0,*A13(COLLOBJ),L
	retp
**************************************************************************

**************************************************************************
JR_XCHECK:
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	move	@SCROLLX,A1,W
	sra	12,A1	
	jrn	SkLftAdj
	add	A1,A2
SkLftAdj:
	cmp	A2,A0
	jrlt	OffLeft

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	move	A1,A1
	jrp	SkRgtAdj
	add	A1,A2
SkRgtAdj:
	move	*A8(OSIZEX),A1,W
	add	A1,A0			;RIGHT EDGE OF OBJECT
	cmp	A2,A0			;IS IT PAST THE RT?
	jrgt	OffRite

	clrc
	rets

OffRite:
OffLeft:
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
ZMaxOK:
	rets
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
	movb	*A10(MODE),A0
	cmpi	MStand,A0
	jrnz	CkXDISTX
	callr	DelHead
	jruc	CkXDISTX
DeepRght:
	movb	*A13(SNOOZE),A0
	jrnz	CkXDISTX
	movk	1,A0
	movb	A0,*A13(SNOOZE)
	movb	*A10(MODE),A0
	cmpi	MStand,A0
	jrnz	CkXDISTX
	callr	DelHead
	jruc	CkXDISTX
NearRght:
	clr	A0
	movb	A0,*A13(SNOOZE)
	movb	*A10(MODE),A0
	cmpi	MStand,A0
	jrnz	CkXDISTX
	callr	GetHead
	jruc	CkXDISTX
NearLeft:
	clr	A0
	movb	A0,*A13(SNOOZE)
	movb	*A10(MODE),A0
	cmpi	MStand,A0
	jrnz	CkXDISTX
	callr	GetHead
;	jruc	CkXDISTX
CkXDISTX:
	RETP
**************************************************************************

**************************************************************************
CkQuit:
	move	@SLPHYPOS,A0,W
	jrz	CkQuitX
	jruc	JR_DONE
CkQuitX:
	RETP
**************************************************************************

**************************************************************************
HYPO_MV:
	callr	ZCHECK

	move	*A13(COLLOBJ),A0,L
	jrz	NOCOLL
	jsrp	DO_JUMP
NOCOLL:

;********  CHECK if a DESTINATION has been reached, and what to do if so..
	movb	*A13(DEST_TAG),A0
	jrz	SkCkDest
	movb	*A13(DESTTIKS),A0
	jrnz	SkCkDest
	calla	CkDest
	jrnc	NotYet

	;* we have reached our destination, what to do??
	movb	*A13(DEST_TAG),A0
SkBUST_D:
	cmpi	DRUG_T,A0
	jrnz	SkDRUG_D
	jsrp	GRAB
;	jruc	DestDone
SkDRUG_D:
DestDone:
	clr	A0
	movb	A0,*A13(BRAINTIKS)	;Allow new course of action
	movb	A0,*A13(DEST_TAG)
NotYet:
SkCkDest:

	movb	*A13(SNOOZE),A0
	jrnz	SkFire
**** Fire checks *****
	callr	SfireCk
	jrnc	SkSfire
	jsrp	Sfire
SkSfire:
	callr	FireCk
	jrnc	SkFire
	jsrp	Fire
SkFire:


**** BRAIN functions *****
DoBrain:
	movb	*A13(BRAINTIKS),A0
	jrnz	BrainX
;	jrz	SkB
;	callr	FRANCHEK
;	jruc	BrainX
;SkB:
	movk	15,A0
	movb	*A13(SNOOZE),A1
	jrnz	SetBTiks
	move	@hypobrain,A0,W
SetBTiks:
	movb	A0,*A13(BRAINTIKS)		;reset brain wait
	move	*A10(LIFECTR),A0,W
	inc	A0
	move	A0,*A10(LIFECTR),W

	jsrp	CkXDIST		;routine can DIE

	movb	*A13(SNOOZE),A0
	jrnz	CkDrug

	movb	*A13(DEST_TAG),A0
	cmpi	BULL_T,A0
	jrge	BrainX
;	jrlt	SkB2
;	callr	FRANCHEK
;	jruc	BrainX
;SkB2:

	move	*A8(OID),A1,W
	btst	2,A1
	jrnz	CkDrug
	jsrp	CkDngr
	jrc	BrainX
;	jrnc	SkFCK
;	callr	FRANCHEK
;	jruc	BrainX
;SkFCK:

CkDrug:
	movb	*A13(DEST_TAG),A0
	cmpi	DRUG_T,A0
	jrge	BrainX
;	jrlt	SkB3
;	callr	FRANCHEK
;	jruc	BrainX
;SkB3:

	callr	GetMode
	callr	DoMode
;	callr	FRANCHEK
BrainX:
;	callr	FRANCHEK


**** Animation check ****
	movb	*A13(SNOOZE),A0
	jrnz	AnimX
	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX

	movb	*A13(BUSTTIKS),A0
	jrnz	NOBUST
	calla	CKBUST
	jrnc	NOBUST
	callr	UnStand
	movi	90,A0
	movb	A0,*A13(BUSTTIKS)
	calla	ClrVel
	movi	30,A2
	movi	JRHYBUST,A9
	mmtm	A12,A10
	jsrp	GBUST
	mmfm	A12,A10
	jrnc	Foolem
	jruc	JRBUSTED
Foolem:
	cmpi	JRCUFF,A9
	jrge	Escape
	clr	A1			;* one frame w/ sleepin
;	callr	FRANCHEK
	jsrp	FRANIM
	jruc	Foolem
Escape:
	callr	AnimRst
	jruc	HYPO_MV

NOBUST:
	movk	10,A0
	movb	*A10(MODE),A1
	cmpi	MStand,A1
	jrz	ListLeft
	cmpi	MStop,A1
	jrz	ListLeft
	cmpi	MThrow,A1
	jrz	ListLeft

;	calla	ZOFF
	movk	4,A1			;* one frame, no sleepin
;	callr	FRANCHEK
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

	move	*A10(SFIRTIKS),A3,W
	jrp	SkSFir3
	movk	1,A3
SkSFir3:
	cmp	A5,A3
	jrge	SkMin3
	move	A3,A5
SkMin3:

	move	*A13(FIRETIKS),A4,W
	jrp	SkFire4
	movk	1,A4
SkFire4:
	cmp	A5,A4
	jrge	SkMin4
	move	A4,A5
SkMin4:

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
	sub	A5,A3
	move	A3,*A10(SFIRTIKS),W
	sub	A5,A4
	move	A4,*A13(FIRETIKS),W

	movb	*A13(BUSTTIKS),A1
	jrz	SkBustDc
	andi	>FF,A1	;No o' this sign extended byte shit
	sub	A5,A1
	jrp	SkClrBst
	clr	A1
SkClrBst:
	movb	A1,*A13(BUSTTIKS)
SkBustDc:

MoveSlp:
	movb	*A13(FLIPTIKS),A1
	jrz	SkFlipDc
	andi	>FF,A1	;No o' this sign extended byte shit
	sub	A5,A1
	jrp	SkClrFlp
	clr	A1
SkClrFlp:
	movb	A1,*A13(FLIPTIKS)
SkFlipDc:

	move	A5,A0
	calla	PRCSLP

	jruc	HYPO_MV
**************************************************************************


**************************************************************************
SfireCk:
;* ret SETC to throw spinning hypo, CLRC to not throw

	move	*A10(SFIRTIKS),A0,W
	jrnz	SFireCkX
	move	*A10(sfirrate),*A10(SFIRTIKS),W
	movb	*A13(DEST_TAG),A0
	cmpi	BUST_T,A0
	jrgt	SFireCkX
	calla	CentDist
	cmpi	300,A0
	jrgt	SFireCkX
	setc
	rets
SFireCkX:
	clrc
	rets
**************************************************************************

**************************************************************************
FireCk:
;* ret SETC to throw spinning hypo, CLRC to not throw
	move	*A13(FIRETIKS),A0,W
	jrnz	FireCkX
	move	*A10(firerate),*A13(FIRETIKS),W
	movb	*A13(DEST_TAG),A0
	cmpi	BUST_T,A0
	jrgt	FireCkX
	setc
	rets
FireCkX:
	clrc
	rets
**************************************************************************

**************************************************************************
GetMode:
	calla	ClosestP
	move	A0,A7		;A7 ptr to obj of closest Player
	move	*A7(OXVEL+16),A2,W
	calla	GETANIX
	move	A0,A1
	move	A8,A6
	move	A7,A8
	calla	GETANIX
	move	A6,A8
	sub	A0,A1		;A1 (Xp-PlXp)
	jrp	SkNegD
	neg	A2
SkNegD:				;A2 velocity ply Twd/Away from Hypoman
	move	A1,A5		;A5 signed dist
	abs	A1		;A1 Abs dist to closest player in X
	move	*A8(OZPOS),A3,W
	move	*A7(OZPOS),A0,W
	sub	A0,A3
	abs	A3		;A3 dist to plyr in Z

;BEFORE DOING MODE SPECIFIC CHECKS make sure hypo man won't hang out forever.
	;* if off screen check to go into charge mode
	calla	SCRTST
	jrz	SlctMode
	move	*A10(LIFECTR),A0,W
	move	A5,A5
	jrp	PlonLft
	srl	1,A0
PlonLft:
	calla	RANDPER
	jrc	SMCharge

SlctMode:
;* select next mode of action
	movb	*A10(MODE),A0
	jrn	BadMode
	cmpi	7,A0
	jrgt	BadMode
	
GotMd:
	sll	5,A0
	addi	GModeTbl,A0
	move	*A0,A0,L
	jump	A0

BadMode:
;	jruc	$
	clr	A0	;NoMode	.set	0
	movb	A0,*A10(MODE)
	jruc	GotMd

GNoMode:
	clr	A9		;make sure set vels go through
	cmpi	80,A1		
	jrlt	SMRun		;XDelt < 80, run away 
	cmpi	15,A3		
	jrlt	SMRun		;ZDelt < 30, run away 
	move	A3,A4
	addk	10,A4		;pad Z to encourage backing off
	sll	1,A4
	cmp	A1,A4
	jrgt	SMBkwrd		;XDelt < 2*Zdelt
	cmpi	150,A1		
	jrgt	StndFar2
	;* 80 < XDelt < 150
	move	A2,A2
	jrp	SMBkwrd		;player approaching, back off
	jruc	SMStop		;player not approaching, hold ground
StndFar2:
	;* Xdelt > 150
	move	A2,A2
	jrn	SMCharge	;player retreating, Charge
	jruc	SMStop		;player not running, Hold Pos

GCharge:
	move	A3,A4
	sll	1,A4
	cmp	A1,A4
	jrgt	SMRun		;XDelt < 2*Zdelt
	addk	30,A4
	cmp	A1,A4
	jrgt	SMThrow		;2*Zdelt < XDelt < 2*ZDelt+20
	cmpi	80,A1
	jrlt	SMRun		;XDelt < 100, player not moving away
	move	A2,A2
	jrn	GModeX		;player moving away from hypoman - charge
	cmpi	150,A1
	jrlt	SMStop		;XDelt < 150, player not moving away
	movi	300,A0
	calla	RANDPER
	jrc	SMStop
	jruc	GModeX
	
GStop:
GStand:
	cmpi	80,A1		
	jrlt	SMRun		;XDelt < 80, run away 
	cmpi	15,A3		
	jrlt	SMRun		;ZDelt < 30, run away 
	move	A3,A4
	addk	10,A4		;pad Z to encourage backing off
	sll	1,A4
	cmp	A1,A4
	jrgt	SMBkwrd		;XDelt < 2*Zdelt
	cmpi	150,A1		
	jrgt	StndFar
	;* 80 < XDelt < 150
	move	A2,A2
	jrp	SMBkwrd		;player approaching, back off
	jruc	GModeX		;player not approaching, hold ground
StndFar:
	;* Xdelt > 250
	cmpi	250,A1		
	jrgt	GModeX
	move	A2,A2
	jrn	SMCharge	;near player retreating, Charge
	jruc	GModeX		;player not running, Hold Pos

GBkwrd:
	cmpi	200,A1
	jrgt	SMStop		;XDelt > 200, safe to Stand
	cmpi	70,A1
	jrlt	SMRun		;XDelt < 70
	jruc	GModeX

GRun:
	cmpi	150,A1
	jrgt	SMStop		;XDelt > 200, safe to Stand
	jruc	GModeX

GThrow:
	move	A3,A4
	sll	1,A4
	cmp	A1,A4
	jrgt	GBkwrd		;XDelt < 2*Zdelt
	callr	CanFire
	jrnc	SMStop
	cmpi	150,A1
	jrlt	GModeX
	move	A2,A2
	jrn	SMCharge	;player moving away from hypoman - charge
	jruc	GModeX

GDrug:
	callr	GoMed
	jruc	GModeX

SMCharge:
	movk	MCharge,A0
	jruc	GMode
SMStop:
	movk	MStop,A0
	jruc	GMode
SMBkwrd:
	movk	MBkwrd,A0
	jruc	GMode
SMRun:
	movk	MRun,A0
	jruc	GMode
SMThrow:
	movk	MThrow,A0
;	jruc	GMode

GMode:
	movb	*A10(MODE),A1
	cmpi	MStand,A1
	jrnz	SMode
	cmpi	MStand,A0
	jrz	SMode
	callr	UnStand
SMode:
	movb	A0,*A10(MODE)
	clr	A0
	movb	A0,*A13(ANIMTIKS)
GModeX:
	rets

GModeTbl:
	.long	GNoMode,GStop,GStand,GCharge,GBkwrd,GRun,GThrow,GDrug
**************************************************************************

**************************************************************************
DoMode:
;* do mode of action
	movb	*A10(MODE),A0
	sll	5,A0
	addi	DModeTbl,A0
	move	*A0,A0,L
	jump	A0

DDrug:
	callr	DrugHunt
	jrc	DoModeX
	callr	DoStop
	jrnc	DBkwrd
	jruc	DoModeX

DStop:
	callr	DoStop
	jrnc	DBkwrd
	jruc	DoModeX

DStand:
	callr	DrugHunt
	jrc	DoModeX
	callr	DoStand
	jruc	DoModeX

DCharge:
	callr	DoCharge
	jruc	DoModeX

DBkwrd:
	callr	DoBack
	jruc	DoModeX

DRun:
	callr	EvadeBust
	jrc	DoModeX
	movk	MStop,A0
	movb	A0,*A10(MODE)
	jruc	DStop

DThrow:
	clr	A0
	move	A0,*A13(FIRETIKS),W
;	jruc	DoModeX

DoModeX:
	rets

DModeTbl:
	.long	0,DStop,DStand,DCharge,DBkwrd,DRun,DThrow,DDrug
**************************************************************************

**************************************************************************
DoCharge:
	calla	ClosestP
	move	A0,*A13(WANTOBJ),L
	movi	100,A3
	move	*A0(OXPOS),A1,W
	move	*A8(OXPOS),A2,W
	cmp	A1,A2
	jrgt	SkNegDst
	neg	A3
SkNegDst:
	add	A3,A1
	move	*A8(OZPOS),A2,W
	sll	16,A2
	movy	A2,A1
	move	A1,*A13(DEST),L
	calla	FACEOBJ

	callr	GoFast
	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	CHARGE_T,A0
	movb	A0,*A13(DEST_TAG)
	rets
**************************************************************************

**************************************************************************
DoBack:
	calla	ClosestP
	move	A0,*A13(WANTOBJ),L
	movi	100,A3
	move	*A0(OXPOS),A1,W
	move	*A8(OXPOS),A2,W
	cmp	A1,A2
	jrgt	SkNegD1
	neg	A3
SkNegD1:
	add	A3,A2
	move	*A8(OZPOS),A1,W
	sll	16,A1
	movx	A2,A1
	move	A1,*A13(DEST),L

	callr	GoBack
	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)
	rets
**************************************************************************


************************** Animation Cycler ******************************
AnimCycle:
;Resets animation loop
	move	*A13(ANIMPTR),A9,L
	rets
**************************************************************************

**************************** GetXVel *************************************
GetXVel:
	cmpi	MOVETBL,A9
	jrlt	NoXvel
	cmpi	MOVEEND,A9
	jrge	NoXvel
	cmpi	WALKMED,A9
	jrge	NotSlow
	movi	SLOWVEL->1000,A0
	jruc	GotXvel
NotSlow:
	cmpi	WALKFAST,A9
	jrge	NotMed
	movi	MEDVEL+>1000,A0
	jruc	GotXvel
NotMed:
	movi	FASTVEL+>1000,A0
	jruc	GotXvel
NoXvel:
	clr	A0
GotXvel:
	rets
**************************************************************************

***************************** GoBack *************************************
GoBack:
	mmtm	SP,A0
	cmpi	MOVETBL,A9
	jrlt	StartSlow
	cmpi	MOVEEND,A9
	jrge	StartSlow

	cmpi	WALKMED,A9
	jrlt	GoSlowX		;already going slow
	cmpi	WALKFAST,A9
	jrge	NotMed1
	subi	WALKMED,A9
	jruc	AdjSlow
NotMed1:
	subi	WALKFAST,A9
	jruc	AdjSlow

StartSlow:
	clr	A9
AdjSlow:
	movi	WALKSLOW,A0
	move	A0,*A13(ANIMPTR),L
	add	A0,A9

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos0
	movi	-SLOWVEL,A0
	jruc	SetXV0
VelPos0:
	movi	SLOWVEL,A0
SetXV0:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV
	
GoSlowX:
	mmfm	SP,A0
	rets
**************************************************************************

***************************** GoMed *************************************
GoMed:
	mmtm	SP,A0
	cmpi	MOVETBL,A9
	jrlt	StartMed
	cmpi	MOVEEND,A9
	jrge	StartMed

	cmpi	WALKMED,A9
	jrge	NotSlow2
	subi	WALKSLOW,A9
	jruc	AdjMed
NotSlow2:
	cmpi	WALKFAST,A9
	jrlt	GoMedX		;Already going Med
	subi	WALKFAST,A9
	jruc	AdjMed

StartMed:
	clr	A9
AdjMed:
	movi	WALKMED,A0
	move	A0,*A13(ANIMPTR),L
	add	A0,A9

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos1
	movi	-MEDVEL,A0
	jruc	SetXV1
VelPos1:
	movi	MEDVEL,A0
SetXV1:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV

GoMedX:
	mmfm	SP,A0
	rets
**************************************************************************

***************************** GoFast *************************************
GoFast:
	mmtm	SP,A0
	cmpi	MOVETBL,A9
	jrlt	StartFast
	cmpi	MOVEEND,A9
	jrge	StartFast

	cmpi	WALKMED,A9
	jrge	NotSlow3
	subi	WALKSLOW,A9
	jruc	AdjFast
NotSlow3:
	cmpi	WALKFAST,A9
	jrge	GoFastX		;Already going Fast
	subi	WALKMED,A9
	jruc	AdjFast

StartFast:
	clr	A9
AdjFast:
	movi	WALKFAST,A0
	move	A0,*A13(ANIMPTR),L
	add	A0,A9

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos2
	movi	-FASTVEL,A0
	jruc	SetXV2
VelPos2:
	movi	FASTVEL,A0
SetXV2:
	move	A0,*A8(OXVEL),L
	calla	UpdShadV

GoFastX:
;	callr	FRANCHEK
	mmfm	SP,A0
	rets
**************************************************************************

*************************** Screen X Check *******************************
ScrXCk:
	callr	JR_XCHECK
	jrnc	OnScr
	callr	GoFast
	calla	GetOnScr
OnScr:
	rets
**************************************************************************

*****************************  Evade Bust  *******************************
EvadeBust:
;* rets setc if evade is being done
	calla	ClosestP

	move	*A0(OXPOS),A1		;if too far away in X don't evade
	move	*A8(OXPOS),A2
	sub	A1,A2
	abs	A2
	cmpi	170,A2
	jrgt	EvadeX

	move	*A0(OZPOS),A1		;if too far away in Z don't evade
	move	*A8(OZPOS),A2
	sub	A1,A2
	abs	A2
	cmpi	80,A2
	jrgt	EvadeX

	;* player is too close - RUN AWAY!!
	callr	GoFast
	calla	FleeObj
	movk	BUST_T,A0
	movb	A0,*A13(DEST_TAG)
	setc
	rets

EvadeX:
	clrc
	rets
**************************************************************************

*************************  Drug Hunt  ************************************
DrugHunt:
;* setc if drugs are being hunted, clrc for no drugs
	movi	DRUGOID,A0
	calla	NEAR_BTY
	jrnc	HuntX

	callr	UnStand
	callr	GoMed
	move	A0,*A13(WANTOBJ),L
	calla	HuntObj
	movk	25,A0
	calla	ShortXDest

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	DRUG_T,A0
	movb	A0,*A13(DEST_TAG)
	movk	MDrug,A0
	movb	A0,*A10(MODE)
	setc
	rets

HuntX:
	clrc
	rets
**************************************************************************

**************************************************************************
GRAB:
	move	*A13(WANTOBJ),A0,L
	jrz	GRABX
;* If ENEMY Z and OBJ Z don't match, can't grab
GrabLp:
	move	*A0(OZPOS),A1,W
	move	*A8(OZPOS),A2,W
	move	A1,A3
	sub	A2,A3
	abs	A3
	cmpi	5,A3
	jrgt	NOGRAB

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
	jrlt	NOGRAB
	cmpi	35,A2
	jrgt	NOGRAB

GRABIT:
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrc	DOGRAB
	clr	A0
	move	A0,*A13(WANTOBJ),L
	jruc	GRABX
DOGRAB:
	move	A0,A11
	calla	FACEOBJ
	callr	UnStand
	callr	AnimRst
	movi	JRREACH1,A9
	calla	ClrVel
	movk	1,A1
	jsrp	FRANIM
	
	move	A11,A0
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrc	DOGRAB1
	clr	A0
	move	A0,*A13(WANTOBJ),L
	jruc	GRABX
DOGRAB1:
	move	*A11(OPLINK),A0,L
	jrz	NoBtyPrc
	calla	KILL
	clr	A0
	move	A0,*A11(OPLINK),L
NoBtyPrc:
	move	A11,A0			;GET THE BLOCK
	movi	BOOTY,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	calla	DELOBJ			;ZAP IT
	movb	*A13(EDRUG),A0
	inc	A0
	movb	A0,*A13(EDRUG)
	clr	A0
	move	A0,*A13(WANTOBJ),L
	callr	SetFireR

	movi	JRREACH2,A9
	movk	1,A1
	jsrp	FRANIM

	clr	A0
	movb	A0,*A13(BUSTTIKS)

	movi	DRUGOID,A0
	calla	NEAR_BTY
	jrc	GrabLp

GRABX:
	setc
	retp
NOGRAB:
	clrc
	retp
**************************************************************************

***************************** CHECK DANGER *******************************
* if JR is in danger of being shot, dodge or send spinning hypo
* if a destination is set, set the carry to prevent MODE stuff
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
	cmpi	200,A6		;is bullet real close?
	jrgt HGH_NEAR
;* bullet is very close - duck and shoot spinner
	;* shoot toward where bullet came from 
	move	A5,A0
	calla	FACEBULL
	calla	ClosestFP
	move	A0,*A13(WANTOBJ),L
	callr	UnStand
	callr	AnimRst
	movi	JRTH,A9
	move	*A8(OID),A1,W
	andi	2,A1
	jrz	SkSpn1
	movi	JRTHS,A9
SkSpn1:	
	calla	ClrVel
	movk	1,A1			; do the whole script
	jsrp	FRANIM
	jruc	JRDNGRX
HGH_NEAR:
	cmpi	500,A6	;is bullet near?
	jrgt	JRDNGRX

	;* bullet is near - move down, down and away!
	;* find Z destination
	move	*A8(OZPOS),A1,W
	movk	30,A0
	calla	RANDU
	addk	15,A0
	add	A0,A1
	move	@PLZMAX,A0,W
	cmp	A0,A1
	jrlt	ZisGood
	move	@PLZMIN,A1,W
	add	A0,A1
	srl	1,A1
ZisGood:
	sll	16,A1	;A1 is z portion of destination

	;* generate X destination
	movk	30,A0
	calla	RANDU
	addk	30,A0		;A0 is magnitude of X distance to run away
	move	*A5(OXVEL+16),A2,W		;Get sign of Bullets velocity
	jrp	XdirOK
	neg	A0
XdirOK:
	move	A0,A2
	calla	GETANIX
	add	A0,A2
	movy	A1,A2
	move	A2,*A13(DEST),L
	jruc	DNGRDEST

BULL_LOW:
	;* bullet heading at feet
	cmpi	200,A6	;is bullet real close?
	jrgt	LOW_NEAR
	;* bullet is very close - jump and shoot spinner
	move	A5,A0
	calla	FACEOBJ
	jsrp	DO_JUMP
	jruc	JRDNGRX
LOW_NEAR:
	cmpi	500,A6	;is bullet near?
	jrgt	JRDNGRX

	;* bullet is near - move up, up and away
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
	add	A0,A1
	srl	1,A1
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
	move	A0,A2
	calla	GETANIX
	add	A0,A2
	movy	A1,A2
	move	A2,*A13(DEST),L

DNGRDEST:
	callr	UnStand
	callr	AnimRst
	callr	GoFast
	movk	BULL_T,A0
	movb	A0,*A13(DEST_TAG)

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0
	setc
	retp

JRDNGRX:
NoDngr:
	clrc
	retp
**************************************************************************

**************************************************************************
JR_DONE:
	callr	DelHead
	move	A10,A0
	calla	FREEOBJE
JR_DIE2:
	move	A8,A0		;GET THE POINTER TO THE OBJECT
	calla	DELENEMY			;DELETE THE ENEMY
JR_DIE1:
	DECW	@JRHYCNT
	DIE
JRBUSTED:
	move	A11,A2
	movi	>5000,A1
	calla	SCORE
	calla	PUT5K

	callr	DelHead
	move	A10,A0
	calla	FREEOBJE
	move	@JRHYCNT,A0,W
	dec	A0
	move	A0,@JRHYCNT,W
	calla	CARDCHEK
	DIE
**************************************************************************


**************************************************************************
*WALKING JR, AS OBJECT 0, COLLSION ROUTINE
*A0 = PTR TO JR OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
CARCOL0
	MOVE	A8,A6		;KILLERS OBJ
	MOVE	A0,A8		;JR OBJ
	move	*A6(OXVEL),A0,L
	move	*A8(OXVEL),A1,L
	sub	A1,A0
	abs	A0
	cmpi	>70000,A0
	jrlt	NotHurt
	movi	>60000,A0
	calla	RANDU
	subi	>30000,A0
	move	*A6(OXVEL),A1,L
	sra	1,A1
	move	A1,A2
	add	A1,A0
	move	A0,*A8(OXVEL),L
	abs	A2
	neg	A2
	move	A2,*A8(OYVEL),L
	jruc	Wasted
NotHurt:
	move	*A8(OPLINK),A0,L
;	move	A6,*A0(COLLOBJ),L
	clr	A0	;don't stop collision scan
	RETS

JRCOL0
	MOVE	A8,A6			;STORE KILLERS OBLOCK
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER
Wasted:
	move	*A8(OPLINK),A0,L
	calla	GETA8
	calla	GETA10
	calla	DelHead
	move	A10,A0
	calla	FREEOBJE

	MOVI	SPLTCOLBOX,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER

	MOVE	*A8(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	MOVE	A0,A14			;STORE THIS RELIC
	
	calla	ShadOn

	MOVE	*A6(OXVEL),A9,L		;GET PROJECTILE DATA
	MOVE	*A6(OYVEL),A10,L
	MOVE	*A6(OID),A11,W		
	MOVI	0EDh,A1
	MOVI	WENDIE,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	jrz	SkWendie
	MOVE	*A6(ODMAXY),*A0(PDATA),L	;PASS KILLERS DMA XY POSITION
	MOVE	*A6(OSIZE),*A0(PDATA+20H),L	;AND KILLERS XY SIZE
	move	*A14(EBCNTRS),*A0(EBCNTRS),L	;and the booty counters
	MOVE	*A14(EMAINT),*A0(EMAINT),L

	move	*A6(OYPOS),A9,W
	MOVI	0EDh,A1
	movi	SPLATBOX,A7
	CALLA	GETPRC

DoDie:
	move	@JRHYCNT,A0,W
	dec	A0
	move	A0,@JRHYCNT,W
	calla	CARDCHEK

	movi	1,A0	;stop collision scan
	RETS
SkWendie:
	move	A8,A0
	calla	DELENEMY
	jruc	DoDie
*************************************************************************

*************************************************************************
JRCOLL:
	.WORD	B1OID|BULLETID
	.LONG	JRCOL0
	.WORD	B1OID|EXPLODID
	.LONG	JRCOL0
	.WORD	B1OID|ROCKETID
	.LONG	JRCOL0
	.WORD	B2OID|BULLETID
	.LONG	JRCOL0
	.WORD	B2OID|EXPLODID
	.LONG	JRCOL0
	.WORD	B2OID|ROCKETID
	.LONG	JRCOL0
	.WORD	BEOID|EXPLODID
	.LONG	JRCOL0
	.word	C1OID		;ENEMY CAR #1 "CADILLAC" OBJECT I.D.
	.LONG	CARCOL0
	.word	CAR2OID		;ENEMY CAR #2 "PORSCHE" OBJECT I.D.
	.LONG	CARCOL0
	.word	CAR3OID		;ENEMY CAR #3 "BELL-JET" OBJECT	I.D.
	.LONG	CARCOL0
	.word	TRAN1OID	;PLAYER TRANSPORT #1 "PORSCHE" OBJECT I.D.
	.LONG	CARCOL0
	.WORD	0
	.LONG	DUMRTSG

;WALKING JUMPING DEATH FRAGMENT STANDING-SHOOT KNEELING-SHOOT
;STANDING KNEELING

JROFF	.WORD	1,3,4,9,18,34,50,50
*THE JR ENEMY, ANIMATION PTR TABLE, FIRST LONG WORD IS THE OFFSET PTR
*
JRTAB	.LONG	JROFF
	.LONG	WALKSLOW,WALKSLOW,JRJLR,JRDBUL,LOFDFLA,LOFDEXP,LOFDEXP1,LOFDROCK

	.LONG	LOFRAG1,LOFRAG2,LOFRAG2,LOFRAG3
	.LONG	LOFRAG1,LOFRAG2,LOFRAG3,LOFRAG4,0
*************************************************************************


**************************************************************************
* JR FRAME TABLES	
* NORMAL TABLE ENTRY:
* 	AFRAME	FRAME,SLEEPT,CONTROL_WORD
* FIRE FRAME TABLE ENTRY:		    
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW

WALKDIST	.set	9+13+16+11+6+7+17+8	
SLOWVEL	.set	->12000
MEDVEL	.set	>1A000
FASTVEL	.set	>26000

FRANMIN:
MOVETBL:
;WALKSLOW:	  ;* sleep is 95% of delta
;	.long	JRW1
;	.word	DELTAXZ|9,9
;	.long	JRW2
;	.word	DELTAXZ|12,13
;	.long	JRW3
;	.word	DELTAXZ|15,16
;	.long	JRW4
;	.word	DELTAXZ|10,11
;	.long	JRW5
;	.word	DELTAXZ|6,6
;	.long	JRW6
;	.word	DELTAXZ|7,7
;	.long	JRW7
;	.word	DELTAXZ|16,17
; 	.long	JRW8
;	.word	DELTAXZ|8,8
;	LONGNULL
;WALKMED:	  ;* sleep is 66% of delta
;	.long	JRW1
;	.word	DELTAXZ|6,9
;	.long	JRW2
;	.word	DELTAXZ|9,13
;	.long	JRW3
;	.word	DELTAXZ|11,16
;	.long	JRW4
;	.word	DELTAXZ|7,11
;	.long	JRW5
;	.word	DELTAXZ|4,6
;	.long	JRW6
;	.word	DELTAXZ|5,7
;	.long	JRW7
;	.word	DELTAXZ|11,17
;	.long	JRW8
;	.word	DELTAXZ|5,8
;	LONGNULL
;WALKFAST:	  ;* sleep is 45% of delta
;	.long	JRW1
;	.word	DELTAXZ|4,9
;	.long	JRW2
;	.word	DELTAXZ|6,13
;	.long	JRW3
;	.word	DELTAXZ|6,16
;	.long	JRW4
;	.word	DELTAXZ|5,11
;	.long	JRW5
;	.word	DELTAXZ|3,6
;	.long	JRW6
;	.word	DELTAXZ|3,7
;	.long	JRW7
;	.word	DELTAXZ|6,17
;	.long	JRW8
;	.word	DELTAXZ|4,8
;	LONGNULL

WALKSLOW:	  ;* sleep is 95% of delta
 	.long	JRW8
	.word	6
	.long	JRW7
	.word	9
	.long	JRW6
	.word	6
	.long	JRW5
	.word	5
	.long	JRW4
	.word	7
	.long	JRW3
	.word	9
	.long	JRW2
	.word	8
	.long	JRW1
	.word	7
	LONGNULL
WALKMED:	  ;* sleep is 66% of delta
	.long	JRW1
	.word	5
	.long	JRW2
	.word	7
	.long	JRW3
	.word	8
	.long	JRW4
	.word	6
	.long	JRW5
	.word	4
	.long	JRW6
	.word	4
	.long	JRW7
	.word	8
	.long	JRW8
	.word	4
	LONGNULL
WALKFAST:	  ;* sleep is 45% of delta
	.long	JRW1
	.word	4
	.long	JRW2
	.word	5
	.long	JRW3
	.word	6
	.long	JRW4
	.word	5
	.long	JRW5
	.word	3
	.long	JRW6
	.word	3
	.long	JRW7
	.word	7
	.long	JRW8
	.word	4
	LONGNULL
MOVEEND:

WALKOUT:	  ;* sleep is 95% of delta
	.long	JRW1
	.word	4
	.long	JRW2
	.word	6
	.long	JRW3
	.word	7
	.long	JRW4
	.word	5
	.long	JRW5
	.word	3
	.long	JRW6
	.word	3
	.long	JRW7
	.word	8
 	.long	JRW8
	.word	4
	LONGNULL

JRSTAND:
	.long	JRBODY
	.word	1
	LONGNULL
JRHEADS:
	.long	JRHEAD3
	.word	FLIPBITS|20,M_FLIPH
	.long	JRHEAD3
	.word	FLIPBITS|20,M_FLIPH
	.long	JRHEAD2
	.word	FLIPBITS|20,M_FLIPH
	.long	JRHEAD1
	.word	FLIPBITS|20,M_FLIPH
	.long	JRHEAD1
	.word	FLIPBITS|20,0
	.long	JRHEAD2
	.word	FLIPBITS|20,0
	.long	JRHEAD3
	.word	FLIPBITS|20,0
	.long	JRHEAD3
	.word	FLIPBITS|20,0
	LONGNULL

JRHYBUST:
	.long	JRBUST3
	.word	4
	.long	JRBUST2
	.word	3
	.long	JRBUST1
	.word	12
	.long	JRBUST2
	.word	4
	.long	JRBUST3
	.word	4
JRCUFF:
	.long	JRBUST4
	.word	10
	LONGNULL

JRREACH1:
	.long	JRTH1
	.word	3
	.long	JRTH2
	.word	5
	.long	JRTH3
	.word	6
	.long	JRTH4
	.word	6
	LONGNULL
JRREACH2:
	.long	JRTH5
	.word	7
	.long	JRTH6
	.word	6
	.long	JRTH7
	.word	5
	LONGNULL

JRTH				;JR THROW NORMAL
	.long	JRTH1
	.word	3
	.long	JRTH2
	.word	4
	.long	JRTH3
	.word	4
 	.long	JRTH4
 	.word	SPAWNP|5,20,-3,0EBH
 	.long	NHYPO			;change to SHYPO when done
	.long	JRTH5
	.word	5
	.long	JRTH6
	.word	5
	.long	JRTH7
	.word	3
	LONGNULL

JRTHS			;JR THROW SPINNER
	.long	JRTH1
	.word	3
	.long	JRTH2
	.word	4
	.long	JRTH3
	.word	6
	.long	JRTH4
	.word	SPAWNP|9,20,-3,0EBH
	.long	SHYPO
	.long	JRTH5
	.word	9
	.long	JRTH6
	.word	10
	.long	JRTH7
	.word	5
	LONGNULL

JRJMPTH:				;JR JUMP & THROW
	.long	JMPTH1
	.word	2
	.long	JMPTH3
	.word	SPAWNP|3,0,0,0EBH
	.long	NHYPO
	.long	JMPTH4
	.word	4
	.long	JMPTH5
	.word	3
	.long	JMPTH6
	.word	3
	LONGNULL

JRJMPTHS:				;JR JUMP & THROW
	.long	JMPTH1
	.word	2
	.long	JMPTH3
	.word	SPAWNP|3,0,0,0EBH
	.long	SHYPO
	.long	JMPTH4
	.word	4
	.long	JMPTH5
	.word	3
	.long	JMPTH6
	.word	3
	LONGNULL

JRDBUL:		    	 ;JR DIE FROM A BULLET
	.long	JRD1
	.word	6
	.long	JRD2
	.word	6
	.long	JRD3
	.word	3
	.long	JRD4
	.word	3
	.long	JRD5
	.word	3
	.long	JRD6
	.word	3
	.long	JRD7
	.word	3
	.long	JRD8
	.word	4
	.long	JRD7
	.word	4
	.long	JRD8
	.word	4
	.long	JRD9
	.word	4
	.LONG	0

;FRANMAX:

JRJLR
JRSD
JRSL
JRNUL
	.LONG	0


****************************************************************************
HYPOCRM1:
	move	@(WORLDTLX+16),A0,W				 
	addi	150,A0
	move	@PLYMIN,A1,W									 
	addi	5,A1
	sll	16,A1
	movx	A0,A1
	movi	JRTAB,A6
	movi	JRINIT,A14	
	calla	ESINITLL		;CREATE HYPOMAN
	clr	A0
	move	A0,*A8(OBLIPIMG),L

	clr	A0
	movb	A0,*A13(SNOOZE)

	;so he can have his head
	calla	GETOBJ
	jrz	JR_DIE2		
	move	A0,A10	;A10 will Always point to extra Data Space
	calla	CLROBJ

	calla	ClrVel
	calla	NOYFLP
	movi	MEDVEL,A0
	move	A0,*A8(OXVEL),L
	movi	WALKMED,A9	
	movk	1,A1
	jsrp	FRANIM
	callr	DoStop
	movk	6,A0
	PUSHP	A0
rumple:
	PULLP	A0
	dec	A0
	jrz	CRM1X
	PUSHP	A0
	SLEEP	5
	callr	DoStand
	jruc	rumple
CRM1X:
	callr	DelHead
	move	A10,A0
	calla	FREEOBJE
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELSUPP
	move	*A8(OPAL),A1,W
	move	A1,@CRIMEPAL,W
	CALLA	DELSOBJ
	retp
****************************************************************************

redhypo:	;PAL #0
	.word	247	;pal size
	.word >402,>402,>422,>403,>404,>423,>424,>444,>445,>402
	.word >403,>422,>423,>C03,>C23,>443,>C43,>424,>C24,>444
	.word >445,>C44,>C45,>C23,>C43,>1443,>C24,>C44,>1444,>C45
	.word >1445,>463,>464,>C63,>C64,>465,>C65,>C62,>C63,>C64
	.word >C65,>1462,>1463,>1464,>1465,>C83,>C83,>C84,>C84,>1483
	.word >1484,>C85,>C85,>1485,>CA5,>CA5,>CE4,>14A5,>446,>426
	.word >446,>447,>466,>467,>C26,>C27,>C46,>C47,>C66,>C67
	.word >C46,>C47,>C66,>C67,>1446,>1447,>1466,>1467,>486,>487
	.word >C86,>C87,>C86,>C87,>1486,>1487,>4A6,>CA6,>CA7,>CA6
	.word >CA7,>14A6,>14A7,>14C7,>C48,>C48,>C68,>46A,>C69,>C6A
	.word >1448,>1468,>1469,>146A,>488,>C88,>C88,>CA8,>1488,>14A8
	.word >14C8,>C89,>C89,>1489,>14A9,>C8A,>C8B,>CAA,>CCD,>1443
	.word >1444,>1462,>1463,>1464,>1445,>1465,>1446,>1447,>1466,>1467
	.word >1484,>1485,>14A5,>14C5,>1486,>1487,>14A6,>14A7,>14C6,>1C44
	.word >1C63,>1C65,>1C47,>1C67,>1C67,>1C84,>1C85,>1CA4,>1C86,>1C87
	.word >1C86,>1CA7,>1CA7,>1CC7,>2463,>2466,>2C66,>24A4,>2CC4,>24A7
	.word >2CE6,>340B,>340B,>340B,>340E,>480C,>482D,>580C,>680D,>1448
	.word >1468,>1488,>1449,>1469,>1489,>146A,>148A,>146B,>1C48,>1C68
	.word >1C88,>2488,>1C69,>1C89,>1C8A,>248A,>14A8,>1CA9,>14C9,>1CC9
	.word >2CC9,>1CCA,>1CCB,>250E,>340F,>3813,>4811,>4430,>5050,>4855
	.word >5410,>5834,>6831,>68B4,>78D5,>7D36,>303B,>3C3A,>3CB8,>60BA
	.word >597F,>715F,>7D19,>7D5A,>7D3D,>7D7D,>7D9B,>7DBD,>7DBF,>7DBF
	.word >4A9,>50C,>56E,>591,>5D1,>635,>15F,>280A,>3C09,>3C0C
	.word >640A,>250A,>CF0,>580F,>641F,>1D70,>1E79,>16BA,>2E7F,>3DD2
	.word >4D9A,>563A,>4E5A,>340D,>154E,>2D6F,>7EBA
HYPOPALS:
	.long	JRwalk
	.long	redhypo
