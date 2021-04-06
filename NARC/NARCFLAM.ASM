	.FILE	'NARCFLAM.ASM'
	.TITLE	" <<< N  A  R  C  -- FLAME THROWER >>>"
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

	.GLOBL	MAKEFLAM,GROWFLAM

FLAMESND	.WORD	>F310,>3,>80cf,0 ;flame thrower snd
;FLAMESND	.WORD	>F310,>3,>8094,0 ;flame thrower snd
FRYSND		.WORD	>F315,>13,>8088,0 ;burning sound

FTHRWPID	.set	>0FF5
FLOUTPID	.set	>0FF6
FLAMZSIZ	.set	>00120012
FLAMEOID	.set	BEOID|FLAMEID

ANIWAIT		.set	2	;tiks between flame animations

;PROCESS BLOCK OFFSETS
HEADANIX	.set	ETEMP1
TAILANIX	.set	ETEMP1+16
FLAMEDIR	.set	ETEMP2
ANICTR		.set	ETEMP2+8
STRTANIX	.set	ETEMP2+16
FLAMEOUT	.set	ETEMP3
GROWING		.set	ETEMP3+8
FXOFF		.set	ETEMP3+16
ANITIKS		.set	ETEMP4
COLLTIKS	.set	ETEMP4+8
FLAMTIKS	.set	ETEMP4+16
SNDTIKS		.set	ETEMP4+24
BLAH3		.set	ETEMP5
BLAH2		.set	ETEMP6
HEADANI		.set	ESWTCH
TAILANI		.set	EYXVEL
;COLLOBJ	.set	EOBJ		from narctequ
FXVEL		.set	EMAINT
SHRNKSPD	.set	EBCNTRS		;byte
GROWSPD		.set	EBCNTRS+8	;byte
FLAMWAIT	.set	EBCNTRS+16 ;how many tiks max between GROW calls
COLLWAIT	.set	EBCNTRS+24 ;how many tiks before growing after collision


	.EVEN
	.TEXT
**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
HeadInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	FLHD1A,FLAMZSIZ,FLAMCOLL
	.WORD	DMAWNZ,FLAMEOID
	.LONG	0
TailInit:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	FLTLA,FLAMZSIZ,FLAMCOLL
	.WORD	DMAWNZ,FLAMEOID
	.LONG	0
**************************************************************************


**************************************************************************
MAKEFLAM:
;PARMS
; A0 - X velocity
; A1 - Y velocity
; A2 - Z velocity
; A3 - X coor of beginning animation pt (tip of gun barrel)
; A4 - Y coor
; A5 - Z coor
; A6 - 0->flame shooting to the right, 1->flame to left
;RETS
; A0 - ptr to Flame Thrower Process, Z-flag set if failure
;FUNCTION
; Creates a Flame Thrower Process.
	mmtm	SP,A0,A1,A2,A7
	mmtm	SP,A0,A1
	CREATE	FTHRWPID,FLAMETHROW ;allocate process	(bashes A1,A7)
	mmfm	SP,A1,A7	;this is to pop A0,A1
	jrz	MAKEFX
	move	A1,*A0(FXVEL),L
	move	A7,*A0(ETEMP5),L
	move	A2,*A0(ETEMP6),L
	move	A3,*A0(HEADANIX),W
	move	A4,*A0(ETEMP3),W
	move	A5,*A0(ETEMP4),W
	movb	A6,*A0(FLAMEDIR)

	movk	11,A1
	movb	A1,*A0(SHRNKSPD) ;speed tail shrinks toward head
	movk	7,A1
	movb	A1,*A0(GROWSPD)	;speed head grows away from tail
	movk	10,A1
	movb	A1,*A0(FLAMWAIT) ;# tiks max between GROW calls
	movk	3,A1
	movb	A1,*A0(COLLWAIT) ;# tiks before growing after collision

MAKEFX:
	mmfm	SP,A0,A1,A2,A7
	rets
**************************************************************************


