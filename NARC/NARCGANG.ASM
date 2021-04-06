 	.FILE	'NARCGANG.ASM'
	.TITLE	" <<< N  A  R  C  -- GANGSTER >>>"

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
	.INCLUDE	"NARCFRAG.GLO"

	.include	"narcgang.tbl"
	.GLOBL	GANGCRM1

	.bss	gangcol,16,1

MAXGANG	.set	9
BCMD	.set	MAXGANG*32

;BOSS process block offsets
BIDLEANI .set	ETEMP1
;ACTION	.set	ETEMP2+16	;set in narctequ
BSYNC	.set	ETEMP3		;* sync counter - word
BHOME	.set	ETEMP3+16	;* homing tick ctr
BZXPOS	.set	ETEMP4
BXPOS	.set	ETEMP4
BZPOS	.set	ETEMP4+16
BVICT	.set	ETEMP5		;* ptr to players data block 
BFORM	.set	ETEMP6

;valide actions
IDLEACT	.set	0
FIREACT	.set	1

********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in VARINIT
;	.BSS	gangbmax,16,16		;U - # of active bosses 
;	.BSS	gangrock,16,16		;U - chance/1000 of gangster having a rocket
;	.BSS	gangmgun,16,16		;U - (clips*gangmgun)/1000 chance of machine gunning
;	.BSS	gangfrck,16,16		;U - (clips*gangmgun)/1000 chance of machine gunning
	.BSS	gangclip,16,16		;U - chance/1000 of gangster having a clip

	.TEXT
VARINIT:
	movi	130,A0
	move	A0,@gangclip,W
	rets
	movi	400,A0
	move	A0,@gangmgun,W
	movi	300,A0
	move	A0,@gangfrck,W
	movk	1,A0
	move	A0,@gangbmax,W
	movi	220,A0
	move	A0,@gangrock,W
	rets
**********************************************************

************************* FUNCTION TABLE ***************************
GANGFUNCS:
	.long	BOOF
	.long	GoDestV
	.long	GetXVel
	.long	>FFFF	;MaxXZAngle - can move on 45 degree angle
	.long	20	;FlipTiks
********************************************************************
********************************************************************
;To catch a nulled dereference through GANGFUNCS
BOOF:	jruc	$
********************************************************************

**************************************************************************
; GANGSTER SUB_TYPES
; NOTE!!!!  -- right now, gangsters ignore their starting coors
;		but I will fix this eventually...
; All gangsters start ~200 pixels off screen, 70% chance of coming
; up to the right.

;SUB_TYPE bits
; Bit 0 - set to dodge bullets	
M_GTDODG	.set	>0001
; Bit 2 -
; Bit 3 -

DTBL:
	.long	D0,D0,D0
	.long	D0,D0,D0,D0,D0,D0
	.long	D0,D0,D0,D0,D0,D0,D0
**************************************************************************

**************************************************************************
GANGCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT
	
	move	@SLPGANGS,A0,W
	cmpi	3,A0
	jrge	ColdX

	move	A5,A9		;Y:X in A9
	move	A6,A10		;0:Z in A10
	move	A14,A11		;ID in A11
	CREATE	GANGBPID,GANGBOSS ;allocate process?	(bashes A1,A7)
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets
**************************************************************************

**************************************************************************
CkPal:
	move	@gangcol,A0,W
	jrz	CkPalX
	sll	5,A0
	addi	GANGPALS,A0
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

**************************************************************************
Cstagger	.set	1
Cclrdest	.set	2
Cgrab		.set	3
CMDTBL:
	.LONG	0,STAGGER,ClrDest,GoGrab
**************************************************************************

**************************************************************************
;* CMDTBL index in A0
CmdAll:
	move	A10,A1
	addi	BCMD,A1
	movk	MAXGANG,A2
StuffCmd:
	movb	*A1,A0
	cmpi	Cgrab,A0
	jreq	SkStfCmd
	movb	A0,*A1
SkStfCmd:
	addk	8,A1
	dsjs	A2,StuffCmd
	rets
**************************************************************************

**************************************************************************
;* CMDTBL index in A0
;* gangster to command in A1
CmdOne:
	sll	3,A1
	add	A10,A1
	addi	BCMD,A1
	movb	A0,*A1
	rets
**************************************************************************

**************************************************************************
;* this routine is to be called by a gangster to check if he is commanded
CkCmd:
	mmtm	SP,A10
	move	*A13(BOSS),A0,L	
	calla	GETA10
	addi	BCMD,A10
	movb	*A13(GNUM),A1
	sll	3,A1		;* indexing through bytes
	add	A1,A10
	movb	*A10,A1
	jrz	NoCmd
	sll	5,A1		;* indexing through table of addresses
	addi	CMDTBL,A1,L
	move	*A1,A0,L	;* return command in A0
	mmfm	SP,A10
	setc
	rets
NoCmd:
	mmfm	SP,A10
	clrc
	rets
**************************************************************************

**************************************************************************
;* this routine is to be called by a gangster to clear his command
ClrCmd:
	mmtm	SP,A10
	move	*A13(BOSS),A0,L	
	calla	GETA10
	addi	BCMD,A10
	movb	*A13(GNUM),A1
	sll	3,A1		;* indexing through bytes
	add	A1,A10
	clr	A0
	movb	A0,*A10
	mmfm	SP,A10
	rets
**************************************************************************

**************************************************************************
BossMove	$MACRO
	move	*A13(BZXPOS),A0,L
	addxy	A1,A0
	move	A0,*A13(BZXPOS),L
	$END

SetAnim	$MACRO	ANISCRIPT
	movi	:ANISCRIPT:,A1
	move	A1,*A13(ANIMPTR),L
	$END

SetForm	$MACRO	FORM
	movi	:FORM:,A1
	move	A1,*A13(BFORM),L
	$END
**************************************************************************


*********************  START OF GANGBOSS PROCESS  *************************
GANGBOSS:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

	INCW	@SLPGANGS
MaxWait:
	move	@gangbmax,A0,W
	move	@GANGCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	DECW	@SLPGANGS
	INCW	@GANGCNT

	clr	A0
	move	A0,@gangcol,W

	move	A11,A0
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	DTBL,A0
	move	*A0,A0,L
	jump	A0

***********************************************************************
D15:
;* CRIME SCENE


***********************************************************************
D2:
	jruc	DMain

***********************************************************************
D1:
	jruc	DMain

***********************************************************************
D0:
;	jruc	DMain
	

DMain:
	mmtm	A12,A9,A10	;Y:X in A9, 0:Z in A10

	CALLA	GETOBJ		;GET AN OBJECT BLOCK
	jrz	BOSSXX
	move	A0,A10		;A10 - ptr to extra space
	calla	CLROBJ

	;* initialize BOSS'S VARS
	clr	A0
	callr	CmdAll
	clr	A0
	move	A0,*A13(BVICT),L
	movb	A0,*A13(BHOME)
	movb	A0,*A13(ACTION)

	;* Determine Start Pattern to use
	jruc	Side
PickStrt:
;* can we use wall start??
	move	@PLZMIN,A3,W
	addi	75,A3
	movi	P1DATA,A0
	move	*A0(POBJ),A0,L
	jrz	CkP2
	move	*A0(OZPOS),A1,W
	cmp	A3,A1
	jrlt	NoWall
CkP2:
	movi	P2DATA,A0
	move	*A0(POBJ),A0,L
	jrz	Wall
	move	*A0(OZPOS),A1,W
	cmp	A3,A1
	jrlt	NoWall
Wall:
	movi	WallStrt,A2  ;A2 - routine to jump to for start
	jruc	GotStrt
NoWall:
	callr	DumpScan	
	jrnc	Side
	move	A0,A11
	movi	DumpStrt,A2
	jruc	GotStrt
Side:
	movi	SideStrt,A2
	jruc	GotStrt

	SLEEP	30
	jruc	PickStrt
GotStrt:


;*********************** BOSS DISPATCHING GANGSTERS ************************
	move	A11,A0
	sll	12,A0
	srl	28,A0
	jrz	SkRndCnt
	calla	RANDU
