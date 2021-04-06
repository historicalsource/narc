**************************************************************************
*                                                                        *
*          NARC (R)                                                      *
*                                                                        *
*          Copyright 1988 Williams Electronics Games Inc.                *
*          All Rights Reserved                                           *
*                                                                        *
**************************************************************************
*                                                                        *
*          THIS MODULE CONTAINS A SPRAY PAINT CHARACTER SET.             *
*                                                                        *
*          THREE ROUTINES MUST BE PROVIDED WITH A CHARACTER SET.         *
*          1)      NUMBER_WIDTH....THE SPACING WIDTH FOR NUMBERS.        *
*                  THIS AMOUNT WILL BE MOVED FROM NUMBER TO NUMBER       *
*                  REGARDLESS OF THE ACTUAL WIDTH OF THE NUMBER.         *
*                  IT IS IN THE SAME UNITS AS THE CHARACTER              *
*                  SET ITSELF.                                           *
*                                                                        *
*          2)      NUMBER_HEIGHT...SAME FACTOR FOR HEIGHT.               *
*                                                                        *
*          3)      FETCH_FIGURE_PTR.  THIS TURNS AN ASCII                *
*                  CHARACTER INTO A "FIGURE SCRIPT" POINTER.             *
*                                                                        *
**************************************************************************
SPRAY_1_TABLE
         .LONG   LET_SPACE
         .LONG   LET_EXPT
         .LONG   LET_DOUBLE_QUOTE
         .LONG   LET_POUND
         .LONG   LET_DOLLAR
         .LONG   LET_PERCENT
         .LONG   LET_AMPERSAND
         .LONG   LET_QUOTE
         .LONG   LET_LEFT_PAREN
         .LONG   LET_RIGHT_PAREN
         .LONG   LET_ASTERISK
         .LONG   LET_PLUS
         .LONG   LET_COMMA
         .LONG   LET_HYPHEN
         .LONG   LET_PERIOD
         .LONG   LET_SLASH
         .LONG   LETTER_0
         .LONG   LETTER_1
         .LONG   LETTER_2
         .LONG   LETTER_3
         .LONG   LETTER_4
         .LONG   LETTER_5
         .LONG   LETTER_6
         .LONG   LETTER_7
         .LONG   LETTER_8
         .LONG   LETTER_9
         .LONG   LET_COLON
         .LONG   LET_SEMI
         .LONG   LET_LESS
         .LONG   LET_EQUAL
         .LONG   LET_GREATER
         .LONG   LET_QUESTION
         .LONG   LET_AT
         .LONG   LETTER_A
         .LONG   LETTER_B
         .LONG   LETTER_C
         .LONG   LETTER_D
         .LONG   LETTER_E
         .LONG   LETTER_F
         .LONG   LETTER_G
         .LONG   LETTER_H
         .LONG   LETTER_I
         .LONG   LETTER_J
         .LONG   LETTER_K
         .LONG   LETTER_L
         .LONG   LETTER_M
         .LONG   LETTER_N
         .LONG   LETTER_O
         .LONG   LETTER_P
         .LONG   LETTER_Q
         .LONG   LETTER_R
         .LONG   LETTER_S
         .LONG   LETTER_T
         .LONG   LETTER_U
         .LONG   LETTER_V
         .LONG   LETTER_W
         .LONG   LETTER_X
         .LONG   LETTER_Y
         .LONG   LETTER_Z
         .LONG   LEFT_BRACKET
         .LONG   LET_BACKSLASH
         .LONG   LET_RIGHT_BRACKET
         .LONG   LET_CARROT
         .LONG   LET_UNDERSCORE

