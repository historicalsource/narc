/* LINKER OPTIONS */

/* INPUT FILES: DATA */

ROMBOARD.OBJ
CPUBOARD.OBJ
ROMCHIPS.OBJ
RAMCHIPS.OBJ
TVMONITR.OBJ
CONTROLS.OBJ
EDITTABL.OBJ
CMOSTABL.OBJ
MISCDATA.OBJ
SYSFONT.OBJ

/* INPUT FILES: CODE */

SYSCHECK.OBJ
ROMCHECK.OBJ
RAMCHECK.OBJ
/*DMACHECK.OBJ*/
TVMCHECK.OBJ
CTLCHECK.OBJ
CMOSEDIT.OBJ
UTILITIE.OBJ
CMOS.OBJ

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
  SRAM   (RW): org = 0x01000000, len = 0x100000 /* SCRATCH RAM */

  VROM   (RX): org = 0xFFFFFC00, len = 0x000400 /* SYSTEM VECTORS */
  PROM   (RX): org = 0xFFC00000, len = 0x100000 /* PROGRAM ROM */
  IROM    (R): org = 0x02000000, len = 0x800000 /* IMAGE ROM   */

}

/* BUILD OUTPUT SECTIONS */

SECTIONS

{

/* SCRATCHPAD AREAS */

  SYSWORK: {

                DMACHECK.OBJ(.bss)
                MISCDATA.OBJ(.bss)

           }

/* DIAGNOSTICS CODE */

  SYSCODE: {

               SYSCHECK.OBJ(.text)
               ROMCHECK.OBJ(.text)
               RAMCHECK.OBJ(.text)
               DMACHECK.OBJ(.text)
               TVMCHECK.OBJ(.text)
               CTLCHECK.OBJ(.text)
               CMOSEDIT.OBJ(.text)
               UTILITIE.OBJ(.text)
               CMOS.OBJ(.text)

	   }

/* DATA TABLES ABOVE CODE */

  SYSDATA: {

               ROMBOARD.OBJ(LABELS)
               ROMBOARD.OBJ(RECTS)
               ROMBOARD.OBJ(VECTS)

               CPUBOARD.OBJ(LABELS)
               CPUBOARD.OBJ(RECTS)
               CPUBOARD.OBJ(VECTS)

               TVMONITR.OBJ(POINTS)
               TVMONITR.OBJ(RECTS)
               TVMONITR.OBJ(VECTS)

               CONTROLS.OBJ(CIRCLES)
               CONTROLS.OBJ(LABELS)
               CONTROLS.OBJ(RECTS)

               ROMCHIPS.OBJ(CHIPS)
               RAMCHIPS.OBJ(CHIPS)
               CMOSTABL.OBJ(CMOSF)

               EDITTABL.OBJ(LABELS)
               EDITTABL.OBJ(EDITS)

               MISCDATA.OBJ(MISC)
               SYSFONT.OBJ(FONT)

	   }

}