SkRndCnt:
	move	A11,A3
	sll	8,A3
	srl	28,A3
	add	A0,A3		;A3 - # to dispatch
	cmpi	MAXGANG,A3
	jrle	MAXGOK
	movi	MAXGANG,A3
MAXGOK:

DISPATCH:
	clr	A4		;A4 - number of gangsters dispatched
	move	A10,A6		;A6 - for stuffing child ptrs
GANGB_LP:
	cmp	A4,A3
	jreq	GANG_OUT

	move	@OVERLOAD,A0		;check system load					 
	cmpi	4,A0							 
	jreq	GANG_OUT
	CREATE	GANGEPID,GANGSTER	;allocate process?	(bashes A1,A7)
	jrz	GANG_OUT
	move	A13,*A0(BOSS),L		;* Tell em who's BOSS
	movb	A4,*A0(GNUM)		;* Give em an ID
	inc	A4
	move	A0,*A6+,L
	jruc	GANGB_LP
GANG_OUT:
	move	A4,A4
	jrz	BOSSX
	jump	A2		;* jump to start routine..
**************************************************************************

*************************************************************************
;* This routine looks for an on screen dumpster
;* PARMS:
;* RETURNS:
;*	A0 - ptr to obj
DumpScan:
	move	@BACKSLST,A1,L
	jrz	NODUMP
	movi	BGDMPID,A3,W
	zext	A3,W
DUMP_LP:
	move	*A1(OID),A2,W
	zext	A2,W
	cmp	A2,A3
	jrnz	DUMPMIS
	calla	RANDOM
	jrn	GOTDUMP
DUMPMIS:
	move	*A1(OSLINK),A1,L	;* get next item and try again
	jrnz	DUMP_LP
NODUMP:
	clrc
	rets
GOTDUMP:
	move	A1,A0
	setc
	rets
*******************************************************************

*******************************************************************
;* obj to grab in A0
;* ptr to list of gangsters in A10
GTOGRAB:
	mmtm	SP,A1,A2,A3,A4
	move	A0,A4
	movi	BCMD,A2
	add	A10,A2	;* end of list 
	movi	MAXGANG,A1
GGLP:
	dec	A1
	jrn	GTOGRABX
	move	-*A2,A3,L
	jrz	GGLP
	move	*A3(WANTOBJ),A0,L
	jrz	GetIt
	cmp	A0,A4
	jreq	GTOGRABX
	jruc	GGLP
GetIt:
	calla	RANDU
	movb	@RAND,A0
	jrn	GGLP
	move	A4,*A3(WANTOBJ),L
	movk	Cgrab,A0
	callr	CmdOne

GTOGRABX:
	mmfm	SP,A1,A2,A3,A4
	rets
**************************************************************************

**************************************************************************
BNRPLYR:
;Get Plyr data block ptr of nearest player to Boss
; RETURNS	A0 - ptr to player OBJ or Zero (with Z flag set)
; DESTROYS A1,A2,A3,A4,A5,A6
	clr	A4			;* A4 is ptr to player to chase
	movi	>7FFF,A5		;* distance to first player
	movi	P1DATA,A6
	move	*A6(POBJ),A0,L
	jrz	TRYP2
	move	*A0(OZPOS),A1,W
	move	*A13(BZPOS),A2,W
	sub	A2,A1
	abs	A1
	move	*A0(OXPOS),A2,W
	move	*A13(BXPOS),A3,W
	sub	A3,A2
	abs	A2
	add	A2,A1
	move	A1,A5
	move	A6,A4
TRYP2:
	movi	P2DATA,A6
	move	*A6(POBJ),A0,L
	jrz	WhichP
	move	*A0(OZPOS),A1,W
	move	*A13(BZPOS),A2,W
	sub	A2,A1
	abs	A1
	move	*A0(OXPOS),A2,W
	move	*A13(BXPOS),A3,W
	sub	A3,A2
	abs	A2
	add	A2,A1
	cmp	A1,A5
	jrle	WhichP
	move	A6,A4	   ;* player 2 is closer
WhichP:
	move	A4,A0
	rets
**************************************************************************

*******************************************************************
BDISTP:
;* PARMS: A0 Zdist:Xdist to stay away from player
;* will return A0 ptr to Player OBJ and SETC if player too close..
	move	A0,A6
	callr	BNRPLYR
	jrz	BPlyrFar
	move	*A0(POBJ),A0,L
	move	*A0(OZPOS),A1,W
	move	*A13(BZPOS),A2,W
	sub	A2,A1
	abs	A1
	movy	A6,A2
	srl	16,A2
	cmp	A2,A1
	jrgt	BPlyrFar
	move	*A0(OXPOS),A1,W
	move	*A13(BXPOS),A2,W
	sub	A2,A1
	abs	A1
	movx	A6,A2
	zext	A2,W
	cmp	A2,A1
	jrgt	BPlyrFar
;* there is a close player
	setc
	rets
BPlyrFar:
	clrc
	rets
*******************************************************************


*************************************************************************
;* This routine looks for the nearest object of type obj Id to the Boss
;* PARMS:
;*	A0 - Obj Id
;* RETURNS:
;*	A0 - ptr to obj  (0 if no close objs)
CK_BTY:
	clr	A5		;A5 will be pointer to nearest obj
	move	@BOOTY,A1,L
	jrz	NOBOOTY
	movi	1000,A6	;A6 is distance of nearest booty
	move	*A13(BXPOS),A3,W
	zext	A0,W
BOOTY_LP:
	mmtm	SP,A0
	movi	500,A0
	calla	RANDPER
	mmfm	SP,A0
	jrc	BOOTYMIS
	move	*A1(OID),A2,W
	zext	A2,W
	cmp	A2,A0
	jrnz	BOOTYMIS
	move	*A1(OXPOS),A2,W
	sub	A3,A2
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

**************************************************************************
;* Formation patterns for gangs of gangsters.
;* the values are the X,Z offsets for each gangster
;* X offset will be multiplied by 2.
GF_HOR:	;* horizontal, narrow gap.
	.BYTE	0,0, 10,0, -10,0, 20,0, -20,0, 30,0, -30,0, 40,0, -40,0 
GF_HOR2: ;* horizontal, wide gap.
	.BYTE	0,0, 15,0, -15,0, 30,0, -30,0, 45,0, -45,0, 60,0, -60,0 
GF_VER:	;* vertical, narrow gap.
	.BYTE	0,0, 0,-10, 0,10, 0,-20, 0,20, 0,-30, 0,30, 0,-40, 0,40
GF_VER1:	;* vertical, wide gap.
	.BYTE	0,0, 0,-15, 0,15, 0,-35, 0,35, 0,-45, 0,45, 0,-60, 0,60
GF_OSIDE1: ;* enter from Opposite sides
	.BYTE	127,0, -127,15, -127,-15, 127,30, 127,-30, -127,45, -127,-45, 127,60, 127,-60
GF_OSIDE2: ;* center from Opposite sides
	.BYTE	0,0, 0,15, 0,-15, 0,30, 0,-30, 0,45, 0,-45, 0,60, 0,-60
GF_DUMP1:	;* horizontal, very narrow gap.
	.BYTE	0,0, 3,-2, 6,2, 9,-4, 12,4, 15,-6, 18,6, 21,-8, 21,8
GF_SCAT:	;* scatter
	.BYTE	-15,0, 15,0, 0,-30, 0,30, -10,20, 10,-20, -8,-15, 8,15, 0,0

GS1_TBL_LEN	.set	4
GS1_TBL:
	.LONG	GF_HOR, GF_VER, GF_VER1, GF_DUMP1
**************************************************************************


;*************************** WALL START **********************************
WallStrt:
	SetForm	GF_HOR
	move	@(WORLDTLX+16),A1,W				 
	addi	570,A1
	move	A1,*A13(BXPOS),W
	move	@PLZMIN,A1,W
	addk	5,A1
	move	A1,*A13(BZPOS),W
	callr	BNRPLYR
	move	A0,*A13(BVICT),L
	jruc	BOSS1
