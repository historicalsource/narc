 	.FILE	'NARCMUGS.ASM'
	.TITLE	" <<< N  A  R  C  -- Mug Plotter >>>"
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
	.INCLUDE	"NARCAUDN.ASM"
	.INCLUDE	"imgtbl.glo"
***	.INCLUDE	"BGNDTBL.GLO"

	.TEXT

	.INCLUDE	"NARCMUGS.TBL"		;Image Label Equates

	.GLOBAL		mainBMOD,dashBMOD
	.GLOBAL		ledsBMOD,handBMOD
	.GLOBAL		k3,voice,SCANPAL1,SCANPAL2
	.GLOBAL		rmanBMOD,bmanBMOD,porsBMOD
	.GLOBAL		FBIBADGE,TITLPAGE,CRDTPAGE
	.GLOBAL		GET_ADJ
	.globl	NARCsupr
	.globl	BIGncar,blegs5a,bltor4d,redarm,newred3,newred2,newred1

	.BSS	FADERAM1,16*257,1	;room for palette fades
	.BSS	FADERAM2,16*257		;room for palette fades
	.BSS	FADERAM3,16*257		;room for palette fades
	.BSS	FADERAM4,16*257		;room for palette fades
	.BSS	FADERAM5,16*257		;room for palette fades
	.BSS	FADERAM6,16*257		;room for palette fades

	.BSS	TitlPg,16,1

	.BSS	msgptr,32
	.BSS	msgpos,32
	.BSS	voiceoff,16
	.BSS	precrim2,16

	.BSS	palptrs,32*20
	.BSS	palslots,16*20
	.BSS	CRIMEPAL,16,1
	
narc1S		.WORD	>F010,>1,>805a,0 ;narc one
readmeS		.WORD	>F000,>1,>805b,0 ;do you read me
whereruS	.WORD	>F010,>1,>805c,0 ;where are you
getonitS	.WORD	>F010,>1,>805d,0 ;get on it
nicejobS	.WORD	>F000,>1,>805e,0 ;nice job
backupS		.WORD	>F010,>1,>805f,0 ;we need backup
sarmedS		.WORD	>F010,>1,>8060,0 ;suspect armed
armedS		.WORD	>F000,>1,>8061,0 ;armed
attnS		.WORD	>F010,>1,>806a,0 ;attn all units
apbS		.WORD	>F010,>1,>806b,0 ;APB
atlargeS	.WORD	>F010,>1,>806c,0 ;At Large
apprS		.WORD	>F010,>1,>806d,0 ;apprehend
prgrssS		.WORD	>F010,>1,>806e,0 ;in progress
possiblS	.WORD	>F010,>1,>806f,0 ;possible
watchS		.WORD	>F010,>1,>8074,0 ;watch it
allunitsS	.WORD	>F010,>1,>8078,0 ;all units
pickupS		.WORD	>F010,>1,>8071,0 ;pickem up
coderedS	.WORD	>F010,>1,>8072,0 ;code red
sightedS	.WORD	>F010,>1,>8076,0 ;sighted
bustemS		.WORD	>F010,>1,>8073,0 ;bust em

letsgoS		.WORD	>F011,>1,>8027,0 ;lets go
rogerS		.WORD	>F011,>1,>8028,0 ;roger chief
onrwayS		.WORD	>F011,>1,>802b,0 ;were on our way
wegotitS	.WORD	>F011,>1,>802d,0 ;we got it

cdclozS		.WORD	>F000,>1,>8019,0 ;car door close
revS		.WORD	>F000,>1,>800e,0 ;rev
squealS		.WORD	>F000,>1,>800f,0 ;squeal

UDIE1SND	.WORD	>F040,>40,>80b8,0 ;13.3Khz You Die
SLOWLAFF	.WORD	>F040,>40,>80B5,0 ;13.3Khz Laugh

SND2b		.WORD	>F000,>1,>8062,0 ;two
SND3c		.WORD	>F010,>1,>8063,0 ;three
SND4b		.WORD	>F010,>1,>8064,0 ;four
SND5a		.WORD	>F010,>1,>8065,0 ;five
SND6a		.WORD	>F010,>1,>8066,0 ;six
SND7a		.WORD	>F010,>1,>8067,0 ;seven
SND1b		.WORD	>F010,>1,>8068,0 ;2nd one
SND1c		.WORD	>F010,>1,>8069,0 ;3rd one
SND2c		.WORD	>F010,>1,>8077,0 ;3rd two
SND511		.WORD	>F010,>1,>8090,0
SND773		.WORD	>F010,>1,>809a,0
SND742		.WORD	>F010,>1,>80A0,0
SND613		.WORD	>F010,>1,>8098,0
SND712		.WORD	>F010,>1,>809d,0

BEEPSND		.WORD	>F300,>1,>80A4,0
KLIKSND		.WORD	>F000,>1,>800C,0	;text click
KLIK1SND	.WORD	>F000,>1,>8053,0	;text click
KLIK2SND	.WORD	>F000,>1,>8054,0	;text click
BOOMSND		.WORD	>F001,>1,>8049,0	;Bust Boom
FOCUSSND	.WORD	>F300,>1,>80A3,0

MSUX	.set	-1

SCANMAIN:
	.long	mainBMOD
	.WORD	MSUX,-1+SKYTOPOF		;x,y start pos.
	.long	dashBMOD
	.WORD	MSUX+147,314+SKYTOPOF	;x,y start pos.
	.long	ledsBMOD
	.WORD	MSUX+13,44+SKYTOPOF		;x,y start pos.
	.long	handBMOD
	.WORD	MSUX+201,311+SKYTOPOF	;x,y start pos.
	.LONG	>FFFFFFFF

SCANHAND:
	.long	dashBMOD
	.WORD	MSUX+147,314+SKYTOPOF	;x,y start pos.
	.long	ledsBMOD
	.WORD	MSUX+13,44+SKYTOPOF		;x,y start pos.
	.long	handBMOD
	.WORD	MSUX+201,311+SKYTOPOF	;x,y start pos.
	.LONG	>FFFFFFFF


DASHLED_Z	.set	75
SCANLED_Z	.set	76
RDRLED_Z	.set	77
ALERT_Z		.set	78
SPKR_Z		.set	79
BUTBOX_Z	.set	80	
HAND_Z		.set	81
NumLed	.set	5	;# of LEDS
NumSpkr	.set	6	;# speaker parts
NumHand	.set	2	;# num hand parts

SpkrOff	.set	(NumLed+1)*>20
BoxOff	.set	(NumSpkr+NumLed+1)*>20
HandOff	.set	(NumSpkr+NumLed+1+1)*>20

;* must load ptrs to objects in the following order
; LEDS, ALERT, SPEAKER PIECES


SCANDATA	.set	PDATA		;ptr to object block for extra storage
SCANSTCK	.set	PDATA+20	;remainder of space is temp storage


TITLSCR1:
	.long	rmanBMOD
	.WORD	56,120		;x,y start pos.
	.long	porsBMOD
	.WORD	70,200		;x,y start pos.
	.LONG	>FFFFFFFF
TITLSCR2:
	.long	rmanBMOD
	.WORD	56,120		;x,y start pos.
	.long	porsBMOD
	.WORD	70,200		;x,y start pos.
	.long	bmanBMOD
	.WORD	260,100		;x,y start pos.
	.LONG	>FFFFFFFF

;* STRUCTURE OF ROUNTINES
;
;	ALL OF THESE ROUTINES ARE DIRTY... THEY CLOBBER BOTH THE
; LOCAL PROCESS SPACE AND THE REGS A8-A11.  THEY ALSO DESTROY
; THE OBJ LIST WHICH MUST BE REINITIALIZED TO BE USED.
;
; PRECRIME
;	routine must be JSRPed to, it RETPs when time to commit CRIME.
;	Actions-
;		Clears out Object and Process lists.
;		Allocates and Fades in Dash.
;		Hand comes out presses 4 buttons as dash leds flash.
;		FBI\Warning Text on monitor fades in at 1st button press.
;		Entr Code text teletypes out.
;		Hand goes away.
;		Monitor Screen Clears.
;	Time- ~70 tiks
; VSCAN
;	VSCAN Process must be created when sound call in crime is triggered.
;	It requires parm (A10) telling it which Sound call was made.
;	Actions-
;		Voice scanner leds go active.
;		Radar led flashes.
;		Speaker Grill Animates???
;		Voice Scanner Freezes
;		Voice Match Text comes up.
;		Process Dies - length depends on Sound Call #.
;
;POSTCRIME
;	routine must be JSRPed to, it RETPs when ready to start game wave.
;	Actions -
;		Alert Light Flashes - Alarm Sound triggered
;		Hand presses buttons, dash leds flash.
;		Mugshot Zooms in, monitor leds flash.
;		Mission text displayed.
;		1/2 second wait for player to read.
;	Time- ~90 tiks
;
;FBIBADGE
;	routine must be JSRPed to
;	Actions-
;		Clears out Object and Process lists.
;		Clears Screen.
;		Unpacks and plots FBI,BADGE,"winners dont use drugs"
;			with palette blacked out
;		Fades up palette.
;	Time- ~10 tiks
;
;TITLPAGE
;	routine must be JSRPed to
;	Actions-
;		Clears out Object and Process lists.
;		Clears Screen.
;		Unpacks and plots NARC stamp with palette blacked out
;		runs bgnd system to bring out PORSCHE and PLAYERS
;		sutffs NARC stamp palette
;		unpacks and plots all mug shots
;		Fades up palette.
;	Time- ~10 tiks
;CRDTPAGE
;	alternate entry point for TITLPAGE which skips bringing out
;	the PORSCHE and PLAYERS and text
;	Time- ~10 tiks


*************************************************************************
****** ENTRY POINT ******
TestPlot:
	jsrp	PRECRIME
;	CREATE	BLINKPID,Led3Blnk	 ;Flash Alert Light

	;* CRIME OCCURS HERE
	sleep	30
	calla	OINIT
	calla	WRAMINIT
	movk	1,A0
	MOVE	A0,@DISPLAYON,W	;TURN ON DISPLAY PROC.

	CREATE	VOXPID,VSCAN	  ;Start Voice Scanner - Needs crimeno
	SLEEP	160

	jsrp	POSTCRIME	  ;Needs crimeno
	SLEEP	30
	callr	MSUCLEAR
	jruc	$
*************************************************************************

*************************************************************************
PRECRIM2:
;* alternate entry point to skip hand shit
	movk	1,A0
	jruc	DoPreCrm
PRECRIME:
;* After this routine executes, 4 fgnd palettes are allocated for the
;* Dash Panel, and these palettes cannot be freed until the Dash Panel
;* is entirely gone from the screen.
;* Those palettes need to be freed by a routine UNGETPAL which releases
;* a palette regardless of its allocation count.
	clr	A0
DoPreCrm:
	;delete this after debuggery
;	movi	>FFFC,A0
;	MOVE	A0,@DPYSTRT,W		;HIDE THE SCORE AREA
;	jsrp	FBIBADGE
;	jsrp	TITLPAGE
;	jruc	$
	move	A0,@precrim2,W
	clr	A0
	move	A0,@CRIMEPAL,W		;if CRIMEPAL=0 in MSUCLEAR, no FREEPAL
	CALLA	AUTOEOFF
	clr	A0
	move	A0,@GAMERASE,W
	MOVE	A0,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	move	@precrim2,A0,W
	jrnz	SkFbi
	jsrp	FbiText
	jruc	FbiDone
SkFbi:
	calla	CLRPAL
	movi	NARCS,A0
	calla	GETFPAL
FbiDone:

	calla	OINIT
	calla	WRAMINIT

	CREATE	ATTNPID,AttnSnd

	clr	A0
	move	A0,@SCRNTL,L
	movi	[479,511],A0
	move	A0,@SCRNLR,L

	jsrp	PrePalloc		;preload pals in fgnd pal slots
	movi	SCANMAIN,A0
	move	A0,@BAKMODS,L
	calla	BGND_UD1
	calla	GetObjs
	move	*A13(SCANDATA),A10,L	;Pass data object ptr
	movk	1,A8			;print password code
	clr	A9
	move	@precrim2,A0,W
	jrnz	NoButs
	movk	4,A9			;# of buttons to push
