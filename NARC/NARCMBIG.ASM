	.FILE	'NARCMBIG.ASM'
	.TITLE	" <<< N  A  R  C  -- Mister Big >>>"
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
;	.INCLUDE	"imgtbl.GLO"		;Image Label Equates
	.INCLUDE	"NARCTEQU.ASM"

	.TEXT
	.include	"narcmbig.tbl"

	.GLOBL	NARCS,FL1,FL2,FL3

	.globl	BIGBULL,bigbull
	.GLOBL	MBIGCRM1
	.GLOBL	LINEPT,LTWRDPT
	.globl	mrbigpal
	.globl	MB_MOVE		;to allow a breakpoint

	.GLOBAL		ADDMRBIG,P_MBIGS,P_GOLD,OUTMBIGS

***************************************************************************
; MBIG SUB_TYPES
; 0 - w/ no coors starts at PLZMIN and 1 to 2 full screens away from
;	players in X.  90% chance of coming up to the right.
; 1 - w/ no coors comes out any available door, else it reverts to type 0
DTBL:
	.long	D0,D0
	.long	D0,D0,D0,D0,D0,D0,D0
	.long	D0,D0,D0,D0,D0,D0,D0
***************************************************************************

	.BSS	mb_fpos,32,1
	.BSS	mb_lpos,32,1
	.BSS	pl_fpos,32,1
	.BSS	pl_lpos,32,1
	.BSS	nxtpdata,32,1
	.BSS	FaceDirs,32,1
	.BSS	ShtVels,32*2*3,1
	.BSS	ShtFPt,32,1

MBigGrav	.set	>1600
CrawlXV		.set	>40000

;Process Block Vars

;EXTRA OBJECT VARS
;long	BWHEEL,SWHEEL,ANIMNXT,SWANIM,BWANIM,ANIMTMP,NANIMTMP
;byte	FranPtr,FaceDir,VDAMP,Spin,FwdSpin,BWhlOn,SWhlOn,BWANTIKS,SWANTIKS
;byte	TURNTIKS,TurnTiks,WantDir,TurnDir
;* BWANTIKS, SWANTIKS
;	Big/Small Wheel Animation TIKS, these Tiks are Bytes (signed 4.3) 
BWHEEL	.set	>0
SWHEEL	.set	>20
WANTANIM	.set	>40
ANIMNXT	.set >60
SWANIM	.set	>80
BWANIM	.set	>A0
FranPtr	.set	>C0
FaceDir	.set	>C8
VDAMP	.set	>D0
Spin		.set	>D8
FwdSpin	.set	>E0
BWhlOn	.set	>E8
SWhlOn	.set	>F0
MBigFly		.set	>F8
BWANTIKS	.set	>100
SWANTIKS	.set	>108
TURNTIKS	.set	>110
TurnTiks	.set	>118
WantDir	.set	>120
TurnDir	.set	>128
ANIMTMP	.set	>130
NANIMTMP	.set	>150
YDEST	.set	>170
FaceTiks	.set	>180
burstct	.set	>188
runmode	.set	>190
HEALTH	.set	>198
MBLIVES	.set	>1A0
ROCKHIT .set	>1A8


;* direction for FaceDir
Fuv	.set	0
Fur	.set	1
Fhr	.set	2
Fdr	.set	3
Fdv	.set	4
Fdl	.set	5
Fhl	.set	6
Ful	.set	7

************************* FUNCTION TABLE ***************************
MBIG_FUNCS:
	.long	BOOF
	.long	GoDestV
	.long	GetXVel		;GetXVel
	.long	>7000	;MaxXZAngle
	.long	15	;FlipTiks
********************************************************************

********************************************************************
;To catch a nulled dereference through MBIG_FUNCS
BOOF:	jruc	$
********************************************************************

********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in GVARINIT
	.BSS	mbigmax,16,16
;	.BSS	mbigbrain,16,16	;U - max sleep between brain funcs
;	.BSS	mbigfire,16,16	;U - max sleep between brain funcs
	.BSS	ATTACKTIKS,16,16
	.bss	mbigburst,16,16		;# rounds to a burst

VARINIT:
	movi	1,A0
	move	A0,@mbigmax,W
	movk	15,A0
	move	A0,@ATTACKTIKS,W
	movk	4,A0
	move	A0,@mbigburst,W
	rets				;<------------------ remove
	movi	30,A0
	move	A0,@mbigfire,W
	movk	6,A0
	move	A0,@mbigbrain,W
	rets
**********************************************************

**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
MBIGINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	case1,MBIGZSIZ,MBIGCOLL
	.WORD	DMAWNZ,MBIGEOID
	.LONG	MBIGBLIP
**************************************************************************

**************************************************************************
MBIGCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT

	move	@SLPMBIGS,A0,W
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
	CREATE	MBIGEPID,MBIG	;allocate process?	(bashes A1,A7)
	jrz	ColdX
	dsjs	A2,ColdLp
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

**************************************************************************
MYENINITUL:
;* keep trying to initialize mrbig until success
TRYINIT:
	calla	ENINITUL	;CREATE MBIG
	jrnz	GOODINIT
	mmtm	A12,A1,A5,A6,A13,A14
	SLEEP	60
	mmfm	A12,A1,A5,A6,A13,A14
	jruc	TRYINIT
GOODINIT:
	retp
**************************************************************************
**************************************************************************
MYENINITLL:
;* keep trying to initialize mrbig until success
TRYINIT2
	calla	ENINITLL	;CREATE MBIG
	jrnz	GOODINIT2
	mmtm	A12,A1,A5,A6,A13,A14
	SLEEP	60
	mmfm	A12,A1,A5,A6,A13,A14
	jruc	TRYINIT2
GOODINIT2:
	retp
**************************************************************************


*********************  START OF MBIG PROCESS  ****************************
MBIG:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

	INCW	@SLPMBIGS
MaxWait:
	move	@mbigmax,A0,W
	move	@MBIGCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	DECW	@SLPMBIGS
	INCW	@MBIGCNT

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
	movi	MBIGINIT,A14
	calla	DOORRITE	;rets upper Y,X start pos in A1
	clr	A6 			;EMAINT (not using it)
	PUSHP	A11
	jsrp	MYENINITUL
	PULLP	A11

	move	A11,*A8(OID),W
	move	A8,A0
	calla	DELSHAD
	movi	->10000,A2	;X VELOCITY
	movi	WALKOUT,A9     	;GET ANIMATION SCRIPT
	JSRP	OUTDOOR
	move	A8,A0
;	calla	SHADST
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

GotCoors:
	move	A9,A1
	clr	A6 			;EMAINT (not using it)
	movi	MBIGINIT,A14	
	PUSHP	A11
	jsrp	MYENINITLL		;CREATE MBIG
	PULLP	A11
	move	A11,*A8(OID),W
;	jruc	InitEnmy


****************************************************************************
InitEnmy:
	calla	GETOBJ		;get OBJECT for extra field space
	jrz	MB_DIE1
	move	A0,A10
	calla	CLROBJ
	movi	25,A0
	movb	A0,*A10(HEALTH)

	calla	P_MBIGS
	movi	2,A0
	sub	A1,A0
	jrnn	GotBigs

	calla	P_GOLD		;if no gold card, dispatch a mr big
	jrnz	MB_DIE2
	clr	A0
GotBigs:
	movb	A0,*A10(MBLIVES)

MB_WARM:
	calla	ShadOff
	clr	A0
	movb	A0,*A10(BWhlOn)
	movb	A0,*A10(SWhlOn)
	calla	GETOBJ		;get OBJECT for Big Wheel
	jrz	MB_DIE2
	movi	DUMCOLL,A4
	move	A0,*A10(BWHEEL),L
	move	*A8(OPAL),*A0(OPAL),W
	move	*A8(OZPOS),*A0(OZPOS),W
	move	*A8(OFLAGS),*A0(OFLAGS),W
	move	A4,*A0(OCVECT),L
	movi	[4,4],A1
	move	A1,*A0(OZSIZ),L
	calla	GETOBJ		;get OBJECT for Small Wheel
	jrz	MB_DIE3
	move	A0,*A10(SWHEEL),L
	move	*A8(OPAL),*A0(OPAL),W
	move	*A8(OZPOS),*A0(OZPOS),W
	move	*A8(OFLAGS),*A0(OFLAGS),W
	move	A4,*A0(OCVECT),L
	movi	[4,4],A1
	move	A1,*A0(OZSIZ),L

	move	A13,*A8(OPLINK),L	;PROC LINK
	calla	ClrVel
	clr	A0
	move	A0,*A13(WANTOBJ),L
	move	A0,*A13(TIKCTRS),L
	move	A0,*A13(EBYTES),L
	movi	MBIG_FUNCS,A0
	move	A0,*A13(FUNCS),L
	move	@mbigfire,A0,W
	movb	A0,*A13(FIRETIKS)

	movi	Fhl,A0
	movb	A0,*A10(FaceDir)
	movb	A0,*A10(WantDir)
	clr	A0
	movb	A0,*A10(burstct)
	move	A0,*A10(ANIMTMP),L
	movb	A0,*A10(TurnDir)
	movb	A0,*A10(TurnTiks)
	movb	A0,*A10(FranPtr)
	movi	CASE1_T,A0
	move	A0,*A10(WANTANIM),L
	callr	GetFrame
	movk	1,A0
	movb	A0,*A10(FwdSpin)
	movk	1,A0
	movb	A0,*A10(Spin)

	movi	>79,A0		;* should give approximately 5% Damping
	movb	A0,*A10(VDAMP)
	movi	MBIGCOLL,A0
	move	A0,*A8(OCVECT),L
	jruc	MB_MOVE
**************************************************************************


**************************************************************************
MB_MOVE:
	movb	*A10(Spin),A0
	callr	SetSpeed	;remove this eventually

;	callr	Attack
	callr	DfltMove
	callr	MB_XCHECK
	callr	DNGR		;danger must override X bounds
	callr	MB_ZCHECK	;Z bounds must override danger

	callr	MB_FIRE

	callr	CkTurn

	movb	*A13(ANIMTIKS),A0
	jrnz	SkAni
	jsrp	DoFrame
SkAni:
	callr	VelAdj
	callr	WheelAnim

	movb	*A13(ANIMTIKS),A0
	jrnn	ATok
;	jruc	$
	movk	1,A0
ATok:
	dec	A0
	movb	A0,*A13(ANIMTIKS)

	movb	*A10(BWhlOn),A0
	jrz	SkBWTIKS
	movb	*A10(BWANTIKS),A0
	jrnn	BTok
;	jruc	$
	movk	8,A0
BTok:
	subk	>8,A0
	movb	A0,*A10(BWANTIKS)
SkBWTIKS:

	movb	*A10(SWhlOn),A0
	jrz	SkSWTIKS
	movb	*A10(SWANTIKS),A0
	jrnn	STok
;	jruc	$
	movk	8,A0
STok:
	subk	>8,A0
	movb	A0,*A10(SWANTIKS)
SkSWTIKS:

	movb	*A10(TurnTiks),A0
	jrz	SkTrnTik
	jrnn	TTok
;	jruc	$
	movk	1,A0
TTok:
	dec	A0
	movb	A0,*A10(TurnTiks)
SkTrnTik:

	movb	*A13(FIRETIKS),A0
	jrz	SkFireTk
	dec	A0
	movb	A0,*A13(FIRETIKS)
SkFireTk:

	movb	*A10(FaceTiks),A0
	jrz	SkFaceTk
	dec	A0
	movb	A0,*A10(FaceTiks)
SkFaceTk:

	SLEEP	1
	jruc	MB_MOVE
**************************************************************************

**************************************************************************
SetSpeed:
	movb	A0,*A10(Spin)
	sll	2,A0
	neg	A0
	addk	20,A0
	movb	A0,*A10(TURNTIKS)
	rets
**************************************************************************

**************************************************************************
DfltMove:
	movb	*A10(FaceTiks),A0
	jrnz	DfltMvX
	movb	*A10(burstct),A0
	jrnz	DfltMvX

	move	@WORLDTL,A1,W
	addi	256,A1		;Center of screen X
	calla	GETANIX
	sub	A1,A0
	move	A0,A4
	movb	*A10(runmode),A0
	jrnn	SkNegDir
	neg	A4
SkNegDir:
	move	A4,A4
	jrn	GoRght
	;Go Left
	movk	6,A3
	jruc	NewDSet
GoRght:
	movk	2,A3
NewDSet:
	move	*A8(OZPOS),A1,W
	movi	P1DATA,A2
	move	*A2(POBJ),A2,L
	jrz	CkP2Z
	move	*A2(OZPOS),A2,W
	sub	A1,A2
	abs	A2
	cmpi	30,A2
	jrgt	CkP2Z
	movk	3,A0
	calla	RANDU
	subk	2,A0
	add	A0,A3
