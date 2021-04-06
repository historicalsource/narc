	.FILE	'NARC1A.ASM'
	.TITLE	" <<< NARC GENERAL PURPOSE SUBROUTINES PART II >>>"

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
	.INCLUDE	"NARCAUDN.ASM"		;NARC Audit Equates
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates

*
*GLOBALS IN THIS FILE
	.GLOBAL	PPOSADDX,ESCAPEJ,INVINCO,INVINCNF,PXFERCRD,PFLYNDIE
	.GLOBAL	PFLASH2,PLEGOFF,PLAYERCON,PIJDECEL,PDELETE,PLEGON,PLEGOFF
	.GLOBAL	PTORSON,BUYINWIN,BOTHPON,GAMEOTXT,DUMPWTCH,AUDPLWAV,AUD1
	.GLOBAL	STRNGLEN,FLYTOPL,BUYINLP,BWAITCLD
*
*EXTERNALS
	.GLOBAL	CR_CONTP,OUTMBIGS,BTIME

	.BSS	XPALRAM,256*16		;RAM FOR FADE PALETTE XFERS
	.BSS	BTIMERST,16		;BUY-IN TIMER RESET FLAG

	.EVEN
	.TEXT

**************************************************************************
*                                                                        *
* MUSICSYN - WATCH FOR THE SYNC BEAT FROM THE SOUND BOARD AND		 *
* 	   INCREMENT RAM.						 *
* I.D. = MSYNPID							 *
*                                                                        *
**************************************************************************
MUSICSYN
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	KILALL
	CLR	A0
	MOVE	A0,@BEATCNT,W
MSYN1
	MOVE	@SWITCH,A0,L
	BTST	26,A0
	JREQ	MUSICINC	
	SLOOP	1,MSYN1
MUSICINC
	MOVE	@BEATCNT,A0,W
	INC	A0
	MOVE	A0,@BEATCNT,W
	SLOOP	4,MSYN1

**************************************************************************
*                                                                        *
* XPALETTE - PALETTE INTENSITY MULTIPLIER				 *
* A1 = XFACTOR								 *
* A2 = PTR TO ROM PALETTE						 *
* A3 = CURRENT PALETTE ALLOCATION #					 *
* A4 = STARTING COLOR #							 *
* A5 = ENDING COLOR #							 *
*                                                                        *
**************************************************************************
XPALETTE
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8
	MOVE	*A2+,A6,W		;GET THE COLOR COUNT
	CLR	A8			;INCREMENTAL COUNTER
	MOVI	XPALRAM,A7		;GET THE RAM
XPALET1
	MOVE	*A2+,A0,W
	CMP	A4,A8
	JRLO	XPJUSTUF		;BELOW LOWER BOUND
	CMP	A5,A8
	JRHI	XPJUSTUF		;ABOVE UPPER BOUND
	CALLR	XCOLOR			;MULTIPLY THIS GUY
XPJUSTUF
	MOVE	A0,*A7+,W
	INC	A8
	CMP	A6,A8
	JRLO	XPALET1			;BR = NOT DONE WITH MULTIPLY
	MOVI	XPALRAM,A0
	CLR	A1
	MOVE	A3,A1
	SLL	16,A1
	MOVE	A6,A2
	CALLA	PALSET			;SET UP THE XFER
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8
	RETS

**************************************************************************
*                                                                        *
* XCOLOR - COLOR VALUE MULTIPLIER					 *
* A0 = COLOR VALUE							 *
* A1 = X FACTOR (MSW:INTEGER LSW:FRACTION)				 *
* RETURNS								 *
* A0 = X COLOR VALUE							 *
*                                                                        *
**************************************************************************
XCOLOR
	MMTM	SP,A3,A4
	CLR	A4
	MOVE	A0,A3
	SLL	27,A3
	SRL	27,A3		;NOW I GOT 'DA BLUES
	MPYU	A1,A3
	SLL	11,A3
	SRL	27,A3
	OR	A3,A4
	MOVE	A0,A3
	SLL	22,A3
	SRL	27,A3		;GREENS
	MPYU	A1,A3
	SLL	11,A3		;STRIP GARBAGE
	SRL	27,A3
	SLL	5,A3
	OR	A3,A4
	MOVE	A0,A3
	SLL	17,A3
	SRL	27,A3		;NOW REDS
	MPYU	A1,A3
	SLL	11,A3
	SRL	27,A3
	SLL	10,A3
	OR	A3,A4
	MOVE	A4,A0
	MMFM	SP,A3,A4
	RETS
**************************************************************************
*                                                                        *
* AUTOEOFF - TURN OFF AUTO ERASE					 *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				 *
*                                                                        *
**************************************************************************
AUTOEOFF
	PUSH	A0
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ORI	AUTOERAS,A0  	;DISABLE AUTO ERASE
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* AUTOEON - TURN ON AUTO ERASE					 	 *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				 *
*                                                                        *
**************************************************************************
AUTOEON
	PUSH	A0
	 MOVE	@NOAUTOE,A0,W
	 JRNE	AUTOEON1	;BR = DEBUGGER MAN SAYS NO AUTOERASE
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ANDNI	AUTOERAS,A0  	;AUTO ERASE IS ENABLED LOW
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
AUTOEON1
	PULL	A0
	RETS

*
*MAKE AND OBJECT WITH Z INITIALIZATION
*RETURN(S)
*A0 = OBJECT BLOCK
MAKOBJZ
	CALLA	GETOBJ
	JRZ	MAKOBZX		;NONE LEFT
	CALLA	STFOBJ	
	CALLA	SETZPOS
	CALLA	INSOBJ
	MOVE	A0,A0		;RETURN NON-ZERO
MAKOBZX
	RETS

**************************************************************************
*                                                                        *
* COPYOBJ	- COPIES THE CONTENTS OF ONE OBJECT BLOCK TO THE OTHER.	 *
* A0 = PTR TO DESTINATION BLOCK						 *
* A8 = PTR TO SOURCE BLOCK						 *
*                                                                        *
**************************************************************************
COPYOBJ
	MMTM	SP,A0,A6,A8
	MOVI	OBSIZ,A6,W	;GET THE SIZE OF THE BLOCK IN WORDS
	ADDI	64,A0
	ADDI	64,A8		;DON'T COPY THE LINKS
	SRL	4,A6		;DIVIDE BY 16		
	SUBK	4,A6		;SUBTRACT TO ACCOUNT FOR THE 1st TWO LINKS
COPYOBJL
	MOVE	*A8+,*A0+,W	;MOVE A WORD
	DSJS	A6,COPYOBJL
	MMFM	SP,A0,A6,A8
	PUSH	A6		;KLUDGE TO ZERO MISPLACED LINKS
	CLR	A6
	MOVE	A6,*A0(OSHAD),L
	PULL	A6
	RETS


**************************************************************************
*                                                                        *
* STRINGER - OUTPUT A TEXT STRING, THIS IS A PROCESS!			 *
* A0  = SLEEP TIME BETWEEN CHARACTERS					 *
* A4  = DMA CONTROL							 *
* A6  = COLOR (16 BITS)							 *
* A8  = PTR TO STRING							 *
* A9  = [Y,X] SCREEN ADDRESS OF STRING					 *
* A10 = [Y,X] SPACING							 *
* A11 = POINTER TO FONT TABLE						 *
* A14 = FLAGS - INSERT:JUSTIFY						 *
*	BIT 16 = 1 INSERT ON OBJECT LIST, 0 JUST QUEUE THE DMA		 *
*	JUSTIFY = 0 LEFT JUSTIFY					 *
*		  1 CENTER JUSTIFY					 *
*		  2 RIGHT JUSTIFY					 *
* RETURNS:								 *
* A8 = POINTS TO NEXT BYTE AFTER STRING TERMINATOR			 *
* A9 = NEXT CURSOR POSITION AFTER THE STRING				 *
* NOTE: CALL WITH JSRP							 *
*                                                                        *
**************************************************************************
*
*STRING ENTRYPOINT, LEFT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST 
STRLNRM
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACNZ,A4
	CLR	A14
	JRUC	STRINGR1
*
*STRING ENTRYPOINT, CENTER JUSTIFY, NORMAL, NOT ON THE OBJECT LIST
STRCNRM
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACNZ,A4
	MOVK	1,A14
	JRUC	STRINGR1
*
*STRING ENTRYPOINT, RIGHT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST 
STRRNRM
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACNZ,A4
	MOVK	2,A14
	JRUC	STRINGR1
*
*STRING ENTRYPOINT, LEFT JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
STRLINV
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACZ,A4
	CLR	A14
	JRUC	STRINGR1
*
*STRING ENTRYPOINT, CENTER JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
STRCINV
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACZ,A4
	MOVK	1,A14
	JRUC	STRINGR1

*
*STRING ENTRYPOINT, LEFT JUSTIFY, NORMAL, OBJECT LIST 
STRLNRMO
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACNZ,A4
	MOVI	10000H,A14
	JRUC	STRINGR1
*
*STRING ENTRYPOINT, CENTER JUSTIFY, NORMAL, OBJECT LIST
STRCNRMO
	MMTM	A12,A1,A4,A6,A14
	MOVI	DMACNZ,A4
	MOVI	10001H,A14
	JRUC	STRINGR1

STRINGER
	MMTM	A12,A1,A4,A6,A14
STRINGR1
	MOVE	A6,A5
	SLL	16,A5		;SETUP CONSTANT COLOR IN FIXED PALETTE

	CLR	A7
	MOVX	A14,A7
	DEC	A7
	JRN	STRINGR2	;NORMAL LEFT JUSTIFY
	JREQ	STRINGRC
*RIGHT JUSTIFY
	CALLR	STRNGLEN	;GET THE STRING LENGTH
	JRUC	STRINGRA
*CENTER JUSTIFY
STRINGRC
	CALLR	STRNGLEN
	SRL	1,A7		;STRNGLEN/2
STRINGRA
	SUBXY	A7,A9		;ADJUST STRING STARTING POSITION
STRINGR2
	MOVB	*A8,A7		;GET A CHARACTER
	SLL	24,A7
	SRL	24,A7		;MAKE SURE WE'RE POSITIVE
	JREQ	STRINGRX	;BR = STRING BE GONE BROTHA

	ADDK	8,A8		;NEXT BYTE

	PUSH	A0

	CMPI	20H,A7
	JRNE	STRNCHAR	;BR = IT'S KOSH BABY 

	MOVK	5,A7		;HARD CODE A SPACE
	ADDXY	A7,A9		;AND ADD IT IN
	ADDXY	A10,A9		;ADD SPACING
	PULL	A0
	JRUC	STRINGR2	;DON'T SLEEP ON A SPACE, IT LOOKS STUPID!!!

STRNCHAR
	MMTM	SP,A2,A3,A4,A10,A14

	MOVE	A11,A1		;ESCAPE TO THE OTHER SIDE

	SUBI	21H,A7		;GET A BASE
	SLL	5,A7
	ADD	A7,A1
	MOVE	*A1,A1,L	;LOAD THE ADDRESS OF THE IMAGE HEADER
	CALLA	GSAGOF
	CALLA	GANIOF
	
	BTST	16,A14
	JREQ	STRNQDMA	;BR = DO NORMAL DMA OF STRING

*CREATE THE CHARACTER AS AN OBJECT, HERE
	CALLA	GETOBJ
	JREQ	STRNGDUN	;BR = NO OBJECT

	MOVE	A1,*A0(OIMG),L
	MOVE	A5,*A0(OPAL),L
	MOVE	A0,A14
	ADDI	OSIZE+20H,A14	
	MMTM	A14,A2,A3,A4	;STUFF VITAL SHIT
	CLR	A14
	ADDI	OZVEL+20H,A0
	MOVK	6,A4