**************************************************************************
GROWFLAM:
;PARMS
; A0 - ptr to Flame Thrower Process
;RETURNS nothing
;FUNCTION
; To keep the flame burning and growing,
; GROWFLAM must be called at least every FLAMWAIT ticks or the Flame
; Thrower Process will change to FLAMEOUT mode where the tail of the
; flame begins to shrink forward into the head of the flame.
; GROWFLAM sets the GROWING flag in the Flame Thrower Process.
; If the process does not have an ID of FTHRWPID, GROWFLAM returns 
; without performing any action.
	mmtm	SP,A1
	move	*A0(PROCID),A1,W
	cmpi	FTHRWPID,A1
	jrnz	GROWX
	movk	1,A1
	movb	A1,*A0(GROWING)
GROWX:
	mmfm	SP,A1
	rets
**************************************************************************


**************************************************************************
FLAMETHROW:
;PROCESS Created by MAKEFLAM
;PARMS
;FLAMEDIR - direction
;HEADANIX - X coor
;ETEMP3 - Y coor
;ETEMP4 - Z coor
;EMAINT - XVEL 
;ETEMP5 - YVEL
;ETEMP6 - ZVEL


FLAME1LEN	.set	30
FLAME2LEN	.set	85

;create TAILOBJ - A8
;create HEADOBJ - A10
	calla	GETOBJ
	jrnz	GotHd
	DIE
GotHd:
	move	A0,A10

	calla	GETOBJ
	jrnz	GotTl
	move	A10,A0
	calla	FREEOBJ
	DIE
GotTl:
	move	A0,A8

	MOVI	NARCS,A0
	CALLA	GETFPAL		;GET A COLOR MAP ASSIGNMENT
	jrnz	GotPal
	move	A8,A0
	calla	FREEOBJ
	move	A10,A0
	calla	FREEOBJ
GotPal:
	move	A0,A7

	move	A8,A0
	movi	TailInit,A14
	calla	STFOBJ
	move	A7,*A0(OPAL),W
	move	A13,*A0(OPLINK),L
	movi	ENEMY_BULLETS,A1
	calla	ADDSUPP

	move	A10,A0
	movi	HeadInit,A14
	calla	STFOBJ
	move	A7,*A0(OPAL),W
	move	A13,*A0(OPLINK),L
	movi	ENEMY_BULLETS,A1
	calla	ADDSUPP

;USE PARMS
	move	*A13(ETEMP5),A0,L
	move	A0,*A8(OYVEL),L
	move	A0,*A10(OYVEL),L
	move	*A13(ETEMP6),A0,L
	move	A0,*A8(OZVEL),L
	move	A0,*A10(OZVEL),L
	
	movb	*A13(FLAMEDIR),A0
	jrz	SkFixX
	calla	YFLP
	SWAP	A8,A10
	calla	YFLP
	SWAP	A8,A10
SkFixX:
	move	*A13(HEADANIX),A1,W
	move	A1,*A13(TAILANIX),W
	move	A1,*A13(STRTANIX),W

;ETEMP3 - Y coor
	move	*A13(ETEMP3),A0,W
	move	A0,A1
	move	*A8(OIMG),A2,L
	move	*A2(IANIOFFY),A2,W		
	sub	A2,A0
	move	A0,*A8(OYPOS),W
	move	*A10(OIMG),A2,L
	move	*A2(IANIOFFY),A2,W		
	sub	A2,A1
	move	A1,*A10(OYPOS),W
;ETEMP4 - Z coor
	move	*A13(ETEMP4),A0,W
	move	A0,*A8(OZPOS),W
	inc	A0			;head must be in front of tail
	move	A0,*A10(OZPOS),W

	move	A8,A0
	calla	INSOBJ
	move	A10,A0
	calla	INSOBJ

;INITIALIZATION
	clr	A0
	move	A0,*A13(COLLOBJ),L
	movb	A0,*A13(ANICTR)
	movb	A0,*A13(ANITIKS)
	movb	A0,*A13(COLLTIKS)
	movb	A0,*A13(FLAMTIKS)
	movb	A0,*A13(FLAMEOUT)
	movk	1,A0
	movb	A0,*A13(GROWING)

	movi	FLAME1,A0
	move	A0,*A13(HEADANI),L
	movi	FLAME3,A0
	move	A0,*A13(TAILANI),L