CkP2Z:
	movi	P2DATA,A2
	move	*A2(POBJ),A2,L
	jrz	ZCKX
	move	*A2(OZPOS),A2,W
	sub	A1,A2
	abs	A2
	cmpi	30,A2
	jrgt	ZCKX
	movk	3,A0
	calla	RANDU
	subk	2,A0
	add	A0,A3
ZCKX:
	move	A3,A0
	movb	A0,*A10(WantDir)
	callr	SetTDir

	abs	A4
	cmpi	35,A4
	jrgt	SkNewRM
	movb	@RAND,A0
	movb	A0,*A10(runmode)
SkNewRM:
	movk	4,A0
	cmpi	250,A4
	jrle	GotSpd
	dec	A0
	cmpi	450,A4
	jrle	GotSpd
	clr	A1
	movb	A1,*A10(runmode)
	dec	A0
GotSpd:	
	callr	SetSpeed

	movb	@ATTACKTIKS,A0
	movb	A0,*A10(FaceTiks)
DfltMvX:
	rets
**************************************************************************


**************************************************************************
Attack:
	movb	*A10(FaceTiks),A0
	jrnz	AttackX
	movb	@ATTACKTIKS,A0
	movb	A0,*A10(FaceTiks)

	calla	SELCTPLY
	move	A11,A0
	calla	GETPLYR
	move	*A0(POBJ),A0,L
	callr	GetDirP
	movb	A0,*A10(WantDir)
	callr	SetTDir

AttackX:
	rets
**************************************************************************

**************************************************************************
DNGR:
	calla	NEAR_BUL	;later, may need to check mbig's vel
	move	A5,A5
	jrz	DNGRX
	cmpi	200,A6
	jrgt	DNGRX
	move	*A5(OXVEL),A0,W
	movb	*A10(FaceDir),A1
	cmpi	Fuv,A1
	jrz	DNGRX
	cmpi	Fdv,A1
	jrz	DNGRX
	jrlt	FaceRt
	neg	A0
FaceRt:	;* If bullet is heading toward back, its vel is now pos.
	move	A0,A0
	jrp	BinBack
	;* bullet heading toward front
	callr	CaseFrnt	;attempts to get animation of case in front
		
BinBack:
	cmpi	100,A6
	jrgt	DNGRX
;	callr	CaseBack
DNGRX:
	rets
**************************************************************************

**************************************************************************
CaseFrnt:
;* as quickly as possible get animation to CASE4
;* implies horizontal motion
	movk	1,A3			;used to set TurnDir
	movb	*A10(FaceDir),A0
	cmpi	Fdv,A0
	jrlt	FaceRt2
	;* Facing left
	movk	Fhl,A2			;used to set WantDir
	cmp	A2,A0
	jrz	GoCase4
	jrlt	SetTurn
	neg	A3
	jruc	SetTurn
FaceRt2:
	movk	Fhr,A2			;used to set WantDir
	cmp	A2,A0
	jrz	GoCase4
	jrlt	SetTurn
	neg	A3
;	jruc	SetTurn

SetTurn:
	movb	A3,*A10(TurnDir)
	movb	A2,*A10(WantDir)
	movb	*A10(TurnTiks),A0
	movk	8,A1
	cmp	A1,A0
	jrle	TTikOk
	movb	A1,*A10(TurnTiks)
TTikOk:
	jruc	CaseFX

GoCase4:
	movb	*A13(ANIMTIKS),A0
	jrz	CaseAnim
	cmpi	5,A0
	jrle	CaseFX
CaseAnim:
	;* moving horizontally toward bullet, attempt to reach case4 frame
	move	*A10(ANIMNXT),A0,L
	cmpi	CASE1_T,A0
	jrlt	GC1
	cmpi	CASE_TX,A0
	jrgt	GC1
	;* already in case animation
	move	*A0,A0,L
	cmpi	CASE1,A0
	jreq	GC4
	cmpi	CASE4,A0
	jreq	CaseFX	
	cmpi	CASE5,A0
	jreq	GC4
;	cmpi	CASE9,A0
;	jrz	GC5
GC5:
	movi	CASE5_T,A0
	move	A0,*A10(ANIMNXT),L
	jruc	CaseFX
GC4:
	movi	CASE4_T,A0
	move	A0,*A10(ANIMNXT),L
	jruc	CaseFX
GC1:
	movi	CASE1_T,A0
	move	A0,*A10(ANIMNXT),L
;	jruc	CaseFX

CaseFX:
	rets
**************************************************************************

**************************************************************************
GetPCoor:
;* TAKES ptr to player obj in A0
;* RETURNS Z:X coors of player in A0
	mmtm	SP,A1,A8
	move	A0,A8
	move	*A0(OZPOS),A1,W
	sll	16,A1
	calla	GETANIX	;A0 - player X
	movy	A1,A0
	mmfm	SP,A1,A8
	rets
**************************************************************************

**************************************************************************
GetDirP:
;* gets direction from Obj in A8 to Player Obj in A0
	callr	GetPCoor
	jruc	GetDir
**************************************************************************

**************************************************************************
GetDir:
;* gets direction from Obj in A8 to Z:X coors in A0, where dir
;* is expressed as
;*	7 0 1 
;*	6 * 2
;*	5 4 3
;* The direction is returned in A0

	mmtm	SP,A2,A3,A4,A5

	movy	A0,A3
	srl	16,A3
	movx	A0,A2
	zext	A2,W

	calla	GETANIX		;A0 - MBIG X
	sub	A0,A2		;A2 = XDELTA	
	move	*A8(OZPOS),A0,W
	sub	A0,A3		;A3 = ZDELTA
	move	A2,A4
	move	A3,A5
	abs	A4
	abs	A5
	sll	16,A5
	clr	A0	;set Direction
	divu	A4,A5	;A5 = A5/A4 = ABS(ZDELTA)/ABS(XDELTA) = TAN(THETA) 	
	jrv	GotD0	;Overflow indicates XDELTA=0
	cmpi	>269FB,A5	;Tan(22.5deg) = 2.414 as 16.16
	jrgt	GotD0
	inc	A0
	cmpi	>69FB,A5	;Tan(67.5deg) = .414 as 16.16
	jrgt	GotD0
	inc	A0

GotD0:
	;* Must Adjust for Quadrant
	move	A2,A2	;check sign of XDELTA
	jrn	Q34
	move	A3,A3	;ck sign of ZDELTA
	jrn	Q1
	;* Quadrant 2, X+,Z+
	neg	A0
	addk	4,A0
	jruc	GotD1
Q34:
	move	A3,A3	;ck sign of ZDELTA
	jrn	Q4
Q3:
	;* Quadrant 3, X-,Z+
	addk	4,A0
     	jruc	GotD1
Q4:
	;* Quadrant 4, X-,Z-
	neg	A0
	jrz	GotD1
	addk	8,A0
     	jruc	GotD1
Q1:
	;* Quadrant 1, X+,Z-
GotD1:
	mmfm	SP,A2,A3,A4,A5
	rets
**************************************************************************

**************************************************************************
SetTDir:
;* takes a direction 0-7 in A0 which is desired and current direction
;* in FaceDir, and sets TurnDir for quickest turn									
	mmtm	SP,A1,A2
	movk	1,A2
	movb	*A10(FaceDir),A1
	sub	A0,A1
	jrn	WantBig
	;* wantdir < FaceDir
	cmpi	4,A1
	jrgt	GotTDir
	neg	A2
	jruc	GotTDir
WantBig:
	;* wantdir > FaceDir
	abs	A1
	cmpi	4,A1
	jrlt	GotTDir
	neg	A2
;	jruc	GotTDir
GotTDir:
	movb	A2,*A10(TurnDir)
	mmfm	SP,A1,A2
	rets
**************************************************************************


**************************************************************************
Fire2:
;* check each of three forward facing directions and see which comes
;* closest to giving a shot at either player..
;*RETURNS
;setc - Good Shot Found, FaceDir is set
;clrc - no shot

	;* set mr Bigs position
	calla	GETANIX	;A0 - player X
	move	*A8(OZPOS),A1,W
	sll	16,A1
	movx	A0,A1			;A1 - mrbig Y:X

	;* Out of Range?
	move	@WORLDTLX+16,A2,W
	addi	256,A2
	sub	A0,A2
	abs	A2
	cmpi	320,A2
	jrgt	Fire2X

	move	A1,@mb_fpos,L
	move	*A8(OZVEL),A2,L
	sla	3,A2			;multiply by 8
	move	*A8(OXVEL),A3,L
	sra	13,A3			;multiply by 8
	movx	A3,A2
	addxy	A1,A2
	move	A2,@mb_lpos,L

	movb	*A10(FaceDir),A1
	move	A1,A7		;save FaceDir
	dec	A1
	movk	3,A14		;# facedirs
	movi	FaceDirs,A2
	movi	ShtVels,A3
GetShtVs:
	move	A1,A0
	inc	A1
	callr	Modulo8
	movb	A0,*A10(FaceDir)
	movb	A0,*A2
	addk	8,A2
	callr	BullXV0
	move	A0,*A3+,L
	callr	BullZV0
	move	A0,*A3+,L
	dsjs	A14,GetShtVs
	movb	A7,*A10(FaceDir)	;restore FaceDir

	movi	P1DATA,A0,L
	movi	P2DATA,A1,L
	movb	@RAND,A2
	jrn	SkSwPls
	SWAP	A0,A1
SkSwPls:
	move	A1,@nxtpdata,L
trypdata:
	move	*A0(POBJ),A3,L
	jrz	trynxtp

	;* calc pl_fpos, pl_lpos
	move	A3,A0	
	callr	GetPCoor
	move	A0,@pl_fpos,L
	move	*A3(OZVEL),A2,L
	sla	3,A2			;multiply by 8
	move	*A3(OXVEL),A4,L
	sra	13,A4			;multiply by 8
	movx	A4,A2
	addxy	A0,A2
	move	A2,@pl_lpos,L

	movi	FaceDirs,A5
	movi	ShtVels,A6
	movk	3,A14
TrySht:
	move	@pl_fpos,A0,L
	move	A0,A4
	move	@mb_fpos,A1,L
	move	*A6+,A2,L
	move	*A6+,A3,L
	calla	LTWRDPT
	jrnc	TryNxtS
	calla	LINEPT
	callr	ShotOk
	jrnc	TryNxtS
	move	A0,@ShtFPt,L
	move	@pl_lpos,A0,L
	move	A0,A4
	move	@mb_lpos,A1,L
	calla	LTWRDPT
	jrnc	TryNxtS
	calla	LINEPT
	callr	ShotOk
	jrnc	TryNxtS
	callr	ShotsOk
	jrnc	TryNxtS
	;* we have a good shot..
	movb	*A5(0),*A10(WantDir)
	setc
	jruc	FireIt
TryNxtS:	
	addk	8,A5		;advance to next FaceDir
	dsj	A14,TrySht

trynxtp:
	;* try other player
	move	@nxtpdata,A0,L
	jrz	Fire2X
	clr	A1
	move	A1,@nxtpdata,L
	jruc	trypdata

Fire2X:
	clrc
FireIt:
       rets
**************************************************************************

**************************************************************************
Modulo8:
;* add or subtract 8 to A0 until in range 0-7
	cmpi	8,A0
	jrlt	Max8Ok
	subk	8,A0
	jruc	Modulo8
Max8Ok:
	move	A0,A0
	jrnn	Mod8X
Mod8Low:
	addk	8,A0
	jrn	Mod8Low
Mod8X:
	rets
**************************************************************************

**************************************************************************
ShotsOk:
;* Return SETC if box w/ crnrs
;	A0=ShtLPt,ShtFPt
;* intersects box w/ crnrs
;	pl_fpos, pl_lpos
	mmtm	SP,A0,A1,A2,A3,A4,A5

	move	@ShtFPt,A1,L

	;make A0 be TL of Shot Points, A1 be BR
	movx	A0,A4
	movx	A1,A5
	cmpxy	A4,A5
	jrxge	GotShtX
	SWAP	A4,A5
GotShtX:
	cmpxy	A0,A1
	jryge	GotShtY
	SWAP	A0,A1
GotShtY:
	movx	A4,A0
	movx	A5,A1

	;make A2 be TL of pl_pos, A3 be BR
	move	@pl_fpos,A2,L
	move	@pl_lpos,A3,L
	movx	A2,A4
	movx	A3,A5
	cmpxy	A4,A5
	jrxge	GotPlX
	SWAP	A4,A5
GotPlX:
	cmpxy	A2,A3
	jryge	GotPlY
	SWAP	A2,A3
GotPlY:
	movx	A4,A2
	movx	A5,A3

	movi	[10,15],A4	;pad size for earlier box intersect
	subxy	A4,A2
	addxy	A4,A3
	
	;* if ShtTL > PlBR, shots no good
	cmpxy	A3,A0
	jrxgt	ShotsBad
	jrygt	ShotsBad

	;* if ShtBR < PlTL, shots no good
	cmpxy	A2,A1
	jrxlt	ShotsBad
	jrylt	ShotsBad

	mmfm	SP,A0,A1,A2,A3,A4,A5
	setc
	rets