STRNGOL
	MOVE	A14,-*A0,L
	DSJS	A4,STRNGOL		;ZERO OUT THE VELS & POSITIONS
	SUBI	64,A0			;BACK TO NORMAL

	MOVI	TEXTOID,A14
	MOVE	A14,*A0(OID),W		;STUF A FINDABLE I.D.

	MOVE	A9,A14
	MOVE	A14,*A0(OXPOS),W
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W	;STUFF POSITIONS
	MOVI	7FFF000AH,A14
	MOVE	A14,*A0(OZVAL),L	
	CALLA	ADJSTWTL		;PUT US IN THE WORLD
	CALLA	INSOBJ			;STUFF THIS SHEEEEEEET
	JRUC	STRNGDUN

*SIMPLY DMA THE SUCKER, HERE
STRNQDMA
	MOVE	A1,A10
	MOVE	A5,A1		;CONSTANT:PALETTE
	MOVE	A4,A5		;OFFSET:CONTROL
	MOVE	A3,A4		;SAG

	CLR	A14
	MOVY	A9,A14
	CLR	A3
	MOVX	A9,A3
	SRL	16,A6
	SUBXY	A6,A3
	SUBXY	A7,A14		;MOVE TO CORRECT POSITION
	MOVY	A14,A3		;A3 = DAG
	CALLA	DMAN
	MOVE	A1,A5
	MOVE	A10,A1
STRNGDUN
	MOVE	*A1(ISIZE),A6,W	;GET THE VISIBLE HORIZONTAL SIZE
	MMFM	SP,A2,A3,A4,A10,A14

	ADDXY	A6,A9		;GET TO THE OTHER SIDE
	ADDXY	A10,A9
	MOVE	*SP+,A0,L
	JREQ	STRINGR2	;BR = NO SLEEP
	MMTM	A12,A0,A4,A5,A14
	CALLA	PRCSLP
	MMFM	A12,A0,A4,A5,A14
	JRUC	STRINGR2
STRINGRX
	ADDK	8,A8		;GET TO THE NEXT BYTE
	MMFM	A12,A1,A4,A6,A14
	RETP

**************************************************************************
*                                                                        *
* STRNGLEN - RETURNS THE LENGTH, IN PIXELS, OF A GIVEN STRING		 *
* A8 = PTR TO STRING							 *
* A10 = [Y,X] SPACING OF STRING						 *
* A11 = PTR TO FONT TABLE						 *
* RETURNS:								 *
* A7 = LENGTH OF STRING							 *
* Z BIT SET IF LENGTH IS ZERO						 *
*                                                                        *
**************************************************************************
STRNGLEN
	MMTM	SP,A8,A14
	CLR	A14
	MOVB	*A8,A7
	SLL	24,A7
	SRL	24,A7		;MAKE SURE WE'RE POSITIVE
	JREQ	STRNLENX
STRNLEN
	ADDK	8,A8		;POINT TO NEXT
	CMPI	20H,A7
	JRNE	STRNLEN1	;BR = IT'S NOT A SPACE 
	MOVK	5,A7		;HARD CODE A SPACE
	JRUC	STRNLEN2
STRNLEN1
	SUBI	21H,A7		;GET A BASE
	SLL	5,A7
	ADD	A11,A7		;A7 = PTR TO CORRECT CHARACTER HEADER
	MOVE	*A7,A7,L
	MOVE	*A7(ISIZE),A7,W	;GET THE ACTUAL X LENGTH
STRNLEN2
	ADDXY	A7,A14		;ADD DIGIT LENGTH
	MOVX	A10,A7
	ADDXY	A7,A14		;ADD SPACE LENGTH
	MOVB	*A8,A7
	SLL	24,A7
	SRL	24,A7		;MAKE SURE WE'RE POSITIVE
	JRNE	STRNLEN		;NEXT CHARACTER
STRNLENX
	MOVE	A14,A7		;PASS RETURN VALUE IN A7
	MMFM	SP,A8,A14
	RETS

**************************************************************************
*                                                                        *
* HEXTOASC - CONVERTS A 32 BIT HEX # TO AN ASCII STRING TERMINATED	 *
* 	   BY 0								 *
* A8 = HEX #								 *
* RETURNS:								 *
* A8 PTR TO THE STRING							 *
*                                                                        *
**************************************************************************
HEXTOASC
	MMTM	SP,A1,A2,A9
	CLR	A1
	CLR	A2			;COMMA COUNT
	MOVE	A1,-*SP,W		;HERE'S THE NULL TERMINATOR
        MOVK	10,A1			;DIVISOR FOR DECIMAL
	MOVE	A8,A9
HEXTASC2
	CLR	A8
	DIVU	A1,A8
	ADDI	'0',A9			;MAKE THE REMAINDER ASCII
	MOVE	A9,-*SP,W		;SAVE HERE
	MOVE	A8,A9
	JRZ	HEXTASC3		;BR = DONE!
	INC	A2
	CMPI	3,A2			;COMMA CHECK 	
	JRLO	HEXTASC2		;BR = NO COMMA
	MOVI	',',A2
	MOVE	A2,-*SP,W		;STUFF A COMMA
	CLR	A2
	JRUC	HEXTASC2
HEXTASC3
	MOVI	STRNGRAM,A1		;STORE HERE FOR BLOW OUT        
	MOVE	A1,A8

HEXTASC4
	MOVE	*SP+,A9,W
	MOVB	A9,*A1
	ADDK	8,A1
	MOVE	A9,A9
	JRNZ	HEXTASC4
	MMFM	SP,A1,A2,A9
        RETS

**************************************************************************
*                                                                        *
* PPOSADDX - ADD LONG KONSTANT TO PLAYER X POSITION.			 *
* A0 = 32 BIT KONSTANT							 *
* A4 = PTR TO PLAYER LEGS						 *
* A8 = PTR TO PLAYER TORSO						 *
*                                                                        *
**************************************************************************
PPOSADDX
	MMTM	SP,A1,A2,A3,A5,A6,A7,A14
	PUSHST
	DINT
	MOVE	*A8(OXVAL),A1,L
	MOVE	*A4(OXVAL),A2,L
	MOVE	*A8(OSHAD),A3,L
	MOVE	*A3(OXVAL),A6,L
	MOVE	*A4(OSHAD),A5,L
	MOVE	*A5(OXVAL),A7,L
	POPST
	ADD	A0,A1
	ADD	A0,A2
	ADD	A0,A6
	ADD	A0,A7
	MOVE	A1,*A8(OXVAL),L
	MOVE	A2,*A4(OXVAL),L
	MOVE	A3,A3
	JREQ	PPADDX1
	MOVE	A6,*A3(OXVAL),L
PPADDX1
	MOVE	A5,A5
	JREQ	PPADDX2
	MOVE	A7,*A5(OXVAL),L
PPADDX2
	MMFM	SP,A1,A2,A3,A5,A6,A7,A14
	RETS

**************************************************************************
*                                                                        *
* ESCAPEJ - ESCAPE FROM THE CAR BY WAY OF THE JUMP BUTTON		 *
* A11 = PLINDX								 *
*                                                                        *
**************************************************************************
ESCAPEJ
	CMPI	P1DATA,A11
	JRNE	ESCAPP2
	MOVI	P1CTRL,A11
	JRUC	ESCAPEJ1
ESCAPP2
	MOVI	P2CTRL,A11
ESCAPEJ1
	MOVE	 *A11,A0,W
	ORI	PJUMP,A0
	MOVE	A0,*A11,W
	SLEEP	12
	MOVE	*A11,A0,W
	ANDNI	PJUMP,A0
	MOVE	A0,*A11,W
	DIE
**************************************************************************
*                                                                        *
* INVINCO - THE PLAYER INVINCIBLE EFFECT				 *
*	     THIS PROCESS WILL SET AND CLEAR THE INVINCIBLE FLAG.	 *
* A8  = PTR TO OBJECT BLOCK OF PART 1					 *
* A9  = PTR TO PLAYER DATA BLOCK					 *
* A10 = ITERATION COUNT							 *
* A11 = PTR TO OBJECT BLOCK OF PART 2					 *
*                                                                        *
**************************************************************************
INVINCO
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRZ	INVINCA			;BR = NO OTHER INVINCO PROCESS
       	MOVE	A10,A1
	CALLA	GETA10
	ADD	A1,A10			;JUST TACK ON SOME MORE TIME
	CALLA	PUTA10			;AND STUFF IT
	DIE
INVINCA
	MOVE	*A9(PEXEFLAG),A0,W
	ORI	MINVINC,A0
	MOVE	A0,*A9(PEXEFLAG),W	;SET THE FLAGS
INVINCO1
	MOVE	A9,A2
	CALLA	PLAYEROF
	SLEEP	1
	MOVE	A9,A2
	CALLA	PLAYERON
	SLEEP	3
	DSJ	A10,INVINCO1
	MOVE	*A9(PEXEFLAG),A0,W
	ANDNI	MINVINC,A0
	MOVE	A0,*A9(PEXEFLAG),W	;SORRY BUDDY
	DIE
*
*INVINCNF - SAME AS INVINCO, BUT WITH NO PLAYER FLASHY
* A8  = PTR TO OBJECT BLOCK OF PART 1
* A9  = PTR TO PLAYER DATA BLOCK     
* A10 = ITERATION COUNT		     
* A11 = PTR TO OBJECT BLOCK OF PART 2
INVINCNF
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRZ	INVINCNA		;BR = NO OTHER INVINCO PROCESS
       	MOVE	A10,A1
	CALLA	GETA10
	ADD	A1,A10			;JUST TACK ON SOME MORE TIME
	CALLA	PUTA10			;AND STUFF IT
	DIE
INVINCNA
	MOVE	*A9(PEXEFLAG),A0,W
	ORI	MINVINC,A0
	MOVE	A0,*A9(PEXEFLAG),W	;SET THE FLAGS
INVINCN1
	SLEEP	4
	DSJ	A10,INVINCN1
	MOVE	*A9(PEXEFLAG),A0,W
	ANDNI	MINVINC,A0
	MOVE	A0,*A9(PEXEFLAG),W	;SORRY BUDDY
	DIE

**************************************************************************
*                                                                        *
* PXFERCRD - XFER CARDS TO OTHER ACTIVE PLAYER				 *
* A2 = PTR PLAYER DOING THE XFERING					 *
*                                                                        *
**************************************************************************
PXFERCRD
	RETS
