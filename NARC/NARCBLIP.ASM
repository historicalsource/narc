	.FILE	'NARCBLIP.ASM'
	.TITLE	" <<< N  A  R  C  -- SCANNER BLIPS >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.EVEN

	.data
*
*SCANNER BLIP IMAGE TABLE
*	.LONG	PTR TO UNFLIPPED,PTR TO FLIPPED
CADBLIP:
	.LONG	CADBLP1,CADBLP2
*BLIP IMAGE DATA
*	.WORD	WIDTH,HEIGHT
*	.BYTE	DATA
CADBLP1:
   .word    >F,>6
   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>00,>1D,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>00,>26,>1D,>00,>00,>00,>00
   .byte    >00,>A4,>B5,>B5,>4A,>A4,>A4,>A4,>A4,>26,>3E,>3D,>3D,>3D,>A8
   .byte    >B6,>3E,>3E,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>B6,>B6,>A8
   .byte    >A8,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>AB,>AB,>3D,>3D,>00
   .byte    >00,>00,>00,>AB,>BB,>00,>00,>00,>00,>00,>AB,>BB,>00,>00,>00
	.EVEN
CADBLP2:
   .word    >F,>6
   .byte    >00,>00,>00,>00,>00,>1D,>00,>00,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>1D,>26,>00,>00,>00,>00,>00,>00,>00,>00,>00
   .byte    >A8,>3D,>3D,>3D,>3E,>26,>A4,>A4,>A4,>A4,>4A,>B5,>B5,>A4,>00
   .byte    >A8,>B6,>B6,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>B5,>3E,>3E,>B6
   .byte    >00,>3D,>3D,>AB,>AB,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>3D,>A8
   .byte    >00,>00,>00,>BB,>AB,>00,>00,>00,>00,>00,>BB,>AB,>00,>00,>00
	.EVEN
DUMPBLIP:
	.LONG	DUMPBLP1,DUMPBLP1
DUMPBLP1
   .word    >4,>8
   .byte    >B6,>1E,>82,>B6
   .byte    >22,>00,>00,>22
   .byte    >22,>45,>B6,>22
   .byte    >8B,>22,>22,>8B
   .byte    >00,>22,>22,>00
   .byte    >1A,>1C,>1C,>1A
   .byte    >22,>00,>00,>22
   .byte    >22,>00,>00,>22
	.EVEN
EXITBLIP:
	.LONG	EXITBLP1,EXITBLP1
EXITBLP1
   .word    >5,>8
   .byte    >D6,>D6,>D6,>D6,>D6
   .byte    >D6,>D6,>D6,>D6,>D6
   .byte    >D6,>D6,>00,>00,>00
   .byte    >D6,>D6,>D6,>D6,>00
   .byte    >D6,>D6,>D6,>D6,>00
   .byte    >D6,>D6,>00,>00,>00
   .byte    >D6,>D6,>D6,>D6,>D6
   .byte    >D6,>D6,>D6,>D6,>D6
	.EVEN

  .IF BLUEP1
P1BLIP:
	.LONG	P1BLP1,P1BLP1
  .ELSE
P1BLIP:
	.LONG	P2BLP1,P2BLP1
  .ENDIF
P1BLP1
   .word    >6,>9
   .byte    >00,>00,>DF,>DF,>00,>00
   .byte    >00,>DF,>00,>00,>DF,>00
   .byte    >DF,>DF,>DF,>DF,>DF,>DD
   .byte    >63,>DD,>DF,>DF,>DD,>B5
   .byte    >63,>00,>DD,>DD,>00,>B6
   .byte    >63,>DE,>DF,>DF,>DE,>B6
   .byte    >00,>DF,>DD,>DD,>DF,>00
   .byte    >00,>DF,>00,>00,>DF,>00
   .byte    >00,>DF,>00,>00,>DF,>00
	.EVEN
  .IF BLUEP1
P2BLIP:
	.LONG	P2BLP1,P2BLP1
  .ELSE
P2BLIP:
	.LONG	P1BLP1,P1BLP1
  .ENDIF
