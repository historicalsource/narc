	.FILE	'NARCHSTD.ASM'
	.TITLE	"High Score to Date Management"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST
**************************************************************************
*                                                                        *
*          NARC (R)                                                      *
*                                                                        *
*          Copyright 1988 Williams Electronics Games Inc.                *
*          All Rights Reserved                                           *
*                                                                        *
**************************************************************************
*                                                                        *
*          HIGH SCORE TABLE HANDLER                                      *
*                                                                        *
*          Larry DeMar    October 4, 1988                                *
*                                                                        *
**************************************************************************
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
	.INCLUDE	"IMGTBL.GLO"		;GLOBALS
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
         .INCLUDE        "NARCLEQU.ASM"             ;LINKY EQUATES
*
*        IN THIS MODULE
*
         .GLOBAL         GET_HSCR
         .GLOBAL         RC_BYTEI
         .GLOBAL         RC_BYTE
         .GLOBAL         RC_WORD
         .GLOBAL         RC_LONG
         .GLOBAL         RC_LONGI
         .GLOBAL         WC_BYTE
         .GLOBAL         WC_BYTEI
         .GLOBAL         WC_WORD
         .GLOBAL         WC_WORDI
         .GLOBAL         WC_LONG
         .GLOBAL         WC_LONGI
         .GLOBAL         PT_ENTRY
         .GLOBAL         INIT_TB
         .GLOBAL         INIT_TAB    ;GEORGES POWER UP ENTRY
         .GLOBAL         P_FORK 
         .GLOBAL         VAL_TAB
         .GLOBAL         ROM_PTRS
         .GLOBAL         ALL_TAB
         .GLOBAL         TOD_TAB
         .GLOBAL         E_GAME
         .GLOBAL         ISHSTD
         .GLOBAL         SET_PAGE
         .GLOBAL         A2_CHECK
         .GLOBAL         DEC_HSR,INIT_HSR,GET_HSC
*
*        OTHER MODULES
*
*
*        INITAL ENTRY MODULE
*
         .GLOBAL         E_INITS, P1_INITS, P2_INITS
         .GLOBAL         SPRAYS, KIL_SPRY

*
*        SPRAY PAINT MODULE
*
         .GLOBAL         BINBCD
         .GLOBAL         SPR_GPAL, SPR_FPAL 
*
*        NARCHELP
*
         .GLOBAL         DEF_PAGE,GET_ADJ

         .TEXT

**************************************************************************
*                                                                        *
*          HIGH SCORE TABLE DEFINITIONS                                  *
*                                                                        *
**************************************************************************

ALL_TAB
         .LONG   ALL_TIME_ORIGIN           ;LOCATION OF TABLE
         .WORD   ALL_TIME_ENTRIES-1        ;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
         .WORD   ALL_TIME_VISIBLE          ;# VISIBLE (SHOW 20 ALL TIME)
         .WORD   ALL_TIME_SELECT           ;BITS TO SELECT IT
         .LONG   ALL_TIME_ROM_TABLE        ;ROM IMAGE OF TABLE
         .WORD   ALL_TIME_ENTRIES/5        ;RESET TABLE IF 1/5 OR MORE BAD

TOD_TAB
         .LONG   TODAYS_ORIGIN           ;LOCATION OF TABLE
         .WORD   TODAYS_ENTRIES-1        ;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
         .WORD   TODAYS_VISIBLE          ;# VISIBLE (SHOW 20 ALL TIME)
         .WORD   TODAYS_SELECT           ;BITS TO SELECT IT
         .LONG   TODAYS_ROM_TABLE        ;ROM IMAGE OF TABLE
         .WORD   TODAYS_ENTRIES/5        ;RESET TABLE IF 1/5 OR MORE BAD

P_FORK
         MMTM    SP,A1
         MOVE    *A13(PROCID),A1,W    ;PASS OUR ID TO FORKED PROCESS
         CALLA   GETPRC               ;MAKE THE PROCESS
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          AUTO HIGH SCORE TABLE RESET HANDLING                          *
*                                                                        *
**************************************************************************
*                                                                        *
*          DEC_HSR                                                       *
*                                                                        *
*          THIS IS CALLED WITH EACH START OR CONTINUE FOR                *
*          A PLAYER.  IT REMOVES 1 FROM THE HSTD COUNTER UNLESS          *
*          ITS ALREADY SITTING AT ZERO.                                  *
*                                                                        *
**************************************************************************
DEC_HSR  MMTM    SP,A0
         CALLR   GET_HSC         ;THIS IS EASY...GET THE COUNTER
         JRZ     DECHX           ;ITS ZERO....NO ACTION.
         DEC     A0              ;REMOVE A TICK
         CALLR   PUT_HSC         ;PUT IT BACK JAK
DECHX	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          DELAY_HSRESET                                                 *
*                                                                        *
*          THIS IS CALLED WHEN A NEW ENTRY IS MADE IN THE ALL TIME       *
*          HIGH SCORE TABLE.  IF WE'RE CLOSE TO A HIGH SCORE             *
*          RESET, WE PUT IT OFF AWHILE SO HE CAN SHOW HIS FRIENDS        *
*          FOR A FEW DAYS.                                               *
*                                                                        *
**************************************************************************
HS_MIN   EQU     750             ;ALWAYS 750 PLAYS BEFORE REMOVING A FRESH
*                                ;NAME.
DELAY_HSRESET
         MMTM    SP,A0
         CALLR   GET_HSC         ;THIS IS EASY...GET THE COUNTER
         CMPI    HS_MIN,A0       ;IS IT TOO LOW
         JRHS    DHX             ;NOPE...NO ACTION

         MOVI    HS_MIN,A0       ;STOP THE RESET!
         CALLR   PUT_HSC         ;THIS MANY PLAYS TILL RESET!
DHX	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          INIT_HSR                                                      *
*                                                                        *
*          THIS IS CALLED TO INITIALIZE THE HIGH SCORE RESET             *
*          COUNTER TO ITS ADJUSTED VALUE.                                *
*                                                                        *
**************************************************************************
INIT_HSR MMTM    SP,A0
         MOVI    ADJHSRES,A0
         CALLA   GET_ADJ              ;GET THE ADJUSTED VALUE
         CALLR   PUT_HSC              ;SET IT TO THIS VALUE
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          PUT_HSC                                                       *
*                                                                        *
*          THIS IS CALLED TO SET THE HIGH SCORE RESET COUNTER            *
*          TO THE VALUE IN A0.                                           *
*                                                                        *
**************************************************************************
PUT_HSC  MMTM    SP,A7,A0
         CALLR   HSR_PAGE             ;HIGH SCORE PAGE

         MOVI    HRESET_COUNTER,A7    ;POINT AT 
         CALLR   WC_LONGI             ;WRITE OUR PARAMETER
         NOT     A0                   ;NEGATE IT.
         CALLR   WC_LONG              ;AND WRITE IN SUBSEQUENT SPOT.
         CALLA   DEF_PAGE             ;FLIP PAGE
	MMFM    SP,A7,A0             ;AND RETURN
	RETS

**************************************************************************
*                                                                        *
*          GET_HSC                                                       *
*                                                                        *
*          THIS IS CALLED TO FETCH THE HIGH SCORE COUNTER IN A0.         *
*          IF IT IS INVALID, IT WILL IMMEDIATELY BE RESET TO THE         *
*          ADJUSTED VALUE AND THIS IS WHAT WILL BE RETURNED              *
*          IN A0.           .EQ. MEANS ITS AT ZERO!                      *
*                                                                        *
**************************************************************************
GET_HSC  MMTM    SP,A7,A1
         CALLR   HSR_PAGE             ;POINT PAGE AT HSR

         MOVI    HRESET_COUNTER,A7    ;POINT AT 
         CALLR   RC_LONGI             ;READ THE VALUE
         MOVE    A0,A1                ;STASH IT
         CALLR   RC_LONG              ;READ VERIFIER
         NOT     A0                   ;SEE IF ITS VALID
         CMP     A0,A1
         JRZ     GET_HSCX             ;IT IS....RETURN IT.

         CALLR   INIT_HSR             ;REFRESH IT WITH FACTORY VALUE
*
*        NOW RETURN THE FACTORY VALUE IN CASE IT DIDN'T TAKE
*
         MOVI    ADJHSRES,A0
         CALLA   GET_ADJ              ;GET THE ADJUSTED VALUE

GET_HSCX CALLA   DEF_PAGE             ;FLIP PAGE AWAY FROM US
         MOVE    A0,A0                ;SET Z FLAG BASED ON COUNTER
	MMFM    SP,A7,A1
	RETS

HSR_PAGE MMTM    SP,A1
         MOVI    HSR_SELECT,A1
         CALLR   SET_PAGE
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          HIGH LEVEL HSTD ROUTINES                                      *
*                                                                        *
**************************************************************************

TEN_X    EQU     0F00000H
ONE_O_X  EQU     0F40000H
ONE_X    EQU     0FE0000H