NoButs:
	clr	A11			;Initial Sleep Time
	CREATE	HANDPID,Hand1
	CREATE	FADEPID,Fader
	SLEEP	1
	movk	1,A0
	MOVE	A0,@DISPLAYON,W	;TURN ON DISPLAY PROC.

	move	@precrim2,A0,W
	jrnz	ShortSlp
	callr	PutPass	;Puts out Password MSG
	jsrp	CkHand
	callr	ClrMsg
	SLEEP	1
	callr	UnFbiText
	jruc	PreCX
ShortSlp:
	SLEEP	16
PreCX:
	RETP
*************************************************************************
	

*************************************************************************
POSTCRIME:
	CLR	A0
	MOVE	A0,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	;* Get Manipulable objects loaded onto object list
	calla	OINIT
	calla	WRAMINIT
	callr	DiviOLst
	PUSHP	A11		;push ret val from DiviOLst
	clr	A0
	move	A0,@SCRNTL,L
	movi	[479,511],A0
	move	A0,@SCRNLR,L

	movi	SCANHAND,A0
	move	A0,@BAKMODS,L
	calla	BGND_UD1
	calla	GetObjs
	move	*A13(SCANDATA),A10,L	;Pass data object ptr
	clr	A8			;no printing
	movk	3,A9			;# of buttons to push
	clr	A11			;Initial Sleep Time
	CREATE	HANDPID,Hand1
	movk	15,A9	;# times to flash Alert
****	CREATE	ALERTPID,AlertBlink
	SLEEP	1
	movk	1,A0
	MOVE	A0,@DISPLAYON,W	;TURN ON DISPLAY PROC.
	mmtm	SP,A0,A1,A7
	CREATE	ATTNPID,MssnSnd
	mmfm	SP,A0,A1,A7
	CREATE	BLINKPID,Led2Blnk
	jsrp	CkHand

	PULLP	A11	;addr to unpack to
	jsrp	DoMug
****	jsrp	FADEOUT
	MOVI	[28+SKYTOPOF,126],A3	
	MOVI	[200,256],A4
	CALLA	BLNKAREA		;WIPE-OUT ANY LEFT OVER DATA

	callr	KilBlnk
	RETP

;	move	*A13(SCANDATA),A10,L	;Pass data object ptr
;	CREATE	BLINKPID,LedBlink
;	CREATE	ALERTPID,AlertBlink
;	CREATE	SPKRPID,SpkrMove
;	CREATE	VOXPID,VOX
*************************************************************************

**************************************************************************
KilBlnk:
;* function to kill blink procs
	mmtm	SP,A0,A1
KillBPID:
	NOMATCHP	BLINKPID,>FFFF,SkBKill
	calla	KILL
	jruc	KillBPID
SkBKill:
	mmfm	SP,A0,A1
	rets
**************************************************************************

**************************************************************************
CkHand:
;* function to wait for hand to go away
	NOMATCHP	HANDPID,>FFFF,SkHKill
	sleep	1
	jruc	CkHand
SkHKill:
	retp
**************************************************************************

*************************************************************************
FBIBADGE:
;* put FBI BADGE and "winners dont use drugs" out
	movi	NARCS,A0
	calla	GETFPAL
	calla	CLR_SCRN

	CALLA	AUTOEOFF
	clr	A0
	move	A0,@GAMERASE,W
	MOVE	A0,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	calla	MYOINIT
	callr	DiviOLst
	calla	WRAMINIT

	movi	FADERAM1,A0
	movi	128,A1
	clr	A2
ClrBLp:
	move	A2,*A0+,L
	dsjs	A1,ClrBLp

	;* Start Palette off BLACKED OUT
	movi	FADERAM1,A0
	clr	A8			;badge4 will get pal 0
	move	A8,A1		
	sll	24,A1
	srl	16,A1
	movi	256,A2
	calla	PALSET
	
BADGE_X	.set	50
BADGE_Y	.set	60

	move	A8,A1
	movi	badge,A0
	movi	[0+BADGE_Y,191+BADGE_X],A3
	callr	UnpckPl2

	move	A8,A1
	movi	fbity1,A0
	movi	[223+BADGE_Y,0+BADGE_X],A3
	callr	UnpckPl2

	move	A8,A1
	movi	fbity2,A0
	movi	[223+BADGE_Y,248+BADGE_X],A3
	callr	UnpckPl2

	move	A8,A1
	movi	fbiseal,A0
	movi	[13+BADGE_Y,61+BADGE_X],A3
	callr	UnpckPl2

	calla	CLRPAL
	movi	badge4,A0
	calla	GETFPAL
	move	A0,A8

;	clr	A9		;fade %
;BdgeFade:
;	addk	16,A9
;	move	A9,A2
;	movi	FADERAM1,A0
;	movi	badge4,A1
;	callr	FadePal
;
;	movi	FADERAM1,A0
;	move	A8,A1
;	sll	8,A1
;	move	*A0+,A2,W
;*A0= PALSRC = 32 BIT SOURCE ADDRESS OF PALETTE COLOR DATA 	
;*A1= PALDEST = BIT 8-15 DESTINATION PALETTE | BIT 0-7 START COLOR
;*A2= PLDCNT = 16 BIT COLOR COUNT
;	calla	PALSET
;	SLEEP	1
;
;	cmpi	128,A9
;	jrlt	BdgeFade
;
	move	A8,A0
	calla	UNGETPAL

	SLEEP	60*4		;4 seconds
	RETP
*************************************************************************


*************************************************************************
CRDTPAGE:
	clr	A0
	jruc	DOPAGE
TITLPAGE:
	movk	1,A0
DOPAGE:
	move	A0,@TitlPg,W
;* put attract mode title page on screen
	CALLA	AUTOEOFF
	clr	A0
	move	A0,@GAMERASE,W
	MOVE	A0,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	calla	MYOINIT
	callr	DiviOLst	;rets A11 ptr to unpack space
	PUSHP	A11
	calla	WRAMINIT

	movi	NARCS,A0
	calla	GETFPAL
	SLEEP	1
	calla	CLR_SCRN

	;* PREALLOCATE ALL PALETTES
	movi	TITLPALS,A11
	movi	palslots,A10
	movi	palptrs,A9
	movk	3,A7
PallocLp:
	move	*A11+,A0,L
	move	A0,*A9+,L
	jrz	PallocX
	calla	GETBPAL
	move	A0,*A10+,W
	dsjs	A7,PallocLp
	SLEEP	1
	movk	3,A7
	jruc	PallocLp	
PallocX:
	SLEEP	1

	;* Black out all palettes
	movi	FADERAM1,A0
	movi	128,A1
	clr	A2
ClrB2Lp:
	move	A2,*A0+,L
	dsjs	A1,ClrB2Lp

	movi	palslots,A10
	movi	palptrs,A9
	movk	3,A7
BlackLp:
	move	*A9+,A0,L	;are we at end of list?	
	jrz	BlackX
	movi	FADERAM1,A0
	move	*A10+,A1,W	;load palslot
	sll	24,A1
	srl	16,A1
	movi	256,A2
	calla	PALSET
	dsjs	A7,BlackLp
	SLEEP	1
	movk	3,A7
	jruc	BlackLp	
BlackX:
	SLEEP	1

;* unpack and print all run length coded stuff.
	PULLP	A11
	movi	NARCsupr,A0
	calla	GETBPAL
	move	A0,A1
	movi	NARCALF1a,A0
	movi	[2,51],A3
	callr	UnpckPl2

	PUSHP	A1
	SLEEP	1
	PULLP	A1

;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A3 packed Y:X screen coors to plot the image
;	A11 address to unpack to
	movi	NARCALF2,A0
	movi	[2,256],A3
	callr	UnpckPl2

	SLEEP	1
	
	movi	mbigmug,A0
	movi	[0,0],A3
	movi	[36,108],A10
	callr	BordrMug

	movi	loafmug,A0
	movi	[134,0],A3
	movi	[35,133],A10
	callr	BordrMug

	SLEEP	1

	movi	rambomug,A0
	movi	[268,0],A3
	movi	[50,95],A10
	callr	BordrMug

	movi	clownmug,A0
	movi	[0,472],A3
	movi	[65,155],A10
	callr	BordrMug

	SLEEP	1

	movi	dumpmug,A0
	movi	[134,472],A3
	movi	[61,105],A10
	callr	BordrMug

	movi	hypomug,A0
	movi	[268,472],A3
	movi	[45,100],A10
	callr	BordrMug

	SLEEP	1

	;Put out the PORSCHE and players
	move	@TitlPg,A0,W
	jrz	FadeUp

	movk	1,A0
	MOVE	A0,@DISPLAYON,W	;TURN ON DISPLAY PROC.
	clr	A0
	move	A0,@SCRNTL,L
	movi	[479,511],A0
	move	A0,@SCRNLR,L

	movi	TITLSCR2,A0
	move	A0,@BAKMODS,L
	calla	BGND_UD1
	SLEEP	2

	CLR	A0
	MOVE	A0,@GAMERASE,W		;TURN OFF GAME AUTO ERASE
	CALLA	AUTOEOFF
	MOVI	BUPDPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL			;KILL THE BACKGROUND UPDATE
	CALLA	SYNCHALF
	CALLA	SYNCFULL
	CLR	A0
	MOVE	A0,@DISPLAYON
	CALLA	DMAQWAIT
	CALLA	MYOINIT			;INITIALIZE OBJECT LIST
	MOVK	1,A0
	MOVE	A0,@DISPLAYON

	;DO NOGUTS
	movi	noguts,A8,L
	movi	[366,73],A9,L
NoGutsLp:
	move	*A8,A0,L
	jrz	NoGutsX
	ADJUST	ADJMUSIC
	JRNZ	NONGSND
	SOUND1	KLIKSND
NONGSND
	MOVK	3,A0		;teletype w/ sleep
	MOVI	0FEFEH,A6
	MOVI	RD15FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM
	jruc	NoGutsLp
NoGutsX:

	SLEEP	60

	;DO UNTIL NOW
	movi	until,A8,L
	movi	[366,315],A9,L
UntilLp:
	move	*A8,A0,L
	jrz	UntilX
	ADJUST	ADJMUSIC
	JRNZ	NOUNSND
	SOUND1	KLIKSND
NOUNSND
	MOVK	3,A0		;teletype w/ sleep
	MOVI	0FEFEH,A6
	MOVI	RD15FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM
	jruc	UntilLp
UntilX:
	ADJUST	ADJMUSIC
	JRNZ	NOBMSND
	SOUND1	BOOMSND
NOBMSND
	;DO COPYRIGHT
	movi	cpyrgt,A8,L
	movi	[389,255],A9,L
	clr	A0		;No Sleep
	MOVI	0C0C0H,A6	;MEDIUM GREY
	MOVI	RD7FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRM

	;DO TRADEMARK
	movi	tm,A8,L
	movi	[137,423],A9,L
	clr	A0		;No Sleep
	MOVI	0FEFEH,A6
	MOVI	RD7FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM

FadeUp:
	;BRING ALL PALETTES OUT from Black
	movi	palslots,A10
	movi	palptrs,A9
	movk	4,A7
ShowLp:
	move	*A9+,A0,L	;are we at end of list?	
	jrz	ShowX
	move	*A10+,A1,W	;load palslot
	sll	24,A1
	srl	16,A1
	move	*A0+,A2,W
	calla	PALSET
	dsjs	A7,ShowLp
	SLEEP	1
	movk	4,A7
	jruc	ShowLp	
ShowX:
	move	@TitlPg,A0,W
	jrz	PageX

	;REPLOT TEXT TO COLOR CYCLE
	movi	noguts,A8,L
	movi	[366,73],A9,L
NoGuts2:
	move	*A8,A0,L
	jrz	NoGuts2X
	clr	A0
	MOVI	0F5F5H,A6
	MOVI	RD15FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM
	jruc	NoGuts2