**************************************************************************
*                                                                        *
* LETTER_A                                                               *
*          .WORD   HIDDEN,25,-1                                          *
*          .WORD   19,-89                                                *
*          .WORD   13,-49                                                *
*          .WORD   21,-52                                                *
*          .WORD   10,-30                                                *
*          .WORD   19,69                                                 *
*          .WORD   18,59                                                 *
*          .WORD   7,41                                                  *
*          .WORD   5,28                                                  *
*          .WORD   4,15                                                  *
*          .WORD   5,9                                                   *
*          .WORD   HIDDEN,-114,-95                                       *
*          .WORD   108,1                                                 *
*          .WORD   HIDDEN,7,94                                           *
*          .WORD   HIDDEN,25,-1                                          *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_A
         .WORD   HIDDEN,26,0
         .WORD   HIDDEN,-5,17
         .WORD   20,-67
         .WORD   8,-56
         .WORD   15,-42
         .WORD   27,-59
         .WORD   9,25
         .WORD   10,28
         .WORD   11,45
         .WORD   11,55
         .WORD   7,34
         .WORD   10,21
         .WORD   HIDDEN,-110,-83
         .WORD   103,3
         .WORD   HIDDEN,7,80
         .WORD   HIDDEN,26,1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_B
         .WORD   HIDDEN,26,0
         .WORD   2,-86
         .WORD   2,-61
         .WORD   4,-37
         .WORD   0,-24
         .WORD   -4,-15
         .WORD   HIDDEN,-2,6
         .WORD   21,-1
         .WORD   12,0
         .WORD   18,5
         .WORD   11,5
         .WORD   9,8
         .WORD   8,8
         .WORD   5,4
         .WORD   6,9
         .WORD   4,8
         .WORD   2,12
         .WORD   0,30
         .WORD   -5,10
         .WORD   -7,8
         .WORD   -18,10
         .WORD   -10,6
         .WORD   -23,0
         .WORD   -36,0
         .WORD   10,-1
         .WORD   26,-1
         .WORD   16,1
         .WORD   10,2
         .WORD   13,5
         .WORD   11,8
         .WORD   8,8
         .WORD   4,9
         .WORD   4,11
         .WORD   -1,10
         .WORD   -2,12
         .WORD   -7,10
         .WORD   -10,8
         .WORD   -7,5
         .WORD   -9,4
         .WORD   -9,3
         .WORD   -10,1
         .WORD   -26,0
         .WORD   -4,-1
         .WORD   -10,-7
         .WORD   HIDDEN,97,7
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_C
         .WORD   HIDDEN,26,-1
         .WORD   HIDDEN,110,-153
         .WORD   0,-15
         .WORD   -6,-14
         .WORD   -12,-16
         .WORD   -11,-10
         .WORD   -8,-2
         .WORD   -10,-4
         .WORD   -10,-4
         .WORD   -17,3
         .WORD   -9,3
         .WORD   -4,6
         .WORD   -6,6
         .WORD   -3,9
         .WORD   -4,11
         .WORD   -3,13
         .WORD   -1,12
         .WORD   -3,15
         .WORD   -2,26
         .WORD   -1,13
         .WORD   -1,14
         .WORD   -2,15
         .WORD   1,20
         .WORD   2,7
         .WORD   3,9
         .WORD   11,19
         .WORD   11,8
         .WORD   12,4
         .WORD   12,4
         .WORD   18,0
         .WORD   12,-4
         .WORD   11,-10
         .WORD   6,-7
         .WORD   6,-7
         .WORD   3,-10
         .WORD   5,-13
         .WORD   HIDDEN,0,52
         .WORD   HIDDEN,24,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_D
         .WORD   HIDDEN,24,-1
         .WORD   1,-90
         .WORD   6,-119
         .WORD   15,2
         .WORD   15,6
         .WORD   13,7
         .WORD   13,11
         .WORD   9,10
         .WORD   10,11
         .WORD   8,12
         .WORD   6,12
         .WORD   3,9
         .WORD   4,16
         .WORD   1,12
         .WORD   0,21
         .WORD   -2,15
         .WORD   -3,17
         .WORD   -6,13
         .WORD   -8,13
         .WORD   -10,10
         .WORD   -15,6
         .WORD   -10,5
         .WORD   -15,2
         .WORD   -35,-1
         .WORD   HIDDEN,104,0
         .WORD   HIDDEN,25,2
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_E
         .WORD   HIDDEN,25,-1
         .WORD   HIDDEN,116,-221
         .WORD   -111,4
         .WORD   -1,22
         .WORD   0,21
         .WORD   0,17
         .WORD   -3,22
         .WORD   -1,35
         .WORD   1,100
         .WORD   61,-3
         .WORD   30,-1
         .WORD   19,-2
         .WORD   HIDDEN,-121,-99
         .WORD   70,2
         .WORD   HIDDEN,50,102
         .WORD   HIDDEN,26,-1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_F
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,117,-209
         .WORD   -25,2
         .WORD   -27,1
         .WORD   -20,-4
         .WORD   -39,-1
         .WORD   HIDDEN,-1,-5
         .WORD   -2,101
         .WORD   -2,35
         .WORD   0,80
         .WORD   HIDDEN,-8,-104
         .WORD   65,0
         .WORD   HIDDEN,58,104
         .WORD   HIDDEN,24,-1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_G
         .WORD   HIDDEN,25,-1
         .WORD   HIDDEN,94,-144
         .WORD   0,-31
         .WORD   -7,-14
         .WORD   -8,-8
         .WORD   -10,-4
         .WORD   -13,-3
         .WORD   -14,0
         .WORD   -14,2
         .WORD   -12,7
         .WORD   -6,14
         .WORD   -4,14
         .WORD   -4,14
         .WORD   -3,13
         .WORD   0,11
         .WORD   1,70
         .WORD   5,14
         .WORD   6,9
         .WORD   6,9
         .WORD   8,8
         .WORD   7,5
         .WORD   10,7
         .WORD   9,3
         .WORD   26,0
         .WORD   18,-2
         .WORD   7,-7
         .WORD   3,-16
         .WORD   0,-13
         .WORD   -3,-10
         .WORD   -5,-9
         .WORD   -5,-6
         .WORD   -5,-10
         .WORD   -6,-9
         .WORD   HIDDEN,-34,4
         .WORD   33,-1
         .WORD   23,1
         .WORD   12,-2
         .WORD   5,-1
         .WORD   HIDDEN,0,86
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
**************************************************************************
*                                                                        *
* LETTER_H                                                               *
*          .WORD   HIDDEN,25,0                                           *
*          .WORD   HIDDEN,-1,-217                                        *
*          .WORD   1,217                                                 *
*          .WORD   HIDDEN,102,-218                                       *
*          .WORD   -1,55                                                 *
*          .WORD   2,7                                                   *
*          .WORD   9,155                                                 *
*          .WORD   HIDDEN,-120,-101                                      *
*          .WORD   120,-1                                                *
*          .WORD   HIDDEN,0,102                                          *
*          .WORD   HIDDEN,25,1                                           *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_H
         .WORD   HIDDEN,26,-1
         .WORD   HIDDEN,0,-222
         .WORD   0,231
         .WORD   HIDDEN,-7,-112
         .WORD   125,0
         .WORD   HIDDEN,-13,-122
         .WORD   1,233
         .WORD   HIDDEN,-6,-8
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_I
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,3,-213
         .WORD   110,0
         .WORD   HIDDEN,-56,-3
         .WORD   -2,226
         .WORD   HIDDEN,-55,-10
         .WORD   114,3
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_J
         .WORD   HIDDEN,27,-2
         .WORD   HIDDEN,69,-216
         .WORD   -1,36
         .WORD   -1,30
         .WORD   -2,62
         .WORD   -1,18
         .WORD   -2,17
         .WORD   -3,15
         .WORD   -4,18
         .WORD   -7,12
         .WORD   -13,7
         .WORD   -22,1
         .WORD   -9,-20
         .WORD   -7,-16
         .WORD   -1,-7
         .WORD   -1,-21
         .WORD   HIDDEN,16,-154
         .WORD   110,0
         .WORD   HIDDEN,4,219
         .WORD   HIDDEN,25,1
         .word   END_OF_FIGURE
