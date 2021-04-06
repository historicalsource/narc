	.FILE	'NARCCARS.ASM'
	.TITLE	" <<< N  A  R  C  -- VEHICLE SUBROUTINES >>>"

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

*
*GLOBALS IN THIS FILE
	.GLOBAL	CNEWPAL

	.TEXT

**************************************************************************
*                                                                        *
* 	VEHICLE(MULTI-PART OBJECT) CONTROL ROUTINES			 *
* 	-------------------------------------------			 *
* 									 *
* PROCESS BLOCK VARIABLES:						 *
* -----------------------						 *
* 	A8 	= PTR TO DRIVER/PILOT/ETC.				 *
* 	A10 	= PTR TO MAIN VEHICLE BODY PART				 *
* 	ETEMP1\								 *
* 	  .    \							 *
* 	  .	> = PARTS, OPLINK PROCESS IS KILLED UPON DELETION	 *
* 	  .    /							 *
* 	ETEMP6/								 *
*									 *
*	ETEMP7	\							 *
* 	ETEMP8	  = PART, OPLINK PROCESS IS NOT KILLED UPON DELETION	 *
* 					    ---				 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* CARINIT - INITIALIZE A VEHICLE TOTALLY, AND INSERT IT ON THE OBJECT LI *
* A6 = PTR TO THE DRIVER AND CAR ANIMATION TABLE			 *
* A13 = PTR TO PROC BLOCK						 *
* A14 = PTR TO INITIALIZATION LIST					 *
* RETURNS:								 *
* A8 = PTR TO THE DRIVER						 *
* A10 = PTR TO THE MAIN CAR						 *
* *A13(ETEMP1) - *A13(ETEMP8) = PTRS TO THE CAR PARTS			 *
* Z BIT CLR = SUCCESS							 *
* Z BIT SET = FAILURE							 *
*                                                                        *
**************************************************************************
CARINIT
	MMTM	SP,A0,A1,A9,A11
	MMTM	SP,B1,B2,B3
	CALLA	CLRPDATA		;CLEAR THE PDATA AREA
	CALLA	GPALOBJ
	JRZ	CARINIFL		;PALETTE CAR CREATE ERROR
	CALLA	STFOBJ			;SETUP MAIN VEHICLE BODY							 
	CALLA	ADJSTWTL
	MOVE	*A0(OZVAL),A10,L
	JRNZ	CARNOZST		;BR = HE SET HIS OWN Z POSITION
	CALLA	SETZPOS							 
CARNOZST
	MOVE	A13,*A0(OPLINK),L	;PROCESS LINK			 
	MOVE	A0,A10

	CALLR	CINIPART
	JRZ	CADTEMP2
	MOVE	A0,*A13(ETEMP1),L	;STORE WINDSHIELD POINTER	 
	MOVE	*A10(OZVAL),A1,L
	ADDK	2,A1
	MOVE	A1,*A0(OZVAL),L		;WINDSHIELD Z = CAR Z + 2
CADTEMP2
	CALLR	CINIPART
	JRZ	CADTEMP3
	MOVE	A0,*A13(ETEMP2),L	;STORE TRUNK OBJECT POINTER
	MOVE	*A10(OZVAL),A1,L
	ADDK	2,A1
	MOVE	A1,*A0(OZVAL),L		;TRUNK Z = CAR Z + 2
CADTEMP3
	CALLR	CINIPART
	JRZ	CADTEMP4
	MOVE	A0,*A13(ETEMP3),L	;STORE FRONT WHEEL OBJECT POINTER
	MOVE	*A10(OZVAL),A1,L
	DEC	A1			;KEEP THE WHEEL BEHIND THE BODY
	MOVE	A1,*A0(OZVAL),L
CADTEMP4
	CALLR	CINIPART
	JRZ	CADTEMP5
	MOVE	A0,*A13(ETEMP4),L	;STORE REAR WHEEL OBJECT POINTER
	MOVE	*A10(OZVAL),A1,L
	DEC	A1			;KEEP THE WHEEL BEHIND THE BODY
	MOVE	A1,*A0(OZVAL),L
CADTEMP5
	CALLR	CINIPART
	JRZ	CADTEMP6
	MOVE	A0,*A13(ETEMP5),L
	MOVE	*A10(OZVAL),A1,L
	INC	A1
	MOVE	A1,*A0(OZVAL),L
CADTEMP6
	CALLR	CINIPART
	JRZ	CADTEMP7
	MOVE	A0,*A13(ETEMP6),L	;STORE OBJECT POINTER
	MOVE	*A10(OZVAL),A1,L
	INC	A1
	MOVE	A1,*A0(OZVAL),L
CADTEMP7
	CALLR	CINIPART		;THIS PART DOES NOT KILL IT'S PROC
	JRZ	CADTEMP8
	MOVE	A0,*A13(ETEMP7),L	;STORE OBJECT POINTER
	MOVE	A13,*A0(OPLINK),L
	MOVE	*A10(OZVAL),A1,L
	INC	A1		 
	MOVE	A1,*A0(OZVAL),L
CADTEMP8
	CALLR	CINIPART		;THIS PART DOES NOT KILL IT'S PROC
	JRZ	CDRVINIT
	MOVE	A0,*A13(ETEMP8),L	;STORE OBJECT POINTER
	MOVE	A13,*A0(OPLINK),L
	MOVE	*A10(OZVAL),A1,L
	INC	A1
	MOVE	A1,*A0(OZVAL),L

*
*INTIALIZE THE DRIVER							 
CDRVINIT
	MOVE	*A14,A0,L
	CMPI	07FFF7FFFH,A0
	JRNE	CDRIVER
	CLR	A8
	MOVE	A6,*A13(EMAINT),L	;STILL STUFF THIS THING
	JRUC	CADDALL
CDRIVER
	MOVE	A10,B3
	MOVE	*A14(50H),A1,W
	MOVE	*A14(70H),A2,W
	SLL	16,A2
	MOVY	A2,A1		;FUDGE OUT THE POSITION FOR ENINIT
	CALLA	ENINIT		;INITIALIZE THE DRIVER			 
	JRNZ	CARDRIVE	;BR = DRIVER, CONTINUE	
	MOVE	B3,A10		;GRAB THE CADILLAC POINTER		 
	JRUC	CARNODRV	;AND STOP THE SHOW									 
CARDRIVE
	MOVE	B3,A10		;A10 = PTR TO CADILLAC
	MOVE	A8,A0
	CALLA	ADJSTWTL
	CALLA	DELSHAD
	MOVE	*A10(OZVAL),A1,L
	INC	A1
	MOVE	A1,*A8(OZVAL),L	;DRIVER Z = CAR Z + 1

CADDALL
	MOVI	CARLIST,A1
	MOVE	A10,A0
	CALLA	INSOBJ		;ADD THE CADDY							 
	CALLA	ADDSUPP

	MOVE	A13,A14
	ADDI	ETEMP1,A14
	MOVK	NPARTS,B2	;INSERT ALL TEMP AREA'S
CADTMPIN
	MOVE	*A14+,A0,L
	JRZ	CADTMPI1	;BR = THERE'S NOTHING HERE
	CALLA	INSOBJ							 
	CALLA	ADDSUPP
CADTMPI1
	DSJS	B2,CADTMPIN
	CLR	A0
	MOVE	A0,*A13(ERESET),W	;CLEAR THE RESET COUNTER
	MOVE	A10,A10		;INDICATE SUCCESS
CARINIFL
	MMFM	SP,B1,B2,B3
	MMFM	SP,A0,A1,A9,A11
	RETS

*THE DRIVER UNINTENTIONALY COULD NOT BE CREATED, WIPE OUT ALL THIS WORK
CARNODRV
       	MOVE	A10,A0						 
	CALLA	DELPAL
	CALLA	FREEOBJ

	MOVE	A13,A1
	ADDI	ETEMP1,A1
	MOVK	NPARTS,B2		;DELETE ALL TEMP AREA'S
