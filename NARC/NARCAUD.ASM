	.FILE	'NARCAUD.ASM'
	.TITLE	" <<< N  A  R  C  -- DISPLAY AUDIT PAGE >>>"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"IMGTBL.GLO"		;GLOBALS
	.EVEN
    	.TEXT
**************************************************************************
*                                                                        *
* CMOSCHEK - CHECK OUT CMOS AND RESET IF NECESSARY			 *
*                                                                        *
**************************************************************************
CMOSCHEK
	CALLR	AUDITCK
	JREQ	CMOSCHKX
	CALLR	CLRAUD
CMOSCHKX
*
*STICK US IN FREE PLAY PLEASE, TAKE THIS OUT BEFORE THE SHOW
	MOVI	FREEPLAY,A0
	MOVK	1,A3
	CALLR	WCMOSB
	MOVI	CREDITS,A0
	MOVK	2,A3
	CALLR	WCMOSW
	CALLR	FORMAUD
	RETS
**************************************************************************
*                                                                        *
* AUDITPAG - DISPLAY THE AUDIT PAGE WITH AUDITS INTACT			 *
*                                                                        *
**************************************************************************
AUDITPAG
	CALLA	CLR_SCRN	
	CLR	A0
	MOVK	2,A10
	MOVI	RD20FONT,A11
	MOVI	AUDITTXT,A8
	MOVI	[10,256],A9
	MOVI	0FDFDH,A6
	JSRP	STRCNRM
	MOVI	0FBFBH,A6
	MOVI	[13,259],A9
	MOVI	AUDITTXT,A8
	JSRP	STRCNRM	
	MOVI	RD15FONT,A11
	MOVI	AUDITTAB,A8	
****	MOVI	[40,80],A9		;START OF TABLE
	MOVI	[55,80],A9		
AUDPLP
	ADDK	8,A8
	SRL	4,A8
	SLL	4,A8			;ALIGN ON WORD BOUNDRY
	MOVE	*A8+,A6,W		;GET THE COLOR	
	JRZ	AUDPEND
	JSRP	STRLNRM
	ADDK	8,A8
	SRL	4,A8
	SLL	4,A8			;ALIGN ON WORD BOUNDRY
	MOVE	A8,A14
	MOVE	*A8,A8,L		;GET THE COUNTER ADDRESS
	CALLR	RCMOSL
	MOVE	A3,A8
	CALLA	HEXTOASC
	MOVI	420,A1
	MOVX	A1,A9
	JSRP	STRRNRM			;OUTPUT THE COUNT
	MOVI	80,A1
	MOVX	A1,A9
	MOVI	27,A1
	SLL	16,A1
	ADDXY	A1,A9
	ADDK	32,A14
	MOVE	A14,A8
	JRUC	AUDPLP
AUDPEND
	MOVI	RD7FONT,A11
	MOVI	REVTXT,A8
	MOVI	[390,256],A9
	MOVI	0FDFDH,A6
	JSRP	STRCNRM
	RETS

**************************************************************************
*                                                                        *
* CREDIT1 - TAKE AWAY ONE CREDIT					 *
* RETURNS:								 *
* Z BIT SET = NO CREDITS TO TAKE					 *
* Z BIT CLR = SUCCESS							 *
*                                                                        *
**************************************************************************
CREDIT1
	MMTM	SP,A0,A3,A8
	MOVI	CREDITS,A8
	CALLR	RCMOSW
	JRZ	CRED1X		;XIT WITH Z BIT SET
	DEC	A3	
	MOVE	A8,A0
	CALLR	WCMOSW
	INC	A3		;CLEAR Z BIT
CRED1X
	MMFM	SP,A0,A3,A8
	RETS
