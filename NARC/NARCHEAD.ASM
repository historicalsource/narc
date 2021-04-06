 	.FILE	'NARCHEAD.ASM'
	.TITLE	"<<< N  A  R  C  --  HEADMAN >>>"

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
	.include	"imgtbl.glo"
	.include	"narcxtra.glo"

	.GLOBL	MAKEFLAM,GROWFLAM,FIRETUNG,MkNuke
	.GLOBL	CKLXBND

;	.GLOBL	BASCTAB,BCCTAB1,BCCTAB0,EYECCTB,EYECCTBE
	.GLOBL	InitTbls,DIRANI
	.GLOBL	BONEINI,CHUNKINI,CHNKTINI,SpineIni
	.GLOBL	BRECOIL,BRECOILF,TUNGFLEX,TUNGFLXF,RRECOIL,RRECOILF,RRECOIL
	.GLOBL	KABOOM,KABOOMF,BOOM5a,BOOM5b,BOOM5c,BOOM6
	.GLOBL	CHNKTBL1,CHNKTBL2,CHNKTBL3,CHNKTBL4,CHNKTBL5
	.GLOBL	HED3hat,skull4,jaw4,stump,stumpskl,BASEskl
	.GLOBL	SDIRANI
	.GLOBL	baseflsh
	.GLOBL	jawbite,jawbitef,FLYSPINE,FLYSKULL,BlowSkul

	.GLOBL	HEADCOLL,BASECOLL,TUNGCOLL,SPNECOLL

	.BSS	FRAGCNT,16,1
	.BSS	GOTCARD,16,1

;BaseSND		.WORD	>F350,>13,>8080,0 ;player touches base
BaseSND		.WORD	>F350,>13,>80D9,0 ;player touches base
HedBlSND	.WORD	>F305,>3,>8096,0 ;head hit by bullet
ChunkSND	.WORD	>F301|NINTEQ,>25,>80A1,0 ;chunk hits ground
Bone1SND	.WORD	>F301|NINTEQ,>10,>8048,0 ;bone hits ground
Bone2SND	.WORD	>F301|NINTEQ,>10,>8054,0 ;" hits ground
Bone3SND	.WORD	>F301|NINTEQ,>15,>800c,0 ;" hits ground
SpinStSND	.WORD	>F3FE,>400,>80B0,0 ;
SpinSND		.WORD	>F3FE,>400,>8090,0 ;
PitchSND	.WORD	>F3FE,>14,>80CC,0 ;incr pitch of Spin
PClrSND		.WORD	>F3FE,>1,>80C6,1,>807F,0

HdExpSND .WORD	>F0FE,>8,>803d,>C,>8007,>18,>8007,>30,>8030,0,0,0,0,0,0 ;BIG SLOW EXPLO
AgitSND	 .WORD	>F0FE,>A,>80C4,>80C9,>80C4,>80C9,0
SkExpSND	.WORD	>F060,>8,>8007,>24,>8007,0 ;skull explode
LaughSND	.WORD	>F040|NINTEQ,>90,>80b5,0 ;13.3Khz
KillSND		.WORD	>F010|NINTEQ,>60,>80b7,0 ;13.3Khz
GetSND		.WORD	>F010|NINTEQ,>60,>80b6,0 ;13.3Khz
UDIE1SND	.WORD	>F040|NINTEQ,>90,>80b8,0 ;13.3Khz
UDIE2SND	.WORD	>F040|NINTEQ,>90,>80ae,0 ;10Khz
NTRYSND		.WORD	>F040|NINTEQ,>90,>80b9,0 ;13.3Khz
BasBSND		.WORD	>F006,>5,>8040,0 ;base clang
BiteSND		.WORD	>F005,>5,>804b,0 ;skeleton bite

SKYFLASH	.set	(32*32*25)+(32*15)+31

BASCCPID	.set	>E9C
EYECCPID	.set	>E9D
SKLCCPID	.set	>E9E
HEADXPID	.set	>E9B
CHUNKPID	.set	>E9A
FLYHTPID	.set	>E99
NUKEPID		.set	>E98
TNGPID		.set	>E9F
;*PROC BLOCK OFFSETS FOR COLOR CYCLERS
COLORLVL	.set	ETEMP1		;byte
OLDCOLOR	.set	ETEMP1+8	;byte

HEADZSIZ	.set	>00230000	;use Z plus only
BASEZMIN	.set	5
BASEZPOS	.set	>28
BASEZSIZ	.set	BASEZPOS*ZP+BASEZMIN
TUNGZSIZ	.set	>00120012

MAXPARTS	.set	7	;# of parts at start
;* offsets in XObj-A10
BASEL		.set	0
BASER		.set	>20
FACE		.set	>40
STUMP			.set	>40
HAT		.set	>60
SKULL			.set	>60
NECK		.set	>80
JAW			.set	>80
GLAS		.set	>A0
STNG			.set	>A0	;skull tung
TUNG		.set	>C0
ANIS		.set	>100
BASELANI	.set	>100
BASERANI	.set	>120
FACEANI		.set	>140
STUMPANI		.set	>140
HATANI		.set	>160
SKLANIS			.set	>160
SKULLANI		.set	>160
NECKANI		.set	>180
JAWANI			.set	>180
GLASANI		.set	>1A0
STNGANI			.set	>1A0
TUNGANI		.set	>1C0
NUMPARTS	.set	>200	;byte
BASPARTS	.set	>208
HEDPARTS	.set	>210	;byte
SKLPARTS		.set	>210	;byte
blah3		.set	>218
INUSE		.set	>220	;byte
ONLIST		.set	>228	;byte
FLIPS		.set	>230	;byte

;* offsets in PROC Block-A13
HEALTH		.set	EMAINT		;word
FLIPPED		.set	EMAINT+16	;byte
COLSRVC		.set	EMAINT+24	;byte
HEDSTATE	.set	ETEMP1	;byte
GLASSES  .set	1
FIREEYES .set	2
TUNGER	 .set	3
SKULBASE .set	4
SPINELEN	.set	ETEMP1+8
BASEFLSH	.set	ETEMP1+16
BITING		.set	ETEMP1+24
SKULBITE .set	11	;values for BITING
SKULTUNG .set	12	; fire tung instead of biting..
INBITE		.set	ESWTCH	;byte
LAUGH		.set	ESWTCH+8 ;byte
TUNGDEAD	.set	ESWTCH+16 ;byte
DIR 		.set	ESWTCH+24	;HEAD
SPINE		.set	EOBJ
GANGTIKS	.set	ETEMP3		;word
EYECTR		.set	ETEMP3+16	;byte
GLASSCTR	.set	ETEMP3+24	;byte



**************************************************************************
HEADCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	
	move	A5,A9		;Y:X in A9
	move	A6,A10		;0:Z in A10
	move	A14,A11		;ID in A11

	CREATE	HEADEPID,BIGHEAD ;allocate process?	(bashes A1,A7)
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

**************************************************************************
GANGCK:
	move	@GANGCNT,A0,W
	jrz	SkCMD
	movb	@RAND,A1
	jrn	SkCMD
	move	@RAND,A1,W
	jrn	SkCMD
	movi	100,A0
	calla	RANDPER
	jrnc	SkCMD
	movi	KillSND,A0
	movb	@RAND,A1
	jrn	GotCMD
	movi	GetSND,A0
GotCMD:
	calla	ONESND
SkCMD:

	move	*A13(GANGTIKS),A0,W
	jrp	SkDisp
	movi	600,A0
	move	A0,*A13(GANGTIKS),W
	clr	A5
	clr	A6
	movi	>00330000|GANGEOID|1,A14
	calla	GANGCOLD
SkDisp:
	rets
**************************************************************************



PalTbl:
	.long	basepal,basepal,headpal,headpal,headpal,headpal,headpal
SPalTbl0:
	.long	basepal,basepal,headxpal,skelpal,skelpal,headpal,headxpal
SuppTbl:
	.long	EXPLOSIONS,EXPLOSIONS
	.long	ENEMIES,ENEMIES,ENEMIES,ENEMIES,ENEMIES


*********************  START OF BIGHEAD PROCESS  *************************
BIGHEAD:
	mmtm	A12,A9,A10	;push Y:X, Z
	jruc	GetXObj

WaitXObj:
	SLEEP	1
GetXObj:
	calla	GETOBJ
	jrz	WaitXObj
	move	A0,A10
	calla	CLROBJ		;Clear out Xtra data object
	
	movk	MAXPARTS,A0
	movb	A0,*A10(NUMPARTS)

;* ALLOCATE OBJECTS
	move	A10,A11		;load up Xtra data obj with ptrs to parts
	movb	*A10(NUMPARTS),A7
	jruc	GetObjs
WaitObjs:
	PUSHP	A7
	SLEEP	1
	PULLP	A7
GetObjs:
	calla	GETOBJ
	jrz	WaitObjs
	move	A0,*A11+,L
	dsjs	A7,GetObjs

;* INITIALIZE OBJECTS
	movi	InitTbls,A7
	move	A10,A11
Stuffem:
	move	*A7+,A14,L
	jrz	StuffX
	move	*A11+,A0,L
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	jruc	Stuffem
StuffX:

;* ALLOCATE AND STUFF PALETTES
	move	A10,A11
	movb	*A10(NUMPARTS),A7
	movi	PalTbl,A6
IniPals:
	move	*A6+,A0,L
TryAlloc:
	calla	GETFPAL
	jrnz	GotP
	mmtm	A12,A0,A6,A7
	SLEEP	1
	mmfm	A12,A0,A6,A7
	jruc	TryAlloc
GotP:
	move	*A11+,A1,L
	move	A0,*A1(OPAL),W
	dsj	A7,IniPals

;*** START UP COLOR CYCLE OF BASE AND EYES
	PUSH	A10
	clr	A10
	CREATE	BASCCPID,BASCC
	CREATE	EYECCPID,EYECC
	PULL	A10

	move	*A10,A8,L
	calla	ClrVel
	callr	UpdHeadV

	;* initialize all VARS
	clr	A0
	move	A0,@FRAGCNT,W
	movk	1,A0
	move	A0,@GOTCARD,W
	movk	5,A0
	movb	A0,*A13(GLASSCTR)
	movk	5,A0
	movb	A0,*A13(EYECTR)
	movi	600,A0
	move	A0,*A13(GANGTIKS),W
	movi	255,A0
	move	A0,*A13(HEALTH),W
	movk	GLASSES,A0
	movb	A0,*A13(HEDSTATE)
	clr	A9
	move	A9,*A13(ANIMPTR),L
	movk	7,A0
	movb	A0,*A13(DIR)
	callr	GetAni
	movk	1,A0
	movb	A0,*A13(FLIPPED)
	clr	A0
	movb	A0,*A13(COLSRVC)
	movb	A0,*A13(LAUGH)

	movi	>FF,A0		;top 6 bits correspond to first 6 parts
	movb	A0,*A10(ONLIST)	;all parts are on the list
	movi	>FF,A0		
	movb	A0,*A10(INUSE)	;all parts are active

	;* set initial position of head
	mmfm	A12,A1,A2	;A1 Y:X, A2 0:Z
	move	A1,A3
	or	A2,A3
	jrz	MkCoors

	move	*A10,A8,L
	move	A2,*A8(OZPOS),W
	subi	32,A2		;Z pos is 32 pixels from top of base
	addi	ZORIGIN,A2
	move	A2,*A8(OYPOS),W
	move	A1,*A8(OXPOS),W
	
	jruc	CoorsSet

MkCoors:
	move	*A10,A8,L
	move	@PLZMID,A0
	subi	35,A0
	move	A0,*A8(OZPOS),W
	subi	32,A0		;Z pos is 32 pixels from top of base
	addi	ZORIGIN,A0
	move	A0,*A8(OYPOS),W
	move	@(WORLDTLX+16),A0,W				 
	addi	600,A0
	move	A0,*A8(OXPOS),W
CoorsSet:
	callr	UpdHeadP

;* INSERT OBJECTS on the obj list and on the supplemental lists
	movi	SuppTbl,A2
	move	A10,A11
	movb	*A10(NUMPARTS),A7
Insertem:
	move	*A11+,A0,L
	move	*A2+,A1,L
	jrz	SkSupp
	calla	INSOBJ
	calla	ADDSUPP
SkSupp:
	dsjs	A7,Insertem

	jruc	HEAD_MV
**************************************************************************

**************************************************************************
XBOUNDS:
	move	*A10,A8,L
	calla	GETANIX

	move	@UNIVSTX,A1,W	;STARTING UNIVERSE X COORDINATE
	addi	106,A1
	cmp	A1,A0
	jrgt	LftEdgOk
	sub	A0,A1	
	move	*A8(OXPOS),A0,W
	add	A1,A0
	move	A0,*A8(OXPOS),W
	
	move	*A8(OXVEL),A3,L
	jrp	XBOUNDSX
	neg	A3
	move	A3,*A8(OXVEL),L
	
	jruc	XBOUNDSX

LftEdgOk:
	move	@UNIVENDX,A1,W	;STARTING UNIVERSE X COORDINATE
	subi	106,A1
	cmp	A1,A0
	jrlt	XBOUNDSX
	sub	A1,A0	
	move	*A8(OXPOS),A1,W
	sub	A0,A1
	move	A1,*A8(OXPOS),W

	move	*A8(OXVEL),A3,L
	jrn	XBOUNDSX
	neg	A3
	move	A3,*A8(OXVEL),L

XBOUNDSX:
	rets
**************************************************************************

**************************************************************************
ZCHECK:
	move	*A8(OZPOS),A1,W
	move	@PLZMIN,A0,W
	addk	BASEZMIN,A0
	sub	A0,A1
	jrnn	ZMinOK
	move	A0,*A8(OZPOS),W
	move	*A8(OYPOS),A0,W
	sub	A1,A0
	move	A0,*A8(OYPOS),W
;	callr	UpdHeadP
	move	*A8(OZVEL),A0,L	;* want to check sign
	jrnn	ZMaxOK
	jruc	SETZV
ZMinOK:
	move	*A8(OZPOS),A1,W
	move	@PLZMAX,A0,W
	subi	BASEZPOS,A0
	sub	A0,A1
	jrn	ZMaxOK
	move	A0,*A8(OZPOS),W
	move	*A8(OYPOS),A0,W
	sub	A1,A0
	move	A0,*A8(OYPOS),W
;	callr	UpdHeadP
	move	*A8(OZVEL),A0,L	;* want to check sign
	jrn	ZMaxOK
	jrz	ZMaxOK
SETZV:
	move	*A8(OYVEL),A1,L
	sub	A0,A1
	move	A1,*A8(OYVEL),L
	clr	A0
	move	A0,*A8(OZVEL),L	;set Z velocity
	callr	UpdHeadV
ZMaxOK:
	rets
**************************************************************************

**************************************************************************
HEAD_MV:
	move	*A10,A8,L
	callr	ZCHECK
	callr	XBOUNDS

	movb	*A13(ANIMTIKS),A0
	jrnz	SkHAnim
	callr	GetDir
	callr	GetAni
	
	callr	AniHead
	movb	A0,*A13(ANIMTIKS)
SkHAnim:

	movb	*A13(BRAINTIKS),A0
	jrnz	HBrainX

	callr	LaffChek
	
	;* CHOOSE APPROPRIATE METHOD OF ATTACK
	movb	*A13(HEDSTATE),A0
	cmpi	GLASSES,A0
	jreq	CHARGE
	cmpi	FIREEYES,A0
	jreq	FLAME

	movk	14,A0
	movb	A0,*A13(BRAINTIKS)
	callr	DOTUNG
	jruc	AttckX
CHARGE:
	movk	6,A0
	movb	A0,*A13(BRAINTIKS)
	callr	DOCHARGE
	jruc	AttckX
FLAME:
	movk	10,A0
	movb	A0,*A13(BRAINTIKS)
	callr	DOFLAME
;	jruc	AttckX
AttckX:
HBrainX:

	callr	UpdHeadP
	callr	UpdHeadV

	;**** FIND NEXT ACTION ****
	movb	*A13(BRAINTIKS),A0
	jrp	SkHBrain1
	movk	1,A0
SkHBrain1:
	move	A0,A5			;current min
	
	movb	*A13(ANIMTIKS),A1
	cmp	A5,A1
	jrge	SkHMin2
	move	A1,A5
SkHMin2:

	sub	A5,A0
	movb	A0,*A13(BRAINTIKS)
	sub	A5,A1
	movb	A1,*A13(ANIMTIKS)

	movb	*A13(LAUGH),A0
	sub	A5,A0
	jrnn	SkClrL
	clr	A0
SkClrL:
	movb	A0,*A13(LAUGH)