*
*** New Character
*
**************************************************************************
*                                                                        *
* LETTER_K                                                               *
*          .WORD   HIDDEN,25,-1                                          *
*          .WORD   HIDDEN,0,-225                                         *
*          .WORD   0,226                                                 *
*          .WORD   HIDDEN,98,-201                                        *
*          .WORD   -17,19                                                *
*          .WORD   -11,17                                                *
*          .WORD   -12,17                                                *
*          .WORD   -8,14                                                 *
*          .WORD   -12,15                                                *
*          .WORD   -11,13                                                *
*          .WORD   -27,24                                                *
*          .WORD   HIDDEN,39,-38                                         *
*          .WORD   8,11                                                  *
*          .WORD   4,8                                                   *
*          .WORD   2,8                                                   *
*          .WORD   2,11                                                  *
*          .WORD   3,14                                                  *
*          .WORD   5,12                                                  *
*          .WORD   7,14                                                  *
*          .WORD   7,16                                                  *
*          .WORD   8,17                                                  *
*          .WORD   12,28                                                 *
*          .WORD   HIDDEN,1,-21                                          *
*          .WORD   HIDDEN,24,-1                                          *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_K
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,1,-225
         .WORD   1,241
         .WORD   HIDDEN,108,-217
         .WORD   -22,19
         .WORD   -24,31
         .WORD   -30,42
         .WORD   -40,41
         .WORD   HIDDEN,47,-34
         .WORD   6,7
         .WORD   4,10
         .WORD   4,17
         .WORD   10,25
         .WORD   13,32
         .WORD   13,31
         .WORD   HIDDEN,12,-18
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
**************************************************************************
*                                                                        *
* LETTER_L                                                               *
*          .WORD   HIDDEN,25,0                                           *
*          .WORD   HIDDEN,1,-219                                         *
*          .WORD   -2,220                                                *
*          .WORD   106,-1                                                *
*          .WORD   HIDDEN,24,0                                           *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_L
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,2,-228
         .WORD   0,235
         .WORD   HIDDEN,-2,-7
         .WORD   117,0
         .WORD   HIDDEN,-2,0
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_M
         .WORD   HIDDEN,25,1
         .WORD   2,-87
         .WORD   2,-137
         .WORD   13,10
         .WORD   8,11
         .WORD   14,25
         .WORD   11,23
         .WORD   7,18
         .WORD   7,16
         .WORD   8,-9
         .WORD   8,-13
         .WORD   22,-43
         .WORD   17,-27
         .WORD   8,1
         .WORD   3,51
         .WORD   1,74
         .WORD   5,90
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_N
         .WORD   HIDDEN,25,0
         .WORD   -2,-190
         .WORD   5,-24
         .WORD   11,14
         .WORD   4,15
         .WORD   4,14
         .WORD   6,21
         .WORD   14,27
         .WORD   6,10
         .WORD   12,25
         .WORD   18,25
         .WORD   13,16
         .WORD   9,20
         .WORD   5,13
         .WORD   6,11
         .WORD   -8,-60
         .WORD   2,-23
         .WORD   1,-17
         .WORD   -1,-118
         .WORD   HIDDEN,7,218
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_0
LETTER_O
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,61,-218
         .WORD   11,1
         .WORD   13,4
         .WORD   13,10
         .WORD   8,12
         .WORD   4,11
         .WORD   3,14
         .WORD   0,18
         .WORD   1,25
         .WORD   1,28
         .WORD   -2,31
         .WORD   -5,27
         .WORD   -9,23
         .WORD   -12,11
         .WORD   -11,4
         .WORD   -15,0
         .WORD   -14,-4
         .WORD   -12,-5
         .WORD   -12,-10
         .WORD   -7,-12
         .WORD   -6,-15
         .WORD   -3,-15
         .WORD   -1,-16
         .WORD   -3,-19
         .WORD   0,-21
         .WORD   -2,-20
         .WORD   5,-22
         .WORD   3,-18
         .WORD   6,-16
         .WORD   6,-10
         .WORD   9,-8
         .WORD   13,-3
         .WORD   12,-3
         .WORD   8,0
         .WORD   7,0
         .WORD   HIDDEN,46,216
         .WORD   HIDDEN,45,0
         .word   END_OF_FIGURE