**************************************************************************
*                                                                        *
* 	MMTM	SP,A0,A1,A2,A3						 *
* 	CMPI	P1DATA,A2						 *
* 	JRNE	PXFER21							 *
* 	MOVI	P2DATA,A3						 *
* 	JRUC	PXFERNOW						 *
* PXFER21								 *
* 	MOVI	P1DATA,A3						 *
* PXFERNOW								 *
* 	MOVE	*A2(PCARDS),A0,L					 *
* 	MOVE	*A3(PCARDS),A1,L					 *
* 	ADD	A0,A1							 *
* 	MOVE	A1,*A3(PCARDS),L					 *
* 	CLR	A0							 *
* 	MOVE	A0,*A2(PCARDS),L					 *
* 	MOVE	*A2(PCARDS1),A0,L					 *
* 	MOVE	*A3(PCARDS1),A1,L					 *
* 	ADD	A0,A1							 *
* 	MOVE	A1,*A3(PCARDS1),L					 *
* 	CLR	A0							 *
* 	MOVE	A0,*A2(PCARDS1),L					 *
* *XFER MR. BIG KILLS ALSO						 *
* 	MOVE	*A2(PMBIGS),A0,W					 *
* 	MOVE	*A3(PMBIGS),A1,W					 *
* 	ADD	A0,A1							 *
* 	MOVE	A1,*A3(PMBIGS),W					 *
* 	CLR	A0							 *
* 	MOVE	A0,*A2(PMBIGS),W					 *
* 									 *
* 	CALLA	OUTCARDS		;SHOW THIS GUYS CARDS OR LACK TH *
* 	CALLA	OUTMBIGS						 *
* 	MOVE	A3,A2							 *
* 	CALLA	OUTCARDS		;SHOW THE OTHER GUYS ADDED CARDS *
* 	CALLA	OUTMBIGS						 *
* 	MMFM	SP,A0,A1,A2,A3						 *
* 	RETS								 *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* PDROPALL - DROP ALL OF THE PLAYERS CARDS AND SHIT			 *
* A2 = PTR TO PLAYER DATA STRUCTURE					 *
* A8 = PTR TO PLAYER OBJECT						 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
* PDROPALL								 *
* 	MMTM	SP,A0,A4,A5,A6,A7,A9,A14				 *
* 	MOVI	CARDCOLD,A7		;THIS IS THE PROCESS TO CREATE	 *
* 	MOVE	*A8(OXPOS),A5,W						 *
* 	MOVE	*A8(OYPOS),A6,W						 *
* 	SLL	16,A6							 *
* 	MOVY	A6,A5							 *
* 	CLR	A6							 *
* 	MOVI	00100000H|CARDOID,A14					 *
* 									 *
* 	MOVB	*A2(PSCARD),A4		;GET THE # SILVER CARDS		 *
* 	JREQ	DRPS1A2							 *
* 	ORI	SILVER,A14						 *
* DRPS1A1								 *
* 	CALL	A7							 *
* 	ADDI	20,A5							 *
* 	DSJS	A4,DRPS1A1						 *
* 	MOVB	A4,*A2(PSCARD)						 *
* DRPS1A2								 *
* 	MOVB	*A2(PBCARD),A4		;GET THE # OF BLUE CARDS	 *
* 	JREQ	DRPS1A4							 *
* 	SRL	4,A14							 *
* 	SLL	4,A14							 *
* 	ORI	BLUE,A14						 *
* DRPS1A3								 *
* 	CALL	A7							 *
* 	ADDI	20,A5							 *
* 	DSJS	A4,DRPS1A3						 *
* 	MOVB	A4,*A2(PBCARD)						 *
* DRPS1A4								 *
* 	MOVB	*A2(PRCARD),A4		;GET THE # OF RED CARDS		 *
* 	JREQ	DRPS1A6							 *
* 	SRL	4,A14							 *
* 	SLL	4,A14							 *
* 	ORI	RED,A14							 *
* DRPS1A5								 *
* 	CALL	A7							 *
* 	ADDI	20,A5							 *
* 	DSJS	A4,DRPS1A5						 *
* 	MOVB	A4,*A2(PRCARD)						 *
* DRPS1A6								 *
* 	MOVB	*A2(PGCARD),A4		;GET THE # OF GOLD CARDS	 *
* 	JREQ	DRPS1A8							 *
* 	SRL	4,A14							 *
* 	SLL	4,A14							 *
* 	ORI	GOLD,A14						 *
* DRPS1A7								 *
* 	CALL	A7							 *
* 	ADDI	20,A5							 *
* 	DSJS	A4,DRPS1A7						 *
* 	MOVB	A4,*A2(PGCARD)						 *
* DRPS1A8								 *
* 	MOVB	*A2(PGRCARD),A4		;GET THE # OF GOLD CARDS	 *
* 	JREQ	DRPS1AA							 *
* 	SRL	4,A14							 *
* 	SLL	4,A14							 *
* 	ORI	GREEN,A14						 *
* DRPS1A9								 *
* 	CALL	A7							 *
* 	ADDI	20,A5							 *
* 	DSJS	A4,DRPS1A9						 *
* 	MOVB	A4,*A2(PGRCARD)						 *
* DRPS1AA								 *
* 	CALLA	OUTCARDS						 *
* 	MMFM	SP,A0,A4,A5,A6,A7,A9,A14				 *
* 	RETS								 *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* SLOWPCAR - SLOW THE PLAYER'S CAR DOWN BY A CONSTANT, SWITCHED PROC.	 *
*                                                                        *
**************************************************************************
SLOWPCAR
	MOVE	@PLAYCAR,A10,L
	JRZ	SLOWPDI			;NO CAR, NO SLOW DOWN
	MOVE	*A10(OPLINK),A0,L
	JRZ	SLOWPDI			;BR = NO CONTROL
	MOVE	A13,A14
	MOVE	A0,A13			;PROC BLOK PTR HERE
	CALLA	GETA8			;GET THE DRIVER PTR
	MOVE	*A10(OXVEL),A1,L	;FUCK WITH X VELOCITY
	JRZ	SLOWPSWP		;BR = THERE WASN'T ANY
	JRN	SLPCBAD			;BR = NEGATIVE SO ADD TO REDUCE	
	SUBI	[0,7FFFH],A1
	JRNN	SLPCBSX			;BR = DIDN'T CHANGE SIGNS
	CLR	A1			;ZERO IN THIS CASE
	JRUC	SLPCBSX
SLPCBAD
	ADDI	[0,7FFFH],A1
	JRN	SLPCBSX			;DIDN'T SWITCH TO POSITIVE
	CLR	A1
SLPCBSX
	CALLA	CARXVEL
SLOWPSWP
	MOVE	A14,A13
SLOWPDI
	DIE

**************************************************************************
*                                                                        *
* POUTOFRK - PLAYER OUT OF ROCKETS SOUND PROCESS			 *
*                                                                        *
**************************************************************************
POUTOFRK
	SOUND1	OUTOROCK		;SOUND OFF
	DIE

OUTOROCK .WORD	>F3A0,>01,>80A7,0	;OUT OF ROCKETS SOUND

**************************************************************************
*                                                                        *
* PFLYNDIE - MAKE THE PLAYER FLY THROUGH THE AIR AND FLAIL HELPLESSLY	 *
* A2 = PLAYER DATA AREA							 *
* A8 = PTR TO TORSO							 *
* A11 = PTR TO LEGS							 *
* NOTE: CALL WITH JSRP, MAKE SURE ALL RELEVANT PLAYER FLAGS ARE SET.	 *
*                                                                        *
**************************************************************************
PFLYNDIE
	MOVE	*A2(PIRQFLAG),A0,W
	BTST	BDRIVER,A0
	JREQ	PFLYND1
*PLAYER IS DRIVING, LET'S VAULT HIM OUT OF THE CAR
	MOVE	@PUPDATE,A1,W
	MOVK	1,A3
	MOVE	A3,@PUPDATE,W
	MOVE	*A2(PIRQFLAG),A0,W
	ANDNI	MDRIVER|MSITIN,A0
	MOVE	A0,*A2(PIRQFLAG),W
	MOVE	A1,@PUPDATE,W

	MOVE	*A8(OSHAD),A0,L
	JRNZ	PFLYND0			;BR = SHADOW ALREADY EXISTS
	CALLA	SHADST2			;RE-START TORSO SHADOW
PFLYND0
	MOVE	*A11(OSHAD),A0,L
	JRNZ	PFLYND0A
	SWAP	A11,A8	
	CALLA	SHADST			;RE-START LEG SHADOW
	SWAP	A11,A8
PFLYND0A
	CALLR	PCAROYZ
	NEG	B2			;NEGATE THE Z VELOCITY

	MOVE	@PLAYCAR,A0,L		;GET THE CAR
	JRZ	PFLYND2

	MOVE	*A0(OZMINUS),A1,W
	MOVE	*A0(OZPOS),A14,W
	SUB	A1,A14
	SUBK	20,A14
***	MOVE	@PLZMIN,A1,W
***	CMP	A1,A14
***	JRGE	PFLYND0B
***	MOVE	A1,A14
***PFLYND0B
	MOVE	A14,*A8(OZPOS),W
	
	MOVE	*A0(OPLINK),A0,L
	JRZ	PFLYND2			;WIERDNESS, NO PROC
	MOVE	A8,B0
	CLR	A8
	CALLA	PUTA8			;ZERO OUT THE DRIVER POINTER			
	MOVE	B0,A8
	JRUC	PFLYND2	
PFLYND1
	MOVE	*A2(PIRQFLAG),A0,W	;RELOAD FOR SAFETY
	BTST	BPASSEN,A0
	JREQ	PFLYND1C

	MOVE	@PUPDATE,A1,W
	MOVK	1,A3
	MOVE	A3,@PUPDATE,W
	MOVE	*A2(PIRQFLAG),A0,W
	ANDNI	MPASSEN|MSITIN,A0
	MOVE	A0,*A2(PIRQFLAG),W
	MOVE	A1,@PUPDATE,W

	MOVE	*A8(OSHAD),A0,L
	JRNZ	PFLYND1A		;BR = SHADOW ALREADY EXISTS
	CALLA	SHADST2			;RE-START TORSO SHADOW
PFLYND1A
	MOVE	*A11(OSHAD),A0,L
	JRNZ	PFLYND1B
	SWAP	A11,A8	
	CALLA	SHADST			;RE-START LEG SHADOW
	SWAP	A11,A8
PFLYND1B
	CALLR	PCAROYZ
	MOVE	@PLAYCAR,A0,L		;GET THE CAR
	JRZ	PFLYND2

	MOVE	*A0(OZPLUS),A1,W
	MOVE	*A0(OZPOS),A14,W
	ADD	A1,A14
	ADDK	5,A14
***	MOVE	@PLZMAX,A1,W
***	CMP	A1,A14
***	JRLE	PFLYND1B0
***	MOVE	A1,A14
***PFLYND1B0
	MOVE	A14,*A8(OZPOS),W

	MOVE	*A0(OPLINK),A0,L
	JRZ	PFLYND2			;WIERDNESS, NO PROC
	CLR	A1
	MOVE	A1,*A0(PASSPTR),L	;CLEAR THE PASSENGER PTR
	JRUC	PFLYND2
PFLYND1C
	CALLA	GETYZVEL		;GET THE MEGA LEGA EXPLODING VEL
	ABS	B3
	CMPI	[6,0],B3
	JRLS	PFLYND2			;O.K. UP VEL, DO IT BABY
	MOVI	[6,0],B3
PFLYND2
	MOVE	A11,A4			;GOT TO HAVE THIS MAAHN
	CALLA	PLEGOFF
	MOVE	A11,A0
	MOVI	PLAYERS,A1
	CALLA	ISSUPP
	JRZ	PFLYND3			;BR = ALREADY OFF YOU NIT WIT
	CALLA	DELSUPP			;RID O' LEGS
PFLYND3
	NEG	B3			;GO UP
	ADD	B2,B3			;MAKE IT REALISTIC
	MOVE	A8,B0
	MOVE	B2,*B0(OZVEL),L
	MOVE	B3,*B0(OYVEL),L

	MOVI	PFLAIL,A9
	PUSHP	A11
PFLYND4
	MOVK	4,A1
	JSRP	FRANIM
	JRC	PFLYND7			;THE END WAS HIT
	MOVE	A0,A11