ShotsBad:
	movi	[1,1],A4	;easier box intersect for "you die" snd
	subxy	A4,A2
	addxy	A4,A3

	;* if ShtTL > PlBR, shots no good
	cmpxy	A3,A0
	jrxgt	SkThreat
	jrygt	SkThreat

	;* if ShtBR < PlTL, shots no good
	cmpxy	A2,A1
	jrxlt	SkThreat
	jrylt	SkThreat

	movi	MBYOUDIE,A0
	calla	ONESND
SkThreat:

	mmfm	SP,A0,A1,A2,A3,A4,A5
	clrc
	rets
**************************************************************************

**************************************************************************
ShotOk:
;* return SETC if point in A0 within range of point in A4
	mmtm	SP,A5
	subxy	A0,A4		;A4 dist shot came from player
	move	A4,A5
	sext	A5,W
	abs	A5
	cmpi	40,A5		;check X dist
	jrgt	ShotWide
	sra	16,A4
	abs	A4
	cmpi	30,A5		;check Z dist
	jrgt	ShotWide
	mmfm	SP,A5
	setc
	rets
ShotWide:
	mmfm	SP,A5
	clrc
	rets
**************************************************************************

**************************************************************************
MB_FIRE:
	movb	*A13(FIRETIKS),A0
	jrnz	FireX

	movb	*A10(burstct),A0
	jrnz	Shoot
	
	callr	Fire2
	jrnc	NoFire

	;* Going to Shoot, Setup Chair for best shot
	clr	A0
	movb	A0,*A10(TurnTiks)
	movb	*A10(WantDir),A0
	callr	SetTDir
	callr	CkTurn
	movk	5,A0
	movb	A0,*A10(Spin)
	;* reanimate
	jsrp	DoFrame
;	jruc	Shoot

Shoot:
	movk	3,A1
	movb	*A10(burstct),A0
	dec	A0
	jrp	DoBurst
	jrz	BigFWait
	movb	@mbigburst,A0
	jruc	DoBurst
BigFWait:
	move	@mbigfire,A1,W
DoBurst:
	movb	A1,*A13(FIRETIKS)
	movb	A0,*A10(burstct)

	CREATE	MBBULPID,BigBull
	jrz	NoFire
	move	A0,A1
	clr	A0
	callr	BullSet

	CREATE	MBBULPID,BigBull
	jrz	NoFire
	move	A0,A1
	movk	1,A0
	callr	BullSet
	jruc	FireX
	
NoFire:
	movk	5,A0
	movb	A0,*A13(FIRETIKS)
FireX:
	rets
**************************************************************************

**************************************************************************
BullOff0:
	;offsets X,Y(from bot of frame),Z,pad
	.byte	5,-44,-2,0	;Dir = 0
	.byte	45,-36,3,0	;Dir = 1
	.byte	43,-36,2,0	;Dir = 2
	.byte	27,-39,2,0	;Dir = 3
	.byte	5,-37,1,0	;Dir = 4
	.byte	21,-39,2,0	;Dir = 5
	.byte	11,-36,2,0	;Dir = 6
	.byte	6,-36,3,0	;Dir = 7

BullOff1:
	;offsets X,Y(from bot of frame),Z,pad
	.byte	34,-44,-2,0	;Dir = 0
	.byte	30,-44,-5,0	;Dir = 1
	.byte	39,-40,-2,0	;Dir = 2
	.byte	46,-44,-3,0	;Dir = 3
	.byte	34,-37,1,0	;Dir = 4
	.byte	2,-44,-3,0	;Dir = 5
	.byte	15,-40,-2,0	;Dir = 6
	.byte	21,-44,-5,0	;Dir = 7
**************************************************************************

**************************************************************************
FLAMINIT:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	sflame0,>0,DUMCOLL	;ZSIZ
	.WORD	DMAWNZ,EFF0OID	;OBJ ID
	.LONG	0
**************************************************************************

**************************************************************************
BullSet:
;A0 - which bullet (0,1)
;A1 - ptr to bullet process
;* set following fields in proc block
;ETEMP1-Xvel	
;ETEMP2-Zvel
;ETEMP3-Xpos
;ETEMP3+16-Ypos
;ETEMP4-Zpos

	movi	BullOff0,A7
	move	A0,A0
	jrz	GotBOff
	movi	BullOff1,A7
GotBOff:
	movb	*A10(FaceDir),A0
	sll	5,A0		;Each entry is 4 bytes
	add	A0,A7

	callr	BullXV0
	move	A0,*A1(ETEMP1),L	;set XVEL
	callr	BullZV0
	move	A0,*A1(ETEMP2),L	;set ZVEL

	movb	*A7,A2
	addk	8,A7
	move	*A8(OXPOS),A0,W
	add	A2,A0
	move	A0,A4
	move	A0,*A1(ETEMP3),W	;set XPOS

	move	*A8(OZPOS),A0,W
	move	A0,A3
	addi	ZORIGIN,A0
	movb	*A7,A2
	addk	8,A7
	add	A0,A2
	move	A2,*A1(ETEMP3+16),W	;set YPOS

	movb	*A7,A0
	add	A0,A3
	move	A3,*A1(ETEMP4),W	;set ZPOS

	;* Make A Flash For The Bullet
	move	A8,A6	;save A8
	calla	GETOBJ
	jrz	NoFObj
	move	A0,A8
	movi	FLAMINIT,A14
	calla	STFOBJ
	movb	*A10(FaceDir),A11	;pass direction of flash
	CREATE	0EFFH,BigFlash	;SOMETHING TO WATCH THE FLASH
	jrz	NoFProc

	move	A4,*A8(OXPOS),W
	move	A3,*A8(OZPOS),W
	move	A2,*A8(OYPOS),W
	move	*A6(OXVEL),*A8(OXVEL),L
	move	*A6(OZVEL),*A8(OZVEL),L
	move	*A6(OYVEL),*A8(OYVEL),L
NoFObj:
	move	A6,A8   ;restore A8
	rets

NoFProc:
	calla	FREEOBJ
	jruc	NoFObj
**************************************************************************


**************************************************************************
BigFlash:
	MOVI	mrbigpal,A0
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	jrz	PalX
	MOVE	A0,*A8(OPAL),W

	move	A13,*A8(OPLINK),L
	move	A8,A0
	calla	INSOBJ
;	movi	ENEMY_BULLETS,A1	;need col vector if this is done
;	calla	ADDSUPP			;ADD TO SUPPLEMENTAL List

	movi	SFLAMES,A9
	sll	6,A11		;shift by 2 longwords
	add	A11,A9
	movk	4,A1
	jsrp	FRANIM

	SLEEP	4

	move	A8,A0			;GET THE BLOCK
	CALLA	DELPAL
;	movi	ENEMY_BULLETS,A1
;	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
PalX:
	move	A8,A0
	calla	DELOBJ
	DIE
**************************************************************************


**************************************************************************
BullXV0:
	mmtm	SP,A3
	movb	*A10(FaceDir),A0
	sll	4,A0
	addi	BXVDTbl,A0
	move	*A0,A0,W
	movi	>C00,A3		;>A00 << 7  =  >50000
	mpys	A0,A3
	move	*A8(OXVEL),A0,L
	add	A3,A0
	mmfm	SP,A3
	rets
BXVDTbl:
	;>7f = 1 in .8 fmt, >5A = .707 in .8 fmt
	.word	0,>5A,>7F,>5A,0,->5A,->7F,->5A
**************************************************************************

**************************************************************************
BullZV0:
	mmtm	SP,A3
	movb	*A10(FaceDir),A0
	sll	4,A0
	addi	BZVDTbl,A0
	move	*A0,A0,W
	movi	>C00,A3		;>A00 << 7  =  >50000
	mpys	A0,A3
	move	*A8(OZVEL),A0,L
	add	A3,A0
	mmfm	SP,A3
	rets
BZVDTbl:
	;>7f = 1 in .8 fmt, >5A = .707 in .8 fmt
	.word	->7F,->5A,0,>5A,>7F,>5A,0,->5A
	rets
**************************************************************************


**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
*	.LONG	SCANNERBLIP
BBullInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	bigbull,>00020002,BBullCol
	.WORD	DMAWNZ,BEOID
	.LONG	0
**************************************************************************

**************************************************************************
BigBull:
;* Mr. Big Bullet Process
	MOVI	EBSND,A0
	CALLA	ONESND		;make bullet fire sound
	calla	GETOBJ
	jrz	BigBullX
	move	A0,A8
	movi	BBullInit,A14
	calla	STFOBJ

	;* get parms from creator
	move	*A13(ETEMP1),*A8(OXVEL),L
	move	*A13(ETEMP2),A0,L
	move	A0,*A8(OZVEL),L
	move	A0,*A8(OYVEL),L
	move	*A13(ETEMP3),*A8(OXPOS),W
	move	*A13(ETEMP3+16),*A8(OYPOS),W
	move	*A13(ETEMP4),*A8(OZPOS),W

	move	*A8(OXVEL),A0,L
	jrn	NoFlp
	calla	YFLP
	jruc	FlpSet
NoFlp:
	calla	NOYFLP
FlpSet:

	;* allocate palette
	MOVI	mrbigpal,A0
;	MOVI	NARCS,A0
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	jrz	NoPal
	MOVE	A0,*A8(OPAL),W

	move	A13,*A8(OPLINK),L
	move	A8,A0
	calla	INSOBJ
	movi	ENEMY_BULLETS,A1
	calla	ADDSUPP			;ADD TO SUPPLEMENTAL List
	calla	SHADST

	movi	90,A0		;dflt max sleep for bullets
	calla	BullSlp
	move	A0,A10

BullFly0:
	movi	BIGBULL,A9
;	movi	BIGFLAME,A9
BullFly:
	move	A10,A10
	jrz	BullDone
	movk	4,A1
	jsrp	FRANIM
	cmp	A0,A10
	jrge	SlpOk
	move	A10,A0
SlpOk:
	sub	A0,A10
	calla	PRCSLP
	move	*A9,A1,L
	jrnz	BullFly
	jruc	BullFly0

BullDone:
	move	A11,A11
	jrz	SkWallHit
	MOVI	ENEMY_BULLETS,A1
	MOVE	A8,A0
	CALLA	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	jauc	DINGANI
SkWallHit:
	move	A8,A0			;GET THE BLOCK
	CALLA	DELPAL
	movi	ENEMY_BULLETS,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	calla	DELSOBJ			;ZAP IT
BigBullX:
	DIE
NoPal:
	calla	FREEOBJ
	DIE
**************************************************************************

**************************************************************************
BBullCol:
	.WORD	P1OID
	.LONG	hitplyr
	.WORD	P2OID
	.LONG	hitplyr
	.WORD	B1OID|BULLETID
	.LONG	mbbcol
	.WORD	B1OID|EXPLODID
	.LONG	mbbcol
	.WORD	B1OID|ROCKETID
	.LONG	mbbcol
	.WORD	B2OID|BULLETID
	.LONG	mbbcol
	.WORD	B2OID|EXPLODID
	.LONG	mbbcol
	.WORD	B2OID|ROCKETID
	.LONG	mbbcol
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
hitplyr:
	mmtm	SP,A0
	movi	100,A0
	calla	RANDPER
	jrnc	NoLaugh
	movi	MBLAUGH,A0
	calla	ONESND
NoLaugh:
	create	MBIGLPID,LghWatch	;A8 is player obj?
	mmfm	SP,A0
mbbcol:
	MOVI	DUMCOLL,A14
	MOVE	A14,*A0(OCVECT),L	;COLLISION POINTER
	CALLA	DELPAL
	movi	ENEMY_BULLETS,A1
	CALLA	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	CALLA	DELSOBJ
	MOVE	*A0(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	
	clr	A0	;don't teminate collision scan
	rets
**************************************************************************

**************************************************************************
KilLaugh:
;* function to kill laugh watch procs
	mmtm	SP,A0,A1
KillLPID:
	NOMATCHP	MBIGLPID,>FFFF,SkLKill
	calla	KILL
	jruc	KillLPID
SkLKill:
	mmfm	SP,A0,A1
	rets
**************************************************************************

**************************************************************************
LghWatch:
;* PROCESS TO WATCH IF Player Dies Shortly after being shot..
; Laugh if he does :-)
	move	A8,A0
	calla	GetPData
	move	A0,A9

	movk	30,A10
LWtchLp:
	SLEEP	6
	;check if player is dead
	move	*A9(PFLAGS),A0,L
	btst	BDEAD,A0
	jrnz	HaHa
	dsj	A10,LWtchLp
	jruc	LWatchX
HaHa:
	movi	MBLAUGH,A0
	calla	ONESND
	SLEEP	70
	movb	@RAND,A0
	jrn	LWatchX
	move	@RAND,A0,W
	jrn	HaHa

