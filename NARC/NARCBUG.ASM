 	.FILE	'NARCBUG.ASM'
	.TITLE	" <<< N  A  R  C  -- BUG >>>"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

; To change from Delta movement to skaters, check the following
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
	.include	"narcxtra.glo"
	.INCLUDE	"NARCFRAG.GLO"

	.TEXT

	.include	"narcbug.tbl"

	.GLOBAL	BUGBURN	;for WENDIE

;HELLBUGS .WORD	>F300|NINTEQ,>80,>809F,0	;bugs from hell..
;BUGHTSND .WORD	>F320,>20,0>809D,0		;bug shot (fly away)


;* bug on player process block offsets
XDIFF	.set	ESWTCH
OLDXPOS	.set	ESWTCH		;* BUG under players feet
OnBack	.set	ESWTCH+16
VICTIMDATA .set	ETEMP3
VICTIM	.set	ETEMP4
OLDZPOS	.set	ETEMP5
OLDYPOS	.set	ETEMP5+16
VOLDXV	.set	ETEMP6
BRAINCT	.set	ETEMP6+16


	.BSS	pl1sqsh,16,1
	.BSS	pl2sqsh,16,1
	.BSS	bugcol,16,1

***************************************************************************
; BUG SUB_TYPES
; w/ no coors starts at PLZMIN and 1 to 2 full screens away from
;	players in X.  90% chance of coming up to the right.
; 0 - Crawler		- Brown
; 1 - Flier		- Red
; 2 - Jumper		- Green
; 3 - Fast Flier	- Blue
DTBL:
	.long	D0,D1,D2
	.long	D1,D1,D1,D1,D1,D1
	.long	D1,D1,D1,D1,D1,D1,D1

LocoTbl:
	.long	Crawler
	.long	Flier
	.long	Jumper
	.long	Flier,Flier,Flier,Flier
	.long	Flier,Flier,Flier,Flier
	.long	Flier,Flier,Flier,Flier
	.long	Flier,Flier,Flier,Flier
***************************************************************************

************************* FUNCTION TABLE ***************************
BUG_FUNCS:
	.long	BOOF
	.long	GoDestV
	.long	GetXVel
	.long	>FFFF	;MaxXZAngle
	.long	10	;FlipTiks
;To catch a nulled dereference through BUG_FUNCS
BOOF:	jruc	$
********************************************************************

********** GEORGE -- COMMENT THIS STUFF OUT **************
;* Also uncomment RETS in GVARINIT
****	.BSS	bugmax,16,16		;U - max # of active bugmen

VARINIT:
	rets		   ;* <---------------------- remove ;
	movk	6,A1
	move	A1,@bugmax,W
	rets
**********************************************************

**************************************************************************
*INIT TABLE
*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
BUGINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	bugwk1,>120012,BUGCOLL		;BUGZSIZ
	.WORD	DMAWNZ,BUGEOID
	.LONG	BUGBLIP
**************************************************************************

**************************************************************************
BUGCOLD:
;* PARMS
; A5  - Y:X
; A6  - 0:Z	;if A5 and A6=0 then Random Position
; A14 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4

	mmtm	SP,A0,A1,A2,A7,A9,A10,A11
	callr	VARINIT
	
	move	@SLPBUGS,A0,W
	cmpi	5,A0
	jrge	DoEnq

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
	CREATE	BUGEPID,BUGGER	;allocate process?	(bashes A1,A7)
	jrz	ColdX
	dsjs	A2,ColdLp
ColdX:
	mmfm	SP,A0,A1,A2,A7,A9,A10,A11
	rets

DoEnq:
;	callr	EnqCold
	jruc	ColdX
**************************************************************************

**************************************************************************
;EnqCold:
;* stows away Bug Requests for later
;* Enqs are done at the Q head "COLDQ + COLDQH*32"
;	move	@COLDQ,A0,L
;	jrnz	SkMkQ
;	calla	GETOBJ
;	jrz	EnqX
;	move	A0,@COLDQ,L
;	clr	A1
;	movb	A1,@COLDQL
;	movb	A1,@COLDQH
;SkMkQ:
;
;	movk	1,A7	;Enq request size in long words
;
;	;* Enq request onto queue at A0
;	;does Q have space for request?
;	movb	@COLDQL,A1
;	add	A7,A1
;	cmpi	OBSIZ/32,A1
;	jrgt	EnqX		;Sorry, but Q is full
;
;	;get ptr to place to make entry
;	
;
;EnqX:
;	rets
**************************************************************************

*********************  START OF BUGGER PROCESS  *************************
BUGGER:
* A9  - Y:X
* A10 - 0:Z	;if A9,A10 = 0 generate random start pos.
* A11 - 0.8:#.4:rand#.4:>0E.8:OIDtype.4:OIDsubtype.4
;based on sub-type, jump to appropriate routine

	INCW	@SLPBUGS
MaxWait:
	movk	10,A0
	calla	RANDU
	calla	PRCSLP
	move	@bugmax,A0,W
	move	@BUGCNT,A1,W
	cmp	A0,A1
	jrlt	MaxWaitX
	SLEEP	30
	jruc	MaxWait
MaxWaitX:
	DECW	@SLPBUGS
	move	@SLPBUGS,A0,W
	cmpi	3,A0
	jrge	SkDeq
;	callr	DeqCold
SkDeq:
	move	@BUGCNT,A0,W
	jrnz	SkStrtWatch
	CREATE	BUGWPID,BUGWATCH	;allocate process?	(bashes A1,A7)
SkStrtWatch:
	INCW	@BUGCNT

	move	A11,A0
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	DTBL,A0
	move	*A0,A0,L
	jump	A0