*
*** New Character
*
**************************************************************************
*                                                                        *
* LETTER_P                                                               *
*          .WORD   HIDDEN,26,-1                                          *
*          .WORD   1,-217                                                *
*          .WORD   25,0                                                  *
*          .WORD   15,0                                                  *
*          .WORD   11,3                                                  *
*          .WORD   10,5                                                  *
*          .WORD   12,7                                                  *
*          .WORD   10,7                                                  *
*          .WORD   6,10                                                  *
*          .WORD   4,17                                                  *
*          .WORD   3,14                                                  *
*          .WORD   -1,13                                                 *
*          .WORD   -5,14                                                 *
*          .WORD   -9,13                                                 *
*          .WORD   -9,4                                                  *
*          .WORD   -12,7                                                 *
*          .WORD   -13,5                                                 *
*          .WORD   -17,2                                                 *
*          .WORD   -22,-2                                                *
*          .WORD   -20,-1                                                *
*          .WORD   HIDDEN,111,102                                        *
*          .WORD   HIDDEN,25,0                                           *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
*                                                                        *
**************************************************************************
LETTER_P
         .WORD   HIDDEN,35,0
         .WORD   HIDDEN,2,-209
         .WORD   0,227
         .WORD   HIDDEN,-10,-225
         .WORD   18,0
         .WORD   23,0
         .WORD   12,-1
         .WORD   15,7
         .WORD   10,6
         .WORD   12,8
         .WORD   11,11
         .WORD   4,14
         .WORD   3,13
         .WORD   2,17
         .WORD   -7,15
         .WORD   -11,11
         .WORD   -13,11
         .WORD   -12,4
         .WORD   -12,4
         .WORD   -14,1
         .WORD   -16,0
         .WORD   -24,-1
         .WORD   HIDDEN,114,89
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_Q
         .WORD   HIDDEN,24,0
         .WORD   HIDDEN,68,-225
         .WORD   11,2
         .WORD   10,4
         .WORD   8,7
         .WORD   5,7
         .WORD   3,12
         .WORD   3,11
         .WORD   1,16
         .WORD   2,24
         .WORD   -1,14
         .WORD   -1,57
         .WORD   -2,13
         .WORD   -3,13
         .WORD   -5,15
         .WORD   -3,10
         .WORD   -5,7
         .WORD   -8,6
         .WORD   -8,3
         .WORD   -6,0
         .WORD   -9,-1
         .WORD   -11,0
         .WORD   -10,-4
         .WORD   -8,-4
         .WORD   -10,-9
         .WORD   -8,-11
         .WORD   -4,-9
         .WORD   -4,-13
         .WORD   -2,-13
         .WORD   -1,-18
         .WORD   -2,-17
         .WORD   -1,-17
         .WORD   1,-18
         .WORD   2,-12
         .WORD   2,-14
         .WORD   3,-13
         .WORD   3,-11
         .WORD   2,-11
         .WORD   5,-9
         .WORD   6,-5
         .WORD   9,-7
         .WORD   10,-3
         .WORD   10,-1
         .WORD   17,0
         .WORD   HIDDEN,4,160
         .WORD   59,78
         .WORD   -10,-12
         .WORD   HIDDEN,25,-1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_R
         .WORD   HIDDEN,26,-1
         .WORD   HIDDEN,7,-215
         .WORD   -2,215
         .WORD   HIDDEN,-5,-217
         .WORD   23,-1
         .WORD   32,0
         .WORD   22,-1
         .WORD   10,4
         .WORD   5,1
         .WORD   5,4
         .WORD   4,7
         .WORD   3,5
         .WORD   2,7
         .WORD   0,55
         .WORD   -4,7
         .WORD   -5,5
         .WORD   -8,4
         .WORD   -5,4
         .WORD   -5,2
         .WORD   -5,4
         .WORD   -9,5
         .WORD   -7,1
         .WORD   -8,2
         .WORD   -6,3
         .WORD   -49,-3
         .WORD   24,2
         .WORD   8,-1
         .WORD   10,-1
         .WORD   12,2
         .WORD   7,4
         .WORD   8,4
         .WORD   7,5
         .WORD   6,5
         .WORD   5,5
         .WORD   6,7
         .WORD   4,10
         .WORD   3,13
         .WORD   3,13
         .WORD   0,10
         .WORD   0,9
         .WORD   1,8
         .WORD   0,7
         .WORD   0,1
         .WORD   HIDDEN,9,-3
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_S
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,107,-158
         .WORD   2,-17
         .WORD   -1,-8
         .WORD   -5,-9
         .WORD   -9,-13
         .WORD   -8,-8
         .WORD   -10,-5
         .WORD   -10,-2
         .WORD   -13,-3
         .WORD   -12,0
         .WORD   -9,4
         .WORD   -9,11
         .WORD   -7,13
         .WORD   -5,11
         .WORD   -4,12
         .WORD   -3,12
         .WORD   0,12
         .WORD   7,7
         .WORD   7,6
         .WORD   15,11
         .WORD   14,9
         .WORD   13,7
         .WORD   14,10
         .WORD   11,8
         .WORD   8,9
         .WORD   7,9
         .WORD   4,10
         .WORD   2,11
         .WORD   -2,13
         .WORD   -3,11
         .WORD   -5,11
         .WORD   -7,6
         .WORD   -6,6
         .WORD   -6,3
         .WORD   -30,-1
         .WORD   -9,-6
         .WORD   -3,-3
         .WORD   -4,-4
         .WORD   -5,-2
         .WORD   -8,-3
         .WORD   -6,-7
         .WORD   -5,-4
         .WORD   -4,-8
         .WORD   -2,-9
         .WORD   -2,-7
         .WORD   0,-6
         .WORD   0,-7
         .WORD   HIDDEN,110,68
         .WORD   HIDDEN,25,-1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_T