;	move	*A13(GANGTIKS),A0,W
;	sub	A5,A0
;	jrp	SkClrGT
;	clr	A0
;SkClrGT
;	move	A0,*A13(GANGTIKS),W

	move	A5,A0
	callr	CkBFlash
	calla	PRCSLP
	clr	A0
	move	A0,@IRQSKYE,W
	
;	callr	GANGCK
	jruc	HEAD_MV
**************************************************************************


**************************************************************************
FindDir:
;* RETURNS
;   A0 - direction to face toward nearest player
;   A7 - ptr to player object
	calla	ClosestP
	move	A0,A8
	calla	GETANIX
	move	A8,A7
	move	A0,A1

	move	*A10,A8,L
	calla	GETANIX
	sub	A0,A1		;A1 = X dist from head to player

	move	*A7(OZPOS),A2,W
	move	*A8(OZPOS),A0,W
	sub	A0,A2		;A2 = Z dist from head to player

	move	A2,A3
	move	A1,A4
	jrz	ZEROX
	abs	A3
	abs	A4
	sll	16,A3
	divu	A4,A3
GotZdivX:

	move	A1,A1
	jrn	LftDir
;* facing right, 0<=dir<=4
	move	A2,A2
	jrn	RgtUDir
;**facing right and down
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	Dir1
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	Dir2
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	Dir3
	jruc	Dir4
RgtUDir:
;**facing right and up
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	Dir1
	jruc	Dir0

LftDir:
;* facing left, 5<=dir<=9
	move	A2,A2
	jrn	LftUDir
;**facing left and down
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	Dir7
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	Dir6
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	Dir5
	jruc	Dir4

LftUDir:
;**facing left and up
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	Dir7
	jruc	Dir8

Dir0:	clr	A0
	jruc	SetBDir
Dir1:	movk	1,A0
	jruc	SetBDir
Dir2:	movk	2,A0
	jruc	SetBDir
Dir3:	movk	3,A0
	jruc	SetBDir
Dir4:	movk	4,A0
	jruc	SetBDir
Dir5:	movk	5,A0
	jruc	SetBDir
Dir6:	movk	6,A0
	jruc	SetBDir
Dir7:	movk	7,A0
	jruc	SetBDir
Dir8:	movk	8,A0
;	jruc	SetBDir

SetBDir:
	rets
ZEROX:
	movi	>7FFFFFFF,A3
	jruc	GotZdivX
***************************************************************************


***************************************************************************
GetDir:
;* Find direction to face and start turning towards it..
	callr	FindDir

	movb	*A13(DIR),A4
	cmp	A0,A4
	jrlt	IncDir
	jrgt	DecDir
	jruc	GotBDir
IncDir:
	sub	A4,A0
	cmpi	4,A0
	jrgt	IncMDir
	inc	A4
	jruc	GotBDir
IncMDir:
	dec	A4
	jrnn	GotBDir
	movk	8,A4
	jruc	GotBDir

DecDir:
	sub	A4,A0
	neg	A0
	cmpi	4,A0
	jrgt	DecMDir
	dec	A4
	jruc	GotBDir
DecMDir:
	inc	A4
	cmpi	8,A4
	jrle	GotBDir
	clr	A4
;	jruc	GotBDir

GotBDir:
	movb	A4,*A13(DIR)
	rets
**************************************************************************

**************************************************************************
LaffChek:
	movi	P1DATA,A0
	move	*A0(PFLAGS),A0,L
	btst	BDEAD,A0
	jrnz	HaHa
	movi	P2DATA,A0
	move	*A0(PFLAGS),A0,L
	btst	BDEAD,A0
	jrz	LaffX

HaHa:
	movk	30,A0
	movb	A0,*A13(LAUGH)
	movi	LaughSND,A0
	calla	ONESND
LaffX:
	rets
**************************************************************************

**************************************************************************
GetAni:	    	
	movb	*A13(COLSRVC),A0
	jrnz	SameAni

	movb	*A13(DIR),A0
	movb	*A13(LAUGH),A1
	jrp	AddLaff
	jruc	NoAddOff
AddLaff:
	addi	9,A0
AddTalk:
	addi	9,A0
NoAddOff:
	sll	5,A0
	addi	DIRANI,A0
	move	*A0,A0,L

	move	*A13(ANIMPTR),A1,L
	cmp	A0,A1
	jreq	SameAni
	move	A0,*A13(ANIMPTR),L
	move	A0,A9
SameAni:
	rets
**************************************************************************

**************************************************************************
MOVEHEAD:
	calla	ClosestP
	move	A0,A8
	calla	GETANIX
	move	A8,A7
	move	A0,A1

	move	*A10,A8,L
	calla	GETANIX
	sub	A0,A1		;A1 = X dist from head to player

	sll	6,A1	
	move	*A7(OXVEL),A0,L
	sra	4,A0
	add	A1,A0

	movb	*A13(COLSRVC),A2
	jrz	SkClrXV
	clr	A0
SkClrXV:

	move	*A8(OXVEL),A1,L
	add	A0,A1
	move	A1,A2
	sra	3,A2
	sub	A2,A1
	move	A1,*A8(OXVEL),L

	move	*A7(OZPOS),A1,W
	move	*A8(OZPOS),A0,W
	sub	A0,A1		;A1 = Z dist from head to player

	sll	5,A1
	move	*A7(OZVEL),A0,L
	sra	4,A0
	add	A1,A0

	movb	*A13(COLSRVC),A2
	jrz	SkClrZV
	clr	A0
SkClrZV:

	move	*A8(OZVEL),A1,L
	add	A0,A1
	move	A1,A2
	sra	3,A2
	sub	A2,A1
	move	A1,*A8(OZVEL),L
	move	A1,*A8(OYVEL),L
	
	callr	UpdHeadV
	rets
**************************************************************************

**************************************************************************
DOCHARGE:
	callr	MOVEHEAD
	rets
**************************************************************************

**************************************************************************
DOFLAME:
	movi	800,A0
	calla	RANDPER
	jrnc	SkMoveF
	callr	MOVEHEAD
SkMoveF:

	movb	*A13(COLSRVC),A0
	jrnz	SkFlame

	movb	*A13(DIR),A14
	cmpi	1,A14
	jreq	FlamOk
	cmpi	7,A14
	jreq	FlamOk
	jruc	SkFlame
FlamOk:
	movi	600,A0
	calla	RANDPER
	jrnc	SkFlame

	move	*A10,A8,L
	move	*A8(OXVEL),A0,L	; A0 - X velocity
	movi	>38000,A1
	calla	ABSADD	;* ADD A1 to A0 with respect to sign of A0
	movi	>20000,A1	; A1 - Y velocity
	move	*A8(OZVEL),A2,L ; A2 - Z velocity
	add	A2,A1

	move	*A8(OXPOS),A3	;X coor of beginning anim pt
	addi	>18,A3
	movk	1,A6		;0->flame shoots to right, 1->flame to left
	movb	*A13(DIR),A14
	cmpi	1,A14
	jrnz	SkAddFlp
	subi	>30,A3
	clr	A6
	move	*A8(OSIZEX),A14
SkAddFlp:
	add	A14,A3

	move	*A8(OYPOS),A4	;Y coor
	subi	>40,A4
	move	*A8(OZPOS),A5	;Z coor
	addi	10,A5
	calla	MAKEFLAM

SkFlame:
	rets
**************************************************************************

**************************************************************************
DOTUNG:
	movi	800,A0
	calla	RANDPER
	jrnc	SkMoveT
	callr	MOVEHEAD
SkMoveT:

	movb	*A13(LAUGH),A1
TryLaff:
	movi	500,A0
	calla	RANDPER
	jrnc	SkLaff
	addi	10,A1
	jruc	TryLaff
SkLaff:
	movb	A1,*A13(LAUGH)

	movb	*A13(COLSRVC),A0
	jrnz	SkTung

	movb	*A13(TUNGDEAD),A0
	jrnz	SkTung

	movb	*A13(DIR),A14
	cmpi	1,A14
	jreq	TungOk
	cmpi	7,A14
	jreq	TungOk
	jruc	SkTung
TungOk:
	move	*A10(TUNGANI),A0,L
	jrz	SkTung

	callr	FindDir
	movb	*A13(DIR),A1
	cmp	A0,A1
	jrnz	SkTung
	move	A7,A0		;A7 set by FindDir
	calla	GetPData
	move	A0,A11		;A11 ptr to player data block

	movk	3,A6
TungMirv:
	movi	400,A0
	calla	RANDPER
	jrnc	SkTung

	;**** FIRE OFF A TONGUE
	mmtm	SP,A10
	move	*A10(TUNG),A8,L
	clr	A10		;not using a reverse tung
	CREATE	TNGPID,FIRETUNG
	mmfm	SP,A10
	dsj	A6,TungMirv

SkTung:
	rets
**************************************************************************

**************************************************************************
UpdHeadP:
; UPDATE HEAD POSITION
;Based on position of first obj, set coors of all other objs
	move	A10,A11