P2BLP1
   .word    >6,>9
   .byte    >00,>00,>D6,>D6,>00,>00
   .byte    >00,>D6,>00,>00,>D6,>00
   .byte    >D6,>D6,>D6,>D6,>D6,>9D
   .byte    >63,>9D,>D6,>D6,>9D,>B6
   .byte    >63,>00,>CE,>CE,>00,>B6
   .byte    >63,>CE,>D6,>D6,>CE,>B6
   .byte    >00,>D6,>9D,>9D,>D6,>00
   .byte    >00,>D6,>00,>00,>D6,>00
   .byte    >00,>D6,>00,>00,>D6,>00
	.EVEN
PORSBLIP:
	.LONG	PORSBLP1,PORSBLP2
PORSBLP1
   .word    >10,>6
   .byte    >00,>00,>D6,>CE,>00,>00,>00,>00,>00,>00,>00,>00,>00,>00,>00,>00
   .byte    >00,>D6,>D6,>D6,>D6,>CE,>CE,>9D,>9D,>9D,>1D,>AB,>CE,>00,>00,>00
   .byte    >D6,>D6,>D6,>CE,>D6,>1D,>9D,>9D,>9A,>1D,>26,>3E,>D6,>D6,>CE,>9D
   .byte    >00,>9D,>CE,>CE,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>CE
   .byte    >00,>00,>D6,>82,>82,>A2,>D6,>A2,>D6,>D6,>A2,>82,>82,>D6,>CE,>00
   .byte    >00,>00,>00,>82,>82,>00,>00,>00,>00,>00,>00,>82,>82,>00,>00,>00
	.EVEN
PORSBLP2
   .word    >10,>6
   .byte    >00,>00,>00,>00,>00,>00,>00,>00,>00,>00,>00,>00,>CE,>D6,>00,>00
   .byte    >00,>00,>00,>CE,>AB,>1D,>9D,>9D,>9D,>CE,>CE,>D6,>D6,>D6,>D6,>00
   .byte    >9D,>CE,>D6,>D6,>3E,>26,>1D,>9A,>9D,>9D,>1D,>D6,>CE,>D6,>D6,>D6
   .byte    >CE,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>D6,>CE,>CE,>9D,>00
   .byte    >00,>CE,>D6,>82,>82,>A2,>D6,>D6,>A2,>D6,>A2,>82,>82,>D6,>00,>00
   .byte    >00,>00,>00,>82,>82,>00,>00,>00,>00,>00,>00,>82,>82,>00,>00,>00
	.EVEN
BUCKBLIP:
	.LONG	BUCKBLP1,BUCKBLP1
BUCKBLP1
   .word    >4,>1
   .byte    >DB,>1C,>1C,>DB
	.EVEN
CLIPBLIP:
	.LONG	CLIPBLP1,CLIPBLP1
CLIPBLP1
   .word    >3,>3
   .byte    >A8,>00,>A8
   .byte    >B2,>0F,>B1
   .byte    >B1,>12,>B1
	.EVEN
CLWNBLIP:
	.LONG	CLWNBLP1,CLWNBLP2
CLWNBLP1:
   .word    >4,>8
   .byte    >00,>D6,>B6,>00
   .byte    >D6,>D6,>B6,>3D
   .byte    >00,>B6,>B4,>00
   .byte    >CC,>53,>CC,>B4
   .byte    >B4,>CC,>CC,>00
   .byte    >00,>CC,>53,>4B
   .byte    >00,>CC,>00,>53
   .byte    >00,>CC,>00,>CC
	.EVEN
CLWNBLP2:
   .word    >4,>8
   .byte    >00,>B6,>D6,>00
   .byte    >3D,>B6,>D6,>D6
   .byte    >00,>B4,>B6,>00
   .byte    >B4,>CC,>53,>CC
   .byte    >00,>CC,>CC,>B4
   .byte    >4B,>53,>CC,>00
   .byte    >53,>00,>CC,>00
   .byte    >CC,>00,>CC,>00
	.EVEN
DRUGBLIP:
	.LONG	DRUGBLP1,DRUGBLP1
DRUGBLP1
   .word    >2,>2
   .byte    >26,>26
   .byte    >31,>31
	.EVEN
GOALBLIP:
	.LONG	GOALBLP1,GOALBLP1
