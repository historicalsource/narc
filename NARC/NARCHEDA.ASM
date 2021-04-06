 	.FILE	'NARCHEDA.ASM'
	.TITLE	"<<< N  A  R  C  --  HEADMAN  Animations >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\mprocEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"NARCTEQU.ASM"
	.include	"imgtbl.glo"
	.include	"narcHEAD.tbl"
	.include	"narcxtra.glo"

	.GLOBL	MkNuke
	.GLOBL	InitTbls,DIRANI
	.GLOBL	BONEINI,CHUNKINI,CHNKTINI,SpineIni
	.GLOBL	BRECOIL,BRECOILF,TUNGFLEX,TUNGFLXF,RRECOIL,RRECOILF,RRECOIL
	.GLOBL	KABOOM,KABOOMF,BOOM5a,BOOM5b,BOOM5c,BOOM6
	.GLOBL	CHNKTBL1,CHNKTBL2,CHNKTBL3,CHNKTBL4,CHNKTBL5
	.GLOBL	HED3hat,skull4,jaw4,stump,stumpskl,BASEskl

	.GLOBL	HEADCOLL,BASECOLL,TUNGCOLL,SPNECOLL
	.GLOBL	SDIRANI
	.GLOBL	baseflsh
	.GLOBL	jawbite,jawbitef,FLYSPINE,FLYSKULL,BlowSkul

FTungSND	.WORD	>F005,>10,>804e,0 ;fire tung
TungHSND	.WORD	>F005,>15,>8015,0 ;tung hits player

HEADZSIZ	.set	>00230000	;use Z plus only
BASEZMIN	.set	5
BASEZPOS	.set	>28
BASEZSIZ	.set	BASEZPOS*ZP+BASEZMIN
TUNGZSIZ	.set	>00120012

**************************************************************************
InitTbls:
	.long	BASELini,BASERini,FACEini,HATini,NECKini,GLASini,TUNGini,0

*	.LONG	OXVEL,OYVEL,OXVAL,XYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
BASELini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	BASElh2e,BASEZSIZ,BASECOLL
;	.WORD	DMAWNZ,HEADEOID|0
	.WORD	DMAWNZ,BEOID|BASEID
	.LONG	HEADBLIP
BASERini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	BASElh2e,BASEZSIZ,BASECOLL
;	.WORD	DMAWNZ,HEADEOID|1
	.WORD	DMAWNZ,BEOID|BASEID
	.LONG	0
FACEini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	HED3mou1,HEADZSIZ,HEADCOLL
	.WORD	DMAWNZ,HEADEOID|2
	.LONG	0
HATini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	HED3hat,HEADZSIZ,HEADCOLL
	.WORD	DMAWNZ,HEADEOID|3
	.LONG	0
NECKini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	HED3neck,HEADZSIZ,HEADCOLL
	.WORD	DMAWNZ,HEADEOID|4
	.LONG	0
GLASini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	GLAS3,HEADZSIZ,HEADCOLL
	.WORD	DMAWNZ,HEADEOID|5
	.LONG	0
TUNGini
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	TUNG0,TUNGZSIZ,TUNGCOLL
	.WORD	DMAWNZ,HEADEOID|6
	.LONG	0


SpineIni:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	spine,>50005,SPNECOLL
	.WORD	DMAWNZ,HEADEOID|7
	.LONG	0


**************************************************************************
CHNKTBL1:
	.long	CHUNKA,CHUNKB,CHUNKC,CHUNKD
	.long	CHUNKA,CHUNKB,CHUNKC,CHUNKD
	.long	CHUNKAR,CHUNKBR,CHUNKCR,CHUNKDR
	.long	CHUNKAR,CHUNKBR,CHUNKCR,CHUNKDR
	.long	CHUNKE,CHUNKF,CHUNKH
	.long	CHUNKE,CHUNKF,CHUNKH
	.long	0
CHNKTBL2:
	.long	CHUNKT1,CHUNKT1,CHUNKT2,CHUNKT2,CHUNKT3,CHUNKT3
	.long	CHUNKT4,CHUNKT4,CHUNKT5,CHUNKT5,CHUNKT6,CHUNKT6
	.long	0
CHNKTBL3:
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKA,CHUNKB,CHUNKD
	.long	CHUNKA,CHUNKB,CHUNKD
	.long	CHUNKAR,CHUNKBR,CHUNKDR
	.long	CHUNKAR,CHUNKBR,CHUNKDR
	.long	0
CHNKTBL4:
	.long	CHUNKE,CHUNKF,CHUNKG,CHUNKH
	.long	CHUNKAR,CHUNKB,CHUNKDR
	.long	0
CHNKTBL5:
	.long	CHUNKB,CHUNKD
	.long	CHUNKAR,CHUNKCR,CHUNKDR
	.long	CHUNKE,CHUNKF
	.long	0
**************************************************************************

**************************************************************************
hed90ft0:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG0
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft1:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG1
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft2:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG2
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft3:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG3
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft4:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG4
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft5:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG5
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft6:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG6
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft7:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG7
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft8:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG8
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90ft9:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG9
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN

hed90t0:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG0
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t1:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG1
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t2:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG2
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t3:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG3
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t4:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG4
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t5:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG5
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t6:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG6
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t7:
	.LONG	BASElh2e,BASElh2e,HED3mou2,HED3hat,HED3neck,GLAS3,TUNG7
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t8:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG8
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90t9:
	.LONG	BASElh2e,BASElh2e,HED3mou3,HED3hat,HED3neck,GLAS3,TUNG9
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN


hed120:
	.LONG	BASElh2e,BASElh2e,HEAD4,0,0,GLAS4,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed120f:
	.LONG	BASElh2e,BASElh2e,HEAD4,0,0,GLAS4,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed60:
	.LONG	BASElh2e,BASElh2e,HEAD2,0,0,GLAS2,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed60f:
	.LONG	BASElh2e,BASElh2e,HEAD2,0,0,GLAS2,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed30:
	.LONG	BASElh2e,BASElh2e,HEAD1,0,0,GLAS1,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed30f:
	.LONG	BASElh2e,BASElh2e,HEAD1,0,0,GLAS1,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed0:
	.LONG	BASElh2e,BASElh2e,HEAD0,0,0,GLAS0,0
	.BYTE	       0,      	0,    2,0,1,	3, 1 ;Zoff
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN


recoil:
	.LONG	BASElh2e,BASElh2e,HEAD3r,0,0,GLAS3r2,0
	.BYTE	       0,      	0,     2,0,1,	  3,1	 ;Z off
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
recoilf:
	.LONG	BASElh2e,BASElh2e,HEAD3r,0,0,GLAS3r2,0
	.BYTE	       0,      	0,     2,0,1,	  3,1	 ;Z off
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN


hedblow0:
	.LONG	BASElh2e,BASElh2e,0,0,0,0,0
	.BYTE	       0,      	0,     1,     2,     3,    2,    1 ;Z off
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
hedblow1:
	.LONG	BASElh2e,BASElh2e,stump,skull4H,jaw4H,0,0
	.BYTE	       0,      	0,    1,     2,     3,    2,    1 ;Z off
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts

hedblo0f:
	.LONG	BASElh2e,BASElh2e,0,0,0,0,0
	.BYTE	       0,      	0,     1,     2,     3,    2,    1 ;Z off
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
hedblo1f:
	.LONG	BASElh2e,BASElh2e,stump,skull4H,jaw4H,0,0
	.BYTE	       0,      	0,    1,     2,     3,    2,    1 ;Z off
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts

hed90f:
	.LONG	BASElh2e,BASElh2e,HED3mou1,HED3hat,HED3neck,GLAS3,0
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>40 ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN
hed90:
	.LONG	BASElh2e,BASElh2e,HED3mou1,HED3hat,HED3neck,GLAS3,0
	.BYTE	       0,      	0,	 2,	 0,	  1,	3,1 ;ZOFF
	.BYTE	>BF ;flip bits - top 6 bits correspond to first 6 parts
	.EVEN


DIRANI:
	.LONG	HED120F
	.LONG	HED90F
	.LONG	HED60F
	.LONG	HED30F
	.LONG	HED0
	.LONG	HED30
	.LONG	HED60
	.LONG	HED90
	.LONG	HED120
;*** THESE ARE USED WHEN TALKING
	.LONG	HED120F
	.LONG	HEDTALKF
	.LONG	HED60F
	.LONG	HED30F
	.LONG	HED0
	.LONG	HED30
	.LONG	HED60
	.LONG	HEDTALK
	.LONG	HED120
;*** THESE ARE USED WHEN Laughing
	.LONG	HED120F
	.LONG	HEDLAFFF
	.LONG	HED60F
	.LONG	HED30F
	.LONG	HED0
	.LONG	HED30
	.LONG	HED60
	.LONG	HEDLAFF
	.LONG	HED120

HED120F:
	.long	hed120f
	.word	6
	.long	0
HED90F:
	.long	hed90f
	.word	6
	.long	0
HEDTALKF:
HEDLAFFF:
	.long	hed90ft0
	.word	7
	.long	hed90ft1
	.word	10
	.long	hed90ft0
	.word	5
	.long	hed90ft1
	.word	7
	.long	0

HED60F:
	.long	hed60f
	.word	6
	.long	0
HED30F:
	.long	hed30f
	.word	6
	.long	0
HED120:
	.long	hed120
	.word	6
	.long	0
HED90:
	.long	hed90
	.word	6
	.long	0
HEDTALK:
HEDLAFF:
	.long	hed90t0
	.word	7
	.long	hed90t1
	.word	10
	.long	hed90t0
	.word	5
	.long	hed90t1
	.word	7
	.long	0
HED60:
	.long	hed60
	.word	6
	.long	0
HED30:
	.long	hed30
	.word	6
	.long	0
HED0:
	.long	hed0
	.word	6
	.long	0


TUNGFLEX:
	.long	hed60
	.word	4
	.long	hed30
	.word	4
	.long	hed0
	.word	4
	.long	hed30f
	.word	4
	.long	hed60f
	.word	4
	.long	hed90ft0
	.word	2
	.long	hed90ft1
	.word	2
	.long	hed90ft2
	.word	2
	.long	hed90ft3
	.word	2
	.long	hed90ft4
	.word	2
	.long	hed90ft5
	.word	2
	.long	hed90ft6
	.word	2
	.long	hed90ft7
	.word	2
	.long	hed90ft8
	.word	2
	.long	hed90ft9
	.word	2
	.long	hed90ft8
	.word	2
	.long	hed90ft7
	.word	2
	.long	hed90ft6
	.word	2
	.long	hed90ft5
	.word	2
	.long	hed90ft4
	.word	2
	.long	hed90ft3
	.word	2
	.long	hed90ft2
	.word	2
	.long	hed90ft3
	.word	2
	.long	hed90ft4
	.word	2
	.long	hed90ft5
	.word	2
	.long	hed90ft6
	.word	2
	.long	hed90ft7
	.word	2
	.long	hed90ft8
	.word	2
	.long	hed90ft9
	.word	2
	.long	hed90ft8
	.word	2
	.long	hed90ft7
	.word	2
	.long	hed90ft6
	.word	2
	.long	hed90ft5
	.word	2
	.long	hed90ft4
	.word	2
	.long	hed90ft3
	.word	2
	.long	hed90ft2
	.word	2
	.long	hed90ft1
	.word	2
	.long	hed90ft0
	.word	2
	.long	hed60f
	.word	4
	.long	hed30f
	.word	4
	.long	hed0
	.word	4
	.long	hed30
	.word	4
	.long	hed60
	.word	4
	LONGNULL