LWatchX:
	DIE
**************************************************************************

**************************************************************************
CkTurn:
	movb	*A10(TurnDir),A3
	jrz	SkDoTurn
	movb	*A10(TurnTiks),A0
	jrnz	SkDoTurn

	movb	*A10(WantDir),A1
	movb	*A10(FaceDir),A2
	cmp	A1,A2
	jrnz	TNotDone
	;* Turn is finished
	clr	A0
	movb	A0,*A10(TurnDir)
	jruc	SkDoTurn

TNotDone:
	movb	*A10(TURNTIKS),*A10(TurnTiks)
	add	A3,A2
	jrn	WrapMaxD
	cmpi	7,A2
	jrle	GotNewD
	clr	A2
	jruc	GotNewD
WrapMaxD:
	movk	7,A2
GotNewD:
	movb	A2,*A10(FaceDir)
	callr	GetFrame

SkDoTurn:
	rets
**************************************************************************

**************************************************************************
StopZV:
	move	*A8(OZVEL),A0,L
	clr	A1
	move	A1,*A8(OZVEL),L
	move	*A8(OYVEL),A1,L
	sub	A0,A1
	move	A1,*A8(OYVEL),L
	rets
**************************************************************************

**************************************************************************
MB_ZCHECK:
	move	*A8(OZPOS),A0,W
	move	A0,A2
	move	@PLZMIN,A1,W	
	sub	A1,A0
	cmpi	15,A0
	jrgt	CkZBot
	cmpi	5,A0
	jrle	OffTop		;kill Upward ZV and turn down
	;* Between 15 and 5 pixels of top boundary
	movb	*A10(burstct),A0
	jrnz	ZCHECKX
	movk	Fhr,A0
	movk	Fhl,A1
	movb	*A10(WantDir),A2
	cmp	A0,A2
	jrlt	NearTp
	cmp	A1,A2
	jrgt	NearTp
	jruc	ZCHECKX
NearTp:	
	cmpi	Fdv,A2
	jrlt	WntRght
	move	A1,A0
WntRght:
	movb	A0,*A10(WantDir)
	clr	A0
	movb	A0,*A10(TurnTiks)
	jruc	ZCHECKX
	
CkZBot:
	move	@PLZMAX,A1,W
	sub	A2,A1
	cmpi	15,A1
	jrgt	ZCHECKX
	cmpi	5,A1
	jrle	OffBot

	;* Between 15 and 5 pixels of bot boundary
	movb	*A10(burstct),A0
	jrnz	ZCHECKX
	movk	Fhr,A0
	movk	Fhl,A1
	movb	*A10(WantDir),A2
	cmp	A0,A2
	jrle	ZCHECKX
	cmp	A1,A2
	jrge	ZCHECKX

	jrlt	WntRght1
	move	A1,A0
WntRght1:
	movb	A0,*A10(WantDir)
	clr	A0
	movb	A0,*A10(TurnTiks)
	jruc	ZCHECKX

OffTop:
	move	*A8(OZVEL),A0,L
	jrnn	ZVok1
	callr	StopZV
ZVok1:
	movk	Fdr,A0
	movb	*A10(FaceDir),A1
	cmpi	Fdv,A1
	jrlt	ZRgtD
	movk	Fdl,A0
ZRgtD:
	movb	A0,*A10(WantDir)
	callr	SetTDir
	jruc	ZCHECKX

OffBot:
	move	*A8(OZVEL),A0,L
	jrn	ZVok2
	callr	StopZV
ZVok2:
	movk	Fur,A0
	movb	*A10(FaceDir),A1
	cmpi	Fdv,A1
	jrlt	ZRgtU
	movk	Ful,A0
ZRgtU:
	movb	A0,*A10(WantDir)
	callr	SetTDir
;	jruc	ZCHECKX
	
ZCHECKX:
	rets
**************************************************************************

**************************************************************************
MB_XCHECK:
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	addi	700,A2
	cmp	A2,A0			;IS IT PAST THE RT?
	jrgt	OffRite

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	subi	700,A2
	move	*A8(OSIZE),A1,W
	add	A0,A1			;RIGHT EDGE OF OBJECT
	cmp	A2,A1
	jrlt	OffLeft
	clrc
	rets

OffRite:
	movb	*A10(WantDir),A1
	movk	Fhl,A0
	cmp	A0,A1
	jreq	RiteX
	movb	A0,*A10(WantDir)

	movk	1,A2
	calla	GetPLZMID
	move	*A8(OZPOS),A1,W
	cmp	A0,A1
	jrle	GotRotD
	neg	A2
GotRotD:
	movb	A2,*A10(TurnDir)
RiteX:
	setc
	rets

OffLeft:
	movk	4,A0
	callr	SetSpeed
	movb	*A10(WantDir),A1
	movk	Fhr,A0
	cmp	A0,A1
	jreq	LeftX
	movb	A0,*A10(WantDir)

	movk	1,A2
	calla	GetPLZMID
	move	*A8(OZPOS),A1,W
	cmp	A0,A1
	jrgt	GotRotD2
	neg	A2
GotRotD2:
	movb	A2,*A10(TurnDir)

LeftX:
	setc
	rets
**************************************************************************

**************************************************************************
WheelAnim:
	movb	*A10(BWhlOn),A0
	jrz	SkBWAn
	movb	*A10(BWANTIKS),A6
	jrp	SkBWAn
	movi	48,A3			;Amount to increment animation ptr
	movb	*A10(Spin),A1
	jrnz	Sk0Delta
	movi	>7F,A6
	movb	A6,*A10(BWANTIKS)
	move	*A10(BWANIM),A9,L
	push	A8
	move	*A10(BWHEEL),A8,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	pull	A8
	jruc	SkBWAn
Sk0Delta:
	sll	3,A1
	addi	BWSpin,A1
	movb	*A1,A7
	move	*A10(BWANIM),A9,L

GetBWLp:	
	;* get wheel Frame
	movb	*A10(FwdSpin),A1
	jrz	RollBack

	;***** Rolling Forward
	cmpi	WEELX,A9
	jrge	SkWeel
	;* In WEEL animation
	add	A3,A9
	cmpi	WEELX,A9
	jrnz	GotBW
	movi	WEEL,A9
	jruc	GotBW
SkWeel:
	cmpi	ANG2WX,A9
	jrge	SkAng2
	;* In ANG2 animation
	add	A3,A9
	cmpi	ANG2WX,A9
	jrnz	GotBW
	movi	ANG2W,A9
	jruc	GotBW
SkAng2:
	;* In ANG3W animation
	add	A3,A9
	cmpi	ANG3WX,A9
	jrnz	GotBW
	movi	ANG3W,A9
	jruc	GotBW

RollBack:
	;***** Rolling Backward
	cmpi	WEELX,A9
	jrgt	SkWeelB
	;* In WEEL animation
	sub	A3,A9
	cmpi	WEEL-48,A9
	jrnz	GotBW
	movi	WEELX-48,A9
	jruc	GotBW
SkWeelB:
	cmpi	ANG2WX,A9
	jrgt	SkAng2B
	;* In ANG2W animation
	sub	A3,A9
	cmpi	ANG2W-48,A9
	jrnz	GotBW
	movi	ANG2WX-48,A9
	jruc	GotBW
SkAng2B:
	;* In ANG3W animation
	sub	A3,A9
	cmpi	ANG3W-48,A9
	jrnz	GotBW
	movi	ANG3WX-48,A9
	jruc	GotBW

GotBW:
	add	A7,A6
	jrn	GetBWLp
	movb	A6,*A10(BWANTIKS)

	move	A9,*A10(BWANIM),L
	push	A8
	move	*A10(BWHEEL),A8,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	pull	A8
SkBWAn:

	;* Check if Small Wheel needs animation
	movb	*A10(SWhlOn),A0
	jrz	SkSWAn
	movb	*A10(SWANTIKS),A6
	jrp	SkSWAn
	move	*A8(OXVEL),A1,L
	jrnz	SkS0Delta
	movi	>7F,A6
	movb	A6,*A10(SWANTIKS)
	move	*A10(SWANIM),A9,L
	push	A8
	move	*A10(SWHEEL),A8,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	pull	A8
	jruc	SkSWAn
SkS0Delta:
	move	A1,A3
	move	*A8(OFLAGS),A4,W
	btst	B_FLIPH,A4
	jrz	SWNFlp
	neg	A1
SWNFlp:
	abs	A3
	movi	12*>23000,A7	
	cmp	A7,A3
	jrge	MinSWTik
	divu	A3,A7
	cmpi	>7F,A7
	jrlt	GotSWTik
	movi	>7F,A7
	jruc	GotSWTik
MinSWTik:
	movk	1,A7
GotSWTik:
	move	*A10(SWANIM),A9,L
	movi	48,A4			;Amount to increment animation ptr

GetSWLp:	
	;* get wheel Frame
	move	A1,A1
	jrn	SRollBck

	;***** Rolling Forward
	add	A4,A9
	cmpi	SWEELX,A9
	jrnz	GotSW
	movi	SWEEL,A9
	jruc	GotSW

SRollBck:
	;***** Rolling Backward
	sub	A4,A9
	cmpi	SWEEL-48,A9
	jrnz	GotSW
	movi	SWEELX-48,A9
	jruc	GotSW

GotSW:
	add	A7,A6
	jrn	GetSWLp
	movb	A6,*A10(SWANTIKS)

	move	A9,*A10(SWANIM),L
	push	A8
	move	*A10(SWHEEL),A8,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	pull	A8
SkSWAn:
	rets

BWSpin:
	.byte	>0,>20,>8,>4,>3,>8
SWSpin:
	.byte	>0,>48,>12,>A,>7,>12
	.even
**************************************************************************

**************************************************************************
DoFrame:
	movb	*A10(FranPtr),A0
	jrnz	GoFranim

	;* ANIMNXT POINTS TO MR.BIG ANIM TABLE
	move	*A10(ANIMNXT),A11,L
	move	*A11+,A9,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	movb	A0,*A13(ANIMTIKS)
;	addk	32,A11
;	jruc	WhlX
;	jruc	DoFrameX

	;* reposition Big Wheel
	movb	*A11,A2
	addk	8,A11
	cmpi	NOWHEEL,A2
	jrnz	BigW
	addk	8,A11
	jruc	SmallWhl

BigW:
	move	*A8(OXPOS),A3,W
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkFlph
	neg	A2
	move	*A8(OSIZEX),A4,W
	add	A4,A2
SkFlph:
	add	A2,A3			;A3 - desired pos for X center of bigwheel
	movb	*A11,A2
	addk	8,A11
	move	*A8(OYPOS),A4,W
	add	A2,A4			;A4 - desired pos for Y center of bigwheel

	move	*A10(BWHEEL),A0,L
	move	*A0(OSIZEX),A2,W
	srl	1,A2
	sub	A2,A3
	move	A3,*A0(OXPOS),W
	move	*A0(OSIZEY),A2,W
	srl	1,A2
	sub	A2,A4
	move	A4,*A0(OYPOS),W
	move	*A8(OZVAL),*A0(OZVAL),L
	
SmallWhl:
	;* reposition Small Wheel
	movb	*A11,A2
	addk	8,A11
	cmpi	NOWHEEL,A2
	jrnz	SmallW
	addk	8,A11
	jruc	WhlX

SmallW:
	move	*A8(OXPOS),A3,W
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkSFlph
	neg	A2
	move	*A8(OSIZEX),A4,W
	add	A4,A2
SkSFlph:
	add	A2,A3			;A3 - desired pos for X center of bigwheel
	movb	*A11,A2
	addk	8,A11
	move	*A8(OYPOS),A4,W
	add	A2,A4			;A4 - desired pos for Y center of bigwheel

	move	*A10(SWHEEL),A0,L
	move	*A0(OSIZEX),A2,W
	srl	1,A2
	sub	A2,A3
	move	A3,*A0(OXPOS),W
	move	*A0(OSIZEY),A2,W
	srl	1,A2
	sub	A2,A4
	move	A4,*A0(OYPOS),W
	move	*A8(OZVAL),*A0(OZVAL),L

WhlX:
	move	A11,*A10(ANIMNXT),L
	move	*A11,A11,L
	jrnz	ListLeft
	callr	AnimCycle
ListLeft:
	jruc	DoFrameX


GoFranim:
	;* ANIMNXT ACTUALLY POINTS DIRECTLY TO FRANIM SCRIPT
	move	*A10(ANIMNXT),A9,L
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	A9,*A10(ANIMNXT),L
	move	*A9,A1,L
	jrnz	LstLeft
	callr	AnimCycle
LstLeft:
	movb	A0,*A13(ANIMTIKS)

DoFrameX:
	retp
**************************************************************************

************************** Animation Cycler ******************************
AnimCycle:
;Resets animation loop
	move	*A13(ANIMPTR),*A10(ANIMNXT),L
	rets
**************************************************************************



