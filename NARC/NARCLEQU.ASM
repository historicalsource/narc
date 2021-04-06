BLUE_P1   EQU    0
**************************************************************************
*                                                                        *
*          NARC (R)                                                      *
*                                                                        *
*          Copyright 1988 Williams Electronics Games Inc.                *
*          All Rights Reserved                                           *
*                                                                        *
**************************************************************************
*
	.INCLUDE	"NARCAUDN.ASM"	 ;AUDIT NAMES!	
*
CHUTES   EQU     3                    ;MAXIMUM COIN CHUTES IN GAME.
*
ADV_BIT          EQU     10H          ;BIT OF ADVANCE BUTTON
ADV_HIGH         EQU     100000H
STARTS_HIGH      EQU     3000000H      ;BOTH START BUTTONS
DOOR_BIT         EQU     800H          ;COIN DOOR MEMORY PROTECT
GERMAN_BIT       EQU     8000H         ;1 SAYS JUMPER HAS BEEN CUT
FRENCH_BIT       EQU     4000H
JUMPERS          EQU     GERMAN_BIT+FRENCH_BIT
L_COIN_BIT       EQU     1H
C_COIN_BIT       EQU     4H
R_COIN_BIT       EQU     2H
X_COIN_BIT       EQU     80H
SLAM_BIT         EQU     8H
*
*****************************
*****************************  GET OFFICIAL PID FROM GEORGE ******************
MENU_PID         EQU      0AC1H   ;GET_MENU SLAVE
MDUN_PID         EQU      0AC2H   ;MENU SLAVE CHANGES TO THIS WHEN DONE
OPMES_PID        EQU      0AC3H   ;OPERATOR ENTER INITIALS
*****************************  GET OFFICIAL PID FROM GEORGE ******************
*****************************
LONG_SIZE        EQU     32
WORD_SIZE        EQU     16
BYTE_SIZE        EQU     8

C_LONG_SIZE      EQU     64
C_WORD_SIZE      EQU     32
C_BYTE_SIZE      EQU     16

BYTE_MASK        EQU     0FFH
WORD_MASK        EQU     0FFFFH

SX_MASK           EQU     0FFFFH
SY_MASK           EQU     0FFFF0000H

**************************************************************************
*                                                                        *
*          ASCII STUFF                                                   *
*                                                                        *
**************************************************************************
SPACE    EQU     20H
EX_PT    EQU     21H
LET_0    EQU     30H
LET_A    EQU     41H
LET_Z    EQU     5AH
UNDERSCORE EQU   5FH
FONT_SPACE  EQU     7EH
FONT_RUB EQU     FONT_SPACE+1
FONT_END EQU     FONT_RUB+1
FONT_RQUOTE EQU  FONT_END+1
FONT_EPOUND equ  FONT_RQUOTE+1
FONT_CR     equ  FONT_EPOUND+1
ASCII_COMMA EQU  2CH
RIGHT_PAREN EQU  29H
ASCII_DQ EQU     22H

**************************************************************************
*                                                                        *
*          SCREEN STUFF                                                  *
*                                                                        *
**************************************************************************
*
SCREEN_X_UNIT    EQU     8            ;THESE ARE FOR PACKED LINEAR ADDRESS
SCREEN_Y_UNIT    EQU     1000H        ;FORMAT
*
STRUCT_X_UNIT    EQU     1000H        ;X UNIT IN SPR DATA STRUCTURE
STRUCT_Y_UNIT    EQU     1000H        ;Y UNIT IN SPR DATA STRUCTURE
*
TABLE_UNIT       EQU     10000H       ;16 BIT FRACTION IN HSTD COORDINATES
*
EVEN_X_MASK      EQU     0FF8H        ;X MASK TO EVEN PIXEL
X_MASK           EQU     0FF8H        ;MASK TO HOLD JUST X
Y_MASK           EQU     1FF000H      ;MASK TO HOLD JUST Y
*
Y_MAX            EQU     400
SCREEN_PITCH     EQU     512

