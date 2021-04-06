
;****************************************************************************
;* SYSFONT: SYSTEM FONT; MODULE DEFINES THE FONT USED WITH SYSTEM	    *
;*	    DIAGNOSTICS.						    *
;****************************************************************************

	  .TITLE 'SYSFONT'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.include	"SYSCHECK.SET"
	.include	"SYSCHECK.GBL"

	  .SECT "FONT"
	  .EVEN

; ===========================
; | DYDX CHAR DIMENSIONS    |
; | POINTER TO XY CHAR DATA |
; ===========================

T2_SP:
   .word    04h,08h
   .long    I2_SP

T2_MN:
   .word    08h,08h
   .long    I2_MN

T2_00:
   .word    06h,08h
   .long    I2_00

T2_11:
   .word    04h,08h
   .long    I2_11

T2_22:
   .word    06h,08h
   .long    I2_22

T2_33:
   .word    06h,08h
   .long    I2_33

T2_44:
   .word    06h,08h
   .long    I2_44

T2_55:
   .word    06h,08h
   .long    I2_55

T2_66:
   .word    06h,08h
   .long    I2_66

T2_77:
   .word    06h,08h
   .long    I2_77

T2_88:
   .word    06h,08h
   .long    I2_88

T2_99:
   .word    06h,08h
   .long    I2_99

T2_AA:
   .word    06h,08h
   .long    I2_AA

T2_BB:
   .word    06h,08h
   .long    I2_BB

T2_CC:
   .word    06h,08h
   .long    I2_CC

T2_DD:
   .word    06h,08h
   .long    I2_DD

T2_EE:
   .word    06h,08h
   .long    I2_EE

T2_FF:
   .word    06h,08h
   .long    I2_FF

T2_GG:
   .word    06h,08h
   .long    I2_GG

T2_HH:
   .word    06h,08h
   .long    I2_HH

T2_II:
   .word    02h,08h
   .long    I2_II

T2_JJ:
   .word    06h,08h
   .long    I2_JJ

T2_KK:
   .word    06h,08h
   .long    I2_KK

T2_LL:
   .word    05h,08h
   .long    I2_LL

T2_MM:
   .word    0Ah,08h
   .long    I2_MM

T2_NN:
   .word    07h,08h
   .long    I2_NN

T2_OO:
   .word    07h,08h
   .long    I2_OO

T2_PP:
   .word    06h,08h
   .long    I2_PP

T2_QQ:
   .word    07h,0Ah
   .long    I2_QQ

T2_RR:
   .word    06h,08h
   .long    I2_RR

T2_SS:
   .word    06h,08h
   .long    I2_SS

T2_TT:
   .word    06h,08h
   .long    I2_TT

T2_UU:
   .word    06h,08h
   .long    I2_UU

T2_VV:
   .word    07h,08h
   .long    I2_VV

T2_WW:
   .word    0Bh,08h
   .long    I2_WW

T2_XX:
   .word    07h,08h
   .long    I2_XX

T2_YY:
   .word    06h,08h
   .long    I2_YY

T2_ZZ:
   .word    06h,08h
   .long    I2_ZZ

; ===========================
; | CHARACTER DIRECTORY     |
; ===========================

