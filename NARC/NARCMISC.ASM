	.FILE	'NARCMISC.ASM'
	.TITLE	" <<< NARC MISCELLANEOUS GARBAGE >>>"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
        .INCLUDE	\VIDEO\GSP.INC
        .INCLUDE	\VIDEO\SYS.INC
	.INCLUDE	\VIDEO\MACROS.HDR
	.INCLUDE	\VIDEO\MPROCEQU.ASM
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	\VIDEO\DISPEQU.ASM

	.EVEN
	.TEXT
**************************************************************************
*                                                                        *
* TABLE DRIVEN COLOR RAM PROCESSES					 *
*                                                                        *
**************************************************************************
*	1800F00(240)	-	RGB
*	1800F10(241)	-	DECAY	
*	1800F20(242)	-	BPR
*	1800F30(243)	-	RGOLD
*	1800F40(244)	-	LASER
*	1800F50(245)	-	LASER FLASH
*	1800F60(246)	-	BWHITE
*	1800F70(247)	-	RWHITE	
*	1800F80(248)	-	REDGLOW

RGB	CALLR	TABDRIVE
	.LONG	RGBTAB,COLRTEMP+100H
	.WORD	8
RGBTAB	.WORD	0380H,7000H,001CH,0FFFFH
*
DECAY	CALLR	TABDRIVE
	.LONG	DCATAB,COLRTEMP+110H
	.WORD	2
DCATAB	.WORD	001CH,001CH,011CH,021CH,031CH,039CH,239CH,2390H,2388H
	.WORD	2380H,4300H,5280H,7180H,6180H,7080H,7000H,6000H,5000H
	.WORD	4000H,3000H,2000H,1000H,0FFFFH
*
BPR	CALLR	TABDRIVE
	.LONG	BPRTAB,COLRTEMP+120H
	.WORD	1
BPRTAB	.WORD	001CH,101CH,201CH,301CH,401CH,501CH,601CH,701CH,7010H
	.WORD	7010H,7008H,7008H,7000H,7000H,7008H,7008H,7010H,7010H
	.WORD	701CH,701CH,601CH,501CH,401CH,301CH,201CH,101CH,0FFFFH
*
RGOLD	CALLR	TABDRIVE
	.LONG	RGTAB,COLRTEMP+130H
	.WORD	6
RGTAB	.WORD	7000H,7000H,7280H,0FFFFH
*
LASER	CALLR	TABDRIVE
	.LONG	COLTAB,COLRTEMP+140H
	.WORD	2
COLTAB	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
	.WORD	0FFFFH

*
*LASER FLASH
*
LFLASH	MOVI	07FFFH,A0
	MOVE	A0,@COLRTEMP+150H,W
	SLEEP	2
LFLASH1
	MOVE	@RAND,A0,W
	ANDI	0000001FH,A0
	MOVI	COLTAB,A1
	SLL	4,A0
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	A1,@COLRTEMP+150H,W
	SLEEP	6
	JRUC	LFLASH

*
*CYCLE SPECTRUM
*
CYCSPECT
	MOVI	COLTAB,A8
CYCSPEC1
	MOVE	*A8+,A0,W	;GET A COLOR
	JRN	CYCSPECT	;OUT OF COLORS
      	MOVI	COLRTEMP,A1
	MOVE	A1,A2
	ADDK	16,A2		;A2 = NEXT COLOR 
	MOVK	15,A3
CYCSUCK
	MOVE	*A2+,*A1+,W	;CYCLE DOWN ONE
	DSJS	A3,CYCSUCK
	MOVE	A0,*A1		;SHIFT IN WALLY NEW GUY
	SLOOP	2,CYCSPEC1
	
BWHITE	CALLR	TABDRIVE
	.LONG	BWTAB,COLRTEMP+160H
	.WORD	6
BWTAB	.WORD	1FH,1FH,7FFFH,0FFFFH

RWHITE
	CALLR	TABDRIVE
	.LONG	RWTAB,COLRTEMP+170H
	.WORD	6