*
*** New Character
*
         .WORD   HIDDEN,26,0
         .WORD   HIDDEN,-10,-220
         .WORD   153,0
         .WORD   HIDDEN,-73,0
         .WORD   0,213
         .WORD   HIDDEN,71,8
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
**************************************************************************
*                                                                        *
*                                                                        *
*          .WORD   HIDDEN,26,0                                           *
*          .WORD   HIDDEN,57,-224                                        *
*          .WORD   1,229                                                 *
*          .WORD   HIDDEN,-63,-221                                       *
*          .WORD   120,-1                                                *
*          .WORD   HIDDEN,-3,220                                         *
*          .WORD   HIDDEN,25,1                                           *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_U
         .WORD   HIDDEN,24,0
         .WORD   HIDDEN,0,-227
         .WORD   -1,179
         .WORD   0,4
         .WORD   4,6
         .WORD   14,14
         .WORD   7,4
         .WORD   14,10
         .WORD   11,4
         .WORD   20,1
         .WORD   7,-5
         .WORD   8,-8
         .WORD   6,-12
         .WORD   5,-13
         .WORD   3,-9
         .WORD   3,-14
         .WORD   0,-155
         .WORD   HIDDEN,2,219
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_V
         .WORD   HIDDEN,27,-1
         .WORD   HIDDEN,-4,-222
         .WORD   3,5
         .WORD   3,9
         .WORD   5,13
         .WORD   8,23
         .WORD   5,13
         .WORD   5,20
         .WORD   6,27
         .WORD   5,25
         .WORD   5,24
         .WORD   4,14
         .WORD   7,15
         .WORD   0,16
         .WORD   1,16
         .WORD   -1,3
         .WORD   2,-14
         .WORD   1,-15
         .WORD   3,-11
         .WORD   3,-18
         .WORD   2,-13
         .WORD   5,-18
         .WORD   5,-13
         .WORD   6,-21
         .WORD   4,-16
         .WORD   5,-16
         .WORD   6,-17
         .WORD   4,-13
         .WORD   5,-15
         .WORD   4,-14
         .WORD   3,-11
         .WORD   0,-7
         .WORD   HIDDEN,1,230
         .WORD   HIDDEN,25,1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_W
         .WORD   HIDDEN,25,-1
         .WORD   HIDDEN,0,-226
         .WORD   0,227
         .WORD   14,-23
         .WORD   9,-14
         .WORD   8,-15
         .WORD   8,-13
         .WORD   7,-15
         .WORD   13,-23
         .WORD   11,11
         .WORD   11,17
         .WORD   10,20
         .WORD   11,21
         .WORD   18,31
         .WORD   0,-223
         .WORD   HIDDEN,1,222
         .WORD   HIDDEN,23,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_X
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,3,-230
         .WORD   8,14
         .WORD   6,12
         .WORD   10,21
         .WORD   10,23
         .WORD   7,20
         .WORD   6,18
         .WORD   9,25
         .WORD   6,18
         .WORD   7,17
         .WORD   10,18
         .WORD   13,14
         .WORD   12,14
         .WORD   13,14
         .WORD   HIDDEN,3,-231
         .WORD   -8,13
         .WORD   -23,36
         .WORD   -10,18
         .WORD   -7,17
         .WORD   -11,19
         .WORD   -10,16
         .WORD   -9,19
         .WORD   -8,14
         .WORD   -8,17
         .WORD   -11,24
         .WORD   -9,16
         .WORD   -6,17
         .WORD   -3,7
         .WORD   HIDDEN,122,-2
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_Y
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,-10,-213
         .WORD   66,116
         .WORD   7,13
         .WORD   0,97
         .WORD   HIDDEN,69,-222
         .WORD   -75,112
         .WORD   HIDDEN,70,99
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_Z
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,-1,-217
         .WORD   122,2
         .WORD   -10,27
         .WORD   -17,32
         .WORD   -25,33
         .WORD   -16,30
         .WORD   -29,41
         .WORD   -25,52
         .WORD   121,1
         .WORD   HIDDEN,26,-1
         .word   END_OF_FIGURE