************************************************************************

;*************************** SIDE START ********************************
SideStrt:
;	SetForm	GF_OSIDE1
	movi	GS1_TBL_LEN,A0
	calla	RANDU
	dec	A0
	sll	5,A0
	addi	GS1_TBL,A0
	move	*A0(0),*A13(BFORM),L

	mmfm	A12,A6,A7	;Y:X in A6, 0:Z in A7
	move	A6,A5
	sext	A5,W
	jrz	SkStrtX
	move	A5,*A13(BXPOS),W
	jruc	GetZPos
SkStrtX:
	movi	700,A1
	movi	700,A0
	calla	RANDPER
	jrc	SkLftSt
	movi	-150,A1
SkLftSt:
	move	@(WORLDTLX+16),A0,W				 
	add	A1,A0
	move	A0,*A13(BXPOS),W
GetZPos:
	move	A7,A5
	sext	A5,W
	jrz	SkStrtZ
	move	A5,*A13(BZPOS),W
	jruc	GotZPos
SkStrtZ:
	move	A7,A5
	sra	16,A5
	jrz	SkStrtY
	subi	ZORIGIN,A5
	move	A5,*A13(BZPOS),W
SkStrtY:
	move	@PLZMIN,B0
	move	@PLZMAX,B1
	calla	RANGRAND
	move	A0,*A13(BZPOS),W
	callr	BNRPLYR
	move	A0,*A13(BVICT),L
GotZPos:

	movi	GSTAND,A1
	move	A1,*A13(BIDLEANI),L
	move	A1,A0
	calla	SumSlp		;sleep time in A0
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	calla	PRCSLP		;wait out animation
	jruc	BOSS1
************************************************************************

;*************************** DUMP START ********************************
DumpStrt:
	SetForm	GF_DUMP1
	SetAnim	GKNEELED
	move	*A11(OXPOS),A0,W	;* A11 must point at dumpster
	addk	15,A0
	move	A0,*A13(BXPOS),W
	move	*A11(OZPOS),A0,W
	subk	24,A0
	move	A0,*A13(BZPOS),W
	movk	Cstagger,A0
	callr	CmdAll

HideLp:
	callr	BNRPLYR
	move	A0,*A13(BVICT),L
	move	*A0(POBJ),A0,L
	move	*A0(OZPOS),A2,W
	move	*A13(BZPOS),A1,W
	sub	A2,A1
	abs	A1
	cmpi	25,A1
	jrle	DoDS

	move	*A0(OXPOS),A2,W
	move	*A13(BXPOS),A1,W
	sub	A2,A1
	abs	A1
	cmpi	40,A1
	jrle	DmpGo

	movk	10,A0
	calla	PRCSLP

	jruc	HideLp

DmpGo:
DoDS:
	SetAnim	GDSHOOT
	movk	10,A0
	calla	PRCSLP
	jruc	BOSS1
************************************************************************


**************************************************************************
MkGrabs:
	movi	CLIPOID,A0
	callr	CK_BTY
	jrnc	SkGClip
	;* assign a gangster to go grab the clip
	callr	GTOGRAB
SkGClip:
	movi	ROCKOID,A0
	callr	CK_BTY
	jrnc	SkGRock
	callr	GTOGRAB
SkGRock:
	rets
**************************************************************************


************************************************************************
BOSS1:
	movi	90,A0
	calla	RANDPER
	jrnc	SkFormCh
	movi	GS1_TBL_LEN,A0
	calla	RANDU
	dec	A0
	sll	5,A0
	addi	GS1_TBL,A0
	move	*A0(0),*A13(BFORM),L
SkFormCh:
	callr	BNRPLYR
	clr	A6		   ;don't need to clrdest gangsters
	move	A0,*A13(BVICT),L
	move	*A0(POBJ),A7,L

	movb	*A13(BHOME),A1
	jrz	NewBPos
	dec	A1
	movb	A1,*A13(BHOME)

	move	*A13(BZPOS),A1,W
	move	*A7(OZPOS),A2,W
	sub	A2,A1
	abs	A1
	cmpi	25,A1		 	;* if Z delta < 25 don't change zpos
	jrle	NoZMov
	move	A2,*A13(BZPOS),W
	movk	1,A6			;* clrdest the gangers
NoZMov:

DoBXP:
	move	*A7(OXPOS),A1,W
	move	*A13(BXPOS),A2,W
	sub	A2,A1
	abs	A1	 		;* A1 is plyrX, gangX delta
	subi	140,A1
	abs	A1
	cmpi	50,A1
	jrgt	NewBXpos		;Xdelt in range of 90:190 ?

	;* old BXPOS is ok
	jruc	GotBXP

NewBPos:
	movk	1,A6			;* clrdest the gangers
	move	*A7(OZPOS),*A13(BZPOS),W
NewBXpos:
	movi	7,A1
	movb	A1,*A13(BHOME)
	
	;* generate new BXPOS
	move	*A7(OXPOS),A1,W
	move	*A13(BXPOS),A2,W
	cmp	A1,A2
	jrgt	BOnRt
;* boss is on the left of the player
	subi	150,A1
	move	@(WORLDTLX+16),A2,W				 
	addi	30,A2		   	;* within 30 of edge of screen?
	cmp	A1,A2
	jrlt	SetBXP
	addi	360,A1
	move	@PLZMIN,B0
	move	@PLZMAX,B1
	calla	RANGRAND
	move	A0,*A13(BZPOS),W
	jruc	SetBXP
BOnRt:
;* boss is on the right of the player
	addi	150,A1
	move	@(WORLDTLX+16),A2,W				 
	addi	482,A2		       	;* within 30 of edge of screen?
	cmp	A1,A2
	jrgt	SetBXP
	subi	360,A1
	move	@PLZMIN,B0
	move	@PLZMAX,B1
	calla	RANGRAND
	move	A0,*A13(BZPOS),W
SetBXP:
	movk	1,A6			;* clrdest the gangers
	move	A1,*A13(BXPOS),W
	callr	MkGrabs

GotBXP:
	move	A6,A6
	jrz	SkCclr
	movk	Cclrdest,A0
	callr	CmdAll
SkCclr:

	;* set desired animation for gangsters when they reach their dest
	movi	GSTAND,A1
	movi	IDLEACT,A2
	movi	400,A0
	calla	RANDPER
	jrnc	NoGDFire
	movi	GDFIRE,A1
	movk	FIREACT,A2
	jruc	GotIdleA
NoGDFire:
	movi	300,A0
	calla	RANDPER
	jrnc	NoGFire
	movi	GFIRE,A1
	movk	FIREACT,A2
;	jruc	GotIdleA
NoGFire:

GotIdleA:
	move	A1,*A13(BIDLEANI),L
	movb	A2,*A13(ACTION)
	move	A1,A0
	calla	SumSlp		;sleep time in A0
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	calla	PRCSLP		;wait out animation

	jruc	BOSS1
************************************************************************


*************************************************************************
*******************  START OF GANGSTER STUFF  ***************************
*************************************************************************

**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
GANGINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	n_bht1,GANGZSIZ,GANGCOLL
	.WORD	DMAWNZ,GANGEOID
	.LONG	GANGBLIP
**************************************************************************

**************************************************************************
* GANGSTER - THE GANG PROCESS 
* A11 = I.D.
GANGSTER:	
	callr	GETGPOS
	movi	[ZORIGIN,0],A1
	addxy	A0,A1		;A1 = Y:X pos for start

	movi	GANGTAB,A6
	movi	GANGINIT,A14	
	mmtm	SP,A11
	calla	ESINITLL
	mmfm	SP,A11
	jrz	GANG_DIE
	move	A11,*A8(OID),W
	sll	31,A11
	jrz	SkNewPal
	movk	1,A0
	move	A0,@gangcol,W
	callr	CkPal