TIMER_TENS
         .LONG   0,0,TEN_X,1500000H             ;XV, YV, XP, YP
         .WORD   0,30                           ;Z VEL 10....Z POS 0
         .LONG   NO_IMG,1,DUMCOLL               ;IMG, Z SIZE, COLLISION VECT
         .WORD   DMACNZ,5                       ;WRITE NON-ZERO CONSTANT, OBJECT ID
         .LONG   0                              ;NO SCANNER BLIP

TIMER_UNITS
         .LONG   0,0,ONE_X,1500000H             ;XV, YV, XP, YP
         .WORD   0,30                           ;Z VEL 10....Z POS 0
         .LONG   NO_IMG,1,DUMCOLL               ;IMG, Z SIZE, COLLISION VECT
         .WORD   DMACNZ,5                       ;WRITE NON-ZERO CONSTANT, OBJECT ID
         .LONG   0                              ;NO SCANNER BLIP

NO_IMG
         .WORD   4,4,0,0                        ;WIDTH, HEIGHT, OFFSET,OFFSET
         .LONG   IROM,NARCS                     ;SOURCE, PALETTE

**************************************************************************
*                                                                        *
*          E_GAME                                                        *
*                                                                        *
*          THIS PROCESS IS GIVEN CONTROL AT GAME OVER.  ITS              *
*          JOB IS TO GET INITIALS FROM THE PLAYER IF NECESSARY.          *
*                                                                        *
**************************************************************************
E_GAME   SLEEP   1                         ;GET FRESH TIMER FOR HEAVY WORK COMING!
         CALLA   SPR_GPAL                  ;GET GLOBAL PALETTE FOR SPRAYER

         CLR     A1
         MOVE    A1,@SPRAYS,W              ;NOBODY IS SPRAYING YET!

         MOVI    END_GAME_PID,A1
         MOVE    A1,*A13(PROCID),W         ;SET OUR ID TO SOMETHING UNIQUE

         MOVE    @P2DATA+PSCORE,A8,L       ;PASS THE SCORE TO THE PROCESS
         MOVE    @P1DATA+PSCORE,A10,L      ;PASS *OTHER* SCORE IN A10
         MOVI    P2_INITS,A9               ;DATABASE FOR P1
         MOVE    A13,A11                   ;PASS OUR ID IN A11
         MOVI    GET_LET,A7                ;PROCESS NAME
         CALLR   P_FORK                    ;START IT

         MOVE    @P1DATA+PSCORE,A8,L
         MOVE    @P2DATA+PSCORE,A10,L      ;PASS *OTHER* SCORE IN A10
         MOVI    P1_INITS,A9
         MOVI    GET_LET,A7
         CALLR   P_FORK
*
         MOVI    31,A0                     ;STORE TIMER IN PROCESS AREA
         MOVE    A0,*A13(PDATA),W          ;LET THE GUY ABOVE US WATCH THIS!
*
*        NOW WE'VE STARTED EM.......SEE IF ANYONE IS HANGING AROUND?
*
         SLEEP   8                         ;GIVE EM STARTUP TIME
         CALLR   HSTD_P                    ;ANYONE ALIVE?
         JRZ     HSTD_DONE                 ;NOPE......EXIT
*
*        THEY'RE RUNNING.....LETS PUT UP A TIMER!
*
         CALLR   SETUP_TIMER

WAIT_FOR_INIT_PS
         CALLR   BLANK_TIMER               ;BLANK OUT THE CURRENT NUMBER
         SLEEP   2                         ;LET THE BLINKING HIT
         MOVE    *A13(PDATA),A0,W          ;GET TIME IN A0
         JREQ    SLEEP_TICK                ;KEEP OFF AT REAL ZERO
         DEC     A0                        ;SHOW 1 LESS TO MAKE ZERO SHOW

         CALLA   BINBCD                    ;CONVERT TO BCD
         CALLR   UPDATE_TIMER              ;AND DISPLAY IT!

         MOVI    6,A8                      ;6 TICKS PER TOCK
SLEEP_TICK
         SLEEP   8
         CALLR   HSTD_P                    ;ANYONE ALIVE?
         JRZ     CLEANUP_TIMER             ;NOPE....WE'RE DONE!
         DSJS    A8,SLEEP_TICK

         MOVE    *A13(PDATA),A0,W          ;GET TIMER
         JREQ    WAIT_FOR_INIT_PS          ;OUT OF TIME...LEAVE IT

         DEC     A0
         MOVE    A0,*A13(PDATA),W          ;PUT BACK
         JRUC    WAIT_FOR_INIT_PS

CLEANUP_TIMER
         CALLR   BLANK_TIMER               ;BLANK OUT THE TIMER
         SLEEP   2                         ;LET IT GO BLANK

         MOVE    A10,A0
         JRZ     TENS_ZAPPED

         CALLA   DELPAL                    ;TRASH IT!
         CALLA   DELOBJ

TENS_ZAPPED
         MOVE    A9,A0
         CALLA   DELPAL                    ;TRASH IT!
         CALLA   DELOBJ

HSTD_DONE
         SOUND1  KIL_SPRY                  ;TURN OFF ANY REMNANT SPRAY SOUND
         CALLA   SPR_FPAL                  ;FREE UP THE GLOBAL SPRAYER PALETTE
         RETP                              ;THEY'RE DONE..RETURN

TIMER_COLOR      EQU     0F5F5H            ;CONSTANT USED FOR TIMER

SETUP_TIMER
         MOVI    TIMER_UNITS,A14
         CALLR   GET_DIGIT
         MOVE    A0,A9                     ;KEEP UNITS IN A9

         MOVI    TIMER_TENS,A14
         CALLR   GET_DIGIT
         MOVE    A0,A10                    ;THEY'RE SET!
         RETS

GET_DIGIT
         MMTM    SP,A1
         CALLA   GPALOBJ                   ;GET THE STUFF
         CALLA   STFOBJ

         MOVI    TIMER_COLOR,A1
         MOVE    A1,*A0(OCONST),W

         CALLA   INSOBJ                    ;ITS SET
	MMFM    SP,A1
	RETS

UPDATE_TIMER
         MOVE    A0,A3                     ;FIRST DO TENS
         MOVE    A3,A1
         SRL     4,A1
         JRNZ    REAL_TENS

         MOVE    A10,A0
         JRZ     TENS_GONE
         CALLA   DELPAL                    ;TRASH IT!
         CALLA   DELOBJ
         CLR     A10

         MOVI    (TEN_X+ONE_X)/2,A0
         MOVE    A0,*A9(OXVAL),L           ;CENTER THE ONES

         JRUC    TENS_GONE

REAL_TENS
         CMPI    1,A1                      ;ARE WE DOWN TO "10"
         JRNZ    NOT_ONE_0

         MOVI    ONE_O_X,A0
         MOVE    A0,*A10(OXVAL),L          ;SLIDE IT OVER TO LOOK NICE!
NOT_ONE_0
         MOVE    A10,A2                    ;GET 10'S OBJECT IN A2
         CALLR   UPDATE_NUMBER             ;OBJECT A2 GETS NUMBER IN A1

TENS_GONE
         MOVE    A3,A1
         MOVE    A9,A2
         CALLR   UPDATE_NUMBER
	RETS

BLANK_TIMER
         MMTM    SP,A0
         CLR     A0
         MOVE    A0,*A9(OCONST),W
         MOVE    A10,A10                   ;TENS PRESENT?
         JREQ    BT_NT                     ;NOPE
         MOVE    A0,*A10(OCONST),W
BT_NT	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          UPDATE_NUMBER                                                 *
*                                                                        *
*          OBJECT IN A2                                                  *
*          NIBBLE IN A1                                                  *
*                                                                        *
*          GET CORRECT NUMBER IMAGE IN THE OBJECT.                       *
*                                                                        *
*                                                                        *
**************************************************************************
UPDATE_NUMBER
         MMTM    SP,A1,A4,A6,A7,A8
         MOVI    RD15FONT,A6
         ANDI    0FH,A1
         ADDI    LET_0-EX_PT,A1       ;INDEX TO TABLE
         SLL     5,A1                 ;
         ADD     A1,A6                ;POINT TO IMAGE (A1 FOR ANI)
         MOVE    *A6,A1,L             ;FETCH THE IMAGE FOR ANI

         MOVE    A2,A8                ;OBJECT STRUCTURE FOR ANI
         MOVE    *A2(OFLAGS),A4,W     ;FETCH THE OFLAGS
         CALLA   ANI                  ;SET NEW ANIMATION PICTURE

         MOVI    TIMER_COLOR,A6       ;GET THE DRAWING COLOR BACK OUT.
         MOVE    A6,*A2(OCONST),W

	MMFM    SP,A1,A4,A6,A7,A8
	RETS