NoGuts2X:
	movi	until,A8,L
	movi	[366,315],A9,L
Until2:
	move	*A8,A0,L
	jrz	Until2X
	clr	A0
	MOVI	0F5F5H,A6
	MOVI	RD15FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM
	jruc	Until2
Until2X:

	SLEEP	600	;10 seconds
PageX:
	SLEEP	3
	RETP

tm:
	.STRING "TM"
	.BYTE	0
noguts:
	.STRING	"N"
	.BYTE	0
	.STRING	"O"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"O"
	.BYTE	0
	.STRING	"N"
	.BYTE	0
	.STRING	"E"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"H"
	.BYTE	0
	.STRING	"A"
	.BYTE	0
	.STRING	"D"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"T"
	.BYTE	0
	.STRING	"H"
	.BYTE	0
	.STRING	"E"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"G"
	.BYTE	0
	.STRING	"U"
	.BYTE	0
	.STRING	"T"
	.BYTE	0
	.STRING	"S"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"."
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"."
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"."
	.BYTE	0
	.long	0
until:
	.STRING	" "
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"U"
	.BYTE	0
	.STRING	"N"
	.BYTE	0
	.STRING	"T"
	.BYTE	0
	.STRING	"I"
	.BYTE	0
	.STRING	"L"
	.BYTE	0
	.STRING	" "
	.BYTE	0
	.STRING	"N"
	.BYTE	0
	.STRING	"O"
	.BYTE	0
	.STRING	"W"
	.BYTE	0
	.STRING	"!"
	.BYTE	0
	.long	0
cpyrgt:
	.BYTE	>22	;quote
	.STRING	"NARC"
	.BYTE	>22	;quote
	.STRING	" COPYRIGHT 1988  WILLIAMS ELECTRONICS GAMES, INC."
	.BYTE	0
	.EVEN

TITLPALS:
	.long	NARCsupr
	.long	BIGncar,blegs5a,bltor4d,redarm,newred3,newred2,newred1
	.long	mbig4,clown4,loaf4,hypo4,rambo4,dump4
	.long	0
*************************************************************************

*************************************************************************
BordrMug:
;	A0 ptr to image frame
;	A10 starting Y:X in image
;	A11 address to unpack to
	mmtm	SP,A1,A2,A6,A11

	calla	LdImgPal

	move	A11,A2		;address to unpack to..
	calla	UnpackRLC

	movk	2,A2		;# bits per pixel
	move	A11,A6		;source address to plot from
	movi	[134,40],A11
	calla	Plt5Pack
	mmfm	SP,A1,A2,A6,A11
	rets
*************************************************************************

*************************************************************************
AttnSnd:
;* Process to make attention sounds
	move	@CRIMENO,A1,W
	sll	5,A1
	addi	ATTNSNDS,A1
	move	*A1,A8,L

AttnLp:
	move	*A8+,A0,L	;get sleep time
	jrz	SkAtnSlp
	calla	PRCSLP
SkAtnSlp:
	move	*A8+,A0,L	;get sound ptr
	jrz	AttnX
	calla	ONESND
	jruc	AttnLp
AttnX:
	DIE
*************************************************************************

*************************************************************************
MssnSnd:
;* Process to make mission sounds
	move	@CRIMENO,A1,W
	sll	5,A1
	addi	MSSNSNDS,A1
	move	*A1,A8,L

MssnLp:
	move	*A8+,A0,L	;get sleep time
	jrz	SkMsnSlp
	calla	PRCSLP
SkMsnSlp:
	move	*A8+,A0,L	;get sound ptr
	jrz	MssnX
	calla	ONESND
	jruc	MssnLp

MssnX:
	DIE
*************************************************************************


*************************************************************************
PrePalloc:
;* Allocate all of the scanner palettes in fgnd pal slots so bgnd system
;* will not use any bgnd palette slots
	movi	SCANPAL2,A0
	calla	GETFPAL
	movi	SCANPAL1,A0
	calla	GETFPAL
	SLEEP	1
	movi	voice,A0
	calla	GETFPAL
	movi	k3,A0
	calla	GETFPAL
	SLEEP	1
	retp
*************************************************************************

*************************************************************************
MSUCLEAR:
;* FREE UP PALETTES used by MSU
	move	@CRIMEPAL,A0,W	;if CRIMEPAL=0 no FREEPAL
	jrz	SkFreeP
	calla	UNGETPAL
SkFreeP:

	;Free Main Scanner Palettes
	movi	SCANPAL2,A0
	CALLA	FINDPAL
	jrz	SkUnget1
	calla	UNGETPAL
SkUnget1:
	movi	SCANPAL1,A0
	CALLA	FINDPAL
	jrz	SkUnget2
	calla	UNGETPAL
SkUnget2:
	movi	voice,A0
	CALLA	FINDPAL
	jrz	SkUnget3
	calla	UNGETPAL
SkUnget3:
	movi	k3,A0
	CALLA	FINDPAL
	jrz	SkUnget4
	calla	UNGETPAL
SkUnget4:
	movi	VOXPAL,A0
	CALLA	FINDPAL
	jrz	SkUnget5
	calla	UNGETPAL
SkUnget5:
	rets
*************************************************************************

*************************************************************************
FbiText:
;* plot out text to monitor screen.
;* must 'black out' palette data so text can be faded in after bringing
;* out the monitor.

	calla	MYOINIT
	callr	DiviOLst

	movi	fbitxt4,A0
	calla	GETFPAL
	move	A0,A8
	movi	warntxtp,A0
	calla	GETFPAL
	move	A0,A9

	movi	FADERAM1,A0
	movi	64,A1
	clr	A2
ClrPLp:
	move	A2,*A0+,L
	move	A2,*A0+,L
	dsjs	A1,ClrPLp

	;* Start Palettes off BLACKED OUT
	movi	FADERAM1,A0
	move	A8,A1		
	sll	24,A1
	srl	16,A1
	movi	256,A2
	calla	PALSET
	movi	FADERAM1,A0
	move	A9,A1		
	sll	24,A1
	srl	16,A1
	movi	256,A2
	calla	PALSET

	SLEEP	2

	;* clear screen to light Green Color
	move	A8,@DMACMAP,W
	movi	(>1000*(28+SKYTOPOF))+(8*(127+MSUX)),A0	;Dest Addr
	movi	>800,A1	;Dest Addr Vertical Adj
	movi	16,A2	;Doing 16 pixels per loop
	movi	200,A3	;height
	movi	>01010101,A5
NxtRow:
	move	A2,A4
PltRow:
	move	A5,*A0+,L
	move	A5,*A0+,L
	move	A5,*A0+,L
	move	A5,*A0+,L
	dsjs	A4,PltRow
	add	A1,A0
	dsjs	A3,NxtRow
	

	move	A8,A1
	movi	filestxt,A0
	movi	[47,166+MSUX],A3
	callr	UnpckPlt
	movi	authtxt,A0
	movi	[142,203+MSUX],A3
	callr	UnpckPlt
;	movi	entrtxt,A0
;	movi	[213,171+MSUX],A3
;	callr	UnpckPlt

	move	A9,A1
	movi	warntxt,A0
	movi	[102,201+MSUX],A3
	movk	6,A2	;# bits per pixel
	move	*A0(ISAG),A6,L		;source address to plot from
	calla	PlotPack
	RETP
*************************************************************************

*************************************************************************
ClrMsuScr:
	mmtm	SP,A0,A1,A2,A3,A4,A5
	;* clear MSU screen to BLACK
	movi	NARCS,A0
	calla	FINDPAL
	move	A0,@DMACMAP,W
	movi	(>1000*(28+SKYTOPOF))+(8*(127+MSUX)),A0	;Dest Addr
	movi	>800,A1	;Dest Addr Vertical Adj
	movi	16,A2	;Doing 16 pixels per loop
	movi	200,A3	;height
	clr	A5
NxtRow2:
	move	A2,A4
PltRow2:
	move	A5,*A0+,L
	move	A5,*A0+,L
	move	A5,*A0+,L
	move	A5,*A0+,L
	dsjs	A4,PltRow2
	add	A1,A0
	dsjs	A3,NxtRow2
	mmfm	SP,A0,A1,A2,A3,A4,A5
	rets
*************************************************************************

*************************************************************************
UnFbiText:
;Stop Display update, Clear MSU Screen, clear out Fbi Palettes

	clr	A0
	MOVE	A0,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	callr	ClrMsuScr
	movi	fbitxt4,A0
	calla	FINDPAL
	calla	UNGETPAL
	movi	warntxtp,A0
	calla	FINDPAL
	calla	UNGETPAL
	rets
*************************************************************************

*************************************************************************
UnpckPl2:
	subi	SKYTOPOF*>10000,A3
UnpckPlt:
;*****  This function unpacks and plots a packed image.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A3 packed Y:X screen coors to plot the image
;	A11 address to unpack to

	move	A11,A2		;A11 contains address to unpack to..
	calla	UnpackRLC

	movk	2,A2	;# bits per pixel
	move	A11,A6		;source address to plot from
	calla	PlotPack

	rets
*************************************************************************

*************************************************************************
Fader:
	;* GET THE PALETTES OF THE MSU
	movi	SCANPAL1,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA),W
	movi	SCANPAL2,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+16),W
	movi	voice,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+32),W
	movi	k3,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+48),W

	move	@precrim2,A0,W
	jrnz	SkGPFbi
	;* and the MSU SCREEN CONTENTS
	movi	fbitxt4,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+64),W
	movi	warntxtp,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+80),W
SkGPFbi:

	clr	A8
FadeIn:
	addk	16,A8

	move	A8,A2
	movi	FADERAM1,A0
	movi	SCANPAL1,A1
	callr	FadePal
	movi	FADERAM2,A0
	movi	SCANPAL2,A1
	callr	FadePal
	movi	FADERAM3,A0
	movi	voice,A1
	callr	FadePal
	movi	FADERAM4,A0
	movi	k3,A1
	callr	FadePal

	movi	FADERAM1,A0
	move	*A13(PDATA),A1,W
	move	*A0+,A2,W
*A0= PALSRC = 32 BIT SOURCE ADDRESS OF PALETTE COLOR DATA 	
*A1= PALDEST = BIT 8-15 DESTINATION PALETTE | BIT 0-7 START COLOR
*A2= PLDCNT = 16 BIT COLOR COUNT
	calla	PALSET
	movi	FADERAM2,A0
	move	*A13(PDATA+16),A1,W
	move	*A0+,A2,W
	calla	PALSET
	movi	FADERAM3,A0
	move	*A13(PDATA+32),A1,W
	move	*A0+,A2,W
	calla	PALSET
	movi	FADERAM4,A0
	move	*A13(PDATA+48),A1,W
	move	*A0+,A2,W
	calla	PALSET
	SLEEP	1

	move	@precrim2,A0,W
	jrnz	SkFbiFad
	;* Do The Screen Contents Too!
	move	A8,A2
	movi	FADERAM5,A0
	movi	fbitxt4,A1
	callr	FadePal
	movi	FADERAM6,A0
	movi	warntxtp,A1
	callr	FadePal

	movi	FADERAM5,A0
	move	*A13(PDATA+64),A1,W
	move	*A0+,A2,W
	calla	PALSET
	movi	FADERAM6,A0
	move	*A13(PDATA+80),A1,W
	move	*A0+,A2,W
	calla	PALSET
	SLEEP	1
SkFbiFad:

	cmpi	128,A8
	jrlt	FadeIn

	DIE
*************************************************************************

*************************************************************************
FADEOUT:
;* Thrashes first 4 words of PDATA and A8
	;* GET THE PALETTES OF THE MSU
	movi	SCANPAL1,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA),W
	movi	SCANPAL2,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+16),W
	movi	voice,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+32),W
	movi	k3,A0
	calla	FINDPAL
	sll	8,A0
	move	A0,*A13(PDATA+48),W

	movi	256,A8