CARNOD1
	MOVE	*A1+,A0,L
	JRZ	CARNOD2			;BR = THERE'S NOTHING HERE
	CALLA	DELPAL
	CALLA	FREEOBJ
CARNOD2
	DSJS	B2,CARNOD1
	CLR	A10
	JRUC	CARINIFL

**************************************************************************
*                                                                        *
* CINIPART - INITIALIZE A PART OF THE CAR, TO BE USED WITH CARINIT	 *
* RETURNS:								 *
* A14 = PTR TO NEXT INIT TABLE						 *
* Z BIT CLR = SUCCESS ---> A0 = PTR TO OBJECT				 *
* Z BIT SET = FAILURE ---> A0 = 0					 *
*                                                                        *
**************************************************************************
CINIPART
	MOVE	*A14+,A0,L
	CMPI	07FFF7FFFH,A0
	JREQ	CIPARTF1		;BR = THERE'S NO PART HERE
	SUBK	32,A14			;RESET POINTER
	CALLA	GPALOBJ
	JRZ	CIPARTF			;BR = OBJ/PALETTE FAILURE
	CALLA	STFOBJ							 
	CALLA	ADJSTWTL
	MOVE	A0,A0			;CLR Z BIT
	RETS
CIPARTF
	ADDI	18*16,A14		;GET TO THE NEXT INIT. TABLE
CIPARTF1
	CLR	A0			;SET Z BIT
	RETS

**************************************************************************
*                                                                        *
* CDELALL - DELETE ALL VEHICLE PARTS AND DRIVER, EXCEPT FOR THE		 *
* 	  MAIN(A10 = PTR).						 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO MAIN							 *
* A13 = PROCBLOC							 *
*                                                                        *
**************************************************************************
CDELALL
	MMTM	SP,A0,A1,A6,A8,A14
	CALLR	KILLCARP		;KILL A CAR PROCESS
	MOVI	ENEMIES,A1
	MOVE	A8,A0							 
	JREQ	CDELALL1
	CALLA	DELPAL
	CALLA	DELSUPP
	CALLA	DELSOBJ			;BYE BYE DRIVER			 
CDELALL1
	MOVI	CARLIST,A1
	MOVE	A13,A14
	ADDI	ETEMP1,A14
	MOVK	NPARTS-2,A6		;DELETE ALL TEMP AREA'S
CDELALL2
	MOVE	*A14+,A8,L
	JRZ	CDELALL4		;BR = THERE'S NOTHING HERE
	MOVE	*A8(OPLINK),A0,L
	JREQ	CDELALL3
	CALLA	KILL			;KILL ANIMATING PROC.
CDELALL3
	MOVE	A8,A0
	CALLA	DELPAL
	CALLA	DELSUPP							 
	CALLA	DELSOBJ
CDELALL4
	DSJS	A6,CDELALL2
	MOVK	2,A6
CDELAL4A
	MOVE	*A14+,A0,L
	JRZ	CDELALL5
	CALLA	DELPAL			;JUST DELETE ETEMP6
	CALLA	DELSUPP							 
	CALLA	DELSOBJ
CDELALL5
	DSJS	A6,CDELAL4A
	MMFM	SP,A0,A1,A6,A8,A14
	RETS


**************************************************************************
*                                                                        *
* DELCBODY - DELETE THE CAR BODY FROM THE OBJECT LIST AND,		 *
* 		CARLIST.						 *
* 		 ALSO DELETE THE SHADOW FROM THE OBJLST.		 *
* A10 = PTR TO ENEMY OBLOCK						 *
*                                                                        *
**************************************************************************
DELCBODY
	PUSH	A1
	MOVI	CARLIST,A1
	MOVE	A10,A0
	CALLA	DELPAL
	CALLA	DELSUPP
	CALLA	DELSOBJ
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* CNEWPAL - STORE A NEW PALETTE TO THE VEHICLE				 *
* A1 = NEW PALETTE							 *
* A8 = DRIVER/PILOT							 *
* A10 = PTR TO MAIN							 *
* A13 = PROCESS BLOCK							 *
*                                                                        *
**************************************************************************
CNEWPAL
	MMTM	SP,A0,A2,A3,A6,A14
	MOVE	A1,A0
	CALLA	GETFPAL
	JRZ	CNEWPALX		;NO PALETTES AVAILABLE
	MOVE	A0,A2
	MOVE	A10,A0
	CALLA	DELPAL
	MOVE	A2,*A10(OPAL),W

	MOVE	A13,A14
	ADDI	ETEMP1,A14
	MOVI	NPARTS-1,A6		;SKIP THE PASSENGER
CNEWPLP
	MOVE	*A14+,A2,L
	JRZ	CNEWPLCT
	MOVE	A1,A0
	CALLA	GETFPAL
	MOVE	A0,A3
	MOVE	A2,A0
	CALLA	DELPAL
	MOVE	A3,*A2(OPAL),W
CNEWPLCT
	DSJS	A6,CNEWPLP
CNEWPALX
	MMFM	SP,A0,A2,A3,A6,A14
	RETS

**************************************************************************
*                                                                        *
* CARYZVEL - STUFF THE VEHICLE AND ALL IT'S PARTS WITH A Y/Z VEL.	 *
* A1 = NEW VELOCITY							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CARYZVEL
	MMTM	SP,A0,A6,A13

	MOVE	A1,*A10(OYVEL),L
	MOVE	A1,*A10(OZVEL),L

	MOVE	A8,A0
	JRZ	CADYZV3
	MOVE	A1,*A0(OYVEL),L
	MOVE	A1,*A0(OZVEL),L
CADYZV3

	ADDI	ETEMP1,A13
	MOVK	NPARTS,A6
CADYZV1
	MOVE	*A13+,A0,L
	JRZ	CADYZV2
	MOVE	A1,*A0(OYVEL),L
	MOVE	A1,*A0(OZVEL),L
CADYZV2
	DSJS	A6,CADYZV1

***	MOVE	*A10(OSHAD),A0,L
***	JRZ	CADYZV4
***	MOVE	A1,*A0(OYVEL),L
***	MOVE	A1,*A0(OZVEL),L
***CADYZV4

	MMFM	SP,A0,A6,A13
	RETS

**************************************************************************
*                                                                        *
* CARXVEL - STUFF THE VEHICLE AND ALL IT'S PARTS WITH AN X VEL.		 *
* A1 = NEW VELOCITY							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CARXVEL
	MMTM	SP,A0,A6,A13

	ADDI	ETEMP1,A13
	MOVK	NPARTS,A6
CADXV1
	MOVE	*A13+,A0,L
	JRZ	CADXV2
	MOVE	A1,*A0(OXVEL),L
CADXV2
	DSJS	A6,CADXV1

	MOVE	A8,A0
	JRZ	CADXV3
	MOVE	A1,*A0(OXVEL),L
CADXV3
	MOVE	A1,*A10(OXVEL),L
***	MOVE	*A10(OSHAD),A0,L
***	JRZ	CADXV4
***	MOVE	A1,*A0(OXVEL),L
***CADXV4
	MMFM	SP,A0,A6,A13
	RETS

**************************************************************************
*                                                                        *
* CARYVEL - STUFF THE VEHICLE AND ALL IT'S PARTS WITH A Y VEL.		 *
* A1 = NEW VELOCITY							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CARYVEL
	MMTM	SP,A0,A6,A13
	ADDI	ETEMP1,A13
	MOVK	NPARTS,A6
CADYV1
	MOVE	*A13+,A0,L
	JRZ	CADYV2
	MOVE	A1,*A0(OYVEL),L
CADYV2
	DSJS	A6,CADYV1
	MOVE	A8,A0
	JRZ	CADYV3
	MOVE	A1,*A0(OYVEL),L