TUNGFLXF:
	.long	hed60f
	.word	4
	.long	hed30f
	.word	4
	.long	hed0
	.word	4
	.long	hed30
	.word	4
	.long	hed60
	.word	4
	.long	hed90t0
	.word	2
	.long	hed90t1
	.word	2
	.long	hed90t2
	.word	2
	.long	hed90t3
	.word	2
	.long	hed90t4
	.word	2
	.long	hed90t5
	.word	2
	.long	hed90t6
	.word	2
	.long	hed90t7
	.word	2
	.long	hed90t8
	.word	2
	.long	hed90t9
	.word	2
	.long	hed90t8
	.word	2
	.long	hed90t7
	.word	2
	.long	hed90t6
	.word	2
	.long	hed90t5
	.word	2
	.long	hed90t4
	.word	2
	.long	hed90t3
	.word	2
	.long	hed90t2
	.word	2
	.long	hed90t3
	.word	2
	.long	hed90t4
	.word	2
	.long	hed90t5
	.word	2
	.long	hed90t6
	.word	2
	.long	hed90t7
	.word	2
	.long	hed90t8
	.word	2
	.long	hed90t9
	.word	2
	.long	hed90t8
	.word	2
	.long	hed90t7
	.word	2
	.long	hed90t6
	.word	2
	.long	hed90t5
	.word	2
	.long	hed90t4
	.word	2
	.long	hed90t3
	.word	2
	.long	hed90t2
	.word	2
	.long	hed90t1
	.word	2
	.long	hed90t0
	.word	2
	.long	hed60
	.word	4
	.long	hed30
	.word	4
	.long	hed0
	.word	4
	.long	hed30f
	.word	4
	.long	hed60f
	.word	4
	LONGNULL


BRECOIL:
	.long	recoil
	.word	4
	LONGNULL
BRECOILF:
	.long	recoilf
	.word	4
	LONGNULL
RRECOIL:
	.long	recoil
	.word	15
	LONGNULL
RRECOILF:
	.long	recoilf
	.word	15
	LONGNULL


KABOOM:
	.long	hedblow0
	.word	1
	.long	hedblow1
	.word	1
	LONGNULL
KABOOMF:
	.long	hedblo0f
	.word	1
	.long	hedblo1f
	.word	1
	LONGNULL




************************************************************
*** CHUNKERS
************************************************************
CHUNKINI:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	meat2a,0,DUMCOLL
	.WORD	DMAWNZ,HEADEOID|>C
	.LONG	0
CHNKTINI:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	TUNG0C,0,DUMCOLL
	.WORD	DMAWNZ,HEADEOID|>C
	.LONG	0
BONEINI:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	bonea0,0,DUMCOLL
	.WORD	DMAWNZ,HEADEOID|>C
	.LONG	0

FLYSPINE:
	.long	spine
	.word	NEWPALET|1
	.LONG	skelpal
	.long	0
	.long	spine
	.word	1
	.long	spine
	.word	1
FLYSKULL:
	.long	skcarc
	.word	1
	.long	0
	.long	skcarc
	.word	1
	.long	skcarc
	.word	1


CHUNKA:
	.long	meat2a
	.word	1
	.long	meat2b
	.word	1
	.long	meat2c
	.word	1
	.long	meat2d
	.word	1
	.long	meat2e
	.word	1
	.long	meat2f
	.word	1
	.long	meat2g
	.word	1
	.long	meat2h
	.word	1
	.long	meat2i
	.word	1
	.long	0
	.long	meat2j
	.word	1
	.long	meat2i
	.word	FLIPBITS|1,M_FLIPV
	

CHUNKAR:
	.long	meat2i
	.word	1
	.long	meat2h
	.word	1
	.long	meat2g
	.word	1
	.long	meat2f
	.word	1
	.long	meat2e
	.word	1
	.long	meat2d
	.word	1
	.long	meat2c
	.word	1
	.long	meat2b
	.word	1
	.long	meat2a
	.word	1
	.long	0
	.long	meat2j
	.word	1
	.long	meat2i
	.word	FLIPBITS|1,M_FLIPV

CHUNKB:
	.long	meat8a
	.word	1
	.long	meat8b
	.word	1
	.long	meat8c
	.word	1
	.long	meat8d
	.word	1
	.long	meat8e
	.word	1
	.long	meat8f
	.word	1
	.long	meat8g
	.word	1
	.long	meat8h
	.word	1
	.long	meat8i
	.word	1
	.long	0
	.long	meat8j
	.word	1
	.long	meat8e
	.word	1
CHUNKBR:
	.long	meat8i
	.word	1
	.long	meat8h
	.word	1
	.long	meat8g
	.word	1
	.long	meat8f
	.word	1
	.long	meat8e
	.word	1
	.long	meat8d
	.word	1
	.long	meat8c
	.word	1
	.long	meat8b
	.word	1
	.long	meat8a
	.word	1
	.long	0
	.long	meat8j
	.word	1
	.long	meat8e
	.word	1

CHUNKC:
	.long	meat11a
	.word	1
	.long	meat11b
	.word	1
	.long	meat11c
	.word	1
	.long	meat11d
	.word	1
	.long	meat11e
	.word	1
	.long	meat11f
	.word	1
	.long	meat11g
	.word	1
	.long	0
	.long	meat11h
	.word	1
	.long	meat11f
	.word	FLIPBITS|1,0
CHUNKCR:
	.long	meat11g
	.word	1
	.long	meat11f
	.word	1
	.long	meat11e
	.word	1
	.long	meat11d
	.word	1
	.long	meat11c
	.word	1
	.long	meat11b
	.word	1
	.long	meat11a
	.word	1
	.long	0
	.long	meat11h
	.word	1
	.long	meat11f
	.word	FLIPBITS|1,0

CHUNKD:
	.long	meat12a
	.word	1
	.long	meat12b
	.word	1
	.long	meat12c
	.word	1
	.long	meat12d
	.word	1
	.long	meat12e
	.word	1
	.long	meat12f
	.word	1
	.long	meat12g
	.word	1
	.long	meat12h
	.word	1
	.long	0
	.long	meat12i
	.word	1
	.long	meat12a
	.word	1
CHUNKDR:
	.long	meat12h
	.word	1
	.long	meat12g
	.word	1
	.long	meat12f
	.word	1
	.long	meat12e
	.word	1
	.long	meat12d
	.word	1
	.long	meat12c
	.word	1
	.long	meat12b
	.word	1
	.long	meat12a
	.word	1
	.long	0
	.long	meat12i
	.word	1
	.long	meat12a
	.word	1