**CBTAB
RWTAB	.WORD	7C00H,7C00H,7FFFH,0FFFFH
****	.WORD	(17*32)+19,(17*32)+31,(20*32)+24,(15*1024)+(20*32)+24
****	.WORD	(10*32)+31,31,0FFFFH

REDGLOW
	CALLR	TABDRIVE
	.LONG	RGLOWTAB,COLRTEMP+180H
	.WORD	2
RGLOWTAB
	.WORD	(7*32*32),(8*32*32),(9*32*32),(10*32*32)
	.WORD	(11*32*32),(12*32*32),(13*32*32),(14*32*32),(15*32*32)
	.WORD	(16*32*32),(17*32*32),(18*32*32),(19*32*32),(20*32*32)
	.WORD	(21*32*32),(22*32*32),(23*32*32),(24*32*32),(25*32*32)
	.WORD	(26*32*32),(27*32*32),(28*32*32),(29*32*32),(30*32*32)
	.WORD	(31*32*32),(31*32*32),(31*32*32),(31*32*32),(31*32*32)
	.WORD	(29*32*32),(27*32*32),(25*32*32),(23*32*32)
	.WORD	(21*32*32),(19*32*32),(17*32*32),(15*32*32),(13*32*32)
	.WORD	(11*32*32),(9*32*32)
	.WORD	0FFFFH

*CYCLE THE SEVEN SEGMENT DISPLAY AT A ONE SECOND INTERVAL
SEG7CYCL
	MOVI	NUMTAB,A8
SEG7C1
	MOVE	*A8+,A0,W
	JREQ	SEG7CYCL
	PUSHST
	DINT
	MOVE	@SYSCOPY,A1,W
	SLL	24,A1
	SRL	24,A1
	OR	A0,A1
	MOVE	A1,@SYSCOPY,W	
	MOVE	A1,@SYSCTRL,W
	POPST
	SLOOP	7H,SEG7C1

NUMTAB	.WORD	SEG70,SEG71,SEG72,SEG73,SEG74,SEG75,SEG76,SEG77,SEG78,SEG79
	.WORD	0FF00H,0
**************************************************************************
*                                                                        *
* COLRSTRT - START THE COLOR RAM PROCESSES				 *
*                                                                        *
**************************************************************************
COLRSTRT
	MOVI	COLRPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
	CREATE	COLRPID,LASER
	CREATE	COLRPID,RGOLD
	CREATE	COLRPID,LFLASH
	CREATE	COLRPID,RGB
	CREATE	COLRPID,BPR
	CREATE	COLRPID,DECAY
****	CREATE	COLRPID,SEG7CYCL
	CREATE	COLRPID,BWHITE
	CREATE	COLRPID,RWHITE
	CREATE	COLRPID,REDGLOW
	CREATE	COLRPID,CYCSPECT
	RETS

**************************************************************************
*                                                                        *
* THE TABLE DRIVEN PROCESS						 *
*                                                                        *
**************************************************************************
TABDRIVE
	MOVE	*SP+,A0,L
	MOVE	*A0+,A11,L	;A11 = TABLE START
	MOVE	*A0+,A9,L	;A9 = LOCATION TO STUFF COLOR
	MOVE	*A0,A10,W	;A10 = SLEEP TIME
TABDRV1
	MOVE	A11,A8		;RESET TO START OF TABLE
TABDRV2
	MOVE	*A8+,A0,W	;GET A COLOR
	JRN	TABDRV1		;BR = END OF TABLE
	MOVE	A0,*A9,W
	MOVE	A10,A0
	MOVI	TABDRV2,A7
	JAUC	PRCLSP		;LOOP SLEEP

**************************************************************************
*                                                                        *
* LINE - DRAW A STRAIGHT LINE 1 PIXEL THICK BETWEEN TWO POINTS		 *
* A0 = COLOR MAP SELECT							 *
* A1 = DRAW COLOR							 *
* A2 = [Y1,X1]								 *
* A3 = [Y2,X2]								 *
*                                                                        *
**************************************************************************
LINE:
	PUSHST
	DINT
	MMTM	SP,B0,B1,B2,B3,B4,B7,B8,B10,B11,B12,B13,B14
	MOVE	A1,B9
	MOVE	A2,B2
	MOVE	A3,B10