;* get POSITION from first obj..
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	move	*A0(OXVAL),A3,L
	add	A6,A3			;A3 XANI pos
	move	*A0(OYVAL),A5,L
	add	A7,A5			;A5 YANI pos
	move	*A0(OZVAL),A14,L

	movb	*A10(NUMPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetPoss:
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	sub	A3,A6
	neg	A6
	move	A6,*A0(OXVAL),L
	sub	A5,A7
	neg	A7
	move	A7,*A0(OYVAL),L
	move	A14,*A0(OZVAL),L
	inc	A14
	dsj	B0,SetPoss
	rets
**************************************************************************

**************************************************************************
UpdBaseP:
; UPDATE BASE POSITION
;Based on position of first obj, set coors of all other objs
	move	A10,A11

;* get POSITION from first obj..
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	move	*A0(OXVAL),A3,L
	add	A6,A3			;A3 XANI pos
	move	*A0(OYVAL),A5,L
	add	A7,A5			;A5 YANI pos
	move	*A0(OZVAL),A14,L	;A14 Z pos

	movb	*A10(BASPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetBPoss:
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	sub	A3,A6
	neg	A6
	move	A6,*A0(OXVAL),L
	sub	A5,A7
	neg	A7
	move	A7,*A0(OYVAL),L
	move	A14,*A0(OZVAL),L
	inc	A14
	dsj	B0,SetBPoss

	;* UPDATE POSITION OF FINAL BONE OF SPINE
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A6
	jrz	UpdPX
	dec	A6
	sll	5,A6
	add	A6,A11
	;*Set Coors of Bottom Bone
	move	*A11,A11,L     ;load ptr to final bone
	addi	>180000,A5
	move	A5,*A11(OYVAL),L   
	subi	>E0000,A3
	move	A3,*A11(OXVAL),L   
	addi	>100000,A14
	move	A14,*A11(OZVAL),L  

UpdPX:
	rets
**************************************************************************

**************************************************************************
UpdSkulP:
; UPDATE SKULL POSITION
;Based on position of first obj, set coors of all other objs
	move	A10,A11
	addi	SKULL,A11

;* get POSITION from first obj..
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	move	*A0(OXVAL),A3,L
	add	A6,A3			;A3 XANI pos
	move	*A0(OYVAL),A5,L
	add	A7,A5			;A5 YANI pos
	move	*A0(OZPOS),A14,W

	movb	*A10(SKLPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetSPoss:
	move	*A11+,A0,L
	move	*A0(OIMG),A1,L
	move	*A0(OSIZE),A2,L
	move	*A0(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	sub	A3,A6
	neg	A6
	move	A6,*A0(OXVAL),L
	sub	A5,A7
	neg	A7
	move	A7,*A0(OYVAL),L
	move	A14,*A0(OZPOS),W
	dsj	B0,SetSPoss
	rets
**************************************************************************


**************************************************************************
UpdHeadV:
; UPDATE HEAD VELOCITY
;Based on velocity of first obj, set velocity of all other objs
	move	A10,A11

;* get VELOCITIES from first obj..
	move	*A11+,A0,L
	move	*A0(OXVEL),A1,L
	move	*A0(OYVEL),A2,L
	move	*A0(OZVEL),A3,L

	movb	*A10(NUMPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetVels:
	move	*A11+,A0,L
	move	A1,*A0(OXVEL),L
	move	A2,*A0(OYVEL),L
	move	A3,*A0(OZVEL),L
	dsj	B0,SetVels
	rets
**************************************************************************

**************************************************************************
UpdBaseV:
; UPDATE BASE VELOCITY
;Based on velocity of first obj, set velocity of all other objs
	move	A10,A11

;* get VELOCITIES from first obj..
	move	*A11+,A0,L
	move	*A0(OXVEL),A1,L
	move	*A0(OYVEL),A2,L
	move	*A0(OZVEL),A3,L

	movb	*A10(BASPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetBVels:
	move	*A11+,A0,L
	move	A1,*A0(OXVEL),L
	move	A2,*A0(OYVEL),L
	move	A3,*A0(OZVEL),L
	dsj	B0,SetBVels

	;* UPDATE VELS OF FINAL BONE OF SPINE
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A6
	jrz	UpdVX
	dec	A6
	sll	5,A6
	add	A6,A11
	;*Set VELS of Bottom Bone
	move	*A11,A11,L     ;load ptr to final bone
	move	A1,*A11(OXVEL),L   
	move	A2,*A11(OYVEL),L   
	move	A3,*A11(OZVEL),L  

UpdVX:
	rets
**************************************************************************

**************************************************************************
UpdSkulV:
; UPDATE SKULL VELOCITY
;Based on velocity of first obj, set velocity of all other objs
	move	A10,A11
	addi	SKULL,A11

;* get VELOCITIES from first obj..
	move	*A11+,A0,L
	move	*A0(OXVEL),A1,L
	move	*A0(OYVEL),A2,L
	move	*A0(OZVEL),A3,L

	movb	*A10(SKLPARTS),A0
	move	A0,B0
	dec	B0	     	;update the rest of the parts
SetSVels:
	move	*A11+,A0,L
	move	A1,*A0(OXVEL),L
	move	A2,*A0(OYVEL),L
	move	A3,*A0(OZVEL),L
	dsj	B0,SetSVels
	rets
**************************************************************************



**************************************************************************
UpdFlips:
; UPDATE HORIZONTAL FLIP FLAG FOR ALL PARTS
;A0 - byte of which images to flip, highest bit is first image
	mmtm	SP,A0
	sll	24,A0
	move	A10,A11
	movb	*A10(NUMPARTS),A8
	move	A8,B0
	movb	*A10(FLIPS),A1
	sll	24,A1
SetFlips:
	move	*A11+,A8,L
	sll	1,A0
	jrc	DoFlp
	sll	1,A1
	jrnc	NxtFlp
	calla	NOYFLP
	jruc	NxtFlp
DoFlp:
	sll	1,A1
	jrc	NxtFlp
	calla	YFLP
NxtFlp:
	dsj	B0,SetFlips
	mmfm	SP,A0
	movb	A0,*A10(FLIPS)
	move	*A10,A8,L
	rets
**************************************************************************

**************************************************************************
StufAnis:
;* Stuff ANIMATION for each piece
;* Stuff Zpos for each piece, based on first piece
;A0 ptr to table of animations
	movi	ANIS,A7
	add	A10,A7
	movb	*A10(NUMPARTS),A3
	move	A3,B0
StufAni:
	move	*A0+,*A7+,L
	dsjs	B0,StufAni

	addk	8,A0	;skip first Z offset
	move	A10,A11
	move	*A11+,A1,L
	move	*A1(OZVAL),A2,L
	movb	*A10(NUMPARTS),A3
	move	A3,B0
	dec	B0	     	;update the rest of the parts
StufZ:
	move	*A11+,A1,L
	movb	*A0,A3
	addk	8,A0
	add	A2,A3
	move	A3,*A1(OZVAL),L
	dsjs	B0,StufZ

	movb	*A0,A0
	movb	*A13(FLIPPED),A1
	jrz	SkFlpSet
	not	A0
SkFlpSet:
	callr	UpdFlips
	rets
**************************************************************************


**************************************************************************
AniHead:
	move	*A9+,A0,L
	jrnz	GotAnim
	move	*A13(ANIMPTR),A9,L
	clr	A0
	movb	A0,*A13(COLSRVC)
	jruc	AniHead
GotAnim:
	callr	StufAnis

;* ANIMATE ALL HEAD PIECES
	move	A10,A11
	movi	ANIS,A7
	add	A10,A7
	movb	*A10(ONLIST),A6
	clr	A5	;new ONLIST
	sll	24,A6
	movb	*A10(INUSE),A0
	move	A0,B1
	sll	24,B1
	movb	*A10(NUMPARTS),A0
	move	A0,B0
DoAnis:
	sll	1,A5
	move	*A11+,A8,L
	move	*A7+,A1,L
	jrz	NoAni
	sll	1,B1
	jrnc	NotActive

	inc	A5	;set Bit for new ONLIST
	move	*A8(OFLAGS),A4,W
* ANI: A1=IMAGE PTR, A4=FLAGS, A8=OBJECT STRUCTURE POINTER TO BE UPDATED				 *
	calla	ANI
	;*** MAKE SURE PART IS ON LIST
	sll	1,A6	;was part on list
	jrc	NxtAni
	move	A8,A0
	calla	INSOBJ
	movi	ENEMIES,A1
	calla	ADDSUPP
	jruc	NxtAni

NoAni:
	sll	1,B1
NotActive:
	sll	1,A6	;was part on list
	jrnc	NxtAni
	move	A8,A0
	calla	PULLOBJ
	movi	ENEMIES,A1
	calla	DELSUPP
NxtAni:
	dsj	B0,DoAnis

	movk	8,A0
	movb	*A10(NUMPARTS),A1
	sub	A1,A0
	sll	A0,A5
	movb	A5,*A10(ONLIST)
	move	*A10,A8,L	;leave ptr to first part in A8
	move	*A9+,A0,W	;load sleep time
	rets
**************************************************************************


**************************************************************************
*MR. BIG BASE COLOR CYCLE
*A10=LEVEL OF 1-8
BASCC:
	movb	A10,*A13(COLORLVL)
	movi	>FF,A0
	movb	A0,*A13(OLDCOLOR)
	MOVI	basepal,A0
	CALLA	FINDPAL
	JAEQ	SUCIDE
	MOVE	A0,A8		;KEEP PALETTE POSITION
	SLL	24,A8
	SRL	16,A8
	ADDI	243,A8		;ADD IN EYE COLOR VALUE

BAS0LP
	movb	*A13(COLORLVL),A10
	movb	*A13(OLDCOLOR),A1
	cmp	A10,A1
	jrz	ColSame
	;* change to new color level
	MOVI	BASCTAB,A9
	MOVI	BCCTAB1-BCCTAB0,A1	
	MPYU	A10,A1
	ADD	A1,A9
	MOVE	*A9+,A11,W	;GET SLEEP TIME
	movb	*A13(COLORLVL),*A13(OLDCOLOR)
ColSame:
	MOVI	17*16,A10
BAS1LP
	MOVE	A8,A1
	MOVK	13,A2
	MOVE	A10,A0
	ADD	A9,A0
	CALLA	PALSET
	MOVE	A11,A0
	CALLA	PRCSLP
	SUBK	16,A10
	JRNN	BAS1LP
	JRUC	BAS0LP
*
*MR. BIG EYES COLOR CYCLE
*
EYECC:
	MOVI	headpal,A0
	CALLA	FINDPAL
	JAEQ	SUCIDE
	MOVE	A0,A8		;KEEP PALETTE POSITION
	SLL	24,A8
	SRL	16,A8
	ADDI	252,A8		;ADD IN EYE COLOR VALUE
EYELP0
	MOVI	EYECCTB,A9
EYELP1
	MOVE	A8,A1
	MOVK	4,A2
	MOVE	A9,A0
	CALLA	PALSET
	SLEEP	3
	ADDI	4*16,A9
	CMPI	EYECCTBE,A9
	JRLO	EYELP1
	JRUC	EYELP0


*
*MR. BIG BASE COLOR CYCLE TABLE
*COLORS 243-255        
BASCTAB:
BCCTAB0
	.WORD	4
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	7*32,9*32,12*32,17*32,25*32,31*32
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB1
	.WORD	4
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(7*32)+(3*32*32),(9*32)+(5*32*32),(12*32)+(6*32*32)
	.WORD	(17*32)+(9*32*32),(25*32)+(12*32*32),(31*32)+(16*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB2
	.WORD	3
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(7*32)+(5*32*32),(9*32)+(6*32*32),(12*32)+(9*32*32)
	.WORD	(17*32)+(13*32*32),(25*32)+(18*32*32),(31*32)+(24*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB3
	.WORD	3
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(6*32)+(6*32*32),(7*32)+(8*32*32),(10*32)+(11*32*32)
	.WORD	(15*32)+(15*32*32),(21*32)+(22*32*32),(27*32)+(28*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB4
	.WORD	2
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(5*32)+(7*32*32),(6*32)+(9*32*32),(9*32)+(12*32*32)
	.WORD	(13*32)+(17*32*32),(18*32)+(25*32*32),(24*32)+(31*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB5
	.WORD	2
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(3*32)+(7*32*32),(5*32)+(9*32*32),(6*32)+(12*32*32)
	.WORD	(9*32)+(17*32*32),(12*32)+(25*32*32),(16*32)+(31*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB6
	.WORD	1
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	(2*32)+(7*32*32),(3*32)+(9*32*32),(4*32)+(12*32*32)
	.WORD	(5*32)+(17*32*32),(6*32)+(25*32*32),(8*32)+(31*32*32)
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB7
	.WORD	1
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	8*32*32,13*32*32,19*32*32,25*32*32,31*32*32,31*32*32
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
BCCTAB8
	.WORD	15
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0
	.WORD	0,0,0,0,0,0
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0


*
*EYE COLOR CYCLE TABLE
*
EYECCTB
	.WORD	(31*32*32)+(00*32),(31*32*32)+(14*32)
	.WORD	(31*32*32)+(21*32),(31*32*32)+(31*32)

	.WORD	(31*32*32)+(14*32),(31*32*32)+(21*32)
	.WORD	(31*32*32)+(31*32),(31*32*32)+(00*32)

	.WORD	(31*32*32)+(21*32),(31*32*32)+(31*32)
	.WORD	(31*32*32)+(00*32),(31*32*32)+(14*32)

	.WORD	(31*32*32)+(31*32),(31*32*32)+(00*32)
	.WORD	(31*32*32)+(14*32),(31*32*32)+(21*32)
EYECCTBE


*
*SKULL EYES COLOR CYCLE
*
SKEYE:
	MOVI	skelpal,A0
	CALLA	FINDPAL
	JAEQ	SUCIDE
	MOVE	A0,A8		;KEEP PALETTE POSITION
	SLL	24,A8
	SRL	16,A8
	ADDI	248,A8		;ADD IN EYE COLOR VALUE
SKEYEL0
	MOVI	SKEYERED,A9
SKEYEL1
	MOVE	A8,A1
	MOVK	7,A2
	MOVE	A9,A0
	CALLA	PALSET
	move	A10,A0
	calla	PRCSLP
	ADDI	7*16,A9
	CMPI	SKEYERX,A9
	JRLO	SKEYEL1
	JRUC	SKEYEL0
SKEYERED
*red
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   ( 27 *32*32)+(  0 *32)+(  0 )       ; color 253
      .word   ( 31 *32*32)+( 13 *32)+(  0 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   ( 26 *32*32)+(  0 *32)+(  0 )       ; color 250
      .word   ( 31 *32*32)+(  2 *32)+(  0 )       ; color 251
      .word   ( 31 *32*32)+( 12 *32)+(  0 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   ( 20 *32*32)+(  0 *32)+(  0 )       ; color 248
      .word   ( 31 *32*32)+(  0 *32)+(  0 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

*purple


      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 252
      .word   ( 27 *32*32)+(  0 *32)+(  27)       ; color 253
      .word   ( 31 *32*32)+( 13 *32)+(  31)       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 249
      .word   ( 26 *32*32)+(  0 *32)+(  26 )      ; color 250
      .word   ( 31 *32*32)+(  2 *32)+(  31 )      ; color 251
      .word   ( 31 *32*32)+( 12 *32)+(  31 )      ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  6 )       ; color 254

      .word   ( 20 *32*32)+(  0 *32)+( 20 )       ; color 248
      .word   ( 31 *32*32)+(  0 *32)+(  31)       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254
*blue
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   ( 0 *32*32)+(  0 *32)+(  27 )       ; color 253
      .word   ( 0 *32*32)+( 13 *32)+(  31 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   ( 0 *32*32)+(  0 *32)+(  26 )       ; color 250
      .word   ( 0 *32*32)+(  2 *32)+(  31 )       ; color 251
      .word   ( 0 *32*32)+( 12 *32)+(  31 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   ( 0 *32*32)+(  0 *32)+(  20 )       ; color 248
      .word   ( 0 *32*32)+(  0 *32)+(  31 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254


*white
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   ( 27 *32*32)+(  27*32)+(  27 )       ; color 253
      .word   ( 31 *32*32)+( 31 *32)+(  31 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   ( 26 *32*32)+(  26 *32)+(  26 )       ; color 250
      .word   ( 31 *32*32)+(  31 *32)+(  31 )       ; color 251
      .word   ( 31 *32*32)+( 31 *32)+(  31 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   ( 20 *32*32)+(  20 *32)+( 20 )       ; color 248
      .word   ( 31 *32*32)+(  31 *32)+(  31 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254

      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 248
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 249
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 250
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 251
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 252
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 253
      .word   (  6 *32*32)+(  6 *32)+(  7 )       ; color 254



SKEYERX
**************************************************************************


**************************************************************************
HEADCOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClHedBul
	.WORD	B1OID|ROCKETID
	.LONG	ClHedRck
	.WORD	B2OID|BULLETID
	.LONG	ClHedBul
	.WORD	B2OID|ROCKETID
	.LONG	ClHedRck
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
TUNGCOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClTngBul
	.WORD	B1OID|ROCKETID
	.LONG	ClTngRck
	.WORD	B2OID|BULLETID
	.LONG	ClTngBul
	.WORD	B2OID|ROCKETID
	.LONG	ClTngRck
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
BASECOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClBasBul
	.WORD	B1OID|ROCKETID
	.LONG	ClBasRck
	.WORD	B2OID|BULLETID
	.LONG	ClBasBul
	.WORD	B2OID|ROCKETID
	.LONG	ClBasRck
	.WORD	P1OID
	.LONG	ClBasPly
	.WORD	P2OID
	.LONG	ClBasPly
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
Injure:
;A0-amt to decrement from HEAD'S health if possible...
; will not blow off glasses, eyes or kill
	mmtm	SP,A1,A2,A5
	move	*A7(HEALTH),A2,W
	jrz	SkDecH
	move	A2,A5
	movb	*A7(HEDSTATE),A1
	cmpi	GLASSES,A1     	;If glasses still on...
	jreq	HvGlas0
	cmpi	FIREEYES,A1    	;If eyballs still on...
	jreq	HvEyes0
	sub	A0,A2
	jrp	GotHlth0
	clr	A2
	jruc	GotHlth0
HvGlas0:
	sub	A0,A2
	cmpi	192,A2
	jrge	GotHlth0
	movi	192,A2
	jruc	GotHlth0
HvEyes0:
	sub	A0,A2
	cmpi	32,A2
	jrge	GotHlth0
	movi	32,A2
;	jruc	GotHlth0

GotHlth0:
	move	A2,*A7(HEALTH),W

	;* SET COLOR CYCLE LEVEL OF BASE
	srl	5,A2
	srl	5,A5
	cmp	A2,A5
	jreq	NoCC
	movk	7,A5
	sub	A2,A5
	NOMATCHP	BASCCPID,>FFFF,NoCC
	movb	A5,*A0(COLORLVL)
NoCC:
SkDecH:
	mmfm	SP,A1,A2,A5
	rets
**************************************************************************

**************************************************************************
Injure1:
;A0-amt to decrement from HEAD'S health if possible...
; will blow off glasses, eyes or kill
	mmtm	SP,A1,A2,A5
	move	*A7(HEALTH),A2,W
	move	A2,A5
	movb	*A7(HEDSTATE),A1
	cmpi	GLASSES,A1     	;If glasses still on...
	jreq	HvGlas1
	cmpi	FIREEYES,A1    	;If eyballs still on...
	jreq	HvEyes1
	sub	A0,A2
	jruc	GotHlth1
HvGlas1:
	move	*A8(OXVEL),A1,L
	jrn	BlFrmRgt
	;* BULLET IS COMING FROM LEFT
	move	*A4(OFLAGS),A3,W
	btst	B_FLIPH,A3
	jrnz	NoHtGlas
	jruc	CkGlsHt
BlFrmRgt:
	;* BULLET IS COMING FROM RIGHT
	move	*A4(OFLAGS),A3,W
	btst	B_FLIPH,A3
	jrz	NoHtGlas
;	jruc	CkGlsHt

CkGlsHt:
	;* did rocket hit glasses?
	move	*A4(OZPOS),A3,W	
	move	*A8(OZPOS),A1,W
	sub	A1,A3
	calla	DFRMGRND		;A8 must pt to rock obj
	add	A3,A1
	cmpi	>52,A1
	jrlt	NoHtGlas
	cmpi	>75,A1
	jrgt	NoHtGlas

	cmpi	2,A0
	jrgt	RckGls

	movb	*A7(GLASSCTR),A1
	sub	A0,A1
	jrz	RckGls
	jrn	RckGls
	movb	A1,*A7(GLASSCTR)
	jruc	NoHtGlas

RckGls:
	;**** REMOVE THE GLASSES ****
	PUSH	A0
	move	A7,A0
	calla	GETA10
	movi	UDIE1SND,A0
	calla	ONESND

	move	A6,A0
	calla	BulToDat
	move	A0,A2
	movi	>25000,A1
	calla	SCORE
	calla	PUT25K

	;* SEND GLASSES FLYING
	move	*A10(GLAS),A0,L
	move	*A0(OIMG),A1,L
	movi	CHUNKINI,A14
	movk	3,A3
	callr	MkHdChnk
	jrz	NoHat
	move	A8,A14
	move	A0,A8

	PUSH	A7
	CREATE	CHUNKPID,FLYGLAS
	PULL	A7
	jrz	DelGlas

	move	*A14(OXVEL),A0,L
	sra	1,A0
	move	A0,*A8(OXVEL),L
	movi	->30000,A0	;YVEL
	move	A0,*A8(OYVEL),L
	movi	>10000,A0
	move	A0,*A8(OZVEL),L
	jruc	GLASFLEW
DelGlas:
	move	A8,A0
	calla	DELPAL
	calla	DELOBJ
GLASFLEW:
	move	A14,A8

	PULL	A0
	movb	*A10(INUSE),A1	;all parts are active
	andi	>FB,A1		;turn glasses off
	movb	A1,*A10(INUSE)

	movi	FIREEYES,A1    	;Turn eyballs on.
	movb	A1,*A7(HEDSTATE)

	sub	A0,A2
	cmpi	192,A2
	jrlt	GotHlth1
	movi	191,A2
	jruc	GotHlth1
HvEyes1:
	move	*A8(OXVEL),A1,L
	jrn	BlFrmRgt1
	;* BULLET IS COMING FROM LEFT
	move	*A4(OFLAGS),A3,W
	btst	B_FLIPH,A3
	jrnz	NoHtEyes
	jruc	CkEyeHt
BlFrmRgt1:
	;* BULLET IS COMING FROM RIGHT
	move	*A4(OFLAGS),A3,W
	btst	B_FLIPH,A3
	jrz	NoHtEyes
;	jruc	CkEyeHt

CkEyeHt:
	;* did rocket hit eyes?
	move	*A4(OZPOS),A3,W	
	move	*A8(OZPOS),A1,W
	sub	A1,A3
	calla	DFRMGRND		;A8 must pt to rock obj
	add	A3,A1
	cmpi	>59,A1
	jrlt	NoHtEyes
	cmpi	>71,A1
	jrgt	NoHtEyes

	cmpi	2,A0
	jrgt	RckEye

	movb	*A7(EYECTR),A1
	sub	A0,A1
	jrz	RckEye
	jrn	RckEye
	movb	A1,*A7(EYECTR)
	jruc	NoHtEyes

RckEye:
	;**** REMOVE THE EYES ****
	PUSH	A0
	NOMATCHP	EYECCPID,>FFFF,NoECC
	calla	KILL
NoECC:
	movi	UDIE2SND,A0
	calla	ONESND

	move	A6,A0
	calla	BulToDat
	move	A0,A2
	movi	>25000,A1
	calla	SCORE
	calla	PUT25K

	PULL	A0

	movi	TUNGER,A1    	;Turn tung on.
	movb	A1,*A7(HEDSTATE)
	sub	A0,A2
	cmpi	64,A2
	jrlt	GotHlth1
	movi	63,A2
;	jruc	GotHlth1

GotHlth1:
	move	A2,*A7(HEALTH),W
	move	A2,A2
	jrp	HlvlOk
	clr	A2
HlvlOk:

	;* SET COLOR CYCLE LEVEL OF BASE
	srl	5,A2
	srl	5,A5
	cmp	A2,A5
	jreq	NoCC
	movk	7,A5
	sub	A2,A5
	NOMATCHP	BASCCPID,>FFFF,NoCC1
	movb	A5,*A0(COLORLVL)
NoCC1:
Injure1X:
	mmfm	SP,A1,A2,A5
	rets

NoHtGlas:
NoHtEyes:
	callr	Injure
	jruc	Injure1X
**************************************************************************

**************************************************************************
FLYGLAS:
	move	*A8(OYVEL),A0,L
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	SLEEP	3
	calla	DFRMGRND
	cmpi	5,A1
	jrgt	FLYGLAS

	calla	ClrVel
	SLEEP	10
	movi	[1,1],A9
	jsrp	OSINK
	move	A8,A0
	calla	DELPAL
	calla	DELOBJ
	DIE
**************************************************************************


**************************************************************************
DrivBack:
;A0 - Amt to drive back
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SkNgBack
	neg	A0
SkNgBack:
	move	A0,A5
	
	move	A7,A0
	calla	GETA10
	move	*A10,A8,L

	sla	2,A5
	move	*A8(OXPOS),A1,W
	add	A5,A1
	move	A1,*A8(OXPOS),W

	movb	@RAND,A0
	jrn	SkNgZoff
	neg	A5
SkNgZoff:
	sra	2,A5

	movb	*A10(NUMPARTS),A4
	move	A10,A11
ZStLp:
	move	*A11+,A8,L
	move	*A8(OZPOS),A1,W
	add	A5,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OYPOS),A1,W
	add	A5,A1
	move	A1,*A8(OYPOS),W
	dsjs	A4,ZStLp

	callr	UpdHeadP
	rets
**************************************************************************

**************************************************************************
ClHedBul:
	move	A8,A6			;KILLERS OBJ
	move	A0,A4			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movi	HedBlSND,A0
	calla	ONESND

	movb	*A7(COLSRVC),A0
	jrnz	SkBrec
	
	movb	*A7(DIR),A0
	cmpi	4,A0
	jrlt	RecFlp
	movi	BRECOIL,A9
	jruc	GotRcFr
RecFlp:
	movi	BRECOILF,A9
GotRcFr:
	move	A7,A0
	calla	PUTA9
SkBrec:
	movk	1,A0
	callr	Injure1
	move	*A7(HEALTH),A0,W
	jrn	BlowUp

	movi	1,A0
	callr	DrivBack

	rets
**************************************************************************

**************************************************************************
ClBasBul:
	move	A8,A6			;KILLERS OBJ
	move	A0,A4			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movi	BasBSND,A0
	calla	ONESND

	movk	1,A0
	callr	Injure1
	move	*A7(HEALTH),A0,W
	jrn	BlowUp

	movi	2,A0
	callr	DrivBack

	rets
**************************************************************************

**************************************************************************
ClTngBul:
	move	A8,A6			;KILLERS OBJ
	move	A0,A4			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	movk	1,A0
	movb	A0,*A7(COLSRVC)

	movb	*A7(DIR),A0
	cmpi	4,A0
	jrlt	RecFlp2
	movi	TUNGFLEX,A9
	jruc	GotRcFr2
RecFlp2:
	movi	TUNGFLXF,A9
GotRcFr2:
	move	A7,A0
	calla	PUTA9

	movk	8,A0
	callr	Injure1
	move	*A7(HEALTH),A0,W
	jrn	BlowUp

	movi	3,A0
	callr	DrivBack

	rets
**************************************************************************

**************************************************************************
ClHedRck:
	move	A8,A6			;KILLERS OBJ
	move	A0,A4			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movb	*A7(DIR),A0
	cmpi	4,A0
	jrlt	RecFlp1
	movi	RRECOIL,A9
	jruc	GotRcFr1
RecFlp1:
	movi	RRECOILF,A9
GotRcFr1:
	move	A7,A0
	calla	PUTA9

	movi	16,A0
	callr	Injure1
	move	*A7(HEALTH),A0,W
	jrn	BlowUp

	move	*A7(HEALTH),A0,W
	jrnn	SkBlow
BlowUp:
* XFERPROC - A0=PRCPTR, A1=NEW ID, A7=NEW PC, A8-A11=PASSED
	PUSH	A7
	move	A7,A0
	calla	GETA10
	callr	ClrColls
	movi	HEADXPID,A1
	movi	HedExplo,A7
	calla	XFERPROC
	PULL	A7

SkBlow:
CollRckX:
	movi	5,A0
;A0 - Amt to drive back
;A7 - ptr to head proc
;A6 - ptr to killers obj
	callr	DrivBack

	rets
**************************************************************************

**************************************************************************
ClBasRck:
	move	A8,A6			;KILLERS OBJ
	move	A0,A4			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	movi	RRECOIL,A9
	move	A7,A0
	calla	PUTA9

	movk	8,A0
	callr	Injure1
	move	*A7(HEALTH),A0,W
	jrn	BlowUp

	movi	10,A0
	callr	DrivBack

	rets
**************************************************************************

**************************************************************************
ClTngRck:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	jruc	BlowUp
**************************************************************************

**************************************************************************
ClrColls:
	mmtm	SP,A0,A1,A7,A10
	movb	*A10(NUMPARTS),A7
	movi	DUMCOLL,A0
ClrColLp:
	move	*A10+,A1,L
	move	A0,*A1(OCVECT),L
	dsjs	A7,ClrColLp
	mmfm	SP,A0,A1,A7,A10
	rets
**************************************************************************

**************************************************************************
ClrSCols:
	mmtm	SP,A0,A1,A7,A11
	move	*A7(SPINE),A11,L
	movb	*A7(SPINELEN),A7
	movi	DUMCOLL,A0
ClrSCoLp:
	move	*A11+,A1,L
	move	A0,*A1(OCVECT),L
	dsjs	A7,ClrSCoLp
	mmfm	SP,A0,A1,A7,A11
	rets
**************************************************************************

**************************************************************************
ClBasPly:
	move	A8,A6			;players OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	callr	PlyrBack

	movb	*A7(BASEFLSH),A0
	jrp	GotFlsh
	movi	BaseSND,A0
	calla	ONESND
	movi	SkExpSND,A0
	calla	ONESND

	movk	20,A0
	movb	A0,*A7(LAUGH)

	movk	10,A0
	movb	A0,*A7(BASEFLSH)
	;Do a palette transfer to the flash pal
	movi	basepal,A0
	calla	FINDPAL
	move	A0,A1
	SLL	24,A1
	SRL	16,A1
	movi	baseflsh,A0
	move	*A0+,A2,W		
	calla	PALSET

	movi	SKYFLASH,A0
	move	A0,@IRQSKYE,W

GotFlsh:
	rets
**************************************************************************

**************************************************************************
PlyrBack:
;parms A0-mb obj, A6-players OBJ
	mmtm	SP,A0,A1,A2
	movk	4,A1
	move	A0,A8
	calla	GETANIX
	move	A0,A2	;A2 mb xpos
	move	A6,A8
	PUSH	A1
	calla	CKLXBND
	PULL	A1
	jrc	PBackX

	calla	GETANIX
	cmp	A0,A2
	jrlt	SkNgXD
	neg	A1
SkNgXD:
	move	A6,A0
	calla	GetPData
	calla	MovePlyr
PBackX:
	mmfm	SP,A0,A1,A2
	rets
**************************************************************************

**************************************************************************
CkBFlash:
	movb	*A13(BASEFLSH),A1
	jrz	CkBFlshX
	sub	A0,A1
	movb	A1,*A13(BASEFLSH)
	jrp	CkBFlshX
	clr	A1
	movb	A1,*A13(BASEFLSH)
	mmtm	SP,A0
	;Do a palette transfer to the flash pal
	movi	basepal,A0
	calla	FINDPAL
	move	A0,A1
	SLL	24,A1
	SRL	16,A1
	movi	basepal,A0
	move	*A0+,A2,W		
	calla	PALSET

	mmfm	SP,A0
CkBFlshX:
	rets
**************************************************************************

**************************************************************************
NewPals:
;THIS FUNCTION CAN SLEEP --- USE JSRP!!!
;Parms:  A6-ptr to pal list 
;* REALLOCATE AND STUFF PALETTES
	PUSHP	A9
	move	A10,A11
	movb	*A10(NUMPARTS),A7
LoadPals:
	move	*A11+,A9,L
	move	*A9(OPAL),A0,W
	calla	FREEPAL
	move	*A6+,A0,L
TryAllc:
	calla	GETFPAL
	jrnz	GotNP
	mmtm	A12,A0,A6,A7
	SLEEP	1
	mmfm	A12,A0,A6,A7
	jruc	TryAllc
GotNP:
	move	A0,*A9(OPAL),W
	dsj	A7,LoadPals
	PULLP	A9
	retp
**************************************************************************


**************************************************************************
HedExplo:
;* PROCESS TO BLOW UP THE HEAD...
	move	*A10,A8,L
	calla	ClrVel
	callr	UpdHeadV

	movi	AgitSND,A0
	calla	ONESND

	movi	20,A0
ShakeLp:
	PUSHP	A0

	callr	AGITATE
	callr	BaseCent
	callr	BaseDamp
	callr	BaseDamp
	move	*A10,A8,L
	callr	ZCHECK
	callr	UpdHeadV
	callr	UpdHeadP
	SLEEP	2
	PULLP	A0
	dec	A0
	jrp	ShakeLp

	movi	HdExpSND,A0
	calla	ONESND

	movi	KABOOMF,A9
	movk	3,A1
	movb	*A13(DIR),A0
	cmpi	4,A0
	jrle	GotBOOM
	movi	KABOOM,A9
	movk	9,A1
GotBOOM:
	move	A9,*A13(ANIMPTR),L
	movb	A1,*A13(DIR)

	movi	>FF,A0		
	movb	A0,*A10(INUSE)	;all parts are active
	callr	AniHead

	;* CREATE MAJOR HEAD PIECES
	movi	HED3hat,A1
	movi	CHUNKINI,A14
	movk	1,A3
	callr	MkHdChnk
	jrz	NoHat
	move	A0,A1
	move	A0,A8
	callr	HatStump
	jrz	NoFly
	move	A0,A11
	create	CHUNKPID,FlyHat
	jrz	NoFlyHat
NoHat:
	movi	BOOM5a,A1
	movi	CHUNKINI,A14
	movk	3,A3
	callr	MkHdChnk
	jrz	NoFace
	move	A0,A8
	create	CHUNKPID,FlyFace
	jrz	NoFly
NoFace:
	movi	BOOM5b,A1
	movi	CHUNKINI,A14
	movk	2,A3
	callr	MkHdChnk
	jrz	NoEar1
	move	A0,A8
	create	CHUNKPID,FlyEar1
	jrz	NoFly
NoEar1:
	movi	BOOM5c,A1
	movi	CHUNKINI,A14
	movk	2,A3
	callr	MkHdChnk
	jrz	NoNeck
	move	A0,A8
	create	CHUNKPID,FlyNeck
	jrz	NoFly
NoNeck:
;	movi	BOOM5b,A1
;	movi	CHUNKINI,A14
;	movi	-5,A3
;	callr	MkHdChnk
;	jrz	NoEar2
;	move	A0,A8
;	create	CHUNKPID,FlyEar2
;	jrz	NoFly
;NoEar2:
	movi	BOOM6,A1
	movi	CHUNKINI,A14
	movk	1,A3
	callr	MkHdChnk
	jrz	NoSNck
	move	A0,A8
	create	CHUNKPID,FlySNck
	jrz	NoFly
NoSNck:
	jruc	GotFlys

NoFlyHat:
	move	A11,A0
	calla	DELPAL
	calla	DELOBJ
NoFly:
	move	A8,A0
	calla	DELPAL
	calla	DELOBJ

GotFlys:
	movi	SPalTbl0,A6
	jsrp	NewPals
	callr	AniHead		;Put Out Skull and Jaw
	;* restuff skull and jaw with centered ani points
	movi	skull4,A1
	move	A1,*A10(SKULLANI),L
	move	*A10(SKULL),A0,L
	move	A1,*A0(OIMG),L

	movi	jaw4,A1
	move	A1,*A10(JAWANI),L
	move	*A10(JAW),A0,L
	move	A1,*A0(OIMG),L

	movi	stumpskl,A1
	move	A1,*A10(STUMPANI),L
	move	*A10(STUMP),A0,L
	move	A1,*A0(OIMG),L

	movi	BASEskl,A1
	move	A1,*A10(BASELANI),L
	move	*A10(BASEL),A0,L
	move	A1,*A0(OIMG),L
	move	A1,*A10(BASERANI),L
	move	*A10(BASER),A0,L
	move	A1,*A0(OIMG),L

	movk	15,A0
	jsrp	EXPLDSLP

;****** CREATE LOTS OF FRAGMENTS TO BLOW FROM HEAD ********
	movi	CHNKTBL5,A1
	movi	CHUNKINI,A2
	movi	CHNKSINK,A4
	movi	>580000,A6 ;Y:X OFFSET of where to start chunks from object
	move	*A10,A8,L
	callr	DOCHUNKS

	movk	10,A0
	jsrp	EXPLDSLP

	;**** kill eye color cycler
	NOMATCHP	EYECCPID,>FFFF,NoEyeCC
	calla	KILL
NoEyeCC:

	movi	CHNKTBL2,A1
	movi	CHNKTINI,A2
	movi	CHNKSINK,A4
	movi	>580000,A6 ;Y:X OFFSET of where to start chunks from object
	move	*A10,A8,L
	callr	DOCHUNKS

	movk	15,A0
	jsrp	EXPLDSLP

	movi	CHNKTBL1,A1
	movi	CHUNKINI,A2
	movi	CHNKSINK,A4
	movi	>580000,A6 ;Y:X OFFSET of where to start chunks from object
	move	*A10,A8,L
	callr	DOCHUNKS

	movk	15,A0
	jsrp	EXPLDSLP

	movi	CHNKTBL1,A1
	movi	CHUNKINI,A2
	movi	CHNKSINK,A4
	movi	>580000,A6 ;Y:X OFFSET of where to start chunks from object
	move	*A10,A8,L
	callr	DOCHUNKS

	movk	5,A0
	jsrp	EXPLDSLP

;BUGCOLD; A5  - Y:X; A6  - 0:Z;
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;	move	*A10(SKULL),A8,L
* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
;	calla	GETANIXY
;	srl	16,A3
;	movx	A3,A5
;	subi	>480000,A2
;	movy	A2,A5
;	move	*A8(OZPOS),A6,W
;	movi	>00330000|BUGEOID|1,A14
;	calla	BUGCOLD

	movk	5,A0
	jsrp	EXPLDSLP

	movi	CHNKTBL1,A1
	movi	CHUNKINI,A2
	movi	CHNKSINK,A4
	movi	>580000,A6 ;Y:X OFFSET of where to start chunks from object
	move	*A10,A8,L
	callr	DOCHUNKS

	jruc	Skeleton
**************************************************************************

**************************************************************************
EXPLDSLP:
	PUSHP	A0
EXPSLP1:
	PULLP	A0
	dec	A0
	jrn	SLPX
	SLEEP	1
	PUSHP	A0
	callr	BaseDamp
	callr	UpdHeadV
	callr	UpdHeadP
	jruc	EXPSLP1
SLPX:
	retp
**************************************************************************

**************************************************************************
FlyHat:
;* PROCESS TO FLY HAT AND STUMP ..
	movi	->80000,A0
	move	A0,*A8(OYVEL),L
	move	A0,*A11(OYVEL),L

	SLEEP	25

	move	A8,A0
	calla	DELPAL
	calla	DELOBJ
	move	A11,A0
	calla	DELPAL
	calla	DELOBJ
	DIE
**************************************************************************

**************************************************************************
FlyFace:
	movk	10,A0
	calla	PRCSLP
	movi	->80000,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkNgXV1
	neg	A0
SkNgXV1:
	move	A0,*A8(OXVEL),L
	movi	->40000,A0
	move	A0,*A8(OYVEL),L
	movi	60,A0
	calla	PRCSLP
	callr	DelChnk
	DIE
**************************************************************************

**************************************************************************
FlyEar1:
	movk	8,A0
	calla	PRCSLP
	movi	>80000,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkNgXV2
	neg	A0
SkNgXV2:
	move	A0,*A8(OXVEL),L
	movi	->48000,A0
	move	A0,*A8(OYVEL),L
	movi	55,A0
	calla	PRCSLP
	callr	DelChnk
	DIE
**************************************************************************

**************************************************************************
FlyEar2:
	movk	8,A0
	calla	PRCSLP
	movi	>48000,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkNgXV5
	neg	A0
SkNgXV5:
	move	A0,*A8(OXVEL),L
	movi	->40000,A0
	move	A0,*A8(OYVEL),L
	movi	65,A0
	calla	PRCSLP
	callr	DelChnk
	DIE
**************************************************************************

**************************************************************************
FlyNeck:
	movk	10,A0
	calla	PRCSLP
	movi	>20000,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkNgXV3
	neg	A0
SkNgXV3:
	move	A0,*A8(OXVEL),L
	movi	->70000,A0
	move	A0,*A8(OYVEL),L
	movi	60,A0
	calla	PRCSLP
	callr	DelChnk
	DIE
**************************************************************************

**************************************************************************
FlySNck:
	movk	15,A0
	calla	PRCSLP
	movi	->20000,A0
	move	*A8(OFLAGS),A1,W
	btst	B_FLIPH,A1
	jrz	SkNgXV4
	neg	A0
SkNgXV4:
	move	A0,*A8(OXVEL),L
	movi	->68000,A0
	move	A0,*A8(OYVEL),L
	movi	60,A0
	calla	PRCSLP
	callr	DelChnk
	DIE
**************************************************************************

**************************************************************************
DelChnk:
	move	A8,A0
	calla	DELPAL
	calla	DELOBJ
	rets
**************************************************************************

**************************************************************************
HatStump:
;* create upside down STUMP object.
;Parms - A1 ptr to hat object
;return ptr to obj in A0
	mmtm	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	calla	GETOBJ
	jrz	NoStump
	move	A0,A3

	movi	headxpal,A0
	calla	GETFPAL
	jrz	NoHdXPal
	move	A0,*A3(OPAL),W

	move	*A1(OFLAGS),A4,L
	andni	M_FLIPH,A4
	ori	M_FLIPV,A4

	move	A1,A7
	movi	stump,A1
	move	A1,*A3(OIMG),L
	move	A3,A10
*GSAGOF: A1=OIMG, A4=OBJECT FLAGS -> A2=OSIZE, A3=OSAG, A4=OFFSET:OFLAGS
	calla	GSAGOF
	move	A4,*A10(OFLAGS),L
	move	A3,*A10(OSAG),L
	move	A2,*A10(OSIZE),L
	move	A10,A3

	move	A7,A1
	move	*A1(OID),*A3(OID),W

	movi	DUMCOLL,A0
	move	A0,*A3(OCVECT),L

	move	*A1(OXPOS),A4,W
	addi	10,A4
	move	A4,*A3(OXPOS),W

	move	*A1(OYPOS),A4,W
	addi	30,A4
	move	A4,*A3(OYPOS),W

	move	*A1(OZPOS),A4,W
	inc	A4
	move	A4,*A3(OZPOS),W

	clr	A0
	move	A0,*A3(OXVEL),L
	move	A0,*A3(OYVEL),L
	move	A0,*A3(OZVEL),L

	move	A3,A0
	calla	INSOBJ
	movi	1,A1	;clr zero flag
	jruc	StumpX

NoHdXPal:
	move	A3,A0
	calla	FREEOBJ
NoStump:
	clr	A0
StumpX:
	mmfm	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	rets
**************************************************************************

**************************************************************************
MkHdChnk:
;Parms
;A10-ptr to head data
;A1-IMG to create
;A3-Z position offset from base
;A14-init table
;Rets
;A0 ptr to new obj
;* create a head chunk positioned about the anim pt of the head
	mmtm	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	calla	GETOBJ
	jrz	NoChnk
	move	A0,A2
	calla	STFOBJ

	move	*A1(ICMAP),A0,L	
	calla	GETFPAL
	jrz	NoCPal
	move	A0,*A2(OPAL),W
	
	move	A2,A8
	move	*A10(HAT),A7,L
	move	*A7(OFLAGS),A4,W
* ANI: A1=IMAGE PTR, A4=FLAGS, A8=OBJECT STRUCTURE POINTER TO BE UPDATED				 *
	calla	ANI
	move	*A7(OZPOS),A0,W
	add	A3,A0
	move	A0,*A2(OZPOS),W

	move	A7,A8
	move	A2,A0
	calla	SetAniP
	move	A2,A0
	calla	INSOBJ
	move	A2,A0
	jruc	MkChnkX

NoCPal:
	move	A2,A0
	calla	FREEOBJ
NoChnk:
	clr	A0
MkChnkX:
	mmfm	SP,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	rets
**************************************************************************


**************************************************************************
DOCHUNKS:
;* PARMS
;   A1 - ptr to chunk table
;   A2 - ptr to init tbl
;   A4 - ptr to ground hit routine
;   A6 - Y:X OFFSET of where to start chunks from object
;   A8 - ptr to obj to send chunks from
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
;	move	*A10,A8,L
	move	A2,A10		;ptr to init table

* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
	calla	GETANIXY
	move	A3,A11
	srl	16,A11
	movy	A2,A11
	addxy	A6,A11

	move	*A8(OZPOS),A3,W
	dec	A3
	move	*A8(OFLAGS),A2,W
	sll	16,A2
	movy	A2,A3		;A3 stuff into PDATA

	move	A1,A14
CHUNKLP:
	move	@FRAGCNT,A0,W
	cmpi	70,A0
	jrgt	CHUNKX

	move	*A14+,A9,L
	jrz	CHUNKX

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
	CREATE	CHUNKPID,NTRAJEC
	jrz	CHUNKX
	move	A0,A7
	move	@FRAGCNT,A0,W
	inc	A0
	move	A0,@FRAGCNT,W

	move	A3,*A7(PDATA),L	;FLAGS:ZPOS
	movi	>40000,A0	;XVEL
	calla	SRAND
	move	A0,*A7(PDATA+>20),L
	movi	>40000,A0	;YVEL
	calla	RANDU
	neg	A0
	subi	>30000,A0
	move	A0,*A7(PDATA+>40),L
	movi	>10000,A0	;ZVEL
	calla	SRAND
	move	A0,*A7(PDATA+>60),L
	clr	A0
	move	A0,*A7(PDATA+>80),L
	move	A4,*A7(PDATA+>A0),L	;GRND PROC
	jruc	CHUNKLP

CHUNKX:
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14
	rets
**************************************************************************

**************************************************************************
;**** CHNKSINK IS ENTRY POINT...
NxtFrm:
	move	*A9+,A0,W
	move	A0,A1
	andi	FLIPBITS,A0
	jrz	SkAFLP2
	move	*A9+,A0,W
SkAFLP2:
	andi	NEWPALET,A1
	jrz	CHNKSINK
	move	*A9+,A0,L

CHNKSINK:
	move	*A9+,A0,L
	jrnz	NxtFrm

	movi	ChunkSND,A0
	calla	ONESND

	MOVK	4,A1
	JSRP	FRANIM

	sleep	20
	movi	[1,1],A9
	jsrp	OSINK
	move	A8,A0
	calla	DELPAL
	calla	DELSOBJ

	move	@FRAGCNT,A0,W
	dec	A0
	move	A0,@FRAGCNT,W

	DIE
**************************************************************************



**************************************************************************
;*  SKELETON PORTION OF HEAD
**************************************************************************

**************************************************************************
Skeleton:
;* PROCESS TO CONTROL SKELETON
	move	*A10,A8,L
	calla	BLIPOFF
	movi	SKULBLIP,A0
	move	A0,*A8(OBLIPIMG),L

	clr	A0
	movb	A0,*A13(ANIMTIKS)
	movb	A0,*A13(BRAINTIKS)
	movb	A0,*A13(BITING)
	movb	A0,*A13(INBITE)
	movb	A0,*A13(TUNGDEAD)

	move	*A10(STNG),A8,L
	movi	STNGCOLL,A0
	move	A0,*A8(OCVECT),L

	movk	6,A0
	movb	A0,*A10(NUMPARTS)
	movk	3,A0
	movb	A0,*A10(BASPARTS)
	movk	3,A0
	movb	A0,*A10(SKLPARTS)

	movi	>FF,A0		
	movb	A0,*A10(INUSE)	;all parts are active
	movb	*A10(ONLIST),A0	;list is only for sklparts now
	sll	3,A0
	movb	A0,*A10(ONLIST)	

	clr	A9
	move	A9,*A13(ANIMPTR),L
	callr	GetSAni

	movk	13,A0
	movb	A0,*A13(SPINELEN)
	jsrp	MkSpine

	move	*A10,A8,L
	calla	ClrVel
	callr	UpdBaseV

	movi	SKULCOLL,A1
	move	*A10(SKULL),A0,L
	move	A1,*A0(OCVECT),L
	move	*A10(JAW),A0,L
	move	A1,*A0(OCVECT),L

	movi	SBSECOLL,A1
	move	*A10(STUMP),A0,L
	move	A1,*A0(OCVECT),L
	move	*A10(BASEL),A0,L
	move	A1,*A0(OCVECT),L
	move	*A10(BASER),A0,L
	move	A1,*A0(OCVECT),L

	push	A10
	movk	7,A10
	CREATE	SKLCCPID,SKEYE
	pull	A10

	jruc	SKEL_MV
**************************************************************************

**************************************************************************
;MAKE SPINE - jsrp to, retps when spine is ready to go...

WaitSObj:
	SLEEP	1
MkSpine:
	calla	GETOBJ
	jrz	WaitSObj
	move	A0,*A13(SPINE),L
	calla	CLROBJ		;Clear out SPINE data object
	
;* ALLOCATE OBJECTS
	move	*A13(SPINE),A11,L	;load up Xtra data obj with ptrs to parts
	movb	*A13(SPINELEN),A7
	jruc	GetSObjs
WtSObj:
	PUSHP	A7
	SLEEP	1
	PULLP	A7
GetSObjs:
	calla	GETOBJ
	jrz	WtSObj
	move	A0,*A11+,L
	dsjs	A7,GetSObjs

;* INITIALIZE OBJECTS
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A7
StuffemS:
	movi	SpineIni,A14,L
	move	*A11+,A0,L
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	dsjs	A7,StuffemS

;* ALLOCATE AND STUFF PALETTES
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A7
IniSPals:
	movi	skelpal,A0
	calla	GETFPAL
	jrnz	GotSP
	mmtm	A12,A6,A7
	SLEEP	1
	mmfm	A12,A6,A7
	jruc	IniSPals
GotSP:
	move	*A11+,A1,L
	move	A0,*A1(OPAL),W
	dsj	A7,IniSPals

	;* set initial position of SPINE
	move	*A10(BASEL),A8,L
	calla	ClrVel
	callr	StSpineV
	callr	StSpineP

;* INSERT OBJECTS on the obj list and on the ENEMIES list
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A7
	movi	ENEMIES,A1
InsertS:
	move	*A11+,A0,L
	calla	INSOBJ
	calla	ADDSUPP
	dsjs	A7,InsertS
	retp
**************************************************************************

**************************************************************************
HedSpine:
;MOVE SPINE FROM HEAD
;PARMS
; A0 - multiplier for portion of dist between previous and next bone
;	to place the current bone
;	0=0%, >FFFF=99.99%

	mmtm	SP,A9

	;**** GET COORS OF HEAD
	move	*A10(SKULL),A8,L
* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
	calla	GETANIXY
	addi	>10000,A2
	subi	>E0000,A3
	move	A2,A5		;A5 = Y coor of previous piece
	move	A3,A7		;A7 = X coor of previous piece
	move	*A8(OZVAL),A9,L	;A9 = Z coor of previous piece

	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A6
	jrz	HedSpX
	dec	A6			;don't update bottom bone
	jrz	HedSpX
SpineLp:
	move	*A11+,A1,L	;Load ptr to current obj
	;**** GET COORS OF NEXT PIECE DOWN
	move	*A11,A8,L     ;get next spine bone
	move	*A8(OYVAL),A2,L
	move	*A8(OXVAL),A3,L
	move	*A8(OZVAL),A4,L
       	sub	A2,A5		;A5 = Y ( (P-1) - (P+1) )
	sra	16,A5
	mpys	A0,A5
	add	A2,A5
	move	A5,*A1(OYVAL),L
	sub	A3,A7		;A7 = X ( (P-1) - (P+1) )
	sra	16,A7
	mpys	A0,A7
	add	A3,A7
	move	A7,*A1(OXVAL),L
	sub	A4,A9		;A9 = Z ( (P-1) - (P+1) )
	sra	16,A9
	mpys	A0,A9
	add	A4,A9
	move	A9,*A1(OZVAL),L
	dsj	A6,SpineLp
	
HedSpX:
	mmfm	SP,A9
	rets
**************************************************************************


**************************************************************************
BasSpine:
;MOVE SPINE FROM BASE
;PARMS
; A0 - multiplier for portion of dist between previous and next bone
;	to place the current bone
;	0=0%, >FFFF=99.99%

	mmtm	SP,A9

	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A6
	move	A6,A4
	sll	5,A4
	add	A4,A11

	;*Get Coors of Bottom Bone
	dec	A6	;LOADING BOTTOM BONE
	move	-*A11,A1,L     ;at end of list so use the base
	move	*A1(OYVAL),A5,L	;A5 = Y coor of previous piece
	move	*A1(OXVAL),A7,L	;A7 = X coor of previous piece
	move	*A1(OZVAL),A9,L	;A9 = Z coor of previous piece

SpineLp1:
	move	-*A11,A1,L	;Load ptr to current obj
	;**** GET COORS OF PREVIOUS PIECE
	cmpi	1,A6
	jrnz	SkHd
	;**** GET COORS OF HEAD
	move	*A10(SKULL),A8,L
* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
	calla	GETANIXY
	addi	>10000,A2
	subi	>E0000,A3
	jruc	GtNCoor
SkHd:
	move	A11,A4
	move	-*A4,A8,L     ;get previous spine bone
	move	*A8(OYVAL),A2,L
	move	*A8(OXVAL),A3,L
	move	*A8(OZVAL),A4,L
GtNCoor:
       	sub	A2,A5		;A5 = Y ( (P-1) - (P+1) )
	sra	16,A5
	mpys	A0,A5
	add	A2,A5
	move	A5,*A1(OYVAL),L
	sub	A3,A7		;A7 = X ( (P-1) - (P+1) )
	sra	16,A7
	mpys	A0,A7
	add	A3,A7
	move	A7,*A1(OXVAL),L
	sub	A4,A9		;A9 = Z ( (P-1) - (P+1) )
	sra	16,A9
	mpys	A0,A9
	add	A4,A9
	move	A9,*A1(OZVAL),L

	dsj	A6,SpineLp1
	
	mmfm	SP,A9
	rets
**************************************************************************


**************************************************************************
StSpineV:
	move	*A8(OXVEL),A1,L
	move	*A8(OYVEL),A2,L
	move	*A8(OZVEL),A3,L

	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A7
StVels:
	move	*A11+,A0,L
	move	A1,*A0(OXVEL),L
	move	A2,*A0(OYVEL),L
	move	A3,*A0(OZVEL),L
	dsjs	A7,StVels
	rets
**************************************************************************

**************************************************************************
StSpineP:
* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
	calla	GETANIXY
	move	*A8(OZVAL),A1,L
	subi	>E0000,A3
	addi	>10000,A2

	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A7
StPoses:
	move	*A11+,A0,L
	move	A3,*A0(OXVAL),L
	move	A2,*A0(OYVAL),L
	move	A1,*A0(OZVAL),L
	dsjs	A7,StPoses
	rets
**************************************************************************


**************************************************************************
SKULCOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClSklBul
	.WORD	B1OID|ROCKETID
	.LONG	ClSklRck
	.WORD	B2OID|BULLETID
	.LONG	ClSklBul
	.WORD	B2OID|ROCKETID
	.LONG	ClSklRck
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
STNGCOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClSklBul
	.WORD	B1OID|ROCKETID
	.LONG	ClStngRck
	.WORD	B2OID|BULLETID
	.LONG	ClSklBul
	.WORD	B2OID|ROCKETID
	.LONG	ClStngRck
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
SPNECOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClSpnBul
	.WORD	B1OID|ROCKETID
	.LONG	ClSpnRck
	.WORD	B2OID|BULLETID
	.LONG	ClSpnBul
	.WORD	B2OID|ROCKETID
	.LONG	ClSpnRck
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
SBSECOLL:
	.WORD	B1OID|BULLETID
	.LONG	ClSbsBul
	.WORD	B1OID|ROCKETID
	.LONG	ClSbsRck
	.WORD	B2OID|BULLETID
	.LONG	ClSbsBul
	.WORD	B2OID|ROCKETID
	.LONG	ClSbsRck
	.WORD	P1OID
	.LONG	ClBasPly
	.WORD	P2OID
	.LONG	ClBasPly
	.WORD	0
	.LONG	DUMRTSG
**************************************************************************

**************************************************************************
ClStngRck:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	movk	1,A0
	movb	A1,*A7(TUNGDEAD)
	jruc	TngEntry

**************************************************************************
ClSklRck:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movi	100,A0
	calla	RANDPER
	jrnc	TngEntry
	movk	1,A0
	movb	A1,*A7(TUNGDEAD)

TngEntry:
	movi	120,A0
	movb	A0,*A7(BRAINTIKS)

	movi	>C0000,A0
	callr	SklBackV
	movi	>30000,A0
	callr	SklUpV

	rets
**************************************************************************

**************************************************************************
ClSpnRck:
	move	A8,A6			;KILLERS OBJ
	move	A0,A8			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB Proc
	movi	70,A0
	movb	A0,*A7(BRAINTIKS)
	calla	SpineHit
	movi	>60000,A0
	callr	SklBackV
	movi	>20000,A0
	callr	SklUpV
	rets
**************************************************************************

**************************************************************************
ClSbsRck:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	movi	60,A0
	movb	A0,*A7(BRAINTIKS)

	movi	>90000,A0
	callr	BasBackV
	rets
**************************************************************************

**************************************************************************
ClSklBul:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movi	6,A0
	callr	SkulBack
	movi	>4000,A0
	callr	SklBackV

	rets
**************************************************************************

**************************************************************************
ClSpnBul:
	move	A8,A6			;KILLERS OBJ
	move	A0,A8			;MB OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ
	calla	SpineHit
	movi	>4000,A0
	callr	SklBackV
	movi	>20000,A0
	callr	SklUpV
	rets
**************************************************************************

**************************************************************************
ClSbsBul:
	move	A8,A6			;KILLERS OBJ
	move	*A0(OPLINK),A7,L	;MB OBJ

	movi	3,A0
	callr	BaseBack

	rets
**************************************************************************


**************************************************************************
SpineHit:
;A6 ptr to obj striking bone
;A8 ptr to spine bone struck

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13
	move	*A8(OPLINK),A13,L 

	;SEARCH SPINE LIST FOR BONE
	movb	*A13(SPINELEN),A1
	move	*A13(SPINE),A11,L
SrchSpn:
	move	*A11+,A0,L
	cmp	A0,A8
	jreq	GotVB
	dsjs	A1,SrchSpn
	jruc	SpnHitX

	;COPY LOWER BONES UP 1, SHORTEN SPINE 1 
GotVB:
	move	A11,A2
	subi	32,A2
CpySpn:
	move	*A11+,*A2+,L	
	dsjs	A1,CpySpn

	;*** ADD NUKE FOR DRAMA
	mmtm	SP,A10,A11
	clr	A10
	clr	A11
	CREATE	NUKEPID,MkNuke
	mmfm	SP,A10,A11

	;* GIVE SOME BONUS
	move	A6,A0
	calla	BulToDat
	jrz	SkScore
	move	A0,A2
	movi	>25000,A1
	calla	SCORE
	calla	PUT25K
SkScore:

	;SEND BONE FLYING
	movi	FLYSPINE,A9
	CREATE	CHUNKPID,NTRAJEC1
	jrz	DelVB
	move	A0,A7
	move	@FRAGCNT,A0,W
	inc	A0
	move	A0,@FRAGCNT,W

	move	A8,A0
	movi	ENEMIES,A1
	calla	DELSUPP

	move	*A6(OXVEL),A0,L
	sra	1,A0
	move	*A8(OXVEL),A1,L
	add	A0,A1
	move	A1,*A8(OXVEL),L
	movi	>20000,A0	;YVEL
	calla	RANDU
	neg	A0
	move	A0,*A8(OYVEL),L
	clr	A0
	move	A0,*A8(OZVEL),L

	movi	BONESINK,A4
	move	A4,*A7(PDATA+>A0),L	;GRND PROC

	;IF SPINELEN <= 6 BLOWUP SKULL
	movb	*A13(SPINELEN),A0
	dec	A0
	movb	A0,*A13(SPINELEN)
	cmpi	6,A0
	jrnz	SpnHitX

	;***** XFER SKEL PROC TO SKEL EXPLO
	move	A13,A0
	calla	GETA10
	movk	7,A1
	movb	A1,*A10(NUMPARTS)
	move	A13,A7
	callr	ClrColls
	callr	ClrSCols
	movi	HEADXPID,A1
	movi	SklExplo,A7
* XFERPROC - A0=PRCPTR, A1=NEW ID, A7=NEW PC, A8-A11=PASSED
	calla	XFERPROC
	jruc	SpnHitX

DelVB:
	move	A8,A0
	calla	DELENEMY	;DELETE THE SPINE BONE

SpnHitX:
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13
	rets
**************************************************************************


**************************************************************************
BaseBack:
;A0 - Amt to drive back
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SkNgBck
	neg	A0
SkNgBck:
	move	A0,A5
	sla	2,A5

	move	A7,A0
	calla	GETA10

	move	*A10(BASEL),A8,L
	move	*A8(OXPOS),A1,W
	add	A5,A1
	move	A1,*A8(OXPOS),W

	move	A7,A13
	callr	UpdBaseP
	rets
**************************************************************************

**************************************************************************
BasBackV:
;A0 - Amt of velocity change
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SkNgBckV
	neg	A0
SkNgBckV:
	move	A0,A5
	move	A7,A0
	calla	GETA10

	move	*A10(BASEL),A8,L
	move	*A8(OXVEL),A0,L
	add	A5,A0
	move	A0,*A8(OXVEL),L

	move	A7,A13
	callr	UpdBaseV
	rets
**************************************************************************

**************************************************************************
SklBackV:
;A0 - Amt of velocity change
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SklBck1
	neg	A0
SklBck1:
	move	A0,A5
	move	A7,A0
	calla	GETA10

	move	*A10(SKULL),A8,L
	move	*A8(OXVEL),A0,L
	add	A5,A0
	move	A0,*A8(OXVEL),L

	callr	UpdSkulV
	rets
**************************************************************************

**************************************************************************
SklUpV:
;A0 - Amt of velocity change
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SklUp1
	neg	A0
SklUp1:
	move	A0,A5
	move	A7,A0
	calla	GETA10

	move	*A10(SKULL),A8,L
	move	*A8(OYVEL),A0,L
	add	A5,A0
	move	A0,*A8(OYVEL),L

	callr	UpdSkulV
	rets
**************************************************************************

**************************************************************************
SkulBack:
;A0 - Amt to drive back
;A7 - ptr to head proc
;A6 - ptr to killers obj

	move	*A6(OXVEL+16),A1,W
	jrnn	SkNgBck2
	neg	A0
SkNgBck2:
	move	A0,A5
	sla	2,A5

	move	A7,A0
	calla	GETA10

	move	*A10(SKULL),A8,L
	move	*A8(OXPOS),A1,W
	add	A5,A1
	move	A1,*A8(OXPOS),W

	move	*A10(JAW),A8,L
	move	*A8(OXPOS),A1,W
	add	A5,A1
	move	A1,*A8(OXPOS),W

	rets
**************************************************************************


**************************************************************************
SKEL_MV:
	move	*A10,A8,L
	callr	ZCHECK
	callr	XBOUNDS
	callr	NeckCk

	movb	*A13(BRAINTIKS),A0
	jrnz	BrainX
	movi	35,A0
	movb	A0,*A13(BRAINTIKS)
	callr	SkulAttk
BrainX:

	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX
	callr	GetSDir
	callr	GetSAni
	callr	AniSkull
	movb	A0,*A13(ANIMTIKS)
	callr	JawBite
AnimX:

	callr	BaseDamp
	callr	SkulDamp
	callr	UpdSkulP
	callr	UpdJawP
	callr	UpdSkulV
	callr	UpdBaseP
	callr	UpdBaseV

	move	*A10(SKULL),A8,L
	move	*A8(OXVEL),A1,L
	abs	A1
	move	*A8(OYVEL),A0,L
	abs	A0
	add	A1,A0
	srl	7,A0
	addi	>00008000,A0,L
	callr	HedSpine

**** Find Next Event ****
	movk	2,A5			;TIME between updating neck

	movb	*A13(BRAINTIKS),A1
	jrp	SkBrain1
	movk	1,A1
SkBrain1:
	cmp	A5,A1
	jrge	SkMin1
	move	A1,A5
SkMin1:
	
	movb	*A13(ANIMTIKS),A2
	cmp	A5,A2
	jrge	SkMin2
	move	A2,A5
SkMin2:

GotMin:
	sub	A5,A1
	movb	A1,*A13(BRAINTIKS)
	sub	A5,A2
	movb	A2,*A13(ANIMTIKS)

	move	A5,A0
	callr	CkBFlash
	calla	PRCSLP
	clr	A0
	move	A0,@IRQSKYE,W

	jruc	SKEL_MV
**************************************************************************


**************************************************************************
SkulAttk:
	;*** Check length of neck to see if skull should extend or recoil
;**** GET TOP NECK PIECE AND BOTTOM NECK PIECE
	move	*A13(SPINE),A11,L  ;load up Xtra data obj with ptrs to parts
	move	A11,A14
	movb	*A13(SPINELEN),A7
	dec	A7
	sll	5,A7
	add	A7,A14
	move	*A11,A11,L		;A11 = first neck bone
	move	*A14,A14,L		;A14 = last neck bone

	move	*A10(SKULL),A5,L
	move	*A10(BASEL),A6,L
;**** GET LENGTH OF NECK IN X ****
	move	*A11(OXPOS),A1,W
	move	*A14(OXPOS),A2,W
	sub	A1,A2
	abs	A2
	cmpi	90,A2
	jrlt	AttckP

	;********  GO BACK TO BASE *******
	move	*A10(SKULL),A8,L
	calla	GETANIX
	move	A0,A2		;A2 - XPOS of Skull
	move	*A8(OZPOS),A4,W ;A4 - ZPOS of Skull
	move	*A8(OYPOS),A6,W ;A6 - YPOS of Skull
	addi	70,A6

	move	*A10(BASEL),A8,L
	calla	GETANIX
	move	A0,A3		;A3 - XPOS of Base
	move	*A8(OZPOS),A5,W ;A5 - ZPOS of Base
	move	*A8(OYPOS),A7,W ;A7 - YPOS of Base
	subi	110,A7
	
	move	*A10(SKULL),A8,L

	sub	A2,A3
	sll	16,A3
	movi	110,A0		;TIME FOR SKULL TO REACH BASE
	divs	A0,A3
	move	A3,*A8(OXVEL),L

	sub	A6,A7
	sll	16,A7
	movi	30,A0		;TIME FOR SKULL TO REACH BASE
	divs	A0,A7	;A7 YVEL

	sub	A4,A5
	sll	16,A5
	movi	35,A0		;TIME FOR SKULL TO REACH BASE
	divs	A0,A5
	move	A5,*A8(OZVEL),L
	add	A5,A7
	move	A7,*A8(OYVEL),L
	jruc	AttkX
	
AttckP:
	;************* ATTACK NEAREST PLAYER ***********
	move	*A10(SKULL),A8,L
	calla	ClosestP

	move	A0,A7
	calla	GETANIX
	move	A0,A2		;A2 - XPOS of Skull
	move	*A8(OZPOS),A4,W ;A4 - ZPOS of Skull
	move	*A8(OYPOS),A6,W ;A6 - YPOS of Skull
	addi	70,A6
	move	A7,A8
	calla	GETANIX
	move	A0,A3		;A3 - XPOS of player
	move	*A8(OZPOS),A5,W ;A5 - ZPOS of player
	move	*A8(OYPOS),A7,W ;A7 - YPOS of player
	
	movi	25,A14		;TIME FOR SKULL TO REACH PLAYER
	move	*A10(SKULL),A8,L

	movi	40,A0
	cmp	A3,A2
	jrgt	SkNgXOff
	neg	A0
SkNgXOff:
	add	A0,A2
	sub	A2,A3
	move	A3,A2
	abs	A2		;A2 = Xdelt
	cmpi	40,A2
	jrlt	SkAttkX
	sll	16,A3
	divs	A14,A3
	move	A3,A1
	movi	>70000,A0
	calla	ABSMAX
	move	A1,*A8(OXVEL),L
SkAttkX:

	sub	A6,A7
	move	A7,A6
	abs	A6		;A6 = Ydelt
	sll	16,A7
	divs	A14,A7	;A7 YVEL
	move	A7,A1
	movi	>40000,A0
	calla	ABSMAX
	move	A1,A7

	sub	A4,A5
	sll	16,A5
	divs	A14,A5
	move	A5,A1
	movi	>28000,A0
	calla	ABSMAX
	move	A1,*A8(OZVEL),L
	add	A1,A7
	move	A7,*A8(OYVEL),L

AttkX:
	rets
**************************************************************************

**************************************************************************
NeckCk:
;**** GET TOP NECK PIECE AND BOTTOM NECK PIECE
	move	*A13(SPINE),A11,L  ;load up Xtra data obj with ptrs to parts
	move	A11,A14
	movb	*A13(SPINELEN),A7
	dec	A7
	sll	5,A7
	add	A7,A14
	move	*A11,A11,L		;A11 = first neck bone
	move	*A14,A14,L		;A14 = last neck bone

	move	*A10(SKULL),A5,L
	move	*A10(BASEL),A6,L

;**** GET LENGTH OF NECK IN X ****
	move	*A11(OXPOS),A1,W
	move	*A14(OXPOS),A2,W
	sub	A2,A1
;**** ADJUST X VELOCITY FOR EXCESSIVE X LENGTH	
	move	A1,A2
	abs	A2
	movb	*A13(SPINELEN),A3
	cmpi	6,A3
	jrlt	SkXMPY
	movi	9,A4
	mpyu	A4,A3
SkXMPY:
	cmp	A3,A2
	jrlt	SkNkXAdj
	movi	>A000,A2
	move	A1,A1
	jrn	SkNgXAdj
	neg	A2
SkNgXAdj:
	move	*A5(OXVEL),A1,L
	add	A2,A1
	move	A1,*A5(OXVEL),L
	neg	A2
	move	*A6(OXVEL),A1,L
	add	A2,A1
	move	A1,*A6(OXVEL),L
SkNkXAdj:


;**** GET LENGTH OF NECK IN Y ****
	move	*A11(OYPOS),A1,W
	move	*A14(OYPOS),A2,W
	sub	A2,A1
;**** ADJUST Y VELOCITY FOR EXCESSIVE Y LENGTH	
	move	A1,A2
	abs	A2
	movb	*A13(SPINELEN),A3
	cmpi	6,A3
	jrlt	SkYMPY
	movi	5,A4
	mpyu	A4,A3
SkYMPY
	cmp	A3,A2
	jrlt	SkNkYAdj
	movi	>A000,A2
	move	A1,A1
	jrn	SkNgYAdj
	neg	A2
SkNgYAdj:
	move	*A5(OYVEL),A1,L
	add	A2,A1
	move	A1,*A5(OYVEL),L
SkNkYAdj:


;**** GET LENGTH OF NECK IN Z ****
	move	*A11(OZPOS),A1,W
	move	*A14(OZPOS),A2,W
	sub	A2,A1
;**** ADJUST Z VELOCITY FOR EXCESSIVE Z LENGTH	
	move	A1,A2
	abs	A2
	movb	*A13(SPINELEN),A3
	sll	1,A3
	cmp	A3,A2
	jrlt	SkNkZAdj
	movi	>A000,A2
	move	A1,A1
	jrn	SkNgZAdj
	neg	A2
SkNgZAdj:
	move	*A5(OZVEL),A1,L
	add	A2,A1
	move	A1,*A5(OZVEL),L
	move	*A5(OYVEL),A1,L
	add	A2,A1
	move	A1,*A5(OYVEL),L
	neg	A2
	move	*A6(OZVEL),A1,L
	add	A2,A1
	move	A1,*A6(OZVEL),L
	move	*A6(OYVEL),A1,L
	add	A2,A1
	move	A1,*A6(OYVEL),L
SkNkZAdj:

	rets
**************************************************************************


**************************************************************************
BaseDamp:
	move	*A10(BASEL),A6,L
	
	move	*A6(OXVEL),A1,L
	move	A1,A2
	sra	4,A2
	jrz	SkXDmp
	sub	A2,A1
	move	A1,*A6(OXVEL),L
SkXDmp:

	move	*A6(OZVEL),A1,L
	move	A1,A2
	sra	4,A2
	jrz	SkZDmp
	sub	A2,A1
	move	A1,*A6(OZVEL),L
	move	*A6(OYVEL),A1,L
	sub	A2,A1
	move	A1,*A6(OYVEL),L
SkZDmp:

	rets
**************************************************************************

**************************************************************************
SkulDamp:
	move	*A10(SKULL),A6,L
	
	move	*A6(OXVEL),A1,L
	move	A1,A2
	sra	7,A2
	jrz	SkXSDmp
	sub	A2,A1
	move	A1,*A6(OXVEL),L
SkXSDmp:

	move	*A10(JAW),A8,L
	jrnz	GotBotOb
	move	A6,A8
GotBotOb:
	calla	DFRMGRND
	jrp	DmpSY
	move	*A6(OYVEL),A1,L
	jrn	SkYSDmp
	neg	A1
	sra	2,A1
	move	A1,*A6(OYVEL),L
	jruc	SkYSDmp

DmpSY:
	move	*A6(OYVEL),A1,L
	move	A1,A2
	sra	6,A2
	jrz	SkYSDmp
	sub	A2,A1
	move	A1,*A6(OYVEL),L
SkYSDmp:

	move	*A6(OZVEL),A1,L
	move	A1,A2
	sra	6,A2
	jrz	SkZSDmp
	sub	A2,A1
	move	A1,*A6(OZVEL),L
	move	*A6(OYVEL),A1,L
	sub	A2,A1
	move	A1,*A6(OYVEL),L
SkZSDmp:

	rets
**************************************************************************

**************************************************************************
UpdJawP:
	move	*A10(SKULL),A0,L
	move	*A10(JAW),A1,L
	move	*A0(OZPOS),A2,W
	addk	5,A2
	move	A2,*A1(OZPOS),W
	rets
**************************************************************************

**************************************************************************
JawBite:
	movb	*A13(BITING),A0
	cmpi	SKULBITE,A0
	jrnz	UnBite
	move	*A9,A1,L
	cmpi	jawbite,A1
	jreq	IsBite
	cmpi	jawbitef,A1
	jrnz	UnBite
IsBite:

	movb	*A13(INBITE),A0
	jrnz	JawBiteX

	movi	BiteSND,A0
	calla	ONESND

	movi	ENEMIES,A1
	move	*A10(JAW),A0,L
	calla	DELSUPP
	movi	EXPLOSIONS,A1
	calla	ADDSUPP
	movi	BEOID|EXPLODID,A1
	move	A1,*A0(OID),W
	movk	1,A0
	movb	A0,*A13(INBITE)
	jruc	JawBiteX

UnBite:
	movb	*A13(INBITE),A0
	jrz	TryFTung

	movi	EXPLOSIONS,A1
	move	*A10(JAW),A0,L
	calla	DELSUPP
	movi	ENEMIES,A1
	calla	ADDSUPP
	movi	HEADEOID|4,A1	;jaw OID
	move	A1,*A0(OID),W
	clr	A0
	movb	A0,*A13(INBITE)

TryFTung:
	movb	*A13(TUNGDEAD),A0
	jrnz	JawBiteX

	movb	*A13(DIR),A14
	cmpi	3,A14
	jreq	TngOk
	cmpi	9,A14
	jreq	TngOk
	jruc	JawBiteX
TngOk:
	move	*A10(STNGANI),A0,L
	jrz	JawBiteX

	callr	FindSDir
	movb	*A13(DIR),A1
	cmp	A0,A1
	jrnz	JawBiteX
	move	A7,A0		;A7 set by FindDir
	calla	GetPData
	move	A0,A11		;A11 ptr to player data block

	movk	3,A6
TungMrv:
	movi	300,A0
	calla	RANDPER
	jrnc	JawBiteX

	;**** FIRE OFF A TONGUE
	mmtm	SP,A10
	move	*A10(STNG),A8,L
	movk	1,A10		;using a reverse tung
	CREATE	TNGPID,FIRETUNG
	mmfm	SP,A10
	dsj	A6,TungMrv

JawBiteX:
	rets
**************************************************************************


**************************************************************************
AniSkull:
	move	*A9+,A0,L
	jrnz	GotSAnim
	clr	A0
	movb	A0,*A13(COLSRVC)
	movb	A0,*A13(BITING)
	callr	GetSAni
	move	*A13(ANIMPTR),A9,L
	jruc	AniSkull
GotSAnim:
	callr	StfSAnis

;* ANIMATE ALL SKULL PIECES
	movi	SKULL,A11
	add	A10,A11
	movi	SKLANIS,A7
	add	A10,A7
	movb	*A10(ONLIST),A6
	clr	A5	;new ONLIST
	sll	24,A6
	movb	*A10(INUSE),A0
	move	A0,B1
	sll	24,B1
	movb	*A10(SKLPARTS),A0
	move	A0,B0
DoSAnis:
	sll	1,A5
	move	*A11+,A8,L
	move	*A7+,A1,L
	jrz	NoSAni
	sll	1,B1
	jrnc	NotActve

	inc	A5	;set Bit for new ONLIST
	move	*A8(OFLAGS),A4,W
* ANI: A1=IMAGE PTR, A4=FLAGS, A8=OBJECT STRUCTURE POINTER TO BE UPDATED				 *
	calla	ANI
	;*** MAKE SURE PART IS ON LIST
	sll	1,A6	;was part on list
	jrc	NxtSAni
	move	A8,A0
	calla	INSOBJ
	movi	ENEMIES,A1
	calla	ADDSUPP
	jruc	NxtSAni

NoSAni:
	sll	1,B1
NotActve:
	sll	1,A6	;was part on list
	jrnc	NxtSAni
	move	A8,A0
	calla	PULLOBJ
	movi	ENEMIES,A1
	calla	DELSUPP
NxtSAni:
	dsj	B0,DoSAnis

	movk	8,A0
	movb	*A10(SKLPARTS),A1
	sub	A1,A0
	sll	A0,A5
	movb	A5,*A10(ONLIST)
	move	*A10,A8,L	;leave ptr to first part in A8
	move	*A9+,A0,W	;load sleep time
	rets
**************************************************************************

**************************************************************************
StfSAnis:
;* Stuff ANIMATION for each piece
;* Stuff Zpos for each piece, based on first piece
;A0 ptr to table of animations
	movi	SKLANIS,A7
	add	A10,A7
	movb	*A10(SKLPARTS),A3
	move	A3,B0
StfSAni:
	move	*A0+,*A7+,L
	dsjs	B0,StfSAni

	addk	8,A0	;skip first Z offset
	movi	SKULL,A11
	add	A10,A11
	move	*A11+,A1,L
	move	*A1(OZPOS),A2,W
	movb	*A10(SKLPARTS),A3
	move	A3,B0
	dec	B0	     	;update the rest of the parts
	jrz	SkZs
StufSZ:
	move	*A11+,A1,L
	movb	*A0,A3
	addk	8,A0
	add	A2,A3
	move	A3,*A1(OZPOS),W
	dsjs	B0,StufSZ
SkZs:
	movb	*A0,A0
	movb	*A13(FLIPPED),A1
	jrz	SkSFlpSet
SkSFlpSet:
	callr	UpdFlips
	rets
**************************************************************************


**************************************************************************
FindSDir:
;* RETURNS
;   A0 - direction to face toward nearest player
;   A7 - ptr to player object
	calla	ClosestP
	move	A0,A8
	calla	GETANIX
	move	A8,A7
	move	A0,A1

	move	*A10(SKULL),A8,L
	calla	GETANIX
	sub	A0,A1		;A1 = X dist from skull to player

	move	*A7(OZPOS),A2,W
	move	*A8(OZPOS),A0,W
	sub	A0,A2		;A2 = Z dist from head to player

	move	A2,A3
	move	A1,A4
	jrz	SZEROX
	abs	A3
	abs	A4
	sll	16,A3
	divu	A4,A3
SGtZdivX:

	move	A1,A1
	jrn	SLftDir
;* facing right, 0<=dir<=4
	move	A2,A2
	jrn	SRgtUDir
;**facing right and down
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	SDir3
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	SDir2
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	SDir1
	jruc	SDir0
SRgtUDir:
;**facing right and up
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	SDir3
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	SDir4
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	SDir5
	jruc	SDir6

SLftDir:
;* facing left, 5<=dir<=9
	move	A2,A2
	jrn	SLftUDir
;**facing left and down
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	SDir9
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	SDir10
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	SDir11
	jruc	SDir0

SLftUDir:
;**facing left and up
	cmpi	>93cd,A3	;ANG < 30 deg		
	jrlt	SDir9
	cmpi	>10000,A3	;ANG < 45 deg		
	jrlt	SDir8
	cmpi	>224FE,A3	;ANG < 65 deg		
	jrlt	SDir7
	jruc	SDir6

SDir0:	clr	A0
	jruc	SetSDir
SDir1:	movk	1,A0
	jruc	SetSDir
SDir2:	movk	2,A0
	jruc	SetSDir
SDir3:	movk	3,A0
	jruc	SetSDir
SDir4:	movk	4,A0
	jruc	SetSDir
SDir5:	movk	5,A0
	jruc	SetSDir
SDir6:	movk	6,A0
	jruc	SetSDir
SDir7:	movk	7,A0
	jruc	SetSDir
SDir8:	movk	8,A0
	jruc	SetSDir
SDir9:	movk	9,A0
	jruc	SetSDir
SDir10:	movk	10,A0
	jruc	SetSDir
SDir11:	movk	11,A0
;	jruc	SetSDir

SetSDir:
	rets
SZEROX:
	movi	>7FFFFFFF,A3
	jruc	SGtZdivX
**************************************************************************


**************************************************************************
GetSDir:
	movb	*A13(INBITE),A0
	jrnz	GetSDirX

	callr	FindSDir

	movb	*A13(DIR),A4
	cmp	A0,A4
	jrlt	IncSDir
	jrgt	DecSDir
	jruc	GotSDir
IncSDir:
	sub	A4,A0
	cmpi	6,A0
	jrgt	IncMSDir
	inc	A4
	jruc	GotSDir
IncMSDir:
	dec	A4
	jrnn	GotSDir
	movk	11,A4
	jruc	GotSDir

DecSDir:
	sub	A4,A0
	neg	A0
	cmpi	6,A0
	jrgt	DecMSDir
	dec	A4
	jruc	GotSDir
DecMSDir:
	inc	A4
	cmpi	11,A4
	jrle	GotSDir
	clr	A4
;	jruc	GotSDir

GotSDir:
	movb	A4,*A13(DIR)
GetSDirX:
	rets
**************************************************************************

**************************************************************************
GetSAni:	    	
	movb	*A13(INBITE),A0
	jrnz	SameSAni

	movb	*A13(DIR),A0
	cmpi	3,A0
	jreq	CkTilt
	cmpi	9,A0
	jrnz	GotOffst
;************** SKULL IS FACING LEFT OR RIGHT ******************
CkTilt:
	move	*A10(SKULL),A1,L
	move	*A1(OYVEL),A2,L
	move	*A1(OZVEL),A3,L
	sub	A3,A2
	cmpi	->32000,A2	
	jrlt	TILTUP
	cmpi	>28000,A2	
	jrgt	TILTDN

	callr	TRYBITE
	movb	*A13(BITING),A2
	add	A2,A0
SkBite:
GotOffst:
	sll	5,A0
	addi	SDIRANI,A0
	move	*A0,A0,L

	move	*A13(ANIMPTR),A1,L
	cmp	A0,A1
	jreq	SameSAni
	move	A0,*A13(ANIMPTR),L
	move	A0,A9
SameSAni:
	rets

TILTUP:
	addk	9,A0
	jruc	GotOffst
TILTDN:
	addk	10,A0
	jruc	GotOffst
**************************************************************************

**************************************************************************
TRYBITE:
	mmtm	SP,A0,A2,A3,A7,A8
	movb	*A13(BITING),A0
	jrnz	TRYBITEX

	move	*A10(SKULL),A8,L
	calla	ClosestP
	move	A0,A7
	calla	GETANIX
	move	A0,A2		;A2 - XPOS of Skull
	movi	50,A3
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	SkNgJAdj
	neg	A3
SkNgJAdj:
	add	A3,A2
	move	A7,A8
	calla	GETANIX
	move	A0,A3		;A3 - XPOS of player

	sub	A2,A3
	abs	A3
	sll	3,A3
	movi	1000,A0
	sub	A3,A0
	jrn	NoBite
	calla	RANDPER
	jrnc	NoBite

	movk	SKULBITE,A0
	movb	A0,*A13(BITING)
NoBite:
	movb	*A13(TUNGDEAD),A0
	jrnz	TRYBITEX

	;*** TRY FIRING A TUNG INSTEAD...
	movi	500,A0
	calla	RANDPER
	jrnc	TRYBITEX
	movk	SKULTUNG,A0
	movb	A0,*A13(BITING)
	
TRYBITEX:
	mmfm	SP,A0,A2,A3,A7,A8
	rets
**************************************************************************
	
**************************************************************************
HDSPIN:
;* First Byte is spine bone to blow (0=none), second byte is tiks
	.BYTE	5	;first addk skips this
	.BYTE	0,5, 0,4, 1,3, 0,3, 0,3, 0,2, 0,2, 3,2, 0,2
	.BYTE	0,1, 0,1, 1,1, 2,1, 0,1, 0,1, 0,0
	.EVEN
**************************************************************************

**************************************************************************
SklExplo:
;* PROCESS TO BLOW UP THE HEAD...

	;* restuff coll vects for base
	movi	SBSECOLL,A1
	move	*A10(STUMP),A0,L
	move	A1,*A0(OCVECT),L
	move	*A10(BASEL),A0,L
	move	A1,*A0(OCVECT),L
	move	*A10(BASER),A0,L
	move	A1,*A0(OCVECT),L

	movk	1,A0
	movb	A0,*A13(TUNGDEAD)

	movb	A0,*A13(BITING)
	callr	JawBite		;get jaw off of explosion list

	movi	40,A1
IncPitch:
	movi	PitchSND,A0
	calla	ONESND
	dsjs	A1,IncPitch

;********* SPIN HEAD AROUND A BIT ************
	movi	SpinStSND,A0
	calla	ONESND

	SLEEP	2

	movi	SpinSND,A0
	calla	ONESND

	movi	HDSPIN,A0	;table of head spin speeds
	PUSHP	A0
SpinLp:
	move	*A10,A8,L
	callr	ZCHECK
	callr	XBOUNDS
	callr	NeckCk

	movb	*A13(ANIMTIKS),A0
	jrnz	ANIMX

	movb	*A13(DIR),A0
	inc	A0
	cmpi	12,A0
	jrlt	DOK
	PULLP	A0
	addk	8,A0
	movb	*A0,A1		;spine bone to blow
	jrz	SkBlowSp
	dec	A1
	sll	5,A1
	move	*A13(SPINE),A2,L
	add	A1,A2
	move	*A2,A8,L
	calla	SpineHit
SkBlowSp:
	addk	8,A0
	movb	*A0,A1
	jrz	SpinX
	PUSHP	A0
	clr	A0
DOK:
	movb	A0,*A13(DIR)

	callr	GetSAni
	callr	AniSkull

	movi	PitchSND,A0
	calla	ONESND
	movi	PitchSND,A0
	calla	ONESND
	PULLP	A1
	movb	*A1,A0
	PUSHP	A1
	movb	A0,*A13(ANIMTIKS)
ANIMX:

	sll	7,A0
	callr	BmpSklV

	callr	BaseCent
	callr	BaseDamp
	callr	SkulDamp
	callr	UpdSkulP
	callr	UpdJawP
	callr	UpdSkulV
	callr	UpdBaseP
	callr	UpdBaseV
	movi	>00008800,A0,L
	callr	HedSpine

	movb	*A13(ANIMTIKS),A0
	subk	1,A0
	jrp	SkClrAnT
	clr	A0
SkClrAnT:
	movb	A0,*A13(ANIMTIKS)

	;* MAKE SOME RANDOM EXPLOSIONS
	movi	170,A0
	calla	RANDPER
	jrnc	SkNukes
	move	A10,A8
	mmtm	SP,A10,A11
	movb	@RAND,A0
	jrn	SkSkull
	addi	SKULL,A8
	movi	50,A0
	calla	SRAND
	move	A0,A10
	movi	40,A0
	calla	SRAND
	subi	15,A0
	move	A0,A11

	mmtm	SP,A8
	movi	CHNKTBL4,A1
	movi	BONEINI,A2
	movi	BONESINK,A4
	movi	>0,A6	 ;Y:X OFFSET of where to start chunks from object
	move	*A8,A8,L
	callr	DOCHUNKS
	mmfm	SP,A8

	jruc	GotNkCrs
SkSkull:
	movi	60,A0
	calla	SRAND
	move	A0,A10
	movi	40,A0
	calla	SRAND
	addi	80,A0
	move	A0,A11
GotNkCrs:
	move	*A8,A8,L
	CREATE	NUKEPID,MkNuke
	mmfm	SP,A10,A11
SkNukes:

	movk	1,A0
	callr	CkBFlash
	calla	PRCSLP
	clr	A0
	move	A0,@IRQSKYE,W

	jruc	SpinLp

SpinX:
	movi	PClrSND,A0
	calla	ONESND
	movi	SkExpSND,A0
	calla	ONESND

	move	*A10(SKULL),A8,L
	calla	ClrVel
	callr	UpdSkulV

	move	*A10,A8,L
	calla	ClrVel
	callr	UpdBaseV

	callr	FlySpine

;****** CREATE LOTS OF FRAGMENTS TO BLOW FROM HEAD ********
	movi	CHNKTBL3,A1
	movi	BONEINI,A2
	movi	BONESINK,A4
	movi	>0,A6	 ;Y:X OFFSET of where to start chunks from object
	move	*A10(SKULL),A8,L
	callr	DOCHUNKS

	movk	9,A0
	calla	PRCSLP

	callr	FlySkull
	
	movk	7,A0
	calla	PRCSLP

	;**** kill eye color cycler
	NOMATCHP	SKLCCPID,>FFFF,NoSkulCC
	calla	KILL
NoSkulCC:

	movi	CHNKTBL2,A1
	movi	CHNKTINI,A2
	movi	CHNKSINK,A4
	movi	>0,A6	 ;Y:X OFFSET of where to start chunks from object
	move	*A10(SKULL),A8,L
	callr	DOCHUNKS

	movk	10,A0
	calla	PRCSLP

	movi	CHNKTBL3,A1
	movi	BONEINI,A2
	movi	BONESINK,A4
	movi	>0,A6	 ;Y:X OFFSET of where to start chunks from object
	move	*A10(SKULL),A8,L
	callr	DOCHUNKS

	movi	HdExpSND,A0
	calla	ONESND

	;* JUST THE BASE IS LEFT
	;* set color cycler to black
	NOMATCHP	BASCCPID,>FFFF,NoBCC
	movk	8,A1
	movb	A1,*A0(COLORLVL)
NoBCC:

BaseLp:
	move	@GOTCARD,A0,W
	jrz	SkDrop
	move	*A10,A8,L
	movi	GOLD,A9
	CREATE	0EAH,DROPCARD
	jrz	SkDrop
	clr	A0
	move	A0,@GOTCARD,W
SkDrop:

	callr	XBOUNDS
	callr	BaseDamp
	callr	BaseDamp
	callr	BaseDamp
	callr	UpdBaseP
	callr	UpdBaseV

	movk	3,A0
	callr	CkBFlash
	calla	PRCSLP
	clr	A0
	move	A0,@IRQSKYE,W

	jruc	BaseLp

	DIE
**************************************************************************

**************************************************************************
;**** BONESINK IS ENTRY POINT...
NxtBFrm:
	move	*A9+,A0,W
	move	A0,A1
	andi	FLIPBITS,A0
	jrz	SkAFLP
	move	*A9+,A0,W
SkAFLP:
	andi	NEWPALET,A1
	jrz	BONESINK
	move	*A9+,A0,L
BONESINK:
	move	*A9+,A0,L
	jrnz	NxtBFrm

	move	*A9+,A0,L
	move	*A9+,A0,W
	andi	FLIPBITS,A0
	jrz	SkBFlps
	move	*A9+,A0,W
SkBFlps:

	movi	Bone1SND,A0
	movb	@RAND,A1
	jrn	GotSnd
	movi	Bone2SND,A0
	move	@RAND,A1,W
	jrn	GotSnd
	movi	Bone3SND,A0
GotSnd:
	calla	ONESND

	MOVK	4,A1
	JSRP	FRANIM

	sleep	20
	movi	[1,1],A9
	jsrp	OSINK
	move	A8,A0
	calla	DELPAL
	calla	DELSOBJ
	move	@FRAGCNT,A0,W
	dec	A0
	move	A0,@FRAGCNT,W
	DIE
**************************************************************************

**************************************************************************
GRNDSKUL:
;	jruc	NoBnce
;
;	movi	->30000,A0
;	move	A0,*A8(OYVEL),L
;
;BnceCk:
;	movi	Bone3SND,A0
;	calla	ONESND
;
;	move	*A8(OYVEL),A0,L
;	sra	1,A0
;	cmpi	>5000,A0
;	jrlt	NoBnce
;	neg	A0
;	move	A0,*A8(OYVEL),L
;
;BnceLp:
;	SLEEP	1
;	move	*A8(OYVEL),A0,L
;	addi	>3000,A0
;	move	A0,*A8(OYVEL),L
;	jrn	BnceLp
;	calla	DFRMGRND
;	cmpi	5,A1
;	jrlt	BnceCk
;	jruc	BnceLp
;NoBnce:
;
	clr	A0
	move	A0,*A8(OPLINK),L
	move	A8,A0
	movi	BACKSLST,A1
	calla	ADDSUPP
	movi	BGDMPID,A0
	move	A0,*A8(OID),W
	movk	1,A1
	move	A8,A0
	calla	ADDBB
	movi	DUMPCOLL,A0
	move	A0,*A8(OCVECT),L
	movi	>00010012,A0
	move	A0,*A8(OZSIZ),L

CarcLp:
	movi	250,A0
	calla	RANDU
	addi	15,A0
	calla	PRCSLP

;BUGCOLD; A5  - Y:X; A6  - 0:Z;
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
* GETANIXY - A8=OBJ -> A2=ANIPT OYVAL, A3=ANIPT OXVAL
	calla	GETANIXY
	srl	16,A3
	movx	A3,A5
	subi	>80000,A2
	movy	A2,A5
	move	*A8(OZPOS),A6,W
	subk	5,A6
	movi	>00100000|BUGEOID|1,A14
	calla	BUGCOLD

	jruc	CarcLp

	sleep	20
	movi	[1,1],A9
	jsrp	OSINK
	move	A8,A0
	calla	DELPAL
	calla	DELSOBJ
	DIE
**************************************************************************

**************************************************************************
FlySpine:
	movi	FLYSPINE,A9
	movi	BONESINK,A4
	move	*A13(SPINE),A11,L
	movb	*A13(SPINELEN),A6
	jrz	FSpineX
	clr	A0
	movb	A0,*A13(SPINELEN)
BlowemS:
	move	*A11+,A8,L

*       TRAJEC1 - JUST DOES THE TRAJECTORY WITH AN EXISTING OBJECT       *
* A8 = RESERVED FOR OBJECT BLOCK POINTER				 *
* A9 = INITIAL ANIMATION LIST						 *
* PDATA+A0H  = PROCESS TO CREATE UPON DEATH (32 BITS)			 *
	CREATE	CHUNKPID,NTRAJEC1
	jrz	NoFlySpn
	move	A0,A7
	move	@FRAGCNT,A0,W
	inc	A0
	move	A0,@FRAGCNT,W

	move	A8,A0
	movi	ENEMIES,A1
	calla	DELSUPP

	movi	>50000,A0	;XVEL
	calla	SRAND
	move	A0,*A8(OXVEL),L
	movi	>50000,A0	;YVEL
	calla	RANDU
	neg	A0
	subi	>40000,A0
	move	A0,*A8(OYVEL),L
	movi	>18000,A0	;ZVEL
	calla	SRAND
	move	A0,*A8(OZVEL),L

	move	A4,*A7(PDATA+>A0),L	;GRND PROC
	dsj	A6,BlowemS
	jruc	FSpineX
	
DelSpn:
	move	*A11+,A8,L
NoFlySpn:
	move	A8,A0
	calla	DELENEMY	;DELETE THE SPINE BONE
	dsjs	A6,DelSpn

FSpineX:
	rets
**************************************************************************


**************************************************************************
FlySkull:
	movk	1,A0
	movb	A0,*A13(TUNGDEAD)
	movk	4,A0
	movb	A0,*A10(SKLPARTS)
	movi	BlowSkul,A9
	callr	AniSkull
	callr	UpdSkulP
	clr	A0
	movb	A0,*A13(BITING)
	callr	JawBite		;get jaw off of explosion list

	movi	GrndTbl,A4
	movi	AnimTbl,A5
	move	A10,A11
	addi	SKULL,A11
	movb	*A10(SKLPARTS),A6
BlowSkLp:
	move	*A5+,A9,L
	move	*A11+,A8,L

*       TRAJEC1 - JUST DOES THE TRAJECTORY WITH AN EXISTING OBJECT       *
* A8 = RESERVED FOR OBJECT BLOCK POINTER				 *
* A9 = INITIAL ANIMATION LIST						 *
* PDATA+A0H  = PROCESS TO CREATE UPON DEATH (32 BITS)			 *
	CREATE	CHUNKPID,NTRAJEC1
	jrz	NoFlySkl
	move	*A4+,A1,L
	move	A1,*A0(PDATA+>A0),L	;GRND PROC
	move	@FRAGCNT,A0,W
	inc	A0
	move	A0,@FRAGCNT,W

	movi	ENEMIES,A1
	move	A8,A0
	calla	DELSUPP

	movi	>10000,A0	;XVEL
	calla	SRAND
	move	A0,*A8(OXVEL),L
	movi	>30000,A0	;YVEL
	calla	RANDU
	neg	A0
	subi	>50000,A0
	move	A0,*A8(OYVEL),L
	movi	->10000,A0	;ZVEL
	move	A0,*A8(OZVEL),L

	dsj	A6,BlowSkLp
	jruc	FlySklX
	
DelSkl:
	move	*A11+,A8,L
NoFlySkl:
	move	A8,A0
	calla	DELENEMY	;DELETE THE SKULL PIECE
	dsjs	A6,DelSkl

FlySklX:
	rets

GrndTbl:
	.long	GRNDSKUL,BONESINK,BONESINK,BONESINK
AnimTbl:
	.long	FLYSKULL,FLYSPINE,FLYSPINE,FLYSPINE
**************************************************************************


**************************************************************************
BmpSklV:
;* PASS A0, % chance of bumping Y vel
	addi	30,A0
	move	*A10(SKULL),A8,L
	calla	RANDPER
	jrnc	SkBmpY
	movi	>10000,A0
	calla	RANDU
	move	*A8(OYVEL),A1,L
	sub	A0,A1
	move	A1,*A8(OYVEL),L
SkBmpY:
	movi	>18000,A0
	calla	SRAND
	move	*A8(OXVEL),A1,L
	add	A0,A1
	move	A1,*A8(OXVEL),L
	rets
**************************************************************************

**************************************************************************
BaseCent:
	move	*A10,A8,L
	move	*A8(OXPOS),A0,W
	move	@(WORLDTLX+16),A1,W				 
	addi	256,A1

	sub	A0,A1
	sla	8,A1

;	movi	>6000,A2
;	cmp	A0,A1
;	jrgt	SkNgBXV
;	neg	A2
;SkNgBXV:
	move	*A8(OXVEL),A0,L
	add	A1,A0
	move	A0,*A8(OXVEL),L

	move	*A8(OYVEL),A0,L
	addi	>400,A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A0,L
	addi	>400,A0
	move	A0,*A8(OZVEL),L
	rets
**************************************************************************


TRAJINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	jaw4,0,DUMCOLL
	.WORD	DMAWNZ,0
    	.LONG	0
**************************************************************************
* TRAJECTORY PROCESS, CREATES AN OBJECT SENDING IT ALONG THE TRAJECTORY	 *
* DETERMINED BY THE GIVEN INITIAL X AND Y VELOCITIES. TWO ANIMATION LIST *
* POINTERS MUST BE PASSED, ONE FOR THE FLYING ANIMATION AND ONE FOR THE	 *
* ANIMATION WHEN IT HITS THE GROUND.					 *
* WHEN THE FIRST LIST IS ANIMATED, THE FIRST TIME THROUGH SLEEP = 1,     *
* THE 2nd, SLEEP = 2 ... THIS IS FOR SPINNING ANIMATIONS.		 *
* ENTRYPOINTS								 *
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
NTRAJEC
	MOVE	A10,A14			;GET INIT TAB
	JRNE	TRAJECS			;BR = NON-EXISTANT
	MOVI	TRAJINIT,A14
TRAJECS
	CALLA	GPALOBJ			;TRY FOR A PALETTE
	JAZ	DUMDIE			;BR = NO PLACE FOR THIS FRAGMENT
	CALLA	STFOBJ

	MOVE	A13,A14
	ADDI	PDATA,A14
	MMFM	A14,A3,A4,A5,A6		;LOAD X&Y VELOCITIES,ZPOS,FLAGS

	MOVE	A5,*A0(OXVEL),L
	MOVE	A4,*A0(OYVEL),L
	MOVE	A3,*A0(OZVEL),L		;STUFF X,Y & Z VELOCITIES

	MOVE	A6,*A0(OZPOS),W
	MOVE	A6,A4
	SRL	16,A4			;FLAGS FOR GANISAG
	
	CLR	A2
	MOVY	A11,A2
	MOVX	A11,A3
	SLL	16,A3			;INITIAL X & Y APOINT POSITIONS

	MOVE	*A9(0),*A0(OIMG),L
	CALLA	GANISAG			;SETUP EVERYTHING
									 
	MOVE	A13,*A0(OPLINK),L	;PROCESS LINK			 
									 
	CALLA	INSOBJ							 
	MOVE	A0,A8
	CALLA	SHADST			;GIVE US A SHADOW PREEEZE

*SECOND ENTRY, NOTE: INITIAL VELOCITIES MUST BE IN PLACE AT THIS POINT
NTRAJEC1
	MOVE	A9,*A13(PDATA+0C0H),L	;KEEP FOR MULTIPLE ANIMATIONS
	MOVK	2,A11
	clr	A10
TrajLp:
	callr	XCHECK
	jrc	TrajX
	move	A10,A0
	jrp	SkAnim
	MOVK	4,A1
	JSRP	FRANIM
	move	*A9,A0,L
	jrnz	ListLft
	MOVE	*A13(PDATA+0C0H),A9,L	;POINT TO THE HEAD OF THE LIST
	INC	A11			;INCREMENT SLEEP TIME
ListLft:
	move	A11,A10
	move	A10,A0
SkAnim:
	cmpi	3,A0
	jrle	GotSlpT
	movk	3,A0
GotSlpT:
	sub	A0,A10
	PUSHP	A0		;push sleep count
	calla	PRCSLP

	calla 	ZCHEK

	MOVE	*A8(OYVEL),A5,L		;GET THE CURRENT Y VELOCITY
	jrn	GoingUp
	calla	DFRMGRND		;DID HE HIT THE GROUND?
	cmpi	6,A1
	jrle	HitGrnd
GoingUp:
	PULLP	A7		;pull sleep count
AddGrav:
	ADDI	>1A00,A5
	dsjs	A7,AddGrav
	MOVE	A5,*A8(OYVEL),L
	JRUC	TrajLp

HitGrnd:
	CALLA	ClrVel
	CALLA	GETANIXY		;GET THE ANIMATION POINT
	MOVE	*A8(OFLAGS),A4,W					 
	ANDNI	M_FLIPV,A4		;NO UPSIDE-DOWNERS ALLOWED	 
	MOVE	A8,A0
	CALLA	GANISAG		;SHOW THE NEW ADJUSTMENTS
	CALLA	SETZPOS		;RESET THE Z POSITION		 
	CALLA	DELSHAD		;DELETE THE SHADOW
	CALLA 	ZCHEK		;MAKE SURE IT IS IN BOUNDS

;	MOVE	*A13(PDATA+80H),A9,L	;GET THE SECOND ANIMATION LIST
;	JRZ	SkAni2			;NON-EXISTANT

;	MOVK	1,A1
;	JSRP	FRANIM			;ANIMATE FROM TOP TO BOTTOM

SkAni2:
	MOVE	*A13(PDATA+0A0H),A7,L	;PROCESS TO CREATE TO HANDLE DELETION
	JRZ	NoDthPrc
	JUMP	A7			;SO JUMP THERE			

TrajX:
NoDthPrc:
	move	@FRAGCNT,A0,W
	dec	A0
	move	A0,@FRAGCNT,W

	MOVE	A8,A0 			;DEFAULT SIMPLE DELETE
	CALLA	DELPAL
	CALLA	DELSOBJ
	DIE
**************************************************************************

**************************************************************************
XCHECK:
	move	*A8(OXPOS),A0,W
	move	@WORLDTL,A1,W
	sub	A1,A0			;SUBTRACT OUT WORLD BASE

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	addk	15,A2	;a little buffer
	cmp	A2,A0			;IS IT PAST THE RT?
	jrgt	OffRite

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	subk	15,A2	;a little buffer
	move	*A8(OSIZE),A1,W
	add	A0,A1			;RIGHT EDGE OF OBJECT
	cmp	A2,A1
	jrlt	OffLeft
	clrc
	rets
OffRite:
OffLeft:
	setc
	rets
**************************************************************************

**************************************************************************
AGITATE:
	move	*A10,A8,L
	movi	20,A0
	calla	SRAND
	movk	10,A1
	calla	ABSADD
	move	*A8(OXPOS),A1,W
	add	A0,A1
	move	A1,*A8(OXPOS),W
	movi	5,A0
	calla	SRAND
	movk	5,A1
	calla	ABSADD
	move	*A8(OZPOS),A1,W
	add	A0,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OYPOS),A1,W
	add	A0,A1
	move	A1,*A8(OYPOS),W
	rets
**************************************************************************