CADYV3
	MOVE	A1,*A10(OYVEL),L
	MMFM	SP,A0,A6,A13
	RETS

**************************************************************************
*                                                                        *
* CARZVEL - STUFF THE VEHICLE AND ALL IT'S PARTS WITH A Z VEL.		 *
* A1 = NEW VELOCITY							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CARZVEL
	MMTM	SP,A0,A6,A13
	ADDI	ETEMP1,A13
	MOVK	NPARTS,A6
CADZV1
	MOVE	*A13+,A0,L
	JRZ	CADZV2
	MOVE	A1,*A0(OZVEL),L
CADZV2
	DSJS	A6,CADZV1
	MOVE	A8,A0
	JRZ	CADZV3
	MOVE	A1,*A0(OZVEL),L
CADZV3
	MOVE	A1,*A10(OZVEL),L
	MOVE	*A10(OSHAD),A0,L
	JRZ	CADZV4
	MOVE	A1,*A0(OYVEL),L
	MOVE	A1,*A0(OZVEL),L
CADZV4
	MMFM	SP,A0,A6,A13
	RETS

**************************************************************************
*                                                                        *
* CARSTOP - STOP A VEHICLE AND ALL IT'S PARTS, TAKES CARE OF KILLING	 *
* 	  THE WHEEL SPINNERS						 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE							 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CARSTOP
	PUSH	A1
	CALLR	KILLCARP		;IN CASE THERE'S ANY
	CLR	A1
	CALLR	CARYZVEL
	CALLR	CARXVEL
	CALLR	CWHLSTOP		;STOP THE WHEEL PROCS
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* CXACCEL - START VEHICLE X ACCELERATION PROCESS. IT WILL		 *
* 	  TAKE CARE OF FLIPPED VEHICLES					 *
* A8 = PTR TO DRIVER							 *
* A9 = ABS(ACCELERATION FACTOR/TICK), 32 BITS				 *
* A10 = PTR TO VEHICLE							 *
* A11 = ABS(TERMINAL VELOCITY), 32 BITS					 *
* A13 = PTR TO CAR PROCESS						 *
* RETURNS:								 *
* A0 = PTR TO PROC. (= 0 IF FAILED)					 *
* A9 = VALUE PASSED							 *
* A11 = VALUE PASSED							 *
* Z BIT SET IF IT FAILED					 	 *
*                                                                        *
**************************************************************************
CXACCEL
	MMTM	SP,A1,A7
	MOVE	*A10(OFLAGS),A1,W	
	BTST	B_FLIPH,A1
	JREQ	CACCEL1
	NEG	A11
	NEG	A9
CACCEL1
	CALLR	KILLCARP
	CREATE	INDPID,CXAPRIM
	JRZ	CACCELX
	MOVE	A13,*A0(PDATA),L
CACCELX
	MOVE	A0,*A13(ETEMP),L
	MMFM	SP,A1,A7
	RETS
**************************************************************************
*                                                                        *
* CXACCELA - START VEHICLE X ACCELERATION PROCESS WITH ABSOLUTE VALUES.	 *
* 	   THE VELOCITIES ARE TAKEN LITERALLY, NO CORRECTION FOR FLIP.	 *
* ALL PARAMETERS ARE THE SAME AS CXACCEL.				 *
*                                                                        *
**************************************************************************
CXACCELA
	MMTM	SP,A1,A7
	JRUC	CACCEL1
**************************************************************************
*                                                                        *
* CXACCELB - START VEHICLE X ACCELERATION BRAKING PROCESS, NO CORRECTION *
* SAME PARAMETERS AS CXACCEL						 *
*                                                                        *
**************************************************************************
CXACCELB
	MMTM	SP,A1,A7
	CALLR	KILLCARP
	CREATE	INDPID,CXAPRIMB
	JRZ	CACCELX
	MOVE	A13,*A0(PDATA),L
	JRUC	CACCELX

**************************************************************************
*                                                                        *
* CXAPRIM - PROCESS TO ACCELERATE A VEHICLE BY SOME CONSTANT.		 *
* A8 = PTR TO DRIVER							 *
* A9 = ACCELERATION FACTOR/TICK						 *
* A10 = PTR TO VEHICLE							 *
* A11 = TERMINAL VELOCITY, 32 BITS					 *
* *A13(PDATA) = PTR TO VEHICLE CONTROL PROCESS				 *
*                                                                        *
**************************************************************************
CXAPRIM
	MOVE	*A10(OXVEL),A1,L
	ADD	A9,A1
	MOVE	A11,B2
	MOVE	A1,B1
	SUB	B1,B2
	MOVE	A9,B1
	ABS	B1
	ABS	B2
	CMP	B1,B2
	JRLE	CXAPRIMX
	MOVE	A13,B0
	MOVE	*A13(PDATA),A13,L
	CALLR	CARXVEL
	MOVE	A13,A14
	MOVE	B0,A13
	CALLR	CWHLSPDS		;ADJUST WHEEL SPEED
	SLOOP	1,CXAPRIM
CXAPRIMX
	MOVE	A11,A1
	MOVE	A13,B0
	MOVE	*A13(PDATA),A13,L
	CALLR	CARXVEL
	CLR	A1
	MOVE	A1,*A13(ETEMP),L
	MOVE	A13,A14
	MOVE	B0,A13
	CALLR	CWHLSPDS		;ADJUST WHEEL SPEED
	DIE


**************************************************************************
*                                                                        *
* CXAPRIMB - PROCESS TO ACCELERATE A VEHICLE BY SOME CONSTANT.		 *
*	     WHEEL SPEED IS NOT UPDATED HERE.				 *
* A8 = PTR TO DRIVER							 *
* A9 = ACCELERATION FACTOR/TICK						 *
* A10 = PTR TO VEHICLE							 *
* A11 = TERMINAL VELOCITY, 32 BITS					 *
* *A13(PDATA) = PTR TO VEHICLE CONTROL PROCESS				 *
*                                                                        *
**************************************************************************
CXAPRIMB
	MOVE	*A10(OXVEL),A1,L
	ADD	A9,A1
	MOVE	A11,B2
	MOVE	A1,B1
	SUB	B1,B2
	MOVE	A9,B1
	ABS	B1
	ABS	B2
	CMP	B1,B2
	JRLE	CXBPRIMX
	MOVE	A13,B0
	MOVE	*A13(PDATA),A13,L
	CALLR	CARXVEL
	MOVE	B0,A13
	SLOOP	1,CXAPRIMB
CXBPRIMX
	MOVE	A11,A1
	MOVE	A13,B0
	MOVE	*A13(PDATA),A13,L
	CALLR	CARXVEL
	CLR	A1
	MOVE	A1,*A13(ETEMP),L
	MOVE	B0,A13
	DIE

**************************************************************************
*                                                                        *
* CWHLSTOP - KILL A VEHICLES WHEEL SPINNING PROCS IF THEY EXIST.	 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE MAIN						 *
* A13 = PTR TO VEHICLE PROCESS						 *
*                                                                        *
**************************************************************************
CWHLSTOP
	MMTM	SP,A0,A8,A11
	CLR	A11
	NOT	A11
	MOVE	*A13(ETEMP3),A8,L	;DO FRONT WHEEL
	JRZ	CWHLSTP1		;BR = NO OBJECT FOR THAT
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSTP1		;BR = NO SPINNING PROCESS
	CALLA	PUTA11
CWHLSTP1
	MOVE	*A13(ETEMP4),A8,L	;REAR WHEEL
	JRZ	CWHLSTP2		;BR = NO OBJECT
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSTP2		;BR = NO SPINNING PROC.
	CALLA	PUTA11
CWHLSTP2
	MMFM	SP,A0,A8,A11
	RETS