**************************************************************************
VelAdj:
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7
	;* Damp Old Velocity -- only applicable if on ground
	movb	*A10(VDAMP),A6
	movi	>300,A1
	movi	>3000,A2
	move	A2,A3
	neg	A3

	;* damp X motion
	move	*A8(OXVEL),A0,L
	jrz	SkXD
	cmp	A2,A0
	jrgt	SkBigXD
	cmp	A3,A0
	jrlt	SkBigXD
	calla	ABSSUB	;sub	A1 from A0
	move	A0,*A8(OXVEL),L
	jruc	SkXD
SkBigXD:
	sra	7,A0
	move	A0,A5
	mpys	A6,A5
	move	A5,*A8(OXVEL),L
SkXD:
	

	;* damp Z motion
	move	*A8(OZVEL),A0,L
	jrz	SkZD
	move	A0,A7
	cmp	A2,A0
	jrgt	SkBigZD
	cmp	A3,A0
	jrlt	SkBigZD
	calla	ABSSUB	;sub	A1 from A0
	move	A0,A5
	jruc	SkMPYZ
SkBigZD:
	sra	7,A0
	move	A0,A5
	mpys	A6,A5
SkMPYZ:
	sub	A5,A7
	move	A5,*A8(OZVEL),L

	move	*A8(OYVEL),A0,L
	sub	A7,A0
	move	A0,*A8(OYVEL),L
SkZD:


	;* add in adjustment for Thrust
	movb	*A10(FaceDir),A0
	sll	5,A0
	addi	VelDirTbl,A0
	move	*A0,A0,L
	clr	A2
	clr	A3
	jump	A0
VelDirTbl:
	.long	V0uv,V0ur,V0hr,V0dr,V0dv,V0dl,V0hl,V0ul

	;>7f = 1 in .8 fmt, >5A = .707 in .8 fmt
V0uv:
	movi	->7F,A2
	jruc	AddThrust
V0ur:
	movi	->5A,A2
	movi	>5A,A3
	jruc	AddThrust
V0hr:
	movi	>7F,A3
	jruc	AddThrust
V0dr:
	movi	>5A,A2
	movi	>5A,A3
	jruc	AddThrust
V0dv:
	movi	>7F,A2
	jruc	AddThrust
V0dl:
	movi	>5A,A2
	movi	->5A,A3
	jruc	AddThrust
V0hl:
	movi	->7F,A3
	jruc	AddThrust
V0ul:
	movi	->5A,A2
	movi	->5A,A3
	jruc	AddThrust

AddThrust:
	;A3 - mpyer for Xthrust, A2 - mpyer for Zthrust
	movb	*A10(FwdSpin),A0
	jrnz	SkNegThr
	neg	A2
	neg	A3
SkNegThr:
	movb	*A10(Spin),A0
	sll	4,A0
	addi	SpinVTbl,A0
	move	*A0,A0,W
	mpys	A0,A3
	move	*A8(OXVEL),A1,L
	add	A3,A1
	move	A1,*A8(OXVEL),L
	move	A2,A3
	mpys	A0,A3
	move	*A8(OZVEL),A1,L
	add	A3,A1
	move	A1,*A8(OZVEL),L
	move	*A8(OYVEL),A1,L
	add	A3,A1
	move	A1,*A8(OYVEL),L
	
	callr	SetAuxV
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7
	rets

SpinVTbl:
	.word	>0,>12,>48,>6C,>90,>10
**************************************************************************


****************** Set Auxiliary velocities ******************************
SetAuxV:
	;* Set velocity of other chair parts
	move	*A10(BWHEEL),A2,L
	move	*A10(SWHEEL),A3,L

	move	*A8(OXVEL),A5,L
	move	A5,*A2(OXVEL),L
	move	A5,*A3(OXVEL),L

	move	*A8(OZVEL),A5,L
	move	A5,*A2(OZVEL),L
	move	A5,*A3(OZVEL),L

	move	*A8(OYVEL),A5,L
	move	A5,*A2(OYVEL),L
	move	A5,*A3(OYVEL),L

	rets
**************************************************************************


***************************** Accelerate *********************************
Accelerate:
	;* select appropriate frame
	movb	*A10(FaceDir),A0
	sll	5,A0
	addi	FDTbl1,A0
	move	*A0,A0,L
	clr	A2
	clr	A3
	jump	A0
FDTbl1
	.long	F1uv,F1ur,F1hr,F1dr,F1dv,F1dl,F1hl,F1ul

F1uv:
F1ur:
F1dr:
F1dv:
F1dl:
F1ul:

F1hr:
F1hl:

	rets
**************************************************************************


****************************** Get Frame *********************************
GetFrame:
;* Only call when FaceDir changes..
	;* select appropriate frame
	clr	A0
	movb	A0,*A10(FranPtr)	;ANIMPTR pts to a MrBig Anim Table

	movb	*A10(FaceDir),A0
	sll	5,A0
	addi	FDirTbl,A0
	move	*A0,A0,L
	clr	A2
	clr	A3
	jump	A0
FDirTbl:
	.long	F0uv,F0ur,F0hr,F0dr,F0dv,F0dl,F0hl,F0ul

F0uv:
	movk	1,A0
	movb	A0,*A10(FranPtr)	;ANIMPTR pts to a Franim Table
	callr	PushAnim
	movi	ANG4,A0
	callr	StrtAnim
	callr	NoBWhl
	callr	NoSWhl
	jruc	GotFrame
F0ur:
	callr	PushAnim
	movi	ANG3_T,A0
	callr	StrtAnim
	movi	ANG3W,A0
	callr	StrtBWhl
	callr	NoSWhl
	calla	NOYFLP
	jruc	GotFrame
F0hr:
	callr	PullAnim
	callr	NewAnim
	movi	WEEL,A0
	callr	StrtBWhl
	callr	StrtSWhl
	calla	NOYFLP
	jruc	GotFrame
F0dr:
	callr	PushAnim
	movi	ANGCASE2_T,A0
	callr	InCase
	jrnz	GotAng2a
	movi	ANG2_T,A0
GotAng2a:
	callr	StrtAnim
	movi	ANG2W,A0
	callr	StrtBWhl
	callr	NoSWhl
	calla	NOYFLP
	jruc	GotFrame
F0dv:
	movk	1,A0
	movb	A0,*A10(FranPtr)	;ANIMPTR pts to a Franim Table
	callr	PushAnim
	movi	ANGCASE1,A0
	callr	InCase
	jrnz	GotAng1
	movi	ANG1,A0
GotAng1:
	callr	StrtAnim
	callr	NoBWhl
	callr	NoSWhl
	jruc	GotFrame
F0dl:
	callr	PushAnim
	movi	ANGCASE2_T,A0
	callr	InCase
	jrnz	GotAng2b
	movi	ANG2_T,A0
GotAng2b:
	callr	StrtAnim
	movi	ANG2W,A0
	callr	StrtBWhl
	callr	NoSWhl
	calla	YFLP
	jruc	GotFrame
F0hl:
	callr	PullAnim
	callr	NewAnim
	movi	WEEL,A0
	callr	StrtBWhl
	callr	StrtSWhl
	calla	YFLP
	jruc	GotFrame
F0ul:
	callr	PushAnim
	movi	ANG3_T,A0
	callr	StrtAnim
	movi	ANG3W,A0
	callr	StrtBWhl
	callr	NoSWhl
	calla	YFLP
	jruc	GotFrame

GotFrame:
	callr	SetWFlp
	rets
**************************************************************************

**************************************************************************
InCase:
;* is MRBIG in an animation with his case out?
	mmtm	SP,A0
	move	*A10(ANIMNXT),A0,L
	cmpi	CASE_T,A0
	jrlt	NinC
	cmpi	CASE_TX,A0
	jrgt	NinC
	movk	1,A0
	jruc	InCaseX
NinC:
	clr	A0
InCaseX:
	mmfm	SP,A0
	rets
**************************************************************************

**************************************************************************
PushAnim:
	move	*A10(ANIMTMP),A0,L
	jrnz	PushAX
	move	*A13(ANIMPTR),*A10(ANIMTMP),L
	move	*A10(ANIMNXT),*A10(NANIMTMP),L
PushAX:
	rets
**************************************************************************

**************************************************************************
PullAnim:
	move	*A10(ANIMTMP),A0,L
	jrz	PullAX

	move	A0,*A13(ANIMPTR),L
	move	*A10(NANIMTMP),*A10(ANIMNXT),L
	clr	A0
	movb	A0,*A13(ANIMTIKS)
	move	A0,*A10(ANIMTMP),L
PullAX:
	rets
**************************************************************************

**************************************************************************
NewAnim:
	move	*A10(WANTANIM),A0,L
	jrz	NewAnX

	move	A0,*A13(ANIMPTR),L
	move	A0,*A10(ANIMNXT),L
	clr	A0
	move	A0,*A10(WANTANIM),L
	movb	A0,*A13(ANIMTIKS)

NewAnX:
	rets
**************************************************************************

**************************************************************************
StrtAnim:
;* desired new Animation Table in A0
	move	*A13(ANIMPTR),A1,L
	cmp	A1,A0
	jreq	StrtAnX

	move	A0,*A13(ANIMPTR),L
	move	A0,*A10(ANIMNXT),L
	clr	A0
	movb	A0,*A13(ANIMTIKS)
StrtAnX:
	rets
**************************************************************************

**************************************************************************
SetWFlp:
;set flip of wheels based on flip of chair
	move	A8,A7
	movb	*A10(BWhlOn),A2
	jrz	SkBWFlp
	move	*A8(OFLAGS),A1,W
	move	*A10(BWHEEL),A8,L
	btst	B_FLIPH,A1
	jrz	BWNoF
	calla	YFLP
	jruc	SkBWFlp
BWNoF:
	calla	NOYFLP
SkBWFlp:

	movb	*A10(SWhlOn),A2
	jrz	SkSWFlp
	move	*A10(SWHEEL),A8,L
	btst	B_FLIPH,A1
	jrz	SWNoF
	calla	YFLP
	jruc	SkSWFlp
SWNoF:
	calla	NOYFLP
SkSWFlp:
	move	A7,A8
	rets
**************************************************************************

**************************************************************************
StrtBWhl:
;* desired new Animation Table in A0
	movb	*A10(BWhlOn),A1
	jrz	DoStrtBW

	;* are we attempting to start same animation?
	move	*A10(BWANIM),A1,L

	cmpi	WEEL,A0
	jrnz	SkWeelS
	cmpi	WEEL,A1
	jrlt	DoStrtBW
	cmpi	WEELX,A1
	jrgt	DoStrtBW
	jruc	StrtBWX
SkWeelS:

	cmpi	ANG2W,A0
	jrnz	SkAng2S
	cmpi	ANG2W,A1
	jrlt	DoStrtBW
	cmpi	ANG2WX,A1
	jrgt	DoStrtBW
	jruc	StrtBWX
SkAng2S:

	cmpi	ANG3W,A0
	jrnz	SkAng3S
	cmpi	ANG3W,A1
	jrlt	DoStrtBW
	cmpi	ANG3WX,A1
	jrgt	DoStrtBW
	jruc	StrtBWX
SkAng3S:

DoStrtBW:
	move	A0,*A10(BWANIM),L
	clr	A0
	movb	A0,*A10(BWANTIKS)

	movb	*A10(BWhlOn),A1
	jrnz	StrtBWX

	movk	1,A0
	movb	A0,*A10(BWhlOn)
	move	*A10(BWHEEL),A0,L
	calla	INSOBJ

StrtBWX:
	rets
**************************************************************************

**************************************************************************
StrtSWhl:
	movb	*A10(SWhlOn),A1
	jrnz	StrtSWX

	movi	SWEEL,A0
	move	A0,*A10(SWANIM),L
	clr	A0
	movb	A0,*A10(SWANTIKS)
	movk	1,A0
	movb	A0,*A10(SWhlOn)
	move	*A10(SWHEEL),A0,L
	calla	INSOBJ

StrtSWX:
	rets
**************************************************************************

**************************************************************************
NoBWhl:
	movb	*A10(BWhlOn),A1
	jrz	NoBWhlX

	;* Remove Big Wheel From Object list
	clr	A0
	movb	A0,*A10(BWhlOn)
	move	*A10(BWHEEL),A0,L
	calla	PULLOBJ

NoBWhlX:
	rets
**************************************************************************

**************************************************************************
NoSWhl:
	movb	*A10(SWhlOn),A1
	jrz	NoSWhlX

	;* Remove Small Wheel From Object list
	clr	A0
	movb	A0,*A10(SWhlOn)
	move	*A10(SWHEEL),A0,L
	calla	PULLOBJ

NoSWhlX:
	rets
**************************************************************************

**************************************************************************
DelSW:
	move	*A10(SWHEEL),A0,L
	movb	*A10(SWhlOn),A1
	jrnz	DelSWhl
	calla	FREEOBJ
	rets
DelSWhl:
	calla	DELOBJ
	rets
