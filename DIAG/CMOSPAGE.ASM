
;****************************************************************************
;* CMOSPAGE.ASM: FILE DECLARES CMOS GAME PARAMETER LAYOUT.                  *
;****************************************************************************

        .TITLE 'CMOSPAGE'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

        .include \VIDEO\GSP.INC
        .include \VIDEO\SYS.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include LAYOUT.MAC
        
;****************************************************************************
;* SYMBOL CONVENTIONS: PxxLyy = PAGE xx LINE yy; FOR xx AND yy INTEGERS.    *
;*                     T_     = TITLE                                       *
;*                     V_     = VALUE                                       *
;****************************************************************************

T1X      .SET 32
T1Y      .SET 50
V1X      .SET 320
V1Y      .SET 50
D1Y      .SET 16

T2X      .SET 32
T2Y      .SET 50
V2X      .SET 384
V2Y      .SET 50
D2Y      .SET 16

;       CMOS PAGE 01 (AUDITS)

        LABEL T_P01L01, GRAY, RIGHT, T1X, T1Y + (0*D1Y), "LEFT SLOT COINS"
        LABEL V_P01L01, GRAY, RIGHT, V1X, V1Y + (0*D1Y)

        LABEL T_P01L02, GRAY, RIGHT, T1X, T1Y + (1*D1Y), "CENTER SLOT COINS"
        LABEL V_P01L02, GRAY, RIGHT, V1X, V1Y + (1*D1Y)

        LABEL T_P01L03, GRAY, RIGHT, T1X, T1Y + (2*D1Y), "RIGHT SLOT COINS" 
        LABEL V_P01L03, GRAY, RIGHT, V1X, V1Y + (2*D1Y)

        LABEL T_P01L04, GRAY, RIGHT, T1X, T1Y + (3*D1Y), "PAID CREDITS"   
        LABEL V_P01L04, GRAY, RIGHT, V1X, V1Y + (3*D1Y)

        LABEL T_P01L05, GRAY, RIGHT, T1X, T1Y + (4*D1Y), "EXTRA MEN EARNED" 
        LABEL V_P01L05, GRAY, RIGHT, V1X, V1Y + (4*D1Y)
 
        LABEL T_P01L06, GRAY, RIGHT, T1X, T1Y + (5*D1Y), "PLAY TIME"       
        LABEL V_P01L06, GRAY, RIGHT, V1X, V1Y + (5*D1Y)
 
        LABEL T_P01L07, GRAY, RIGHT, T1X, T1Y + (6*D1Y), "MEN PLAYED"
        LABEL V_P01L07, GRAY, RIGHT, V1X, V1Y + (6*D1Y)
 
        LABEL T_P01L08, GRAY, RIGHT, T1X, T1Y + (7*D1Y), "CREDITS PLAYED"
        LABEL V_P01L08, GRAY, RIGHT, V1X, V1Y + (7*D1Y)
 
        LABEL T_P01L09, GRAY, RIGHT, T1X, T1Y + (8*D1Y), "AVG TIME PER CREDIT"
        LABEL V_P01L09, GRAY, RIGHT, V1X, V1Y + (8*D1Y)
 
        LABEL T_P01L10, GRAY, RIGHT, T1X, T1Y + (9*D1Y), "AVG TURNS PER CREDIT"
        LABEL V_P01L10, GRAY, RIGHT, V1X, V1Y + (9*D1Y)

;       CMOS PAGE 02 (GAME ADJUSTMENTS)

        LABEL T_P02L01, GRAY, RIGHT, T2X, T2Y + (0*D2Y), "ENERGY BONUS LEVEL"
        LABEL V_P02L01, GRAY, RIGHT, V2X, V2Y + (0*D2Y)

        LABEL T_P02L02, GRAY, RIGHT, T2X, T2Y + (1*D2Y), "ENERGY UNITS PER PLAYER"
        LABEL V_P02L02, GRAY, RIGHT, V2X, V2Y + (1*D2Y)

        LABEL T_P02L03, GRAY, RIGHT, T2X, T2Y + (2*D2Y), "PRICING SELECTION"
        LABEL V_P02L03, GRAY, RIGHT, V2X, V2Y + (2*D2Y)

        LABEL T_P02L04, GRAY, RIGHT, T2X+24, T2Y + (3*D2Y), "LEFT SLOT UNITS"
        LABEL V_P02L04, GRAY, RIGHT, V2X   , V2Y + (3*D2Y)

        LABEL T_P02L05, GRAY, RIGHT, T2X+24, T2Y + (4*D2Y), "CENTER SLOT UNITS"
        LABEL V_P02L05, GRAY, RIGHT, V2X   , V2Y + (4*D2Y)
 
        LABEL T_P02L06, GRAY, RIGHT, T2X+24, T2Y + (5*D2Y), "RIGHT SLOT UNITS"
        LABEL V_P02L06, GRAY, RIGHT, V2X   , V2Y + (5*D2Y)
 
        LABEL T_P02L07, GRAY, RIGHT, T2X+24, T2Y + (6*D2Y), "UNITS REQUIRED FOR CREDIT"
        LABEL V_P02L07, GRAY, RIGHT, V2X,    V2Y + (6*D2Y)
 
        LABEL T_P02L08, GRAY, RIGHT, T2X+24, T2Y + (7*D2Y), "UNITS REQUIRED FOR BONUS"
        LABEL V_P02L08, GRAY, RIGHT, V2X,    V2Y + (7*D2Y)
 
        LABEL T_P02L09, GRAY, RIGHT, T2X+24, T2Y + (8*D2Y), "MINIMUM UNITS FOR CREDIT"
        LABEL V_P02L09, GRAY, RIGHT, V2X,    V2Y + (8*D2Y)
 
        LABEL T_P02L10, GRAY, RIGHT, T2X, T2Y + (9*D2Y), "DIFFICULTY OF PLAY"
        LABEL V_P02L10, GRAY, RIGHT, V2X, V2Y + (9*D2Y)
 
        LABEL T_P02L11, GRAY, RIGHT, T2X, T2Y + (10*D2Y), "RESTORE FACTORY SETTINGS"
        LABEL V_P02L11, GRAY, RIGHT, V2X, V2Y + (10*D2Y)
 
        LABEL T_P02L12, GRAY, RIGHT, T2X, T2Y + (11*D2Y), "CLEAR BOOKEEPING TOTALS"
        LABEL V_P02L12, GRAY, RIGHT, V2X, V2Y + (11*D2Y)
 
        LABEL T_P02L13, GRAY, RIGHT, T2X, T2Y + (12*D2Y), "CLEAR HIGHSCORE"
        LABEL V_P02L13, GRAY, RIGHT, V2X, V2Y + (12*D2Y)
 
        LABEL T_P02L14, GRAY, RIGHT, T2X, T2Y + (13*D2Y), "AUTOCYCLE"
        LABEL V_P02L14, GRAY, RIGHT, V2X, V2Y + (13*D2Y)
 
        LABEL T_P02L15, GRAY, RIGHT, T2X, T2Y + (14*D2Y), "SET HIGHSCORE NAME"
        LABEL V_P02L15, GRAY, RIGHT, V2X, V2Y + (14*D2Y)
 