**************************************************************************
*                                                                        *
*          HSTD_P                                                        *
*                                                                        *
*          ARE EITHER OF THE ENTER INITIALS PROCESSES ALIVE.             *
*          JRNZ MEANS YES.                                               *
*                                                                        *
**************************************************************************
HSTD_P   MMTM    SP,A0,A1
         MOVI    END_GAME_PID,A0
         MOVI    0FFFFH,A1
         CALLA   EXISTP
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          GET_LET                                                       *
*                                                                        *
*          THIS IS THE RE-ENTRANT ROUTINE FOR EACH PLAYER'S              *
*          GET YOUR INITIALS.                                            *
*                                                                        *
*          A8 HAS THE SCORE.                                             *
*          A9 HAS THE GET INITIALS DESCRIPTOR STRING.                    *
*          A10 HAS SCORE OF "OTHER" PLAYER                               *
*          A11 HAS POINTER TO PROCESS THAT CREATED US                    *
*                                                                        *
*          WE LOOK UP THE SCORE IN THE VARIOUS TABLES.                   *
*          IF ITS GOOD ENOUGH IN EITHER TABLE, THEN                      *
*          CREATE A GET THE INITIALS PROCESS.                            *
*                                                                        *
*          THAT PROCESS STORES THE INITIALS IN OUR PROCESS               *
*          STORE AREA.                                                   *
*                                                                        *
*          WHEN IT DIES, WE TAKE THE INITIALS AND PUT THEM               *
*          IN THE HIGH SCORE TABLES.                                     *
*                                                                         *
**************************************************************************
GL_SCORE         EQU     PDATA                  ;LONG - SCORE OF PLAYER
GL_DAD           EQU     GL_SCORE+LONG_SIZE     ;LONG-FATHER PROCESS.....TO WATCH HIS TIMER
GL_SON           EQU     GL_DAD+LONG_SIZE       ;LONG-SON TO CLEANUP ON TIMEOUT
GL_INITS         EQU     GL_SON+LONG_SIZE       ;NUMBER OF INITS - PLACE TO STORE FETCHED INITS
*

GET_LET  CALLR   CHECK_ALL_TIME                 ;ARE WE ON THE ALL TIME TABLE?
         JRNZ    GET_EM                         ;WE ARE...GET INITS
         CALLR   CHECK_TODAY
         JRZ     TOO_BAD                        ;DIDN'T MAKE IT..EXIT

GET_EM   MOVE    A11,*A13(GL_DAD),L             ;SAVE THE TIMER GUY
         MOVE    A8,*A13(GL_SCORE),L            ;SAVE THE SCORE IN MEMORY
         MOVE    A9,A8                          ;PASS STRUCTURE IN A8
         MOVE    A13,A9                         ;POINT IN OUR PROCESS AREA 
*                                               ;TO PLACE TO STORE
         ADDI    GL_INITS,A9                    ;POINT RIGHT AT INITIALS
         MOVI    E_INITS,A7                     ;THIS IS THE PROCESS TO MAKE
         MOVE    *A8(LET_PID),A1,W              ;FETCH ID FOR THIS ONE
         CALLA   GETPRC                         ;MAKE THE PROCESS

         MOVE    A0,*A13(GL_SON),L              ;SAVE HIS ID.

         MOVE    A1,A8                          ;SAVE THE ID
*         MOVI    SPACE,A0                       ;BLANK OUT THE INITIALS
         CLR     A0                             ;ZERO MEANS NOT ENTERED YET
         MOVI    NUM_INITS,A1
*
*        A9 POINTS AT INITIAL STORAGE AREA
*
SP_STOR  MOVB    A0,*A9                         ;PUT A SPACE WHERE POINTER POINTS
         ADDI    BYTE_SIZE,A9                   ;PUSH POINTER
         DSJS    A1,SP_STOR

GETTING  SLEEP   8                              ;WAIT FOR IT TO FINISH
         MOVE    A8,A0
         MOVI    0FFFFH,A1
         CALLA   EXISTP                          ;IS HE DONE?
         JRZ     FINISHED                        ;YEP.....NO CLEANUP REQUIRED!

         MOVE    *A13(GL_DAD),A0,L              ;CHECK DAD'S TIMER
         MOVE    *A0(PDATA),A0,W                ;THIS IS WHERE HE KEEPS IT!
         JRNZ    GETTING                        ;ITS RUNNING....CONTINUE
*
*        DAD TIMED OUT....OUR PROC IS RUNNING
*
         MOVE    *A13(GL_SON),A1,L              ;GET THE GUY...WE'RE GONNA TRASH HIM
         MOVI    1,A0
         MOVE    A0,*A1(ENT_TIMEOUT),W          ;TELL HIM HE'S TIMED OUT!
         JRUC    GETTING                        ;AND WAIT FOR HIS CLEANUP!

FINISHED
         MOVE    *A13(GL_SCORE),A0,L            ;GET THE SCORE
         MOVE    A13,A1                         ;SETUP POINTER TO INITIALS
         ADDI    GL_INITS,A1                    ;NOW WE'RE SET

         MOVI    TOD_TAB,A8                     ;ALWAYS ADD TO TODAYS (EVEN IF SPACES)
         CALLR   ADD_ENTRY                      ;ADD EM TO THIS ONE IF NEC.

         CALLR   CHECK_INITS                    ;SEE IF ALL BLANK  
         JRZ     TOO_BAD                        ;DON'T ADD UGLY ONES.

         MOVI    ALL_TAB,A8
         CALLR   ADD_ENTRY                      ;ADD EM TO THE TABLE
         JRC     TOO_BAD                        ;DIDN'T MAKE ALL TIME

         CALLR   DELAY_HSRESET                  ;NEW ENTRY....DON'T RESET TOO QUICK

TOO_BAD  JAUC    SUCIDE                         ;WE'RE DONE!

**************************************************************************
*                                                                        *
* 	ISHSTD								 *
* 									 *
* 	DID ANYONE MAKE THE HIGH SCORE TABLE.				 *
* 									 *
* 	.EQ.		NO						 *
* 	.NE.		YES						 *
*                                                                        *
**************************************************************************
ISHSTD	MMTM	SP,A8,A10
	MOVE	@P1DATA+PSCORE,A8,L
	MOVE	@P2DATA+PSCORE,A10,L

	CALLR	CHECK_ALL_TIME
	JRNZ	VERY_HIGH

	CALLR	CHECK_TODAY
	JRNZ	VERY_HIGH

	SWAP	A8,A10
	
	CALLR	CHECK_ALL_TIME
	JRNZ	VERY_HIGH

	CALLR	CHECK_TODAY
VERY_HIGH
	MMFM	SP,A8,A10
	RETS

CHECK_ALL_TIME
         MMTM    SP,A0,A2,A8
         MOVE    A8,A0
         MOVE    A10,A2                         ;SHOW "OTHER" SCORE IN A2
         MOVI    ALL_TAB,A8
         CALLR   CHECK_SCORE                    
	MMFM    SP,A0,A2,A8
	RETS

CHECK_TODAY
         MMTM    SP,A0,A2,A8               
         MOVE    A10,A2                         ;SHOW "OTHER" SCORE IN A2
         MOVE    A8,A0
         MOVI    TOD_TAB,A8
         CALLR   CHECK_SCORE                    
	MMFM    SP,A0,A2,A8               
	RETS

**************************************************************************
*                                                                        *
*          A2_CHECK                                                      *
*                                                                        *
*          DOES THE SCORE IN A2 MATCH EITHER OF THE PLAYER'S SCORE.      *
*          .EQ.  MEANS YES                                               *
*          .NE.  MEANS NO                                                *
*                                                                        *
*          THIS IS A NARCSPRY MODULE MOVED HERE TO FREE                  *
*          NARCSPRY DEPENDANCY ON NARCEQU  (T.I. B.D. OVERFLOWS)         *
*                                                                        *
**************************************************************************
A2_CHECK
         MMTM    SP,A0
         MOVE    @P1DATA+PSCORE,A0,L
         CMP     A2,A0
         JREQ    A2_SUCC              ;IT WAS PLAYER 1'S SCORE

         MOVE    @P2DATA+PSCORE,A0,L
         CMP     A2,A0

A2_SUCC  MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          CHECK_INITS                                                   *
*                                                                        *
*          A1 POINTS AT A SET OF INITIALS ENTERED.  RETURN .EQ.          *
*          IF THEY'RE ALL SPACES (OR ZERO).                              *
*                                                                        *
**************************************************************************
CHECK_INITS
         MMTM    SP,A0,A1,A2
         MOVI    NUM_INITS,A2
CHECK_NEXT
         MOVB    *A1,A0               ;GET AN INITIAL
         JRZ     SPACE_FOUND          ;NULL IS A SPACE
         CMPI    SPACE,A0             ;IS IT A REAL SPACE?
         JRNZ    LET_FOUND
SPACE_FOUND
         ADDI    BYTE_SIZE,A1
         DSJS    A2,CHECK_NEXT
         CLR     A2                   ;SET Z BIT ON FALL THROUGH

