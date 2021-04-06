/*	NARC linker command file					*/
-e SETUP			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o NARC.out			/* specify output file			*/
-m NARC.map			/* map file				*/
-s				/* Kill the symbol table		*/

NARC.OBJ
NARC1.OBJ
NARC1A.OBJ
NARCBGND.OBJ
NARCBULL.OBJ
NARCLOOT.OBJ
NARCCARS.OBJ
NARCCAD.OBJ
NARCPORS.OBJ
NARCMINE.OBJ
NARCDOOR.OBJ
NARCCANS.OBJ
NARCATT.OBJ
NARCOL.OBJ
NARCPLAY.OBJ
NARCMISC.OBJ
NARCPALL.OBJ
NARCSCOR.OBJ
NARCRIME.OBJ
NARCPAL.OBJ
NARCRAM.OBJ
NARCSND.OBJ
NARCTEXT.OBJ
NARCANIM.OBJ
NARCDATA.OBJ
NARCDATB.OBJ
NARCBLIP.OBJ
IMGTBL.OBJ
BGNDTBL.OBJ
BGNDPAL.OBJ
NARCL.REL
NARCE.REL
NARCT.REL
\video\MPROC.OBJ		/*MULTI-TASKER*/
\video\NDSP1.OBJ		/*IMAGE HANDLER*/
\video\GSPSND.OBJ		/*SOUND PROCESSOR*/

MEMORY        			/* set up memory for sdb board */
{
 SCRATCH	: org = 0x01000000,	len = 0x100000
 ROM		: org = 0xFFC00000,	len = 0x33F000 
 ROM2		: org = 0xFFF4F000,	len = 0x1000
 ROM3		: org = 0xFFF50000,	len = 0x10000
 TRAP31		: org = 0xFFFFFC00,	len = 0x400 
}

SECTIONS       /* linker sections directive */
 {
	VECTORS:  {} 	> TRAP31
	POWERON:  {}	> ROM2
	DISPTEXT: {} 	> ROM3
	GROUP:
	      {
		FIXED: {}
		OFIXED: {}
		NFIXED: {}
	       .BSS: {}
	       .bss: {}
		SYSWORK: {}
	      } > SCRATCH

	GROUP:
	      {	
	       .text: {}
	       .TEXT: {}
	       .data: {}
	       .DATA: {}
		img_tbl: {}
		SYSCODE: {}
		SYSDATA: {}
	      } > ROM	

 }
                                                        

