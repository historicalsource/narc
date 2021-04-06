	.FILE	'NARCHELP.ASM'
	.TITLE	"Audits and Adjustments"
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
*          Narc Adjustments and Audit handing                            *
*                                                                        *
*          Larry DeMar    November 10, 1988                              *
*                                                                        *
**************************************************************************

	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"
	.INCLUDE	"\video\GSP.INC"	  ;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"    ;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR" ;Macros, Yeah!
	.INCLUDE	"IMGTBL.GLO"		  ;GLOBALS
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
         .INCLUDE        "NARCLEQU.ASM"      ;LINKY EQUATES

*
*        BAD_AUD - ANYTIME AN AUDIT NUMBER IS FETCHED, IF ITS
*                  CHECKSUM IS BAD, THEN BAD_AUD GETS SET TO 1
*                  THIS CAUSES "ERROR" IF ANY AUDIT IN A CALCULATION
*                  IS CORRUPTED, AND KEEPS A BAD CHECKSUM BAD WHEN
*                  AN AUDIT IS CHANGED.

         .BSS            BAD_AUD,16   ;(BAD_AUD...NOT BAD_DOG!)     
         .BSS            P1_TIMR,16   ;TIMER UNITS FOR 1 PLAYER
         .BSS            P2_TIMR,16   ;TIMER UNITS FOR 2 PLAYERS
         .BSS            C_FRAC,16              ;TIME 10 SECONDS TO
*                                               ;INDICATE COIN ACTIVITY
         .BSS            C_FLAGS,3*32     ;INTERRUPT COIN BOUNCE
         .BSS    OCT_FLG,16           ;FLAG SAYS WE'RE HALFWAY THROUGH PUSS!

*
*        IN THIS MODULE
*
         .GLOBAL         L_MESS, AUD, AUD1, GET_ADJ
         .GLOBAL         GET_AUD, LCOIN, CCOIN, RCOIN, SLAM_SW
         .GLOBAL         CR_STRTP
         .GLOBAL         CR_CONTP
         .GLOBAL         P_START  
         .GLOBAL         P_CONT  
         .GLOBAL         CRED_P  
         .GLOBAL         L_TIMER
         .GLOBAL         CRD_SCRN
	.GLOBAL	        ADD_DUMP
         .GLOBAL         LM_SETUP
         .GLOBAL         LM_FINIS
         .GLOBAL         CMOS_VAL
         .GLOBAL         CLR_AUD,FAC_SET,DISPDUMP
         .GLOBAL         CLR_AUDR
         .GLOBAL         FORM_ADC
         .GLOBAL         F_ADC_S
         .GLOBAL         CRED_P
         .GLOBAL         BAD_AUD
         .GLOBAL         ADJ_PAGE
         .GLOBAL         STRCAT
         .GLOBAL         CLR_SUBS
         .GLOBAL         NO_CREDS
         .GLOBAL	        COIN_PAG
         .GLOBAL         CAT_A0
         .GLOBAL         UNIT_CLR
         .GLOBAL         CK_MAX
         .GLOBAL         DUMP_FS
         .GLOBAL         HTOHXASC
         .GLOBAL         PUT_ADJ
         .GLOBAL         LD_CTAB
         .GLOBAL         DEF_PAGE
         .GLOBAL         ROM_NAME
         .GLOBAL         C_FLAGS
         .GLOBAL	        GET_CSTR
         .GLOBAL	        WAIT_MUT
*
*        IN NARCHSTD
*
         .GLOBAL         SET_PAGE
         .GLOBAL         P_FORK 
         .GLOBAL         DEC_HSR,INIT_HSR
*
*        GLOBALS IN NARCHSTD
*
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
*
*        IN NARCMENU
*
         .GLOBAL         GET_CSPT
         .GLOBAL         STR_OBJ
         .GLOBAL         STR_FREE
         .GLOBAL         CKPROMPT
         .GLOBAL         TWO_TS,TWO_TP
         .GLOBAL         G1SEL,F1SEL
         .GLOBAL         BUILD_ST
         .GLOBAL         HID_P
*
*        IN NARCMUGS
*
        .GLOBAL          CRDTPAGE
*
*        IN NARCTEST
*
         .GLOBAL         CK_DOOR
         .GLOBAL         WT_ADV,WW_ADV
         .GLOBAL         WAIT_BUT
         .GLOBAL         FORM_SWS
*
*        OTHERS
*
         .GLOBAL         SOUNDSUP
         .GLOBAL         G_CRED

         .TEXT

**************************************************************************
*                                                                        *
*          COIN HANDLING                                                 *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
*          GEORGE INTERFACE ROUTINES                                     *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          L_TIMER                                                       *
*                                                                        *
*          THIS IS CALLED EACH TICK THROUGH THE EXEC LOOP                *
*          BEFORE TIMER IS CLEARED.  IT DOES NOTHING                     *
*          IF THE GAME IS NOT IN PLAY.   ELSE IT ADDS                    *
*          THE EXEC TIME TO THE 1 PLAYER OR 2 PLAYER                     *
*          TIMER BASED ON CURRENT NUMBER OF PEOPLE PLAYING.              *
*                                                                        *
**************************************************************************
FIVE_SEC EQU     113H                ;THIS IS 5 SECONDS.  (Experimentally!)

L_TIMER  MOVE    @C_FRAC,A0,W         ;COUNT DOWN COIN FRACTION TIMER
         JRZ     L_TIM1               ;NOTHING THERE
         ANDI    07FFH,A0             ;THIS IS 30 SECONDS.....IF LARGER BRING DOWN!
         DEC     A0
         MOVE    A0,@C_FRAC,W

L_TIM1   MOVE    @GAMSTATE,A0         ;CHECK IF ITS IN PLAY
         CMPI    INAMODE,A0
         JREQ    CK_OCTO              ;ATTRACT MODE..CHECK OCTOPUS!
         CMPI    INDIAG,A0
         JREQ    NO_PLAY
         CMPI    INGAMEOV,A0
         JREQ    NO_PLAY
*
*        WE'RE PLAYING!
*
         MOVE    @NPLYRS,A0           ;HOW MANY?
         JRZ     NO_PLAY              ;NONE!

         MOVE    @TIMER,A1,W          ;GET ELAPSED TIME

         CMPI    1,A0                 ;1?
         JRZ     LT_ONE
*
*        TWO PLAYER GAME
*
         MOVE    @P2_TIMR,A0,W        ;GET PLAYER 2 TIMER.
         ADD     A1,A0                ;ADD ELAPSED TIME
         MOVE    A0,@P2_TIMR,W        ;PUT BACK IN MEMORY
*
         CMPI    FIVE_SEC,A0          ;ARE WE AT 5 SECONDS?
         JRLO    NO_PLAY              ;NOT YET

         MOVI    AUD2TIME,A0
         CALLA   AUD1                 ;CHALK IT!

         CLR     A0
         MOVE    A0,@P2_TIMR,W        ;CLEAR OUT TIMER
NO_PLAY  RETS
*
*        ITS A-MODE...CHECK OCTOPUS!
*
CK_OCTO
         MOVE    @OCT_FLG,A0,W        ;HALF WAY THERE?
         JRNZ    CK_P2                ;YEP...CHECK FOR OTHER HALF
*
*        CHECK PART 1
*
         MOVE    @SWITCH,A0,W         ;CHECK FOR OCTOPUS 
         CMPI    37CEH,A0
         JRNZ     NO_OCTO             ;NO ONE HOME
*
*        GOT PART 1..SET FLAG
*
         MOVE    A0,@OCT_FLG,W        ;NON-ZERO MEANS PART 1!
*
*        WE HAVE PART 1 OF THE OCTOPUSS!
*
CK_P2    MOVE    @SWITCH,A0,W         ;GET SWITCHES
         MOVE    A0,A1                ;MAKE A COPY

         NOT     A0                   ;CHECK JUST THE JOYSTICKS
         ANDI    0F0FH,A0
         CMPI    0801H,A0             ;JOYSTICKS CORRECT?
         JRNZ    NO_JOY               ;NOPE.......TOO BAD!

         CMPI    675EH,A1             ;DID WE GET TO OUR DESIRED COMBO?
         JRNZ    NO_OCTO              ;NOPE....HOLD FLAG

         MOVI    ACTIVE,A13
         MOVI    HID_P,A7             ;START THE PROCESS!
         CLR     A1
         CALLA   GETPRC               ;THAT'S ALL FOLKS!

NO_JOY   CLR     A0
         MOVE    A0,@OCT_FLG,W        ;START FROM SQUARE 1

NO_OCTO  RETS

LT_ONE
*
*        ONE PLAYER GAME
*
         MOVE    @P1_TIMR,A0,W        ;GET PLAYER 1 TIMER.
         ADD     A1,A0                ;ADD ELAPSED TIME
         MOVE    A0,@P1_TIMR,W        ;PUT BACK IN MEMORY
*
         CMPI    FIVE_SEC,A0          ;ARE WE AT 5 SECONDS?
         JRLO    NO_PLAY              ;NOT YET

         MOVI    AUD1TIME,A0
         CALLA   AUD1                 ;CHALK IT!

         CLR     A0
         MOVE    A0,@P1_TIMR,W        ;CLEAR OUT TIMER
         RETS
*
*        CR_STRTP - ARE THERE ENOUGH CREDITS TO START
*        CR_CONTP - ARE THERE ENOUGH CREDITS TO CONTINUE
*        P_START  - PLAYER STARTED...DEDUCT CREDITS
*        P_CONT   - PLAYER CONTINUED...DEDUCT CREDITS
*        CRED_P   - HOW MANY CREDITS (FOR A GEORGE MESSAGE)
*
*        JRHS FOR OK TO START!
*
CR_STRTP MMTM    SP,A0,A1
         MOVI    ADJFREPL,A0
         CALLR   GET_ADJ              ;ARE WE IN FREE PLAY?
         CMPI    1,A0                 ;WE ARE IF ITS NOT ZERO.
         JRHS    CR_STX

         CALLR   CCCC                 ;MAKE SURE THINGS ARE IN TACT
         CALLR	COIN_PAG
**************************************************************************
*                                                                        *
*          MOVI    HSR_C,A7                                              *
*          CALLA   RC_LONG                                               *
*          CMPI    1,A0          SUPER-CHARGED!                          *
*          JRLO    CR_STX                                                *
*                                                                        *
**************************************************************************
         CALLR   GET_CREDITS          ;GET CURRENT CREDITS
         MOVE    A0,A1
         MOVI    ADJCSTRT,A0
         CALLR   GET_ADJ              ;GET NUMBER NEEDED
         CMP     A0,A1                ;DO WE HAVE ENOUGH TO START?

CR_STX   MMFM    SP,A0,A1
	RETS

CR_CONTP
         MMTM    SP,A0,A1
         MOVI    ADJFREPL,A0
         CALLR   GET_ADJ              ;ARE WE IN FREE PLAY?
         CMPI    1,A0                 ;WE ARE IF ITS NOT ZERO.
         JRHS    CR_STX1

         CALLR   CCCC                 ;MAKE SURE THINGS ARE IN TACT
	CALLR	COIN_PAG
**************************************************************************
*                                                                        *
*          MOVI    HSR_C,A7                                              *
*          CALLA   RC_LONG                                               *
*          CMPI    1,A0                                                  *
*          JRLO    CR_STX1                                               *
*                                                                        *
**************************************************************************
         CALLR   GET_CREDITS          ;GET CURRENT CREDITS
         MOVE    A0,A1
         MOVI    ADJCCONT,A0
         CALLR   GET_ADJ              ;GET NUMBER NEEDED
         CMP     A0,A1                ;DO WE HAVE ENOUGH TO START?
CR_STX1	MMFM    SP,A0,A1
	RETS

P_START  MMTM    SP,A0,A1
         CALLR   CRED_P
         MOVE    A0,A1
         MOVI    ADJCSTRT,A0
         CALLR   GET_ADJ              ;GET NUMBER NEEDED
         CALLR   REMOVE_CREDITS
         CALLA   DEC_HSR              ;TAKE 1 FROM HIGH SCORE RESET COUNTER
	MMFM    SP,A0,A1
	RETS

P_CONT   MMTM    SP,A0,A1
         CALLR   CRED_P
         MOVE    A0,A1
         MOVI    ADJCCONT,A0
         CALLR   GET_ADJ              ;GET NUMBER NEEDED
         CALLR   REMOVE_CREDITS
         CALLA   DEC_HSR              ;TAKE 1 FROM HIGH SCORE RESET COUNTER
	MMFM    SP,A0,A1
	RETS

REMOVE_CREDITS
         SUB     A0,A1                ;REMOVE START AMOUNT FROM WHAT WE HAVE
         JRHS    PS1                  ;WE'RE OK.

         CLR     A1                   ;IT WENT NEGATIVE....MAKE ZERO.
PS1      CALLR   COIN_PAG
         MOVI    CREDITS,A7
         MOVE    A1,A0                ;PUT WHATS LEFT OUT TO WRITE
         CALLA   WC_BYTE              ;WRITE THE NEW AMOUNT

         CALLR   FORM_COIN_CKSUM_AND_STORE
         CALLR   DEF_PAGE             ;POINT AT DEFAULT PAGE.
	 CALLA	 G_CRED			;UPDATE THE SCANNER CREDIT MESSAGE
         RETS