LINEDMAW
	MOVE	@DMACTRL,B0,W
	SEXT	B0			;CHECK DMA STATUS
	JRN	LINEDMAW		;BR = DMA IS BUSY, SO WAIT

	MOVE	A0,@CMAPSEL,W		;SELECT CORRECT COLOR MAP

	MOVI	OFFSETVAL,B4		;Set up OFFSET register
	MOVI	0,B8		 	;Set background color
	MOVI	SCRN_PTCH,B0 		;Get Screen Pitch
	MOVE	B0,B1
	MOVE	B0,B3
	LMO	B0,B0			;Convert in temporary register
	MOVE	B0,@CONVSP,W		;Move to CONVSP io register
	MOVE	B0,@CONVDP,W		;Move to CONVDP io register

* Determine which octant line is in, and set up accordingly.
	CLR	B7
	SUBXY	B2,B10			; B10 = (y1-y0,x1-x0) = (b,a)
	JRYEQ	horiz			; jump if y1 = y2
	JRXEQ	vert			; jump if x1 = x2
	JRYGE	bpos			; jump if y1 < y2
	JRXGE	bneg_apos		; jump if x1 < x2

bneg_aneg:
	SUBXY	B10,B7			; B7 = (|b|,|a|)
	MOVI	-1,B11			; B11 = (-1,-1)
	JRUC	cmp_b_a
bneg_apos:
	SUBXY	B10,B7
	MOVX	B10,B7			; B7 = (|b|,|a|)
	MOVI	>FFFF0001,B11		; B11 = (-1,1)
	JRUC	cmp_b_a
bpos:	
	JRXGE	bpos_apos
bpos_aneg:
	SUBXY	B10,B7
	MOVY	B10,B7			; B7 = (|b|,|a|)
	MOVI	>0001FFFF,B11		; B11 = (1,-1)
	JRUC	cmp_b_a
bpos_apos:  
	MOVE	B10,B7			; B7 = (|b|,|a|)
	MOVI	>00010001,B11		; B11 = (1,1)
