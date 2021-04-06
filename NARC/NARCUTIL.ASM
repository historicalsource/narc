 	.FILE	'NARCUTIL.ASM'
	.TITLE	" <<< NARC - TODD'S UTILITIES >>>"
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
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates
	.INCLUDE	"NARCFRAG.GLO"
	.INCLUDE	"NARCTEQU.ASM"
	.INCLUDE	"NARCAUDN.ASM"

;	.GLOBL	FLYTOPL
	.GLOBAL	GET_ADJ

	.TEXT
Y_NEAR	.set	10


**************************************************************************
MovePlyr:
;A0 - player data obj
;A1 - X offset
	move	*A0(POBJ),A2,L
	jrz	NoPMv
	move	*A2(OXPOS),A3,W
	add	A1,A3
	move	A3,*A2(OXPOS),W

	move	*A2(OSHAD),A4,L
	jrz	SkShad1
	move	*A4(OXPOS),A3,W
	add	A1,A3
	move	A3,*A4(OXPOS),W
SkShad1:

	move	*A0(PLOBJ),A2,L
	jrz	NoPMv
	move	*A2(OXPOS),A3,W
	add	A1,A3
	move	A3,*A2(OXPOS),W

	move	*A2(OSHAD),A4,L
	jrz	SkShad2
	move	*A4(OXPOS),A3,W
	add	A1,A3
	move	A3,*A4(OXPOS),W
SkShad2:

NoPMv:
	rets
**************************************************************************

**************************************************************************
SetAniP:
;Parms
;A8 ptr to BASE OBJ
;A0 ptr to obj which is to have its position set so that its anim pt
;is at the same coors as the BASE OBJ

	mmtm	SP,A1,A2,A3,A4,A5,A6,A7
;* get POSITION from first obj..
	move	*A8(OIMG),A1,L
	move	*A8(OSIZE),A2,L
	move	*A8(OFLAGS),A4,W
*GANIOF: A1=OIMG, A2=H:W, A4=OFLAGS -> A6=X ANIOFF<<16, A7=Y ANIOFF<<16
	calla	GANIOF
	move	*A8(OXVAL),A3,L
	add	A6,A3			;A3 XANI pos
	move	*A8(OYVAL),A5,L
	add	A7,A5			;A5 YANI pos

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
	mmfm	SP,A1,A2,A3,A4,A5,A6,A7
	rets
**************************************************************************

**************************************************************************
ZCHEK:
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
WHATCOLL:
;* decide which collision vector should be taken
;* PARMS	A1 - obj ID of item collided with
;* RETURNS	A1 - offset for a jump table of collision vectors
	rets
**************************************************************************


***************************************************************************
ShadOn:
	move	*A8(OSHAD),A0,L
	jaz	SHADST
	rets
***************************************************************************

***************************************************************************
ShadOff:
	move	*A8(OSHAD),A0,L
	jrz	NoShad	
	move	A8,A0
	jauc	DELSHAD
NoShad:
	rets
***************************************************************************

***************************************************************************
GetPLZMID:
	mmtm	SP,A1
	move	@PLZMIN,A0,W
	move	@PLZMAX,A1,W
	add	A1,A0
	srl	1,A0
	mmfm	SP,A1
	rets
***************************************************************************

**************************************************************************
* DFrmGrnd - RETURNS THE DIST FROM THE BOT OF OBJ TO THE "GROUND."				 *
* A0 = OBJECT BLOCK							 *
* RETURN(S)								 *
* A1 = DISTANCE FROM GROUND (16 BITS)					 *
* STATUS BITS SET ACCORDING TO THE SIGN OF A1				 *
* NOTE: MAX ACCEPTABLE Y = +32K, MIN ACCEPTABLE Y = -32K		 *
DFrmGrnd:
	PUSH	A2
	move	*A0(OYPOS),A1,W
	move	*A0(OSIZEY),A2,W
	add	A1,A2			;A2 = BOTTOM Y
	move	*A0(OZPOS),A1,W
	sub	A2,A1
	addi	ZORIGIN,A1
	mmfm	SP,A2
	RETS
**************************************************************************

*************************** Get Player Data *******************************
OidToDat:
;* entry point that takes players OID in A0
	mmtm	SP,A1,A2
	move	A0,A1
	jruc	GotOid
GetPData:
;* PARMS : A0 - ptr to a players Object
;* RETS : A0 - ptr to players DATA Block, rets 0 if neither
	mmtm	SP,A1,A2
	move	*A0(OID),A1,W
GotOid:
	move	A1,A2
	andi	P1OID,A1
	jrz	GetP2Dat
	movi	P1DATA,A0
	jruc	GotPData
GetP2Dat:
	andi	P2OID,A2
	jrz	NoPDat
	movi	P2DATA,A0
	jruc	GotPData
NoPDat:
	clr	A0
GotPData:
	mmfm	SP,A1,A2
	rets
***************************************************************************

***************************************************************************
BulToDat:
;* PARMS : A0 - ptr to a bullet Object
;* RETS : A0 - ptr to firing players DATA Block, rets 0 if neither
	mmtm	SP,A1,A2
	move	*A0(OID),A1,W
	srl	4,A1
	sll	4,A1
	cmpi	B1OID,A1
	jrnz	BP2Dat
	movi	P1DATA,A0
	jruc	GotBPDat
BP2Dat:
	cmpi	B2OID,A1
	jrnz	NoBPDat
	movi	P2DATA,A0
	jruc	GotBPDat
NoBPDat:
	clr	A0
GotBPDat:
	mmfm	SP,A1,A2
	rets
***************************************************************************

****************************** Get Mid Z **********************************
GetMidZ:
;PARMS ptr to obj in A0
;RETURNS middle Z val in A0
	mmtm	SP,A1,A2
	move	*A0(OZSIZ),A2,W
	move	A2,A1
	srl	16,A2
	zext	A1,W
	neg	A1	
	add	A1,A2
	sra	1,A2
	move	*A0(OZPOS),A0,W
	add	A2,A0
	mmfm	SP,A1,A2
	rets
***************************************************************************

***************************************************************************
CentDist:
	mmtm	SP,A1
	move	@(WORLDTLX+16),A0,W				 
	addi	240,A0			;deducting 1/2 avg. width of char
	move	*A8(OXPOS),A1,W
	sub	A1,A0
	abs	A0
	mmfm	SP,A1
	rets
***************************************************************************

************************** Get On Screen **********************************
GetOnScr:
; set dest to be just past current screen bounds
	move	*A8(OXPOS),A1,W

	move	@WORLDTL,A3,W
	zext	A3,W

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	add	A3,A2
	addi	120,A2
	cmp	A2,A1
	jrge	SkLf
	move	A2,A1
	jruc	SkRt
SkLf:

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	add	A3,A2
	subi	120,A2
	cmp	A2,A1
	jrle	SkRt
	move	A2,A1
SkRt:

	;* set z dest to be same as current Z
;	move	*A8(OZPOS),A3,W
;	move	@PLZMIN,A2,W		;check top
;	cmp	A2,A3
;	jrge	SkTp
;	move	A2,A3
;	jruc	SkBt
;SkTp:
;	move	@PLZMAX,A2,W		;check bottom
;	cmp	A2,A3
;	jrle	SkBt
;	move	A2,A3
;SkBt:
;	move	A3,A0

	move	@PLZMIN,B0,W		;check top
	move	@PLZMAX,B1,W		;check bottom
	calla	RANGRAND
	sll	16,A0
	movy	A0,A1

	move	A1,*A13(DEST),L

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	OFFSCR_T,A0
	movb	A0,*A13(DEST_TAG)

	rets
**************************************************************************

