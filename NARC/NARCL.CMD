/*	NARC linker command file					*/
-e SETUP			/* entry point of program		*/
-f 0xFFFF			/* fill unspecified memory with value	*/
-m NARCL.map			/* map file				*/
-o NARCL.REL
-r 

NARCENT.OBJ
NARCSPRY.OBJ
NARCHSTD.OBJ
NARCHELP.OBJ
NARCTEST.OBJ
NARCMENU.OBJ
NARCADJ.OBJ

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