cmp_b_a:  
	CLR	B12
	MOVI	-1,B13			; B13 = FFFFFFFF (set pattern to all 1's)
	MOVE	B7,B0
	SRL	16,B0			; B0 = b
	CLR	B10
	MOVX	B7,B10			; B10 = a
	CMP	B0,B10
	JRGT	a_ge_b
a_lt_b:   
	MOVE	B0,B10
	MOVX	B7,B0
	RL	16,B7			; a and b swapped
	MOVY	B11,B12
	SLL	1,B0
	SUB	B10,B0			; B0 = 2b - a
	ADDK	1,B10
* If drawing in +Y direction, use LINE 0.  Otherwise, use LINE 1.
	MOVE	B11,B11			; if drawing in +Y direction, use LINE 0
	JRN	line1			; otherwise use LINE 1
line0:
	LINE	0
	JRUC	done

a_ge_b:
	MOVX    B11,B12
	SLL	1,B0
	SUB	B10,B0			; B0 = 2b - a
	MOVE	B11,B11			; if drawing in -Y direction, use LINE 1
	JRNN	line0			; otherwise use LINE 0
line1:
	LINE	1
	JRUC	done

* Handle special case of horizontal line.
horiz:
	JRXEQ	pixel
	JRXGE	do_fill
	ADDXY	B10,B2			; change start to (y1,x1)
	SUBXY	B10,B7			; make dx positive
	MOVE	B7,B10
* Handle special case of vertical line.
vert:
	JRYGE	do_fill
	ADDXY	B10,B2			; change start to (y1,x1)
	NEG	B10			; make dy positive
* Draw horizontal or vertical line.
do_fill:
	MOVE	B10,B7
	ADDI	>10001,B7		; no check for dx or dy overflow
	FILL	XY
	JRUC	done
* Draw dot if start and end points are the same.
pixel:
	DRAV	B12,B2
* Restore registers and return.
done:
	MMFM	SP,B0,B1,B2,B3,B4,B7,B8,B10,B11,B12,B13,B14
	MOVE	B13,B13
	JRZ	DONESTAT
	TRAP	1			;RE-START THIS PUPPY
DONESTAT
	POPST
	RETS				; Return to calling routine

;=============================================================================
;
;CIRCLE routine
;
;	A0 = radius
;	A1 = center  (Y:X)
;	A6 = color
;	A7 = routine
;
CIRCLE:
	PUSHST
	DINT
	MMTM	SP,A0,A1,A2,A3,A5,A6,A8  ;save registers
	MMTM	SP,B3,B7,B9,B10,B11,B12,B13,B14

	SETF	16,0,0
	MOVI	SCRN_PTCH,B3		; Restore screen pitch and convdp
	MOVI	>13,B10			; THIS IS FASTER
	MOVE	B10,@CONVDP
	MOVE	A6,B9
	MOVI	Y,B7			; Y width always 1
	MOVI	W,B10
	MOVE	B10,@CONTROL

;	x = A2
;	y = A3
;	d = A4
;	y:x = A5

	clr	A2			; x = 0
	move	a0,a3			; y = r
	move	a0,a4
	sll	1,a4
	subk	3,a4
	neg	a4			; d = 3 - 2*r
cloop:
	cmp	a3,a2			; if x > y, we are done
	jrgt	cdone
	call	a7			; plot routine
	move	a2,a5			; x -> a5
	btst	31,a4
	jrz 	dpos			; branch if d is positive
;			d negative
	sll	2,a5			; 4*x -> a5
	addk	6,a5			; 4*x+6 -> a5
	jruc	cont
;			d positive
dpos:		
	sub	a3,a5			; x-y -> a5
	sll	2,a5			; 4*(x-y) -> a5
	addk	10,a5			; 4*(x-y)+10 -> a5
	subk	1,a3			; y = y - 1

cont:
	add	a5,a4			; d = d + a5
	addk	1,a2			; x = x + 1
	jruc	cloop

cdone:
	MMFM	SP,B3,B7,B9,B10,B11,B12,B13,B14
	MMFM	SP,A0,A1,A2,A3,A5,A6,A8
	POPST
	rets

plot8:
	move	a3,a5
	neg 	a5			; -y into a5      +y in a3
	sll 	16,a5
	sll 	16,a3
	movx	a2,a5			; a3 = (y:x)
	movx	a2,a3			; a5 = (-y:x)

	movk	2,a8
put4:
	move	a1,a0			; center (Y:X) in a0
	addxy	a3,a0			; (cx+x),(cy+y)
	pixt	a6,*a0.XY
	move	a1,a0			; center (Y:X) in a0
	addxy	a5,a0			; (cx+x),(cy-y)
	pixt	a6,*a0.XY
	move	a1,a0			; center (Y:X) in a0
	subxy	a3,a0			; (cx-x),(cy-y)
	pixt	a6,*a0.XY
	move	a1,a0			; center (Y:X) in a0
	subxy	a5,a0			; (cx-x),(cy+y)
	pixt	a6,*a0.XY
	rl  	16,a3
	rl  	16,a5			; transpose x and y	
	dsj 	a8,put4
	sra 	16,a3			; restore y
	rets

fill4:
	move	a2,b10			; x
	sll	1,b10			; 2x
	movx	b10,B7			; delta x = 2x
	move	a3,a5
	neg	a5			; -y into a5      +y in a3
	sll	16,a5
	sll	16,a3
	movx	a2,a5			; a3 = (y:x)
	movx	a2,a3			; a5 = (-y:x)
	movk	2,a8
put2:	
	move	a1,a0
	subxy	a5,a0
	move	a0,B2
	fill	XY

	move	a1,a0
	subxy	a3,a0
	move	a0,B2
	fill	XY

	rl  	16,a3			; a3 = (x:y)
	rl  	16,a5			; transpose x and y	
	clr 	a6
	subxy	a5,a6
	move	a6,a5			; a5 = (-x:y)
	move	a3,b10			; y
	sll 	1,b10			; 2y
	movx	b10,B7			; delta x = 2y
	dsj 	a8,put2
	sra 	16,a3			; restore y
	
	rets

	.END
  