GOALBLP1
   .word    >B,>B
   .byte    >00,>00,>00,>00,>00,>F5,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>F5,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>F5,>F5,>F5,>00,>00,>00,>00
   .byte    >00,>00,>00,>F5,>00,>F5,>00,>F5,>00,>00,>00
   .byte    >00,>00,>F5,>00,>00,>F5,>00,>00,>F5,>00,>00
   .byte    >F5,>F5,>F5,>F5,>F5,>F5,>F5,>F5,>F5,>F5,>F5
   .byte    >00,>00,>F5,>00,>00,>F5,>00,>00,>F5,>00,>00
   .byte    >00,>00,>00,>F5,>00,>F5,>00,>F5,>00,>00,>00
   .byte    >00,>00,>00,>00,>F5,>F5,>F5,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>F5,>00,>00,>00,>00,>00
   .byte    >00,>00,>00,>00,>00,>F5,>00,>00,>00,>00,>00
	.EVEN
HOOKBLIP:
	.LONG	HOOKBLP1,HOOKBLP2
HOOKBLP1
   .word    >3,>A
   .byte    >B1,>DA,>00
   .byte    >DA,>CA,>00
   .byte    >00,>CA,>00
   .byte    >00,>CC,>CC
   .byte    >00,>D6,>00
   .byte    >D6,>D6,>00
   .byte    >D6,>CE,>00
   .byte    >CA,>00,>00
   .byte    >CA,>00,>00
   .byte    >B4,>00,>00
	.EVEN
HOOKBLP2
   .word    >3,>A
   .byte    >00,>DA,>B1
   .byte    >00,>CA,>DA
   .byte    >00,>CA,>00
   .byte    >CC,>CC,>00
   .byte    >00,>D6,>00
   .byte    >00,>D6,>D6
   .byte    >00,>CE,>D6
   .byte    >00,>00,>CA
   .byte    >00,>00,>CA
   .byte    >00,>00,>B4
	.EVEN

HYPOBLIP
	.LONG	HYPOBLP1,HYPOBLP2
HYPOBLP1:
   .word    >5,>A
   .byte    >45,>D8,>00,>00,>00
   .byte    >45,>B6,>00,>00,>00
   .byte    >45,>85,>00,>00,>00
   .byte    >D8,>85,>85,>00,>00
   .byte    >B7,>B6,>27,>26,>91
   .byte    >85,>85,>83,>00,>00
   .byte    >85,>85,>83,>00,>00
   .byte    >85,>00,>85,>00,>00
   .byte    >85,>00,>85,>00,>00
   .byte    >B7,>00,>B7,>00,>00
	.EVEN
HYPOBLP2:
   .word    >5,>A
   .byte    >00,>00,>00,>D8,>45
   .byte    >00,>00,>00,>B6,>45
   .byte    >00,>00,>00,>85,>45
   .byte    >00,>00,>85,>85,>D8
   .byte    >91,>26,>27,>B6,>B7
   .byte    >00,>00,>83,>85,>85
   .byte    >00,>00,>83,>85,>85
   .byte    >00,>00,>85,>00,>85
   .byte    >00,>00,>85,>00,>85
   .byte    >00,>00,>B7,>00,>B7
	.EVEN
LOFBLIP:
	.LONG	LOFBLP1,LOFBLP2
LOFBLP1
   .word    >4,>7
   .byte    >00,>9F,>9F,>CA
   .byte    >9F,>A8,>A8,>C5
   .byte    >A8,>A8,>34,>00
   .byte    >A8,>A8,>47,>00
   .byte    >A8,>A8,>9F,>00
   .byte    >BB,>00,>BB,>00
   .byte    >BB,>00,>BB,>00
	.EVEN
LOFBLP2
   .word    >4,>7
   .byte    >CA,>9F,>9F,>00
   .byte    >C5,>A8,>A8,>9F
   .byte    >00,>34,>A8,>A8
   .byte    >00,>47,>A8,>A8
   .byte    >00,>9F,>A8,>A8
   .byte    >00,>BB,>00,>BB
   .byte    >00,>BB,>00,>BB
	.EVEN