*
*AUDIT COUNTER INCREMENT ROUTINES
*
**************************************************************************
*                                                                        *
* AUD1B - INCREMENT A BYTE CMOS AUDIT COUNTER				 *
* A0 = CMOS LOCATION							 *
*                                                                        *
**************************************************************************
AUD1B
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSB
	ADDK	1,A3
	CALLR	WCMOSB
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
**************************************************************************
*                                                                        *
* AUDB - ADD A VALUE TO A BYTE CMOS AUDIT COUNTER			 *
* A0 = LOCATION								 *
* A1 = VALUE TO ADD							 *
*                                                                        *
**************************************************************************
AUDB
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSB
	ADD	A1,A3
	CALLR	WCMOSB
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
**************************************************************************
*                                                                        *
* AUD1W - INCREMENT A WORD CMOS AUDIT COUNTER				 *
* A0 = CMOS LOCATION							 *
*                                                                        *
**************************************************************************
AUD1W
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSW
	ADDK	1,A3
	CALLR	WCMOSW
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
**************************************************************************
*                                                                        *
* AUDW - ADD A VALUE TO A WORD CMOS AUDIT COUNTER			 *
* A0 = LOCATION								 *
* A1 = VALUE TO ADD							 *
*                                                                        *
**************************************************************************
AUDW
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSW
	ADD	A1,A3
	CALLR	WCMOSW
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
**************************************************************************
*                                                                        *
* AUD1L - INCREMENT A LONG WORD CMOS AUDIT COUNTER			 *
* A0 = CMOS LOCATION							 *
*                                                                        *
**************************************************************************
AUD1L
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSL
	ADDK	1,A3
	CALLR	WCMOSL
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
**************************************************************************
*                                                                        *
* AUDL - ADD A VALUE TO A LONG WORD CMOS AUDIT COUNTER			 *
* A0 = LOCATION								 *
* A1 = VALUE TO ADD							 *
*                                                                        *
**************************************************************************
AUDL
	MMTM	SP,A3,A8
	MOVE	A0,A8
	CALLR	RCMOSL
	ADD	A1,A3
	CALLR	WCMOSL
	CALLR	FORMAUD			;NEW CHECKSUM
	MMFM	SP,A3,A8
	RETS
*
*CMOS READ/WRITE PRIMITIVES, TO CIRCUMVENT LOFFREDO BRAIN DAMAGE
*
**************************************************************************
*                                                                        *
* RCMOSB - READ A CMOS BYTE						 *
* A8 = CMOS LOCATION							 *
* RETURNS								 *
* A3 = 8 BIT VALUE 							 *
*                                                                        *
**************************************************************************
RCMOSB
	MOVB	*A8,A3
	RETS
**************************************************************************
*                                                                        *
* RCMOSW - READ A CMOS WORD						 *
* A8 = CMOS LOCATION							 *
* RETURNS								 *
* A3 = 16 BIT VALUE(SIGN EXTENDED)					 *
*                                                                        *
**************************************************************************
RCMOSW
	PUSH	A1
	MOVK	2,A1
	CALLR	RCMOSA
	SEXT	A3
	PULL	A1
	RETS
**************************************************************************
*                                                                        *
* RCMOSL - READ A CMOS LONG WORD					 *
* A8 = CMOS LOCATION							 *
* RETURNS								 *
* A3 = 32 BIT VALUE							 *
*                                                                        *
**************************************************************************
RCMOSL
	PUSH	A1
	MOVK	4,A1
	CALLR	RCMOSA
	PULL	A1
	RETS
**************************************************************************
*                                                                        *
* RCMOSA - READ A CMOS FIELD OF 2-4 BYTES				 *
* 	    READ MEM -> MEM+N ---> MSB -> LSB				 *
* A1 = # OF BYTES IN FIELD						 *
* A8 = LOCATION TO READ							 *
* RETURNS:								 *
* A3 = VALUE								 *
* STATUS BITS SET ACCORDING TO VALUE					 *
*                                                                        *
**************************************************************************
RCMOSA
	MMTM	SP,A1,A2,A8
	PUSHST
	DINT
	MOVE	@SYSCOPY,A2,W
	ORI	0C0H,A2		;ASSURE PAGE ZERO
	MOVE	A2,@SYSCOPY,W
	MOVE	A2,@SYSCTRL,W
	POPST
        CLR	A3
RCMOSAL
	RL	8,A3	
        MOVB	*A8,A2
        OR	A2,A3
        ADDK	16,A8
        DSJS	A1,RCMOSAL
	MOVE	A3,A3			;SET THE SIGN
	MMFM	SP,A1,A2,A8
        RETS