;every TIK
;  if ANITIKS tiks have elapsed without animating,
;    bump ANICTR by 1 (modulo 3), reset ANITIKS
;    set ANITIKS to ANIWAIT
;  if (COLLOBJ)
;    set HEADANI to FLHIT
;    set HEADANIX to COLLOBJ(ANIX)
;    reset COLLWAIT, COLLOBJ
;  else if COLLOBJ has been 0 for COLLWAIT tiks,
;    extend HEADANIX from TAILANIX by GROWSPD
;    if (HEADANI == FLHIT)
;      if (ABS(HEADANIX - TAILANIX) > FLAME2LEN)
;        HEADANI = FLAME2
;        move HEADANIX back toward TAILANIX by FLAME2LEN
;      else
;        HEADANI = FLAME1
;        HEADANIX = TAILANIX
;  if (FLAMEOUT)
;    while (ABS(HEADANIX - TAILANIX) <= SHRINKSPD)
;      if (HEADANI != FLAME2)
;        jump to FLAMDONE {deletes objs, proc dies}
;      else
;        HEADANI = FLAME1
;        HEADANIX set away from TAILANIX by FLAME2LEN-FLAME1LEN
;    move TAILANIX SHRINKSPD closer to HEADANIX
;  else /*!FLAMEOUT*/
;    if (GROWING)
;      clear GROWING
;      reset FLAMTIKS to FLAMWAIT
;    if FLAMWAIT tiks have elapsed without GROWING set, 
;      set FLAMEOUT, set Proc ID to FLOUTPID
;    else
;      if (HEADANI == FLAME1)
;        if (ABS(HEADANIX - TAILANIX) > FLAME2LEN-FLAME1LEN)
;          HEADANI = FLAME2
;          HEADANIX moves toward TAILANIX by FLAME2LEN-FLAME1LEN
;  DO ANIMATION
;  plot head
;  set head X coor to HEADANIX
;  UNCLIP old Tail
;  plot tail 
;  compute new clip size
;  CLIP new TAIL
;  set tail X coor to TAILANIX
;  Decrement tik ctrs
;  SLEEP


;every TIK
FlameLp:
; update for X velocity	
	move	*A13(FXVEL),A0,L
	move	*A13(FXOFF),A1,W
	add	A1,A0
	move	A0,A1
	zext	A1,W
	move	A1,*A13(FXOFF),W
	sra	16,A0
	move	*A13(HEADANIX),A1,W
	move	*A13(STRTANIX),A2,W
	move	*A13(TAILANIX),A3,W
	add	A0,A1
	move	A1,*A13(HEADANIX),W
	add	A0,A2
	move	A2,*A13(STRTANIX),W
	add	A0,A3
	move	A3,*A13(TAILANIX),W


;  if (COLLOBJ)
	move	*A13(COLLOBJ),A0,L
	jrz	NoColl
;    set HEADANI to FLHIT
	movi	FLHIT,A1
	move	A1,*A13(HEADANI),L
;    set HEADANIX to COLLOBJ(ANIX)
	move	*A0(OXPOS),A1,W
	addk	10,A1
	movb	*A13(FLAMEDIR),A2
	jrz	GotHX
	move	*A0(OSIZEX),A2,W
	add	A2,A1
	subk	20,A1
GotHX:
	move	A1,*A13(HEADANIX),W
;    reset COLLWAIT, COLLOBJ
	movb	*A13(COLLWAIT),*A13(COLLTIKS)
	clr	A0
	move	A0,*A13(COLLOBJ),L
	movi	FRYSND,A0
	calla	ONESND
	jruc	SkNoColl
NoColl:
;  else if COLLOBJ has been 0 for COLLWAIT tiks,
	movb	*A13(COLLTIKS),A0
	jrp	SkNoColl
;    extend HEADANIX from TAILANIX by GROWSPD
	movb	*A13(GROWSPD),A0
	callr	HeadFwd