**************************************************************************
*                                                                        *
* KILLCARP - KILL THE MAIN VEHICLE BODY PROCESS, USUALLY ACCEL, AND	 *
* 	   DECEL PROCS.							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO PROCBLOC							 *
*                                                                        *
**************************************************************************
KILLCARP
	PUSH	A0
	MOVE	*A13(ETEMP),A0,L
	JRZ	KILLCRPX
	CALLA	KILL
	CLR	A0
	MOVE	A0,*A13(ETEMP),L
KILLCRPX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* CFLIPART - SET THE FLIP BITS OF ALL CAR PARTS ACCORDING TO		 *
* 	   THE MAIN BODY. THIS INCLUDES THE DRIVER.			 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO THE VEHICLE						 *
* A13 = PTR TO PROC BLOCK						 *
*                                                                        *
**************************************************************************
CFLIPART
	MMTM	SP,A0,A1,A4,A8,A13
	MOVE	*A10(OFLAGS),A4,W
	MOVE	A8,A0
	MOVE	A10,A8
	CALLA	GETANIXY
	MOVE	A2,B2
	MOVE	A3,B3
	TEST	A0
	JRZ	CFLIPP1
	CALLA	GANISAG			;RE-ADJUST DRIVER
CFLIPP1
	ADDI	ETEMP1,A13
	MOVK	NPARTS,A6
CFLIPP2
	MOVE	*A13+,A0,L
	JRZ	CFLIPP3
	MOVE	B2,A2
	MOVE	B3,A3
	CALLA	GANISAG			;RE-ADJUST PARTS
CFLIPP3
	DSJS	A6,CFLIPP2
	MMFM	SP,A0,A1,A4,A8,A13
	RETS

**************************************************************************
*                                                                        *
* CARTNKO - OPEN THE VEHICLES TRUNK, DOORS, ETC.			 *
* A13 = PTR TO PROC BLOCK						 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
CARTNKO
	MMTM	A12,A9,A11
	MOVE	*A13(ETEMP2),A11,L
	JRZ	CARTNKOX
	MOVE	*A13(EMAINT),A6,L
	MOVK	TRUNKOP,A0
	CALLA	GSCRIPT
CARTNKO1
	SWAP	A8,A11
	MOVK	4,A1
	JSRP	FRANIM
	SWAP	A8,A11
	JRC	CARTNKOX
	SLOOPR	A0,CARTNKO1		;LOOP SLEEP ON REGISTER
CARTNKOX
	MMFM	A12,A9,A11
	RETP

**************************************************************************
*                                                                        *
* CARTNKC - CLOZ THE VEHICLES TRUNK, DOORS, ETC.			 *
* A13 = PTR TO PROC BLOCK						 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
CARTNKC
	MMTM	A12,A9,A11
	MOVE	*A13(ETEMP2),A11,L
	JRZ	CARTNKCX
	MOVE	*A13(EMAINT),A6,L
	MOVK	TRUNKCL,A0
	CALLA	GSCRIPT
CARTNKC1
	SWAP	A8,A11
	MOVK	4,A1
	JSRP	FRANIM
	SWAP	A8,A11
	JRC	CARTNKCX
	SLOOPR	A0,CARTNKC1
CARTNKCX
	MMFM	A12,A9,A11
	RETP

**************************************************************************
*                                                                        *
* CRTURN - CADILLAC TURN RIGHT PLEASE					 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO BODY							 *
* A13 = PTR TO MASSIVE AUTO DATA STRUCTURE, SEE CADDY FOR DETAILS.	 *
* RETURNS:								 *
* A9 = POINTING TO THE WORD AFTER THE LAST PROCESSED ANIMATION SCRIPT    *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
CRTURN
	PUSHP	A11
	MOVE	A8,B0
	MOVE	*A13(ETEMP3),A8,L	;HANDLE FRONT WHEELS	
	JRZ	CRTURN2
	MOVE	*A13(EMAINT),A6,L
	CALLR	ISREVERS		;IS, IS, IS IT REVERSED
	JRC	CRTURN0
	MOVK	WHEELR,A0
	JRUC	CRTURN0A
CRTURN0
	MOVK	WHEELRR,A0
CRTURN0A
	CALLA	GSCRIPT
	MOVE	*A8(OPLINK),A0,L
	JRZ	CRTURN1
	MOVE	A9,B1
	CALLR	ANIMATCH
	JRZ	CRTURN2			;NO NEED TO CHANGE
	CALLA	GETA11
	JRNN	CRTURN2			;T'WILL ANIMATE ITSELF IN
	MOVE	*A9,A1,L
	JRNZ	CRTURN1			;O.K. TO ANIMATE CURRENT FRAME
	MOVE	B1,A9
CRTURN1
	MOVK	4,A1
	JSRP	FRANIM			;JUST STUFF THE NEW FRAME
CRTURN2
	MOVE	B0,A8
	JRZ	CRTURNX			;BR = NO DRIVER TO BEGIN WITH
	MOVE	*A13(EMAINT),A6,L
	MOVK	DRIVRYTE,A0
	CALLA	GSCRIPT			;GET US A SCRIPT
CRTURN3
	MOVE	*A13(EFLAGS),A0,L
	BTST	BDIE,A0
	JRNE	CRTURNX			;BR = THE DRIVER IS DEAD
	CLR	A1
	JSRP	FRANIM
	JRC	CRTURNX
	MOVE	A8,A8
	JRNZ	CRTURN3
CRTURNX
	PULLP	A11
	RETP	

**************************************************************************
*                                                                        *
* CLTURN - CADILLAC TURN LEFT PLEASE					 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO BODY							 *
* A13 = PTR TO MASSIVE AUTO DATA STRUCTURE, SEE CADDY FOR DETAILS.	 *
* RETURNS:								 *
* A9 = POINTING TO THE WORD AFTER THE LAST PROCESSED ANIMATION SCRIPT    *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
CLTURN
	PUSHP	A11
	MOVE	A8,B0
	MOVE	*A13(ETEMP3),A8,L	;HANDLE FRONT WHEELS	
	JRZ	CLTURN2
	MOVE	*A13(EMAINT),A6,L
	CALLR	ISREVERS		;IS, IS, IS IT REVERSED
	JRC	CLTURN0
	MOVK	WHEELL,A0
	JRUC	CLTURN0A
CLTURN0
	MOVK	WHEELLR,A0
CLTURN0A
	CALLA	GSCRIPT
	MOVE	*A8(OPLINK),A0,L
	JRZ	CLTURN1
	MOVE	A9,B1
	CALLR	ANIMATCH
	JRZ	CLTURN2			;NO NEED TO CHANGE
	CALLA	GETA11
	JRNN	CLTURN2			;ANIMATE YOUR HOLE
	MOVE	*A9,A1,L
	JRNZ	CLTURN1
	MOVE	B1,A9
CLTURN1
	MOVK	4,A1
	JSRP	FRANIM			;JUST STUFF THE NEW FRAME
CLTURN2
	MOVE	B0,A8
	JRZ	CLTURNX			;BR = NO DRIVER
	MOVE	*A13(EMAINT),A6,L
	MOVK	DRIVLEFT,A0
	CALLA	GSCRIPT			;GET THE SCRIPT
CLTURN3
	MOVE	*A13(EFLAGS),A0,L
	BTST	BDIE,A0
	JRNE	CLTURNX			;BR = THE DRIVER IS DEAD
	CLR	A1
	JSRP	FRANIM
	JRC	CLTURNX
	MOVE	A8,A8
	JRNZ	CLTURN3
CLTURNX
	PULLP	A11
DUMRETP
	RETP	

