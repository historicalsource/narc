	.FILE	'NARCNDLE.ASM'
	.TITLE	" <<< N  A  R  C  -- HYPODERMIC PROJECTILE >>>"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST	

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCTEQU.ASM"
	.include	"narchypo.glo"
	.INCLUDE	"imgtbl.glo"
	.EVEN
	.TEXT

ShftInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	HYPOB0,PBULZ,ShftColl
	.WORD	DMAWNZ|M_PIXSCAN,0
	.LONG	0
TipInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	HYPOT0,PBULZ,TipColl
	.WORD	DMAWNZ|M_PIXSCAN,0
	.LONG	0

TIPTBL	.set	ETEMP1
SHAFTANI .set	ETEMP2
TIPANI	.set	ETEMP3
ANICTR	.set	ETEMP4		;byte
SLPTIKS	.set	ETEMP4+8	;byte
PDBLOCK	.set	ETEMP5
TIMELEFT .set	ETEMP6

OLDXP	.set	ESWTCH
OLDZP	.set	ESWTCH+16
OLDYP	.set	EYXVEL

**************************************************************************
* NHYPO - Normal HYPODERMIC ENTRY POINT
* A8  = OBLOCK PTR OF ENEMY		  
* A10 = X,Y Pos to start hypo at
NHYPO:
	movi	FLYNHYPO,A5
	jruc	AllocHypo
**************************************************************************

**************************************************************************
* SHYPO - SPINNING HYPODERMIC ENTRY POINT
* A8  - OBLOCK PTR OF ENEMY		  
* A10 - X,Y Pos to start hypo anim pt at
SHYPO:
	clr	A9
SHYPOM:
	inc	A9
	cmpi	3,A9
	jrge	SkMirv
	movi	160,A0
	calla	RANDPER
	jrnc	SkMirv
	CREATE	0EBH,SHYPOM
SkMirv:
	movi	FLYSHYPO,A5
;	jruc	AllocHypo
**************************************************************************

**************************************************************************
AllocHypo:
* A5 - Routine to Continue Hypos Flight
* allocates the object blocks for the hypo shaft and tip
* does basic initialization of these objects
	move	A8,A6		;A6 - Obj ptr of Thrower
	move	A10,A4		;A4 - start coors

	calla	GETOBJ
	jrz	NoShft
	movi	ShftInit,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	move	A0,A8

	calla	GETOBJ
	jrz	NoTip
	movi	TipInit,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	move	A0,A10

	;* allocate palette
	MOVI	JRwalk,A0
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	jrz	NoPal
	MOVE	A0,*A8(OPAL),W
	MOVE	A0,*A10(OPAL),W
	jruc	InitHypo

NoPal:
	;* must free the tip obj
	move	A10,A0
	calla	FREEOBJ
NoTip:
	;* must free the shaft obj
	move	A8,A0
	calla	FREEOBJ
NoShft:
	DIE

InitHypo:		;* Yay, we got all the stuff..
	movi	BEOID|HYPOD,A0	;set ID of Tip
	move	A0,*A10(OID),W
	movi	HYPOD,A0	;set ID of Shaft
	move	A0,*A8(OID),W

	;* Init Proc Vars
	;*** Load Data Block of Targeted Player Pop was after
	move	*A6(OPLINK),A0,L
	move	*A0(WANTOBJ),A0,L	;A0-ptr to players proc
	movi	P1DATA,A1
	move	*A1(POBJ),A2,L
	jrz	SkP1D
	cmp	A2,A0
	jreq	GotP
SkP1D:
	movi	P2DATA,A1
	move	*A1(POBJ),A2,L
	jrz	SkP2D
	cmp	A2,A0
	jreq	GotP
SkP2D:
	CALLA	SELCTPLY
	move	A11,A0
	CALLA	GETPLYR
	move	A0,A1