CHUNKE:
	.long	bonea0
	.word	FLIPBITS|1,0
	.long	bonea30
	.word	FLIPBITS|1,0
	.long	bonea60
	.word	FLIPBITS|1,0
	.long	bonea90
	.word	FLIPBITS|1,M_FLIPV
	.long	bonea60
	.word	FLIPBITS|1,M_FLIPV
	.long	bonea30
	.word	FLIPBITS|1,M_FLIPV
	.long	bonea0
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonea30
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonea60
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonea90
	.word	FLIPBITS|1,M_FLIPH
	.long	bonea60
	.word	FLIPBITS|1,M_FLIPH
	.long	bonea30
	.word	FLIPBITS|1,M_FLIPH
	.long	0
	.long	meat11h
	.word	1
	.long	bonea30
	.word	FLIPBITS|1,0

CHUNKF:
	.long	boneb30
	.word	FLIPBITS|1,M_FLIPH
	.long	boneb60
	.word	FLIPBITS|1,M_FLIPH
	.long	boneb90
	.word	FLIPBITS|1,M_FLIPH
	.long	boneb60
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boneb30
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boneb0
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boneb30
	.word	FLIPBITS|1,M_FLIPV
	.long	boneb60
	.word	FLIPBITS|1,M_FLIPV
	.long	boneb90
	.word	FLIPBITS|1,M_FLIPV
	.long	boneb60
	.word	FLIPBITS|1,0
	.long	boneb30
	.word	FLIPBITS|1,0
	.long	boneb0
	.word	FLIPBITS|1,0
	.long	0
	.long	meat11h
	.word	1
	.long	boneb90
	.word	FLIPBITS|1,0

CHUNKG:
	.long	bonec0
	.word	FLIPBITS|1,0
	.long	bonec30
	.word	FLIPBITS|1,0
	.long	bonec60
	.word	FLIPBITS|1,0
	.long	bonec90
	.word	FLIPBITS|1,M_FLIPV
	.long	bonec60
	.word	FLIPBITS|1,M_FLIPV
	.long	bonec30
	.word	FLIPBITS|1,M_FLIPV
	.long	bonec0
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonec30
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonec60
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	bonec90
	.word	FLIPBITS|1,M_FLIPH
	.long	bonec60
	.word	FLIPBITS|1,M_FLIPH
	.long	bonec30
	.word	FLIPBITS|1,M_FLIPH
	.long	0
	.long	meat12h
	.word	1
	.long	bonec0
	.word	FLIPBITS|1,0

CHUNKH:
	.long	boned0
	.word	FLIPBITS|1,0
	.long	boned30
	.word	FLIPBITS|1,0
	.long	boned60
	.word	FLIPBITS|1,0
	.long	boned90
	.word	FLIPBITS|1,M_FLIPV
	.long	boned60
	.word	FLIPBITS|1,M_FLIPV
	.long	boned30
	.word	FLIPBITS|1,M_FLIPV
	.long	boned0
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boned30
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boned60
	.word	FLIPBITS|1,(M_FLIPH+M_FLIPV)
	.long	boned90
	.word	FLIPBITS|1,M_FLIPH
	.long	boned60
	.word	FLIPBITS|1,M_FLIPH
	.long	boned30
	.word	FLIPBITS|1,M_FLIPH
	.long	0
	.long	meat2h
	.word	1
	.long	boned0
	.word	FLIPBITS|1,M_FLIPV

CHUNKT1:
	.long	TUNG2C
	.word	1
	.long	TUNG3C
	.word	1
	.long	TUNG4C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG9C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG4C
	.word	1
	.long	TUNG3C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

CHUNKT2:
	.long	TUNG4C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG9C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG5C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

CHUNKT3:
	.long	TUNG3C
	.word	1
	.long	TUNG4C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG4C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

CHUNKT4:
	.long	TUNG3C
	.word	1
	.long	TUNG4C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG4C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

CHUNKT5:
	.long	TUNG3C
	.word	1
	.long	TUNG4C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG9C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG5C
	.word	1
	.long	TUNG4C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

CHUNKT6:
	.long	TUNG5C
	.word	1
	.long	TUNG6C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG9C
	.word	1
	.long	TUNG8C
	.word	1
	.long	TUNG7C
	.word	1
	.long	TUNG6C
	.word	1
	.long	0
	.long	TUNG6C
	.word	1

BlowSkul:
	.long	blowskul
	.word	1
	.long	0
blowskul:
	.LONG	skcarc,spine,spine,spine
	.BYTE	0,     0,    0,	   0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skull0:
	.LONG	skull1,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull0f:
	.LONG	skull1,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull30:
	.LONG	skull2,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull30f:
	.LONG	skull2,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull60:
	.LONG	skull3,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull60f:
	.LONG	skull3,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skull90up:
	.LONG	tiltup,0,0
	.BYTE	0,     0,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90dn:
	.LONG	tiltdn,0,0
	.BYTE	0,     0,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90upf:
	.LONG	tiltup,0,0
	.BYTE	0,     0,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90dnf:
	.LONG	tiltdn,0,0
	.BYTE	0,     0,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skull90a:
	.LONG	skull4,jaw1,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90b:
	.LONG	skull4,jaw2,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
jawbite:
	.LONG	skull4,jaw2,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90c:
	.LONG	skull4,jaw3,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90d:
	.LONG	skull4,jaw4,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skull90af:
	.LONG	skull4,jaw1,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90bf:
	.LONG	skull4,jaw2,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
jawbitef:
	.LONG	skull4,jaw2,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90cf:
	.LONG	skull4,jaw3,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull90df:
	.LONG	skull4,jaw4,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skult90a:
	.LONG	skull4,jaw1,0
	.BYTE	0,     3,  -1
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90b:
	.LONG	skull4,jaw2,TUNG0SF
	.BYTE	0,     3, -1
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90c:
	.LONG	skull4,jaw3,TUNG1SF
	.BYTE	0,     3,   -1
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90d:
	.LONG	skull4,jaw4,TUNG2SF
	.BYTE	0,     3,  -1
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even

skult90af:
	.LONG	skull4,jaw1,0
	.BYTE	0,     3,   -1
	.BYTE	>9C ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90bf:
	.LONG	skull4,jaw2,TUNG0SF
	.BYTE	0,     3,   -1
	.BYTE	>9C ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90cf:
	.LONG	skull4,jaw3,TUNG1SF
	.BYTE	0,     3,   -1
	.BYTE	>9C ;flip bits - top 6 bits correspond to first 6 parts
	.even