**************************************************************************
*                                                                        *
*          COLOR STUFF                                                   *
*                                                                        *
**************************************************************************
NARCS_GREY       EQU     0C0C0H
NARCS_WHITE      EQU     0FEFEH
NARCS_RED        EQU     0F9F9H
NARCS_ORANGE     EQU     0FAFAH
NARCS_YELLOW     EQU     0FBFBH
NARCS_GREEN      EQU     0FCFCH
NARCS_BLUE       EQU     0FDFDH
NARCS_LF         EQU     0F5F5H
NARCS_CYAN       EQU     02C2CH
NARCS_DECAY      EQU     0F1F1H
NARCS_RGOLD      EQU     0F3F3H
NARCS_LASER      EQU     0F4F4H
NARCS_BLUWH      EQU     0F6F6H
NARCS_PINK       EQU     0D9D9H
NARCS_SKY        EQU     0FFFFH  ;LAST COLOR IN NARCS IS "SKY" COLOR
NARCS_PURPLE     EQU     NARCS_SKY     ;PURPLE FOR TEST MODE

LOG_PAL_SIZE     EQU     12      ;SHIFT 12 BITS TO TURN NUMBER INTO OFFSET
*                                ;IN PALETTE MEMORY
*
MAX_PAL_MASK     EQU     3FH     ;THIS IS MASK FOR NUMBER OF PALETTES.
*
*
ALL_BLUE         equ     1fh
ALL_GREEN        equ     3e0h
ALL_RED          equ     7c00h
ALL_PURPLE       EQU     ALL_RED+ALL_BLUE
LIGHT_PURPLE     EQU     701CH
*
ONE_BLUE         EQU     1
ONE_GREEN        EQU     20H
ONE_RED          EQU     400H
*
THIRD_GREEN      EQU     140H    ;1/3TH GREEN ON
THIRD_RED        EQU     2800H   ;1/3 RED ON

*
*        THESE ARE THE NUMBERS TO INDICATE WHICH COLOR TO 
*        SPRAY
*
SPRAY_NUM_MASK   EQU     7            ;MASK FOR BELOW COLORS
*
SPRAY_BLACK      EQU     0
SPRAY_BLUE       EQU     1
SPRAY_GREEN      EQU     2
SPRAY_CYAN       EQU     3
SPRAY_RED        EQU     4
SPRAY_VIOLET     EQU     5
SPRAY_YELLOW     EQU     6
SPRAY_WHITE      EQU     7
**************************************************************************
*                                                                        *
*          DISPLAY HIGH SCORE TO DATE PARAMETERS                         *
*                                                                        *
**************************************************************************
ALL_TIME_SPRAY_START     EQU     0E0H       ;USE 1/2 THE SCREEN
*                                          ;(THIS IS BASE OF FIRST ROW)
*                  12) <MARGIN_1> LED <MARGIN_2> SCORE
*
MARGIN_1 EQU     40H             ;GOOD SIZE SPACE AFTER PAREN
MARGIN_2 EQU     0H              ;(missing) ten mil helps this gap
*
LEFT_MARGIN_X    EQU     22H               ;ALL TIME MARGIN IN PIXELS
X_MARGIN_TODAYS  EQU     1AH*STRUCT_X_UNIT  ;TODAYS MARGIN IN STRUCTURE UNITS

TODAY_Y_SCALER   EQU     48H                ;SCALER FOR TODAYS Y SPACING
*                                          ;6 BIT FRACTION
*
*        HYPER FROM ALL TIME TO TOP 5 MESSAGES IN Y:
*
TODAYS_Y_HYPER   EQU     78H*SCREEN_Y_UNIT
TOP5_Y_HYPER     EQU     64H*SCREEN_Y_UNIT
ENTRY_Y_HYPER    EQU     50H*SCREEN_Y_UNIT

INITIAL_SCROLL_DELAY   EQU       060H

SCROLL_TOP1      EQU     026     ;SCROLL TO GET HIGHEST NARCS OFF SAVE BORDER ONLY
SCROLL_TOP2      EQU     5EH     ;KEEP HIGHEST SCORE ON TOP
SCROLL_TOP3      EQU     SCROLL_TOP1     ;DON'T PROTECT EXTRA RING
SCROLL_BOT       EQU     174H    ;
*
SCORE_BOX_Y      EQU     7CH     ;DETERMINES HEIGHT OF SCORE BOXES.
*
DIST_1_TO_TOP    EQU     049H       ;NUMBER OF VIDEO FRAMES TO SCORE 1 TO TOP
*
Y_TO_DRAW        EQU     366      ;SCROLLED CURSOR MUST GET THIS HIGH

PLOT_MAX         EQU     Y_TO_DRAW*SCREEN_Y_UNIT