LET_FOUND
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          CHECK_SCORE                                                   *
*                                                                        *
*          THIS IS CALLED WITH A SCORE IN A0 TO SEE IF IT                *
*          IS HIGH ENOUGH TO MAKE THE TABLE.                             *
*                                                                        * 
*          THE OTHER PLAYER'S SCORE IS PASSED IN A2.  IF                 * 
*          THE PLAYER MAKES THE LAST POSITION OF THE TABLE,              *
*          THEN HIS SCORE IS COMPARED AGAINST THE OTHER SCORE            *
*          IT MUST BE HIGHER THAN THE OTHER SCORE, OTHERWISE             *
*          HE WILL ENTER HIS INITIALS, BUT THERE WILL BE NO              *
*          PLACE TO PUT THEM WHEN HIS BUDDY IS DONE ENTERING HIS!        *
*                                                                        *
*          THIS ROUTINE CALLS FIND_TABLE_LEVEL WHICH RETURNS             *
*          THE POINT IN THE TABLE THAT THE PASSED SCORE WOULD            *
*          LAND.   THIS VALUE MUST BE LESS THAN OR EQUAL TO              *
*          THE "TB_VISIBLE" VALUE FOR THE TABLE.  THIS WOULD             *
*          MEAN THAT WE WANT TO GET THE PLAYER'S INITIALS.               *
*                                                                        *
*          A8 CONTAINS ROM POINTER FOR TABLE TO CHECK.                   *
*          RETURN A0 = 0 (AND .EQ.) IF SCORE ISN'T HIGH ENOUGH           *
*          AND A0 = POSITION IN TABLE IF SCORE MAKES IT.                 *
*                                                                        *
**************************************************************************
CHECK_SCORE
         MMTM    SP,A1,A3,A9,A10
         MOVE    A0,A3                     ;STASH SCORE IN A3
         CALLR   FIND_TABLE_LEVEL          ;SEE WHERE WE LAND IN THIS TABLE
         JRZ     ANSWER_IN_A0              ;ZERO.....GUY DIDN'T MAKE IT
         MOVE    *A8(TB_VISIBLE),A1,W      ;GET THE NUMBER "ENTERED"
         CMP     A1,A0                     ;A0 MUST BE LESS OR EQUAL
         JRLO    ANSWER_IN_A0              ;NOT LAST ENTRY...RETURN SUCCESS
         JRHI    DIDNT_MAKE_HSTD
*
*        GUY IS GOING FOR LAST POSITION.....SEE IF HIS BUDDY IS
*        GOING TO NOSE HIM OUT:
*
         CMP     A2,A3                     ;HI MUST BE HIGHER THAN BUDDY
         JRHI    ANSWER_IN_A0
*
*
*        ****** NOTE  NOTE NOTE NOTE NOTE NOTE NOTE NOTE ******
*        ****** NOTE  NOTE NOTE NOTE NOTE NOTE NOTE NOTE ******
*
*        NOTE THAT IF BOTH PLAYERS HAVE AN IDENTICAL SCORE THAT
*        WOULD MAKE THE LAST POSITION OF A TABLE, THEN THEY
*        WONT GET TO ENTER THEIR INITIALS!!!!!!
*
*        TOUGH LUCK!     -LED  10/22/88
*
*        ****** NOTE  NOTE NOTE NOTE NOTE NOTE NOTE NOTE ******
*        ****** NOTE  NOTE NOTE NOTE NOTE NOTE NOTE NOTE ******
*
*
*        WE WOULD MAKE THE PHYSICAL TABLE, BUT WE'RE OUT OF
*        WHAT THE PLAYER CAN SEE....RETURN FALSE
*
DIDNT_MAKE_HSTD
         CLR     A0                        ;RETURN FAILURE
ANSWER_IN_A0:
         MOVE    A0,A0                     ;SET EQ BIT ACCORDINGLY
	MMFM    SP,A1,A3,A9,A10
	RETS

**************************************************************************
*                                                                        *
*          ADD_ENTRY                                                     *
*                                                                        *
*          THIS IS CALLED AFTER "ENTER YOUR INITIALS" TO                 *
*          ADD AN ENTRY TO THE TABLE.  A0 CONTAINS THE                   *
*          SCORE OF THE PLAYER.  A1 CONTAINS A POINTER                   *
*          TO THE FETCHED INITIALS.   THE INITIALS ARE                   *
*          STORED AS CONSECUTIVE BYTES IN CONVENTIONAL                   *
*          (1 BYTE TAKES 1 BYTE SPACE) RAM.                              *
*                                                                        *
*          A8 contains a the table to store the entry in.                *
*                                                                        *
*          RETURN CARRY SET IF IT DIDN'T MAKE IT INTO REQUESTED TABLE    *
*                                                                        *
**************************************************************************
ADD_ENTRY
         MMTM    SP,A0,A1,A2,A3,A4,A7,A9,A10
         CALLR   ROM_PTRS                  ;SETUP FOR THIS TABLE
         MOVE    A0,A4                     ;STASH THE SCORE A SEC.
         CLR     A2                        ;DONT WORRY ABOUT OTHER GUY AT THIS POINT
         CALLR   CHECK_SCORE               ;DOES THE REQUEST MAKE IT?
         SETC                              ;ANTICIPATE FAILURE
         JRZ     DIDNT_MAKE_IT             ;DON'T KNOW WHY I GOT THESE INITS.
*
*        A0 NOW HAS THE PLACE FOR THE NEW GUY.
*        MOVE THE ENTIRE TABLE DOWN 1 UNIT.
*
         MOVE    A10,A3                    ;LAST GUY IN TABLE IS DESTINATION
COPY_DOWN_LOOP
         MOVE    A3,A2                     ;GUY BEFORE HIM IS SOURCE
         DEC     A2                        ;A2 NOW HAS SOURCE
         CMP     A0,A2                     ;IS SOURCE LOWER THAN OUR SLOT? 
         JRLO    COPY_DONE                 ;IT IS...DON'T MOVE HIM.  

         CALLR   COPY_ENTRY                ;COPY A2 ENTRY TO A3
         DEC     A3                        ;MOVE DOWN TO ONE BEFORE
         JRUC    COPY_DOWN_LOOP

COPY_DONE
         CALLR   PUT_SCORE_FOR_ENTRY       ;SCORE IN A4 WRITTEN TO ENTRY A0
*
*        INITAIAL POINTER IS IN A1
*        TABLE OFFSET IN A0
*
         CALLR   PT_ENTRY                  ;GET ENTRY POINTER IN A7
         ADDI    HS_INITS,A7               ;POINT AT FIRST INITIAL
         MOVI    NUM_INITS,A2              ;THIS IS NUMBER OF INITIALS
         MMTM    SP,A0                     ;SAVE A0

INIT_COPY_LOOP
         MOVB    *A1,A0                    ;GET AN INITIAL
         JRNZ    NOT_BLANK
         MOVI    SPACE,A0                  ;REPLACE BLANKS WITH SPACES
NOT_BLANK
         CALLR   WC_BYTEI       ;WRITE THE BYTE AND INCREMENT
         ADDI    BYTE_SIZE,A1              ;A1 TO NEXT BYTE PLEASE
         DSJ     A2,INIT_COPY_LOOP

	MMFM    SP,A0                     ;GET BACK ENTRY NUMBER
         CALLR   FORM_HS_CKSUM_AND_STORE   ;FOR CHECKSUM FOR THIS ENTRY AND STORE!
         CLRC                              ;RETURN SUCCESS!

DIDNT_MAKE_IT
	MMFM    SP,A0,A1,A2,A3,A4,A7,A9,A10
	RETS

**************************************************************************
*                                                                        *
*          FIND_TABLE_LEVEL                                              *
*                                                                        *
*          THIS IS CALLED TO COMPARE THE SCORE IN A0 TO                  *
*          THE TABLE POINTED TO BY A8.                                   *
*                                                                        *
*          RETURN PHYSICALLY WHERE IT FITS IN A0, AND                    *
*          SET THE Z FLAG ACCORDINGLY                                    *
*                                                                        *
**************************************************************************
FIND_TABLE_LEVEL
         MMTM    SP,A1,A2,A3
         CALLR   ROM_PTRS                  ;SETUP FOR THIS TABLE
         CALLR   VAL_TAB                   ;FIX THE TABLE IN CASE ITS BROKEN.
         JRC     FTL_FAIL                  ;CAN'T VALIDATE..SAY SCORE DIDN'T MAKE IT

         MOVE    A0,A2                     ;KEEP SCORE IN A2
         MOVK    1,A0                      ;START AT 1 AND WORK UP.

CHECK_NEXT_SCORE
         CALLR   GET_HSCR       ;FETCH A0 ENTRY'S SCORE IN A1
         CMP     A1,A2                     ;HOW DO WE FARE AGAINST A1?
         JRHI    FOUND_THE_SPOT            ;WE FOUND THE SPOT
         INC     A0                        ;KEEP MOVING DOWN TILL WE FIT
         CMP     A10,A0                    ;ARE WE LOOKING AT THE LAST ONE?
         JRLS    CHECK_NEXT_SCORE