MBIGBLIP:
	.LONG	MBIGBLP1,MBIGBLP2
MBIGBLP1:
   .word    >7,>8
   .byte    >00,>00,>63,>63,>00,>00,>00
   .byte    >00,>63,>B6,>B6,>63,>00,>00
   .byte    >B9,>63,>63,>B6,>00,>00,>00
   .byte    >00,>63,>CC,>CC,>B6,>00,>00
   .byte    >4E,>C3,>4E,>4E,>63,>C3,>1E
   .byte    >63,>00,>00,>8D,>63,>63,>00
   .byte    >63,>B9,>00,>00,>63,>63,>00
   .byte    >8D,>63,>63,>4E,>8D,>C3,>63
	.EVEN
MBIGBLP2:
   .word    >7,>8
   .byte    >00,>00,>00,>63,>63,>00,>00
   .byte    >00,>00,>63,>B6,>B6,>63,>00
   .byte    >00,>00,>00,>B6,>63,>63,>B9
   .byte    >00,>00,>B6,>CC,>CC,>63,>00
   .byte    >1E,>C3,>63,>4E,>4E,>C3,>4E
   .byte    >00,>63,>63,>8D,>00,>00,>63
   .byte    >00,>63,>63,>00,>00,>B9,>63
   .byte    >63,>C3,>8D,>4E,>63,>63,>8D
	.EVEN
ROCKBLIP:
	.LONG	ROCKBLP1,ROCKBLP2
ROCKBLP1:
   .word    >6,>1
   .byte    >CC,>AB,>CC,>CC,>D6,>D6
	.EVEN
ROCKBLP2:
   .word    >6,>1
   .byte    >D6,>D6,>CC,>CC,>AB,>CC
	.EVEN
DOGBLIP:
	.LONG	DOGBLP1,DOGBLP2
DOGBLP1:
   .word    >5,>3
   .byte    >32,>00,>00,>32,>A8
   .byte    >A8,>A8,>A8,>A8,>00
   .byte    >A8,>00,>00,>A8,>00
	.EVEN
DOGBLP2:
   .word    >5,>3
   .byte    >A8,>32,>00,>00,>32
   .byte    >00,>A8,>A8,>A8,>A8
   .byte    >00,>A8,>00,>00,>A8
	.EVEN
BUGBLIP:
	.LONG	BUGBLP1,BUGBLP1
BUGBLP1
   .word    >5,>3
   .byte    >75,>33,>A7,>33,>94
   .byte    >A5,>39,>39,>A5,>39
   .byte    >A2,>00,>A5,>00,>A5
	.EVEN
PIMPBLIP
	.LONG	PIMPBLP1,PIMPBLP2
PIMPBLP1:
   .word    >3,>9
   .byte    >00,>A6,>A6
   .byte    >7D,>B9,>A6
   .byte    >B9,>BD,>00
   .byte    >BD,>BD,>D6
   .byte    >BD,>BD,>D6
   .byte    >BD,>B9,>CE
   .byte    >B9,>CE,>D6
   .byte    >B9,>00,>D6
   .byte    >D6,>00,>D6
	.EVEN
PIMPBLP2:
   .word    >3,>9
   .byte    >A6,>A6,>00
   .byte    >A6,>B9,>7D
   .byte    >00,>BD,>B9
   .byte    >D6,>BD,>BD
   .byte    >D6,>BD,>BD
   .byte    >CE,>B9,>BD
   .byte    >D6,>CE,>B9
   .byte    >D6,>00,>B9
   .byte    >D6,>00,>D6
	.EVEN

CHOPBLIP
	.LONG	CHOPBLP1,CHOPBLP2
CHOPBLP1:
   .word    >C,>6
   .byte    >00,>00,>00,>4E,>4E,>5E,>5E,>CC,>5E,>5E,>4E,>4E
   .byte    >CC,>00,>00,>00,>00,>00,>00,>CC,>00,>00,>00,>00
   .byte    >5E,>4E,>00,>00,>00,>CC,>CC,>CC,>CC,>4E,>00,>00
   .byte    >B7,>CC,>CC,>CC,>CC,>CC,>4E,>00,>00,>B7,>4E,>00
   .byte    >00,>00,>00,>00,>00,>CC,>5E,>00,>00,>00,>5E,>4E
   .byte    >00,>00,>00,>00,>00,>00,>5E,>CC,>CC,>CC,>5E,>4E
	.EVEN
