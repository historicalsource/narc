	.FILE	'NARCDYNA.ASM'
	.TITLE	" <<< N  A  R  C  -- DYNAMITE >>>"
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
	.INCLUDE	"NARCTEQU.ASM"		;TODD JIZZ
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates

	.EVEN
	.TEXT

;* stick this stuff into narcequ someday..
DYNAZSIZ	EQU	[12,12] 
DYNABOID	EQU	>0BE0|DYNAID

;* OFFSETS into process block.
rot		.set	ESWTCH
fanimct	.set	ESWTCH+8
fuselen	.set	ESWTCH+16
rotdir	.set	ESWTCH+24

rottiks	.set	ETEMP1
expltiks	.set	ETEMP1		;* not needed until bomb is exploding
fusetiks	.set	ETEMP1+16
OnGrnd	.set ETEMP1+24

ROTTIKS	.set	ETEMP2

;* CONSTANTS



**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
StckInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	dstk90,DYNAZSIZ,StckColl
	.WORD	DMAWNZ,DYNABOID
	.LONG	0
FuseInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	spk90a,DYNAZSIZ,DUMCOLL
	.WORD	DMAWNZ,DYNABOID
	.LONG	0
**************************************************************************


**************************************************************************
StckColl:
	.WORD	BEOID|EXPLODID
	.LONG	bullcol
	.WORD	B1OID|BULLETID
	.LONG	bullcol
	.WORD	B1OID|EXPLODID
	.LONG	bullcol
	.WORD	B1OID|ROCKETID
	.LONG	bullcol
	.WORD	B2OID|BULLETID
	.LONG	bullcol
	.WORD	B2OID|EXPLODID
	.LONG	bullcol
	.WORD	B2OID|ROCKETID
	.LONG	bullcol
	.WORD	0
	.LONG	DUMRTSG

**************************************************************************

**************************************************************************
bullcol:
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER

	MOVI	DUMCOLL,A14
	MOVE	A14,*A0(OCVECT),L	;COLLISION POINTER

	MOVE	*A0(OPLINK),A0,L
	calla	GETA10
	CALLA	KILL			;KILL CONTROL
	
	MOVI	0EDh,A1
	MOVI	ExpDyna,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS

	movi	1,A0	;stop coll scan
	CLRC		;Don't delete in Coll routine
	RETS
*************************************************************************


**************************** DYNAMITE PROCESS ****************************
dynamite:
;* PARMS
;	ETEMP1 - Xvel
;	ETEMP2 - Yvel
;	ETEMP3 - Zvel
;	ETEMP4 - Ypos:Xpos
;	rotdir - rotation direction
;	fuselen - Fuse Length  (-7:7)

	move	A8,A7
	calla	GETOBJ
	jrz	NoStck
	movi		StckInit,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	calla	INSOBJ
	move	A0,A8

	calla	GETOBJ
	jrz	NoFuse
	movi		FuseInit,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L
	calla	INSOBJ
	move	A0,A10

	;* allocate palette
	MOVI	NARCS,A0
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	jrz	NoPal
	MOVE	A0,*A8(OPAL),W
	MOVE	A0,*A10(OPAL),W

	jruc	GoDyna

NoPal:
	;* must free the fuse obj
	move	A10,A0
	calla	DELOBJ
NoFuse:
	;* must free the stick obj
	move	A8,A0
	calla	DELOBJ
NoStck:
	DIE

GoDyna:	  				;* Yay, we got all the stuff..
	MOVE	*A7(OZPOS),*A8(OZPOS),W		
	move	*A13(ETEMP1),*A8(OXVEL),L
	move	*A13(ETEMP2),*A8(OYVEL),L
	move	*A13(ETEMP3),*A8(OZVEL),L

	MMTM	SP,A1,A2,A4
	MOVE	*A8(OIMG),A1,L
	MOVE	*A8(OSIZE),A2,L
	MOVE	*A8(OFLAGS),A4,W
	CALLA	GANIOF
	MMFM	SP,A1,A2,A4
	
	sra	16,A6	;*A6=X ANIMATION OFFSET X 64K
	srl	16,A7	;*A7=Y ANIMATION OFFSET X 64K
	sll	16,A7
	move	*A13(ETEMP4),A1,L
	add	A6,A1
	add	A7,A1
	move	A1,*A8(OXPOS),W
	sra	16,A1
	move	A1,*A8(OYPOS),W

	movi	ENEMY_BULLETS,A1
	move	A8,A0
	calla	ADDSUPP			;ADD TO SUPPLEMENTAL List
	calla	SHADST
	SWAP	A8,A10
	calla	SHADST
	SWAP	A8,A10

	;initialize a dynamite stick
	clr	A0
	movb	A0,*A13(rot)
	movb	A0,*A13(OnGrnd)
	movk	3,A0
	movb	A0,*A13(fanimct)

	movi	FUSETIKS,A0
	movb	A0,*A13(fusetiks)
	movk	3,A0
	movb	A0,*A13(ROTTIKS)
	movk	1,A0
	movb	A0,*A13(rottiks)


