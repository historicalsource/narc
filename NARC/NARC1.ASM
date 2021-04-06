	.FILE	'NARC1.ASM'
	.TITLE	" <<< NARC GENERAL PURPOSE SUBROUTINES >>>"

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
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCTEQU.ASM"		;NARC Todd Equates
	.INCLUDE	"NARCAUDN.ASM"
***	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates
	.INCLUDE	"NARCFRAG.GLO"

*LABELS IN THIS MODULE
	.GLOBAL	FILLAREA,FINDBB,ANIMATCK
*LABELS EXTERNAL TO THIS MODULE
	.GLOBAL	BUGBURN,LDEXP1
	.GLOBAL	CHINADR1,CHINADR2,CHINADR3,ARMDR1,ARMDR2,ARMDR3,GET_ADJ
	.GLOBAL	BIGDOOR1,BIGDOOR2,BIGDOOR3,HOTWIN1

	 .BSS	NOAUTOE,16			;DEBUGGERY

	.EVEN
	.TEXT

SNDSIDE	JAUC	ONESND

**************************************************************************
*                                                                        *
* OBJECT BLOCK INITIALIZATION ROUTINES					 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* GPALOBJ - GET A PALETTE AND AN OBJECT BLOCK				 *
* A14 = PTR TO PLAYER INITIALIZATION TABLE.				 *
* RETURNS:								 *
* A0 = PTR TO OBJECT							 *
* Z BIT SET = FAILURE,A0 = 0						 *
*                                                                        *
**************************************************************************
GPALOBJ
	CALLA	GETOBJ
	JRZ	GPALOBJX		;OBJECT BLOCK FAILURE
	CALLA	INITPAL			;GET THE PALETTE
	JRNZ	GPALOBJX
	CALLA	FREEOBJ
	CLR	A0
GPALOBJX
	RETS
**************************************************************************
*                                                                        *
* GBPALOBJ - GET A BACKGROUND PALETTE AND AN OBJECT BLOCK		 *
* A14 = PTR TO PLAYER INITIALIZATION TABLE.				 *
* RETURNS:								 *
* A0 = PTR TO OBJECT							 *
* Z BIT SET = FAILURE,A0 = 0						 *
*                                                                        *
**************************************************************************
GBPALOBJ
	CALLA	GETOBJ
	JRZ	GBPALOX			;OBJECT BLOCK FAILURE
	CALLA	INITBPAL		;GET THE BACKGROUND PALETTE
	JRNZ	GBPALOX
	CALLA	FREEOBJ
	CLR	A0
GBPALOX
	RETS

*
*SHVELCPY - COPY VELOCITIES TO SHADOW (IF ANY)
*A8=OBJECT
*
SHVELCPY: 
	MMTM	SP,A0,A1
	MOVE	*A8(OSHAD),A0,L
	JREQ	SHVLCPX
	MOVE	*A8(OXVEL),*A0(OXVEL),L
	MOVE	*A8(OZVEL),A1,L
	MOVE	A1,*A0(OZVEL),L
	MOVE	A1,*A0(OYVEL),L
SHVLCPX:
	MMFM	SP,A0,A1
	RETS

*
*SHVELFLP - COPY SHADOW VELOCITY AND FLIP HIM
*A8=OBJECT
*A3=OXVEL
SHVELFLP:
	CALLR	SHVELCPY
	MOVE	*A8(OXVEL+>10),A14,W		;TEST X VELOCITY
*FLIPDUDE
*A8=OBJECT, N=SIGN OF XVEL
FLP:
	JAN	YFLP
	JAUC	NOYFLP

**************************************************************************
*                                                                        *
* OBJOFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT TO 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
OBJOFF
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	MOVE	A4,*A0(OFLAGS),W
	PULL	A4
	RETS
**************************************************************************
*                                                                        *
* OBJON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
OBJON
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	ADDK	2,A4
	MOVE	A4,*A0(OFLAGS),W
	PULL	A4
	RETS

**************************************************************************
*                                                                        *
* Z POSITIONING ROUTINES						 *
*                                                                        *
**************************************************************************

*
*XZCHK
*CALLING PARAMETERS:
*A8=OBJECT SEEKING
*A0=OBJECT SEEKED
*A5=X RANGE
*A6=Z RANGE
*RETURNS:
*CARRY SET IF HE IS CLOSE ENOUGH
*A1=DELTA X
*A2=DELTA Z
*A3=ABS DELTA X
*A4=ABS	DELTA Z
XZCHK:
	MOVE	A0,A4
	CALLR	GETANIX			;GET X ANIMATION POINT
	MOVE	A0,A3
	SWAP	A4,A8
	CALLR	GETANIX
	MOVE	A0,A1
	MOVE	A8,A0
	MOVE	A4,A8
	MOVE	*A8(OZPOS),A4,W	       
	MOVE	*A0(OZPOS),A2,W
	SUB	A4,A2
	SUB	A3,A1
	MOVE	A1,A3
	MOVE	A2,A4
	ABS	A3
	ABS	A4
	CMP	A5,A3
	JRNC	XZCHKX
	CMP	A6,A4
XZCHKX:
	RETS
	
**************************************************************************
*                                                                        *
* CLRPDATA - CLEAR THE PDATA AREA OF A PROCESS BLOCK			 *
* A13 = PTR TO PROCESS BLOCK						 *
*                                                                        *
**************************************************************************
CLRPDATA
	MMTM	SP,A1,A6,A14
	MOVE	A13,A14
	CLR	A1
	ADDI	PDATA,A14
	MOVI	(PSDATA-PDATA)/16,A6
CLRSHL
	SRL	1,A6
	JRNC	CLRPDL
	MOVE	A1,*A14+,W	;STUFF THE ODD WORD	
CLRPDL
	MOVE	A1,*A14+,L		
	DSJS	A6,CLRPDL
	MMFM	SP,A1,A6,A14
	RETS
**************************************************************************
*                                                                        *
* DFRMGRND - RETURNS THE DISTANCE FROM THE BOTTOM OF			 *
* 		   AN OBJECT TO THE "GROUND."				 *
* A8 = OBJECT BLOCK							 *
* RETURN(S)								 *
* A1 = DISTANCE FROM GROUND (16 BITS)					 *
* STATUS BITS SET ACCORDING TO THE SIGN OF A1				 *
* NOTE: MAX ACCEPTABLE Y = +32K, MIN ACCEPTABLE Y = -32K		 *
*                                                                        *
**************************************************************************
DFRMGRND
	PUSH	A2
	move	*A8(OYPOS),A1,W
	move	*A8(OSIZEY),A2,W
	add	A1,A2			;A2 = BOTTOM Y
	move	*A8(OZPOS),A1,W
	sub	A2,A1
	addi	ZORIGIN,A1
	mmfm	SP,A2
	RETS

**************************************************************************
*                                                                        *
* GET BOTTOM Y OF AN OBJECT						 *
* A8 = OBJECT BLOCK PTR							 *
* RETURN(S)								 *
* A1 = 16 BIT BOTTOM Y IN LSW						 *
* STATUS SET ACCORDING TO THE BOTTOM Y					 *
*NOTE: MAKE SURE OBLOCK IS INIT'D WITH GSAGOF BEFORE CALLING		 *
*                                                                        *
**************************************************************************
GETBOTY
	PUSH	A2
	MOVE	*A8(OYPOS),A1,W		;GET Y POSITION
	MOVE	*A8(OSIZEY),A2,W	;GET THE CURRENT SIZE
	ADD	A2,A1			;A1 = BOTTOM Y
	MMFM	SP,A2
	RETS

**************************************************************************
*                                                                        *
* GETCPNT - RETURNS THE CENTER XY POSITION OF A GIVEN IMAGE		 *
* A8 = IMAGE OBLOCK							 *
* RETURN(S)								 *
* A1 = CENTER Y:CENTER X							 *
*                                                                        *
**************************************************************************
GETCPNT	MOVE	A0,-*SP,L
	MOVE	*A8(OYPOS),A0,W
	SLL	16,A0
	MOVE	*A8(OXPOS),A1,W
	MOVX	A1,A0
	MOVE	*A8(OSIZE),A1,L
	CALLR	GETCENT
	SLL	16,A0
	MOVY	A0,A1
	MOVE	*SP+,A0,L
	RETS

**************************************************************************
*                                                                        *
* GETCENT - RETURNS THE CENTER POINT OF A BOX		      		 *
* A0 = UPPER LEFT Y:UPPER LEFT X					 *
* A1 = Y_SIZE:X_SIZE   							 *
* RETURN(S)								 *
* A0 = CENTER Y(LSW)							 *
* A1 = CENTER X(LSW)							 *
*                                                                        *
**************************************************************************
GETCENT	MOVE	A2,-*SP,L
	MOVY	A1,A2
	SRL	17,A2		;YSIZE/2
	SLL	16,A2		;BACK TO Y HALF
	SLL	16,A1		;CLEAR Y
	SRL	17,A1		;XSIZE/2
	MOVY	A2,A1
	ADDXY	A1,A0		;OFFSET TO CENTER
	CLR	A1
	MOVX	A0,A1		;RETURN THESE IN USEFUL POSITIONS
	SRL	16,A0
	MOVE	*SP+,A2,L
	RETS

**************************************************************************
*                                                                        *
* GETSCRRX - THE THE WORLD X COORDINATE OF THE SCREEN RIGHT END		 *
* RETURNS								 *
* A0 = SCREEN RIGHT X, 32 BITS						 *
*                                                                        *
**************************************************************************
GETSCRRX
	PUSH	A2
	MOVE	@SCRNLR,A0,W
	MOVE	@WORLDTL,A2,W
	ADD	A2,A0			;GET SCREEN LOWER RT.
	SLL	16,A0
	PULL	A2
	RETS

*
*GETANIX - GET ANIMATION POINT X COORD
*CALLING PARMS: A8=OBJECT
*RETURNS A0=16 BIT WORLD COORD OF UPPER LEFT
*
GETANIX:
	MMTM	SP,A1,A2
	MOVE	*A8(OIMG),A1,L
	MOVE	*A1(IANIOFF),A2,W
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRZ	GETAX1
	MOVE	*A1(ISIZE),A0,W
	SUB	A2,A0
	DEC	A0
	MOVE	A0,A2
GETAX1:
	MOVE	*A8(OXPOS),A0,W
	ADD	A2,A0
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* GETZMID - GET THE Z MIDPOINT OF AN OBJECT.				 *
* A8 = PTR TO OBJECT							 *
* RETURNS:								 *
* A0 = 32 BIT Z CENTER							 *
*                                                                        *
**************************************************************************
GETZMID
	MMTM	SP,A1,A2
	MOVE	*A8(OZSIZ),A2,L
	MOVY	A2,A1				;A1 = OZPLUS
	SRL	16,A1
	ZEXT	A2
	ADD	A1,A2				;A2 = TOTAL Z WIDTH
	SLL	15,A2				;DIVIDE FOR HALF
	SLL	16,A1
	MOVE	*A8(OZVAL),A0,L
	ADD	A1,A0				;GET TO THE EDGE
	SUB	A2,A0				;GO BACK TO MIDPOINT	
	MMFM	SP,A1,A2	
	RETS

**************************************************************************
*                                                                        *
* CLRWORLD - CLEAR ALL WORLD COORDINATES AND SCROLL VELOCITIES.		 *
*                                                                        *
**************************************************************************
CLRWORLD
	PUSH	A0
	CLR	A0
	MOVE	A0,@SCROLLX,L		;X SCROLL VALUE
	MOVE	A0,@SCROLLY,L		;Y SCROLL VALUE
	MOVE	A0,@WORLDTLX,L		;TOP LEFT X SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTLY,L		;TOP LEFT Y SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTL,L
	MOVE	A0,@BAK2TLY,L		;TOP LFT Y SLOW SCROLL BACKGROUND
	MOVE	A0,@BAK2TLX,L		;TOP LFT X SLOW SCROLL BACKGROUND
	MOVI	SCRNST,A0
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0
	MOVE	A0,@SCRNLR,L
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* GETSCRBY - THE THE WORLD Y COORDINATE OF THE SCREEN BOTTOM		 *
* RETURNS								 *
* A0 = SCREEN BOTTOM Y							 *
*                                                                        *
**************************************************************************
GETSCRBY
	PUSH	A2
	MOVE	@SCRNLR+16,A0,W
	MOVE	@WORLDTL+16,A2,W
	ADD	A2,A0			;GET SCREEN BOTTOM Y
	SLL	16,A0			;MAKE IT A 32 BIT VALUE
	PULL	A2
	RETS

**************************************************************************
*                                                                        *
* SETZPOS - SETUP OBJECTS Z POSITION					 *
*	    BASED ON OBJECTS BOTTOM Y POSITION				 *
* A0 = OBJECT BLOCK							 *
*                                                                        *
**************************************************************************
SETZPOS	MOVE	A1,-*SP,L
	CALLR	GETZPOS
	SLL	16,A1
	MOVE	A1,*A0(OZVAL),L
	MOVE	*SP+,A1,L
	RETS

**************************************************************************
*                                                                        *
* SETYFRMZ - SET THE OBJECTS Y POSITION ACCORDING TO IT'S CURRENT Z	 *
* A0 = OBJECT								 *
*                                                                        *
**************************************************************************
SETYFRMZ
	MMTM	SP,A1,A2
	MOVE	*A0(OZVAL),A1,L
	ADDI	ZORIGIN*10000H,A1
	MOVE	*A0(OSIZEY),A2,W
	SLL	16,A2
	SUB	A2,A1
	MOVE	A1,*A0(OYVAL),L
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* SETTZPOS - SET OBJECTS Z POS. BASED ON TOP Y POSITION			 *
* A0 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
SETTZPOS
	PUSH	A1
	MOVE	*A0(OYPOS),A1,W
	SUBI	ZORIGIN,A1 	;GET Z POSITION 			
	MOVE	A1,*A0(OZPOS),W
	PULL 	A1
	RETS

**************************************************************************
*                                                                        *
* GETZPOS - GET AN OBJECTS Z POSITION BASED ON ZORIGIN			 *
* A0 = OBJECT BLOCK PTR							 *
* RETURN(S)								 *
* A1 = Z POSITION							 *
*                                                                        *
**************************************************************************
GETZPOS	MOVE	A8,-*SP,L
	MOVE	A0,A8
	CALLR	GETBOTY
	SUBI	ZORIGIN,A1 	;GET Z POSITION 			
	MOVE	*SP+,A8,L
	RETS

**************************************************************************
*                                                                        *
* PUTZPOS - STUFF OBJECTS Z POSITION					 *
* A0 = OBJECT BLOCK PTR							 *
* A1 = 16 BIT Z POSITION						 *
*                                                                        *
**************************************************************************
PUTZPOS	MOVE	A1,*A0(OZPOS),W
	RETS

**************************************************************************
*                                                                        *
* MAKSHAD - MAKE A SHADOW OF AN OBJECT. IT IS JUST THE OBJECT WITH A	 *
* 	  CONSTANT COLOR, XLATED TO THE GROUND				 *
* A8 = OBJECT TO SHADOW							 *
* RETURN(S)								 *
* A0 = SHADOW OBJECT							 *
*                                                                        *
**************************************************************************
MAKSHAD
	CALLA	SHADST
	RETS

**************************************************************************
*                                                                        *
* OFLASH - FLASH THE OBJECT WITH A CONSTANT COLOR			 *
* A8=PTR TO OBJECT BLOCK						 *
*                                                                        *
**************************************************************************
OFLASH	MOVI	0FFFFh,A0
	MOVE	A0,*A8(OCONST),W	;SELECT CONSTANT COLOR

OFLSH1	MOVE	*A8(OFLAGS),A0,W
	SRL	4,A0
	SLL	4,A0
	ADDK	8,A0
	MOVE	A0,*A8(OFLAGS),W	;FLASHY

	MOVK	4,A0
	CALLA	PRCSLP

	MOVE	*A8(OFLAGS),A0,W
	SRL	4,A0
	SLL	4,A0
	ADDK	2,A0
	MOVE	A0,*A8(OFLAGS),W	;NORMAL

	MOVK	3,A0
	CALLA	PRCSLP
	JRUC	OFLSH1		

**************************************************************************
*                                                                        *
* BOUNCER - ALTERS AN OBJECTS VELOCITY ACCORDING TO THE DIRECTION IT IS	 *
* 	  CURRENTLY MOVING. IF THE OBJECT IS TRAVELLING IN POSITIVE X	 *
* 	  IT WILL ADD A NEGATIVE X VELOCITY FACTOR, AND VICE-VERSA. THE	 *
* 	  SAME GOES FOR Y.						 *
* A4 = BOUNCE VELOCITY FACTOR FOR X					 *
* A5 = BOUNCE VELOCITY FACTOR FOR Y					 *
* A8 = OBLOCK PTR							 *
*                                                                        *
**************************************************************************
BOUNCER
	MMTM	SP,A0,A1
	MOVE	*A8(OXVEL),A1,L		;PROCESS X VELOCITY
	MOVE	A4,A0
	CALLR	REVVEL
	MOVE	A1,*A8(OXVEL),L
	MOVE	*A8(OYVEL),A1,L		;PROCESS Y VELOCITY
	MOVE	A5,A0
	CALLR	REVVEL
	MOVE	A1,*A8(OYVEL),L
	SRL	16,A1
	MOVE	A1,*A8(OZVEL),W		;STUFF THIS AS A Z VELOCITY ALSO
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* REVVEL - ADDS A REVERSE VELOCITY FACTOR TO A GIVEN VELOCITY 		 *
* A0 = VELOCITY FACTOR							 *
* A1 = VELOCITY								 *
*                                                                        *
**************************************************************************
REVVEL	PUSH	A0
	TEST	A1	
	JREQ	REVVELX		;BR = NOT GOING ANYWHERE
	JRN	REVVEL1		;BR = VELOCITY IS NEGATIVE, ADD AS IS
	NEG	A0
REVVEL1
	ADD	A0,A1