skult90df:
	.LONG	skull4,jaw4,TUNG2SF
	.BYTE	0,     3,   -1
	.BYTE	>9C ;flip bits - top 6 bits correspond to first 6 parts
	.even

skull120:
	.LONG	skull5,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull120f:
	.LONG	skull5,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull150:
	.LONG	skull6,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull150f:
	.LONG	skull6,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull180:
	.LONG	skull7,0,0
	.BYTE	0,     3,0
	.BYTE	>80 ;flip bits - top 6 bits correspond to first 6 parts
	.even
skull180f:
	.LONG	skull7,0,0
	.BYTE	0,     3,0
	.BYTE	>98 ;flip bits - top 6 bits correspond to first 6 parts
	.even


SKULL0:
	.long	skull0
	.word	5
	.long	0
SKULL30:
	.long	skull30
	.word	5
	.long	0
SKULL60:
	.long	skull60
	.word	5
	.long	0
SKULL90:
	.long	skull90b
	.word	5
	.long	0
SKULL120:
	.long	skull120
	.word	5
	.long	0
SKULL150:
	.long	skull150
	.word	5
	.long	0
SKULL180:
	.long	skull180
	.word	5
	.long	0

SKULL0F:
	.long	skull0f
	.word	5
	.long	0
SKULL30F:
	.long	skull30f
	.word	5
	.long	0
SKULL60F:
	.long	skull60f
	.word	5
	.long	0
SKULL90F:
	.long	skull90bf
	.word	5
	.long	0
SKULL120F:
	.long	skull120f
	.word	5
	.long	0
SKULL150F:
	.long	skull150f
	.word	5
	.long	0
SKULL180F:
	.long	skull180f
	.word	5
	.long	0

SKULL90UF:
	.long	skull90upf
	.word	5
	.long	0
SKULL90U:
	.long	skull90up
	.word	5
	.long	0
SKULL90DF:
	.long	skull90dnf
	.word	5
	.long	0
SKULL90D:
	.long	skull90dn
	.word	5
	.long	0

SKLBITE:
	.long	skull90c
	.word	2
	.long	skull90d
	.word	10
	.long	skull90c
	.word	2
	.long	jawbite
	.word	2
	.long	skull90a
	.word	8
	.long	skull90b
	.word	2
	.long	0
SKLBITEF:
	.long	skull90cf
	.word	2
	.long	skull90df
	.word	10
	.long	skull90cf
	.word	2
	.long	jawbitef
	.word	2
	.long	skull90af
	.word	8
	.long	skull90bf
	.word	2
	.long	0

SKLTUNG:
	.long	skult90a
	.word	7
	.long	skult90b
	.word	5
	.long	skult90c
	.word	5
	.long	skult90d
	.word	10
	.long	skult90c
	.word	5
	.long	skult90b
	.word	5
	.long	0
SKLTUNGF:
	.long	skult90af
	.word	7
	.long	skult90bf
	.word	5
	.long	skult90cf
	.word	5
	.long	skult90df
	.word	10
	.long	skult90cf
	.word	5
	.long	skult90bf
	.word	5
	.long	0


SDIRANI:
	.LONG	SKULL0
	.LONG	SKULL30
	.LONG	SKULL60
	.LONG	SKULL90
	.LONG	SKULL120
	.LONG	SKULL150
	.LONG	SKULL180
	.LONG	SKULL150F
	.LONG	SKULL120F
	.LONG	SKULL90F
	.LONG	SKULL60F
	.LONG	SKULL30F
;* the rest of this table is a kluge to access the tiltup,tiltdn frames
	.LONG	SKULL90U	;UP = dir + 9
	.LONG	SKULL90D	;DN = dir +10
	.LONG	SKLBITE		;BITE = dir + 11
	.LONG	SKLTUNG		;TUNG = dir + 12
	.LONG	0
	.LONG	0
	.LONG	SKULL90UF
	.LONG	SKULL90DF
	.LONG	SKLBITEF
	.LONG	SKLTUNGF



****************************************************************************
************************** START OF TONGUE STUFF ***************************
****************************************************************************
	.GLOBAL	FIRETUNG
	.GLOBAL	ZCHK,XZCNTCK
	.GLOBAL	HEADBUTT
 	.GLOBAL	SWAPAL0
*
*TONGUE STARTER PROCESS
*A8=OBJECT TO COPY
*A11=PLAYER TO GO FOR
*A10 - 1 if tung needs to be flipped.
FIRETUNG:
	MMTM	SP,A8,A10,A11
	movi	FTungSND,A0
	calla	ONESND
	MOVI	TNGTAB,A6
	MOVI	TNGINIT,A14	
	MOVE	*A8(OXPOS),A1,W
	MOVE	*A8(OYVAL),A2,L
	MOVY	A2,A1
	CALLA	ENINITUL	
	MMFM	SP,A9,A10,A11
	JAEQ	SUCIDE		
	MOVE	*A9(OZPOS),*A8(OZPOS),W
	MOVE	*A9(OFLAGS),A9,W	;SAVE FLIP
	move	A10,A10
	jrz	SkHFlp
	xori	M_FLIPH,A9
SkHFlp:

	MOVI	>2000,A0
	CALLA	RANDU
	ADDI	>2000,A0
	MOVE	A0,A10		;SAVE Z ACCEL FACTOR IN A10
	MOVI	500,A0
	CALLA	RANDPER
	JRC	FTUNG0
	CLR	A10
FTUNG0
	MOVE	A11,A0
	CALLA	SHADUPD
	BTST	B_FLIPH,A9
	JREQ	FTUNG1
	CALLA	YFLP		 ;FLIP THE DUDE IF APPROPRIATE
FTUNG1:
	CALLR	TNGVEL
	ADDI	->20000,A1	 ;GET Y VELOCITY
	MOVE	A1,*A8(OYVEL),L
	CALLA	SHVELCPY	 ;COPY VELOCITY TO SHADOW
TNGJMP:
	MOVI	TNGLIK,A9     	 ;JUMP ON THE DUDE
TNGJMP0:
	MOVK	4,A1
	JSRP	FRANIM
	JRC	TNGJMP
*FALLING GRAVITY PROCESS
	SLEEP	2