**************************************************************************
*                                                                        *
* CSTRAYTE - CADILLAC STRAIGHT AHEAD, WARP FACTOR 1, SCOTTY		 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO BODY							 *
* A13 = PTR TO MASSIVE AUTO DATA STRUCTURE, SEE CADDY FOR DETAILS.	 *
* RETURNS:								 *
* A9 = POINTING TO THE WORD AFTER THE LAST PROCESSED ANIMATION SCRIPT    *
* NOTE: CALL WITH JSRP, THIS ROUTINE ASSUMES THAT A9 WAS LEFT		 *
* 	POINTING TO THE CORRECT ANIMATION OF THE DRIVER RETURNING	 *
* 	TO A STRAIGHT POSITION.	IF A9 = 0 THEN ANIMATE NOTHING.		 *
*                                                                        *
**************************************************************************
CSTRAYTE
	PUSHP	A11
	MOVE	A8,B0
	MOVE	A9,B2
	MOVE	*A13(ETEMP3),A8,L	;HANDLE FRONT WHEELS	
	JRZ	CSTRAYT2
	MOVE	*A13(EMAINT),A6,L
	CALLR	ISREVERS
	JRC	CSTRAY0			;MAKE THEM REVERSE WHEELS
	MOVK	FRONTWHE,A0
	JRUC	CSTRAY0A
CSTRAY0
	MOVK	FRONTWR,A0
CSTRAY0A
	CALLA	GSCRIPT
	MOVE	*A8(OPLINK),A0,L
	JRZ	CSTRAYT1
	MOVE	A9,B1
	CALLR	ANIMATCH
	JRZ	CSTRAYT2		;NO NEED TO CHANGE
	CALLA	GETA11			;CHECK ANIMATION TIME
	JRNN	CSTRAYT2
	MOVE	*A9,A1,L
	JRNZ	CSTRAYT1
	MOVE	B1,A9
CSTRAYT1
	MOVK	4,A1
	JSRP	FRANIM			;JUST STUFF THE NEW FRAME
CSTRAYT2
	MOVE	B0,A8
	JRZ	CSTRAYX
	MOVE	B2,A9
	JRZ	CSTRAYX
CSTRAYT3
	MOVE	*A13(EFLAGS),A0,L
	BTST	BDIE,A0
	JRNE	CSTRAYX		;BR = THE DRIVER IS DEAD
	CLR	A1
	JSRP	FRANIM
	JRC	CSTRAYX
	MOVE	A8,A8
	JRNZ	CSTRAYT3
CSTRAYX
	PULLP	A11
	RETP	


**************************************************************************
*                                                                        *
* WHLSTR - VEHICLE WHEELS POINTED STRAIGHT AHEAD		 	 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO BODY							 *
* A13 = PTR TO MASSIVE AUTO DATA STRUCTURE, SEE CADDY FOR DETAILS.	 *
* RETURNS:								 *
* A9 = POINTING TO THE WORD AFTER THE LAST PROCESSED ANIMATION SCRIPT    *
*                                                                        *
**************************************************************************
WHLSTR
	MMTM	SP,A8,A11
	MOVE	*A13(ETEMP3),A8,L	;HANDLE FRONT WHEELS	
	JRZ	WHLSTRX
	MOVE	*A13(EMAINT),A6,L
	CALLR	ISREVERS
	JRC	WHLSTR0
	MOVK	FRONTWHE,A0
	JRUC	WHLSTR0A
WHLSTR0
	MOVK	FRONTWR,A0
WHLSTR0A
	CALLA	GSCRIPT
	MOVE	*A8(OPLINK),A0,L
	JRZ	WHLSTR1
	MOVE	A9,B1
	CALLR	ANIMATCH
	JRZ	WHLSTRX			;NO NEED TO CHANGE
	CALLA	GETA11
	JRNN	WHLSTRX			;BR = "AUTOMATIC" ANIMATION
	MOVE	*A9,A1,L
	JRNZ	WHLSTR1
	MOVE	B1,A9			;RESET TO TOP
WHLSTR1
	MOVK	4,A1
	JSRP	FRANIM			;JUST STUFF THE NEW FRAME
WHLSTRX
	MMFM	SP,A8,A11
	RETS	

**************************************************************************
*                                                                        *
* CR180PRM - SPIN THE VEHICLE 180 DEGREES RIGHT PRIMITIVE.		 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE MAIN						 *
* A13 = PTR TO PROC BLOCK						 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
CR180PRM
	MOVE	*A13(EMAINT),A6,L
	MOVE	*A10(OFLAGS),A1,W
	BTST	B_FLIPH,A1
	JRNE	CRYTE181	;BR = HE'S FLIPPED OUT
	MOVK	SPINFOR,A0
	JRUC	CR1800
CRYTE181
	MOVK	SPINFORF,A0
	JRUC	CR1800
*CL180PRM - SAME AS CR180PRM BUT IN THE OPPOSITE DIRECTION
CL180PRM
	MOVE	*A13(EMAINT),A6,L
	MOVE	*A10(OFLAGS),A1,W
	BTST	B_FLIPH,A1
	JRNE	CLEFT181	;BR = HE'S FLIPPED OUT
	MOVK	SPINREV,A0
	JRUC	CR1800
CLEFT181
	MOVK	SPINREVF,A0
CR1800
	MOVE	A0,B0
	MOVE	A10,A0
	CALLA	DELSHAD		;GET-RID-O-SHAD
	MOVE	B0,A0
	CALLA	GSCRIPT		;GET THE CORRECT SCRIPT
	MOVE	A8,A0
	JRZ	CR1801
	CALLA	OBJOFF
CR1801
	MOVE	A13,A14
	ADDI	ETEMP1,A14
	MOVK	NPARTS,A6
CR1802
	MOVE	*A14+,A0,L
	JRZ	CR1803
	CALLA	OBJOFF
CR1803	
	DSJS	A6,CR1802
CR1805
	SWAP	A8,A10
	MOVK	4,A1
	JSRP	FRANIM
	SWAP	A10,A8
	JRC	CR1805A
       	SLOOPR	A0,CR1805
CR1805A
	CALLR	CFLIPART	;FLIP ALL OF THE CAR PARTS

	MOVE	A8,A0
	JRZ	CR1806
	CALLA	OBJON
CR1806
	MOVE	A13,A14
	ADDI	ETEMP1,A14
	MOVK	NPARTS,A6
CR1807
	MOVE	*A14+,A0,L
	JRZ	CR1808
	CALLA	OBJON
CR1808	
	DSJS	A6,CR1807
	CALLR	CSHADST
	RETP

**************************************************************************
*                                                                        *
* CRYTE360 - TURN A VEHICLE 360 DEG. CLOCKWISE				 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* NOTE: CALL WITH JSRP							 *
*	A9 IS THRASHED							 *
*                                                                        *
**************************************************************************
CRYTE360
	JSRP	CRTURN
	PUSHP	A9

	JSRP	CR180PRM		;SPIN THIS DUDE
	JSRP	CL180PRM		;SPIN THIS DUDE

	JRUC	C360G
*CLEFT360 - SAME AS CRYTE360 EXCEPT COUNTERCLOCKWISE
CLEFT360
	JSRP	CLTURN
	PUSHP	A9

	JSRP	CL180PRM		;SPIN THIS DUDE
	JSRP	CR180PRM		;SPIN THIS DUDE
C360G
	PULLP	A9
	JSRP	CSTRAYTE
	CALLR	CZRESET
	RETP

**************************************************************************
*                                                                        *
* CRYTE180 - TURN A VEHICLE 180 DEG. CLOCKWISE				 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* NOTE: CALL WITH JSRP							 *
*	A9 IS THRASHED							 *
*                                                                        *
**************************************************************************
CRYTE180
	JSRP	CRTURN
	PUSHP	A9
	JSRP	CR180PRM		;SPIN THIS DUDE
	JRUC	C180G
*CLEFT180 - SAME AS CRYTE180 EXCEPT COUNTERCLOCKWISE
CLEFT180
	JSRP	CLTURN
	PUSHP	A9
	JSRP	CL180PRM		;SPIN THIS DUDE