PFLYND5
	SLEEP	1
	MOVE	*A8(OYVEL),A3,L		;GET THE CURRENT Y VELOCITY
	MOVE	*A8(OZVEL),A2,L
	SUB	A2,A3
	JRLE	PFLYND6			;BR = NOT GOING DOWN, DON'T CHECK GROUND HIT

	CALLA	DFRMGRND		;DID HE HIT THE GROUND?
	JRLE	PFLYND8			;BR = YES

PFLYND6
	ADDI	GRAVITY,A3
	ADD	A2,A3
	MOVE	A3,*A8(OYVEL),L

	MOVE	*A8(OXVEL),A5,L
	JRNZ	PFLYND6A		;HE'S STILL MOVING IN X
	CALLA	GETANIX			;IF HE STOPPED IN X
	MOVE	@WORLDTLX+16,A5,W
	SUB	A5,A0			;MAKE THE ANIMATION PNT SCREEN REL
	CMPI	256,A0			;START HIM MOVING TOWARDS THE MIDDLE
	JRGT	PFLYND60
	MOVI	[1,0],A5		;MOVE RIGHT
	JRUC	PFLYND61
PFLYND60
	MOVI	[-1,0],A5		;MOVE LEFT
PFLYND61
	MOVE	A5,*A8(OXVEL),L

*CHECK FOR ZERO Z VEL
PFLYND6A
	MOVE	*A8(OZVEL),A5,L
	JRNZ	PFLYND6B		;HE'S STILL MOVING IN Z
	MOVE	*A8(OZPOS),A5,W		;NOW GET THE Z POSITION
	MOVE	@PLZMID,A0
	CMP	A0,A5
	JRLT	PFLYND6A0
	MOVI	[-1,0],A5
	JRUC	PFLYND6A1
PFLYND6A0
	MOVI	[1,0],A5	
PFLYND6A1
	MOVE	A5,*A8(OZVEL),L		;LET'S KEEP TRUCKIN'
	MOVE	*A8(OYVEL),A0,L
	ADD	A5,A0
	MOVE	A0,*A8(OYVEL),L

PFLYND6B
	DSJ	A11,PFLYND5		
	JRUC	PFLYND4
PFLYND7
	MOVI	PFLAIL,A9
	JRUC	PFLYND4
PFLYND8
	PULLP	A11
	MOVE	A11,A4
	CALLA	PLSTOP
	RETP
**************************************************************************
*                                                                        *
* PCAROYZ - GET SOME YZ VELOCITIES FOR GETTING OUSTED FROM THE CAR	 *
* RETURNS:								 *
* B2 = POSITIVE Z VEL							 *
* B3 = CORRECT Y VEL							 *
*                                                                        *
**************************************************************************
PCAROYZ
	PUSH	A0
	MOVI	[1,0],A0
	CALLA	SRAND
	ADDI	[3,0],A0
	MOVE	A0,B3
	NEG	B3
	MOVI	0800H,A0	
	CALLA	SRAND
	ADDI	18000H,A0
	MOVE	A0,B2
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* PFLASH2 - FLASH A PLAYER WITH A CONSTANT COLOR.			 *
* A11 = PTR TO PLAYER DATA STRUCTURE					 *
*                                                                        *
**************************************************************************
PFLASH2
	MOVI	0FFFFh,A0
	MOVE	*A11(POBJ),A1,L
	MOVE	A0,*A1(OCONST),W	;SELECT CONSTANT COLOR
	MOVE	*A11(PLOBJ),A1,L
  	MOVE	A0,*A1(OCONST),W	;FOR BOTH OBJECTS
PFLSH21
	MOVE	A11,A2
	CALLA	PLAYERCON		;CONSTANT ON
	SLEEP	2
	MOVE	A11,A2
	CALLA	PLAYERON		;NORMAL
	SLEEP	4
	JRUC	PFLSH21		

**************************************************************************
*                                                                        *
* PIJDECEL - DECELERATE A PLAYER DURING HIS GAMEPLAY INTRO		 *
* A9 = PTR TO PLAYER CONTROL LOCATION					 *
* A10 = PTR TO VEHICLE THAT PLACEHOLDER IS ABOARD			 *
* A11 = PTR TO PLAYER DATA BLK						 *
*                                                                        *
**************************************************************************
PIJDECEL
	MOVE	A11,A2
	MOVE	A9,A11
	MOVE	*A2(POBJ),A8,L
	MOVE	*A2(PLOBJ),A9,L
	MOVE	*A10(OXVEL),A10,L
	CMPI	[3,0],A10
	JRGT	PIJDEC1
	MOVI	[4,0],A10
	JRUC	PIJDEC2
PIJDEC1
	CMPI	[15,0],A10
	JRLT	PIJDEC2
	MOVI	[14,0],A10
PIJDEC2
	SLEEP	6
	MOVE	A10,*A8(OXVEL),L
	MOVE	A10,*A9(OXVEL),L
	MOVE	*A8(OYVEL),A3,L
	ADDI	[-2,0],A3
	MOVE	A3,*A8(OYVEL),L
	MOVE	A3,*A9(OYVEL),L
	SLEEP	4
PLJSLP
	SUBI	3000H,A10
	MOVE	*A8(OXVEL),A1,L
	ABS	A1
	CMPI	[2,1000H],A1
	JRLE	PLJDECX
	MOVE	A10,*A8(OXVEL),L
	MOVE	A10,*A9(OXVEL),L
	SLOOP	1,PLJSLP
PLJDECX
	MOVI	PRYTE,A0
	MOVE	A0,*A11,W
	SLEEP	16
	CLR	A0
	MOVE	A0,*A11,W
	DIE

**************************************************************************
*                                                                        *
* PLAYER DELETE ROUTINE							 *
* A2=PLINDX=PLAYER DATA STRUCTURE					 *
* RETURNS:								 *
* Z BIT SET = LAST PLAYER TO DIE					 *
* Z BIT CLR = ANOTHER PLAYER LEFT					 *
*                                                                        *
**************************************************************************
PDELETE:                   
	MMTM	SP,A0,A1,A4,A6,A8
	MOVI	PLAYERS,A1		;DELETE FROM THIS LIST
	MOVE	@NPLYRS,A6,W	
	DEC	A6			;DECREMENT NUMBER OF PLAYERS
	MOVE	A6,@NPLYRS,W
	MOVE	*A2(PLOBJ),A0,L		;GET THE LEGS
	JREQ	PDELETE1		;BR = NO LEGS
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	ORI	2,A4
	MOVE	A4,*A0(OFLAGS),W
	CALLA	DELSUPP
	MOVE	A6,A6
	JREQ	PDELETE1
	MOVE	A0,A8
	CREATE	0DFH,PLSINK
PDELETE1
	MOVE	*A2(POBJ),A0,L		;GET THE OBJECT BLOCK PTR
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	ORI	2,A4
	MOVE	A4,*A0(OFLAGS),W
	CALLA	DELSUPP
	MOVE	A6,A6
	JREQ	PDELETE2
	MOVE	A0,A8
	CREATE	0DFH,DSINK
****	CALLA	PDROPALL		;DROP ALL OF HIS CARDS
	CALLA	PXFERCRD		;XFER CARDS

	CLR	A0
	MOVE	A0,*A2(POBJ),L		;AND MAKE HIS OBJECT PTR NULL
	MOVE	A0,*A2(PLOBJ),L
	MOVE	*A2(PSCORE),A0,L
	CALLA	OUTSCR			;TURN OFF THE FLASH OF HIS SCORE


***	MOVI	INTR1OID|CBODYID,A0
***	MOVI	CARLIST,A1
***	CALLA	ISSUPPID
***	JRZ	PDELETE3		;BR = NO INTRO VEHICLE AROUND
***
***	MMTM	SP,A2,A3,A5,A14
***	MOVE	*A1(OPLINK),A5,L
***	CMPI	P2DATA,A2
***	JREQ	PDELTOT1
***	MOVI	P1TINIT,A14
***	CALLA	GPALOBJ
***	JRZ	PDELTOTX
***	MOVE	A0,*A5(PASSPTR),L	;STUFF THE PLAYER 1 PTR
***	MOVE	A5,*A0(OPLINK),L
***	MOVI	CARLIST,A14
***	JRUC	PDELTOT2
***PDELTOT1
***	MOVI	P2TINIT,A14
***	CALLA	GPALOBJ
***	JRZ	PDELTOTX
***	MOVE	A0,A8
***	MOVE	A5,A0
***	CALLA	PUTA8
***	MOVE	A8,A0
***	MOVE	A5,*A0(OPLINK),L
***	MOVI	ENEMIES,A14
***PDELTOT2
***	CALLA	STFOBJ
***	MOVE	A1,A8	
***	MOVE	*A8(OZPOS),A1,W
***	INC	A1
***	MOVE	A1,*A0(OZPOS),W
***	MOVE	*A8(OXVEL),*A0(OXVEL),L
***	MOVE	*A8(OYVEL),*A0(OYVEL),L
***	MOVE	*A8(OZVEL),*A0(OZVEL),L
***	CALLA	GETANIXY		;GET ROCKET APOINT POSITION
***	MOVE	*A8(OFLAGS),A4,W	;AND ROCKET FLAGS
***	CALLA	GANISAG			;ADJUST FOR NEW IMAGE AND POSS. FLIP
***	CALLA	INSOBJ			;PUT IT ON THE LIST
***	MOVE	A14,A1
***	CALLA	ADDSUPP			;O.K., WE'RE HAPPENING
***PDELTOTX
***	MMFM	SP,A2,A3,A5,A14

PDELETE3
	MOVE	A6,A6
	MMFM	SP,A0,A1,A4,A6,A8
	RETS
PDELETE2
	MOVE	A0,A4
	CLR	A0
	MOVE	A0,*A2(POBJ),L		;AND MAKE HIS OBJECT PTR NULL
	MOVE	*A2(PSCORE),A0,L
	CALLA	OUTSCR			;TURN OFF THE FLASH OF HIS SCORE
	MOVE	A4,*A2(POBJ),L
	JRUC	PDELETE3
*
*PLSINK - PLAYER LEG SINK,NO PALETTE DELETE
*A8 = PTR TO PLAYER LEG OBJECT
PLSINK
	MOVI	[1,1],A9
	JSRP	OSINK
	MOVE	A8,A0
	CALLA	DELSOBJ			;GET RID OF THIS THING
	JAUC	SUCIDE

**************************************************************************
*                                                                        *
* PLEGOFF - TURN THE PLAYERS LEGS AND SHADOW OFF			 *
* A2 = PTR TO PLAYER DATA BLOCK						 *
* A4 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
PLEGOFF
	MMTM	SP,A0,A1
	MOVE	*A4(OFLAGS),A0,W
	SRL	4,A0
	SLL	4,A0
	MOVE	A0,*A4(OFLAGS),W	;TURN OFF THE LEGS
	MOVE	*A4(OSHAD),A0,L
	JREQ	PLEGOFF1
	MOVE	*A0(OFLAGS),A1,W
	SRL	4,A1
	SLL	4,A1
	MOVE	A1,*A0(OFLAGS),W	;TURN OFF THE LEG SHADOW
PLEGOFF1
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* PLEGON - TURN THE PLAYERS LEGS AND SHADOW ON				 *
* A4 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
PLEGON
	MMTM	SP,A0,A1
	MOVE	*A4(OFLAGS),A0,W
	SRL	4,A0
	SLL	4,A0
	ADDK	2,A0
	MOVE	A0,*A4(OFLAGS),W	;TURN ON THE LEGS
	MOVE	*A4(OSHAD),A0,L
	JREQ	PLEGON1
	MOVE	*A0(OFLAGS),A1,W
	SRL	4,A1
	SLL	4,A1
	ADDK	8,A1
	MOVE	A1,*A0(OFLAGS),W	;TURN ON THE LEG SHADOW