**************************************************************************
*                                                                        *
* WCMOSB - WRITE A CMOS BYTE						 *
* A0 = CMOS LOCATION							 *
* A3 = VALUE								 *
*                                                                        *
**************************************************************************
WCMOSB
	MOVB	A3,*A0
	RETS
**************************************************************************
*                                                                        *
* WCMOSW - WRITE A CMOS WORD						 *
* A0 = CMOS LOCATION							 *
* A3 = VALUE								 *
*                                                                        *
**************************************************************************
WCMOSW
	PUSH	A1
	MOVK	2,A1
	CALLR	WCMOSA
	PULL	A1
	RETS
**************************************************************************
*                                                                        *
* WCMOSL - WRITE A CMOS LONG WORD					 *
* A0 = CMOS LOCATION							 *
* A3 = VALUE								 *
*                                                                        *
**************************************************************************
WCMOSL
	PUSH	A1
	MOVK	4,A1
	CALLR	WCMOSA
	PULL	A1
	RETS
**************************************************************************
*                                                                        *
* WCMOSA - WRITE A CMOS FIELD OF 2-4 BYTES.				 *
* 	  WRITTEN MSB -> LSB ---> MEM -> MEM+N				 *
* A0 = CMOS LOCATION							 *
* A1 = # OF BYTES TO WRITE						 *
* A3 = VALUE								 *
*                                                                        *
**************************************************************************
WCMOSA
	MMTM	SP,A0,A1,A2,A3
	PUSHST
	DINT
	MOVE	@SYSCOPY,A2,W
	ORI	0C0H,A2		;ASSURE PAGE ZERO
	MOVE	A2,@SYSCOPY,W
	MOVE	A2,@SYSCTRL,W
	POPST
        MOVK	5,A2		; 8 * (4 - #bytes + 1)
	SUB	A1,A2
        SLL	3,A2
        RL	A2,A3
WCMOSAL
	MOVB	A3,*A0
        ADDK	16,A0
        RL	8,A3
        DSJS	A1,WCMOSAL
	MMFM	SP,A0,A1,A2,A3
        RETS

**************************************************************************
*                                                                        *
* CLRAUD - CLEAR ALL AUDITS						 *
*                                                                        *
**************************************************************************
CLRAUD
	MMTM	SP,A1,A2
	MOVI	AUDITST,A1
	MOVI	AUDITEND,A2
	CALLR	CLRCMOS
	MOVI	AUDCKSM,A0
	CALLR	NEWCKSM
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* FORMAUD - FORM AND STORE THE AUDIT AREA CHECKSUM			 *
*                                                                        *
**************************************************************************
FORMAUD
	MMTM	SP,A0,A1,A2
	MOVI	AUDITST,A1
	MOVI	AUDITEND,A2
	MOVI	AUDCKSM,A0
	CALLR	NEWCKSM
	MMFM	SP,A0,A1,A2
	RETS
**************************************************************************
*                                                                        *
* AUDITCK - CHECK THE AUDIT CHECKSUM					 *
* RETURNS:								 *
* Z BIT SET ALL IS WELL							 *
* Z BIT CLR MEMORY IS TRASHED						 *
*                                                                        *
**************************************************************************
AUDITCK
	MMTM	SP,A1,A2,A8
	MOVI	AUDITST,A1
	MOVI	AUDITEND,A2
	MOVI	AUDCKSM,A8
	CALLR	CMPCKSM
	MMFM	SP,A1,A2,A8
	RETS
**************************************************************************
*                                                                        *
* CMPCKSM - FORM A CHECKSUM AND COMPARE IT TO THE STORED ONE		 *
* A1 = START								 *
* A2 = END								 *
* A8 = LOCATION								 *
*                                                                        *
**************************************************************************
CMPCKSM
	MMTM	SP,A3,A4
	CALLR	CMOSCKSM
	MOVE	A3,A4
	CALLR	RCMOSW		;READ THE CHECK
	CMP	A3,A4
	MMFM	SP,A3,A4
	RETS
**************************************************************************
*                                                                        *
* NEWCKSM - FORM & STORE A NEW CMOS CHECKSUM				 *
* A0 = LOCATION TO STORE CHECKSUM					 *
* A1 = START								 *
* A2 = END								 *
*                                                                        *
**************************************************************************
NEWCKSM
	CALLR	CMOSCKSM
	JRUC	WCMOSW	
**************************************************************************
*                                                                        *
* CMOSCKSM - CORE CMOS CHECKSUM ROUTINE					 *
* A1 = START								 *
* A2 = END								 *
* RETURNS								 *
* A3 = 16 BIT DATAIO CHECKSUM						 *
*                                                                        *
**************************************************************************
CMOSCKSM
	MMTM	SP,A0,A1
	PUSHST
	DINT
	MOVE	@SYSCOPY,A3,W
	ORI	0C0H,A3		;ASSURE PAGE ZERO
	MOVE	A3,@SYSCOPY,W
	MOVE	A3,@SYSCTRL,W
	POPST
	SUBK	10H,A1
	CLR	A3
CCKSML
	ADDK	10H,A1
	MOVB	*A1,A0
	ADD	A0,A3
	CMP	A1,A2
	JRNE	CCKSML
	SEXT	A3
	MMFM	SP,A0,A1
	RETS
**************************************************************************
*                                                                        *
* CLRCMOS - CLEAR A SECTION OF CMOS RAM PAGE 0				 *
* A1 = START								 *
* A2 = END								 *
*                                                                        *
**************************************************************************
CLRCMOS
	MMTM	SP,A0,A1
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ORI	0C0H,A0		;ASSURE PAGE ZERO
	MOVE	A0,@SYSCOPY,W
	MOVE	A0,@SYSCTRL,W
	POPST
	SUBK	10H,A1
	CLR	A0
CLRCMOSL
	ADDK	10H,A1
	MOVE	A0,*A1	
	CMP	A1,A2
	JRNE	CLRCMOSL
	MMFM	SP,A0,A1
	RETS

	.DATA
AUDITTXT
	.STRING	"AUDITS"
	.BYTE	0
REVTXT	.STRING	"NARC REVISION 1.1"
	.BYTE	0
*
*AUDIT TABLE
*	.WORD	COLOR
*	.STRING TEXT
*	.LONG	AUDIT LOCATION
AUDITTAB
	.WORD	0F9F9H
	.STRING	"LEFT SLOT COINS"
	.BYTE	0
	.LONG	LCOINS
	.WORD	0F9F9H
	.STRING	"CENTER SLOT COINS"
	.BYTE	0
	.LONG	CCOINS
	.WORD	0F9F9H
	.STRING	"RIGHT SLOT COINS"
	.BYTE	0
	.LONG	RCOINS
	.WORD	0FEFEH
	.STRING	"TOTAL PAID CREDITS"
	.BYTE	0
	.LONG	TOTPDC
	.WORD	0F9F9H
	.STRING	"PLAYER ONE STARTS"
	.BYTE	0
	.LONG	TOT1P
	.WORD	0F9F9H
	.STRING	"PLAYER TWO STARTS"
	.BYTE	0
	.LONG	TOT2P
	.WORD	0F9F9H
	.STRING	"PLAYER 1 BUYIN"
	.BYTE	0
	.LONG	TOT1BUY
	.WORD	0F9F9H
	.STRING	"PLAYER 2 BUYIN"
	.BYTE	0
	.LONG	TOT2BUY
	.WORD	0FEFEH
	.STRING	"TOTAL PLAYS"
	.BYTE	0
	.LONG	TOTCRD
	.WORD	0F9F9H
	.STRING	"PLAYER 1 EXTRA MEN"
	.BYTE	0
	.LONG	TOT1EX
	.WORD	0F9F9H
	.STRING	"PLAYER 2 EXTRA MEN"
	.BYTE	0
	.LONG	TOT2EX

***	.WORD	0F9F9H
***	.STRING	"AVERAGE GAME TIME"
***	.BYTE	0
***	.LONG	AVGTIME

	.WORD	0F9F9H
	.STRING	"GAME MODE RECYCLES"
	.BYTE	0
	.LONG	AUTOPS

	.WORD	0
	.EVEN

	.END