SkNewPal:

	calla	ClrVel
	clr	A0
	move	A0,*A13(DEST),L
	move	A0,*A13(TEMPDEST),L
	movb	A0,*A13(DEST_TAG)
	movb	A0,*A13(SNOOZE)
	movb	A0,*A13(FLIPTIKS)
	move	A0,*A13(WANTOBJ),L
	move	A0,*A13(TIKCTRS),L
;	move	A0,*A13(EBYTES),L
	movi	GANGFUNCS,A0
	move	A0,*A13(FUNCS),L

	;* Allocate some goodies
	clr	A1
ClpLp:
	move	@gangclip,A0,W
	calla	RANDPER
	jrnc	ClpX
	inc	A1
	cmpi	2,A1
	jrlt	ClpLp
ClpX:
	move	A1,A0
	jrz	NoClp
	calla	ADDCLIPS
NoClp:
	clr	A1
RckLp:
	move	@gangrock,A0,W
	calla	RANDPER
	jrnc	RckX
	inc	A1
	cmpi	3,A1
	jrlt	RckLp
RckX:
	move	A1,A0
	jrz	NoRck
	calla	ADDROCKS
NoRck:

;* Special kluge to allow dumpster starts to hide..
DumpWtLp:
	move	*A13(BOSS),A0,L
	move	*A0(BIDLEANI),A0,L
	cmpi	GKNEELED,A0
	jrnz	GANG_MV
	movk	6,A0
	calla	PRCSLP
	jruc	DumpWtLp
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
***	calla	ShadOff
	jruc	CkXDISTX
DeepRght:
	movb	*A13(SNOOZE),A0
	jrnz	CkXDISTX
	movk	1,A0
	movb	A0,*A13(SNOOZE)
***	calla	ShadOff
	jruc	CkXDISTX
NearRght:
	clr	A0
	movb	A0,*A13(SNOOZE)
***	calla	ShadOn
	jruc	CkXDISTX
NearLeft:
	clr	A0
	movb	A0,*A13(SNOOZE)
***	calla	ShadOn
;	jruc	CkXDISTX
CkXDISTX:
	RETP
**************************************************************************

**************************************************************************
CkQuit:
	move	@SLPGANGS,A0,W
	jrz	CkQuitX
	jruc	GANGDONE
CkQuitX:
	RETP
**************************************************************************

**************************************************************************
GETGPOS:
;* get desired position for gangster
;* returns position Z:X in A0

	move	*A13(BOSS),A0,L
	move	*A0(BFORM),A1,L
	move	*A0(BZXPOS),A2,L

	movb	*A13(GNUM),A4
	sll	4,A4		;want to move 2*GNUM bytes down formation tbl
	add	A4,A1
	movb	*A1,A4	;X offset
	sll	1,A4		;multiply X offset by 2
	zext	A4,W
	addxy	A4,A2

	addk	8,A1
	movb	*A1,A4	;Z offset
	zext	A4,W
	sll	16,A4
	addxy	A4,A2

	move	A2,A0
	rets
**************************************************************************

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
	movi	GANGBUST,A9
	jsrp	GBUST
	jrc	Busted
	;bust failed
	clr	A0													
	movb	A0,*A13(ACTION)
	movb	A0,*A13(DEST_TAG)
	move	A0,*A13(ANIMPTR),L
	move	A0,*A13(WANTOBJ),L
	setc
	retp
NOBUST:
	clrc
	retp
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
;* MAIN LOOP FOR GANGSTER PROCESS
GANG_MV:
	callr	ZCHECK

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
	cmpi	ROCK_T,A0	;same for clip
	jrnz	SkItem_D
	jsrp	GRAB
;	jruc	DestDone
SkItem_D:
DestDone:
	clr	A0
	movb	A0,*A13(ACTION)
	movb	A0,*A13(DEST_TAG)
	movb	A0,*A13(ANIMTIKS)
;	move	A0,*A13(ANIMPTR),L
NotYet:
SkCkDest:

**** Animation check ****
	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX

	clr	A11		;used to sync animations
	jsrp	CkXDIST		;routine can DIE
	movb	*A13(SNOOZE),A0
	jrnz	SkCks
	jsrp	TRYBUST
	movb	*A13(DEST_TAG),A0
	cmpi	BULL_T,A0
	jreq	InDngr
	jsrp	CkDngr
	jrc	GANG_MV
	movb	*A13(DEST_TAG),A0
	cmpi	BULL_T,A0
	jreq	InDngr
SkCks:
	jsrp	GetAnim
InDngr:
	movb	*A13(SNOOZE),A0
	jrnz	AnimX
	movk	4,A1			;* one frame, no sleepin
;	callr	FRANCHEK
	jsrp	FRANIM
	move	A0,A7
	move	*A9,A1,L
	jrnz	ListLeft
	clr	A0
	movb	A0,*A13(ACTION)
	move	*A13(ANIMPTR),A0,L
	cmpi	GHSTSHT,A0
	jrnz	NotShtWk
	movi	GHSTEP,A0
	move	A0,*A13(ANIMPTR),L
NotShtWk:
	movb	*A13(DEST_TAG),A1
	jrz	ClrAni
	move	*A13(ANIMPTR),A9,L
	jruc	SkSync
ClrAni:
;	move	A1,*A13(ANIMPTR),L	;clr animation
	move	*A13(ANIMPTR),A9,L
ListLeft:
	move	A11,A11		;set by GetAnim
	jrz	SkSync
	move	A11,A7
SkSync:
	movb	A7,*A13(ANIMTIKS)
AnimX:

**** Find Next Event ****
	movk	10,A5			;max sleep time
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

	jruc	GANG_MV
**************************************************************************

**************************************************************************
ClrDest:
;A command from the BOSS
	callr	ClrCmd
	movb	*A13(DEST_TAG),A0
	cmpi	ROCK_T,A0
	jreq	SkClrD
	cmpi	BULL_T,A0
	jreq	SkClrD
	clr	A0
	movb	A0,*A13(DEST_TAG)
SkClrD:
	clrc
	retp
**************************************************************************

**************************************************************************
GoGrab:
;A command from the BOSS
	callr	ClrCmd
	move	*A13(WANTOBJ),A0,L
	jrz	GoGrabX
	
	callr	GoHSTEP

	calla	HuntObj
	movk	20,A0
	calla	ShortXDest
	calla	GoDestV
	movk	ROCK_T,A0
	movb	A0,*A13(DEST_TAG)

	setc
	retp
GoGrabX:
	clrc
	retp
**************************************************************************

**************************************************************************
GetAnim:
;if GCOM - a specially requested command
;	if GACT==GCOM return
;	execute command
;	if carry set return
;call CkFire
;	if carry set return
;else if not at desired location
;	if not moving start high stepping - call syncanim
;else if at desired loc
;	load BIDLEANI
;	call syncanim

	callr	CkCmd
	jrnc	SkCmd
	jsrpr	A0
	jrc	GetAnimX
SkCmd:
	callr	CkFire
	jrc	GetAnimX

	movb	*A13(DEST_TAG),A0
	jrnz	GetAnimX
	callr	GETGPOS
	calla	SCRNZCLP
	move	A0,A2
	calla	GETANIX
	movx	A2,A1
	sext	A1,W
	sub	A1,A0
	abs	A0
	cmpi	15,A0
	jrgt	GoToBoss
	move	*A8(OZPOS),A0,W
	movy	A2,A1
	sra	16,A1
	sub	A1,A0
	abs	A0
	cmpi	10,A0
	jrgt	GoToBoss

	;load idle anim
	calla	ClrVel
	move	*A13(BOSS),A7,L
	move	*A7(BIDLEANI),A6,L
	move	*A13(ANIMPTR),A0,L
	cmp	A6,A0
	jreq	GetAnimX
	;face player
	move	*A7(BVICT),A0,L
	calla	GETPLYR
	move	*A0(POBJ),A0,L
	calla	FACEOBJ
	move	A6,*A13(ANIMPTR),L
	move	A6,A0
	
	move	@WAVETIME,A1,W
	move	*A7(BSYNC),A2,W
	sub	A2,A1
	calla	SyncAnim
	move	A0,A9
	move	A1,A11
	jruc	GetAnimX