PLEGON1
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* PTORSON - TURN THE PLAYERS TORSO AND SHADOW ON			 *
* A8 = PTR TO TORSO OBJECT						 *
*                                                                        *
**************************************************************************
PTORSON
	MMTM	SP,A0,A1
	MOVE	*A8(OFLAGS),A0,W
	SRL	4,A0
	SLL	4,A0
	ADDK	2,A0
	MOVE	A0,*A8(OFLAGS),W	;TURN ON THE TORSO
	MOVE	*A8(OSHAD),A0,L
	JREQ	PTORSON1
	MOVE	*A0(OFLAGS),A1,W
	SRL	4,A1
	SLL	4,A1
	ADDK	8,A1
	MOVE	A1,*A0(OFLAGS),W	;TURN ON THE LEG SHADOW
PTORSON1
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* BOTHPON - TURN BOTH PLAYERS ON IF ACTIVE				 *
*                                                                        *
**************************************************************************
BOTHPON
	MMTM	SP,A0,A2
	MOVI	P1DATA,A2
	MOVE	*A2(POBJ),A0,L
	JRZ	BOTHP2ON
	CALLA	PLAYERON
BOTHP2ON
	MOVI	P2DATA,A2
	MOVE	*A2(POBJ),A0,L
	JRZ	BOTHPXON
	CALLA	PLAYERON	
BOTHPXON
	MMFM	SP,A0,A2
	RETS

**************************************************************************
*                                                                        *
* TSHADST - CREATES A NEW PLAYER TORSO SHADOW IF NONE EXISTED.		 *
* A2 = PTR TO PLAYER DATA BLOCK						 *
*                                                                        *
**************************************************************************
TSHADST1		 		;PLAYER ONE ENTRY
	MOVI	P1DATA,A2
	JRUC	TSHADST
TSHADST2		 		;PLAYER TWO ENTRY
	MOVI	P2DATA,A2
TSHADST
	MOVE	*A2(POBJ),A8,L
	MOVE	*A8(OSHAD),A0,L
	JRNZ	TSHADSTX		;BR = SHADOW ALREADY EXISTS
	CALLA	SHADST2
TSHADSTX
	DIE

**************************************************************************
*                                                                        *
* LSHADST - CREATES A NEW PLAYER LEG SHADOW IF NONE EXISTED.		 *
* A2 = PTR TO PLAYER DATA BLOCK						 *
*                                                                        *
**************************************************************************
LSHADST1		 		;PLAYER ONE ENTRY
	MOVI	P1DATA,A2
	JRUC	LSHADST
LSHADST2		 		;PLAYER TWO ENTRY
	MOVI	P2DATA,A2
LSHADST
	MOVE	*A2(PLOBJ),A8,L
	JRZ	LSHADSTX
	MOVE	*A8(OSHAD),A0,L
	JRNZ	LSHADSTX		;BR = SHADOW ALREADY EXISTS
	CALLA	SHADST
LSHADSTX
	DIE

**************************************************************************
*                                                                        *
* TSHADDEL - DELETE THE PLAYER TORSO SHADOW.				 *
* A2 = PTR TO PLAYER DATA						 *
*                                                                        *
**************************************************************************
TSHADDL1
	MOVI	P1DATA,A2
	JRUC	TSHADDEL
TSHADDL2
	MOVI	P2DATA,A2
TSHADDEL
	MOVE	*A2(POBJ),A8,L
	MOVE	*A8(OSHAD),A0,L
	JRZ	TSHADDLX		;BR = NO SHADOW
	CALLA	DELOBJ
	CLR	A0
	MOVE	A0,*A8(OSHAD),L
TSHADDLX
	DIE

**************************************************************************
*                                                                        *
* LSHADDEL - DELETE THE PLAYER LEG SHADOW.				 *
* A2 = PTR TO PLAYER DATA						 *
*                                                                        *
**************************************************************************
LSHADDL1
	MOVI	P1DATA,A2
	JRUC	LSHADDEL
LSHADDL2
	MOVI	P2DATA,A2
LSHADDEL
	MOVE	*A2(PLOBJ),A8,L
	JRZ	LSHADDLX
	MOVE	*A8(OSHAD),A0,L
	JRZ	LSHADDLX		;BR = NO SHADOW
	CALLA	DELOBJ
	CLR	A0
	MOVE	A0,*A8(OSHAD),L
LSHADDLX
	DIE

**************************************************************************
*                                                                        *
* PCONTST - START PLAYER CONTINUATION MESSAGES, IF NECESSARY		 *
*                                                                        *
**************************************************************************
PCONTST
	PUSH	A2
	MOVI	P1DATA,A2
	CALLR	STRTCONT
	MOVI	P2DATA,A2
	CALLR	STRTCONT
	PULL	A2
	RETS
**************************************************************************
*                                                                        *
* STRTCONT - START A PLAYER'S CONTINUATION MESSAGE IF HE'S DEAD.	 *
* A2 = PLINDX								 *
*                                                                        *
**************************************************************************
STRTCONT
	MMTM	SP,A0,A1,A7,A11
	MOVE	*A2(POBJ),A0,L
	JREQ	STRTCNT1		;BR = NO PLAYER TO BE FOUND
	MOVE	*A2(PFLAGS),A0,L
	BTST	BBUYIN,A0
	JREQ	STRTCNTX		;BR = NOT BUY-IN TIME
STRTCNT1
	MOVE	A2,A11
	MOVE	*A2(PPID),A1
	ORI	PMPID,A1
	MOVI	PRESCONT,A7
	CALLA	GETPRC			;FLASH THE BUY-IN MESSAGE
STRTCNTX
	MMFM	SP,A0,A1,A7,A11
	RETS

**************************************************************************
*                                                                        *
* OWINDOW - OPEN A TEXT WINDOW, ON THE OBJECT LIST.			 *
* 		 ZVAL WILL BE = 7FFF0000H				 *
* A8 = WINDOW SIZE							 *
* A10 = CENTER POINT OF WINDOW (SCREEN RELATIVE)			 *
* RETURNS:								 *
* A8 = PTR WINDOW OBJECT						 *
* 	ZBIT SET = FAILURE TO CREATE					 *
* 	ZBIT CLR = WINDOW IS OPEN					 *
* NOTE: CALL WITH JSRP							 *
*	TRASHES A9,A10 & A11						 *
*                                                                        *
**************************************************************************
OWINDOW
	MOVI	WINDINIT,A14
	CALLA	GPALOBJ
	MOVE	A8,A11
	MOVE	A0,A8
	JRZ	OWINDOWX	;BR = FAILED MISERBLY
	CALLA	STFOBJ
	MOVE	A10,*A8(OXPOS),W	
	MOVY	A10,A1
	SRL	16,A1
	MOVE	A1,*A8(OYPOS),W
	MOVI	0101H,A1
	MOVE	A1,*A8(OCONST),W
	CALLA	ADJSTWTL	;ADJUST TO THE WORLD TOP LEFT
	CALLA	INSOBJ
	MOVE	*A8(OXPOS),A10,W
	MOVE	*A8(OYPOS),A0,W
	SLL	16,A0
	MOVY	A0,A10		;GET NEW WORLD COORDS.
	MOVE	A10,A0		;STORE HERE
	MOVY	A11,A1
	SRL	17,A1
	SLL	16,A1		;DIVIDE Y BY 2
	SLL	16,A11
	SRL	17,A11		;AND X
	MOVY	A1,A11
	SUBXY	A11,A10
	ADDXY	A0,A11
	MOVI	16,A0
	JSRP	OBJEXP32
	MOVE	A8,A8
OWINDOWX
	RETP

**************************************************************************
*                                                                        *
* CWINDOW - CLOSE A TEXT WINDOW, ON THE OBJECT LIST.			 *
* A8 = PTR TO WINDOW OBJECT						 *
* RETURNS:								 *
* 	WITH WINDOW OBJECT DELETED					 *
* NOTE: CALL WITH JSRP							 *
*	TRASHES A9,A10 & A11						 *
*                                                                        *
**************************************************************************
CWINDOW
	MOVE	*A8(OXPOS),A10,W
	MOVE	*A8(OYPOS),A11,W
	SLL	16,A11
	MOVY	A11,A10
	MOVE	*A8(OSIZE),A11,L
	MOVY	A11,A1
	SRL	17,A1
	SLL	16,A1
	SLL	16,A11
	SRL	17,A11
	MOVY	A1,A11
	ADDXY	A11,A10
	MOVE	A10,A11			;CALCULATED CENTER OF OBJECT
	MOVI	20,A0
	JSRP	OBJEXP32
	MOVE	A8,A0
	CALLA	DELPAL
	CALLA	DELOBJ
	RETP

**************************************************************************
*                                                                        *
* OBJEXP32 - SHRINK OR EXPAND AN OBJECT FROM THE CURRENT SIZE		 *
*	      TO THE GIVEN SIZE IN A GIVEN AMOUNT OF TICKS.		 *
* A0 = # OF TICKS							 *
* A8 = PTR TO OBJECT							 *
* A10 = NEW OBJTL							 *
* A11 = NEW OBJLR							 *
* NOTE: CALL WITH JSRP							 *
*	TRASHES A9							 *
*                                                                        *
**************************************************************************
OBJEXP32
	MOVE	*A8(OXPOS),A1,W
	MOVE	*A8(OYPOS),A14,W
	SLL	16,A14
	MOVX	A1,A14			;A14 = OBJECT UL

	SLL	16,A1
	CLR	A2
	MOVY	A14,A2
	SUBXY	A10,A14
	MOVX	A14,A5
	SLL	16,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A6
	CLR	A5
	MOVY	A14,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A7

	MOVE	*A8(OXPOS),A3,W
	MOVE	*A8(OYPOS),A14,W
	SLL	16,A14
	MOVX	A3,A14
	MOVE	*A8(OSIZE),A3,L
	ADDXY	A3,A14			;A14 = OBJECT LR

	PUSH	A8			;STACK OBJECT
	MOVX	A14,A3
	SLL	16,A3
	CLR	A4
	MOVY	A14,A4
	SUBXY	A11,A14
	MOVX	A14,A5
	SLL	16,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A8
	CLR	A5
	MOVY	A14,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A9
	MOVE	A0,A5
	PULL	A14			;KEEP OBJECT HERE
OBJTIMLP
	ADD	A6,A1			;ADD THE TLX INCREMENT
	ADD	A7,A2			;ADD THE TLY INCREMENT
	ADD	A8,A3			;ADD THE LRX INCREMENT
	ADD	A9,A4			;ADD THE LRY INCREMENT
	MMTM	A12,A1,A2,A3,A4,A5,A6,A7,A14
	MOVE	A1,*A14(OXVAL),L
	MOVE	A2,*A14(OYVAL),L
	SUB	A1,A3
	SUB	A2,A4			;GET A SIZE FOR THE WINDOW
	SRL	16,A3
	MOVY	A4,A3
	CALLR	FIXA3XY
	MOVE	A3,*A14(OSIZE),L
	SLEEP	1
	MMFM	A12,A1,A2,A3,A4,A5,A6,A7,A14
	DSJS	A5,OBJTIMLP
	MOVE	A10,*A14(OXPOS),W
	MOVY	A10,A1
	SRL	16,A1
	MOVE	A1,*A14(OYPOS),W
	MOVE	A11,A9
	SUBXY	A10,A11
	MOVE	A11,A3
	CALLR	FIXA3XY
	MOVE	A3,*A14(OSIZE),L	;MATCH WHAT THE CALLER WANTED
	MOVE	A9,A11			;PRESERVE FOR YUKS
	MOVE	A14,A8
	RETP