FTL_FAIL
         CLR     A0                        ;WE'RE NOT HIGH ENOUGH RETURN FAILURE

FOUND_THE_SPOT
         MOVE    A0,A0                     ;MAKE SURE YOU SET THE FLAGS
	MMFM    SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
*          GET_HSCR                                                      *
*                                                                        *
*          THIS IS CALLED TO FETCH THE SCORE FROM CMOS FOR               *
*          A GIVEN ENTRY.                                                *
*                                                                        *
*          ENTRY NUMBER PASSED IN A0.                                    *
*          SCORE RETURNED IN A1.                                         *
*                                                                        *
**************************************************************************
GET_HSCR
         MMTM    SP,A7,A0
         CALLR   PT_ENTRY                  ;POINT A7 AT ENTRY
         ADDI    HS_SCORE,A7               ;INDEX SCORE PART.
         CALLR   RC_LONG            ;FETCH THE LONG WORD INTO A0
         MOVE    A0,A1                     ;MOVE TO A1
	MMFM    SP,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          PUT_SCORE_FOR_ENTRY                                           *
*                                                                        *
*          THIS IS CALLED TO WRITE OUT THE SCORE FOR A GIVEN ENTRY.      *
*          ENTRY SPECIFIED BY A0.                                        *
*          SCORE PASSED IN A4.                                           *
*                                                                        *
**************************************************************************
PUT_SCORE_FOR_ENTRY
         MMTM    SP,A7,A0
         CALLR   PT_ENTRY                  ;POINT A7 AT ENTRY
         ADDI    HS_SCORE,A7               ;INDEX SCORE PART.
         MOVE    A4,A0                     ;MOVE SCORE TO A0
         CALLR   WC_LONG           ;WRITE OUT THE LONG WORD 
	MMFM    SP,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          LOW LEVEL HSTD PROCESSING                                     *
*                                                                        *
**************************************************************************
*
*        FOR HIGH SCORE ROUTINES
*
*        A8  = ROM POINTER FOR A GIVEN TABLE STATS
*        A9  = RAM POINTER FOR CMOS DATA
*        A10 = NUMBER OF ENTRIES IN THE TABLE
*
*        A0  = PARTICULAR ENTRY TO DEAL WITH
*                0 = FILL ENTRY (POINTER ROUTINES POINT HERE IF ERROR)
*                1 = HIGHEST SCORE IN TABLE
*                N = NTH SCORE
*
*        A1  = OUTPUT OF CHECKSUM ROUTINE  (BYTE)
*
*        A7  = POINTER TO CURRENT ENTRY
*
*        A4,A5,A6  SCRATCH
*
**************************************************************************
*                                                                        *
*          FORM_HS_CKSUM                                                 *
*                                                                        *
*          THIS IS CALLED TO FORM THE CHECKSUM FOR THE SCORE             *
*          NUMBER IN A0.  (RAM POINTER ASSUMED IN A9).                   *
*          CHECKSUM IS RETURNED IN A1.   THIS IS A *BYTE*.               *
*                                                                        *
*          CHECKSUM IS COMPUTED AS THE COMPLEMENT OF THE SIMPLE SUM      *
*          OF THE BYTES IN THE ENTRY.                                    *
*                                                                        *
*          THIS ROUTINE RETURNS WITH THE Z BIT SET (.EQ.) IF THE         *
*          CHECKSUM FOR THIS ENTRY MATCHES.                              *
*                                                                        *
**************************************************************************
FORM_HS_CKSUM
         MMTM    SP,A0,A4,A6,A7
         CALLR   PT_ENTRY                  ;A7 = POINTER TO CURRENT ENTRY
         MMTM    SP,A7                     ;SAVE POINTER TO ENTRY
         MOVI    HS_BYTES_TO_CHECK,A4      ;COUNT DOWN THE BYTES
         CLR     A1                        ;KEEP SUM IN A1
ADD_A_BYTE
         CALLR   RC_BYTEI        ;GET A BYTE INTO A0
         ADD     A0,A1                     ;ADD TO SUM
         DSJ     A4,ADD_A_BYTE             ;ONE MORE ADDED
         NOT     A1                        ;CHECKSUM IS NOW IN LOW BYTE
         ANDI    BYTE_MASK,A1                   ;MASK SO ITS COOL
	MMFM    SP,A7                     ;GET POINTER BACK
         ADDI    HS_CKBYTE,A7              ;POINT AT CHECKBYTE
         CALLR   RC_BYTE            ;READ IN THE BYTE
         CMP     A0,A1                     ;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM    SP,A0,A4,A6,A7                  ;Z BIT RETURNS COMPARE
	RETS                              ;A1 RETURNS CKSUM

**************************************************************************
*                                                                        *
*          FORM_HS_CKSUM_AND_STORE                                       *
*                                                                        *
*          THIS IS USED TO SET THE CHECKSUM FOR THE CURRENT              *
*          ENTRY (A0) TO THE CORRECT VALUE.                              *
*                                                                        *
**************************************************************************
FORM_HS_CKSUM_AND_STORE
         MMTM    SP,A0,A7
         CALLR   FORM_HS_CKSUM             ;GET THE CKSUM IN A1, POINTER IN A7
         CALLR   PT_ENTRY                  ;POINT AT THE VALUE
         ADDI    HS_CKBYTE,A7              ;POINT AT CHECKBYTE
         MOVE    A1,A0                     ;GET CHECKBYTE TO A0
         CALLR   WC_BYTE           ;WRITE OUT THE BYTE
	MMFM    SP,A0,A7
	RETS

**************************************************************************
*                                                                        *
*          PT_ENTRY                                                      *
*                                                                        *
*          THIS IS CALLED TO POINT AT A GIVEN ENTRY OF                   *
*          THE HIGH SCORE TABLE.  THIS ROUTINE BASES                     *
*          ACTIVITY ON ROM POINTER IN A8.  IT FETCHES                    *
*          FRESH COPIES OF THE A9 RAM POINTER AND THE                    *
*          A10 ENTRY COUNTER.  IT RETURNS THE ENTRY                      *
*          POINTER IN A7.                                                *
*                                                                        *
*          A0 SPECIFIES WHICH ENTRY TO POINT AT                          *
*          A8,A9,A10 AND SYSCTRL ASSUMED SET PROPERLY                    *
*          A7 RETURNED POINTING TO THAT ENTRY                            *
*                                                                        *
**************************************************************************
PT_ENTRY
         CMP     A10,A0                   ;A10 IS MAX VALUE
         JRLS    POINTER_IN_RANGE

         .IF DEBUG
            JRUC   $                         ;HANG IN DEVELOPMENT
         .ENDIF

         MOVE    A9,A7                     ;RETURN ZERO OFFSET IN FIELD
         RETS

POINTER_IN_RANGE
         MOVI    HS_SIZE,A7                ;SIZE OF ENTRY
         MPYU    A0,A7                     ;OFFSET OF ENTRY
         ADD     A9,A7                     ;ADD IN THE BASE
         RETS

**************************************************************************
*                                                                        *
*          ROM_PTRS                                                      *
*                                                                        *
*          THIS IS CALLED TO LOAD UP THE ROM STRUCTURE                   *
*          DATA INTO REGISTERS.                                          *
*                                                                        *
*          THIS ALSO SETS UP STATUS WORD TO SELECT THE CMOS              *
*          BANK SELECT FOR WHERE THE PARTICULAR TABLE RESIDES.           *
*                                                                        *
*          INPUT A8    = HSTD STRUCTURE ROM POINTER.                     *
*                                                                        *
*          OUTPUT  A9  = CMOS RAM POINTER TO BASE OF TABLE               *
*          OUTPUT  A10 = LAST ENTRY IN TABLE.  TABLE WILL                *
*                          HAVE A10+1 ENTRIES SINCE ENTRY                *
*                          0 IS A FILLER.                                *
*                                                                        *
**************************************************************************
ROM_PTRS
         MMTM    SP,A0,A1                  ;SCRATCH REGGIES
         MOVE    *A8(TB_POINTER),A9,L      ;GET CMOS POINTER
         MOVE    *A8(TB_COUNT),A10,W       ;GET NUMBER OF ENTRIES
         MOVE    *A8(TB_PAGE_BITS),A1      ;GET OUR CMOS PAGE BITS

         CALLR   SET_PAGE                  ;

	MMFM    SP,A0,A1                  ;SCRATCH REGGIES
	RETS

