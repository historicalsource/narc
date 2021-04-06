/* LINKER OPTIONS */

-e POWERUP
-f 0xFFFF			/* fill unspecified memory with value	*/
-o SYSCHECK.out			/* specify output file			*/
-m SYSCHECK.map			/* map file				*/
-s

/* INPUT FILES: DATA */

ROMBOARD.OBJ
CPUBOARD.OBJ
ROMCHIPS.OBJ
RAMCHIPS.OBJ
TVMONITR.OBJ
CONTROLS.OBJ
/*EDITTABL.OBJ*/
/*CMOSTABL.OBJ*/
MISCDATA.OBJ
SYSFONT.OBJ

/* INPUT FILES: CODE */

SYSCHECK.OBJ
ROMCHECK.OBJ
RAMCHECK.OBJ
/*DMACHECK.OBJ*/
TVMCHECK.OBJ
CTLCHECK.OBJ
/*CMOSEDIT.OBJ*/
UTILITIE.OBJ
/*CMOS.OBJ*/

/* CONFIGURE MEMORY */

MEMORY

{

  CRAM00 (RW): org = 0x01800000, len = 0x001000 /* COLOR PALETTE 00   */
  CRAM01 (RW): org = 0x01801000, len = 0x001000 /* COLOR PALETTE 01   */
  CRAM02 (RW): org = 0x01802000, len = 0x001000 /* COLOR PALETTE 02   */
  CRAM03 (RW): org = 0x01803000, len = 0x001000 /* COLOR PALETTE 03   */
  CRAM04 (RW): org = 0x01804000, len = 0x001000 /* COLOR PALETTE 04   */
  CRAM05 (RW): org = 0x01805000, len = 0x001000 /* COLOR PALETTE 05   */
  CRAM06 (RW): org = 0x01806000, len = 0x001000 /* COLOR PALETTE 06   */
  CRAM07 (RW): org = 0x01807000, len = 0x001000 /* COLOR PALETTE 07   */
  CRAM08 (RW): org = 0x01808000, len = 0x001000 /* COLOR PALETTE 08   */
  CRAM09 (RW): org = 0x01809000, len = 0x001000 /* COLOR PALETTE 09   */
  CRAM10 (RW): org = 0x0180A000, len = 0x001000 /* COLOR PALETTE 10   */
  CRAM11 (RW): org = 0x0180B000, len = 0x001000 /* COLOR PALETTE 11   */
  CRAM12 (RW): org = 0x0180C000, len = 0x001000 /* COLOR PALETTE 12   */
  CRAM13 (RW): org = 0x0180D000, len = 0x001000 /* COLOR PALETTE 13   */
  CRAM14 (RW): org = 0x0180E000, len = 0x001000 /* COLOR PALETTE 14   */
  CRAM15 (RW): org = 0x0180F000, len = 0x001000 /* COLOR PALETTE 15   */

  VRAM   (RW): org = 0x00000000, len = 0x200000 /* VIDEO RAM   */ 
  SRAM   (RW): org = 0x010D0000, len = 0x20000 /* SCRATCH RAM */

  VROM   (RX): org = 0xFFFFFC00, len = 0x000400 /* SYSTEM VECTORS */
  PROM   (RX): org = 0xFFF77000, len = 0x1C000  /* PROGRAM ROM */
  IROM    (R): org = 0x02000000, len = 0x800000 /* IMAGE ROM   */

}

/* BUILD OUTPUT SECTIONS */

SECTIONS

{

/* SCRATCH AREAS IN SCRATCHPAD */

  	GROUP: {
	
                .bss: {}
		.BSS: {}

		} > SRAM

/* DIAGNOSTICS CODE */

	GROUP: {
		.text: {}
		.TEXT: {}
		LABELS: {}
		RECTS: {}
		VECTS: {}
		POINTS: {}
		CIRCLES: {}
		CHIPS: {}
		CMOSF: {}
		EDITS: {}
		MISC: {}
		FONT: {}
		} > PROM

}