;    if (HEADANI == FLHIT)
	move	*A13(HEADANI),A0,L
	cmpi	FLHIT,A0
	jrnz	SkNoColl
;      if (ABS(HEADANIX - TAILANIX) > FLAME2LEN)
	move	*A13(HEADANIX),A0,W
	move	*A13(TAILANIX),A1,W
	sub	A1,A0
	abs	A0
	cmpi	FLAME2LEN,A0
	jrle	DoFlame1
;        HEADANI = FLAME2
	movi	FLAME2,A0
	move	A0,*A13(HEADANI),L
;        move HEADANIX back toward TAILANIX by FLAME2LEN
	movi	FLAME2LEN,A0
	callr	HeadBack
;      else
DoFlame1:
;        HEADANI = FLAME1
	movi	FLAME1,A0
	move	A0,*A13(HEADANI),L
;        HEADANIX = TAILANIX
	move	*A13(TAILANIX),*A13(HEADANIX),W
SkNoColl:
;  if (FLAMEOUT)
	movb	*A13(FLAMEOUT),A0
	jrz	Growing
;    while (ABS(HEADANIX - TAILANIX) <= SHRINKSPD)
CkLen:
	move	*A13(HEADANIX),A0,W
	move	*A13(TAILANIX),A1,W
	sub	A1,A0
	movb	*A13(FLAMEDIR),A1
	jrz	SkNegDlt
	neg	A0
SkNegDlt:
	movb	*A13(SHRNKSPD),A14
	cmp	A14,A0
	jrgt	LenOk
;      if (HEADANI != FLAME2)
	move	*A13(HEADANI),A0,L
	cmpi	FLAME2,A0
	jreq	NotOut
;        FLAMDONE {deletes objs, proc dies}
	move	A8,A0
	calla	DELPAL
	movi	ENEMY_BULLETS,A1
	calla	DELSUPP
	calla	DELOBJ
	move	A10,A0
	movi	ENEMY_BULLETS,A1
	calla	DELSUPP
	calla	DELOBJ
	DIE

;      else
NotOut:
;        HEADANI = FLAME1
	movi	FLAME1,A0
	move	A0,*A13(HEADANI),L
;        HEADANIX set away from TAILANIX by FLAME2LEN-FLAME1LEN
	movi	FLAME2LEN-FLAME1LEN,A0
	callr	HeadFwd
	jruc	CkLen
LenOk:
;    move TAILANIX SHRINKSPD closer to HEADANIX
	movb	*A13(SHRNKSPD),A0
	callr	TailFwd
	jruc	DoAni
;  else /*!FLAMEOUT*/
Growing:
;    if (GROWING)
	movb	*A13(GROWING),A0
	jrz	SkGrowSt
;      clear GROWING
	clr	A0
	movb	A0,*A13(GROWING)
;      reset FLAMTIKS to FLAMWAIT
	movb	*A13(FLAMWAIT),*A13(FLAMTIKS)
SkGrowSt:
;Check to trigger flame sound
	movb	*A13(SNDTIKS),A0
	jrp	SkSnd
	movk	5,A0
	movb	A0,*A13(SNDTIKS)
	movi	FLAMESND,A0
	calla	ONESND
SkSnd:

;    if FLAMWAIT tiks have elapsed without GROWING set, 
	movb	*A13(FLAMTIKS),A0
	jrp	StilGrow
;      set FLAMEOUT, set Proc ID to FLOUTPID
	movk	1,A0
	movb	A0,*A13(FLAMEOUT)
	movi	FLOUTPID,A0
	move	A0,*A13(PROCID),W
	jruc	DoAni
StilGrow:
;    else
;      if (HEADANI == FLAME1)
	move	*A13(HEADANI),A0,L
	cmpi	FLAME1,A0
	jrnz	DoAni
;        if (ABS(HEADANIX - TAILANIX) > FLAME2LEN-FLAME1LEN)
	move	*A13(HEADANIX),A0,W
	move	*A13(TAILANIX),A1,W
	sub	A1,A0
	abs	A0
	cmpi	FLAME2LEN-FLAME1LEN,A0
	jrle	DoAni