**************************** Dest OK *************************************
DestOk:
; make sure dest is still within bounds, else clear destination
	movb	*A13(DEST_TAG),A0
	jrz	DestGood
	cmpi	ESCAPE_T,A0
	jreq	DestGood

	move	*A13(DEST),A1,L
	move	@WORLDTL,A2,W		;sub off world base from position
	zext	A2,W
	subxy	A2,A1

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	subk	25,A2			; give a little padding
	cmpxy	A2,A1
	jrxlt	DestBad

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	addk	25,A2			; give a little padding
	cmpxy	A2,A1
	jrxgt	DestBad

	move	@PLZMIN,A2,W		;check top
	sll	16,A2
	cmpxy	A2,A1
	jrylt	DestBad

	move	@PLZMAX,A2,W		;check bottom
	sll	16,A2
	cmpxy	A2,A1
	jrygt	DestBad

DestGood:
	clrc
	jruc	DestOkX

DestBad:
	clr	A0
	movb	A0,*A13(DEST_TAG)
	movb	A0,*A13(DESTTIKS)
	movb	A0,*A13(BRAINTIKS)
	move	A0,*A13(DEST),L
	move	A0,*A13(WANTOBJ),L
	setc

DestOkX:
	rets
**************************************************************************


**************************************************************************
SCRNCLIP:
;PARMS	A0-Z:X coor
;RETS	A0-Z:X clipped to screen bounds
	mmtm	SP,A2,A3
	move	@WORLDTL,A3,W
	zext	A3,W

	move	@SCRNTL,A2,W		;GET SCREEN LEFT
	add	A3,A2
	addk	10,A2
	cmpxy	A2,A0
	jrxge	SkClipLf
	movx	A2,A0
	jruc	SkClipRt
SkClipLf:

	move	@SCRNLR,A2,W		;GET SCREEN RT.
	add	A3,A2
	subk	10,A2
	cmpxy	A2,A0
	jrxle	SkClipRt
	movx	A2,A0
SkClipRt:

	move	@PLZMIN,A2,W		;check top
	sll	16,A2
	cmpxy	A2,A0
	jryge	SkClipTp
	movy	A2,A0
	jruc	SkClipBt
SkClipTp:

	move	@PLZMAX,A2,W		;check bottom
	sll	16,A2
	cmpxy	A2,A0
	jryle	SkClipBt
	movy	A2,A0
SkClipBt:
	mmfm	SP,A2,A3
	rets
**************************************************************************

**************************** Clip Dest ***********************************
ClipDest:
; clip dest to be within screen bounds
	PUSH	A0
	move	*A13(DEST),A0,L
	callr	SCRNCLIP
	move	A0,*A13(DEST),L
	PULL	A0
	rets
**************************************************************************

**************************** Clip Z Dest *********************************
ClipZDst:
; clip dest to be within screen Z bounds
	PUSH	A0
	move	*A13(DEST),A0,L
	callr	SCRNZCLP
	move	A0,*A13(DEST),L
	PULL	A0
	rets
**************************************************************************

**************************************************************************
SCRNZCLP:
;PARMS	A0-Z:X coor
;RETS	A0-Z:X clipped to screen Z bounds
	PUSH	A2
	move	@PLZMIN,A2,W		;check top
	sll	16,A2
	cmpxy	A2,A0
	jryge	SkClpTp2
	movy	A2,A0
	jruc	SkClpBt2
SkClpTp2:

	move	@PLZMAX,A2,W		;check bottom
	sll	16,A2
	cmpxy	A2,A0
	jryle	SkClpBt2
	movy	A2,A0
SkClpBt2:
	PULL	A2
	rets
**************************************************************************


**************************** CkDest **************************************
CkDest:
;* RETURNS setc if within tolerance of destination
	move	*A13(DEST),A2,W
	jrz	AtDest

	move	*A13(TEMPDEST),A1,W		;want just X component
	jrnz	TDest
	move	A2,A1
TDest:
	calla	GETANIX
	sub	A0,A1			;A1 is dist to be traveled to reach dest

	;* Get X velocity
	move	*A13(FUNCS),A0,L
	addi	GETXVEL,A0
	move	*A0,A0,L
	call	A0				;A0 is velocity

	move	*A8(OFLAGS),A2
	BTST	B_FLIPH,A2
	jrz	FaceRt
	;* Facing left
	move	A0,A0
	jrp	GoingL
	jruc	GoingR
FaceRt:
	move	A0,A0
	jrn	GoingL
	jruc	GoingR

GoingL:
	;* we are heading left, have we passed the destination
	addk	5,A1		;allow 5 pixel tolerance to reach dest
	jrn	DestX
	jruc	AtDest

GoingR:
	subk	5,A1
	jrp	DestX
	
AtDest:
	move	*A13(TEMPDEST),A0,W
	jrz	MadeIt
	move	*A13(FUNCS),A0,L
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0
	jruc	DestX
MadeIt:
	setc
	rets
	 
DestX:
	clrc
	rets
**************************************************************************

*************************** GO DEST Delta ********************************
GoDestD:
;* calculates z motion as value for ZPER
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10

	;* Get MaxXZAngle
	move	*A13(FUNCS),A10,L
	move	*A10(MAXXZANGLE),A10,L	    ;A10 is .16

	;* Get X velocity
	move	*A13(FUNCS),A0,L
	addi	GETXVEL,A0
	move	*A0,A0,L
	call	A0
	move	A0,A9

	move	*A13(DEST),A5,L
	movy	A5,A1			;A5 = Zdest:Xdest
	sra	16,A1
	move	*A8(OZPOS),A2,W
	sub	A2,A1			;A1 = Zdelta = Zdest - Zpos	
	movx	A5,A2
	sext	A2,W
	calla	GETANIX
	sub	A0,A2			;A2 = Xdelta = Xdest - Xpos

	;* make sure we're facing the correct way..
	jrn	GoLeft2
	;*** need to go RIGHT
	move	A9,A9
	jrp	NoFlip
	jruc	YesFlip
GoLeft2:
	;*** need to go LEFT
	move	A9,A9
	jrn	NoFlip
	jruc	YesFlip

NoFlip:
	callr	Ck_NOYFLP
	jrc	SetZVel2		;Flip succeeded
	jruc	FlipFail
YesFlip:	
	callr	Ck_YFLP
	jrc	SetZVel2		;Flip Succeeded

FlipFail:
	;* flip failed
	movb	*A13(FLIPTIKS),A1
	sll	24,A1
	srl	24,A1	;* Flip tiks is always positive
	movb	A1,*A13(DESTTIKS)
	mpys	A9,A1
	sra	16,A1
	addxy	A1,A5
	move	A5,*A13(TEMPDEST),L
	clr	A5
	movb	A5,*A13(ZPER)
	jruc	GoDestX2

SetZVel2:
	;* can a straight course be set for the dest
	;** A4 = (abs Zdelta) - (abs Xdelta)*(MaxXZAngle)
	; if A4 positive, need a temp dest
	move	A2,A4
	abs	A4			    ;A4 is 16.				 (abs Xdelta)
	move	A10,A3		;A3 - MaxXZAngle  is .16
	mpyu	A4,A3		    ; result is 16.16
	srl	16,A3		    ;A3 is 16.
	move	A1,A4								 
	abs	A4									;(abs Zdelta)
	sub	A3,A4		    ;A4 = Zdist left to travel
	jrp	MkTmpDest2

	;* Head straight for the destination
	clr	A3
	move	A3,*A13(TEMPDEST),L
	move	A2,A4
	abs	A4				;(abs Xdelta)
	move	A4,A7
	sll	7,A1				;(A1 = Zdelta) Zper has 7 signifcant digits
	divs	A4,A1			;A4 is 16. A1 is 16
	movb	A1,*A13(ZPER)

	sll	16,A7			;A7 16. -> 32.
	divu	A9,A7			;A9 is 16.16, A7 is 32.
						;A7 -> 16.	
	jruc	SetSlp

MkTmpDest2:
	;* calculate Z part of TEMPDEST
	srl	1,A4	;travel half of Zdist left to go
	move	A10,A7	;A7 - MaxXZAngle
	srl	9,A7	;Zper has 7 significant digits
	move	A1,A1
	jrp	ZdeltaP2
	neg	A7			
	neg	A4