C180G
	PULLP	A9
	JSRP	CSTRAYTE
	CALLR	CZRESET
	RETP


**************************************************************************
*                                                                        *
* CWHLSPD - ADJUST A VEHICLES WHEEL ANIMATION SPEED ACCORDING TO	 *
* 	  THE CURRENT X VELOCITY.					 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE MAIN						 *
* A13 = PTR TO VEHICLE PROCESS BLOCK					 *
*                                                                        *
**************************************************************************
CWHLSPD
	MMTM	SP,A0,A1,A6,A7,A8,A9,A11
	MOVE	*A10(OXVEL),A11,L
	JRZ	CWHLSPDA	
	SRA	16,A11
	JRNZ	CWHLSPD0
	INC	A11			;FRACTIONAL ALWAYS DOES THIS
	JRUC	CWHLSPD0
CWHLSPDA
	CALLR	CWHLSTOP		;XVEL = 0, STOP THE WHEELS
	MMFM	SP,A0,A1,A6,A7,A8,A9,A11
	RETS
CWHLSPD0
	MOVE	*A13(EMAINT),A6,L
	MOVI	INDPID,A1	;LOAD THESE PARAMS IN CASE WE MUST CREATE
	MOVI	ANIMATOR,A7	;INDEPENDANT ANIMATION PROCESS
	ABS	A11
	SUBK	8,A11
	JRLT	CWHLSPD1
	CLR	A11
CWHLSPD1
	ABS	A11
	MOVE	*A13(ETEMP3),A8,L
	JRZ	CWSPD2A			;BR = NO FRONT WHEEL
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSPD2		;BR = NO SPIN PROC
	CALLA	PUTA11			;PUT THE TIME
	JRUC	CWSPD2A
CWHLSPD2
	CALLR	ISREVERS
	JRC	CWSPD1A
	MOVK	FRONTWHE,A0
	JRUC	CWSPD1B
CWSPD1A
	MOVK	FRONTWR,A0
CWSPD1B
	CALLA	GSCRIPT
	CALLA	GETPRC			;START THE FRONT WHEEL SPIN PROC
	MOVE	A0,*A8(OPLINK),L
CWSPD2A
	CALLR	ISREVERS
	JRC	CWHLSPD4
	MOVK	REARWHEE,A0
	JRUC	CWHLSPD5
CWHLSPD4
	MOVK	REARWR,A0
CWHLSPD5
	CALLA	GSCRIPT
	MOVE	*A13(ETEMP4),A8,L
	JRZ	CWSPD3A			;BR = NO REAR WHEEL
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSPD3
	CALLR	ANIMATCH
	CALLA	PUTA11
	JRUC	CWSPD3A
CWHLSPD3
	CALLA	GETPRC		;REAR WHEEL SPIN PROC
	MOVE	A0,*A8(OPLINK),L
CWSPD3A
CWHLSPDX
	MMFM	SP,A0,A1,A6,A7,A8,A9,A11
	RETS

**************************************************************************
*                                                                        *
* CWHLSPDS - !SPECIAL! ADJUST A VEHICLES WHEEL ANIMATION SPEED		 *
* 		     ACCORDING TO THE CURRENT X VELOCITY.		 *
* 		     USE THIS WHEN CALLING FROM A SECONDARY PROCESS.	 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE MAIN						 *
* A14 = PTR TO VEHICLE PROCESS BLOCK					 *
*                                                                        *
**************************************************************************
CWHLSPDS
	MMTM	SP,A0,A1,A6,A7,A8,A9,A11
	MOVE	*A10(OXVEL),A11,L
	JRZ	CWHLSPSA	
	SRA	16,A11
	JRNZ	CWHLSPS0
	INC	A11			;FRACTIONAL ALWAYS DOES THIS
	JRUC	CWHLSPS0
CWHLSPSA
	SWAP	A13,A14
	CALLR	CWHLSTOP		;XVEL = 0, STOP THE WHEELS
	SWAP	A13,A14
	MMFM	SP,A0,A1,A6,A7,A8,A9,A11
	RETS

CWHLSPS0
	MOVE	*A14(EMAINT),A6,L
	MOVI	INDPID,A1	;LOAD THESE PARAMS IN CASE WE MUST CREATE
	MOVI	ANIMATOR,A7	;INDEPENDANT ANIMATION PROCESS
	ABS	A11
	SUBK	8,A11
	JRLT	CWHLSPS1
	CLR	A11
CWHLSPS1
	ABS	A11
	MOVE	*A14(ETEMP3),A8,L
	JRZ	CWSPS2A			;BR = NO FRONT WHEEL
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSPS2		;BR = NO SPIN PROC
	CALLA	PUTA11			;PUT THE TIME
	JRUC	CWSPS2A
CWHLSPS2
	CALLR	ISREVERS
	JRC	CWSPS1A
	MOVK	FRONTWHE,A0
	JRUC	CWSPS1B
CWSPS1A
	MOVK	FRONTWR,A0
CWSPS1B
	CALLA	GSCRIPT
	CALLA	GETPRC			;START THE FRONT WHEEL SPIN PROC
	MOVE	A0,*A8(OPLINK),L
CWSPS2A
	CALLR	ISREVERS
	JRC	CWHLSPS4
	MOVK	REARWHEE,A0
	JRUC	CWHLSPS5
CWHLSPS4
	MOVK	REARWR,A0
CWHLSPS5
	CALLA	GSCRIPT
	MOVE	*A14(ETEMP4),A8,L
	JRZ	CWSPS3A			;BR = NO REAR WHEEL
	MOVE	*A8(OPLINK),A0,L
	JRZ	CWHLSPS3
	CALLR	ANIMATCH
	CALLA	PUTA11
	JRUC	CWSPS3A
CWHLSPS3
	CALLA	GETPRC		;REAR WHEEL SPIN PROC
	MOVE	A0,*A8(OPLINK),L
CWSPS3A
CWHLSPSX
	MMFM	SP,A0,A1,A6,A7,A8,A9,A11
	RETS

**************************************************************************
*                                                                        *
* DRIVERAN - PROCESS TOTAL DRIVER ANIMATION SCRIPT. QUITS IF THE	 *
* 	   GUY DIED. PROC BLOCK MUST BE INITIALIZED AS AN ENEMY.	 *
* A8 = PTR TO OBJ							 *
* A9 = PTR TO SCRIPT							 *
* RETURNS								 *
* A9 = POINTING TO WORD AFTER SCRIPT					 *
* CARRY CLEAR = DIED							 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
DRIVERAN
	CLR	A1						 
	JSRP	FRANIM							 
	JRC	DRVRANX			;BR = THE ANIMATION IS DONE

	MOVE	*A13(EFLAGS),A0,L
	BTST	BDIE,A0
	JREQ	DRIVERAN		;BR = HE'S STILL ALIVE
	CLRC
DRVRANX
	RETP

**************************************************************************
*                                                                        *
* CZRESET - RESET ALL VEHICLE PART Z POSITIONS TO MATCH THE MAIN	 *
* 	  BODY.								 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
*                                                                        *
**************************************************************************
CZRESET
	MMTM	SP,A0,A11
	MOVE	*A10(OZVAL),A11,L	;GET THE CURRENT CAR Z VALUE
	DEC	A11	
	MOVE	*A13(ETEMP3),A0,L
	JRZ	CZRESET1
	MOVE	A11,*A0(OZVAL),L	;FRONT WHEEL = CAR Z - 1
CZRESET1
	MOVE	*A13(ETEMP4),A0,L
	JRZ	CZRESET2
	MOVE	A11,*A0(OZVAL),L	;REAR WHEEL = CAR Z - 1
CZRESET2
	ADDK	3,A11
	MOVE	*A13(ETEMP2),A0,L
	JRZ	CZRESET3
	MOVE	A11,*A0(OZVAL),L	;TRUNK = CAR Z + 2