**************************************************************************
*                                                                        *
* FIXA3XY - CHECKS THE X AND Y COMPONENT OF A3, ANY ONE THAT IS ZERO	 *
* 		WILL BE SET TO ONE. KEEPS OSIZE IN ORDER.		 *
* A3 = [Y,X]								 *
*                                                                        *
**************************************************************************
FIXA3XY
	PUSH	A0
	CLR	A0
	MOVY	A3,A0
	MOVE 	A0,A0
	JRNZ	FA3YOK
	MOVK	1,A0
	SLL	16,A0
	MOVY	A0,A3
FA3YOK
	CLR	A0
	MOVX	A3,A0
	MOVE	A0,A0
	JRNZ	FA3XOK
	MOVK	1,A0
	MOVX	A0,A3
FA3XOK
	PULL	A0
	RETS

*INIT TABLE FOR WINDOW
WINDINIT
	.LONG	0,0,0,0,7FFF0000H,WINDOBJ,0,0					 
	.WORD	DMACAL,TEXTWOID,0,0
*INITIAL WINDOW OBJECT
WINDOBJ
	.WORD	1,1,0,0
	.LONG	02000000H,NARCS
	
**************************************************************************
*                                                                        *
* BUYINWIN - PUT UP THE BUY-IN WINDOW PROCESS				 *
* A10 = PTR TO PLAYER DATA CAUSING THIS					 *
*                                                                        *
**************************************************************************
BUYINWIN
	PUSHP	A10			;KEEP PLINDX 
	MOVI	[65+SKYTOPOF,255],A10
	MOVI	[120,230],A8
	JSRP	OWINDOW			;OPEN THE WINDOW
	JRZ	BUYINWDI		;COULDN'T DO IT
	SOUND1	BUYMUSIC
	CALLR	INIBTIME		;INITIALIZE BUY IN TIME
	CALLR	INIBMESS		;INITIALIZE BUY IN MESSAGE
	MOVK	1,A0
	MOVE	A0,@BUYNOW,W
PBUYOLP
	MOVI	BUYTICK,A11
PBUYILP
	MOVE	*A12,A2,L
	MOVE	*A2(PENERGY),A0,L
	JRGT	PBUYDONE
	MOVE	@NPLYRS,A0,W
	DEC	A0
	JRNZ	PBUYDONE		;OTHER GUY BOUGHT IN
	SLEEP	BUYSLP
	CALLR	UPBMESS1		;UPDATE BUYIN MESSAGE 1
	CALLR	UPBMESS2
	DSJS	A11,PBUYILP
	CALLR	DECBTIME		;DECREMENT BUYIN TIME
	JRGE	PBUYOLP			;WE ARE NOT DONE YET
*SOMEBODY JUST BOUGHT IN OR TIME IS UP
PBUYDONE
	CALLR	CLRBTIME
	CALLR	CLRBMESS
	SOUND1	BUYMOFF
	JSRP	CWINDOW
	CLR	A0
	MOVE	A0,@BUYNOW,W
BUYINWDI
	DIE


**************************************************************************
*                                                                        *
* BUYINLP - PUT UP THE BUY-IN WINDOW PROCESS AND LOOP BACK ON BUY-IN.	 *
* A10 = PTR TO PLAYER DATA CAUSING THIS					 *
*                                                                        *
**************************************************************************
BUYINLP
	PUSHP	A10			;KEEP PLINDX 
	MOVI	[65+SKYTOPOF,255],A10
	MOVI	[120,230],A8
	JSRP	OWINDOW			;OPEN THE WINDOW
	JRZ	BUYINLPDI		;COULDN'T DO IT
	SOUND1	BUYMUSIC
	CALLR	INIBTIME		;INITIALIZE BUY IN TIME
	CALLR	INIBMESS		;INITIALIZE BUY IN MESSAGE
*YES IT'S BUY-IN TIME AGAIN!
	MOVI	INGAME,A0
	MOVE	A0,@GAMSTATE,W		;TAKE US OUT OF GAME PLAY
	MOVI	IBUYINS,A0
	MOVE	A0,@P1DATA+PBUYINS,W
	MOVE	A0,@P2DATA+PBUYINS,W
	MOVK	1,A0
	MOVE	A0,@BUYNOW,W
BUYLPOLP
	MOVI	BUYTICK,A11
BUYLPILP
	MOVE	*A12,A2,L
	MOVE	*A2(PENERGY),A0,L
	JRGT	BUYLPBAK
	MOVE	@NPLYRS,A0,W
	DEC	A0
	JRNZ	BUYLPBAK		;OTHER GUY BOUGHT IN
	SLEEP	BUYSLP
	CALLR	UPBMESS1		;UPDATE BUYIN MESSAGE 1
	CALLR	UPBMESS2
	DSJS	A11,BUYLPILP
	CALLR	DECBTIME		;DECREMENT BUYIN TIME
	JRGE	BUYLPOLP		;WE ARE NOT DONE YET
*YOUR TIIIIIIIIIIIIIIME IS UP!
	CALLR	CLRBTIME
	CALLR	CLRBMESS
	SOUND1	BUYMOFF
	MOVI	INGAMEOV,A0
	MOVE	A0,@GAMSTATE,W
	JSRP	CWINDOW
	CLR	A0
	MOVE	A0,@BUYNOW,W
BUYINLPDI
	DIE
*
*SOMEBODY JUST BOUGHT IN
*IT IS TIME TO LOOP BACK TO THE BEGINNING
BUYLPBAK
	CLR	A0
	MOVE	A0,@BUYNOW,W
	AUDIT	AUDLOOP
	CALLR	CLRBTIME
	CALLR	CLRBMESS
	SOUND1	BUYMOFF
	JSRP	CWINDOW

	CALLA	KILLWAVE
	SOUND1	MUSICOFF
	SOUND1	YAMOFF

	CLR	A0
	MOVE	A0,@PUPDATE,W
	CLR	A9
	MOVE	A9,@IRQSKYE,W		;CLEAR AUTO-ERASE COLOR

	MOVK	1,A0
	MOVE	A0,@GAMERASE,W
	MOVI	SCRNMID,A10
	MOVI	SCRNMID,A11
	MOVI	20,A0
	JSRP	SCREXP32		;NOW GO THE CENTER
	CLR	A0
	MOVE	A0,@DISPLAYON,W
	CALLA	DMAQWAIT
	CALLA	MYOINIT
	MOVI	SCRNMID,A0
	MOVE	A0,@SCRNTL,L
	MOVE	A0,@SCRNLR,L
	CALLA	WRAMINIT		;INITIALIZE WAVE RAM

	MOVE	@LOOPWAVE,A0,W
	JRN	BLPCURR			;USE SAME WAVE

	MOVE	A0,@WAVE,W
	MOVE	@LOOPBACK,A10,L
	MOVE	@LOOPDISP,A7,L
	MOVE	*A10(0E0H),A6,L		;FIX THIS SOUND KLUDGE
	JRUC	BLPWWBK
BLPCURR
	MOVE	@WAVE,A0,W		;RELOAD CURRENT WAVE HERE
	DEC	A0
	SLL	28,A0
	SRL	23,A0
	MOVE	A0,A10
	ADDI	WAVEBGND,A10
	MOVE	*A10,A10,L
	MOVE	A0,A6
	ADDI	WAVMUSIC,A6
	MOVE	*A6,A6,L
	MOVI	MASTERDP,A7
BLPWWBK
	CALLA	GETWAVE			;SET UP WAVE DIFFICULTY PARAMS

	MOVK	1,A0
	MOVE	A0,@PUPDATE,W

	MOVE	A6,A0
	CALLA	ONESND			;START ROOM MUSIC

	MOVI	BAKSTAKS,A1
	MOVE	A1,@BAKSTAKP,L	;INITIALIZE BACKGROUND STACK POINTER

	MOVI	OBJSTAKS,A1
	MOVE	A1,@OBJSTAKP,L	;INITIALIZE OBJECT STACK POINTER

	CALLA	BBINIT
	CALLA	INITBGND
	MOVK	1,A0
	MOVE	A0,@DISPLAYON,W		;TURN THE DISPLAY PROC ON
*TIME TO RE-INITIALIZE PLAYER 1
	MOVI	P1DATA,A2
	CALLR	CLRPBODY
	MOVI	P1INITTL,A14
	CALLA	PLWAVEST
*TIME TO RESET PLAYER 2
	MOVI	P2DATA,A2
	CALLR	CLRPBODY
	MOVI	P2INITT,A14
	CALLA	PLWAVEST
	CALLA	SCORAREA		;OUTPUT THE SCORE AREA

	CLR	A0
	MOVE	A0,@PUPDATE,W

	MOVI	INPLAY,A0
	MOVE	A0,@GAMSTATE,W		;START YOUR ENGINES

	MOVI	MASTERID,A1		;A7 SHOULD BE LOADED ABOVE
	CALLA	GETPRC			;GET THE DISPATCH PROC

	CREATE	BUPDPID,BBOFSCRN	;CREATE THE BACKGROUND UPDATE PROCESS
	MOVK	32,A0
	MOVI	SCRNST,A10
	MOVI	SCRNEND,A11
	JSRP	SCREXP32		;BLOW UP THE SCREEN AGAIN
	SOUND1	ALLOFF
	SOUND1	YAMOFF
	MOVK	2,A0
	MOVE	A0,@GAMERASE,W		;TURN ON HALF SCREEN AUTOERASE
	CREATE	0BACH,BSCHKG		;START THE SCROLL CHECKER
	CREATE	BUYCPID,BUYWAIT		;CREATE THE BUY-IN WAIT
	DIE

**************************************************************************
*                                                                        *
* CLRPBODY - CLEAR THE PLAYER IF HIS DEAD BODY WAS HANGING AROUND.	 *
* 		I.E. POBJ STUFFED, NO LIFE, NO OBJECT			 *
* A2 = PLINDX								 *
*                                                                        *
**************************************************************************
CLRPBODY
	PUSH	A0
	MOVE	*A2(POBJ),A0,L
	JRZ	PBODCLRD		;NOBODY TO CLEAR
	MOVE	*A2(PLIVES),A0,W
	JRGT	PBODCLRD		;HE'S GOT LIFE
	MOVE	*A2(PENERGY),A0,L
	JRGT	PBODCLRD		;A LITTLE ENERGY LEFT
	CLR	A0
	MOVE	A0,*A2(POBJ),L		;O.K. WASTE HIM
	MOVE	A0,*A2(PLOBJ),L
	MOVE	@NPLYRS,A0,W
	DEC	A0	    		;A MUST TO KEEP IN PACE
	MOVE	A0,@NPLYRS,W
	CALLR	PXFERCRD		;TRANSFER ANY HELD CARDS
PBODCLRD
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* BWAITCLD - START THE BUYIN WAIT PROCESS, USED AS A COLD START BY	 *
* 		THE DISPATCHERS IN LOOP BACK POINTS.			 *
*                                                                        *
**************************************************************************
BWAITCLD
	MOVI	IBUYINS,A0		;MAKE SURE BUY-IN IS ACTIVE
	MOVE	A0,@P1DATA+PBUYINS,W
	MOVE	A0,@P2DATA+PBUYINS,W
	CREATE	BUYCPID,BUYWAIT	
	RETS