ZdeltaP2:
	movb	A7,*A13(ZPER)
	movy	A5,A3
	sra	16,A3
	sub	A4,A3

	;* calculate X part of TEMPDEST
	move	A10,A6		;A6 is .16
	move	A4,A7		;A4 is 16.
	abs	A7
	sll	16,A7		;A7 is 32.
	divu	A6,A7		;A7 is 16.
	move	A2,A2		
	jrp	XdeltaP2	
	neg	A7
XdeltaP2:
	clr	A6
	movx	A5,A6
	add	A7,A6
	move	A6,A7

	sll	16,A3
	movy	A3,A6
	move	A6,*A13(TEMPDEST),L

	calla	GETANIX
	subxy	A0,A7
	abs	A7
	sll	16,A7
	
	divu	A9,A7
SetSlp:
	movi >FF,A1
	cmp	A1,A7
	jrle	SlpOk
	move	A1,A7
SlpOk:	
	movb	A7,*A13(DESTTIKS)
	
GoDestX2:
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	rets
**************************************************************************

*************************** GO DEST Velocity *****************************
GoDestV:
;* calculates Z motion as a velocity
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10

	;* Get X velocity
	move	*A13(FUNCS),A0,L
	addi	GETXVEL,A0
	move	*A0,A0,L
	call	A0
	move	A0,A9			;A9 = signed XVEL

	move	*A13(DEST),A5,L
	movy	A5,A1			;A5 = Zdest:Xdest
	sra	16,A1
	move	*A8(OZPOS),A2,W
	sub	A2,A1			;A1 = Zdelta = Zdest - Zpos	
	movx	A5,A2
	sext	A2,W
	calla	GETANIX
	move	A0,A10			;A10 = current Xpos
	sub	A0,A2			;A2 = Xdelta = Xdest - Xpos
	move	A2,A3
	move	A9,A9
	jrp	SkNegDlt
	neg	A3
SkNegDlt:
	;* make sure we're facing the correct way..
	move	A3,A3
	jrp	GoRgt
	neg	A9		;going to be flipped, so neg XVEL
	callr	Ck_YFLP
	jrc	SetZVel
	jruc	FlpFail
GoRgt:
	callr	Ck_NOYFLP
	jrc	SetZVel
FlpFail:
	;* flip failed
	neg	A9	;not going direction we wanted.
	movb	*A13(FLIPTIKS),A1
	movb	A1,*A13(DESTTIKS)
	sll	24,A1
	srl	24,A1
	mpys	A9,A1
	srl	16,A1
	add	A0,A1
	movy	A5,A1
	move	A1,*A13(TEMPDEST),L
	clr	A5
	move	A5,*A8(OZVEL),L
	move	A5,*A8(OYVEL),L
	jruc	GoDestX

SetZVel:
	;* can a straight course be set for the dest
	move	A2,A4
	abs	A4			    ;A4=xdist is 16.
	move	*A13(FUNCS),A3,L
	move	*A3(MAXXZANGLE),A3,L	    ;A3 is .16
	mpyu	A4,A3		    ; result is 16.16
	srl	16,A3		    ;A3=zdist travelable is 16.
	move	A1,A4		    
	abs	A4		    ;A4=zdist
	sub	A3,A4		    ;A4 = Zdist left to travel
	jrp	MkTmpDest

	;* Head straight for the destination
	clr	A3
	move	A3,*A13(TEMPDEST),L
	move	A2,A7
	mpys	A9,A1			;A1 is 16. -> 16.16
	divs	A2,A1			;A4 is 16. A1 is 16.16
	move	A1,*A8(OZVEL),L
	move	A1,*A8(OYVEL),L
	sll	16,A7			;A7=(xdelt) 16. -> 32.
	divs	A9,A7			;A9 is 16.16, A7 is 32.
						;A7 -> 16.	
	jruc	SetSlp2

MkTmpDest:
	;* calculate Z part of TEMPDEST
	move	A4,A0
	srl	2,A0			    
	sub	A0,A4			    ;lets travel 3/4 zdist left to go
	move	*A13(FUNCS),A7,L
	move	*A7(MAXXZANGLE),A7,L	    ;A7 is .16
	move	A9,A3
	abs	A3
	srl	8,A3
	srl	8,A7
	mpyu	A3,A7		;A7 is 16.16  Zvel = Xvel*MaxXZAngle
	move	A1,A1
	jrp	ZdeltaP
	neg	A7			
	neg	A4
	neg	A0		;portion of zdelta not travelled
ZdeltaP:
	move	A7,*A8(OZVEL),L
	move	A7,*A8(OYVEL),L
	movy	A5,A3
	sra	16,A3
	sub	A0,A3			;A3 = Z part of tempdest

	;* calculate X part of TEMPDEST
	move	*A13(FUNCS),A6,L
	move	*A6(MAXXZANGLE),A6,L	    ;A6 is .16
	move	A4,A7		;A4 is 16.
	abs	A7
	sll	16,A7		;A7 is 32.
	divu	A6,A7		;A7 is 16.    1/2 Zdist to travel  / XZang
	neg	A7
	move	A2,A2		
	jrp	XdeltaN	
	neg	A7
XdeltaN:
	clr	A6
	movx	A5,A6
	sub	A7,A6
	move	A6,A7

	sll	16,A3
	movy	A3,A6
	move	A6,*A13(TEMPDEST),L

	subxy	A10,A7			;A10 = ret from GETANIX
	sll	16,A7
	divs	A9,A7
SetSlp2:
	move	A7,A7
	jrn	FixSlp
	movi >FF,A1
	cmp	A1,A7
	jrle	SlpOk2
	move	A1,A7
SlpOk2:	
	movb	A7,*A13(DESTTIKS)
	
GoDestX:
	callr	UpdShadV
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	rets
FixSlp:
	movk	2,A7
	jruc	SlpOk2
**************************************************************************

**************************************************************************
T_YFLP:
	mmtm	SP,A0
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrnz	NOFLP3

	move	*A13(FUNCS),A0,L
	movb	*A0(FLIPCT),*A13(FLIPTIKS)
	calla	YFLP

	;* set veloctiy for skaters
	move	*A8(OXVEL),A0,L
	neg	A0
	move	A0,*A8(OXVEL),L
	callr	UpdShadV

NOFLP3:
	mmfm	SP,A0
	rets
**************************************************************************

**************************************************************************
T_NOYFLP:
	mmtm	SP,A0
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	NOFLP4

	move	*A13(FUNCS),A0,L
	movb	*A0(FLIPCT),*A13(FLIPTIKS)
	callA	NOYFLP

	;* set veloctiy for skaters
	move	*A8(OXVEL),A0,L
	neg	A0
	move	A0,*A8(OXVEL),L
	callr	UpdShadV

NOFLP4:
	mmfm	SP,A0
	rets
**************************************************************************

**************************************************************************
Ck_YFLP:
	mmtm	SP,A0
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrnz	NOFLP0

	movb	*A13(FLIPTIKS),A0
	jrnz	CANTFLP0

	move	*A13(FUNCS),A0,L
	movb	*A0(FLIPCT),*A13(FLIPTIKS)
	calla	YFLP

	;* set veloctiy for skaters
	move	*A8(OXVEL),A0,L
	neg	A0
	move	A0,*A8(OXVEL),L
	callr	UpdShadV

NOFLP0:
	mmfm	SP,A0
	setc
	rets
CANTFLP0:
	mmfm	SP,A0
	clrc
	rets
**************************************************************************

**************************************************************************
Ck_NOYFLP:
	mmtm	SP,A0
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	NOFLP1

	movb	*A13(FLIPTIKS),A0
	jrnz	CANTFLP1

	move	*A13(FUNCS),A0,L
	movb	*A0(FLIPCT),*A13(FLIPTIKS)
	calla	NOYFLP

	;* set veloctiy for skaters
	move	*A8(OXVEL),A0,L
	neg	A0
	move	A0,*A8(OXVEL),L
	callr	UpdShadV