**************************************************************************
D3:
;* Flier
	movk	3,A0	;Blue
	move	A0,@bugcol,W
	movk	5,A0
	movb	A0,*A13(BRAINCT)
	jruc	DMain

**************************************************************************
D2:
;* Jumper
	movk	2,A0	;Green
	move	A0,@bugcol,W
	movk	10,A0
	movb	A0,*A13(BRAINCT)
	jruc	DMain

**************************************************************************
D1:
;* Flier
	movk	1,A0	;Red
	move	A0,@bugcol,W
	movk	10,A0
	movb	A0,*A13(BRAINCT)
	jruc	DMain

**************************************************************************
D0:	
;* Crawler
	clr	A0	;brown
	move	A0,@bugcol,W
	movk	15,A0
	movb	A0,*A13(BRAINCT)
;	jruc	DMain

DMain:
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
	movi	80,A0
	calla	RANDU
	add	A0,A9

	move	@PLYMIN,A1,W									 
	movi	50,A0
	calla	RANDU
	add	A0,A1
	sll	16,A1
	movy	A1,A9	;* initial position							 
	clr	A10

GotCoors:
	move	A9,A1
	movi	BUGTAB,A6
	movi	BUGINIT,A14	
	mmtm	SP,A9,A10,A11
	calla	ENINITLL		;CREATE BUG
	mmfm	SP,A9,A10,A11
	jrz	BUG_DIE
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
	move	@bugcol,A0,W
	jrz	SkNewCol
	sll	5,A0
	addi	BugColor,A0
	move	*A0,A0,L
	calla	GETFPAL
	jrz	SkNewCol
	move	A0,A1
	move	*A8(OPAL),A0,W
	calla	FREEPAL
	move	A1,*A8(OPAL),W
SkNewCol:

	calla	ClrVel
	clr	A0
	move	A0,*A13(DEST),L
	move	A0,*A13(TEMPDEST),L
	movb	A0,*A13(DEST_TAG)
;	movb	A0,*A13(ZPER)
	move	A0,*A13(TIKCTRS),L
	move	A0,*A13(EBYTES),L
	movi	BUG_FUNCS,A0
	move	A0,*A13(FUNCS),L

	callr	GOCRAWL
	jruc	BUG_MOVE
**************************************************************************

BugColor:
	.long	brnbug,redbug,grnbug,blkbug

**************************************************************************
* BUGGER2 - THE bug broke free from player process
BUGGER2:	
*Enemy object initialization
;	move	A13,*A8(OPLINK),L	;PROC LINK
;	clr	A0
;	move	A0,*A13(DEST),L
;	move	A0,*A13(TEMPDEST),L
;	movb	A0,*A13(DEST_TAG)
;	movb	A0,*A13(ZPER)
;	move	A0,*A13(TIKCTRS),L
;	move	A0,*A13(EBYTES),L
	movi	BUG_FUNCS,A0
	move	A0,*A13(FUNCS),L

	jruc	BUG_MOVE
**************************************************************************

**************************************************************************
BUG_MOVE:
;********  CHECK if a DESTINATION has been reached, and what to do if so..
	callr	ZCHECK

	movb	*A13(FLYING),A0
	jrz	OnGrnd			;flying = 0 - crawling
	dec	A0
	jrz	BFlying			;flying = 1 - flying
	dec	A0
	jrz	BJumping		;flying	= 2 - jumping
	dec	A0
	jrz	BJumping		;flying	= 3 - falling
;	jruc	BWiggle			;flying = 4 - wiggling on back

;BWiggle:
	movk	5,A0
	calla	RANDU
	subk	3,A0
	move	*A8(OXPOS),A1,W
	add	A0,A1
	move	A1,*A8(OXPOS),W
	movk	5,A0
	calla	RANDU
	subk	3,A0
	move	*A8(OYPOS),A1,W
	add	A0,A1
	move	A1,*A8(OYPOS),W
	move	*A8(OYPOS),A1,W
	add	A0,A1
	move	A1,*A8(OYPOS),W
	movk	4,A0
	calla	RANDU
	dec	A0
	move	*A8(OYPOS),A1,W
	sub	A0,A1
	move	A1,*A8(OYPOS),W

	calla	DFRMGRND
	jrz	HghtOk
	jrn	HghtOk
	move	*A8(OYPOS),A1,W
	addk	2,A1
	move	A1,*A8(OYPOS),W
HghtOk:
	jruc	SkCkDest


BJumping:
	move	*A8(OYVEL),A0,L
	move	*A8(OZVEL),A1,L
	sub	A1,A0
	jrn	GoingUp

	calla	DFRMGRND
	cmpi	2,A1
	jrle	HitGrnd
GoingUp:
	movb	*A13(FLYING),A0
	cmpi	2,A0
	jrgt	SkJmpYV
	move	*A8(OYVEL),A0,L
	addi	>B000,A0
	move	A0,*A8(OYVEL),L
	jruc	SkCkDest
SkJmpYV:
	move	*A8(OYVEL),A0,L
	addi	>18000,A0
	move	A0,*A8(OYVEL),L
	jruc	SkCkDest

HitGrnd:
	clr	A0
	movb	A0,*A13(BRAINTIKS)
	clr	A0
	movb	A0,*A13(FLYING)
	move	*A8(OZVEL),*A8(OYVEL),L
	callr	DOCRAWL
	move	A8,A0
	calla	SETZPOS