**************************************************************************

**************************************************************************
DelBW:
	move	*A10(BWHEEL),A0,L
	movb	*A10(BWhlOn),A1
	jrnz	DelBWhl
	calla	FREEOBJ
	rets
DelBWhl:
	calla	DELOBJ
	rets
**************************************************************************

**************************************************************************
MB_DONE:

MB_DIE4:					;Delete Small Wheel obj
	callr	DelSW
MB_DIE3:					;Delete Big Wheel obj
	callr	DelBW
MB_DIE2:					;Delete Obj of extra data space
	move	A10,A0
	calla	FREEOBJ

MB_DIE1:					
	MOVE	A8,A0		
	calla	DELENEMY		;DELETE THE ENEMY
MB_DIE:
	move	@MBIGCNT,A0,W
	dec	A0
	move	A0,@MBIGCNT,W
	calla	P_GOLD
	jrnz	SkCard

	calla	CARDCHEK
SkCard:
	DIE
**************************************************************************

**************************************************************************
ExBWInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	weel1,>00020002,DUMCOLL   ;2nd entry is Zsiz
	.WORD	DMAWNZ,EFF0OID
	.LONG	0
ExSWInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	sweel1,>00020002,DUMCOLL   ;2nd entry is Zsiz
	.WORD	DMAWNZ,EFF0OID
	.LONG	0
;ExWCInit:
;	.LONG	0,0,0,0
;	.WORD	0,0
;	.LONG	chair2,>000C000C,DUMCOLL   ;2nd entry is Zsiz
;	.WORD	DMAWNZ,EFF0OID
;	.LONG	0
**************************************************************************

**************************************************************************
GetXVel:
	movi	CrawlXV,A0
	rets
**************************************************************************

**************************************************************************
BigBlast:
;* Mr. Big has been hit by a rocket or explosion, send him flying..

	;* Get Rid of Wheels
	callr	DelBW
	callr	DelSW