NOFLP1:
	mmfm	SP,A0
	setc
	rets
CANTFLP1:
	mmfm	SP,A0
	clrc
	rets
**************************************************************************

****************************** Z OFF *************************************
ZOFF:
;A8 - obj ptr
;A9 - anim ptr
;*A13(ZPER) - signed byte, zoff = zper * Xoff >> 7
	mmtm	SP,A0,A9

	move	*A9+,A0,L		;FRAME
	jreq	ZoffX		;No Frame -> No Xoff -> no Zoff
	move	*A9+,A0,W		;BITS|Sleep Time
	btst BDELTAXZ,A0
	jrz	ZoffX		;No Xoff -> no Zoff
	btst	BSPAWNP,A0
	jrz	SPAWNSk2
	addi	>50,A9
SPAWNSk2:
	btst	BFLIPBIT,A0
	jrz	FLIPSk2
	addi	16,A9
FLIPSk2:
	btst	BNEWPAL,A0
	jrz	PALSk2
	addk	16,A9
PALSk2:
	movb	*A9,A0		;X offset
	abs	A0
	movb	*A13(ZPER),A1
	mpys	A0,A1
	sll	9,A1			;had 7 bits frac, want 16
	move	*A8(OZVAL),A0,L
	add	A1,A0
	move	A0,*A8(OZVAL),L
	move	*A8(OYVAL),A0,L
	add	A1,A0
	move	A0,*A8(OYVAL),L

ZoffX:
	mmfm	SP,A0,A9
	rets
**************************************************************************

*************************************************************************
;* This routine looks for the nearest bullet heading toward an enemy.
;* PARMS:
;*	A8 - Enemy obj ptr
;* RETURNS:
;*	A5 - ptr to bullet obj  (0 if no threatening bullets)
;*	A6 - X distance to bullet
NEAR_BUL:
	push	A9
	clr	A5		;A5 will be pointer to nearest bullet
	move	@PLAYER_BULLETS,A1,L
	jrz	NO_BULL
	movi 1000,A6	;A6 is distance of nearest bullet
	move	*A8(OZPOS),A4,W
	calla	GETANIX
	move	A0,A3
	subi	9,A3			;* 1/2 width of bullet (kluge to cmp w/ mid point)
	move	*A8(OYPOS),A7,W
	move	*A8(OSIZEY),A9,W
	add	A7,A9
	addk Y_NEAR,A9		;* clearance below feet
	subk	3*Y_NEAR,A7	;* clearance above head

BULL_LP:
	move	*A1(OXPOS),A2,W
	sub	A3,A2
	jrgt	BULL_RGT
	;* Bullet on the left
	move	*A1(OXVEL+16),A0,W
	jrn	BULL_MIS	
	jruc	BULL_XOK
BULL_RGT:
	move	*A1(OXVEL+16),A0,W
	jrp	BULL_MIS	

BULL_XOK:
	abs	A2		;A2 is X distance from bullet
	cmp	A6,A2	;is this bullet closer than last?	
	jrge	BULL_MIS

;* check if Z rng is ok
	move	*A1(OZPOS),A0,W
	sub	A4,A0
	abs	A0
	cmpi	15,A0
	jrgt BULL_MIS
;* check Y rng
	move	*A1(OYPOS),A0,W
	cmp	A7,A0
	jrlt	BULL_MIS	;* bullet will pass above head
	cmp	A9,A0
	jrgt	BULL_MIS	;* bullet will	pass below feet

GOT_BULL:
	move	A1,A5	;new closest bullet
	move	A2,A6	;new distance
BULL_MIS:
	move	*A1(OSLINK),A1,L	;* get next bullet and try again
	jrnz	BULL_LP
NO_BULL:
	pull	A9
	rets
*******************************************************************

**************************************************************************
FACINGOB:
;* ptr to obj in A0
;* enemy in A8
;* return setc if facing object
	move	*A0(OSIZEX),A1,W
	srl	1,A1
	move	*A0(OXPOS),A0,W
	add	A0,A1
	calla	GETANIX
	sub	A0,A1		;A1 = objX - Xpos
	move	*A8(OFLAGS),A0,W
	andi	M_FLIPH,A0
	jrz	SkFlpN
	neg	A1
SkFlpN:
	move	A1,A1
	jrp	ISFACING

	clrc
	rets

ISFACING:
	setc
	rets
**************************************************************************

**************************************************************************
FACEOBJ:
;* ptr to obj in A0
;* enemy in A8
;** make Enemy face object
	move	*A0(OSIZEX),A1,W
	srl	1,A1
	move	*A0(OXPOS),A0,W
	add	A0,A1
	calla	GETANIX
	cmp	A1,A0
	jrgt	T_YFLP
	jruc	T_NOYFLP
**************************************************************************

**************************************************************************
FaceObj:
;* ptr to obj in A0
;* enemy in A8
;** make Enemy face object if fliptiks allow...
	move	*A0(OSIZEX),A1,W
	srl	1,A1
	move	*A0(OXPOS),A0,W
	add	A0,A1
	calla	GETANIX
	cmp	A1,A0
	jrgt	Ck_YFLP
	jruc	Ck_NOYFLP
**************************************************************************

**************************************************************************
FACEBULL:
;* ptr to bullet in A0
;* enemy in A8
;** make Enemy face object
	movb	*A0(OXVEL+24),A1
	jrnn	T_YFLP
	jruc	T_NOYFLP
**************************************************************************

**************************************************************************
FACEAWAY:
;* ptr to obj in A0
;* enemy in A8
;** make Enemy face away from object
	mmtm	SP,A0,A1
	move	*A0(OSIZEX),A1,W
	srl	1,A1
	move	*A0(OXPOS),A0,W
	add	A0,A1
	calla	GETANIX
	cmp	A1,A0
	mmfm	SP,A0,A1
	jrlt	T_YFLP
	jruc	T_NOYFLP
**************************************************************************

**************************************************************************
FACEFWD:
;* enemy obj in A8
;** make Enemy face Forward
	move	*A8(OXVEL+16),A0,W
	jrn	T_YFLP
	jruc	T_NOYFLP
**************************************************************************

**************************************************************************
FACEBKWD:
;* enemy obj in A8
;** make Enemy face Backward
	move	*A8(OXVEL+16),A0,W
	jrn	T_NOYFLP
	jruc	T_YFLP
**************************************************************************

**************************************************************************
NEARPLYR:
;Get disp obj of nearest person to shoot at
; RETURNS	A0 - ptr to disp obj or Zero (with Z flag set)
; DESTROYS A1,A2,A3,A4,A5
	clr	A4			;* A4 is ptr to player to chase
	movi	1000,A5		;* X distance to first player
	move	*A8(OZPOS),A2,W
	move	*A8(OXPOS),A3,W
	movi	P1DATA,A0
	move	*A0(POBJ),A0,L
	jrz	TRYP2
	move	*A0(OZPOS),A1,W
	sub	A2,A1
	abs	A1
	cmpi	18,A1
	jrgt	TRYP2
	move	A0,A4
	move	*A0(OXPOS),A5,W
	sub	A3,A5
	abs	A5
TRYP2:
	movi	P2DATA,A0
	move	*A0(POBJ),A0,L
	jrz	WhichP
	move	*A0(OZPOS),A1,W
	sub	A2,A1
	abs	A1
	cmpi	20,A1
	jrgt	WhichP
	move	*A0(OXPOS),A1,W
	sub	A3,A1
	abs	A1
	cmp	A5,A1
	jrgt	WhichP
	move	A0,A4	   ;* player 2 is closer
WhichP:
	move	A4,A0
	rets
**************************************************************************

