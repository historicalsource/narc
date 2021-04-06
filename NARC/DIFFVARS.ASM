**************************************************************************
*                                                                        *
* 	NARC ENEMY DIFFICULTY SETTINGS 1/11/88				 *
*                                                                        *
**************************************************************************

	.BSS	DIFRAM,0  	;START DIFFICULTY RAM

	.BSS	DRUGCNT,16	;# OF DRUG DROPS ALLOWED THIS WAVE
	.BSS	BUCKCNT,16	;# OF MONEY DROPS ALLOWED THIS WAVE
	.BSS	ROCKCNT,16	;# OF ROCKET BOMB DROPS ALLOWED THIS WAVE
	.BSS	CLIPCNT,16	;# OF CLIP DROPS ALLOWED THIS WAVE

	.BSS	gangblft,16,16	;U - # of ALLOWED bosses
	.BSS	gangbmax,16,16	;U - # of ALLOWED active bosses 
	.BSS	ganggmin,16,16	;U - min size of gang
	.BSS	ganggmax,16,16	;U - max size of gang -- <= 9
	.BSS	gangclip,16,16	;U - chance/1000 of gangster having a clip
	.BSS	gangrock,16,16	;U - chance/1000 of gangster having a rocket

	.BSS	hypoleft,16,16	;# of hypomen left
	.BSS	hypomax,16,16 	;max # of active hypomen
	.BSS	hypodrug,16,16	;chance/1000 of hypoman having drugs
	.BSS	hypobrain,16,16	;TICKS BETWEEN DECISIONS
	.BSS	hypofire,16,16 	;CHANCE/K OF THROWING SPINNER
	.BSS	hyposfir,16,16	;time between spinners

	.BSS	hookleft,16,16	;U - # of hookers left
	.BSS	hookmax,16,16 	;U - max # of active hookers
	.BSS	hookbrain,16,16	;U - max sleep between dispatches

	.BSS	pimpleft,16,16	;U - # of pimpmen left
	.BSS	pimpmax,16,16 	;U - max # of active pimpmen
	.BSS	pimpbuck,16,16	;U - chance/1000 of pimpman having bucks

	.BSS	rambleft,16,16	;U - # of rambmen left
	.BSS	rambmax,16,16 	;U - max # of active rambmen
	.BSS	rambbrain,16,16	;U - sleep between homing on players
	.BSS	rambdrug,16,16 	;U - chance/1000 of rambman having drugs
	.BSS	rambclip,16,16 	;U - chance/1000 of rambman having clips

	.BSS	DUMPNUM,16	;NUMBER OF DUMPMEN IN WAVE
	.BSS	DUMPMAX,16	;MAX AMOUNT OF DUMPMEN AT A TIME
	.BSS	DUMPSPD,16	;SPEED OF DUMPSTER MAN
	.BSS	DUMPBTT,16	;BUTT PROBABILITY
	.BSS	DUMPX,16  	;X COORDINATE TO START
	.BSS	DUMPSHT,16	;SHOT COUNT FOR DEATH

	.BSS	CLWNUM,16	;NUMBER OF CLWNMEN IN WAVE
	.BSS	CLWNMAX,16	;MAX AMOUNT OF CLWNMEN AT A TIME
	.BSS	CLWNSPD,16	;SPEED OF CLWNSTER MAN
	.BSS	CLWNX,16  	;X COORDINATE TO START
	.BSS	CLWNSHT,16	;SHOT COUNT FOR DEATH

	.BSS	LOFMAX,16	;MAX LOFFREDO'S ON SCREEN
	.BSS	LOFFIRE,16	;CHANCE/1000 OF FIRING

	.BSS	CHOPXST,16	;CHOPPER X COORDINATE START

	.BSS	DOGMAX,16	;MAXIMUM DOGS @ ONE TIME
	.BSS	DOGSPD,16	;DOGGY SPEED

	.BSS	bugleft,16,16	;BUGS THIS WAVE
	.BSS	bugmax,16,16 	;max # of active bugmen

	.BSS	ENDIFRAM,0	;END DIFFICULTY RAM