START_FADE       EQU     8020H     ;STORE THIS AT SCRL_FRC TO START A FADE

FINAL_SCROLL     EQU     94H      ;THIS GETS TODAY'S TABLE TO FIXED POINT!

**************************************************************************
*                                                                        *
*          AUDIT STRUCTURE                                               *
*                                                                        *
**************************************************************************
AUD_DATA EQU     0                 ;THE COUNTER IS 4 BYTES STARTING AT ZERO
AUD_CKSUM        EQU     AUD_DATA+(4*C_BYTE_SIZE)  ;CHECKSUM = 2 BYTES
AUD_SIZE         EQU     AUD_CKSUM+C_WORD_SIZE
AUD_BYTES_TO_CHECK EQU    (AUD_SIZE/C_BYTE_SIZE)-2  ;# TO ADD FOR CHECKSUM

N_AUDITS         EQU     45                ;USE 45 AUDITS!

         .IF     (LAST_AUDIT+1)>N_AUDITS                               
                 XXX     NOT ENOUGH RAM ALLOCATED FOR AUDITS!          
         .ENDIF                                                        

**************************************************************************
*                                                                        *
*          ADJUSTMENTS                                                   *
*                                                                        *
**************************************************************************
ADJ_SIZE         EQU     C_LONG_SIZE
N_ADJUSTS        EQU     28           ;28 NORMAL ADJUSTMENTS

         .IF     (LAST_ADJUST+1)>N_ADJUSTS
                 XXX     NOT ENOUGH RAM ALLOCATED FOR ADJUSTMENTS!
         .ENDIF

**************************************************************************
*                                                                        *
*                                                                        *
*          CMOS STUFF FOR HSTD..........MOVE THIS TO SPECIAL EQUATE FILE *
*          SOME DAY                                                      *
*                                                                        *
*                                                                        *
**************************************************************************
*
*        High Score table (CMOS) entry data structure
*
NUM_INITS        EQU     3          ;INITIALS IN EACH ENTRY..THIS MUST BE ODD
*
HS_SCORE         EQU     0                        ;LONG WORD.....8 DIGIT SCORE
HS_INITS         EQU     HS_SCORE+C_LONG_SIZE     ;BYTE FOR FIRST INITIAL
HS_CKBYTE        EQU     HS_INITS+(NUM_INITS*C_BYTE_SIZE)  ;BYTE FOR CHECKSUM
HS_SIZE          EQU     HS_CKBYTE+C_BYTE_SIZE    ;SIZE OF STRUCTURE
HS_BYTES_TO_CHECK EQU    (HS_SIZE/C_BYTE_SIZE)-1  ;# TO ADD FOR CHECKSUM
HS_SIZE_IN_WORDS  EQU    HS_SIZE/C_WORD_SIZE      ;SIZE OF ENTRY IN WORDS
HS_SIZE_IN_BYTES  EQU    HS_SIZE/C_BYTE_SIZE      ;SIZE OF ENTRY IN BYTES
HS_ROM_SIZE       equ    HS_SIZE/2                ;address size of rom entry
*
**************************************************************************
*                                                                        *
*         A HIGH SCORE TABLE IS DEFINED IN ROM BY THE FOLLOWING          *
*         STRUCTURE (THERE ARE AT LEAST 2 TABLES....ALL TIME             *
*         AND "TODAYS")                                                  *
*                                                                        *
**************************************************************************
TB_POINTER       EQU     0                      ;LONG-POINTER TO BEGINNING OF TABLE
TB_COUNT         EQU     TB_POINTER+LONG_SIZE   ;WORD....# IN THE TABLE.
TB_VISIBLE       EQU     TB_COUNT+WORD_SIZE ;WORD....NUMBER DISPLAYED
TB_PAGE_BITS     EQU     TB_VISIBLE+WORD_SIZE     ;WORD....STATUS WORD FOR CMOS PAGE
TB_FACTORY       EQU     TB_PAGE_BITS+WORD_SIZE   ;LONG....ROM STARTUP TABLE
TB_ERROR_COUNT   EQU     TB_FACTORY+LONG_SIZE     ;WORD....NUM ERRORS TO RE-INIT
*
CMOS     EQU     1400000H        ;BASE OF CMOS
WPCMOS   EQU     1404000H        ;WRITE PROTECTED CMOS
WP_READ  EQU     1C00010H        ;PLACE TO READ WRITE PROTECT STATUS
SND_TALK EQU     1C00020H        ;SOUND BOARD TALK BACK.
WP_BIT   EQU     800H            ;BIT WHERE WRITE ENABLE LIVES  0=NO WRITES
CMOS_PAGE_SELECT_BITS EQU 0C0H   ;BITS 6 AND 7 OF SYSCTRL SELECT CMOS PAGE
CMOS_PAGE_SELECT_UNIT EQU 040H   ;4 PAGES USE MULTIPLES OF THIS
*
**************************************************************************
*                                                                        *
*          CMOS ALLOCATION                                               *
*                                                                        *
**************************************************************************
*
*        4 PAGES OF 2K
*
*        EACH PAGE.....LOW 1K = READ/WRITE
*                     HIGH 1K = WRITE PROTECTED
*
*        PAGE 0        LOW HALF = AUDITS
*                     HIGH HALF = ADJUSTMENTS
*
*        PAGE 1        LOW HALF = HSTD TODAY
*
*        PAGE 2        LOW HALF = HSTD ALL TIME
*