GoToBoss:
	move	A2,*A13(DEST),L
	calla	ClipZDst
	callr	GoHStep
	calla	GoDestV
	movk	BOSS_T,A0
	movb	A0,*A13(DEST_TAG)
GetAnimX:
	retp
**************************************************************************


**************************************************************************
CkFire:
;if boss requesting gunfire
;	if already shooting, return
;	clr DEST_TAG
;	flip toward player
;	load appropriate fire animation
;	call syncanim
;setc if firing is to be done
	movb	*A13(SNOOZE),A0
	jrnz	NoFire

	movb	*A13(ACTION),A0
	cmpi	FIREACT,A0
	jreq	CkFireX

	move	*A13(BOSS),A7,L
	movb	*A7(ACTION),A0
	cmpi	FIREACT,A0
	jrnz	NoFire
DoFire:
	move	*A13(ANIMPTR),A0,L
	cmpi	GHSTEP,A0
	jrnz	NOWLKSHT

	;do High Step shoot
	cmpi	PostSht1,A9
	jrge	NoFire

	;make sure were within Z of our target
	move	*A7(BVICT),A0,L
	calla	GETPLYR
	move	*A0(POBJ),A0,L
	move	*A0(OZPOS),A1,W
	move	*A8(OZPOS),A2,W
	sub	A1,A2
	abs	A2
	cmpi	35,A2
	jrgt	NoFire
	;* A0 still points to victims obj
	calla	FACINGOB
	jrnc	NoFire
	movi	FIREACT,A0
	movb	A0,*A13(ACTION)
	addi	GHSTSHT-GHSTEP,A9
	movi	GHSTSHT,A0
	move	A0,*A13(ANIMPTR),L
	jruc	NoFire

NOWLKSHT:
	calla	ClrVel
	;face player
	move	*A7(BVICT),A0,L
	calla	GETPLYR
	move	*A0(POBJ),A0,L
	calla	FACEOBJ

	move	*A7(BIDLEANI),A6,L

	;* Do We Rocket?
	move	@gangfrck,A0,W
	jrz	NoFRock
	movb	*A13(EROCK),A1
	jrz	NoFRock
	mpyu	A0,A1
	cmpi	1000,A1
	jrge	DoFRock
	move	A1,A0
	calla	RANDPER
	jrnc	NoFRock
DoFRock:
	movi	GFROCK,A6	; Blast Away!!!
	jruc	GotWeap
NoFRock:

	;* Do We Machine Gun?
	move	@gangmgun,A0,W
	jrz	NoMgun
	movb	*A13(ECLIP),A1
	jrz	NoMgun
	mpyu	A0,A1
	cmpi	1000,A1
	jrge	DoMgun
	move	A1,A0
	calla	RANDPER
	jrnc	NoMgun
DoMgun:
	cmpi	GDFIRE,A6
	jrnz	RegMGun
	movi	GDMGUN,A6
	jruc	GotWeap
RegMGun:
	movi	MGSHOOT,A6	; Blast Away!!!
;	jruc	GotWeap
NoMgun:

GotWeap:
	move	A6,A0
	move	A6,*A13(ANIMPTR),L
	move	@WAVETIME,A1,W
	move	*A7(BSYNC),A2,W
	sub	A2,A1
	calla	SyncAnim
	move	A0,A9
	move	A1,A11			;slp time for first frame
	movi	FIREACT,A0
	movb	A0,*A13(ACTION)
	clr	A0
	movb	A0,*A13(DEST_TAG)
	move	A0,*A13(WANTOBJ),L

CkFireX:
	setc
	rets
NoFire:
	clrc
	rets
**************************************************************************

**************************************************************************
GoHSTEP:
;* entry point for HSTEP only
	mmtm	SP,A0,A1,A2
	move	*A13(ANIMPTR),A1,L
	movi	GHSTEP,A0
	cmp	A0,A1
	jreq	SkSetAni

	;* sync the animation
	move	A0,*A13(ANIMPTR),L
	move	@WAVETIME,A1,W
	move	*A13(BOSS),A2,L
	move	*A2(BSYNC),A2,W
	sub	A2,A1
	calla	SyncAnim
	move	A0,A9
	move	A1,A11			;slp time for first frame

	jruc	SkSetAni

GoHStep:
;* entry point for HSTEP or HSTSHT
	mmtm	SP,A0,A1,A2
	move	*A13(ANIMPTR),A1,L
	movi	GHSTEP,A0
	cmp	A0,A1
	jreq	SkSetAni
	cmpi	GHSTSHT,A1
	jreq	SkSetAni

	;* sync the animation
	move	A0,*A13(ANIMPTR),L
	move	@WAVETIME,A1,W
	move	*A13(BOSS),A2,L
	move	*A2(BSYNC),A2,W
	sub	A2,A1
	calla	SyncAnim
	move	A0,A9
	move	A1,A11			;slp time for first frame

SkSetAni:
	move	*A8(OXVEL),A0,L
	jrnz	GoHStepX

	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos2
	movi	-HSTEPVEL,A0
	jruc	SetXV2
VelPos2:
	movi	HSTEPVEL,A0
SetXV2:
	move	A0,*A8(OXVEL),L
***	calla	UpdShadV
	
GoHStepX:
	mmfm	SP,A0,A1,A2
	rets
****************************************************************************

**************************** GetXVel *************************************
GetXVel:
	cmpi	MOVETBL,A9
	jrlt	NoXvel
	cmpi	MOVEEND,A9
	jrge	NoXvel

	movi	HSTEPVEL+>1000,A0
	jruc	GotXvel
NoXvel:
	clr	A0
GotXvel:
	rets
**************************************************************************

************************************************************************
NEEDDUCK:
	calla	NEAR_BUL
	move	A5,A0	;* is there a bullet headed our way??
	jrz	DUKX
;	move	*A5(OYPOS),A2,W
;	subi	ZORIGIN,A2
;	move	*A5(OZPOS),A3,W
;	sub	A2,A3
;	cmpi	45,A3		;is bullet height < 45
;	jrlt	DUKX
;* BULLET IS HEADING TOWARDS HEAD -- DO SOMETHING !!!
	cmpi	250,A6		;is bullet real close?
	jrgt	DUKX
PICKDUCK:
;* select appropriate ducking frame
	cmpi	GDUCK2,A9
	jrz	TryD3
	cmpi	GDUCK3,A9
	jrz	TryD3
	cmpi	GDUCK4,A9
	jrnz	tryD5
TryD3:
	movi	GDUCK3,A9
	movi	gangmgun,A0,W
	addi	250,A0
	cmpi	1000,A0
	jrge	Blastem
	calla	RANDPER
	jrnc	DUKX
Blastem:
	movi	GDUCKS3,A9
	;* Do We Rocket?
	move	@gangfrck,A0,W
	jrz	NoDRock
	movb	*A13(EROCK),A1
	jrz	NoDRock
	mpyu	A0,A1
	cmpi	1000,A1
	jrge	DoDRock
	move	A1,A0
	calla	RANDPER
	jrnc	NoDRock
DoDRock:
	movi	GDUCKR3,A9	; Blast Away!!!
NoDRock:
	jruc	DUKX
tryD5:
	cmpi	GDUCK5,A9
	jrz	TryD3
	cmpi	GDUCKS4,A9
	jrz	TryD3
	cmpi	GDUCKS5,A9
	jrz	TryD3
	cmpi	GDUCKR4,A9
	jrz	TryD3
	cmpi	GDUCKR5,A9
	jrz	TryD3
DoDuk1:
	movi	GDUCK,A9,L
DUKX:
	rets
************************************************************************

****************************  CHECK DANGER  ******************************
* if in danger of being shot, jump or duck or move away
CkDngr:
	calla	NEAR_BUL
	move	A5,A0	;* is there a bullet headed our way??
	jrz	NODNGR

	move	*A5(OYPOS),A2,W
	subi	ZORIGIN,A2
	move	*A5(OZPOS),A3,W
	sub	A2,A3
	cmpi	45,A3		;is bullet height < 45
	jrlt	BULL_LOW