**************************************************************************
*                                                                        *
* BUYWAIT - WAIT AWHILE BEFORE CUTTING OFF BUYIN AGAIN			 *
*                                                                        *
**************************************************************************
BUYWAIT
	MOVE	*A13(PROCID),A0,W
	CLR	A1
	NOT	A1
	CALLA	KILALL			;KILL THE OTHER GOONS
	CLR	A8
	MOVI	BUYTICK*BUYTIME,A9
BUYWAITLP
***	CALLA	CR_CONTP	;ENOUGH TO CONTINUE
***	JRLO	BUYWAITS
***	MOVE	A8,A8
***	JRNZ	BUYWAITS	;WE'VE ALREADY RESET THE TIMER ONCE
***	MOVI	BUYTICK*BUYTIME,A9	;RESET THE WAIT TIMER
***	MOVK	1,A8		;AND FLAG IT
***BUYWAITS
	SLEEP	BUYSLP
	DSJ	A9,BUYWAITLP
	CALLA	CLRBUYIN	;CUT IF OFF AGAIN
***	CLR	A0		;CUT IT OFF AGAIN
***	MOVE	A0,@P1DATA+PBUYINS,W
***	MOVE	A0,@P2DATA+PBUYINS,W
	DIE

BUYMUSIC
	.WORD	>F3FE,>01,>8041,0
BUYMOFF
	.WORD	>F3FE,>01,>8042,0
**************************************************************************
*                                                                        *
* INIBMESS - INITIALIZE THE BUY IN MESSAGE				 *
*                                                                        *
**************************************************************************
INIBMESS
	MMTM	SP,A0,A1,A2,A6,A8,A9,A10,A11
	CALLA	CR_CONTP	;ENOUGH TO CONTINUE?
	JRLO	INIBMIN		;BR = NO
	MOVI	PRESSMSG,A8
	CLR	A0
	MOVE	A0,@BTIMERST,W
	JRUC	INIBM1
INIBMIN
	MOVI	INSRTMSG,A8
	MOVK	1,A0
	MOVE	A0,@BTIMERST,W