**************************************************************************
*                                                                        *
*          .WORD   HIDDEN,26,0                                           *
*          .WORD   HIDDEN,70,-221                                        *
*          .WORD   9,1                                                   *
*          .WORD   4,1                                                   *
*          .WORD   9,4                                                   *
*          .WORD   5,5                                                   *
*          .WORD   6,10                                                  *
*          .WORD   6,21                                                  *
*          .WORD   3,15                                                  *
*          .WORD   1,21                                                  *
*          .WORD   -1,18                                                 *
*          .WORD   -1,51                                                 *
*          .WORD   -1,13                                                 *
*          .WORD   -2,10                                                 *
*          .WORD   -4,13                                                 *
*          .WORD   -4,14                                                 *
*          .WORD   -5,9                                                  *
*          .WORD   -7,8                                                  *
*          .WORD   -8,4                                                  *
*          .WORD   -8,2                                                  *
*          .WORD   -11,-1                                                *
*          .WORD   -12,-1                                                *
*          .WORD   -10,-3                                                *
*          .WORD   -9,-5                                                 *
*          .WORD   -10,-7                                                *
*          .WORD   -6,-11                                                *
*          .WORD   -4,-10                                                *
*          .WORD   -6,-16                                                *
*          .WORD   0,-16                                                 *
*          .WORD   -3,-17                                                *
*          .WORD   -1,-29                                                *
*          .WORD   0,-17                                                 *
*          .WORD   2,-19                                                 *
*          .WORD   4,-15                                                 *
*          .WORD   4,-14                                                 *
*          .WORD   4,-14                                                 *
*          .WORD   6,-12                                                 *
*          .WORD   12,-7                                                 *
*          .WORD   8,-4                                                  *
*          .WORD   16,-2                                                 *
*          .WORD   14,-1                                                 *
*          .WORD   5,0                                                   *
*          .WORD   HIDDEN,48,222                                         *
*          .WORD   HIDDEN,25,0                                           *
*          .word   END_OF_FIGURE                                         *
*                                                                        *
**************************************************************************
*
*** New Character
*
LETTER_1
         .WORD   HIDDEN,26,-1
         .WORD   HIDDEN,16,-174
         .WORD   39,-46
         .WORD   2,220
         .WORD   HIDDEN,-58,1
         .WORD   108,-1
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_2
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,1,-168
         .WORD   9,-17
         .WORD   9,-8
         .WORD   13,-9
         .WORD   16,-9
         .WORD   18,-6
         .WORD   14,2
         .WORD   12,12
         .WORD   8,8
         .WORD   5,14
         .WORD   5,25
         .WORD   -1,30
         .WORD   -9,19
         .WORD   -10,12
         .WORD   -13,8
         .WORD   -16,13
         .WORD   -14,11
         .WORD   -12,14
         .WORD   -17,18
         .WORD   -12,14
         .WORD   -6,11
         .WORD   -2,6
         .WORD   120,1
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_3
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,1,-175
         .WORD   2,-12
         .WORD   6,-15
         .WORD   7,-6
         .WORD   15,-6
         .WORD   11,-4
         .WORD   36,1
         .WORD   8,4
         .WORD   6,6
         .WORD   6,8
         .WORD   4,12
         .WORD   4,12
         .WORD   3,11
         .WORD   2,10
         .WORD   0,12
         .WORD   0,8
         .WORD   -7,9
         .WORD   -7,6
         .WORD   -10,8
         .WORD   -8,1
         .WORD   -11,1
         .WORD   -11,-1
         .WORD   9,0
         .WORD   10,-1
         .WORD   13,2
         .WORD   7,3
         .WORD   3,7
         .WORD   6,13
         .WORD   3,12
         .WORD   1,12
         .WORD   0,14
         .WORD   -2,15
         .WORD   -4,13
         .WORD   -7,12
         .WORD   -7,5
         .WORD   -10,3
         .WORD   -10,2
         .WORD   -8,-2
         .WORD   -10,0
         .WORD   -9,-2
         .WORD   -8,0
         .WORD   -9,-3
         .WORD   -8,-2
         .WORD   -9,-4
         .WORD   -3,-4
         .WORD   -3,-5
         .WORD   -3,-13
         .WORD   HIDDEN,115,30
         .WORD   HIDDEN,25,1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_4
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,2,-226
         .WORD   -2,108
         .WORD   112,6
         .WORD   HIDDEN,-35,-119
         .WORD   2,233
         .WORD   HIDDEN,35,-2
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_5
         .WORD   HIDDEN,24,0
         .WORD   HIDDEN,112,-215
         .WORD   -109,0
         .WORD   -2,100
         .WORD   12,-7
         .WORD   15,-2
         .WORD   20,-1
         .WORD   15,3
         .WORD   14,8
         .WORD   14,15
         .WORD   11,16
         .WORD   3,20
         .WORD   3,21
         .WORD   0,20
         .WORD   -7,12
         .WORD   -6,6
         .WORD   -12,3
         .WORD   -13,1
         .WORD   -15,-1
         .WORD   -17,-4
         .WORD   -11,-3
         .WORD   -11,-7
         .WORD   -10,-8
         .WORD   -5,-11
         .WORD   -3,-10
         .WORD   HIDDEN,113,44
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_6
         .WORD   HIDDEN,25,0
         .WORD   HIDDEN,113,-166
         .WORD   0,-13
         .WORD   0,-6
         .WORD   -4,-8
         .WORD   -9,-9
         .WORD   -12,-7
         .WORD   -15,-7
         .WORD   -15,-3
         .WORD   -10,-1
         .WORD   -10,3
         .WORD   -9,5
         .WORD   -8,9
         .WORD   -3,11
         .WORD   -7,13
         .WORD   -5,19
         .WORD   -4,17
         .WORD   -2,13
         .WORD   1,18
         .WORD   0,23
         .WORD   2,18
         .WORD   0,20
         .WORD   2,18
         .WORD   3,11
         .WORD   11,8
         .WORD   10,7
         .WORD   9,3
         .WORD   13,3
         .WORD   13,1
         .WORD   17,1
         .WORD   17,-10
         .WORD   7,-9
         .WORD   5,-11
         .WORD   3,-14
         .WORD   1,-12
         .WORD   0,-10
         .WORD   -5,-11
         .WORD   -11,-11
         .WORD   -9,-5
         .WORD   -13,-7
         .WORD   -10,0
         .WORD   -11,2
         .WORD   -11,5
         .WORD   -10,3
         .WORD   -10,5
         .WORD   -9,8
         .WORD   -8,6
         .WORD   HIDDEN,109,70
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_7
**************************************************************************
*                                                                        *
*          .WORD   HIDDEN,25,0                                           *
*          .WORD   HIDDEN,-3,-220                                        *
*          .WORD   110,0                                                 *
*          .WORD   -31,55                                                *
*          .WORD   -13,25                                                *
*          .WORD   -11,22                                                *
*          .WORD   -11,28                                                *
*          .WORD   -12,30                                                *
*          .WORD   -12,30                                                *
*          .WORD   -2,10                                                 *
*          .WORD   -6,24                                                 *
*          .WORD   HIDDEN,99,-3                                          *
*          .WORD   HIDDEN,25,0                                           *
*                                                                        *
**************************************************************************
         .WORD   HIDDEN,5,0
         .WORD   HIDDEN,0,-215
         .WORD   138,0
         .WORD   -5,11
         .WORD   -22,44
         .WORD   -14,26
         .WORD   -13,30
         .WORD   -14,29
         .WORD   -13,38
         .WORD   -11,30
         .WORD   -3,14
         .WORD   HIDDEN,100,-1
         .WORD   HIDDEN,35,1
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_8
         .WORD   HIDDEN,26,0
         .WORD   HIDDEN,60,-218
         .WORD   6,1
         .WORD   11,3
         .WORD   10,4
         .WORD   9,8
         .WORD   8,22
         .WORD   0,6
         .WORD   0,12
         .WORD   -1,13
         .WORD   -3,14
         .WORD   -8,13
         .WORD   -8,7
         .WORD   -12,5
         .WORD   -13,2
         .WORD   -8,2
         .WORD   -12,2
         .WORD   -13,7
         .WORD   -9,11
         .WORD   -6,13
         .WORD   -3,11
         .WORD   1,18
         .WORD   2,10
         .WORD   5,12
         .WORD   6,10
         .WORD   7,4
         .WORD   8,4
         .WORD   8,2
         .WORD   9,1
         .WORD   24,0
         .WORD   9,-4
         .WORD   7,-4
         .WORD   4,-4
         .WORD   4,-4
         .WORD   2,-7
         .WORD   2,-7
         .WORD   0,-28
         .WORD   -2,-6
         .WORD   -5,-10
         .WORD   -2,-7
         .WORD   -5,-7
         .WORD   -5,-5
         .WORD   -7,-5
         .WORD   -9,-3
         .WORD   -10,-3
         .WORD   -12,-3
         .WORD   -24,-8
         .WORD   -9,-8
         .WORD   -7,-8
         .WORD   -7,-11
         .WORD   -1,-12
         .WORD   0,-9
         .WORD   5,-11
         .WORD   6,-11
         .WORD   7,-10
         .WORD   8,-8
         .WORD   9,-6
         .WORD   10,-4
         .WORD   4,-1
         .WORD   7,-2
         .WORD   4,0
         .WORD   HIDDEN,48,217
         .WORD   HIDDEN,25,0
         .word   END_OF_FIGURE
