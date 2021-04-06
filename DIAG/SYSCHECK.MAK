
#############################################################################
# SYSCHECK: MAKE FILE BUILDS SYSTEM DIAGNOSTICS.                            #
#############################################################################

#       PATHS: PATHS MUST BE ABSOLUTE; DO NOT APPEND TRAILING BACKSLASHES

SRC = C:\gsp\DIAG
GSP = D:\VIDEO
OBJ = C:\gsp\DIAG
EXE = C:\gsp\DIAG

#       OPTIONS

ASO =
LKO =

#       ASSEMBLE DATA TABLES

$(OBJ)\ROMCHIPS.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\ROMCHIPS.MAC \
                     $(SRC)\ROMCHIPS.ASM
                     GSPA $(SRC)\ROMCHIPS $(OBJ)\ROMCHIPS -l

$(OBJ)\RAMCHIPS.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\RAMCHIPS.MAC \
                     $(SRC)\RAMCHIPS.ASM
                     GSPA $(SRC)\RAMCHIPS $(OBJ)\RAMCHIPS -l

$(OBJ)\ROMBOARD.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\ROMBOARD.ASM
                     GSPA $(SRC)\ROMBOARD $(OBJ)\ROMBOARD -l

$(OBJ)\CPUBOARD.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\CPUBOARD.ASM
                     GSPA $(SRC)\CPUBOARD $(OBJ)\CPUBOARD -l

$(OBJ)\TVMONITR.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\TVMONITR.ASM
                     GSPA $(SRC)\TVMONITR $(OBJ)\TVMONITR -l

$(OBJ)\CONTROLS.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\CONTROLS.ASM
                     GSPA $(SRC)\CONTROLS $(OBJ)\CONTROLS -l

$(OBJ)\EDITTABL.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\CMOSTABL.MAC $(SRC)\EDITTABL.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\EDITTABL.ASM
                     GSPA $(SRC)\EDITTABL $(OBJ)\EDITTABL -l

$(OBJ)\CMOSTABL.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\CMOSTABL.MAC \
                     $(SRC)\CMOSTABL.ASM
                     GSPA $(SRC)\CMOSTABL $(OBJ)\CMOSTABL -l

$(OBJ)\MISCDATA.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\MISCDATA.ASM
                     GSPA $(SRC)\MISCDATA $(OBJ)\MISCDATA -l

$(OBJ)\SYSFONT.OBJ:  $(SRC)\SYSFONT.ASM
                     GSPA $(SRC)\SYSFONT $(OBJ)\SYSFONT -l

#       ASSEMBLE CODE MODULES

$(OBJ)\SYSCHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\SYSCHECK.ASM
                     GSPA $(SRC)\SYSCHECK $(OBJ)\SYSCHECK -l

$(OBJ)\ROMCHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\LAYOUT.MAC $(SRC)\ROMCHIPS.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\ROMCHECK.ASM
                     GSPA $(SRC)\ROMCHECK $(OBJ)\ROMCHECK -l

$(OBJ)\RAMCHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\LAYOUT.MAC $(SRC)\RAMCHIPS.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\RAMCHECK.ASM
                     GSPA $(SRC)\RAMCHECK $(OBJ)\RAMCHECK -l

$(OBJ)\TVMCHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\LAYOUT.MAC \
                     $(SRC)\TVMCHECK.ASM
                     GSPA $(SRC)\TVMCHECK $(OBJ)\TVMCHECK -l

$(OBJ)\CTLCHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\UTILITIE.MAC $(SRC)\LAYOUT.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\CTLCHECK.ASM
                     GSPA $(SRC)\CTLCHECK $(OBJ)\CTLCHECK -l

$(OBJ)\DMACHECK.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\DMAGSP.INC $(SRC)\DMASYS.INC \
                     $(SRC)\DMAMACRO.HDR \
                     $(SRC)\DMACHECK.ASM
                     GSPA $(SRC)\DMACHECK $(OBJ)\DMACHECK -l

$(OBJ)\CMOSEDIT.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\CMOSTABL.MAC $(SRC)\EDITTABL.MAC \
                     $(SRC)\UTILITIE.MAC $(SRC)\LAYOUT.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\CMOSEDIT.ASM
                     GSPA $(SRC)\CMOSEDIT $(OBJ)\CMOSEDIT -l

$(OBJ)\CMOS.OBJ:     $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(SRC)\CMOSTABL.MAC $(SRC)\ROMCHIPS.MAC \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\CMOS.ASM
                     GSPA $(SRC)\CMOS $(OBJ)\CMOS -l

$(OBJ)\UTILITIE.OBJ: $(SRC)\SYSCHECK.SET $(SRC)\SYSCHECK.GBL \
                     $(GSP)\GSP.INC $(GSP)\SYS.INC \
                     $(SRC)\UTILITIE.ASM
                     GSPA $(SRC)\UTILITIE $(OBJ)\UTILITIE -l

#       LINK (ABSOLUTE)

:
CD $(OBJ)
GSPLNK -a -o $(EXE)\SYSCHECK.OUT -m $(EXE)\SYSCHECK.MAP $(SRC)\SYSALINK.CMD
CD $(SRC)

#       LINK (RELOCATABLE)

:
CD $(OBJ)
GSPLNK -r -o $(EXE)\SYSCHECK.REL $(SRC)\SYSRLINK.CMD
CD $(SRC)