**************************************************************************
*                                                                        *
*          NO_CREDS                                                      *
*                                                                        *
*          THIS IS CALLED TO REMOVE CREDITS AND CREDIT FRACTIONS         *
*          FROM THE MACHINE.                                             *
*                                                                        *
**************************************************************************
NO_CREDS MMTM    SP,A0,A1,A7
         CALLR   FORM_COIN_CKSUM ;MAKE THE REAL CKSUM
         MOVI    COIN_CKSUM,A7
         MOVE    A1,A0
         INC     A0              ;MAKE THE CKSUM BAD!
         CALLA   WC_BYTE
	MMFM    SP,A0,A1,A7
	RETS

**************************************************************************
*                                                                        *
*          COIN SWITCHES                                                 *
*                                                                        *
**************************************************************************
LC_FLAG  EQU     C_FLAGS
RC_FLAG  EQU     C_FLAGS+BYTE_SIZE
CC_FLAG  EQU     C_FLAGS+(2*BYTE_SIZE)
XC_FLAG  EQU     C_FLAGS+(3*BYTE_SIZE)

RUN_TIME EQU     LONG_SIZE            ;2ND LONG WORD COUNTS DOWN LONG TIME
OPENS_LEFT EQU   2*LONG_SIZE          ;3RD LONG WORD COUNTS DOWN CONSEC OPENS

PULSE_MAX        EQU     700/16       ;FRAMES TILL ITS TOO LINE.
MIN_OPENS        EQU     4

COIN_SBIT        EQU     0
COIN_SUCC_BIT    EQU     1
COIN_FAIL_BIT    EQU     2
COIN_ACK_BIT     EQU     3

COIN_SFLAG       EQU     1
COIN_SUCC_VAL    EQU     2
COIN_FAIL_VAL    EQU     4
COIN_ACK_VAL     EQU     8

LCOIN    MOVI    ADJLMULT,A8
*         MOVI    L_COIN_BIT,A9
         MOVI    LC_FLAG,A10          ;LEFT COIN FLAG
         MOVI    AUDLCOIN,A11
         JRUC    COIN_ROUTINE

CCOIN    MOVI    ADJCMULT,A8
*         MOVI    C_COIN_BIT,A9
         MOVI    CC_FLAG,A10          ;LEFT COIN FLAG
         MOVI    AUDCCOIN,A11
         JRUC    COIN_ROUTINE

RCOIN    MOVI    ADJRMULT,A8
*         MOVI    R_COIN_BIT,A9
         MOVI    RC_FLAG,A10          ;LEFT COIN FLAG
         MOVI    AUDRCOIN,A11
         JRUC    COIN_ROUTINE

         .IF     FOURTH_SLOT

         .GLOBAL XCOIN
XCOIN    MOVI    ADJCMULT,A8
*        MOVI    X_COIN_BIT,A9
         MOVI    XC_FLAG,A10          ;LEFT COIN FLAG
         CLR     A11                  ;SIGNAL ZERO FOR SPECIAL AUDIT PROCEDURE
*
*        FETCH THE CENTER COIN UNITS
*
         MOVE    @GAMSTATE,A0,W       ;DIAGNOSTICS?
         CMPI    INDIAG,A0
         JREQ    CRX                  ;THEN NO ACTION!

         MOVE    A8,A0                ;MOVE MULTIPLIER ADJUST NUMBER TO A0
         CALLA   GET_ADJ              ;FETCH IT
         MOVE    A0,A8                ;AND BACK TO STATIC REG...ANY THERE?
         JRZ     CRX                  ;NOPE....DON'T WASTE THE TIME!

         SLL     1,A8                 ;DOUBLE THE CENTER SLOT UNITS!
         JRUC    XCOIN_CONTINUE       ;NOW USE "NORMAL COIN ROUTINE

         .ENDIF

**************************************************************************
*                                                                        *
*          COIN_ROUTINE                                                  *
*                                                                        *
*          THIS IS CALLED FROM EACH OF THE COIN SWITCHES WHEN            *
*          MADE.  IT CONTAINS THE FOLLOWING:                             *
*                                                                        *
*                  A8 = MULTIPLIER FOR THAT SWITCH.                      *
*                  A10 = BASE OF RAM POINTERS                            *
*                  A11 = BASE AUDIT NUMBER                               *
*                                                                        *
**************************************************************************
COIN_ROUTINE
         MOVE    @GAMSTATE,A0,W       ;DIAGNOSTICS?
         CMPI    INDIAG,A0
         JREQ    CRX                  ;THEN NO ACTION!

         MOVE    A8,A0                ;MOVE MULTIPLIER ADJUST NUMBER TO A0
         CALLA   GET_ADJ              ;FETCH IT
         MOVE    A0,A8                ;AND BACK TO STATIC REG...ANY THERE?
         JRZ     CRX                  ;NOPE....DON'T WASTE THE TIME!

XCOIN_CONTINUE
         CALLR   SLAM_P               ;SLAM AROUND?
         JRNZ    CRX                  ;THEN NO ACTION

          MOVI    LC_PID,A0            ;ALL 3 SLOTS USE THIS ID NOW
         MOVE    A0,*A13(PROCID),W    ;SET OUR ID (IN CASE TABLE IS WRONG)

         MOVB    *A10,A0              ;GET FLAG BYTE
         JRNZ    CRX                  ;SOMEONE ELSE THERE...WE'RE A BOUNCE!
*
*        OK....THIS IS A NEW POSITIVE EDGE....START THE TIMING
*        WHEELS   (A0 HAS A ZERO!)
*
         MOVI    PULSE_MAX,A1         ;MAXIMUM PULSE WIDTH
         MOVB    A1,*A10(RUN_TIME)    ;COUNT IT DOWN HERE.

         MOVI    MIN_OPENS,A1         ;THIS MANY FRAMES OF OPEN TIL OPEN
         MOVB    A1,*A10(OPENS_LEFT)

         MOVI    COIN_SFLAG,A1
         MOVB    A1,*A10              ;TELL INTERRUPT TO START!

         MOVI    100H,A9              ;4 SECONDS MAX

COIN_LOOP
         SLEEP   1                    ;NOW SLEEP TIGHTLY TILL WE GET SUCCESS OR FAIL
         MOVB    *A10,A0              ;GET THE FLAGS
         BTST    COIN_FAIL_BIT,A0     ;TOO LONG?
         JRZ     CK_SUCC
*
*        WE HAVE FAILURE...ACKNOWLEDGE IT
*
         ORI     COIN_ACK_VAL,A0      ;THIS ACKNOWLEDGES WE SAW IT.
         MOVB    A0,*A10              ;PUT IT BACK
         JRUC    CRX                  ;AND GET OUT

CK_SUCC
         BTST    COIN_SUCC_BIT,A0
         JRNZ    COIN_GO              ;GOT IT!...CONTINUE!

         DSJS    A9,COIN_LOOP         ;TIME OUT FOR SAFETY

         .IF     DEBUG
                 JRUC    $
         .ENDIF

         JRUC    CRX                  ;TIMED OUT....JUST DIE!

COIN_GO  CLR     A0
         MOVB    A0,*A10              ;CLEAR THE FLAGS BACK OUT!

         CALLR   SLAM_P               ;SLAM?
         JRNZ    CRX                 ;THEN WE'RE OUT OF HERE
*
*        WE SURVIVED 1/2 SECOND WITHOUT A SLAM....ITS TIME TO CASH
*        IN HIS STACHE.
*
         CLR     A0
         MOVE    A0,@SOUNDSUP,W       ;TURN SOUNDS ON. (A-MODE SOUND SUPRESSOR)

	SOUND1	COINSND	 

         MOVI    15*40H,A0            ;DON'T WIPE ON GAME OVER IF ITS WITHIN
         MOVE    A0,@C_FRAC,W         ;15 SECONDS (THIS TIMES OUT TO OVER 20)

         CALLR   CHALK_COIN           ;STRIKE UP THE AUDIT(S)

         MOVE    A8,A8                ;NO CUNITS?
         JRZ     CRX                  ;THEN NO MORE WORK TO DO.

         CALLR   ADJUST_CREDITS       ;GIVE CREDIT FOR THE MONEY.
         CALLR   DEF_PAGE             ;POINT PAGE AWAY!
*
*         NOW LET'S COMPOSE A CREDITS STRING FOR
*         GEORGE
*
         CALLA   G_CRED                ;GIVE TO GEORGE TO PLOT!

	 MOVE	 @GAMSTATE,A0,W	      ;HE GOT HIS BOOTY....NOW HE GETS
	 CMPI	 INAMODE,A0	      ;A DISPLAY IN AMODE ONLY!
	 JRNZ	 CRX			
*
*	 THE FOLLOWING ID IS FOR THE "TODD IS PUTTING UP THE OUTSIDE"
*	 PORTION OF THIS PROCESS......IF IT IS RUNNING...NO NEED FOR
*	 US TO RUN.
*
         MOVI    CP_PID1,A0           ;CHANGE OUR ID TO "TODD IN PROGRESS"
         MOVE    A0,*A13(PROCID),W    

	 MOVI	 0FFFFH,A1	      ;AND CHECK IF THERE IS A TODD IN PROGRESS
	 CALLA   EXISTP              
	 JRZ	 CRY		      ;NO TODD..CONTINUE 
          JRUC    CRX                  ;TODD IS COMING UP...AFTER THAT
*				      ;OUR UPDATED NUMBER WILL BE USED!

CRY      JSRP    CRD_SCRN       ;PUT UP THE CREDITS SCREEN
         SLEEP   500H                 ;SLEEP FOR 20 SECONDS
*
*        NOW THAT CREDITS HAS BEEN ADJUSTED.....WE NEED TO 
*        GO TO THE TITLE PAGE
*
         CALLR   KIL_MINE

         CALLA   ATSTRT              ;
CRX      JAUC    SUCIDE

KIL_MINE
         MMTM    SP,A0,A1
         MOVE    *A13(PROCID),A0,W    ;PASS OUR ID TO FORKED PROCESS
         MOVI    0FFFFH,A1
         CALLA   KILALL
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          CHALK_COIN                                                    *
*                                                                        *
*          A11 contains the base audit number.  Chalk the audit for      *
*          1 more coin hit there!                                        *
*                                                                        *
*          3 away from the base is the "door-closed" counter             *
*                                                                        *
*          3 away from that is the "sub-total".                          *
*                                                                        *
*          3 away from that is the "door-closed" sub-total.              *
*                                                                        *
*                                                                        *
**************************************************************************
CHALK_COIN 
         MMTM    SP,A0
         MOVE    A11,A0
*
*        READY TO CHALK THE AUDIT......ZERO MEANS "EXTRA SLOT"
*
         .IF     FOURTH_SLOT
         JRNZ    CCC01                ;ITS A NORMAL ONE

         MOVI    AUDCCOIN,A0          ;CHALK FOR "CENTER COINS"
         CALLR   CHALK_FOR_A0         ;CHALK TWO SETS!
         .ENDIF

CCC01    CALLR   CHALK_FOR_A0    ;CHALK RELEVANT COUNTERS

	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          CHALK_FOR_A0                                                  *
*                                                                        *
*          THIS IS CALLED TO CHALK THE AUDITS FOR A COIN SWITCH.         *
*          A0 HAS THE BASE AUDIT FOR THE COIN SWITCH.                    *
*                                                                        *
**************************************************************************
CHALK_FOR_A0
         MMTM    SP,A0
         CALLR   AUD1            ;CHALK THE DIRECT AUDIT

         ADDI    2*CHUTES,A0     ;AND THE "SUB-TOTAL"
         CALLR   AUD1

         CALLA   CK_DOOR         ;NOW SEE IF DOOR IS CLOSED.
         JRNE    CKCN1           ;ITS OPEN....DON'T CHALK THE OTHERS!

         SUBI    CHUTES,A0       ;MOVE TO DOOR OPEN TOTAL
         CALLR   AUD1

         ADDI    2*CHUTES,A0     ;AND DOOR OPEN SUB-TOTAL
         CALLR   AUD1
CKCN1 	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          ADJUST_CREDITS                                                *
*                                                                        *
*          This is the routine that turns the coin switch hit            *
*          into a tangable (if you could say that) reward.               *
*                                                                        *
*          The coin chute multiplier is in A8.                           *
*                                                                        *
**************************************************************************
ADJUST_CREDITS
         MMTM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
         CALLR   CK_MAX          ;ARE WE AT MAXIMUM CREDITS?
         JRHS    ADCRXX          ;YEP.....DON'T ROCK THE BOAT!
*
         CALLR   CCCC            ;VALIDATE THE CURRENT TOTALS (OR CLEAR!)

         CALLR   FETCH_REQ       ;GET THE REQUIRED FOR CREDIT, BONUS AND MINIMUM
*
*        A2 = REQUIRED FOR CREDIT
*        A3 = FOR BONUS
*        A4 = MINIMUM
*
         CALLR   ADD_TO_CUNITS   ;ADD TO OUR CUNITS
         MOVE    A3,A3           ;BONUS EFFECTIVE?
         JRZ     NO_BUNITS       ;NOPE....DON'T RUN UP THE COUNTER!

         CALLR   ADD_TO_BUNITS   ;ADD TO BONUS UNITS

NO_BUNITS
         MOVE    A4,A4           ;MINIMUM REQUIRED?
         JRZ     NO_MINIMUM      ;NOPE.....LEAVE ALONE.

         MOVI    MINUNITS,A7     ;POINT AT MINIMUM
         CALLA   RC_WORD         ;GET THE AMOUNT ACCUMULATED
         ADD     A8,A0           ;ADD AMOUNT RECEIVED
         CALLA   WC_WORD         ;WRITE THE MINUNITS BACK IN CASE NOT ENOUGH.

         SUB     A4,A0           ;DO WE HAVE ENOUGH TO ACT?
         JRLO    ADCRX           ;NOPE....NO CREDITS YET!

         CLR     A0              ;CLEAR OUT MINIMUM FOR NEXT SHOT!
         CALLA   WC_WORD         ;REMOVE ACCUMULATED MINIMUM.

