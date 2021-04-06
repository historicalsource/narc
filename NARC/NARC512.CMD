/*	NARC linker command file					*/
-e SETUP			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-o NARC512.out			/* specify output file			*/
-m NARC512.map			/* map file				*/
-s				/* Kill the symbol table		*/

NARC.OBJ
NARC1.OBJ
NARC1A.OBJ
NARCBGND.OBJ
NARCBULL.OBJ
NARCLOOT.OBJ
NARC6.OBJ
NARCPIMP.OBJ
NARCGANG.OBJ
NARCHYPO.OBJ
NARCNDLE.OBJ
NARCHOOK.OBJ
NARCDYNA.OBJ
NARCBUG.OBJ
NARCMBIG.OBJ
NARCUTIL.OBJ
NARCMATH.OBJ
NARCMUGS.OBJ
NARCRAMB.OBJ
NARCFLAM.OBJ
NARCHEAD.OBJ
NARCHEDA.OBJ
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
NARCCHOP.OBJ
NARCSCOR.OBJ
NARCRIME.OBJ
NARCDUMP.OBJ
NARCLOWN.OBJ
NARCDOG.OBJ
NARCPAL.OBJ
NARCRAM.OBJ
NARCSND.OBJ
NARCENT.OBJ
NARCSPRY.OBJ
NARCHSTD.OBJ
NARCHELP.OBJ
NARCTEST.OBJ
NARCMENU.OBJ
NARCADJ.OBJ
NARCTEXT.OBJ
NARCANIM.OBJ
NARCDATA.OBJ
NARCDATB.OBJ
NARCBLIP.OBJ
IMGTBL.OBJ
BGNDTBL.OBJ
BGNDPAL.OBJ
\video\MPROC.OBJ		/*MULTI-TASKER*/
\video\NDSP1.OBJ		/*IMAGE HANDLER*/
\video\GSPSND.OBJ		/*SOUND PROCESSOR*/

MEMORY        			/* set up memory for sdb board */
{
 SCRATCH	: org = 0x01000000,	len = 0x100000
 ROM		: org = 0xFF900000,	len = 0x200000 
 ROM1		: org = 0xFFD00000,	len = 0x16E000
 ROM2		: org = 0xFFE6E000,	len = 0x1000
 ROM3		: org = 0xFFE6F000,	len = 0x8000
 TRAP31		: org = 0xFFEFFC00,	len = 0x400 
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
	      } > ROM	

	GROUP:
	      {
	       .data: {}
	       .DATA: {}
		img_tbl: {}
	      } > ROM1	
 }
                                                        
