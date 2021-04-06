
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
;****************************************************************************
;* MISCDATA.ASM: MISCELLANEOUS DATA; FILE DEFINES ALL MISCELLANEOUS DATA    *
;*               TABLES.                                                    *
;****************************************************************************

        .include \VIDEO\GSP.INC
        .include \VIDEO\SYS.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

	.INCLUDE LAYOUT.MAC

        .BSS  SRAM_STRING, 32 * 8, 16
        .BSS  SRAM_TIME,   32 * 8, 16

        .SECT "MISC"
        .EVEN

IOREG_TABLE_START:

	  .WORD   001CH			; HESYNC
          .WORD   003DH			; HEBLNK
	  .WORD   013DH			; HSBLNK
	  .WORD   0150H			; HTOTAL

   .IF INTRLACE
    .WORD   0003H			; VESYNC
    .WORD   001BH			; VEBLNK
    .WORD   00E3H			; VSBLNK
    .WORD   0100H			; VTOTAL
    .WORD   0B020H			; DPYCTL
   .ELSE
    .WORD   0003H			; VESYNC
    .WORD   001BH			; VEBLNK
    .WORD   01ABH			; VSBLNK
    .WORD   01B0H			; VTOTAL
    .WORD   0F010H			; DPYCTL
   .ENDIF

	  .WORD   0FFFCH		; DPYSTRT
	  .WORD   01AFH			; DPYINT
	  .WORD   0000H			; CONTROL
	  .WORD   0000H			; HSTDATA
	  .WORD   0000H			; HSTADRL
	  .WORD   0000H			; HSTADRH
	  .WORD   0000H			; HSTCTLL
	  .WORD   0000H			; HSTCTLH
	  .WORD   0000H			; INTENBL
	  .WORD   0000H			; INTPEND
	  .WORD   0000H			; CONVSP
	  .WORD   0013H			; CONVDP
	  .WORD   0008H			; PSIZE
	  .WORD   0000H			; PMASK
	  .WORD   0000H			; RESERVED
	  .WORD   0000H			; RESERVED
	  .WORD   0000H			; RESERVED
	  .WORD   0000H			; RESERVED
	  .WORD   0000H			; DPYTAP

IOREG_TABLE_END:

TRADEMARK_COLORS_START:

      .word   (  0 *32*32)+(  0 *32)+( 0 )           ; color 0
      .word   (  0 *32*32)+(  0 *32)+( 0 )           ; color 1
      .word   ( 31 *32*32)+( 31 *32)+( 31 )          ; color 2
      .word   (  3 *32*32)+(  2 *32)+( 3 )           ; color 3
      .word   (  3 *32*32)+(  2 *32)+( 4 )           ; color 4
      .word   ( 17 *32*32)+( 19 *32)+( 21 )          ; color 5
      .word   (  8 *32*32)+(  1 *32)+( 1 )           ; color 6
      .word   (  6 *32*32)+(  6 *32)+( 7 )           ; color 7
      .word   ( 10 *32*32)+(  5 *32)+( 7 )           ; color 8
      .word   (  9 *32*32)+( 10 *32)+( 10 )          ; color 9
      .word   ( 13 *32*32)+(  9 *32)+( 10 )          ; color 10
      .word   ( 14 *32*32)+( 14 *32)+( 12 )          ; color 11
      .word   ( 16 *32*32)+( 13 *32)+( 16 )          ; color 12
      .word   ( 25 *32*32)+( 25 *32)+( 25 )          ; color 13

TRADEMARK_COLORS_END:

COLOR_TABLE_START:

          .WORD 0000H                   ; TRANSPARENT
          .WORD 3DD0H			; CHIP GRAY
	  .WORD	03E0H			; GREEN
	  .WORD 7C00H			; RED
	  .WORD 001FH			; BLUE
	  .WORD 0000H			; BLACK
	  .WORD 7FFFH			; WHITE
	  .WORD 7FE0H			; YELLOW
	  .WORD	7C1FH			; PURPLE
	  .WORD	03FFH			; CYAN

COLOR_TABLE_END:

LED_TABLE_START:

          .WORD 03FCH                   ; 0
          .WORD 9FFCH                   ; 1
          .WORD 25FCH                   ; 2
          .WORD 0DFCH                   ; 3
          .WORD 99FCH                   ; 4
          .WORD 49FCH                   ; 5
          .WORD 41FCH                   ; 6
          .WORD 1FFCH                   ; 7
          .WORD 01FCH                   ; 8
          .WORD 09FCH                   ; 9

LED_TABLE_END:

	.SECT	"LABELS"
ROMCOMPL
        LABEL , GREEN, RIGHT, 170, 80, "NO ROM ERRORS DETECTED" 
	LABEL , WHITE, RIGHT, 135, 95, "PRESS ANY KEY TO RETURN TO MENU"
        END_LABL
ROMERRL
        LABEL , RED, RIGHT, 180, 80, "ROM ERRORS DETECTED" 
	LABEL , WHITE, RIGHT, 135, 95, "PRESS ANY KEY TO RETURN TO MENU"
        END_LABL
RAMCOMPL
        LABEL , GREEN, RIGHT, 265, 28, "NO RAM ERRORS DETECTED" 
	LABEL , WHITE, RIGHT, 235, 43, "PRESS ANY KEY TO RETURN TO MENU"
        END_LABL
RAMERRL
        LABEL , RED, RIGHT, 280, 28, "RAM ERRORS DETECTED" 
	LABEL , WHITE, RIGHT, 235, 43, "PRESS ANY KEY TO RETURN TO MENU"
        END_LABL

BROMERRL
        LABEL , RED, RIGHT, 175, 80, "ROM ERRORS DETECTED" 
	LABEL , RED, RIGHT, 200, 95, "BURN IN HALTED"
        END_LABL

BRAMERRL
        LABEL , RED, RIGHT, 250, 28, "RAM ERRORS DETECTED" 
	LABEL , RED, RIGHT, 275, 43, "BURN IN HALTED"
        END_LABL

        .END

