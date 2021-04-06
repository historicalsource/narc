;*  defines for routines in narcutil, and the shit I use in my enemies..

	.GLOBL	MovePlyr,ZCHEK
	.GLOBL	SetAniP
	.GLOBL	PUT1K,PUT2x5K,PUT5K,PUT10K,PUT25K,PUTBONUS
	.GLOBL	SumSlp,SyncAnim
	.GLOBL	ShadOn,ShadOff
	.GLOBL	GetPLZMID,CentDist
	.GLOBL	DFrmGrnd
	.GLOBL	GetPData,OidToDat,BulToDat
	.GLOBL	GetMidZ
	.GLOBL	dynamite,SHYPO,NHYPO
	.GLOBL	ZOFF
	.GLOBL	NEAR_BUL,NEARPLYR
	.GLOBL	FACINGOB
	.GLOBL	FACEOBJ,FaceObj,FACEAWAY,FACEBULL,FACEFWD,FACEBKWD
	.GLOBL	MAX,MIN
	.GLOBL	ABSMAX
	.GLOBL	ABSINC,ABSDEC,ABSADD,ABSSUB
	.GLOBL	XTOZSIZE
	.GLOBL	ClrVel,UpdShadV
	.GLOBL	NEAR_BTY,NEAR_OBJ
	.GLOBL	ON_SLIST
	.GLOBL	CLROBJ
	.GLOBL	BullSlp
	.GLOBL	SPLATBOX,SPLATANI,SPLATS
	.GLOBL	SPLTCOLANI,SPLTCOLBOX

	.GLOBL	ClosestFP
	.GLOBL	HuntObj,HuntObj0,FleeObj,ClosestP,Flee
	.GLOBL	ClipDest,ClipZDst,SCRNZCLP,SCRNCLIP
	.GLOBL	DestOk,GoDestD,GoDestV,CkDest,ShortXDest
	.GLOBL	GetOnScr
	.GLOBL	T_YFLP,T_NOYFLP,Ck_YFLP,Ck_NOYFLP


ANIMPTR		.set	EYXVEL		;everyone
FUNCS		.set	ESWTCH		;everyone
COLLOBJ		.set	EOBJ

BOSS	.set	ETEMP1		;GANG
EBYTES	.set	ETEMP1
FLYING	.set	ETEMP1		;BUG
FIRETIKS .set	ETEMP1		;HYPO-word, MBIG  - byte
CANFIRE	.set	ETEMP1		;RAMBO
HIDING	.set	ETEMP1	 	;PIMP - byte
GOOSECNT .set	ETEMP1		;hook
GOOSETIK .set	ETEMP1+8	;hook
FLIRTING .set	ETEMP1+16	;hook word

;* offsets into function tables
GODEST		.set	>20
GETXVEL		.set	>40
MAXXZANGLE	.set	>60
FLIPCT		.set	>80

TIKCTRS		.set	ETEMP2
ANIMTIKS	.set	ETEMP2	 	;everyone
DESTTIKS	.set	ETEMP2+8 	;everyone
BRAINTIKS	.set	ETEMP2+16	;PIMP, HYPO, HOOK, BUG, MBIG
ACTION		.set	ETEMP2+16	;GANG, BOSS - Checkk .sets in narcgang
BUSTTIKS	.set	ETEMP2+24	;PIMP, HYPO, GANG, BUG, MBIG
FLIRTTIKS	.set	ETEMP2+24	;Hooker

DEST_TAG	.set	ETEMP3		;everyone
ZPER		.set	ETEMP3+8	;HOOK
;DIR 		.set	ZPER		;RAMBO
GNUM		.set	ETEMP3+8	;GANG
SNOOZE		.set	ETEMP3+16	;everyone
FLIPTIKS 	.set	ETEMP3+24	;everyuone
DEST		.set	ETEMP4		;PIMP, HYPO, HOOK, GANG, BUG, MBIG
TEMPDEST	.set	ETEMP5		;PIMP, HYPO, HOOK, GANG, BUG, MBIG
WANTOBJ		.set	ETEMP6		;PIMP, HYPO, GANG


;* CONSTANTS
FUSETIKS	.set	10	 ;was 8
;* Dynamite OFFSETS into process block.
rot	.set	ESWTCH
fanimct	.set	ESWTCH+8
fuselen	.set	ESWTCH+16
rotdir	.set	ESWTCH+24

;* Destination tags
BULL_T	.set	20
BUST_T	.set	15
OFFSCR_T .set	10
ESCAPE_T .set	6

;* hypo
FIRE_T	.set	25
CHARGE_T .set	15
DRUG_T	.set	12
KILL_T	.set	1

;* hooker
LEAN_T	.set	2
DFLT_T	.set	1

;* pimp
CHASE_T	.set	5
BUCK_T	.set	4
HIDE_T	.set	3
H_CASH_T .set	2

;* gang
;BULL_T	.set	20
;BUST_T	.set	15
ROCK_T	.set	5
CLIP_T	.set	5
BOSS_T	.set	3