NO_MINIMUM
         CLR     A6              ;COUNT ACCUMULATED CREDITS IN A6
         CLR     A10             ;IN CASE NO BONUS!

         CLR     A8
         MOVI    BUNITS,A7
         CALLA   RC_WORD         ;GET THE NUMBER OF BUNITS
         MOVE    A0,A9           ;INTO A9

         MOVE    A3,A3           ;DON'T DIVIDE BY ZERO!
         JRZ     NO_BU_BU
         DIVU    A3,A8           ;DIVIDE BUNITS BY NUMBER NEEDED FOR BONUS

         MOVE    A9,A0           ;WRITE REMAINDER BACK
         CALLA   WC_WORD

         MOVE    A8,A6           ;NUMBER OF BONUS CREDITS EARNED.
         MOVE    A8,A10          ;REMEMBER IF ANY BONUS CREDITS WERE EARNED!

NO_BU_BU
         CLR     A8
         CALLR   GET_CUNITS      ;READ IN THE CUNITS
         MOVE    A0,A9

         MOVE    A2,A2           ;DON'T DIVIDE BY ZERO.
         JRZ     NO_CR

         DIVU    A2,A8           ;GET CREDITS!
         MOVE    A9,A0           ;REMAINDER IS LEFTOVER CUNITS
         CALLR   PUT_CUNITS
         ADD     A8,A6           ;A6 HAS WHAT WE'VE WON!

NO_CR    MOVE    A6,A1
         MOVI    AUDPAIDC,A0
         CALLA   AUD             ;CHALK UP THE EARNED CREDITS!

         CALLR   GET_CREDITS
         ADD     A6,A0           ;ADD IN THE NEW ONES.
         CALLR   PUT_CREDITS     ;NOW STORE EM BACK (ENFORCE MAX)

         MOVE    A10,A10         ;WAS THE BONUS EARNED?
         JRZ     ADCRX           ;NOPE...EXIT!
*
*        WHEN BONUS EARNED...WE START THE WHOLE SYSTEM OVER!
*
         CALLR   CLEAR_UNITS

ADCRX    CALLR   FORM_COIN_CKSUM_AND_STORE
ADCRXX	MMFM    SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	RETS

**************************************************************************
*                                                                        *
*          PUT_CREDITS                                                   *
*                                                                        *
*          STORE CREDIT COUNT IN A0 TO CMOS....ENFORCING                 *
*          MAXIMUM CREDITS.                                              *
*                                                                        *
**************************************************************************
PUT_CREDITS
         MMTM    SP,A0,A6,A7
         CALLR   GET_MAX         ;GET MAX CREDS IN A1....BE ON COIN PAGE
         CMP     A1,A0           ;SEE HOW WE STACK UP.
         JRLO    USE_A0          ;WE'RE LOWER...JUST STORE.
*
*        WE'RE AT (OR OVER) MAXIMUM CREDITS
*
         CALLR   CLEAR_UNITS     ;CLEAR OUT THE UNIT FRACTIONS.
         MOVE    A1,A0           ;USE MAXIMUM

USE_A0   MOVI    CREDITS,A7
         CALLA   WC_BYTE         ;WRITE THE CREDITS OUT.
	MMFM    SP,A0,A6,A7
	RETS

**************************************************************************
*                                                                        *
*          GET_MAX                                                       *
*                                                                        *
*          GET MAXIMUM CREDITS IN A1.                                    *
*                                                                        *
*          THIS LEAVES YOU ON COIN PAGE.                                 *
*                                                                        *
**************************************************************************
GET_MAX
         MMTM    SP,A0
         MOVI    ADJMAXC,A0
         CALLA   GET_ADJ_FOR_COIN    ;FETCH MAXIMUM CREDITS (PUT US ON COIN PAGE)
         MOVE    A0,A1
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          CK_MAX                                                        *
*                                                                        *
*          THIS IS CALLED TO SEE IF WE ARE AT MAXIMUM CREDITS.           *
*          .HS. MEANS WE ARE AT MAXIMUM CREDITS.                         *
*                                                                        *
**************************************************************************
CK_MAX   MMTM    SP,A0,A1
         CALLR   GET_MAX              ;GET MAXIMUM IN A1
         CALLR   CRED_P               ;GET CREDITS IN A0 (AND FLIP PAGE AWAY)
         CMP     A1,A0                ;JRHS FOR MAXIMUM CREDITS!
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          UNIT_CLR                                                      *
*                                                                        *
*          THIS IS CALLED BY GEORGE AT GAME OVER.  IT CLEARS             *
*          OUT ANY COIN FRACTIONS THAT WERE NOT USED BY THE              *
*          CURRENT PLAYER(S).  THIS ALLOWS ALL BUY-IN TO                 *
*          TAKE ADVANTAGE OF MULTIPLE COIN BONUSES.                      *
*                                                                        *
*          ANYTIME A COIN IS INSERTED, C_FRAC IS SET TO ABOUT            *
*          10 SECONDS.  MY TIMING INTERFACE COUNTS C_FRAC DOWN           *
*          TO ZERO.  IF C_FRAC IS NON ZERO WHEN THIS ROUTINE IS          *
*          CALLED, THEN SOMEONE PUT A COIN IN NOT TOO LONG BEFORE        *
*          GAME OVER.  DON'T SCREW HIM OUT OF HIS FRACTIONS.             *
*                                                                        *
**************************************************************************
UNIT_CLR MMTM    SP,A0
         MOVE    @C_FRAC,A0,W                   ;DO WE GIVE HIM A REPRIEVE?
         JRNZ    UC1                            ;YEP!
         CALLR   CCCC                           ;VALIDATE COINAGE
         CALLR   CLEAR_UNITS                    ;CLEAR OUT FRACTIONAL UNITS
         CALLR   FORM_COIN_CKSUM_AND_STORE      ;MAKE ALL GOOD.
UC1	MMFM    SP,A0
	RETS

CLEAR_UNITS
         MMTM    SP,A0,A7
         CLR     A0
         MOVI    CUNITS,A7       ;3 CONSECUTIVE WORDS OF CMOS
         CALLA   WC_WORDI
         CALLA   WC_WORDI
         CALLA   WC_WORD
	MMFM    SP,A0,A7
	RETS
*
*        RETURN CREDITS IN A0.........AND Z BIT CLEAR IF
*        CREDITS EXIST OR IN FREE PLAY.
*
CRED_P   CALLR   CCCC            ;CHECK TO SEE IF DATA IS OK.

GET_CREDITS
         MMTM    SP,A7
         CALLR   COIN_PAG
         MOVI    CREDITS,A7      ;
         CALLA   RC_BYTE         ;READ CURRENT CREDITS
         JRNZ    GC1             ;WE GOT SOME!

         MMTM    SP,A0           ;PUSH THE ZERO!
         MOVI    ADJFREPL,A0
         CALLR   GET_ADJ         ;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
         MMFM    SP,A0           ;RESTORE A0

GC1      CALLR   DEF_PAGE        ;FLIP CMOS AWAY
	MMFM    SP,A7
	RETS

ADD_TO_CUNITS
         MMTM    SP,A0,A7
         CALLR   GET_CUNITS
         ADD     A8,A0
         CALLR   PUT_CUNITS
	MMFM    SP,A0,A7
	RETS

GET_CUNITS
         MMTM    SP,A7
         MOVI    CUNITS,A7
         CALLA   RC_WORD
	MMFM    SP,A7
	RETS

PUT_CUNITS
         MMTM    SP,A7
         MOVI    CUNITS,A7
         CALLA   WC_WORD
	MMFM    SP,A7
	RETS

ADD_TO_BUNITS
         MMTM    SP,A7,A0
         MOVI    BUNITS,A7
         CALLA   RC_WORD
         ADD     A8,A0
         CALLA   WC_WORD
	MMFM    SP,A7,A0
	RETS

CRD_SCRN
         MOVI    CP_PID1,A0           ;CHANGE OUR ID TO "TODD IN PROGRESS"
         MOVE    A0,*A13(PROCID),W    

         MOVI    CP_PID2,A0       ;ARE WE SHOWING THE TITLE PAGE?
         MOVI    0FFFFH,A1
         CALLA   EXISTP

         JRZ     NOT_TITLE       ;ITS NOT THE TITLE PAGE...TRASH IT.
*
*        TITLE PAGE IS RUNNING....KILL IT!
*
         MOVI    CP_PID2,A0
         CALLA   KILALL          ;ITS DEAD!
         CALLA   DMAQWAIT        ; WAIT FOR DMA TO BE DONE (IF IN MOTION)
*
*        NOW BLANK THE AREA OF OUR INTEREST
*

* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
         
         MOVI    0B80040H,A3                              ;CORNER OF REGION
         MOVI    0DC0180H,A4
         CALLA   BLNKAREA                                 ;BLANK IT OUT!
         JRUC    BLANKED_NOW_GO

NOT_TITLE
         CALLA   WIPEOUT         ;TAKE DOWN WHATEVER'S RUNNING.
*         CALLR   COIN_PAG       ;GET THE CMOS PAGE BACK TO US!
         SLEEP   1               ;GIVE TODD SOME TIME
         JSRP    CRDTPAGE        ;PUT UP THE GOOD LOOKING PART OF THE PAGE.

         MOVI    1,A0
         MOVE    A0,@DISPLAYON,W ;TURN THE DISPLAY PROCESSOR BACK ON!

         SLEEP   1

         CALLA   COLRSTRT        ;RESTART THE COLORS JACK

BLANKED_NOW_GO
         MOVI    CPYR_MES,A8          ;COPYRIGHT MESSAGE
         JSRP    L_MESS

         MOVI    CP_PID2,A0           ;CHANGE OUR ID TO "CREDITS PAGE"
         MOVE    A0,*A13(PROCID),W    ;SET OUR ID (IN CASE TABLE IS WRONG)
*
*        BEWARE.....GET_CSTR SMASHES A LONG WORD IN THE PDATA AREA
*        AT:  AT PDATA + 3*LONG_SIZE
*
         CALLR   GET_CSTR                  ;GET THE CREDITS STRING
         MOVE    A8,A2                     ;PUT IT IN NON-VOLITILE REGGIE!

         CALLR   SELECT_SETUP              ;POINT AT PLACE BASED ON PROMPTING
         CALLR   LM_SETUP
         MOVE    A2,A8                     ;POINT AT MESSAGE
         JSRP    LM_FINIS                  ;AND PRINT IT OUT!

         CALLA   CKPROMPT                  ;IS THERE A PROMPT STRING?
         JRZ     BOT_PROMPT                ;NOT ON TOP...DO THE BOTTOM 