REVVELX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* SLINEVEL - GET THE X & Y VELOCITIES TO MAKE AN OBJECT TRAVEL		 *
* 	   FROM PNT. A TO PNT. B ALONG THE SHORTEST PATH.		 *
* A2 = PNT. A [Y,X] POSITION						 *
* A3 = PNT. B [Y,X] POSITION						 *
* A4 = DURATION(# OF TICKS TO GET FROM A TO B)				 *
* RETURNS:								 *
* A1 = X VEL (32 BITS)							 *
* A2 = Y VEL (32 BITS)							 *
* NOTE: DON'T CALL WITH THE A=B, IT'S A WAIST OF TIME AND UNDEFINED.	 *
*                                                                        *
**************************************************************************
SLINEVEL
	MMTM	SP,A3
	SUBXY	A2,A3		;GET THE DIFFERENCE
	MOVX	A3,A1		;A1 = X DISTANCE
	SRL	16,A3
	SLL	16,A3		;CLEAR OUT THE X PART
	DIVS	A4,A3		;A3 = Y VELOCITY(32 BITS)
	SLL	16,A1
	DIVS	A4,A1		;A1 = X VELOCITY(32 BITS)
	MOVE	A3,A2		;RETURN Y VEL HERE FOR CONSISTENCY
	MMFM	SP,A3
	RETS

**************************************************************************
*                                                                        *
* ROUTINES TO SUPPORT THE NARC SPECIFIC MISC. LISTS			 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* BBINIT - INITIALIZE THE BACKGROUND BLOCK FREE LIST			 *
*                                                                        *
**************************************************************************
BBINIT	MMTM	SP,A0,A1,A2,A3
	MOVI	NBBLOCKS,A3,W		;# OF BACKGROUND BLOCKS TO INIT
	MOVI	BBLOCKS,A1
	MOVE	A1,@BBFREE,L		;INITIALIZE FREE LIST POINTER
	CLR	A0
	MOVE	A0,@BBACTIVE,L		;EMPTY THE ACTIVE LIST

**************************************************************************
*                                                                        *
* NINIT - FREE LIST INITIALIZATION FOR NARC MISC. LISTS			 *
* A1 = FIRST BLOCK OF LIST						 *
* A3 = BLOCK COUNT							 *
*                                                                        *
**************************************************************************
NINIT 
	MOVE	A1,A2
	ADDI	NSIZ,A1,W
	MOVE	A1,*A2,L		;LINK UP THE FREE LIST
	DSJS	A3,NINIT
    	MOVE	A0,*A2,L		;ZERO LAST LINK
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS

**************************************************************************
*                                                                        *
* ADDBB - ADD BACKGROUND BLOCK TO BB ACTIVE LIST			 *
*         THE LIST IS SORTED IN ASCENDING X, THEN ASCENDING Y.		 *
* A0 = PTR TO BACKGROUND BLOCK						 *
* A1 = DATA								 *
* RETURN(S)								 *
* A0 = PTR TO ELEMENT							 *
* ZBIT SET UPON FAILURE							 *
* NOTE: THE BCKGND BLOCK MUST BE STUFFED WITH INFO FIRST		 *
*                                                                        *
**************************************************************************
ADDBB	MMTM	SP,A2,A3,A4,A5,A6,A7,A8,A9,A10	
	MOVI	BBFREE,A2
	MOVI	BBACTIVE,A3
	MOVE	*A0(OXVAL),A7,L
	MOVE	*A0(OYVAL),A8,L

	MOVE	*A2,A4,L	;GET A BLOCK OFF THE FREE LIST
	JREQ	ADDBBX		;BR = NONE AVAILABLE

	MOVE	*A4,A5,L	;A5 = REST OF FREE LIST
	MOVE	A5,*A2,L	

	MOVE	A0,*A4(NPTR),L	;STUFF THE OBJECT PTR
	MOVE	A1,*A4(NDATA),W	;AND THE DATA

ADDBBL
	MOVE	A3,A6		;A6 = POINTER TO PREVIOUS
	MOVE	*A6,A3,L	;A3 = PTR TO NEXT
	JREQ	ADDBBEND	;BR = END OF THE LIST, ADD IT HERE

	MOVE	*A3(NPTR),A9,L
	MOVE	*A9(OXVAL),A10,L
	CMP	A10,A7
	JRGT	ADDBBL		;BR = NOT TIME TO ADD
	JRLT	ADDBBEND	;BR = ADD AWAY.

	MOVE	*A9(OYVAL),A10,L	;X'S ARE =, WE MUST TRY THE YPOS
	CMP	A10,A8
	JRGT	ADDBBL

ADDBBEND
	MOVE	A3,*A4,L	;PTR TO THE REST OF THE LIST	
	MOVE	A4,*A6,L

ADDBBX
	MOVE	A4,A0		;RETURN THE PTR
	MMFM	SP,A2,A3,A4,A5,A6,A7,A8,A9,A10
	RETS

**************************************************************************
*                                                                        *
* DELBB - DELETE A BACKGROUND BLOCK FROM THE BBACTIVE LIST		 *
* A0 = PTR TO BACKGROUND BLOCK						 *
*                                                                        *
**************************************************************************
DELBB	MMTM	SP,A2,A3
	MOVI	BBFREE,A2
	MOVI	BBACTIVE,A3
	CALLR	DELNLIST
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* ISBB - CHECK TO SEE IF OBJECT IS ON THE BB LIST			 *
* A0 = PTR TO OBJECT							 *
* RETURNS								 *
* CARRY CLEAR = NOT FOUND						 *
* CARRY SET   = FOUND							 *
*                                                                        *
**************************************************************************
ISBB
	MMTM	SP,A3
	MOVI	BBACTIVE,A3
	CALLR	ISNLIST
	MMFM	SP,A3
	RETS

**************************************************************************
*                                                                        *
* FINDBB - FIND AN OBJECTS BB LIST NODE.				 *
* A0 = PTR TO OBJECT							 *
* RETURNS								 *
*	A0 = NODE PTR, 0 = NONE FOUND					 *
*  	Z BIT SET  = NOT FOUND						 *
* 	Z BIT CLR  = FOUND						 *
*                                                                        *
**************************************************************************
FINDBB
	MMTM	SP,A3
	MOVI	BBACTIVE,A3
	CALLR	ISNLIST
	MOVE	A3,A0
	MMFM	SP,A3
	RETS

**************************************************************************
*                                                                        *
* ADDNLIST - ADD AN ELEMENT TO A GIVEN NARC MISC. LIST.			 *
* A0 = PTR TO STUFF 							 *
* A1 = DATA TO STUFF							 *
* A2 = MEMORY LOCATION OF FREE LIST					 *
* A3 = MEMORY LOCATION OF ACTIVE LIST					 *
* RETURN(S)								 *
* A0 = PTR TO ELEMENT							 *
* ZBIT SET UPON FAILURE							 *
*                                                                        *
**************************************************************************
ADDNLIST
	MMTM	SP,A4,A5

	MOVE	*A2,A4,L	;GET A BLOCK OFF THE FREE LIST
	JREQ	ADDNX		;BR = NONE AVAILABLE

	MOVE	*A4,A5,L	;A5 = REST OF FREE LIST
	MOVE	A5,*A2,L	

	MOVE	*A3,A5,L	;A5 = ACTIVE LIST
	MOVE	A4,*A3,L	;PUT NEW ELEMENT TO THE HEAD OF THE LIST
	MOVE	A5,*A4,L	;LINK THE REST OF THE ACTIVE LIST

	MOVE	A0,*A4(NPTR),L	;STUFF THE OBJECT PTR
	MOVE	A1,*A4(NDATA),W	;AND THE DATA
	MOVE	A4,A0		;RETURN IN A RECONIZED POSITION

ADDNX:	
	MMFM	SP,A4,A5
	RETS	

**************************************************************************
*                                                                        *
* DELNLIST - DELETE AN ELEMENT FROM A NARC MISC. LIST.			 *
* A0 = VALUE CONTAINED IN NPTR						 *
* A2 = MEMORY LOCATION OF FREE LIST					 *
* A3 = MEMORY LOCATION OF ACTIVE LIST					 *
*                                                                        *
**************************************************************************
DELNLIST
	MMTM	SP,A3,A4,A5
DELNLP	
	MOVE	A3,A4       	;SAVE PREVIOUS
	MOVE	*A3,A3,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRNE	DELNCHK

	CALLERR	3		;LOG THE ERROR
	JRUC	DELNX
***	JREQ	$		;ELEMENT DOES NOT EXIST, ERROR

DELNCHK
	MOVE	*A3(NPTR),A5,L
	CMP	A5,A0
	JRNE	DELNLP		;NOT FOUND KEEP LOOKING

	MOVE	*A3,*A4,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	*A2,A4,L	;LINK INTO FREE LIST AT START
	MOVE	A4,*A3,L
	MOVE	A3,*A2,L
DELNX
	MMFM 	SP,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* ISNLIST - SEE IF ELEMENT EXISTS ON NARC MISC. LIST			 *
* A0 = CONTENTS OF NPTR TO SEARCH FOR					 *
* A3 = LOCATION OF ACTIVE LIST						 *
* RETURNS								 *
* A3 = BBLIST NODE IF FOUND						 *
* CARRY CLEAR = NOT FOUND						 *
* CARRY SET   = FOUND							 *
*                                                                        *
**************************************************************************
ISNLIST
	MMTM	SP,A5
ISNLP	
	MOVE	*A3,A3,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRNZ	ISNCMP
	CLRC			;NO FOUNDING BROHCK, MANG		
	MMFM	SP,A5
	RETS
ISNCMP
	MOVE	*A3(NPTR),A5,L
	CMP	A5,A0
	JRNE	ISNLP		;NOT FOUND KEEP LOOKING
	SETC			;FOUND ONE, FLAG PLEASE
	MMFM	SP,A5
	RETS

**************************************************************************
*                                                                        *
* ISBBID - SEE IF AN OBJECT OF GIVEN ID EXISTS ON THE BB LIST.		 *
* A0 = OID TO SEARCH AGAINST.						 *
* A1 = MASK 0=DON'T CARE						 *
* RETURNS								 *
*	Z BIT SET = NOT FOUND, A0 = 0					 *
*	Z BIT CLR = FOUND, A0 = PTR TO BBLIST ELEMENT			 *
*                                                                        *
**************************************************************************
ISBBID
	MMTM	SP,A2,A3
	MOVE	A1,A2
	AND	A0,A2		;FORM SEARCH I.D.
	MOVI	BBACTIVE,A0
ISBBIDLP	
	MOVE	*A0,A0,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRZ	ISBBIDX
	MOVE	*A0(NPTR),A3,L
	MOVE	*A3(OID),A3,W
	AND	A1,A3		;STRIP DON'T CARES
	CMP	A3,A2		;CHECK AGAINST MATCH
	JRNE	ISBBIDLP	;BR = NO MATCH
	MOVE	A0,A0		;CLR Z
ISBBIDX
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* ISBBBLP - SEE IF AN OBJECT WITH A GIVEN OBLIP EXISTS ON THE BB LIST.	 *
* A0 = OBLIPIMG TO SEARCH AGAINST.					 *
* RETURNS								 *
*	Z BIT SET = NOT FOUND, A0 = 0					 *
*	Z BIT CLR = FOUND, A0 = PTR TO BBLIST ELEMENT			 *
*                                                                        *
**************************************************************************
ISBBBLP
	MMTM	SP,A1,A2
	MOVE	A0,A1
	MOVI	BBACTIVE,A0
ISBBBBLP	
	MOVE	*A0,A0,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRZ	ISBBLPX
	MOVE	*A0(NPTR),A2,L
	MOVE	*A2(OBLIPIMG),A2,L
	CMP	A1,A2		;CHECK AGAINST MATCH
	JRNE	ISBBBBLP	;BR = NO MATCH
	MOVE	A0,A0		;CLR Z
ISBBLPX
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* DELBBOBJ - FULLY DELETE A BBLIST OBJECT FROM THE WORLD.		 *
* A0 = PTR TO BBLIST NODE.						 *
*                                                                        *
**************************************************************************
DELBBOBJ
	PUSH	A1
	MOVE	*A0(NDATA),A1,W		;SEE IF IT IS ON SCREEN
	JRZ	DELBBOP			;BR = NO JUST PULL IT
	MOVE	*A0(NPTR),A0,L
	MOVI	BACKSLST,A1
	CALLA	DELSUPP			;DELETE OFF THE SUPPLEMENTAL
	CALLA	DELSOBJ			;DELETE IT OFF OF THE LIST
	JRUC	DELBBBB
DELBBOP
	MOVE	*A0(NPTR),A0,L
	CALLA	FREESOBJ		;JUST FREE UP THE DATA BLOCK
DELBBBB
	CALLR	DELBB			;AND DELETE IT OFF OF THE 
	MOVE	*A0(OPLINK),A0,L
	JRZ	DELBBNP
	CALLA	KILL
DELBBNP
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* BBWIPE - PUT ALL BACKGROUND OBJECTS, CURRENTLY IN LIMBO, ONTO THE 	 *
* 	 OBJECT FREE LIST.						 *
*                                                                        *
**************************************************************************
BBWIPE	MMTM	SP,A0,A1,A2
	MOVI	BBACTIVE,A1

BBWIPE1
	MOVE	*A1,A1,L
	JREQ	BBWIPEX		;BR = WE'RE DONE
	MOVE	*A1(NDATA),A2,W
	JRNE	BBWIPE1		;BR = THIS BLOCK IS NOT IN LIMBO
	MOVE	*A1(NPTR),A0,L	;GET THE POINTER

	MOVE	@OFREE,A2,L				
	MOVE	A2,*A0,L
	MOVE	A0,@OFREE,L	;STICK THIS BLOCK AT THE HEAD OF THE LIST
	JRUC	BBWIPE1
BBWIPEX
	MMFM	SP,A0,A1,A2
	RETS

	
**************************************************************************
*                                                                        *
* SUPPLEMENTAL LIST ROUTINES						 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* MYOINIT - INITIALIZE SUPPLEMENTAL OBJECT LIST HEADERS			 *
*                                                                        *
**************************************************************************
MYOINIT
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST
	CALLA	CLRPAL
	MOVI	NARCS,A0
	CALLA	GETFPAL			;GET THE FIXED FOREGROUND PALETTE
	MOVE	A0,@CURPAL,W		;STUFF THIS HERE FOR FIXED STUFF
	MOVI	NARCS,A0
	CALLA	GETBPAL			;GET THE FIXED BACKGROUND PALETTE
	JRUC	MYOINITG
*
*MYOINITF - MYOINIT ONLY CLEARING THE FOREGROUND PALETTES
MYOINITF
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST
	CALLA	CLRFPAL
	MOVI	NARCS,A0
	CALLA	GETFPAL			;GET THE FIXED FOREGROUND PALETTE
	MOVE	A0,@CURPAL,W		;STUFF THIS HERE FOR FIXED STUFF
	JRUC	MYOINITG
*
*MYOINITF - MYOINIT ONLY CLEARING THE FOREGROUND PALETTES
MYOINITB
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST
	CALLA	CLRBPAL
	MOVI	NARCS,A0
	CALLA	GETBPAL			;GET THE FIXED BACKGROUND PALETTE
	MOVE	A0,@CURPAL,W		;STUFF THIS HERE FOR FIXED STUFF
MYOINITG
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0			;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST
	CALLR	SLSTINIT
	CLR	A0
	MOVE	A0,@PLAYERS,L
	MOVE	A0,@GAMERASE
	CALLA	AUTOEOFF		;DISABLE AUTOERASE
	CALLR	DMAWAIT			;WAIT ON DMA
	MOVI	ERASECOL,A1
	SLL	16,A1			;CONSTANT:PALETTE
	MOVI	[2,511],A2		;HEIGHT:WIDTH
	MOVI	[510,0],A3		;DAG
	MOVI	2000000H,A4		;SAG
	MOVI	DMAREGS,A0
	MMTM	A0,A1,A2,A3,A4		;STORE TO LAST 2 LINES OF BITMAP
	CLR	A5	 		;STUFF OFFSET
	MOVE	A5,-*A0,W
	MOVI	DMACAL,A5		;CONTROL &
	MOVE	A5,-*A0,W		;GO!
	MMFM	SP,A0,A1,A2,A3,A4,A5
	JAUC	OINIT


**************************************************************************
*                                                                        *
* SLSTINIT - SUPPLEMENTAL LIST INITIALIZER, THIS INITIALIZES ALL BUT	 *
* 	   THE PLAYER SUPPLEMENTAL LIST					 *
*                                                                        *
**************************************************************************
SLSTINIT
	PUSH	A0
	CLR	A0
	MOVE	A0,@BACKSLST,L
	MOVE	A0,@PLAYER_BULLETS,L
	MOVE	A0,@ENEMY_BULLETS,L
	MOVE	A0,@ENEMIES,L
	MOVE	A0,@PLAYERS,L
	MOVE	A0,@BOOTY,L
	MOVE	A0,@CARLIST,L
	MOVE	A0,@EXPLOSIONS,L
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* ADDSBOBJ - ADD OBJECT TO SUPPLEMENTAL BACKGROUND LIST			 *
* A0 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
ADDSBOBJ
	PUSH	A1
	MOVI	BACKSLST,A1
	CALLR	ADDSUPP
	PULL	A1
	RETS
**************************************************************************
*                                                                        *
* ADDSUPP - ADD OBJECT TO A SUPPLEMENTAL LIST				 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
*                                                                        *
**************************************************************************
ADDSUPP	
	MOVE	*A1(0),*A0(OSLINK),L	;LINK SLIST TO THIS BLOCK
	MOVE	A0,*A1,L		;NEW HEAD OF THE SLIST
	RETS

**************************************************************************
*                                                                        *
* DELSBOBJ - DELETE OBJECT FROM SUPPLEMENTAL BACKGROUND LIST		 *
* A0 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
DELSBOBJ
	PUSH	A1
	MOVI	BACKSLST,A1
	CALLR	DELSUPP
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* DELSUPP - DELETE OBJECT FROM THE SUPPLEMENTAL LIST			 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
*                                                                        *
**************************************************************************
DELSUPP
	MMTM	SP,A1,A2
	MOVE	A1,A2
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JRNZ	DELSCHK1

	CALLERR	2		;LOG THE ERROR
	JRUC	DELSX
***	JREQ	$		;ERROR
DELSCHK1
	CMP	A1,A0
	JRNE	DELSLUP
	MOVE	*A1(OSLINK),*A2(0),L	;LINK AROUND THIS GUY 	
DELSX
	MMFM 	SP,A1,A2
	RETS

DELSLUP
	MOVE	A1,A2       	;SAVE PREVIOUS
	MOVE	*A1(OSLINK),A1,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRNZ	DELSCHK2

	CALLERR	2		;LOG THE ERROR
	JRUC	DELSX
***	JREQ	$		;ELEMENT DOES NOT EXIST, HOLD FOR ERROR
DELSCHK2
	CMP	A1,A0
	JRNE	DELSLUP		;NOT FOUND KEEP LOOKING

	MOVE	*A1(OSLINK),*A2(OSLINK),L	;LINK AROUND THIS GUY 	

	MMFM 	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* ISSUPP - IS AN OBJECT ON A SUPPLEMENTAL LIST				 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*  Z BIT CLR = IS ON							 *
*                                                                        *
**************************************************************************
ISSUPP
	PUSH	A1
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JREQ	ISEND
	CMP	A1,A0
	JRNE	ISSEARCH
ISFOUND
	MOVE	A1,A1		;SET Z BIT
ISEND
	PULL	A1
	RETS
ISSEARCH
	MOVE	*A1(OSLINK),A1,L  	;SEARCHING FOR THE ELEMENT IN THE LIST
	JREQ	ISEND			;ELEMENT DOES NOT EXIST
	CMP	A1,A0
	JRNE	ISSEARCH		;NOT FOUND KEEP LOOKING
	JRUC	ISFOUND			;FOUND RETURN

**************************************************************************
*                                                                        *
* ISSUPPID - IS AN OBJECT ON A SUPPLEMENTAL LIST(SEARCH BY OBJECT I.D.)	 *
* A0 = OBJECT I.D.							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*	       A1 = ZERO						 *
*  Z BIT CLR = IS ON							 *
*	       A1 = PTR TO OBJECT					 *	 
*                                                                        *
**************************************************************************
ISSUPPID
	PUSH	A2	
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JREQ	ISENDID
	MOVE	*A1(OID),A2,W
	CMP	A2,A0
	JRNE	ISSRCHID
ISFNDID
	MOVE	A1,A1		;SET Z BIT
ISENDID
	PULL	A2
	RETS
ISSRCHID
	MOVE	*A1(OSLINK),A1,L  	;SEARCHING FOR THE ELEMENT IN THE LIST
	JREQ	ISENDID			;ELEMENT DOES NOT EXIST
	MOVE	*A1(OID),A2,W
	CMP	A2,A0
	JRNE	ISSRCHID		;NOT FOUND KEEP LOOKING
	JRUC	ISFNDID			;FOUND RETURN

**************************************************************************
*                                                                        *
* CNTSUPP - COUNT THE NUMBER OF OBJECTS ON GIVEN SUPPLEMENTAL LIST.	 *
* A1 = SUPPLEMENTAL LIST						 *
* RETURNS:								 *
* A0 = OBJECT CNT							 *
*                                                                        *
**************************************************************************
CNTSUPP
	PUSH	A1
	CLR	A0
	MOVE	*A1,A1,L
	JRZ	CNTSUPPX	
CNTSUPPL
	INC	A0
	CMPI	NOBJ,A0
	JRHS	CNTSUPPX		;WE'VE MAXED, SOMETHING IS WRONG
	MOVE	*A1(OSLINK),A1,L
	JRNZ	CNTSUPPL
CNTSUPPX	
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* RANDOM - GENERATE A RANDOM NUMBER					 *
* RETURNS:								 *
* A0 = 32 BIT RANDOM #							 *
*                                                                        *
**************************************************************************
RANDOM:	PUSH	A1
	MOVE	@RAND,A0,L
	SLA	1,A0
	JRV	RND2
	ORI	2,A0
RND2:	MOVE	A0,@RAND,L
	CLR	A1
	ADDC	A1,A0	;GET LAST BIT BACK TO MAKE 32
	MOVE	@HCOUNT,A1
	RL	A1,A0	;RANDOM ROTATION
	MOVE	A0,A0	;SET STATUS BITS
	MMFM	SP,A1
	RETS	

**************************************************************************
*                                                                        *
* RANDU - GENERATE A UNIFORMLY DISTRIBUTED RANDOM # BETWEEN 1 AND [A0]	 *
* A0 = RANGE INPUT							 *
* RETURNS:								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANDU:	PUSH	A1
	MOVE	A0,A1
	CALLR	RANDOM
	MPYU	A1,A0
	INC	A0
	MMFM	SP,A1
	RETS		
*
*GET SIGNED RANDOM # IN RANGE +/- A0
*CALLING PARAMETERS: A0
*RETURNS A0
*
SRAND:
	MMTM	SP,A1
	MOVE	A0,A1
	SLL	1,A0
	CALLA	RANDU
	SUB	A1,A0
	MMFM	SP,A1
	RETS
**************************************************************************
*                                                                        *
* RANGRAND - GENERATE A RANDOM NUMBER IN A GIVEN RANGE.			 *
* B0 = LOWER BOUND							 *
* B1 = UPPER BOUND							 *
* RETURNS								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANGRAND
	PUSH	A1
	PUSH	B1
	SUB	B0,B1		;NORMALIZE THE RANGE
	MOVE	B1,A0		;SET RANGE FOR RANDU
	CALLR	RANDU
	MOVE	B0,A1
	ADD	A1,A0
	PULL	B1
	PULL	A1
	RETS

*
*RANDPER - RANDOM % ROUTINE
*CALLING PARAMETERS:
*A0=PROBABILITY OF EVENT (0-1000) P(A0=1000) = 1; P(A0=1) = 1/1000.
*RETURNS CS IF PROBABILITY IS TRUE, CC FOR FALSE
*RETURNS A0 = ACTUAL RANDOM # 0-999
RANDPER:
	MMTM	SP,A1,A2
	MOVE	A0,A2
	CALLA	RANDOM
	MOVI	1000,A1
	MPYU	A1,A0
	CMP	A2,A0
	MMFM	SP,A1,A2
	RETS		

**************************************************************************
*                                                                        *
* FILLAREA - FILL A GIVEN SQUARE AREA ON THE SCREEN WITH A COLOR	 *
* A1 = [COLOR,PALETTE]							 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*                                                                        *
**************************************************************************
FILLAREA
	MMTM	SP,A1,A2,A4,A5
	JRUC	AREACON
**************************************************************************
*                                                                        *
* BLNKAREA - BLANK A GIVEN SQUARE AREA ON THE SCREEN			 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*                                                                        *
**************************************************************************
BLNKAREA
	MMTM	SP,A1,A2,A4,A5
	CLR	A1			;CONSTANT 0:PALETTE 0
AREACON
	MOVE	A4,A2
	MOVI	2000000H,A4		;SOMEWHERE IN IMAGE ROM
	MOVI	DMACAL,A5
	CALLR	DMAN
	MMFM	SP,A1,A2,A4,A5
	RETS

**************************************************************************
*                                                                        *
* LOADATAB - LOAD A ANIMATION LIST FROM MAIN ANIMATION TABLE		 *
* A0 = FRAME TYPE							 *
* A6 = MAIN ANIMATION TABLE						 *
* RETURN(S):								 *
* A11 = PTR TO HEAD OF ANIMATION LIST					 *
*                                                                        *
**************************************************************************
LOADATAB:
	MOVE	A6,-*SP,L
	CALLA	BASFRM	 	;OFFSET INTO LIST TABLE
	MOVE	*A6,A11,L	;POINT TO THE LIST
	MOVE	*SP+,A6,L
	RETS

**************************************************************************
*                                                                        *
* PFRAME - GET NEXT FRAME FROM ANIMATION LIST				 *
* A8 = POINTER TO OBJECT BLOCK						 *
* A11 = POINTER TO NEXT FRAME IN THE ANIMATION LIST			 *
* RETURN(S)								 *
* A5 = TICKS FOR THIS FRAME						 *
* C BIT SET(JxC)  = END OF LIST WAS HIT					 *
* N BIT SET(JxN)  = SPECIAL FRAME ENCOUNTERED				 *
*                                                                        *
**************************************************************************
PFRAME	MMTM	SP,A1,A4
	MOVE	*A11+,A1,L		;LOAD NEXT FRAME
	JRNE	PFRAME1			;NOT THE END OF THE LIST

	SETC	       			;SET CARRY FLAG
	JRUC	PFRAMEX

PFRAME1
	MOVE	*A8(OFLAGS),A4,W
	CALLA	ANI			;SETUP NEW FRAME
PFRAME2
	MOVE	*A11+,A5,W		;LOAD SLEEP TICKS PER FRAME
	CLRC	

PFRAMEX	MMFM	SP,A1,A4
	RETS

**************************************************************************
*                                                                        *
* BOUNDRY CHECK ROUTINES						 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* CKOUTOFX - CHECK THE OBJECT AGAINST UNIVERSE X START AND END		 *
* 		IF IT IS OUT OF RANGE. PUT IT IN BOUNDS 		 *
* A8 = OBJECT								 *
*                                                                        *
**************************************************************************
CKOUTOFX
	MMTM	SP,A1,A2,A3
	MOVE	*A8(OXPOS),A1,W
	JRNN	CKOXMAX
	CLR	A1		;IT'S LEFT OF UNIVERSE START
	MOVE	A1,*A8(OXPOS),W
	JRUC	CKOXXX
CKOXMAX
	MOVE	*A8(OSIZEX),A2,W
	SRL	1,A2
	ADD	A2,A1
	MOVE	@UNIVENDX,A3,W
	CMP	A3,A1
	JRLS	CKOXXX	
	SUB	A2,A3		;IT'S RIGHT OF UNIVERSE END
	MOVE	A3,*A8(OXPOS),W
CKOXXX
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* CKBOUNDS - CHECK OBJECT AGAINST BOUNDRIES. THE PROPER VELOCITY	 *
* 	   IS ZERO'D IF A BOUNDRY IS HIT.				 *
* A8 = OBJECT BLOCK PTR							 *
*                                                                        *
**************************************************************************
CKBOUNDS
	MMTM	SP,A1,A2,A3,A4
*DO X BOUNDRIES FIRST
	MOVE	*A8(OXPOS),A1,W
	MOVE	@WORLDTL,A2,W
	SUB	A2,A1			;ADJUST FOR WORLD COORDS

	MOVE	*A8(OXVEL),A2,L		;GET HIS VELOCITY
	JREQ	CKYBND			;BR = NOT MOVING, FORGET IT
	JRN	CKLBND			;BR = NEGATIVE, CHECK LEFT

	CMPI	PXMAX,A1		;TOO FAR RIGHT?
	JRLT	CKYBND			;BR = NO

	CALLR	PSTOPX			;ZERO HIS X VELOCITY
	JRUC	CKYBND

CKLBND	CMPI	PXMIN,A1		;TOO FAR LEFT?
	JRGT	CKYBND			;BR = NO
	CALLR	PSTOPX

*NOW CHECK THE Y BOUNDRIES
CKYBND
	MOVE	*A8(OZPOS),A1,W		;GET THE Z POSITION
	MOVE	@PLZMIN,A3,W
	MOVE	@PLZMAX,A4,W

	MOVE	*A8(OZVEL),A2,L
	JREQ	CKBNDX			;BR = NO VELOCITY, NO CHECK
	JRN	CKUBND			;BR = NEGATIVE, CHECK YMIN

	MOVE	*A8(OZPLUS),A2,W
	ADD	A2,A1
	CMP	A4,A1			;HIT ROCK BOTTOM?
	JRLT	CKBNDX			;BR = NO
	CALLR	PSTOPYZ			;ZERO Y VELOCITY
	JRUC	CKBNDX

CKUBND
	MOVE	*A8(OZMINUS),A2,W
	SUB	A2,A1
	CMP	A3,A1			;AT THE TOP?
	JRGT	CKBNDX			;BR = NO
	CALLR	PSTOPYZ

CKBNDX	MMFM	SP,A1,A2,A3,A4
	RETS

**************************************************************************
*                                                                        *
* CKZBOUND - CHECK OBJECT AGAINST IT'S CURRENT Z BOUNDRIES AND ZERO IF	 *
* 	   IT IS HIT							 *
* A8 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
CKZBOUND
	MMTM	SP,A1,A2,A3,A4
	MOVE	*A8(OZPOS),A1,W		;GET THE Z POSITION
	MOVE	@PLZMIN,A3,W
	MOVE	@PLZMAX,A4,W
	MOVE	*A8(OZVEL),A2,L
	JREQ	CKZBNDX			;BR = NO VELOCITY, NO CHECK
	JRN	CKUZBND			;BR = NEGATIVE, CHECK YMIN
	MOVE	*A8(OZPLUS),A2,W
	ADD	A2,A1
	CMP	A4,A1			;HIT ROCK BOTTOM?
	JRLT	CKZBNDX			;BR = NO
	CALLR	PSTOPZ			;ZERO Y VELOCITY
	JRUC	CKZBNDX
CKUZBND
	MOVE	*A8(OZMINUS),A2,W
	SUB	A2,A1
	CMP	A3,A1			;AT THE TOP?
	JRGT	CKZBNDX			;BR = NO
	CALLR	PSTOPZ
CKZBNDX
	MMFM	SP,A1,A2,A3,A4
	RETS

**************************************************************************
*                                                                        *
* CKZADJST - CHECK OBJECT AGAINST IT'S CURRENT Z BOUNDRIES,  	 	 *
* 	   IF A BOUNDRY IS HIT OR PASSED, ADJUST TO BOUNDRY		 *
* 	   AND ZERO VELOCITY						 *
* A8 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
CKZADJST
	MMTM	SP,A1,A3,A4,A5
	MOVE	*A8(OZPOS),A1,W		;GET THE Z POSITION
	MOVE	A1,A4
	MOVE	*A8(OYPOS),A5,W
	MOVE	@PLZMAX,A3,W
	SUB	A1,A3
	JRGT	CKUZADJ
	ABS	A3
	SUB	A3,A4
	SUB	A3,A5
	JRUC	CKZADJ1
CKUZADJ
	MOVE	@PLZMIN,A3,W
	SUB	A3,A1
	JRGT	CKZADJX
	ABS	A1
	ADD	A1,A4
	ADD	A1,A5
CKZADJ1
	CALLR	PSTOPZ
	MOVE	A4,*A8(OZPOS),W
	MOVE	A5,*A8(OYPOS),W
CKZADJX
	MMFM	SP,A1,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* CKZAMIN - CHECK OBJECT AGAINST THE CURRENT ZMIN BOUNDRY		 *
* 		ZERO VELOCITY AND ADJUST POSITION TO THAT 		 *
* 		BOUNDRY IF IT WAS EXCEEDED.				 *
* A8 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
CKZAMIN
	MMTM	SP,A1,A2,A3,A4,A5
	MOVE	*A8(OZPOS),A1,W		;GET THE Z POSITION
	MOVE	A1,A4
	MOVE	*A8(OYPOS),A5,W
	MOVE	*A8(OZVEL),A2,L
	JRNN	CKZAMINX		;BR = 0/PLUS VELOCITY, NO CHECK
	MOVE	*A8(OZMINUS),A2,W
	SUB	A2,A1
	MOVE	@PLZMIN,A3,W
	SUB	A3,A1
	JRGT	CKZAMINX
	ABS	A1
	ADD	A1,A4
	ADD	A1,A5
	CALLR	PSTOPZ
	MOVE	A4,*A8(OZPOS),W
	MOVE	A5,*A8(OYPOS),W
CKZAMINX
	MMFM	SP,A1,A2,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* OBJECT VELOCITY STOP ROUTINES						 *
*                                                                        *
**************************************************************************
*
*PSTOP - STOP AN OBJECT, A8:OBJECT BLOCK PTR
PSTOP	CALLR	PSTOPX
	JRUC	PSTOPYZ
*
*PSTOPX - CLEAR AN OBJECTS X VELOCITY, A8:OBJECT BLOCK PTR
PSTOPX	MMTM	SP,A0,A1	
	CLR	A1
	MOVE	A1,*A8(OXVEL),L
	MOVE	*A8(OSHAD),A0,L
	JREQ	PSTOPXX
	MOVE	A1,*A0(OXVEL),L		;STOP THE SHADOW
PSTOPXX
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* PSTOPZ - STOP AN OBJECTS Z VELOCITY ONLY				 *
* A8 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
PSTOPZ
	MMTM	SP,A1,A2,A3
	MOVE	*A8(OYVEL),A2,L
	MOVE	A2,A3			;KEEP HERE FOR SIGN COMPARISON
	MOVE	*A8(OZVEL),A1,L
	ABS	A1
	ABS	A2
	SUB	A1,A2
	MOVE	A3,A3			;SWITCH SIGNS?
	JRNN	PSTOPZN			;BR = NO
	NEG	A2
PSTOPZN
	CLR	A1
	MOVE	A1,*A8(OZVEL),L
	MOVE	A2,*A8(OYVEL),L
	MOVE	*A8(OSHAD),A3,L
	JREQ	PSTOPZNS
	MOVE	A1,*A3(OZVEL),L		;STOP THE SHADOW
	MOVE	A1,*A3(OYVEL),L
PSTOPZNS
	MMFM	SP,A1,A2,A3
	RETS

*PSTOPYZ - CLEAR AN OBJECTS(AND ITS SHADOW) Y & Z VELOCITY, A8:OBJECT BLOCK PTR
PSTOPYZ
	MMTM	SP,A0,A1
	CLR	A1
	MOVE	A1,*A8(OYVEL),L
	MOVE	A1,*A8(OZVEL),L
	MOVE	*A8(OSHAD),A0,L
	JREQ	PSTOPYZX
	MOVE	A1,*A0(OYVEL),L		;STOP THE SHADOW
	MOVE	A1,*A0(OZVEL),L		
PSTOPYZX
	MMFM	SP,A0,A1
	RETS

*
*YFLP - SET OBJECT Y-FLIP, A8:OBJECT BLOCK PTR
YFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ORI	M_FLIPH,A4
	JRUC	STUFLAGS
*
*NOYFLP - CLEAR OBJECT Y-FLIP, A8:OBJECT BLOCK PTR	
NOYFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ANDNI	M_FLIPH,A4
STUFLAGS
	MOVE	*A8(OIMG),A1,L		;GET THE CURRENT IMAGE POINTER
	CALLA	ANI			;SETUP THE "NEW" IMAGE
UNFLPD	MMFM	SP,A1,A4
	RETS

*
*SEE IF THE GUY WANTS TO FLIP LEFT OR RIGHT
PSWLR 	BTST	BPRYTE,A7		;SWITCHED TO RIGHT
	JRNE	NOYFLP			;NO
SWLF	BTST	BPLEFT,A7		;SWITCHED TO LEFT
	JRNE	YFLP			;NO
	RETS

**************************************************************************
*                                                                        *
* SYNCUP - SYNCHRONIZE WITH THE NEXT DISPLAY INTERRUPT, I.E.		 *
* 	 WAIT UNTIL THE NEXT INTERRUPT IS FINISHED BEFORE RETURNING	 *
*                                                                        *
**************************************************************************
SYNCUP	MOVE	A0,-*SP,L
	CLR	A0
	MOVE	A0,@INTSYNC0,L	;CLEAR HALF SCREEN SYNC

SYNCUP1	MOVE	@INTSYNC0,A0,L
	JREQ	SYNCUP1		;END HASN'T HIT YET
	MOVE	*SP+,A0,L
	RETS

**************************************************************************
*                                                                        *
* SYNCHALF - SYNCHRONIZE WITH THE HALF SCREEN INTERRUPT			 *
*                                                                        *
**************************************************************************
SYNCHALF
	MMTM	SP,A0,A1
	MOVI	INTSYNC0,A1
	JRUC	SYNCSD
**************************************************************************
*                                                                        *
* SYNCFULL - SYNCHRONIZE WITH THE FULL SCREEN INTERRUPT			 *
*                                                                        *
**************************************************************************
SYNCFULL
	MMTM	SP,A0,A1
	MOVI	INTSYNC1,A1

SYNCSD	CLR	A0
	MOVE	A0,*A1,W	;CLEAR HALF SCREEN SYNC

SYNCSD1	MOVE	*A1,A0,W
	JREQ	SYNCSD1		;END HASN'T HIT YET
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* DTIME - USED TO DMA AN IMAGE						 *
* A1 = [CONSTANT COLOR,PALETTE(STUFFED IN DTIME)]			 *
* A3 = DAG [Y,X]							 *
* A5 = [OFFSET,CONTROL]							 *
* A14 = ADDRESS OF IMAGE HEADER						 *
*                                                                        *
**************************************************************************
DTIME:
	MMTM	SP,A0,A1
	MOVE	*A14(ICMAP),A0,L	;GET THE PALETTE
	CALLA	FINDPAL			;GET THE CORRECT COLOR MAP #
	JRNZ	DTIME1			;BR = PALETTE WAS FOUND
	CLR	A0			;DEFAULT TO FIXED PALETTE
DTIME1
	MOVX	A0,A1
	CALLA	QDMA			;QUEUE THIS SUCKAH
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* DMAN - MANUAL DMA, ALL REGS MUST BE SETUP UPON CALLING		 *
*                                                                        *
**************************************************************************
DMAN	JAUC	QDMAN
**************************************************************************
*                                                                        *
* DMAWAIT - WAIT ON THE DMA BUSY BIT TO CLEAR				 *
*                                                                        *
**************************************************************************
DMAWAIT	
	PUSH	A0
DMAWAITL
	MOVE	@DMACTRL,A0,W	;DMA BUSY?
	JRN	DMAWAITL	;BR = YES
	PULL	A0
	RETS
**************************************************************************
*                                                                        *
* DMAQWAIT - WAIT FOR DMA QUEUES TO EMPTY, THEN WAIT FOR DMA TO FINISH	 *
* 	   THE LAST ONE.						 *
*                                                                        *
**************************************************************************
DMAQWAIT
	PUSH	A0
DMAQWT1
	MOVE	@TOPQ0CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@TOPQ1CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@BOTQ0CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@BOTQ1CNT,A0,W	
	JRNE	DMAQWT1
	PULL	A0
DMAQWT2
	MOVE	B13,B13
	JRZ	DMAWAIT
	JRUC	DMAQWT2
**************************************************************************
*                                                                        *
* DMAHALT - HALT THE DMA						 *
*                                                                        *
**************************************************************************
DMAHALT
	PUSH	A0
	CLR	A0
	MOVE	A0,@DMACTRL,W		;HALT THE DMA			 
	PULL	A0
	RETS
*
*CMAPRS - RESET THE COLOR MAP SELECT
CMAPRS	CLR	A0
*CMAPSL - SELECT THE COLOR MAP(0-15 IN A0)
CMAPSL	MOVE	A1,-*SP,L
	CALLA	DMAWAIT
	MOVE	A0,@CMAPSEL
	MOVE	*SP+,A1,L
	RETS

**************************************************************************
*                                                                        *
* CRINIT - COLOR RAM INITIALIZATION, FIRST CLEAR ALL COLOR RAM, THEN	 *
* 	 FILL WITH PALETTES.						 *
*                                                                        *
**************************************************************************
CRINIT
	MMTM	SP,A0,A1,A2,A6
	MOVI	COLRAM,A1
	CLR	A0
	MOVI	10000H,A6,L
*CLEAR ALL COLOR PALETTES
CRINIT1
	MOVE	A0,*A1+,L	;STUFF TWO WORDS AT A TIME
	DSJS	A6,CRINIT1

	MMFM	SP,A0,A1,A2,A6 ;<----
	RETS		       ;<----

**************************************************************************
*                                                                        *
* CRLOAD - LOAD COLOR RAM FROM A ROM TABLE				 *
* A1 = START OF ROM TABLE						 *
* A2 = COLOR RAM START ADDRESS						 *
* A6 = PALETTE COUNT							 *
*                                                                        *
**************************************************************************
CRLOAD
	MMTM	SP,A0,A1,A2
CRLOAD1
 	MOVE	*A1+,A0,W	;GRAB FIRST COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NULL PALETTE
CRLOAD3
	MOVE	A0,*A2,W	;STUFF COLOR
	MOVE	*A1+,A0,W	;GRAB NEXT COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NEXT PALETTE
	ADDK	16,A2		;INC THIS WAY SO WE DON'T OVERRUN PALETTES
	JRUC	CRLOAD3

CRLOAD4
	ADDI	1000H,A2	;NEXT PALETTE
	SRL	12,A2
	SLL	12,A2		;MASK OFF LOW BULLSHIT
	DSJ	A6,CRLOAD1

	MMFM	SP,A0,A1,A2
	RETS

*
*SCRCLR - CLEAR THE SCREEN WITH EUGENE
*ONLY CALL WITH INTERRUPTS DISABLED AND THE DMA SHUT DOWN, OTHERWISE
*	USE CLR_SCRN
SCRCLR	CLR	A0
*SCRFIL - FILL SCREEN WITH A0
SCRFIL:
	MMTM	SP,A1,A2
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	(SCRNE-SCREEN)/32,A2,L
SCRLP	MOVE	A0,*A1+,L
	DSJS	A2,SCRLP
	MMFM	SP,A1,A2
	RETS

*
*LAST2CLR - CLEAR LAST TWO LINES OF BIT MAP(I.E. SET AUTO ERASE COLOR)
LAST2CLR
	CLR	A0
*
*LAST2FIL - FILL LAST TWO LINES OF BIT MAP
*A0 = FILL COLOR
LAST2FIL
	MOVE	A0,@ERASELOC,W			;STUFF DA COLOR
	RETS
**************************************************************************
*                                                                        *
* SETPPROC - SETUP TI'S PIXEL PROCESSING REGISTER'S (BFILE), TO MATCH 	 *
* 	   THE ZUNIT SYSTEM.						 *
* NOTE:	   IF YOU WANT TO DO ANY SPECIAL TRICKS, DON'T USE THIS. 	 *
*                                                                        *
**************************************************************************
SETPPROC
	PUSH	A0
	MOVI	OFFSETVAL,B4	;Set up OFFSET register
	MOVI	0,B8		 	;Set background color
	MOVI	SCRN_PTCH,A0 		;Get Screen Pitch
	MOVE	A0,B1
	MOVE	A0,B3
	LMO	A0,A0			;Convert in temporary register
	MOVE	A0,@CONVSP		;Move to CONVSP io register
	MOVE	A0,@CONVDP		;Move to CONVDP io register
	PULL	A0
	RETS


************  CLEAR SCREEN ROUTINE  *********************
CLR_SCRN
clr_scrn:
	CLR	A0
	MMTM	SP,A1,A2,A3
	MOVE	@DISPLAYON,A3,W
	CLR	A1
	MOVE	A1,@DISPLAYON,W
	CALLR	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	((SCRNE-2000H)-SCREEN)/32,A2,L
CLRLP	MOVE	A0,*A1+,L
	DSJS	A2,CLRLP
	MOVE	A3,@DISPLAYON,W
	MMFM	SP,A1,A2,A3
	RETS

*	color to clear to stored in Lines 510 and 511
*****	MOVE	A13,-*SP,L	;STACK THIS
*****	PUSHST
*****	DINT
*****	CALLA	DMAWAIT		;WAIT FOR THE DMA TO BE DONE
*****
*****	MMTM	SP,B12,B13
*****	move	@convdp,b12
*****	MOVE	@DPYCTL,b13,0		;Copy display control reg.
*****	mmtm	sp,b13,b12,B4,B3
*****	move	b13,a13			; save in A file 
*****	movi	SCRN_PTCH*2,B3 	;Get Screen Pitch
*****	movi	>12,b12
*****	move	b12,@CONVDP		;Move to CONVDP io register
*****
****** Set SRT=1.  This converts pixel accesses to VRAM SR transfer cycles.
*****
*****	ANDNI	SRE+ENV,a13	     	;Turn off screen refresh
*****	ORI	SRT,a13		     	;Enable SR transfers
*****	MOVE	a13,@DPYCTL,0 		;Load new display control
*****	MOVE	@DPYCTL,a13,0 		;Read back to be safe!
*****
****** Load frame buffer for 1st line into VRAM shift registers.
*****
*****	CLR	B4		     	;Origin at start of memory
*****	movi	(255*Y),daddr			; zero line
*****	cvxyl	daddr,daddr
*****	PIXT	*DADDR,daddr		;Load VRAM shift registers
*****
****** Transfer contents of VRAM shift registers to rest of frame buffer.
*****
*****	clr	daddr
*****	MOVI	(1*X)+(200*Y),DYDX	;Set B7 = (1,200)
*****	FILL	 XY				;200 SR-to-memory transfers
*****
****** Restore previous contents of registers.
*****
*****	mmfm	sp,b13,b12,B4,B3
*****	move	b12,@convdp
*****   	MOVE 	b13,@DPYCTL,0		;Copy display control reg.
*****	MMFM	SP,B12,B13
*****	POPST
*****	MOVE	*SP+,A13,L		
*****	rets

**************************************************************************
*                                                                        *
* ENINIT - ENEMY DATA STRUCTURE AND OBJECT INITIALIZATION		 *
* 									 *
* A6  = PTR TO MAIN ANIMATION TABLE					 *
* A5  = WALKING YX VELOCITY, IF APPLICABLE				 *
* A13 = PTR TO PROC BLOC						 *
* A14 = PTR TO INIT TABLE						 *
* RETURN(S)								 *
* A0  = PTR TO OBJECT SHADOW						 *
* A8  = PTR TO OBJECT BLOCK						 *
* A9  = CLEARED FRAME PTR						 *
* A11 = CLEARED TEMP							 *
* A10 = ENEMY FLAGS							 *
* Z BIT CLR = EVERYTHING WENT FINE					 *
* Z BIT SET = OBJECT OR PALETTE CREATE ERROR				 *
* --------------------------------------------------------------------	 *
* ENEMY DATA STRUCTURE:							 *
* MNEM.	PBLOCK LOCATION	REGISTER	DESCRIP.			 *
* -----	---------------	--------	--------			 *
* ETEMP	 (PDATA) 	A11		TEMP STORAGE FOR SLEEPS		 *
* EFLAGS (PDATA+20H)	A10		FLAGS				 *
* EFRM	 (PDATA+40H)	A9		CURRENT FRAME(IF ANIMATING)	 *
* EOBJ	 (PDATA+60H)	A8		OBJECT BLOCK PTR		 *
* ESWTCH (PDATA+80H)	A7		[FRANIM COMMAND,SWITCH BITS]	 *
* EMAINT (PDATA+A0H)	A6		PTR TO MAIN ANIMATION TABLE	 *
* EYXVEL (PDATA+C0H)	A5		THIS TEMP. HOLDS MOVING YX VEL.	 *
*                                                                        *
**************************************************************************
*ENTRY POINT; A1  = INITIAL ENEMY POSITION [Y,X] UPPER LEFT IN WORLD COORDS
ENINITUL
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	MOVK	1,B0	
	CLR	B1
	JRUC	ENEMYINI
*ENTRY POINT; A1  = INITIAL ENEMY POSITION [Y,X] LOWER LEFT IN WORLD COORDS
ENINITLL
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	MOVI	-1,B0	
	CLR	B1
	JRUC	ENEMYINI
*ENTRY POINT; A1  = INITIAL ENEMY POSITION [Y,X] ANIMATION POINT IN WORLD COORDS
ENINIT
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	CLR	B0	
	CLR	B1
	JRUC	ENEMYINI
*ENTRY POINT(NO SHADOW); A1 = ENEMY POSITION [Y,X] UPPER LEFT
ESINITUL
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	MOVK	1,B0	
	MOVK	1,B1
	JRUC	ENEMYINI
*ENTRY POINT(NO SHADOW); A1 = ENEMY POSITION [Y,X] LOWER LEFT
ESINITLL
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	MOVI	-1,B0	
	MOVK	1,B1
	JRUC	ENEMYINI
*ENTRY POINT(NO SHADOW); A1  = ENEMY POSITION [Y,X] ANIMATION POINT
ESINIT
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	MMTM	SP,B0,B1
	CLR	B0	
	MOVK	1,B1
*ENEMYINI - MAIN ENTRY POINT FOR ENEMY INITIALIZATION
*A14 = ENEMY POSITION SPEC:
*	0 = [Y,X] POSITION OF ANIMATION POINT
*	1 = [Y,X] POSITION OF UPPER LEFT CORNER
*	2 = [Y,X] POSITION OF LOWER LEFT CORNER
ENEMYINI
*INITIALIZE PALETTE
	CALLA	GPALOBJ
	JRZ	ENINITX		;BR = FAILURE ON PALETTE CREATION
	MOVE	A0,A8		;PTR FOR INSERTION TO DATA BLOCK
	MOVE	A13,*A0(OPLINK),L	;LINK HOME

	CLR	A7		;FRANIM FRAME STEP : CLEAR SWITCHES
	CLR	A9		;CLEAR FRAME PTR
	CLR	A10		;CLEAR FLAGS
	CLR	A11		;CLEAR TEMP

	ADDI	EINIEND,A13
	CLR	A4		;CLEAR EBCNTRS
	MMTM	A13,A4,A5,A6,A7,A8,A9,A10,A11	;STUFF THE DATA BLOCK

*INITIALIZE THE ENEMYS OBJECT BLOCK
	CALLA	STFOBJ

	TEST	B0
	JREQ	ENEMYINR
	JRN	ENEMYILL
*CALLED WITH UPPER LEFT CORNER AS AN INITIAL POSITION
ENEMYIUL
	MOVE	A1,*A0(OXPOS),W		;SET INITIAL POSITION
	SRL	16,A1
	MOVE	A1,*A0(OYPOS),W
	JRUC	ENEMYIST
*CALLED WITH ANIMATION POINT AS A POSITION
ENEMYINR
	CLR	A2
	MOVY	A1,A2			;Y POSITION
	MOVX	A1,A3
	SLL	16,A3			;X POSITION
	MOVE	*A0(OFLAGS),A4,W	;SAME FLAGS
	CALLA	GANISAG			;ADJUST NEW POSITION
	JRUC	ENEMYIST
*CALLED	WITH LOWER LEFT CORNER AS AN INITIAL POSITION
ENEMYILL
	MOVE	A1,*A0(OXPOS),W		;X IS COOL
	MOVE	*A0(OSIZEY),A2,W	;GET THE IMAGE HEADER
	SRL	16,A1
	SUBXY	A2,A1			;MOVE TO THE Y TOP
	MOVE	A1,*A0(OYPOS),W

ENEMYIST
	CALLR	SETZPOS			;NOW SET THE Z POSITION
	CALLA	INSOBJ			;PUT THE OBJECT ON THE LIST	 
	MOVI	ENEMIES,A1
	CALLR	ADDSUPP
	MOVE	B1,B1
	JRNE	ENNOSH			;BR = DON'T CREATE THE SHADOW	
	CALLA	SHADST			;GIVE THIS GUY A SHADOW
ENNOSH
	TEST	A8			;CLEAR ZERO BIT
ENINITX
	MMFM	SP,B0,B1
	MMFM	SP,A1,A2,A3,A4,A5,A6,A7,A13
	RETS
**************************************************************************
*                                                                        *
* DOOR ROUTINES								 *
*                                                                        *
**************************************************************************
*
*GETDOOR - GET A BACKGROUND DOOR ON SCREEN
*A8 RETURNED WITH DOOR OBJECT POINTER
*EQ MEANS NO DOOR FOUND
*
GETDOOR:
	MMTM	SP,A0,A1
	MOVE	@BACKSLST,A8,L		;LOOK THROUGH THE BACKGROUND
	JREQ	GDFAIL			;NOBODY HOME
GDOORL0:
	MOVE	*A8(OID),A0,W		;CHECK THIS GUY
	MOVE	A0,A1
	SRL	4,A0
	SLL	4,A0			;WIPE OUT SPECIFIC I.D.
	CMPI	BGDCID,A0		;IS IT A DOOR
	JRNE	GDOORL
	SLL	28,A1
	SRL	28,A1
	CMPI	SAFEDRL,A1
	JREQ	GDOORL			;BR = SAFE DOORS, SPECIAL CASE THESE
	CMPI	SAFEDRR,A1
	JREQ	GDOORL			;BR = SAFE DOOR
	CMPI	SUBDOORL,A1
	JREQ	GDOORL			;BR = SUBWAY DOORS, SPECIAL CASE THESE
	CMPI	SUBDOORR,A1
	JREQ	GDOORL			;BR = SUBWAY DOOR
	CALLA	SCRTST
	JRNE	GDOORL			;DOOR NOT ON SCREEN
	MOVI	1,A0			;SET NE BIT
	JRUC	GOTDOOR
GDOORL:
	MOVE	*A8(OSLINK),A8,L	;LET'S SEARCH FOR A DOOR
	JRNE	GDOORL0
GOTDOOR:
GDFAIL:
	MMFM	SP,A0,A1
	RETS
*
*CLOZDOOR - PROCESS TO CLOSE THE DOOR
*A8=DOOR OBJECT
CLOZDOOR:
	SLEEP	40H
	JSRP	DOORCLOZ
	JAUC	SUCIDE

**************************************************************************
*                                                                        *
* DOORRITE - GET THE UPPER LEFT CORNER STARTING POSITION OF AN ENEMY	 *
* 	   SO THAT HE IS STANDING JUST TO THE RIGHT OF THE DOOR		 *
* A8 = PTR TO DOOR							 *
* A14= PTR TO ENEMY INIT TABLE						 *
* RETURNS:								 *
* A1 = [Y,X] UPPER LEFT STARTING POSITION				 *
*                                                                        *
**************************************************************************
DOORRITE
	PUSH	A2
	MOVE	*A8(ODMAXY),A1,L
	MOVE	*A8(OSIZE),A2,L
	ADDXY	A2,A1			
	SUBK	5,A1			;FUDGE FACTOR THE X POSITION
	MOVE	*A14(INITIMG),A2,L
	MOVE	*A2(ISIZEY),A2,W
	SLL	16,A2
	SUBXY	A2,A1			;THIS IS THE STARTING POSITION
	PULL	A2
	RETS
*
*OUTDOOR - OUT THE DOOR YOU GO
*A2=OXVEL, A8=OBJECT, A9=ANIMATION TABLE (FRANIM), A13=PROCESS
*RETURNS WHEN OBJECT IS OUT OF THE DOOR
*NOTE: CALL WITH JSRP
*
OUTDOOR:
	MOVE	A9,*A13(ETEMP6),L	;SAVE START FRAME
	MOVE	*A8(OXPOS),A10,W	;FLIP IN PLACE
	MOVE	*A8(OYPOS),A4,W
	CALLA	YFLP
	MOVE	A10,*A8(OXPOS),W
	MOVE	A4,*A8(OYPOS),W
	MOVE	A2,*A8(OXVEL),L		;GIVE HIM SOME VELOCITY
OUTDOOR1:
	MOVE	*A13(ETEMP6),A9,L	;GET START FRAME
OUTDOOR2:
	MOVE	*A8(OIMG),A1,L		;RESET SIZE TO AVOID CONFUSION
	MOVE	*A1(ISIZE),A2,W
	MOVE	A2,*A8(OSIZEX),W
	MOVK	4,A1	
	JSRP	FRANIM
	JRC	OUTDOOR1
	MOVE	A0,A11
OUTDOORL:
	MOVE	*A8(OIMG),A1,L		;RESET SIZE TO AVOID CONFUSION
	MOVE	*A8(OFLAGS),A4,W
	MOVE	*A1(ISIZE),A2,W
	MOVE	A2,*A8(OSIZEX),W
	XORI	M_NODIS,A4		;FAKE ANI INTO ANIMATING YOURSELF
	CALLA	ANI			;ANIMATE TO YOURSELF, RESETTING CLIP
	MOVE	*A1(ISIZE),A3,W
	MOVE	*A8(OXPOS),A2,W
	SUB	A10,A2
	ADD	A3,A2			;NO MORE REAL CLIP?
	JRLE	OUTDOORX			;DONE...
	CLR	A3
	CALLA	CLIPOBJ
	SLEEP	1
	DSJS	A11,OUTDOORL
	JRUC 	OUTDOOR2
OUTDOORX:
	RETP

**************************************************************************
*                                                                        *
* DOOROPEN - OPEN THE DOOR						 *
* A8 = OBLOCK OF DOOR							 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
DOOROPEN
	MMTM	A12,A9,A10
	MOVE	*A8(OID),A10,W
	SLL	28,A10
	SRL	28,A10			;KEEP DOOR I.D.
	MOVI	BGDOMID,A9
	ADD	A10,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS OPENING
	MOVI	DOOROSND,A0
	CALLA	ONESND

	MOVI	DOOROTAB,A9
	MOVE	A10,A0
	SLL	5,A0
	ADD	A0,A9
	MOVE	*A9,A9,L		;GET ANIMATION TABLE

	MOVK	1,A1
	JSRP	FRANIM
	MOVI	BGDOID,A9
	ADD	A10,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS OPEN
	MMFM	A12,A9,A10
	RETP
*
*TABLE OF DOOR OPEN ANIMATIONS
DOOROTAB
	.LONG	CHINAOP,ARMDROP,HOTWINOP,BIGDROP
	.LONG	CHINAOP,CHINAOP,CHINAOP,CHINAOP
	.LONG	CHINAOP,CHINAOP,CHINAOP,CHINAOP
	.LONG	CHINAOP,CHINAOP,CHINAOP,CHINAOP

**************************************************************************
*                                                                        *
* DOORCLOZ - CLOSE THE DOOR						 *
* A8 = OBLOCK OF DOOR							 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
DOORCLOZ
	MMTM	A12,A9,A10
	MOVE	*A8(OID),A10,W
	SLL	28,A10
	SRL	28,A10			;KEEP DOOR I.D.
	MOVI	BGDCMID,A9
	ADD	A10,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS OPENING

	MOVI	DOORCTAB,A9
	MOVE	A10,A0
	SLL	5,A0
	ADD	A0,A9
	MOVE	*A9,A9,L		;GET ANIMATION TABLE

	MOVK	1,A1
	JSRP	FRANIM
	MOVI	BGDCID,A9
	ADD	A10,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS OPEN
	MOVI	DOORCSND,A0
	CALLA	ONESND
	MMFM	A12,A9,A10
	RETP
*
*TABLE OF DOOR CLOSE ANIMATIONS
DOORCTAB
	.LONG	CHINACL,ARMDRCL,HOTWINCL,BIGDRCL

*CHINA DOOR ANIMATIONS
CHINAOP
	.LONG	CHINADR2
	.WORD	7
	.LONG	CHINADR3
	.WORD	7
	.LONG	0
CHINACL
	.LONG	CHINADR2
	.WORD	7
	.LONG	CHINADR1
	.WORD	7
	.LONG	0
*ARMOR DOOR ANIMATIONS
ARMDROP
	.LONG	ARMDR2
	.WORD	7
	.LONG	ARMDR3
	.WORD	7
	.LONG	0
ARMDRCL
	.LONG	ARMDR2
	.WORD	7
	.LONG	ARMDR1
	.WORD	7
	.LONG	0
*MR. BIG OFFICE DOOR ANIMATIONS
BIGDROP
	.LONG	BIGDOOR2
	.WORD	7
	.LONG	BIGDOOR3
	.WORD	7
	.LONG	0
BIGDRCL
	.LONG	BIGDOOR2
	.WORD	7
	.LONG	BIGDOOR1
	.WORD	7
	.LONG	0

*HOTEL WINDOW OPEN ANIMATIONS
HOTWINOP
	.LONG	HOTWIN1
	.WORD	7
	.LONG	0

HOTWINCL
	.LONG	HOTWIN1
	.WORD	7
	.LONG	0

**************************************************************************
*                                                                        *
* SLIDCLOZ - CLOZ THE SLIDING DOOR					 *
* A8 = OBLOCK OF DOOR							 *
* NOTE: CALL WITH JSRP, ALSO, DOOR SHOULD BE CLIPPED TO 1 PIXEL IN Y	 *
*                                                                        *
**************************************************************************
SLIDCLOZ
	PUSHP	A9
	MOVI	BGDCMID,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS CLOSING
	MOVE	*A8(OIMG),A9,L		;GET IMAGE HEADER
	MOVE	*A9(ISIZE+16),A9,W	;GET THE YSIZE
	DEC	A9
SLIDC1
	CLR	A2
	MOVI	0FFFF0000H,A3
	CALLA	CLIPOBJ			;CLIP ONE OFF THE TOP
	MOVE	*A8(OYPOS),A0,W		;GET THE CURRENT YPOS
	INC	A0			;AND MOVE UP
	MOVE	A0,*A8(OYPOS),W		
	SLEEP	1
	DSJS	A9,SLIDC1
	MOVI	BGDCID,A9
	MOVE	A9,*A8(OID),W		;MARK IT AS CLOSED
	MOVI	DOORCSND,A0	
	CALLA	ONESND
	PULLP	A9
	RETP

*
*GETCPLY - GET CLOSEST PLAYER
*CALLING PARAMS: A8=ENEMY OBJECT
*RETURNS: A0= CLOSEST PLAYER DATA STRUCT.
*
GETCPLY:
	MMTM	SP,A1,A2,A3,A4,A5
	MOVI	>FFFF,A1		;PLAYER 1 DISTANCE
	MOVI	>FFFF,A2		;PLAYER 2 DISTANCE
	MOVI	P1DATA,A0		;LOOKING FOR PLAYER 1
	MOVE	*A0(POBJ),A3,L		;GET PLAYERS OBJECT	
	JRZ	GETCP2			;ZERO INDICATES INACTIVE
	MOVE	*A8(OXPOS),A1,W		;FIND DELTA X PLAYER 1
	MOVE	*A3(OXPOS),A5,W
	SUB	A5,A1
	ABS	A1
	MOVE	*A8(OZPOS),A4,W		;FIND DELTA Z PLAYER 1
	MOVE	*A3(OZPOS),A5,W
	SUB	A5,A4			
	ABS	A4
	CMP	A1,A4			;FIND GREATEST DX OR DZ
	JRLS	GETCP2
	MOVE	A4,A1
GETCP2:
       	MOVI	P2DATA,A0	
	MOVE	*A0(POBJ),A3,L		;GET EXPECTED PLAYERS OBJECT	
	JRZ	GETCPX1			;INACTIVE, GO FOR #1
	MOVE	*A8(OXPOS),A2,W		;FIND DELTA X PLAYER 2
	MOVE	*A3(OXPOS),A5,W
	SUB	A5,A2
	ABS	A2
	MOVE	*A8(OZPOS),A4,W		;FIND DELTA Z PLAYER 2
	MOVE	*A3(OZPOS),A5,W
	SUB	A5,A4			
	ABS	A4
	CMP	A2,A4			;FIND GREATEST DX OR DZ
	JRLS	GETCP3
	MOVE	A4,A2
GETCP3:
	CMP	A1,A2			;WHICH IS CLOSER?
	JRLS	GETCPX
GETCPX1:
	MOVI	P1DATA,A0		;PLAYER 1 CLOSER
GETCPX:
	MMFM	SP,A1,A2,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* SELCTPLY - SELECT A PLAYER TO GO AFTER				 *
* RETURNS:								 *
* A11 = PTR TO PLAYER DATA BLOCK					 *
*                                                                        *
**************************************************************************
SELCTPLY
	MMTM	SP,A0,A1
	CALLA	RANDOM			;Random numbers always do me right
	JRN	SELCTP1			;50/50

	MOVI	P2DATA,A11		;MAKE HIM GO FOR PLAYER 2
	JRUC	SELCTPXX
SELCTP1
	MOVI	P1DATA,A11		;OR PLAYER 1
SELCTPXX
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* INPYRNG - IS THE ENEMY IN FIRING Y RANGE OF THE PLAYER.		 *
* A8 = PTR TO ENEMY OBLOCK						 *
* A11 = PTR TO PLAYER'S DATA BLOCK					 *
* RETURNS								 *
* CARRY SET = IN RANGE							 *
*                                                                        *
**************************************************************************
INPYRNG
	MMTM	SP,A0,A1,A2,A3
	MOVE	A11,A0
	CALLR	GETPBOTY		;GET PLAYERS FOOT POSITION
	MOVE	A1,A2
	MOVE	A2,A3
**************************************************************************
*                                                                        *
* 	SUBK	3,A2			;OPEN A Y BANDWIDTH		 *
*                                                                        *
**************************************************************************
	ADDK	7,A3			;SHOOT FOR THE GUT
	CALLA	GETBOTY			;GET LOFFY'S FOOT
	CALLR	CHKRANGE
	MMFM	SP,A0,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* INPXRNG - IS THE ENEMY IN A FIXED X RANGE OF THE PLAYER.		 *
* A8 = PTR TO ENEMY OBLOCK						 *
* A11 = PTR TO PLAYER'S DATA BLOCK					 *
* RETURNS								 *
* CARRY SET = IN RANGE							 *
*                                                                        *
**************************************************************************
INPXRNG
	MMTM	SP,A0,A1,A2,A3
	MOVE	A11,A0
	CALLR	GETPCENT		;GET PLAYERS CENTER POINT
	MOVX	A1,A2
	ZEXT	A2			;CLEAR TOP 16 BITS
	SUBI	60,A2	
	MOVX	A1,A3
	ZEXT	A3			;CLEAR Y
	ADDI	60,A3			;OPEN X BANDWIDTH
	MOVE	*A8(OXPOS),A1,W
	CALLR	CHKRANGE
	MMFM	SP,A0,A1,A2,A3
	RETS
**************************************************************************
*                                                                        *
* GPLAYERD - GET THE PLAYER DATA BLOCK PTR				 *
* A8 = PTR TO PLAYER OBJECT(TORSO OR LEG)				 *
* RETURNS:								 *
* A2 = PLINDX (0=WASN'T A PLAYER)					 *
*                                                                        *
**************************************************************************
GPLAYERD
	MOVE	*A8(OID),A2,W		;LOOK @ OBJECT I.D.
	CMPI	P1OID,A2
	JRNE	GPD1
	MOVI	P1DATA,A2		;LOAD PLAYER 1 PLINDX
	RETS
GPD1
	CMPI	P2OID,A2
	JRNE	GPD2
	MOVI	P2DATA,A2		;LOAD PLAYER 2 PLINDX
	RETS
GPD2
	CLR	A2
	RETS
**************************************************************************
*                                                                        *
* GETPBOTY - GET PLAYERS FOOT Y POSITION 				 *
* A0 = PTR TO PLAYER DATA BLOCK						 *
* RETURN(S)								 *
* A1 = BOTTOM Y OF CURRENT PLAYER IMAGE					 *
*                                                                        *
**************************************************************************
GETPBOTY
	MMTM	SP,A0,A8
	CALLR	GETPLYR			;GET AN ACTIVE PLAYER
	MOVE	*A0(PLOBJ),A8,L		;<---- RIP THE CHECKS OUT
	JRNE	GETPBY1	      		;BR = LEGS ARE ACTIVE
	MOVE	*A0(POBJ),A8,L
GETPBY1
	CALLA	GETBOTY			;GET THE PLAYERS BOTTOM Y
	MMFM	SP,A0,A8
	RETS

**************************************************************************
*                                                                        *
* FACEPLYR - MAKE SURE THE ENEMY FACES THE PLAYER 			 *
* 	   HE WANTS TO BLOW AWAY.					 *
* A0 = PTR TO SELECTED PLAYER DATA BLOCK				 *
* A8 = PTR TO ENEMY							 *
*                                                                        *
**************************************************************************
FACEPLYR
	MMTM	SP,A1,A2
	CALLR	GETPCENT		;GET THE PLAYER'S CENTER POINT
	MOVE	A1,A2
	SEXT	A2			;A2 = PLAYER X CENTER
	CALLR	GETCPNT
	SEXT	A1			;A1 = ENEMY X CENTER

	CMP	A2,A1			;COMPARE THE TWO
	JRGT	FACEP1

	CALLR	NOYFLP
	MMFM	SP,A1,A2
	RETS
FACEP1
	CALLR	YFLP
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* GETPLYR-TAKES THE POINTER TO A PLAYERS DATA BLOCK, IF THAT PLAYER      *
* 	  IS ACTIVE, THEN THAT POINTER IS RETURNED, OTHERWISE THE 	 *
* 	  POINTER TO THE OTHER PLAYER IS RETURNED.			 *
* A0 = PTR TO EXPECTED PLAYER DATA BLOCK				 *
* RETURN(S)								 *
* A0 = PLAYER CLOSEST ACTIVE PLAYER					 *
* NOTE: AT LEAST ONE PLAYER MUST BE ACTIVE WHEN CALLING THIS ROUTINE	 *
*                                                                        *
**************************************************************************
GETPLYR	MOVE	A8,-*SP,L
	MOVE	*A0(POBJ),A8,L		;GET EXPECTED PLAYERS OBJECT	
	JRNE	GETPLYX			;NON-ZERO INDICATES ACTIVE

	CMPI	P1DATA,A0		;LOOKING FOR PLAYER 1?
	JREQ	GETPLY2			;YES, GET PLAYER 2

	MOVI	P1DATA,A0		;OTHERWISE PLAYER ONE
	JRUC	GETPLYX

GETPLY2	MOVI	P2DATA,A0
GETPLYX	MOVE	*SP+,A8,L
	RETS

**************************************************************************
*                                                                        *
* CHKRANGE - CHECK TO SEE IF 32 BIT # IS IN A GIVEN RANGE (INCLUSIVE)	 *
* A1 = #								 *
* A2 = LOWER BOUND							 *
* A3 = UPPER BOUND							 *
* RETURN(S)								 *
* CARRY CLEAR (JxNC) = OUT OF RANGE					 *
* CARRY SET   (JxC)  = IN RANGE						 *
*                                                                        *
**************************************************************************
CHKRANGE
	CMP	A2,A1			;CHECK LOWER BOUND
	JRLT	OUTOFRNG		;BR = # TOO LOW
	CMP	A3,A1
	JRGT	OUTOFRNG		;BR = # TOO HIGH

	SETC				;# IN RANGE, YEAH!
	RETS
OUTOFRNG
	CLRC
	RETS

**************************************************************************
*                                                                        *
* GETPCENT - GET CENTER POINT OF PLAYERS IMAGE				 *
* A0 = PTR TO PLAYER DATA BLOCK						 *
* RETURN(S)								 *
* A1 = CENTERY:CENTERX							 *
*                                                                        *
**************************************************************************
GETPCENT
	MMTM	SP,A0,A2,A8
	CALLR	GETPLYR			;GET ACTIVE PLAYER

	MOVE	*A0(PLOBJ),A8,L		;<---- RIP THE CHECKS OUT
	JRNE	GETPCNT1      		;BR = LEGS ARE ACTIVE
	MOVE	*A0(POBJ),A8,L
GETPCNT1
	CALLA	GETBOTY			;GET THE PLAYERS BOTTOM Y

	MOVE	*A0(POBJ),A8,L

	MOVE	*A8(OYPOS),A0,W
	SUBXY	A0,A1
	SLL	16,A0
	MOVE	*A8(OXPOS),A2,W
	MOVX	A2,A0			;A0 = UL [Y,X]
	
	MOVE	*A8(OSIZE),A2,L
	SLL	16,A1
	MOVX	A2,A1			;A1 = [Y,X] SIZE

	CALLR	GETCENT
	SLL	16,A0
	MOVY	A0,A1

	MMFM	SP,A0,A2,A8
	RETS

**************************************************************************
*                                                                        *
* MOVEINPX - RETURNS THE CORRECT DIRECTION (L OR R) TO MOVE		 *
* 	   TO GET TO THE PLAYER IN X. RETURNED DIRECTION		 *
* 	   IS IN THE FORM OF JOYSTICK BITS				 *
* A0 = PTR TO PLAYER DATA BLOCK						 *
* A8 = PTR TO ATTACKING OBJECT						 *
* RETURN(S)								 *
* A1 = CORRECT JOYSTICK BITS						 *
*                                                                        *
**************************************************************************
MOVEINPX
	MMTM	SP,A0,A2
	CALLR	GETPCENT		;GET PLAYER'S CENTER	
	MOVX	A1,A2
	CALLA	GETCPNT			;GET ATTACKER'S CENTER
	CMPXY	A2,A1
	JRXLT	MOVERT			;MOVE RIGHT TO GET THERE

	MOVK	PLEFT,A1
	JRUC	MOVEINXX

MOVERT	MOVK	PRYTE,A1
MOVEINXX
	MMFM	SP,A0,A2
	RETS

**************************************************************************
*                                                                        *
* MVAWAYPX - RETURNS THE CORRECT DIRECTION (L OR R) TO MOVE		 *
* 	   TO GET AWAY FROM THE PLAYER IN X. RETURNED DIRECTION		 *
* 	   IS IN THE FORM OF JOYSTICK BITS				 *
* A0 = PTR TO PLAYER DATA BLOCK						 *
* A8 = PTR TO ATTACKING OBJECT						 *
* RETURN(S)								 *
* A1 = CORRECT JOYSTICK BITS						 *
*                                                                        *
**************************************************************************
MVAWAYPX
	MMTM	SP,A0,A2,A7,A14
	CALLR	GETPLYR			;A0 = GET THE PLAYER I'M AFTER
	MOVE	*A0(POBJ),A14,L		;A14 = PLAYER OBJECT BLOCK PTR
	CALLR	GETPCENT		;GET PLAYER'S CENTER	
	MOVX	A1,A2
	CALLA	GETCPNT			;GET ATTACKER'S CENTER

	MOVE	*A14(OXVEL),A7,L	;SEE WHICH WAY THIS CAT IS GOING
	JRGT	MVAWAYLT		;BR = MOVE TO THE LEFT TO GET AWAY
	JRN	MVAWAYRT		;BR = MOVE TO THE RIGHT TO GET AWAY

	CMPXY	A2,A1	    		;CHECK TO SEE WHICH SIDE OF THE P WE ARE ON
	JRXLT	MVAWAYLT		;MOVE LEFT TO GET AWAY QUICKEST

MVAWAYRT
	MOVK	PRYTE,A1
	JRUC	MVAWAYXX

MVAWAYLT
	MOVK	PLEFT,A1
MVAWAYXX
	MMFM	SP,A0,A2,A7,A14
	RETS

**************************************************************************
*                                                                        *
* MOVEINPY - RETURNS THE CORRECT DIRECTION (U OR D) TO MOVE		 *
* 	   TO GET TO THE PLAYER IN X. RETURNED DIRECTION		 *
* 	   IS IN THE FORM OF JOYSTICK BITS				 *
* A0 = PTR TO PLAYER DATA BLOCK						 *
* A8 = PTR TO ATTACKING OBJECT						 *
* RETURN(S)								 *
* A1 = CORRECT JOYSTICK BITS						 *
*                                                                        *
**************************************************************************
MOVEINPY
	MOVE	A2,-*SP,L
	CALLR	GETPBOTY 		;GET ACTIVE PLAYERS BOTTOM Y
	MOVE	A1,A2			
	CALLA	GETBOTY			;NOW THE ATTACKERS
	CMP 	A2,A1
	JRLT	MOVEDN			;MOVE DOWN TO GET THERE

	MOVK	PUP,A1
	JRUC	MOVEINYX
MOVEDN	MOVK	PDOWN,A1
MOVEINYX
	MOVE	*SP+,A2,L
	RETS

**************************************************************************
*                                                                        *
* ISPBULLT - CHECKS TO SEE IF AN OBJECT IS IN RANGE OF A PLAYERS BULLET	 *
* A0 = PLAYER DATA BLOCK						 *
* A8 = OBJECT TO CHECK							 *
* RETURN(S)								 *
* CARRY CLEAR (JxNC) = NO BULLET IN SIGHT				 *
* CARRY SET   (JxC)  = WATCH OUT BUDDY					 *
*                                                                        *
**************************************************************************
ISPBULLT
	MMTM	SP,A1,A2,A3,A4,A5,A6
	MOVE	*A0(POBJ),A4,L
	JREQ	NOPBULLT		;PLAYER NON-EXISTANT, NO BULLETS

	MOVI	OBJLST,A4		
	MOVE	*A8(OZPOS),A1,W		;GET OBJECTS ZPOS

	CMPI	P1DATA,A0		;CHECK AGAINST PLAYER 1?
	JRNE	ISP2B			;NO, PLAYER 2

	MOVI	B1OID,A5
	JRUC	ISPLSTC

ISP2B	MOVI	B2OID,A5

ISPLSTC	MOVE	*A4,A4,L		;GET NEXT OBJECT
	JREQ	NOPBULLT		;NO BULLETS FOUND

	MOVE	*A4(OID),A6,W		;GET THIS OBJECTS I.D.
	CMPXY	A5,A6
	JRXNE	ISPLSTC			;NOT A BULLET

	MOVE	*A4(OZPOS),A2,W		;GET BULLETS Z
	MOVE	A2,A3
	
	SUBK	10,A2
	ADDK	10,A3			;SET BANDWIDTH

	CALLR	CHKRANGE
	JRC	PBULLTX			;THIS BULLETS COM'N OUR WAY

	JRUC	ISPLSTC

NOPBULLT
	CLRC				;NO BULLETS

PBULLTX	MMFM	SP,A1,A2,A3,A4,A5,A6
	RETS
							  
**************************************************************************
*                                                                        *
* WHICHSID - FIND WHICH SIDE (LEFT OR RIGHT) OF THE OBJECT IN A8,	 *
* 	   OBJECT IN A0 EXISTS ON, BASED ON THE CENTER LINES.		 *
* A0 = OBJECT IN ?							 *
* A8 = OBJECT TO CHECK AGAINST						 *
* RETURNS:								 *
* CARRY SET = RIGHT OF OBJECT IN A8					 *
* CARRY CLR = LEFT OR ON TOP OF OBJECT IN A8				 *
*                                                                        *
**************************************************************************
WHICHSID
	MMTM	SP,A1,A2,A8
	CALLR	GETCPNT		;GET CENTER POINT OF A8 OBJECT
	CLR	A2
	MOVX	A1,A2
	MOVE	A0,A8
	CALLR	GETCPNT		;GET CENTER POINT OF A0 OBJECT
	ZEXT	A1
	CMP	A2,A1		
	JRHS	WHICHR
	CLRC
	MMFM	SP,A1,A2,A8
	RETS
WHICHR
	SETC	
	MMFM	SP,A1,A2,A8
	RETS

*
*CKBUST - CHECK FOR A BUST
*A8=OBJECT
*CARRY SET IF A BUST
*A6 RETURNED WITH PDATA OF BUSTING PLAYER
*
CKBUST:
	MMTM	SP,A0,A1,A2,A3,A4,A5
	MOVE	@GAMSTATE,A0,W	;GET RID OF THIS KLUDGE KUICKLY
	CMPI	INMSU,A0
	JRNE	CKBUSTOK
	CLRC
	CLR	A0
	JRUC	CKBSTX
CKBUSTOK
	MOVI	P1DATA,A0
***	CALLR	CKMAXBST	;SEE IF PLAYER 1 HAS MAXED OUT
***	JRNC	CKBST1		;BR = NO MORE BUSTS FOR THIS CAT
	CALLR   CKBSUB
	JRNC	CKBST1 		;NO BUST FOR PLAYER 1
	ADD	A2,A3		;SAVE TOTAL DELTA
	MMTM	SP,A0,A3	;CHECK WHO'S CLOSEST
	MOVI	P2DATA,A0
	CALLR   CKBSUB
	JRC	CKBST0
	MMFM	SP,A0,A3	;NO BUST PLAYER 2
	JRUC	CKBST00
CKBST0:
	ADD	A3,A2
	MMFM	SP,A0,A3
	CMP	A2,A3
	JRC	CKBSTX	 	;PLAYER 1 CLOSEST
	MOVI	P2DATA,A0	;PLAYER 2 CLOSEST
CKBST00:
	SETC
	JRUC	CKBSTX
CKBST1:
	MOVI	P2DATA,A0
***	CALLR	CKMAXBST
***	JRNC	CKBSTX		;NO MORE BUSTS CHIEF
	CALLR   CKBSUB
CKBSTX:
	MOVE	A0,A6
	MMFM	SP,A0,A1,A2,A3,A4,A5
	RETS
*
*CKBSUB - CHECK BUST SUBROUTINE
*CALLING PARAMETERS
*A0=PLAYER DATA AREA
*A8=ENEMY OBJECT
*RETURNS CARRY SET IF BUSTED, CARRY CLEAR IF NO BUST
*
CKBSUB:
	MOVE	*A0(POBJ),A1,L
	JREQ	CKBSX			;NO BUST, PLAYER NON-EXISTANT
	MOVE	*A0(PIRQFLAG),A2,W
	ANDI	MJUMP2|MDRIVER|MPASSEN,A2
	JRNE	CKBSX
	MOVE	*A0(PEXEFLAG),A2,W
	ANDI	MDHOLD|MDEAD,A2
	JRNE	CKBSX

	PUSH	A0
	MOVE	A1,A0
	MOVI	30,A5
	MOVI	24,A6
	CALLR	XZCHK			;CALC DX,DZ
	PULL	A0
	RETS
CKBSX
	CLRC
	RETS

PMAXBUST .EQU	50
**************************************************************************
*                                                                        *
* CKMAXBST - CHECK IF A PLAYER HAS ACHIEVED THE MAXIMUM ALLOWED BUSTS.	 *
* A0 = PTR TO PLAYER DATA AREA						 *
* RETURNS:								 *
* 	CARRY CLR = MAXED OUT						 *
* 	CARRY SET = O.K. TO BUST					 *
*                                                                        *
**************************************************************************
CKMAXBST
	PUSH	A1
	MOVE	*A0(PBUSTS),A1,W
	CMPI	PMAXBUST,A1
	JRLO	CKMAXOK
	CLRC
	PULL	A1
	RETS
CKMAXOK
	SETC
	PULL	A1
	RETS
*
*GBUST - GET BUSTED
*A9=BUST ANIMATION
*A8=ENEMY
*A2=PROBABILITY OF ESCAPE
*NOTE: CALL WITH JSRP
*
GBUST:
	MOVK	6,A0
	CALLA	RANDU		;GET A RANDOM SOUND
	DEC	A0
	SLL	5,A0		;ADJUST FOR TABLE LENGTH
	ADDI	BSTSNDTAB,A0
	MOVE	*A0,A0,L	;GET SOUND ADDRESS
	CALLA	ONESND

*MAKE NO SOUND ENTRY POINT
GBSTNSND:
	CALLA	PSTOP
	MOVE	A2,-*A12,W	;SAVE ESCAPE % ON PROCESS STACK
GBUSTL:
	CALLR	CKBUST
	JRNC	BUSTX		;NO LONGER BUSTED, RUN AWAY
	
	MOVE	A6,A0
	CALLR	CKMAXBST
	JRNC	BUSTX		;BR = MAXIMUM BUSTS, NO MORE

	MOVE	A6,A11		;A6 RETURNED WITH BUST PLAYER DATA PTR 
	CLR	A1
	JSRP	FRANIM
	JRC	GBUST1		;FINISHED GETTING BUSTED

	MOVE	*A12,A0,W     	;CHECK RANDOM ESCAPE %
	CALLA	RANDPER
	JRC	BUSTX

	MOVE	*A11(PFLAGS),A2,L	;SQUAT WALK?
	BTST	BSWALK,A2
	JREQ	GBUSTL			;NO

	MOVE	*A12,A0,W		;DOUBLE ESCAPE %
	CALLA	RANDPER
	JRC	BUSTX
	JRUC	GBUSTL

GBUST1:
	ADDK	>10,A12		;PULL CRUD OF STACK
	MOVI	DUMCOLL,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER NULL FOR NOW
	MOVE	A11,A10	

BSTRYAGN
	CREATE	INDPIDW,BUSTAMP		;STAMP OUT A BUST
	JRNE	BUSTMT			;BR = SUCCESSFUL CREATE
	SLOOP	1,BSTRYAGN
BUSTMT
	CALLR	DROPSTUF
	SETC				;HE IS TRULY DEAD
	RETP
BUSTX:
	ADDK	>10,A12		;PULL CRUD OF STACK
	CLRC	       		;HE IS FREE
	RETP
*
*BUST SOUND TABLE
*
BSTSNDTAB:
	.LONG	SPRDSND,SPRDSND,YBUSTSND,POLSND,FREZSND,YBUSTSND
POLSND	.WORD	>F400|SPEAKPRI,>1F,>8029,0	;"POLICE"
*
*DROPSTUF - DROP ALL YOUR STUFF
*A8=ENEMY OBJECT POINTER
*A13=ENEMY PROCESS POINTER
*
DROPSTUF:
	MMTM	SP,A0,A6,A1,A7
	MOVB	*A13(EBUCK),A6		;GET THE # OF BUCKS
	JREQ	DRPS1A2
DRPS1A1
	CREATE	0EAH,DROPBUCK		;CREATE A MONEY DROPPING
	DSJS	A6,DRPS1A1
DRPS1A2
	MOVB	*A13(EDRUG),A6		;GET THE # OF DRUGS
	JREQ	DRPS1A4
DRPS1A3
	CREATE	0EAH,DROPDRUG		;CREATE A DRUG DROPPING
	DSJS	A6,DRPS1A3
DRPS1A4
	MOVB	*A13(EROCK),A6		;GET THE # OF ROCKS
	JREQ	DRPS1A6
DRPS1A5
	CREATE	0EAH,DROPROCK		;CREATE A ROCKET BOMB DROPPING
	DSJS	A6,DRPS1A5
DRPS1A6
	MOVB	*A13(ECLIP),A6		;GET THE # OF CLIPS
	JREQ	DRPS1A8
DRPS1A7
	CREATE	0EAH,DROPCLIP		;CREATE A CLIP DROPPING
	DSJS	A6,DRPS1A7
DRPS1A8
	MMFM	SP,A0,A6,A1,A7
	RETS

**************************************************************************
*                                                                        *
* CARDCHEK - CHECK TO SEE IF ENEMY SHOULD DROP A CARD			 *
* A0 = ENEMY COUNTER - THIS ENEMY					 *
* A8 = PTR TO ENEMY OBJECT						 *
*                                                                        *
**************************************************************************
CARDCHEK
	MMTM	SP,A0,A1,A7,A9
	MOVE	A0,A0
	JRNZ	CARDCKX			;BR = THERE'S MORE LEFT
	MOVE	@CARDHOLD,A7,W		;GET THE CARD HOLDER I.D.
	MOVE	A7,A9
	SRL	4,A7			;STRIP CARD TYPE
	SLL	4,A7
	JRZ	CARDCKX			;NO HOLDER CURRENTLY
	MOVE	*A8(OID),A1,W
	SRL	4,A1
	SLL	4,A1
	CMP	A1,A7
	JRNE	CARDCKX			;NOT THE CORRECT ENEMY
	SLL	28,A9
	SRL	28,A9
	CREATE	0EAH,DROPCARD
	CLR	A7
	MOVE	A7,@CARDHOLD,W
CARDCKX
	MMFM	SP,A0,A1,A7,A9
	RETS

**************************************************************************
*                                                                        *
* WALKING ENEMY DIE PROCESS						 *
* A8=OBJECT PTR OF ENEMY						 *
* A9=XVEL OF KILLER				 			 *
* A10=YVEL OF KILLER							 *
* A11=OID OF KILLER							 *
* PDATA	    = UPPER LEFT X OF KILLER					 *
* PDATA+10H = UPPER LEFT Y OF KILLER					 *
* PDATA+20H = CURRENT X SIZE OF KILLER					 *
* PDATA+30H = CURRENT Y SIZE OF KILLER					 *
* PDATA+A0H = ADDRESS OF MAIN ANIMATION TABLE				 *
* PDATA+E0H = # OF CLIPS:# OF ROCKS:# OF BUCKS:# OF DRUGS		 *
* I.D. = $ED                                                             *
*                                                                        *
**************************************************************************
WENDIE
	CALLR	SCRKIL			;SCORE THE KILL								 

	MOVE	A11,A3		  	;COPY OF I.D.
	SLL	28,A3
	SRL	28,A3

	CMPI	ROCKETID,A3,W
	JREQ	WROCK			;DEATH BY ROCKET

	CMPI	EXPLODID,A3,W
	JREQ	WEXPD			;DEATH BY EXPLOSION

	MOVE	*A8(OXVEL+16),A0,W
	JRN	WEND1A			;BR = OBJECT HAD A NEGATIVE VELOCITY

	MOVE	A9,A9
	JRN	WEND1C			;BR = OBJECT HIT FROM FRONT

WEND1B	SRA	18,A9 			;OBJECT MOVING IS SAME DIRECTION
	SRA	2,A10			;DIVIDE VELS. BY 4
	JRUC	WEND1D

WEND1A	MOVE	A9,A9
	JRN	WEND1B

WEND1C	SRA	19,A9			;OBJECTS MOVING IN OPPOSITE DIREC.
	SRA	2,A10			;DIVIDE INTEGER VELS. BY 8

WEND1D
	MOVE	*A8(OXVEL+16),A0,W
	ADD	A9,A0
	MOVE	A0,*A8(OXVEL+16),W
;	MOVE	*A8(OYVEL),A0,L
;	add	A10,A0
;	MOVE	A0,*A8(OYVEL),L
;	MOVE	A10,*A8(OZVEL),L
	MOVE	*A8(OYVEL),A0,L
	MOVE	*A8(OZVEL),A1,L
	SUB	A1,A0
	MOVE	A0,*A8(OYVEL),L
	CLR	A1
	MOVE	A1,*A8(OZVEL),L

	MOVE	*A13(EMAINT),A6,L	;GET THE MAIN ANIMATION TABLE
	MOVK	DFRAME,A0						 
	CALLR	BASFRM							 

	SLL	5,A3
	ADD	A3,A6			;AND OFFSET INTO THE ANIMATION TABLE
	MOVE	*A6,A9,L		;FRAME TABLE L O A D E D

	CALLR	GRUNTRND		;MAKE A RANDOM GRUNT NOISE
	CALLR	DROPSTUF		;DROP THE BOOTY
			 	
WEND1F
	MOVE	*A8(OYVEL),A1,L
	MOVE	*A8(OZVEL),A0,L
	SUB	A0,A1
	JRN	WENFALL
	CALLA	DFRMGRND
	CMPI	5,A1
	JRGT	WENFALL

WEND1
	clr	A0
	move	A0,*A8(OYVEL),L
	MOVK	1,A1
	JSRP	FRANIM			;DO DEATH FRAMES
	jruc	WEND2
WENFALL
	clr	A10
WFLp
	move	A10,A10
	jrnz	SkAnim
	movk	4,A1			;* one frame, no sleepin
	PUSHP	A9
	jsrp	FRANIM
	PULLP	A2
	move	*A9,A1,L
	jrnz	LISTLEFT
	move	A2,A9			;KEEP LAST FRAME
;	movi	>FFFFFFFF,A0,L		;fall without any more FRANIM
LISTLEFT:
	move	A0,A10
SkAnim
	SLEEP	1
	dec	A10
	move	*A8(OYVEL),A0,L
	jrn	GOINGUP
	calla	DFRMGRND
	cmpi	5,A1
	jrlt	HitGRND
	move	*A8(OYVEL),A0,L
GOINGUP:
	addi	>8000,A0
	move	A0,*A8(OYVEL),L
	calla	UpdShadV
	jruc	WFLp
HitGRND:
	clr	A0
	move	A0,*A8(OYVEL),L
	CALLR	PSTOP							 
	move	A8,A0
	calla	SETZPOS
	CALLA	DELSHAD
	move	A10,A0
	jrz	SkSlp
	jrn	SkSlp
	calla	PRCSLP
SkSlp:
	MOVK	1,A1
	JSRP	FRANIM			;Finish DEATH FRAMES
WEND2
	CALLR	PSTOP							 
WEND3
	MOVE	A8,A0
	CALLA	SETZPOS
	CALLA	DELSHAD
	SLEEP	10
	MOVI	[1,1],A9
	CREATE	0DFh,ESINK		;CREATE THE DEADMAN SINK	 
	DIE				;AND ME									 

**************************************************************************
*                                                                        *
* WROCK - DEATH BY ROCKET						 *
* A3 = TYPE DESCRIPTOR OF THING THAT KILLED HIM				 *
* A8 = OBJECT BLOCK PTR OF ENEMY					 *
*                                                                        *
**************************************************************************
WROCK	CALLA	PSTOP							 

*PUT OUT THE INITIAL CREOSOTE FRAME
	MOVE	*A13(EMAINT),A6,L	;GET THE MAIN ANIMATION TABLE
	MOVK	DFRAME,A0						 
	CALLR	BASFRM							 

	SLL	5,A3			;DESCRIPTOR * 32
	ADD	A3,A6			;AND OFFSET INTO THE ANIMATION TABLE

	MOVE	*A6,A9,L		;GET THE FRAMES

	MOVE	@DEATHCNT,A0,W
	INC	A0
	MOVE	A0,@DEATHCNT,W		;BIG DEATH CNT INCREMENT

	MOVK	1,A1
	JSRP	FRANIM			;ANIMATE THIS

*SEND THE BODY PARTS FLYING

	MOVE	*A13(EMAINT),A6,L	;GET THE MAIN ANIMATION TABLE
	MOVK	FFRAME,A0						 
	CALLR	BASFRM							 

	ADJUST	ADJGORE
	JRNZ	PARTSKIP

	MOVE	@OVERLOAD,A0
	CMPI	3,A0
	JREQ	PARTSKIP		;SKIP DUE TO OVERLOAD

	MMTM	SP,A9,A10,A11

	CALLA	GETCPNT			;GET ENEMY'S CENTER
	MOVY	A1,A11
	MOVX	A1,A11			;SET UP STARTING POSITION

	MOVE	A11,A5			;SAVE CENTER POSITION 

	MOVI	TRAJEC,A7		;PROCESS FOR FRAGMENTS AND DOOR
	CLR	A1			;ZERO I.D.

	MOVE	*A8(OZPOS),A14,W
	MOVI	DMAWNZ,A0	
	SLL	16,A0
	MOVX	A14,A0			;A0 = [DMA FLAGS,ZPOS]
	MOVE	A0,B5			;CONSTANT THROUGHOUT FRAGMENT CREATION
	MOVI	DBOUNCE,A14		;SAME HERE		
	CLR	A10			;USE DEFAULT INIT TABLE
	CLR	B1			;NOW 2nd ANIMATION

	MOVE	*A6,A9,L
	JREQ	WROCKPX

PIECER1	MOVI	50,A0 			;RANDOMIZE POSITION & VELOCITY
	CALLA	RANDU
	BTST	0,A0
	JREQ	PIECER2			;SEND PART RIGHT
	NEG	A0  			;SEND PART LEFT
PIECER2
	ZEXT	A0			;BLOW OFF THE SIGN
	ADDXY	A0,A11			;ADD FOR NEW POSITION
	SEXT	A0			;RE-SIGN FOR DIVIDE

	SLL	12,A0			;DIVIDE VELOCITY
	JREQ	PIECER1  		;NO ZEROZ
	MOVE	A0,B4			;XVEL IS LOADED
	CALLR	GETYZVEL		;GET A RANDOM Y AND Z VELOCITY
	CALLR	MAKTPROC

	MOVE	A5,A11			;RESTORE CENTER
	ADDK	32,A6
	MOVE	*A6,A9,L
	JRNE	PIECER1
WROCKPX
	MMFM	SP,A9,A10,A11
PARTSKIP
	CALLR	DELENEMY
	JAUC	SUCIDE

**************************************************************************
*                                                                        *
* WEXPD - WALKING BAD GUY, DEATH BY EXPLOSION				 *
* A3 = TYPE DESCRIPTOR OF THING THAT KILLED HIM				 *
* A8 = OBJECT BLOCK PTR OF ENEMY					 *
* PDATA = UPPER LEFT [Y,X] OF KILLER					 *
* PDATA+20H = [Y,X] SIZE OF KILLER					 *
*                                                                        *
**************************************************************************
WEXPD	CALLR	PSTOP

	MOVE	*A13(PDATA),A0,L	;GET DMA XY POSITION OF KILLER
	MOVE	*A13(PDATA+20H),A1,L	;GET DMA XY SIZE OF KILLER

	CALLR	DROPSTUF		;DROP THE BOOTY

	CALLR	GETCENT

	MOVE	A1,A2			;KEEP CENTER OF KILLER
	CALLR	GETCPNT			;GET ENEMY'S CENTER

	MOVE	*A13(EMAINT),A6,L	;GET THE MAIN ANIMATION TABLE
	MOVK	DFRAME,A0						 
	CALLR	BASFRM							 
	SLL	5,A3			;DESCRIPTOR * 32
	ADD	A3,A6			;AND OFFSET INTO THE ANIMATION TABLE

	SEXT	A1			;JUST DEAL WITH X CENTER
	SUB	A2,A1			;A1 = ENEMY XCENT - KILLER XCENT
	MOVE	A1,A2
	MOVE	A2,A4
	ABS	A4
	CMPI	50,A4			;BURN 'EM DOWN IF YOU CAN
	JRLE	WEXSPIN			;HE'S CLOSE ENOUGH TO SPIN
	CALLR	DFRMGRND		;GET THE DISTANCE FROM THE GROUND
	CMPI	5,A1
	JRGT	WEXSPIN			;BR = HE'S IN THE AIR ALREADY
	SOUND1	FSIZZSND
	SRA	6,A2
	MOVE	A2,*A8(OXVEL+16),W
	move	A8,A0
	SUBK	32,A6			;GET BACK TO THE FLAMER FRAMES
	MOVE	*A6,A9,L
	MOVK	4,A1
	JSRP	FRANIM			;DO 1st FRAME so DFRMGRND is valid
	MOVE	*A6,A9,L
	JRUC	WEND1F			;JUST ANIMATE AND CRUISE
WEXSPIN
	MOVE	A2,A2
	JRNN	WEXPD1A			;BR = SPIN LIKE IT IS	

       	ADDK	32,A6			;OTHERWISE REVERSE SPIN IS REQUIRED

WEXPD1A	MOVE	*A6,A9,L		;FRAME TABLE L O A D E D

	SRA	5,A2			;DIVIDE
	MOVE	A2,*A8(OXVEL+16),W	;MAKE DCENTERS A VELOCITY

	CALLR	GETYZVEL		;GET A RANDOM Y & Z VELOCITY
	MOVE	A8,B0
	MOVE	B2,*B0(OZVEL),L
	MOVE	B3,*B0(OYVEL),L		;STUFF THE ILL GOTTEN BOOTY

	SOUND1	SIZZAIR			;SUPER SCREEEEEEEAM
	MOVE	@DEATHCNT,A0,W
	INC	A0
	MOVE	A0,@DEATHCNT,W		;INCREMENT THE DEATH

	MOVE	A9,*A13(PDATA+70H),L	;KEEP FOR MULTIPLE ANIMATIONS
	MOVK	3,A11

WEXPD1
	PUSHP	A11
	MOVK	4,A1
	JSRP	FRANIM
	JRC	WEXPD3			;THE END WAS HIT

WEXPDS
	SLEEP	1
	CALLR	CKZADJST
	MOVE	*A8(OYVEL),A3,L		;GET THE CURRENT Y VELOCITY
	JRLE	WEXPD1B			;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT

	CALLR	DFRMGRND		;DID HE HIT THE GROUND?
	JRLE	LEXPHIT			;BR = YES

WEXPD1B
	MOVE	*A8(OYVEL),A0,L		;DECREASE Y VELOCITY
	ADDI	GRAVITY,A0
	MOVE	A0,*A8(OYVEL),L

	DSJS	A11,WEXPDS		
	PULLP	A11
	JRUC	WEXPD1

WEXPD3	MOVE	*A13(PDATA+70H),A9,L	;POINT TO THE HEAD OF THE LIST
	PULLP	A11
	INC	A11			;INCREMENT SLEEP TIME
	JRUC	WEXPD1

LEXPHIT
	CALLR	PSTOP
	move	A8,A0
	calla	SETZPOS
	calla	SHADUPD

	clr	A7		;Do sizzle sound
	move	*A8(OID),A9,W
	sll	16,A9
	srl	20,A9
	cmpi	BUGEOID/16,A9
	jreq	BugBurn
	MOVI	LDEXP1,A9		;GET BURN FRAMES
	jruc	GotBurn
BugBurn:
	MOVI	BUGBURN,A9
	movk	1,A7		;don't sizzle bug
	CALLA	GETANIXY		;GET THE ANIMATION POINT
	MOVE	*A8(OFLAGS),A4,W					 
	ANDNI	M_FLIPV,A4		;NO UPSIDE-DOWN FIRES ALLOWED	 
	jruc	SkSizz
GotBurn:

	CALLA	GETANIXY		;GET THE ANIMATION POINT

	SUBI	[50H,0],A2		;OFFSET TO Y

	MOVE	*A8(OFLAGS),A4,W					 
	ANDNI	M_FLIPV,A4		;NO UPSIDE-DOWN FIRES ALLOWED	 

	BTST	B_FLIPH,A4
	JREQ	WEXPD4			;NON-CENTERED A-POINTS ARE A B-I-T-C-H

	SUBI	[30H,0],A3
	JRUC	WEXPD5

WEXPD4	ADDI	[30H,0],A3
WEXPD5

	move	A7,A7
	jrnz	SkSizz
	SOUND1	SIZZSND			;SIZZLE,SIZZLE, TOIL AND GRIZZLE
SkSizz:

	MOVE	A8,A0
	CALLA	GANISAG			;SHOW THE NEW ADJUSTMENTS
	CALLA	DELSHAD			;DELETE THE SHADOW

	MOVK	4,A1
	JSRP	FRANIM			;ANIMATE THE FIRST PART OF THE BURN
	JRC	WEND2
	MOVE	A0,A5
	MOVE	A8,A0
	CALLA	SETZPOS			;LAY ME DOWN TO BURN
;	MOVE	*A8(OZPOS),A0,W
;	SUBK	20,A0	       		;GET IT CLOSER TO THE GROUND
;	MOVE	A0,*A8(OZPOS),W
	SLEEPR	A5
	MOVK	1,A1
	JSRP	FRANIM			;ANIMATE THE REST S.V.P.
	JRUC	WEND2
	
*****************************************************************
ADDBUCKS:
;	A0 - Amount of $$ desired for enemy
;	A13 - Ptr to enemies proc block
;moves the minimum of money available and money requested
;from pool of available money to enemies ctr
	PUSH	A1
	move	@BUCKCNT,A1,W
	sub	A0,A1
	jrnn	EnufBuck
	add	A1,A0
	clr	A1
EnufBuck:
	move	A1,@BUCKCNT,W
	movb	*A13(EBUCK),A1
	add	A0,A1
	movb	A1,*A13(EBUCK)
	PULL	A1	
	rets
*****************************************************************

*****************************************************************
ADDDRUGS:
;	A0 - Amount of Drug desired for enemy
;	A13 - Ptr to enemies proc block
;moves the minimum of money available and money requested
;from pool of available money to enemies ctr
	PUSH	A1
	move	@DRUGCNT,A1,W
	sub	A0,A1
	jrnn	EnufDrug
	add	A1,A0
	clr	A1
EnufDrug:
	move	A1,@DRUGCNT,W
	movb	*A13(EDRUG),A1
	add	A0,A1
	movb	A1,*A13(EDRUG)
	PULL	A1	
	rets
*****************************************************************

*****************************************************************
ADDROCKS:
;	A0 - Amount of Rockets desired for enemy
;	A13 - Ptr to enemies proc block
;moves the minimum of money available and money requested
;from pool of available money to enemies ctr
	PUSH	A1
	move	@ROCKCNT,A1,W
	sub	A0,A1
	jrnn	EnufRock
	add	A1,A0
	clr	A1
EnufRock:
	move	A1,@ROCKCNT,W
	movb	*A13(EROCK),A1
	add	A0,A1
	movb	A1,*A13(EROCK)
	PULL	A1	
	rets
*****************************************************************

*****************************************************************
ADDCLIPS:
;	A0 - Amount of Clips desired for enemy
;	A13 - Ptr to enemies proc block
;moves the minimum of money available and money requested
;from pool of available money to enemies ctr
	PUSH	A1
	move	@CLIPCNT,A1,W
	sub	A0,A1
	jrnn	EnufClip
	add	A1,A0
	clr	A1
EnufClip:
	move	A1,@CLIPCNT,W
	movb	*A13(ECLIP),A1
	add	A0,A1
	movb	A1,*A13(ECLIP)
	PULL	A1	
	rets
*****************************************************************

*
*DELENEMY - DELETE YENEMY FROM THE OBJECT LIST AND ENEMIES LIST,
*		 ALSO DELETE THE SHADOW FROM THE OBJLST.
*A8 = PTR TO ENEMY OBLOCK
DELENEMY
	PUSH	A1
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELPAL
	CALLR	DELSUPP
	CALLA	DELSOBJ
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* GRUNTRND - MAKE A RANDOM GRUNT NOISE IN THE CORRECT SPEAKER.		 *
* A8 = PTR TO ENEMY OBJECT						 *
*                                                                        *
**************************************************************************
GRUNTRND
	MMTM	SP,A0,A1
	MOVK	5,A0
	CALLR	RANDU			;GET A # 1-3
	DEC	A0
	MOVI	GRUNTTAB,A1	
	SLL	5,A0
	ADD	A1,A0
	MOVE	*A0,A0,L		;GET DAT SOUND
	CALLA	ONESND			;MAKE SOUND ON THE CORRECT SIDE
	MMFM	SP,A0,A1
	RETS

GRUNTTAB .LONG	GRUNT1R,GRUNT2R,GRUNT3R,GRUNT4R,GRUNT5R
**************************************************************************
*                                                                        *
* GETLZVEL - GET A RANDOM LANDING POSITION, AND SET THE Z VELOCITY	 *
* 	   ACCORDING TO THE RELATIONSHIP OF THE LANDING POSITION	 *
* 	   TO THE BOTTOM Y OF THE OBJECT.				 *
* A8 = PTR TO OBJECT BLOCK						 *
* RETURNS								 *
* A10 = LANDING Y LINE (16 BITS)					 *
*                                                                        *
**************************************************************************
GETLZVEL
	PUSH	A1
	CALLR	GETLAND
	CALLR	GETBOTY
	CMP	A10,A1
	JREQ	GETLZX			;BR = LAND RIGHT HERE BUDDY
	JRGT	GETLNZ			;BR = NEGATIVE Z VELOCITY
	MOVk	1,A1
	JRUC	GETLZIN
GETLNZ	MOVI	-1,A1
GETLZIN
	MOVE	A1,*A8(OZVEL+16),W
GETLZX
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* GETYZVEL - GET A RANDOM UPWARD Y VELOCITY, THEN A RANDOM Z VELOCITY	 *
* 	   THAT WILL KEEP THE OBJECT IN THE PLAYFIELD AREA ALONG	 *
* 	   ITS TRAJECTORY.						 *
* A8 = PTR TO OBJECT BLOCK						 *
* RETURNS								 *
* B2 = Z VELOCITY (32 BITS)						 *
* B3 = Y VELOCITY (32 BITS)						 *
*                                                                        *
**************************************************************************
GETYZVEL
	MMTM	SP,A0,A1,A3,A4,A5
	MMTM	SP,B0,B1

	MOVI	040000H,B0
	MOVI	0A0000H,B1
        CALLR	RANGRAND		;GET A RANDOM # BETWEEN 11 & 16
	MOVE	A0,B3
	NEG	B3			;-YVEL IS UP

	MOVE	A0,A1			;NEED THIS HERE FOR 32 BIT DIVIDE

	SRL	1,A0
	GETST	A5			;SAVE THE STATUS

	MOVI	GRAVITY/2,A0
	DIVU	A0,A1			;A1 = YDURATION			

	BTST	30,A5	
	JRNE	GETZVPL			;BR = WE WANT A POSITIVE Z VEL.

	MOVE	*A8(OZVAL),A3,L
GETZDMIN
	MOVE	@PLZMIN,A4,W		;SET UP FOR NEGATIVE Z VEL
	SLL	16,A4
	CMP	A4,A3
	JRGT	GETZABV
	MOVE	A3,A4
	JRUC	GETZDPL	
GETZVPL
	MOVE	*A8(OZVAL),A4,L
GETZDPL
	MOVE	@PLZMAX,A3,W		;SET UP FOR POSITIVE Z VEL
	SLL	16,A3
	CMP	A3,A4
	JRLT	GETZABV
	MOVE	A4,A3
	JRUC	GETZDMIN
GETZABV
	SUB	A4,A3			;A3 = Z DISTANCE
	
	DIVU	A1,A3			;A3 = MAX Z VELOCITY
	MOVE	A3,B1			
	INC	B1			;MAKE SURE THIS RANGE IS NOT ZERO
	MOVI	0800H,B0		;MIN Z VELOCITY IS A CONSTANT
	ADD	B0,B1			;INSURE POSITIVE RANGE
	CALLR	RANGRAND		;GET A VELOCITY
	MOVE	A0,B2

	BTST	30,A5
	JRNE	GETYZX	

	NEG	B2			;OH, MAKE IT NEGATIVE
GETYZX
	MMFM	SP,B0,B1
	MMFM	SP,A0,A1,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* GETLAND - GET A RANDOM LANDING POSITION. 				 *
*									 *
* RETURNS								 *
* A10 = LANDING Y LINE (16 BITS)					 *	 *
*                                                                        *
**************************************************************************
GETLAND
	PUSH	A0
	MMTM	SP,B0,B1
	MOVE	@PLYMIN,B0,W			;LOWER BOUNDRY
	MOVE	@PLYMAX,B1,W			;UPPER BOUNDRY
	CALLR	RANGRAND
	MOVE	A0,A10
	MMFM	SP,B0,B1
	PULL	A0
	RETS


**************************************************************************
*                                                                        *
* GCUBEVEL - GET VELOCITIES FROM COLLIDING WITH A CUBE.			 *
* A8 = PTR TO OBJECT THAT HIT THE BIG CUBE				 *
* A10 = PTR TO OBJECT THAT MAKES THIS CUBE				 *
* RETURNS:								 *
* A1 = 32 BIT XVEL							 *
* A2 = 32 BIT YVEL							 *
* A3 = 32 BIT ZVEL							 *
*                                                                        *
**************************************************************************
GCUBEVEL
	PUSH	A0
	MMTM	SP,B0,B1
	MOVE	*A10(OXPOS),A0,W
	MOVE	*A10(OSIZEX),A1,W
	ADD	A0,A1
	MOVE	*A8(OXPOS),A2,W
	MOVE	*A8(OSIZEX),A3,W
	ADD	A2,A3
	CLR	B0
	CMP	A0,A2
	JRLO	GCUBEV00		;BR = HIT OBJECT IS BEHIND
       	CMP	A1,A3
	JRHI	GCUBEV01		;BR = HIT OBJECT IS AHEAD
	MOVI	08000H,B1
	MOVE	*A10(OXVEL),A2,L
	JRUC	GCUBEV2
GCUBEV00
	MOVE	*A10(OXVEL),A2,L
	JRNN	GCUBEV20		;BR = NO FUNKY BOUNCE
	JRUC	GCUBEV1
GCUBEV01
	MOVE	*A10(OXVEL),A2,L
	JRN	GCUBEV20		;BR = AGAIN, NO FUNKY BOUNCE	
GCUBEV1
	MOVI	18000H,B1
GCUBEV2
	CALLA	RANGRAND
	MOVE	A0,A1
	SRA	1,A2
	JRGT	GCUBEV3
	JRLT	GCUBEV2A
GCUBEV20
	CLR	A1
	JRUC	GCUBEV4
GCUBEV2A
	NEG	A1
GCUBEV3
	ADD	A2,A1			;BR = X VELOCITY IS LOADED
GCUBEV4
	MOVE	*A10(OYVEL),A3,L	;THIS WILL BE THE Y BASE
	ABS	A3
	MOVE	A1,A2
	ABS	A2	
	ADD	A3,A2
	NEG	A2			;THIS IS THE Y VELOCITY
	JRNZ	GCUBEV5
       	CLR	A3			;IF THERE'S NO Y, THERE'S NO Z
	JRUC	GCUBEV6
GCUBEV5
	CALLA	GETZMID			;GET MIDPOINT OF OBJECT
	MOVE	A0,A3
	SWAP	A10,A8
	CALLA	GETZMID			;GET MIDPOINT OF CUBE
	SWAP	A10,A8
	SUB	A0,A3			;DIFFERENCE IN Z CENTERS
	SRA	4,A3			;THIS IS THE Z VELOCITY	
GCUBEV6
	MMFM	SP,B0,B1	
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* GIBOX - GET THE INTERSECTION BOX OF TWO OBJECTS. OBJECTS MUST		 *
* 	BE INTERSECTING IF THIS ROUTINE IS CALLED.			 *
* A0 = PTR TO OBJECT 0							 *
* A8 = PTR TO OBJECT 1							 *
* RETURNS								 *
* A1 = [ULY,ULX]							 *
* A2 = [LRY,LRX]							 *
*                                                                        *
**************************************************************************
GIBOX
	MMTM	SP,A3,A4,A5
	MOVE	*A0(OXPOS),A1,W
	MOVE	*A8(OXPOS),A2,W
	ZEXT	A1
	ZEXT	A2
	CALLR	MAXIMUM
	MOVX	A3,A4
	MOVE	*A0(OSIZEX),A3,W
	ADD	A3,A1
	MOVE	*A8(OSIZEX),A3,W
	ADD	A3,A2
	CALLR	MINIMUM
	MOVX	A3,A5
	MOVE	*A0(OYPOS),A1,W
	MOVE	*A8(OYPOS),A2,W
	ZEXT	A1
	ZEXT	A2
	CALLR	MAXIMUM
	SLL	16,A3
	MOVY	A3,A4
	MOVE	*A0(OSIZEY),A3,W
	ADD	A3,A1
	MOVE	*A8(OSIZEY),A3,W
	ADD	A3,A2
	CALLR	MINIMUM
	SLL	16,A3
	MOVY	A3,A5
	MOVE	A4,A1
	MOVE	A5,A2
	MMFM	SP,A3,A4,A5
	RETS

**************************************************************************
*                                                                        *
* MAXIMUM - RETURNS THE UNSIGNED MAXIMUM OF TWO 32 BIT #'S		 *
* A1 = #								 *
* A2 = #								 *
* RETURNS								 *
* A3 = MAX								 *
*                                                                        *
**************************************************************************
MAXIMUM
	CMP	A1,A2
	JRHI	MAXI1
	MOVE	A1,A3
	RETS
MAXI1
	MOVE	A2,A3
	RETS
**************************************************************************
*                                                                        *
* MINIMUM - RETURNS THE UNSIGNED MINIMUM OF TWO 32 BIT #'S		 *
* A1 = #								 *
* A2 = #								 *
* RETURNS								 *
* A3 = MIN								 *
*                                                                        *
**************************************************************************
MINIMUM
	CMP	A1,A2
	JRLO	MINI1
	MOVE	A1,A3
	RETS
MINI1
	MOVE	A2,A3
	RETS

**************************************************************************
*                                                                        *
* MAKTPROC - MAKE THE TRAJECTORY PROCESS, OR ANY WITH THE SAME PARAMS.	 *
* A1 = ID OF PROCESS TO CREATE (16 BITS)				 *
* A7 = ADDRESS OF PROCESS TO CREATE  					 *
* A9 = INITIAL ANIMATION LIST						 *
* A10 = PTR TO OBJECT INITIALIZATION TABLE(IF = 0 THEN DEFAULT IS USED	 *
* A11 = INITIAL YPOS:XPOS						 *
* A14 = PROCESS TO CREATE UPON DEATH					 *
* B1 = 2nd ANIMATION SCRIPT						 *
* B2 = ZVEL								 *
* B3 = YVEL								 *
* B4 = XVEL								 *
* B5 = [DMA FLAGS,ZPOS]							 *
* RETURN(S)								 *
* Z BIT CLR = ACCOMPLISHED						 *
* 	      A0 = PROCESS CREATED					 *
* Z BIT SET = FAILURE							 *
*                                                                        *
**************************************************************************
MAKTPROC
	CALLA	GETPRC			;GET A PROCESS
	JRZ	MAKTPRX			;BR = PROC FAIL
	PUSH	B0
	MOVE	A14,*A0(PDATA+0A0H),L
	MOVE	A0,B0
	ADDI	PDATA+0A0H,B0
	MMTM	B0,B1,B2,B3,B4,B5
	PULL	B0
	MOVE	A0,A0
MAKTPRX
	RETS

*TRAJECTORY PROCESS DEFAULT INITABLE
TRAJINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	BGDTHF5,0,DUMCOLL
	.WORD	DMAWNZ,0
    	.LONG	0
**************************************************************************
*                                                                        *
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
*                                                                        *
**************************************************************************
TRAJEC
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
TRAJEC1
	MOVE	A9,*A13(PDATA+0C0H),L	;KEEP FOR MULTIPLE ANIMATIONS
	MOVK	1,A11

TRAJW1
	PUSHP	A11
	MOVK	4,A1
	JSRP	FRANIM
	JRC	TRAJW3			;THE END WAS HIT

TRAJWS
	SLEEP	1

	CALLA 	CKZADJST

	MOVE	*A8(OYVEL),A3,L		;GET THE CURRENT Y VELOCITY
	JRLE	TRAJW1B			;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT

	CALLR	DFRMGRND		;DID HE HIT THE GROUND?
	JRLE	TRAJEND			;BR = YES

TRAJW1B
	MOVE	*A8(OYVEL),A0,L		;DECREASE Y VELOCITY
	ADDI	GRAVITY,A0
	MOVE	A0,*A8(OYVEL),L

	DSJS	A11,TRAJWS		
	PULLP	A11
	JRUC	TRAJW1

TRAJW3
	MOVE	*A13(PDATA+0C0H),A9,L	;POINT TO THE HEAD OF THE LIST
	PULLP	A11
	INC	A11			;INCREMENT SLEEP TIME
	JRUC	TRAJW1

TRAJEND
***	CALLR	PSTOP
	CALLA	GETANIXY		;GET THE ANIMATION POINT
	MOVE	*A8(OFLAGS),A4,W					 
	ANDNI	M_FLIPV,A4		;NO UPSIDE-DOWNERS ALLOWED	 

	MOVE	A8,A0
	CALLA	GANISAG			;SHOW THE NEW ADJUSTMENTS
***	CALLR	SETZPOS			;RESET THE Z POSITION		 
***	CALLA	DELSHAD			;DELETE THE SHADOW

	PUSHP	A9
	MOVE	*A13(PDATA+80H),A9,L	;GET THE SECOND ANIMATION LIST
	JREQ	TRAJE1			;NON-EXISTANT

	CALLR	PSTOP
	MOVE	A8,A0
	CALLR	SETZPOS			;RESET THE Z POSITION		 
	CALLA	DELSHAD			;DELETE THE SHADOW
	CALLA 	CKZADJST		;MAKE SURE IT IS IN BOUNDS

	MOVK	1,A1
	JSRP	FRANIM			;ANIMATE FROM TOP TO BOTTOM

TRAJE1
	PULLP	A9
	MOVE	*A13(PDATA+0A0H),A7,L	;PROCESS TO CREATE TO HANDLE DELETION
	JREQ	TRAJE2			;NOBODY HOME

	JUMP	A7			;SO JUMP THERE			

TRAJE2	MOVE	A8,A0 			;DEFAULT SIMPLE DELETE
	CALLA	DELPAL
	CALLA	DELSOBJ
	DIE

**************************************************************************
*                                                                        *
* DBOUNCE - BOUNCE AN OBJECT A COUPLE FEW TIMES THEN SINK IT		 *
* A8 = PTR TO OBLOCK							 *
* A9 = PTR TO CURRENT ANIMATION FRAME					 *
* A11 = CURRENT SLEEP TICKS						 *
* PDATA+0C0H = PTR TO ANIMATION LIST					 *
*                                                                        *
**************************************************************************
DBOUNCE
	MOVE	*A8(OYVEL),A0,L
	SRA	2,A0
	CMPI	[1,0],A0
	JRLT	DBHIT1
	NEG	A0
	MOVE	*A8(OXVEL),A1,L
	SRA	1,A1	       		;HALVE THESE GUYS
	MOVE	A1,*A8(OXVEL),L
	MOVE	*A8(OZVEL),A1,L
	SRA	1,A1
	MOVE	A1,*A8(OZVEL),L
	CALLA	SHVELCPY
	MOVE	A0,*A8(OYVEL),L
DBNCE1
	PUSHP	A11
	MOVK	4,A1
	JSRP	FRANIM
	JRC	DBNCE3			;THE END WAS HIT
DBNCE1A
	SLEEP	1
	CALLA	CKZADJST
	MOVE	*A8(OYVEL),A3,L	;GET THE CURRENT Y VELOCITY
	JRLE	DBNCE2		;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT
	CALLR	DFRMGRND	;DID HE HIT THE GROUND?
	JRLE	DBOUNCE		;BR = YES
DBNCE2
	MOVE	*A8(OYVEL),A0,L		;DECREASE Y VELOCITY
	ADDI	GRAVITY,A0
	MOVE	A0,*A8(OYVEL),L
	DSJS	A11,DBNCE1A		
	PULLP	A11
	JRUC	DBNCE1
DBNCE3
	MOVE	*A13(PDATA+0C0H),A9,L	;POINT TO THE HEAD OF THE LIST
	PULLP	A11
	JRUC	DBNCE1
DBHIT1
	CALLA	PSTOP			;STOP THE SUCKER   
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	CALLA	DELSHAD			;RESET SHADOW
	JRUC	DSINK

**************************************************************************
*                                                                        *
* DTBOUNCE - BOUNCE A TIRE OBJECT THEN ROLL IT OFF OF THE SCREEN	 *
* A8 = PTR TO TIRE OBLOCK						 *
* PDATA+0C0H = PTR TO HEAD OF SPINNING ANIMATION SCRIPT			 *
*                                                                        *
**************************************************************************
DTBOUNCE
	MOVI	28000H,A5
	MOVE	*A8(OXVEL),A11,L
	JRNN	DTBNCEA
	CALLR	YFLP
	NEG	A5
	CMP	A5,A11
	JRLT	DTBNCEB
	JRUC	DTBNCEA1
DTBNCEA
	CALLR	NOYFLP
	CMP	A5,A11
	JRGT	DTBNCEB
DTBNCEA1
	MOVE	A5,A11
	MOVE	A11,*A8(OXVEL),L
DTBNCEB
	SRL	16,A11
	SEXT	A11
	MOVE	*A13(PDATA+0C0H),A9,L
	ABS	A11
	SUBK	8,A11
	ABS	A11
	CREATE	INDPID,ANIMATOR
	MOVE	A0,*A8(OPLINK),L
DTBNCEC
	MOVE	*A8(OYVEL),A0,L
	SRA	1,A0
	CMPI	8000H,A0
	JRLT	DTBHIT1
	NEG	A0
	MOVE	*A8(OZVEL),A1,L
	SRA	1,A1
	MOVE	A1,*A8(OZVEL),L
	CALLA	SHVELCPY
	MOVE	A0,*A8(OYVEL),L
DTBNCE1
	SLEEP	1
	CALLA	CKZADJST
	MOVE	*A8(OYVEL),A3,L	;GET THE CURRENT Y VELOCITY
	JRLE	DTBNCE2		;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT
	CALLR	DFRMGRND	;DID HE HIT THE GROUND?
	JRLE	DTBNCEC		;BR = NO
DTBNCE2
	MOVE	*A8(OYVEL),A0,L		;DECREASE Y VELOCITY
	ADDI	GRAVITY,A0
	MOVE	A0,*A8(OYVEL),L
	JRUC	DTBNCE1
DTBHIT1
	CALLA	PSTOPYZ			;KEEP IT FLIPPED THE SUCKER   
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	CALLA	DELSHAD			;RESET SHADOW
DTBHIT4
	SLEEP	8
	CALLA	SCRTST
	JREQ	DTBHIT4
	MOVE	*A8(OPLINK),A0,L
	JRZ	DTBHIT5
	CALLA	KILL
DTBHIT5
	MOVE	A8,A0
	CALLA	DELPAL
	CALLA	DELSOBJ
	DIE

**************************************************************************
*                                                                        *
* SINK AN OBJECT OUT OF EXISTENCE, OBJECT IS DELETED SO IS IT'S PALETTE. *
* A8=OBLOCK POINTER.							 *
* I.D. = $DF                                                             *
**************************************************************************
DSINK
	MOVI	[1,1],A9
	JSRP	OSINK
	MOVE	A8,A0
	CALLA	DELPAL
	CALLA	DELSOBJ			;GET RID OF THIS THING
	JAUC	SUCIDE

*
*SINK ENEMY OBJECT INTO GROUND PROCESS
*A8=OBJECT
*A9=SLEEP TIME: SINK RATE PIX/SLEEP
*
ESINK
	JSRP	OSINK
	MOVE	A8,A0			;GET OBJECT DESCRIPTOR
	CALLA	DELENEMY 		;DELETE OBJECT AND QUIT
	JAUC	SUCIDE

**************************************************************************
*                                                                        *
* OSINK - SINK OBJECT INTO GROUND PROCESS SUBROUTINE			 *
* A8=OBJECT								 *
* A9=SLEEP TIME: SINK RATE PIX/SLEEP					 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
OSINK:	
	PUSHP	A10
	MOVE	A8,A0
	CALLA	PSTOP
	CALLA	DELSHAD			;CAN THE SHADOW
	MOVE	A9,A10
	ZEXT	A9
	SRL	16,A10
OSINKL:
	MOVE	*A8(OSIZEY),A0,W
	SUB	A9,A0
	JRLS	OSINKX			;SINKING IS DONE
	MOVE	A0,*A8(OSIZEY),W	;ADJUST HT.
	MOVE	*A8(OYPOS),A1,W		;ADJUST TOP LEFT Y
	ADD	A9,A1
	MOVE	A1,*A8(OYPOS),W
	MOVE	A10,A0			;GET SLEEP TIME
	CALLA	PRCSLP			;SLEEP YOUR BIT
	JRUC	OSINKL
OSINKX:
	PULLP	A10
	RETP
*
*COLLISION VECTOR LISTS
DUMCOLL	.WORD	0
	.LONG	DUMRTSG

DUMRTSG
	CLR	A0			;DON'T STOP SCAN
	CLRC				;AND DON'T DELETE
	RETS	

**************************************************************************
*                                                                        *
* CKYBOUND - CHECK OBJECT AGAINST Y BOUNDRIES. THE VELOCITY IS 		 *
* 	     ZERO'D IF A BOUNDRY IS HIT.				 *
* A8 = OBJECT BLOCK PTR							 *
*                                                                        *
**************************************************************************
CKYBOUND
	MMTM	SP,A1,A2
									 
	MOVE	*A8(OZPOS),A1,W		;GET THE Z POSITION

	MOVE	*A8(OZVEL),A2,L
	JREQ	CKYBNDX			;BR = NO VELOCITY, NO CHECK
	JRN	CKUYBND			;BR = NEGATIVE, CHECK YMIN

	MOVE	@PLZMAX,A2,W		;GET THE MAX Z
	CMP	A2,A1			;HIT ROCK BOTTOM?
	JRLT	CKYBNDX			;BR = NO
	CALLR	PSTOPYZ			;ZERO Y VELOCITY
	JRUC	CKYBNDX

CKUYBND
	MOVE	@PLZMIN,A2,W
	CMP	A2,A1			;AT THE TOP?
	JRGT	CKYBNDX			;BR = NO
	CALLR	PSTOPYZ

CKYBNDX	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* GSCRIPT - LOAD AN ANIMATION SCRIPT FROM MAIN ANIMATION TABLE		 *
* A0 = FRAME TYPE							 *
* A6 = PTR TO MAIN ANIMATION TABLE					 *
* RETURN(S):								 *
* A9 = PTR TO HEAD OF ANIMATION LIST					 *
*                                                                        *
**************************************************************************
GSCRIPT
	MOVE	A6,-*SP,L
	CALLA	BASFRM	 	;OFFSET INTO LIST TABLE
	MOVE	*A6,A9,L	;POINT TO THE LIST
	MOVE	*SP+,A6,L
	RETS

**************************************************************************
*                                                                        *
* BASFRM - GET THE BASE OF THE ANIMATION TABLE POINTERS			 *
* A0 = OFFSET TO THE OFFSET TABLE					 *
* A6 = MAIN ANIMATION TABLE						 *
* RETURNS								 *
* A6 = PTR TO BASE OF ANIMATION TABLE					 *
*                                                                        *
**************************************************************************
BASFRM	MMTM	SP,A0,A1
	SLL	4,A0			;OFFSET*32
	MOVE	*A6,A1,L		;GET THE OFFSET TABLE PTR
	ADD	A0,A1
	MOVE	*A1,A1,W		
	SLL	5,A1
	ADD	A1,A6			;A6 IS INDEXED TO THE BASE FRAMES
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* EFRAME - STUFF A FRAME						 *
* A8 = POINTER TO OBJECT BLOCK						 *
* A9 = PTR TO CURRENT FRAME						 *
* RETURNS								 *
* CARRY SET IF THE END WAS HIT						 *
* A0 = CANNED FRAME DURATION						 *
*                                                                        *
**************************************************************************
EFRAME	MMTM	SP,A1,A4
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	EFRMX			;BR = END WAS HIT

	MOVE	*A8(OIMG),A4,L	
	CMP	A4,A1
	JREQ	EFRMATCH		;BR = SAME FRAME TWO TIME IN A ROW

	MOVE	*A8(OFLAGS),A4,W
	CALLA	ANI
EFRMATCH
	MOVE	*A9+,A0,W		;GET THE SLEEP TIME
	CLRC
	MMFM	SP,A1,A4
	RETS

EFRMX	SETC
	MMFM	SP,A1,A4
	RETS

**************************************************************************
*                                                                        *
* FRANIM - ANIMATION SCRIPT PROCESSOR					 *
* A1 = COMMAND:	00 = PROCESS CURRENT FRAME.				 *
* 		01 = PROCESS TO END OF LIST.				 *
* 		02 = PROCESS X # OF FRAMES OR TO END. A1 = [# FRMS,CMD]  *
* 		03 = INFINITELY LOOP ON THE LIST.			 *
* 		04 = PROCESS CURRENT FRAME, NO SLEEP(TIME RETRN'D IN A0) *
* A8 = PTR TO OBJECT BLOCK						 *
* A9 = PTR TO CURRENT FRAME						 *
* RETURN(S)								 *
* CARRY SET IF END OF ANIMATION LIST WAS HIT				 *
* A9 = POINTING TO NEXT FRAME, IF NOT AT END OF LIST			 *
* SETS EPARENT OF THE SPAWNED CHILD POINTING TO THIS PROCESS		 *
* NOTE: CALL WITH JSRP, IT SLEEPS					 *
* 									 *
* ANIMATION SCRIPT FORMAT						 *
* 	.LONG	IMAGE_HEADER<-- IF = 0 END OF SCRIPT			 *
* 	.WORD	SLEEP_TIME  <-- BITS 0 - 7 ARE THE SLEEP TIME.	 	 *
* 			    <-- BITS 8 -15 ARE THE FLAGS:		 *
* 				 BIT #		FLAG			 *
* 				 -----		----			 *
* 				   8	       UNUSED			 *
* 				   9	       UNUSED			 *
* 				  10	       UNUSED			 *
* 				  11	 DELTA Y WORD IS PRESENT	 *
* 				  12	PACKED DELTAS FOR X&Z PRESENT    *
* 				  13	NEW PALETTE ADDRESS IS SPECIFIED *
* 				  14	NEW FLIP BITS ARE SPECIFIED	 *
* 				  15	SPAWN PROCESS W/OFFSETS		 *
* 					   .WORD XOFF,YOFF,PROCID	 *
* 					   .LONG PROCADDR		 *
* 				FLAG HIERARCHY: 15 --> 8		 *
* 				 OPTIONS SHOULD FOLLOW IN THIS ORDER.    *
*                                                                        *
**************************************************************************
FRANIM
	MMTM	A12,A3,A11
	MOVE	A9,A11		;SAVE ENTRYPOINT FOR INFINITE CASE		
FRAN1
	MOVE	A1,A3
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRANND			;BR = END WAS HIT

	MMTM	SP,A2,A4,A5,A6,A7,A10,A14

	MOVE	*A9+,A0,W
	MOVE	A0,A14			;XFER FLAGS HERE	
	SLL	24,A0
	SRL	24,A0			;WIPE OFF THE FLAGS
	SLL	16,A14			;MOVE FLAGGIES UP HERE

	SLL	1,A14
	JRNC	FRANNOSP
*SPAWN A PROCESS
	MMTM	SP,A0,A1
	MOVE	*A9+,A10,L	;X AND Y FIRING OFFSETS PASSED IN A10
	MOVE	*A9+,A1,W	;GET PROCESS ID
	MOVE	*A9+,A7,L	;PROCESS STARTING ADDRESS
	CALLA	GETPRC		;SPAWN THE PROCESS
***	JREQ	FRSPAWNF	;BR = FAILED TO SPAWN
***	MOVE	A13,*A0(EPARENT),L	;RETURN LINK TO PARENT PROCESS	
FRSPAWNF
	MMFM	SP,A0,A1	
FRANNOSP
	SLL	1,A14
	JRNC	FRANNOBI
*STUFF SOME NEW FLAGS
	MOVE	*A9+,A2,W		;GET THE NEW FLIP FLAGS
	MOVE	*A8(OFLAGS),A4,W	;GET THE OLD FLIP FLAGS
	ANDNI	(M_FLIPV+M_FLIPH),A4	;CLEAR THE CURRENT FLIP STATUS
	OR	A2,A4			;SET DESIRED BITS
	JRUC	FRAN2A				
FRANNOBI
      	MOVE	*A8(OFLAGS),A4,W	;NORMAL FLAGS TO BE USED
FRAN2A
	SLL	1,A14
	JRNC	FRANNOPA
*ACTIVATE A NEW PALETTE
	PUSH	A0			
	MOVE	*A9+,A0,L		;GET THE PALETTE ADDRESS
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	JRZ	FRAN2B			;NO PALETTE AVAILABLE
	MOVE	A0,A7			;SAVE HERE
	MOVE	A8,A0
	CALLA	DELPAL
	MOVE	A7,*A8(OPAL),W		;STORE THE NEW PALETTE
FRAN2B
	PULL	A0
FRANNOPA
	SLL	1,A14
	JRNC	FRANNDXZ
*ADD DELTA X AND Z
	MOVE	*A9+,A7,W		;GET THE DELTAS
	MOVE	A7,A6
	SLL	24,A6
	SRA	24,A6			;BRING THE SIGN BACK DOWN
	JRZ	FNODX			;BR = THERE'S NO DELTA HERE
	BTST	B_FLIPH,A4
	JREQ	FNOFDX
	NEG	A6			;HE'S FLIPPED, NEGATE
FNOFDX
	MOVE	*A8(OXPOS),A5,W
	ADD	A6,A5
	MOVE	A5,*A8(OXPOS),W		;ADJUST X POSITION
FNODX
	SRA	8,A7
	JRZ	FRANNDXZ		;BR = NO Z OFFSET
	BTST	B_FLIPV,A4
	JREQ	FNOFDZ
	NEG	A7
FNOFDZ
	MOVE	*A8(OZPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OZPOS),W		;ADJUST Z POSITION
	MOVE	*A8(OYPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OYPOS),W		;ADJUST MATCHING Y POSITION
FRANNDXZ
	SLL	1,A14
	JRNC	FRANNDY
*ADD DELTA Y
	MOVE	*A9+,A7,W
	JRZ	FRANNDY
	BTST	B_FLIPV,A4
	JREQ	FNOFDY
	NEG	A7
FNOFDY
	MOVE	*A8(OYPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OYPOS),W		;ADJUST Y POSITION
FRANNDY
	CALLA	ANI		;SETUP NEW ANIMATION

	MMFM	SP,A2,A4,A5,A6,A7,A10,A14

	MOVE	A3,A1		;GET THE COMMAND BACK
	CMPI	4,A1		;ONE FRAME, NO SLEEP?
	JREQ	FRAN3		;YES

	PUSHP	A1
	CALLA	PRCSLP		;SLEEP THE PROPER TIME
	PULLP	A1

	CMPI	1,A1
	JREQ	FRAN1		;BR = LOOP 'TIL END OF LIST
	JRLT	FRAN3		;BR = ONE FRAME AT A TIME

	SUBI	010000h,A1	;DECREMENT FRAME COUNT
    	CLR	A0
	CMPXY	A0,A1
	JRYGT	FRAN1		;FRAME COUNT HAS NOT BEEN EXHAUSTED

FRAN3	CLRC			;CLEAR END FLAG
	JRUC	FRANX			

FRANND	MOVE	A3,A1
	CMPI	3,A1
	JRNE	FRAN4		;BR = EXIT

	MOVE	A11,A9		;GET THE STARTING POINTER BACK
	JRUC	FRAN1		;LOOP INFINITELY

FRAN4	SETC			;OTHERWISE, RETURN WITH END FLAG SET
FRANX
	MMFM	A12,A3,A11
	RETP

**************************************************************************
*                                                                        *
* FRAMSKIP - SKIP TO THE NEXT FRAME OF AN ANIMATION SCRIPT		 *
* A9 = SCRIPT PTR							 *
* RETURNS:								 *
* 	C CLR = A9 IS POINTING TO NEXT FRAME				 *
* 	C SET = SCRIPT END WAS HIT, A9 POINTS TO NEXT WORD		 *
*                                                                        *
**************************************************************************
FRAMSKIP
	MMTM	SP,A1
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRAMSSC			;BR = END WAS HIT
	MOVE	*A9+,A1,W
	SLL	16,A1			;MOVE FLAGGIES UP HERE
	SLL	1,A1
	JRNC	FRAMSNSP
	ADDI	32+16+32,A9		;PROCESS SPAWN
FRAMSNSP
	SLL	1,A1
	JRNC	FRAMSNF
	ADDK	16,A9			;NEW FLAGS
FRAMSNF
	SLL	1,A1
	JRNC	FRAMSNP
	ADDK	32,A9			;NEW PALETTE
FRAMSNP
	SLL	1,A1
	JRNC	FRAMSNXZ
	ADDK	16,A9			;DELTA X & DELTA Z
FRAMSNXZ
	SLL	1,A1
	JRNC	FRAMSNY
	ADDK	16,A9			;DELTA Y
FRAMSNY
	CLRC	
	JRUC	FRAMSND
FRAMSSC
	SETC
FRAMSND
	MMFM	SP,A1
	RETS
**************************************************************************
*                                                                        *
* ANIMATOR - INDEPENDENT ANIMATION PROCESS, PROCESSES AN ANIMATION	 *
* 	     SCRIPT INFINITELY.			     			 *
* A8 = OBJECT TO ANIMATE						 *
* A9 = SCRIPT								 *
* A11 = # OF TICKS PER FRAME (IF NEG. HOLD CURRENT FRAME)		 *
*                                                                        *
**************************************************************************
ANIMATOR
	PUSHP	A9		;SAVE BEGINNING OF SCRIPT
ANIMATO1
	MOVE	A11,A11
	JRNN	ANIMATO0	;BR = O.K. TO ANIMATE
	SLOOP	1,ANIMATO1
ANIMATO0
	MOVK	4,A1
	JSRP	FRANIM
	JRC	ANIMATO3	;BR = HIT END OF SCRIPT
	MOVI	ANIMATO1,A7
	MOVE	A11,A0
	JRNZ	ANIMATO2	;NO EXTRA SLEEP
	MOVK	1,A0
ANIMATO2
	JAUC	PRCLSP		;SLEEP ADDITIONAL TIME
ANIMATO3	
	PULLP	A9		;RESTORE LIST POINTER
	JRUC	ANIMATOR

**************************************************************************
*                                                                        *
* ANIMATCK - INDEPENDENT ANIMATION PROCESS, PROCESSES AN ANIMATION	 *
* 	     SCRIPT INFINITELY, BUT DOESN'T ANIMATE IF OFF SCREEN.	 *
*	     THE SCREEN CHECK IS ONLY IN X FOR SPEED.			 *
* A8 = OBJECT TO ANIMATE						 *
* A9 = SCRIPT								 *
* A11 = # OF TICKS PER FRAME (IF NEG. HOLD CURRENT FRAME)		 *
*                                                                        *
**************************************************************************
ANIMATCK
	PUSHP	A9		;SAVE BEGINNING OF SCRIPT
ANIMCKO1
	MOVE	A11,A11
	JRNN	ANIMCKO0	;BR = O.K. TO ANIMATE
	SLOOP	1,ANIMCKO1
ANIMCKO0
	CALLR	SCRTSTX		;ON SCREEN?
	JREQ	ANIMCKON
	CALLR	FRAMSKIP 	;SKIP TO THE NEXT ANIMATION FRAME
	JRC	ANIMCKO3	;HIT THE END
	JRUC	ANIMCKOF
ANIMCKON
	MOVK	4,A1
	JSRP	FRANIM
	JRC	ANIMCKO3	;BR = HIT END OF SCRIPT
ANIMCKOF
	MOVI	ANIMCKO1,A7
	MOVE	A11,A0
	JRNZ	ANIMCKO2	;NO EXTRA SLEEP
	MOVK	1,A0		;DEFAULT TO 1
ANIMCKO2
	JAUC	PRCLSP		;SLEEP ADDITIONAL TIME
ANIMCKO3	
	PULLP	A9		;RESTORE LIST POINTER
	JRUC	ANIMATCK

**************************************************************************
*                                                                        *
* SCRTSTX - SCREEN TEST ONLY IN X					 *
* A8 = OBJECT TO TEST							 *
* RETURNS:								 *
* 	EQ = ON SCREEN							 *
* 	NE = OFF							 *
*                                                                        *
**************************************************************************
SCRTSTX
	MMTM	SP,A0,A2,A3
	MOVE	*A8(OXPOS),A0,W
	MOVE	@WORLDTLX+16,A2,W	;COMPARE ONLY TO FULL WIDTH
	MOVE	A2,A3
	ADDI	512,A3			;AND 512 IS IT
	CMP	A3,A0
	JRGT	SCRTSTXOFF		;OFF THE RIGHT SIDE
	MOVE	*A8(OSIZEX),A3,W	
	ADD	A3,A0
	CMP	A2,A0
	JRLT	SCRTSTXOFF		;OFF THE LEFT
	CLR	A0
	JRUC	SCRTSTXXX
SCRTSTXOFF
	CLR	A0
	INC	A0
SCRTSTXXX
	MMFM	SP,A0,A2,A3
	RETS
	
**************************************************************************
*                                                                        *
* SCRKIL - GIVE APPROPRIATE SCORE FOR ENEMY KILL			 *
* A8 = OBLOCK PTR OF ENEMY						 *
* A11 = OID OF KILLER							 *
*                                                                        *
**************************************************************************
SCRKIL	MMTM	SP,A0,A1,A2,A11
	SRL	4,A11
	SLL	4,A11  			;MASK OFF WEAPON
	ZEXT	A11			;MUST CLEAR HONORABLE HIGH WORD

	CMPI	P1OID,A11
	JREQ	SCRK1A
	CMPI	B1OID,A11
	JRNE	SCRK1			;BR = NO
SCRK1A
	MOVI	P1DATA,A2		
	JRUC	SCRK2

SCRK1	CMPI	B2OID,A11
	JREQ	SCRK2A			;NOPE KILLED BY A NOBODY	
	CMPI	P2OID,A11
	JRNE	SCRKCAR
SCRK2A
	MOVI	P2DATA,A2
	JRUC	SCRK2
*CHECK VEHICLE I.D.'S
SCRKCAR
	CMPI	TRAN1OID,A11
	JREQ	SCRKBOTH		;BR = CAR, SCORE BOTH PLAYERS
	CMPI	TRAN2OID,A11
	JREQ	SCRKBOTH		;BR = HELICOPTER, SCORE BOTH PLAYERS
	JRUC	SCRKX

SCRK2	MOVI	ESCRTAB,A1		;POINT TO THE SCORE TABLE
	MOVE	*A8(OID),A0,W
	SRL	4,A0
	SLL	28,A0
	SRL	23,A0			;MASK OFF AND MULTIPLY BY 32
	ADD	A0,A1			
	MOVE	*A1,A1,L		;GET THE SCORE
	CALLA	SCORE			;AND SCORE IT
	JRUC	SCRKX
*
*GIVE SCORE TO BOTH PLAYER'S IF THEY'RE IN A VEHICLE
SCRKBOTH
	MOVI	ESCRTAB,A1		;POINT TO THE SCORE TABLE
	MOVE	*A8(OID),A0,W
	SRL	4,A0
	SLL	28,A0
	SRL	23,A0			;MASK OFF AND MULTIPLY BY 32
	ADD	A0,A1			
	MOVE	*A1,A1,L		;GET THE SCORE
	CALLA	SCORE2P			;AND SCORE IT

SCRKX	MMFM	SP,A0,A1,A2,A11
	RETS

***** DATA SECTION ******
	.data

*ENEMY SCORING TABLE, INDEXED BY TYPE
ESCRTAB	.LONG	050h		;TYPE 0 ENEMY (BUG)
	.LONG	0100h		;TYPE 1 ENEMY (LOF)
	.LONG	0250h		;TYPE 2 ENEMY (GANGSTER)
	.LONG	0500h		;TYPE 3 ENEMY (PIMP)
	.LONG	01000H		;TYPE 4 ENEMY (HYPOMAN)
	.LONG	02500h		;TYPE 5 ENEMY (DUMPSTER-MAN)
	.LONG	02500h		;TYPE 6 ENEMY (CLOWN)
	.LONG	00200h		;TYPE 7 ENEMY (DOG)
	.LONG	01750h		;TYPE 8 ENEMY
	.LONG	02000H		;TYPE 9 ENEMY
	.LONG	05000H		;TYPE A ENEMY
	.LONG	0H		;TYPE B ENEMY (HOOKER)
	.LONG	025000h
	.LONG	050000h
	.LONG	0100000h


	.END									 