**************************************************************************
ClosestP:
;* return A0 - the object pointer of the Closest Player
	mmtm	SP,A1,A2,A3,A4,A5,A6
	move	*A8(OXPOS),A2,W
	move	*A8(OZPOS),A3,W

	movi	>7FFF,A4		;so P2 can be selected if no P1
	movi	P1DATA,A1
	move	*A1(POBJ),A1,L
	jrz	TryP2

	move	*A1(OXPOS),A4,W
	move	*A1(OZPOS),A5,W
	sub	A2,A4
	sub	A3,A5
	abs	A4
	abs	A5
	add	A5,A4

TryP2:
	movi	P2DATA,A0
	move	*A0(POBJ),A0,L
	jrz	ItsP1

	move	*A0(OXPOS),A6,W
	move	*A0(OZPOS),A5,W
	sub	A2,A6
	sub	A3,A5
	abs	A6
	abs	A5
	add	A5,A6

	cmp	A4,A6
	jrle	GotCP

ItsP1:
	move	A1,A0
GotCP:
	mmfm	SP,A1,A2,A3,A4,A5,A6
	rets
**************************************************************************


**************************************************************************
ClosestFP:
;* return A0 - the object pointer of the Closest Player	that is being faced.
;		0 if neither player is being faced.

	mmtm	SP,A1,A2,A3,A4,A5,A6,A7
	move	*A8(OXPOS),A2,W
	move	*A8(OZPOS),A3,W

	movi	>7FFF,A4		;so P2 can be selected if no P1
	movi	P1DATA,A1
	move	*A1(POBJ),A1,L
	jrz	NotP1
	
	move	*A1(OXPOS),A4,W
	sub	A2,A4
	;* are we facing this player
	jrn	PonLft1
	;player is to the right
	move	*A8(OFLAGS),A7,W
	btst	B_FLIPH,A7
	jrnz	NotP1
	jruc	Fok1
PonLft1:
	move	*A8(OFLAGS),A7,W
	btst	B_FLIPH,A7
	jrz	NotP1
Fok1:

	move	*A1(OZPOS),A5,W
	sub	A3,A5
	abs	A4
	abs	A5
	add	A5,A4
	jruc	FTryP2
NotP1:
	clr	A1
FTryP2:
	movi	P2DATA,A0
	move	*A0(POBJ),A0,L
	jrz	FItsP1

	move	*A0(OXPOS),A6,W
	sub	A2,A6
	;* are we facing this player
	jrn	PonLft2
	;player is to the right
	move	*A8(OFLAGS),A7,W
	btst	B_FLIPH,A7
	jrnz	NotP2
	jruc	Fok2
PonLft2:
	move	*A8(OFLAGS),A7,W
	btst	B_FLIPH,A7
	jrz	NotP2
Fok2:

	move	*A0(OZPOS),A5,W
	sub	A3,A5
	abs	A6
	abs	A5
	add	A5,A6

	cmp	A4,A6
	jrle	FGotCP

NotP2:
FItsP1:
	move	A1,A0
FGotCP:
	mmfm	SP,A1,A2,A3,A4,A5,A6,A7
	rets
**************************************************************************


****************************  Flee  **************************************
Flee:
;* Goes through DestTbl looking for the offset from the enemy which
;* places the enemy furthest from any players.  This offset is then
;* added to current coors to generate a dest, and course is set for the dest.

;* TRASHES B0,B1,B2,B3,B4,B5
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A11,A14

	move	A8,A7			;save pimps obj ptr

	;* stuff B2 = PIMP Z:X
	calla	GETANIX
	move	*A8(OZPOS),A1,W
	sll	16,A1
	movy	A1,A0
	move	A0,B2

	;* stuff A1 = Plyr1 Z:X
	movi	P1DATA,A8
	move	*A8(POBJ),A8,L
	jrz	NoP1
	calla	GETANIX
	move	*A8(OZPOS),A1,W
	sll	16,A1
	movx	A0,A1
	jruc	GetP2
NoP1:
	clr	A1

GetP2:
	;* stuff A2 = Plyr2 Z:X
	movi	P2DATA,A8
	move	*A8(POBJ),A8,L
	jrz	NoP2
	calla	GETANIX
	move	*A8(OZPOS),A2,W
	sll	16,A2
	movx	A0,A2
	jruc	GotP2
NoP2:
	clr	A2
GotP2:
	move	A7,A8			;restore pimps obj ptr

	;* stuff B3 = Top Left Z:X
	;* stuff B4 = Bot Right Z:X
	move	@(WORLDTLX+16),B3,W				 
	move	B3,B4
	move	@PLZMIN,B0,W
	sll	16,B0
	movy	B0,B3
	addi	511,B4
	move	@PLZMAX,B0,W
	sll	16,B0
	movy	B0,B4

	clr	A5		;Best distance for dest (big is good)
	movk	6,B0		;# times to check for flee dest
	movi	DestTbl,B5
	movk	12,A0
	calla	RANDU
	dec	A0
	sll	5,A0
	move	A0,B1
	add	B1,B5		;B5 1st entry in dest tbl to check
	
FleeLp:
	callr	GenFleeD	;rets dest in A0
	callr	EvFleeD		;rets A0 unchanged, A7 - dist to near plyr
	cmp	A5,A7
	jrle	NxtFD
	;* Got a Better Dest
	move	A0,A6
	move	A7,A5
NxtFD:
	dsjs	B0,FleeLp

	;* A6 is Best dest..
	move	A6,*A13(DEST),L
	move	*A13(FUNCS),A0,L
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A11,A14
	rets


;***************************
GenFleeD:
; generate a valid destination to flee toward.
; return as A0
;NEEDS	B2 - Pimp Z:X
;	B3 - playfield TL Z:X
;	B4 - playfield BR Z:X
;	B5 - DestTbl

	movk	5,A0	;Max # times to check for on screen

GetDstLp:
	dec	A0
	jrz	GotFD
	cmpi	DestTblX,B5
	jrnz	SkRstDT
	movi	DestTbl,B5
SkRstDT:
	move	*B5+,B1,L
	addxy	B2,B1	
	cmpxy	B3,B1	;Compare against TL
	jrxlt	GetDstLp
	jrylt	GetDstLp
	cmpxy	B4,B1	;Compare against BR
	jrxgt	GetDstLp
	jrygt	GetDstLp
GotFD:
	move	B1,A0
	rets

EvFleeD:
;* evaluate a flee destination
; the value is the nearest distance to a player
;  check distance at midpoint and endpoint..

;	A0 - flee dest
;	A1 - Plyr 1 Z:X
;	A2 - Plyr 2 Z:X
;	
;returns dist to nearest plyr in A7

	movi	>7FFF,A7
	move	A1,A14
	jrz	GetP2Dst
	subxy	A0,A14
	move	A14,A7
	sext	A7,W
	abs	A7
	sra	16,A14
	abs	A14
	add	A14,A7

GetP2Dst:
	move	A2,A14
	jrz	EvFDX
	subxy	A0,A14
	move	A14,A11
	sext	A11,W
	abs	A11
	sra	16,A14
	abs	A14
	add	A14,A11

	cmp	A11,A7
	jrle	EvFDX
	move	A11,A7

EvFDX:
	rets
**************************************************************************


**************************************************************************
FleeObj:
;* ptr to obj to flee in A0
	move	*A8(OXPOS),A1,W
	move	*A8(OZPOS),A2,W
	move	*A0(OXPOS),A3,W
	move	*A0(OZPOS),A4,W
	
	movi	100,A0
	calla	RANDU
	addi	50,A0
	move	A3,A5
	sub	A1,A5
	jrn	NoNegX
	neg	A0
NoNegX:
	add	A1,A0
	move	A0,A6	;A6 - New X Dest

	;* generate Z dest
	movi	40,A0
	calla	RANDU
	addk	20,A0
	move	A4,A5
	sub	A2,A5
	jrn	NoNegZ		
	neg	A0
