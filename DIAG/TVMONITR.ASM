;****************************************************************************
;* TVMONITR.ASM: TV MONITOR; FILE DEFINES DISPLAYS USED TO ADJUST MONITOR   *
;*               CONVERGENCE AND COLOR.                                     *
;****************************************************************************

        .TITLE 'TVMONITR'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

        .include \VIDEO\GSP.INC
        .include \VIDEO\SYS.INC

        .include SYSCHECK.SET
        .include SYSCHECK.GBL

        .include LAYOUT.MAC

;       CONVERGENCE GRID

        .SECT "VECTS"

CONVERGENCE_VECTS:

        VECTOR , WHITE, 004, 004, 507, 004
        VECTOR , WHITE, 004, 395, 507, 395
        VECTOR , WHITE, 004, 004, 004, 395
        VECTOR , WHITE, 507, 004, 507, 395

        VECTOR , WHITE, 055, 004, 055, 396
        VECTOR , WHITE, 056, 004, 056, 396
        VECTOR , WHITE, 111, 004, 111, 396
        VECTOR , WHITE, 167, 004, 167, 396
        VECTOR , WHITE, 168, 004, 168, 396
        VECTOR , WHITE, 223, 004, 223, 396
        VECTOR , WHITE, 287, 004, 287, 396
        VECTOR , WHITE, 288, 004, 288, 396
        VECTOR , WHITE, 343, 004, 343, 396
        VECTOR , WHITE, 399, 004, 399, 396
        VECTOR , WHITE, 400, 004, 400, 396
        VECTOR , WHITE, 455, 004, 455, 396

        VECTOR , WHITE, 004, 056, 508, 056
        VECTOR , WHITE, 004, 113, 508, 113
        VECTOR , WHITE, 004, 114, 508, 114
        VECTOR , WHITE, 004, 170, 508, 170
        VECTOR , WHITE, 004, 228, 508, 228
        VECTOR , WHITE, 004, 229, 508, 229
        VECTOR , WHITE, 004, 285, 508, 285
        VECTOR , WHITE, 004, 342, 508, 342
        VECTOR , WHITE, 004, 343, 508, 343

        VECTOR , GREEN, 223, 002, 287, 002
        VECTOR , GREEN, 223, 398, 287, 398
        VECTOR , GREEN, 002, 170, 002, 228
        VECTOR , GREEN, 509, 170, 509, 228

        VECTOR , GREEN, 223, 003, 287, 003
        VECTOR , GREEN, 223, 397, 287, 397
        VECTOR , GREEN, 003, 170, 003, 228
        VECTOR , GREEN, 508, 170, 508, 228

        VECTOR , BLUE, 006, 199, 506, 199
        VECTOR , BLUE, 255, 005, 255, 394

        VECTOR , RED, 223, 000, 287, 000
        VECTOR , RED, 223, 400, 287, 400
        VECTOR , RED, 000, 170, 000, 228
        VECTOR , RED, 511, 170, 511, 228

        VECTOR , RED, 223, 001, 287, 001
        VECTOR , RED, 223, 399, 287, 399
        VECTOR , RED, 001, 170, 001, 228
        VECTOR , RED, 510, 170, 510, 228

        END_VECT

;       CONVERGENCE DOTS

        .SECT "POINTS"

CONVERGENCE_POINTS:

        POINT , WHITE, 028, 028
        POINT , WHITE, 083, 028
        POINT , WHITE, 139, 028
        POINT , WHITE, 195, 028
        POINT , WHITE, 255, 028
        POINT , WHITE, 315, 028
        POINT , WHITE, 371, 028
        POINT , WHITE, 427, 028
        POINT , WHITE, 483, 028

        POINT , WHITE, 028, 084
        POINT , WHITE, 083, 084
        POINT , WHITE, 139, 084
        POINT , WHITE, 195, 084
        POINT , WHITE, 255, 084
        POINT , WHITE, 315, 084
        POINT , WHITE, 371, 084
        POINT , WHITE, 427, 084
        POINT , WHITE, 483, 084

        POINT , WHITE, 028, 141
        POINT , WHITE, 083, 141
        POINT , WHITE, 139, 141
        POINT , WHITE, 195, 141
        POINT , WHITE, 255, 141
        POINT , WHITE, 315, 141
        POINT , WHITE, 371, 141
        POINT , WHITE, 427, 141
        POINT , WHITE, 483, 141
                         
        POINT , WHITE, 028, 199
        POINT , WHITE, 083, 199
        POINT , WHITE, 139, 199
        POINT , WHITE, 195, 199
        POINT , WHITE, 255, 199
        POINT , WHITE, 315, 199
        POINT , WHITE, 371, 199
        POINT , WHITE, 427, 199
        POINT , WHITE, 483, 199

        POINT , WHITE, 028, 257
        POINT , WHITE, 083, 257
        POINT , WHITE, 139, 257
        POINT , WHITE, 195, 257
        POINT , WHITE, 255, 257
        POINT , WHITE, 315, 257
        POINT , WHITE, 371, 257
        POINT , WHITE, 427, 257
        POINT , WHITE, 483, 257

        POINT , WHITE, 028, 315
        POINT , WHITE, 083, 315
        POINT , WHITE, 139, 315
        POINT , WHITE, 195, 315
        POINT , WHITE, 255, 315
        POINT , WHITE, 315, 315
        POINT , WHITE, 371, 315
        POINT , WHITE, 427, 315
        POINT , WHITE, 483, 315

        POINT , WHITE, 028, 373
        POINT , WHITE, 083, 373
        POINT , WHITE, 139, 373
        POINT , WHITE, 195, 373
        POINT , WHITE, 255, 373
        POINT , WHITE, 315, 373
        POINT , WHITE, 371, 373
        POINT , WHITE, 427, 373
        POINT , WHITE, 483, 373

        END_PNT

        .SECT "RECTS"

PRIMARY_COLORS:

        RECTANGL ,   RED, 512, 400, 0, 0
        RECTANGL , GREEN, 512, 400, 0, 0        
        RECTANGL ,  BLUE, 512, 400, 0, 0

        END_RECT

        .SECT "RECTS"

COLOR_BARS:

        RECTANGL , BLACK, 64, 13,   0, 0
        RECTANGL , BLACK, 64, 13,  64, 0        
        RECTANGL , BLACK, 64, 13, 128, 0
        RECTANGL , BLACK, 64, 13, 192, 0
        RECTANGL , BLACK, 64, 13, 256, 0        
        RECTANGL , BLACK, 64, 13, 320, 0
        RECTANGL , BLACK, 64, 13, 384, 0
        RECTANGL , BLACK, 64, 13, 448, 0

        END_RECT

        .END