FadeOut:
	subk	16,A8

	move	A8,A2
	movi	FADERAM1,A0
	movi	SCANPAL1,A1
	callr	FadePal
	movi	FADERAM2,A0
	movi	SCANPAL2,A1
	callr	FadePal
	movi	FADERAM3,A0
	movi	voice,A1
	callr	FadePal
	movi	FADERAM4,A0
	movi	k3,A1
	callr	FadePal

	movi	FADERAM1,A0
	move	*A13(PDATA),A1,W
	move	*A0+,A2,W
*A0= PALSRC = 32 BIT SOURCE ADDRESS OF PALETTE COLOR DATA 	
*A1= PALDEST = BIT 8-15 DESTINATION PALETTE | BIT 0-7 START COLOR
*A2= PLDCNT = 16 BIT COLOR COUNT
	calla	PALSET
	movi	FADERAM2,A0
	move	*A13(PDATA+16),A1,W
	move	*A0+,A2,W
	calla	PALSET
	movi	FADERAM3,A0
	move	*A13(PDATA+32),A1,W
	move	*A0+,A2,W
	calla	PALSET
	movi	FADERAM4,A0
	move	*A13(PDATA+48),A1,W
	move	*A0+,A2,W
	calla	PALSET
	SLEEP	1

	move	A8,A8
	jrnz	FadeOut

	RETP
*************************************************************************

*************************************************************************
FadePal:
;* PARMS
;	A0 - Dest Ram for Pal
;	A1 - Src for Pal
;	A2 - Color Multiplier
;* Each color in palette will be multiplied by A2 then divided by 128

	mmtm	SP,A0,A1,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14

	move	*A1+,A14,W
	move	A14,*A0+,W
	sll	23,A14		;top bits of field are flags
	srl	23,A14		;	only 9 bits needed for # colors

	movi	>7C00,A4	;A4 - Pre Mult Mask for 5 bits of red
	movi	>03E0,A6	;A6 - Pre Mult Mask for 5 bits of green
	movi	>001F,A8	;A8 - Pre Mult Mask for 5 bits of blue
	move	A4,A9
	move	A6,A10
	move	A8,A11
	sll	7,A9		; A9 - Post Mult Max for 5 bits of red
	sll	7,A10		;A10 - Post Mult Max for 5 bits of green
	sll	7,A11		;A11 - Post Mult Max for 5 bits of blue

FadeLp:
	move	*A1+,A3,W	;A3 - RED
	move	A3,A5		;A5 - GREEN
	move	A3,A7		;A7 - BLUE
	and	A4,A3
	and	A6,A5
	and	A8,A7
	mpyu	A2,A3
	mpyu	A2,A5
	mpyu	A2,A7
	cmp	A9,A3
	jrle	RedOk
	move	A9,A3
RedOk:
	cmp	A10,A5
	jrle	GreenOk
	move	A10,A5
GreenOk:
	cmp	A11,A7
	jrle	BlueOk
	move	A11,A7
BlueOk:
	and	A9,A3
	and	A10,A5
;	and	A11,A7	;unnecessary cause bottom bits will get >> 7

	or	A5,A3
	or	A7,A3
	srl	7,A3
	move	A3,*A0+,W
	dsjs	A14,FadeLp
	
	mmfm	SP,A0,A1,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	rets
*************************************************************************

*************************************************************************
FullFill:
;* PARMS
;	A0 - Dest Ram for Pal
;* repeat the first N colors of the palette through the remaining
;* colors of the palette
	mmtm	SP,A0,A1,A2,A3,A4,A14

	move	*A0+,A14,W
	sll	23,A14		;top bits of field are flags
	srl	23,A14		;	only 9 bits needed for # colors
				;A14 # src colors 	
	move	A0,A2		;A2, start of src addr - for reset of A0
	movi	256,A3
	sub	A14,A3		;A3 # of copies to be made
	jrz	FullX
	move	A14,A1
	sll	4,A1
	add	A0,A1		;A1 dest addr, A0 src addr

FillMore:
	move	A14,A4		;A4 # colors to be copied this loop
	move	A2,A0		;reset src addr
FulFilLp:
	move	*A0+,*A1+,W
	dsjs	A3,NotFull
	jruc	FullX
NotFull:
	dsjs	A4,FulFilLp
	jruc	FillMore
FullX:
	
	mmfm	SP,A0,A1,A2,A3,A4,A14
	rets
*************************************************************************


*************************************************************************
DiviOLst:
;* Divide Object List Into Two Pieces,
;the first piece is 150 objects worth of space,
;the second piece is at least 16K bytes of space for UnPackRLC
	movi	OFREE,A0
	movi	150,A1
SkLp:
	move	*A0,A0,L
	dsjs	A1,SkLp

	move	*A0,A11,L	;A11 pts to start of Second Space
	clr	A1
	move	A1,*A0,L	;terminate 1st List
	rets
*************************************************************************

*************************************************************************
LedBlink:
;** PROCESS to blink MSU Leds
;* PARMS
;	A10 - ptr to data object
;	--- the data object will have ptrs to led objs in slots 0-4

BlinkLp:
	movk	5,A2
	move	A10,A11
	jrz	BlinkX

LedLp:
	calla	RANDU
	movi	SCANPAL1,A0
	movb	@RAND,A1
	jrn	GotP
	movi	SCANPAL2,A0
GotP:
	calla	FINDPAL
	move	*A11+,A8,L
	move	A0,*A8(OPAL),W
	dsjs	A2,LedLp

	SLEEP	5
	jruc	BlinkLp

BlinkX:
	DIE
*************************************************************************


*************************************************************************
Led1Blnk:
;** PROCESS to blink MSU Dash Leds after button press
;* PARMS
;	A10 - ptr to data object
;	--- the data object will have ptrs to dash led objs in slots 0&1
	move	A10,A10
	jrz	Blnk1X

	movi	SCANPAL1,A0
	calla	FINDPAL
	move	A0,*A13(PDATA),W

	movi	SCANPAL2,A0
	calla	FINDPAL
	move	A0,*A13(PDATA+16),W
	
	move	*A10+,A8,L
	move	*A10,A9,L

	movk	2,A0
Blnk1Lp:
	PUSHP	A0	;# tiks to blink for
	move	*A13(PDATA),A1,W
	movb	@RAND,A0
	jrn	GotP1
	move	*A13(PDATA+16),A1,W
GotP1:
	move	A1,*A8(OPAL),W

	move	*A13(PDATA),A1,W
	move	@RAND,A0,W
	jrn	GotP2
	move	*A13(PDATA+16),A1,W
GotP2:
	move	A1,*A9(OPAL),W

	SLEEP	3
	PULLP	A0
	dec	A0
	jrp	Blnk1Lp

Blnk1X:
	DIE
*************************************************************************


*************************************************************************
Led2Blnk:
;** PROCESS to blink MSU Screen Leds after button press
;* PARMS
;	A10 - ptr to data object
;	--- the data object will have ptrs to scan led objs in slots 2&3
	move	A10,A10
	jrz	Blnk2X

	movi	SCANPAL1,A0
	calla	FINDPAL
	move	A0,*A13(PDATA),W

	movi	SCANPAL2,A0
	calla	FINDPAL
	move	A0,*A13(PDATA+16),W
	
	addi	64,A10		;Skip Dash leds
	move	*A10+,A8,L
	move	*A10,A9,L

	movi	70,A0
Blnk2Lp:
	PUSHP	A0	;# tiks to blink for
	move	*A13(PDATA),A1,W
	movb	@RAND,A0
	jrn	GotP3
	move	*A13(PDATA+16),A1,W
GotP3:
	move	A1,*A8(OPAL),W

	move	*A13(PDATA),A1,W
	move	@RAND,A0,W
	jrn	GotP4
	move	*A13(PDATA+16),A1,W
GotP4:
	move	A1,*A9(OPAL),W

	SLEEP	3
	PULLP	A0
	dec	A0
	jrp	Blnk2Lp

Blnk2X:
	DIE
*************************************************************************

*************************************************************************
Led3Blnk:
;** PROCESS to blink MSU Radar Led
;* PARMS
;	A10 - ptr to data object
;	--- the data object will have ptrs to scan led objs in slots 2&3
	move	A10,A10
	jrz	Blnk3X

	movi	SCANPAL1,A0
	calla	FINDPAL
	move	A0,*A13(PDATA),W

	movi	SCANPAL2,A0
	calla	FINDPAL
	move	A0,*A13(PDATA+16),W
	
	move	*A10(128),A8,L	;Skip Dash leds	& Scanner Leds

	movi	30,A0	;# times to blink
Blnk3Lp:
	PUSHP	A0	
	move	*A13(PDATA),A1,W
	movb	@RAND,A0
	jrn	GotP3
	move	*A13(PDATA+16),A1,W
GotP5:
	move	A1,*A8(OPAL),W

	SLEEP	5
	PULLP	A0
	dec	A0
	jrp	Blnk3Lp

Blnk3X:
	DIE
*************************************************************************

*************************************************************************
AlertBlink:
;** PROCESS to blink MSU Alert Light
;* PARMS
;	A9  - # times to BLINK
;	A10 - ptr to data object
;	--- the data object will have ptrs to led objs in slots 0-4
	move	A10,A10
	jrz	BAlertX
	addi	NumLed*>20,A10	;skip LEDS

AlertLp:
	movi	SCANPAL1,A0
	calla	FINDPAL
	move	*A10,A8,L
	move	A0,*A8(OPAL),W
	SLEEP	10

	movi	SCANPAL2,A0
	calla	FINDPAL
	move	*A10,A8,L
	move	A0,*A8(OPAL),W
	SLEEP	5

	dec	A9
	jrp	AlertLp

BAlertX:
	DIE
*************************************************************************

*************************************************************************
SpkrMove:
;** PROCESS to manipulate speaker parts
;* PARMS
;	A10 - ptr to data object
;	--- the data object will have ptrs to led objs in slots 0-4

	move	A10,A10
	jrz	BSpkrX

	addi	SpkrOff,A10	;skip LEDS & Alert
	clr	A9	;A9 ctr for which piece to flip
	clr	A11	;if A11 == 1, dec A9 instead of inc

FlipLp:
	move	A9,A0
	sll	5,A0	;long word offset
	add	A10,A0
	move	*A0,A0,L	;A0 now pts to spkr obj

	;* flip it horizontally
	move	*A0(OIMG),A1,L
	move	*A0(OFLAGS),A4,W
	XORI	M_FLIPH,A4
	calla	GSAGOF
	addi	OSIZE+>20,A0
	mmtm	A0,A2,A3,A4	;stuff OSIZE,OSAG,OFFSET:OFLAGS

	move	A11,A11
	jrz	IncIt

	dec	A9
	jrnn	SpkDecd
	clr	A9
	not	A11
SpkDecd:
	jruc	GotSpk

IncIt:
	inc	A9
	cmpi	NumSpkr,A9
	jrlt	SpkIncd
	movk	NumSpkr-1,A9
	not	A11
SpkIncd:

GotSpk:

	SLEEP	5
	jruc	FlipLp

BSpkrX:
	DIE
*************************************************************************

*************************************************************************
HndClr:
	calla	GETOBJ
	jrz	HndClrX
	move	A0,A2
	
	movi	156,A1
	move	A1,*A2(OXPOS),W
	movi	316+SKYTOPOF,A1
	move	A1,*A2(OYPOS),W
	movi	240,A1
	move	A1,*A2(OSIZEX),W
	movi	85,A1
	move	A1,*A2(OSIZEY),W
	movi	>2000000,A1
	move	A1,*A2(OSAG),L
	movi	DMACAL,A1
	zext	A1,W
	move	A1,*A2(OFLAGS),W

	clr	A0
	move	A0,*A2(OPAL),L

	move	A2,A0
	calla	INSB2OBJ


	calla	GETOBJ
	jrz	HndClrX
	move	A0,A2
	
	movi	396,A1
	move	A1,*A2(OXPOS),W
	movi	316+SKYTOPOF,A1
	move	A1,*A2(OYPOS),W
	movi	32,A1
	move	A1,*A2(OSIZEX),W
	movi	85,A1
	move	A1,*A2(OSIZEY),W
	movi	>2000000,A1
	move	A1,*A2(OSAG),L
	movi	DMACAL,A1
	zext	A1,W
	move	A1,*A2(OFLAGS),W

	clr	A0
	move	A0,*A2(OPAL),L

	move	A2,A0
	calla	INSB2OBJ