;          HEADANI = FLAME2
	movi	FLAME2,A0
	move	A0,*A13(HEADANI),L
;          HEADANIX moves toward TAILANIX by FLAME2LEN-FLAME1LEN
	movi	FLAME2LEN-FLAME1LEN,A0
	callr	HeadBack
DoAni:
;  DO ANIMATION
;  if ANITIKS tiks have elapsed without animating,
	movb	*A13(ANITIKS),A0
	jrp	SkNxtAni
;    bump ANICTR by 1 (modulo 3), reset ANITIKS
	movb	*A13(ANICTR),A0
	inc	A0
	cmpi	3,A0
	jrlt	GotAniCt
	clr	A0
GotAniCt:
	movb	A0,*A13(ANICTR)
;    set ANITIKS to ANIWAIT
	movk	ANIWAIT,A0
	movb	A0,*A13(ANITIKS)

	;ANIMATE THE HEAD
	move	*A13(HEADANI),A9,L
	movb	*A13(ANICTR),A0
	sll	6,A0	;2 longwords
	add	A0,A9
	movk	4,A1			;* one frame, no sleepin
	SWAP	A8,A10
	jsrp	FRANIM
	SWAP	A8,A10
SkNxtAni:

;  set head X coor to HEADANIX
	move	*A13(HEADANIX),A0,W
	movb	*A13(FLAMEDIR),A1
	jrz	GotHXCoor
	move	*A10(OSIZEX),A1,W
	sub	A1,A0
GotHXCoor:
	move	A0,*A10(OXPOS),W

;  plot tail 
	;*** COMPUTE WIDTH
	move	*A13(HEADANIX),A1,W
	move	*A13(TAILANIX),A2,W
	sub	A1,A2
	abs	A2
	addk	10,A2	;amount of overlap between head and tail
	;*** GET FRAME	
	move	*A13(TAILANI),A1,L
	movb	*A13(ANICTR),A0
	sll	5,A0	;longwords
	add	A0,A1
	move	*A1,A1,L
	callr	ANIXCLIP

;  set tail X coor to TAILANIX
	move	*A13(TAILANIX),A0,W
	movb	*A13(FLAMEDIR),A1
	jrz	GotTXCoor
	move	*A8(OSIZEX),A1,W
	sub	A1,A0
GotTXCoor:
	move	A0,*A8(OXPOS),W

;  Decrement tik ctrs
	movb	*A13(ANITIKS),A0
	dec	A0
	movb	A0,*A13(ANITIKS)
	movb	*A13(COLLTIKS),A0
	dec	A0
	movb	A0,*A13(COLLTIKS)
	movb	*A13(FLAMTIKS),A0
	dec	A0
	movb	A0,*A13(FLAMTIKS)
	movb	*A13(SNDTIKS),A0
	dec	A0
	movb	A0,*A13(SNDTIKS)

	SLEEP	1
	jruc	FlameLp
**************************************************************************

**************************************************************************
ANIXCLIP:
* A1=IMAGE POINTER
* A2=WIDTH OF IMAGE to BE PLOTTED
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED

	;* update Y pos
	move	*A8(OYPOS),A0,W
	move	*A8(OIMG),A3,L
	cmp	A1,A3
	jreq	SkYAniOf
	move	A1,*A8(OIMG),L
	move	*A3(IANIOFFY),A4,W	;old anioffy
	move	*A1(IANIOFFY),A5,W	;new anioffy
	sub	A4,A5
	sub	A5,A0		;A0 = NewYpos
	move	A0,*A8(OYPOS),W
SkYAniOf:

	move	*A1(ISAG),A3,L
	move	*A8(OFLAGS),A4,L
	move	*A1,A7,L	;(ISIZE) = 0
	addk	3,A7
	srl	2,A7
	sll	2,A7
	
	movy	A7,A2
	subxy	A2,A7		;clip = ISIZEX - WIDTH plotted
	btst	B_FLIPH,A4
	jrnz	XFlipped

NonFlp:
	move	A7,A5
	sll	16,A5		; offset = clip
	movy	A5,A4
	jruc	StfAni
	