NoNegZ:
	add	A2,A0
	
	move	@PLZMIN,A1,W
	addk	5,A1
	move	@PLZMAX,A2,W
	subk	5,A2
	cmp	A1,A0
	jrle	SetEvZ
	cmp	A2,A0
	jrlt	ZSet
SetEvZ:
;	add	A2,A1
;	srl	1,A1
;	move	A1,A0
	move	A1,B0
	move	A2,B1
	calla	RANGRAND
ZSet:
	sll	16,A0
	movx	A6,A0
	move	A0,*A13(DEST),L
	move	*A13(FUNCS),A0,L
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0
	rets
**************************************************************************

**************************************************************************
HuntObj:
;* chase after the object in WANTOBJ
	move	*A13(WANTOBJ),A0,L
HuntObj0:
	move	*A0(OXPOS),A1,W
	move	*A0(OSIZEX),A2,W
	srl	1,A2
	add	A2,A1
	move	*A0(OZPOS),A2,W
	sll	16,A2
	movy	A2,A1
	move	A1,*A13(DEST),L
	rets
**************************************************************************

**************************************************************************
ShortXDest:
;* reduce Xdes by amount in A0
	move	*A13(DEST),A1,W	;Get X portion of destination
	move	*A8(OXPOS),A2,W
	sub	A1,A2
	jrn	ShortOK
	neg	A0
ShortOK:
	sub	A0,A1		;reduce X destination
	move	A1,*A13(DEST),W
	rets
**************************************************************************

**************************************************************************
MAX:
;* returns max of A0,A1 in A0
	cmp	A1,A0
	jrge	GotMax
	move	A1,A0
GotMax:
	rets
**************************************************************************

**************************************************************************
MIN:
;* returns min of A0,A1 in A0
	cmp	A1,A0
	jrle	GotMin
	move	A1,A0
GotMin:
	rets
**************************************************************************

**************************************************************************
ABSMAX:
;* returns A1 Clipped at the value A0 in either pos or neg direction
;parm A0 must be pos
;A0 will be negated if A1 is neg
	move	A1,A1
	jrn	NegMax
	cmp	A0,A1
	jrle	MAXOK
	move	A0,A1
	rets
NegMax:
	neg	A0
	cmp	A0,A1
	jrge	MAXOK
	move	A0,A1
MAXOK:
	rets
**************************************************************************

**************************************************************************
ABSINC:
	move	A0,A0
	jrn	DECX
	inc	A0
	rets
DECX:
	dec	A0
	rets
**************************************************************************

**************************************************************************
ABSDEC:
	move	A0,A0
	jrz	ABSDECX
	jrn	INCX
	dec	A0
	rets
INCX:
	inc	A0
ABSDECX:
	rets
**************************************************************************

**************************************************************************
ABSSUB:
;* absolutely subtracts A1 from A0, A0 can't change signs
	move	A0,A0
	jrz	ABSSUBX
	jrn	SUBX
	sub	A1,A0
	jrp	SUBX1
	clr	A0
SUBX1:
	rets
SUBX:
	add	A1,A0
	jrn	SUBX2
	clr	A0
SUBX2:
ABSSUBX:
	rets
**************************************************************************

**************************************************************************
ABSADD:
;* absolutely ADD A1 to A0
	move	A0,A0
	jrn	ADDX
	add	A1,A0
	rets
ADDX:
	sub	A1,A0
	rets
**************************************************************************

**************************************************************************
XTOZSIZE:
	mmtm	SP,A0,A1
	move	*A8(OSIZEX),A0,W
	srl	1,A0
	move	A0,A1
	sll	16,A1
	add	A1,A0
	move	A0,*A8(OZSIZ),L
	mmfm	SP,A0,A1
	rets
**************************************************************************

**************************************************************************
ClrVel:
	clr	A0
	move	A0,*A8(OXVEL),L
	move	A0,*A8(OYVEL),L
	move	A0,*A8(OZVEL),L
	rets
**************************************************************************

*************************************************************************
UpdShadV:
	mmtm	SP,A0,A1
	move	*A8(OSHAD),A0,L
	jrz	UpdShX
	move	*A8(OXVEL),A1,L
	move	A1,*A0(OXVEL),L
	move	*A8(OZVEL),A1,L
	move	A1,*A0(OYVEL),L
	move	A1,*A0(OZVEL),L
UpdShX:
	mmfm	SP,A0,A1
	rets
*************************************************************************

*************************************************************************
;* This routine looks for the nearest object of type obj Id
;* PARMS:
;*	A0 - Obj Id
;* NEAR_OBJ entry pt, A1 - SLIST to search
;* RETURNS:
;*	A0 - ptr to obj  (0 if no close objs)
NEAR_BTY:
	move	@BOOTY,A1,L
NEAR_OBJ:
	move	A1,A1
	jrz	NOBOOTY
	clr	A5		;A5 will be pointer to nearest obj
	move	A0,A3
	zext	A3,W		;A3 obj ID
	movi	1000,A6	;A6 is distance of nearest booty
	calla	GETANIX
BOOTY_LP:
	move	*A1(OID),A2,W
	zext	A2,W
	cmp	A2,A3
	jrnz	BOOTYMIS
	move	*A1(OPLINK),A2,L  ;if booty has a proc (flying), skip it..
	jrnz	BOOTYMIS
	move	*A1(OXPOS),A2,W
	sub	A0,A2
	abs	A2
	cmp	A6,A2
	jrgt	BOOTYMIS
GOTBOOTY:
	move	A1,A5	;new closest booty
	move	A2,A6	;new distance
BOOTYMIS:
	move	*A1(OSLINK),A1,L	;* get next item and try again
	jrnz	BOOTY_LP
BOOTYX:
	move	A5,A0
	jrz	NOBOOTY
	setc
	rets
NOBOOTY:
	clrc
	rets
*******************************************************************

*************************************************************************
;* Check if obj A0 is on supplemental list A1
;* PARMS:
;*	A0 - Obj ptr, A1 - supplemental list
;* RETURNS:
;*	setc if obj on list
ON_SLIST:
	move	A1,A1
	jrz	OffList
CK_LP:
	cmp	A0,A1
	jrz	OnList
	move	*A1(OSLINK),A1,L	;* get next item and try again
	jrnz	CK_LP
OffList:
	clrc
	rets
OnList:
	setc
	rets
*******************************************************************

*******************************************************************
CLROBJ:
	mmtm	SP,A1,A2,A3
	move	A0,A1
	movi	OBSIZ/16,A2
	clr	A3
ClrObjLp:
	move	A3,*A1+,W
	dsjs	A2,ClrObjLp
	mmfm	SP,A1,A2,A3
	rets
*******************************************************************

*******************************************************************
BullSlp:
;* generate Sleep Time for Bullet Before striking wall or
;* Going off bottom of screen
;* PARMS A0 - MAX Sleep Time if Bullet doesn't hit wall or go off screen
;* RETS A0 - SLEEP TIME
;	A11 - cleared if bullet doesn't strike bgnd wall, else set

	mmtm	SP,A1,A2,A3
	clr	A11	;A11 set if bullet strikes bgnd
	move	*A8(OZVEL),A1,L
	move	A1,A2
	abs	A2
	srl	8,A2
	jrz	GotBSlp
	move	A1,A1
	jrn	BHitWall

	;* bullet going off Bot of Screen
	move	@PLZMAX,A3,W
	addi	60,A3
	move	*A8(OZPOS),A1,W
	sub	A1,A3
	jruc	CalcBSlp

BHitWall: ;* bullet has neg Z, it will hit the wall
	movk	1,A11	;hit wall flag
	move	*A8(OZPOS),A3,W
	move	@PLZMIN,A1,W
	sub	A1,A3

CalcBSlp:
	sll	16,A3
	divu	A2,A3
	srl	8,A3
	cmp	A0,A3
	jrls	SkUseMax
	clr	A11	;clear wall hit flag
	move	A0,A3