;       EDIT TABLE FOR CMOS PAGE 01 (AUDITS)

        BGN_EDIT

        EDIT BGN_CMOS_PAGE_1, 2000000H, 0, 10,   T_P01L01, V_P01L01, CVT_BIN_TO_STR
        EDIT                , 2000020H, 0, 10,   T_P01L02, V_P01L02, CVT_BIN_TO_STR
        EDIT                , 2000040H, 0, 10,   T_P01L03, V_P01L03, CVT_BIN_TO_STR
        EDIT                , 2000060H, 0, 10,   T_P01L04, V_P01L04, CVT_BIN_TO_STR
        EDIT                , 2000080H, 0, 10,   T_P01L05, V_P01L05, CVT_BIN_TO_STR
        EDIT                , 20000A0H, 0, 10,   T_P01L06, V_P01L06, CVT_BIN_TO_TIM
        EDIT                , 20000C0H, 0, 10,   T_P01L07, V_P01L07, CVT_BIN_TO_STR
        EDIT                , 20000E0H, 0, 10,   T_P01L08, V_P01L08, CVT_BIN_TO_STR
        EDIT                , 2000100H, 0,  1,   T_P01L09, V_P01L09, CVT_BIN_TO_TIM
        EDIT END_CMOS_PAGE_1, 20001C0H, 0,  1,   T_P01L10, V_P01L10, CVT_BIN_TO_STR

        END_EDIT

;       EDIT TABLE FOR CMOS PAGE 02 (GAME ADJUSTMENTS)

        BGN_EDIT

        EDIT BGN_CMOS_PAGE_2, 2000000H, 0, 10,   T_P02L01, V_P02L01, CVT_BIN_TO_STR
        EDIT                , 2000020H, 0, 10,   T_P02L02, V_P02L02, CVT_BIN_TO_STR
        EDIT                , 2000040H, 0, 10,   T_P02L03, V_P02L03, CVT_BIN_TO_STR
        EDIT                , 2000060H, 0, 10,   T_P02L04, V_P02L04, CVT_BIN_TO_STR
        EDIT                , 2000080H, 0, 10,   T_P02L05, V_P02L05, CVT_BIN_TO_STR
        EDIT                , 20000A0H, 0, 10,   T_P02L06, V_P02L06, CVT_BIN_TO_STR
        EDIT                , 20000C0H, 0, 10,   T_P02L07, V_P02L07, CVT_BIN_TO_STR
        EDIT                , 20000E0H, 0, 10,   T_P02L08, V_P02L08, CVT_BIN_TO_STR
        EDIT                , 2000100H, 0,  1,   T_P02L09, V_P02L09, CVT_BIN_TO_YN
        EDIT                , 2000120H, 0,  8,   T_P02L10, V_P02L10, CVT_BIN_TO_PLAYLEVEL
        EDIT                , 2000140H, 0,  1,   T_P02L11, V_P02L11, CVT_BIN_TO_YN
        EDIT                , 2000160H, 0,  1,   T_P02L12, V_P02L12, CVT_BIN_TO_YN
        EDIT                , 2000180H, 0,  1,   T_P02L13, V_P02L13, CVT_BIN_TO_YN
        EDIT                , 20001A0H, 0,  1,   T_P02L14, V_P02L14, CVT_BIN_TO_YN
        EDIT END_CMOS_PAGE_2, 20001C0H, 0,  1,   T_P02L15, V_P02L15, CVT_BIN_TO_YN

        END_EDIT

        .END