XFlipped:
	movx	A2,A5
	zext	A5,W
	sll	3,A5
	add	A5,A3		;SAG += OSIZEX<<3
	srl	2,A5
	add	A7,A5		;OFFSET = 2*OSIZEX+CLIP
	sll	16,A5		; << 3
	movy	A5,A4

StfAni:
	move	A8,A0  		;GET PUSH ADDRESS OF OFLAGS,OSAG,OSIZE
	ADDI	OFLAGS+>60,A0
	MOVE	A7,*A8(OXCLIP),W
	;A4 - OFLAGS:OFFSET, A3 - OSAG, A2 - OSIZE
	MMTM	A0,A2,A3,A4	;BLOW STUFF OUT without interruption

	rets
**************************************************************************

**************************************************************************
HeadBack:
	neg	A0
HeadFwd:
	mmtm	SP,A1,A2,A3
	movb	*A13(FLAMEDIR),A1
	jrz	SkNegHd
	neg	A0
SkNegHd:
	move	*A13(HEADANIX),A1,W
	add	A0,A1
	move	*A13(STRTANIX),A2,W
	move	A2,A3
	sub	A1,A2
	abs	A2
	cmpi	300,A2
	jrle	GotNHead
	movi	300,A2
	movb	*A13(FLAMEDIR),A1
	jrz	SkNgNHd
	neg	A2
SkNgNHd:
	add	A2,A3
	move	A3,A1
GotNHead:
	move	A1,*A13(HEADANIX),W
	mmfm	SP,A1,A2,A3
	rets
**************************************************************************

**************************************************************************
TailFwd:
	mmtm	SP,A1
	movb	*A13(FLAMEDIR),A1
	jrz	SkNegTl
	neg	A0
SkNegTl:
	move	*A13(TAILANIX),A1,W
	add	A0,A1
	move	A1,*A13(TAILANIX),W
	mmfm	SP,A1
	rets
**************************************************************************

FLAMCOLL:
	.WORD	BEOID|FLAMEID
	.LONG	DUMRTSG
	.WORD	BEOID|BULLETID
	.LONG	DUMRTSG
	.WORD	BEOID|DYNAID
	.LONG	DUMRTSG
	.WORD	BEOID|ROCKETID
	.LONG	DUMRTSG

	.WORD	B1OID|BULLETID
	.LONG	DUMRTSG
	.WORD	B1OID|ROCKETID
	.LONG	DUMRTSG
	.WORD	B1OID|FLAMEID
	.LONG	DUMRTSG

	.WORD	B2OID|BULLETID
	.LONG	DUMRTSG
	.WORD	B2OID|ROCKETID
	.LONG	DUMRTSG
	.WORD	B2OID|FLAMEID
	.LONG	DUMRTSG

	.WORD	0
	.LONG	FlamColl

FlamColl:
;A0 - ptr to flame obj
;A8 - ptr to obj struck
	move	*A0(OPLINK),A0,L
	move	A8,*A0(COLLOBJ),L

	move	A8,A0
	calla	GetPData
	move	A0,A2
	jrz	SkBurnPl
	movi	>6000,A0
	calla	BUGBITE
SkBurnPl

	rets
**************************************************************************


**************************************************************************
FLHIT:
	.long	FLHIT1
	.word	1,0
	.long	FLHIT2
	.word	1,0
	.long	FLHIT3
	.word	1,0

**************************************************************************
*                                                                        *
* FLAME0:								 *
* 	.long	FL1							 *
* 	.word	1,0							 *
* 	.long	FL2							 *
* 	.word	1,0							 *
* 	.long	FL3							 *
* 	.word	1,0							 *
*                                                                        *
**************************************************************************
FLAME1:
	.long	FLHD1A
	.word	1,0
	.long	FLHD1B
	.word	1,0
	.long	FLHD1C
	.word	1,0
FLAME2:
	.long	FLHD2A
	.word	1,0
	.long	FLHD2B
	.word	1,0
	.long	FLHD2C
	.word	1,0

FLAME3:
	.long	FLTLA
	.long	FLTLB
	.long	FLTLC