HndClrX:
	rets
*************************************************************************


*************************************************************************
MoveHand:
;* PARMS
; A1 - 16.16  X offset
; A2 - 16.16  Y offset
; A9,A11 hand obj ptrs
;CLOBBERS	A0

	move	*A9(OYVAL),A0,L
	add	A2,A0
	move	A0,*A9(OYVAL),L
	move	*A9(OXVAL),A0,L
	add	A1,A0
	move	A0,*A9(OXVAL),L

	move	*A11(OYVAL),A0,L
	add	A2,A0
	move	A0,*A11(OYVAL),L
	move	*A11(OXVAL),A0,L
	add	A1,A0
	move	A0,*A11(OXVAL),L
	rets
*************************************************************************


*************************************************************************
Hand1:
;** PROCESS to manipulate hand
;* PARMS
;	A8 - MSG to Print
;	A9 - # of buttons to push
;	A10 - ptr to data object
;	A11 - Initial Sleep Time
;	--- the data object will have ptrs to led objs in slots 0-4
	PUSHP	A9		;PUSH # of Buttons to Push
	movb	A8,*A13(PDATA)
	move	A11,A7		;hang on to Sleep Time
	move	A10,A11
	jrz	Hand1X

	addi	BoxOff,A11	;set ptr to ButBox,hand pieces

	move	*A11+,A8,L	;A8 points to butbox
	move	*A11+,A9,L	;A9 points to fing part
	move	*A11,A11,L	;A11 points to hand part

	callr	HndClr		;sets up erase objs under hand

	;Get the Parts off Screen
	movi	[700,0],A0		;Y off bottom of screen
	move	A0,*A8(OYVAL),L
	clr	A1
	movi	>640000,A2
	callr	MoveHand

	;* Do Initial Sleep
	move	A7,A0
	jrz	NoHSlp
	calla	PRCSLP
NoHSlp:
	PULLP	A0	;# buts to push
	MOVE	A0,A0	;CHECK IT OUT!
	jrz	Hand1X
	PUSHP	A0

H1ButLp:
	;select button to Press
	movk	14,A0
	calla	RANDU
	dec	A0
	sll	5,A0	;offset into but table is 2 words
	addi	ButTbl,A0
	PUSHP	A0	;Push dest Button
	move	*A0+,A1,W	;X offset
	move	*A0,A3,W	;Y offset
	subi	5,A1
	addi	14,A3

	movi	6,A14	;# tiks per button push
	
	move	*A9(OYPOS),A0,W
	sub	A0,A3
	sla	16,A3
	divs	A14,A3
	move	*A9(OXPOS),A0,W
	sub	A0,A1
	sla	16,A1
	divs	A14,A1	

	PUSHP	A1	;XVEL
	PUSHP	A3	;YVEL
	PUSHP	A14	;TIKS

MvH1Lp:
	PULLP	A14	;TIKS
	PULLP	A2	;YVEL
	PULLP	A1	;XVEL

	callr	MoveHand

	dec	A14
	jrz	H1Dst

	PUSHP	A1	;XVEL
	PUSHP	A2	;YVEL
	PUSHP	A14	;TIKS
	SLEEP	1
	jruc	MvH1Lp

H1Dst:
	;* Do Button Press Action
	clr	A1
	movi	->50000,A2
	callr	MoveHand
	SLEEP	1

	;* Get Red Box on Screen
	SOUND1	BEEPSND		;TACTILE FEEDBACK	
	PULLP	A0	;Pop dest Button
	move	*A0+,A1,W	;X offset
	subi	4,A1
	move	*A0,A2,W	;Y offset
	move	A1,*A8(OXPOS),W
	move	A2,*A8(OYPOS),W

	;* Start LEDs Flashing
	CREATE	BLINKPID,Led1Blnk

	;* Do we type something out?
	movb	*A13(PDATA),A0
	jrz	SkMsg
	callr	PutLMsg
SkMsg:

	clr	A1
	movi	->50000,A2
	callr	MoveHand
	SLEEP	1
	clr	A1
	movi	->40000,A2
	callr	MoveHand
	SLEEP	1
	clr	A1
	movi	>70000,A2
	callr	MoveHand
	SLEEP	1

	;* Get Red Box off Screen
	;set Y to 450+SKYOFFSET, off bottom of screen
	movi	((450+SKYTOPOF)*>10000),A0
	move	A0,*A8(OYVAL),L

	movi	12,A0
	calla	RANDU
	subk	6,A0
	jrn	NoHes
	jrz	NoHes
	calla	PRCSLP
NoHes:

	PULLP	A0	;# of buttons left to push
	dec	A0
	jrz	Hand1Bye
	PUSHP	A0
	jruc	H1ButLp
	

Hand1Bye:
	movk	6,A14
	PUSHP	A14

Bye1Lp:
	PULLP	A14	;TIKS

	movi	>110000,A2	;Yvel
	clr	A1		;Xvel
	callr	MoveHand

	dec	A14
	jrz	Hand1X

	PUSHP	A14	;TIKS
	SLEEP	1
	jruc	Bye1Lp

Hand1X:
	move	*A9(OPAL),A0,W
	calla	UNGETPAL
	DIE
*************************************************************************

*************************************************************************
ButTbl:
	.WORD	182+MSUX,316+SKYTOPOF, 202+MSUX,316+SKYTOPOF
	.WORD	222+MSUX,316+SKYTOPOF, 242+MSUX,316+SKYTOPOF
	.WORD	262+MSUX,316+SKYTOPOF, 282+MSUX,316+SKYTOPOF
	.WORD	302+MSUX,316+SKYTOPOF, 322+MSUX,316+SKYTOPOF
	.WORD	202+MSUX,339+SKYTOPOF, 222+MSUX,339+SKYTOPOF
	.WORD	242+MSUX,339+SKYTOPOF, 262+MSUX,339+SKYTOPOF
	.WORD	282+MSUX,339+SKYTOPOF, 302+MSUX,339+SKYTOPOF
*************************************************************************

*************************************************************************
GetObjs:
;* Finds all manipulable scanner objects
;* and loads ptrs to each of them into the SCANDATA
;* object space.

	;* allocate space for recording all ptrs to objects
	calla	GETOBJ
	move	A0,*A13(SCANDATA),L
	jrz	GetObjsX
	calla	CLROBJ

	;* load up the led ptrs
	movi	BAKLST,A1,L
Led1Scan:
	move	*A1,A1,L
	jrz	Led1X
	move	*A1(OZPOS),A2,W
	cmpi	DASHLED_Z,A2
	jrnz	Led1Scan
	move	A1,*A0+,L
	jruc	Led1Scan
Led1X:

	;* load up the led ptrs
	movi	BAKLST,A1,L
Led2Scan:
	move	*A1,A1,L
	jrz	Led2X
	move	*A1(OZPOS),A2,W
	cmpi	SCANLED_Z,A2
	jrnz	Led2Scan
	move	A1,*A0+,L
	jruc	Led2Scan
Led2X:

	;* load up the led ptrs
	movi	BAKLST,A1,L
Led3Scan:
	move	*A1,A1,L
	jrz	Led3X
	move	*A1(OZPOS),A2,W
	cmpi	RDRLED_Z,A2
	jrnz	Led3Scan
	move	A1,*A0+,L
;	jruc	Led3Scan
Led3X:

	;* load up the Alert ptrs
	movi	BAKLST,A1,L
AlrtScan:
	move	*A1,A1,L
	jrz	AlertX
	move	*A1(OZPOS),A2,W
	cmpi	ALERT_Z,A2
	jrnz	AlrtScan
	move	A1,*A0+,L
;	jruc	AlrtScan		;cause their is only 1 Alert
AlertX:

	;* load up the Spkr ptrs
	movi	BAKLST,A1,L
SpkrScan:
	move	*A1,A1,L
	jrz	SpkrX
	move	*A1(OZPOS),A2,W
	cmpi	SPKR_Z,A2
	jrnz	SpkrScan
	move	A1,*A0+,L
	jruc	SpkrScan
SpkrX:

	;* load up the button box ptr
	movi	BAKLST,A1,L
BoxScan:
	move	*A1,A1,L
	jrz	BoxX
	move	*A1(OZPOS),A2,W
	cmpi	BUTBOX_Z,A2
	jrnz	BoxScan
	move	A1,*A0+,L
;	jruc	BoxScan
BoxX:

	;* load up the Hand ptrs
	movi	BAKLST,A1,L
HandScan:
	move	*A1,A1,L
	jrz	HandX
	move	*A1(OZPOS),A2,W
	cmpi	HAND_Z,A2
	jrnz	HandScan
	move	A1,*A0+,L
	jruc	HandScan
HandX:
	;* order hand parts sorted by increasing Y
	move	-*A0,A1,L
	move	-*A0,A2,L
	move	*A1(OYPOS),A3,W
	move	*A2(OYPOS),A4,W
	cmp	A3,A4
	jrgt	LdHand
	SWAP	A1,A2
LdHand:
	move	A1,*A0+,L
	move	A2,*A0+,L

GetObjsX:
	rets
*************************************************************************

*************************************************************************
DoFocusSnd:
	push	A0
	movi	FOCUSSND,A0
	calla	ONESND
	pull	A0
	rets
*************************************************************************

*************************************************************************
Zoomer:
;Parms	A0-ptr to image
;		A1 - palette
;		A2 - Unpack buffer must be 16K bytes+1word in size
;	A14 gets clobbered

	move	A13,A14
	addi	SCANSTCK+(7*>20),A14
	mmtm	A14,A1,A2,A3,A4,A5,A6,A11

	move	A11,A2		;A11 contains address to unpack to..
	calla	UnpackRLC
	move	A2,A6		;A6 is src addr
	movk	2,A2			;* number of bits per pixel
	movi	[28,127+MSUX],A3
	movi	128,A4

ZPlot:
	callr	DoFocusSnd
	calla	Plt3Pack
	movk	1,A14
	jsrp	ZoomRest
	srl	1,A4
	cmpi	1,A4
	jrgt	ZPlot

	callr	DoFocusSnd
	calla	PlotPack

	movk	1,B0
	move	B0,@voiceoff,W
	callr	ClrMsg
	move	@CRIMENO,B0,W
	callr	PutMssn
	movi	65,A14
	jsrp	ZoomRest

	movk	1,A4
Uplot:
	sll	1,A4
	callr	DoFocusSnd
	calla	Plt3Pack
	movk	1,A14
	jsrp	ZoomRest
	cmpi	128,A4
	jrnz	Uplot

	callr	ClrMsuScr

	move	A13,A14
	addi	SCANSTCK,A14
	mmfm	A14,A1,A2,A3,A4,A5,A6,A11
	RETP

ZoomRest:
	move	A0,A8
	move	A1,A9
	move	A2,A10
	move	A3,A11
	PUSHP	A4
	PUSHP	A6
	move	A14,A0
	calla	PRCSLP
	PULLP	A6
	PULLP	A4
	move	A8,A0
	move	A9,A1
	move	A10,A2
	move	A11,A3
	RETP
*************************************************************************

*************************************************************************
Spreader:
;Parms	A0-ptr to image
;		A1 - palette
	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	movi	OBJSTR+>3000,A2,L
	calla	UnpackRLC
	move	A2,A6		;A6 is src addr
	movk	2,A2			;* number of bits per pixel
	movi	[28,127+MSUX],A3

	move	*A0(ISIZEX),A7
	sll	16,A7	
	clr	A8
	clr	A5		;pixel pad
	movi	SprdTbl,A11
SPlot:
	addk	16,A11
	move	*A11,A10,W
	jrz	SPlotX
	move	A10,A8
	move	A7,A9
	divu	A8,A9
	move	A9,A4
	calla	Plt4Pack
	SLEEP	1
	jruc	SPlot