*	TRAJEC  - CREATES A NEW OBJECT WITH THE GIVEN VEL AND POS PARAMS *
*       TRAJEC1 - JUST DOES THE TRAJECTORY WITH AN EXISTING OBJECT       *
* A8 = RESERVED FOR OBJECT BLOCK POINTER				 *
* A9 = INITIAL ANIMATION LIST						 *
* A10 = PTR TO OBJECT INITIALIZATION TABLE(IF = 0 THEN DEFAULT IS USED	 *
* A11 = INITIAL YPOS:XPOS						 *
* PDATA      = [DMA FLAGS,INITIAL Z-POSITION]				 *
* PDATA+20H  = INITIAL X-VELOCITY (32 BITS)				 *
* PDATA+40H  = INITIAL Y-VELOCITY (32 BITS)				 *
* PDATA+60H  = INTIIAL Z-VELOCITY (32 BITS)				 *
* PDATA+80H  = SECOND ANIMATION LIST (32 BITS)				 *					 *
* PDATA+A0H  = PROCESS TO CREATE UPON DEATH (32 BITS)			 *

	;Set initial position of all parts..
	move	*A8(OXPOS),A4,W
	move	*A8(OSIZEX),A2,W
	srl	1,A2
	add	A2,A4
	move	*A8(OYPOS),A1,W
	move	*A8(OSIZEY),A2,W
	srl	1,A2
	add	A2,A1
	sll	16,A1
	movy	A1,A4

	move	*A8(OZPOS),A3,W
	move	*A8(OFLAGS),A2,W
	sll	16,A2
	movy	A2,A3

	move	A10,A6
	jruc	SkWFrags

	;* Blow off Chair
;	movi	FlyCHAIR,A9
;	movi	ExWCInit,A10	;Init Tbl
;	move	A4,A11		;initial Ypos:Xpos
;	CREATE	>0ED,TRAJEC	;Start flying piece proc (bashes A1,A7)
;	jrz	SkWFrags
;	move	A0,A1
;	move	A3,*A1(PDATA),L	    	;FLAGS:ZPOS
;	movi	>20000,A0
;	calla	RANDU
;	addi	>20000,A0
;	movb	@RAND,A14
;	jrn	PosXV3
;	neg	A0
;PosXV3:
;	move	A0,*A1(PDATA+>20),L	;XVEL
;	calla	GETYZVEL	;A8=PTR TO OBJ->B2=Z VEL(32),B3=Y VEL(32)						 *
;	move	B2,A0
;	move	A0,*A1(PDATA+>40),L	;YVEL
;	move	B3,A0
;	move	A0,*A1(PDATA+>60),L	;ZVEL
;	movi	RollCHAIR,A0
;	move	A0,*A1(PDATA+>80),L	;Grnd ANIM
;	movi	DBOUNCE,A0
;	move	A0,*A1(PDATA+>A0),L	;Grnd Process

	
	;* Blow off 2 Big Wheels
	movk	2,B0
BlowBW:
	movi	FlyWEEL,A9
	movi	ExBWInit,A10	;Init Tbl
	move	A4,A11		;initial Ypos:Xpos
	CREATE	>0ED,TRAJEC	;Start flying piece proc (bashes A1,A7)
	jrz	SkWFrags
	move	A0,A1
	move	A3,*A1(PDATA),L	    	;FLAGS:ZPOS
	movi	>20000,A0
	calla	RANDU
	addi	>20000,A0
	movb	@RAND,A14
	jrn	PosXV1
	neg	A0
PosXV1:
	move	A0,*A1(PDATA+>20),L	;XVEL
	calla	GETYZVEL	;A8=PTR TO OBJ->B2=Z VEL(32),B3=Y VEL(32)						 *
	move	B2,A0
	move	A0,*A1(PDATA+>40),L	;YVEL
	move	B3,A0
	move	A0,*A1(PDATA+>60),L	;ZVEL
	movi	WEEL,A0
	move	A0,*A1(PDATA+>80),L	;Grnd ANIM
	movi	DTBOUNCE,A0
	move	A0,*A1(PDATA+>A0),L	;Grnd Process
	dsj	B0,BlowBW


	;* Blow off 2 Small Wheels
	movk	2,B0
BlowSW:
	movi	FlySWEEL,A9
	movi	ExSWInit,A10	;Init Tbl
	move	A4,A11		;initial Ypos:Xpos
	CREATE	>0ED,TRAJEC	;Start flying piece proc (bashes A1,A7)
	jrz	SkWFrags
	move	A0,A1
	move	A3,*A1(PDATA),L	    	;FLAGS:ZPOS
	movi	>20000,A0
	calla	RANDU
	addi	>20000,A0
	movb	@RAND,A14
	jrn	PosXV2
	neg	A0
PosXV2:
	move	A0,*A1(PDATA+>20),L	;XVEL
	calla	GETYZVEL	;A8=PTR TO OBJ->B2=Z VEL(32),B3=Y VEL(32)						 *
	move	B2,A0
	move	A0,*A1(PDATA+>40),L	;YVEL
	move	B3,A0
	move	A0,*A1(PDATA+>60),L	;ZVEL
	movi	SWEEL,A0
	move	A0,*A1(PDATA+>80),L	;Grnd ANIM
	movi	DTBOUNCE,A0
	move	A0,*A1(PDATA+>A0),L	;Grnd Process
	dsj	B0,BlowSW


SkWFrags:
	move	A6,A10		;restore data obj ptr

	;* init MrBig's Body for flight
	MOVE	*A8(OSHAD),A0,L
	jrnz	SkShad
	calla	SHADST
SkShad:

	;* get destination point
	clr	A0
	move	A0,*A10(YDEST),W

	jruc	GoEdge			;delete eventually

	movi	BGDCID,A0
	move	@BACKSLST,A1,L
	calla	NEAR_OBJ
	jrc	GotDoor1
	movi	BGDOID,A0
	move	@BACKSLST,A1,L
	calla	NEAR_OBJ
	jrc	GotDoor1
	movi	BGDOMID,A0
	move	@BACKSLST,A1,L
	calla	NEAR_OBJ
	jrc	GotDoor1
	movi	BGDCMID,A0
	move	@BACKSLST,A1,L
	calla	NEAR_OBJ
	jrc	GotDoor1

	;* No Available Door, go for screen edge
	move	@WORLDTL,A0,W
	addi	255,A0
	move	A0,A1
	calla	BGNDHGHT
	jrz	GoEdge
	move	A0,*A10(YDEST),W
	jruc	DfltZD
GoEdge:
	move	@WORLDTL,A1,W
	move	@SCRNLR,A2,W		;GET SCREEN RT.
	add	A2,A1
	subi	100,A1
DfltZD:
	move	@PLZMIN,A0,W
	addi	20,A0
	sll	16,A0
	movy	A0,A1
	move	A1,*A13(DEST),L
	clr	A0
	move	A0,*A13(WANTOBJ),L
	jruc	GotFlyD

	;* Got Door, go for it
GotDoor1:
	move	A0,*A13(WANTOBJ),L
	calla	HuntObj0
GotFlyD:
	movi	>10000,A0
	calla	RANDU
	addi	>48000,A0
	move	A0,A1
	neg	A0
	move	A0,A4	;Yvel

	movi	MBigGrav,A0
	sll	1,A1		;time to go up and down
	divu	A0,A1		;A1 = tiks for flight
	addk	10,A1		;fudge factor to make flight fall short

	move	*A8(OXPOS),A2,W
	move	*A13(DEST),A3,W
	sub	A2,A3		;A3=Xdist to travel
	sll	16,A3
	divs	A1,A3
	move	A3,*A8(OXVEL),L

	move	*A8(OZPOS),A2,W
	move	*A13(DEST+16),A3,W
	sub	A2,A3		;A3=Zdist to travel
	sll	16,A3
	divs	A1,A3

	movb	*A10(ROCKHIT),A0
	jrnz	FLYHIM
	sra	2,A4
FLYHIM:
	move	A3,*A8(OZVEL),L
	add	A4,A3		;Add in YVel
	move	A3,*A8(OYVEL),L

	movk	1,A0			;Set Flag to Process Body
	movb	A0,*A10(MBigFly)
	movi	BigSpin1,A0
	move	A0,*A13(ANIMPTR),L
	movi	BigSpin0,A9
	movk	4,A1
	jsrp	FRANIM
	move	A9,*A10(ANIMNXT),L
	movb	A0,*A13(ANIMTIKS)
	move	*A8(OYPOS),A0,W
	addi	100,A0
	move	A0,*A8(OYPOS),W

	movi	DUMCOLL,A0
	move	A0,*A8(OCVECT),L

BlastLp:
	movb	*A10(MBigFly),A0
	jrz	SkFlyBod

	move	*A8(OYVEL+16),A0,W
	jrn	Fly0
	move	*A10(YDEST),A0,W
	jrz	SkRoofD
	move	*A8(OYPOS),A1,W
	addi	40,A1
	cmp	A0,A1
	jrgt	Crawl
	jruc	Fly0
SkRoofD:
	calla	DFRMGRND
	cmpi	5,A1
	jrgt	Fly0
	
	;* Body has struck the Ground
	clr	A0
	movb	A0,*A10(MBigFly)

	;* just for now!!
	jruc	Crawl

Fly0:
	move	*A8(OZPOS),A0,W
	subk	3,A0
	move	@PLZMIN,A1,W
	cmp	A1,A0
	jrgt	ZVOk
	clr	A0
	move	A0,*A8(OZVEL),L
ZVOk:
	
	;* add trajectory for MBIG's Body
	move	*A8(OYVEL),A0,L
	addi	MBigGrav,A0
	move	A0,*A8(OYVEL),L

	;* animate his body..
	movb	*A13(ANIMTIKS),A0
	jrnz	SkAni1
	move	*A10(ANIMNXT),A9,L
	movk	4,A1
	jsrp	FRANIM
	move	A9,*A10(ANIMNXT),L
	move	*A9,A1,L
	jrnz	LstLeft1
	callr	AnimCycle
LstLeft1:
	movb	A0,*A13(ANIMTIKS)
SkAni1:

	movb	*A13(ANIMTIKS),A0
	jrnn	ATok2
	movk	1,A0
ATok2:
	dec	A0
	movb	A0,*A13(ANIMTIKS)

SkFlyBod:

	SLEEP	1
	jruc	BlastLp

Crawl:
	calla	ClrVel
	move	*A10(YDEST),A0,W
	jrz	SkRoof0
	move	A8,A0
	calla	DELSHAD
	movi	-1,A0
	move	A0,*A8(OZPOS),W
	movi	>1000,A0
	move	A0,*A8(OYVEL),L
SkRoof0:
	movi	CrawlXV,A0
	move	A0,*A8(OXVEL),L
	movi	BigCrawl,A9
	movk	4,A1
	jsrp	FRANIM
	movb	A0,*A13(ANIMTIKS)

	move	*A8(OYPOS),A0,W
	subi	100,A0
	move	A0,*A8(OYPOS),W
	move	A8,A0
	calla	SETZPOS
	move	*A8(OZPOS),A0,W
	subk	4,A0
	move	A0,*A8(OZPOS),W

	;* Am I already Dead?
	movb	*A10(HEALTH),A0
	jrnz	NotDead
	movb	*A10(MBLIVES),A0
	jrnz	NotDead

	movi	DUMCOLL,A0
	move	A0,*A8(OCVECT),L
	calla	KilLaugh
	move	A10,A0
	calla	FREEOBJ
	calla	ClrVel
	move	*A8(OFLAGS),A0,W
	ori	M_FLIPV,A0
	move	A0,*A8(OFLAGS),W
	move	*A8(OYPOS),A0,W
	addi	2,A0
	move	A0,*A8(OYPOS),W

	movi	BigDead,A9
SquirmLp:
	clr	A1			;frame 11
	jsrp	FRANIM
	move	*A8(OYPOS),A0,W
	addi	8,A0
	move	A0,*A8(OYPOS),W

	clr	A1			;frame 12
	jsrp	FRANIM
	move	*A9,A0,L
	jrz	SquirmX
	move	*A8(OYPOS),A0,W
	subi	8,A0
	move	A0,*A8(OYPOS),W

	movi	5,A3
	callr	MakeBty
	CALLA	DROPSTUF	;DROP Extra BOOTY
	jruc	SquirmLp
SquirmX:

	sleep	20
	movi	[1,1],A9
	CREATE	0DFh,ESINK		;CREATE THE DEADMAN SINK	 
	move	@MBIGCNT,A0,W
	dec	A0
	move	A0,@MBIGCNT,W
	calla	P_GOLD
	jrnz	SkCard2
	calla	CARDCHEK
SkCard2:
	DIE
	
NotDead:
	movi	150,A0
CrawlLp:
	PUSHP	A0
	;* animate his body..
	movb	*A13(ANIMTIKS),A0
	jrnz	SkAni2
	movk	4,A1
	jsrp	FRANIM
	move	*A9,A1,L
	jrnz	LstLeft2
	movi	BigCrawl,A9
LstLeft2:
SkAni2:
	dec	A0
	movb	A0,*A13(ANIMTIKS)
	SLEEP	1
	PULLP	A0
	dec	A0
	jrp	CrawlLp
	
	jruc	MB_WARM
**************************************************************************

**************************************************************************
*A0 = PTR TO MBIG OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
BullCol:
	MOVE	A8,A6
	MOVE	A0,A8
	move	*A6(OXVEL),A3,L
	sra	1,A3
	movi	>20000,A0
	calla	RANDU
	subi	>10000,A0
	move	A0,A4
	movk	2,A5
	jruc	HurtMe

ExploCol:
	MOVE	A8,A6
	MOVE	A0,A8
	calla	GETANIX
	move	*A6(OXPOS),A1,W
	move	*A6(OSIZEX),A2,W
	srl	1,A2
	add	A2,A1
	move	A2,A3
	sll	14,A3
	cmp	A0,A1
	jrle	SkNgXv
	neg	A3
SkNgXv:
	clr	A4
	movk	2,A5
	jruc	HurtMe

CarCol:
	MOVE	A8,A6		;killers Obj
	MOVE	A0,A8		;Mr. Big Obj
	move	*A6(OXVEL),A3,L
	sra	2,A3
	move	*A6(OZVEL),A4,L
	sra	1,A4
	movk	1,A5
;	jruc	HurtMe

HurtMe:
;* expect A3-XVEL ADJ, A4-ZVEL ADJ, A5-DAMAGE
	move	*A8(OXVEL),A0,L
	add	A3,A0
	move	A0,*A8(OXVEL),L
	move	*A8(OZVEL),A0,L
	add	A4,A0
	move	A0,*A8(OZVEL),L
	move	*A8(OYVEL),A0,L
	add	A4,A0
	move	A0,*A8(OYVEL),L

	calla	Wound
	jrnc	SkKill

	clr	A0
	movb	A0,*A10(ROCKHIT)
	MOVE	*A8(OPLINK),A0,L
	MOVI	MBIGBPID,A1
	MOVI	BigBlast,A7
* XFERPROC - A0=PRCPTR, A1=NEW ID, A7=NEW PC, A8-A11=PASSED
	CALLA	XFERPROC 	;CHANGE TO ENEMY DEATH PROCESS

SkKill:
	movi	1,A0	;stop collision scan
	RETS
**************************************************************************

**************************************************************************
*          BINBCD                                                        *
*          CONVERT BINARY NUMBER IN A0 TO BCD.                           *
BINBCD   MMTM    SP,A1,A2,A3,A4,A5
         MOVI    10,A1                     ;ALWAYS DIVIDE BY A0
         CLR     A5                        ;ACCUMULATE RESULT IN A5
         CLR     A4                        ;A4 HAS CURRENT SHIFT COUNT
         MOVE    A0,A3                     ;<A2><A3> HAS NUMERATOR
DO_BCD_AGAIN
         CLR     A2
         DIVU    A1,A2                     ;A2 HAS LEFTOVER...A3 HAS CURRENT DIGIT
         SLL     A4,A3                     ;SHIFT IT CORRECT NUMBER OF TIMES
         ADD     A3,A5                     ;ADD IT INTO RESULT REG
         ADDK    4,A4                      ;ADD 4 TO SHIFT COUNT
         MOVE    A2,A3                     ;REFRESH NUMERATOR
         JRNZ    DO_BCD_AGAIN

         MOVE    A5,A0                     ;PUT OUT RESULT
	MMFM    SP,A1,A2,A3,A4,A5
	RETS
**************************************************************************


**************************************************************************
MakeBty:
;A3 - 0-30, the bigger, the more booty
;A13 process ptr
	movi	30,A1	;make some bucks
	mpys	A3,A1
	move	A1,A0	;%
	clr	A1	;ct
BckLp:
	calla	RANDPER
	jrnc	BckX
	inc	A1
	cmpi	10,A1
	jrlt	BckLp
BckX:
	movb	A1,*A13(EBUCK)

	movi	25,A1	;make some drugs
	mpys	A3,A1
	move	A1,A0	;%
	clr	A1	;ct
DrgLp:
	calla	RANDPER
	jrnc	DrgX
	inc	A1
	cmpi	10,A1
	jrlt	DrgLp
DrgX:
	movb	A1,*A13(EDRUG)

	movi	20,A1	;make some clips
	mpys	A3,A1
	move	A1,A0	;%
	clr	A1	;clip ct
ClpLp:
	calla	RANDPER
	jrnc	ClpX
	inc	A1
	cmpi	10,A1
	jrlt	ClpLp
ClpX:
	movb	A1,*A13(ECLIP)

	movi	25,A1	;make some rocks
	mpys	A3,A1
	move	A1,A0	;%
	clr	A1	;ct
RckLp:
	calla	RANDPER
	jrnc	RckX
	inc	A1
	cmpi	10,A1
	jrlt	RckLp
RckX:
	movb	A1,*A13(EROCK)
	rets
**************************************************************************

**************************************************************************
Wound:
;A5 - amount of damage to deliver
;A6 - ptr to obj striking mbig
;A8 - mbig obj
	move	A6,A0
	calla	BulToDat
	jrz	SkScore
	move	A0,A2	;A2-player to get points
	move	A5,A1
	movi	1000,A0
	mpyu	A0,A1	;A1-score amt
	move	A1,A0
	calla	BINBCD
	move	A0,A1
	calla	SCORE
	cmpi	25,A5
	jrlt	SkBonus
	calla	PUT25K
SkBonus:
SkScore:

	mmtm	SP,A2,A13
	move	*A8(OPLINK),A13,L
	move	A5,A3
	addk	5,A3
	cmpi	30,A3
	jrle	DCntOk
	movi	30,A3
DCntOk:
	callr	MakeBty
	CALLA	DROPSTUF		;DROP THE BOOTY
	move	A13,A0
	mmfm	SP,A2,A13

	calla	GETA10
	movb	*A10(HEALTH),A1
	sll	24,A1
	srl	24,A1
	sub	A5,A1
	jrn	Woundead
	jrz	Woundead
	movb	A1,*A10(HEALTH)

	clrc
	rets

Woundead:

*A2=PLAYER DATA AREA
	calla	ADDMRBIG	;ADD MR. BIG KILL						 *

	movb	*A10(MBLIVES),A2
	jrz	NoLife
	dec	A2
	movb	A2,*A10(MBLIVES)
	addk	25,A1
	jrp	StHlth
	movk	1,A1
StHlth:
	movb	A1,*A10(HEALTH)
	setc
	rets
NoLife:
	clr	A1
	movb	A1,*A10(HEALTH)
	setc
	rets
**************************************************************************

**************************************************************************
*A0 = PTR TO MBIG OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
RockCol:
	MOVE	A8,A6			;STORE KILLERS OBJ
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER

	movk	25,A5			;give em some damage
	calla	Wound

	movi	DUMCOLL,A0
	move	A0,*A8(OCVECT),L

	movk	1,A0
	movb	A0,*A10(ROCKHIT)
	MOVE	*A8(OPLINK),A0,L
	MOVI	MBIGBPID,A1
	MOVI	BigBlast,A7
* XFERPROC - A0=PRCPTR, A1=NEW ID, A7=NEW PC, A8-A11=PASSED
	CALLA	XFERPROC	;CHANGE TO ENEMY DEATH PROCESS

	movi	1,A0	;stop collision scan
	RETS
*************************************************************************


*************************************************************************
MBIGCOLL:
	.WORD	B1OID|ROCKETID
	.LONG	RockCol
	.WORD	B2OID|ROCKETID
	.LONG	RockCol
	.WORD	B1OID|BULLETID
	.LONG	BullCol
	.WORD	B2OID|BULLETID
	.LONG	BullCol
	.WORD	B1OID|EXPLODID
	.LONG	ExploCol
	.WORD	B2OID|EXPLODID
	.LONG	ExploCol
	.WORD	BEOID|EXPLODID
	.LONG	ExploCol
	.word	C1OID		;ENEMY CAR #1 "CADILLAC" OBJECT I.D.
	.LONG	CarCol
	.word	CAR2OID		;ENEMY CAR #2 "PORSCHE" OBJECT I.D.
	.LONG	CarCol
	.word	CAR3OID		;ENEMY CAR #3 "BELL-JET" OBJECT	I.D.
	.LONG	CarCol
	.word	TRAN1OID	;PLAYER TRANSPORT #1 "PORSCHE" OBJECT I.D.
	.LONG	CarCol
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************


**************************************************************************
* Mister BIG FRANIM TABLES	
* NORMAL TABLE ENTRY:
* 	AFRAME	FRAME,SLEEPT,CONTROL_WORD
* FIRE FRAME TABLE ENTRY:		    
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW

SFLAMES:
;* flames corresponding to dirs 0-Up through 7-UpLeft
;* multiply dir by >60 to get address
	.long	sflame90
	.word	FLIPBITS|1,M_FLIPV
	.long	sflame45
	.word	FLIPBITS|1,M_FLIPV
	.long	sflame0
	.word	FLIPBITS|1,0
	.long	sflame45
	.word	FLIPBITS|1,0
	.long	sflame90
	.word	FLIPBITS|1,0
	.long	sflame45
	.word	FLIPBITS|1,M_FLIPH
	.long	sflame0
	.word	FLIPBITS|1,M_FLIPH
	.long	sflame45
	.word	FLIPBITS|1,M_FLIPH|M_FLIPV
	LONGNULL
	

;BUST_F:
;	.long	mbust3
;	.word	7
;	.long	mbust4
;	.word	7
;	.long	mbust5
;	.word	7
;	.long	mbust6
;	.word	7
;	.long	mbust7
;	.word	7
;	.long	mbust8
;	.word	7
;	.long	mbust9
;	.word	7
;	LONGNULL

;CHAIR_F:
;	.long	chair1
;	.word	5
;FlyCHAIR:
;RollCHAIR:
;	.long	chair2
;	.word	5
;	.long	chair3
;	.word	5
;	.long	chair4
;	.word	5
;	.long	chair5
;	.word	5
;	.long	chair6
;	.word	5
;	.long	chair7
;	.word	5
;	.long	chair8
;	.word	5
;	.long	chair9
;	.word	5
;	.long	chair10
;	.word	5
;	.long	chair11
;	.word	5
;	LONGNULL

BigSpin0:
	.long	mdead3
	.word	5
BigSpin1:
	.long	mdead4
	.word	5
	.long	mdead5
	.word	5
	.long	mdead6
	.word	5
	.long	m90dead7
	.word	5
	.long	m90dead6
	.word	FLIPBITS|5,M_FLIPH
	.long	mdead5
	.word	FLIPBITS|5,(M_FLIPH+M_FLIPV)
	.long	mdead2
	.word	5
	LONGNULL

BigCrawl:
	.long	mdead11
	.word	FLIPBITS|3,M_FLIPH
	.long	mdead12
	.word	FLIPBITS|3,M_FLIPH
	LONGNULL

BigDead:
	.long	mdead11
	.word	1
	.long	mdead12
	.word	1
	.long	mdead11
	.word	2
	.long	mdead12
	.word	2
	.long	mdead11
	.word	3
	.long	mdead12
	.word	3
	.long	mdead11
	.word	4
	.long	mdead12
	.word	5
	.long	mdead11
	.word	6
	.long	mdead12
	.word	7
	.long	mdead11
	.word	8
	.long	mdead12
	.word	10
	.long	mdead11
	.word	12
	.long	mdead12
	.word	1
	LONGNULL

;DEAD_F:
;	.long	mdead1
;	.word	5
;	.long	mdead2
;	.word	5
;	.long	mdead3
;	.word	5
;	.long	mdead4
;	.word	5
;	.long	mdead5
;	.word	5
;	.long	mdead6
;	.word	5
;	.long	mdead7
;	.word	5
;	.long	mdead8
;	.word	5
;	.long	mdead9
;	.word	5
;	.long	mdead10
;	.word	5
;	.long	mdead11
;	.word	5
;	.long	mdead12
;	.word	5
;	LONGNULL


;MBGUN1:
;	.long	mbgun1
;	.word	1
;MBGUN2:
;	.long	mbgun2
;	.word	1

;MBUP1:
;	.long	mbup1
;	.word	1

;FONE1:
;	.long	fone1
;	.word	10
;FONE2:
;	.long	fone2
;	.word	10
;FONE3:
;	.long	fone3
;	.word	10
;FONE4:
;	.long	fone4
;	.word	10
;FONE5:
;	.long	fone5
;	.word	10
;FONE6:
;	.long	fone6
;	.word	10
;FONE7:
;	.long	fone7
;	.word	10
;FONE8:
;	.long	fone8
;	.word	10
;FONE9:
;	.long	fone9
;	.word	10

;MBPUSH1:
;	.long	mbpush1
;	.word	1
;MBPUSH2:
;	.long	mbpush2
;	.word	1
;MBPUSH3:
;	.long	mbpush3
;	.word	1
;MBPUSH4:
;	.long	mbpush4
;	.word	1
;MBPUSH5:
;	.long	mbpush5
;	.word	1
;MBPUSH6:
;	.long	mbpush6
;	.word	1

CASE1:
	.long	case1
	.word	12
CASE4:
	.long	case4
	.word	12
CASE5:
	.long	case5
	.word	12
CASE9:
	.long	case9
	.word	12

;MBOMB1:
;	.long	mbomb1
;	.word	1
;MBOMB2:
;	.long	mbomb2
;	.word	1
;MBOMB3:
;	.long	mbomb3
;	.word	1
;MBOMB4:
;	.long	mbomb4
;	.word	1
;MBOMB5:
;	.long	mbomb5
;	.word	1
;MBOMB6:
;	.long	mbomb6
;	.word	1
;MBOMB7:
;	.long	mbomb7
;	.word	1
;MBOMB8:
;	.long	mbomb8
;	.word	1
;MBOMB9:
;	.long	mbomb9
;	.word	1
;MBOMB10:
;	.long	mbomb10
;	.word	1

;MBINC1:
;	.long	mbinc1
;	.word	1
;MBINC2:
;	.long	mbinc2
;	.word	1
;MBINC3:
;	.long	mbinc3
;	.word	1
;MBINC4:
;	.long	mbinc4
;	.word	1
;MBINC5:
;	.long	mbinc5
;	.word	1
;MBINC6:
;	.long	mbinc6
;	.word	1
;MBINCD1:
;	.long	mbincd1
;	.word	1
;MBINCD2:
;	.long	mbincd2
;	.word	1

;BIG1:
;	.long	big1
;	.word	1
;BIG2:
;	.long	big2
;	.word	1
;BIG3:
;	.long	big3
;	.word	1
;BIG4:
;	.long	big4
;	.word	1
;BIG5:
;	.long	big5
;	.word	1
;BIG6:
;	.long	big6
;	.word	1
;BIG7:
;	.long	big7
;	.word	1
;BIG8:
;	.long	big8
;	.word	1
;BIG9:
;	.long	big9
;	.word	1
;BIG10:
;	.long	big10
;	.word	1
;BIG11:
;	.long	big11
;	.word	1
;BIG12:
;	.long	big12
;	.word	1
;BIG13:
;	.long	big13
;	.word	1
;BIG14:
;	.long	big14
;	.word	1
;BIG15:
;	.long	big15
;	.word	1

WALKOUT:
ANG1:
	.long	ang1
	.word	8
	.long	ang1b
	.word	8
	LONGNULL

ANGCASE1:
	.long	angcase1
	.word	127
	LONGNULL

ANGCASE2:
	.long	angcase2
	.word	127
	LONGNULL

ANG2:
	.long	ang2
	.word	127
	LONGNULL
ANG3:
	.long	ang3
	.word	127
	LONGNULL
ANG4:
	.long	ang4
	.word	8
	.long	ang4b
	.word	8
	LONGNULL


FlyWEEL:
	.long	weel1
	.word	1
	.long	weel3
	.word	1
	.long	weel5
	.word	1
	LONGNULL
WEEL:
	.long	weel1
	.word	1
	.long	weel2
	.word	1
	.long	weel3
	.word	1
	.long	weel4
	.word	1
	.long	weel5
	.word	1
	.long	weel6
	.word	1
WEELX:
	LONGNULL

FlySWEEL:
	.long	sweel1
	.word	1
	.long	sweel3
	.word	1
	.long	sweel5
	.word	1
	LONGNULL
SWEEL:
	.long	sweel1
	.word	1
	.long	sweel2
	.word	1
	.long	sweel3
	.word	1
	.long	sweel4
	.word	1
	.long	sweel5
	.word	1
	.long	sweel6
	.word	1
SWEELX:
	LONGNULL

ANG2W:
	.long	ang2wa
	.word	1
	.long	ang2wb
	.word	1
	.long	ang2wc
	.word	1
	.long	ang2wd
	.word	1
ANG2WX:
	LONGNULL

ANG3W:
	.long	ang3wa
	.word	1
	.long	ang3wb
	.word	1
	.long	ang3wc
	.word	1
	.long	ang3wd
	.word	1
ANG3WX:
	LONGNULL

BIGBULL:
	.long	bigbull
	.word	200
	LONGNULL

BIGFLAME:
;	.long	FL1
;	.word	3
;	.long	FL2
;	.word	3
;	.long	FL3
;	.word	3
	LONGNULL

;****************************************************************************
;* MR BIG ANIMATION TABLES
; .long	FRANIM ptr
; .word	Big Wheel X,Y, Small Wheel X,Y  offsets from top left.
;				(An X coor of NOWHEEL indicates no wheel)
; Script is terminated by a LONGNULL

NOWHEEL	.set	>80

;MBGUN_T:
;	.long	MBGUN1
;	.byte	11,60,34,65
;	.long	MBGUN2
;	.byte	12,61,35,67
;	LONGNULL

;MBUP_T:
;	.long	MBUP1
;	.byte	11,56,33,62
;	LONGNULL

;FONE_T:
;	.long	FONE1
;	.byte	15,57,38,66
;	.long	FONE2
;	.byte	19,57,42,66
;	.long	FONE3
;	.byte	14,57,37,66
;	.long	FONE4
;	.byte	17,57,40,66
;	.long	FONE5
;	.byte	15,58,38,67
;	.long	FONE6
;	.byte	15,58,38,67
;	.long	FONE7
;	.byte	15,62,38,71
;	.long	FONE8
;	.byte	15,55,38,64
;	.long	FONE9
;	.byte	15,55,38,64
;	LONGNULL

;* MBPUSH_T and CASE_T must Remain contiguous
;MBPUSH_T:
;	.long	MBPUSH1
;	.byte	13,60,37,66
;	.long	MBPUSH2
;	.byte	13,59,36,65
;	.long	MBPUSH3
;	.byte	14,60,37,65
;	.long	MBPUSH4
;	.byte	14,60,37,65
;	.long	MBPUSH5
;	.byte	13,60,36,66
;	.long	MBPUSH6
;	.byte	13,60,36,66
;	LONGNULL

CASE_T:
CASE9_T:
	.long	CASE9
	.byte	27,56,49,65
CASE5_T:
	.long	CASE5
	.byte	18,61,40,70
CASE4_T:
	.long	CASE4
	.byte	18,52,40,61
CASE1_T:
	.long	CASE1
	.byte	18,54,40,63
CASE_TX:
	LONGNULL



;MBOMB_T:
;	.long	MBOMB1
;	.byte	11,61,34,68
;	.long	MBOMB2
;	.byte	12,60,33,69
;	.long	MBOMB3
;	.byte	10,63,31,69
;	.long	MBOMB4
;	.byte	10,63,31,69
;	.long	MBOMB5
;	.byte	11,67,33,73
;	.long	MBOMB6
;	.byte	10,62,31,69
;	.long	MBOMB7
;	.byte	10,59,32,68
;	.long	MBOMB8
;	.byte	11,71,33,79
;	.long	MBOMB9
;	.byte	12,73,34,80
;	.long	MBOMB10
;	.byte	12,62,32,69
;	LONGNULL
;
;BIG_T:
;	.long	BIG1
;	.byte	10,60,32,66
;	.long	BIG2
;	.byte	11,61,34,67
;	.long	BIG3
;	.byte	13,58,34,62
;	.long	BIG4
;	.byte	11,59,35,63
;	.long	BIG5
;	.byte	10,62,33,67
;	.long	BIG6
;	.byte	12,60,33,67
;	.long	BIG7
;	.byte	14,61,35,68
;	.long	BIG8
;	.byte	36,60,57,68
;	.long	BIG9
;	.byte	10,68,33,75
;	.long	BIG10
;	.byte	11,58,33,67
;	.long	BIG11
;	.byte	12,58,32,68
;	.long	BIG12
;	.byte	12,57,33,68
;	.long	BIG13
;	.byte	14,59,36,69
;	.long	BIG14
;	.byte	17,65,37,75
;	.long	BIG15
;	.byte	16,58,38,67
;	LONGNULL

ANG2_T:
	.long	ANG2
	.byte	11,55,NOWHEEL,NOWHEEL
	LONGNULL

ANGCASE2_T:
	.long	ANGCASE2
	.byte	11,55,NOWHEEL,NOWHEEL
	LONGNULL

ANG3_T:
	.long	ANG3
	.byte	30,55,NOWHEEL,NOWHEEL
	LONGNULL

;ACCEL_T:
;	.long	MBINC5
;	.byte	26,52,50,47
;	.long	MBINC3
;	.byte	28,50,54,45
;	.long	MBINC2
;	.byte	37,50,63,42
;	.long	MBINC1
;	.byte	33,49,57,43
;	.long	MBINC5
;	.byte	26,52,50,47
;	LONGNULL
	

;INC_T:
;	.long	MBINC1
;	.byte	33,49,57,43
;	.long	MBINC2
;	.byte	37,50,63,42
;	.long	MBINC3
;	.byte	28,50,54,45
;	.long	MBINC4
;	.byte	26,52,49,46
;	.long	MBINC5
;	.byte	26,52,50,47
;	.long	MBINC6
;	.byte	24,53,45,49
;INCD_T:
;	.long	MBINCD1
;	.byte	14,56,NOWHEEL,NOWHEEL
;	.long	MBINCD2
;	.byte	17,69,NOWHEEL,NOWHEEL
	


MBCRIME:
	.long	case1
	.word	1
	LONGNULL
MBCRMWHL:
	.long	weel1
	.word	1
	LONGNULL

****************************************************************************
MBIGCRM1:
	move	@(WORLDTLX+16),A0,W				 
	addi	250,A0
	move	@PLYMIN,A1,W									 
	addi	25,A1
	sll	16,A1
	movx	A0,A1
	movi	MBIGINIT,A14	
	calla	ENINITLL
	clr	A0
	move	A0,*A8(OBLIPIMG),L

	calla	ClrVel
	calla	YFLP
	movi	MBCRIME,A9	
	movk	4,A1
	jsrp	FRANIM

	PUSHP	A8

	move	@(WORLDTLX+16),A0,W				 
	addi	258,A0
	move	@PLYMIN,A1,W									 
	addi	30,A1
	sll	16,A1
	movx	A0,A1
	movi	ExBWInit,A14
	calla	ENINITLL
	clr	A0
	move	A0,*A8(OBLIPIMG),L
	calla	ClrVel
	movi	MBCRMWHL,A9	
	movk	4,A1
	jsrp	FRANIM

	SLEEP	35
	SOUND1	MBLAUGH
	SLEEP	70

CRM1X:
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELSUPP
	CALLA	DELSOBJ

	PULLP	A8
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELSUPP
	move	*A8(OPAL),A1,W
	move	A1,@CRIMEPAL,W
	CALLA	DELSOBJ
	retp
****************************************************************************

	.END