;* Main Loop For Dyanmite
DynaLp:	

;***** Process Trajectory for dynamite stick *****
	movb	*A13(OnGrnd),A0
	jrnz	Grounded	

	move	*A8(OZPOS),A0,W
	move	@PLZMIN,A1,W
	cmp	A1,A0
	jrgt FlyZOk
	move	*A8(OZVEL),A0,L
	jrp	FlyZOk
	sra	1,A0
	neg	A0
	move	A0,*A8(OZVEL),L
	move	*A8(OYVEL),A0,L
	sra	2,A0
	move	A0,*A8(OYVEL),L
FlyZOk:

BVEL_ADJ:
	CALLA	DFRMGRND	;A1
	calla	BnceHght	;A0
	cmp	A0,A1
	jrgt	BFLYING
	move	*A8(OYVEL+16),A0,W	;* if bomb is going up don't bounce
	jrn	BFLYING
	calla	SCRTST			;OFFSCREEN?
	jrnz	BOMBSCRX
	;* make the bomb bounce ?
	move	*A8(OXVEL),A0,L
	jrnz	BOMBBNCE
	;* the bomb has come to a halt
	movk	1,A0
	movb	A0,*A13(OnGrnd)
	clr	A0
	move	A0,*A8(OZVEL),L
	jruc	Grounded

BOMBBNCE:
	movi	>25000,A0
	calla	RANDU
	subi	>3000,A0
	move	A0,A1
	move	*A8(OXVEL),A0,L
	CALLA	ABSSUB
	move	A0,*A8(OXVEL),L
	move	*A8(OYVEL),A0,L
	sra	1,A0
	neg	A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A0,L
	sra	1,A0
	move	A0,*A8(OZVEL),L

	movk	4,A0
	calla	RANDU
	inc	A0
	movb	A0,*A13(ROTTIKS)	;set time between rotations from 2-5

	callr	SetRotD
	
	jruc	UpdVels
BFLYING:
	move	*A8(OYVEL),A0,L
	addi	>4000,A0
	move	A0,*A8(OYVEL),L
	jruc	UpdVels

Grounded:
	CALLA	DFRMGRND	;A1
	jrp	Falling
	clr	A0
	jruc	SetFallV

Falling:
	move	*A8(OYVEL+16),A0,W
	addk	2,A0
	cmp	A1,A0
	jrlt	SetFallV
	move	A1,A0
SetFallV:
	sll	16,A0
	move	A0,*A8(OYVEL),L

UpdVels:
	CALLA	UpdShadV

;***** Update Fuse Velocity *****
	move	*A8(OXVEL),*A10(OXVEL),L
	move	*A8(OYVEL),*A10(OYVEL),L
	move	*A8(OZVEL),*A10(OZVEL),L

;***** Do Stick Animation *****
	movb	*A13(rottiks),A0
	dec	A0
	jrnz	SkSAnim

	movb	*A13(OnGrnd),A0
	jrz	InAir
	movi	255,A0		;reset rottiks
	movb	*A13(rot),A1
	cmpi	3,A1
	jreq	SkSAnim
	cmpi	9,A1
	jreq	SkSAnim
InAir:
  ;* Bump Rotation counter
	movb	*A13(rotdir),A0
	jrz	RotCW	

	;***** ROTATE Counter Clockwise
	movb	*A13(rot),A0
	jrnz	DecRot
	movk	11,A0
	jruc	RotX
DecRot:
	dec	A0
	jruc	RotX
RotCW:
	;***** ROTATE Clockwise
	movb	*A13(rot),A0
	inc	A0
	cmpi	12,A0
	jrlt	RotX
	clr	A0
RotX:
	movb	A0,*A13(rot)

	callr	StckFrm
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	movb	*A13(ROTTIKS),A0
SkSAnim:
	movb	A0,*A13(rottiks)