SkUseMax:
	move	A3,A0
GotBSlp:
	mmfm	SP,A1,A2,A3
	rets
*******************************************************************

*******************************************************************
SyncAnim:
;PARMS	A0 ptr to animation script
;	A1 # tiks of anim to skip
;RETURNS A0 ptr to frame to be animated
;	 A1 # tiks to sleep on that frame
	mmtm	SP,A7,A9,A10,A11
	move	A0,A10
	clr	A7
FrstFrme:
	move	A10,A9
GetSlpLp:
	move	*A9,A0,L	;FRAME
	jrnz	GotNxtFr
AniDcLp:
	cmp	A7,A1
	jrlt	FrstFrme
	sub	A7,A1
	jruc	AniDcLp
GotNxtFr:
	move	A9,A11		;hang onto frame ptr
	addk	32,A9
	move	*A9+,A0,W		;BITS|Sleep Time
	btst	BSPAWNP,A0
	jrz	SPAWNSk1
	addi	>50,A9
SPAWNSk1:
	btst	BFLIPBIT,A0
	jrz	FLIPSk1
	addi	16,A9
FLIPSk1:
	btst	BNEWPAL,A0
	jrz	PALSk1
	addk	16,A9
PALSk1:
	andi	>FFF,A0
	cmp	A1,A0
	jrgt	GotFrm
	sub	A0,A1
	add	A0,A7
	jruc	GetSlpLp
GotFrm:
	sub	A1,A0
	move	A0,A1		;sleep for remaining tiks of frame
	move	A11,A0		;get ptr to the frame
	mmfm	SP,A7,A9,A10,A11
	rets
*******************************************************************

*******************************************************************
SumSlp:
;PARMS	A0 ptr to animation script
;RETURNS  A0 sum of sleep times for animation script
	mmtm	SP,A1,A9
	move	A0,A9
	clr	A1			;A1	sum up sleep times
SlpSumLp:
	move	*A9+,A0,L		;FRAME
	jreq	SlpSumX		;BR = END WAS HIT
	move	*A9+,A0,W		;BITS|Sleep Time
	btst	BSPAWNP,A0
	jrz	SPAWNSk
	addi	>50,A9
SPAWNSk:
	btst	BFLIPBIT,A0
	jrz	FLIPSk
	addi	16,A9
FLIPSk:
	btst	BNEWPAL,A0
	jrz	PALSk
	addk	16,A9
PALSk:
	andi	>FFF,A0
	add	A0,A1
	jruc	SlpSumLp
SlpSumX:
	move	A1,A0
	mmfm	SP,A1,A9
	rets
*******************************************************************


*******************************************************************
SPLTCOLBOX:
	.WORD	B1OID|BULLETID
	.LONG	SPLTCOL0
	.WORD	B1OID|ROCKETID
	.LONG	SPLTCOL0
	.WORD	B2OID|BULLETID
	.LONG	SPLTCOL0
	.WORD	B2OID|ROCKETID
	.LONG	SPLTCOL0
	.WORD	0
	.LONG	DUMRTSG
*******************************************************************
*MAKE MORE BLOOD COLLSION ROUTINE
*A0 = PTR TO ENEMY OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
SPLTCOL0:
	MOVE	*A8(OID),A11,W		
	move	*A8(OYPOS),A9,W
	MOVI	0EDh,A1
	movi	SPLATBOX,A7
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER
	CALLA	GETPRC

	CLRC		;Don't delete in Coll routine
	rets
*******************************************************************

*******************************************************************
SPLTCOLANI:
	.WORD	B1OID|BULLETID
	.LONG	SPLTCOL1
	.WORD	B1OID|ROCKETID
	.LONG	SPLTCOL1
	.WORD	B2OID|BULLETID
	.LONG	SPLTCOL1
	.WORD	B2OID|ROCKETID
	.LONG	SPLTCOL1
	.WORD	0
	.LONG	DUMRTSG
*******************************************************************
*MAKE MORE BLOOD COLLSION ROUTINE
*A0 = PTR TO ENEMY OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
SPLTCOL1:
	MOVE	*A8(OID),A11,W		
	move	*A8(OYPOS),A9,W
	MOVI	0EDh,A1
	movi	SPLATANI,A7
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER
	CALLA	GETPRC

	CLRC		;Don't delete in Coll routine
	rets
*******************************************************************

**************************************************************************
* BLOOD SPLATTER PROCESS x positioning on animation pt.
* A8 = Obj ptr of guy hit
* A9 = Y POS of killer
* A11 - OID of killer
SPLATANI:
	ADJUST	ADJGORE
	JRNZ	NOSPLAT

	move	A8,A10			;keep ptr to victims obj
	SLL	28,A11
	SRL	28,A11
	CMPI	ROCKETID,A11,W
	JREQ	NOSPLAT			;DEATH BY ROCKET
	CMPI	EXPLODID,A11,W
	JREQ	NOSPLAT			;DEATH BY EXPLOSION
	calla	GETOBJ
	jrz	NOSPLAT
	movi	SPLTINIT,A14
	calla	STFOBJ
	move	A0,A8
	move	A9,*A8(OYPOS),W
	move	*A10(OYPOS),A1,W
	sub	A1,A9
	sll	16,A9
	move	*A10(OSIZEY),A1,W
	divu	A1,A9
	move	A9,A11
	clr	A9
	move	A9,*A8(OPAL),W
	
	clr	A0
	move	A0,*A8(OZPOS),W
	move	A0,*A8(OXPOS),W
	movb	A0,*A13(ANIMTIKS)
	movi	BSPLAT,A9
	move	A8,A0
	calla	INSOBJ
SpltLp:
	move	*A10(OZPOS),A1,W
	inc	A1
	move	*A8(OZPOS),A3,W
	jrz	StfZ0
	sub	A1,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX
StfZ0:
	move	A1,*A8(OZPOS),W
	move	A8,A7
	move	A10,A8
	calla	GETANIX
	move	A7,A8
	move	*A8(OSIZEX),A2,W
	srl	1,A2
	sub	A2,A0
	move	*A8(OXPOS),A3,W
	jrz	StfX0
	sub	A0,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX
StfX0:
	move	A0,*A8(OXPOS),W
	move	*A10(OSIZEY),A1,W
	mpyu	A11,A1
	srl	16,A1
	move	*A10(OYPOS),A2,W
	add	A2,A1
	move	*A8(OSIZEY),A2,W
	srl	1,A2
	sub	A2,A1
	move	*A8(OYPOS),A3,W
	sub	A1,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX
	move	A1,*A8(OYPOS),W

	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrz	SpltX
AnimX:
	dec	A0
	movb	A0,*A13(ANIMTIKS)
	movk	1,A0
	calla	PRCSLP
	jruc	SpltLp

SpltX:
	move	A8,A0
	calla	DELOBJ
NOSPLAT:
	DIE
**********************************************************************

**************************************************************************
* BLOOD SPLATTER PROCESS X positioning on middle of frames
* A8 = Obj ptr of guy hit
* A9 = Y POS of killer
* A11 - OID of killer
SPLATBOX:
	ADJUST	ADJGORE
	JRNZ	NOSPLAT1

	move	A8,A10			;keep ptr to victims obj
	SLL	28,A11
	SRL	28,A11
	CMPI	ROCKETID,A11,W
	JREQ	NOSPLAT1			;DEATH BY ROCKET
	CMPI	EXPLODID,A11,W
	JREQ	NOSPLAT1			;DEATH BY EXPLOSION
	calla	GETOBJ
	jrz	NOSPLAT1
	movi	SPLTINIT,A14
	calla	STFOBJ
	move	A0,A8
	move	A9,*A8(OYPOS),W
	move	*A10(OYPOS),A1,W
	sub	A1,A9
	sll	16,A9
	move	*A10(OSIZEY),A1,W
	divu	A1,A9
	move	A9,A11
	clr	A9
	move	A9,*A8(OPAL),W
	
	clr	A0
	move	A0,*A8(OZPOS),W
	move	A0,*A8(OXPOS),W
	movb	A0,*A13(ANIMTIKS)
	movi	BSPLAT,A9
	move	A8,A0
	calla	INSOBJ
