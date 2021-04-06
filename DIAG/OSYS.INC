	.nolist

	.globl	SYNC

PXSIZE    .set		8
SCRN_PTCH .set		512*PXSIZE
SCRN_CONV	.set		13h
STACK_ST  .set		10FFFF0h
RAM_ST	.set		1000000h
RAM_LEN	.set		0100000h/32
TAPVALUE	.set		0
OFFSETVAL .set		0
PLANEMSK  .set		0
INI_CTRL  .set		0
SCREEN	.SET	00h	;START OF SCREEN MEMORY
SCRNE	.SET	0200000h	;END OF SCREEN+1

SOUND	.SET	01E00000h	;SOUND I/O (B0-B7 = SOUND#)
				;	    B8 =  MUSIC STROBE (0 EN)
				;	    B9 =  SOUND STROBE (0 EN)
				;	    B10 = RESET (0 EN)


CMAPSEL	.set		1a80080h		; NEW (10/26/87) color map select (0 - F)
COLRAM	.set		1800000h
DMAREGS	.set		1a800a0h

DMACON  .SET            1A00090H
DMAMAP  .SET            1A00080H
DMACMAP:	.equ	01A80080h	;DMA COLOR MAP SELECT
DMASIZ  .SET            1A00060H
DMADAD  .SET            1A00040H
DMASAD  .SET            1A00020H
DMAOFF  .SET            1A00010H
DMACTL  .SET            1A80000H

*BITS FOR THE DMA CONTROL WORD
DMAWZ	.SET	1|8000h		;WRITE ZERO DATA
DMAWNZ	.SET	2|8000h		;WRITE NON-ZERO DATA
DMACZ	.SET	4|8000h		;WRITE CONSTANT ON ZERO DATA
DMACNZ	.SET	8|8000h		;WRITE CONSTANT ON NON-ZERO DATA
DMAWAL	.SET	3|8000h		;WRITE BOTH ZERO & NON-ZERO DATA
DMACAL	.SET	0Ch|8000h	;WRITE CONSTANT ON BOTH ZERO & NON-ZERO DATA

;--------------------------------------
ISIZE	 .set		0	        	; image table offsets
IANIOFF	 .set		20h                     ; animation tool only
ISAG	 .set		40h
ICMAP	 .set		60h
ITOTSZ	 .set		70h
IOBLCK   .set           80h
IHDRSZ   .set           0A0h
;--------------------------------------

IXCOLLOFF .set		80h
IYCOLLOFF .set		90h
IXBOXSIZ .set		0A0h
IYBOXSIZ .set		0B0h

EBLNK	.set		1Bh
SBLNK	.set		EBLNK+400

MIDSCRN	.set		190
HALFINT	.set		EBLNK+MIDSCRN	; line number for half screen interrupt
BOTMINT	.set		SBLNK		; line number for bottom of screen int

                                                                                                                                              