**************************************************************************
*                                                                        *
*          SET_PAGE                                                      *
*                                                                        *
*          This is called to set the CMOS page to the bits               *
*          contained in A1.                                              *
*                                                                        *
**************************************************************************
SET_PAGE
         MMTM    SP,A0,A1
         ANDI    CMOS_PAGE_SELECT_BITS,A1  ;KILL SIGN EXTEND..SAVE BITS
         PUSHST                            ;SAVE INTERRUPT STATUS
         DINT                              ;STOP INTERRUPTS
         MOVE    @SYSCOPY,A0,W             ;GET THE RAM COPY
         ANDNI   CMOS_PAGE_SELECT_BITS,A0  ;REMOVE THE CURRENT PAGE SELECT
         OR      A1,A0                     ;ADD IN OUR BITS
         MOVE    A0,@SYSCOPY,W             ;PUT THEM BACK IN THE RAM COPY
         MOVE    A0,@SYSCTRL,W             ;NOW THE HARDWARE
         POPST                             ;OK TO RE-START INTS
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          INIT_TAB                                                      *
*                                                                        *
*          This entrypoint is called at power up to                      *
*          clear out "today's" high score table.  We do                  *
*          this job, and then we do the job on the                       *
*          all time table for high score reset if                        *
*          necessary.                                                    *
*                                                                        *
**************************************************************************
INIT_TAB MMTM    SP,A8,A0

         MOVI    TOD_TAB,A8
         CALLR   INIT_TB         ;RESET TODAYS TABLE

         CALLR   GET_HSC         ;CHECK THE HIGH SCORE RESET COUNTER
         JRNZ    INIT_TAB1        ;NOT ZERO...NO MORE ACTIVITY
*
*        ITS ZERO....SEE IF ITS TURNED OFF
*
         MOVI    ADJHSRES,A0
         CALLA   GET_ADJ              ;GET THE ADJUSTED VALUE
         JRZ     INIT_TAB1            ;ITS TURNED OFF...NO ACTION.

         MOVI    ALL_TAB,A8      ;RESET THE ALL TIME TABLE
         CALLR   INIT_TB         ;INIT THE ALL TIME TABLE

         CALLR   INIT_HSR        ;RESET THE COUNTER TO ADJUSTED VALUE

INIT_TAB1
	MMFM    SP,A8,A0
	RETS

**************************************************************************
*                                                                        *
*          INIT_TB                                                       *
*                                                                        *
*          THIS IS CALLED TO SETUP A HIGH SCORE TABLE WITH               *
*          FACTORY ENTRIES.                                              *
*                                                                        *
*          A8 = ROM TABLE POINTER                                        *
*                                                                        *
**************************************************************************
INIT_TB
         MMTM    SP,A5,A6,A7,A0
         CALLR   ROM_PTRS             ;STUFF TABLE DATA
         MOVE    *A8(TB_FACTORY),A6,L ;GET THE FACTORY TABLE
         MOVE    A10,A5               ;NUMBER OF VALID ENTRIES
         INC     A5                   ;1 MORE TO HOLD ZERO ENTRY
         MOVI    HS_SIZE_IN_BYTES,A1  ;SIZE OF 1 ENTRY
         MPYU    A1,A5                ;A7 HAS NUMBER OF WORDS TO MOVE
         MOVE    A9,A7                ;CMOS POINTER IN A7

INIT_TB_1
         MOVB    *A6,A0               ;GET A BYTE FROM ROM
         ADDI    BYTE_SIZE,A6         ;KICK ROM POINTER
         CALLR   WC_BYTEI  ;WRITE THE BYTE AND INCREMENT
         DSJS    A5,INIT_TB_1        ;UNTIL THEY'RE ALL THERE.

         MOVE    A10,A0               ;POINT AT LAST ENTRY
INIT_TB_2
         CALLR   FORM_HS_CKSUM_AND_STORE   ;SET ITS CHECKSUM
         DEC     A0                   ;MOVE DOWN
         JRNN    INIT_TB_2           ;SET EACH ONE INCLUDING ZERO
	MMFM    SP,A5,A6,A7,A0
	RETS
         
**************************************************************************
*                                                                        *
*          KILL_TAB                                                      *
*                                                                        *
*          THIS IS CALLED TO SMASH A HIGH SCORE TABLE.                   *
*                                                                        *
**************************************************************************
*KILL_TAB
*         MMTM    SP,A5,A6,A7,A0
*         CALLR   ROM_PTRS             ;STUFF TABLE DATA
*         MOVE    A10,A0               ;POINT AT LAST ENTRY
*KILL_TAB_2
*
*         MMTM    SP,A0,A7
*         CALLR   FORM_HS_CKSUM             ;GET THE CKSUM IN A1, POINTER IN A7
*         CALLR   PT_ENTRY                  ;POINT AT THE VALUE
*         ADDI    HS_CKBYTE,A7              ;POINT AT CHECKBYTE
*         MOVE    A1,A0                     ;GET CHECKBYTE TO A0
*         INC     A0                        ;BAD CKSUM
*         CALLR   WC_BYTE                   ;WRITE OUT THE BYTE
*	MMFM    SP,A0,A7
*
*         DEC     A0                   ;MOVE DOWN
*         JRNN    KILL_TAB_2           ;SET EACH ONE INCLUDING ZERO
*	MMFM    SP,A5,A6,A7,A0
*	RETS
*         
**************************************************************************
*                                                                        *
*          COPY_ENTRY                                                    *
*                                                                        *
*          THIS IS CALLED TO COPY 1 ENTRY OF THE TABLE TO A              *
*          DIFFERENT LOCATION IN THE TABLE.                              *
*                                                                        *
*          A8,A9,A10,SYSCTRL ASSUMED TO BE SETUP ALREADY                 *
*          A2 = SOURCE ENTRY  (NUMBER)                                   *
*          A3 = DESTINATION ENTRY (NUMBER)                               *
*                                                                        *
**************************************************************************
COPY_ENTRY
         MMTM    SP,A0,A4,A5,A6,A7
         MOVI    HS_SIZE_IN_BYTES,A4      ;ENTRY SIZE IN BYTES
         MOVE    A2,A0                    ;FIRST POINT FOR A0
         CALLR   PT_ENTRY           
         MOVE    A7,A6                    ;A6 = SOURCE POINTER
         MOVE    A3,A0
         CALLR   PT_ENTRY                 ;A5 = DESTINATION
         MOVE    A7,A5
COPY_LOOP
*
*        IN THIS LOOP WE MOVE A BYTE AT A TIME.
*        SINCE THE WORD AND LONG DO THE SHIFTING AND
*        MASKING AND CALL MULTIPLE ROUTINES, THIS IS 
*        THE MOST EFFICIENT MODE OF OPERATION.
*
         MOVE    A6,A7                    ;SOURCE IN CMOS REGGIE
         CALLR   RC_BYTEI       ;FETCH A WORD
         MOVE    A7,A6
         MOVE    A5,A7                    ;DESTINATION
         CALLR   WC_BYTEI      ;WRITE IT
         MOVE    A7,A5                    ;BACK TO DEST REGGIE
         DSJ     A4,COPY_LOOP             ;UNTIL ALL WORDS ARE COPIED
	MMFM    SP,A0,A4,A5,A6,A7
	RETS

**************************************************************************
*                                                                        *
*          VAL_TAB                                                       *
*                                                                        *
*          THIS ROUTINE IS CALLED WHEN WE ARE INTERESTED IN              *
*          THE HSTD TABLE DATA.  A8 CONTAINS THE ROM POINTER             *
*          FOR THE TABLE.  FOR ANY ENTRIES THAT WE THROW                 *
*          OUT, WE MOVE THE REST OF THE TABLE UP, AND CREATE             *
*          A NEW ENTRY AT THE END OF THE TABLE.                          *
*                                                                        *
*          A2 = 0 ON OUTSIDE CALL.                                       *
*          A2 = 1 ON RECURSIVE CALL (THE CHECK AFTER RE-INIT)            *
*                                                                        *
*          THERE ARE 3 CHECKS MADE FOR EACH ENTRY:                       *
*                                                                        *
*          1)      IS CHECKSUM CORRECT.                                  *
*          2)      IS SCORE ALL NUMERIC                                  *
*          3)      ARE INITIALS ALL VALID ENTRIES.                       *
*                                                                        *
*        OUTPUT CC = TABLE OK                                            *
*               CS = PROBLEM THAT CAN'T BE RECTIFIED                     *
*                    (PROBABLY BAD RAM)                                  *
*                                                                        *
*               A2 = 0 ...table ok, or cleaned up                        *
*               A2 otherwise meanes table initialized                    *
*                                                                        *
**************************************************************************
VAL_TAB
         CLR     A2              ;indicate first call in
         CALLR   DO_VALIDATE     ;validate
	RETS

DO_VALIDATE
         MMTM    SP,A0,A1,A3,A4,A5,A6,A7
         CALLR   ROM_PTRS                  ;SETUP FOR TABLE
         MOVI    1,A0                      ;ITERATE THROUGH THE ENTRIES
         CLR     A1                        ;COUNT ERRORS

CHECK_A0_ENTRY
         CALLR   CHECK_ENTRY               ;IS THE ENTRY OK?
         JRNC    VT_1                      ;YEP.

         CALLR   REMOVE_ENTRY              ;REMOVE THIS ENTRY
         INC     A1
         MOVE    *A8(TB_ERROR_COUNT),A3    ;GET THRESHOLD
         CMP     A3,A1                     ;ARE WE THERE?
         JRLO    CHECK_A0_ENTRY            ;NOPE...CHECK MOVE UP ENTRY AT A0