GotP:	;A1 ptr to players Data Block
	move	A1,*A13(PDBLOCK),L
	;******* INITIALIZE ANIMATION VARS
	clr	A0
	move	A0,*A13(ANICTR),L
	move	*A6(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrnz	FlpStrt
	;* not Flipped
	movi	HYPOCCW,A0
	move	A0,*A13(SHAFTANI),L
	movi	HTIPCCW,A0
	move	A0,*A13(TIPANI),L
	movi	TIPOFFCCW,A0
	move	A0,*A13(TIPTBL),L
	jruc	AniSet
FlpStrt:
	movi	HYPOCW,A0
	move	A0,*A13(SHAFTANI),L
	movi	HTIPCW,A0
	move	A0,*A13(TIPANI),L
	movi	TIPOFFCW,A0
	move	A0,*A13(TIPTBL),L
AniSet:

	;Set Shaft Position - A4 is start coors
	move	A4,A3
	sext	A3,W 	;A3 - x start
	move	*A6(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkFlpH
	neg	A3
SkFlpH:
	move	*A8(OXPOS),A0,W
	add	A3,A0
	move	*A6(OXPOS),A3,W
	add	A3,A0
	move	*A6(OSIZEX),A3,W
	srl	1,A3
	add	A3,A0
	move	A0,*A8(OXPOS),W
	sra	16,A4	;A4 - y start
	move	*A8(OYPOS),A0,W
	add	A4,A0
	move	*A6(OYPOS),A4,W
	add	A4,A0
	move	*A6(OSIZEY),A4,W
	srl	1,A4
	add	A4,A0
	move	A0,*A8(OYPOS),W
	move	*A6(OZVAL),A0,L
	inc	A0
	move	A0,*A8(OZVAL),L


	;* Put Objects on Obj List
	move	A8,A0
	calla	INSOBJ
	move	A10,A0
	calla	INSOBJ

	;Insert Objs on enemy bullet list
	movi	ENEMY_BULLETS,A1
	move	A8,A0
	calla	ADDSUPP			;ADD TO SUPPLEMENTAL List
	move	A10,A0
	calla	ADDSUPP			;ADD TO SUPPLEMENTAL List

	calla	SHADST
;	SWAP	A8,A10
;	calla	SHADST
;	SWAP	A8,A10
	jump	A5
**************************************************************************

**************************************************************************
DelHypo:
	MOVI	ENEMY_BULLETS,A1
	MOVE	A8,A0		;THE Shaft
	CALLA	DELPAL
	CALLA	DELSUPP
	CALLA	DELSOBJ
	MOVE	A10,A0 		;THE Tip
	CALLA	DELSUPP
	CALLA	DELSOBJ
	rets
DelTip:
	MOVI	ENEMY_BULLETS,A1
	MOVE	A10,A0 		;THE Tip
	CALLA	DELSUPP
	CALLA	DELSOBJ
	rets
**************************************************************************

**************************************************************************
*CONTINUATION POINT FOR A NORMAL HYPODERMIC NEEDLE
FLYNHYPO:
;A6 - obj ptr of thrower
;	movi	SHYPOSND,A0
;	calla	ONESND

	;Set Velocities
	movi	HYPOVEL+1,A3
	move	*A6(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkNegXV
	neg	A3
SkNegXV:
	sll	16,A3
	move	A3,*A8(OXVEL),L		;A3 - X VEL

	callr	DoFrame
		       	
	;set ZV = ZDIST / TIME, TIME = XDIST/XVEL
	;ZV = ZDIST * (XVEL / XDIST)
	move	*A13(PDBLOCK),A0,L
	move	*A0(POBJ),A1,L
	move	A8,A7
	move	A1,A8
	calla	GETANIX
	move	A0,A2
	move	A7,A8
	move	*A10(OXPOS),A4,W
	sub	A4,A2
	divs	A2,A3
	move	*A1(OZPOS),A2,W
	move	*A8(OZPOS),A4,W
	sub	A4,A2
	mpys	A2,A3
	move	A3,A1
	move	*A8(OXVEL),A0,L
	abs	A0
	calla	ABSMAX ;* returns A1 Clipped at val A0 in pos or neg
	move	A1,*A8(OZVEL),L
	move	A1,*A8(OYVEL),L
	move	A1,*A10(OZVEL),L
	move	A1,*A10(OYVEL),L
	calla	UpdShadV
	move	A8,A7
	move	A10,A8
	calla	UpdShadV
	move	A7,A8

	movi	150,A0
	calla	BullSlp
	calla	PRCSLP

	move	A11,A11
	jrz	SkWallHit
	MOVI	ENEMY_BULLETS,A1
	MOVE	A8,A0
	CALLA	DELSUPP		;DELETE FROM THE SUPPLEMENTAL LIST
	callr	DelTip
	jauc	DINGANI
SkWallHit:
	callr	DelHypo
	DIE
*************************************************************************

**************************************************************************
*CONTINUATION POINT FOR A SPINNING HYPODERMIC NEEDLE
*A5 = X VELOCITY, CORRECT DIRECTION
*A8 = OBLOCK
*A9 = ANIMATION TABLE
*B1 = OID
FLYSHYPO:
	movi	SHYPOSND,A0
	calla	ONESND

	movi	200,A0
	move	A0,*A13(TIMELEFT),W

	;Set Velocities
	movi	HYPOVEL,A3
	move	*A6(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkNegXV2
	neg	A3
SkNegXV2:
	sll	16,A3
	movi	>10000,A0
	calla	RANDU
	subi	>8000,A0
	add	A0,A3
	move	A3,*A8(OXVEL),L		;A3 - X VEL

	callr	DoFrame

	;set ZV = ZDIST / TIME, TIME = XDIST/XVEL
	;ZV = ZDIST * (XVEL / XDIST)
	move	*A13(PDBLOCK),A0,L
	move	*A0(POBJ),A1,L
	move	A8,A7
	move	A1,A8
	calla	GETANIX
	move	A0,A2
	move	A7,A8
	move	*A10(OXPOS),A4,W
	sub	A4,A2
	divs	A2,A3
	move	*A1(OZPOS),A2,W
	move	*A8(OZPOS),A4,W
	sub	A4,A2
	mpys	A2,A3
	move	A3,A1
	move	*A8(OXVEL),A0,L
	abs	A0
	calla	ABSMAX ;* returns A1 Clipped at val A0 in pos or neg
	move	A1,*A8(OZVEL),L
	move	A1,*A8(OYVEL),L

	movk	7,A0
	CALLA	RANDU
	movb	A0,*A13(SLPTIKS)	;sleep time between frames
	clr	A11	;ctr for when to adjust velocity
ShypoLp:
	movb	*A13(SLPTIKS),A0
	move	*A13(TIMELEFT),A1,W
	sub	A0,A1
	jrn	SPINDONE
	move	A1,*A13(TIMELEFT),W
	CALLA	PRCSLP	
	move	*A8(OZPOS),A0,W
	move	@PLZMIN,A1,W
	cmp	A1,A0
	jrge SkBnc
	;* make sure Z velocity is positive
	move	*A8(OZVEL+16),A0,W
	abs	A0
	move	A0,*A8(OZVEL+16),W
	move	*A8(OYVEL+16),A0,W
	abs	A0
	move	A0,*A8(OYVEL+16),W
SkBnc:

	cmpi	2,A11
	jrgt	VEL_ADJ
	inc	A11
	jruc	DO_FRAME
VEL_ADJ:
	clr	A11

	;* did player die?
	move	*A13(PDBLOCK),A0,L
	move	*A0(PFLAGS),A0,L
	btst	BDEAD,A0
	jrnz	SPINDONE

	;* XVEL remains constant,
	;* time of approaching intersection with player given by
	;*	 TIME = ABS(Xp-PlXp) / ABS(Xv-PlXv)
	;* desired Z velocity given by
	;*	Zv = ((PlZp+PlZv*TIME)-Zp)/TIME
	;* desired Y velocity given by
	;*	Yv = (Yp-(PlYpMid+PlYv*TIME))/TIME
	move	*A13(PDBLOCK),A0,L
	move	*A0(POBJ),A0,L
	jrnz	GotPlObj
	CALLA	SELCTPLY
	move	A11,A0
	clr	A11
	CALLA	GETPLYR
	move	A0,*A13(PDBLOCK),L
	move	*A0(POBJ),A0,L
GotPlObj:
	move	A0,A7		;A7 = ptr to player obj

	calla	GETANIX
	move	A0,A1		;A1 = Xp (hypo)
	move	A8,A6
	move	A7,A8
	calla	GETANIX
	move	A6,A8
	sub	A0,A1
	abs	A1		;A1 = ABS (Xp-PlXp)
	move	*A8(OXVEL),A2,L
	move	*A7(OXVEL),A3,L
	sub	A3,A2
	abs	A2		;A2 = ABS (Xv-PlXv)
	sll	16,A1
	divu	A2,A1				
	move	A1,A3		;A3 = TIME

	;get desired Z velocity
	move	*A7(OZVEL+16),A1,W
	mpys	A3,A1
	move	*A7(OZPOS),A2,W
	add	A2,A1
	move	*A8(OZPOS),A2,W
	sub	A2,A1
	sll	16,A1
	divs	A3,A1		;A1 = desired Z velocity
	;adjust Z velocity
	move	*A8(OZVEL),A2,L
	sub	A2,A1		;A1 - desired Z vel delta
	movi	>10000,A0
	calla	ABSMAX		;clip A1 by A0
	add	A1,A2
	move	A2,*A8(OZVEL),L
	move	*A8(OYVEL),A2,L
	add	A1,A2
	move	A2,*A8(OYVEL),L

	;get desired Y velocity
	move	*A7(OYVEL+16),A5,W
	move	*A7(OZVEL+16),A2,W
	sub	A2,A5
	mpys	A3,A5
	move	*A7(OYPOS),A2,W
	move	*A7(OSIZEY),A1,W
	subk	5,A1
	movk	30,A0
	calla	MIN	;min of A0,A1->A0
	add	A0,A2
	add	A2,A5
	move	*A8(OYPOS),A2,W
	move	*A8(OSIZEY),A1,W
	add	A1,A2
	sub	A2,A5
	sll	16,A5
	divs	A3,A5		;A5 = desired Y velocity
	;adjust Y velocity
	move	A5,A1
	move	*A8(OYVEL),A2,L
	move	*A8(OZVEL),A3,L
	sub	A3,A2
	sub	A2,A1		;A1 - desired Y vel delta
	movi	>10000,A0
	calla	ABSMAX		;clip A1 by A0
	add	A1,A2
	add	A3,A2
	move	A2,*A8(OYVEL),L

DO_FRAME:
	calla	DFRMGRND
	cmpi	10,A1
	jrgt	HghtOk
	move	*A8(OYVEL),A0,L
	move	*A8(OZVEL),A1,L
	cmp	A0,A1
	jrge	HghtOk
	move	A1,*A8(OYVEL),L
HghtOk:

	callr	DoFrame
	movb	*A13(ANICTR),A0
	inc	A0
	cmpi	12,A0
	jrlt	AniCtOk
	clr	A0
AniCtOk:
	movb	A0,*A13(ANICTR)
	jruc	ShypoLp

SPINDONE:
	callr	DelHypo
	DIE
***************************************************************************

***************************************************************************
DoFrame:
	callr	GetFrame
	movk	4,A1
	JSRP	FRANIM
	callr	UpdTip		;Set Hypo Tips Anim, Position and Vel
	rets
***************************************************************************

***************************************************************************
GetFrame:
	mmtm	SP,A0
	move	*A13(SHAFTANI),A9,L
	movb	*A13(ANICTR),A0
	sll	6,A0	;2 longword offset
	add	A0,A9
	mmfm	SP,A0
	rets
***************************************************************************

***************************************************************************
UpdTip:
	mmtm	SP,A0,A1
	move	*A8(OXVEL),*A10(OXVEL),L
	move	*A8(OYVEL),*A10(OYVEL),L
	move	*A8(OZVEL),*A10(OZVEL),L
	move	*A8(OZVAL),A0,L
	dec	A0
	move	A0,*A10(OZVAL),L

	movb	*A13(ANICTR),A1
	move	*A13(TIPANI),A9,L
	sll	6,A1	;2 longword offset
	add	A1,A9
	movk	4,A1
	SWAP	A8,A10
	jsrp	FRANIM
	SWAP	A8,A10

	movb	*A13(ANICTR),A1
	sll	4,A1	;2 byte offset
	move	*A13(TIPTBL),A9,L
	add	A1,A9
	movb	*A9,A0
	addk	8,A9
	move	*A8(OXPOS),A1,W
	add	A0,A1
	move	A1,*A10(OXPOS),W
	movb	*A9,A0
	move	*A8(OYPOS),A1,W
	add	A0,A1
	move	A1,*A10(OYPOS),W
	
	mmfm	SP,A0,A1
	rets
***************************************************************************

***************************************************************************
TipColl:
	.WORD	P1OID
	.LONG	HCOLL1
	.WORD	P2OID
	.LONG	HCOLL1
	.WORD	0
	.LONG	DUMRTSG
ShftColl:
	.WORD	0
	.LONG	HYPOPPER

	.WORD	B1OID|BULLETID
	.LONG	HYPOPPER
	.WORD	B1OID|ROCKETID
	.LONG	HYPOPPER
	.WORD	B1OID|EXPLODID
	.LONG	HYPOPPER
	.WORD	B2OID|BULLETID
	.LONG	HYPOPPER
	.WORD	B2OID|ROCKETID
	.LONG	HYPOPPER
	.WORD	B2OID|EXPLODID
	.LONG	HYPOPPER
***************************************************************************

***************************************************************************
*HYPODERMIC NEEDLE Tip STICKING SOMEONE
*A0 - obj ptr of hypo Tip
*A8 - ptr to obj stuck
HCOLL1:
	move	A8,A11

	;* Remove objs from bullet list
	move	*A0(OPLINK),A0,L
	move	A0,A6
	calla	GETA8
	calla	GETA10
	movi	ENEMY_BULLETS,A1
	move	A10,A0
	calla	DELSUPP
	move	A8,A0
	calla	DELSUPP

	move	A6,A0
	movi	>00E5,A1
	movi	INJECT,A7
	calla	XFERPROC
	movi	1,A0		;stop collision scan
	RETS
***************************************************************************

***************************************************************************
*INJECT THE HYPO
INJECT:
;A11 ptr to stuck Pig
	move	A11,A0
	calla	GetPData
	move	A0,*A13(PDBLOCK),L
	move	*A0(POBJ),A1,L
	move	*A1(OXPOS),*A13(OLDXP),W
	move	*A1(OYPOS),*A13(OLDYP),W
	move	*A1(OZPOS),*A13(OLDZP),W

	calla	ClrVel
	move	A8,A7
	move	A10,A8
	calla	ClrVel
	move	A7,A8

	;* pivot hypo around tip
	move	*A10(OYPOS),A0,W
	move	*A10(OSIZEY),A1,W
	srl	1,A1
	add	A1,A0
	move	A0,*A8(OYPOS),W

	movi	HYPOSTCK,A0
	move	A0,*A13(SHAFTANI),L
	movi	TIPSTCK,A0
	move	A0,*A13(TIPANI),L
	move	*A8(OFLAGS),A0,W	
	btst	B_FLIPH,A0
	jrnz	InjFlp
	movi	STCKOFFNFLP,A0
	move	A0,*A13(TIPTBL),L
	jruc	GotTT
InjFlp:
	movi	STCKOFFFLP,A0
	move	A0,*A13(TIPTBL),L
GotTT:
	clr	A0
	movb	A0,*A13(SLPTIKS)
	movb	A0,*A13(ANICTR)
StckLp:
	movb	*A13(SLPTIKS),A0
	jrnz	SkInjAni
	callr	DoFrame
	movb	*A13(ANICTR),A0
	inc	A0
	movb	A0,*A13(ANICTR)
	movk	6,A0
SkInjAni:
	dec	A0
	movb	A0,*A13(SLPTIKS)

	;* update shaft position
	move	*A13(PDBLOCK),A0,L
	move	*A0(POBJ),A1,L
	jrz	SkInjUpd

	move	*A1(OZPOS),A0,W
	move	*A13(OLDZP),A2,W
	move	A0,*A13(OLDZP),W
	sub	A2,A0
	move	*A8(OZPOS),A2,W
	add	A0,A2
	move	A2,*A8(OZPOS),W
	move	*A10(OZPOS),A2,W
	add	A0,A2
	move	A2,*A10(OZPOS),W

	move	*A1(OXPOS),A0,W
	move	*A13(OLDXP),A2,W
	move	A0,*A13(OLDXP),W
	sub	A2,A0
	cmpi	10,A0	
	jrgt	StckX
	move	*A8(OXPOS),A2,W
	add	A0,A2
	move	A2,*A8(OXPOS),W
	move	*A10(OXPOS),A2,W
	add	A0,A2
	move	A2,*A10(OXPOS),W

	move	*A1(OYPOS),A0,W
	move	*A13(OLDYP),A2,W
	move	A0,*A13(OLDYP),W
	sub	A2,A0
	cmpi	10,A0	
	jrgt	StckX
	move	*A8(OYPOS),A2,W
	add	A0,A2
	move	A2,*A8(OYPOS),W
	move	*A10(OYPOS),A2,W
	add	A0,A2
	move	A2,*A10(OYPOS),W
SkInjUpd:

	SLEEP	1

	movb	*A13(ANICTR),A0
	cmpi	7,A0
	jrlt	StckLp


StckX:
	;* del the Hypo
	move	A8,A0
	calla	DELPAL
	calla	DELSOBJ
	move	A10,A0 
	calla	DELSOBJ
	DIE
***************************************************************************

***************************************************************************
*HYPODERMIC NEEDLE BUSTING AGAINST SOMETHING
*A0=OBLOCK PTR OF HYPO
*A0 - obj ptr of hypo Tip
*A8 - ptr to obj stuck
HYPOPPER:
	move	*A8(OID),A1,W
	sll	20,A1	;
	srl	28,A1 	;andi	>0F00,A1
	cmpi	>E,A1
	jrz	EnemyCol

	;* Remove objs from bullet list
	move	*A0(OPLINK),A0,L
	calla	GETA8
	calla	GETA10
	calla	KILL			;KILL THE CONTROLLING PROCESS
	callr	DelTip
	movi	ENEMY_BULLETS,A1
	MOVE	A8,A0
	CALLA	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	CREATE	INDPID,DINGANI		;MAKE THE DING PROC

	movi	1,A0	;stop collision scan
EnemyCol:
	RETS
***************************************************************************

***************************************************************************
TIPOFFCCW:	;used if thrower was not flipped
;* dist from Hypo TL to Tip TL
	.byte	29,3
	.byte	26,-5
	.byte	16,-11
	.byte	3,-11
	.byte	-5,-11
	.byte	-9,-5
	.byte	-11,3
	.byte	-9,19
	.byte	-5,29
	.byte	3,32
	.byte	16,29
	.byte	26,19
TIPOFFCW:	;thrower was flipped
;* dist from Hypo TL to Tip TL
	.byte	-11,3
	.byte	-9,-5
	.byte	-5,-11
	.byte	3,-11
	.byte	16,-11
	.byte	26,-5
	.byte	29,3
	.byte	26,19
	.byte	16,29
	.byte	3,32
	.byte	-5,29
	.byte	-9,19
***************************************************************************


;* INJECTION
HYPOSTCK:
	.long	HYPOB0
	.word	1,0
	.long	HYPOB02
	.word	1,0
	.long	HYPOB03
	.word	1,0
	.long	HYPOB03
	.word	1,0
	.long	HYPOB03
	.word	1,0
	.long	HYPOB03
	.word	1,0
	.long	HYPOB03
	.word	1,0
	LONGNULL
TIPSTCK:
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	.long	HYPOT0
	.word	1,0
	LONGNULL
STCKOFFNFLP:
	.byte	29,3
	.byte	24,3
	.byte	20,3
	.byte	20,3
	.byte	20,3
	.byte	20,3
	.byte	20,3
STCKOFFFLP:
	.byte	-11,3
	.byte	-11,3
	.byte	-11,3
	.byte	-11,3
	.byte	-11,3
	.byte	-11,3
	.byte	-11,3


	;* any frame without FLIPH set will inject plyr
HYPOCCW:
	.long	HYPOB0
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB90
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOB0
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB90
	.word	FLIPBITS|1,0
	.long	HYPOB60
	.word	FLIPBITS|1,0
	.long	HYPOB30
	.word	FLIPBITS|1,0
	LONGNULL
HTIPCCW:
	.long	HYPOT0
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT90
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOT0
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT90
	.word	FLIPBITS|1,0
	.long	HYPOT60
	.word	FLIPBITS|1,0
	.long	HYPOT30
	.word	FLIPBITS|1,0
	LONGNULL


	;* any frame with FLIPH set will inject plyr
HYPOCW:
	.long	HYPOB0
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOB90
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB0
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOB30
	.word	FLIPBITS|1,0
	.long	HYPOB60
	.word	FLIPBITS|1,0
	.long	HYPOB90
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB60
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOB30
	.word	FLIPBITS|1,M_FLIPH
	LONGNULL
HTIPCW:
	.long	HYPOT0
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	.long	HYPOT90
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT0
	.word	FLIPBITS|1,M_FLIPV
	.long	HYPOT30
	.word	FLIPBITS|1,0
	.long	HYPOT60
	.word	FLIPBITS|1,0
	.long	HYPOT90
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT60
	.word	FLIPBITS|1,M_FLIPH
	.long	HYPOT30
	.word	FLIPBITS|1,M_FLIPH
	LONGNULL