OnGrnd:
BFlying:
	movb	*A13(DESTTIKS),A0
	jrnz	SkCkDest
	calla	CkDest
	jrnc	NotYet

	;* we have reached our destination, what to do??
	movb	*A13(DEST_TAG),A0
	jrz	SkCkDest			;* No Destination

DestDone:
	clr	A0
	movb	A0,*A13(BRAINTIKS)	;Allow new course of action
	movb	A0,*A13(DEST_TAG)
NotYet:
SkCkDest:

**** BRAIN functions *****
	movb	*A13(BRAINTIKS),A0
	jrnz	BrainX
	movb	*A13(BRAINCT),*A13(BRAINTIKS)		;reset brain wait

	callr	RollOver	;is bug flipped on Back?
	jrc	BrainX

	move	*A8(OID),A0,W
	sll	28,A0
	srl	28,A0
	sll	5,A0
	addi	LocoTbl,A0
	move	*A0,A0,L
	call	A0
BrainX:

**** Animation check ****
	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX

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

	movb	*A13(DEST_TAG),A0
	jrz	SkDestDc
	sub	A6,A2
	movb	A2,*A13(DESTTIKS)
SkDestDc:
	sub	A6,A1
	movb	A1,*A13(BRAINTIKS)
	sub	A6,A3
	movb	A3,*A13(ANIMTIKS)

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

	move	A6,A0
	jrp	Slp
;	jruc	$
	movk	2,A0
Slp:
	calla	PRCSLP

	jruc	BUG_MOVE
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
RollOver:
;* check if bug is on back, if so try to roll over else squirm
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPV,A0
	jrz	NoRoll

	movk	4,A0
	movb	A0,*A13(FLYING)

	calla	ClrVel
	calla	DFRMGRND
	move	A1,A0
	abs	A0
	sll	5,A0
	addi	50,A0
	calla	RANDPER
	jrc	UnRoll

	movi	BUGWIGGL,A0
	move	*A13(ANIMPTR),A1,L
	cmp	A0,A1
	jrz	SkAnRst
	move	A0,A9
SkAnRst:
	move	A0,*A13(ANIMPTR),L

	;* Flip Bug horizontally??
	movi	600,A0
	calla	RANDPER
	jrnc	SkHFlp
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	NotHFlp
	calla	Ck_NOYFLP
	jruc	SkHFlp
NotHFlp:
	calla	Ck_YFLP
SkHFlp:
	setc	;bug is on back
	rets

UnRoll:
	clr	A0
	movb	A0,*A13(FLYING)
	move	*A8(OFLAGS),A0,W
	andni	M_FLIPV,A0
	move	A0,*A8(OFLAGS),W
NoRoll:
	clrc
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
	move	*A13(ANIMPTR),A0,L
	cmpi	BUGCRAWL,A0
	jreq	CrawlV
	cmpi	BUGJUMP,A0
	jreq	JumpV
	cmpi	BUGFLY,A0
	jreq	FlyV

	jruc	NoXvel
CrawlV:
	movi	CRAWLXVEL,A0
	jruc	GotXvel
JumpV:
	movi	JUMPXVEL,A0
	jruc	GotXvel
FlyV:
	movi	FLYXVEL,A0
	jruc	GotXvel
NoXvel:
	clr	A0
GotXvel:
	rets
**************************************************************************

******************************* Go Crawl *********************************
DOCRAWL:  ;alternate entry point which allows completion of last anim
	mmtm	SP,A0
	jruc	CrawlNxt

GOCRAWL:
	mmtm	SP,A0
	move	*A13(ANIMPTR),A0,L
	cmpi	BUGCRAWL,A0
	jreq	Crawling
	movi	BUGCRAWL,A9
CrawlNxt:
	movi	BUGCRAWL,A0
	move	A0,*A13(ANIMPTR),L
Crawling:
	calla	DFRMGRND
	cmpi	5,A0
	jrgt	StrtJump		;don't fuck with Jump routine
	move	A8,A0
	calla	SETZPOS
	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos2
	movi	-CRAWLXVEL,A0
	jruc	SetXV2
VelPos2:
	movi	CRAWLXVEL,A0
SetXV2:
	move	A0,*A8(OXVEL),L

GoCrawlX:
	mmfm	SP,A0
	rets
**************************************************************************

***************************** Go Jump ************************************
GOJUMP:
;* GO CRAWL jumps into middle of this routine be careful!!!
	mmtm	SP,A0
	move	*A13(ANIMPTR),A0,L
	cmpi	BUGJUMP,A0
	jreq	Jumping
StrtJump:
	movi	BUGJUMP,A0
	move	A0,*A13(ANIMPTR),L
	move	A0,A9
Jumping:
	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos3
	movi	-JUMPXVEL,A0
	jruc	SetXV3
VelPos3:
	movi	JUMPXVEL,A0
SetXV3:
	move	A0,*A8(OXVEL),L

GoJumpX:
	mmfm	SP,A0
	rets
**************************************************************************

***************************** Go Fly *************************************
GOFLY:
	mmtm	SP,A0
	move	*A13(ANIMPTR),A0,L
	cmpi	BUGFLY,A0
	jreq	Flying
	movi	BUGFLY,A0
	move	A0,*A13(ANIMPTR),L
	move	A0,A9
Flying:
	;* set veloctiy for skaters
	move	*A8(OFLAGS),A0,W
	btst	B_FLIPH,A0
	jrz	VelPos4
	movi	-FLYXVEL,A0
	jruc	SetXV4
VelPos4:
	movi	FLYXVEL,A0
SetXV4:
	move	A0,*A8(OXVEL),L

GoFlyX:
	mmfm	SP,A0
	rets
**************************************************************************