*
*WAVE TABLE
*.WORD 	DIFFICULTY DELTA,MIN,MAX,BOZO,WAVE 1,WAVE 2...WAVE 20
*DIFFICULTY: 0=EASIEST (-5*DIFF DELTA), 5=DEFAULT (0*DIFF DELTA), 10=HARDEST(5*DIFF DELTA)
WAVETAB:	
	.WORD	1,15,50,10		;DRUGCNT   ---   DRUG COUNTS
	.WORD	 16, 32, 33, 34, 35, 36, 37, 38, 39, 40
	.WORD	 41, 42, 43, 44, 45, 46, 47, 48, 49, 50

	.WORD	1,15,50,10		;BUCKCNT   ---   MONEY COUNTS
	.WORD	 16, 32, 33, 34, 35, 36, 37, 38, 39, 40
	.WORD	 41, 42, 43, 44, 45, 46, 47, 48, 49, 50

	.WORD	1,15,50,10		;ROCKCNT   ---   ROCKET COUNTS
	.WORD	 16, 32, 33, 34, 35, 36, 37, 38, 39, 40
	.WORD	 41, 42, 43, 44, 45, 46, 47, 48, 49, 50

	.WORD	1,15,50,10		;CLIPCNT   ---   CLIP COUNTS
	.WORD	 16, 32, 33, 34, 35, 36, 37, 38, 39, 40
	.WORD	 41, 42, 43, 44, 45, 46, 47, 48, 49, 50

*** GANGSTERS
	.WORD	1,0,20,0		;gangblft   ---   # ALLOWED GANGS
	.WORD	 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
	.WORD	 50, 54, 54, 54, 55, 56, 57, 58, 59, 50

	.WORD	0,1,2,0			;gangbmax   ---   # ALLOWED CONCURRENT GANGS
	.WORD	  1,  1,  1,  1,  2,  2,  1,  2,  2,  2
	.WORD	  2,  2,  2,  2,  2,  2,  2,  2,  2,  2

	.WORD	0,1,4,1			;ganggmin   ---   MIN GANG SIZE
	.WORD	  1,  1,  1,  1,  1,  1,  2,  2,  3,  3
	.WORD	  3,  3,  2,  4,  2,  5,  2,  2,  2,  2

	.WORD	0,3,9,2			;ganggmax   ---   MAX GANG SIZE
	.WORD	  4,  4,  4,  5,  5,  6,  6,  7,  7,  8
	.WORD	  8,  8,  5,  5,  5,  8,  8,  8,  9,  9

	.WORD	50,50,500,400		;gangclip   ---   CHANCE/1000 OF CLIP
	.WORD	400,350,330,310,290,270,250,240,230,220
	.WORD	210,200,190,180,170,160,150,150,150,150

	.WORD	50,50,500,400		;gangrock   ---   CHANCE/1000 OF ROCKET
	.WORD	400,350,330,310,175,270,250,240,230,220
	.WORD	210,200,190,180,170,160,150,150,150,150

*** HYPO MEN
	.WORD	1,0,50,0		;hypoleft   ---   # allowed
	.WORD	 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
	.WORD	 20, 22, 24, 26, 28, 30, 32, 34, 36, 28

	.WORD	0,1,6,1			;hypomax   ---   # ALLOWED CONCURRENT
	.WORD	  4,  4,  4,  4,  4,  4,  4,  4,  4,  4
	.WORD	  4,  4,  4,  4,  4,  4,  4,  4,  4,  4

	.WORD	-30,100,500,400		;hypodrug   ---   CHANCE/K OF DRUG
	.WORD	450,450,380,370,450,350,340,330,320,310
	.WORD	300,300,300,300,300,300,300,300,300,300

	.WORD	-1,2,12,12		;hypobrain   ---   TICKS BETWEEN DECISIONS
	.WORD	8,8,8,8,8,8,7,7,7,6
	.WORD	6,6,6,6,5,5,5,5,4,4

	.WORD	30,100,600,100		;hypofire   ---   CHANCE/K OF FIRING SPINNER
	.WORD	100,100,200,250,300,350,400,450,450,500
	.WORD	500,500,500,500,500,500,500,500,500,500

	.WORD	-1,150,500,500		;hyposfir   ---   TIME BETWEEN SPINNERS
	.WORD	400,400,400,400,400,400,400,400,400,400
	.WORD	300,300,300,300,300,300,300,300,300,300