ALL_TIME_ORIGIN   EQU     CMOS
ALL_TIME_SELECT   EQU     CMOS_PAGE_SELECT_UNIT*2
ALL_TIME_VISIBLE  EQU     20
*TODAYS_ORIGIN     EQU     ALL_TIME_ORIGIN+(HS_SIZE*37)
TODAYS_ORIGIN     EQU     CMOS
TODAYS_SELECT     EQU     CMOS_PAGE_SELECT_UNIT*0
TODAYS_VISIBLE    EQU     5

AUDIT_SELECT     EQU     CMOS_PAGE_SELECT_UNIT*1
HSR_SELECT       EQU     AUDIT_SELECT                ;HIGH SCORE RESET COUNTER
COIN_SELECT      EQU     AUDIT_SELECT                ;COINS AND CREDITS
*
ADJUST_SELECT    EQU     CMOS_PAGE_SELECT_UNIT*1
*
DUMP_SELECT      EQU     CMOS_PAGE_SELECT_UNIT*3
DUMP_ORG         EQU     CMOS
DUMP_PTR         EQU     DUMP_ORG               ;WORD....NUMBER OF ENTRIES!
DUMP_DATA        EQU     DUMP_PTR+C_WORD_SIZE   ;DUMPS GO HERE!
*
*        AUDIT PAGE AUDIT DATA AND CREDITS
*
AUDITORG         EQU     CMOS                             ;AUDITS LIVE HERE
CREDITS          EQU     AUDITORG+(N_AUDITS*AUD_SIZE)     ;BYTE FOR CREDITS
CUNITS           EQU     CREDITS+C_BYTE_SIZE              ;WORD
BUNITS           EQU     CUNITS+C_WORD_SIZE               ;WORD
MINUNITS         EQU     BUNITS+C_WORD_SIZE               ;WORD
COIN_CKSUM       EQU     MINUNITS+C_WORD_SIZE             ;BYTE
HSR_C            EQU     COIN_CKSUM+C_BYTE_SIZE           ;LONG = HIGH SCORE RESET COUNTER
*
*        NEXT TWO ARE ASSUMED TO BE BACK TO BACK
*
HRESET_COUNTER   EQU     HSR_C+C_LONG_SIZE                ;LONG = HIGH SCORE RESET COUNTER
HRESET_VERIFY    EQU     HRESET_COUNTER+C_LONG_SIZE       ;LONG = 2ND COPY INVERTED.

COIN_CKSUM_START EQU     CREDITS
COIN_CKSUM_SIZE  EQU     COIN_CKSUM-COIN_CKSUM_START      ;SIZE OF REGION TO CHECK
COIN_CKSUM_BYTES EQU     COIN_CKSUM_SIZE/C_BYTE_SIZE      ;NUMBER OF BYTES TO ADD

CMESS_CHARS      EQU     25                     ;25 CHARS/LINE OF CUSTOM MESSAGE
CMESS_LINES      EQU     3                      ;3 LINES
CMESS_LINE_SIZE  EQU     CMESS_CHARS*C_BYTE_SIZE
CMESS_SIZE       EQU     CMESS_LINES*CMESS_LINE_SIZE

VALID_VALUE      EQU     0EABCH                 ;STORED AT "VALID_CUSTOM" IF OK!

NAME_REV_SIZE    EQU     30                     ;NAME AND REV DATA