SPlotX:
	subk	16,A11

	movi	8000000,A5
SStall:	dsjs	A5,SStall	

SPlot2:
	subk	16,A11
	move	*A11,A10,W
	jrz	SPlot2X
	move	A8,A5
	sub	A10,A5
	inc	A5		;round up
	srl	1,A5
	move	A10,A8
	jrz	SpreadX
	move	A7,A9
	divu	A8,A9
	move	A9,A4
	calla	Plt4Pack
	jruc	SPlot2
SPlot2X:

SpreadX:
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	rets

SprdTbl:
	.word	0
	.word	1,2,4,6,8,10
	.word	13,16,20,24,25,31
	.word	38,46
	.word	54,64
	.word	75,86
	.word	98,111
	.word	125
	.word	140
	.word	156
	.word	172
	.word	190
	.word	210
	.word	232
 	.word	256
	.word	0
*************************************************************************

*************************************************************************
DoMug:
;* PARMS
;crimeno
	movi	NARCS,A0
	calla	GETFPAL
	SLEEP	1
	MOVI	[28+SKYTOPOF,127+MSUX],A3	
	MOVI	[200,256],A4
	CALLA	BLNKAREA		;WIPE-OUT ANY LEFT OVER DATA
	SLEEP	2
	move	@CRIMENO,A5,W
	callr	GetMug
	PUSHP	A0
	PUSHP	A1
	SLEEP	1	;allow palette to be allocated
	PULLP	A1
	PULLP	A0
	jsrp	Zoomer

	move	A1,A0
	calla	FREEPAL
	RETP
*************************************************************************

*************************************************************************
GetMug:
;* PARM A5 - # of mug to load
	;* load ptr to mug in A0
	;* palette in A1

	mmtm	SP,A5

	sll	5,A5		;long word ptr
	addi	MugTbl,A5
	move	*A5,A0,L
	callr	LdImgPal
	
	mmfm	SP,A5
	rets

MugTbl:
	.long	loafmug
	.long	loafmug		;pimpmug
	.long	clownmug
	.long	hypomug
	.long	dumpmug
	.long	gangmug
	.long	rambomug
	.long	mbigmug		;gaymug
	.long	loafmug		;snowmug
	.long	mbigmug

*************************************************************************

*************************************************************************
UnpackRLC:
;*****  This function takes a run length code image and generates the
;* packed form.  Right now this function only works with 4 color
;* images in the following format..
;*	[1][rrrrr][cc]
;*		r is a run length decoded as follows:
;*			0 -> 68
;*			1-31 -> 4-34
;*		cc is the color of the run.
;*	[00][c2][c1][c0]
;*		c0 - color pixel 0
;
;PARMS:
;	A0 ptr to image frame
;	A2 dest addr -- dest space needs at least 1 extra word of space

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	pushst

	move	*A0(ISIZEX),A3,W		;size in bytes
	move	*A0(ISIZEY),A4,W
	mpyu	A4,A3				;A3 # pixels to unpack

	move	*A0(ISAG),A6,L		;A6 is src addr
	subk	8,A6
PixLp:
	addk	8,A6
	movb	*A6,A4
	jrn	RunLen
	;* put pixels into packed data space
	movb	A4,*A2
	addk	6,A2
	subk	3,A3
	jrhi	PixLp	
	jruc	PixLpX
RunLen:
	move	A4,A5
	sll	25,A5	
	srl	27,A5
	jrnz	SkSetLen
	movi	68,A5
	jruc	GotLen
SkSetLen:
	addk	3,A5
GotLen:

	;* in case of corrupted src data
	cmp	A3,A5
	jrls	CtOK
	move	A3,A5
CtOK:

	sll	30,A4
	srl	30,A4
	move	A5,A7
PutRun:
	setf	2,0,1
	clr	A1		;No adjust needed for dest ptr if field size is 2
	cmpi	16,A5
	jrlt	RunLp	

	;fill data out to a full word in length
	move	A4,A8
	sll	2,A8	
	add	A8,A4	
	move	A4,A8
	sll	4,A8	
	add	A8,A4	
	move	A4,A8
	sll	8,A8	
	add	A8,A4	
	
	setf	16,0,1
	move	A5,A1
	srl	3,A5	 	;divide by 8
	sll	29,A1	; is there any remainder?
	jrz	SkAdj

	srl	28,A1	;remainder * 2
	subk	16,A1	
	inc	A5
SkAdj:

RunLp:
	move	A4,*A2+,1
	dsjs	A5,RunLp
	add	A1,A2		;readjust ptr if write went to far

	sub	A7,A3
	jrnz	PixLp
PixLpX:

	popst
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10
	rets
*************************************************************************


*************************************************************************
LdImgPal:
;* PARMS
;	A0 ptr to image frame
;* RETURNS
;	A1 colormap allocated - returns EQ if no Pal Free
	mmtm	SP,A0
	move	*A0(ICMAP),A0,L
	calla	GETFPAL
	jrz	LdPalX
	move	A0,A1
	inc	A0		;reset Z flag
LdPalX:
	mmfm	SP,A0
	rets
*************************************************************************

*************************************************************************
SetField1:
;* PARMS	A0-#bits to set field size to
;destroys A0
	;*** set field size
	sll	5,A0
	addi	SetfTbl,A0
	jump	A0
SetfTbl:
	setf	1,0,1		;* can't set to Zero	
	rets
	setf	1,0,1	
	rets
	setf	2,0,1	
	rets
	setf	3,0,1	
	rets
	setf	4,0,1	
	rets
	setf	5,0,1	
	rets
	setf	6,0,1	
	rets
	setf	7,0,1	
	rets
	setf	8,0,1	
	rets
	setf	9,0,1	
	rets
	setf	10,0,1	
	rets
	setf	11,0,1	
	rets
	setf	12,0,1	
	rets
	setf	13,0,1	
	rets
	setf	14,0,1	
	rets
	setf	15,0,1	
	rets
	setf	16,0,1	
	rets
	setf	17,0,1	
	rets
	setf	18,0,1	
	rets
	setf	19,0,1	
	rets
	setf	20,0,1	
	rets
	setf	21,0,1	
	rets
	setf	22,0,1	
	rets
	setf	23,0,1	
	rets
	setf	24,0,1	
	rets
	setf	25,0,1	
	rets
	setf	26,0,1	
	rets
	setf	27,0,1	
	rets
	setf	28,0,1	
	rets
	setf	29,0,1	
	rets
	setf	30,0,1	
	rets
	setf	31,0,1	
	rets
	setf	32,0,1	
	rets
*************************************************************************


*************************************************************************
PlotPack:
;*****  This function plots a packed image.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A2 #bits per pixel
;	A3 packed Y:X screen coors to plot the image
;	A6 src addr

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	pushst

	addi	SKYTOPOF*>10000,A3

	move	@DISPLAYON,A5,W
	PUSH	A5
	CLR	A5
	MOVE	A5,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	move	A1,@DMACMAP,W
	clr	A7
	movy	A3,A7
	srl	4,A7
	zext	A3,W
	sll	3,A3
	add	A3,A7			;A7 is dest addr

	movk	8,A9
	sub	A2,A9	;A9 # of bits needed to incr dest ptr by

	move	*A0(ISIZEX),A3,W		;size in bytes
	;*** compute vertical adjust
	movi	512,A8 				;512 bytes in horizontal row
	sub	A3,A8
	sll	3,A8					;want bit address increment
	move	A3,A5
	move	*A0(ISIZEY),A4,W

	move	A2,A0
	callr	SetField1
YLp:
XLp:
	move	*A6+,*A7+,1
	add	A9,A7
	dsjs	A3,XLp
	move	A5,A3			;reset X count
	add	A8,A7			;Vertical dest addr adjust
	dsjs	A4,YLp

	PULL	A5
	MOVE	A5,@DISPLAYON,W		;RESTORE DISPLAY PROC. STATE

	popst
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	rets
*************************************************************************


*************************************************************************
Plt2Pack:
;*****  This function sample plots a packed image with jaggies.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A2 #bits per pixel
;	A3 packed Y:X screen coors to plot the image
;	A4 #pixels plotted per pixel sampled
;	A6 src addr

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	pushst

	move	A1,@DMACMAP,W
	clr	A7
	movy	A3,A7
	srl	4,A7
	zext	A3,W
	sll	3,A3
	add	A3,A7			;A7 is dest addr

	move	A2,A9
	move	A2,A1
	move	A2,A10
	mpyu	A4,A9			;A9 is x src increment in bits

	move	*A0(ISIZEY),A3,W		;A3 - number rows left
	move	*A0(ISIZEX),A2,W		;A2 - bytes left on horizontal row
	move	A2,A5			;A5 # pixels in X dimension
	;*** compute vertical adjust
	movi	512,A8 				;512 bytes in horizontal row
	sub	A2,A8
	sll	3,A8					;A8 = dest vertical adjust
	mpyu	A4,A1
	mpyu	A2,A1				;A1 = src vert inc.

	move	A10,A0
	callr	SetField1
	clr	A10				;x pixel sample ct
	clr	A11				;y pixel sample ct
YLp2:
	move	A6,A0		;record start of horizontal row
XLp2:
	move	*A6,*A7,1
	addk	8,A7
	inc	A10
	cmp	A10,A4		; is x ct = pix sample ct?
	jrnz	SkXinc
	clr	A10
	add	A9,A6		; add X src inc
SkXinc:
	dsjs	A2,XLp2
	move	A0,A6		;reset src back to start of horizontal row
	inc	A11
	cmp	A11,A4
	jrnz	SkYinc
	clr	A11
	add	A1,A6		;inc src (sample ct) vertical rows
SkYinc:
	move	A5,A2			;reset X count
	add	A8,A7			;Vertical dest addr adjust
	dsjs	A3,YLp2

	popst
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	rets
*************************************************************************


*************************************************************************
Plt3Pack:
;*****  This function sample plots a packed image without jaggies.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A2 #bits per pixel
;	A3 packed Y:X screen coors to plot the image
;	A4 #pixels plotted per pixel sampled
;	A6 src addr

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	pushst

	addi	SKYTOPOF*>10000,A3

	move	@DISPLAYON,A5,W
	PUSH	A5
	CLR	A5
	MOVE	A5,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	move	A1,@DMACMAP,W
	clr	A7
	movy	A3,A7
	srl	4,A7
	zext	A3,W
	sll	3,A3
	add	A3,A7			;A7 is dest addr

	move	A2,A9
	move	A2,A1
	move	A2,A10
	mpyu	A4,A9			;A9 is x src increment in bits

	move	*A0(ISIZEY),A3,W		;A3 - number rows left
	move	*A0(ISIZEX),A2,W		;A2 - bytes left on horizontal row
	move	A2,A5			;A5 # pixels in X dimension
	;*** compute vertical adjust
	movi	512,A8 				;512 bytes in horizontal row
	sub	A2,A8
	sll	3,A8					;A8 = dest vertical adjust
	mpyu	A4,A1
	mpyu	A2,A1				;A1 = src vert inc.

	move	A10,A0
	callr	SetField1
	move	*A6,A14,1		;preload source value
	clr	A11				;y pixel sample ct
YLp3A:
	clr	A10				;x pixel sample ct
	move	A6,A0		;record start of horizontal row
XLp3A:
	move	A14,*A7,1
	addk	8,A7
	inc	A10
	cmp	A10,A4		; is x ct = pix sample ct?
	jrnz	SkXinc3A
	clr	A10
	add	A9,A6		; add X src inc
	move	*A6,A14,1
SkXinc3A:
	dsjs	A2,XLp3A
	move	A0,A6		;reset src back to start of horizontal row
	inc	A11
	cmp	A11,A4
	jrnz	SkYinc3A
	clr	A11
	add	A1,A6		;inc src (sample ct) vertical rows
SkYinc3A:
	move	*A6,A14,1
	move	A5,A2			;reset X count
	add	A8,A7			;Vertical dest addr adjust
	dsjs	A3,YLp3A

	PULL	A5
	MOVE	A5,@DISPLAYON,W		;RESTORE DISPLAY PROC. STATE

	popst
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	rets
*************************************************************************