*** Hookers
	.WORD	1,0,50,0		;hookleft   ---   # allowed
	.WORD	 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
	.WORD	 50, 50, 50, 50, 50, 50, 50, 50, 50, 50

	.WORD	0,1,6,1			;hookmax   ---   # ALLOWED CONCURRENT
	.WORD	 10, 10, 10, 10, 10, 10, 10, 20, 20, 20
	.WORD	 20, 20, 20, 20, 20, 20, 20, 20, 20, 20

	.WORD	1,1,20,15		;hookbrain   ---   # TIKS between BRAIN funcs
	.WORD	 15, 15, 15, 15, 13, 13, 13, 13, 10, 10
	.WORD	 12, 12, 12, 12, 12, 10, 10, 10, 10, 10

***	PIMPsters
	.WORD	1,0,50,0		;pimpleft   ---   # allowed
	.WORD	 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
	.WORD	 30, 30, 30, 50, 30, 30, 50, 30, 30, 50

	.WORD	0,1,7,1			;pimpmax   ---   # ALLOWED CONCURRENT
	.WORD	  3,  3,  3,  4,  3,  3,  3,  3,  3,  3
	.WORD	  3,  3,  3,  3,  3,  3,  3,  3,  3,  3

	.WORD	-30,100,500,400		;pimpbuck   ---   CHANCE/1000 OF BUCK
	.WORD	450,450,450,450,450,450,450,450,450,450
	.WORD	450,450,450,450,450,450,450,450,450,450

*** SGT. SKYHIGH DIFFICULTY VARIABLE INIT TABLE
	.WORD	3,0,50,0		;rambleft   ---   # allowed
	.WORD	 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
	.WORD	 20, 22, 24, 26, 28, 30, 32, 34, 36, 28

	.WORD	1,1,6,1			;rambmax   ---   # ALLOWED CONCURRENT
	.WORD	  4,  4,  4,  4,  4,  4,  4,  4,  4,  4
	.WORD	  4,  4,  4,  4,  4,  4,  4,  4,  4,  4

	.WORD	-1,2,12,12		;rambbrain   ---   TICKS BETWEEN DECISIONS
	.WORD	8,8,8,8,8,8,7,7,7,6
	.WORD	6,6,6,6,5,5,5,5,4,4

	.WORD	-30,100,500,400		;rambdrug   ---   CHANCE/K OF DRUG
	.WORD	450,450,380,370,450,350,340,330,320,310
	.WORD	300,300,300,300,300,300,300,300,300,300

	.WORD	-30,100,500,400		;rambclip   ---   CHANCE/K OF CLIP
	.WORD	450,450,380,370,450,350,340,330,320,310
	.WORD	300,300,300,300,300,300,300,300,300,300

*DUMPSTER DUDES
	.WORD	1,0,50,0		;DUMPNUM   ---   # PER WAVE
	.WORD	 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
	.WORD	 30, 30, 30, 30, 30, 30, 30, 30, 30, 30

	.WORD	1,0,20,0		;DUMPMAX   ---   # CONCURRENT
	.WORD	  1,  1,  6, 20,  2,  2,  2,  2,  2,  2
	.WORD	  3,  3,  3,  3,  3,  3,  3,  3,  3,  3
	
	.WORD	1,>100,>400,0		;DUMPSPD   ---   SPEED 
	.WORD	>210,>210,>210,>210,>210,>280,>280,>280,>280,>280
	.WORD	>280,>280,>280,>280,>280,>280,>280,>280,>280,>280

	.WORD	10,0,500,100		;DUMPBTT   ---   HEAD BUTT PROBABILITY
	.WORD	100,200,200,370,360,350,340,330,320,310
	.WORD	300,300,300,300,300,300,300,300,300,300

	.WORD	1,0,>7FFF,>7FFF		;DUMPX   ---   DUMPSTER MAN STARTING X 
	.WORD	2700,2700,2700,2700,2700,2700,2700,2700,2700,2700
	.WORD	2700,2700,2700,2700,2700,2700,2700,2700,2700,2700

	.WORD	5,3,10,3		;DUMPSHT   ---   # OF HIT TO KILL 
	.WORD	 5, 5, 5, 6, 6, 6,10,10,10,10
	.WORD	10,10,10,10,10,10,10,10,10,10