*
*        BASED ON A1.....WE NEED TO DO THE FOLLOWING:
*
*        A1 = 0 PLOT THE A0 STRING OUTRIGHT USING L_MESS
*               (IT CONTAINS ALL DATA)
*
*        A1 = 1  PLOT ONLY THE STRING LIST (1, 2 or 3 POINTERS
*                CENTERED APPROPRIATELY
*
*        A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE
*        
*        A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*        A1 = 4  PLOT THE 3RD LINE OF THE STRING LIST ALONG
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*        A1 = 5 PLOT THE 1ST LINE W/ 2 CREDITS PER PLAYER
*
*        A1 = 6 PLOT THE 2ND LINE W/2 CREDITS PER PLAYER
*
*        A1 = 7 PLOT THE 3RD LINE W/2 CREDITS PER PLAYER
*
*        A1 = 8 PLOT CUSTOM MESSAGE
*
         MOVE    A0,A8                                                 
         MOVI    LONG_SIZE,A0              ;INDEX A1 INTO A TABLE
         MPYU    A0,A1                     ;A1 HAS OFFSET
         ADDI    HELP_TAB,A1               ;A1 POINTS AT VECTOR
         MOVE    *A1,A1,L                  ;GET THE VECTOR

         MOVI    BOT_PROMPT,A7
         MOVE    A7,-*A12,L                ;PUSH RETURN ADDRESS
         JUMP    A1                        ;THUS "JSRP"ing THE ROUTINE

BOT_PROMPT
         JSRP    ADD_PROMPT           ;ADD THE HELPFUL HARDWARE PROMPT

         RETP

HELP_TAB .LONG   L_MESS               ;0 SAYS USE L_MESS
         .LONG   JUST_LIST            ;1 SAYS USE LISTED MESSAGES ONLY
         .LONG   LINE_ONE_PLUS        ;2 SAYS USE 1ST LINE W/ 2 TO START
         .LONG   LINE_TWO_PLUS        ;3
         .LONG   LINE_THREE_PLUS      ;4
         .LONG   LINE_ONE_PLUS_2      ;5 USE 1ST LINE 2/ 2 CREDITS PER PLAYER
         .LONG   LINE_TWO_PLUS_2      ;6
         .LONG   LINE_THREE_PLUS_2    ;7
         .LONG   OUTPUT_CUSTOM        ;8 CUSTOM MESSAGE!

JUST_LIST
         MOVE    A8,A3                ;STASH WHERE IT WILL SURVIVE
         MOVE    *A3(LONG_SIZE),A2,L  ;ONE WORD ONLY?
         JRZ     JUST_ONE             ;YEP....CENTER IT NICELY
*
*        there's a 2nd line...check for 3rd!
*
         MOVE    *A3(2*LONG_SIZE),A2,L  ;IS THERE A 3RD LINE?
         JRZ     JUST_TWO               ;NOPE

         MOVI    SETUP_3_OF_3,A8
         JSRP    SET_THEN_A2

         MOVE    *A3(LONG_SIZE),A2,L    ;GET LINE 2

         MOVI    SETUP_2_OF_3,A8
         JSRP    SET_THEN_A2

         MOVI    SETUP_1_OF_3,A8        ;SET HEIGHT FOR TOP LINE
         JRUC    FIRST_LINE

JUST_TWO
         MOVE    *A3(LONG_SIZE),A2,L    ;GET LINE 2
         MOVI    SETUP_2_OF_2,A8
         JSRP    SET_THEN_A2

         MOVI    SETUP_1_OF_2,A8

FIRST_LINE
         MOVE    *A3,A2,L
         JRUC    SET_THEN_A2               ;DO TOP LEN AND RETURN

JUST_ONE MOVI    SETUP_1_OF_1,A8
         JRUC    FIRST_LINE                ;DO TOP LEN AND RETURN

*
*        OUTPUT THE CUSTOM MESSAGE
*
CM_LINE1 EQU     CUSTOM_MESSAGE
CM_LINE2 EQU     CUSTOM_MESSAGE+CMESS_LINE_SIZE
CM_LINE3 EQU     CUSTOM_MESSAGE+(2*CMESS_LINE_SIZE)

OUTPUT_CUSTOM
         MOVI    CM_LINE3,A10         ;CHECK LINE 3
         CALLR   CK_LINE              ;3 VALID LINES?
         JRZ     GO_FOR_2

         MOVI    SETUP_3_OF_3,A8
         JSRP    SET_THEN_STRNGRAM    ;PUT IT OUT

         MOVI    CM_LINE2,A10
         MOVI    SETUP_2_OF_3,A8
         JSRP    SET_THEN_STRNGRAM

         MOVI    CM_LINE1,A10
         MOVI    SETUP_1_OF_3,A8
         JRUC    SET_THEN_STRNGRAM

GO_FOR_2
         MOVI    CM_LINE2,A10         ;CHECK LINE 2
         CALLR   CK_LINE              ;3 VALID LINES?
         JRZ     GO_FOR_1

         MOVI    SETUP_2_OF_2,A8
         JSRP    SET_THEN_STRNGRAM    ;PUT IT OUT

         MOVI    CM_LINE1,A10
         MOVI    SETUP_1_OF_2,A8
         JRUC    SET_THEN_STRNGRAM

GO_FOR_1
         MOVI    CM_LINE1,A10
         MOVI    SETUP_1_OF_1,A8
         JRUC    SET_THEN_STRNGRAM

**************************************************************************
*                                                                        *
*          SET_THEN_A2                                                   *
*                                                                        *
*          THIS IS A PRIMITIVE FOR THE COIN PAGE PLOTTERS.               *
*                                                                        *
*          IT SETS UP WITH THE STRING IN A8, THEN FINSHES                *
*          ON THE STRING IN A2.                                          *
*                                                                        *
*          JSRP THIS ROUTINE!                                            *
*                                                                        *
**************************************************************************
SET_THEN_A2
         CALLA   LM_SETUP
         MOVE    A2,A8
         JAUC    LM_FINIS               ;THAT DOES LINE 3

**************************************************************************
*                                                                        *
*          SET_THEN_STRNGRAM                                             *
*                                                                        *
*          A10 POINTS AT A CMOS STRING FOR CUSTOM MESSAGE.               *
*          A8 CONTAINS THE SETUP STRING FOR PRINTING THIS                *
*          STRING OUT.  CONVERT FROM CMOS TO STRNGRAM                    *
*          AND PRINT ON THE STRING.                                      *
*                                                                        *
**************************************************************************
SET_THEN_STRNGRAM
         CALLR   CK_LINE                ;TRANSFER TO STRNGRAM
         CALLA   LM_SETUP
         MOVI    STRNGRAM,A8
         JAUC    LM_FINIS

**************************************************************************
*                                                                        *
*          CK_LINE                                                       *
*                                                                        *
*          A10 POINTS AT A CMOS STRING.  WE MOVE THIS STRING             *
*          TO OUR PDATA AREA.  THEN WE CALL BUILD_ST TO                  *
*          PACK IT INTO "STRNGRAM" WE RETURN .EQ. (PASSED FROM           *
*          BUILD_ST) BACK TO OUR CALLER IF IT IS ALL SPACES.             *
*                                                                        *
**************************************************************************
CK_LINE  MMTM    SP,A0,A7,A1,A2,A10
         MOVE    A10,A7               ;INPUT POINTER TO CMOS
         MOVE    A13,A10              ;OUR PDATA AREA
         ADDI    PDATA,A10            ;A10 IS DESTINATION.
         MOVE    A10,A2               ;ITERATE TO LOAD IT UP.

         MOVI    CMESS_CHARS,A1       ;COUNTER
         CALLA   ADJ_PAGE             ;POINT THE PAGE

CK_LOOP  CALLA   RC_BYTEI             ;FETCH A BYTE
         MOVB    A0,*A2               ;STORE
         ADDI    BYTE_SIZE,A2
         DSJS    A1,CK_LOOP

         CALLA   DEF_PAGE             ;POINT AWAY NOW
         CALLA   BUILD_ST             ;NOW XFER TO STRNGRAM (REMOVING SPACES ETC)
	MMFM    SP,A0,A7,A1,A2,A10   ;RETURN .EQ. IF ITS ALL SPACES.
	RETS

LINE_ONE_PLUS
         MOVE    *A8,A2,L             ;GET LINE 1
LOP_1    MOVI    SETUP_1_OF_3,A8
         CALLA   LM_SETUP
         MOVE    A2,A8                ;SWAP IN TEXT POINTER
         JSRP    LM_FINIS             ;PRINT IT

LOP_2    MOVI    TWO_TS,A8            ;TWO TO START STUFF
         JAUC    L_MESS               ;PRINT IT AND RETURN

*
*        IF THE GAME IS IN A 2 TO START....2 TO CONTINUE MODE
*
LINE_THREE_PLUS
         MOVE    *A8(2*LONG_SIZE),A2,L  ;FETCH LINE 3
         JRZ     LOP_2                ;NOTHING ON LINE 3
         JAUC    LOP_1                ;THEN ITS THE SAME AS ABOVE!

LINE_TWO_PLUS
         MOVE    *A8(LONG_SIZE),A2,L  ;FETCH LINE 2
         JRZ     LOP_2                ;NOTHING ON LINE 2
         JAUC    LOP_1                ;THEN ITS THE SAME AS ABOVE!

LINE_ONE_PLUS_2
         MOVE    *A8,A2,L             ;GET LINE 1
LOP_12   MOVI    SETUP_1_OF_2,A8
         CALLA   LM_SETUP
         MOVE    A2,A8                ;SWAP IN TEXT POINTER
         JSRP    LM_FINIS             ;PRINT IT

LOP_22   MOVI    TWO_TP,A8            ;TWO CREDITS PER PLAYER
         JAUC    L_MESS               ;PRINT IT AND RETURN

LINE_TWO_PLUS_2
         MOVE    *A8(LONG_SIZE),A2,L  ;FETCH LINE 2
         JRZ     LOP_22               ;NOTHING ON LINE 2
         JAUC    LOP_12               ;THEN ITS THE SAME AS ABOVE!

LINE_THREE_PLUS_2
         MOVE    *A8(2*LONG_SIZE),A2,L  ;FETCH LINE 3
         JRZ     LOP_22               ;NOTHING ON LINE 3
         JAUC    LOP_12               ;THEN ITS THE SAME AS ABOVE!

**************************************************************************
*                                                                        *
*          SELECT_SETUP                                                  *
*                                                                        *
*          THIS IS CALLED TO SELECT A SETUP STRING FOR THE               *
*          CREDITS MESSAGE.  IF THERE IS PROMPTING TO ADD...WE           *
*          DROP IT DOWN....ELSE WE PRINT IT CENTERED.                    *
*                                                                        *
**************************************************************************
SELECT_SETUP
         MMTM    SP,A0                     
         MOVI    MESS_CNUM,A8              ;ASSUME NO EXTRA PROMPT

         CALLA   CKPROMPT                  ;IS THERE ONE?
         JRZ     NO_EXTRA

         MOVI    MESS_LOWNUM,A8
NO_EXTRA	MMFM    SP,A0                     
	RETS
 
**************************************************************************
*                                                                        *
*          FETCH_REQ                                                     *
*                                                                        *
*          THIS ROUTINE FETCHES THE NUMBER OF UNITS REQUIRED             *
*          FOR CREDIT, BONUS AND MINIMUM:                                *
*                                                                        *
*                  A2 = REQ FOR CREDITS                                  *
*                  A3 = REQ FOR BONUS                                    *
*                  A4 = MINIMUM                                          *
*                                                                        *
**************************************************************************
FETCH_REQ
         MMTM    SP,A0
         MOVI    ADJCUNIT,A0
         CALLR   GET_ADJ
         MOVE    A0,A2

         MOVI    ADJBUNIT,A0
         CALLR   GET_ADJ
         MOVE    A0,A3

         MOVI    ADJMUNIT,A0
         CALLR   GET_ADJ_FOR_COIN
         MOVE    A0,A4
	MMFM    SP,A0
	RETS

**************************************************************************
*                                                                        *
*          SLAM_P                                                        *
*                                                                        *
*          IS THERE A SLAM PROCESS RUNNING?                              *
*                                                                        *
*          .EQ.    NO                                                    *
*          .NE.    YES                                                   *
*                                                                        *
**************************************************************************
SLAM_P   MOVI    SLAM_PID,A0          ;SLAM PROCESS ACTIVE?
         MOVI    0FFFFH,A1
         CALLA   EXISTP
	 RETS

SLAM_SW  MOVI    SLAM_PID,A0
         MOVE    A0,*A13(PROCID),W    ;SET OUR ID TO SLAM
         MOVI    0FFFFH,A1
         CALLA   KILALL               ;KILL ANY OTHER INCARNATIONS

         SLEEP   40H                  ;1 SECOND OF COIN IGNORING.
         JAUC    SUCIDE

**************************************************************************
*                                                                        *
*          FORM_COIN_CKSUM                                               *
*                                                                        *
*          THIS ROUTINE IS CALLED TO FORM THE COIN/CREDITS               *
*          CHECKSUM.  THE CHECKSUM IS RETURNED IN A1.                    *
*                                                                        *
*          .EQ.   IT MATCHES WHATS THERE                                 *
*          .NE.   IT DOESN'T MATCH                                       *
*                                                                        *
**************************************************************************
FORM_COIN_CKSUM
         MMTM    SP,A0,A7,A2
         CALLR   COIN_PAG                 ;MAKE SURE WE'RE ON THE RIGHT PAGE.
         MOVI    COIN_CKSUM_START,A7       ;POINT AT FIRST BYTE TO CHECK
         MOVI    COIN_CKSUM_BYTES,A2
         CLR     A1                        ;CLEAR OUT CHECKSUM

CN_SUM   CALLA   RC_BYTEI                  ;FETCH A BYTE IN A0
         ADD     A0,A1                     ;ADD TO SUM
         DSJS    A2,CN_SUM                 ;TILL WE HAVE EM ALL

         NOT     A1                        ;COMPLEMENT OF COURSE
         ANDI    BYTE_MASK,A1              ;AND KEEP THE BYTE

         MOVI    COIN_CKSUM,A7
         CALLA   RC_BYTE                   ;FETCH THE CURRENT CKSUM
         CMP     A0,A1                     ;COMPARE TO THIS
	MMFM    SP,A0,A7,A2
	RETS

FORM_COIN_CKSUM_AND_STORE
         MMTM    SP,A1,A7,A0
         CALLR   FORM_COIN_CKSUM
         MOVI    COIN_CKSUM,A7
         MOVE    A1,A0
         CALLA   WC_BYTE
	MMFM    SP,A1,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          CCCC                                                          *
*                                                                        *
*          Check_Coin_and_Clear_on_bad_Checksum.                         *
*                                                                        *
*          This is called before operations that deal with               *
*          the coinage and credits values.                               *
*                                                                        *
*          It checks to see if they area is in tact. If it               *
*          is, then no action is performed.                              *
*                                                                        *
*          Else, it clears our all values (credits, etc.)                *
*          so that nothing is given away erroneously.                    *
*                                                                        *
**************************************************************************
CCCC     MMTM    SP,A0,A1,A7,A2
         CALLR   FORM_COIN_CKSUM      ;THIS SETS US TO THE COINAGE PAGE!
         JRZ     CCCCX                ;ALL IS OK!

         MOVI    COIN_CKSUM_START,A7  ;POINT AT FIRST BYTE
         MOVI    COIN_CKSUM_BYTES,A2  ;NUMBER OF BYTES TO CLEAR
         CLR     A0

CCCC_LOOP
         CALLA   WC_BYTEI             ;WRITE A BYTE
         DSJS    A2,CCCC_LOOP         ;UNTIL THEY'RE DONE!

         CALLR   FORM_COIN_CKSUM_AND_STORE  ;NOW MAKE THE CKSUM VALID

CCCCX    MMFM    SP,A0,A1,A7,A2
	RETS

**************************************************************************
*                                                                        *
*          COIN_PAG                                                     *
*                                                                        *
*          THIS SETS THE CURRENT CMOS PAGE FOR COIN/CREDITS              *
*                                                                        *
**************************************************************************
COIN_PAG
         MMTM    SP,A1
         MOVI    COIN_SELECT,A1       ;THIS IS COIN/CREDITS PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*         AUDIT HANDLING                                                 *
*                                                                        *
**************************************************************************
*                                                                        *
*          POINT_AT_AUDIT                                                *
*                                                                        *
*          THIS IS CALLED TO POINT AT THE AUDIT INDICATED BY             *
*          A0.  A0 IS THE AUDIT NUMBER 0-30.  A7 IS RETURNED             *
*          POINTING AT THE BEGINNING OF THE AUDIT.                       *
*                                                                        *
**************************************************************************
POINT_AT_AUDIT
         MMTM    SP,A1
         CALLR   AUDIT_PAGE

         MOVI    AUD_SIZE,A7          ;THIS IS SIZE PER AUDIT
         MPYU    A0,A7                ;A1 NOW HAS OFFSET
         ADDI    AUDITORG,A7          ;ADD BASE
	MMFM    SP,A1
	RETS

AUDIT_PAGE
         MMTM    SP,A1
         MOVI    AUDIT_SELECT,A1      ;THIS IS AUDIT PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM                                                *
*                                                                        *
*          THIS IS CALLED TO FORM THE CHECKSUM FOR THE AUDIT             *
*          SPECIFIED IN A0.                                              *
*                                                                        *
*          A1 RETURNS THE CHECKSUM.                                      *
*                                                                        *
*          Z BIT IS SET BASED ON WHETHER IT MATCHES THE CHECKSUM THERE.  *
*                                                                        *
**************************************************************************
FORM_AUD_CKSUM
         MMTM    SP,A0,A4,A7
         CALLR   POINT_AT_AUDIT            ;A7 = POINTER TO CURRENT ENTRY
         MMTM    SP,A7                     ;SAVE POINTER TO ENTRY
         MOVI    AUD_BYTES_TO_CHECK,A4     ;COUNT DOWN THE BYTES
         CLR     A1                        ;KEEP SUM IN A1
ADD_A_BYTE
         CALLA   RC_BYTEI                  ;GET A BYTE INTO A0
         ADD     A0,A1                     ;ADD TO SUM
         DSJ     A4,ADD_A_BYTE             ;ONE MORE ADDED
         NOT     A1                        ;CHECKSUM IS NOW IN LOW WORD
         ANDI    WORD_MASK,A1              ;MASK SO ITS COOL
	MMFM    SP,A7                     ;GET POINTER BACK
         ADDI    AUD_CKSUM,A7              ;POINT AT CHECKBYTE
         CALLA   RC_WORD                   ;READ IN THE CKSUM
         CMP     A0,A1                     ;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM    SP,A0,A4,A7               ;Z BIT RETURNS COMPARE
	RETS                              ;A1 RETURNS CKSUM

**************************************************************************
*                                                                        *
*          STORE_AUD_CKSUM                                               *
*                                                                        *
*          THIS WILL STORE THE AUDIT CHECKSUM IN A1 FOR THE              *
*          AUDIT NUMBER SPECIFIED BY A0.                                 *
*                                                                        *
**************************************************************************
STORE_AUD_CKSUM
         MMTM    SP,A7,A0                  ;POINTING REGISTER
         CALLR   POINT_AT_AUDIT            ;A7 POINTS AT AUDIT
         ADDI    AUD_CKSUM,A7              ;POINT AT CHECKBYTE
         MOVE    A1,A0                     ;GET CHECKBYTE IN A0
         CALLA   WC_WORD                   ;WRITE THE CKSUM
	MMFM    SP,A7,A0                  ;POINTING REGISTER
	RETS

**************************************************************************
*                                                                        *
*          FORM_AUD_CKSUM_AND_STORE                                      *
*                                                                        *
*          THE VALUE AT BAD_AUD IS USED TO DETERMINE WHETHER TO STORE    *
*          THE CORRECT OR INCORRECT VALUE!                               *
*                                                                        *
*          A0 = AUDIT NUMBER                                             *
*                                                                        *
**************************************************************************
FORM_AUD_CKSUM_AND_STORE
         MMTM    SP,A1,A2                     ;SAVE A1!
         CALLR   FORM_AUD_CKSUM
         MOVE    @BAD_AUD,A2,W                ;GET THE "FUDGE" WORD
         XOR     A2,A1                        ;MAKE CKSUM BAD IF AUDIT IS BAD
         CALLR   STORE_AUD_CKSUM
	MMFM    SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
*          GET_AUD                                                       *
*                                                                        *
*          THIS IS CALLED TO FETCH THE AUDIT VALUE FOR THE AUDIT         *
*          SPECIFIED IN A0 INTO A1.  IF THE CHECKBYTE FOR THE            *
*          AUDIT IS INCORRECT, THEN RAM LOCATION BAD_AUD WILL BE         *
*          SET TO 1.                                                     *
*                                                                        *
**************************************************************************
GET_AUD
         MMTM    SP,A7,A0
         CALLR   FORM_AUD_CKSUM       ;SEE IF CKSUM IS OK
         JRZ     FETCH_AUDIT_1        ;ITS OK....
*
*        CHECKSUM IS BAD....SET GLOBAL
*
         MOVK    1,A1
         MOVE    A1,@BAD_AUD,W        ;SET THE FLAG!

FETCH_AUDIT_1
         CALLR   POINT_AT_AUDIT       ;A7 POINTS AT AUDIT
         ADDI    AUD_DATA,A7          ;ADD ZERO OFFSET
         CALLA   RC_LONG              ;FETCH THE LONG WORD TO A0
         MOVE    A0,A1                ;RETURN IN A1
	MMFM    SP,A7,A0
	RETS

**************************************************************************
*                                                                        *
*          STORE_AUDIT                                                   *
*                                                                        *
*          A0 = AUDIT NUMBER TO STORE VALUE FOR                          *
*          A1 = VALUE TO STORE.                                          *
*          BAD_AUD = NON ZERO IF BAD CHECKSUM IS TO BE MAINTAINED.       *
*                                                                        *
**************************************************************************
STORE_AUDIT
         MMTM    SP,A0,A7
         CALLR   POINT_AT_AUDIT       ;A7 POINTS AT AUDIT
         ADDI    AUD_DATA,A7          ;ADD ZERO OFFSET
         MOVE    A1,A0                ;MOVE DATA TO WRITING REGISTER
         CALLA   WC_LONG              ;WRITE THE DATA BACK
	MMFM    SP,A0,A7             ;GET AUDIT NUMBER BACK
         JRUC    FORM_AUD_CKSUM_AND_STORE    ;STORE GOOD OR BAD CKSUM BASED
*                                            ;ON BAD_AUD

**************************************************************************
*                                                                        *
*          CLR_SUBS                                                      *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT THE COINAGE SUB-TOTALS.           *
*                                                                        *
**************************************************************************
CLR_SUBS MOVI    FRST_SUB,A0
         MOVI    LAST_SUB,A1
         CALLR   CLR_AUDR        ;CLEAR EM OUT!
         RETP

**************************************************************************
*                                                                        *
*          CLR_AUDR                                                 *
*                                                                        *
*          THIS IS CALLED TO CLEAR OUT A RANGE OF AUDITS.                *
*          A0 = 1ST AUDIT NUMBER                                         *
*          A1 = LAST AUDIT NUMBER (INCLUSIVE)                            *
*                                                                        *
**************************************************************************
CLR_AUDR
         MMTM    SP,A0,A1,A2
         MOVE    A1,A2                     ;MOVE "LAST" TO A2
         CLR     A1                        ;WE'LL STORE ZEROS
         MOVE    A1,@BAD_AUD               ;MAKE CKSUMS GOOD ON STORING
CAR1     CALLR   STORE_AUDIT               ;STORE THIS AUDIT
         INC     A0                        ;KICK TO NEXT AUDIT
         CMP     A2,A0
         JRLS    CAR1
	MMFM    SP,A0,A1,A2
	RETS

**************************************************************************
*                                                                        *
* 	CLR_DUMP_AUD							 *
* 									 *
* 	This is called by both joysticks down while looking		 *
* 	at dump page.   It clears out the audits associated		 *
* 	with that page.							 *
*                                                                        *
**************************************************************************
CLR_DUMP_AUD
        MOVI    AUDDOGGY,A0 
	CALLR   KILL_AUD
        MOVI    AUDLOCK,A0  
	CALLR   KILL_AUD
        MOVI    AUDTRAP,A0  
	CALLR   KILL_AUD
        MOVI    AUDSURV,A0  
	CALLR   KILL_AUD
        MOVI    AUDBONE,A0  
	CALLR   KILL_AUD
	RETS

**************************************************************************
*                                                                        *
* 	KILL_AUD							 *
* 									 *
* 	This is called to clear out an audit.				 *
* 									 *
* 	A0 = audit number.						 *
*                                                                        *
**************************************************************************
KILL_AUD
	MMTM	SP,A1
        CLR     A1                        ;WE'LL STORE ZEROS
        MOVE    A1,@BAD_AUD               ;MAKE CKSUMS GOOD ON STORING
        CALLR   STORE_AUDIT               ;STORE THIS AUDIT
	MMFM	SP,A1
	RETS

**************************************************************************
*                                                                        *
*          AUD                                                           *
*                                                                        *
*          A0 = AUDIT NUMBER.......A1 = COUNT TO ADD.                    *
*                                                                        *
**************************************************************************
AUD      MMTM    SP,A1,A2
         CLR     A2                   ;SET "BAD_AUD" GOOD UNTIL OTHERWISE PROVEN!
         MOVE    A2,@BAD_AUD,W        ;ITS GOOD.
         MOVE    A1,A2                ;COPY OUR COUNT
         CALLR   GET_AUD              ;FETCH THE CURRENT AUDIT COUNTER
         ADD     A2,A1                ;ADD THE NEW COUNT
         CALLR   STORE_AUDIT          ;STORE IT BACK
         CALLR   DEF_PAGE             ;SWITCH PAGE AWAY FROM THE DATA!
	MMFM    SP,A1,A2
	RETS

AUD1     MMTM    SP,A1
         MOVK    1,A1
         CALLR   AUD
	MMFM    SP,A1
	RETS

**************************************************************************
*                                                                        *
*          CLR_AUD                                                       *
*                                                                        *
*          This is called to clear out all of the audits.                *
*                                                                        *
*          A relatively easy task given the primitives available.        *
*                                                                        *
**************************************************************************
CLR_AUD  MMTM    SP,A0,A1
         MOVI    1,A0                 ;START AT AUDIT 1
         MOVI    N_AUDITS-1,A1        ;THIS IS TOTAL ALLOCATED
         CALLR   CLR_AUDR
	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          ADJUSTMENTS                                                   *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
*          CMOS_VAL                                                     *
*                                                                        *
*          ARE ADJUSTMENTS AND NAME/REV OK?                              *
*                                                                        *
*          .EQ. MEANS YES                                                *
*          .NE. MEANS NO                                                 *
*                                                                        *
**************************************************************************
CMOS_VAL
         CALLR   FORM_ADC  ;SEE IF CKSUM IS OK.
         JRNZ    CMOS_BAD        ;NOPE....RETURN .NE.

         CALLR   CHECK_NAME_AND_REV   ;HOW ABOUT THE NAME AND REV?
CMOS_BAD
         RETS

**************************************************************************
*                                                                        *
*          Adjustments are all stored as long words in CMOS.             *
*          They are referenced by adjustment number.  Stuff              *
*          adjustment number in A0.  Call GET_ADJ and the                *
*          value is returned in A0.                                      *
*                                                                        *
**************************************************************************
**************************************************************************
*                                                                        *
*          FORM_ADC                                                *
*                                                                        *
*          THIS IS CALLED TO FORM THE CHECKSUM FOR THE ADJUSTMENTS       *
*          AREA.  IT IS RETURNED IN A1.                                  *
*                                                                        *
*          IT IS COMPARED TO THE REAL CHECKSUM AND .EQ. RETURNED IF OK.  *
*                                                                        *
**************************************************************************
FORM_ADC 
         MMTM    SP,A7,A0,A6
         CALLR   ADJ_PAGE          ;SET CMOS PAGE FOR ADJUSTMENTS
         MOVI    ADJUSTORG,A7         ;POINT AT FIRST BYTE
         MOVI    ADJ_BYTES_TO_CHECK,A6  ;NUMBER OF BYTES
         CLR     A1                     ;ACCUMULATE CKSUM HERE

ADJ_C1   CALLA   RC_BYTEI               ;READ A BYTE
         ADD     A0,A1                  ;ADD THE BYTE TO THE SUM
         DSJS    A6,ADJ_C1

         NOT     A1                     ;COMPLEMENT THE SUM
         ANDI    WORD_MASK,A1           ;KEEP A WORD.

         MOVI    ADJ_CKSUM,A7
         CALLA   RC_WORD                ;FETCH THE CHECKSUM
         CMP     A0,A1                  ;COMPARE TO FETCHED VALUE
	MMFM    SP,A7,A0,A6
	RETS

**************************************************************************
*                                                                        *
*          F_ADC_S                                                       *
*                                                                        *
*          CALCULATE THE ADJUSTMENT CHECKSUM AND STORE THE               *
*          NEW VALUE.                                                    *
*                                                                        *
**************************************************************************
F_ADC_S
         MMTM    SP,A0,A1,A7
         CALLR   FORM_ADC         ;FORM THE CKSUM
         MOVE    A1,A0                  ;PUT IN CMOS WRITING REGGIE
         MOVI    ADJ_CKSUM,A7
         CALLA   WC_WORD                ;AND STORE IT
	MMFM    SP,A0,A1,A7
	RETS

**************************************************************************
*                                                                        *
*          GET_ADJ                                                       *
*                                                                        *
*          THIS IS CALLED TO FETCH THE VALUE OF AN ADJUSTMENT.           *
*                                                                        *
*          THE ADJUSTMENT NUMBER IS GIVEN IN A0.                         *
*          THE VALUE FOR THE ADJUSTMENT IS RETURNED IN A0.               *
*                                                                        *
**************************************************************************
GET_ADJ  MMTM    SP,A1,A7
         CALLR   ADJPOINT             ;POINT AT ADJUSTMENT
         CALLA   RC_LONG              ;FETCH THE ADJUST PLEASE
         CALLR   DEF_PAGE
         MOVE    A0,A0                ;RETURN Z BIT BASED ON ADJUSTMENT!
	MMFM    SP,A1,A7
	RETS

**************************************************************************
*                                                                        *
*          PUT_ADJ                                                       *
*                                                                        *
*          ADJUST NUMBER IN A0.                                          *
*          VALUE IN A1.                                                  *
*          STORE IT!........                                             *
*                                                                        *
*          ****************** THIS IS A UTILITY......IT DOES NOT         *
*                             CORRECT ANY CHECKSUM CHANGE THAT           *
*                             MAY OCCUR!!                                *
*                                         ***************************    *
*                                                                        *
**************************************************************************
PUT_ADJ  MMTM    SP,A7,A0
         CALLR   ADJPOINT             ;POINT AT REQUESTED ADJ.
         MOVE    A1,A0                ;GET VALUE IN WRITING REGGIE!
         CALLA   WC_LONG              ;WRITE THE ADJUSTMENT
         CALLR   DEF_PAGE             ;SWAP PAGE AWAY.
	MMFM    SP,A7,A0
	RETS

ADJPOINT
         CALLR   ADJ_PAGE             ;SET CMOS PAGE FOR ADJUSTMENTS
         MOVI    ADJ_SIZE,A7          ;SIZE PER ADJUSTMENT IN A7
         MPYU    A0,A7                ;TIMES ADJUSTMENT REQUESTED.

         ADDI    ADJUSTORG,A7         ;ADD TO BASE
         RETS

GET_ADJ_FOR_COIN
         CALLR   GET_ADJ              ;GET THE ADJUSTMENT
         JAUC    COIN_PAG            ;THEN RE-INSTATE THE COIN PAGE!

**************************************************************************
*                                                                        *
*          CHECK_NAME_AND_REV                                            *
*                                                                        *
*          THIS ROUTINE IS CALLED TO SEE IF THE GAME NAME/REV IS         *
*          CORRECT.  IF IT IS NOT, THE GAME WILL AUTOMATICALLY           *
*          FACTORY SET.   .EQ. MEANS OK!                                 *
*                                                                        *
**************************************************************************
CHECK_NAME_AND_REV
         MMTM    SP,A0,A1,A2,A3,A7
         CALLR   ADJ_PAGE          ;MAKE SURE WE'RE ON THE CORRECT PAGE

         MOVI    NAME_REV,A7          ;POINT AT CMOS NAME STORAGE
         MOVI    ROM_NAME,A1          ;POINT AT OUR VERSION
         MOVI    NAME_REV_SIZE,A2     ;MAXIMUM NAME SIZE

NEXT_LET1
         CALLA   RC_BYTEI             ;FETCH A BYTE
         MOVB    *A1,A3               ;GET 1 FROM ROM
         ANDI    BYTE_MASK,A3         ;MASK ANY SIGN EXTENDS

         CMP     A3,A0                ;THEY BETTER BE THE SAME
         JRNZ    RETURN_NOW           ;NOPE....BYE  (RETURN .NE.)

         ADDI    BYTE_SIZE,A1         ;KICK SOURCE POINTER
         MOVE    A0,A0                ;WAS IT A ZERO?
         JRZ     RETURN_NOW           ;YEP....NO MORE (RETURN .EQ.)
         DSJS    A2,NEXT_LET1
         CLR     A0                   ;RETURN .EQ.
         
RETURN_NOW
	MMFM    SP,A0,A1,A2,A3,A7
	RETS

**************************************************************************
*                                                                        *
*          ADJ_PAGE                                                   *
*                                                                        *
*          THIS SETS THE CURRENT CMOS PAGE FOR ADJUSTMENTS.              *
*                                                                        *
**************************************************************************
ADJ_PAGE
         MMTM    SP,A1
         MOVI    ADJUST_SELECT,A1      ;THIS IS AUDIT PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS


**************************************************************************
*                                                                        *
*          DEF_PAGE                                                      *
*                                                                        *
*          THIS SWITCHES TO "DEFAULT" PAGE.  THE DEFAULT                 *
*          PAGE IS THE ONE THAT WE WOULD LIKE TO SMASH                   *
*          MOST IN THE CASE OF A CRASH.  AFTER MOST                      *
*          PROCESSING, WE SWITCH TO THIS PAGE!                           *
*                                                                        *
**************************************************************************
DEF_PAGE
         PUSHST                       ;PRESERVE CODES THAT ARE BEING RETURNED
         MMTM    SP,A1
         MOVI    TODAYS_SELECT,A1     ;THIS IS TODAY'S HIGH SCORES PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
         MMFM    SP,A1
         POPST
	 RETS

**************************************************************************
*                                                                        *
*          FAC_SET                                                       *
*                                                                        *
*          THIS ROUTINE RESTORES THE FACTORY SETTINGS TO THE             *
*          ADJUSTMENTS.                                                  *
*                                                                        *
**************************************************************************
FAC_SET  MMTM    SP,A0,A1,A2,A7
         CALLR   DUMP_FS              ;CLEAR OUT "DUMP" MEMORY
         CALLR   NO_CREDS             ;REMOVE ANY COINS
**************************************************************************
*                                                                        *
*          CALLR   HS_RESET_COUNTER                                      *
*                                                                        *
**************************************************************************
         CALLR   ADJ_PAGE             ;SET CMOS PAGE CORRECTLY

         MOVI    FACTORY_TABLE,A1     ;ROM
         MOVI    ADJUSTORG,A7         ;CMOS
         MOVI    N_ADJUSTS,A2         ;NUMBER OF ADJUSTMENTS ALLOCATED

FACS1    MOVE    *A1+,A0,L            ;FETCH A ROM LONG WORD
         CALLA   WC_LONGI             ;WRITE THE WORD TO CMOS
         DSJS    A2,FACS1             ;WRITE 1 LONG WORD PER ADJUST

         CALLR   SWITCH_FOR_JUMPER    ;CHANGE COINAGE BASED ON JUMPER.

         CALLR   LD_CTAB      ;EXPAND THE CSELCT VALUE

         CALLR   F_ADC_S  ;MAKE THE CHECKSUM CORRECT.
*
*        NOW STORE THE GAME NAME AND REVISION INFO
*
         MOVI    NAME_REV,A7          ;POINT AT CMOS NAME STORAGE
         MOVI    ROM_NAME,A1          ;POINT AT OUR VERSION
         MOVI    NAME_REV_SIZE,A2     ;MAXIMUM NAME SIZE

NEXT_LETTER
         MOVB    *A1,A0               ;FETCH A BYTE
         CALLA   WC_BYTEI             ;WRITE IT TO CMOS
         ADDI    BYTE_SIZE,A1         ;KICK SOURCE POINTER
         MOVE    A0,A0                ;WAS IT A ZERO?
         JRZ     NAME_DONE            ;YEP....NO MORE!
         DSJS    A2,NEXT_LETTER
         
NAME_DONE
	MMFM    SP,A0,A1,A2,A7
	RETS

**************************************************************************
*                                                                        *
*          SWITCH_FOR_JUMPER                                             *
*                                                                        *
*          THIS IS CALLED OUT OF THE FACTORY SETTING SEQUENCE.           *
*          IT CHECKS FOR JUMPER COMBINATIONS INDICATING                  *
*          GERMAN OR FRENCH GAMES.                                       *
*                                                                        *
*          THE JUMPERS ARE CONNECTED AS FOLLOWS:                         *
*                                                                        *
*                     GERMAN JUMPER = BIT 15 OF "COINS"                  *
*                     FRENCH JUMPER = BIT 14 OF "COINS"                  *
*                                                                        *
*          IF BOTH JUMPERS ARE IN, OR BOTH ARE MISSING, THEN             *
*          ITS U.S. DEFAULT....LEAVE EVERYTHING ALONE.                   *
*                                                                        *
*          IF GERMAN IS MISSING (READ AS A 1) THEN USE                   *
*          GERMAN 1 COINAGE.                                             *
*                                                                        *
*          IF FRENCH IS MISSING THEN USE FRENCH 1 COINAGE.               *
*                                                                        *
**************************************************************************
SWITCH_FOR_JUMPER
         MMTM    SP,A0
         MOVE    @COINS,A0,W          ;GET THE 16 BITS
         ANDI    JUMPERS,A0           ;JUST KEEP THE BITS
         JRZ     USA                  ;BOTH ARE IN...US!

         CMPI    JUMPERS,A0           ;ARE BOTH MISSING?
         JRZ     USA                  ;YEP....US.

         CMPI    GERMAN_BIT,A0        ;IS JUST THE GERMAN MISSING?
         JRNZ    NOGERM               ;NOPE

         CALLR   DO_GERMAN            ;DO THE GERMAN STUFF
         JRUC    SFJX                 ;AND EXIT
*
*        MUST BE FRENCH
*
NOGERM   CALLR   DO_FRENCH            ;IF IT IS NOT POSSIBLE....DO IT.
USA
SFJX     MMFM    SP,A0
	RETS

DO_FRENCH
         MMTM    SP,A0,A1
         MOVI    ADJPRICE,A0          ;AS MASTER PRICER.
         MOVI    F1SEL,A1             ;USE FRENCH SELECTOR
         CALLA   PUT_ADJ
	MMFM    SP,A0,A1
	RETS

DO_GERMAN
         MMTM    SP,A0,A1
         MOVI    ADJPRICE,A0          ;AS MASTER PRICER.
         MOVI    G1SEL,A1             ;USE GERMAN SELECTOR
         CALLA   PUT_ADJ

         MOVI    ADJDIFF,A0
         MOVI    1,A1                 ;DIFFICULTY 1 FOR GERMANS
         CALLA   PUT_ADJ

         MOVI    ADJBUYIN,A0
         MOVI    1,A1                 ;EASY BUY-IN FOR GERMANS
         CALLA   PUT_ADJ

	MMFM    SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
*          LD_CTAB                                                       *
*                                                                        *
*          THIS IS CALLED TO STORE THE CSELCT VALUES FOR                 *
*          THE COIN SELECTOR STORED AS ADJPRICE.                         *
*                                                                        *
**************************************************************************
LD_CTAB
         MMTM    SP,A0,A6,A1
         CALLA   GET_CSPT             ;A6 POINTS AT CORRECT CSELCT VALUE
         MOVI    ADJC1,A0             ;FIRST ONE TO STORE
LCT1     MOVE    *A6+,A1,W            ;FETCH A VALUE (WORD)
         ANDI    WORD_MASK,A1         ;IN CASE SOMEONE SIGN EXTENDS.
         CALLR   PUT_ADJ              ;WRITE THIS ONE TO MEMORY
         INC     A0
         CMPI    ADJCX,A0
         JRLS    LCT1
*
*        NOW INDICATE THAT VALUES ARE "UNTOUCHED"
*
         MOVI    1,A1
         MOVI    ADJVIRGIN,A0         ;THIS SAYS 1ST 8 UNTOUCHED.
         CALLR   PUT_ADJ

         MOVI    ADJ1ST6,A0           ;THIS SAYS 1ST 6 UNTOUCHED.
         CALLR   PUT_ADJ              ;DONE!

	MMFM    SP,A0,A6,A1
	RETS

**************************************************************************
*                                                                        *
* HS_RESET_COUNTER                                                       *
*          MMTM    SP,A0,A7                                              *
*          CALLR   COIN_PAG                                              *
*          MOVI    HSR_C,A7                                              *
*          CLR     A0                                                    *
*          CALLA   WC_LONG                                               *
* 	MMFM    SP,A0,A7                                                *
* 	RETS                                                            *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* CC_COIN                                                                *
*          MMTM    SP,A7                                                 *
*          CALLR   COIN_PAG                                              *
*          MOVI    HSR_C,A7                                              *
*          CALLA   RC_LONG         ;GET THE TABLE COUNTER                *
*          JRZ     CCC_X           ;ITS DOWN                             *
*          DEC     A0              ;1 LESS                               *
*          CALLA   WC_LONG                                               *
* CCC_X	MMFM    SP,A7                                                   *
* 	RETS                                                            *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
*          L_MESS                                                        *
*                                                                        *
*          A8 POINTS AT MESS_MAC FOLLOWED BY MESSAGE TEXT.               *
*             POP ALL REGGIES LEAVING A8 POINTING AT TEXT.               *
*             AND JUMP TO THE TEXT PROCESSOR!                            *
*                                                                        *
*          THE MMFM POPS THE ROUTINE TO CALL INTO A1.                    *
*                                                                        *
*          YOU ***MUST*** USE JSRP TO GET HERE.  WE JUMP TO              *
*          THE STRING ROUTINE WHICH WILL RETP BACK TO THE CALLER!        *
*                                                                        *
**************************************************************************
L_MESS_LOOP      ADDI    BYTE_SIZE,A8         ;PUSH BEYOND THIS BYTE
L_MESS   ADDI    0FH,A8              ;IF IT ENDS IN OTHER THAN ZERO..KICK TO 
*                                     ;NEXT WORD
         ANDI    0FFFFFFF0H,A8        ;AND MASK FRACTIONAL WORD

         MMFM    A8,A1,A6,A9,A10,A11       ;LOAD UP REGGIES FROM A8.
         CLR     A0                        ;NEVER SLEEP!

         MOVI    L_RET,A7
	MOVE	A7,-*A12,L	;PUSH RET ADDR
	JUMP    A1              ;JUMP TO THE ROUTINE.
L_RET    MOVB    *A8,A0          ;CHECK NEXT BYTE 0=DONE...1=MORE.
         JRNZ    L_MESS_LOOP
         RETP
         
**************************************************************************
*                                                                        *
*          LM_SETUP                                                      *
*                                                                        *
*          THIS IS CALLED TO SETUP THE WORLD FOR A STRING                *
*          OPERATION, BUT NOT PHYSICALLY MAKE THE CALL.                  *
*                                                                        *
*          THIS ALLOWS TWEAKING OF REGGIES BEFORE THE CALL.              *
*                                                                        *
*          LM_FINIS                                                     *
*                                                                        *
*          THIS IS CALLED ONCE THE MODIFICATIONS ARE MADE!               *
*                                                                        *
*                                                                        *
**************************************************************************
LM_SETUP MMFM    A8,A1,A6,A9,A10,A11       ;LOAD UP REGGIES FROM A8.
         CLR     A0                        ;DON'T SLEEP
         RETS

LM_FINIS
         JUMP    A1                            ;THIS RUNS ROUTINE AND

**************************************************************************
*                                                                        *
*          GET_CSTR                                                      *
*                                                                        *
*          HERE WE FORM THE CREDITS STRING AND                           *
*          RETURN IT IN THE GEORGE STRING BUFFER.                        *
*          WE RETURN A8 POINTING AT THIS BUFFER.                         *
*                                                                        *
*          WE ALSO PUT APPROPRIATE FRACTION ON THE                       *
*          END IF ADJUSTED ACCORDINGLY.                                  *
*                                                                        *
**************************************************************************
GET_CSTR MOVI    ADJFREPL,A0                    ;ARE WE IN FREE PLAY?
         CALLA   GET_ADJ
         JRZ     NOT_FREE

         MOVI    MESS_FREEP,A8                  ;RETURN POINTING AT FREE PLAY MESSAGE
         JRUC    GET_CX

NOT_FREE
         CALLA   STR_OBJ                        ;ALLOCATE AN OBJECT PLEASE
         JRC     NO_SOBJ                        ;NONE TO USE!
         
         MOVI    MESS_CREDITS,A8                ;POINT AT TEXT PART
         CALLA   STRCAT                         ;BUILD THIS IN.
         CALLR   CRED_P
         MOVE    A0,A10                         ;SAVE CREDITS
         CALLR   CAT_A0
*
*        NOW WE NEED TO SEE IF WE SHOULD ADD A FRACTION.
*
         MOVI    ADJFRAC,A0
         CALLA   GET_ADJ                        ;CHECK THE ADJUSTMENT
         JRZ     NSFRAC                         ;DON'T SHOW IT!
*
*        ADD ANY FRACTION WE HAVE.
*
         CALLR   COIN_PAG                       ;PUT US ON COIN PAGE
         CALLR   GET_CUNITS                     ;A0 HAS CUNITS
         CALLR   DEF_PAGE                       ;FLIP CMOS AWAY
         MOVE    A0,A0                          ;ZERO?
         JRZ     NSFRAC                         ;THEN NO FRACTION.
*
*        WE HAVE A FRACTION...WERE THE CREDITS ZERO?
*
         MOVE    A10,A10                        ;WE SAVED EM IN A10
         JRNZ    NZM                            ;NON ZERO MANTISSA

         MOVE    A7,A8                          ;WALK DOWN STRING LOOKING FOR THE "ZERO"
KILL_Z   MOVB    *A8,A1                         ;GET A BYTE
         JRZ     NZM                            ;COULDN'T FIND IT....GO ON.

         CMPI    LET_0,A1                       ;IS THIS THE ZERO?
         JRZ     GOT_ZERO

         ADDI    BYTE_SIZE,A8
         JRUC    KILL_Z

GOT_ZERO CLR     A1
         MOVB    A1,*A8                         ;KILL THE ZERO

NZM      MOVI    MESS_2SPACE,A8                 ;SPACE BET. MANTISSA AND DENMO
         CALLA   STRCAT

NOT_ZM   CALLR   CAT_A0                         ;ADD A0 ONTO FRACTION

         MOVI    MESS_SLASH,A8
         CALLA   STRCAT                         ;ADD SLASH

         MOVI    ADJCUNIT,A0                    ;UNITS REQUIRED FOR CREDIT
         CALLA   GET_ADJ
         CALLR   CAT_A0                         ;DENOMINATOR

NSFRAC   MOVE    A7,A8                          ;MOVE "OBJECT" TO A8
         MOVI    STRNGRAM,A7                    ;POINT AT STRING RAM
         CLR     A0
         MOVB    A0,*A7                         ;STRINGRAM IS NULL
         CALLA   STRCAT                         ;COPY THE STRING OUT OF OBJECT BLOCK
         MOVE    A7,A8
         CALLA   STR_FREE                       ;AND FREE UP THE OBJECT BLOCK

GET_CX   CLRC                                   ;RETURN OK
GET_CXX  RETS
*
*        NO OBJECTS AVAILABLE TO FORM STRING
*
NO_SOBJ  MOVI    MESS_NULL,A8
         SETC
         JRUC    GET_CXX                        ;RETURN BLANK STRING!

**************************************************************************
*                                                                        *
*          CAT_A0                                                        *
*                                                                        *
*          A0 HAS A BINARY NUMBER.  TURN INTO DECIMAL STRING             *
*          AND CONCATONATE TO THE STRING WE'RE BUILDING IN               *
*          A7.                                                           *
*                                                                        *
**************************************************************************
CAT_A0   MMTM    SP,A8
         MOVE    A0,A8                          ;CREDIT COUNT IN A8
         CALLA   HEXTOASC                       ;STRING
         CALLA   STRCAT                         ;NOW WE HAVE WHOLE NUMBER.
	MMFM    SP,A8
	RETS

**************************************************************************
*                                                                        *
*          ADD_PROMPT                                                    *
*                                                                        *
*          THIS IS CALLED ON THE CREDITS PAGE TO ADD A WORD OF           *
*          WISDOM BELOW THE CREDITS MESSAGE.  IT PICKS OUT THE           *
*          CORRECT MESSAGES AND BLINKS THEM.                             *
*                                                                        *
**************************************************************************
ADD_PROMPT
         MOVI    PROMPT_PROC,A7
         CALLA   P_FORK               ;START UP ANOTHER W/ SAME ID TO FLASH!
         RETP

PROMPT_PROC
         MOVI    ADJFREPL,A0
         CALLA   GET_ADJ
         JRNZ    RF2                  ;ALWAYS READY FOR 2 PLAYERS!

         CALLR   CRED_P
         JRZ     PP1

         MOVE    A0,A1                ;PUT CREDITS IN A1
         MOVI    ADJCSTRT,A0          ;GET AMOUNT NEEDED TO START.
         CALLA   GET_ADJ
         CMP     A0,A1                ;ARE THERE ENOUGH TO START?
         JRLO    PP1                  ;NOPE...."INSERT COIN"
*
*        WE HAVE ENOUGH TO START FOR 1....HOW ABOUT 2?
*
         SLL     1,A0                 ;THIS IS AMOUNT NEEDED FOR 2.
         CMP     A0,A1
         JRLO    PP2                  ;NOT ENOUGH.....PRINT 1.
*
*        >1 = READY FOR 2 PLAYERS.  PRESS START.
*
RF2      MOVI    MESS_READY_2,A1
         JRUC    RED_1

PP1      MOVI    MESS_INS_COIN,A0
         CLR     A1
         JRUC    RED_2

PP2      MOVI    MESS_READY_1,A1
RED_1    MOVI    MESS_PRESS_START,A0
RED_2    MOVE    A0,*A13(PDATA),L             ;HOLD MESSAGES
         MOVE    A1,*A13(PDATA+LONG_SIZE),L

BLINK_LOOP
         MOVE    *A13(PDATA),A8,L             ;FIRST MESSAGE
         JSRP    L_MESS
         MOVE    *A13(PDATA+LONG_SIZE),A8,L   ;2ND MESSAGE
         JRZ     BL1                          ;NOT HOME!

         JSRP    L_MESS

BL1      SLEEP   10H

         MOVE    *A13(PDATA),A8,L
         CALLR   LM_SETUP
         CLR     A6                             ;BLACK
         JSRP    LM_FINIS

**************************************************************************
*                                                                        *
*          MOVE    *A13(PDATA+LONG_SIZE),A8,L                            *
*          JRZ     BL2                                                   *
*          CALLR   LM_SETUP                                              *
*          CLR     A6                                                    *
*          JSRP    LM_FINIS                                             *
*                                                                        *
**************************************************************************

BL2      SLEEP   10H
         JRUC    BLINK_LOOP

**************************************************************************
*                                                                        *
* 	SOUND(S?)							 *
*                                                                        *
**************************************************************************
COINSND	.WORD	>F3FE,>10,>8085,0		;"COIN" SOUND

**************************************************************************
*                                                                        *
*          MESSAGE SECTION                                               *
*                                                                        *
**************************************************************************
ROM_NAME .STRING   "NARC REVISION 7.00-GNP"
         .BYTE     0
         .EVEN

FACTORY_TABLE
                 .LONG   0000H  ;ADJ_UNUSED       EQU     0
                 .LONG   0001H  ;ADJ_PRICING      EQU     1      ;MASTER PRICING
                 .LONG   0001H  ;ADJ_LEFT_MULT    EQU     2
                 .LONG   0004H  ;ADJ_CENTER_MULT  EQU     3
                 .LONG   0001H  ;ADJ_RIGHT_MULT   EQU     4
                 .LONG   0001H  ;ADJ_UNITS_CREDIT EQU     5
                 .LONG   0000H  ;ADJ_UNITS_BONUS  EQU     6
                 .LONG   0000H  ;ADJ_MIN_UNITS    EQU     7
                 .LONG   0004H  ;ADJCDIV          EQU     8       ;COINS PER DOLLAR 
                 .LONG   0001H  ;SHOW FRACTIONS           9
                 .LONG   0001H  ;ADJ_START_CRED   EQU     10      ;CREDITS REQUIRED TO START
                 .LONG   0001H  ;ADJ_CONT_CRED    EQU     11      ;CREDITS REQUIRED TO CONTINUE
                 .LONG   0003H  ;ADJ_DIFFICULTY   EQU     12
                 .LONG    5000  ;ADJ_HSRESET      EQU     13
                 .LONG   0003H  ;ADJ_LIVES        EQU     14
                 .LONG   0005H  ;ADJ_ROCKETS      EQU     15
                 .LONG  100000H  ;ADJ_EXTRA_MAN    EQU    16      ;SCORE STORED HERE
                 .LONG   0000H  ;ADJ_LAST_MAN     EQU     17      ;NO EXTRA MEN BEYOND THIS SCORE
                 .LONG   0000H  ;ADJ_AMODE_MUSIC  EQU     18
                 .LONG   0030   ;MAXIMUM CREDITS          19
*
*	G_FREE:	 REPLACE  ".LONG 0"   WITH  ".LONG 1"	
*		
*                     .LONG   0001H  ;FREE PLAY                20
                      .LONG   0000H  ;FREE PLAY                20
                 .LONG   0001H  ;NON-ZERO MEANS COIN BLOCK (1ST 8) UNTOUCHED 21
                 .LONG   0000H  ;ZERO MEANS NORMAL GORE ... 1 = SOFTEN IT  22
                 .LONG   0001H  ;NON-ZERO MEANS 1ST 6 UNTOUCHED.           23
                 .LONG   0000H  ;NON-ZERO MEANS NO COIN-SPECIFIC MESSAGE ON COIN PAGE  24
                 .LONG   0001H  ;non-zero means buy-in safes allowed without loop-around               25
                 .LONG   0000H  ; UNUSED                  26
                 .LONG   0000H  ; UNUSED                  27
                 .LONG   0000H  ; UNUSED                  28
                 .LONG   0000H  ; UNUSED                  29
                 .LONG   0000H  ; UNUSED                  30
*
*        A0 = SLEEP
*        A1 = ROUTINE
*        A6 = COLOR
*        A8 = STRING POINTER
*        A9 = SCREEN ADDRESS
*        A10 = SPACING
*        A11 = FONT
*        A14 = FLAGS
*

MESS_CREDITS
         .STRING   "CREDITS: "
         .BYTE     0
         .EVEN
*
*        NORMAL CREDITS SETUP STRING
*
MESS_CNUM
         MESS_MAC  RD20FONT,SPACING20,CP_CX,240,NARCS_LF,STRCNRM,0
*
*        "LOW" CREDITS SETUP STRING WHEN EXTRA ADVICE ON PRICING
*        IS BEING ADDED.
*
MESS_LOWNUM
         MESS_MAC  RD20FONT,SPACING20,CP_CX,118H,NARCS_LF,STRCNRM,0

MESS_FREEP
         .STRING   "FREE  PLAY"
         .BYTE     0
         .EVEN

MESS_READY_1
         MESS_MAC  RD15FONT,SPACING20,CP_CX,14BH,NARCS_YELLOW,STRCNRM,0
         .STRING   "READY FOR  1  PLAYER."
         .BYTE     0,0
         .EVEN

MESS_READY_2
         MESS_MAC  RD15FONT,SPACING20,CP_CX,14BH,NARCS_YELLOW,STRCNRM,0
         .STRING   "READY FOR  2  PLAYERS."
         .BYTE     0,0
         .EVEN

MESS_INS_COIN
         MESS_MAC  RD15FONT,SPACING20,CP_CX,335,NARCS_YELLOW,STRCNRM,0
         .STRING   "INSERT COIN."
         .BYTE     0,0
         .EVEN

MESS_PRESS_START
         MESS_MAC  RD15FONT,SPACING20,CP_CX,355,NARCS_YELLOW,STRCNRM,0
         .STRING   "PRESS START"
         .BYTE     0,0
         .EVEN

**************************************************************************
*                                                                        *
*          DUMPING SOFTWARE                                              *
*                                                                        *
**************************************************************************
DUMP_FS
         CALLR   DUMP_PAGE
         CLR     A0
         MOVI    DUMP_PTR,A7
         CALLA   WC_WORD              ;SET NUMBER OF DUMPS TO ZERO
         RETS

**************************************************************************
*                                                                        *
*          ADD_DUMP                                                      *
*                                                                        *
*          THIS IS CALLED TO RECORD A DUMP.  A0 THROUGH A8 ARE           *
*          RECORDED IN MEMORY.                                           *
*                                                                        *
**************************************************************************
DUMP_SIZE        EQU     9*C_LONG_SIZE     ;9 LONG WORDS.
DUMP_LAST        EQU     WPCMOS-DUMP_SIZE  ;ALLOW EM TO USE THE WHOLE PAGE!
MAX_DUMP         EQU     12                ;DON'T HOLD MORE THAN 12

ADD_DUMP MMTM    SP,B0,B1,B2
         MMTM    SP,A0,A1,A7
         CALLR   DUMP_PAGE            ;SET CMOS PAGE CORRECTLY.
         MOVE    A0,B0
         MOVE    A7,B2                ;SAVE THESE!
         MOVE    A1,B1

         MOVI    DUMP_PTR,A7
         CALLA   RC_WORD              ;GET THE INDICATOR OF HOW MANY.
         MOVI    DUMP_SIZE,A1
         MPYU    A0,A1                ;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

         ADDI    DUMP_DATA,A1         ;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
         CMPI    DUMP_LAST,A1         ;ARE WE TOO FAR FOR ANOTHER?
         JRHS    NO_DUMP              ;YEP....SKIP IT

         INC     A0                   ;1 MORE OUT THERE!
         CALLA   WC_WORD              ;CHALK IT!

         MOVE    A1,A7                ;THIS IS POINTER TO STORE DATA.
         MOVE    B0,A0                ;THIS IS A0
         CALLA   WC_LONGI
         MOVE    B1,A0                ;THIS IS A1
         CALLA   WC_LONGI
         MOVE    A2,A0                ;THIS IS A2
         CALLA   WC_LONGI
         MOVE    A3,A0                ;THIS IS A3
         CALLA   WC_LONGI
         MOVE    A4,A0                ;THIS IS A4
         CALLA   WC_LONGI
         MOVE    A5,A0                ;THIS IS A5
         CALLA   WC_LONGI
         MOVE    A6,A0                ;THIS IS A6
         CALLA   WC_LONGI
         MOVE    B2,A0                ;THIS IS A7
         CALLA   WC_LONGI
         MOVE    A8,A0                ;THIS IS A8
         CALLA   WC_LONGI
NO_DUMP 
	MMFM    SP,A0,A1,A7
	MMFM    SP,B0,B1,B2
	RETS

DUMP_PAGE
         MMTM    SP,A1
         MOVI    DUMP_SELECT,A1      ;THIS IS DUMP PAGE
         CALLA   SET_PAGE             ;SET IT PLEASE
	MMFM    SP,A1
	RETS

DISPDUMP
         CALLR   DUMP_PAGE
         MOVI    DUMP_PTR,A7
         CALLA   RC_WORD              ;GET THE INDICATOR OF HOW MANY.
         JRZ     NOTHIN_TO_DUMP
*
         CLR     A9                   ;THIS IS CURRENT ONE
         MOVE    A0,A8                ;THIS IS THE LAST ONE TO DO

DO_ANOTHER_DPAGE
         CALLA   CLR_SCRN             ;CLEAR SCREEN
         CALLR   DUMP_PAGE
         MOVI    20,A10               ;THIS IS Y COORDIANTE OF CURRENT ONE!
         MOVI    MAX_DUMP,A11         ;THIS IS MAX NUMBER PER PAGE.

DO_ANOTHER_DUMP
         JSRP    DO_DUMP
         ADDI    30,A10               ;KICK Y UP
         INC     A9                   ;KICK TO NEXT DUMP
         CMP     A8,A9                ;UNTIL THEY'RE ALL DONE!
         JRHS    DUMP_DONE            ;WE'RE NOT ALL DONE YET!

         DSJS    A11,DO_ANOTHER_DUMP  ;NOT FOR THIS PAGE EITHER!

         JSRP    WAIT_MUT             ;WATCH FOR STICKS!
         JRUC    DO_ANOTHER_DPAGE

SW_BUTS          EQU     0F0F0H
CN_BUTS          EQU     3500000H                    ;BOTH STARTS, ADV, COIN BUT.
BUTTONS          EQU     SW_BUTS+CN_BUTS

**************************************************************************
*                                                                        *
*          WAIT_MUT                                                      *
*                                                                        *
*          THIS IS LIKE "WAIT_BUT"....WAIT FOR ANY BUTTON EXCEPT         *
*          THAT IT WILL CLEAR OUT THE DUMPS IF BOTH STICKS ARE PUSHED    *
*          DOWN.                                                         *
*                                                                        *
**************************************************************************
WAIT_MUT
         CALLA   FORM_SWS        ;1ST STATE DOESN'T COUNT
*
*        RETURN CURRENT STATE IN A0..PREVIOUS STATE IN A1.
*
WB1      SLEEP   1

         CALLA   FORM_SWS
         MOVE    A0,A2               
         ANDI    202H,A2
         CMPI    202H,A2
         JRNZ    WB2                  ;NOT "CLEAR"

         SOUND1  COINSND
         CALLR   DUMP_FS              ;CLEAR OUT THE DUMPS!
	 CALLR	 CLR_DUMP_AUD
         JRUC    WB1

WB2      NOT     A1                   ;LAST = 0 AND NOW = 1 MEANS EDGE!

         AND     A1,A0                ;1'S WHERE WE HAVE POSITIVE EDGE.
         ANDI    BUTTONS,A0           ;IS IT A BUTTON? 
         JRZ     WB1
         SOUND1  BEEP_1                ;MAKE A BEEP
         RETP

BEEP_1   .WORD	>F3DF,>10,>80A2,0		;LOW BEEP 

DUMP_DONE
         RETP                         ;AND RETURN TO CALLER!

NOTHIN_TO_DUMP
         CALLA   CLR_SCRN             ;PRINT SOMEHTING PLEASE
         MOVI    MESS_NODUMP,A8
         JSRP    L_MESS
         RETP

**************************************************************************
*                                                                        *
*          DO_DUMP                                                       *
*                                                                        *
*          A9 = DUMP NUMBER TO DO                                        *
*          A10 = Y POSITION.                                             *
*                                                                        *
**************************************************************************
DO_DUMP  MMTM    A12,A8,A9,A10,A11

         MOVI    DUMP_SIZE,A7
         MPYU    A9,A7                ;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

         ADDI    DUMP_DATA,A7         ;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
*
*        Y IS IN A10
*
         MOVE    A10,A3               ;Y IN A3
         MOVI    20,A2                ;STORE X IN A2
         MOVI    9,A5                 ;NUMBER OF WORDS TO DUMP
NEXT_ELE
         CALLA   RC_LONGI             ;GET A WORD
         MOVE    A0,A4                ;HEX IN A4

         MOVE    A7,*A13(PDATA),L
         MOVE    A2,*A13(PDATA+LONG_SIZE),L
         MOVE    A3,*A13(PDATA+(2*LONG_SIZE)),L
         MOVE    A5,*A13(PDATA+(3*LONG_SIZE)),L

         JSRP    WRITE_HEX            ;WRITE IT OUT.....A0 = DATA
*                                                      A10 = Y
*                                                      A11 = X
         MOVE    *A13(PDATA),A7,L
         MOVE    *A13(PDATA+LONG_SIZE),A2,L
         MOVE    *A13(PDATA+(2*LONG_SIZE)),A3,L
         MOVE    *A13(PDATA+(3*LONG_SIZE)),A5,L

         ADDI    48H,A2

         CMPI    4,A5                 ;WHEN WE'RE DOWN TO 4 SKIP TO NEXT LINE
         JRNZ    NO_SKIP_NOW

         ADDI    12,A3                ;PUSH TO 2ND LINE
         MOVI    20,A2                ;RE-MARGIN OVER.

NO_SKIP_NOW
         DSJ     A5,NEXT_ELE

	MMFM    A12,A8,A9,A10,A11
         RETP

**************************************************************************
*                                                                        *
*          WRITE_HEX                                                     *
*                                                                        *
*          A4  = DATA                                                    *
*          A3  = Y                                                       *
*          A2  = X                                                       *
*                                                                        *
**************************************************************************
WRITE_HEX
         MOVI    MESS_DUMP,A8
         CALLR   LM_SETUP             ;SETUP FOR A DUMP!
         MOVE    A3,A9               ;MOVE Y DOWN
         SLL     16,A9                ;SHIFT Y INTO PLACE
         ADD     A2,A9               ;ADD IN X

         MOVE    A4,A8
         CLR     A3                   ;NO COMMAS!
         CALLR   HTOHXASC             ;CONVERT PLEASE!
         JSRP    LM_FINIS
         RETP

**************************************************************************
*                                                                        *
* HTOHXASC - CONVERTS A 32 BIT HEX # TO AN ASCII STRING TERMINATED	     *
* 	   BY 0								               *
* A8 = HEX #								               *
* RETURNS:								               *
* A8 PTR TO THE STRING							               *
* A3 = NON ZERO IF COMMAS ARE TO BE ADDED!                               *
*                                                                        *
**************************************************************************
HTOHXASC
	MMTM	SP,A1,A2,A9
	CLR	A1
	CLR	A2			;COMMA COUNT
	MOVE	A1,-*SP,W		;HERE'S THE NULL TERMINATOR
         MOVK	16,A1			;DIVISOR FOR HEX
	MOVE	A8,A9
HEXTASC2
	CLR	A8
	DIVU	A1,A8
	ADDI	'0',A9			;MAKE THE REMAINDER ASCII
         CMPI    '9',A9               ;IS IT IN A-F RANGE?
         JRLS    HHH1
         ADDI    7,A9                 ;MAKE ALPHA!
HHH1	MOVE	A9,-*SP,W		;SAVE HERE
	MOVE	A8,A9
	JRZ	HEXTASC3		;BR = DONE!
	INC	A2
	CMPI	3,A2			;COMMA CHECK 	
	JRLO	HEXTASC2		;BR = NO COMMA
*
*        SEE IF WE'RE DOING COMMAS
*
         MOVE    A3,A3                ;COMMAS?
         JRZ     HEXTASC2             ;NOPE....IGNORE!

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
*          STRCAT                                                        *
*                                                                        *
*          THIS IS CALLED TO CONCATONATE 2 STRINGS.                      *
*                                                                        *
*          A7 <--- <A7><A8>                                              *
*                                                                        *
*          THAT IS.......CONCATONATE A8 ONTO THE END OF A7.              *
*                                                                        *
**************************************************************************
STRCAT   MMTM    SP,A7,A0,A8
STRC2    MOVB    *A7,A0          ;WALK DOWN A7 TO ITS ZERO.
         JRZ     STRC1           ;WE'RE THERE!

         ADDI    BYTE_SIZE,A7    ;KICK TO NEXT BYTE
         JRUC    STRC2
*
*        NOW A7 POINTS AT ITS ZERO.
*
STRC1    MOVB    *A8,A0          ;GET A BYTE FROM 2ND STRING
         MOVB    A0,*A7          ;ADD THIS TO 1ST STRING
         ADDI    BYTE_SIZE,A7
         ADDI    BYTE_SIZE,A8
         MOVE    A0,A0           ;DID WE JUST MOVE TERMINATOR?
         JRNZ    STRC1           ;NOPE...MOVE ANOTHER

	MMFM    SP,A7,A0,A8
	RETS

MESS_DUMP
         MESS_MAC  RD7FONT,SPACING07,30,355,NARCS_WHITE,STRLNRM,0

MESS_NODUMP
         MESS_MAC  RD15FONT,SPACING20,256,200,NARCS_ORANGE,STRCNRM,0
         .STRING "NOTHING HERE....PRESS ADVANCE!"
         .BYTE   0,0
         .EVEN

MESS_SLASH .STRING "/"
           .BYTE 0
           .EVEN

MESS_2SPACE .STRING "  "
MESS_NULL   .BYTE 0
            .EVEN

SETUP_1_OF_3
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_13,NARCS_LASER,STRCNRM,0
SETUP_2_OF_3
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_23,NARCS_LASER,STRCNRM,0
SETUP_3_OF_3
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_33,NARCS_LASER,STRCNRM,0

SETUP_1_OF_2
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_12,NARCS_LASER,STRCNRM,0

SETUP_2_OF_2
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_22,NARCS_LASER,STRCNRM,0

SETUP_1_OF_1
         MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,NARCS_LASER,STRCNRM,0

CPYR_MES
         MESS_MAC  RD7FONT,SPACING07,CP_CX,182H,NARCS_GREY,STRCNRM,0
         .BYTE   ASCII_DQ
         .STRING "NARC"  
         .BYTE   ASCII_DQ
         .STRING " COPYRIGHT 1988 WILLIAMS ELECTRONICS GAMES INC."
         .BYTE 0,0
         .EVEN

         .END