CHOPBLP2:
   .word    >C,>6
   .byte    >4E,>4E,>5E,>5E,>CC,>5E,>5E,>4E,>4E,>00,>00,>00
   .byte    >00,>00,>00,>00,>CC,>00,>00,>00,>00,>00,>00,>CC
   .byte    >00,>00,>4E,>CC,>CC,>CC,>CC,>00,>00,>00,>4E,>5E
   .byte    >00,>4E,>B7,>00,>00,>4E,>CC,>CC,>CC,>CC,>CC,>B7
   .byte    >4E,>5E,>00,>00,>00,>5E,>CC,>00,>00,>00,>00,>00
   .byte    >4E,>5E,>CC,>CC,>CC,>5E,>00,>00,>00,>00,>00,>00
	.EVEN

GANGBLIP
	.LONG	GANGBLP1,GANGBLP2
GANGBLP1:
   .word    >3,>9
   .byte    >8A,>57,>40
   .byte    >7D,>A6,>A6
   .byte    >B9,>BD,>A6
   .byte    >BD,>BD,>40
   .byte    >BD,>B9,>8A
   .byte    >B9,>B9,>8A
   .byte    >B9,>8A,>40
   .byte    >B9,>00,>57
   .byte    >57,>00,>57
	.EVEN
GANGBLP2:
   .word    >3,>9
   .byte    >40,>57,>8A
   .byte    >A6,>A6,>7D
   .byte    >A6,>BD,>B9
   .byte    >40,>BD,>BD
   .byte    >8A,>B9,>BD
   .byte    >8A,>B9,>B9
   .byte    >40,>8A,>B9
   .byte    >57,>00,>B9
   .byte    >57,>00,>57
	.EVEN

RAMBBLIP
	.LONG	RAMBBLP1,RAMBBLP2
RAMBBLP1:
   .word    >7,>10
   .byte    >00,>00,>00,>A4,>A1,>00,>00
   .byte    >00,>00,>00,>B1,>B1,>00,>00
   .byte    >00,>00,>B1,>3D,>B4,>00,>00
   .byte    >00,>B1,>B4,>F4,>B4,>00,>00
   .byte    >00,>47,>3A,>B3,>C1,>88,>00
   .byte    >00,>47,>C6,>60,>CC,>5B,>00
   .byte    >00,>B6,>B4,>34,>18,>34,>18
   .byte    >00,>47,>CA,>34,>14,>00,>00
   .byte    >00,>15,>3C,>C7,>39,>00,>00
   .byte    >00,>0D,>34,>33,>3A,>B1,>00
   .byte    >00,>16,>C7,>00,>03,>34,>00
   .byte    >00,>35,>C4,>00,>B1,>34,>00
   .byte    >B1,>35,>00,>00,>B1,>C4,>00
   .byte    >B1,>35,>00,>00,>B1,>65,>00
   .byte    >15,>B1,>00,>00,>00,>66,>00
   .byte    >65,>B1,>00,>00,>00,>00,>00
	.EVEN
RAMBBLP2:
   .word    >7,>10
   .byte    >00,>00,>A1,>A4,>00,>00,>00
   .byte    >00,>00,>B1,>B1,>00,>00,>00
   .byte    >00,>00,>B4,>3D,>B1,>00,>00
   .byte    >00,>00,>B4,>F4,>B4,>B1,>00
   .byte    >00,>88,>C1,>B3,>3A,>47,>00
   .byte    >00,>5B,>CC,>60,>C6,>47,>00
   .byte    >18,>34,>18,>34,>B4,>B6,>00
   .byte    >00,>00,>14,>34,>CA,>47,>00
   .byte    >00,>00,>39,>C7,>3C,>15,>00
   .byte    >00,>B1,>3A,>33,>34,>0D,>00
   .byte    >00,>34,>03,>00,>C7,>16,>00
   .byte    >00,>34,>B1,>00,>C4,>35,>00
   .byte    >00,>C4,>B1,>00,>00,>35,>B1
   .byte    >00,>65,>B1,>00,>00,>35,>B1
   .byte    >00,>66,>00,>00,>00,>B1,>15
   .byte    >00,>00,>00,>00,>00,>B1,>65
	.EVEN

