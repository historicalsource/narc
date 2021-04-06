	.FILE	'NARCMATH.ASM'
	.TITLE	" <<< N  A  R  C    M  A  T  H >>>"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!

;	.GLOBL	TEST
	.GLOBL	LINEPT,LTWRDPT

	.EVEN
	.TEXT
TEST:
	movi	>0001000A,A0	;Y1=1, X1=10 
	clr	A1		;Y0=0, X0=0
	movi	>00018000,A2	;XVEL = 2^-9
	movi	>00008000,A3	;YVEL = 1.0
	callr	LINEPT
	jruc	$

testpreinf:
	movi	>0001000A,A0	;Y1=1, X1=10 
	clr	A1		;Y0=0, X0=0
	movi	>00000080,A2	;XVEL = 2^-9
	movi	>00010000,A3	;YVEL = 1.0
	callr	LINEPT
	jruc	$

testprezero:
	movi	>0001000A,A0	;Y1=1, X1=10 
	clr	A1		;Y0=0, X0=0
	movi	>00010000,A2	;XVEL = 1.0
	movi	>00000080,A3	;YVEL = 2^-9
	callr	LINEPT
	jruc	$


****************************************************************************
LTWRDPT:
;* PARMS
;	A0 Y:X coor of a target point	  - Y1:X1
;	A1 Y:X start coor of moving obj	  - Y0:X0
;	A2 XVEL 16.16 of moving obj
;	A3 YVEL 16.16 of moving obj
;* RETURNS
;	SETC if Line Vels X and Y components are each in the direction
;	from moving obj toward target point

	cmpxy	A0,A1
	jrxgt	NdNegXv
	move	A2,A2
	jrn	WrongWay
	jruc	XDOK
NdNegXv:
	move	A2,A2
	jrp	WrongWay
;	jruc	XDOK
XDOK:
	cmpxy	A0,A1
	jrygt	NdNegYv
	move	A3,A3
	jrn	WrongWay
	jruc	YDOK
NdNegYv:
	move	A3,A3
	jrp	WrongWay
;	jruc	XDOK
YDOK:
	setc
	rets

WrongWay:
	clrc
	rets
****************************************************************************


****************************************************************************
LINEPT:
;* PARMS
;	A0 Y:X coor of a target point	  - Y1:X1
;	A1 Y:X start coor of moving obj	  - Y0:X0
;	A2 XVEL 16.16 of moving obj
;	A3 YVEL 16.16 of moving obj
;* RETURNS
;	A0 Y:X closest point on moving objects path to the target point

	mmtm	SP,A1,A2,A3,A4,A5,A6,A7

	move	A3,A4
	jrz	MZero
	move	A2,A5
	jrz	MInf
	abs	A4
	lmo	A4,A4
	abs	A5
	lmo	A5,A5
	;lmo result is 1's comp, so subtract A4 from A5 instead of vice versa
	sub	A4,A5	;A4 is appropriate shift count to normalize YVEL
	cmpi	10,A5
	jrge	MInf
	cmpi	6,A5
	jrge	MPreInf
	cmpi	-10,A5
	jrle	MZero
	cmpi	-6,A5
	jrle	MPreZero

;* 2^-6 < M < 2^6
;* Xf = ((M^2)X0 + M(Y1 - Y0) + X1) / ((M^2)+1)
;* Yf = Y0 + M(Xf - X0)
	;* calc M = YVEL / XVEL
	sll	8,A3
	divs	A2,A3	;A3 = M	<< 8
	move	A3,A5
	mpys	A5,A5	
	sra	8,A5	;A5 = M^2 << 8
	movy	A0,A7
	subxy	A1,A7
	sra	16,A7	;A7 = Y1-Y0
	mpys	A3,A7	;A7 = M(Y1-Y0) << 8
	movx	A0,A2
	sext	A2,W
	sll	8,A2
	add	A7,A2	;A2 = M(Y1-Y0)+X1 << 8
	movx	A1,A7
	sext	A7,W
	mpys	A5,A7	;A7 = (M^2)X0 << 8
	add	A2,A7
	sll	8,A7	;A7 << 16
	addi	>100,A5	;A5 = M^2 + 1 << 8
	divs	A5,A7	;A7 = Xf << 8
	move	A7,A2
	addi	>80,A2	;round by adding .5
	sra	8,A2
	movx	A2,A0

	movx	A1,A6
	sext	A6,W
	sll	8,A6
	sub	A6,A7	;A7 = Xf-X0 << 8
	mpys	A3,A7	;A7 = M*(Xf-X0) << 16
	addi	>8000,A7  ;round
	addxy	A1,A7
	movy	A7,A0

	jruc	GotPt


MPreZero:
	;* 2^-10 < M < 2^-6
	;* Xf = X1 + M(Y1 - Y0)
	;* Yf = Y0 + M(Xf - X0)

	;* calc M = YVEL / XVEL
	sll	8,A3
	sra	8,A2
	divs	A2,A3	;A3 = M	<< 16
	move	A3,A5

	movy	A0,A6
	subxy	A1,A6
	sra	16,A6
	mpys	A6,A3	;A3 = M*(Y1-Y0)	<< 16
	movx	A0,A7	
	sll	16,A7	;A7 = X1 << 16
	add	A3,A7	;A7 = Xf << 16
	addi	>8000,A3	;A3 = (Xf-X1) << 16 + (.5 << 16)
	sra	16,A3	;A3 = Xf-X1
	addxy	A3,A0	;add in to X1 to give Xf, Y1 could get clobbered

	movx	A1,A6
	sll	16,A6	;A6 = X0 << 16
	sub	A6,A7
	sra	8,A7	;A7 = (Xf-X0) << 8
	sra	8,A5	;A5 = M << 8	
	mpys	A5,A7	;A5 = M*(Xf-X0)
	addi	>8000,A7	;A7 = M(Xf-X0) << 16 + (.5 << 16)
	addxy	A7,A1	;result already << 16
	movy	A1,A0
	jruc	GotPt

MPreInf:
	;* 2^6 < M < 2^10
	;* Xf = X0 + (Y1 - Y0)/M
	;* Yf = (X1 - Xf)/M + Y1

	movy	A0,A7
	movx	A1,A7
	subxy	A1,A7	;A7 = (Y1-Y0) << 16
	divs	A2,A3	;A3 = M
	divs	A3,A7	;A7 = (Y1-Y0)/M	  << 16
	movx	A1,A5
	sll	16,A5
	add	A5,A7	;A7 = Xf << 16

	move	A7,A5
	addi	>8000,A5 ;add in round adj .5
	sra	16,A5	;A5 = Xf
	
	;* Yf = (X1 - Xf)/M + Y1
	movx	A0,A2
	sll	16,A2	;A2 = X1 << 16
	sub	A7,A2
	move	A2,A7
	divs	A3,A7	;A7 = (X1 - Xf)/M << 16
	addi	>8000,A7 ;add in round adj .5
	addxy	A7,A0
	movx	A5,A0
	jruc	GotPt

MInf:
	;* 2^10 < M
	;* Xf = X0,  Yf = Y1
	movx	A1,A0
	jruc	GotPt

MZero:
	;* M < 2^-10
	;* Xf = X1,  Yf = Y0
	movy	A1,A0
;	jruc	GotPt

GotPt:
	mmfm	SP,A1,A2,A3,A4,A5,A6,A7
	rets

	.END