*************************************************************************
Plt4Pack:
;*****  This function plots a packed image.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A2 #bits per pixel
;	A3 packed Y:X screen coors to plot the image
;	A4 XSrcInc
;	A5 # pixels to pad left & right with
;	A6 src addr

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	mmtm	SP,B0,B1,B2
	pushst

	move	A1,@DMACMAP,W
	clr	A7
	movy	A3,A7
	srl	4,A7
	zext	A3,W
	sll	3,A3
	add	A3,A7			;A7 is Base dest addr

	move	*A0(ISIZEX),A11,W		;size in bytes
	move	A11,B1
	move	A2,B2
	mpyu	B2,B1			;B1 - Src addr incr for one row
	move	A6,B0
	sub	B1,B0			;B0 - Src Address 

	move	A11,A10
	sll	16,A11
	divu	A4,A11			;A11 = #pixels in destination row
	add	A5,A11			;add in left pad
	add	A5,A11			;add in right pad
	sub	A11,A10
	srl	1,A10			;A10 = #bytes to offset start of dest row
	sll	3,A10			;A10 = #bits to offset start of dest row
	add	A10,A7

	;*** compute vertical destination adjust as bit offset
	movi	512,A8 				;512 bytes in horizontal row
	sub	A11,A8
	sll	3,A8					;want bit address increment

	sub	A5,A11			;sub left pad
	sub	A5,A11			;sub right pad

	movi	>10000,A10		;CONST Decr for X Src Ctr
	move	A4,A1			;XSrcInc
	move	*A0(ISIZEY),A4,W	;set Y count

	move	A2,A0
	callr	SetField1

	move	A1,A9
	srl	16,A9
	sll	16,A9
	sub	A9,A1
	srl	16,A9
	mpyu	A2,A9

YLp4:
	add	B1,B0
	move	B0,A6

	move	A5,A3
	jrz	SkLftPad
	movk	1,A0
LftPad:
	movb	A0,*A7
	addk	8,A7
	dsjs	A3,LftPad
SkLftPad:

	movi	->10000,A0		;XSrcCt
	move	A11,A3			;reset X count
XLp4:
	move	*A6,*A7,1
	addk	8,A7
	add	A9,A6
	add	A1,A0		;inc X source ctr
	jrn	SkXFrac
	sub	A10,A0
	add	A2,A6
SkXFrac:
	dsjs	A3,XLp4

	move	A5,A3
	jrz	SkRgtPad
	movk	1,A0
RgtPad:
	movb	A0,*A7
	addk	8,A7
	dsjs	A3,RgtPad
SkRgtPad:

	add	A8,A7			;Vertical dest addr adjust
	dsjs	A4,YLp4

	popst
	mmfm	SP,B0,B1,B2
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	rets
*************************************************************************

*************************************************************************
Plt5Pack:
;*****  This function plots a packed image.
;PARMS:
;	A0 ptr to image frame
;	A1 color map containing palette for image
;	A2 #bits per pixel
;	A3 packed Y:X screen coors to plot the image
;	A6 src addr
;	A10 starting Y:X in image
;	A11 Ylen:Xlen

;RETURNS nothing

	mmtm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A14
	pushst

	move	@DISPLAYON,A5,W
	PUSH	A5
	CLR	A5
	MOVE	A5,@DISPLAYON,W	;TURN OFF DISPLAY PROC.
	CALLA	DMAQWAIT	;AND WAIT FOR THE DMA TO CLEAR

	move	A1,@DMACMAP,W

	;compute dest addr
	clr	A7
	movy	A3,A7
	srl	4,A7
	zext	A3,W
	sll	3,A3
	add	A3,A7		;A7 is dest addr

	;dest ptr horizontal inc
	movk	8,A12
	sub	A2,A12		;A9 # of bits needed to incr dest ptr by

	clr	A5
	movx	A11,A5		;X ct of pixels to plot				
	movy	A11,A4
	srl	16,A4		;Y ct of pixels to plot

	;*** compute destination vertical adjust
	movi	512,A8 		;512 bytes in horizontal row
	sub	A5,A8
	sll	3,A8		;dest. vert. adj bit addr inc

	;* compute starting src addr
	clr	A9
	movx	A10,A9		;horizontal start offset
	mpyu	A2,A9 		;mult by # bits per pix
	add	A9,A6

	move	*A0(ISIZEX),A9,W	;src width in pix
	mpyu	A2,A9		; mult  # pixels in row by pixel width
	move	A9,A0		; Src delt for 1 entire row
	movy	A10,A14
	srl	16,A14
	mpyu	A14,A9		; mult by #hor rows to skip
	add	A9,A6

	;* compute src addr vert adj
	move	A5,A3		;#pixels plotted in hor row
	mpyu	A2,A3
	sub	A3,A0		
	move	A0,A9		;src vert adj 

	move	A2,A0
	callr	SetField1
YLp5:
	move	A5,A3			;reset X count
XLp5:
	move	*A6+,*A7+,1
	add	A12,A7
	dsjs	A3,XLp5
	add	A8,A7			;vert dest addr adj
	add	A9,A6			;vert src addr adj
	dsjs	A4,YLp5

	PULL	A5
	MOVE	A5,@DISPLAYON,W		;RESTORE DISPLAY PROC. STATE

	popst
	mmfm	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A14
	rets
*************************************************************************

*************************************************************************
PlotVBox:
;* called from VOX process to plot one bar in Graph
;* PARMS
;	A0 - color
;	A2 - Height
;	A5 - col #
;	A11 - palette
	
	mmtm	SP,A1,A2,A3,A4,A5

	;bottom left of Vox Scan at 154:11 - add in offset of -4:6
	movi	>00960012+MSUX+(SKYTOPOF*>10000),A3
	movi	3,A1
	mpyu	A2,A1
	sll	16,A1
	subxy	A1,A3		;Add in adjustment for height
	movi	11,A1	
	mpyu	A5,A1
	addxy	A1,A3		;A3 - Y:X plot location

	move	A0,A1		;double up color #
	sll	8,A1
	add	A1,A0

	move	A0,A1		;A1 - Color:Pal
	jrz	GotCP
	sll	16,A1
	movx	A11,A1
GotCP:
	movi	>00020008,A2	;A2 - VSIZE:HSIZE
	movi	>2000000,A4	;A4 - SAG
	movi	DMACAL,A5	;A5 - offset:control
	zext	A5,W

	calla	QDMAN
	mmfm	SP,A1,A2,A3,A4,A5
	rets
*************************************************************************

*************************************************************************
ChngHght:
;	A11 - palette
;* For Each Column Attempt to place height at desired height
;* height can shrink by at most 1.

	clr	A5	;col ctr
ColHtLp:
	move	A5,A1
	sll	3,A1
	add	A13,A1
	addi	PDATA,A1
	move	A1,A2
	movb	*A1,A4		;A4 = current height of column
	addi	6*8,A2
	movb	*A2,A6		;A6 = desired height of column

	cmp	A4,A6
	jrz	NoChng
	jrgt	ColUp

	;* Col Goes Down
	move	A4,A0
	dec	A0
	movb	A0,*A1		;set new col height
	clr	A0		;set color
	move	A4,A2		;set height
	callr	PlotVBox
	jruc	NoChng

ColUp:
	movb	A6,*A1		;set new col height
	move	A6,A1
	move	A4,A2
ColUpLp:
	inc	A2
	move	A2,A0
	callr	PlotVBox
	cmp	A2,A1
	jrgt	ColUpLp

NoChng:
	inc	A5
	cmpi	6,A5
	jrlt	ColHtLp

ChngHX:
	rets
*************************************************************************


;*	Volume, VolumeDelta, count
;*	if volume=1, all bars on 1, no randomness
VOXLOFF:
	.byte	1,0,7
	.byte	20,0,1
	.byte	10,0,2	
	.byte	20,0,1
	.byte	10,0,2	
	.byte	20,0,1
	.byte	10,0,2	
	.byte	20,0,1
	.byte	10,0,2	
	.byte	20,0,1
	.byte	15,0,1
	.byte	0,0,0

VOXCLOWN:
	.byte	1,0,8
	.byte	5,4,3	
	.byte	1,0,1	
	.byte	10,0,10	
	.byte	0,0,0

VOXDUMP:
	.byte	1,0,7
	.byte	25,0,1
	.byte	15,0,6
	.byte	25,0,1
	.byte	15,0,2
	.byte	0,0,0

VOXHEAD:
	.byte	1,0,1
	.byte	20,0,5
	.byte	15,0,6
	.byte	20,0,4
	.byte	15,0,1
	.byte	0,0,0

VOXPIMP:
	.byte	1,0,6
	.byte	15,0,2
	.byte	2,0,3	
	.byte	20,0,2
	.byte	2,0,3	
	.byte	0,0,0

VOXMBIG:
	.byte	1,0,6
	.byte	20,0,1
	.byte	2,0,1	
	.byte	22,0,1
	.byte	2,0,1	
	.byte	24,0,1
	.byte	2,0,1	
	.byte	20,0,1
	.byte	2,0,1	
	.byte	20,0,1
	.byte	2,0,1	
	.byte	18,0,1
	.byte	2,0,1	
	.byte	16,0,1
	.byte	2,0,1	
	.byte	14,0,1
	.byte	2,0,1	
	.byte	14,0,1
	.byte	2,0,1	
	.byte	12,0,1
	.byte	2,0,1	
	.byte	10,0,1
	.byte	2,0,1	
	.byte	0,0,0


VOXHYPO:
VOXGANG:
VOXTIMBO:
VOXQUEEN:
	.byte	1,0,5
	.byte	0,0,0

	.even

*************************************************************************
VSCAN:
;* PARMS
;crimeno
	move	@CRIMENO,A0,W
	sll	5,A0
	addi	VoiceTbl,A0
	move	*A0,A8,L
	
	movi	VOXPAL,A0
	calla	GETFPAL
	move	A0,A11

	;* clear first 6 bytes of process data for height of column vars
	clr	A0
	move	A0,*A13(PDATA),L
	move	A0,*A13(PDATA+32),W	

VRdLp:
	movb	*A8(16),A1	;Count
	jrz	VSCANX
	movb	*A8(8),A10	;Delta
	movb	*A8,A9		;Vol
	addi	24,A8

VDeltLp:
	PUSHP	A1
	clr	A5	;Col Ctr
	move	A9,A2
ColLp:
	cmpi	1,A2
	jreq	MaxHOk
	movk	14,A0
	calla	RANDU
	subk	7,A0
	add	A0,A2
	jrp	MinHOk
	clr	A2
MinHOk:
	cmpi	34,A2
	jrlt	MaxHOk
	movi	33,A2
MaxHOk:
	move	A5,A0
	sll	3,A0	;Byte Offset
	addi	PDATA+6*8,A0	;skip col height indicators
	add	A13,A0
	movb	A2,*A0

ColX:
	inc	A5
	cmpi	6,A5		;# of cols 	
	jrlt	ColLp

	movk	5,A0
AdjHtLp:
	movb	A0,*A13(PDATA+6*16)	;skip the 6 col heights, desired heights
	callr	ChngHght
	SLEEP	1
	movb	*A13(PDATA+6*16),A0
	dec	A0
	jrp	AdjHtLp

	add	A10,A9	;Add Delta to Volume
	PULLP	A1	;Count
	dec	A1
	jrnz	VDeltLp

	jruc	VRdLp
	
VSCANX:
	move	@CRIMENO,B0,W
	callr	PutMatch
	jruc	VSCANXX

	clr	A0
	move	A0,@voiceoff,W
WaitFall:
	SLEEP	1
	move	@voiceoff,A0,W
	jrz	WaitFall

	clr	A0
	move	A13,A1
	addi	PDATA+6*8,A1
	movk	6,A2
ClrHght:
	movb	A0,*A1
	addk	8,A1
	dsjs	A2,ClrHght

	movi	34,A0