SpltLp1:
	move	*A10(OZPOS),A1,W
	inc	A1
	move	*A8(OZPOS),A3,W
	jrz	StfZ1
	sub	A1,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX1
StfZ1:
	move	A1,*A8(OZPOS),W
	move	*A10(OXPOS),A1,W
	move	*A10(OSIZEX),A2,W
	srl	1,A2
	add	A2,A1
	move	*A8(OSIZEX),A2,W
	srl	1,A2
	sub	A2,A1
	move	*A8(OXPOS),A3,W
	jrz	StfX1
	sub	A1,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX1
StfX1:
	move	A1,*A8(OXPOS),W
	move	*A10(OSIZEY),A1,W
	mpyu	A11,A1
	srl	16,A1
	move	*A10(OYPOS),A2,W
	add	A2,A1
	move	*A8(OSIZEY),A2,W
	srl	1,A2
	sub	A2,A1
	move	*A8(OYPOS),A3,W
	sub	A1,A3
	abs	A3
	cmpi	64,A3
	jrgt	SpltX1
	move	A1,*A8(OYPOS),W

	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX1
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrz	SpltX1
AnimX1:
	dec	A0
	movb	A0,*A13(ANIMTIKS)
	movk	1,A0
	callA	PRCSLP
	jruc	SpltLp1

SpltX1:
	move	A8,A0
	calla	DELOBJ
NOSPLAT1:
	DIE
**********************************************************************

**************************************
* STATIC BLOOD SPLATTER PROCESS
* A9 = Y:X OFFSET FROM KILLER OBJECT
* A8 = killer OBJECT
**************************************
SPLATS:
	ADJUST	ADJGORE
	JRNZ	NOSPLATS
	CALLA	GETANIXY
	SRL	16,A3
	ADDXY	A9,A2
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JREQ	SPLATS0
	NEG	A9
SPLATS0:
	ADDXY	A9,A3
	MOVY	A2,A3
	calla	GETOBJ
	jrz	NOSPLATS
	movi 	SPLTINIT,A14
	calla	STFOBJ
	MOVE	*A8(OZPOS),A1,W
	ADDI	6,A1
	MOVE	A1,*A0(OZPOS),W
	move	A0,A8
	MOVE	A3,A0
	MOVE	*A8(OSIZEX),A1
	SRL	1,A1
	SUB	A1,A0		;SUBTRACT 1/2 WIDTH
	MOVE	A0,*A8(OXPOS),W
	SRL	16,A3
	MOVE	A3,*A8(OYPOS),W
	clr	A9
	move	A9,*A8(OPAL),W
	
	move	A8,A0
	calla	INSOBJ
	movi	BSPLAT,A9
	movk	1,A1			;DO IT UNTIL THE END
	jsrp	FRANIM
	move	A8,A0
	calla	DELOBJ
NOSPLATS:
	DIE
**********************************************************************


*************************************************************************
;* THESE ROUTINES WILL PUT THE BONUS OUT CENTERED ON THE BOTTOM OF THE
;* OBJECT IN A8
; ptr to player data in A2
PUT1K:
	mmtm	SP,A0,A1,A7,A8,A9,A10,A11
	movi	K1IMG,A11
	jruc	MAKEBON
PUT2x5K:
	mmtm	SP,A0,A1,A7,A8,A9,A10,A11
	movi	K2x5IMG,A11
	jruc	MAKEBON
PUT5K:
	mmtm	SP,A0,A1,A7,A8,A9,A10,A11
	movi	K5IMG,A11
	jruc	MAKEBON
PUT10K:
	mmtm	SP,A0,A1,A7,A8,A9,A10,A11
	movi	K10IMG,A11
	jruc	MAKEBON
PUT25K:
	mmtm	SP,A0,A1,A7,A8,A9,A10,A11
	movi	K25IMG,A11
;	jruc	MAKEBON
MAKEBON:
	calla	GETANIX
	move	A0,A9
	move	*A8(OYPOS),A10,W
	move	*A8(OSIZEY),A0,W
	srl	1,A0
	add	A0,A10

	move	A2,A8
	CREATE	INDPID,PUTBONUS

	mmfm	SP,A0,A1,A7,A8,A9,A10,A11
	rets
*************************************************************************

*************************************************************************
PUTBONUS:
;PARMS
; A8 ptr to player data
; A9-XPOS for center of bonus
; A10-YPOS for top of bonus
; A11-ptr to frame to use for bonus
	move	A8,A2
	;* create bonus image
	calla	GETOBJ
	jrz	BONUSX
	move	A0,A8
	movi	BONINIT,A14
	calla	STFOBJ
	move	A13,*A0(OPLINK),L

	;* allocate palette
	MOVI	NARCS,A0
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	jrz	NoPal
	MOVE	A0,*A8(OPAL),W

	movi	>8000|M_WRNONZ|M_NOCOLL,A4
	move	A11,A1	
	calla	ANI

	;Set The Coors
	move	*A8(OSIZEX),A0,W
	srl	1,A0
	sub	A0,A9
	move	A9,*A8(OXPOS),W
	move	A10,*A8(OYPOS),W
	movi	1000,A0
	move	A0,*A8(OZPOS),W

	move	A8,A0
	calla	INSOBJ

	movi	120,A4
	jsrp	FLYTOPL

	;* delete bonus image
	move	*A8(OPAL),A0,W
	calla	FREEPAL
	move	A8,A0
	calla	DELOBJ
BONUSX:
	DIE
NoPal:
	;* must free the obj
	move	A8,A0
	calla	FREEOBJ
	jruc	BONUSX
*************************************************************************

**************************************************************************
*                                                                        *
* FLYTOPL - SEND AN OBJECT TO THE PLAYER STATUS AREA.			 *
* A2 = PTR TO PLAYER DATA						 *
* A4 = TRAVEL TIME IN TICKS						 *
* A8 = PTR TO OBJECT							 *
* RETURNS WHEN THE OBJECT HAS MADE IT.					 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
FLYTOPL
	PUSHP	A2
	CALLA	PSTOP
	MOVE	*A2(PSCRAD),A3,L	;SET UP FOR EFFECT

	MOVE	A8,A0
	CALLA	GSCRNREL
	SRL	16,A1
	MOVX	A1,A2
	CALLA	SLINEVEL		;GET THE VELOCITIES
FLYTOP1
	MOVE	A1,*A8(OXVEL),L
	MOVE	A2,*A8(OYVEL),L		;STUFF THE VELOCITIES
	MMTM	A12,A1,A2
	MOVE	A8,A0
	CALLA	SCRNRELV		;MAKE THE VELOCITIES SCREEN RELATIVE
	SLEEP	1
	MMFM	A12,A1,A2
	CALLA	SCRTST			;CHECK FOR OFF SCREEN
	JREQ	FLYTOP1
	PULLP	A2
	RETP
**************************************************************************


SPLTINIT:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	blood1,0,DUMCOLL
	.WORD	DMAWNZ,JUNKOID
	.LONG	0
BONINIT:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	K1IMG,0,DUMCOLL
	.WORD	DMAWNZ,JUNKOID
	.LONG	0



BSPLAT:
	.long	blood1
	.word	6
	.long	blood2
	.word	6
	.long	blood3a
	.word	6
	.long	blood2
	.word	6
	LONGNULL

DestTbl:
	;*  x offset, z offset
	.word	 80,  0
	.word	-80,  0
	.word	 60, 20
	.word	 60,-20
	.word	-60, 20
	.word	-60,-20
	.word	 60, 40
	.word	 60,-40
	.word	-60, 40
	.word	-60,-40
	.word	  0, 60
	.word	  0,-60
DestTblX:
