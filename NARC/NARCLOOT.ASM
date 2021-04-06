	.FILE	'NARCLOOT.ASM'
	.TITLE	" <<< N  A  R  C  -- MONEY,DRUGS,GUNS & ROCKETS >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

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
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates

*
*GLOBALS IN THIS FILE
	.GLOBAL		WEEDCOLL,BUCKCOLD,DRUGCOLD
*
*EXTERNALS
	.GLOBAL	CANEXCOL,PICKMESS,CLRMESS

	.TEXT
MAXLOOT	.EQU	30	;MAX AMOUNT OF LOOT ALLOWED ON SCREEN
**************************************************************************
*                                                                        *
* SPECIAL NOTE: LOOT OBJECTS AND THE BUST STAMP SHOULD BE PART OF	 *
* 	      THE FIXED COLOR MAP, THEREFORE THEIR PALETTES ARE		 *
* 	      NEVER FREE'D. REMEBER THAT!				 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* DROPCARD - PROCESS TO DROP A SAFE CARD			  	 *
* A8 = OBLK PTR OF ENEMY THAT DROPPED THIS				 *
* A9 = CARD IDENTIFIER							 *
*                                                                        *
**************************************************************************
DROPCARD
	CREATE	CRCPID,PICKMESS	;CREATE THE PICKUP MESSAGE PROCESS
	MOVI	CARDCOLL,A5
	MOVI	CARDOID,A11
	OR	A9,A11
	SLL	5,A9
	MOVE	A9,A7
	ADDI	CARDBTAB,A7
	MOVE	*A7,A7,L	;GET THE BLIP STUFF
	ADDI	CRDANTAB,A9
	MOVE	*A9,A9,L	;AND THE ANIMATION SCRIPT
	CLR	A10
	MOVI	DMAWNZ,A6	;SEND YOUR OWN FLAGS
	JRUC	DROPLTNC

*CARD ANIMATION SCRIPT TABLE
CRDANTAB
	.LONG	CARDSAN,CARDRAN,CARDBAN,CARDGAN,CARDGRAN
*CARD BLIP TABLE
CARDBTAB
	.LONG	SILVBLIP,REDBLIP,BLUEBLIP,GOLDBLIP,GRNBLIP
**************************************************************************
*                                                                        *
* DROPBUCK - PROCESS TO DROP SOME BUCKS				  	 *
* A8 = OBLK PTR OF ENEMY THAT DROPPED THIS				 *
*                                                                        *
**************************************************************************
DROPBUCK
	MOVI	MONYCOLL,A5
	MOVI	BUCKBLIP,A7
	CALLA	RANDOM
	JRN	DROPBUK1
	MOVI	MONEY1,A9	
	JRUC	DROPBUK2
DROPBUK1
	MOVI	MONEY2,A9
DROPBUK2
	CLR	A10
	MOVI	BUCKOID,A11
	CLR	A6
	JRUC	DROPLOOT

**************************************************************************
*                                                                        *
* DROPCLIP - PROCESS TO DROP A BULLET CLIP			  	 *
* A8 = OBLK PTR OF ENEMY THAT DROPPED THIS				 *
*                                                                        *
**************************************************************************
DROPCLIP
	MOVI	CLIPCOLL,A5
	MOVI	CLIPBLIP,A7
	MOVI	CLIPF,A9	
	CLR	A10
	MOVI	CLIPOID,A11
	CLR	A6
	JRUC	DROPLOOT
**************************************************************************
*                                                                        *
* DROPROCK - PROCESS TO DROP A ROCKET BOMB			  	 *
* A8 = OBLK PTR OF ENEMY THAT DROPPED THIS				 *
*                                                                        *
**************************************************************************
DROPROCK
	MOVI	ROCKCOLL,A5
	MOVI	ROCKBLIP,A7
	MOVI	ROCKF,A9	
	CLR	A10
	MOVI	ROCKOID,A11
	CLR	A6
	JRUC	DROPLOOT
**************************************************************************
*                                                                        *
* DROPDRUG - PROCESS TO DROP A BAG OF DOPE 				 *
* A8 = OBLK PTR OF ENEMY THAT DROPPED THIS				 *
*                                                                        *
**************************************************************************
DROPDRUG
	MOVI	DOPECOLL,A5
	MOVI	DRUGBLIP,A7
	MOVI	DOPE,A9	
	MOVI	DOPEHIT,A10
	MOVI	DRUGOID,A11
	CLR	A6
**************************************************************************
*                                                                        *
* DROPLOOT - DROPPING PROCESS FOR SOME LOOT				 *
* A5 = COLLISION ROUTINE						 *
* A6 = OBJECT FLAGS OF LOOT IMAGE, 0 = JUST TAKE THE DROPPERS		 *
* A7 = PTR TO SCANNER BLIP						 *
* A8 = PTR TO OBJECT THAT DROPPED THIS					 *
* A9 = PTR TO ANIMATION SCRIPT						 *
* A10 = PTR TO GROUND HIT ANIMATION SCRIPT				 *
* A11 = I.D. OF OBJECT							 *
*                                                                        *
**************************************************************************
DROPLOOT
	MOVI	BOOTY,A1
	CALLA	CNTSUPP
	CMPI	MAXLOOT,A0
	JRHS	LOOTDIE			;BR = NO MORE LOOT ALLOWED

	MOVE	@OVERLOAD,A0
	CMPI	4,A0
	JREQ	LOOTDIE			;BR = SYSTEM IS BOGGED
*DROP LOOT REGARDLESS OF BOOTY COUNT AND OVERLOAD
DROPLTNC
	CALLA	GETOBJ			;GET AN OBJECT
	JREQ	LOOTDIE			;NO CAN DO

	CALLA	COPYOBJ			;COPY THE CONTENTS FROM THE ENEMY

	MOVE	A11,*A0(OID),W		;CHANGE ID
	MOVE	A11,A1
	SRL	4,A1
	SLL	4,A1
	CMPI	CARDOID,A1		;IS THIS A SAFE CARD?
	JRNE	NRMLDROP		;NO, JUST DO A NOMINAL Z SIZE

	MOVI	CARDZSIZ,A1
	JRUC	DROPZSIZ		;SET A SPECIAL Z SIZE FOR THE CARD
NRMLDROP
	MOVI	LOOTZSIZ,A1
DROPZSIZ
	MOVE	A1,*A8(OZSIZ),L		;STUFF A SIZE

	MOVE	A5,*A0(OCVECT),L	;THE COLLISION VECTOR
	MOVE	A7,*A0(OBLIPIMG),L
	MOVE	A6,A6
	JRZ	DROPNFLG
	MOVE	A6,*A0(OFLAGS),W	;STUFF YOUR OWN FLAGS
DROPNFLG
	CALLA	GETCPNT
	MOVE	A1,*A0(OXPOS),W		;SET CENTER X POSITION
	SRL	16,A1
	MOVE	A1,*A0(OYPOS),W		;AND CENTER Y POSITION

	MOVE	A0,A8
	CALLA	PSTOP
	MOVE	*A9,A1,L
	MOVE	*A1(ICMAP),A0,L
	CALLA	FINDPAL
	MOVE	A0,*A8(OPAL),W
	CALLA	RANDOM
	SEXT	A0
	MOVE	A0,*A8(OXVEL),L		;A FRACTION OF A VELOCITY
	ANDI	30H,A0	
	XOR	A0,A4			;FLAGGY BAGGY SHAGGY DAGGY
	MOVE	*A8(OFLAGS),A4,W
	ORI	M_PIXSCAN,A4		;MAKE THIS OBJECT PIXABLE
	CALLA	ANI			;STUFF NEW FRAME

	MOVK	2,A1
	MOVE	A1,*A8(OYVEL+16),W	;STUFF A DOWNWARD VELOCITY
	MOVE	A13,*A8(OPLINK),L	;LINK ME UP BABY
	MOVE	A8,A0
	CALLA	INSOBJ
	MOVI	BOOTY,A1
	CALLA	ADDSUPP			;PLAYER CAN PICK IT UP NOW	

	MOVE	A10,*A13(PDATA+80H),L	;NO SECOND ANIMATION LIST
	MOVI	LOOTPROC,A1
	MOVE	A1,*A13(PDATA+0A0H),L	;PROCESS TO CREATE UPON HIT
	JAUC	TRAJEC1			;ACCELERATE DUE TO GRAVITY

**************************************************************************
*                                                                        *
* LOOTPROC - WATCH FOR MONEY OR DRUGS TO GET OFF OF THE SCREEN,		 *
* 	   THEN DELETE IT.						 *
* A8 = PTR TO LOOT							 *
*                                                                        *
**************************************************************************
LOOTPROC
	MOVE	A8,A0
	CALLA	DELSHAD
	CALLA	PSTOP
	CALLA	CKOUTOFX		;SEE IF THIS THING IS OUT OF X BOUNDS
	MOVE	*A8(OID),A1,W

	ZEXT	A1
	CMPI	CARDOID|BLUE,A1		;IS THIS A BLUE SAFE CARD
	JRNE	LOOTPNBC		;NO, THIS IS NOT A BLUE CARD

	MOVE	*A8(OSIZEY),A3,W	;HACK FOR BLUE CARD
	SRA	1,A3
	MOVE	@PLZMID,A4,W
	ADDI	ZORIGIN,A4
	SUB	A3,A4			;CENTERLINE OF ROOM FOR ACCESSABILITY
	MOVE	A4,*A8(OYPOS),W

LOOTPNBC
	SEXT	A1
	MOVE	A1,A1
	JRN	LOOTLAY			;THIS STUFF LIES DOWN
	CALLA	SETZPOS			;OTHERWISE STAND IT UP
	JRUC	LOOTCLR
LOOTLAY	
	CALLA	SETTZPOS		;SET Z POSITION BASED ON TOP Y
LOOTCLR
	CALLA	CKZADJST
	CLR	A0
	MOVE	A0,*A8(OPLINK),L	;CLEAR THE LINK, I'M GONE BUDDY
LOOTDIE
	DIE

**************************************************************************
*                                                                        *
* TRNKBUCK - PROCESS TO PUT SOME BUCKS IN A TRUNK		  	 *
* A3 = [Y,X] OFFSET TO TRUNK 						 *
* A10 = OBLK PTR OF CAR							 *
*                                                                        *
**************************************************************************
TRNKBUCK
	MMTM	SP,A0,A1,A4,A5,A8,A10,A11
	MOVI	MONYCOLL,A5
	MOVI	BUCKBLIP,A7
	MOVI	GETCASH1,A1	
	MOVI	BUCKOID,A11
	CLR	A6
	JRUC	TRNKLOOT
**************************************************************************
*                                                                        *
* TRNKCLIP - PUT A BULLET CLIP IN A VEHICLE TRUNK		  	 *
* A3 = [Y,X] OFFSET TO TRUNK 						 *
* A10 = OBLK PTR OF VEHICLE						 *
*                                                                        *
**************************************************************************
TRNKCLIP
	MMTM	SP,A0,A1,A4,A5,A8,A10,A11
	MOVI	CLIPCOLL,A5
	MOVI	CLIPBLIP,A7
	MOVI	GETCLIP,A1	
	MOVI	CLIPOID,A11
	CLR	A6
	JRUC	TRNKLOOT
**************************************************************************
*                                                                        *
* TRNKROCK - PROCESS TO TRUNK A ROCKET BOMB			  	 *
* A3 = [Y,X] OFFSET TO TRUNK 						 *
* A10 = OBLK PTR OF VEHICLE						 *
*                                                                        *
**************************************************************************
TRNKROCK
	MMTM	SP,A0,A1,A4,A5,A8,A10,A11
	MOVI	ROCKCOLL,A5
	MOVI	ROCKBLIP,A7
	MOVI	ROCKBIG,A1	
	MOVI	ROCKOID,A11
	CLR	A6
	JRUC	TRNKLOOT
**************************************************************************
*                                                                        *
* TRNKDRUG - PROCESS TO TRUNK A BAG OF DOPE 				 *
* A3 = [Y,X] OFFSET TO TRUNK 						 *
* A10 = OBLK PTR OF VEHICLE						 *
*                                                                        *
**************************************************************************
TRNKDRUG
	MMTM	SP,A0,A1,A4,A5,A8,A10,A11
	MOVI	DOPECOLL,A5
	MOVI	DRUGBLIP,A7
	MOVI	GETDOPE,A1	
	MOVI	DRUGOID,A11
	CLR	A6
**************************************************************************
*                                                                        *
* TRNKLOOT - TRNKPING PROCESS FOR SOME LOOT				 *
* A1 = FRAME TO STUFF							 *
* A3 = [Y,X] OFFSET TO TRUNK 						 *
* A5 = COLLISION ROUTINE						 *
* A6 = OBJECT FLAGS OF LOOT IMAGE, 0 = JUST TAKE THE DROPPERS		 *
* A7 = PTR TO BLIP IMAGE						 *
* A10 = PTR TO OBJECT THAT TRNKPED THIS					 *
* A11 = I.D. OF OBJECT							 *
*                                                                        *
**************************************************************************
TRNKLOOT
	PUSH	A1
	MOVI	BOOTY,A1
	CALLA	CNTSUPP
	PULL	A1
	CMPI	MAXLOOT,A0
	JRHS	TRNKDIE			;BR = NO MORE LOOT ALLOWED

	MOVE	@OVERLOAD,A0
	CMPI	4,A0
	JREQ	TRNKDIE			;BR = SYSTEM IS BOGGED
TRNKLTNC
	MOVE	A10,A8
	CALLA	GETOBJ			;GET AN OBJECT
	JREQ	TRNKDIE			;NO CAN DO
	CALLA	COPYOBJ			;COPY THE CONTENTS FROM THE VEHICLE
	MOVE	A11,*A0(OID),W		;CHANGE ID
	MOVE	A5,*A0(OCVECT),L	;THE COLLISION VECTOR
	MOVE	A7,*A0(OBLIPIMG),L
	MOVE	A6,A6
	JRZ	TRNKNFLG
	MOVE	A6,*A0(OFLAGS),W	;STUFF YOUR OWN FLAGS
TRNKNFLG
	CLR	A5
	MOVE	A5,*A0(OPLINK),L
	MOVE	*A8(OFLAGS),A4,W
	MOVE	A8,A10			;STORE FOR SAFE KEEPING
	MOVE	A0,A8
	CALLA	PSTOP
	MOVE	*A1(ICMAP),A0,L
	CALLA	FINDPAL
	MOVE	A0,*A8(OPAL),W
	CALLA	RANDOM
	SEXT	A0
	ANDI	10H,A0	
	XOR	A0,A4			;FLAGGY BAGGY SHAGGY DAGGY
	ANDNI	M_PIXSCAN,A4		;MAKE THIS OBJECT PIXABLE
	CALLA	ANI			;STUFF NEW FRAME
	CLR	B0
	MOVK	12,B1	
	CALLA	RANGRAND
	MOVE	A0,A5			;GET RANDOM X TRAVEL
	MOVE	A8,A0
	MOVE	A10,A8			;RESTORE PTRS
	MOVE	*A8(OFLAGS),A4,W
	MOVE	A5,A10
	SLL	30,A10
	SRL	14,A10
	MOVY	A10,A5	
	ADDXY	A5,A3			;GIVE A LITTLE RANDOMNESS
	MOVE	*A8(OYPOS),A5,W		;ADJUST BOOTY Y POSITION
	MOVX	A3,A10
	SRL	16,A3
	ADDXY	A3,A5
	MOVE	A5,*A0(OYPOS),W
	MOVE	*A8(OXPOS),A5,W		;ADJUST BOOTY X POSITION,COMP FOR XFLIP
	BTST	B_FLIPH,A4
	JREQ	TLOOT1
	MOVE	*A8(OSIZEX),A1,W	
	ADDXY	A1,A5			;MUST ADD OFFSET FROM THE LEFT
	ADDK	15,A10
	NEG	A10
TLOOT1
	ADDXY	A10,A5
	MOVE	A5,*A0(OXPOS),W
	MOVE	*A8(OZVAL),A5,L
	ADDK	1,A5
	MOVE	A5,*A0(OZVAL),L
	MOVI	[8,8],A1
	MOVE	A1,*A0(OZSIZ),L		;STUFF A SIZE
	CALLA	INSOBJ
	MOVI	BOOTY,A1
	CALLA	ADDSUPP			;PLAYER CAN PICK IT UP NOW	
TRNKDIE
	MMFM	SP,A0,A1,A4,A5,A8,A10,A11
	RETS	

**************************************************************************
*                                                                        *
* ISPPICK - CHECK TO SEE IF A PLAYER OBJECT IS PICKING UP LOOT		 *
* A8 = POINTER TO OBJECT IN QUESTION					 *
* RETURNS:								 *
* CARRY CLR = NOT PICKING UP						 *
* CARRY SET = PICKING UP						 *
*                                                                        *
**************************************************************************
ISPPICK
	MMTM	SP,A1,A2
	CALLA	GPLAYERD
	JRZ	ISPICK3			;BR = IT'S NOT EVEN A PLAYER
	MOVE	*A2(PFLAGS),A6,L
	BTST	BPICKUP,A6		;PLAYER GETTIN' SOME?	
	JREQ	ISPICK3		     	;BR = NO
	SETC
	MMFM	SP,A1,A2
	RETS
ISPICK3
	CLRC
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* GOLDCOL0 - GOLD COLLISION AS OBJECT ZERO				 *
* A0 = PTR TO LOOT OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT LOOT					 *
*                                                                        *
**************************************************************************
GOLDCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,GOLDPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* MONCOL0 - MONEY COLLISION AS OBJECT ZERO				 *
* A0 = PTR TO LOOT OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT LOOT					 *
*                                                                        *
**************************************************************************
MONCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,BUCKPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* MONPCAR - MONEY COLLISION WITH A PLAYER VEHICLE. EACH PLAYER IN THE CA *
* 	  GETS A PIECE OF STASH.					 *
* A0 = PTR TO LOOT							 *
* A8 = PTR TO VEHICLE MAIN OBJECT THAT HIT THE MONEY			 *
*                                                                        *
**************************************************************************
MONPCAR
	MOVI	BUCKPICK,A7
	JRUC	LOOTPCAR
MONPART
	MOVI	BUCKPICK,A7
	JRUC	LOOTPART
**************************************************************************
*                                                                        *
* DRUGPCAR - DRUG COLLISION WITH A PLAYER VEHICLE. EACH PLAYER IN THE CAR*
* 	  GETS A PIECE OF STASH.					 *
* A0 = PTR TO LOOT							 *
* A8 = PTR TO VEHICLE MAIN OBJECT THAT HIT THE DRUGS			 *
*                                                                        *
**************************************************************************
DRUGPCAR
	MOVI	DRUGPICK,A7
	JRUC	LOOTPCAR
DRUGPART
	MOVI	DRUGPICK,A7
	JRUC	LOOTPART
**************************************************************************
*                                                                        *
* CLIPPCAR - CLIP COLLISION WITH A PLAYER VEHICLE. EACH PLAYER IN THE CAR*
* 	  GETS A PIECE OF STASH.					 *
* A0 = PTR TO LOOT							 *
* A8 = PTR TO VEHICLE MAIN OBJECT THAT HIT THE CLIP			 *
*                                                                        *
**************************************************************************
CLIPPCAR
	MOVI	CLIPPICK,A7
	JRUC	LOOTPCAR
CLIPPART
	MOVI	CLIPPICK,A7
	JRUC	LOOTPART
**************************************************************************
*                                                                        *
* ROCKPCAR - ROCKET COLLISION WITH A PLAYER VEHICLE. EACH PLAYER IN THE  *
* 	  GETS A PIECE OF STASH.					 *
* A0 = PTR TO LOOT							 *
* A8 = PTR TO VEHICLE MAIN OBJECT THAT HIT THE ROCKET			 *
*                                                                        *
**************************************************************************
ROCKPCAR
	MOVI	ROCKPICK,A7
	JRUC	LOOTPCAR
ROCKPART
	MOVI	ROCKPICK,A7
	JRUC	LOOTPART
**************************************************************************
*                                                                        *
* CARDPCAR - CARD COLLISION WITH A PLAYER VEHICLE. EACH PLAYER IN THE CAR*
* 	  GETS A PIECE OF STASH.					 *
* A0 = PTR TO LOOT							 *
* A8 = PTR TO VEHICLE MAIN OBJECT THAT HIT THE CARD			 *
*                                                                        *
**************************************************************************
CARDPCAR
	MOVI	CARDPICK,A7
	JRUC	LOOTPCAR
CARDPART
	MOVI	CARDPICK,A7
	JRUC	LOOTPART
**************************************************************************
*                                                                        *
* LOOTPCAR - LOOT CHECK AGAINST CAR.					 *
* A0 = PTR TO LOOT							 *
* A7 = PICKUP PROCESS TO CREATE						 *
* A8 = PTR TO VEHICLE MAIN						 *
* EXPECTS TO RETURN TO COLLISION SCANNER				 *
*                                                                        *
**************************************************************************
*
*ENTRY POINT FOR A VEHICLE PART OTHER THAN MAIN.
*A8 = PTR TO VEHICLE PART
LOOTPART
	MOVE	A0,A10
	MOVE	A8,A11
	MOVE	A8,A0
	CALLA	FINDMVP
	JRZ	LOOTPCX			;NO MASTER VEHICLE PROCESS WAS FOUND
	JRUC	LOOTPCG
LOOTPCAR
	MOVE	A0,A10			;MOVE HERE FOR PROCESS CREATION XFER
	MOVE	A8,A11			;IN CASE OF MISS
	MOVE	*A8(OPLINK),A0,L	
	JRZ	LOOTPCX			;BR = RENEGADE OBJECT, BEWARE!
LOOTPCG
	CALLA	GETA8
	JRZ	LOOTND			;NO DRIVER AVAILABLE
	MOVE	*A0(PASSPTR),A11,L
	JRNZ	LOOTPDAP		;JUST PICK-UP FOR THE DRIVER
	CALLR	LOOT1P
	JRUC	LOOTPCX
LOOTPDAP
	CALLR	LOOT1P			;FIRE OFF DRIVER PICK
	JRNC	LOOTCPL			;FIRED O.K., NEW OBJ FOR PASSENGER
*HERE TO CREATE PASSENGER LOOT PROC, IF DRIVER LOOT PROC NOT CREATED.
       	MOVE	A11,A8			;GET PASSENGER PTR HERE
	CALLR	LOOT1P
	JRUC	LOOTPCX
*HERE TO CREATE PASSENGER LOOT PROC, IF DRIVER LOOT PROC CREATED.
LOOTCPL
	MOVE	A11,A8			;PASSENGER PTR PLEASE.
	CALLA	ISPPICK
	JRC	LOOTPCX			;BR = PASSENGER IS PICKING UP

	CALLA	GETOBJ			;GET A NEW OBJECT FOR THE OTHER GUY
	SWAP	A10,A8			;LOOT FOR SOURCE COPY
	CALLA	COPYOBJ
	SWAP	A10,A8

	MOVI	DUMCOLL,A14
	MOVE	A14,*A0(OCVECT),L
	CLR	A14	
	MOVE	A14,*A0(OSHAD),L
	MOVE	A14,*A0(OPLINK),L

	CALLA	INSOBJ			;SHOW IT TO THE DUDE MAN
	MOVI	BOOTY,A1
	CALLA	ADDSUPP			;LINK UP FOR BOOTYFLY
	MOVE	A0,A10			;SAVE HERE

	CALLR	LOOT1P			;FIRE PASSENGER PROCESS
	JRUC	LOOTPCX
*NO DRIVER, CHECK PASSENGER 
LOOTND
	MOVE	*A0(PASSPTR),A8,L
	JRZ	LOOTPCON		;NO PASSENGER
	CALLR	LOOT1P
*EXIT POINT TO END COLLISION SCAN
LOOTPCX
	CLR	A14
	INC	A14			;END COLLISIONS
	RETS
*EXIT POINT COLLISION WITH CAR BUT NOT THE PLAYER
*A10 = PTR TO LOOT
*A11 = PTR TO VEHICLE
LOOTPCON
	MOVE	*A11(OZPOS),A14,W
	MOVE	*A11(OZMINUS),A3,W
	MOVE	A14,A7
	SUB	A3,A7
	MOVE	@PLZMIN,A5,W
	SUB	A5,A7

	MOVE	*A11(OZPLUS),A5,W
	MOVE	A5,A4
	ADD	A14,A5
	MOVE	@PLZMAX,A6,W
	SUB	A5,A6

	CMP	A7,A6
	JRGT	LOOTFOR

	SUB	A3,A14
	MOVE	*A10(OZMINUS),A3,W
	SUB	A3,A14
	
	MOVE	*A10(OZPOS),A2,W
	SUB	A14,A2
	ABS	A2
	MOVE	*A10(OYPOS),A3,W
	SUB	A2,A3
	MOVE	A3,*A10(OYPOS),W
	MOVE	A14,*A10(OZPOS),W
	JRUC	LOOTREP

LOOTFOR
	MOVE	*A10(OZPLUS),A2,W
	ADD	A2,A5
	MOVE	*A10(OZPOS),A2,W
	SUB	A5,A2
	ABS	A2
	MOVE	*A10(OYPOS),A3,W
	ADD	A2,A3
	MOVE	A3,*A10(OYPOS),W
	MOVE	A5,*A10(OZPOS),W

LOOTREP
	CLR	A14
	RETS
*
*1 PLAYER ONLY PICK-UP SUB
*A7 = PROCESS ADDRESS TO CREATE
*A8 = PTR OBJECT PICKING UP THE LOOT, SHOULD BE A PLAYER
*A10 = PTR TO LOOT OBJECT
*RETURNS:
*	C SET = DIDN'T CREATE
*	C CLR = CREATED THE PICKUP PROC
*A0 = CREATED PROCESS ADDRESS
*A1 = CREATED PROCESS I.D.
*TRASHES A14
LOOT1P
	CALLR	ISPPICK	
	JRC	LOOT1PXC		;PLAYER ALREADY PICKING UP
	MOVI	INDPIDW,A1
	CALLA	GETPRC
	JRNZ	LOOT1PX
	SETC				;PROCESS FAILURE,
LOOT1PXC
	RETS
LOOT1PX
	CLRC
	RETS

**************************************************************************
*                                                                        *
* DOPECOL0 - DOPE COLLISION 						 *
* A0 = PTR TO DOPE OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT DOPE					 *
*                                                                        *
**************************************************************************
DOPECOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,DRUGPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* ROCKCOL0 - ROCK COLLISION 						 *
* A0 = PTR TO ROCK OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT ROCK					 *
*                                                                        *
**************************************************************************
ROCKCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,ROCKPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* CLIPCOL0 - CLIP COLLISION 						 *
* A0 = PTR TO CLIP OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT CLIP					 *
*                                                                        *
**************************************************************************
CLIPCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,CLIPPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* CARDCOL0 - CARD COLLISION 						 *
* A0 = PTR TO CARD OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT CLIP					 *
*                                                                        *
**************************************************************************
CARDCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,CARDPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* WEEDCOL0 - WEED PLANT COLLISION 						 *
* A0 = PTR TO WEED OBJECT						 *
* A8 = PTR TO OBJECT THAT HIT THAT CLIP					 *
*                                                                        *
**************************************************************************
WEEDCOL0
	CALLR	ISPPICK
	JAC	DUMRTSG			;BR = IT'S A PLAYER PICKING SHIT UP
	MOVE	A0,A10
	CREATE	INDPIDW,WEEDPICK
	CLR	A0
	INC	A0			;END COLLISIONS
	RETS

**************************************************************************
*                                                                        *
* GOLDPICK - PLAYER GOLD PICKUP PROCESS, IT MAKES THE PLAYER PICKUP	 *
* 	   HIS BOOTY 1,2,3,... AT A TIME.				 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE GOLD OBJECT						 *
*                                                                        *
**************************************************************************
GOLDPICK
	MOVI	PBUCKOF,A9
	SWAP	A10,A8
	CALLA	DFRMGRND
	SWAP	A10,A8
	CMPI	25,A1
	JRLT	GLDPICK1
	MOVE	*A10(OYVEL+16),A0,W
	JRNN	GLDPICK1
	MOVK	1,A0
	JRUC	GLDPICK2
GLDPICK1
	CLR	A0
GLDPICK2
	MOVE	A0,*A13(PDATA),W
	MOVI	CASHSND,A0
	JSRP	BOOTYFLY
	JRC	GOLDPDI			;BR = DIDN'T WORK
	MOVI	850H,A1
	CALLA	SCORE
	MOVE	*A13(PDATA),A0,W
	JREQ	GLDPICK3
	CALLA	SCORE			;2X FOR THIS GUY
GLDPICK3
	MOVE	*A2(PGOLD),A14,W
	INC	A14	       		;CLICK ANOTHER ONE FOR THIS GUY
	MOVE	A14,*A2(PGOLD),W
GOLDPDI
       DIE

**************************************************************************
*                                                                        *
* BUCKPICK - PLAYER BUCK PICKUP PROCESS, IT MAKES THE PLAYER PICKUP	 *
* 	   HIS BOOTY 1 AT A TIME.					 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE BUCK OBJECT						 *
*                                                                        *
**************************************************************************
BUCKPICK
	MOVI	PBUCKOF,A9
	SWAP	A10,A8
	CALLA	DFRMGRND
	SWAP	A10,A8
	CMPI	25,A1
	JRLT	BPICK1
	MOVE	*A10(OYVEL+16),A0,W
	JRNN	BPICK1
	MOVK	1,A0
	JRUC	BPICK2
BPICK1
	CLR	A0
BPICK2
	MOVE	A0,*A13(PDATA),W
	MOVI	CASHSND,A0
	JSRP	BOOTYFLY
	JRC	BUCKPDI			;BR = DIDN'T WORK
	MOVI	250H,A1
	CALLA	SCORE
	MOVE	*A13(PDATA),A0,W
	JREQ	BPICK3
	CALLA	SCORE			;2X FOR THIS GUY
BPICK3
	MOVE	*A2(PMONEY),A14,W
	INC	A14	       		;CLICK ANOTHER ONE FOR THIS GUY
	MOVE	A14,*A2(PMONEY),W
	CALLA	OUTBUCKS		;AND TALLY IT
BUCKPDI
       DIE

**************************************************************************
*                                                                        *
* DRUGPICK - PLAYER DRUG PICKUP PROCESS, IT MAKES THE PLAYER PICKUP	 *
* 	   HIS BOOTY 1 AT A TIME.					 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE DRUG OBJECT						 *
*                                                                        *
**************************************************************************
DRUGPICK
	MOVI	PDRUGOF,A9
	SWAP	A10,A8
	CALLA	DFRMGRND
	SWAP	A10,A8
	CMPI	25,A1
	JRLT	DPICK1
	MOVE	*A10(OYVEL+16),A0,W
	JRNN	DPICK1
	MOVK	1,A0
	JRUC	DPICK2
DPICK1
	CLR	A0
DPICK2
	MOVE	A0,*A13(PDATA),W
	MOVI	DRUGSND,A0
	JSRP	BOOTYFLY
	JRC	DRUGPDI			;BR = DIDN'T WORK
	MOVI	500H,A1
	CALLA	SCORE
	MOVE	*A13(PDATA),A0,W
	JREQ	DPICK3
	CALLA	SCORE			;2X
DPICK3
	MOVE	*A2(PDRUGS),A14,W
	INC	A14	       		;CLICK ANOTHER ONE FOR THIS GUY
	MOVE	A14,*A2(PDRUGS),W
	CALLA	OUTDRUGS		;AND TALLY IT
DRUGPDI
       DIE

**************************************************************************
*                                                                        *
* ROCKPICK - PLAYER ROCKET PICKUP PROCESS, IT MAKES THE PLAYER PICKUP	 *
* 	   HIS BOOTY 1 AT A TIME.					 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE ROCKET OBJECT					 *
*                                                                        *
**************************************************************************
ROCKPICK
	MOVI	PROCKOF,A9
	MOVI	ROCKSND,A0
	JSRP	BOOTYFLY
	JRC	ROCKPDI			;BR = DIDN'T WORK
	MOVE	*A2(PROCKETS),A14,W
	INC	A14	       		;CLICK ANOTHER ONE FOR THIS GUY
	MOVE	A14,*A2(PROCKETS),W
	CALLA	OUTROCKS		;AND TALLY IT
ROCKPDI
       DIE

**************************************************************************
*                                                                        *
* CLIPPICK - PLAYER CLIP PICKUP PROCESS, IT MAKES THE PLAYER PICKUP	 *
* 	   HIS BOOTY 1 AT A TIME.					 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE CLIP OBJECT						 *
*                                                                        *
**************************************************************************
CLIPPICK
	MOVI	PBULLOF,A9
	MOVI	CLIPSND,A0
	JSRP	BOOTYFLY
	JRC	CLIPPDI			;BR = DIDN'T WORK
	MOVE	*A2(PBULLETS),A14,W
	ADDK	25,A14			;<---- MAKE THIS OPER. ADJUSTABLE
	MOVE	A14,*A2(PBULLETS),W
	CALLA	OUTBULLS		;AND TALLY IT
CLIPPDI
       DIE

**************************************************************************
*                                                                        *
* CARDPICK - PLAYER "SAFE" CARD PICKUP PROCESS.				 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE CARD OBJECT						 *
*                                                                        *
**************************************************************************
CARDPICK
	MOVE	*A10(OID),A0,W
	PUSHP	A0	
	MOVI	PCARDOF,A9
	MOVE	@NPLYRS,A0,W
	DEC	A0
	JRNZ	CARDPCK2
	MOVI	CARDSND1,A0
	JRUC	CARDPCK3
CARDPCK2
	MOVI	CARDSND2,A0
CARDPCK3
	JSRP	BOOTYFLY
	PULLP	A3
	JRC	CARDPDI			;BR = DIDN'T WORK
	MOVE	@GOALCARD,A0,W
	CMP	A0,A3
	JRNE	CARDPCK4		;BR = NOT THE GOAL CARD
	CALLA	CLRGOAL			;CLEAR THE GOAL DOOR			
CARDPCK4
	CALLA	CLRMESS
	SLL	28,A3
	SRL	23,A3
	ADDI	CARDATAB,A3
	MOVE	*A3,A3,L
	CALL	A3
CARDPDI
       DIE
*
*ADD CARD ROUTINE TABLE
CARDATAB
	.LONG	ADDCARDS,ADDCARDR,ADDCARDB,ADDCARDG,ADDCRDGR

**************************************************************************
*                                                                        *
* WEEDPICK - PLAYER WEED PLANT PICKUP PROCESS, A COUPLE AT A TIME.	 *
* A8 = PTR TO OBJECT PICKING UP THE LOOT				 *
* A10 = PTR TO THE WEED PLANT OBJECT					 *
*                                                                        *
**************************************************************************
WEEDPICK
	MOVE	A10,A0
	CALLA	ISBB
	JRNC	WEEDOFFBB
	CALLA	DELBB
WEEDOFFBB
	MOVI	BACKSLST,A1
	CALLA	ISSUPP
	JREQ	WEEDOFSUP
	CALLA	DELSUPP
WEEDOFSUP
	MOVI	PDRUGOF,A9
	MOVI	DRUGSND,A0
	JSRP	BOOTYBACK
	JRC	WEEDPDI			;BR = DIDN'T WORK
	MOVI	1000H,A1
	CALLA	SCORE
	MOVE	*A2(PWEED),A14,W
	ADDK	1,A14	       		;CLICK ANOTHER ONE FOR THIS GUY
	MOVE	A14,*A2(PWEED),W
	DIE
WEEDPDI
	MOVE	A10,A0
	MOVK	1,A1
	CALLA	ADDBB
	MOVE	A10,A0
	MOVI	BACKSLST,A1
	CALLA	ADDSUPP
	DIE

**************************************************************************
*                                                                        *
* BUSTAMP - CREATE THE BUST STAMP, WITH THE STAMP SOUND, AND THEN	 *
* 	  MAKE IT FLY UP TO THE CORRECT PLAYER, TALLY, AND SCORE.	 *
* A8 = PTR TO ENEMY BEING BUSTED					 *
* A10 = PTR TO PLAYER DATA BLOCK					 *
*                                                                        *
**************************************************************************
BUSTAMP
	MOVE	A8,A0
	CALLA	DELSHAD		;DELETE THE ENEMY'S SHADOW
	MOVI	ENEMIES,A1
	CALLA	DELSUPP		;TAKE IT OFF OF THIS LIST TOO
	MOVE	A8,A11		;COPY HERE FOR LATER
	CALLA	GETOBJ
	JREQ	BUSTTAL		;BR = NO OBJECT AVAILABLE, JUST TALLY
	MOVI	JUNKOID,A14
	MOVE	A14,*A0(OID),W	;SET THE I.D.
	MOVE	*A8(OZVAL),A14,L
	INC	A14
	MOVE	A14,*A0(OZVAL),L
	CALLA	GETCPNT
	MOVE	A1,A5
	CLR	A9
	MOVY	A5,A9
	SLL	16,A5
	MOVI	BUSTED,A1
	MOVE	*A1,A2,L
	MOVI	DMAWNZ,A4
	CALLA	GANIOF
	SUB	A6,A5
	SUB	A7,A9
	SRL	18,A2
	SLL	16,A2	
	SUB	A2,A9		;MAKE THE STAMP A QUARTER OF THE WAY DOWN
	MOVE	A5,*A0(OXVAL),L
	MOVE	A9,*A0(OYVAL),L
	CALLA	GSAGOF
	MOVE	A1,*A0(OIMG),L
	MOVI	0F9F90000H,A1	;OCONST:OPAL
	MOVE	A0,A14
	ADDI	OPAL+20H,A14
	MMTM	A14,A1,A2,A3,A4
	MOVE	A0,A8		;KEEP ICON POINTER HERE
BUSSNDCK
	MOVI	CHANCVSD,A0
	MOVK	SPEAKPRI,A1	
	CALLA	CKSNDPRI
	JRNC	BUSSNDOK
	SLOOP	3,BUSSNDCK
BUSSNDOK
	CALLA	PSTOP
	MOVE	A8,A0
	CALLA	INSOBJ		;INSERT THIS GUY
	SOUND1	BUSTSND
	SLEEP	18H
	MOVE	A8,A0	
	CALLA	GSCRNREL
	SRL	16,A1
	MOVX	A1,A2
	MOVK	28,A4
	MOVE	*A10(PSCRAD),A3,L
	ADDI	PBUSTOF,A3		;SEND BUST TO THE COUNTER
	CALLA	SLINEVEL		;GET THE VELOCITIES
BUSTAMP1
	MOVE	A1,*A8(OXVEL),L
	MOVE	A2,*A8(OYVEL),L		;STUFF THE VELOCITIES
	MOVE	A1,*A11(OXVEL),L
	MOVE	A2,*A11(OYVEL),L
	MMTM	A12,A1,A2
	MOVE	A8,A0
	CALLA	SCRNRELV		;MAKE THE VELOCITIES SCREEN RELATIVE
	MOVE	A11,A0
	CALLA	SCRNRELV
	SLEEP	1
	MMFM	A12,A1,A2
	CALLA	SCRTST			;CHECK FOR OFF SCREEN
	JREQ	BUSTAMP1

	MOVE	A8,A0
	CALLA	DELOBJ
BUSTTAL
	MOVE	A11,A0
	CALLA	DELPAL
	CALLA	DELOBJ
	MOVE	A10,A0
	CALLA	CKMAXBST
	JRNC	NOBUSTAL		;NO MORE BUSTING ALLOWED, SAYS EUGENE.
	MOVE	A10,A2
	MOVI	>1000,A1
	CALLA 	SCORE
	CALLA	ADDBUST
NOBUSTAL
	DIE

**************************************************************************
*                                                                        *
* BOOTYFLY - MAKE THE BOOTY FLY TO THE TO THE PLAYER'S SCORE AREA.	 *
* A0 = SOUND TO MAKE(0 = NO SOUND)					 *
* A8 = PTR TO PLAYER OBJECT PICKING UP BOOTY				 *
* A9 = OFFSET FROM SCORE ADDRESS TO SEND THIS THING			 *
* A10 = PTR TO BOOTY OBJECT						 *
* RETURNS								 *
* A2 = PTR TO DATA BLOCK OF AFFECTED PLAYER				 *
* CARRY CLEAR ALL IS O.K.						 *
* CARRY SET ACTION DID NOT TAKE PLACE, DON'T TALLY			 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
BOOTYFLY
	CALLA	GPLAYERD
	JRZ	BOOTYPDI
	MOVE	*A2(PFLAGS),A6,L
	BTST	BPICKUP,A6	
	JRNE	BOOTYPDI	     	;BR = ALREADY PICKING UP SOME LOOT

	MOVE	A0,A0
	JRZ	BOOTYP2A		;BR = DON'T MAKE A SOUND
	CALLA	ONESND
BOOTYP2A
	MOVE	A10,A0
	MOVI	BOOTY,A1
	CALLA	DELSUPP			;TAKE THIS BUTTHEAD OFF THE LIST
	CALLA	DELSHAD			;GET RID OF THIS ALSO
	JRUC	BOOTYFLYG

*
*BOOTY FLY ENTRY POINT FOR BOOTY NOT ON A SUPPLEMENTAL LIST YOU SEE
BOOTYBACK
	CALLA	GPLAYERD
	JRZ	BOOTYPDI
	MOVE	*A2(PFLAGS),A6,L
	BTST	BPICKUP,A6	
	JRNE	BOOTYPDI	     	;BR = ALREADY PICKING UP SOME LOOT

	MOVE	A0,A0
	JRZ	BOOTYFLYG		;BR = DON'T MAKE A SOUND
	CALLA	ONESND
	JRUC	BOOTYFLYG
*
*GENERIC BOOTY FLY ENTRYPOINT
BOOTYFLYG
	MOVE	*A10(OPLINK),A0,L
	JREQ	BOOTYP3
	CALLA	KILL
BOOTYP3
	MOVE	A13,*A10(OPLINK),L
	MOVE	A10,A8
	CALLA	PSTOP
	MOVE	*A2(PSCRAD),A3,L	;SET UP FOR EFFECT
	ADD	A9,A3			;SEND BOOTYS TO THE COUNTER

	SRL	16,A6
	ORI	MPICKUP,A6		;HOLD THE PLAYER A BIT
	MOVE	A6,*A2(PEXEFLAG),W
	MOVE	A2,A11			;SAVE HERE

	MOVE	A10,A0	
	CALLA	GSCRNREL
	SRL	16,A1
	MOVX	A1,A2
	MOVK	30,A4			;1/2 SECOND AIR TIME
	CALLA	SLINEVEL		;GET THE VELOCITIES
	MOVE	A10,A8
	PUSHP	A11
	MOVE	*A11(PIRQFLAG),A6,W
	ANDI	MDRIVER|MPASSEN,A6
	JREQ	BOOTYLPF
	MOVK	1,A11
	JRUC	BOOTYP4			;1 TICK 'TIL FLAG CLR FOR CAR DUDES
BOOTYLPF
	MOVK	15,A11			;1/4 SEC 'TIL FLAG CLEAR FOR WALKING
BOOTYP4
	MOVE	A1,*A10(OXVEL),L
	MOVE	A2,*A10(OYVEL),L	;STUFF THE VELOCITIES
	MMTM	A12,A1,A2
	MOVE	A10,A0
	CALLA	SCRNRELV		;MAKE THE VELOCITIES SCREEN RELATIVE
	SLEEP	1
	MMFM	A12,A1,A2
	CALLA	SCRTST			;CHECK FOR OFF SCREEN
	JREQ	BOOTYP4A
	PULLP	A11
	JRUC	BOOTYP6
BOOTYP4A
	DSJS	A11,BOOTYP4
	PULLP	A11
	MOVE	*A11(PEXEFLAG),A6,W
	ANDNI	MPICKUP,A6		;CLEAR THIS SHIT AFTER 1/4 SEC.
	MOVE	A6,*A11(PEXEFLAG),W
BOOTYP5
	MOVE	A1,*A10(OXVEL),L
	MOVE	A2,*A10(OYVEL),L	;STUFF THE VELOCITIES
	MMTM	A12,A1,A2
	MOVE	A10,A0
	CALLA	SCRNRELV		;MAKE THE VELOCITIES SCREEN RELATIVE
	SLEEP	1
	MMFM	A12,A1,A2
	CALLA	SCRTST			;CHECK FOR OFF SCREEN
	JREQ	BOOTYP5
BOOTYP6
	CLR	A0
	MOVE	A0,*A10(OPLINK),L
	MOVE	A10,A0
	CALLA	DELSOBJ			;DELETE THAT BAD DOG
	MOVE	A11,A2
	MOVE	*A2(PEXEFLAG),A6,W
	ANDNI	MPICKUP,A6
	MOVE	A6,*A2(PEXEFLAG),W
	CLRC
	RETP
BOOTYPDI
	SETC
	RETP

**************************************************************************
*                                                                        *
* LOOTXCOL - COLLISION OF A LOOT OBJECT AND AN EXPLOSION		 *
* A0 = PTR TO LOOT OBJECT						 *
* A8 = PTR TO THE 'TING THAT SMASHED IT MAAHN				 *
*                                                                        *
**************************************************************************
LOOTXCOL
	MOVE	A8,A10
	MOVE	A0,A8
	MOVE	*A8(OPLINK),A0,L
	JRZ	LOOTXCNP
	CALLA	KILL
LOOTXCNP
	MOVE	*A8(OIMG),A0,L
	CMPI	GETDOPE,A0	
	JREQ	LOOTXC1
	CMPI	DOPE2,A0
	JREQ	LOOTXC1
	CMPI	DOPE3,A0
	JRNE	LOOTXC2
LOOTXC1
	MOVI	DOPE1,A1
	MOVE	*A8(OFLAGS),A4,W
	CALLA	ANI
LOOTXC2
	CREATE	0EDH,LOOTAWAY
	MOVE	A0,*A8(OPLINK),L
	CLR	A0	
	INC	A0			;STOP THIS SCAN
	CLRC
	RETS

**************************************************************************
*                                                                        *
* LOOTAWAY - MAKE A LOOT OBJECT GET HURLED FROM AN EXPLOSION		 *
* A8 = PTR TO LOOT OBJECT						 *
* A10 = PTR TO THE 'TING THAT SMASHED IT MAAHN				 *
*                                                                        *
**************************************************************************
LOOTAWAY

	MOVE	*A8(OFLAGS),A0,W
	ANDNI	M_PIXSCAN,A0		;MAKE THIS OBJECT PIXABLE
	MOVE	A0,*A8(OFLAGS),W
	MOVE	*A10(ODMAXY),A0,L	;GET DMA XY POSITION OF KILLER
	MOVE	*A10(OSIZE),A1,L	;GET DMA XY SIZE OF KILLER
	CALLA	GETCENT
	MOVE	A1,A2			;KEEP CENTER OF KILLER
	CALLA	GETCPNT			;GET ENEMY'S CENTER

	SEXT	A1			;JUST DEAL WITH X CENTER
	SUB	A2,A1			;A1 = ENEMY XCENT - KILLER XCENT
	MOVE	A1,A2
	SRA	5,A2			;DIVIDE
	MOVE	A2,*A8(OXVEL+16),W	;MAKE DCENTERS A VELOCITY
	CALLA	GETYZVEL		;GET A RANDOM Y & Z VELOCITY
	MOVE	*A8(OSHAD),A0,L
	JRNZ	LOOTSHAD
	CALLA	SHADST			;START A SHADOW
	JRZ	LOOTNOSH
LOOTSHAD	
	MOVE	A0,B0
	MOVE	B2,*B0(OZVEL),L
	MOVE	B2,*B0(OYVEL),L		;SOME SHADOW VEL
LOOTNOSH	
	MOVE	A8,B0
	MOVE	B2,*B0(OZVEL),L
	MOVE	*B0(OYVEL),B1,L		;GET THE CURRENT Y VELOCITY
	JRLE	LOOTRST
	ADD	B1,B3			;FREAK THE LOOT OUT
	JRNN	LOOTRST
	CLR	B3
LOOTRST
	MOVE	B3,*B0(OYVEL),L		;STUFF THE ILL GOTTEN BOOTY

LOOTPDS
	SLEEP	1
	CALLA 	CKZADJST
	MOVE	*A8(OYVEL),A3,L		;GET THE CURRENT Y VELOCITY
	JRLE	LOOTPD1B			;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT
	CALLA	DFRMGRND		;DID HE HIT THE GROUND?
	JRLE	LOOTHIT			;BR = YES

LOOTPD1B
	MOVE	*A8(OYVEL),A0,L		;DECREASE Y VELOCITY
	ADDI	GRAVITY,A0
	MOVE	A0,*A8(OYVEL),L
	JRUC	LOOTPDS
LOOTHIT
	CALLA	PSTOP			;STOP THE SUCKER   
	MOVE	*A8(OIMG),A0,L
	CMPI	DOPE1,A0
	JRNE	LOOTHIT1
	MOVI	DOPEHIT,A9
	MOVK	1,A1
	JSRP	FRANIM
LOOTHIT1
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	MOVE	*A8(OID),A1,W
	JRN	LOOTFLAT		;THIS STUFF LIES DOWN
	CALLA	SETZPOS			;OTHERWISE STAND IT UP
	JRUC	LOOTAEND
LOOTFLAT	
	CALLA	SETTZPOS		;SET Z POSITION BASED ON TOP Y
LOOTAEND
	CALLA	DELSHAD			;RESET SHADOW
	MOVE	A8,A0
	CLR	A0
	MOVE	A0,*A8(OPLINK),L	;DE-LINK PORFAVOR
	DIE

**************************************************************************
*                                                                        *
* KHIT - PUT OUT AN ICON, FLASHING THAT IS, OBJECT IS DELETED.		 *
* A8=OBLOCK POINTER.							 *
* A9 = PTR TO IMAGE HEADER OF OBJECT TO STICK IN.			 *
* I.D. = $DF                                                             *
**************************************************************************
*ENTRY FOR 1K
K1HIT
	MOVI	K1IMG,A9
	JRUC	KHIT
*ENTRY FOR 5K
K5HIT
	MOVI	K5IMG,A9
KHIT
	CALLA	GETCPNT			;GET THE CENTER OF THIS THING
	MOVE	A1,*A8(OXPOS),W
	SRL	16,A1
	MOVE	A1,*A8(OYPOS),W

	MOVI	0F4F4H,A0
	MOVE	A0,*A8(OCONST),W	;STUFF A CONSTANT COLOR

	MOVE	A9,A1
	MOVE	*A8(OFLAGS),A4,W
	ANDNI	(M_FLIPV|M_FLIPH|M_WRNONZ),A4
	ORI	M_CONNON,A4	
	CALLA	ANI

	MOVI	[-2,0],A0
	MOVE	@RAND,A1,W		;GET THE LOW 16 BITS OF RAND
	MOVX	A1,A0			;MAKE SOME DIFFERENT VELS.
	MOVE	A0,*A8(OYVEL),L		;GIVE US A YVEL
	SLEEP	120
	MOVE	A8,A0
	CALLA	DELSOBJ			;GET RID OF THIS THING
	DIE

*
*CARD I.D. TO OFFSET TABLE
CARDIDTB
	.WORD	PSCARD,PRCARD,PBCARD,PGCARD,PGRCARD
**************************************************************************
*                                                                        *
* BOZOCARD - CHECK TO SEE IF BOZO HAS THE CARD HE NEEDS, IF NOT		 *
* 		STICK ONE OUT THERE USING CARDCOLD.			 *
* SAME PARAMS AS CARDCOLD						 *
*                                                                        *
**************************************************************************
BOZOCARD
	MMTM	SP,A1,A2
	MOVE	A14,A1
	SLL	28,A1
	SRL	24,A1
	ADDI	CARDIDTB,A1
	MOVE	*A1,A1,W
	MOVI	P1DATA,A2
	ADD	A1,A2	
	MOVB	*A2,A2
	JRNZ	GBOZOX			;PLAYER ONE HAS ONE
	MOVI	P2DATA,A2
	ADD	A1,A2	
	MOVB	*A2,A2
	JRNZ	GBOZOX			;PLAYER TWO HAS ONE
	MMFM	SP,A1,A2	
	JRUC	CARDCOLD
GBOZOX
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* CARDCOLD - "SAFE" CARD COLD START		       			 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* A14 = [0:#START;#RAND,OID]						 *
* TYPES:	0 = SILVER SAFE CARD					 *
* 		1 = RED SAFE CARD					 *
*		2 = BLUE SAFE CARD					 *
*		3 = GOLD SAFE CARD					 *
*		4 = GREEN SAFE CARD					 *
*                                                                        *
**************************************************************************
CARDCOLD
	MMTM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	MMTM	SP,B0,B1
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	CARDPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	CARDDOIT
CARDPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
CARDDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	CARDNORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
CARDNORN
	MOVE	A14,A7			;STORE THE TOTAL I.D. HERE
	SLL	28,A14
	SRL	23,A14
	ADDI	CARDITAB,A14
	MOVE	*A14,A14,L
CARDLP
	MOVE	A5,A5
	JRZ	CARDCR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
CARDCR
	MOVE	A14,B0
	CALLA	GPALOBJ			;GET US AN OBJECT
	JRZ	CARDCRD			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A7,*A0(OID),W		;STUFF THE GIVEN I.D.
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	CARDSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	CARDGO
CARDSETZ
	CALLA	SETTZPOS		;LAY THOSE MAMA'S DOWN
CARDGO
	MOVI	BOOTY,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
CARDCRD
	MOVE	B0,A14
	DSJ	A6,CARDLP	
	MMFM	SP,B0,B1
	MMFM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	RETS
*CARD INIT TAB PTR TABLE
CARDITAB
	.LONG	SILVINIT,REDINIT,BLUEINIT,GOLDINIT,GRNINIT


*"SAFE" CARD INIT BLOCKS
SILVINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	SILVcard,CARDZ,CARDCOLL					 
	.WORD	DMAWNZ,CARDOID|SILVER
	.LONG	SILVBLIP

REDINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	REDcard,CARDZ,CARDCOLL					 
	.WORD	DMAWNZ,CARDOID|RED
	.LONG	REDBLIP

BLUEINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	BLUEcard,CARDZ,CARDCOLL					 
	.WORD	DMAWNZ,CARDOID|BLUE
	.LONG	BLUEBLIP

GOLDINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	GOLDcard,CARDZ,CARDCOLL					 
	.WORD	DMAWNZ,CARDOID|GOLD
	.LONG	GOLDBLIP

GRNINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	GREENcard,CARDZ,CARDCOLL					 
	.WORD	DMAWNZ,CARDOID|GREEN
	.LONG	GRNBLIP

**************************************************************************
*                                                                        *
* BUCKCOLD - BUCK COLD START			       			 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* A14 = [0:#START;#RAND,OID]						 *
*	TYPES:								 *
*		0 = HORIZONTAL						 *
*		1 = VERTICAL						 *
*                                                                        *
**************************************************************************
BUCKCOLD
	MMTM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	MMTM	SP,B0,B1
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	BUCKPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	BUCKDOIT
BUCKPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
BUCKDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	BUCKNORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
BUCKNORN
	MOVE	A14,A7			;STORE THE TOTAL I.D. HERE
	SLL	28,A14
	SRL	23,A14
	ADDI	BUCKITAB,A14
	MOVE	*A14,A14,L
BUCKLP
	MOVE	@BCCOUNT,A1,W
	DEC	A1
	JRN	BUCKCXX			;NO MORE DOLLARS ALLOWED
	MOVE	A1,@BCCOUNT,W
	MOVE	A5,A5
	JRZ	BUCKCR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
BUCKCR
	MOVE	A14,B0
	CALLA	GPALOBJ			;GET US AN OBJECT
	JRZ	BUCKCRD			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A7,*A0(OID),W		;STUFF THE GIVEN I.D.
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	BUCKSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	BUCKGO
BUCKSETZ
	CALLA	SETTZPOS
BUCKGO
	MOVI	BOOTY,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
BUCKCRD
	MOVE	B0,A14
	DSJ	A6,BUCKLP	
BUCKCXX
	MMFM	SP,B0,B1
	MMFM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	RETS

*MONEY INIT TAB PTR TABLE
BUCKITAB
	.LONG	BCKHINIT,BCKVINIT

BCKHINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	GETCASH1,GOLDHZ,MONYCOLL					 
	.WORD	DMAWNZ,BUCKOID
	.LONG	0

BCKVINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	GETCASH2,GOLDVZ,MONYCOLL					 
	.WORD	DMAWNZ,BUCKOID
	.LONG	0

**************************************************************************
*                                                                        *
* DRUGCOLD - DRUG COLD START			       			 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* A14 = [0:#START;#RAND,OID]						 *
*	TYPES:								 *
*		0 = HORIZONTAL						 *
*		1 = VERTICAL						 *
*                                                                        *
**************************************************************************
DRUGCOLD
	MMTM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	MMTM	SP,B0,B1
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	DRUGPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	DRUGDOIT
DRUGPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
DRUGDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	DRUGNORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
DRUGNORN
	MOVE	A14,A7			;STORE THE TOTAL I.D. HERE
	MOVI	DRUGINIT,A14
DRUGLP
	MOVE	@DCCOUNT,A1,W
	DEC	A1
	JRN	DRUGCXX			;NO MORE DOLLARS ALLOWED
	MOVE	A1,@DCCOUNT,W
	MOVE	A5,A5
	JRZ	DRUGCR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
DRUGCR
	MOVE	A14,B0
	CALLA	GPALOBJ			;GET US AN OBJECT
	JRZ	DRUGCRD			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A7,*A0(OID),W		;STUFF THE GIVEN I.D.
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	DRUGSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	DRUGGO
DRUGSETZ
	CALLA	SETZPOS
DRUGGO
	MOVI	BOOTY,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
DRUGCRD
	MOVE	B0,A14
	DSJ	A6,DRUGLP	
DRUGCXX
	MMFM	SP,B0,B1
	MMFM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	RETS

DRUGINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	GETDOPE,GOLDHZ,DOPECOLL					 
	.WORD	DMAWNZ,DRUGOID
	.LONG	0

**************************************************************************
*                                                                        *
* GOLDCOLD - GOLD CARD COLD START		       			 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* A14 = [0:#START;#RAND,OID]						 *
*	TYPES:								 *
*		0 = HORIZONTAL						 *
*		1 = VERTICAL						 *
*                                                                        *
**************************************************************************
GOLDCOLD
	MMTM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	MMTM	SP,B0,B1
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	GOLDPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	GOLDDOIT
GOLDPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
GOLDDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	GOLDNORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
GOLDNORN
	MOVE	A14,A7			;STORE THE TOTAL I.D. HERE
	SLL	28,A14
	SRL	23,A14
	ADDI	GOLDITAB,A14
	MOVE	*A14,A14,L
GOLDLP
	MOVE	A5,A5
	JRZ	GOLDCR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
GOLDCR
	MOVE	A14,B0
	CALLA	GPALOBJ			;GET US AN OBJECT
	JRZ	GOLDCRD			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A7,*A0(OID),W		;STUFF THE GIVEN I.D.
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	GOLDSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	GOLDGO
GOLDSETZ
	CALLA	SETZPOS
GOLDGO
	MOVI	BOOTY,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
GOLDCRD
	MOVE	B0,A14
	DSJ	A6,GOLDLP	
	MMFM	SP,B0,B1
	MMFM	SP,A0,A1,A5,A6,A7,A10,A11,A14
	RETS

*GOLD BAR INIT TAB PTR TABLE
GOLDITAB
	.LONG	GLDHINIT,GLDVINIT

GLDHINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	goldbr1,GOLDHZ,GOLDCOLL					 
	.WORD	DMAWNZ,GOLDOID
	.LONG	0

GLDVINIT
	.LONG	0,0,0,0					 
	.WORD	0,0							 
	.LONG	goldbr2,GOLDVZ,GOLDCOLL					 
	.WORD	DMAWNZ,GOLDOID
	.LONG	0

*
*"SAFE" CARD ANIMATION SCRIPTS
*
CARDSAN
	.LONG	SILVcard
	.WORD	1
	.LONG	0
CARDRAN
	.LONG	REDcard
	.WORD	1
	.LONG	0
CARDBAN
	.LONG	BLUEcard
	.WORD	1
	.LONG	0
CARDGAN
	.LONG	GOLDcard
	.WORD	1
	.LONG	0
CARDGRAN
	.LONG	GREENcard
	.WORD	1
	.LONG	0

*
*COLLISION LISTS
GOLDCOLL
	.WORD	P1OID
	.LONG	GOLDCOL0
	.WORD	P2OID
	.LONG	GOLDCOL0
	.WORD	0
	.LONG	DUMRTSG
MONYCOLL
	.WORD	B1OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	B2OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	BEOID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	TRAN1OID|CBODYID
	.LONG	MONPCAR
	.WORD	TRAN2OID|CBODYID
	.LONG	MONPCAR
	.WORD	TRAN2OID|WSHLDID
	.LONG	MONPART
	.WORD	P1OID
	.LONG	MONCOL0
	.WORD	P2OID
	.LONG	MONCOL0
	.WORD	0
	.LONG	DUMRTSG
DOPECOLL
	.WORD	B1OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	B2OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	BEOID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	P1OID
	.LONG	DOPECOL0
	.WORD	P2OID
	.LONG	DOPECOL0
	.WORD	TRAN1OID|CBODYID
	.LONG	DRUGPCAR
	.WORD	TRAN2OID|CBODYID
	.LONG	DRUGPCAR
	.WORD	TRAN2OID|WSHLDID
	.LONG	DRUGPART
	.WORD	0
	.LONG	DUMRTSG
ROCKCOLL
	.WORD	B1OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	B2OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	BEOID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	P1OID
	.LONG	ROCKCOL0
	.WORD	P2OID
	.LONG	ROCKCOL0
	.WORD	TRAN1OID|CBODYID
	.LONG	ROCKPCAR
	.WORD	TRAN2OID|CBODYID
	.LONG	ROCKPCAR
	.WORD	TRAN2OID|WSHLDID
	.LONG	ROCKPART
	.WORD	0
	.LONG	DUMRTSG
*
*AMMO CLIP COLLISION LIST
CLIPCOLL
	.WORD	B1OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	B2OID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	BEOID|EXPLODID
	.LONG	LOOTXCOL
	.WORD	P1OID
	.LONG	CLIPCOL0
	.WORD	P2OID
	.LONG	CLIPCOL0
	.WORD	TRAN1OID|CBODYID
	.LONG	CLIPPCAR
	.WORD	TRAN2OID|CBODYID
	.LONG	CLIPPCAR
	.WORD	TRAN2OID|WSHLDID
	.LONG	CLIPPART
	.WORD	0
	.LONG	DUMRTSG
*
*"SAFE" CARD COLLISION LIST
CARDCOLL
	.WORD	P1OID
	.LONG	CARDCOL0
	.WORD	P2OID
	.LONG	CARDCOL0
	.WORD	TRAN1OID|CBODYID
	.LONG	CARDPCAR
	.WORD	TRAN2OID|CBODYID
	.LONG	CARDPCAR
	.WORD	0
	.LONG	DUMRTSG
*
*WEED PLANT COLLISION LIST
WEEDCOLL
	.WORD	P1OID
	.LONG	WEEDCOL0
	.WORD	P2OID
	.LONG	WEEDCOL0
	.WORD	B1OID|EXPLODID
	.LONG	CANEXCOL
	.WORD	B2OID|EXPLODID
	.LONG	CANEXCOL
	.WORD	BEOID|EXPLODID
	.LONG	CANEXCOL
	.WORD	0
	.LONG	DUMRTSG
*LOOTSKI
MONEY1	.LONG	GETCASH1
	.WORD	3
	LONGNULL
MONEY2
	.LONG	GETCASH2
	.WORD	3
	LONGNULL

ROCKF	.LONG	ROCKBIG
	.WORD	3
	LONGNULL

CLIPF	.LONG	GETCLIP
	.WORD	3
	LONGNULL

DOPE	.LONG	DOPE1
	.WORD	1
	LONGNULL
DOPEHIT
	.LONG	DOPE2
	.WORD	8
	.LONG	DOPE3
	.WORD	8
	.LONG	GETDOPE
	.WORD	8
	LONGNULL
*
*CARD SCANNER BLIPS
SILVBLIP
	.LONG	SILVBLP1,SILVBLP1
SILVBLP1
   .word    >B,>4
   .byte    >00,>B9,>50,>50,>50,>50,>50,>50,>50,>50,>50
   .byte    >00,>50,>50,>50,>50,>50,>50,>50,>50,>50,>B9
   .byte    >B9,>50,>50,>50,>50,>50,>50,>50,>50,>50,>00
   .byte    >50,>50,>50,>50,>50,>50,>50,>50,>50,>B9,>00
	.EVEN
REDBLIP
	.LONG	REDBLP1,REDBLP1
REDBLP1
   .word    >B,>4
   .byte    >00,>CE,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5
   .byte    >00,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>CE
   .byte    >CE,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>00
   .byte    >D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>D5,>CE,>00
	.EVEN
BLUEBLIP
	.LONG	BLUEBLP1,BLUEBLP1
BLUEBLP1
   .word    >B,>4
   .byte    >00,>8C,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF
   .byte    >00,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>8C
   .byte    >8C,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>00
   .byte    >DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>DF,>8C,>00
	.EVEN
GOLDBLIP
	.LONG	GOLDBLP1,GOLDBLP1
GOLDBLP1
   .word    >B,>4
   .byte    >00,>B1,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9
   .byte    >00,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>B1
   .byte    >B1,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>00
   .byte    >D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>D9,>B1,>00
	.EVEN
GRNBLIP
	.LONG	GRNBLP1,GRNBLP1
GRNBLP1
   .word    >B,>4
   .byte    >00,>1A,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB
   .byte    >00,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>1A
   .byte    >1A,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>00
   .byte    >DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>DB,>1A,>00
	.EVEN

	.END