SYSFONT:

   .long    T2_SP            ; SPACE CHARACTER, " "
   .long    0                ; FILLER   
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    0
   .long    T2_MN            ; MINUS CHARACTER, "-"
   .long    0
   .long    0
   .long    T2_00            ;0
   .long    T2_11            ;1
   .long    T2_22            ;2
   .long    T2_33            ;3
   .long    T2_44            ;4
   .long    T2_55            ;5
   .long    T2_66            ;6
   .long    T2_77            ;7
   .long    T2_88            ;8
   .long    T2_99            ;9
   .long    T2_00			; no :
   .long    T2_00			; no ;
   .long    T2_00			; no <
   .long    T2_00			; no =
   .long    T2_00			; no >
   .long    T2_00			; no ?
   .long    T2_00			; no @
   .long    T2_AA            ;A
   .long    T2_BB            ;B
   .long    T2_CC            ;C
   .long    T2_DD            ;D
   .long    T2_EE            ;E
   .long    T2_FF            ;F
   .long    T2_GG            ;G
   .long    T2_HH            ;H
   .long    T2_II            ;I
   .long    T2_JJ            ;J
   .long    T2_KK            ;K
   .long    T2_LL            ;L
   .long    T2_MM            ;M
   .long    T2_NN            ;N
   .long    T2_OO            ;O
   .long    T2_PP            ;P
   .long    T2_QQ            ;Q
   .long    T2_RR            ;R
   .long    T2_SS            ;S
   .long    T2_TT            ;T
   .long    T2_UU            ;U
   .long    T2_VV            ;V
   .long    T2_WW            ;W
   .long    T2_XX            ;X
   .long    T2_YY            ;Y
   .long    T2_ZZ            ;Z

; ===========================
; | CHARACTER DEFINITIONS   |
; ===========================

I2_SP:
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
 
I2_MN:
   .byte    000h
   .byte    000h
   .byte    0FFh
   .byte    0FFh
   .byte    0FFh
   .byte    000h
   .byte    000h
   .byte    000h
 
I2_00:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_11:
   .byte    0Eh
   .byte    0Fh
   .byte    0Fh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_22:
   .byte    01Fh
   .byte    03Fh
   .byte    038h
   .byte    01Ch
   .byte    0Eh
   .byte    07h
   .byte    03Fh
   .byte    03Fh

I2_33:
   .byte    01Fh
   .byte    03Fh
   .byte    030h
   .byte    01Eh
   .byte    01Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_44:
   .byte    038h
   .byte    03Ch
   .byte    036h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    030h
   .byte    030h

I2_55:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Fh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_66:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_77:
   .byte    03Fh
   .byte    03Fh
   .byte    030h
   .byte    018h
   .byte    018h
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_88:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    01Eh
   .byte    01Eh
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_99:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    03Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_AA:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    033h
   .byte    033h

I2_BB:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh

I2_CC:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03Fh
   .byte    03Eh

I2_DD:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Fh

I2_EE:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh

I2_FF:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    03h

I2_GG:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_HH:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_II:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h

I2_JJ:
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_KK:
   .byte    033h
   .byte    033h
   .byte    01Bh
   .byte    0Fh
   .byte    01Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_LL:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    01Fh
   .byte    01Fh

I2_MM:
   .byte    087h,03h
   .byte    0CFh,03h
   .byte    0CFh,03h
   .byte    07Bh,03h
   .byte    07Bh,03h
   .byte    033h,03h
   .byte    033h,03h
   .byte    033h,03h

I2_NN:
   .byte    063h
   .byte    067h
   .byte    06Fh
   .byte    06Fh
   .byte    07Bh
   .byte    07Bh
   .byte    073h
   .byte    063h

I2_OO:
   .byte    03Eh
   .byte    07Fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07Fh
   .byte    03Eh

I2_PP:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    03h
   .byte    03h
   .byte    03h

I2_QQ:
   .byte    03Eh
   .byte    07Fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07Fh
   .byte    03Eh
   .byte    060h
   .byte    060h

I2_RR:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_SS:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_TT:
   .byte    03Fh
   .byte    03Fh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_UU:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_VV:
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    036h
   .byte    03Eh
   .byte    01Ch
   .byte    01Ch

I2_WW:
   .byte    023h,06h
   .byte    023h,06h
   .byte    073h,06h
   .byte    076h,03h
   .byte    076h,03h
   .byte    0DEh,03h
   .byte    08Ch,01h
   .byte    08Ch,01h

I2_XX:
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    01Ch
   .byte    01Ch
   .byte    036h
   .byte    063h
   .byte    063h

I2_YY:
   .byte    033h
   .byte    033h
   .byte    01Eh
   .byte    01Eh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_ZZ:
   .byte    03Fh
   .byte    03Fh
   .byte    038h
   .byte    01Ch
   .byte    0Eh
   .byte    07h
   .byte    03Fh
   .byte    03Fh

  .end