;* BULLET IS HEADING TOWARDS HEAD -- DO SOMETHING !!!
	cmpi	300,A6		;is bullet real close?
	jrgt HGH_FAR
;* bullet is close - duck.

DuckBul:
	calla	ClrVel
	callr	PICKDUCK
DUCKLP:
	;* carry out a Duck
	clr	A1	;* Do frame with sleep
;	callr	FRANCHEK
	jsrp	FRANIM
	jrc	DUCKX	;* end of script yet
	callr	NEEDDUCK
	jruc	DUCKLP
DUCKX:
	jruc	DNGRX

HGH_FAR:
;* bullet is far - run down and away
	;* move away from bullet on Z
	movi	200,A0
	calla	RANDPER
	jrc	DuckBul
	jruc	NODNGR

BULL_LOW:
;* BULLET IS HEADING TOWARDS FEET -- DO SOMETHING !!!
	;* move away from bullet on Z
	cmpi	300,A6		;is bullet real close?
	jrgt	NODNGR		;bullet is still far away

	movi	500,A0
	calla	RANDPER
	jrc	DuckBul

	move	*A8(OID),A0,W
	andi	M_GTDODG,A0
	jrz	NODNGR

	;* bullet is near - move out on Z
	;* find Z destination
	movk	25,A3
	move	*A8(OZPOS),A1,W
	move	*A5(OZPOS),A2,W
	cmp	A1,A2
	jrlt	SkNegZD
	neg	A3
SkNegZD:
	add	A3,A1
	sll	16,A1

	;* generate X destination
	movi	35,A0		;A0 is magnitude of X distance to run away
	move	*A5(OXVEL+16),A2,W	;Get sign of Bullets velocity
	jrp	XdirOK2
	neg	A0
XdirOK2:
	move	A0,A2
	calla	GETANIX
	add	A0,A2
	movy	A1,A2
	move	A2,*A13(DEST),L

DNGRDEST:
	calla	ClipZDst
	callr	GoHSTEP
	calla	GoDestV
	jruc	ISDNGR

DNGRX:
	clr	A9
	movb	A9,*A13(DEST_TAG)
	movb	A9,*A13(DESTTIKS)
	movb	A9,*A13(ACTION)
	move	A9,*A13(ANIMPTR),L
	move	A9,*A13(WANTOBJ),L
	setc
	RETP

ISDNGR:
	clr	A0
	move	A0,*A13(WANTOBJ),L
	movk	BULL_T,A0
	movb	A0,*A13(DEST_TAG)
NODNGR:
	clrc
	RETP
**************************************************************************


**************************************************************************
BOSSX:
	move	A10,A0
	calla	FREEOBJ
BOSSXX:
	DECW	@GANGCNT
	DIE
GANGDONE:
	MOVE	A8,A0		;GET THE POINTER TO THE OBJECT
	calla	DELENEMY			;DELETE THE ENEMY
GANG_DIE:
Busted:
	callr	PopGrief
	DIE
**************************************************************************

**************************************************************************
PopGrief:
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A10,A13
	move	*A8(OPLINK),A13,L	;in case called from collision scan

	move	*A13(BOSS),A0,L
	calla	GETA10
	movb	*A13(GNUM),A1	;A1 = # of gangster killed	
	movk	MAXGANG-1,A2
FindBro:
	cmp	A1,A2
	jrle	NoSwpId
	move	A2,A3
	sll	5,A3		;A3 is a longword ptr
	add	A10,A3
	move	*A3,A4,L
	jrnz	SwpId
	dec	A2
	jruc	FindBro

NoSwpId:
	move	A1,A1
	jrz	AllDead
	sll	5,A1
	add	A10,A1
	clr	A0
	move	A0,*A1,L	;Boss's child pointer cleared
	jruc	GriefX

SwpId:
	clr	A5
	move	A5,*A3,L	;kill bottom child slot
	move	A1,A5
	sll	5,A5
	add	A10,A5
	move	A4,*A5,L	;Boss's child pointer updated
	movb	A1,*A4(GNUM)	;childs ID updated
	movb	*A3(BCMD),*A5(BCMD) ;keep old cmd
	jruc	GriefX

AllDead:
	;All gangsters are dead, kill Boss and see if time to drop card
	move	A10,A0
	calla	FREEOBJ
	move	*A13(BOSS),A0,L
	calla	KILL

	move	@GANGCNT,A0,W
	dec	A0
	move	A0,@GANGCNT,W
	calla	CARDCHEK

GriefX:
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A10,A13
	rets
**************************************************************************

**************************************************************************
GRAB:
	move	*A13(WANTOBJ),A0,L

;* If ENEMY Z and OBJ Z don't match, can't grab
	move	*A0(OZPOS),A1,W
	move	*A8(OZPOS),A2,W
	move	A1,A3
	sub	A2,A3
	abs	A3
	cmpi	10,A3
	jrgt	NOGRAB

;* Check X distance
	move	*A0(OXPOS),A2,W	;A3 - OBJx
	move	A2,A3
	move	*A8(OXPOS),A1,W	;A1 - ENEMYx
	sub	A1,A2
	jrn	ObjLft
	cmpi	10,A2
	jrlt	NOGRAB
	cmpi	40,A2
	jrgt	NOGRAB
	jruc GRABIT
ObjLft:
	neg	A2
	cmpi	15,A2
	jrlt	NOGRAB
	cmpi	35,A2
	jrgt	NOGRAB

GRABIT:
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrnc	NOGRAB
	move	A0,A10
	calla	FACEOBJ
	calla	ClrVel
	movi	GREACH1,A9
	movk	1,A1
;	callr	FRANCHEK
	jsrp	FRANIM
	
	move	A10,A0
	move	@BOOTY,A1,L
	calla	ON_SLIST
	jrnc	BADGRAB

	move	*A10(OPLINK),A0,L
	jrz	NoBtyPrc
	calla	KILL
	clr	A0
	move	A0,*A10(OPLINK),L
NoBtyPrc:

	move	A10,A0			;GET THE BLOCK
	movi	BOOTY,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	move	*A10(OID),A1,W
	calla	DELOBJ			;ZAP IT
	zext	A1,W
	cmpi	CLIPOID,A1
	jrnz	SkClip
	movb	*A13(ECLIP),A0
	inc	A0
	movb	A0,*A13(ECLIP)
	jruc	CTRX
SkClip:
	movb	*A13(EROCK),A0
	inc	A0
	movb	A0,*A13(EROCK)
CTRX:
	movi	GREACH2,A9
	movk	1,A1
;	callr	FRANCHEK
	jsrp	FRANIM
BADGRAB:
	clr	A9
	move	A9,*A13(ANIMPTR),L
NOGRAB:
	clr	A0
	move	A0,*A13(WANTOBJ),L
	retp
**************************************************************************


**************************************************************************
;* to be invoked as a command to the gangster
STAGGER:
	movb	*A13(GNUM),A0
	sll	2,A0
	calla	PRCSLP
	callr	ClrCmd
	clrc
	retp
**************************************************************************


*************************************************************************
GANGCOLL:
	.WORD	B1OID|BULLETID
	.LONG	GANGCOL0
	.WORD	B1OID|EXPLODID
	.LONG	GANGCOL0
	.WORD	B1OID|ROCKETID
	.LONG	GANGCOL0
	.WORD	B2OID|BULLETID
	.LONG	GANGCOL0
	.WORD	B2OID|EXPLODID
	.LONG	GANGCOL0
	.WORD	B2OID|ROCKETID
	.LONG	GANGCOL0
	.WORD	BEOID|EXPLODID
	.LONG	GANGCOL0
	.word	C1OID		;ENEMY CAR #1 "CADILLAC" OBJECT I.D.
	.LONG	GANGCOL0
	.word	CAR2OID		;ENEMY CAR #2 "PORSCHE" OBJECT I.D.
	.LONG	GANGCOL0
	.word	CAR3OID		;ENEMY CAR #3 "BELL-JET" OBJECT	I.D.
	.LONG	GANGCOL0
	.word	TRAN1OID	;PLAYER TRANSPORT #1 "PORSCHE" OBJECT I.D.
	.LONG	GANGCOL0
	.WORD	0
	.LONG	DUMRTSG