****************************  Jumper  ************************************
;* bug homes in on player while jumping..
Jumper:
	movb	*A13(FLYING),A0
	jrnz	JumperX
	calla	ClosestP
	move	A8,A7
	move	A0,A8
	calla	GETANIX
	move	A8,A1		;Ptr to Plyr
	move	A0,A2		;Xpos of Plyr
	move	A7,A8
	calla	GETANIX
	move	A0,A7
	sub	A2,A7		;A14 dist between bug and player
	jrgt	OnRght
	addi	75,A0
	jruc	GotXD
OnRght:
	subi	75,A0
GotXD:
	move	A0,A3

	movk	15,A0
	calla	RANDU
	addk	10,A0
	movb	@RAND,A2
	jrn	SkNeg
	neg	A0
SkNeg:
	move	*A1(OZPOS),A2,W
	add	A0,A2
	sll	16,A2
	movy	A2,A3
	move	A3,*A13(DEST),L
	calla	ClipDest

	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)

	movi	300,A0
	abs	A7
	sub	A7,A0
	jrn	NoJmp
	calla	RANDPER
	jrc	GoJmp
NoJmp:
	callr	GOCRAWL
	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0
	jruc	JumperX
GoJmp:
	callr	GOJUMP
	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movk	2,A0
	movb	A0,*A13(FLYING)
	movi	>38000,A0
	calla	RANDU
	addi	>38000,A0
	neg	A0
	move	*A8(OYVEL),A1,L
	add	A0,A1
	move	A1,*A8(OYVEL),L
JumperX:
	rets
**************************************************************************

****************************  Crawler  ************************************
;* bug homes in on player by CRAWLING.
Crawler:
	calla	ClosestP
	move	A8,A7
	move	A0,A8
	calla	GETANIX
	move	A8,A1		;Ptr to Plyr
	move	A0,A3		;Xpos of Plyr
	move	A7,A8

	move	*A1(OZPOS),A2,W
	sll	16,A2
	movy	A2,A3
	move	A3,*A13(DEST),L
	calla	ClipDest

	callr	GOCRAWL
	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)

	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	rets
**************************************************************************

****************************  Flier  ************************************
;* bug homes in on player by Flying
Flier:
	calla	ClosestP
	move	A8,A7
	move	A0,A8
	calla	GETANIX
	move	A8,A1		;Ptr to Plyr
	move	A0,A3		;Xpos of Plyr
	move	A7,A8
	move	*A1(OZPOS),A2,W
	sll	16,A2
	movx	A0,A2
	move	A2,*A13(DEST),L
	calla	ClipDest

	movk	DFLT_T,A0
	movb	A0,*A13(DEST_TAG)

	callr	GOFLY
	move	*A13(FUNCS),A0,L	;* choose appropriate godest func
	addi	GODEST,A0
	move	*A0,A0,L
	call	A0

	movi	5,B0		;Min Y Height
	movi	95,B1		;Max Y Height
	calla	RANGRAND	;A0 = desired Y Height
	calla	DFRMGRND	;A1 = Current Y Height
	sub	A0,A1		;A0 = Y Delta
	sll	16,A1
	movb	*A13(BRAINCT),A2	;A2 = Amt of time to get there
;	sll	1,A2
	divs	A2,A1		;A1 = new Y Velocity
	move	*A8(OZVEL),A0,L
	add	A0,A1
	move	A1,*A8(OYVEL),L

	rets
**************************************************************************

**************************************************************************
BUG_DONE:
	MOVE	A8,A0		;GET THE POINTER TO THE OBJECT
	calla	DELENEMY			;DELETE THE ENEMY
BUG_DIE:
	DECW	@BUGCNT
	DIE
**************************************************************************

**************************************************************************
BUGCOL0:
*A0 = PTR TO Bug OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
	MOVE	*A8(OXVEL),A9,L		;GET PROJECTILE DATA
	MOVE	*A8(OYVEL),A10,L
	MOVE	*A8(OID),A11,W		

	MOVE	A8,A6			;STORE KILLERS OBLOCK
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER

	MOVI	DUMCOLL,A14
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

;	move	*A6(OYPOS),A9,W
;	MOVI	0EDh,A1
;	movi	SPLATTER,A7
;	CALLA	GETPRC

SkDie:
	DECW	@BUGCNT

	movi	BUGHTSND,A0
	calla	ONESND

	CLRC		;Don't delete in Coll routine
	RETS
*************************************************************************