*KINKO THE CLOWN
	.WORD	1,0,40,0		;CLWNUM   ---   # CLOWNS PER WAVE
	.WORD	 30, 30, 30, 30, 34, 30, 30, 36, 30, 30
	.WORD	 38, 30, 30, 38, 30, 30, 38, 30, 30, 83

	.WORD	1,0,5,0			;CLWNMAX   ---   # CONCURRENT CLOWNS
	.WORD	  1,  1,  1,  1,  5,  1,  1,  1,  1,  1
	.WORD	  2,  2,  2,  2,  2,  2,  2,  2,  2,  2
	
	.WORD	1,>100,>400,0		;CLWNSPD   ---   CLOWN SPEED 
	.WORD	>1C0,>1C0,>1C0,>1C0,>1C0,>200,>200,>200,>200,>200
	.WORD	>210,>210,>210,>210,>210,>210,>210,>210,>210,>210

	.WORD	1,0,>7FFF,>7FFF		;CLWNX   ---   CLOWN MAN STARTING X 
	.WORD	1000,1000,1000,1000,1000,1000,1000,1000,1000,1000
	.WORD	1000,1000,1000,1000,1000,1000,1000,1000,1000,1000

	.WORD	5,3,10,3		;CLWNSHT   ---   # OF HIT TO KILL 
	.WORD	 5, 5, 5, 6, 6, 6,10,10,10,10
	.WORD	10,10,10,10,10,10,10,10,10,10

*DAS LOFF VARIABLES
	.WORD	1,1,20,5		;LOFMAX   ---   MAX LOFS ON SCREEN AT ONCE
	.WORD	  8,  8,  8,  8,  8,  8,  8,  8,  8,  8
	.WORD	  8,  8,  8,  8,  8,  8,  8,  8,  8,  8

	.WORD	1,1,1000,50		;LOFFIRE   ---   CHANCE/1K OF FIRING
	.WORD	100,100,100,100,100,100,100,100,100,100
	.WORD	200,200,200,200,200,200,200,200,200,200

*CHOPPER STUFF
	.WORD	1,0,>7FFF,0		;CHOPXST   ---   CHOPPER STARTING X, 0 = NO CHOPPER 
	.WORD	   0,   0,3000,   0,   0,3000,   0,   0,3000,   0
	.WORD	   0,3000,   0,   0,3000,   0,   0,3000,   0,   0

*DOG STUFF
	.WORD	1,1,20,5		;DOGMAX   ---   MAX DOGS ON SCREEN AT ONCE
	.WORD	  8,  8,  8,  8,  8,  8,  8,  8,  8,  8
	.WORD	  8,  8,  8,  8,  8,  8,  8,  8,  8,  8

	.WORD	1,>100,>400,0		;DOGSPD   ---   DOG SPEED 
	.WORD	>300,>300,>300,>300,>300,>300,>300,>300,>300,>300
	.WORD	>300,>300,>300,>300,>300,>300,>300,>300,>300,>300
*
*BUG STUFF
	.WORD	1,0,30,0		;bugleft  ---   # BUGS PER WAVE
	.WORD	 30, 30, 30, 30, 34, 30, 30, 36, 30, 30
	.WORD	 38, 30, 30, 38, 30, 30, 38, 30, 30, 83

	.WORD	1,1,50,5		;bugmax   ---   MAX BUGS ON SCREEN AT ONCE
	.WORD	  7,  7,  7,  7, 10,  7,  7,  7,  7,  7
	.WORD	  7,  7,  7,  7,  7,  7,  7,  7,  7,  7


*
*DIFFICULTY VARIABLES CURRENTLY USED BUT NOT IN THE TABLE
*
	NARCPIMP.ASM
	------------
	.BSS	pimpbrain,16,16 	;U - tiks between brain funcs
	 	;U - chance/1000 of pimp throwing every brain cycle when walking
	.BSS	pimpthr1,16,16
	 	;U - chance/1000 of pimp throwing every brain cycle when hiding
	.BSS	pimpthr2,16,16
	 	;U - each throw chance/1000 of pimp throwing a fast ball
	.BSS	pimpfbal,16,16

	NARCHOOK.ASM
	------------
	.BSS	hookflirt,16,16	;U - tiks between flirt funcs

	NARCMBIG.ASM
	------------
	.BSS	mbigleft,16,16
	.BSS	mbigmax,16,16
	.BSS	mbigbrain,16,16	;U - max sleep between brain funcs
	.BSS	mbigfire,16,16	;U - max sleep between brain funcs
	.BSS	ATTACKTIKS,16,16
	.bss	mbigburst,16,16		;# rounds to a burst

	NARCGANG.ASM
	------------
	.BSS	gangmgun,16,16		;U - (clips*gangmgun)/1000 chance of machine gunning
	.BSS	gangfrck,16,16		;U - (clips*gangmgun)/1000 chance of machine gunning