CZRESET3
	MOVE	*A13(ETEMP1),A0,L
	JRZ	CZRESET5
	MOVE	A11,*A0(OZVAL),L	;WINDSHEILD = CAR Z + 2
CZRESET5
	DEC	A11
	MOVE	*A13(ETEMP5),A0,L
	JRZ	CZRESET6
	MOVE	A11,*A0(OZVAL),L	;ETEMP5 = CAR Z + 1
CZRESET6
	MOVE	*A13(ETEMP6),A0,L
	JRZ	CZRESET7
	MOVE	A11,*A0(OZVAL),L	;ETEMP6 = CAR Z + 1
CZRESET7
	MOVE	*A13(ETEMP7),A0,L
	JRZ	CZRESET8
	MOVE	A11,*A0(OZVAL),L	;ETEMP7 = CAR Z + 1
CZRESET8
	MOVE	*A13(ETEMP8),A0,L
	JRZ	CZRESETD
	MOVE	A11,*A0(OZVAL),L	;ETEMP8 = CAR Z + 1
CZRESETD
	MOVE	A8,A8
	JRZ	CZRESETX
	MOVE	A11,*A8(OZVAL),L	;DRIVER = CAR Z + 1
CZRESETX
	MMFM	SP,A0,A11
	RETS

**************************************************************************
*                                                                        *
* CARSETZ - SET Z POSITION OF VEHICLE ACCORDING TO THE REAR WHEEL,	 *
* 		THEN RESET THE REST TO MATCH THAT BAD DOG.		 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO VEHICLE							 *
* A13 = PTR TO PROC BLOC						 *
*                                                                        *
**************************************************************************
CARSETZ
	PUSH	A0
	MOVE	*A13(ETEMP4),A0,L	
	CALLA	SETZPOS
	MOVE	*A0(OZVAL),*A10(OZVAL),L
	MMFM	SP,A0
	JRUC	CZRESET

**************************************************************************
*                                                                        *
* CARADDY - ADD THIS AMOUNT TO THE Y VALUE OF ALL VEHICLE PARTS.	 *
* A1 = AMOUNT TO ADD 32 BITS						 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
*                                                                        *
**************************************************************************
CARADDY
	MMTM	SP,A0,A6,A11,A14
	MOVE	*A10(OYVAL),A11,L	;GET THE CURRENT CAR Y VALUE
	ADD	A1,A11
	MOVE	A11,*A10(OYVAL),L
	MOVE	A8,A0
	JRZ	CARYM1
	MOVE	*A0(OYVAL),A11,L
	ADD	A1,A11
	MOVE	A11,*A0(OYVAL),L
CARYM1
	MOVK	NPARTS,A6	
	MOVE	A13,A14
	ADDI	ETEMP1,A14
CARYM2
	MOVE	*A14+,A0,L
	JRZ	CARYM3
	MOVE	*A0(OYVAL),A11,L
	ADD	A1,A11
	MOVE	A11,*A0(OYVAL),L
CARYM3
	DSJS	A6,CARYM2
	MMFM	SP,A0,A6,A11,A14
	RETS

**************************************************************************
*                                                                        *
* CARSCRTST - TEST TO SEE IF A VEHICLE IS TOTALLY OFF THE SCREEN.	 *
* A8 = PTR TO DRIVER/PILOT/RANCHERO					 *
* A10 = PTR TO VEHICLE							 *
* A13 = PTR TO LOADED PROC BLOC						 *
* RETURNS:								 *
* Z BIT CLR = ALL OFF SCREEN						 *
* Z BIT SET = ALL/PART ON SCREEN					 *
*                                                                        *
**************************************************************************
CARSCRTST
	MMTM	SP,A6,A8,A14
	MOVE	A8,A8
	JRZ	CSTST1		;BR = NO DRIVER
	CALLA	SCRTST
	JRZ	CSTSTX		;BR = THIS GUYS ON SCREEN
CSTST1
	MOVE	A10,A8
	JRZ	CSTST2		;BR = NO VEHICLE?
	CALLA	SCRTST
	JRZ	CSTSTX		;BR = ON SCREEN
CSTST2
	MOVK	NPARTS,A6	;TEST 'DEM PARTS
	MOVE	A13,A14
	ADDI	ETEMP1,A14
CSTST3
	MOVE 	*A14+,A8,L
	JRZ	CSTST4
	CALLA	SCRTST
	JRZ	CSTSTX
CSTST4
	DSJ	A6,CSTST3
	MOVI	1,A6		;CLEAR THE Z BIT
CSTSTX
	MMFM	SP,A6,A8,A14
	RETS

**************************************************************************
*                                                                        *
* ISREVERS - DETERMINE IF A CAR IS TRAVELING IN REVERSE			 *
* A10 = PTR TO CAR							 *
* RETURNS:								 *
* 	CARRY CLR = FORWARD						 *
* 	CARRY SET = REVERSE						 *
*                                                                        *
**************************************************************************
ISREVERS
	MMTM	SP,A0,A4
	MOVE	*A10(OFLAGS),A4,W
	MOVE	*A10(OXVEL),A0,L
	JRZ	ISREVCLR		;NOT TRAVELING, DEFAULT IS FORWARD
	JRN	ISREV1
	BTST	B_FLIPH,A4
	JRNE	ISREVSET
ISREVCLR
	CLRC
	JRUC	ISREVX
ISREV1
	BTST	B_FLIPH,A4	
	JRNE	ISREVCLR
ISREVSET
	SETC
ISREVX
	MMFM	SP,A0,A4
	RETS
**************************************************************************
*                                                                        *
* ANIMATCH - ANIMATOR LOOP MATCH. TAKES A CURRENT ANIMATOR PROCESS 	 *
* 	   AND ATTEMPTS TO STICK A NEW SCRIPT IN. IT WILL MATCH		 *
* 	   THE FRAME #'S FOR SIMILAIR ANIMATIONS.			 *
* A0 = PTR TO ANIMATOR PROCESS						 *
* A9 = NEW ANIMATION SCRIPT						 *
* RETURNS								 *
* Z BIT SET = NO NEED TO CHANGE, CORRECT LIST IS IN PLACE		 *
* Z BIT CLR = A9 IS THE PTR TO MATCHING ANIMATION FRAME			 *
*                                                                        *
**************************************************************************
ANIMATCH
	MMTM	SP,A1,A2,A3
	MOVE	*A0(PSPTR),A1,L
	ADDI	0A0H,A1
	MOVE	*A1,A2,L		;GET THE SCRIPT LOOP POINT
	CMP	A2,A9
	JREQ	ANIMATX
	MOVE	A9,A3
	CALLA	GETA9
	SUB	A2,A9			;FROM AN OFFSET
	MOVE	A9,A2
	MOVE	A3,A9
	MOVE	A9,*A1,L		;RE-STUFF AS LOOP POINT
	ADD	A2,A9			;OFFSET RIGHT INTO THAT SUCKER
	CALLA	PUTA9
	MOVE	A9,A9			;CLEAR Z BIT
ANIMATX
	MMFM	SP,A1,A2,A3
	RETS
**************************************************************************
*                                                                        *
* FINDMVP - FIND YOUR MASTER VEHICLE PROCESS,				 *
* 	   IF YOUR'RE PART OF A VEHICLE CONTAINED IN THE ETEMP1-6 AREA.	 *
* A0 = OBJECT PTR.							 *
* RETURNS:								 *
* 	Z BIT SET = NO MATCH WAS FOUND, A0 = 0				 *
* 	Z BIT CLR = MATCH FOUND, A0 = PTR TO PROCESS			 *
*                                                                        *
**************************************************************************
FINDMVP
	MMTM	SP,A1,A2,A3,A6,A14
	MOVE	A0,A1
	MOVI	CADEPID,A3
	SRL	4,A3			;WE'RE ONLY CONCERNED WITH THESE
	MOVI	ACTIVE,A0		;GET THE PROCESS LIST