**************************************************************************
BugPlCol:
*A0 = PTR TO BUG OBJECT
*A8 = PTR to Player
;* This routine kills the standard bug process.
;* If the player is travelling up, the bug bounces off.
;* If the player collided with is coming down, and the bug is on the
;* ground, the bug is smashed.
;* Else, the bug is switched to the attached-to-player process.

	move	A8,A6
	move	A0,A8

	move	A6,A0
	calla	GetPData
	move	*A0(PFLAGS),A0,L
	andi	MJUMP2,A0
	jrz	GrabOn

	MOVE	*A6(OYVEL),A10,L
	MOVE	*A6(OZVEL),A11,L
	sub	A11,A10
	move	A10,A2
	abs	A2
	cmpi	>50,A2
	jrlt	GrabOn
	cmpi	>4000,A10
	jrlt	PlyrGoUp

	;* Player coming down..
	calla	DFRMGRND
	cmpi	10,A1
	jrle	BugSplat

	move	A6,A0
	calla	GetPData
	calla	GETPBOTY
	move	*A8(OYPOS),A2,W
	subk	15,A2			;roughly half the height of a bug
	sub	A1,A2
	abs	A2
	cmpi	32,A2
	jrgt	GrabOn

	;* Bug is near players feet, drag it down to the pavement
	move	*A6(OID),A11,W
	calla	SCRKIL

	MOVI	DUMCOLL,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER

	MOVE	*A8(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	move	A0,A14
	
	MOVI	BUGSPID,A1
	MOVI	BugFall,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	jrz	DelBug
	move	*A14(EMAINT),*A0(EMAINT),L
	move	A6,*A0(VICTIM),L	;PASS KILLERS DMA XY POSITION

	CLRC		;Don't delete in Coll routine
	RETS
	
GrabOn:
	movi	180,A0
	calla	RANDPER
	jrnc	BCOLX

	;* is bug close enough to player?
	calla	GETANIX
	move	A0,A2
	move	A8,A3
	move	A6,A8
	calla	GETANIX
	move	A3,A8
	sub	A0,A2
	abs	A2
	cmpi	22,A2
	jrgt	BCOLX

	;* Attach bug to player
	MOVI	BUGCOLL2,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER

	MOVE	*A8(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	MOVE	A0,A14			;STORE THIS RELIC
	
	MOVI	BUGPPID,A1
	MOVI	BugOn,A7
	CALLA	GETPRC
	jrz	DelBug
	move	*A14(EMAINT),*A0(EMAINT),L
	move	A6,*A0(VICTIM),L	;PASS KILLERS DMA XY POSITION
	jruc	SkDelBug

DelBug:
	MOVE	A8,A0
	calla	DELENEMY
	DECW	@BUGCNT
SkDelBug:
	CLRC		;Don't delete in Coll routine
	RETS


PlyrGoUp:
	CLRC		;Don't delete in Coll routine
	RETS

BugSplat:
	move	*A6(OID),A11,W
	calla	SCRKIL

	MOVI	DUMCOLL,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER

	MOVE	*A8(OPLINK),A0,L
	CALLA	KILL			;KILL CONTROL
	
	MOVI	BUGSPID,A1
	MOVI	BugSplt,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	jrz	DelBug

BCOLX:
	CLRC		;Don't delete in Coll routine
	RETS
*************************************************************************


*************************************************************************
BugFall:
;* The bug is trapped below the players feet and is carried to the
;* pavement below.
	move	A13,*A8(OPLINK),L

	calla	ClrVel
	move	*A13(VICTIM),A1,L
	move	*A1(OZPOS),*A13(OLDZPOS),W
	move	*A1(OYPOS),*A13(OLDYPOS),W
	move	*A1(OXPOS),*A13(OLDXPOS),W

	move	A1,A0
	calla	GetPData
	move	A0,*A13(VICTIMDATA),L

	movi	BUGFALL,A9
	clr	A0
	
FallLp:
	move	*A13(VICTIMDATA),A0,L
	move	*A0(PLOBJ),A0,L
	calla	DFRMGRND
	cmpi	20,A1
	jrle	BugSplt
	MOVE	*A0(OYVEL),A2,L
	MOVE	*A0(OZVEL),A3,L
	sub	A3,A2
	cmpi	>4000,A2
	jrlt	BugOff

	move	*A13(VICTIM),A1,L

	move	*A1(OXPOS),A2,W
	move	*A13(OLDXPOS),A3,W
	move	A2,*A13(OLDXPOS),W
	sub	A3,A2
	move	*A8(OXPOS),A0,W
	add	A2,A0
	move	A0,*A8(OXPOS),W

	move	*A1(OZPOS),A2,W
	move	*A13(OLDZPOS),A3,W
	move	A2,*A13(OLDZPOS),W
	sub	A3,A2
	move	*A8(OZPOS),A0,W
	add	A2,A0
	move	A0,*A8(OZPOS),W

	move	*A1(OYPOS),A2,W
	move	*A13(OLDYPOS),A3,W
	move	A2,*A13(OLDYPOS),W
	sub	A3,A2
	move	*A8(OYPOS),A0,W
	add	A0,A2
	addk	3,A2
	move	*A13(VICTIMDATA),A0,L
	calla	GETPBOTY
	subk	5,A1
	cmp	A1,A2
	jrlt	SetFallY
	move	A1,A2
SetFallY:
	move	A2,*A8(OYPOS),W

	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX2
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrnz	LstLft2
	;* recycle animation
	movi	BUGFALL,A9
LstLft2:
	movb	A0,*A13(ANIMTIKS)
AnimX2:
	movb	*A13(ANIMTIKS),A0
	dec	A0
	movb	A0,*A13(ANIMTIKS)
	
	SLEEP	1

	jruc	FallLp
*************************************************************************


*************************************************************************
BugSplt:
; Squish the bug.

	;* BUMP APPROPRIATE SQUISH CTR, GIVE BIG BONUS
	zext	A11,W
	cmpi	P2OID,A11
	jreq	BMPP2CNT
	move	@pl1sqsh,A0,W	
	inc	A0
	move	A0,@pl1sqsh,W
	cmpi	2,A0
	jrle	SkBon1
	;GIVE BIG BONUS
	movi	P1DATA,A2
	movi	>1000,A1
	calla	SCORE
	calla	PUT1K
SkBon1:
	jruc	SqshIncd
BMPP2CNT:
	move	@pl2sqsh,A0,W	
	inc	A0
	move	A0,@pl2sqsh,W
	cmpi	2,A0
	jrle	SkBon2
	;GIVE BIG BONUS
	movi	P2DATA,A2
	movi	>1000,A1
	calla	SCORE
	calla	PUT1K
SkBon2:
SqshIncd:

	movi	SQISHSND,A0
	calla	ONESND
	move	A8,A0
	calla	SETTZPOS
	calla	DELSHAD
	calla	ZCHECK

	calla	ClrVel
	movi	SQUISH,A9
	movk	1,A1
	jsrp	FRANIM

	DECW	@BUGCNT

	SLEEP	20
	MOVI	[1,1],A9
	CREATE	0DFh,ESINK
	DIE			   
*************************************************************************


*************************************************************************
BugOn:
;* The bug slowly crawls up the players body,
;* the higher the bug is on the body the more damage it does.
;* If the Player jumps, the bug is knocked loose. 
	calla	ClrVel

	move	*A13(VICTIM),A1,L
	jrz	BugOff
	move	*A1(OZPOS),*A13(OLDZPOS),W
	move	*A1(OYPOS),*A13(OLDYPOS),W
	move	*A1(OXVEL+16),*A13(VOLDXV),W

	calla	GETANIX
	move	A0,A2
	move	A8,A3
	move	A1,A8
	calla	GETANIX
	move	A8,A1
	move	A3,A8
	sub	A0,A2
	move	A2,*A13(XDIFF),W

	move	A1,A0
	calla	GetPData
	jrz	BugOff
	move	A0,*A13(VICTIMDATA),L

	movi	BITE,A9
	clr	A0
	move	*A1(OZPOS),A2,W
	move	A2,A4
	inc	A4
	move	*A8(OZPOS),A3,W
	cmp	A2,A3
	jrnn	SkOnBack
	movk	1,A0
	subk	2,A4
	movi	BBITE,A9
SkOnBack:	
	movb	A0,*A13(OnBack)
	move	A4,*A8(OZPOS),W

	;* Don't always start anim on first frame..
	movk	3,A0
	calla	RANDU
	dec	A0
	sll	4,A0
	add	A0,A9
	sll	1,A0
	add	A0,A9
	
CrawlLp:
	move	*A13(VICTIMDATA),A1,L
	move	*A1(POBJ),A2,L
	jrnz	SkNoPlay
	calla	ClrVel
	jruc	BugOff
SkNoPlay:
	move	*A1(PFLAGS),A2,L
	btst	BDEAD,A2
	jrnz	SkObjRst
	move	*A1(POBJ),*A13(VICTIM),L
SkObjRst:

	;* check if Player is changing directions
	move	*A13(VICTIM),A1,L
	move	*A1(OXVEL+16),A2,W
	move	*A13(VOLDXV),A3,W
	cmp	A2,A3
	jreq	SkShake
	move	A2,*A13(VOLDXV),W
	jruc	ShakeOff
SkShake:
	
	;* check if Player is jumping
;	move	*A13(VICTIM),A1,L
;	move	*A1(OYVEL),A2,L
;	move	*A1(OZVEL),A3,L
;	sub	A3,A2
;	jrn	ShakeOff

	calla	GETANIX
	move	A0,A2
	move	A8,A3
	move	A1,A8
	calla	GETANIX
	move	A8,A1
	move	A3,A8
	sub	A0,A2
	move	*A8(OXPOS),A0,W
	sub	A2,A0
	move	*A13(XDIFF),A3,W
	jrz	SkXDiff
	add	A3,A0	
	move	A3,A3
	jrp	SkIncXD
	addk	2,A3
SkIncXD:
	dec	A3
	move	A3,*A13(XDIFF)
SkXDiff:
	move	A0,*A8(OXPOS),W

	move	*A1(OZPOS),A0,W
	move	*A13(OLDZPOS),A2,W
	move	A0,*A13(OLDZPOS),W
	sub	A2,A0
	move	*A8(OZPOS),A2,W
	add	A0,A2
	move	A2,*A8(OZPOS),W

	move	*A1(OYPOS),A3,W
	move	A3,A4
	addk	5,A4				;Max Height Bug will climb to...
	move	*A13(OLDYPOS),A2,W
	move	A3,*A13(OLDYPOS),W
	sub	A2,A3
	dec	A3
	move	*A8(OYPOS),A2,W
	add	A3,A2
	cmp	A4,A2
	jrge	SkMaxY
	move	A4,A2
SkMaxY:
	move	A2,*A8(OYPOS),W

	;* cause BITE damage
	sub	A4,A2   	;how many pixels from the top?
	sll	8,A2
	movi	>1E00,A0
	sub	A2,A0
	move	*A13(VICTIMDATA),A2,L
	calla	BUGBITE

	movb	*A13(ANIMTIKS),A0
	jrnz	AnimX1
	movk	4,A1			;* one frame, no sleepin
	jsrp	FRANIM
	move	*A9,A1,L
	jrnz	LstLft

	;* recycle animation
	move	A0,A6
	MOVI	BBITESND,A0
	CALLA	ONESND
	move	A6,A0
	movb	@RAND,A1
	jrn	SkFlp
	move	@RAND,A1,W
	jrn	yflp
	calla	NOYFLP
	jruc	SkFlp
yflp:	
	calla	YFLP
SkFlp:
	movb	*A13(OnBack),A1
	jrnz	BackBite
	movi	BITE2,A9
	jruc	LstLft
BackBite:
	movi	BBITE,A9
LstLft:
	movb	A0,*A13(ANIMTIKS)
AnimX1:
	movb	*A13(ANIMTIKS),A0
	subk	2,A0
	jrnn	SkClrAnT
	clr	A0
SkClrAnT:
	movb	A0,*A13(ANIMTIKS)
	SLEEP	2
	jruc	CrawlLp

ShakeOff:
	move	*A1(OYVEL),A2,L
	movi	>30000,A0
	calla	RANDU
	subi	>4000,A0
	sub	A0,A2
	move	A2,*A8(OYVEL),L

	move	*A1(OZVEL),A2,L
	movi	>20000,A0
	calla	RANDU
	subi	>10000,A0
	add	A0,A2
	move	A2,*A8(OZVEL),L

	move	*A13(VOLDXV),A2,W
	sll	16,A2
	movi	>80000,A0
	calla	RANDU
	subi	>40000,A0
	add	A0,A2
	move	A2,*A8(OXVEL),L

	;* Fling the Bug off	
	movi	BUGFLING,A9
	move	A9,*A13(ANIMPTR),L
	movk	3,A0
	movb	A0,*A13(FLYING)
	movi	128,A0
	movb	A0,*A13(BRAINTIKS)
	movb	A0,*A13(DESTTIKS)

BugOff:
	;Switch back to regular Process
	MOVI	BUGCOLL,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER
	jruc	BUGGER2
*************************************************************************


*************************************************************************
BUGCOLL:
	.WORD	P1OID
	.LONG	BugPlCol
	.WORD	P2OID
	.LONG	BugPlCol
	.WORD	B1OID|BULLETID
	.LONG	BUGCOL0
	.WORD	B1OID|EXPLODID
	.LONG	BUGCOL0
	.WORD	B1OID|ROCKETID
	.LONG	BUGCOL0
	.WORD	B2OID|BULLETID
	.LONG	BUGCOL0
	.WORD	B2OID|EXPLODID
	.LONG	BUGCOL0
	.WORD	B2OID|ROCKETID
	.LONG	BUGCOL0
	.WORD	BEOID|EXPLODID
	.LONG	BUGCOL0
	.word	C1OID		;ENEMY CAR #1 "CADILLAC" OBJECT I.D.
	.LONG	BUGCOL0
	.word	CAR2OID		;ENEMY CAR #2 "PORSCHE" OBJECT I.D.
	.LONG	BUGCOL0
	.word	CAR3OID		;ENEMY CAR #3 "BELL-JET" OBJECT	I.D.
	.LONG	BUGCOL0
	.word	TRAN1OID	;PLAYER TRANSPORT #1 "PORSCHE" OBJECT I.D.
	.LONG	BUGCOL0
	.WORD	0
	.LONG	DUMRTSG
*************************************************************************

*************************************************************************
BUGCOLL2:
	.WORD	B1OID|BULLETID
	.LONG	BUGCOL0
	.WORD	B1OID|EXPLODID
	.LONG	BUGCOL0
	.WORD	B1OID|ROCKETID
	.LONG	BUGCOL0
	.WORD	B2OID|BULLETID
	.LONG	BUGCOL0
	.WORD	B2OID|EXPLODID
	.LONG	BUGCOL0
	.WORD	B2OID|ROCKETID
	.LONG	BUGCOL0
	.WORD	0
	.LONG	DUMRTSG
*************************************************************************


*************************************************************************
BUGWATCH:
;* PROCESS TO WATCH BUGS, awards multi squash bonus, controls bug theme song
	
	clr	A11		;p2:p1 ctrs for clearing squash ctrs
	clr	A10		;last p2ct:last p1ct
WatchLp:
	move	@BUGCNT,A0,W
	jrz	WATCHX

	;Trigger bug tune?
	move	@BUGCNT,A0,W
	cmpi	3,A0
	jrlt	SkTune
	movi	HELLBUGS,A0
	calla	ONESND
SkTune:

	;update time ctrs
	movi	[1,1],A0
	addxy	A0,A11

	;update pl1 last squish ct
	move	A10,A0
	zext	A0,W
	move	@pl1sqsh,A1,W
	cmp	A0,A1
	jreq	SkUpdSq1
	movx	A1,A10
	clr	A0
	movx	A0,A11
SkUpdSq1:

	;update pl2 last squish ct
	move	A10,A0
	srl	16,A0
	move	@pl2sqsh,A1,W
	cmp	A0,A1
	jreq	SkUpdSq2
	sll	16,A1
	movy	A1,A10
	clr	A0
	movy	A0,A11
SkUpdSq2:
	
	;check to clear player 1's squash ctr
	move	A11,A0
	zext	A0,W
	cmpi	5,A0
	jrlt	SkClrCt1
	clr	A0
	movx	A0,A11
	move	A0,@pl1sqsh,W
SkClrCt1:

	;check to clear player 2's squash ctr
	move	A11,A0
	srl	16,A0
	cmpi	5,A0
	jrlt	SkClrCt2
	clr	A0
	movy	A0,A11
	move	A0,@pl2sqsh,W
SkClrCt2:

	SLEEP	10
	jruc	WatchLp

WATCHX:
	;stop hellbugs
	movi	YAMOFF,A0
	calla	ONESND

	clr	A0
	move	A0,@pl1sqsh,W
	move	A0,@pl2sqsh,W
	DIE
*************************************************************************


*************************************************************************
;WALKING JUMPING DEATH FRAGMENT STANDING-SHOOT KNEELING-SHOOT
;STANDING KNEELING

BUGOFF	.WORD	1,3,4,9,18,34,50,50
*ANIMATION PTR TABLE, FIRST LONG WORD IS THE OFFSET PTR
*
BUGTAB	.LONG	BUGOFF
	.LONG	BUGCRAWL,BUGCRAWL,BUGCRAWL,BUGDIE,BUGDIVE,BUGDIVE,BUGDIVE,BUGDIVE

	.LONG	0,FRAG1,FRAG2,FRAG3,FRAG4,FRAG5,FRAG6,0
*************************************************************************


**************************************************************************
* BUG FRAME TABLES	
CRAWLXVEL	.set	>18000
JUMPXVEL	.set	>30000
FLYXVEL		.set	>38000


BUGCRAWL:
	.long	bugwk1
	.word	5
	.long	bugwk2
	.word	5
	.long	bugwk3
	.word	5
	.long	bugwk4
	.word	5
	.long	bugwk5
	.word	5
	.long	bugwk6
	.word	5
	LONGNULL
BUGCRAWLX:

BUGJUMP:
	.long	bugfly1
	.word	2
	.long	bugfly2
	.word	2
	.long	bugfly3
	.word	2
	.long	bugfly4
	.word	2
	.long	bugfly3
	.word	2
	.long	bugfly2
	.word	2
	LONGNULL
BUGJUMPX:

BUGWIGGL:
	.long	bugfly5
	.word	1
	.long	bugfly6
	.word	1
	.long	bugfly7
	.word	1
	.long	bugfly8
	.word	1
	.long	bugfly7
	.word	1
	.long	bugfly6
	.word	1
	LONGNULL

BUGFLY:
	.long	bugfly5
	.word	2
	.long	bugfly6
	.word	2
	.long	bugfly7
	.word	2
	.long	bugfly8
	.word	2
	.long	bugfly7
	.word	2
	.long	bugfly6
	.word	2
	LONGNULL
BUGFLYX:

BITE:
	.long	bugjmp1
	.word	5
	.long	bugjmp2
	.word	5
	.long	bugjmp3
	.word	5
	LONGNULL

BITE2:
	.long	bugjmp4
	.word	5
	.long	bugjmp3
	.word	5
	.long	bugjmp2
	.word	5
	.long	bugjmp3
	.word	5
	LONGNULL

BBITE:
	.long	bugdie6
	.word	5
	.long	bugdie5
	.word	5
	.long	bugdie4
	.word	5
	.long	bugdie5
	.word	5
	LONGNULL

BUGFALL:
	.long	bugfly1
	.word	1
	.long	bugfly2
	.word	1
	.long	squish1
	.word	1
	.long	bugfly4
	.word	1
	.long	squish1
	.word	1
	.long	bugfly2
	.word	1
	LONGNULL

BUGFLING:
	.long	bugjmp1
	.word	4
	.long	bugjmp4
	.word	4
	.long	bugdie2
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie3
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie4
	.word	FLIPBITS|4,M_FLIPH
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPH
	LONGNULL

BUGDIVE:
	.long	bugjmp1
	.word	4
	.long	bugjmp4
	.word	4
	.long	bugdie2
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie3
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie4
	.word	FLIPBITS|4,M_FLIPH
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPH
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPH|M_FLIPV
	.long	bugdie6
	.word	FLIPBITS|4,M_FLIPV|M_FLIPH
	.long	bugdie6
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie5
	.word	4
	LONGNULL

BUGDIE:
	.long	bugjmp1
	.word	5
	.long	bugdie2
	.word	FLIPBITS|5,M_FLIPV
	.long	bugdie3
	.word	FLIPBITS|5,M_FLIPV
	.long	bugdie4
	.word	FLIPBITS|5,M_FLIPH
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPH
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPH|M_FLIPV
	.long	bugdie6
	.word	FLIPBITS|4,M_FLIPV|M_FLIPH
	.long	bugdie6
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie5
	.word	FLIPBITS|4,M_FLIPV
	.long	bugdie5
	.word	6
	.long	bugdie4
	.word	7
	.long	bugdie5
	.word	6
	LONGNULL

SQUISH:
	.long	squish2
	.word	10
	LONGNULL

BUGBURN:
	.long	squish1
	.word	10
	.long	squish2
	.word	10
	LONGNULL

FRAG1
	.long	CSHRAPA1
	.word	NEWPALET|3
	.LONG	NARCS
	.long	CSHRAPA2
	.word	3
	.long	CSHRAPA3
	.word	3
	.long	CSHRAPA4
	.word	3
	.long	CSHRAPA5
	.word	3
	.LONG	0

FRAG2
	.long	CSHRAPB1
	.word	NEWPALET|2
	.LONG	NARCS
	.long	CSHRAPB2
	.word	2
	.long	CSHRAPB3
	.word	3
	.long	CSHRAPB4
	.word	2
	.long	CSHRAPB5
	.word	2
	.LONG	0

FRAG3
	.long	CSHRAPC1
	.word	NEWPALET|2
	.LONG	NARCS
	.long	CSHRAPC2
	.word	2
	.long	CSHRAPC3
	.word	3
	.long	CSHRAPC4
	.word	2
	.long	CSHRAPC5
	.word	3
	.LONG	0

FRAG4
	.long	CSHRAPD1
	.word	NEWPALET|3
	.LONG	NARCS
	.long	CSHRAPD2
	.word	2
	.long	CSHRAPD3
	.word	3
	.long	CSHRAPD4
	.word	2
	.long	CSHRAPD5
	.word	3
	.LONG	0

FRAG5
	.long	CSHRAPE1
	.word	NEWPALET|3
	.LONG	NARCS
	.long	CSHRAPE2
	.word	2
	.long	CSHRAPE3
	.word	3
	.long	CSHRAPE4
	.word	2
	.long	CSHRAPE5
	.word	3
	.LONG	0

FRAG6
	.long	CFRAG1
	.word	NEWPALET|3
	.LONG	NARCS
	.long	CFRAG2
	.word	2
	.long	CFRAG3
	.word	2
	.long	CFRAG4
	.word	2
	.long	CFRAG5
	.word	2
	.LONG	0

	.END