*
*** New Character
*
LETTER_9
         .WORD   HIDDEN,24,0
         .WORD   HIDDEN,104,-196
         .WORD   -5,-9
         .WORD   -11,-8
         .WORD   -14,-5
         .WORD   -15,-2
         .WORD   -15,-1
         .WORD   -18,7
         .WORD   -12,5
         .WORD   -8,10
         .WORD   -3,11
         .WORD   -2,17
         .WORD   0,13
         .WORD   8,12
         .WORD   7,8
         .WORD   11,5
         .WORD   15,5
         .WORD   11,0
         .WORD   15,2
         .WORD   6,1
         .WORD   9,-5
         .WORD   8,-6
         .WORD   6,-6
         .WORD   4,-10
         .WORD   1,-12
         .WORD   0,-34
         .WORD   0,199
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE
*
*** New Character
*
LET_COMMA
         .WORD   HIDDEN,35,4
         .WORD   -3,2
         .WORD   -4,1
         .WORD   -3,-1
         .WORD   -4,-3
         .WORD   0,-4
         .WORD   2,-3
         .WORD   2,-4
         .WORD   5,0
         .WORD   4,2
         .WORD   2,3
         .WORD   1,5
         .WORD   -2,7
         .WORD   -2,5
         .WORD   -14,25
         .WORD   HIDDEN,28,-39
         .word   END_OF_FIGURE