TNGJMP1
	CALLA	ZCHK			;MAKE SURE Z IN BOUNDS
	CALLR	TNGCLCK
	MOVE	@WORLDTL,A0,W		;CHECK FOR FAR OFF SCREEN
	ADDI	256,A0			;NORMALIZE FOR SCREEN CENTER
	MOVE	*A8(OXPOS),A1,W	
	SUB	A0,A1
	ABS	A1
	CMPI	300,A1
	JRLS	TNGOK			;NOT OFF SCREEN
	MOVE	A8,A0
	CALLA	DELENEMY		;OFF ENEMY
	JAUC	SUCIDE			;BAG IT...

TNGOK
       	MOVE	*A11(POBJ),A0,L
	CALLA	XZCHK
	MOVE	A10,A1
	MOVE	A2,A2
	JRNN	TNGOK1
	NEG	A1
TNGOK1
	MOVE	*A8(OZVEL),A0,L
	ADD	A1,A0			;ADD DELTA Z
	MOVE	A0,*A8(OZVEL),L
	MOVE	*A8(OYVEL),A0,L		;EFFECT OF GRAVITY
	ADD	A1,A0			;ADD DELTA Z
	ADDI	>4000,A0
	MOVE	A0,*A8(OYVEL),L
	MOVE	*A8(OZVEL),A1,L
	SUB	A1,A0
	JRN	TNGJMP0 		;UPWARD VEL, NO LAND

	CALLA	DFRMGRND
	CMPI	0,A1
	JRGT	TNGJMP0			;IN THE AIR STILL
	CMPI	TNGLIK1,A9
	JRLS	TNGLAND
	MOVI	TNGLIK,A9
	MOVK	4,A1
	JSRP	FRANIM
	JRUC	TNGJMP1
TNGLAND					;CHALLENGER HAS LANDED
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	CALLA	SHADUPD			;RESET YOUR SHADOW
	MOVE	*A8(OYVEL),A0,L
	MOVE	*A8(OZVEL),A1,L
	SUB	A1,A0
	NEG	A0			;NEGATE Y COMPONENT
	ADD	A1,A0
	MOVE	A0,*A8(OYVEL),L
	CALLA	SHVELCPY
	MOVI	TNGLIK1,A9		;BOUNCE ANIMATION
	JRUC	TNGJMP0

*TONGUE COLLISION CHECK
TNGCLCK
	CALLA	GETCPLY
	MOVE	*A0(POBJ),A0,L 	;PLAYER OBJECT
	CLR	A1
	CLR	A3
	MOVI	15,A6
	MOVI	25,A5
	CALLA	XZCNTCK		;ARE WE IN POSITION
	JRNC	TNGCLX		;NO, GET DIRECTION

	MOVE	*A0(OSIZEY),A2,W
	SRL	1,A2
	MOVE	*A0(OYPOS),A1,W
	ADD	A2,A1
	MOVE	*A8(OSIZEY),A4,W
	SRL	1,A4
	MOVE	*A8(OYPOS),A3,W
	ADD	A4,A3
	SUB	A3,A1
	ABS	A1
	CMPI	30,A1
	JRHS	TNGCLX

	PUSH	A0
	movi	TungHSND,A0
	calla	ONESND
	PULL	A0

	CALLA	GETCPLY
	MOVE	A0,A2
	CALLA	HEADBUTT

	MOVI	DUMCOLL,A14
	MOVE	A14,*A8(OCVECT),L	;COLLISION POINTER NULL FOR NOW

	CALLA	PSTOP
	MOVI	>20000,A0
	MOVE	A0,*A8(OYVEL),L		;INITIAL DOWNWARD THRUST
	CALLA	SHVELCPY
	PULL	A0			;BLOW OFF A WORD ON STACK
	JRUC	TNGDIE
TNGCLX
	RETS

*COPY TO SHADOW AND FLIP OPPOSITE
SHVLFLP1
	CALLA	SHVELCPY
	MOVE	*A8(OXVEL+>10),A14,W		;TEST X VELOCITY
	JAN	NOYFLP
	JAUC	YFLP
*
*GET TONGUE VELOCITY
*COMPUTE JUMP VELOCITIES
*A0=PDATA OF TARGET PLAYER
*A8=TONGUE
*
TNGVEL
	MOVE	*A0(POBJ),A6,L	 ;GET TARGET
	MOVE	*A6(OXVAL),A1,L	 ;COMPUTE X VELOCITY
	MOVE	*A8(OXVAL),A2,L
	MOVE	*A6(OXVEL),A3,L
	MOVI	>3F,A0
	CALLA	SRAND
	MOVE	A0,A4  		;SAVE FASTBALL INDICATOR
	JRN	TUNGV1
	CLR	A3
TUNGV1	
	ADD	A0,A2
	SUB	A2,A1
	SRA	5,A1
	MOVE	A1,A5
	SRA	1,A5
	MOVE	A4,A4
	JRN	TUNGV11
	CLR	A5
TUNGV11
	ADD	A5,A1
	ADD	A1,A3
	MOVE	A3,*A8(OXVEL),L
	MOVE	*A6(OZVAL),A1,L	 ;COMPUTE Z VELOCITY
	MOVE	*A8(OZVAL),A2,L
	MOVE	*A6(OZVEL),A3,L
	MOVI	>1F,A0
	CALLA	SRAND
	JRN	TUNGV2
	CLR	A3
TUNGV2
	ADD	A0,A2
	SUB	A2,A1
	SRA	5,A1
	MOVE	A1,A5
	SRA	1,A5
	MOVE	A4,A4
	JRN	TUNGV22
	CLR	A5
TUNGV22
	ADD	A5,A1
	ADD	A3,A1
	MOVE	A1,*A8(OZVEL),L
      	RETS
*
*COLLISION ROUTINE
*A0=PTR TO TONGUE
*A8=PTR TO THING THAT SMASHED HIM
*
TNGBUL
TNGEX
TNGROK
	MOVE	*A8(OID),A11,W		;GET ENEMY ID FOR POINTS
         MOVE 	A8,A10			;SAVE BULLET
	MOVE	A0,A8       		;PASS WASTED GUYS POINTER
	CALLA	SCRKIL
	MOVI	DUMCOLL,A14
	MOVE	A14,*A0(OCVECT),L	;COLLISION POINTER NULL FOR NOW

	CALLA	PSTOP
	MOVI	>20000,A0
	MOVE	A0,*A8(OYVEL),L		;INITIAL DOWNWARD THRUST
	CALLA	SHVELCPY
	MOVI	TNGDIE,A7
	MOVE	*A8(OPLINK),A0,L
	MOVI	0EDh,A1
	CALLA	XFERPROC		;CREATE A TNGDIE
	RETS