INIBM1
	CALLR	GWINCENT	;POSITION
	MOVE	A0,A2		;KEEP
	SUBI	[50,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9
	CLR	A0
	MOVI	0F0F0H,A6
	MOVI	RD20FONT,A11	;BIG OLD LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRMO       	;OUTPUT THE TIME
	MOVI	TEXTOID,A0
	MOVI	BMES1OID,A1
	CALLA	CHNGOID		;CHANGE THE OID

	MOVI	TOCONMSG,A8
	MOVI	0F4F4H,A6

	MOVE	A2,A0
	SUBI	[22,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9
	CLR	A0
	JSRP	STRCNRMO	;"TO"

	MOVE	A2,A0
	ADDI	[5,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9
	CLR	A0
	JSRP	STRCNRMO	;"CONTINUE"

	MOVI	TEXTOID,A0
	MOVI	BMES2OID,A1
	CALLA	CHNGOID		;CHANGE THE OID

	MMFM	SP,A0,A1,A2,A6,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* INIBTIME - INITIALIZE THE BUY IN TIMER				 *
*                                                                        *
**************************************************************************
INIBTIME
	MMTM	SP,A0,A1,A6,A8,A9,A10,A11
	CALLR	CLRBTIME
	MOVI	BUYTIME,A8
	MOVE	A8,@BTIME,W	;STORE IT AWAY
	CALLR	HEXTOASC

	CALLR	GWINCENT	;POSITION
	ADDI	[35,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9

	CLR	A0
	MOVI	0F5F5H,A6
	MOVI	RD20FONT,A11	;BIG OLD LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRMO       	;OUTPUT THE TIME
	MOVI	TEXTOID,A0
	MOVI	BTIMEOID,A1
	CALLA	CHNGOID		;CHANGE THE OID
	MMFM	SP,A0,A1,A6,A8,A9,A10,A11
	RETS
	
**************************************************************************
*                                                                        *
* DECBTIME - DECREMENT THE BUY IN TIMER					 *
* RETURNS:								 *
* 	Z BIT SET = BUY IN TIME DONE					 *
* 	Z BIT CLR = HURRY WHILE SPECIALS LAST!				 *
*                                                                        *
**************************************************************************
DECBTIME
	MMTM	SP,A0,A1,A6,A8,A9,A10,A11
	CALLR	CLRBTIME
	MOVE	@BTIME,A8,W
	DEC	A8
	JRLT	DECBTX
	MOVE	A8,@BTIME,W
	CALLR	HEXTOASC

	CALLR	GWINCENT	;POSITION
	ADDI	[35,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9

	CLR	A0
	MOVI	0F5F5H,A6
	MOVI	RD20FONT,A11	;BIG OLD LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRMO       	;OUTPUT THE TIME
	MOVI	TEXTOID,A0
	MOVI	BTIMEOID,A1
	CALLA	CHNGOID		;CHANGE THE OID
	MOVE	@BTIME,A8,W	;SET STATUS
DECBTX
	MMFM	SP,A0,A1,A6,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* UPBMESS1 - UPDATE THE "PRESS START" OR "INSERT COIN" MESSAGE.		 *
* RETURNS:								 *
* A11 = UPDATED SLEEP LOOP TIME FOR BUYIN THING				 *
*                                                                        *
**************************************************************************
UPBMESS1
	MMTM	SP,A0,A1,A6,A8	;MORE PUSHING TO COME
	CALLA	CR_CONTP	;ENOUGH TO CONTINUE?
	JRLO	UPBMIN		;BR = NO
***	MOVE	@BTIMERST,A0,W
***	JRZ	UPBPTW		;BR = DO NOT RESET TIMER, NOT A NEW COIN
***	CLR	A0
***	MOVE	A0,@BTIMERST,W
***	MOVI	BUYTICK,A11	;RESET BUY-IN LOOP TIMER
***	CALLR	INIBTIME	;RE-INITIALIZE THE BUY-IN TIME
***UPBPTW
	MOVI	PRESSMSG,A8
	JRUC	UPBM1
UPBMIN
	MOVI	INSRTMSG,A8
UPBM1
	MMTM	SP,A9,A10,A11	;WATCH OUT FOR THIS BOGUSNESS
	CALLR	GWINCENT	;POSITION
	SUBI	[50,0],A0
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0		;MAKE'UM SCREEN RELATIVE
	MOVE	A0,A9
	CLR	A0
	MOVI	0F0F0H,A6
	MOVI	RD20FONT,A11	;BIG OLD LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS
	JSRP	STRCNRMO       	;OUTPUT THE TIME

	MOVI	BMES1OID,A0
	CLR	A1
	NOT	A1
	CALLA	KILOBJ		;KILL OLD MESSAGE

	MOVI	TEXTOID,A0
	MOVI	BMES1OID,A1
	CALLA	CHNGOID		;CHANGE THE OID
	MMFM	SP,A0,A1,A6,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* UPBMESS2 - UPDATE THE "TO CONTIMUE" MESSAGE, TO INSURE ALIGNMENT.	 *
*                                                                        *
**************************************************************************
UPBMESS2
	MMTM	SP,A0,A1,A2,A6,A8,A9,A10,A11

	MOVI	RD20FONT,A11	;BIG OLD LETTERS
	MOVK	1,A10		;ONE SPACE BETWEEN LETTERS

	CALLR	GWINCENT	;POSITION
	MOVE	A0,A2

	MOVI	TOCONMSG,A8
	MOVI	0F4F4H,A6

	SUBI	[22,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9
	CLR	A0
	JSRP	STRCNRMO	;"TO"

	MOVE	A2,A0
	ADDI	[5,0],A0	;OFFSET FROM BOX CENTER
	MOVE	@WORLDTL,A1,L
	SUB	A1,A0
	MOVE	A0,A9
	CLR	A0
	JSRP	STRCNRMO	;"CONTINUE"

	MOVI	BMES2OID,A0
	CLR	A1
	NOT	A1
	CALLA	KILOBJ		;KILL OLD MESSAGE

	MOVI	TEXTOID,A0
	MOVI	BMES2OID,A1
	CALLA	CHNGOID		;CHANGE THE OID

	MMFM	SP,A0,A1,A2,A6,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
* CLRBMESS - CLEAR THE BUY-IN MESSAGE TEXT.				 *
*                                                                        *
**************************************************************************
CLRBMESS
	MMTM	SP,A0,A1
	MOVI	BMES1OID,A0
	CLR	A1
	NOT	A1
	CALLA	KILOBJ
	MOVI	BMES2OID,A0
	CALLA	KILOBJ
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* CLRBTIME - CLEAR THE BUY-IN TIME TEXT.				 *
*                                                                        *
**************************************************************************
CLRBTIME
	MMTM	SP,A0,A1
	MOVI	BTIMEOID,A0
	CLR	A1
	NOT	A1
	CALLA	KILOBJ
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* GWINCENT - GET THE CURRENT TEXT WINDOW CENTER POINT.			 *
* RETURNS:								 *
* A0 = CENTER PNT.							 *
*                                                                        *
**************************************************************************
GWINCENT
	MMTM	SP,A1,A8
	MOVI	TEXTWOID,A0
	CLR	A1
	NOT	A1
	CALLA	EXISTOBJ
	JRZ	GWINCX
	MOVE	A0,A8
	CALLA	GETCPNT
	MOVE	A1,A0
GWINCX
	MMFM	SP,A1,A8
	RETS

**************************************************************************
*                                                                        *
* GAMEOTXT - PROCESS TO PUT "GAME OVER" UP AND KEEP IT CENTERED		 *
*                                                                        *
**************************************************************************
GAMEOTXT
	CLR	A0
	MOVI	0F5F5H,A6
	MOVI	GAMOVMSG,A8	
	MOVI	[90+SKYTOPOF,255],A9
	MOVK	2,A10
	MOVI	RD20FONT,A11		;SET UP FONT
	JSRP	STRCNRMO 		;"GAME OVER"

	MOVI	GOTXTOID,A0
	CLR	A1
	NOT	A1
	CALLA	KILOBJ		;KILL OLD MESSAGE

	MOVI	TEXTOID,A0
	MOVI	GOTXTOID,A1
	CALLA	CHNGOID		;CHANGE THE OID
	SLOOP	1,GAMEOTXT

**************************************************************************
*                                                                        *
* CHNGOID - CHANGE ALL MATCHING OID'S ON THE OBJECT LIST TO A NEW ONE.	 *
* A0 = OID TO CHANGE							 *
* A1 = NEW OID								 *
*                                                                        *
**************************************************************************
CHNGOID
	MMTM	SP,A2,A3
	MOVI	OBJLST,A2
CHNGOLP
	MOVE	*A2,A2,L
	JRZ	CHNGOIDX		;BR = DONE WITH THE LIST
	MOVE	*A2(OID),A3,W
	CMP	A0,A3
	JRNE	CHNGOLP			;THIS IS NOT ONE OF THEM
	MOVE	A1,*A2(OID),W		;STUFF THE NEW ONE
	JRUC	CHNGOLP
CHNGOIDX
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*                                                                        *
* DUMPWTCH - CREATE THE DUMPSTER MAN WATCH PROCESS			 *
*                                                                        *
**************************************************************************
DUMPWTCH
	CREATE	INDPID,DUMPWTP
	RETS

**************************************************************************
*                                                                        *
* DUMPWTP - DUMPSTER MAN WATCH PROCESS, CONSTANTLY CHECKS DUMPCNT	 *
* 		WHEN IT IS 0 IT WILL CLEAR THE XSCROLLS			 *
*                                                                        *
**************************************************************************
DUMPWTP
	SLEEP	60		;HOLD FOR A SECOND BEFORE STARTING
DUMPWLP
	MOVE	@DUMPCNT,A0,W
	JRZ	DUMPCLRX
	SLOOP	4,DUMPWLP
DUMPCLRX
	CLR	A0
	MOVE	A0,@XSCROLLS,W	;LET'S CLEAR THE SCROLL STOPPER
	DIE

**************************************************************************
*                                                                        *
* AUDPLWAV - AUDIT THE PLAYER'S FOR THIS WAVE WHO HAVE NOT YET BEEN.	 *
*                                                                        *
**************************************************************************
AUDPLWAV
	PUSH	A0
	MOVE	@WAVE,A0,W
AUDPLWVL
	CALLR	AUDPLYRS		;AUDIT ALL PLAYERS THIS WAVE
	DSJS	A0,AUDPLWVL		;AND ALL PREVIOUS WAVES
AUDPLWVX
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* AUDPLYRS - CLICK AN AUDIT COUNTER FOR EACH PLAYER THAT IS ACTIVE	 *
* 		AND HAS NOT YET BEEN AUDITED.				 *
* A0 = WAVE # TO AUDIT							 *
*                                                                        *
**************************************************************************
AUDPLYRS
	PUSH	A2
	MOVI	P1DATA,A2
	CALLR	CKPAUD
	MOVI	P2DATA,A2
	CALLR	CKPAUD
	PULL	A2
	RETS
*
*CKPAUD - CHECK PLAYER FOR AUDITABLITIY, AND CLICK IF O.K.
*A0 = WAVE # AUDIT
*A2 = PLINDX
CKPAUD
	MMTM	SP,A0,A1,A3,A4
	CMPI	AUDWLAST,A0
	JRHI	CKPAUDX
	DEC	A0
	MOVE	A0,A3
	ADDI	AUDWAVE1,A0	;GET AUDIT # TO CLICK

	MOVE	*A2(POBJ),A1,L
	JRZ	CKPAUDX		;BR = NOT EVEN ACTIVE
	MOVE	*A2(PAUDIT),A1,W
	BTST	A3,A1
	JRNE	CKPAUDX		;THIS WAVE IS AUDITED	
	MOVK	1,A4
	SLL	A3,A4
	OR	A4,A1
	MOVE	A1,*A2(PAUDIT),W	;THE SCARLET WORD
	CALLA	AUD1
CKPAUDX
	MMFM	SP,A0,A1,A3,A4
	RETS

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
*                                                                        *
* BONUSCR - CONSTRUCT THE BONUS SCREEN AND INSERT IT ON THE OBJECT LIST. *
* A10 = [Y,X] POSITION OFFSET						 *
*                                                                        *
* NOTE: DON'T CALL WITH A NULL BONUSTAB, BOYEEEE     			 *
**************************************************************************
BONUSCR
	MMTM	SP,A0,A1,A2,A14
	MOVI	BONUSTAB,A14		;GET THE BONUS SCREEN TABLE
BSCRNLP
	CALLA	GPALOBJ			;GET US AN OBJECT
	JRNZ	BSCRN1
	CALLA	GBPALOBJ		;TRY HERE, WE'LL TAKE WHAT WE CAN GET
	JRNZ	BSCRN1			
	ADDI	INITSIZE+16,A14		;NO DICE CHROME-DOME
	JRUC	BSCRN2
BSCRN1
	CALLA	STFOBJ
	CALLA	ADJSTWTL		;MAKE US BE, WHEREVER WE ARE!
	MOVE	*A14+,A1,W		;GET THE CONSTANT COLOR
	MOVE	A1,*A0(OCONST),W	;STUFF THE CONSTANT COLOR
	MOVE	*A0(OXPOS),A1,W	
	MOVE	*A0(OYPOS),A2,W
	SLL	16,A2
	MOVY	A2,A1
	ADDXY	A10,A1
	MOVY	A1,A2
	SRL	16,A2
	MOVE	A2,*A0(OYPOS),W
	MOVE	A1,*A0(OXPOS),W
	CALLA	INSOBJ			;POP THAT SUCKER ON
BSCRN2
	MOVE	*A14,A1,W
	INC	A1
	JRNZ	BSCRNLP
	MMFM	SP,A0,A1,A2,A14
	RETS
*
*THE BONUS SCREEN CONSTRUCTION TABLE

	.INCLUDE	"NARCBON.TBL"		;BONUS SCREEN SHITMAGES

BONUSTAB
	.LONG	0,0,(0*10000H),(80*Y),0,BV17320,0,0					 
	.WORD	DMACAL,0,0,0,0B8B8H

	.LONG	0,0,(493*10000H),(80*Y),0,BV17320,0,0					 
	.WORD	DMACAL,0,0,0,0B8B8H

	.LONG	0,0,(17*10000H),(80*Y),0,BH47826,0,0					 
	.WORD	DMACAL,0,0,0,0B8B8H

	.LONG	0,0,(17*10000H),(376*Y),0,BH47826,0,0					 
	.WORD	DMACAL,0,0,0,0B8B8H

	.LONG	0,0,(253*10000H),(103*Y),0,BV8274,0,0					 
	.WORD	DMACAL,0,0,0,0B8B8H

	.LONG	0,0,(17*10000H),(106*Y),10000H,BH2349,0,0					 
	.WORD	DMACAL,0,0,0,08585H

	.LONG	0,0,(261*10000H),(106*Y),10000H,BH2349,0,0					 
	.WORD	DMACAL,0,0,0,08585H

	.LONG	0,0,(17*10000H),(112*Y),0,BV7264,0,0					 
	.WORD	DMACAL,0,0,0,0C0C0H

	.LONG	0,0,(245*10000H),(112*Y),0,BV5264,0,0					 
	.WORD	DMACAL,0,0,0,0C0C0H

	.LONG	0,0,(261*10000H),(112*Y),0,BV5264,0,0					 
	.WORD	DMACAL,0,0,0,0C0C0H

	.LONG	0,0,(486*10000H),(112*Y),0,BV7264,0,0					 
	.WORD	DMACAL,0,0,0,0C0C0H

	.LONG	0,0,(24*10000H),(370*Y),0,BH2246,0,0					 
	.WORD	DMACAL,0,0,0,0CCCCH

	.LONG	0,0,(266*10000H),(370*Y),0,BH2206,0,0					 
	.WORD	DMACAL,0,0,0,0CCCCH

*PLAYER ONE BORDER PARTS
      .IF BLUEP1
*DRAW AS BLUE
	.LONG	0,0,(88*10000H),(115*Y),0,BH15629,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(25*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(25*10000H),(366*Y),0,BH2164,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(241*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH
      .ELSE	
*DRAW AS RED
	.LONG	0,0,(88*10000H),(115*Y),0,BH15629,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(25*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(25*10000H),(366*Y),0,BH2164,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(241*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H
      .ENDIF
*PLAYER 2 BONUS BORDER PARTS
      .IF BLUEP1	
*DRAW AS RED
	.LONG	0,0,(269*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(482*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(270*10000H),(115*Y),0,BH15629,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H

	.LONG	0,0,(269*10000H),(366*Y),0,BH2164,0,0					 
	.WORD	DMACAL,0,0,0,0F9F9H
      .ELSE	
*DRAW AS BLUE
	.LONG	0,0,(269*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(482*10000H),(112*Y),0,BV4258,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(270*10000H),(115*Y),0,BH15629,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH

	.LONG	0,0,(269*10000H),(366*Y),0,BH2164,0,0					 
	.WORD	DMACAL,0,0,0,0FDFDH
      .ENDIF
*BONUS SCREEN IMAGES
	.LONG	0,0,(43*10000H),(83*Y),20000H,EVIDENCE,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(154*10000H),(83*Y),20000H,BONUS,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(288*10000H),(83*Y),20000H,EVIDENCE,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(404*10000H),(83*Y),20000H,BONUS,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(0*10000H),(106*Y),20000H,BADGE7a,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(19*10000H),(128*Y),30000H,MAXB,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(55*10000H),(145*Y),30000H,B357,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(397*10000H),(106*Y),20000H,BADGE7a,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(428*10000H),(127*Y),30000H,HITB,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(452*10000H),(145*Y),30000H,B999,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(17*10000H),(360*Y),20000H,BONANG1,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(261*10000H),(360*Y),20000H,BONANG1,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(493*10000H),(360*Y),20000H,BONANG1,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(251*10000H),(360*Y),20000H,BONANG1,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(237*10000H),(106*Y),20000H,BONANG3,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(276*10000H),(106*Y),20000H,BONANG3,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(1*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(16*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(248*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(263*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(491*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(506*10000H),(85*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(1*10000H),(235*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(16*10000H),(235*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(494*10000H),(235*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(509*10000H),(235*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(1*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(16*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(124*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(139*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(249*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(264*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(376*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(391*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.LONG	0,0,(494*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ,0,0,0,0

	.LONG	0,0,(509*10000H),(382*Y),20000H,BONBOLT,0,0					 
	.WORD	DMAWNZ|M_FLIPH,0,0,0,0

	.WORD	0FFFFH			;END IT ALL
*
*KLUDGED BONUS SCREEN IMAGE HEADERS
BV17320
	.WORD	17,320,0,0
	.LONG	02000000H,NARCS
BH47826
	.WORD	478,26,0,0
	.LONG	02000000H,NARCS
BV8274	
	.WORD	8,274,0,0
	.LONG	02000000H,NARCS
BH15629
	.WORD	156,29,0,0
	.LONG	02000000H,NARCS
BH2349
      	.WORD	234,9,0,0
	.LONG	02000000H,NARCS
BH2246
      	.WORD	224,6,0,0
	.LONG	02000000H,NARCS
BH2206
      	.WORD	220,6,0,0
	.LONG	02000000H,NARCS
BV7264
      	.WORD	7,264,0,0
	.LONG	02000000H,NARCS
BV5264
      	.WORD	5,264,0,0
	.LONG	02000000H,NARCS
BV4258
      	.WORD	4,258,0,0
	.LONG	02000000H,NARCS

BH2164	.WORD	216,4,0,0
	.LONG	02000000H,NARCS

*
*PLAYER TRANSPORT PLACEHOLDER INIT. ROUTINES
P1TINIT
	.LONG	0,0,256*10000H,200*Y		;PLAYER 1 HELD AS PASSENGER
	.WORD	0,0
	.LONG	jtpassen1,PZSIZ,DUMCOLL
	.WORD	DMAWNZ,P1PLACE
	.LONG	0
P2TINIT
	.LONG	0,0,256*10000H,200*Y		;PLAYER 2 HELD AS DRIVER
	.WORD	0,0
	.LONG	ytdrive1,PZSIZ,DUMCOLL
	.WORD	DMAWNZ,P2PLACE
	.LONG	0

*
*FLAIL ABOUT WHILE IN THE AIR
PFLAIL
	.LONG	flail1
	.WORD	7
	.LONG	flail2
	.WORD	7
	.LONG	flail3
	.WORD	7
	.LONG	flail4
	.WORD	7
	.LONG	0

*
*SOME MESSAGES
INSRTMSG
	.STRING "INSERT COIN"
	.BYTE	0
PRESSMSG
	.STRING	"PRESS START"
	.BYTE	0
TOCONMSG
	.STRING "TO"
	.BYTE	0
	.STRING	"CONTINUE"
	.BYTE	0
	.EVEN

	.END