*
*        TABLE IS MESSED UP....RE-INITIALIZE IT PLEASE
*
         MOVE    A2,A2                     ;IS THIS RECURSIVE CHECK AFTER INIT?
         JRNZ    CANT_VALIDATE             ;THEN RETURN FAILURE

         CALLR   INIT_TB                  ;INIT THIS TABLE PLEASE
         MOVK    1,A2                      ;INDICATE RECURSIVE CALL
         CALLR   DO_VALIDATE               ;IS IT ALRIGHT NOW?
	MMFM    SP,A0,A1,A3,A4,A5,A6,A7
	RETS
*
*        LAST ENTRY WAS VALID...MOVE TO NEXT
*
VT_1     INC     A0                        ;KICK IT
         CMP     A10,A0                    ;STILL IN TABLE?
         JRLS    CHECK_A0_ENTRY            ;YEP....CHECK THIS ENTRY

         CLRC                              ;RETURN VALID!
	MMFM    SP,A0,A1,A3,A4,A5,A6,A7
	RETS

CANT_VALIDATE
         SETC                              ;RETURN FAILURE!
	MMFM    SP,A0,A1,A3,A4,A5,A6,A7
	RETS

**************************************************************************
*                                                                        *
*          CHECK_ENTRY                                                   *
*                                                                        *
*          THIS IS CALLED TO CHECK THE ENTRY INDICATED BY                *
*          A0.                                                           *
*                                                                        *
*          CC = OK                                                       *
*          CS = ENTRY BAD                                                *
*                                                                        *
**************************************************************************
CHECK_ENTRY
         MMTM    SP,A0,A1,A2,A3,A7

         CALLR   FORM_HS_CKSUM             ;CHECK OUT CKSUM FIRST
         JRNZ    CHECK_FAIL                ;BAD CHECKSUM....ITS BAD
*
*        CHECKSUM OK...CHECK SCORE
*
         CALLR   GET_HSCR       ;SCORE IN A1
         MOVE    A1,A3                     ;SAVE COPY OF SCORE

CHECK_DIGIT
         MOVE    A1,A2                     ;COPY FOR NEXT NIBBLE
         ANDI    0FH,A2                    ;MASK THE NIBBLE
         CMPI    9,A2
         JRHI    CHECK_FAIL                ;NIBBLE TOO HIGH
         SRL     4,A1                      ;SHIFT DOWN TO NEXT NIBBLE
         JRNZ    CHECK_DIGIT

         DEC     A0                        ;MAKE SURE WE ARE LOWER THAN PREVIOUS SCORE!
         JREQ    FIRST_ENT                 ;WE'RE THE 1ST IN THE TABLE

         CALLR   GET_HSCR       ;GET THE SCORE FOR THE GUY BEFORE US
         CMP     A1,A3                     ;OURS MUST BE LOWER OR SAME
         JRHI    CHECK_FAIL                ;OURS IS BIGGER....REMOVE US

FIRST_ENT
         INC     A0                        ;RESTORE THE ENTRY NUMBER
*
*        SCORE OK...CHECK INITIALS
*
         CALLR   PT_ENTRY                  ;POINT A7 AT ENTRY
         ADDI    HS_INITS,A7               ;POINT AT FIRST INITIAL
         MOVI    NUM_INITS,A2              ;THIS IS NUMBER OF INITIALS

NEXT_LETTER
         CALLR   RC_BYTEI        ;FETCH A BYTE

         CALLR   VERIFY_LETTER             ;SEE IF ITS VALID.
         JRC     CHECK_FAIL                ;NOT A LETTER...BYTE

         DSJ     A2,NEXT_LETTER

         CLRC                              ;RETURN PASS
	MMFM    SP,A0,A1,A2,A3,A7
	RETS

CHECK_FAIL
         SETC
	MMFM    SP,A0,A1,A2,A3,A7
	RETS


**************************************************************************
*                                                                        *
*          VERIFY_LETTER                                                 *
*                                                                        *
*          THIS IS CALLED FOR EACH INITIAL LETTER TO SEE                 *
*          IF ITS VALID.                                                 *
*                                                                        *
*          CC = VALID                                                    *
*          CS = NOT VALID                                                *
*                                                                        *
**************************************************************************

VERIFY_LETTER
         ANDI    BYTE_MASK,A0             ;KEEP JUST THE BYTE

         CMPI    SPACE,A0                    ;SPACE?
         JREQ    VERIFY_PASS                ;ITS OK.

         CMPI    LET_A,A0                    ;BETWEEN A-Z?
         JRLO    VERIFY_FAIL

         CMPI    LET_Z,A0
         JRHI    VERIFY_FAIL

VERIFY_PASS
         CLRC
         RETS

VERIFY_FAIL
         SETC
         RETS

**************************************************************************
*                                                                        *
*          REMOVE_ENTRY                                                  *
*                                                                        *
*          THIS IS CALLED TO REMOVE A BAD ENTRY FROM THE TABLE.          *
*          IT DELETES THE ENTRY INDICATED BY A0.                         *
*                                                                        *
*          IT BUBBLES THE REST OF THE TABLE UP 1 UNIT.                   *
*                                                                        *
*          IT THEN PUTS THE LOWEST SCORE FROM THE ROM TABLE              *
*          WITH INITIALS IN THAT ENTRY.                                  *
*                                                                        *
**************************************************************************
REMOVE_ENTRY
         MMTM    SP,A0,A1,A2,A6,A7
         MOVE    A0,A3                ;THIS IS DEST
         MOVE    A3,A2                ;SOURCE IS 1 BELOW

BUBBLE_ANOTHER
         INC     A2                   ;NOW WE'RE SET FOR A COPY...

         CMP     A10,A2               ;IS SOURCE OUT OF RANGE?
         JRHI    BUBBLE_DONE          ;YEP....WE'RE AT THE BOTTOM (A3)

         CALLR   COPY_ENTRY
         INC     A3
         JRUC    BUBBLE_ANOTHER

BUBBLE_DONE
         MOVE    A3,A0                ;THIS IS BOTTOM OF TABLE
         CALLR   PT_ENTRY             ;A7 POINTS AT CMOS BLOCK

         MOVE    *A8(TB_FACTORY),A6,L  ;GET FACTORY TABLE
         MOVI    HS_ROM_SIZE,A1        ;SIZE OF ENTRY
         MPYU    A10,A1                ;TIMES NUMBER OF VALID ENTRIES..POINTS AT LAST.
         ADD     A1,A6                 ;NOW WE POINT AT END OF ROM TABLE
         MOVI    HS_SIZE_IN_BYTES,A2   ;SIZE OF ENTRY

REPLACE_LOOP
         MOVB    *A6,A0             ;MOVE A ROM BYTE TO A0
         ADDI    BYTE_SIZE,A6
         CALLR   WC_BYTEI  ;WRITE THE WORD AND INCREMENT
         DSJ     A2,REPLACE_LOOP      ;UNTIL THEY'RE ALL THERE.

         MOVE    A10,A0               ;POINT AT "LAST" ENTRY
         CALLR   FORM_HS_CKSUM_AND_STORE   ;STORE THE CHECKBYTE
	MMFM    SP,A0,A1,A2,A6,A7         ;AND RETURN
	RETS

**************************************************************************
*                                                                        *
*          CMOS UTILITIES                                                *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          FOR ALL OF THESE CMOS ROUTINES.                               *
*                                                                        *
*                  A7 = POINTER TO MEMORY                                *
*                  A0 = DATA TO/FROM MEMORY                              *
*                                                                        *
**************************************************************************
*
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*        ****  IMPORTANT NOTE ON WORD AND LONG WORD PACKING  ****
*
*        NOTE THAT REQUESTS FOR WORDS RETURN THE 2 BYTES PACKED
*        INTO A WORD AS <1ST BYTE><2ND BYTE>.   THIS IS NOT
*        THE SAME WAY THAT THE GSP HANDLES A WORD POINTED AT
*        WITH A POINTER.
*
*        LONG WORDS WORK SIMILARLY:
*
*           MSB                                              LSB
*               <1ST BYTE> <2ND BYTE> <3RD BYTE> <4TH BYTE>
*
*        TOUGH LUCK INTEL HACKERS!
*
*
*        RC_BYTE
*        WC_BYTE
*
*        These 2 routines are the only routines that ever touch
*        CMOS ram.  This is done to localize the effect of
*        changes in the architecture.  All efforts to deal with
*        CMOS should come through these routines.  Locking
*        hardware will be easily added in the future (as well
*        as different memory mapping).
*
RC_BYTE
         MOVB    *A7,A0
         ANDI    BYTE_MASK,A0
         RETS

WC_BYTE
         MOVB    A0,*A7          ;WRITE OUT THE BYTE
         RETS                    ;AND RETURN