ADJUSTORG        EQU     WPCMOS                 ;FIRST ADJUSTMENT HERE
CUSTOM_MESSAGE   EQU     ADJUSTORG+(N_ADJUSTS*ADJ_SIZE)
VALID_CUSTOM     EQU     CUSTOM_MESSAGE+CMESS_SIZE        ;WORD = EABC IF OK.
END_CK_REGION    EQU     VALID_CUSTOM+C_WORD_SIZE
ADJ_AREA_SIZE    EQU     END_CK_REGION-ADJUSTORG          ;ADJUSTS+CUSTOM MESSAGE
ADJ_CKSUM        EQU     END_CK_REGION                    ;WORD CHECK FOR ADJUSTS
ADJ_BYTES_TO_CHECK EQU   ADJ_AREA_SIZE/C_BYTE_SIZE        ;NUMBER OF BYTES IN CHECKSUM.
NAME_REV         EQU     ADJ_CKSUM+C_WORD_SIZE
END_ADJ          EQU     NAME_REV+(NAME_REV_SIZE*C_BYTE_SIZE)
*
PSYCHO_BOX_NUMBER  EQU   ALL_TIME_VISIBLE-3    ;ON THE WAY TO 17 IF NO BOXES IS TIME FOR BACKGROUND
PSYCHO_FRACTION    EQU   11        ;NUMBER OF SCROLLS BETWEEN NUMBERS FOR BACKGROUND 

**************************************************************************
*                                                                        *
*          ENTER YOUR INITIALS PROCESS OFFSETS                           *
*                                                                        *
**************************************************************************
*
*        LETTER COLORS
*
         .IF     BLUE_P1                        ;IF ITS RELEASE BLUE IS PLAYER 1

P1_COLOR  EQU    0FDFDH                         ;BLUE
P2_COLOR  EQU    0F9F9H                         ;RED
*
P1_SCOL   EQU     SPRAY_BLUE
P2_SCOL   EQU     SPRAY_RED

         .ELSE

P1_COLOR  EQU    0F9F9H                         ;RED
P2_COLOR  EQU    0FDFDH                         ;BLUE
*
P1_SCOL   EQU     SPRAY_RED
P2_SCOL   EQU     SPRAY_BLUE

         .ENDIF