*
*TONGUE DIE
*A8=DYING TONGUE
*
TNGDIE:
	MOVI	TNGLK1,A9		;MAKE A FLAT TONGUE
TNGDIEL:
	MOVK	4,A1
	JSRP	FRANIM
	JRC	TNGDIE
	SLEEP	3
	MOVE	*A8(OYVEL),A0,L		;EFFECT OF GRAVITY
	ADDI	>7FFF,A0
	MOVE	A0,*A8(OYVEL),L
	JRN	TNGDIEL			;CANT LAND WITH NEGATIVE Y VEL.
	CALLA	DFRMGRND
	JRNN	TNGDIEL			;STILL GOING

	CMPI	>20000,A0
	JRLS	TNGSINK
	MOVI	>60000000,A1
	MPYU	A1,A0
	NEG	A0
	MOVE	A0,*A8(OYVEL),L		;CUT DOWN Y
	JRUC	TNGDIEL

TNGSINK:
	CALLA	PSTOP			;STOP THE SUCKER   
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	MOVI	[1,1],A9
	CREATE	0DFh,ESINK 	    	;CREATE THE DEADMAN SINK	 
	JAUC	SUCIDE			;DIE

TNGTAB:	
TNGINIT:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	TUNG1C,LOFZ,TNGCOLL
	.WORD	DMAWNZ,>E01
	.LONG	0

*COLLISION TABLE
TNGCOLL	
	.WORD	B1OID|BULLETID
	.LONG	TNGBUL
	.WORD	B1OID|EXPLODID
	.LONG	TNGEX
	.WORD	B1OID|ROCKETID
	.LONG	TNGROK
	.WORD	B2OID|BULLETID
	.LONG	TNGBUL
	.WORD	B2OID|EXPLODID
	.LONG	TNGEX
	.WORD	B2OID|ROCKETID
	.LONG	TNGROK
	.WORD	BEOID|EXPLODID
	.LONG	TNGEX
	.WORD	0
	.LONG	DUMRTSG
*
*TONGUE ANIMATION
*
*LICKING
TNGLIK:
	.LONG	TUNG6C
	.word	4
	.LONG	TUNG7C
	.word	4
	.LONG	TUNG8C
	.word	4
	.LONG	TUNG9C
	.word	6
	.LONG	TUNG8C
	.word	4
	.LONG	TUNG7C
	.word	4
TNGLIK1
	.LONG	TUNG6C
	.word	4
	.LONG	TUNG5C
	.word	4
	.LONG	TUNG4C
	.word	4
	.LONG	TUNG3C
	.word	7
	.LONG	TUNG4C
	.word	4
	.LONG	TUNG5C
	.word	4
         .LONG	0
*	
*TONGUE ANIMATION STICK IN AND OUT
*
TNGSTK
	.LONG	TUNG0C
	.word	4
	.LONG	TUNG1C
	.word	4
	.LONG	TUNG2C
	.word	7
	.LONG	TUNG5C
	.word	4
	.LONG	TUNG2C
	.word	4
	.LONG	TUNG1C
	.word	4
	.LONG	TUNG0C
	.word	4
         .LONG	0
TNGLK1:
	.LONG	TUNG7C
	.word	4
	.LONG	TUNG8C
	.word	4
	.LONG	TUNG9C
	.word	6
	.LONG	TUNG8C
	.word	4
	.LONG	0


baseflsh:
	.word	243
	.word	>0,>0,>20,>400,>404,>424,>824,>428
	.word	>828,>444,>448,>844,>848,>868,>C48,>C68
	.word	>84C,>86C,>C4C,>C6C,>C70,>C8C,>C90,>106C
	.word	>1070,>108C,>1090,>1490,>1094,>1494,>10B0,>10B4
	.word	>14B0,>14B4,>14D4,>14B8,>14D8,>1CB4,>1CB8,>1CD4
	.word	>1CD8,>1CF8,>1CD8,>1CF8,>1CDC,>1CFC,>1CDC,>1CFC
	.word	>1CFF,>1D3C,>1D3F,>24FC,>24FF,>253C,>253F,>253F
	.word	>255F,>255F,>253F,>255F,>253F,>253F,>255F,>255F
	.word	>257F,>257F,>2D3F,>2D5F,>2D5F,>2D5F,>2D7F,>2D7F
	.word	>2D9F,>2D7F,>2D9F,>2D7F,>2D9F,>2D7F,>2D9F,>359F
	.word	>2D9F,>359F,>95F,>2DBF,>2DBF,>35BF,>35BF,>35DF
	.word	>35BF,>35DF,>35BF,>35DF,>35BF,>35DF,>35DF,>35FF
	.word	>35FF,>3DDF,>3DDF,>3DFF,>3DFF,>3DFF,>3DFF,>3DFF
	.word	>3E1F,>3E1F,>3E1F,>3E1F,>3E5F,>3E1F,>3E5F,>4E1F
	.word	>461F,>461F,>465F,>465F,>465F,>467F,>467F,>465F
	.word	>465F,>467F,>467F,>469F,>4E7F,>4E9F,>467F,>469F
	.word	>4E7F,>4E9F,>4E9F,>4E9F,>4E9F,>4EBF,>4EBF,>4EBF
	.word	>4EBF,>4EBF,>4EDF,>4EDF,>4EFF,>56BF,>56DF,>56BF
	.word	>56DF,>56DF,>56DF,>56DF,>5EDF,>56FF,>56FF,>56FF
	.word	>56FF,>56FF,>571F,>571F,>571F,>573F,>5EFF,>5EFF
	.word	>5F1F,>5F1F,>5F3F,>5F1F,>5F3F,>5F1F,>5F3F,>5F1F
	.word	>5F3F,>5F3F,>673F,>673F,>5F7F,>677F,>5F7F,>677F
	.word	>677F,>679F,>679F,>677F,>677F,>679F,>679F,>6F9F
	.word	>679F,>6F9F,>67BF,>67BF,>6FBF,>6FBF,>6FDF,>6FBF
	.word	>6FDF,>6FBF,>6FDF,>6FBF,>6FDF,>6FDF,>6FFF,>6FFF
	.word	>77BF,>77DF,>77DF,>77FF,>77FF,>77FF,>77FF,>77FF
	.word	>77FF,>77FF,>77FF,>77FF,>77FF,>77FF,>77FF,>7FFF
	.word	>7FFF,>7FFF,>7FFF,>7FFF,>7FFF,>7FFF,>7FFF,>7FFF
	.word	>7FFF,>7FFF,>7FDF,>7FDF,>7FFF,>7FFF,>7FFF,>7FFF
	.word	>7FFF,>7FFF,>7FFF,>7FFF,>5F1F,>67BF,>6F9F,>769F
	.word	>7EDF,>567F,>6E7F