VScanOff:
	PUSHP	A0
	callr	ChngHght
	SLEEP	1
	PULLP	A0
	dec	A0
	jrp	VScanOff

	;Free Voice Scanner Palette
;	move	A11,A0		;Voxpal		this is now done in msuclear
;	calla	UNGETPAL

VSCANXX:
	DIE
*************************************************************************


*************************************************************************
PutPass:
	PUSH	A0
	MOVE	*A13(PROCID),A0,W
	ZEXT	A0
	CMPI	P1SWPID,A0
	JRNE	PUTPASS1
	MOVI	PASS1MSG,B0
	JRUC	PUTPASS2
PUTPASS1
	MOVI	PASS2MSG,B0
PUTPASS2
	PULL	A0
	move	B0,@msgptr,L
	MOVI	[268+SKYTOPOF,222+MSUX],B0	;POSITION
	move	B0,@msgpos,L
	jruc	PutMsg
PutMatch:
	sll	5,B0
	addi	VMATCHTBL,B0
	move	*B0,B0,L
	move	B0,@msgptr,L
	MOVI	[268+SKYTOPOF,256+MSUX],B0	;POSITION
	move	B0,@msgpos,L
	jruc	PutMsg
PutMssn:
	sll	5,B0
	addi	MSSNTBL,B0
	move	*B0,B0,L
	move	B0,@msgptr,L
	MOVI	[268+SKYTOPOF,256+MSUX],B0	;POSITION
	move	B0,@msgpos,L
	jruc	PutMsg

PutMsg:
	mmtm	SP,A0,A6,A8,A9,A10,A11
	move	@msgptr,A8,L
	move	@msgpos,A9,L
	clr	A0		;No Sleep
	MOVI	0FCFCH,A6
	MOVI	RD7FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRM
	move	A8,@msgptr,L
	move	A9,@msgpos,L
	mmfm	SP,A0,A6,A8,A9,A10,A11
	rets
PutLMsg:
	mmtm	SP,A0,A6,A8,A9,A10,A11
	move	@msgptr,A8,L
	move	@msgpos,A9,L
	clr	A0		;No Sleep
	MOVI	0FCFCH,A6
	MOVI	RD7FONT,A11
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRLNRM
	move	A8,@msgptr,L
	move	A9,@msgpos,L
	mmfm	SP,A0,A6,A8,A9,A10,A11
	rets
*************************************************************************


PASS1MSG:
	.STRING	"NARC 2000  PASSWORD:  "
	.BYTE	0
	.STRING	"M"
	.BYTE	0
	.STRING	"A"
	.BYTE	0
	.STRING	"X"
	.BYTE	0
	.STRING	"1"
	.BYTE	0

PASS2MSG:
	.STRING	"NARC 2000  PASSWORD:  "
	.BYTE	0
	.STRING	"H"
	.BYTE	0
	.STRING	"I"
	.BYTE	0
	.STRING	"T"
	.BYTE	0
	.STRING	"2"
	.BYTE	0

	.even

VMLOFF:
	.STRING	"VOICE MATCH:  DAS LOF GANG"
	.BYTE	0
MSLOFF:
	.STRING	"INVESTIGATE "
	.BYTE	22H
	.STRING	"PIPELINE"
	.BYTE	22H
	.STRING	" HIDEOUT"
	.BYTE	0
	.even
ATNLOFF:
	.LONG	0,attnS,30,narc1S,0,0
SNDLOFF:
	.LONG	0,SND511,47,prgrssS,45,letsgoS,0,0

VMPIMP:
	.STRING	"VOICE MATCH:  BEVON FACE"
	.BYTE	0
MSPIMP:
	.STRING	"ARMED & DANGEROUS -- PROCEED WITH CAUTION"
	.BYTE	0
	.even
ATNPIMP:
	.LONG	0,coderedS,40,SND773,45,prgrssS,0,0
SNDPIMP:
	.LONG	0,watchS,50,letsgoS,0,0	

VMCLOWN:
	.STRING	"VOICE MATCH:  KINKY PINKY"
	.BYTE	0
MSCLOWN:
	.STRING	"PROTECT THE INNOCENT !"
	.BYTE	0
	.even
ATNCLOWN:
	.LONG	0,coderedS,0,0
SNDCLOWN:
	.LONG	10,whereruS,65,onrwayS,0,0

VMHYPO:
	.STRING	"DR. SPIKE RUSH (HYPOMAN) - CHEMIST/PUSHER"
	.BYTE	0
MSHYPO:
	.STRING	"BUST HIM, DESTROY CLANDESTINE DRUG LAB"
	.BYTE	0
	.even
ATNHYPO:
	.LONG	0,allunitsS,42,apbS,45,sarmedS,24,sightedS,0,0
SNDHYPO:
	.LONG	0,pickupS,65,rogerS,0,0

VMDUMP:
	.STRING	"VOICE MATCH: JOE ROCKHED A.K.A. DUMPSTER MAN"
	.BYTE	0
MSDUMP:
	.STRING	"P.C.P. ADDICT, PROCEED WITH CAUTION"
	.BYTE	0
	.even
ATNDUMP:
	.LONG	0,sarmedS,24,atlargeS,0,0
SNDDUMP:
	.LONG	15,getonitS,65,onrwayS,0,0

VMGANG:
	.STRING	"HQ POSSE - HEAVILY ARMED"
	.BYTE	0
MSGANG:
	.STRING	"BUST 'EM OR BLAST 'EM"
	.BYTE	0
	.even
ATNGANG:
	.LONG	0,coderedS,40,sarmedS,0,0
SNDGANG:
	.LONG	0,bustemS,60,wegotitS,0,0


VMTIMBO:
	.STRING	"SGT. SKYHIGH -- KNOWN CULTIVATOR"
	.BYTE	0
MSTIMBO:
	.STRING	"HARVEST TIME -- ENJOY!"
	.BYTE	0
	.even
ATNTIMBO:
	.LONG	0,allunitsS,42,apbS,45,sarmedS,0,0
SNDTIMBO:
	.LONG	64,watchS,70,letsgoS,0,0	

VMHEAD:
	.STRING	"MR. BIG LIVES !"
	.BYTE	0
MSHEAD:
	.STRING	"!! BEWARE !!"
	.BYTE	0
	.even
ATNHEAD:
	.LONG	>24,UDIE1SND,0,0
SNDHEAD:
	.LONG	>30,SLOWLAFF,0,0

VMQUEEN:
;	.STRING	"VOICE MATCH:  SNOWQUEEN"
	.BYTE	0
MSQUEEN:
;	.STRING	"WICKED BITCH -- NAIL HER GOOD"
	.BYTE	0
	.even
ATNQUEEN:
SNDQUEEN:
	.LONG	0,0

VMMBIG:
	.STRING	"VOICE MATCH:  MR. BIG!"
	.BYTE	0
MSMBIG:
	.STRING	"PUBLIC ENEMY #1 -- APPREHEND AT ALL COSTS!"
	.BYTE	0
	.even
ATNMBIG:
SNDMBIG:
	.LONG	0,nicejobS,50,0,0

VMATCHTBL:
	.LONG	  VMLOFF,   VMPIMP,  VMCLOWN,   VMHYPO,   VMDUMP,   VMGANG
	.LONG	 VMTIMBO,    VMHEAD,  VMQUEEN,   VMMBIG
MSSNTBL:
	.LONG	  MSLOFF,   MSPIMP,  MSCLOWN,   MSHYPO,   MSDUMP,   MSGANG
	.LONG	 MSTIMBO,    MSHEAD,  MSQUEEN,   MSMBIG
VoiceTbl:
	.LONG	 VOXLOFF,  VOXPIMP, VOXCLOWN,  VOXHYPO,  VOXDUMP,  VOXGANG
	.LONG	VOXTIMBO,   VOXHEAD, VOXQUEEN,  VOXMBIG
MSSNSNDS:
	.LONG	 SNDLOFF,  SNDPIMP, SNDCLOWN,  SNDHYPO,  SNDDUMP,  SNDGANG
	.LONG	SNDTIMBO,   SNDHEAD, SNDQUEEN,  SNDMBIG
ATTNSNDS:
	.LONG	 ATNLOFF,  ATNPIMP, ATNCLOWN,  ATNHYPO,  ATNDUMP,  ATNGANG
	.LONG	ATNTIMBO,   ATNHEAD, ATNQUEEN,  ATNMBIG

	.even
*************************************************************************
ClrMsg:
;* PARMS
;	A0 - color
;	A2 - Height
;	A5 - col #
;	A11 - palette
	
	mmtm	SP,A1,A2,A3,A4,A5

	movi	>01010000,A1	;A1 - Color:Pal
	movi	>000B00FC,A2	;A2 - VSIZE:HSIZE
	movi	[267+SKYTOPOF,105+MSUX],A3	;A3 - Y:X plot location
	movi	>2000000,A4	;A4 - SAG
	movi	DMACAL,A5	;A5 - offset:control
	zext	A5,W
	calla	QDMAN

	movi	>01010000,A1	;A1 - Color:Pal
	movi	>000B0030,A2	;A2 - VSIZE:HSIZE
	movi	[267+SKYTOPOF,357+MSUX],A3	;A3 - Y:X plot location
	movi	>2000000,A4	;A4 - SAG
	movi	DMACAL,A5	;A5 - offset:control
	zext	A5,W
	calla	QDMAN

	mmfm	SP,A1,A2,A3,A4,A5
	rets
*************************************************************************


VOXPAL:
	.WORD	37
	.word	(31 *1024)+( 0 *32)+( 0 )	; 1
	.word	(31 *1024)+( 1 *32)+( 0 )	; 2
	.word	(31 *1024)+( 2 *32)+( 0 )	; 3
	.word	(31 *1024)+( 3 *32)+( 0 )	; 4
	.word	(31 *1024)+( 4 *32)+( 0 )	; 5
	.word	(31 *1024)+( 5 *32)+( 0 )	; 6
	.word	(31 *1024)+( 6 *32)+( 0 )	; 7
	.word	(31 *1024)+( 7 *32)+( 0 )	; 8
	.word	(31 *1024)+( 8 *32)+( 0 )	; 9
	.word	(31 *1024)+( 9 *32)+( 0 )	; 10
	.word	(31 *1024)+(10 *32)+( 0 )	; 11
	.word	(31 *1024)+(11 *32)+( 0 )	; 12
	.word	(31 *1024)+(12 *32)+( 0 )	; 13
	.word	(31 *1024)+(13 *32)+( 0 )	; 14
	.word	(31 *1024)+(14 *32)+( 0 )	; 15
	.word	(31 *1024)+(15 *32)+( 0 )	; 16
	.word	(31 *1024)+(16 *32)+( 0 )	; 17
	.word	(31 *1024)+(17 *32)+( 0 )	; 18
	.word	(31 *1024)+(18 *32)+( 0 )	; 19
	.word	(31 *1024)+(19 *32)+( 0 )	; 20
	.word	(31 *1024)+(20 *32)+( 0 )	; 21
	.word	(31 *1024)+(21 *32)+( 0 )	; 22
	.word	(31 *1024)+(22 *32)+( 0 )	; 23
	.word	(31 *1024)+(23 *32)+( 0 )	; 24
	.word	(31 *1024)+(24 *32)+( 0 )	; 25
	.word	(31 *1024)+(25 *32)+( 0 )	; 26
	.word	(31 *1024)+(26 *32)+( 0 )	; 27
	.word	(31 *1024)+(27 *32)+( 0 )	; 28
	.word	(31 *1024)+(28 *32)+( 0 )	; 29
	.word	(31 *1024)+(29 *32)+( 0 )	; 30
	.word	(31 *1024)+(30 *32)+( 0 )	; 31
	.word	(31 *1024)+(31 *32)+( 0 )	; 32
	.word	(31 *1024)+(30 *32)+( 0 )	; 33
	.word	(31 *1024)+(31 *32)+( 0 )	; 34
	.word	(31 *1024)+(31 *32)+( 0 )	; 35
	.word	(31 *1024)+(31 *32)+( 0 )	; 36

	.END