*
*        Y COORDINATE FOR ENTER YOUR INITIALS BLOCK:
*
PLYR_Y           EQU     308*TABLE_UNIT
OP_Y             EQU     307*TABLE_UNIT   ;THIS IS FLAG TO INDICATE OPERATOR!
*
BUTTON_BITS      EQU     0F0H                   ;4 "FIRE" BUTTONS
*
ENT_X_COR        EQU     PDATA                  ;LONG-X COORDINATE OF UPPER LEFT
ENT_Y_COR        EQU     ENT_X_COR+LONG_SIZE    ;LONG-Y COORDINATE OF UPPER LEFT 
ENT_INIT_SIZE    EQU     ENT_Y_COR+LONG_SIZE    ;WORD-DISTANCE BETWEEN INITIALS
ENT_COUNT        EQU     ENT_INIT_SIZE+WORD_SIZE ;WORD-NUMBER TO GET
ENT_COUNTDOWN    EQU     ENT_COUNT+WORD_SIZE    ;WORD-NUMBER LEFT TO GET
ENT_CONST        EQU     ENT_COUNTDOWN+WORD_SIZE    ;WORD-CONSTANT FOR COLOR
ENT_FONT         EQU     ENT_CONST+WORD_SIZE    ;LONG CHARACTER FONT SET
ENT_STICK        EQU     ENT_FONT+LONG_SIZE     ;WORD SHIFT COUNT FOR JOYSTICK
ENT_STRUCT_END   EQU     ENT_STICK+WORD_SIZE     ;END OF PARAMETER AREA
*
ENT_STRUCT_SIZE  EQU     ENT_STRUCT_END-PDATA   ;SIZE OF STRUCTURE
ENT_STRUCT_IN_WORDS  EQU ENT_STRUCT_SIZE/WORD_SIZE
*
ENT_OLIST        EQU     ENT_STRUCT_END        ;LONG.....MY OBJECTS
ENT_INIT_PTR     EQU     ENT_OLIST+LONG_SIZE   ;LONG-PLACE TO PUT NEXT INITIAL
ENT_FROB_OBJ     EQU     ENT_INIT_PTR+LONG_SIZE  ;LONG-OBJECT OF FROB LETTER
ENT_FROB_ASCII   EQU     ENT_FROB_OBJ+LONG_SIZE ;WORD-ASCII FOR WHERE FROB IS
ENT_HAND_OBJ     EQU     ENT_FROB_ASCII+WORD_SIZE ;LONG-PART 2 OF HAND
ENT_SPRAY_PROC   EQU     ENT_HAND_OBJ+LONG_SIZE   ;LONG-OUR SPRAYER PROCESS
ENT_LAST_BUTTON  EQU     ENT_SPRAY_PROC+LONG_SIZE ;WORD-IMAGE OF LAST BUTTON
ENT_Y_OFFSET     EQU     ENT_LAST_BUTTON+WORD_SIZE ;LONG-Y-OFFSET FOR HAND ANIMATION
ENT_ANI_TIMER    EQU     ENT_Y_OFFSET+LONG_SIZE    ;WORD - ANIMATION TIMER
ENT_PRESSED      EQU     ENT_ANI_TIMER+WORD_SIZE   ;WORD - BIT OF BUTTON HE'S HOLDING
ENT_TIMEOUT      EQU     ENT_PRESSED+WORD_SIZE     ;WORD - PASSED TO US AT TIMEOUT
ENT_DATA         EQU     ENT_TIMEOUT+WORD_SIZE     ;LONG - POINTER TO ROM DATA
*
*
*        THE FOLLOWING VARIABLES ARE DEFINED AT THE
*        END OF THE ROM IMAGE FOR THE 2 ROUTINES.  THESE
*        ARE NOT COPIED INTO THE PROCESS AREA.
*
LET_PID          EQU     ENT_STRUCT_END-PDATA    ;WORD-THIS IS IN ROM STRUCTURE
*                                                ;BUT *NOT* STORED IN PROCESS
LET_HAND_PTR     EQU     LET_PID+WORD_SIZE       ;LONG-POINTER TO STFOBJ FOR HAND
LET_SCRIPT       EQU     LET_HAND_PTR+LONG_SIZE  ;LONG - SPRAY SCRIPT FOR SETUP
LET_ERASE        EQU     LET_SCRIPT+LONG_SIZE    ;LONG - SCRIPT TO SET ERASE BRUSH
LET_WIDTH        EQU     LET_ERASE+LONG_SIZE     ;LONG - X DISTANCE FOR EACH SPRAY
LET_MESS         EQU     LET_WIDTH+LONG_SIZE     ;LONG - MESSAGE STRING FOR PLAYER
*
*        FOR COIN PAGE MESSAGES.....WE HAVE UP TO 3 LINES ABOVE
*        THE CREDITS MESSAGE.
*
CP_13    EQU     0BCH                 ;LINE 1 OF 3
CP_23    EQU     0D4H                 ;LINE 2 OF 3
CP_33    EQU     0ECH                 ;LINE 3 OF 3

CP_DELTA3        EQU     CP_23-CP_13        ;AMOUNT TO STEP FROM LINE TO LINE

CP_12    EQU     0CCH                 ;LINE 1 OF 2
CP_22    EQU     0E4H                 ;LINE 2 OF 2

CP_11    EQU     0DAH                 ;SINGLE HELP LINE

CP_CX    EQU     256                  ;CENTER X FOR CREDITS SCREEN STUFF!

**************************************************************************
*                                                                        *
*          MESS_MAC                                                      *
*                                                                        *
*          THIS MACRO IS USED TO SETUP AN "L_MESS" MESSAGE.              *
*          THE MESSAGE FOLLOWS THE MACRO.                                *
*          ZERO TERMINATES THE MESSAGE.                                  *
*          ANOTHER ZERO TERMINATES L_MESS.                               *
*                                                                        *
*          A "1" AFTER THE TERMINATING "0" WILL CAUSE                    *
*          L_MESS TO PRINT OUT ANOTHER MESSAGE.                          *
*                                                                        *
**************************************************************************

MESS_MAC $MACRO  FONT,SPACING,X,Y,COLOR,ROUTINE,SLEEP
         .LONG   :FONT:
         .LONG   :SPACING:
         .LONG   (:Y:*10000H)+:X:
         .LONG   :COLOR:
         .LONG   :ROUTINE:
*         .LONG   :SLEEP:
         $END

SPACING20        EQU     00000002H
SPACING07        EQU     1
*