**************************************************************************
*                                                                        *
*          RC_BYTEI                                            *
*                                                                        *
*          READ BYTE POINTED TO BY A7...INCREMENT POINTER TO             *
*          "NEXT" BYTE.                                                  *
*                                                                        *
**************************************************************************
RC_BYTEI
         CALLR   RC_BYTE
         ADDI    C_BYTE_SIZE,A7    ;WORDS SEPARATE CMOS BYTES.
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

RC_WORD
         MMTM    SP,A1,A7              ;USE A1 TO COMBINE BYTES
         CALLR   RC_BYTEI    ;GET A BYTE
         MOVE    A0,A1                 ;SAVE IN A1
         ANDI    BYTE_MASK,A1          ;MASK ONLY BYTE
         SLL     8,A1                  ;SHIFT TO HIGH BYTE
         CALLR   RC_BYTE        ;GET THE 2ND BYTE
         ANDI    BYTE_MASK,A0
         OR      A1,A0                 ;A0 HAS THE WORD
	MMFM    SP,A1,A7              
	RETS

RC_WORDI
         CALLR   RC_WORD
         ADDI    C_WORD_SIZE,A7    ;LONG SEPARATE CMOS WORDS.
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

RC_LONG
         MMTM    SP,A1,A7              ;USE A1 TO COMBINE BYTES
         CALLR   RC_WORDI    ;GET A WORD
         MOVE    A0,A1                 ;SAVE IN A1
         ANDI    WORD_MASK,A1          ;MASK ONLY WORD
         SLL     16,A1                 ;SHIFT TO HIGH WORD
         CALLR   RC_WORD        ;GET THE 2ND WORD
         ANDI    WORD_MASK,A0
         OR      A1,A0                 ;A0 HAS THE LONG WORD
	MMFM    SP,A1,A7              
	RETS

RC_LONGI
         CALLR   RC_LONG
         ADDI    C_LONG_SIZE,A7    ;DOUBLE THE DISTANCE FOR BRAIN DAMIJ
         MOVE    A0,A0             ;RETURN FLAGS ACCORDINGLY
         RETS

WC_BYTEI
         CALLR   WC_BYTE
         ADDI    C_BYTE_SIZE,A7
         RETS

WC_WORD
         MMTM    SP,A0,A1,A7
         MOVE    A0,A1           ;MAKE COPY OF WORD
         SRL     8,A0            ;GET HIGH BYTE IN A0
         CALLR   WC_BYTEI  ;WRITE THE HIGH BYTE
         MOVE    A1,A0           ;NOW GET THE LOW BYTE BACK
         CALLR   WC_BYTE ;WRITE IT
	MMFM    SP,A0,A1,A7     ;AND RESTORE ALL WE TOUCHED
	RETS

WC_WORDI
         CALLR   WC_WORD
         ADDI    C_WORD_SIZE,A7
         RETS

WC_LONG
         MMTM    SP,A0,A1,A7
         MOVE    A0,A1           ;MAKE COPY OF LONG
         SRL     16,A0           ;GET HIGH WORD IN A0
         CALLR   WC_WORDI  ;WRITE THE HIGH WORD
         MOVE    A1,A0           ;NOW GET THE LOW WORD BACK
         CALLR   WC_WORD ;WRITE IT
	MMFM    SP,A0,A1,A7     ;AND RESTORE ALL WE TOUCHED
	RETS

WC_LONGI
         CALLR   WC_LONG
         ADDI    C_LONG_SIZE,A7
         RETS

*****************************************************************************
*****************************************************************************
*****
*****    DEFAULT ROM HSTD TABLES AND TABLE DEFINITIONS
*****
*****************************************************************************
*****************************************************************************

TB_POINTER       EQU     0                      ;LONG-POINTER TO BEGINNING OF TABLE
TB_COUNT         EQU     TB_POINTER+LONG_SIZE   ;WORD....# IN THE TABLE.
TB_VISIBLE       EQU     TB_COUNT+WORD_SIZE ;WORD....NUMBER DISPLAYED
TB_PAGE_BITS     EQU     TB_VISIBLE+WORD_SIZE     ;WORD....STATUS WORD FOR CMOS PAGE
TB_FACTORY       EQU     TB_PAGE_BITS+WORD_SIZE   ;LONG....ROM STARTUP TABLE
TB_ERROR_COUNT   EQU     TB_FACTORY+LONG_SIZE     ;WORD....NUM ERRORS TO RE-INIT
*

SCR_M    $MACRO  A,B,C,D
         .BYTE   :A:
         .BYTE   :B:
         .BYTE   :C:
         .BYTE   :D:
         $END

INIT_M   $MACRO  A,B,C
         .BYTE   :A:
         .BYTE   :B:
         .BYTE   :C:
         .BYTE   0               ;CHECKBYTE
         $END

ALL_TIME_ROM_TABLE:
         SCR_M   02H,12H,21H,45H                ;****ZERO ENTRY...NOT SEEN!
         INIT_M  "E","P","J"
ROM_ENTRY_SIZE      EQU     $-ALL_TIME_ROM_TABLE
         SCR_M   01H,00H,00H,01H
         INIT_M  "J","E","H"           ;1
         SCR_M   00H,92H,52H,21H
         INIT_M  "J","R","N"           ;2
         SCR_M   00H,88H,88H,88H
         INIT_M  "T","J","E"           ;3
         SCR_M   00H,79H,82H,18H
         INIT_M  "L","I","N"           ;4           
         SCR_M   00H,77H,77H,77H
         INIT_M  "M","L"," "           ;5   ;LOCASIO
         SCR_M   00H,69H,69H,96H
         INIT_M  "G","W","S"           ;6
         SCR_M   00H,66H,66H,66H
         INIT_M  "A","L"," "           ;7
         SCR_M   00H,65H,10H,08H
         INIT_M  "B","L","S"           ;8   
         SCR_M   00H,57H,02H,18H
         INIT_M  "J","R","H"           ;9 ;J.R.
         SCR_M   00H,55H,55H,55H 
         INIT_M  "J"," ","P"           ;10  ;J.P.
         SCR_M   00H,55H,01H,27H                 
         INIT_M  "D","T","W"           ;11  ;WATSON
         SCR_M   00H,51H,11H,15H
         INIT_M  "D"," ","P"           ;12  ;DIANA
         SCR_M   00H,48H,48H,47H
         INIT_M  "R","A","Y"           ;13
         SCR_M   00H,44H,44H,44H
         INIT_M  "W","B","D"           ;14  ;WE KNOW WHAT B.D. STANDS FOR
         SCR_M   00H,41H,82H,80H
         INIT_M  "K","J","F"           ;15  ;THE MAN
         SCR_M   00H,39H,20H,35H
         INIT_M  "N","D","N"           ;16
         SCR_M   00H,38H,10H,90H
         INIT_M  "J"," ","B"           ;17    IS HE BEAGLE?
         SCR_M   00H,36H,02H,13H
         INIT_M  "S","S","R"           ;18
         SCR_M   00H,33H,09H,60H
         INIT_M  "M","R"," "           ;19
         SCR_M   00H,32H,66H,66H
         INIT_M  "B","I","G"           ;20
         SCR_M   00H,31H,00H,55H
         INIT_M  "L","E","P"
         SCR_M   00H,30H,75H,65H
         INIT_M  "M","D","R"
         SCR_M   00H,29H,72H,56H
         INIT_M  "B","A","C"
         SCR_M   00H,28H,70H,70H
         INIT_M  "W"," ","R"
         SCR_M   00H,27H,60H,60H
         INIT_M  "M","P","T"
         SCR_M   00H,26H,55H,20H
         INIT_M  "S","U","E"
         SCR_M   00H,25H,44H,80H
         INIT_M  "M","O","M"
         SCR_M   00H,24H,44H,79H
         INIT_M  "D","A","D"
         SCR_M   00H,23H,44H,78H
         INIT_M  "S","F","D"
         SCR_M   00H,22H,44H,77H
         INIT_M  "A","K","D"
ALL_TIME_ENTRIES     EQU     ($-ALL_TIME_ROM_TABLE)/ROM_ENTRY_SIZE

TODAYS_ROM_TABLE:
         SCR_M   02H,12H,21H,45H                ;****ZERO ENTRY...NOT SEEN!
         INIT_M  "E","P","J"
         SCR_M   00H,20H,01H,27H
         INIT_M  "D","R","J"
         SCR_M   00H,10H,08H,65H
         INIT_M  "G","N","P"
         SCR_M   00H,08H,21H,64H
         INIT_M  "T","R","A"
         SCR_M   00H,05H,72H,18H
         INIT_M  "L","E","D"
         SCR_M   00H,05H,12H,55H
         INIT_M  "M","L"," "        
         SCR_M   00H,04H,12H,50H
         INIT_M  "L","E","D"
         SCR_M   00H,03H,19H,20H
         INIT_M  "F","O","O"
         SCR_M   00H,03H,19H,19H
         INIT_M  "B","A","R"
TODAYS_ENTRIES     EQU     ($-TODAYS_ROM_TABLE)/ROM_ENTRY_SIZE
         .END