FINDMVPL
	MOVE	*A0,A0,L
	JRZ	FINDMVPX		;BR = WE'RE DONE
	MOVE	*A0(PROCID),A2,W
	SRL	4,A2
	CMP	A3,A2
	JRNE	FINDMVPL		;BR = NOT A MASTER VEHICLE PROCESS
	MOVK	NPARTS,A6 		;CHECK ALL THE ETEMP AREAS
	MOVE	A0,A14
	ADDI	ETEMP1,A14
FINDMVP2
	MOVE	*A14+,A2,L	
	CMP	A2,A1
	JREQ	FINDMVPF
	DSJS	A6,FINDMVP2
	JRUC	FINDMVPL
FINDMVPF
	MOVE	A0,A0			;CLR Z FLAG
FINDMVPX
	MMFM	SP,A1,A2,A3,A6,A14
	RETS

**************************************************************************
*                                                                        *
* CSHADST - VEHICLE SHADOW START, FUDGED FOR CARS			 *
* A10 = PTR TO VEHICLE							 *
* RETURNS:								 *
* A0 = SHADOW, 0 IF NO SHADOW WAS CREATED				 *
* 	Z BIT REFELCTS A0						 *
*                                                                        *
**************************************************************************
CSHADST
	RETS			;SHADOWS HAVE BEEN CANNED
	MMTM	SP,A1,A2
	SWAP	A10,A8			;START SHADOW ON MAIN BODY
	CALLA	SHADST
	CALLA	DFRMGRND		;Z IS SET ACCORDING TO WHEELS BY NOW
	SWAP	A10,A8
	MOVE	A0,A0
	JRZ	CSHADSTX	
	MOVE	*A0(OYPOS),A2,W
	SUB	A1,A2			;FUDGE THE Y POSITION
	MOVE	A2,*A0(OYPOS),W
	MOVE	A0,A0
CSHADSTX
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* CRESET - POSITION ALL PARTS WITH RESPECT TO THE MAIN ANIMATION POINT.	 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO CAR PROCESS						 *
* ETEMP1-8 = PART POINTERS						 *
*                                                                        *
**************************************************************************
CRESET
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
	MMTM	SP,B0,B1,B2
	MOVE	*A10(OIMG),A1,L
	MOVE	*A10(OSIZE),A2,L
	MOVE	*A10(OFLAGS),A4,W
	CALLA	GANIOF				;GET THE CAR ANIMATION PNT.
	MOVE	*A10(OXVAL),A3,L
	MOVE	*A10(OYVAL),A5,L
	ADD	A6,A3
	ADD	A7,A5				;SET THE PRECEDENT

	MOVE	A3,B0
	MOVE	A5,B1				;COPY HERE FOR PROCESSING
	MOVE	A8,A8
	JRZ	CRESET1				;BR = NO DRIVER
	MOVE	*A8(OIMG),A1,L
	MOVE	*A8(OSIZE),A2,L
	MOVE	*A8(OFLAGS),A4,W
	CALLA	GANIOF
	SUB	A6,A3	
	SUB	A7,A5
	MOVE	A3,*A8(OXVAL),L
	MOVE	A5,*A8(OYVAL),L			;STUFF NEW DRIVER COORDS.
CRESET1
	MOVE	A13,A14
	ADDI	ETEMP1,A14			;GO FOR THE PARTS
	MOVK	NPARTS,B2			;ALL SIX OF THEM	  	
CRESET2
	MOVE	*A14+,A0,L			;GET A NEW PART
	JRZ	CRESET3				;BR = NO PART TO BE FOUND
	MOVE	*A0(OIMG),A1,L
	MOVE	*A0(OSIZE),A2,L
	MOVE	*A0(OFLAGS),A4,W
	CALLA	GANIOF
	MOVE	B0,A3
	MOVE	B1,A5				;RESTORE REFERENCE PNT.
	SUB	A6,A3	
	SUB	A7,A5
	MOVE	A3,*A0(OXVAL),L
	MOVE	A5,*A0(OYVAL),L			;STUFF NEW PART COORDS.
CRESET3
	DSJS	B2,CRESET2
	MOVE	*A10(OSHAD),A0,L
	JRZ	CRESET4				;BR = NO SHADOW TO RESET
	MOVE	A10,A0
	CALLA	DELSHAD
	CALLR	CSHADST				;RESET THE SHADOW
CRESET4
	MMFM	SP,B0,B1,B2
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
	RETS


**************************************************************************
*                                                                        *
* CFRAGGED - CHECK TO SEE IF THE CAR AND IT'S CONSTITUENTS ARE NOT	 *
*		TOGETHER.						 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO CAR PROCESS						 *
* ETEMP1-8 = PART POINTERS						 *
* RETURNS:								 *
*	NE = FRAGMENTED	(SHOULD RESET AS SOON AS POSSIBLE)		 *
*	EQ = ALL TOGETHER (DON'T FUCK WITH IT, IT'S NOT BROKEN.)	 *
*                                                                        *
**************************************************************************
CFRAGGED
	MMTM	SP,A2,A3,A4,A5,A6,A8,A14
	SWAP	A10,A8
	CALLA	GETANIXY
	SWAP	A10,A8
	MOVE	A2,A4
	MOVE	A3,A5				;SET A PRECEDENT

	MOVE	A8,A8
	JRZ	CFRAGGED1			;BR = NO DRIVER
	CALLA	GETANIXY
	CMP	A2,A4
	JRNE	CFRAGGEDX
	CMP	A3,A5
	JRNE	CFRAGGEDX
CFRAGGED1
	MOVE	A13,A14
	ADDI	ETEMP1,A14			;GO FOR THE PARTS
	MOVK	NPARTS,A6			;ALL SIX OF THEM	  	
CFRAGGED2
	MOVE	*A14+,A8,L			;GET A NEW PART
	JRZ	CFRAGGED3			;BR = NO PART TO BE FOUND
	CALLA	GETANIXY
	CMP	A2,A4
	JRNE	CFRAGGEDX
	CMP	A3,A5
	JRNE	CFRAGGEDX
CFRAGGED3
	DSJS	A6,CFRAGGED2
	CLR	A6				;SET Z BIT 
CFRAGGEDX
	MMFM	SP,A2,A3,A4,A5,A6,A8,A14
	RETS

**************************************************************************
*                                                                        *
* CKCRESET - CHECK TO SEE IF IT'S TIME TO RESET, VIA THE TIMER STORED	 *
* 	   IN ERESET.							 *
* A8 = PTR TO DRIVER							 *
* A10 = PTR TO CAR							 *
* A13 = PTR TO CAR PROCESS						 *
* ETEMP1-8 = PART POINTERS						 *
*                                                                        *
**************************************************************************
CKCRESET
	PUSH	A0
	MOVE	*A13(ERESET),A0,W	;GET TIME 'TIL NEXT RESET
	CMPI	3CH,A0			;IS IT TIME?
	JRLO	CKNORST			;BR = NO, IT'S NOT.
	CALLR	CFRAGGED
	JREQ	CKNOFRAGS		;NOT FRAGMENTED, DON'T RESET IT
	CALLR	CRESET
CKNOFRAGS
	CLR	A0
CKNORST
	INC	A0			;KICK IT
	MOVE	A0,*A13(ERESET),W
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* SINKCARC - SINK THE VEHICLE CARCASS INTO THE GROUND			 *
* A8 = PTR TO VEHICLE CARCASS						 *
*                                                                        *
**************************************************************************
SINKCARC
	SLEEP	10
	MOVI	[1,1],A9
	JSRP	OSINK
	MOVE	A8,A10			;GET OBJECT DESCRIPTOR
	CALLR	DELCBODY 		;DELETE CAR BODY OBJECT AND QUIT
	DIE

	.END