**************************************************************************
GANGCOL0:
	MOVE	A8,A6			;STORE KILLERS OBLOCK
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER
	callr	PopGrief
	move	*A8(OPLINK),A0,L

	MOVE	*A6(OXVEL),A9,L		;GET PROJECTILE DATA
	MOVE	*A6(OYVEL),A10,L
	MOVE	*A6(OID),A11,W		

	MOVI	SPLTCOLBOX,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER

	MOVE	*A8(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	MOVE	A0,A14			;STORE THIS RELIC
	
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
	movi	1,A0	;stop collision scan
	CLRC		;Don't delete in Coll routine
	RETS
SkWendie:
	move	A8,A0
	calla	DELENEMY
	jruc	DoDie
*************************************************************************

**************************************************************************
FRANCHEK:
	cmpi	FRANMIN,A9
	jrlt	$
	cmpi	FRANMAX,A9
	jrgt	$
	rets
**************************************************************************


**************************************************************************
;WALKING JUMPING DEATH FRAGMENT STANDING-SHOOT KNEELING-SHOOT
;STANDING KNEELING

GANGOFF	.WORD	1,3,4,9,18,34,50,50
*THE GANG ENEMY, ANIMATION PTR TABLE, FIRST LONG WORD IS THE OFFSET PTR
*
GANGTAB	.LONG	GANGOFF
	.LONG	GDIE,GDIE,GDIE,GDIE,GDIE,GEXP1,GEXP2,GDROCK

	.LONG	GFRAG1,GFRAG2,GFRAG3,GFRAG4
	.LONG	GFRAG1,GFRAG2,GFRAG3,GFRAG4,0

	.LONG	0,0,0,0,0,0,0,0
	.LONG	0,0,0,0,0,0,0,0
	.LONG	0,0,0,0,0,0,0,0
	.LONG	0,0,0,0,0,0,0,0

	.LONG	GBSTAND
*************************************************************************

;* GANGSTER ANIMATION SCRIPTS
* FIRE FRAME TABLE ENTRY:		    
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW

HSTEPVEL	.set	>2A000

FRANMIN:
MOVETBL:
GHSTEP:
	.long	gh1a
	.word	5
	.long	gh2a
	.word	5
	.long	gh3a
	.word	5
	.long	gh4a
	.word	5
	.long	gh5a
	.word	6
PostSht1:
	.long	gh6a
	.word	5
	.long	gh7a
	.word	5
	.long	gh8a
	.word	5
	LONGNULL
GHSTSHT:
	.long	gh1a
	.word	5
	.long	gh2a
	.word	5
	.long	gh3a
	.word	5
	.long	gh4a
	.word	3
	.long	n_sht1
	.word	2
	.long	n_sht2
	.word	SPAWNP|5,32,-22,0EBH
	.long	EBULLET
	.long	gh6a
	.word	5
	.long	gh7a
	.word	5
	.long	gh8a
	.word	5
	LONGNULL
MOVEEND:

GDUCK:
	.long	n_duck1
	.word	3
GDUCK2:
	.long	n_duck2
	.word	3
GDUCK3:
	.long	gduck3
	.word	7
GDUCK4:
	.long	n_duck2
	.word	6
GDUCK5:
	.long	n_duck1
	.word	5
	LONGNULL
GDIE:
	.long	n_die1
	.word	5
	.long	n_die2
	.word	7
	.long	n_die3
	.word	10
	.long	n_die4
	.word	10
	LONGNULL
GANGBUST:
	.long	n_bt2
	.word	10
	.long	n_bust1
	.word	10
	.long	n_bust3
	.word	10
	.long	n_bust4
	.word	10
	LONGNULL
GKNEELED:
	.long	n_duck3
	.word	10
	LONGNULL
GUNKNEEL:
	.long	n_duck2
	.word	8
	.long	n_duck1
	.word	8
	LONGNULL
GBHEADTRN:
	.long	n_bht3
	.word	10
	LONGNULL
GBSTAND:
	.long	n_bht1
	.word	10
	LONGNULL
GBHDTRNL:
	.long	n_bht3
	.WORD	FLIPBITS|10,M_FLIPH
	LONGNULL
GBHDTRNR:
	.long	n_bht3
	.WORD	FLIPBITS|10,0
	LONGNULL
GSTAND:
	.long	n_sht3
	.word	6
	LONGNULL
GFIRE:
	.long	n_sht3
	.word	9
	.long	n_sht4
	.word	SPAWNP|7,24,-25,0EBH
	.long	EBULLET
	.long	n_sht3
	.word	6
	LONGNULL
MGSHOOT:
	.long	n_sht3
	.word	3
	.long	n_sht4
	.word	SPAWNP|3,24,-25,0EBH
	.long	EBULLET
	.long	n_sht3
	.word	2
	.long	n_sht4
	.word	SPAWNP|3,24,-25,0EBH
	.long	EBULLET
	.long	n_sht3
	.word	3
	.long	n_sht4
	.word	SPAWNP|3,24,-25,0EBH
	.long	EBULLET
	.long	n_sht3
	.word	2
	.long	n_sht4
	.word	SPAWNP|3,24,-25,0EBH
	.long	EBULLET
	LONGNULL
GDSHOOT:
	.long	n_duck3
	.word	SPAWNP|7,20,-15,0EBH
	.long	EBULLET
	LONGNULL

GDFIRE:
GDUCKS:
	.long	n_duck1
	.word	3
GDUCKS2:
	.long	n_duck2
	.word	4
GDUCKS3:
	.long	n_duck3
	.word	SPAWNP|8,20,-7,0EBH
* 	FAFRAME	FRAME,SLEEPT,XOFFSET,YOFFSET,PROCID,PROCESS_ADDRESS,CW
	.long	EBULLET
GDUCKS4:
	.long	n_duck2
	.word	4
GDUCKS5:
	.long	n_duck1
	.word	5
	LONGNULL

GDUCKR:
	.long	n_duck1
	.word	3
GDUCKR2:
	.long	n_duck2
	.word	4
GDUCKR3:
	.long	n_duck3
	.word	SPAWNP|10,20,-15,0EBH
	.long	EROCKET
GDUCKR4:
	.long	n_duck2
	.word	4
GDUCKR5:
	.long	n_duck1
	.word	5
	LONGNULL


GDMGUN:
	.long	n_duck1
	.word	3
	.long	n_duck2
	.word	4
	.long	n_duck3
	.word	SPAWNP|2,20,-7,0EBH
	.long	EBULLET
	.long	gduck3
	.word	3
	.long	n_duck3
	.word	SPAWNP|2,20,-7,0EBH
	.long	EBULLET
	.long	gduck3
	.word	3
	.long	n_duck3
	.word	SPAWNP|2,20,-7,0EBH
	.long	EBULLET
	.long	gduck3
	.word	3
	.long	n_duck3
	.word	SPAWNP|2,20,-7,0EBH
	.long	EBULLET
	.long	gduck3
	.word	3
	.long	n_duck2
	.word	4
	.long	n_duck1
	.word	5
	LONGNULL

GFROCK:
	.long	n_duck1
	.word	3
	.long	n_duck2
	.word	4
	.long	n_duck3
	.word	7
	.long	n_duck3
	.word	SPAWNP|7,20,-15,0EBH
	.long	EROCKET
	.long	n_duck2
	.word	6
	.long	n_duck1
	.word	5
	LONGNULL

GREACH1:
	.long	n_pk1
	.word	7
	.long	n_pk2
	.word	10
	LONGNULL
GREACH2:
	.long	n_pk3
	.word	7
	LONGNULL
FRANMAX:

GWALK:
	.long	n_wa1
	.word	5
	.long	n_wa2
	.word	5
	.long	n_wa3
	.word	5
	.long	n_wa4
	.word	5
	.long	n_wa5
	.word	5
	.long	n_wa6
	.word	5
	LONGNULL

GDROCK:				;Gangster HIT BY ROCKET
	.long	LCREOSOTE
	.word	NEWPALET|5
	.LONG	NARCS
	LONGNULL
GEXP1:
	.long	BGDF3C
	.word	FLIPBITS|NEWPALET|2
	.WORD	0
	.LONG	NARCS
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPV
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPH
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPV|M_FLIPH
	.long	BGDF4C
	.word	FLIPBITS|2,00000h
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPV
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPH
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPV|M_FLIPH
	LONGNULL
GEXP2:
	.long	BGDF3C
	.word	FLIPBITS|NEWPALET|2
	.WORD	0
	.LONG	NARCS
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPV
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPH
	.long	BGDF3C
	.word	FLIPBITS|2,M_FLIPV|M_FLIPH
	.long	BGDF4C
	.word	FLIPBITS|2,00000h
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPV
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPH
	.long	BGDF4C
	.word	FLIPBITS|2,M_FLIPV|M_FLIPH
	LONGNULL
GFRAG1:
	.long	LLEG1
	.word	2
	.long	LLEG2
	.word	2
	.long	LLEG3
	.word	2
	.long	LLEG4
	.word	2
	.long	LLEG5
	.word	2
	.long	LLEG6
	.word	2
	.long	LLEG7
	.word	2
	.long	LLEG8
	.word	2
	.LONG	0
GFRAG2:
	.long	L4ARM1
	.word	2
	.long	L4ARM2
	.word	2
	.long	L4ARM3
	.word	2
	.long	L4ARM4
	.word	2
	.long	L4ARM5
	.word	2
	.long	L4ARM6
	.word	2
	.long	L4ARM7
	.word	2
	.long	L4ARM8
	.word	2
	.LONG	0
GFRAG3:
	.long	LSHIN1
	.word	2
	.long	LSHIN2
	.word	2
	.long	LSHIN3
	.word	2
	.long	LSHIN4
	.word	2
	.long	LSHIN5
	.word	2
	.long	LSHIN6
	.word	2
	.long	LSHIN7
	.word	2
	.long	LSHIN8
	.word	2
	.LONG	0
GFRAG4:
	.long	LGOAT1
	.word	2
	.long	LGOAT2
	.word	2
	.long	LGOAT3
	.word	2
	.long	LGOAT4
	.word	2
	.long	LGOAT5
	.word	2
	.long	LGOAT6
	.word	2
	.long	LGOAT7
	.word	2
	.long	LGOAT8
	.word	2
	.long	LGOAT9
	.word	2
	.long	LGOAT10
	.word	2
	.LONG	0
GANGNUL:
	.LONG	0


NUMCRIM	.set	MAXGANG
****************************************************************************
GANGCRM1:
	CALLA	GETOBJ		;GET AN OBJECT BLOCK
	jrz	BOSSXX
	move	A0,A10		;A10 - ptr to extra space
	calla	CLROBJ

	;* initialize BOSS'S VARS
	clr	A0
	callr	CmdAll
	clr	A0
	movb	A0,*A13(ACTION)

	movi	CONTCRIM,A2
	movi	NUMCRIM,A3
	jruc	DISPATCH
CONTCRIM:
	move	@(WORLDTLX+16),A0,W				 
	addi	255,A0
	move	A0,*A13(BXPOS),W
	move	@PLZMIN,A0,W									 
	addi	5,A0
	move	A0,*A13(BZPOS),W

	movi	GF_HOR2,A0
	move	A0,*A13(BFORM),L

	movi	GBSTAND,A1
	move	A1,*A13(BIDLEANI),L
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	SLEEP	10
	movi	GBHDTRNL,A1
	move	A1,*A13(BIDLEANI),L
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	SLEEP	20
	movi	GBSTAND,A1
	move	A1,*A13(BIDLEANI),L
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	SLEEP	10
	movi	GBHDTRNR,A1
	move	A1,*A13(BIDLEANI),L
	move	@WAVETIME,A1,W
	move	A1,*A13(BSYNC),W
	SLEEP	20

	movi	NUMCRIM,A3
	move	A10,A1
KillCrim:
	move	*A1+,A0,L
	calla	KILL
	dsjs	A3,KillCrim

	movi	gangpal,A0
	calla	FINDPAL
	move	A0,@CRIMEPAL,W
	retp
****************************************************************************

blugang:	;PAL #0
	.word	256	;pal size
	.word >0,>1,>400,>C00,>C03,>1400,>1400,>1403,>C06,>21
	.word >421,>C21,>443,>C43,>C44,>C64,>1443,>1463,>1444,>1464
	.word >1464,>1446,>1466,>1466,>1484,>1486,>1487,>14A7,>1C43,>1C64
	.word >2441,>2463,>1C84,>2483,>1C67,>1C86,>1C87,>1C66,>1C86,>2467
	.word >1CA4,>24A3,>1CA6,>24C6,>1CA7,>1CA7,>24A7,>24A7,>1CC7,>1CC7
	.word >24C7,>24E7,>1489,>1C89,>1CA9,>1CA9,>1CC9,>1CC9,>1CE9,>14AB
	.word >1CCB,>1CCC,>14CF,>1CCB,>1CEB,>1CCC,>1CCF,>248B,>24A9,>24AB
	.word >24A9,>24AB,>24C9,>24CB,>24C9,>24CB,>24E9,>24EB,>24E9,>24EB
	.word >24AC,>24CC,>24AC,>24CC,>24EC,>24EC,>24CF,>24EE,>24EF,>1D0B
	.word >1D2B,>2509,>250B,>2529,>252B,>250C,>252C,>2509,>250B,>250C
	.word >2529,>252B,>254B,>252C,>254C,>1D0E,>1D0E,>250E,>250E,>250F
	.word >250F,>2511,>254F,>252E,>252F,>254F,>2531,>2593,>2C83,>2CA7
	.word >2CA9,>2CC7,>2CE9,>2CCB,>2CEB,>2CEB,>2CEC,>2CEE,>2CEE,>2D09
	.word >2D07,>2D09,>2D0B,>2D0B,>2D0C,>2D0C,>2D27,>2D29,>2D29,>2D2B
	.word >2D4B,>2D2B,>2D4B,>2D2C,>2D2C,>2D4C,>2D4C,>2D8C,>2D0E,>2D0E
	.word >2D2E,>2D4E,>2D2E,>2D4E,>3484,>34E4,>34E7,>34CB,>34EC,>350C
	.word >350E,>3529,>352C,>352E,>354B,>354E,>358E,>44A1,>4504,>3CEB
	.word >4CEB,>4549,>452C,>45AE,>5504,>552C,>5D2B,>5DA7,>5DAC,>6DCB
	.word >6DCE,>2D0F,>2D0F,>2D11,>2D2F,>2D2F,>352F,>2D31,>3531,>2D4F
	.word >2D51,>2D91,>354F,>3551,>3591,>2D93,>3553,>3593,>2D96,>3594
	.word >3531,>354F,>3551,>3591,>35B1,>3593,>35B4,>3D4F,>3D33,>3D91
	.word >3D93,>3DB1,>3DB3,>3DB4,>3D91,>3DB3,>3DB6,>4591,>45B4,>4593
	.word >5D91,>35D4,>3DD4,>3DD3,>45D6,>4614,>4DD1,>4DD6,>4E0D,>5DF3
	.word >6614,>3DF7,>3E13,>4DF9,>4E52,>6639,>6671,>5E74,>66F7,>7611
	.word >7E53,>7657,>76BB,>7F33,>7F98,>7F9A,>7FFA,>77DD,>7F9D,>7FDD
	.word >7FDF,>7FFC,>7FFD,>7FFE,>7FFF,>7FFF

GANGPALS:
	.long	gangpal
	.long	blugang