;***** Do Fuse Animation *****
	;* Bump Fuse Animation counter
	movb	*A13(fanimct),A0
	inc	A0
	cmpi 3,A0
	jrlt	SkRstFCt
	clr	A0
SkRstFCt:
	movb	A0,*A13(fanimct)

	callr	FuseFrm
	SWAP	A8,A10
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	SWAP	A8,A10

;***** Update Fuse Position ******
	callr	MoveFuse

;***** SLEEP Since Animation is Done
	movk	1,A0
	calla	PRCSLP

;***** Burn Down Fuse Length - check for explosion *****
	movb	*A13(fusetiks),A0
	dec	A0
	jrnz	SkFuseDc
	movb	*A13(fuselen),A0
	cmpi	-7,A0
	jreq	ExpDyna
	dec	A0
	movb	A0,*A13(fuselen)
	movi	FUSETIKS,A0
SkFuseDc:
	movb	A0,*A13(fusetiks)

	jruc	DynaLp


*************************************************************************
ExpDyna:
	move	A10,A0		;* Free the Fuse Obj
	calla	DELSOBJ
	move	A8,A0		;* delete stick's shadow
	calla	DELSHAD
	;get stick off bullet list
	movi	ENEMY_BULLETS,A1
	calla	DELSUPP		  
	;* insert on proper list
	movi	EXPLOSIONS,A1
	calla	ADDSUPP

	MOVI	DUMCOLL,A0
	MOVE	A0,*A8(OCVECT),L	;MAKE IT DO NOTHING IF IT HITS
	MOVE	*A8(OID),A0,W
	SRL	4,A0
	SLL	4,A0
	ADDK	EXPLODID,A0
	MOVE	A0,*A8(OID),W		;UPDATE I.D. TO EXPLOSION
	MOVE	*A8(OFLAGS),A0,W
	ANDNI	M_PIXSCAN|M_FLIPV,A0
	MOVE	A0,*A8(OFLAGS),W	;UPDATE FOR NO PIXEL SCAN, no VFLIP
	move	A8,A0

	movi	AIRB1,A9
	movi	AIRB2,A10
	calla	DFRMGRND
	cmpi	10,A1
	jrge	GOTEXP
	;**** Do a Ground Nuke
	calla	ClrVel
	;set ani pt on the ground
	move	*A8(OYPOS),A0,W
	add	A1,A0
	move	*A8(OSIZEY),A1,W
	srl	1,A1
	add	A1,A0
	move	A0,*A8(OYPOS),W
	movi	GRNDB1,A9
	movi	GRNDB2,A10
GOTEXP:

	movi	BOMBSND,A0
	calla	ONESND

	movi	[5,5],A0
	move	A0,*A8(OZSIZ),L
	movk	1,A0
	movb	A0,*A13(expltiks)
NxtFrm:
	movb	*A13(expltiks),A0
	dec	A0
	jrnz	SkVDamp
	move	*A8(OXVEL),A0,L
	sra	1,A0
	move	A0,*A8(OXVEL),L
	move	*A8(OYVEL),A0,L
	sra	1,A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A0,L
	sra	1,A0
	move	A0,*A8(OZVEL),L
	movk	3,A0
SkVDamp:
	movb	A0,*A13(expltiks)

	movk	4,A1
	jsrp	FRANIM
	jrnc	AdjZ
	;do second half of explosion??
	move	A10,A9
	jrz	XploDone
	clr	A10
	move	A0,A7
	move	A8,A0
	movi	EXPLOSIONS,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	move	A7,A0

AdjZ:
	move	*A8(OZPOS),A1,W		;move explosion forward
	add	A0,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OZSIZ),A1,W		;grow Zminus thickness
	add	A0,A1
	add	A0,A1
	move	A1,*A8(OZSIZ),W
	CALLA	PRCSLP
	jruc	NxtFrm
XploDone:
BOMBDONE:
	move	A8,A0			;GET THE BLOCK
	CALLA	DELPAL
	calla	DELSOBJ			;ZAP IT
	DIE

BOMBSCRX:
	;* Free the Fuse Obj
	move	A10,A0
	calla	DELSOBJ
	move	A8,A0			;GET THE BLOCK
	movi	ENEMY_BULLETS,A1
	calla	DELSUPP		  
	jruc	BOMBDONE

***********************  Stick Frame  ***********************************
StckFrm:
;* stuff the appropriate dynamite stick frame into A9 based on the
;* current value of "rot"

	movb	*A13(rot),A9
	sll	6,A9		;* value is a 2 longword (64 bit) offset
	addi	StckTbl,A9
	rets
*************************************************************************

***********************  Set Rotatation Direction  **********************
SetRotD:
;* generate new direction of rotation based on the
;* current value of "rot" (turn toward closest horizontal pos)

	movb	*A13(rot),A0
	sll	3,A0		;* value is a 2 longword (64 bit) offset
	addi	RotDTbl,A0
	movb	*A0(0),*A13(rotdir)
	rets
*************************************************************************

**************************  BnceHght  ***********************************
BnceHght:
;* put height at which stick strikes the ground into A0

	mmtm	SP,A1,A2,A3
	movk	3,A0
	movb	*A13(rot),A1
	sll	5,A1		;Long word ptr	into CircleOff
	addi	CircleOff+16,A1		;16 is to skip X offset
	move	*A1+,A3,W		;multiplier for Y offset
	jrz	SkFuseHt
	jrn	SkFuseHt
	movb	*A13(fuselen),A2		;# pixels of fuse exposed..
	addk	8,A2
	mpys	A2,A3
	addi	>4000,A3
	sra	15,A3
	add	A3,A0
SkFuseHt:
	mmfm	SP,A1,A2,A3
	rets
*************************************************************************

***********************  Fuse Frame  ***********************************
FuseFrm:
;* stuff the appropriate dynamite stick frame into A9 based on the
;*	current value of "rot"
;*	current value of Fuse Animation counter "fanimct"

	movb	*A13(rot),A9
	move	A9,A0
	sll	7,A9
	sll	6,A0	
	add	A0,A9	;* value is a 6 longword (192 bit) offset
	movb	*A13(fanimct),A0
	sll	6,A0		;* fanimct is a 2 longword offset
	add	A0,A9
	addi	FuseTbl,A9
	rets
*************************************************************************

*************************  Move Fuse  ***********************************
MoveFuse:
;* Update the position of the Fuse, based on:
;	The location of the animation point of the stick
;	The Rotation of the stick
;	The Length of the Fuse
;	The animation point of the Fuse

	;Set Z position
	move	*A8(OZPOS),A0,W
	dec	A0
	move	A0,*A10(OZPOS),W

	;* Get animation point of the stick X,Y in A2,A3
	calla	GETANIXY
	sra	16,A2	;A2 was APOINT OYVAL, 32 BITS
	sra	16,A3	;A3 was APOINT OXVAL, 32 BITS

	;* Generate offset from Stick anim pt to Fuse anim pt.
	;*   based on the rotation of the stick
	movb	*A13(rot),A0
	sll	5,A0		;Long word ptr	into CircleOff
	addi	CircleOff,A0
	movb	*A13(fuselen),A4		;# pixels of fuse exposed..
	move	*A0+,A5,W		;multiplier for X offset
	move	*A0+,A7,W		;multiplier for Y offset
	mpys	A4,A5
	mpys	A4,A7
	addi	>4000,A5
	addi	>4000,A7
	sra	15,A5		;A5 = X offset
	sra	15,A7		;A7 = Y offset
	add	A5,A3		;A3 = desired X coor of Fuse Anim Pt
	add	A7,A2		;A2 = desired Y coor of Fuse Anim Pt

	;* Get the offset from the fuse anim pt to the top left corner
	MMTM	SP,A1,A2,A4
	MOVE	*A10(OIMG),A1,L
	MOVE	*A10(OSIZE),A2,L
	MOVE	*A10(OFLAGS),A4,W
	CALLA	GANIOF
	MMFM	SP,A1,A2,A4
	
	sra	16,A6	;*A6=X ANIMATION OFFSET X 64K
	sra	16,A7	;*A7=Y ANIMATION OFFSET X 64K
	sub	A6,A3	;A3 = Top Left X of Fuse
	sub	A7,A2	;A2 = Top Left Y of Fuse
	move	A3,*A10(OXPOS),W
	move	A2,*A10(OYPOS),W

	rets
*********************************************************************

AIRB1:
	.long	nb1
	.word	NEWPALET|4
	.long	newbom
	.long	nb2a
	.word	6
	.long	nb3a
	.word	5
	LONGNULL
AIRB2:
	.long	nb4
	.word	4
	.long	nb5
	.word	3
	.long	nb6
	.word	3
	.long	nb7
	.word	3
	.long	nb8
	.word	3
	.long	hiro9air
	.word	3
	.long	hiro10air
	.word	3
	.long	hiro11air
	.word	3
	LONGNULL

GRNDB1:				;GROUND BLAST ON EXPLOSION LIST
	.long	nb1grnd
	.word	NEWPALET|3
	.long	newbom
	.long	hiro1
	.word	5
	.long	hiro2
	.word	5
	.long	hiro3
	.word	5
	.long	hiro4
	.word	4
	LONGNULL
GRNDB2:				;GROUND BLAST OFF EXPLO LIST
	.long	hiro5
	.word	3
	.long	hiro6
	.word	3
	.long	nb5grnd
	.word	3
	.long	nb6grnd
	.word	3
	.long	nb7grnd
	.word	3
	.long	nb8grnd
	.word	3
	.long	hiro9
	.word	3
	.long	hiro10
	.word	3
	.long	hiro11
	.word	3
	LONGNULL

StckTbl:
	.long	dstk0
	.word	FLIPBITS|1,0
	.long	dstk30
	.word	FLIPBITS|1,0
	.long	dstk60
	.word	FLIPBITS|1,0
	.long	dstk90
	.word	FLIPBITS|1,0
	.long	dstk60
	.word	FLIPBITS|1,(M_FLIPV)
	.long	dstk30
	.word	FLIPBITS|1,(M_FLIPV)
	.long	dstk0
	.word	FLIPBITS|1,(M_FLIPV)
	.long	dstk30
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	dstk60
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	dstk90
	.word	FLIPBITS|1,(M_FLIPH)
	.long	dstk60
	.word	FLIPBITS|1,(M_FLIPH)
	.long	dstk30
	.word	FLIPBITS|1,(M_FLIPH)
	LONGNULL

RotDTbl:
;* 0 - clockwise,  1 - CCW
	.byte	0,0,0,0,1,1,1,0,0,1,1,1	
	LONGNULL

FuseTbl:
	.long	spk0a
	.word	FLIPBITS|1,0
	.long	spk0b
	.word	FLIPBITS|1,0
	.long	spk0c
	.word	FLIPBITS|1,0
	.long	spk30a
	.word	FLIPBITS|1,0
	.long	spk30b
	.word	FLIPBITS|1,0
	.long	spk30c
	.word	FLIPBITS|1,0
	.long	spk60a
	.word	FLIPBITS|1,0
	.long	spk60b
	.word	FLIPBITS|1,0
	.long	spk60c
	.word	FLIPBITS|1,0
	.long	spk90a
	.word	FLIPBITS|1,0
	.long	spk90b
	.word	FLIPBITS|1,0
	.long	spk90c
	.word	FLIPBITS|1,0
	.long	spk60a
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk60b
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk60c
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk30a
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk30b
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk30c
	.word	FLIPBITS|1,(M_FLIPV)
	.long	spk0a
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk0b
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk0c
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk30a
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk30b
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk30c
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk60a
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk60b
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk60c
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk90a
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk90b
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk90c
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	spk60a
	.word	FLIPBITS|1,(M_FLIPH)
	.long	spk60b
	.word	FLIPBITS|1,(M_FLIPH)
	.long	spk60c
	.word	FLIPBITS|1,(M_FLIPH)
	.long	spk30a
	.word	FLIPBITS|1,(M_FLIPH)
	.long	spk30b
	.word	FLIPBITS|1,(M_FLIPH)
	.long	spk30c
	.word	FLIPBITS|1,(M_FLIPH)
	LONGNULL


;* The following #'s are 2's comp left shifted 15 bits
sin00	.set	0
sin30	.set	>4000
sin60	.set	>6ED9
sin90	.set >7FFF
nsin30	.set	>C000
nsin60	.set	>9127
	;could go for >8000 but may as well have -1 be same magnitude as 1
nsin90	.set	>8001


CircleOff:
	.word	sin00,nsin90	;0 degree rotation
	.word	sin30,nsin60	;30
	.word	sin60,nsin30	;60
	.word	sin90,sin00	;90
	.word	sin60,sin30	;120
	.word	sin30,sin60	;150
	.word	sin00,sin90	;180
	.word	nsin30,sin60	;210
	.word	nsin60,sin30	;240
	.word	nsin90,sin00	;270
	.word	nsin60,nsin30	;300
	.word	nsin30,nsin60	;330


	.END