LET_SPACE
*
*** New Character
*
         .WORD   HIDDEN,130,0
         .word   END_OF_FIGURE
*
*** New Character
*
LET_RIGHT_PAREN
         .WORD   HIDDEN,24,0
         .WORD   HIDDEN,34,-229
         .WORD   8,8
         .WORD   8,8
         .WORD   8,10
         .WORD   7,12
         .WORD   7,13
         .WORD   4,15
         .WORD   5,24
         .WORD   3,26
         .WORD   1,15
         .WORD   2,15
         .WORD   0,25
         .WORD   -2,14
         .WORD   -3,12
         .WORD   -7,17
         .WORD   -5,9
         .WORD   -8,13
         .WORD   -7,9
         .WORD   -8,8
         .WORD   HIDDEN,43,-24
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE

LET_QUOTE
*
*** New Character
*
         .WORD   HIDDEN,25,1
         .WORD   HIDDEN,27,-184
         .WORD   -4,-2
         .WORD   -2,-5
         .WORD   3,-3
         .WORD   5,-2
         .WORD   5,0
         .WORD   3,3
         .WORD   1,5
         .WORD   -4,3
         .WORD   HIDDEN,8,1
         .WORD   0,8
         .WORD   -1,11
         .WORD   -4,12
         .WORD   HIDDEN,32,151
         .WORD   HIDDEN,25,1
         .word   END_OF_FIGURE

*
*** New Character
*
LET_UNDERSCORE
         .WORD   HIDDEN,26,0
*         .WORD   HIDDEN,0,45
         .WORD   123,0
*         .WORD   HIDDEN,0,-45
         .WORD   HIDDEN,26,0
         .word   END_OF_FIGURE

*
*        THE FOLLOWING LIST ARE THE CURRENTLY UNDEFINED
*        SYMBOLS THAT FALL IN THE ASCII RANGE FROM
*        SPACE ($20) TO CAPITAL Z ($5A)
*
LET_EXPT
LET_DOUBLE_QUOTE
LET_POUND
LET_DOLLAR
LET_PERCENT
LET_AMPERSAND
LET_LEFT_PAREN
LET_ASTERISK
LET_PLUS
LET_HYPHEN
LET_PERIOD
LET_SLASH
LET_COLON
LET_SEMI
LET_LESS
LET_EQUAL
LET_GREATER
LET_QUESTION
LET_AT
LEFT_BRACKET
LET_BACKSLASH
LET_RIGHT_BRACKET
LET_CARROT
         .word   END_OF_FIGURE