HEADBLIP
	.LONG	HEADBLP,HEADBLP
HEADBLP:
   .word    >C,>12
   .byte    >00,>00,>00,>40,>57,>57,>40,>4C,>00,>00,>00,>00
   .byte    >00,>00,>CC,>CB,>48,>40,>48,>48,>38,>00,>00,>00
   .byte    >00,>00,>64,>64,>5A,>4C,>48,>40,>38,>0B,>00,>00
   .byte    >00,>00,>CC,>CC,>5A,>38,>98,>98,>98,>98,>98,>40
   .byte    >00,>00,>64,>CC,>38,>17,>98,>37,>46,>AF,>C1,>48
   .byte    >00,>00,>4C,>98,>4C,>CC,>60,>C1,>47,>3D,>B4,>00
   .byte    >00,>00,>1C,>CC,>CC,>AF,>AE,>3D,>3E,>3D,>3C,>00
   .byte    >00,>42,>57,>AE,>1B,>A0,>34,>A6,>3D,>3D,>3C,>00
   .byte    >37,>CA,>AE,>3D,>A4,>34,>A5,>34,>3D,>3D,>3C,>00
   .byte    >3C,>00,>3D,>3D,>A4,>16,>16,>A6,>47,>3D,>3C,>00
   .byte    >00,>00,>B4,>D3,>16,>14,>C7,>3D,>47,>3D,>18,>00
   .byte    >00,>00,>A1,>AE,>98,>15,>35,>3C,>C8,>3D,>A1,>00
   .byte    >00,>00,>00,>40,>AF,>37,>36,>A4,>C8,>3D,>3D,>00
   .byte    >00,>00,>00,>B4,>3C,>C7,>C7,>D3,>B0,>47,>B5,>00
   .byte    >00,>00,>00,>B6,>C8,>C7,>A4,>A6,>D3,>3E,>47,>AE
   .byte    >00,>00,>00,>B6,>3C,>18,>A0,>39,>3D,>47,>B6,>B4
   .byte    >00,>00,>00,>47,>C8,>A4,>A1,>39,>C6,>47,>B6,>B1
   .byte    >00,>00,>00,>00,>B1,>34,>A0,>A4,>D3,>D3,>00,>00
	.EVEN

SKULBLIP
	.LONG	SKULBLP,SKULBLP
SKULBLP:
   .word    >A,>F
   .byte    >00,>00,>00,>87,>87,>79,>68,>00,>00,>00
   .byte    >00,>B8,>BB,>B8,>87,>85,>0C,>0B,>00,>00
   .byte    >00,>C0,>BD,>90,>87,>7F,>7A,>0C,>0C,>00
   .byte    >BB,>C0,>BD,>B8,>1E,>87,>1E,>90,>90,>00
   .byte    >BD,>C0,>BD,>BA,>1E,>1E,>BA,>4B,>4E,>90
   .byte    >BD,>4B,>4E,>4E,>4B,>54,>50,>4B,>53,>B8
   .byte    >BB,>4B,>AA,>AE,>BA,>50,>A2,>37,>54,>4B
   .byte    >BD,>4B,>34,>A4,>4B,>38,>A5,>98,>4E,>BA
   .byte    >BB,>C0,>4E,>53,>42,>4E,>C3,>C3,>53,>00
   .byte    >00,>5E,>62,>5E,>4B,>53,>64,>64,>5E,>00
   .byte    >00,>C0,>4B,>C0,>C0,>4B,>53,>C0,>84,>00
   .byte    >00,>BD,>4B,>54,>53,>4B,>54,>4E,>00,>00
   .byte    >00,>4B,>C0,>62,>64,>64,>63,>C0,>00,>00
   .byte    >00,>00,>53,>62,>61,>63,>63,>BA,>00,>00
   .byte    >00,>00,>00,>C0,>5E,>5E,>BA,>00,>00,>00
	.EVEN

	.END