****************************************************************************
MkNuke:
;*** PROCESS TO CREATE A NUCLEAR BURST
;A8 - ptr to obj to position air burst at
;A10 - X pos offset
;A11 - Y pos offset

expltiks	.set	ETEMP1

	calla	GETOBJ
	jrz	NoBomObj
	move	A0,A6

	move	A6,A0
	movi	NUKEINI,A14
	calla	STFOBJ

	movi	newbom,A0
	calla	GETFPAL
	jrz	NoBomPal
	move	A0,*A6(OPAL),W

	MOVE	*A6(OFLAGS),A0,W
	ANDNI	M_PIXSCAN|M_FLIPV,A0
	MOVE	A0,*A6(OFLAGS),W	;UPDATE FOR NO PIXEL SCAN, no VFLIP

	move	A6,A0
;A8 ptr to BASE OBJ
;A0 ptr to obj which is to have its position set so that its anim pt
	move	*A8(OXVEL),*A0(OXVEL),L
	move	*A8(OYVEL),*A0(OYVEL),L
	move	*A8(OZVEL),*A0(OZVEL),L
	move	*A8(OZPOS),*A0(OZPOS),W
	calla	SetAniP
	move	A6,A8

	move	*A8(OXPOS),A0,W
	add	A10,A0
	move	A0,*A8(OXPOS),W
	move	*A8(OYPOS),A0,W
	add	A11,A0
	move	A0,*A8(OYPOS),W
	move	*A8(OZPOS),A0,W
	addk	5,A0
	move	A0,*A8(OZPOS),W

	;* insert on proper lists
	move	A8,A0
	movi	EXPLOSIONS,A1
	calla	ADDSUPP
	calla	INSOBJ


	movi	AIRB1,A9
	movi	AIRB2,A10
	calla	DFRMGRND
	cmpi	10,A1
	jrge	GOTEXP
	;**** Do a Ground Nuke
	calla	ClrVel
	;set ani pt on the ground
	move	*A8(OYPOS),A0,W
	add	A1,A0
	addi	15,A0
	move	A0,*A8(OYPOS),W
	movi	GRNDB1,A9
	movi	GRNDB2,A10
GOTEXP:

	movi	BOMBSND,A0
	calla	ONESND

	movi	[5,5],A0
	move	A0,*A8(OZSIZ),L
	movk	1,A0
	movb	A0,*A13(expltiks)
NxtFrm:
	movb	*A13(expltiks),A0
	dec	A0
	jrnz	SkVDamp
	move	*A8(OXVEL),A0,L
	sra	1,A0
	move	A0,*A8(OXVEL),L
	move	*A8(OYVEL),A0,L
	sra	1,A0
	move	A0,*A8(OYVEL),L
	move	*A8(OZVEL),A0,L
	sra	1,A0
	move	A0,*A8(OZVEL),L
	movk	3,A0
SkVDamp:
	movb	A0,*A13(expltiks)

	movk	4,A1
	jsrp	FRANIM
	jrnc	AdjZ
	;do second half of explosion??
	move	A10,A9
	jrz	XploDone
	clr	A10
	move	A0,A7
	move	A8,A0
	movi	EXPLOSIONS,A1
	calla	DELSUPP			;DELETE FROM THE SUPPLEMENTAL LIST
	move	A7,A0

AdjZ:
	move	*A8(OZPOS),A1,W		;move explosion forward
	add	A0,A1
	move	A1,*A8(OZPOS),W
	move	*A8(OZSIZ),A1,W		;grow Zminus thickness
	add	A0,A1
	add	A0,A1
	move	A1,*A8(OZSIZ),W
	CALLA	PRCSLP
	jruc	NxtFrm
XploDone:
	move	A8,A0			;GET THE BLOCK
	CALLA	DELPAL
	calla	DELOBJ			;ZAP IT
	DIE

NoBomPal:
	move	A6,A0
	calla	FREEOBJ
NoBomObj:
	DIE
****************************************************************************

NUKEINI:
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	nb1,0,DUMCOLL
	.WORD	DMAWNZ,BEOID|EXPLODID
	.LONG	0

AIRB1:
	.long	nb1
	.word	4
	.long	nb2a
	.word	6
	.long	nb3a
	.word	5
	LONGNULL
AIRB2:
	.long	nb4
	.word	4
	.long	nb5
	.word	3
	.long	nb6
	.word	3
	.long	nb7
	.word	3
	.long	nb8
	.word	3
	.long	hiro9air
	.word	3
	.long	hiro10air
	.word	3
	.long	hiro11air
	.word	3
	LONGNULL

GRNDB1:				;GROUND BLAST ON EXPLOSION LIST
	.long	nb1grnd
	.word	3
	.long	hiro1
	.word	5
	.long	hiro2
	.word	5
	.long	hiro3
	.word	5
	.long	hiro4
	.word	4
	LONGNULL
GRNDB2:				;GROUND BLAST OFF EXPLO LIST
	.long	hiro5
	.word	3
	.long	hiro6
	.word	3
	.long	nb5grnd
	.word	3
	.long	nb6grnd
	.word	3
	.long	nb7grnd
	.word	3
	.long	nb8grnd
	.word	3
	.long	hiro9
	.word	3
	.long	hiro10
	.word	3
	.long	hiro11
	.word	3
	LONGNULL
