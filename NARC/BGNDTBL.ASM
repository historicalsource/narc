	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA

SKYHDRS:
	.word	96,94	;x size, y size
	.long	>0		;anim
	.long	>37258A0	;address
	.word	120,78
	.long	>0,>37372A0
	.word	124,66
	.long	>0,>3749720
	.word	52,33
	.long	>0,>37596E0
	.word	112,85
	.long	>0,>375CC80
	.word	92,87
	.long	>0,>376F600
	.word	88,81
	.long	>0,>377F020
	.word	112,85
	.long	>0,>375CC80
	.word	52,35
	.long	>0,>378CEE0
	.word	120,78
	.long	>0,>37372A0
	.word	64,72
	.long	>0,>37907C0


SKY1BLKS:
	.word	>4040	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4041,233,28,>6
	.word	>4041,519,61,>9
	.word	>4040,824,7,>F
	.word	>4050,912,7,>F
	.word	>4040,1341,9,>15
	.word	>4040,1646,16,>1B
	.word	0FFFFH	;End Marker

SKY2BLKS:
	.word	>4040	;flags
	.word	0,7 ;x,y
	.word	>3	;pal5,pal4,hdr13-0
	.word	>4040,479,0,>C
	.word	>4040,1043,4,>12
	.word	>4040,1444,50,>18
	.word	>4040,1568,13,>1E
	.word	0FFFFH	;End Marker

SKYMOD0BLKS:
	.word	0FFFFH		;End Marker
SKY1BMOD:
	.word	1766,94,7	;x size, y size, #blocks
	.long	SKY1BLKS, SKYHDRS, SKYPALS
SKY2BMOD:
	.word	1632,85,5	;x size, y size, #blocks
	.long	SKY2BLKS, SKYHDRS, SKYPALS

DEMOHDRS:
	.word	60,44	;x size, y size
	.long	>0		;anim
	.long	>37997C0	;address
	.word	60,17
	.long	>0,>379EA40
	.word	60,150
	.long	>0,>37A0A20
	.word	60,92
	.long	>0,>37B2360
	.word	20,147
	.long	>0,>37BCFE0
	.word	60,36
	.long	>0,>37C2BC0
	.word	60,36
	.long	>0,>37C6F40
	.word	60,72
	.long	>0,>37CB2C0
	.word	60,30
	.long	>0,>37D39C0
	.word	32,61
	.long	>0,>37D7200
	.word	60,150
	.long	>0,>37DAF00
	.word	132,29
	.long	>0,>37EC840
	.word	120,30
	.long	>0,>37F3FE0
	.word	32,32
	.long	>0,>37FB060
	.word	60,4
	.long	>0,>37FD060
	.word	32,84
	.long	>0,>37FD7E0
	.word	40,144
	.long	>0,>3802BE0
	.word	60,72
	.long	>0,>380DFE0
	.word	60,44
	.long	>0,>38166E0
	.word	100,10
	.long	>0,>381B960
	.word	60,44
	.long	>0,>381D8A0
	.word	100,134
	.long	>0,>3822B20
	.word	60,44
	.long	>0,>383CDE0
	.word	60,20
	.long	>0,>3842060
	.word	40,45
	.long	>0,>38445E0
	.word	120,25
	.long	>0,>3847E20
	.word	60,65
	.long	>0,>384DBE0
	.word	12,139
	.long	>0,>38555C0
	.word	40,107
	.long	>0,>38589E0
	.word	156,32
	.long	>0,>3860FA0
	.word	132,30
	.long	>0,>386ABA0
	.word	20,45
	.long	>0,>3872760
	.word	20,107
	.long	>0,>3874380
	.word	36,2
	.long	>0,>3878660
	.word	36,88
	.long	>0,>38788A0
	.word	36,17
	.long	>0,>387EBA0
	.word	16,38
	.long	>0,>387FEC0
	.word	44,38
	.long	>0,>38811C0
	.word	68,15
	.long	>0,>3884600
	.word	48,33
	.long	>0,>38865E0
	.word	24,100
	.long	>0,>3889760
	.word	24,38
	.long	>0,>388E260
	.word	176,33
	.long	>0,>388FEE0
	.word	136,15
	.long	>0,>389B460
	.word	108,17
	.long	>0,>389F420
	.word	16,138
	.long	>0,>38A2D80
	.word	16,138
	.long	>0,>38A7280
	.word	68,15
	.long	>0,>38AB780
	.word	20,51
	.long	>0,>38AD760
	.word	44,100
	.long	>0,>38AF740
	.word	44,38
	.long	>0,>38B80C0
	.word	20,21
	.long	>0,>38BB500
	.word	12,31
	.long	>0,>38BC220
	.word	44,31
	.long	>0,>38BCDC0
	.word	40,21
	.long	>0,>38BF860
	.word	20,28
	.long	>0,>38C12A0
	.word	40,29
	.long	>0,>38C2420
	.word	144,56
	.long	>0,>38C4860
	.word	60,66
	.long	>0,>38D4460
	.word	60,18
	.long	>0,>38DC020
	.word	60,24
	.long	>0,>38DE1E0
	.word	20,28
	.long	>0,>38E0EE0
	.word	20,28
	.long	>0,>38E2060
	.word	40,28
	.long	>0,>38E31E0
	.word	40,112
	.long	>0,>38E54E0
	.word	28,158
	.long	>0,>38EE0E0
	.word	20,100
	.long	>0,>38F6B20
	.word	20,12
	.long	>0,>38FA9A0
	.word	60,60
	.long	>0,>38FB120
	.word	60,60
	.long	>0,>39021A0
	.word	20,28
	.long	>0,>3909220
	.word	60,89
	.long	>0,>390A3A0
	.word	60,124
	.long	>0,>3914A80
	.word	80,53
	.long	>0,>3923300
	.word	20,72
	.long	>0,>392B780
	.word	40,144
	.long	>0,>392E480
	.word	20,21
	.long	>0,>3939880
	.word	60,50
	.long	>0,>393A5A0
	.word	60,22
	.long	>0,>3940360
	.word	60,13
	.long	>0,>3942CA0
	.word	32,66
	.long	>0,>3944500
	.word	144,17
	.long	>0,>3948700
	.word	12,29
	.long	>0,>394D380
	.word	12,129
	.long	>0,>394DE60
	.word	24,29
	.long	>0,>3950EC0
	.word	40,35
	.long	>0,>3952480
	.word	40,22
	.long	>0,>3955040
	.word	48,45
	.long	>0,>3956BC0
	.word	44,18
	.long	>0,>395AF40
	.word	152,30
	.long	>0,>395C800
	.word	20,18
	.long	>0,>3965680
	.word	16,38
	.long	>0,>39661C0
	.word	32,38
	.long	>0,>39674C0
	.word	28,18
	.long	>0,>3969AC0
	.word	40,116
	.long	>0,>396AA80
	.word	28,116
	.long	>0,>3973B80
	.word	16,38
	.long	>0,>397A100
	.word	44,38
	.long	>0,>397B400
	.word	20,18
	.long	>0,>397E840
	.word	92,19
	.long	>0,>397F380
	.word	96,40
	.long	>0,>3982A20
	.word	168,30
	.long	>0,>398A220
	.word	48,29
	.long	>0,>3993FA0
	.word	24,39
	.long	>0,>3996B20
	.word	12,160
	.long	>0,>3998860
	.word	40,116
	.long	>0,>399C460
	.word	60,71
	.long	>0,>39A5560
	.word	40,28
	.long	>0,>39ADA80
	.word	40,91
	.long	>0,>39AFD80
	.word	28,116
	.long	>0,>39B6F40
	.word	24,21
	.long	>0,>39BD4C0
	.word	96,70
	.long	>0,>39BE480
	.word	48,11
	.long	>0,>39CB680
	.word	20,102
	.long	>0,>39CC700
	.word	40,98
	.long	>0,>39D06C0
	.word	8,98
	.long	>0,>39D8140
	.word	28,87
	.long	>0,>39D99C0
	.word	196,38
	.long	>0,>39DE5E0
	.word	180,44
	.long	>0,>39ECEA0
	.word	4,87
	.long	>0,>39FC620
	.word	20,87
	.long	>0,>39FD100
	.word	60,12
	.long	>0,>3A00760
	.word	64,33
	.long	>0,>3A01DE0
	.word	12,124
	.long	>0,>3A05FE0
	.word	112,33
	.long	>0,>3A08E60
	.word	40,96
	.long	>0,>3A101E0
	.word	16,124
	.long	>0,>3A179E0
	.word	40,96
	.long	>0,>3A1B7E0
	.word	60,19
	.long	>0,>3A22FE0
	.word	100,50
	.long	>0,>3A25380
	.word	44,98
	.long	>0,>3A2EFC0


ALLEY2ABLKS:
	.word	>6E40	;flags
	.word	0,0 ;x,y
	.word	>108	;pal5,pal4,hdr13-0
	.word	>4041,0,18,>132
	.word	>4051,0,47,>6C
	.word	>4041,0,85,>6C
	.word	>4041,0,123,>6C
	.word	>4040,0,161,>0
	.word	>4040,0,297,>0
	.word	>404F,0,205,>9
	.word	>4050,16,45,>11A
	.word	>6E40,44,0,>108
	.word	>4041,48,18,>132
	.word	>4040,56,45,>11A
	.word	>4040,60,161,>0
	.word	>4040,60,297,>0
	.word	>405F,60,205,>9
	.word	>4041,72,18,>132
	.word	>6E40,76,0,>108
	.word	>4041,96,46,>135
	.word	>4041,96,84,>135
	.word	>4041,96,122,>135
	.word	0FFFFH	;End Marker

BRIDGENDBLKS:
	.word	>4044	;flags
	.word	0,107 ;x,y
	.word	>48	;pal5,pal4,hdr13-0
	.word	>4044,0,62,>48
	.word	>4044,0,17,>48
	.word	>6447,0,101,>90
	.word	>4041,0,0,>3
	.word	>404F,0,152,>9
	.word	>404F,0,244,>9
	.word	>404F,0,336,>9
	.word	>404F,0,428,>9
	.word	>4054,40,107,>48
	.word	>4044,40,62,>48
	.word	>4054,40,17,>48
	.word	>4051,60,0,>3
	.word	>405F,60,152,>9
	.word	>405F,60,244,>9
	.word	>405F,60,336,>9
	.word	>405F,60,428,>9
	.word	>4044,80,107,>48
	.word	>4054,80,62,>48
	.word	>4044,80,17,>48
	.word	>6442,80,25,>24
	.word	>4044,120,17,>48
	.word	>4051,120,0,>3
	.word	>404F,120,152,>9
	.word	>404F,120,244,>9
	.word	>404F,120,336,>9
	.word	>404F,120,428,>9
	.word	>4054,160,107,>48
	.word	>4044,160,62,>48
	.word	>4054,160,17,>48
	.word	>4041,180,0,>3
	.word	>405F,180,152,>9
	.word	>405F,180,244,>9
	.word	>405F,180,336,>9
	.word	>405F,180,428,>9
	.word	>4044,200,107,>48
	.word	>4044,200,62,>48
	.word	>4044,200,17,>48
	.word	>6447,220,101,>90
	.word	0FFFFH	;End Marker

ALLEY3BLKS:
	.word	>4040	;flags
	.word	0,335 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,199,>0
	.word	>4055,0,85,>6C
	.word	>4045,0,123,>6C
	.word	>4055,0,161,>6C
	.word	>4045,0,56,>132
	.word	>6E40,0,38,>108
	.word	>4040,0,2,>123
	.word	>404F,0,243,>9
	.word	>4050,16,83,>11A
	.word	>4040,23,0,>123
	.word	>4045,24,56,>132
	.word	>6E40,44,38,>108
	.word	>4040,50,2,>123
	.word	>4040,56,83,>11A
	.word	>4040,60,335,>0
	.word	>4040,60,199,>0
	.word	>405F,60,243,>9
	.word	>4045,72,56,>132
	.word	>4040,75,0,>123
	.word	>6E40,76,38,>108
	.word	>4045,96,160,>135
	.word	>4055,96,122,>135
	.word	>4045,96,84,>135
	.word	0FFFFH	;End Marker

HOTEL3BLKS:
	.word	>4055	;flags
	.word	0,37 ;x,y
	.word	>D2	;pal5,pal4,hdr13-0
	.word	>4055,0,65,>D2
	.word	>4065,0,93,>D2
	.word	>4045,0,121,>45
	.word	>4051,0,141,>F6
	.word	>4053,0,170,>F6
	.word	>4041,0,199,>F6
	.word	>4043,0,228,>F6
	.word	>4040,0,393,>0
	.word	>4040,0,257,>0
	.word	>404F,0,301,>9
	.word	>6E45,4,156,>B4
	.word	>6E75,4,180,>B4
	.word	>6E75,4,204,>B4
	.word	>6445,5,141,>B4
	.word	>4041,12,228,>FC
	.word	>4045,20,32,>D5
	.word	>4073,36,228,>FC
	.word	>4045,40,121,>45
	.word	>4053,60,141,>F6
	.word	>4041,60,170,>F6
	.word	>4063,60,199,>F6
	.word	>4051,60,228,>F6
	.word	>4040,60,393,>0
	.word	>4040,60,257,>0
	.word	>405F,60,301,>9
	.word	>4050,72,141,>102
	.word	>6E65,80,45,>B4
	.word	>6E75,80,69,>B4
	.word	>4075,80,93,>D2
	.word	>4045,100,93,>D2
	.word	>4045,100,121,>45
	.word	>4051,112,141,>FC
	.word	>4043,112,170,>FC
	.word	>4051,112,199,>FC
	.word	>4043,112,228,>F6
	.word	>4065,120,93,>D2
	.word	>4040,120,393,>0
	.word	>4040,120,257,>0
	.word	>404F,120,301,>9
	.word	>4041,124,228,>FC
	.word	>6E63,136,141,>105
	.word	>6E63,136,183,>105
	.word	>4045,140,32,>D5
	.word	>4053,148,228,>FC
	.word	>4045,160,121,>45
	.word	>4041,172,228,>F6
	.word	>4040,180,257,>0
	.word	>4040,180,393,>0
	.word	>405F,180,301,>9
	.word	>4053,184,141,>F6
	.word	>4061,184,170,>F6
	.word	>4053,184,199,>F6
	.word	>4041,184,228,>F6
	.word	>4053,196,228,>FC
	.word	>4041,196,141,>FC
	.word	>4053,196,170,>FC
	.word	>4041,196,199,>FC
	.word	>4055,200,37,>D2
	.word	>4045,200,65,>D2
	.word	>4055,200,93,>D2
	.word	>784B,212,0,>C3
	.word	>A40,220,157,>C6
	.word	0FFFFH	;End Marker

DOORSBLKS:
	.word	>4040	;flags
	.word	0,148 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,284,>0
	.word	>4048,0,120,>141
	.word	>6E48,0,16,>144
	.word	>4041,0,91,>132
	.word	>404F,0,192,>9
	.word	>6E40,39,0,>144
	.word	>4048,40,120,>141
	.word	>4041,48,91,>132
	.word	>4040,60,148,>0
	.word	>4040,60,284,>0
	.word	>405F,60,192,>9
	.word	>6E55,76,9,>144
	.word	>4048,80,120,>141
	.word	>A41,96,91,>132
	.word	>6E61,115,6,>144
	.word	>4048,120,120,>141
	.word	>4040,120,148,>0
	.word	>4040,120,284,>0
	.word	>404F,120,192,>9
	.word	>4041,144,91,>132
	.word	>6E54,153,0,>144
	.word	>4048,160,120,>141
	.word	>4040,180,148,>0
	.word	>4040,180,284,>0
	.word	>405F,180,192,>9
	.word	>6E5A,192,12,>144
	.word	>4041,192,91,>132
	.word	>4048,200,120,>141
	.word	>4044,232,16,>159
	.word	0FFFFH	;End Marker

ALLEY2BLKS:
	.word	>4051	;flags
	.word	0,132 ;x,y
	.word	>6C	;pal5,pal4,hdr13-0
	.word	>4041,0,94,>6C
	.word	>4051,0,56,>6C
	.word	>4040,0,170,>0
	.word	>4040,0,306,>0
	.word	>6E40,0,38,>108
	.word	>404F,0,214,>9
	.word	>4040,1,1,>123
	.word	>4050,16,54,>11A
	.word	>4040,26,1,>123
	.word	>6E40,44,38,>108
	.word	>4040,50,1,>123
	.word	>4040,56,54,>11A
	.word	>4040,60,170,>0
	.word	>4040,60,306,>0
	.word	>405F,60,214,>9
	.word	>6E40,76,38,>108
	.word	>4040,76,0,>123
	.word	>4041,96,131,>135
	.word	>4041,96,93,>135
	.word	>4041,96,55,>135
	.word	0FFFFH	;End Marker

PIPELINEBLKS:
	.word	>4040	;flags
	.word	0,315 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,179,>0
	.word	>6E55,0,76,>B4
	.word	>6E45,0,52,>B4
	.word	>4040,0,166,>ED
	.word	>4050,0,100,>F0
	.word	>4040,0,30,>EA
	.word	>404F,0,223,>9
	.word	>4041,5,0,>112F
	.word	>6E50,28,100,>F0
	.word	>4040,60,50,>F9
	.word	>4040,60,315,>0
	.word	>4040,60,179,>0
	.word	>4040,60,30,>EA
	.word	>405F,60,223,>9
	.word	>4040,70,50,>FF
	.word	>4050,108,50,>F9
	.word	>4040,120,315,>0
	.word	>4040,120,179,>0
	.word	>6E45,120,76,>B4
	.word	>6E45,120,52,>B4
	.word	>4040,120,166,>ED
	.word	>6E40,120,100,>F0
	.word	>7840,120,30,>EA
	.word	>404F,120,223,>9
	.word	>4040,148,100,>F0
	.word	0FFFFH	;End Marker

ALLEYBLKS:
	.word	>4040	;flags
	.word	0,160 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4041,0,131,>F6
	.word	>4043,0,102,>F6
	.word	>4044,0,73,>F6
	.word	>4043,0,44,>F6
	.word	>4040,0,296,>0
	.word	>6E40,0,0,>10E
	.word	>4041,0,18,>FC
	.word	>404F,0,204,>9
	.word	>6440,4,44,>11A
	.word	>6E40,4,0,>117
	.word	>4043,24,18,>FC
	.word	>6E40,32,0,>117
	.word	>4043,44,122,>6C
	.word	>4044,44,84,>6C
	.word	>4043,44,46,>6C
	.word	>4044,48,17,>F6
	.word	0FFFFH	;End Marker

WALKUPBLKS:
	.word	>4044	;flags
	.word	0,217 ;x,y
	.word	>A5	;pal5,pal4,hdr13-0
	.word	>4040,0,245,>0
	.word	>4054,0,189,>A5
	.word	>4054,0,161,>A5
	.word	>4044,0,133,>A5
	.word	>4044,0,105,>A5
	.word	>4040,0,85,>45
	.word	>4040,0,381,>0
	.word	>4054,0,56,>A8
	.word	>4044,0,28,>A8
	.word	>4054,0,0,>A8
	.word	>404F,0,289,>9
	.word	>4044,20,217,>B7
	.word	>4044,20,189,>BA
	.word	>4044,20,161,>BA
	.word	>4044,20,133,>BA
	.word	>4044,20,105,>BD
	.word	>6E45,28,61,>B4
	.word	>6E55,28,37,>B4
	.word	>6E45,28,13,>B4
	.word	>4050,40,133,>C0
	.word	>4054,60,105,>BD
	.word	>4040,60,245,>0
	.word	>4040,60,85,>45
	.word	>4040,60,381,>0
	.word	>405F,60,289,>9
	.word	>4054,80,217,>B7
	.word	>4054,80,189,>BA
	.word	>4054,80,161,>BA
	.word	>4054,80,133,>BA
	.word	>4054,80,56,>A8
	.word	>4054,80,28,>A8
	.word	>4054,80,0,>A8
	.word	>4054,100,217,>A5
	.word	>4044,100,189,>A5
	.word	>4054,100,161,>A5
	.word	>4044,100,133,>A5
	.word	>4054,100,105,>A5
	.word	0FFFFH	;End Marker

HOTEL2BLKS:
	.word	>4040	;flags
	.word	0,257 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,393,>0
	.word	>4041,0,228,>F6
	.word	>4041,0,199,>F6
	.word	>4051,0,170,>F6
	.word	>4051,0,141,>F6
	.word	>4041,0,121,>45
	.word	>4065,0,93,>D2
	.word	>4055,0,65,>D2
	.word	>4055,0,37,>D2
	.word	>404F,0,301,>9
	.word	>6E75,4,204,>B4
	.word	>6E75,4,180,>B4
	.word	>6E45,4,156,>B4
	.word	>6445,5,141,>B4
	.word	>4041,12,228,>FC
	.word	>4045,20,32,>D5
	.word	>4071,36,228,>FC
	.word	>4041,40,121,>45
	.word	>4040,60,257,>0
	.word	>4040,60,393,>0
	.word	>4051,60,228,>F6
	.word	>4061,60,199,>F6
	.word	>4041,60,170,>F6
	.word	>4051,60,141,>F6
	.word	>405F,60,301,>9
	.word	>4050,72,141,>102
	.word	>6E45,79,93,>B4
	.word	>4045,80,93,>D2
	.word	>6E75,80,69,>B4
	.word	>6E65,80,45,>B4
	.word	>4041,100,121,>45
	.word	>4045,100,93,>D2
	.word	>4041,112,228,>F6
	.word	>4051,112,199,>FC
	.word	>4041,112,170,>FC
	.word	>4051,112,141,>FC
	.word	>4040,120,257,>0
	.word	>4040,120,393,>0
	.word	>4045,120,93,>D2
	.word	>404F,120,301,>9
	.word	>4041,124,228,>FC
	.word	>6E43,136,141,>105
	.word	>6443,136,183,>105
	.word	>4045,140,32,>D5
	.word	>4051,148,228,>FC
	.word	>4041,160,121,>45
	.word	>4041,172,228,>F6
	.word	>4040,180,393,>0
	.word	>4040,180,257,>0
	.word	>405F,180,301,>9
	.word	>4041,184,228,>F6
	.word	>4051,184,199,>F6
	.word	>4061,184,170,>F6
	.word	>4051,184,141,>F6
	.word	>4041,196,199,>FC
	.word	>4051,196,170,>FC
	.word	>4041,196,141,>FC
	.word	>4051,196,228,>FC
	.word	>4055,200,93,>D2
	.word	>4045,200,65,>D2
	.word	>4055,200,37,>D2
	.word	>784E,212,0,>C3
	.word	>4040,220,157,>C6
	.word	0FFFFH	;End Marker

HOLEBLKS:
	.word	>4040	;flags
	.word	0,216 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>6458,0,71,>C
	.word	>6458,0,60,>C9
	.word	>4041,0,43,>3
	.word	>4040,0,352,>0
	.word	>404F,0,260,>9
	.word	>4048,20,180,>F
	.word	>4043,20,120,>CC
	.word	>4040,20,60,>10CF
	.word	>4041,40,43,>3
	.word	>4040,60,216,>0
	.word	>4040,60,352,>0
	.word	>405F,60,260,>9
	.word	>6458,80,71,>C
	.word	>4058,80,60,>C9
	.word	>4068,100,180,>12
	.word	>4043,100,120,>CC
	.word	>4042,100,60,>18
	.word	>4042,100,90,>18
	.word	>4041,100,43,>3
	.word	>4040,120,216,>0
	.word	>4040,120,352,>0
	.word	>404F,120,260,>9
	.word	>6458,160,71,>C
	.word	>6458,160,0,>DE
	.word	>4068,170,36,>12
	.word	>4048,170,0,>F
	.word	>4040,180,216,>0
	.word	>4058,180,72,>E1
	.word	>4040,180,352,>0
	.word	>405F,180,260,>9
	.word	>4048,195,142,>E4
	.word	>6458,220,71,>C
	.word	>6458,220,0,>DE
	.word	0FFFFH	;End Marker

PAWNBLKS:
	.word	>4040	;flags
	.word	0,186 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,322,>0
	.word	>4041,0,148,>6C
	.word	>4041,0,110,>6C
	.word	>4041,0,72,>6C
	.word	>4041,0,34,>6C
	.word	>404F,0,230,>9
	.word	>6443,14,48,>6F
	.word	>644D,14,33,>72
	.word	>4047,14,0,>75
	.word	>4041,16,86,>78
	.word	>4051,34,86,>78
	.word	>4041,58,86,>78
	.word	>4041,58,48,>7B
	.word	>4040,60,186,>0
	.word	>4040,60,322,>0
	.word	>405F,60,230,>9
	.word	>404D,62,0,>7E
	.word	>4051,78,86,>78
	.word	>4051,78,48,>7B
	.word	>404D,82,33,>81
	.word	>644D,97,48,>84
	.word	>4051,102,48,>87
	.word	>4051,118,48,>8A
	.word	>4040,120,186,>0
	.word	>4040,120,322,>0
	.word	>404F,120,230,>9
	.word	>4041,134,48,>8A
	.word	>4051,150,48,>8A
	.word	>4041,166,48,>8A
	.word	>4040,180,186,>0
	.word	>4040,180,322,>0
	.word	>405F,180,230,>9
	.word	>4041,182,48,>87
	.word	>4041,198,86,>78
	.word	>4041,198,48,>7B
	.word	>644D,218,33,>8D
	.word	>4051,218,48,>7B
	.word	>4051,218,86,>78
	.word	>4047,238,0,>75
	.word	>4040,240,186,>0
	.word	>4040,240,322,>0
	.word	>404F,240,230,>9
	.word	>6451,242,86,>93
	.word	>6443,242,48,>96
	.word	>4041,284,148,>6C
	.word	>4041,284,110,>6C
	.word	>4041,284,72,>6C
	.word	>4041,284,34,>6C
	.word	0FFFFH	;End Marker

VOIDBLKS:
	.word	>4040	;flags
	.word	0,218 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,354,>0
	.word	>4040,0,58,>138
	.word	>404F,0,262,>9
	.word	>4050,12,102,>13B
	.word	>4057,12,31,>13E
	.word	>4050,52,102,>147
	.word	>4040,60,218,>0
	.word	>4040,60,354,>0
	.word	>405F,60,262,>9
	.word	>4047,72,81,>14A
	.word	>4047,72,11,>14D
	.word	>4047,72,0,>150
	.word	>4040,80,102,>108
	.word	>6447,80,120,>153
	.word	>4047,96,81,>14A
	.word	>4047,100,120,>156
	.word	>4040,116,102,>108
	.word	>4040,120,218,>0
	.word	>4040,120,354,>0
	.word	>4047,120,81,>14A
	.word	>4047,120,0,>150
	.word	>404F,120,262,>9
	.word	>6447,140,120,>153
	.word	>4047,144,81,>14A
	.word	>4040,160,102,>147
	.word	>4047,168,31,>13E
	.word	>4040,180,218,>0
	.word	>4040,180,354,>0
	.word	>405F,180,262,>9
	.word	>4040,188,102,>13B
	.word	>4040,228,58,>138
	.word	0FFFFH	;End Marker

HQBLKS:
	.word	>4040	;flags
	.word	0,172 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,308,>0
	.word	>4041,0,143,>F6
	.word	>4041,0,114,>F6
	.word	>4041,0,85,>F6
	.word	>4041,0,56,>F6
	.word	>4040,0,38,>10E
	.word	>4040,0,0,>111
	.word	>404F,0,216,>9
	.word	>4041,12,143,>FC
	.word	>4043,12,98,>105
	.word	>6E43,12,56,>105
	.word	>4040,16,0,>114
	.word	>4040,20,38,>117
	.word	>4041,36,143,>FC
	.word	>4040,44,0,>114
	.word	>4040,48,38,>117
	.word	>4040,60,172,>0
	.word	>4040,60,308,>0
	.word	>4041,60,143,>F6
	.word	>4041,60,114,>F6
	.word	>4041,60,85,>F6
	.word	>4041,60,56,>F6
	.word	>405F,60,216,>9
	.word	>4040,72,56,>11D
	.word	>4040,76,38,>117
	.word	>4040,76,0,>120
	.word	>4040,89,2,>123
	.word	>4040,100,56,>11A
	.word	>4040,104,38,>126
	.word	>4040,120,308,>0
	.word	>4040,120,172,>36
	.word	>404F,120,216,>9
	.word	>4040,124,38,>108
	.word	>4040,124,2,>123
	.word	>4040,140,56,>11D
	.word	>4040,154,2,>123
	.word	>4040,168,38,>108
	.word	>4040,168,96,>129
	.word	>4040,168,115,>129
	.word	>4040,168,134,>129
	.word	>4040,168,153,>129
	.word	>4050,169,56,>12C
	.word	>4040,180,172,>3C
	.word	>4040,180,308,>0
	.word	>405F,180,216,>9
	.word	>4040,187,2,>123
	.word	>4040,212,38,>108
	.word	>4040,220,2,>123
	.word	>4040,240,172,>3C
	.word	>4040,240,308,>0
	.word	>404F,240,216,>9
	.word	>4040,253,3,>123
	.word	>4040,256,38,>108
	.word	>4040,256,56,>12C
	.word	>4050,260,96,>129
	.word	>4050,260,115,>129
	.word	>4050,260,134,>129
	.word	>4050,260,153,>129
	.word	>4040,283,3,>123
	.word	>4040,300,172,>42
	.word	>4040,300,38,>108
	.word	>4040,300,308,>0
	.word	>405F,300,216,>9
	.word	>4040,315,2,>123
	.word	>4040,344,38,>108
	.word	>4040,347,2,>123
	.word	>4040,352,56,>11D
	.word	>4040,360,172,>0
	.word	>4040,360,38,>108
	.word	>4040,360,308,>0
	.word	>404F,360,216,>9
	.word	>4040,380,56,>102
	.word	>6440,388,0,>111
	.word	>4040,404,38,>10E
	.word	>6E40,404,0,>114
	.word	>4040,420,172,>0
	.word	>4041,420,143,>FC
	.word	>4041,420,114,>FC
	.word	>4071,420,85,>FC
	.word	>4041,420,56,>FC
	.word	>4040,420,308,>0
	.word	>405F,420,216,>9
	.word	>4040,424,38,>117
	.word	>4040,432,0,>114
	.word	>4071,444,143,>FC
	.word	>4041,444,114,>FC
	.word	>4041,444,85,>FC
	.word	>4041,444,56,>FC
	.word	>4040,452,38,>117
	.word	>4040,464,0,>120
	.word	>4041,468,143,>F6
	.word	>4041,468,114,>F6
	.word	>4041,468,85,>F6
	.word	>4041,468,56,>F6
	.word	0FFFFH	;End Marker

EUGBLKS:
	.word	>4040	;flags
	.word	0,315 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,179,>0
	.word	>6E42,0,29,>6
	.word	>404F,0,223,>9
	.word	>4040,60,179,>0
	.word	>4040,60,315,>0
	.word	>4042,60,149,>18
	.word	>4042,60,119,>18
	.word	>4047,60,29,>18
	.word	>4043,60,58,>1B
	.word	>405F,60,223,>9
	.word	>4053,88,58,>1B
	.word	>4040,120,179,>0
	.word	>4040,120,315,>0
	.word	>352,120,29,>1E
	.word	>404F,120,223,>9
	.word	>4047,145,0,>21
	.word	>6442,150,29,>24
	.word	>4040,180,179,>0
	.word	>4040,180,315,>0
	.word	>4042,180,59,>27
	.word	>4042,180,175,>2A
	.word	>405F,180,223,>9
	.word	>4042,180,91,>2D
	.word	>4052,208,59,>27
	.word	>4052,208,91,>2D
	.word	>4040,240,179,>0
	.word	>4040,240,315,>0
	.word	>4042,240,29,>1E
	.word	>404F,240,223,>9
	.word	>4040,300,179,>0
	.word	>4040,300,315,>0
	.word	>4042,300,149,>18
	.word	>4042,300,119,>18
	.word	>4042,300,29,>18
	.word	>4043,300,58,>1B
	.word	>405F,300,223,>9
	.word	>4053,328,58,>1B
	.word	>4040,360,179,>0
	.word	>4040,360,315,>0
	.word	>6E52,360,29,>6
	.word	>404F,360,223,>9
	.word	0FFFFH	;End Marker

RENTBLKS:
	.word	>4040	;flags
	.word	0,291 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,155,>0
	.word	>4040,0,0,>45
	.word	>4044,0,20,>48
	.word	>4044,0,65,>48
	.word	>4044,0,110,>48
	.word	>404F,0,199,>9
	.word	>4047,40,20,>4B
	.word	>4044,40,110,>48
	.word	>4050,40,45,>4E
	.word	>4040,60,155,>0
	.word	>4040,60,291,>0
	.word	>4040,60,0,>45
	.word	>405F,60,199,>9
	.word	>4044,80,110,>48
	.word	>4040,100,45,>4E
	.word	>4040,120,155,>0
	.word	>4040,120,291,>0
	.word	>4040,120,0,>45
	.word	>4044,120,110,>48
	.word	>404F,120,199,>9
	.word	>4044,160,110,>5D
	.word	>4044,160,65,>5D
	.word	>4044,160,20,>5D
	.word	>4040,180,155,>0
	.word	>4040,180,291,>0
	.word	>4040,180,0,>45
	.word	>4044,180,20,>48
	.word	>405F,180,199,>9
	.word	>4044,220,110,>5D
	.word	>4044,220,65,>5D
	.word	>4044,220,20,>5D
	.word	>4040,240,155,>0
	.word	>4040,240,291,>0
	.word	>4047,240,20,>4B
	.word	>4040,240,0,>45
	.word	>4044,240,110,>48
	.word	>4050,240,45,>4E
	.word	>404F,240,199,>9
	.word	>4044,280,110,>48
	.word	>4040,300,155,>0
	.word	>4040,300,291,>0
	.word	>4040,300,0,>45
	.word	>4040,300,45,>4E
	.word	>405F,300,199,>9
	.word	>4044,320,110,>48
	.word	>4040,360,155,>0
	.word	>4040,360,291,>0
	.word	>4040,360,0,>45
	.word	>4044,360,110,>48
	.word	>4044,360,65,>48
	.word	>4044,360,20,>48
	.word	>404F,360,199,>9
	.word	>4044,400,110,>5D
	.word	>4044,400,65,>5D
	.word	>4044,400,20,>5D
	.word	0FFFFH	;End Marker

WARE1BLKS:
	.word	>4040	;flags
	.word	0,336 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,200,>36
	.word	>4040,0,0,>45
	.word	>4044,0,155,>48
	.word	>4044,0,110,>48
	.word	>4044,0,65,>48
	.word	>4044,0,20,>48
	.word	>405F,0,244,>9
	.word	>4044,40,20,>5D
	.word	>4044,40,110,>5D
	.word	>4044,40,65,>5D
	.word	>6447,40,155,>90
	.word	>4040,60,336,>0
	.word	>4040,60,200,>3C
	.word	>4040,60,0,>45
	.word	>4040,60,179,>99
	.word	>4040,60,65,>9C
	.word	>4044,60,20,>48
	.word	>404F,60,244,>9
	.word	>4040,72,65,>9F
	.word	>4040,80,179,>A2
	.word	>4044,100,20,>48
	.word	>4040,116,65,>9F
	.word	>4040,120,336,>0
	.word	>4040,120,200,>3C
	.word	>4040,120,0,>45
	.word	>4040,120,179,>A2
	.word	>405F,120,244,>9
	.word	>4044,140,20,>48
	.word	>4044,160,65,>5D
	.word	>4044,160,110,>5D
	.word	>6447,160,155,>90
	.word	>4040,180,336,>0
	.word	>4040,180,200,>3C
	.word	>4040,180,0,>45
	.word	>4040,180,179,>99
	.word	>4040,180,65,>9C
	.word	>4044,180,20,>48
	.word	>404F,180,244,>9
	.word	>4040,192,65,>9F
	.word	>4040,200,179,>A2
	.word	>4044,220,20,>48
	.word	>4040,236,65,>9F
	.word	>4040,240,336,>0
	.word	>4040,240,200,>3C
	.word	>4040,240,0,>45
	.word	>4040,240,179,>A2
	.word	>405F,240,244,>9
	.word	>4044,260,20,>48
	.word	>4044,280,65,>5D
	.word	>4044,280,110,>5D
	.word	>6447,280,155,>90
	.word	>4040,300,336,>0
	.word	>4040,300,200,>3C
	.word	>4040,300,0,>45
	.word	>4040,300,179,>99
	.word	>4040,300,65,>9C
	.word	>4044,300,20,>48
	.word	>404F,300,244,>9
	.word	>4040,312,65,>9F
	.word	>4040,320,179,>A2
	.word	>4044,340,20,>48
	.word	>4040,356,65,>9F
	.word	>4040,360,336,>0
	.word	>4040,360,200,>42
	.word	>4040,360,0,>45
	.word	>4040,360,179,>A2
	.word	>405F,360,244,>9
	.word	>4044,380,20,>48
	.word	>4044,400,65,>5D
	.word	>6447,400,155,>90
	.word	>4044,400,110,>48
	.word	>4040,420,200,>0
	.word	>4040,420,336,>0
	.word	>4044,420,155,>5D
	.word	>4040,420,45,>45
	.word	>4044,420,65,>48
	.word	>404F,420,244,>9
	.word	>4044,460,65,>48
	.word	>4040,480,200,>0
	.word	>4040,480,336,>0
	.word	>4040,480,45,>45
	.word	>4044,480,110,>48
	.word	>4044,480,155,>48
	.word	>405F,480,244,>9
	.word	>4044,500,65,>48
	.word	>4044,520,155,>5D
	.word	>4044,520,110,>5D
	.word	0FFFFH	;End Marker

HOTEL1BLKS:
	.word	>4040	;flags
	.word	0,258 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4045,0,106,>D2
	.word	>4041,0,0,>3
	.word	>4040,0,394,>0
	.word	>4045,0,17,>D5
	.word	>4056,0,134,>D8
	.word	>404F,0,302,>9
	.word	>6E46,20,98,>DB
	.word	>4040,60,258,>0
	.word	>4046,60,134,>D8
	.word	>4041,60,0,>3
	.word	>4040,60,394,>0
	.word	>4045,60,17,>D5
	.word	>405F,60,302,>9
	.word	>4045,100,106,>D2
	.word	0FFFFH	;End Marker

BOOK1BLKS:
	.word	>4040	;flags
	.word	0,168 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4047,0,39,>E7
	.word	>4040,0,17,>EA
	.word	>4040,0,304,>0
	.word	>4040,0,155,>ED
	.word	>4050,0,89,>F0
	.word	>404F,0,212,>9
	.word	>4047,19,0,>F3
	.word	>4040,28,89,>F0
	.word	>4040,60,168,>0
	.word	>4040,60,17,>EA
	.word	>4040,60,304,>0
	.word	>4040,60,39,>F9
	.word	>405F,60,212,>9
	.word	>4040,70,39,>FF
	.word	>4050,108,39,>F9
	.word	>4040,120,168,>0
	.word	>4047,120,39,>E7
	.word	>4040,120,17,>EA
	.word	>4040,120,304,>0
	.word	>4040,120,155,>ED
	.word	>4050,120,89,>F0
	.word	>404F,120,212,>9
	.word	>4040,148,89,>F0
	.word	0FFFFH	;End Marker

LIQBLKS:
	.word	>4040	;flags
	.word	0,168 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,304,>0
	.word	>4040,0,12,>108
	.word	>4041,0,30,>7B
	.word	>4041,0,68,>78
	.word	>404F,0,212,>9
	.word	>4051,20,30,>7B
	.word	>4051,20,68,>78
	.word	>4040,44,12,>108
	.word	>6447,44,0,>10B
	.word	>4041,44,30,>7B
	.word	>4041,44,68,>78
	.word	>4040,60,168,>0
	.word	>4040,60,304,>0
	.word	>405F,60,212,>9
	.word	>4051,64,30,>7B
	.word	>4051,64,68,>78
	.word	>4051,88,30,>87
	.word	>4051,104,30,>8A
	.word	>4040,120,168,>0
	.word	>4040,120,304,>0
	.word	>4041,120,30,>8A
	.word	>404F,120,212,>9
	.word	>4041,136,30,>87
	.word	>4040,152,12,>108
	.word	>4041,152,68,>78
	.word	>4041,152,30,>7B
	.word	>4051,172,68,>78
	.word	>4051,172,30,>7B
	.word	>4040,180,168,>0
	.word	>4040,180,304,>0
	.word	>405F,180,212,>9
	.word	>4040,196,12,>108
	.word	>4041,196,68,>78
	.word	>4041,196,30,>7B
	.word	>4051,216,68,>78
	.word	>4051,216,30,>7B
	.word	0FFFFH	;End Marker

WARE2BLKS:
	.word	>4040	;flags
	.word	0,333 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,197,>0
	.word	>4041,0,36,>3
	.word	>404F,0,241,>9
	.word	>6458,0,52,>C
	.word	>4058,20,161,>F
	.word	>4048,20,53,>12
	.word	>4048,20,89,>15
	.word	>4040,60,333,>0
	.word	>4040,60,197,>0
	.word	>4041,60,36,>3
	.word	>405F,60,241,>9
	.word	>4068,80,161,>12
	.word	>4048,80,53,>F
	.word	>4048,80,89,>15
	.word	>4040,120,333,>0
	.word	>4040,120,197,>0
	.word	>4041,120,36,>3
	.word	>404F,120,241,>9
	.word	>4048,140,161,>12
	.word	>4048,140,53,>12
	.word	>4048,140,89,>15
	.word	>4040,180,333,>0
	.word	>4040,180,197,>0
	.word	>4048,180,17,>F
	.word	>4041,180,0,>3
	.word	>405F,180,241,>9
	.word	>4048,200,53,>30
	.word	>4040,240,333,>0
	.word	>4058,240,89,>33
	.word	>4048,240,53,>12
	.word	>4048,240,17,>12
	.word	>4041,240,0,>3
	.word	>4040,240,197,>36
	.word	>4048,240,161,>F
	.word	>404F,240,241,>9
	.word	>4040,300,333,>0
	.word	>4040,300,53,>39
	.word	>4048,300,17,>12
	.word	>4041,300,0,>3
	.word	>4040,300,197,>3C
	.word	>405F,300,241,>9
	.word	>4040,300,63,>3F
	.word	>4040,360,333,>0
	.word	>4048,360,17,>12
	.word	>4041,360,0,>3
	.word	>4040,360,197,>42
	.word	>404F,360,241,>9
	.word	>4048,400,161,>12
	.word	>4048,400,53,>F
	.word	>4048,400,89,>15
	.word	>4040,420,197,>0
	.word	>4040,420,197,>0
	.word	>4040,420,333,>0
	.word	>4041,420,36,>3
	.word	>405F,420,241,>9
	.word	>4068,460,161,>F
	.word	>4058,460,89,>33
	.word	>4048,460,53,>12
	.word	>4040,480,197,>0
	.word	>4041,480,36,>3
	.word	>4040,480,333,>0
	.word	>404F,480,241,>9
	.word	>6478,520,51,>C
	.word	0FFFFH	;End Marker

PINKYBLKS:
	.word	>4040	;flags
	.word	0,196 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,332,>0
	.word	>4047,0,109,>15C
	.word	>4040,0,91,>10E
	.word	>4057,0,20,>13E
	.word	>404F,0,240,>9
	.word	>4040,20,91,>117
	.word	>6E43,28,109,>105
	.word	>6E63,28,151,>105
	.word	>4040,48,91,>117
	.word	>6447,58,0,>15F
	.word	>4040,60,196,>0
	.word	>4040,60,332,>0
	.word	>4057,60,70,>14A
	.word	>4047,60,26,>162
	.word	>405F,60,240,>9
	.word	>4047,76,109,>165
	.word	>4040,76,91,>117
	.word	>4042,80,193,>2A
	.word	>4042,80,109,>2D
	.word	>4047,84,70,>14A
	.word	>4040,104,91,>117
	.word	>4047,108,70,>14A
	.word	>4052,108,109,>2D
	.word	>4040,120,196,>0
	.word	>4040,120,332,>0
	.word	>404F,120,240,>9
	.word	>4040,132,91,>117
	.word	>4047,132,70,>14A
	.word	>4047,140,109,>168
	.word	>4057,156,70,>14A
	.word	>4040,160,91,>117
	.word	>4042,160,193,>2A
	.word	>4042,161,109,>2D
	.word	>4040,180,196,>0
	.word	>4040,180,332,>0
	.word	>4047,180,70,>14A
	.word	>405F,180,240,>9
	.word	>4040,188,91,>117
	.word	>4052,188,109,>2D
	.word	>4047,204,70,>14A
	.word	>4040,216,91,>117
	.word	>4047,216,70,>14A
	.word	>4047,216,70,>14A
	.word	>4047,220,109,>165
	.word	>6E73,224,151,>105
	.word	>6E53,224,109,>105
	.word	>4040,240,196,>0
	.word	>4040,240,332,>0
	.word	>4047,240,20,>13E
	.word	>404F,240,240,>9
	.word	>4040,244,91,>117
	.word	>4047,272,109,>15C
	.word	>4040,272,91,>117
	.word	0FFFFH	;End Marker

TAPESBLKS:
	.word	>4040	;flags
	.word	0,181 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,317,>0
	.word	>4056,0,57,>D8
	.word	>4049,0,45,>16B
	.word	>4049,0,12,>16E
	.word	>4049,0,0,>16B
	.word	>404F,0,225,>9
	.word	>4040,60,317,>0
	.word	>4040,60,181,>0
	.word	>4056,60,57,>171
	.word	>4049,60,45,>16B
	.word	>4049,60,0,>16B
	.word	>405F,60,225,>9
	.word	>4049,64,12,>174
	.word	>4045,72,153,>141
	.word	>4049,72,57,>177
	.word	>4046,112,57,>17A
	.word	>4040,120,317,>0
	.word	>4040,120,181,>0
	.word	>4049,120,45,>16B
	.word	>4049,120,0,>16B
	.word	>404F,120,225,>9
	.word	>4045,128,153,>141
	.word	>4049,128,57,>17D
	.word	>4046,168,57,>171
	.word	>4049,176,12,>16E
	.word	>4040,180,317,>0
	.word	>4040,180,181,>0
	.word	>4046,180,57,>D8
	.word	>4049,180,45,>16B
	.word	>4049,180,0,>16B
	.word	>405F,180,225,>9
	.word	0FFFFH	;End Marker

CHECKSBLKS:
	.word	>4040	;flags
	.word	0,189 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,325,>0
	.word	>4044,0,91,>159
	.word	>4040,0,73,>10E
	.word	>4054,0,44,>A8
	.word	>4054,0,16,>A8
	.word	>4041,0,0,>3
	.word	>405F,0,233,>9
	.word	>4040,8,91,>180
	.word	>4040,8,176,>ED
	.word	>4050,8,110,>F0
	.word	>4050,20,73,>10E
	.word	>6E50,36,110,>F0
	.word	>404A,40,41,>183
	.word	>4044,40,16,>A8
	.word	>4040,60,189,>0
	.word	>4040,60,325,>0
	.word	>4041,60,0,>3
	.word	>404F,60,233,>9
	.word	>4041,68,91,>186
	.word	>4054,80,16,>A8
	.word	>4040,112,91,>180
	.word	>4040,112,176,>ED
	.word	>6E40,112,110,>F0
	.word	>4040,120,189,>0
	.word	>4040,120,325,>0
	.word	>4044,120,16,>A8
	.word	>4041,120,0,>3
	.word	>405F,120,233,>9
	.word	>4040,140,73,>10E
	.word	>4054,140,44,>A8
	.word	>4040,140,110,>F0
	.word	>4050,160,73,>10E
	.word	>4044,160,17,>A5
	.word	>4044,172,91,>159
	.word	0FFFFH	;End Marker

THERATBLKS:
	.word	>4040	;flags
	.word	0,169 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,30,>51
	.word	>4040,0,305,>0
	.word	>405F,0,213,>9
	.word	>405B,12,62,>54
	.word	>404C,12,30,>57
	.word	>404C,24,0,>5A
	.word	>405B,52,62,>60
	.word	>4040,60,169,>0
	.word	>4040,60,305,>0
	.word	>404F,60,213,>9
	.word	>404B,72,167,>63
	.word	>4044,72,79,>66
	.word	>404B,72,62,>69
	.word	>404B,108,62,>60
	.word	>4040,120,169,>0
	.word	>4040,120,305,>0
	.word	>405F,120,213,>9
	.word	>404B,128,62,>54
	.word	>4040,168,30,>51
	.word	0FFFFH	;End Marker

FASSGRLBLKS:
	.word	>4040	;flags
	.word	0,258 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,394,>0
	.word	>4044,0,202,>A5
	.word	>4044,0,174,>A5
	.word	>4044,0,146,>A5
	.word	>4044,0,118,>A5
	.word	>4044,0,90,>A5
	.word	>4040,0,70,>45
	.word	>4044,0,42,>A5
	.word	>4044,0,14,>A5
	.word	>4054,0,229,>A8
	.word	>404F,0,302,>9
	.word	>6447,7,90,>AB
	.word	>4041,20,164,>AE
	.word	>4041,20,146,>B1
	.word	>4044,40,42,>A5
	.word	>4044,40,14,>A5
	.word	>4054,40,229,>A8
	.word	>4040,60,258,>0
	.word	>4040,60,394,>0
	.word	>4040,60,70,>45
	.word	>405F,60,302,>9
	.word	>4044,80,42,>A5
	.word	>4044,80,14,>A5
	.word	>4041,80,146,>B1
	.word	>4055,80,184,>B4
	.word	>6445,80,208,>B4
	.word	>6445,80,160,>B4
	.word	>4054,80,229,>A8
	.word	>4040,120,258,>0
	.word	>4040,120,394,>0
	.word	>4054,120,230,>A5
	.word	>4040,120,70,>45
	.word	>4044,120,42,>A5
	.word	>4044,120,14,>A5
	.word	>404F,120,302,>9
	.word	>4044,140,230,>B7
	.word	>4044,140,202,>BA
	.word	>4044,140,174,>BA
	.word	>4044,140,146,>BA
	.word	>4044,140,118,>BD
	.word	>4054,140,90,>A5
	.word	>6445,140,46,>B4
	.word	>6445,140,22,>B4
	.word	>6E45,140,14,>B4
	.word	>4050,160,146,>C0
	.word	>4040,160,70,>45
	.word	>4044,160,89,>A8
	.word	>4040,180,258,>0
	.word	>4054,180,118,>BD
	.word	>4040,180,394,>0
	.word	>405F,180,302,>9
	.word	>4054,200,230,>B7
	.word	>4054,200,202,>BA
	.word	>4054,200,174,>BA
	.word	>4054,200,146,>BA
	.word	>4044,200,90,>A5
	.word	>4044,200,42,>A5
	.word	>4044,200,14,>A5
	.word	>784E,212,0,>C3
	.word	>A40,220,158,>C6
	.word	0FFFFH	;End Marker

DEMOMOD0BLKS:
	.word	0FFFFH		;End Marker
ALLEY2ABMOD:
	.word	120,341,20	;x size, y size, #blocks
	.long	ALLEY2ABLKS, DEMOHDRS, DEMOPALS
BRIDGENDBMOD:
	.word	240,520,39	;x size, y size, #blocks
	.long	BRIDGENDBLKS, DEMOHDRS, DEMOPALS
ALLEY3BMOD:
	.word	120,379,24	;x size, y size, #blocks
	.long	ALLEY3BLKS, DEMOHDRS, DEMOPALS
HOTEL3BMOD:
	.word	240,437,63	;x size, y size, #blocks
	.long	HOTEL3BLKS, DEMOHDRS, DEMOPALS
DOORSBMOD:
	.word	240,328,30	;x size, y size, #blocks
	.long	DOORSBLKS, DEMOHDRS, DEMOPALS
ALLEY2BMOD:
	.word	120,350,21	;x size, y size, #blocks
	.long	ALLEY2BLKS, DEMOHDRS, DEMOPALS
PIPELINEBMOD:
	.word	180,359,26	;x size, y size, #blocks
	.long	PIPELINEBLKS, DEMOHDRS, DEMOPALS
ALLEYBMOD:
	.word	60,340,17	;x size, y size, #blocks
	.long	ALLEYBLKS, DEMOHDRS, DEMOPALS
WALKUPBMOD:
	.word	120,425,38	;x size, y size, #blocks
	.long	WALKUPBLKS, DEMOHDRS, DEMOPALS
HOTEL2BMOD:
	.word	240,437,64	;x size, y size, #blocks
	.long	HOTEL2BLKS, DEMOHDRS, DEMOPALS
HOLEBMOD:
	.word	240,396,34	;x size, y size, #blocks
	.long	HOLEBLKS, DEMOHDRS, DEMOPALS
PAWNBMOD:
	.word	300,366,49	;x size, y size, #blocks
	.long	PAWNBLKS, DEMOHDRS, DEMOPALS
VOIDBMOD:
	.word	240,398,32	;x size, y size, #blocks
	.long	VOIDBLKS, DEMOHDRS, DEMOPALS
HQBMOD:
	.word	480,352,95	;x size, y size, #blocks
	.long	HQBLKS, DEMOHDRS, DEMOPALS
EUGBMOD:
	.word	420,359,42	;x size, y size, #blocks
	.long	EUGBLKS, DEMOHDRS, DEMOPALS
RENTBMOD:
	.word	420,335,56	;x size, y size, #blocks
	.long	RENTBLKS, DEMOHDRS, DEMOPALS
WARE1BMOD:
	.word	540,380,88	;x size, y size, #blocks
	.long	WARE1BLKS, DEMOHDRS, DEMOPALS
HOTEL1BMOD:
	.word	120,438,15	;x size, y size, #blocks
	.long	HOTEL1BLKS, DEMOHDRS, DEMOPALS
BOOK1BMOD:
	.word	180,348,24	;x size, y size, #blocks
	.long	BOOK1BLKS, DEMOHDRS, DEMOPALS
LIQBMOD:
	.word	240,348,37	;x size, y size, #blocks
	.long	LIQBLKS, DEMOHDRS, DEMOPALS
WARE2BMOD:
	.word	540,377,64	;x size, y size, #blocks
	.long	WARE2BLKS, DEMOHDRS, DEMOPALS
PINKYBMOD:
	.word	300,376,54	;x size, y size, #blocks
	.long	PINKYBLKS, DEMOHDRS, DEMOPALS
TAPESBMOD:
	.word	240,361,32	;x size, y size, #blocks
	.long	TAPESBLKS, DEMOHDRS, DEMOPALS
CHECKSBMOD:
	.word	180,369,35	;x size, y size, #blocks
	.long	CHECKSBLKS, DEMOHDRS, DEMOPALS
THERATBMOD:
	.word	180,349,20	;x size, y size, #blocks
	.long	THERATBLKS, DEMOHDRS, DEMOPALS
FASSGRLBMOD:
	.word	240,438,61	;x size, y size, #blocks
	.long	FASSGRLBLKS, DEMOHDRS, DEMOPALS

BRIDHDRS:
	.word	28,36	;x size, y size
	.long	>0		;anim
	.long	>3A37680	;address
	.word	60,92
	.long	>0,>37B2360
	.word	20,148
	.long	>0,>3A39600


BRIDGE2BLKS:
	.word	>4041	;flags
	.word	0,112 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,148,>3
	.word	>4040,0,240,>3
	.word	>4040,0,332,>3
	.word	>4040,0,424,>3
	.word	>4041,28,112,>0
	.word	>4041,56,112,>0
	.word	>4050,60,148,>3
	.word	>4050,60,240,>3
	.word	>4050,60,332,>3
	.word	>4050,60,424,>3
	.word	>4041,84,112,>0
	.word	>4041,112,112,>0
	.word	>4040,120,148,>3
	.word	>4040,120,240,>3
	.word	>4040,120,332,>3
	.word	>4040,120,424,>3
	.word	>4041,140,112,>0
	.word	>4041,168,112,>0
	.word	>4050,180,148,>3
	.word	>4050,180,240,>3
	.word	>4050,180,332,>3
	.word	>4050,180,424,>3
	.word	>4041,194,0,>6
	.word	>4051,220,0,>6
	.word	0FFFFH	;End Marker

BRIDGEBLKS:
	.word	>4041	;flags
	.word	0,112 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,148,>3
	.word	>4040,0,240,>3
	.word	>4040,0,332,>3
	.word	>4040,0,424,>3
	.word	>4041,28,112,>0
	.word	>4041,56,112,>0
	.word	>4050,60,148,>3
	.word	>4050,60,240,>3
	.word	>4050,60,332,>3
	.word	>4050,60,424,>3
	.word	>4041,84,112,>0
	.word	>4041,112,112,>0
	.word	>4040,120,148,>3
	.word	>4040,120,240,>3
	.word	>4040,120,332,>3
	.word	>4040,120,424,>3
	.word	>4041,140,112,>0
	.word	>4041,168,112,>0
	.word	>4050,180,148,>3
	.word	>4050,180,240,>3
	.word	>4050,180,332,>3
	.word	>4050,180,424,>3
	.word	>4041,194,0,>6
	.word	>4041,212,112,>0
	.word	0FFFFH	;End Marker

BRIDMOD0BLKS:
	.word	0FFFFH		;End Marker
BRIDGE2BMOD:
	.word	240,516,25	;x size, y size, #blocks
	.long	BRIDGE2BLKS, BRIDHDRS, BRIDPALS
BRIDGEBMOD:
	.word	240,516,25	;x size, y size, #blocks
	.long	BRIDGEBLKS, BRIDHDRS, BRIDPALS

ROOMHDRS:
	.word	68,33	;x size, y size
	.long	>0		;anim
	.long	>3A3F280	;address
	.word	68,14
	.long	>0,>3A438A0
	.word	68,31
	.long	>0,>3A45660
	.word	68,64
	.long	>0,>3A49840
	.word	24,63
	.long	>0,>3A52040
	.word	48,31
	.long	>0,>3A54F80
	.word	48,19
	.long	>0,>3A57E00


ROOM1BLKS:
	.word	>4050	;flags
	.word	0,110 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4050,0,78,>0
	.word	>4050,0,143,>0
	.word	>4050,0,176,>3
	.word	>4050,0,47,>6
	.word	>4040,0,189,>9
	.word	>4060,0,253,>9
	.word	>4050,0,33,>3
	.word	>4060,68,176,>3
	.word	>4060,68,143,>0
	.word	>4040,68,47,>6
	.word	>4060,68,77,>0
	.word	>4060,68,110,>0
	.word	>4040,68,189,>9
	.word	>4060,68,253,>9
	.word	>4060,68,33,>3
	.word	>4050,136,176,>3
	.word	>4050,136,144,>0
	.word	>4050,136,111,>0
	.word	>4050,136,78,>0
	.word	>4050,136,47,>6
	.word	>4040,136,189,>9
	.word	>4060,136,253,>9
	.word	>4050,136,33,>3
	.word	>4060,204,78,>0
	.word	>4060,204,111,>0
	.word	>4060,204,144,>0
	.word	>4060,204,177,>3
	.word	>4040,204,47,>6
	.word	>4040,204,189,>9
	.word	>4060,204,253,>9
	.word	>4060,204,33,>3
	.word	>4040,272,189,>9
	.word	>4060,272,253,>9
	.word	>4641,311,126,>C
	.word	>4641,311,63,>C
	.word	>4040,312,32,>F
	.word	>4641,335,126,>C
	.word	>4641,335,63,>C
	.word	>4040,340,189,>9
	.word	>4060,340,253,>9
	.word	>4641,359,126,>C
	.word	>4641,359,63,>C
	.word	>4050,360,32,>F
	.word	>5A50,365,76,>12
	.word	>5A50,365,63,>12
	.word	>4040,408,189,>9
	.word	>4060,408,253,>9
	.word	>4040,408,32,>F
	.word	>4641,409,126,>C
	.word	>4641,409,63,>C
	.word	>4641,433,126,>C
	.word	>4641,433,63,>C
	.word	>4040,476,189,>9
	.word	>4060,476,253,>9
	.word	>4050,495,179,>3
	.word	>4050,495,146,>0
	.word	>4050,495,113,>0
	.word	>4050,495,80,>0
	.word	>4050,495,50,>6
	.word	>4050,495,36,>3
	.word	>4040,544,189,>9
	.word	>4060,544,253,>9
	.word	>4060,563,179,>3
	.word	>4060,563,147,>0
	.word	>4060,563,114,>0
	.word	>4060,563,81,>0
	.word	>4040,563,50,>6
	.word	>4060,563,36,>3
	.word	>4040,612,189,>9
	.word	>4060,612,253,>9
	.word	>4050,631,179,>3
	.word	>4050,631,147,>0
	.word	>4050,631,114,>0
	.word	>4050,631,81,>0
	.word	>4050,631,50,>6
	.word	>4050,631,36,>3
	.word	>4040,680,189,>9
	.word	>4060,680,253,>9
	.word	>4060,699,179,>3
	.word	>4060,699,147,>0
	.word	>4060,699,114,>0
	.word	>4060,699,81,>0
	.word	>4040,699,50,>6
	.word	>4060,699,36,>3
	.word	>4040,748,189,>9
	.word	>4060,748,253,>9
	.word	>4050,766,146,>0
	.word	>4050,767,179,>3
	.word	>4050,767,113,>0
	.word	>4050,767,80,>0
	.word	>4050,767,49,>6
	.word	>4050,767,36,>3
	.word	>4040,816,189,>9
	.word	>4060,816,253,>9
	.word	>4060,834,146,>0
	.word	>4060,835,179,>3
	.word	>4060,835,113,>0
	.word	>4060,835,80,>0
	.word	>4040,835,49,>6
	.word	>4060,835,36,>3
	.word	>4040,884,189,>9
	.word	>4060,884,253,>9
	.word	>4060,942,179,>3
	.word	>4050,943,146,>0
	.word	>4050,943,113,>0
	.word	>4050,943,80,>0
	.word	>4050,943,49,>6
	.word	>4050,943,35,>3
	.word	>4040,952,189,>9
	.word	>4060,952,253,>9
	.word	>4060,1010,179,>3
	.word	>4060,1011,146,>0
	.word	>4060,1011,113,>0
	.word	>4060,1011,80,>0
	.word	>4040,1011,49,>6
	.word	>4060,1011,35,>3
	.word	>4060,1020,253,>9
	.word	>4040,1020,189,>9
	.word	>4060,1078,179,>3
	.word	>4050,1079,146,>0
	.word	>4050,1079,113,>0
	.word	>4050,1079,80,>0
	.word	>4050,1079,49,>6
	.word	>4050,1079,35,>3
	.word	>4040,1088,189,>9
	.word	>4060,1088,253,>9
	.word	>4060,1145,179,>3
	.word	>4060,1147,146,>0
	.word	>4060,1147,113,>0
	.word	>4060,1147,80,>0
	.word	>4040,1147,49,>6
	.word	>4060,1147,35,>3
	.word	>4040,1156,189,>9
	.word	>4060,1156,253,>9
	.word	>4641,1198,126,>C
	.word	>4641,1198,63,>C
	.word	>5A41,1198,0,>C
	.word	>4641,1222,0,>C
	.word	>4641,1222,63,>C
	.word	>4040,1224,189,>9
	.word	>4060,1224,253,>9
	.word	>4641,1246,0,>C
	.word	>4641,1246,63,>C
	.word	0FFFFH	;End Marker

ROOMMOD0BLKS:
	.word	0FFFFH		;End Marker
ROOM1BMOD:
	.word	1292,317,144	;x size, y size, #blocks
	.long	ROOM1BLKS, ROOMHDRS, ROOMPALS

RISEHDRS:
	.word	124,136	;x size, y size
	.long	>0		;anim
	.long	>3A59A80	;address
	.word	124,22
	.long	>0,>3A7A980
	.word	24,24
	.long	>0,>3A7FEC0
	.word	64,68
	.long	>0,>3A810C0
	.word	40,24
	.long	>0,>3A898C0
	.word	60,24
	.long	>0,>3A8B6C0
	.word	20,45
	.long	>0,>3A8E3C0
	.word	16,119
	.long	>0,>3A8FFE0
	.word	64,16
	.long	>0,>3A93B60
	.word	84,45
	.long	>0,>3A95B60
	.word	20,90
	.long	>0,>3A9D180
	.word	84,90
	.long	>0,>3AA09C0
	.word	4,91
	.long	>0,>3AAF600
	.word	8,106
	.long	>0,>3AB0160
	.word	8,75
	.long	>0,>3AB1BE0
	.word	40,75
	.long	>0,>3AB2EA0
	.word	40,106
	.long	>0,>3AB8C60
	.word	8,106
	.long	>0,>3AC10E0
	.word	48,16
	.long	>0,>3AC2B60
	.word	60,44
	.long	>0,>37997C0
	.word	60,92
	.long	>0,>37B2360
	.word	44,106
	.long	>0,>3AC4360
	.word	8,75
	.long	>0,>3ACD520
	.word	144,44
	.long	>0,>3ACE7E0
	.word	48,53
	.long	>0,>3ADADE0
	.word	84,27
	.long	>0,>3ADFD60
	.word	44,106
	.long	>0,>3AE4440
	.word	48,75
	.long	>0,>3AED600
	.word	28,64
	.long	>0,>3AF4680
	.word	44,53
	.long	>0,>3AF7E80
	.word	16,107
	.long	>0,>3AFC760
	.word	20,88
	.long	>0,>3AFFCE0
	.word	20,21
	.long	>0,>3B033E0
	.word	88,20
	.long	>0,>3B04100
	.word	76,90
	.long	>0,>3B07800
	.word	44,22
	.long	>0,>3B14DC0
	.word	8,91
	.long	>0,>3B16C00
	.word	28,66
	.long	>0,>3B182C0
	.word	44,34
	.long	>0,>3B1BC80
	.word	44,98
	.long	>0,>3B1EB40
	.word	72,110
	.long	>0,>3B27200
	.word	16,22
	.long	>0,>3B36980
	.word	156,22
	.long	>0,>3B37480
	.word	20,110
	.long	>0,>3B3DFC0
	.word	36,110
	.long	>0,>3B42480
	.word	32,18
	.long	>0,>3B4A040
	.word	80,115
	.long	>0,>3B4B240
	.word	40,45
	.long	>0,>3B5D1C0
	.word	180,24
	.long	>0,>3B60A00
	.word	60,20
	.long	>0,>3842060
	.word	28,104
	.long	>0,>3B69100
	.word	20,40
	.long	>0,>3B6EC00
	.word	20,24
	.long	>0,>3B70500
	.word	20,48
	.long	>0,>3B71400
	.word	16,24
	.long	>0,>3B73200
	.word	60,40
	.long	>0,>3B73E00
	.word	36,24
	.long	>0,>3B78900
	.word	36,96
	.long	>0,>3B7A400
	.word	24,72
	.long	>0,>3B81000
	.word	48,25
	.long	>0,>3B84600
	.word	12,75
	.long	>0,>3B86B80
	.word	60,25
	.long	>0,>3B887A0
	.word	88,75
	.long	>0,>3B8B680
	.word	8,75
	.long	>0,>3B984C0
	.word	24,25
	.long	>0,>3B99780
	.word	144,50
	.long	>0,>3B9AA40
	.word	48,112
	.long	>0,>3BA8B40
	.word	48,38
	.long	>0,>3BB3340
	.word	24,25
	.long	>0,>3BB6C40
	.word	4,20
	.long	>0,>3BB7F00
	.word	4,92
	.long	>0,>3BB8180
	.word	32,20
	.long	>0,>3BB8D00
	.word	24,69
	.long	>0,>3BBA100
	.word	24,68
	.long	>0,>3BBD4C0
	.word	32,92
	.long	>0,>3BC07C0
	.word	32,112
	.long	>0,>3BC63C0
	.word	40,112
	.long	>0,>3BCD3C0


BIGFLR4SBLKS:
	.word	>406D	;flags
	.word	0,0 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>404D,0,90,>101E
	.word	>4049,0,180,>0
	.word	>404B,0,316,>1003
	.word	>4051,20,0,>101B
	.word	>4075,20,45,>101B
	.word	>4055,20,90,>101B
	.word	>407D,20,135,>101B
	.word	>407D,104,0,>101E
	.word	>405D,104,90,>101E
	.word	0FFFFH	;End Marker

BIGFLR1SBLKS:
	.word	>404D	;flags
	.word	0,0 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>404D,0,90,>101E
	.word	>4049,0,180,>0
	.word	>404B,0,316,>1003
	.word	>404D,20,0,>101B
	.word	>4047,20,45,>21
	.word	>404D,20,135,>101B
	.word	>407D,104,0,>101E
	.word	>405D,104,90,>101E
	.word	0FFFFH	;End Marker

BIGFLR10SBLKS:
	.word	>4046	;flags
	.word	0,45 ;x,y
	.word	>18	;pal5,pal4,hdr13-0
	.word	>4049,0,180,>0
	.word	>4046,0,61,>15
	.word	>404D,0,0,>1012
	.word	>404B,0,316,>1003
	.word	>404D,20,0,>101B
	.word	>4056,60,45,>18
	.word	>404D,104,0,>1012
	.word	>4056,108,61,>15
	.word	0FFFFH	;End Marker

BIGFLR9SBLKS:
	.word	>A6D	;flags
	.word	0,0 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>A49,0,180,>0
	.word	>404B,0,316,>1003
	.word	>4051,20,0,>101B
	.word	>4075,20,45,>101B
	.word	>4055,20,90,>101B
	.word	>A7D,20,135,>101B
	.word	>A7D,104,0,>101E
	.word	>A5D,104,90,>101E
	.word	0FFFFH	;End Marker

BIGFLR8SBLKS:
	.word	>A6D	;flags
	.word	0,0 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>A4D,0,90,>101E
	.word	>4049,0,180,>0
	.word	>404B,0,316,>1003
	.word	>4075,20,45,>101B
	.word	>4051,20,0,>101B
	.word	>4055,20,90,>101B
	.word	>A7D,20,135,>101B
	.word	>A7D,104,0,>101E
	.word	0FFFFH	;End Marker

SAFEFBBLKS:
	.word	>54D	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	0FFFFH	;End Marker

SAFEFGRBLKS:
	.word	>54E	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	0FFFFH	;End Marker

SAFEFSBLKS:
	.word	>549	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	0FFFFH	;End Marker

SAFEFGBLKS:
	.word	>542	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	0FFFFH	;End Marker

SAFEFRBLKS:
	.word	>541	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	0FFFFH	;End Marker

BIGFLR9BLKS:
	.word	>404B	;flags
	.word	0,316 ;x,y
	.word	>1003	;pal5,pal4,hdr13-0
	.word	>A4D,0,180,>0
	.word	>A6D,0,0,>101E
	.word	>A7D,20,135,>101B
	.word	>4055,20,90,>101B
	.word	>4075,20,45,>101B
	.word	>4051,20,0,>101B
	.word	>A5D,104,90,>101E
	.word	>A7D,104,0,>101E
	.word	0FFFFH	;End Marker

BIGFLR8BLKS:
	.word	>404D	;flags
	.word	0,180 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>A4D,0,90,>101E
	.word	>A6D,0,0,>101E
	.word	>404B,0,316,>1003
	.word	>4051,20,0,>101B
	.word	>A7D,20,135,>101B
	.word	>4055,20,90,>101B
	.word	>4075,20,45,>101B
	.word	>A7D,104,0,>101E
	.word	0FFFFH	;End Marker

BIGFLR7BLKS:
	.word	>404B	;flags
	.word	0,316 ;x,y
	.word	>1003	;pal5,pal4,hdr13-0
	.word	>A49,0,180,>0
	.word	>404D,0,90,>101E
	.word	>406D,0,0,>101E
	.word	>6E5A,4,44,>5D
	.word	>6E5A,4,131,>60
	.word	>407A,4,24,>60
	.word	>406A,18,24,>63
	.word	>A4A,18,132,>63
	.word	>4041,20,0,>104B
	.word	>A4D,20,153,>104B
	.word	>404C,24,43,>66
	.word	>404A,40,132,>69
	.word	>6E4A,100,44,>5D
	.word	>6E4A,100,131,>60
	.word	>6E6A,100,24,>60
	.word	>405D,104,90,>101E
	.word	>A7D,104,0,>101E
	.word	0FFFFH	;End Marker

BIGFLR6BLKS:
	.word	>404D	;flags
	.word	0,97 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>406D,0,7,>101E
	.word	>A4D,0,187,>0
	.word	>404B,0,323,>1003
	.word	>A6B,18,107,>1057
	.word	>A4B,18,54,>1057
	.word	>404B,20,160,>104B
	.word	>404B,20,27,>104B
	.word	>4055,20,0,>104B
	.word	>407B,62,107,>1057
	.word	>A5B,62,54,>1057
	.word	>6E4D,104,97,>101E
	.word	>A6D,104,7,>101E
	.word	0FFFFH	;End Marker

BIGFLR5BLKS:
	.word	>404D	;flags
	.word	0,97 ;x,y
	.word	>101E	;pal5,pal4,hdr13-0
	.word	>406D,0,7,>101E
	.word	>A4D,0,187,>0
	.word	>404B,0,323,>1003
	.word	>A4B,18,54,>1057
	.word	>A6B,18,107,>1057
	.word	>404B,20,160,>104B
	.word	>404B,20,27,>104B
	.word	>4055,20,0,>104B
	.word	>785B,20,54,>105A
	.word	>407B,62,107,>1057
	.word	>A5B,62,54,>1057
	.word	>784B,88,54,>105A
	.word	>407D,104,7,>101E
	.word	>795D,104,97,>101E
	.word	0FFFFH	;End Marker

BIGFLR4BLKS:
	.word	>404D	;flags
	.word	0,180 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404D,0,90,>101E
	.word	>406D,0,0,>101E
	.word	>404B,0,316,>1003
	.word	>407D,20,135,>101B
	.word	>4055,20,90,>101B
	.word	>4051,20,0,>101B
	.word	>4075,20,45,>101B
	.word	>405D,104,90,>101E
	.word	>407D,104,0,>101E
	.word	0FFFFH	;End Marker

BIGFLR3BLKS:
	.word	>404D	;flags
	.word	0,187 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404D,0,97,>101E
	.word	>406D,0,7,>101E
	.word	>404B,0,323,>1003
	.word	>6E4B,18,54,>103F
	.word	>404B,20,160,>104B
	.word	>404B,20,27,>104B
	.word	>4055,20,0,>104B
	.word	>6E5B,62,54,>103F
	.word	>405D,104,97,>101E
	.word	>407D,104,7,>101E
	.word	0FFFFH	;End Marker

BIGFLRBLKS:
	.word	>404D	;flags
	.word	0,181 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,90,>1024
	.word	>404B,0,0,>1024
	.word	>404B,0,317,>1003
	.word	>404B,4,75,>1027
	.word	>4045,4,0,>102A
	.word	>4055,12,0,>102D
	.word	>405B,12,75,>1030
	.word	>4045,52,0,>102D
	.word	>404B,52,75,>1030
	.word	>405B,92,75,>1027
	.word	>4045,92,0,>1042
	.word	>404B,100,90,>1024
	.word	>404B,100,0,>1024
	.word	>405D,104,91,>101E
	.word	>407D,104,1,>101E
	.word	0FFFFH	;End Marker

BIGFLR1BLKS:
	.word	>404B	;flags
	.word	0,316 ;x,y
	.word	>1003	;pal5,pal4,hdr13-0
	.word	>404D,0,180,>0
	.word	>404D,0,90,>101E
	.word	>404D,0,0,>101E
	.word	>404D,20,135,>101B
	.word	>404D,20,0,>101B
	.word	>4047,20,45,>21
	.word	>405D,104,90,>101E
	.word	>407D,104,0,>101E
	.word	0FFFFH	;End Marker

SNOBWINBLKS:
	.word	>4042	;flags
	.word	0,44 ;x,y
	.word	>100C	;pal5,pal4,hdr13-0
	.word	>4042,0,20,>1006
	.word	>4042,0,92,>100C
	.word	>4042,0,68,>1006
	.word	>4042,0,116,>10A2
	.word	>6E46,0,188,>10A5
	.word	>4040,0,228,>39
	.word	>4040,0,0,>93
	.word	>4042,0,140,>10A8
	.word	>4042,0,164,>10A2
	.word	>4040,0,364,>39
	.word	>4047,0,272,>103C
	.word	>4042,16,116,>10A8
	.word	>4042,16,164,>10A8
	.word	>4042,24,20,>10A2
	.word	>4042,24,68,>10A2
	.word	>4042,36,140,>10A2
	.word	>405B,40,20,>10AB
	.word	>4053,52,116,>10AE
	.word	>6E46,60,188,>10A5
	.word	>4040,60,228,>39
	.word	>4040,60,0,>93
	.word	>4040,60,364,>39
	.word	>4057,60,272,>103C
	.word	>404B,76,20,>10AB
	.word	>4043,76,116,>10AE
	.word	>4042,100,164,>100C
	.word	>4042,100,140,>100C
	.word	>4042,100,116,>100C
	.word	>4042,112,92,>10A2
	.word	>4042,112,68,>10A2
	.word	>4042,112,44,>10A2
	.word	>6E46,120,188,>10A5
	.word	>4040,120,228,>39
	.word	>4040,120,0,>93
	.word	>4040,120,364,>39
	.word	>4047,120,272,>103C
	.word	>405B,128,20,>10AB
	.word	>4053,140,116,>10AE
	.word	>4043,164,116,>10AE
	.word	>404B,164,20,>10AB
	.word	>6E46,180,188,>10A5
	.word	>4040,180,228,>39
	.word	>4040,180,0,>93
	.word	>4040,180,364,>39
	.word	>4057,180,272,>103C
	.word	>4042,188,116,>10A2
	.word	>4042,188,140,>10A8
	.word	>4042,188,164,>10A2
	.word	>4042,200,92,>10A2
	.word	>4042,200,44,>10A2
	.word	>4042,200,68,>100C
	.word	>4042,200,20,>100C
	.word	>4042,204,116,>10A8
	.word	>4042,204,164,>10A8
	.word	>4042,216,92,>1006
	.word	>4042,216,44,>1006
	.word	>4042,224,140,>10A2
	.word	0FFFFH	;End Marker

SNOBDORBLKS:
	.word	>4040	;flags
	.word	0,228 ;x,y
	.word	>39	;pal5,pal4,hdr13-0
	.word	>404C,0,113,>108A
	.word	>4042,0,68,>108D
	.word	>4049,0,44,>1090
	.word	>4042,0,20,>100F
	.word	>4040,0,0,>93
	.word	>4040,0,364,>39
	.word	>4047,0,272,>103C
	.word	>4052,40,68,>108D
	.word	>4040,60,228,>39
	.word	>4042,60,20,>100F
	.word	>4040,60,0,>93
	.word	>4040,60,364,>39
	.word	>4057,60,272,>103C
	.word	>6E4A,76,129,>1096
	.word	>4046,80,188,>1099
	.word	>4042,80,164,>109C
	.word	>4042,80,140,>109C
	.word	>4042,80,116,>109C
	.word	>4042,80,68,>109F
	.word	>404C,100,113,>108A
	.word	>4042,100,68,>108D
	.word	>4040,120,228,>39
	.word	>4042,120,20,>100F
	.word	>4040,120,0,>93
	.word	>4040,120,364,>39
	.word	>4047,120,272,>103C
	.word	>4052,140,68,>108D
	.word	0FFFFH	;End Marker

FANNYCOBLKS:
	.word	>4040	;flags
	.word	0,250 ;x,y
	.word	>39	;pal5,pal4,hdr13-0
	.word	>4049,0,225,>10B1
	.word	>4049,0,75,>10B1
	.word	>4049,0,25,>10B1
	.word	>4049,0,125,>10B4
	.word	>4049,0,200,>10B7
	.word	>4049,0,100,>10B7
	.word	>4049,0,50,>10B7
	.word	>4049,0,0,>10B7
	.word	>4040,0,386,>39
	.word	>4047,0,294,>103C
	.word	>4043,12,125,>10BA
	.word	>4049,48,225,>10B7
	.word	>4049,48,75,>10B7
	.word	>4049,48,25,>10B7
	.word	>4040,60,250,>39
	.word	>4049,60,100,>10B1
	.word	>4049,60,50,>10B1
	.word	>4049,60,200,>10B1
	.word	>4049,60,0,>10B7
	.word	>4040,60,386,>39
	.word	>4057,60,294,>103C
	.word	>6E4A,94,151,>1096
	.word	>4049,100,125,>10BD
	.word	>4049,108,225,>10C0
	.word	>4049,108,200,>10C0
	.word	>4049,108,175,>10C0
	.word	>4049,108,150,>10C0
	.word	>4049,108,125,>10C0
	.word	>4049,108,100,>10C0
	.word	>4049,108,50,>10C3
	.word	>4049,108,25,>10B7
	.word	>4040,120,250,>39
	.word	>4049,120,0,>10B7
	.word	>4040,120,386,>39
	.word	>4047,120,294,>103C
	.word	>4052,132,138,>10C6
	.word	>4052,132,100,>10C9
	.word	>4049,168,25,>10CC
	.word	>4042,180,100,>10C9
	.word	>4042,180,138,>10C6
	.word	>4040,180,250,>39
	.word	>4049,180,0,>10B7
	.word	>4040,180,386,>39
	.word	>4057,180,294,>103C
	.word	>4049,192,25,>10B7
	.word	>4059,228,225,>10C0
	.word	>4059,228,200,>10C0
	.word	>4059,228,175,>10C0
	.word	>4059,228,150,>10C0
	.word	>4059,228,125,>10C0
	.word	>4059,228,100,>10C0
	.word	>4040,240,250,>39
	.word	>4049,240,0,>10B7
	.word	>4040,240,386,>39
	.word	>6E4A,240,150,>1096
	.word	>4047,240,294,>103C
	.word	>4049,252,225,>10B7
	.word	>4049,252,200,>10B1
	.word	>4049,252,125,>10BD
	.word	>4049,252,100,>10B1
	.word	>4049,252,75,>10B7
	.word	>4049,252,50,>10B1
	.word	>4049,252,25,>10B7
	.word	>4043,260,125,>10BA
	.word	>4040,300,250,>39
	.word	>4049,300,200,>10B7
	.word	>4049,300,100,>10B7
	.word	>4049,300,50,>10B7
	.word	>4049,300,0,>10B7
	.word	>4040,300,386,>39
	.word	>4057,300,294,>103C
	.word	>4049,312,225,>10B1
	.word	>4049,312,75,>10B1
	.word	>4049,312,25,>10B1
	.word	>4049,348,125,>10B4
	.word	0FFFFH	;End Marker

OFFICE1BLKS:
	.word	>4040	;flags
	.word	0,264 ;x,y
	.word	>39	;pal5,pal4,hdr13-0
	.word	>4040,0,400,>39
	.word	>4043,0,112,>10CF
	.word	>4053,0,20,>10D2
	.word	>4043,0,0,>10D5
	.word	>4042,0,132,>10D8
	.word	>6442,0,201,>10DB
	.word	>4047,0,308,>103C
	.word	>4043,4,112,>10D5
	.word	>4053,4,20,>10DE
	.word	>4043,24,152,>10E1
	.word	>4048,24,132,>10D5
	.word	>4043,32,0,>10D5
	.word	>4043,36,112,>10D5
	.word	>4053,36,20,>10DE
	.word	>4043,56,152,>10E4
	.word	>4048,56,132,>10D5
	.word	>4040,60,264,>39
	.word	>4040,60,400,>39
	.word	>4057,60,308,>103C
	.word	>4043,64,0,>10D5
	.word	>4043,68,112,>10D5
	.word	>4053,68,20,>10DE
	.word	>4048,88,132,>10D5
	.word	>4053,96,152,>10E4
	.word	>4043,96,0,>10D5
	.word	>4043,100,112,>10D5
	.word	>4053,100,20,>10DE
	.word	>4040,120,264,>39
	.word	>4048,120,132,>10D5
	.word	>4040,120,400,>39
	.word	>4047,120,308,>103C
	.word	>4043,128,0,>10D5
	.word	>4043,132,112,>10D5
	.word	>4053,132,20,>10DE
	.word	>4053,136,152,>10E1
	.word	>4048,136,132,>10D5
	.word	>4043,160,0,>10D5
	.word	>4043,164,112,>10D5
	.word	>4053,164,20,>10DE
	.word	>4042,168,132,>10D8
	.word	>6442,168,201,>10DB
	.word	>4040,180,264,>39
	.word	>4040,180,400,>39
	.word	>4057,180,308,>103C
	.word	>4043,192,152,>10E1
	.word	>4048,192,132,>10D5
	.word	>4043,192,0,>10D5
	.word	>4043,196,112,>10D5
	.word	>4053,196,20,>10DE
	.word	>4043,224,152,>10E4
	.word	>4048,224,132,>10D5
	.word	>4043,224,0,>10D5
	.word	>4043,228,112,>10D5
	.word	>4053,228,20,>10DE
	.word	>4040,240,264,>39
	.word	>4040,240,264,>39
	.word	>4040,240,400,>39
	.word	>4047,240,308,>103C
	.word	>4048,256,132,>10D5
	.word	>4043,256,0,>10D5
	.word	>4043,260,112,>10D5
	.word	>4053,260,20,>10DE
	.word	>4053,264,152,>10E4
	.word	>4048,288,132,>10D5
	.word	>4043,288,0,>10D5
	.word	>4043,292,112,>10D5
	.word	>4053,292,20,>10DE
	.word	>4040,300,264,>39
	.word	>4040,300,400,>39
	.word	>4057,300,308,>103C
	.word	>4053,304,152,>10E1
	.word	>4048,304,132,>10D5
	.word	>4043,320,0,>10D5
	.word	>4043,324,112,>10D5
	.word	>4053,324,20,>10DE
	.word	>4042,336,132,>10D8
	.word	>6442,336,201,>10DB
	.word	>4043,352,0,>10CF
	.word	>4043,356,112,>10CF
	.word	>4043,356,20,>10D2
	.word	>4043,356,0,>10CF
	.word	0FFFFH	;End Marker

BIGBANKBLKS:
	.word	>4042	;flags
	.word	0,198 ;x,y
	.word	>106F	;pal5,pal4,hdr13-0
	.word	>4042,0,132,>106F
	.word	>4042,0,66,>106F
	.word	>4042,0,0,>106F
	.word	>4040,0,264,>39
	.word	>4040,0,400,>39
	.word	>4047,0,308,>103C
	.word	>404B,28,230,>1072
	.word	>404B,28,132,>1075
	.word	>404B,28,98,>1072
	.word	>404B,28,0,>1075
	.word	>4040,60,264,>39
	.word	>4040,60,400,>39
	.word	>4057,60,308,>103C
	.word	>404B,72,230,>1072
	.word	>404B,72,132,>1075
	.word	>404B,72,98,>1072
	.word	>404B,72,0,>1075
	.word	>404B,116,230,>1072
	.word	>404B,116,132,>1075
	.word	>404B,116,98,>1072
	.word	>404B,116,0,>1075
	.word	>4040,120,264,>39
	.word	>4040,120,400,>39
	.word	>4047,120,308,>103C
	.word	>404B,160,98,>1072
	.word	>404B,160,0,>1075
	.word	>404B,160,154,>1078
	.word	>404B,160,132,>107B
	.word	>404B,176,132,>107B
	.word	>4040,180,264,>39
	.word	>4040,180,400,>39
	.word	>4057,180,308,>103C
	.word	>404B,192,132,>107E
	.word	>404B,204,98,>1072
	.word	>404B,204,0,>1075
	.word	>404B,232,154,>1081
	.word	>4040,240,264,>39
	.word	>4040,240,400,>39
	.word	>4047,240,308,>103C
	.word	>404B,248,98,>1072
	.word	>404B,248,0,>1075
	.word	>404B,252,154,>1084
	.word	>404B,255,168,>1087
	.word	>405B,288,154,>1081
	.word	>404B,292,98,>1072
	.word	>404B,292,0,>1075
	.word	>4040,300,264,>39
	.word	>4040,300,400,>39
	.word	>4057,300,308,>103C
	.word	>405B,308,154,>1078
	.word	>404B,336,98,>1072
	.word	>404B,336,0,>1075
	.word	>404B,348,132,>107B
	.word	>4040,360,264,>39
	.word	>4040,360,400,>39
	.word	>4047,360,308,>103C
	.word	>404B,364,132,>107B
	.word	>404B,380,230,>1072
	.word	>404B,380,132,>1075
	.word	>404B,380,98,>1072
	.word	>404B,380,0,>1075
	.word	>4040,420,264,>39
	.word	>4040,420,400,>39
	.word	>4057,420,308,>103C
	.word	>404B,424,230,>1072
	.word	>404B,424,132,>1075
	.word	>404B,424,98,>1072
	.word	>404B,424,0,>1075
	.word	>404B,468,230,>1072
	.word	>404B,468,132,>1075
	.word	>404B,468,98,>1072
	.word	>404B,468,0,>1075
	.word	>4040,480,264,>39
	.word	>4040,480,400,>39
	.word	>4047,480,308,>103C
	.word	>4052,512,198,>106F
	.word	>4052,512,132,>106F
	.word	>4052,512,66,>106F
	.word	>4052,512,0,>106F
	.word	0FFFFH	;End Marker

BIGBLDRBLKS:
	.word	>407B	;flags
	.word	0,106 ;x,y
	.word	>102D	;pal5,pal4,hdr13-0
	.word	>407B,0,181,>102D
	.word	>404B,0,0,>1033
	.word	>404B,0,256,>1036
	.word	>A40,0,272,>39
	.word	>A40,0,408,>39
	.word	>4047,0,316,>103C
	.word	>404B,8,0,>103F
	.word	>405B,40,106,>102D
	.word	>407B,40,181,>102D
	.word	>404B,48,256,>1036
	.word	>405B,52,0,>103F
	.word	>A40,60,272,>39
	.word	>A40,60,408,>39
	.word	>4057,60,316,>103C
	.word	>404B,80,181,>102D
	.word	>405B,80,106,>102D
	.word	>405B,96,0,>1033
	.word	>404B,96,256,>1036
	.word	>404B,104,0,>103F
	.word	>404B,120,159,>1045
	.word	>404B,120,106,>1048
	.word	>404B,120,203,>1048
	.word	>A40,120,272,>39
	.word	>A40,120,408,>39
	.word	>4047,120,316,>103C
	.word	>404B,144,256,>1036
	.word	>404B,148,0,>104E
	.word	>407B,168,106,>1048
	.word	>404B,168,203,>1048
	.word	>A40,180,272,>39
	.word	>A40,180,408,>39
	.word	>4057,180,316,>103C
	.word	>404B,192,0,>1033
	.word	>404B,192,256,>1036
	.word	>405B,200,0,>104E
	.word	>404B,216,106,>1048
	.word	>404B,216,203,>1048
	.word	>404B,240,256,>1036
	.word	>A40,240,272,>39
	.word	>A40,240,408,>39
	.word	>4047,240,316,>103C
	.word	>404B,244,0,>104E
	.word	>407B,264,106,>102D
	.word	>407B,264,181,>102D
	.word	>406B,288,0,>1033
	.word	>404B,288,256,>1036
	.word	>404B,296,0,>103F
	.word	>A40,300,272,>39
	.word	>A40,300,408,>39
	.word	>4057,300,316,>103C
	.word	>404B,304,106,>102D
	.word	>405B,304,181,>102D
	.word	>404B,336,256,>1036
	.word	>404B,340,0,>104E
	.word	>406B,344,106,>1051
	.word	>404B,344,181,>1051
	.word	>A40,360,272,>39
	.word	>A40,360,408,>39
	.word	>4047,360,316,>103C
	.word	>404B,372,256,>1036
	.word	>404B,384,0,>1033
	.word	>405B,392,0,>1054
	.word	>405B,392,64,>1054
	.word	>405B,392,128,>1054
	.word	>405B,392,192,>1054
	.word	0FFFFH	;End Marker

BIGBLDLBLKS:
	.word	>A40	;flags
	.word	0,272 ;x,y
	.word	>39	;pal5,pal4,hdr13-0
	.word	>404B,0,192,>1054
	.word	>407B,0,128,>1054
	.word	>405B,0,64,>1054
	.word	>404B,0,0,>1054
	.word	>404B,0,256,>1036
	.word	>A40,0,408,>39
	.word	>4057,0,316,>103C
	.word	>406B,28,106,>1051
	.word	>404B,28,181,>1051
	.word	>404B,28,0,>1033
	.word	>404B,36,256,>1036
	.word	>404B,36,0,>103F
	.word	>A40,60,272,>39
	.word	>A40,60,408,>39
	.word	>4047,60,316,>103C
	.word	>404B,76,106,>102D
	.word	>405B,76,181,>102D
	.word	>404B,80,0,>104E
	.word	>404B,84,256,>1036
	.word	>407B,116,106,>102D
	.word	>407B,116,181,>102D
	.word	>A40,120,272,>39
	.word	>A40,120,408,>39
	.word	>4057,120,316,>103C
	.word	>405B,124,0,>1033
	.word	>404B,132,256,>1036
	.word	>405B,132,0,>104E
	.word	>404B,156,159,>1045
	.word	>405B,156,203,>1048
	.word	>404B,156,106,>1048
	.word	>404B,176,0,>104E
	.word	>A40,180,272,>39
	.word	>404B,180,256,>1036
	.word	>A40,180,408,>39
	.word	>4047,180,316,>103C
	.word	>404B,204,203,>1048
	.word	>407B,204,106,>1048
	.word	>404B,220,0,>1033
	.word	>404B,228,256,>1036
	.word	>404B,228,0,>103F
	.word	>A40,240,272,>39
	.word	>A40,240,408,>39
	.word	>4057,240,316,>103C
	.word	>406B,252,203,>1048
	.word	>406B,252,106,>1048
	.word	>404B,272,0,>104E
	.word	>404B,276,256,>1036
	.word	>404B,300,181,>102D
	.word	>405B,300,106,>102D
	.word	>A40,300,272,>39
	.word	>A40,300,408,>39
	.word	>4047,300,316,>103C
	.word	>407B,316,0,>1033
	.word	>404B,324,256,>1036
	.word	>404B,324,0,>103F
	.word	>406B,340,181,>102D
	.word	>404B,340,106,>102D
	.word	>A40,360,272,>39
	.word	>A40,360,408,>39
	.word	>4057,360,316,>103C
	.word	>405B,368,0,>103F
	.word	>404B,372,256,>1036
	.word	>404B,380,181,>102D
	.word	>405B,380,106,>102D
	.word	>405B,412,0,>1033
	.word	0FFFFH	;End Marker

BIGEL1BLKS:
	.word	>4044	;flags
	.word	0,181 ;x,y
	.word	>106C	;pal5,pal4,hdr13-0
	.word	>4044,0,90,>106C
	.word	>4044,0,0,>106C
	.word	>A40,0,408,>39
	.word	>A40,0,272,>39
	.word	>4047,0,316,>103C
	.word	>404B,8,181,>1024
	.word	>404B,8,90,>1024
	.word	>404B,8,0,>1024
	.word	>404B,12,181,>102A
	.word	>404B,12,106,>102A
	.word	>404B,12,0,>1027
	.word	>404B,12,256,>1036
	.word	>405B,20,181,>102D
	.word	>405B,20,106,>102D
	.word	>404B,60,181,>102D
	.word	>404B,60,106,>102D
	.word	>A40,60,272,>39
	.word	>404B,60,256,>1036
	.word	>A40,60,408,>39
	.word	>4057,60,316,>103C
	.word	>404B,100,181,>1042
	.word	>404B,100,106,>1042
	.word	>405B,100,0,>1027
	.word	>404B,108,181,>1024
	.word	>404B,108,90,>1024
	.word	>404B,108,0,>1024
	.word	>4044,112,181,>106C
	.word	>4044,112,90,>106C
	.word	>4044,112,0,>106C
	.word	0FFFFH	;End Marker

BIGFLR10BLKS:
	.word	>404D	;flags
	.word	0,180 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,316,>1003
	.word	>404D,0,0,>1012
	.word	>4046,0,61,>15
	.word	>4046,0,45,>18
	.word	>404D,20,0,>101B
	.word	>4056,60,45,>18
	.word	>404D,104,0,>1012
	.word	>4056,108,61,>15
	.word	0FFFFH	;End Marker

SFINT1BLKS:
	.word	>4044	;flags
	.word	0,144 ;x,y
	.word	>C	;pal5,pal4,hdr13-0
	.word	>4044,0,120,>F
	.word	>4043,0,96,>C
	.word	>4044,0,48,>6
	.word	>4043,0,24,>C
	.word	>4044,0,0,>6
	.word	>4044,0,72,>6
	.word	>4044,0,168,>6
	.word	>4043,24,0,>F
	.word	>4043,24,168,>C
	.word	>4044,34,72,>6
	.word	>4044,34,48,>6
	.word	>4043,40,144,>F
	.word	>4044,40,96,>6
	.word	>4044,40,24,>F
	.word	>4043,60,120,>6
	.word	>4044,64,168,>F
	.word	>4044,64,96,>F
	.word	>4044,67,48,>6
	.word	>4044,67,72,>6
	.word	>4044,84,120,>C
	.word	>4044,84,0,>C
	.word	>4043,100,144,>6
	.word	>4044,100,72,>6
	.word	>4044,100,48,>6
	.word	>4044,100,24,>6
	.word	0FFFFH	;End Marker

SFINT2BLKS:
	.word	>4046	;flags
	.word	0,65 ;x,y
	.word	>15	;pal5,pal4,hdr13-0
	.word	>4046,0,49,>18
	.word	>4044,0,0,>F
	.word	>4044,0,24,>6
	.word	>4044,24,24,>F
	.word	>4056,60,49,>18
	.word	>4044,60,0,>6
	.word	>4044,84,24,>C
	.word	>4044,84,0,>C
	.word	>4056,108,65,>15
	.word	0FFFFH	;End Marker

SFINWALBBLKS:
	.word	>A4D	;flags
	.word	0,184 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,320,>1003
	.word	>4044,0,160,>6
	.word	>4060,0,24,>1009
	.word	>4040,0,92,>1009
	.word	>4044,0,0,>6
	.word	>4043,24,160,>C
	.word	>4043,24,0,>C
	.word	>4070,60,24,>1009
	.word	>4050,60,92,>1009
	.word	>4044,64,160,>F
	.word	>4044,64,0,>F
	.word	0FFFFH	;End Marker

SFINWALSBLKS:
	.word	>A49	;flags
	.word	0,184 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,320,>1003
	.word	>4043,0,160,>6
	.word	>4048,0,92,>9
	.word	>4068,0,24,>9
	.word	>4044,0,0,>6
	.word	>4043,24,160,>C
	.word	>4043,24,0,>C
	.word	>4078,60,24,>9
	.word	>4058,60,92,>9
	.word	>4044,64,0,>F
	.word	>4044,64,160,>F
	.word	0FFFFH	;End Marker

SFINWALGBLKS:
	.word	>4042	;flags
	.word	0,184 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,320,>1003
	.word	>4043,0,160,>6
	.word	>4045,0,92,>9
	.word	>4065,0,24,>9
	.word	>4044,0,0,>6
	.word	>4043,24,160,>C
	.word	>4043,24,0,>C
	.word	>4055,60,92,>9
	.word	>4075,60,24,>9
	.word	>4044,64,160,>F
	.word	>4044,64,0,>F
	.word	0FFFFH	;End Marker

SFINWAGRBLKS:
	.word	>A4E	;flags
	.word	0,184 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,320,>1003
	.word	>4044,0,160,>6
	.word	>404B,0,92,>9
	.word	>406B,0,24,>9
	.word	>4044,0,0,>6
	.word	>4043,24,160,>C
	.word	>4043,24,0,>C
	.word	>405B,60,92,>9
	.word	>407B,60,24,>9
	.word	>4044,64,160,>F
	.word	>4044,64,0,>F
	.word	0FFFFH	;End Marker

SFINWALRBLKS:
	.word	>404B	;flags
	.word	0,320 ;x,y
	.word	>1003	;pal5,pal4,hdr13-0
	.word	>A41,0,184,>0
	.word	>4044,0,160,>6
	.word	>404F,0,92,>9
	.word	>406F,0,24,>9
	.word	>4044,0,0,>6
	.word	>4043,24,160,>C
	.word	>4043,24,0,>C
	.word	>405F,60,92,>9
	.word	>407F,60,24,>9
	.word	>4044,64,160,>F
	.word	>4044,64,0,>F
	.word	0FFFFH	;End Marker

SFINFLRBBLKS:
	.word	>404D	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,136,>1003
	.word	0FFFFH	;End Marker

SFINFLRSBLKS:
	.word	>4049	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,136,>1003
	.word	0FFFFH	;End Marker

SFINFLRGBLKS:
	.word	>4042	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,136,>1003
	.word	0FFFFH	;End Marker

SFINFLGRBLKS:
	.word	>404E	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,136,>1003
	.word	0FFFFH	;End Marker

SFINFLRRBLKS:
	.word	>4041	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>404B,0,136,>1003
	.word	0FFFFH	;End Marker

SFINT1ABLKS:
	.word	>4044	;flags
	.word	0,0 ;x,y
	.word	>6	;pal5,pal4,hdr13-0
	.word	>4044,0,24,>6
	.word	>4043,0,48,>C
	.word	>4044,0,72,>6
	.word	>4044,0,96,>6
	.word	>4044,0,120,>F
	.word	>4044,0,144,>6
	.word	>4043,0,168,>6
	.word	>4043,24,0,>F
	.word	>4043,24,168,>F
	.word	>4043,24,144,>C
	.word	>4044,33,24,>6
	.word	>4044,33,96,>6
	.word	>4044,33,72,>6
	.word	>4044,40,48,>6
	.word	>4043,60,120,>6
	.word	>4044,64,48,>F
	.word	>4044,64,144,>F
	.word	>4044,66,72,>6
	.word	>4044,66,96,>6
	.word	>4044,67,24,>6
	.word	>4044,84,0,>C
	.word	>4044,84,120,>C
	.word	>4044,84,168,>C
	.word	>4044,100,24,>6
	.word	>4044,100,72,>6
	.word	>4044,100,96,>6
	.word	0FFFFH	;End Marker

SFINT1BBLKS:
	.word	>4043	;flags
	.word	0,168 ;x,y
	.word	>6	;pal5,pal4,hdr13-0
	.word	>4043,0,144,>F
	.word	>4044,0,120,>6
	.word	>4044,0,96,>6
	.word	>4044,0,48,>6
	.word	>4044,0,24,>6
	.word	>4044,0,0,>C
	.word	>4043,0,72,>C
	.word	>4043,24,168,>C
	.word	>4044,34,120,>6
	.word	>4044,34,24,>6
	.word	>4044,34,48,>6
	.word	>4044,34,96,>6
	.word	>4043,40,0,>F
	.word	>4044,40,72,>6
	.word	>4043,60,144,>6
	.word	>4044,64,168,>F
	.word	>4044,64,72,>F
	.word	>4044,67,120,>6
	.word	>4044,67,48,>6
	.word	>4044,67,24,>6
	.word	>4044,67,96,>6
	.word	>4044,84,144,>C
	.word	>4044,100,120,>6
	.word	>4043,100,0,>6
	.word	>4044,100,24,>6
	.word	>4044,100,48,>6
	.word	>4044,100,96,>6
	.word	0FFFFH	;End Marker

SFINT1CBLKS:
	.word	>4044	;flags
	.word	0,0 ;x,y
	.word	>F	;pal5,pal4,hdr13-0
	.word	>4044,0,24,>6
	.word	>4043,0,48,>C
	.word	>4044,0,72,>6
	.word	>4044,0,96,>C
	.word	>4044,0,144,>F
	.word	>4043,0,168,>F
	.word	>4043,0,120,>6
	.word	>4043,24,120,>F
	.word	>4044,33,24,>6
	.word	>4044,34,72,>6
	.word	>4044,40,48,>6
	.word	>4043,40,96,>6
	.word	>4043,60,0,>6
	.word	>4044,60,144,>6
	.word	>4044,60,168,>C
	.word	>4044,64,48,>F
	.word	>4044,64,96,>F
	.word	>4044,67,24,>6
	.word	>4044,67,72,>6
	.word	>4044,84,0,>C
	.word	>4043,84,144,>C
	.word	>4044,84,120,>C
	.word	>4044,100,24,>6
	.word	>4044,100,72,>6
	.word	>4043,100,168,>6
	.word	0FFFFH	;End Marker

RISEMOD0BLKS:
	.word	0FFFFH		;End Marker
BIGFLR4SBMOD:
	.word	124,338,10	;x size, y size, #blocks
	.long	BIGFLR4SBLKS, RISEHDRS, RISEPALS
BIGFLR1SBMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR1SBLKS, RISEHDRS, RISEPALS
BIGFLR10SBMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR10SBLKS, RISEHDRS, RISEPALS
BIGFLR9SBMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR9SBLKS, RISEHDRS, RISEPALS
BIGFLR8SBMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR8SBLKS, RISEHDRS, RISEPALS
SAFEFBBMOD:
	.word	124,136,1	;x size, y size, #blocks
	.long	SAFEFBBLKS, RISEHDRS, RISEPALS
SAFEFGRBMOD:
	.word	124,136,1	;x size, y size, #blocks
	.long	SAFEFGRBLKS, RISEHDRS, RISEPALS
SAFEFSBMOD:
	.word	124,136,1	;x size, y size, #blocks
	.long	SAFEFSBLKS, RISEHDRS, RISEPALS
SAFEFGBMOD:
	.word	124,136,1	;x size, y size, #blocks
	.long	SAFEFGBLKS, RISEHDRS, RISEPALS
SAFEFRBMOD:
	.word	124,136,1	;x size, y size, #blocks
	.long	SAFEFRBLKS, RISEHDRS, RISEPALS
BIGFLR9BMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR9BLKS, RISEHDRS, RISEPALS
BIGFLR8BMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR8BLKS, RISEHDRS, RISEPALS
BIGFLR7BMOD:
	.word	124,338,18	;x size, y size, #blocks
	.long	BIGFLR7BLKS, RISEHDRS, RISEPALS
BIGFLR6BMOD:
	.word	124,345,13	;x size, y size, #blocks
	.long	BIGFLR6BLKS, RISEHDRS, RISEPALS
BIGFLR5BMOD:
	.word	124,345,15	;x size, y size, #blocks
	.long	BIGFLR5BLKS, RISEHDRS, RISEPALS
BIGFLR4BMOD:
	.word	124,338,10	;x size, y size, #blocks
	.long	BIGFLR4BLKS, RISEHDRS, RISEPALS
BIGFLR3BMOD:
	.word	124,345,11	;x size, y size, #blocks
	.long	BIGFLR3BLKS, RISEHDRS, RISEPALS
BIGFLRBMOD:
	.word	124,339,16	;x size, y size, #blocks
	.long	BIGFLRBLKS, RISEHDRS, RISEPALS
BIGFLR1BMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR1BLKS, RISEHDRS, RISEPALS
SNOBWINBMOD:
	.word	240,408,58	;x size, y size, #blocks
	.long	SNOBWINBLKS, RISEHDRS, RISEPALS
SNOBDORBMOD:
	.word	180,408,28	;x size, y size, #blocks
	.long	SNOBDORBLKS, RISEHDRS, RISEPALS
FANNYCOBMOD:
	.word	360,430,76	;x size, y size, #blocks
	.long	FANNYCOBLKS, RISEHDRS, RISEPALS
OFFICE1BMOD:
	.word	360,444,82	;x size, y size, #blocks
	.long	OFFICE1BLKS, RISEHDRS, RISEPALS
BIGBANKBMOD:
	.word	540,444,80	;x size, y size, #blocks
	.long	BIGBANKBLKS, RISEHDRS, RISEPALS
BIGBLDRBMOD:
	.word	420,452,66	;x size, y size, #blocks
	.long	BIGBLDRBLKS, RISEHDRS, RISEPALS
BIGBLDLBMOD:
	.word	420,452,66	;x size, y size, #blocks
	.long	BIGBLDLBLKS, RISEHDRS, RISEPALS
BIGEL1BMOD:
	.word	120,452,30	;x size, y size, #blocks
	.long	BIGEL1BLKS, RISEHDRS, RISEPALS
BIGFLR10BMOD:
	.word	124,338,9	;x size, y size, #blocks
	.long	BIGFLR10BLKS, RISEHDRS, RISEPALS
SFINT1BMOD:
	.word	124,192,26	;x size, y size, #blocks
	.long	SFINT1BLKS, RISEHDRS, RISEPALS
SFINT2BMOD:
	.word	124,184,10	;x size, y size, #blocks
	.long	SFINT2BLKS, RISEHDRS, RISEPALS
SFINWALBBMOD:
	.word	124,342,12	;x size, y size, #blocks
	.long	SFINWALBBLKS, RISEHDRS, RISEPALS
SFINWALSBMOD:
	.word	124,342,12	;x size, y size, #blocks
	.long	SFINWALSBLKS, RISEHDRS, RISEPALS
SFINWALGBMOD:
	.word	124,342,12	;x size, y size, #blocks
	.long	SFINWALGBLKS, RISEHDRS, RISEPALS
SFINWAGRBMOD:
	.word	124,342,12	;x size, y size, #blocks
	.long	SFINWAGRBLKS, RISEHDRS, RISEPALS
SFINWALRBMOD:
	.word	124,342,12	;x size, y size, #blocks
	.long	SFINWALRBLKS, RISEHDRS, RISEPALS
SFINFLRBBMOD:
	.word	124,158,2	;x size, y size, #blocks
	.long	SFINFLRBBLKS, RISEHDRS, RISEPALS
SFINFLRSBMOD:
	.word	124,158,2	;x size, y size, #blocks
	.long	SFINFLRSBLKS, RISEHDRS, RISEPALS
SFINFLRGBMOD:
	.word	124,158,2	;x size, y size, #blocks
	.long	SFINFLRGBLKS, RISEHDRS, RISEPALS
SFINFLGRBMOD:
	.word	124,158,2	;x size, y size, #blocks
	.long	SFINFLGRBLKS, RISEHDRS, RISEPALS
SFINFLRRBMOD:
	.word	124,158,2	;x size, y size, #blocks
	.long	SFINFLRRBLKS, RISEHDRS, RISEPALS
SFINT1ABMOD:
	.word	124,192,27	;x size, y size, #blocks
	.long	SFINT1ABLKS, RISEHDRS, RISEPALS
SFINT1BBMOD:
	.word	124,192,28	;x size, y size, #blocks
	.long	SFINT1BBLKS, RISEHDRS, RISEPALS
SFINT1CBMOD:
	.word	124,192,26	;x size, y size, #blocks
	.long	SFINT1CBLKS, RISEHDRS, RISEPALS

msuHDRS:
	.word	12,6	;x size, y size
	.long	>0		;anim
	.long	>3BD5FC0	;address
	.word	100,6
	.long	>0,>3BD6200
	.word	84,1
	.long	>0,>3BD74C0
	.word	100,2
	.long	>0,>3BD7760
	.word	4,53
	.long	>0,>3BD7DA0
	.word	84,14
	.long	>0,>3BD8440
	.word	4,73
	.long	>0,>3BDA900
	.word	64,123
	.long	>0,>3BDB220
	.word	4,57
	.long	>0,>3BEA820
	.word	76,2
	.long	>0,>3BEAF40
	.word	76,1
	.long	>0,>3BEB400
	.word	68,1
	.long	>0,>3BEB660
	.word	40,29
	.long	>0,>3BEB880
	.word	24,23
	.long	>0,>3BEDCC0
	.word	72,58
	.long	>0,>3BEEE00
	.word	16,8
	.long	>0,>3BF7080
	.word	24,1
	.long	>0,>3BF7480
	.word	4,73
	.long	>0,>3BF7540
	.word	28,35
	.long	>0,>3BF7E60
	.word	28,17
	.long	>0,>3BF9D00
	.word	4,21
	.long	>0,>3BFABE0
	.word	4,28
	.long	>0,>3BFAE80
	.word	4,17
	.long	>0,>3BFB200
	.word	8,20
	.long	>0,>3BFB420
	.word	108,2
	.long	>0,>3BFB920
	.word	108,2
	.long	>0,>3BFBFE0
	.word	52,20
	.long	>0,>3BFC6A0
	.word	20,21
	.long	>0,>3BFE720
	.word	20,28
	.long	>0,>3BFF440
	.word	24,28
	.long	>0,>3C005C0
	.word	32,30
	.long	>0,>3C01AC0
	.word	88,39
	.long	>0,>3C038C0
	.word	16,20
	.long	>0,>3C0A400
	.word	20,20
	.long	>0,>3C0AE00
	.word	16,20
	.long	>0,>3C0BA80
	.word	144,20
	.long	>0,>3C0C480
	.word	104,1
	.long	>0,>3C11E80
	.word	20,6
	.long	>0,>3C121C0
	.word	8,6
	.long	>0,>3C12580
	.word	4,105
	.long	>0,>3C12700
	.word	32,2
	.long	>0,>3C13420
	.word	84,14
	.long	>0,>3C13620
	.word	32,1
	.long	>0,>3C15AE0
	.word	40,49
	.long	>0,>3C15BE0
	.word	36,28
	.long	>0,>3C19920
	.word	4,71
	.long	>0,>3C1B8A0
	.word	16,8
	.long	>0,>3C1C180
	.word	16,8
	.long	>0,>3C1C580
	.word	64,2
	.long	>0,>3C1C980
	.word	64,1
	.long	>0,>3C1CD80
	.word	20,21
	.long	>0,>3C1CF80
	.word	20,21
	.long	>0,>3C1CF80
	.word	4,105
	.long	>0,>3C1DCA0
	.word	44,3
	.long	>0,>3C1E9C0
	.word	4,70
	.long	>0,>3C1EDE0
	.word	16,6
	.long	>0,>3C1F6A0
	.word	12,53
	.long	>0,>3C1F9A0
	.word	8,7
	.long	>0,>3C20D80
	.word	8,7
	.long	>0,>3C20D80
	.word	44,18
	.long	>0,>3C20F40
	.word	124,37
	.long	>0,>3C22800
	.word	40,50
	.long	>0,>3C2B760
	.word	20,20
	.long	>0,>3C2F5E0


dashBLKS:
	.word	>4041	;flags
	.word	0,56 ;x,y
	.word	>57	;pal5,pal4,hdr13-0
	.word	>4071,13,23,>5A
	.word	>4051,23,50,>5D
	.word	>4041,32,0,>63
	.word	>4041,52,23,>63
	.word	>4041,52,0,>63
	.word	>4041,72,23,>63
	.word	>4041,72,0,>63
	.word	>4041,92,23,>63
	.word	>4041,92,0,>63
	.word	>4041,111,50,>5D
	.word	>4041,112,23,>63
	.word	>4041,112,0,>63
	.word	>4041,132,23,>63
	.word	>4041,132,0,>63
	.word	>4041,152,23,>63
	.word	>4041,152,0,>63
	.word	>4041,172,0,>63
	.word	>4061,175,24,>5A
	.word	>4051,196,56,>57
	.word	>4051,209,1,>2A
	.word	>4051,226,66,>51
	.word	>4051,256,67,>30
	.word	>4051,256,68,>42
	.word	>3C51,264,3,>2D
	.word	>3C51,264,11,>2D
	.word	>3C51,264,19,>2D
	.word	>3C51,264,27,>2D
	.word	>3C51,264,35,>2D
	.word	>3C51,264,43,>2D
	.word	>3C51,264,51,>2D
	.word	>3C51,264,59,>2D
	.word	0FFFFH	;End Marker

handBLKS:
	.word	>5144	;flags
	.word	0,58 ;x,y
	.word	>B4	;pal5,pal4,hdr13-0
	.word	>5144,21,8,>B7
	.word	>5041,52,0,>BA
	.word	0FFFFH	;End Marker

ledsBLKS:
	.word	>4F50	;flags
	.word	0,131 ;x,y
	.word	>A8	;pal5,pal4,hdr13-0
	.word	>4F50,12,131,>A8
	.word	>4D40,21,195,>AB
	.word	>4F50,24,131,>A8
	.word	>4F50,36,131,>A8
	.word	>4F50,48,131,>A8
	.word	>4F50,60,131,>A8
	.word	>4B40,145,275,>AE
	.word	>4B40,335,275,>AE
	.word	>4C40,421,28,>AB
	.word	>4C40,421,58,>AB
	.word	>4E40,446,0,>B1
	.word	0FFFFH	;End Marker

mainBLKS:
	.word	>4041	;flags
	.word	0,43 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4041,0,53,>0
	.word	>4041,0,63,>0
	.word	>4041,0,73,>0
	.word	>4041,0,83,>0
	.word	>4041,0,93,>0
	.word	>4041,0,103,>0
	.word	>4041,0,113,>0
	.word	>4041,0,123,>0
	.word	>4041,0,133,>0
	.word	>3C41,0,223,>3
	.word	>3C41,0,213,>3
	.word	>3C41,0,203,>3
	.word	>3C41,0,193,>3
	.word	>3C41,0,183,>3
	.word	>3C41,0,173,>3
	.word	>3C41,0,163,>3
	.word	>4041,0,233,>0
	.word	>4041,0,243,>0
	.word	>4041,0,263,>0
	.word	>4041,0,273,>0
	.word	>4041,0,283,>0
	.word	>4041,0,293,>0
	.word	>3C41,0,33,>3
	.word	>3C41,0,303,>0
	.word	>4041,0,318,>6
	.word	>4041,0,143,>0
	.word	>4041,0,153,>0
	.word	>3B41,0,26,>9
	.word	>3B41,0,308,>3
	.word	>4041,0,253,>0
	.word	>4040,9,176,>C
	.word	>4040,9,159,>F
	.word	>4041,12,232,>12
	.word	>4143,12,266,>15
	.word	>4042,12,43,>18
	.word	>4062,12,99,>18
	.word	>4041,13,232,>1B
	.word	>4041,13,304,>1E
	.word	>4041,16,43,>21
	.word	>4041,16,155,>21
	.word	>4040,18,235,>24
	.word	>4051,60,236,>27
	.word	>4051,60,258,>27
	.word	>4051,60,280,>27
	.word	>4041,83,316,>2A
	.word	>4072,83,99,>18
	.word	>4052,83,43,>18
	.word	>3C41,84,318,>2D
	.word	>3C41,84,326,>2D
	.word	>3C41,84,334,>2D
	.word	>3C41,84,342,>2D
	.word	>3C41,84,350,>2D
	.word	>3C41,84,358,>2D
	.word	>3C41,84,366,>2D
	.word	>3C41,84,374,>2D
	.word	>4041,84,382,>30
	.word	>4050,85,176,>C
	.word	>4041,86,232,>33
	.word	>4041,87,43,>0
	.word	>4041,87,53,>0
	.word	>4041,87,63,>0
	.word	>4041,87,73,>0
	.word	>4041,87,83,>0
	.word	>4041,87,93,>0
	.word	>4041,87,103,>0
	.word	>4041,87,113,>0
	.word	>4041,87,123,>0
	.word	>4041,87,133,>0
	.word	>4041,87,143,>0
	.word	>4041,88,153,>0
	.word	>3C41,90,233,>0
	.word	>3C41,90,243,>0
	.word	>3C41,90,253,>0
	.word	>3C41,90,263,>0
	.word	>3C41,90,273,>0
	.word	>3C41,90,283,>0
	.word	>3C41,90,293,>0
	.word	>3C41,90,303,>0
	.word	>4040,99,0,>36
	.word	>4040,99,35,>39
	.word	>4040,99,52,>39
	.word	>4040,99,69,>39
	.word	>4040,99,86,>39
	.word	>4040,99,103,>39
	.word	>4040,99,120,>39
	.word	>4040,99,137,>39
	.word	>4040,99,154,>39
	.word	>4040,99,171,>39
	.word	>4040,99,204,>39
	.word	>4040,99,187,>39
	.word	>4060,99,221,>36
	.word	>4040,101,291,>3C
	.word	>3C41,102,248,>0
	.word	>4041,102,258,>3F
	.word	>4041,104,383,>42
	.word	>4040,105,291,>45
	.word	>4041,105,284,>48
	.word	>4041,106,258,>4B
	.word	>4040,113,291,>4E
	.word	>4041,119,380,>51
	.word	>4040,127,0,>54
	.word	>4060,127,228,>54
	.word	>4040,147,0,>54
	.word	>4060,147,228,>54
	.word	>4040,165,291,>45
	.word	>4040,167,0,>54
	.word	>4060,167,228,>54
	.word	>4040,173,291,>60
	.word	>4040,187,0,>54
	.word	>4060,187,228,>54
	.word	>4040,189,291,>66
	.word	>4040,205,291,>66
	.word	>4040,207,0,>54
	.word	>4060,207,228,>54
	.word	>4041,213,284,>48
	.word	>4041,213,258,>4B
	.word	>4040,221,291,>66
	.word	>4040,227,0,>54
	.word	>4060,227,228,>54
	.word	>4040,237,291,>45
	.word	>4040,245,291,>45
	.word	>4040,247,0,>54
	.word	>4060,247,228,>54
	.word	>4040,253,291,>69
	.word	>4040,267,0,>54
	.word	>4060,267,228,>54
	.word	>4040,287,0,>54
	.word	>4060,287,228,>54
	.word	>4041,297,284,>48
	.word	>4041,297,258,>4B
	.word	>4040,307,0,>54
	.word	>4060,307,228,>54
	.word	>4060,323,228,>54
	.word	>4040,327,0,>54
	.word	>4060,343,228,>54
	.word	>4040,347,0,>54
	.word	>4040,363,0,>54
	.word	>4060,363,228,>54
	.word	>4050,383,0,>36
	.word	>4050,383,35,>39
	.word	>4050,383,204,>39
	.word	>4050,383,187,>39
	.word	>4050,383,170,>39
	.word	>4050,383,153,>39
	.word	>4050,383,52,>39
	.word	>4050,383,69,>39
	.word	>4050,383,86,>39
	.word	>4050,383,103,>39
	.word	>4050,383,120,>39
	.word	>4050,383,137,>39
	.word	>4070,383,221,>36
	.word	>4040,397,291,>45
	.word	>3C41,398,248,>0
	.word	>4051,404,258,>3F
	.word	>4050,405,291,>3C
	.word	>3C41,407,33,>6C
	.word	>3C41,407,248,>6F
	.word	>3C41,408,238,>6F
	.word	>3C41,408,258,>6F
	.word	>3C41,408,303,>0
	.word	>3C41,408,268,>6F
	.word	>3C41,408,278,>6F
	.word	>3C41,408,288,>6F
	.word	>3C41,408,298,>6F
	.word	>4041,411,48,>72
	.word	>4041,411,58,>72
	.word	>4041,411,68,>72
	.word	>4041,411,78,>72
	.word	>4041,411,88,>72
	.word	>4041,411,98,>72
	.word	>4041,411,108,>72
	.word	>4041,411,118,>72
	.word	>4041,411,128,>72
	.word	>4041,411,138,>72
	.word	>4041,411,149,>72
	.word	>3C41,411,228,>3
	.word	>3C41,411,158,>3
	.word	>3C41,411,168,>3
	.word	>3C41,411,178,>3
	.word	>3C41,411,188,>3
	.word	>3C41,411,198,>3
	.word	>3C41,411,208,>3
	.word	>3C41,411,218,>3
	.word	>3C41,411,38,>3
	.word	>4041,411,26,>9
	.word	>3C41,411,308,>3
	.word	>3B41,419,49,>75
	.word	>3C41,419,47,>78
	.word	>4040,420,162,>7B
	.word	>3B41,420,153,>7E
	.word	>4141,422,177,>81
	.word	>4041,424,123,>84
	.word	>4041,424,42,>5A
	.word	>4041,427,318,>6
	.word	>3F51,428,236,>87
	.word	>4041,430,113,>8A
	.word	>4041,430,83,>8D
	.word	>4041,430,236,>90
	.word	>4041,430,306,>93
	.word	>4040,431,283,>96
	.word	>4040,431,261,>99
	.word	>4040,431,239,>96
	.word	>3B41,449,49,>9C
	.word	>4040,452,283,>96
	.word	>4040,452,239,>96
	.word	>4040,452,261,>96
	.word	>4061,459,63,>9F
	.word	>3B41,459,49,>75
	.word	>4040,462,133,>96
	.word	>4040,462,111,>96
	.word	>4040,462,67,>96
	.word	>4040,462,89,>96
	.word	>4141,467,177,>81
	.word	>4040,473,283,>96
	.word	>4040,473,261,>96
	.word	>4040,473,239,>96
	.word	>4040,483,67,>96
	.word	>4040,483,89,>96
	.word	>4040,483,133,>96
	.word	>4040,483,111,>96
	.word	>4051,491,237,>A2
	.word	>4041,495,238,>A5
	.word	>4041,495,248,>A5
	.word	>4041,495,258,>A5
	.word	>4041,495,268,>A5
	.word	>4041,495,278,>A5
	.word	>4041,495,288,>A5
	.word	>4041,495,298,>A5
	.word	>4041,503,48,>72
	.word	>4041,503,58,>72
	.word	>4041,503,68,>72
	.word	>4041,503,88,>72
	.word	>4041,503,78,>72
	.word	>4041,503,98,>72
	.word	>4041,503,108,>72
	.word	>4041,503,118,>72
	.word	>4041,503,128,>72
	.word	>4041,503,138,>72
	.word	>4041,503,148,>72
	.word	0FFFFH	;End Marker

msuMOD0BLKS:
	.word	0FFFFH		;End Marker
dashBMOD:
	.word	281,89,32	;x size, y size, #blocks
	.long	dashBLKS, msuHDRS, msuPALS
handBMOD:
	.word	124,95,3	;x size, y size, #blocks
	.long	handBLKS, msuHDRS, msuPALS
ledsBMOD:
	.word	490,282,12	;x size, y size, #blocks
	.long	ledsBLKS, msuHDRS, msuPALS
mainBMOD:
	.word	511,404,240	;x size, y size, #blocks
	.long	mainBLKS, msuHDRS, msuPALS

STATHDRS:
	.word	140,47	;x size, y size
	.long	>0		;anim
	.long	>3C30260	;address
	.word	108,57
	.long	>0,>3C3D000
	.word	84,11
	.long	>0,>3C49060
	.word	72,127
	.long	>0,>3C4AD40
	.word	88,127
	.long	>0,>3C5CB00
	.word	72,46
	.long	>0,>3C72840
	.word	40,24
	.long	>0,>3C78FC0
	.word	40,105
	.long	>0,>3C7ADC0
	.word	148,29
	.long	>0,>3C83100
	.word	88,127
	.long	>0,>3C5CB00
	.word	76,10
	.long	>0,>3C8B720
	.word	20,12
	.long	>0,>3C8CEE0
	.word	88,127
	.long	>0,>3C5CB00
	.word	80,52
	.long	>0,>3C8D660
	.word	124,53
	.long	>0,>3C95860
	.word	96,16
	.long	>0,>3CA25C0
	.word	120,55
	.long	>0,>3CA55C0
	.word	40,46
	.long	>0,>3CB2400
	.word	80,23
	.long	>0,>3CB5D80


SUBWAYBLKS:
	.word	>4048	;flags
	.word	0,0 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4047,41,255,>3
	.word	>2848,60,159,>6
	.word	>4051,130,128,>9
	.word	>4048,139,0,>0
	.word	>4047,149,255,>3
	.word	>4041,238,128,>C
	.word	>4047,257,255,>3
	.word	>4048,279,0,>0
	.word	>4051,326,128,>C
	.word	>4047,365,255,>3
	.word	>5045,404,47,>F
	.word	>4041,414,127,>12
	.word	>4049,414,150,>15
	.word	>4048,419,0,>0
	.word	>4051,454,127,>12
	.word	>4059,454,150,>15
	.word	>4047,473,255,>3
	.word	>4041,494,128,>C
	.word	>4048,559,0,>0
	.word	>4047,581,255,>3
	.word	>4041,582,128,>9
	.word	>4051,657,128,>9
	.word	>4048,679,47,>18
	.word	>4047,689,255,>3
	.word	>4048,697,0,>0
	.word	>5051,729,128,>1B
	.word	>4044,754,83,>1E
	.word	>5042,764,50,>21
	.word	>4047,797,255,>3
	.word	>5041,817,128,>24
	.word	>4048,837,0,>0
	.word	>4047,948,255,>3
	.word	>5041,958,128,>1B
	.word	>4048,977,0,>0
	.word	>4047,1056,255,>3
	.word	>5041,1082,128,>1B
	.word	>4048,1117,0,>0
	.word	>4047,1164,255,>3
	.word	>5051,1170,128,>24
	.word	>4045,1203,32,>27
	.word	>4048,1257,0,>0
	.word	>4041,1258,127,>12
	.word	>4049,1258,150,>15
	.word	>4047,1272,255,>3
	.word	>4051,1297,127,>12
	.word	>4059,1297,150,>15
	.word	>5041,1337,128,>24
	.word	>4047,1380,255,>3
	.word	>4048,1397,0,>0
	.word	>4048,1418,50,>18
	.word	>4041,1425,128,>9
	.word	>4047,1488,255,>3
	.word	>5042,1501,52,>21
	.word	>4048,1537,0,>0
	.word	>4047,1596,255,>3
	.word	>4043,1623,160,>2A
	.word	>4048,1677,0,>0
	.word	>4045,1680,122,>2D
	.word	>4047,1704,255,>3
	.word	>4043,1753,158,>30
	.word	>4047,1812,255,>3
	.word	>4048,1817,0,>0
	.word	>4047,1920,255,>3
	.word	>4048,1957,0,>0
	.word	>4046,1976,116,>33
	.word	>4046,1976,162,>33
	.word	>4046,1976,208,>33
	.word	>4040,1976,93,>36
	.word	>4046,1976,47,>33
	.word	>4046,2016,116,>33
	.word	>4046,2016,47,>33
	.word	>4047,2028,255,>3
	.word	>4048,2050,0,>0
	.word	>4046,2056,208,>33
	.word	>4046,2056,162,>33
	.word	>4046,2056,116,>33
	.word	>4040,2056,93,>36
	.word	>4046,2056,47,>33
	.word	>4046,2096,208,>33
	.word	>4046,2096,162,>33
	.word	>4046,2096,116,>33
	.word	>4046,2096,47,>33
	.word	0FFFFH	;End Marker

STATMOD0BLKS:
	.word	0FFFFH		;End Marker
SUBWAYBMOD:
	.word	2190,312,83	;x size, y size, #blocks
	.long	SUBWAYBLKS, STATHDRS, STATPALS

tscrHDRS:
	.word	16,19	;x size, y size
	.long	>0		;anim
	.long	>3CB9700	;address
	.word	16,20
	.long	>0,>3CBA080
	.word	16,59
	.long	>0,>3CBAA80
	.word	12,45
	.long	>0,>3CBC800
	.word	12,89
	.long	>0,>3CBD8E0
	.word	12,42
	.long	>0,>3CBFA40
	.word	28,107
	.long	>0,>3CC0A00
	.word	8,27
	.long	>0,>3CC67A0
	.word	16,58
	.long	>0,>3CC6E60
	.word	64,32
	.long	>0,>3CC8B60
	.word	48,22
	.long	>0,>3CCCB60
	.word	32,121
	.long	>0,>3CCEC60
	.word	48,52
	.long	>0,>3CD6560
	.word	28,36
	.long	>0,>3CDB360
	.word	12,13
	.long	>0,>3CDD2E0
	.word	32,129
	.long	>0,>3CDD7C0
	.word	40,42
	.long	>0,>3CE58C0
	.word	20,10
	.long	>0,>3CE8D40
	.word	104,133
	.long	>0,>3CE9380
	.word	140,21
	.long	>0,>3D043C0
	.word	16,23
	.long	>0,>3D09FA0
	.word	96,18
	.long	>0,>3D0AB20
	.word	16,24
	.long	>0,>3D0E120
	.word	16,24
	.long	>0,>3D0ED20
	.word	8,18
	.long	>0,>3D0F920
	.word	8,107
	.long	>0,>3D0FDA0
	.word	16,60
	.long	>0,>3D11860
	.word	12,82
	.long	>0,>3D13660
	.word	32,13
	.long	>0,>3D15520
	.word	12,55
	.long	>0,>3D16220
	.word	8,68
	.long	>0,>3D176C0
	.word	24,19
	.long	>0,>3D187C0
	.word	8,64
	.long	>0,>3D19600
	.word	8,34
	.long	>0,>3D1A600
	.word	24,25
	.long	>0,>3D1AE80
	.word	28,34
	.long	>0,>3D1C140
	.word	8,61
	.long	>0,>3D1DF00
	.word	24,21
	.long	>0,>3D1EE40
	.word	8,60
	.long	>0,>3D1FE00
	.word	28,21
	.long	>0,>3D20D00
	.word	84,29
	.long	>0,>3D21F60
	.word	32,17
	.long	>0,>3D26B80
	.word	28,78
	.long	>0,>3D27C80
	.word	12,77
	.long	>0,>3D2C0C0
	.word	68,22
	.long	>0,>3D2DDA0
	.word	56,16
	.long	>0,>3D30C60
	.word	68,17
	.long	>0,>3D32860
	.word	72,51
	.long	>0,>3D34C80
	.word	24,10
	.long	>0,>3D3BF40
	.word	36,48
	.long	>0,>3D3C6C0
	.word	16,71
	.long	>0,>3D3FCC0
	.word	16,19
	.long	>0,>3D42040
	.word	4,49
	.long	>0,>3D429C0
	.word	36,8
	.long	>0,>3D42FE0
	.word	36,30
	.long	>0,>3D438E0
	.word	24,2
	.long	>0,>3D45AA0
	.word	24,10
	.long	>0,>3D45C20
	.word	24,29
	.long	>0,>3D463A0
	.word	28,27
	.long	>0,>3D47960
	.word	28,38
	.long	>0,>3D49100
	.word	24,17
	.long	>0,>3D4B240
	.word	28,10
	.long	>0,>3D4BF00
	.word	32,13
	.long	>0,>3D4C7C0
	.word	12,33
	.long	>0,>3D4D4C0
	.word	12,14
	.long	>0,>3D4E120
	.word	4,11
	.long	>0,>3D4E660


rmanBLKS:
	.word	>2043	;flags
	.word	0,38 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>2043,16,46,>3
	.word	>2043,32,48,>9
	.word	>2043,44,55,>F
	.word	>2043,56,62,>15
	.word	>2043,64,42,>18
	.word	>2041,66,110,>1B
	.word	>2041,72,88,>1E
	.word	>2042,74,36,>24
	.word	>2042,82,0,>27
	.word	>2143,104,45,>2A
	.word	>2040,121,38,>30
	.word	>2043,135,28,>33
	.word	>2043,141,5,>3C
	.word	0FFFFH	;End Marker

bmanBLKS:
	.word	>6045	;flags
	.word	0,45 ;x,y
	.word	>42	;pal5,pal4,hdr13-0
	.word	>6045,16,56,>45
	.word	>6045,32,68,>48
	.word	>6045,39,62,>4E
	.word	>6045,55,73,>57
	.word	>6044,61,280,>5D
	.word	>6045,67,82,>63
	.word	>6044,68,255,>66
	.word	>6044,70,221,>69
	.word	>6045,75,65,>72
	.word	>6044,76,200,>75
	.word	>6044,79,154,>78
	.word	>6044,79,183,>7B
	.word	>6045,83,56,>81
	.word	>6044,85,132,>84
	.word	>6044,89,116,>87
	.word	>6045,95,48,>8A
	.word	>6045,95,65,>8D
	.word	>6045,100,0,>93
	.word	>6044,127,183,>9F
	.word	>6044,130,191,>A2
	.word	>6044,143,221,>A5
	.word	>6044,144,223,>A8
	.word	>6044,148,233,>AB
	.word	>6044,155,262,>AE
	.word	>6045,157,133,>B1
	.word	>6045,158,116,>B4
	.word	>6044,158,289,>B7
	.word	>6045,165,171,>BA
	.word	>6045,167,83,>BD
	.word	>6045,170,184,>C0
	.word	>6045,179,198,>C3
	.word	0FFFFH	;End Marker

porsBLKS:
	.word	>4046	;flags
	.word	0,90 ;x,y
	.word	>6	;pal5,pal4,hdr13-0
	.word	>4046,16,65,>C
	.word	>4046,28,55,>12
	.word	>4046,56,47,>21
	.word	>4046,88,43,>2D
	.word	>4046,120,39,>36
	.word	>4046,122,18,>39
	.word	>4046,137,0,>3F
	.word	>4046,224,39,>4B
	.word	>4046,232,39,>51
	.word	>4046,233,5,>54
	.word	>4046,244,39,>5A
	.word	>4046,252,39,>60
	.word	>4046,260,39,>6C
	.word	>4046,262,18,>6F
	.word	>4046,268,39,>7E
	.word	>4046,286,19,>90
	.word	>4046,296,46,>96
	.word	>4046,310,14,>99
	.word	>4046,312,54,>9C
	.word	0FFFFH	;End Marker

tscrMOD0BLKS:
	.word	0FFFFH		;End Marker
rmanBMOD:
	.word	161,142,14	;x size, y size, #blocks
	.long	rmanBLKS, tscrHDRS, tscrPALS
bmanBMOD:
	.word	197,299,32	;x size, y size, #blocks
	.long	bmanBLKS, tscrHDRS, tscrPALS
porsBMOD:
	.word	326,172,20	;x size, y size, #blocks
	.long	porsBLKS, tscrHDRS, tscrPALS

GHSHDRS:
	.word	24,84	;x size, y size
	.long	>0		;anim
	.long	>3D4E7C0	;address
	.word	40,46
	.long	>0,>3D526C0
	.word	60,29
	.long	>0,>3D56040
	.word	60,92
	.long	>0,>37B2360
	.word	56,22
	.long	>0,>3D596A0
	.word	44,46
	.long	>0,>3D5BD20
	.word	24,84
	.long	>0,>3D5FC60
	.word	20,46
	.long	>0,>3D63B60
	.word	124,48
	.long	>0,>3D65820
	.word	56,19
	.long	>0,>3D71220
	.word	44,46
	.long	>0,>3D73360
	.word	56,51
	.long	>0,>3D772A0
	.word	64,19
	.long	>0,>3D7CBE0
	.word	72,22
	.long	>0,>3D7F1E0


GRNHSBLKS:
	.word	>4040	;flags
	.word	0,47 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4045,0,131,>3
	.word	>4041,0,177,>6
	.word	>4053,0,206,>9
	.word	>4040,24,47,>0
	.word	>4044,40,131,>F
	.word	>4040,48,47,>0
	.word	>4041,56,177,>6
	.word	>4043,60,206,>9
	.word	>4040,72,47,>0
	.word	>4044,84,131,>F
	.word	>4040,96,47,>0
	.word	>4041,116,177,>6
	.word	>4040,120,47,>12
	.word	>4053,120,206,>9
	.word	>4051,128,131,>15
	.word	>4040,144,47,>0
	.word	>4041,148,131,>15
	.word	>4040,168,47,>0
	.word	>4044,168,131,>F
	.word	>4045,174,1,>3
	.word	>4041,176,177,>6
	.word	>4043,180,206,>9
	.word	>4040,192,47,>0
	.word	>4044,212,131,>F
	.word	>4045,214,0,>18
	.word	>4040,216,47,>0
	.word	>4041,236,177,>6
	.word	>4040,240,47,>0
	.word	>4053,240,206,>9
	.word	>4044,256,131,>1E
	.word	>4040,264,47,>0
	.word	>4040,288,47,>12
	.word	>4041,296,177,>6
	.word	>4041,300,131,>15
	.word	>4043,300,206,>9
	.word	>4040,312,47,>0
	.word	>4042,320,131,>1E
	.word	>4040,336,47,>0
	.word	>4045,337,1,>3
	.word	>4041,356,177,>6
	.word	>4040,360,47,>0
	.word	>4053,360,206,>9
	.word	>4051,364,131,>15
	.word	>4040,384,47,>0
	.word	>4041,384,131,>15
	.word	>4044,404,131,>F
	.word	>4040,407,47,>0
	.word	>4041,416,177,>6
	.word	>4043,420,206,>9
	.word	>4040,431,47,>0
	.word	>4045,448,131,>3
	.word	>4040,454,47,>0
	.word	>4041,476,177,>6
	.word	>4040,478,47,>12
	.word	>4053,480,206,>9
	.word	>4044,488,131,>F
	.word	>4040,502,47,>0
	.word	>4040,526,47,>0
	.word	>4042,532,131,>1E
	.word	>4041,536,177,>6
	.word	>4043,536,206,>9
	.word	>4040,550,47,>0
	.word	>4040,572,47,>0
	.word	>3E41,576,131,>15
	.word	0FFFFH	;End Marker

GRNHSDRBLKS:
	.word	>4053	;flags
	.word	0,159 ;x,y
	.word	>9	;pal5,pal4,hdr13-0
	.word	>4040,0,0,>0
	.word	>4040,24,0,>0
	.word	>5A40,36,0,>12
	.word	>3E41,40,113,>15
	.word	>5541,40,83,>15
	.word	0FFFFH	;End Marker

CLOUDBLKS:
	.word	>4046	;flags
	.word	0,34 ;x,y
	.word	>C	;pal5,pal4,hdr13-0
	.word	>4046,233,67,>1B
	.word	>4046,413,0,>21
	.word	>4046,468,36,>24
	.word	>4046,665,53,>27
	.word	0FFFFH	;End Marker

GHSMOD0BLKS:
	.word	>4046	;flags
	.word	930,293 ;x,y
	.word	>C	;pal5,pal4,hdr13-0
	.word	0FFFFH		;End Marker
GRNHSBMOD:
	.word	596,298,65	;x size, y size, #blocks
	.long	GRNHSBLKS, GHSHDRS, GHSPALS
GRNHSDRBMOD:
	.word	60,251,6	;x size, y size, #blocks
	.long	GRNHSDRBLKS, GHSHDRS, GHSPALS
CLOUDBMOD:
	.word	737,86,5	;x size, y size, #blocks
	.long	CLOUDBLKS, GHSHDRS, GHSPALS

GHSIHDRS:
	.word	92,99	;x size, y size
	.long	>0		;anim
	.long	>3D82360	;address
	.word	52,91
	.long	>0,>3D94000
	.word	52,91
	.long	>0,>3D9D3E0
	.word	28,18
	.long	>0,>3DA67C0
	.word	36,26
	.long	>0,>3DA7780
	.word	24,16
	.long	>0,>3DA94C0


GHSINTDRBLKS:
	.word	>4050	;flags
	.word	0,91 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4042,0,0,>3
	.word	>4042,40,0,>3
	.word	0FFFFH	;End Marker

GHSINTBLKS:
	.word	>4040	;flags
	.word	0,227 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4042,0,136,>6
	.word	>5041,0,53,>9
	.word	>4042,52,136,>3
	.word	>4050,92,227,>0
	.word	>6441,100,0,>C
	.word	>4042,104,136,>3
	.word	>4641,106,90,>F
	.word	>4042,156,136,>3
	.word	>4040,183,227,>0
	.word	>5041,200,53,>9
	.word	>4042,208,136,>6
	.word	>4042,260,136,>3
	.word	>4050,274,227,>0
	.word	>6441,300,0,>C
	.word	>4641,306,90,>F
	.word	>4042,312,136,>3
	.word	>4042,364,136,>3
	.word	>4040,366,227,>0
	.word	>5041,400,53,>9
	.word	>4042,416,136,>3
	.word	>4050,458,227,>0
	.word	>4042,468,136,>6
	.word	>6441,500,0,>C
	.word	>4641,506,90,>F
	.word	>4042,520,136,>3
	.word	>4040,550,227,>0
	.word	>4042,572,136,>3
	.word	>5041,600,53,>9
	.word	>4042,624,136,>3
	.word	>4050,642,227,>0
	.word	>4042,676,136,>6
	.word	>6441,700,0,>C
	.word	>4641,706,90,>F
	.word	>4042,728,136,>3
	.word	>4040,734,227,>0
	.word	>4042,780,136,>3
	.word	>5041,800,53,>9
	.word	>4050,826,227,>0
	.word	>4042,832,136,>3
	.word	>4042,884,136,>6
	.word	>6441,900,0,>C
	.word	>4641,906,90,>F
	.word	>4040,918,227,>0
	.word	>4042,936,136,>3
	.word	>4042,988,136,>3
	.word	>5041,1000,53,>9
	.word	>4050,1010,227,>0
	.word	>4042,1040,136,>3
	.word	>4042,1092,136,>3
	.word	>6441,1100,0,>C
	.word	>4040,1101,227,>0
	.word	>4641,1106,90,>F
	.word	>4042,1144,136,>6
	.word	>4050,1193,227,>0
	.word	>4042,1196,136,>3
	.word	>5041,1200,53,>9
	.word	>4042,1248,136,>3
	.word	>4040,1284,227,>0
	.word	>4042,1300,136,>3
	.word	>6441,1300,0,>C
	.word	>4641,1306,90,>F
	.word	>4042,1352,136,>3
	.word	>4050,1376,227,>0
	.word	>5041,1400,53,>9
	.word	>4042,1404,136,>6
	.word	>4042,1456,136,>3
	.word	>4040,1468,227,>0
	.word	>6441,1500,0,>C
	.word	>4641,1506,90,>F
	.word	>4042,1508,136,>3
	.word	>4050,1560,227,>0
	.word	>4042,1560,136,>3
	.word	>4042,1600,136,>3
	.word	>5041,1600,53,>9
	.word	0FFFFH	;End Marker

GHSIMOD0BLKS:
	.word	0FFFFH		;End Marker
GHSINTDRBMOD:
	.word	92,190,3	;x size, y size, #blocks
	.long	GHSINTDRBLKS, GHSIHDRS, GHSIPALS
GHSINTBMOD:
	.word	1652,326,75	;x size, y size, #blocks
	.long	GHSINTBLKS, GHSIHDRS, GHSIPALS

CHEMHDRS:
	.word	48,94	;x size, y size
	.long	>0		;anim
	.long	>3DAA0C0	;address
	.word	40,51
	.long	>0,>3DB2DC0
	.word	116,19
	.long	>0,>3DB6D80
	.word	64,10
	.long	>0,>3DBB260
	.word	20,22
	.long	>0,>3DBC660
	.word	84,90
	.long	>0,>3AA09C0
	.word	20,52
	.long	>0,>3DBD420
	.word	44,147
	.long	>0,>3DBF4A0
	.word	64,80
	.long	>0,>3DCBEC0
	.word	24,33
	.long	>0,>3DD5EC0
	.word	24,16
	.long	>0,>3DD7780
	.word	16,24
	.long	>0,>3DD8380
	.word	44,79
	.long	>0,>3DD8F80
	.word	28,62
	.long	>0,>3DDFC20


LABBLKS:
	.word	>5056	;flags
	.word	0,227 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4040,0,176,>3
	.word	>5076,0,320,>0
	.word	>4044,14,0,>6
	.word	>4044,38,41,>9
	.word	>4040,40,176,>3
	.word	>5046,48,227,>0
	.word	>5066,48,321,>0
	.word	>4040,80,176,>3
	.word	>A56,96,227,>0
	.word	>5076,96,321,>0
	.word	>4040,100,155,>C
	.word	>4040,100,133,>C
	.word	>4040,100,111,>C
	.word	>4040,120,111,>C
	.word	>4044,122,41,>9
	.word	>4040,140,111,>C
	.word	>5046,144,227,>0
	.word	>5066,144,321,>0
	.word	>4040,160,176,>3
	.word	>4040,160,155,>C
	.word	>4040,160,133,>C
	.word	>4040,160,111,>C
	.word	>4044,185,0,>6
	.word	>5056,192,227,>0
	.word	>A41,192,76,>F
	.word	>5076,192,321,>0
	.word	>4040,200,176,>3
	.word	>4044,206,41,>9
	.word	>5046,240,227,>0
	.word	>4040,240,176,>3
	.word	>5066,240,321,>0
	.word	>4040,280,176,>3
	.word	>5056,288,227,>0
	.word	>5076,288,321,>0
	.word	>4047,289,115,>12
	.word	>4044,290,41,>9
	.word	>4047,309,115,>12
	.word	>A40,320,176,>3
	.word	>4047,329,115,>12
	.word	>5046,336,227,>0
	.word	>5066,336,321,>0
	.word	>4047,349,115,>12
	.word	>4044,356,0,>6
	.word	>A40,360,176,>3
	.word	>7842,377,29,>15
	.word	>5056,384,227,>0
	.word	>5076,384,321,>0
	.word	>A52,417,29,>15
	.word	>5046,432,227,>0
	.word	>5066,432,321,>0
	.word	>4044,458,41,>9
	.word	>A42,461,96,>18
	.word	>5056,480,227,>0
	.word	>5076,480,321,>0
	.word	>4043,498,63,>1B
	.word	>4053,521,63,>1B
	.word	>A52,521,96,>18
	.word	>4044,527,0,>6
	.word	>5046,528,227,>0
	.word	>5066,528,321,>0
	.word	>4043,542,66,>1E
	.word	>4044,542,41,>9
	.word	>4043,566,66,>1E
	.word	>A56,576,227,>0
	.word	>5076,576,321,>0
	.word	>6442,585,29,>15
	.word	>A46,623,227,>0
	.word	>5066,624,321,>0
	.word	>7852,625,29,>15
	.word	>4040,640,176,>3
	.word	>A43,661,67,>1E
	.word	>A56,671,227,>0
	.word	>5076,671,321,>0
	.word	>4040,680,176,>3
	.word	>4043,684,120,>1B
	.word	>4043,685,64,>1B
	.word	>4044,687,41,>9
	.word	>4044,698,0,>6
	.word	>4053,700,97,>21
	.word	>4053,707,120,>1B
	.word	>4053,707,64,>1B
	.word	>5046,719,227,>0
	.word	>5066,719,321,>0
	.word	>4040,720,176,>3
	.word	>4043,729,67,>1E
	.word	>4043,731,123,>1E
	.word	>4043,753,64,>1B
	.word	>4043,755,120,>1B
	.word	>4040,760,176,>3
	.word	>5056,767,227,>0
	.word	>5076,767,321,>0
	.word	>4044,771,41,>9
	.word	>4053,777,64,>1B
	.word	>4053,778,120,>1B
	.word	>4040,800,176,>3
	.word	>4043,801,67,>1E
	.word	>4043,802,123,>1E
	.word	>5046,815,227,>0
	.word	>5066,815,321,>0
	.word	>4043,825,67,>1E
	.word	>4043,826,120,>1B
	.word	>4040,840,176,>3
	.word	>4053,849,120,>1B
	.word	>4043,849,67,>1E
	.word	>4044,855,41,>9
	.word	>5056,863,227,>0
	.word	>5076,863,321,>0
	.word	>4044,869,0,>6
	.word	>4043,873,123,>1E
	.word	>4043,873,67,>1E
	.word	>7845,879,155,>24
	.word	>6E45,894,93,>27
	.word	>7843,897,64,>1B
	.word	>5046,911,227,>0
	.word	>5066,911,321,>0
	.word	>7855,917,155,>24
	.word	>6E55,918,93,>27
	.word	>7853,920,64,>1B
	.word	>4044,939,41,>9
	.word	>4043,944,124,>1E
	.word	>4043,944,67,>1E
	.word	>5056,959,227,>0
	.word	>5076,959,321,>0
	.word	>4040,959,176,>3
	.word	>4043,968,121,>1B
	.word	>4043,968,64,>1B
	.word	>4053,991,121,>1B
	.word	>7853,991,64,>1B
	.word	>4040,999,176,>3
	.word	>5046,1007,227,>0
	.word	>5066,1007,321,>0
	.word	>4043,1015,124,>1E
	.word	>4043,1015,67,>1E
	.word	>4044,1023,41,>9
	.word	>4043,1039,121,>1B
	.word	>4040,1039,176,>3
	.word	>4043,1039,67,>1E
	.word	>4044,1040,0,>6
	.word	>5056,1055,227,>0
	.word	>5076,1055,321,>0
	.word	>4053,1062,121,>1B
	.word	>4043,1063,67,>1E
	.word	>4040,1079,176,>3
	.word	>4043,1086,124,>1E
	.word	>4043,1087,67,>1E
	.word	>5046,1103,227,>0
	.word	>5066,1103,321,>0
	.word	>4044,1107,41,>9
	.word	>4043,1110,121,>1B
	.word	>4043,1111,65,>1B
	.word	>4040,1119,176,>3
	.word	>4053,1127,98,>21
	.word	>4053,1133,121,>1B
	.word	>4053,1133,65,>1B
	.word	>5056,1150,227,>0
	.word	>5076,1150,321,>0
	.word	>4043,1157,67,>1E
	.word	>4040,1159,176,>3
	.word	>4047,1166,115,>12
	.word	>4043,1181,67,>1E
	.word	>4047,1186,115,>12
	.word	>4044,1191,41,>9
	.word	>5046,1198,227,>0
	.word	>5066,1198,321,>0
	.word	>4040,1199,176,>3
	.word	>4043,1201,67,>1E
	.word	>4044,1211,0,>6
	.word	>7842,1215,29,>15
	.word	>5056,1246,227,>0
	.word	>5076,1246,321,>0
	.word	>6452,1255,29,>15
	.word	>5046,1294,227,>0
	.word	>A43,1294,66,>1E
	.word	>5066,1294,321,>0
	.word	>A42,1299,96,>18
	.word	>4044,1299,41,>9
	.word	>4043,1318,66,>1E
	.word	>4043,1337,63,>1B
	.word	>5056,1342,227,>0
	.word	>5076,1342,321,>0
	.word	>A52,1359,96,>18
	.word	>4053,1360,63,>1B
	.word	>4044,1382,0,>6
	.word	>4044,1383,41,>9
	.word	>5046,1390,227,>0
	.word	>5066,1390,321,>0
	.word	>6442,1423,29,>15
	.word	>5056,1437,227,>0
	.word	>5076,1437,321,>0
	.word	>7852,1463,29,>15
	.word	>4040,1480,176,>3
	.word	>5046,1485,227,>0
	.word	>5066,1485,321,>0
	.word	>4047,1513,115,>12
	.word	>4040,1520,176,>3
	.word	>4044,1527,41,>9
	.word	>5056,1533,227,>0
	.word	>5076,1533,321,>0
	.word	>4040,1540,155,>C
	.word	>4040,1540,133,>C
	.word	>4040,1540,111,>C
	.word	>4044,1553,0,>6
	.word	>4040,1560,111,>C
	.word	>5046,1580,227,>0
	.word	>4040,1580,111,>C
	.word	>5066,1581,321,>0
	.word	>4040,1600,176,>3
	.word	>4040,1600,155,>C
	.word	>4040,1600,133,>C
	.word	>4040,1600,111,>C
	.word	>4044,1611,41,>9
	.word	>5056,1627,227,>0
	.word	>5076,1627,321,>0
	.word	>4040,1640,176,>3
	.word	>5046,1675,227,>0
	.word	>5066,1675,321,>0
	.word	>4040,1680,176,>3
	.word	>4044,1695,41,>9
	.word	>4040,1720,176,>3
	.word	>5056,1723,227,>0
	.word	>5076,1723,321,>0
	.word	>4044,1724,0,>6
	.word	>4040,1760,176,>3
	.word	>5046,1771,227,>0
	.word	>5066,1771,321,>0
	.word	>4044,1779,41,>9
	.word	>4040,1800,176,>3
	.word	>5056,1819,227,>0
	.word	>5076,1819,321,>0
	.word	>4040,1827,176,>3
	.word	0FFFFH	;End Marker

CHEMMOD0BLKS:
	.word	0FFFFH		;End Marker
LABBMOD:
	.word	1867,415,231	;x size, y size, #blocks
	.long	LABBLKS, CHEMHDRS, CHEMPALS

KASTHDRS:
	.word	60,44	;x size, y size
	.long	>0		;anim
	.long	>37997C0	;address
	.word	60,92
	.long	>0,>37B2360
	.word	60,150
	.long	>0,>37A0A20
	.word	60,30
	.long	>0,>3DE3260
	.word	180,30
	.long	>0,>3DE6AA0
	.word	32,60
	.long	>0,>3DF1360
	.word	60,30
	.long	>0,>37D39C0
	.word	12,129
	.long	>0,>394DE60
	.word	40,35
	.long	>0,>3952480
	.word	60,150
	.long	>0,>37DAF00


KASTLEBLKS:
	.word	>4040	;flags
	.word	0,180 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>4045,0,224,>3
	.word	>4040,0,316,>0
	.word	>6E42,0,30,>6
	.word	>4052,0,0,>9
	.word	>4042,30,0,>9
	.word	>7841,31,30,>C
	.word	>4040,60,180,>0
	.word	>4055,60,224,>3
	.word	>4040,60,316,>0
	.word	>4042,60,150,>9
	.word	>4052,60,120,>9
	.word	>4053,60,60,>F
	.word	>4043,88,60,>F
	.word	>4040,120,180,>0
	.word	>4045,120,224,>3
	.word	>4040,120,316,>0
	.word	>4042,120,150,>9
	.word	>4052,120,120,>9
	.word	>4053,120,60,>F
	.word	>4043,148,60,>F
	.word	>4052,165,0,>9
	.word	>4040,180,180,>0
	.word	>4055,180,224,>3
	.word	>4040,180,316,>0
	.word	>4042,180,150,>9
	.word	>4052,180,120,>9
	.word	>4044,180,30,>12
	.word	>4042,180,90,>9
	.word	>4052,180,60,>9
	.word	>4042,195,0,>9
	.word	>4040,240,180,>0
	.word	>4045,240,224,>3
	.word	>4040,240,316,>0
	.word	>4040,240,51,>15
	.word	>7842,240,30,>12
	.word	>4040,252,51,>18
	.word	>4050,292,51,>15
	.word	>4040,296,51,>15
	.word	>4040,300,180,>0
	.word	>4055,300,224,>3
	.word	>4040,300,316,>0
	.word	>7842,300,30,>12
	.word	>4040,308,51,>18
	.word	>4052,330,0,>9
	.word	>4050,348,51,>15
	.word	>4040,360,180,>0
	.word	>352,360,30,>1B
	.word	>4045,360,224,>3
	.word	>4040,360,316,>0
	.word	>4042,360,0,>9
	.word	0FFFFH	;End Marker

KASTMOD0BLKS:
	.word	0FFFFH		;End Marker
KASTLEBMOD:
	.word	420,360,51	;x size, y size, #blocks
	.long	KASTLEBLKS, KASTHDRS, KASTPALS

HDRMHDRS:
	.word	124,136	;x size, y size
	.long	>0		;anim
	.long	>3A59A80	;address
	.word	84,90
	.long	>0,>3AA09C0
	.word	144,44
	.long	>0,>3ACE7E0
	.word	20,21
	.long	>0,>3B033E0
	.word	20,88
	.long	>0,>3AFFCE0
	.word	88,20
	.long	>0,>3B04100
	.word	76,90
	.long	>0,>3B07800
	.word	44,22
	.long	>0,>3B14DC0
	.word	16,119
	.long	>0,>3A8FFE0
	.word	64,16
	.long	>0,>3A93B60


HEADRBLKS:
	.word	>A40	;flags
	.word	0,283 ;x,y
	.word	>0	;pal5,pal4,hdr13-0
	.word	>A40,0,147,>0
	.word	>A40,122,147,>0
	.word	>A40,124,283,>0
	.word	>4044,162,29,>3
	.word	>A40,246,147,>0
	.word	>A40,248,283,>0
	.word	>A40,370,147,>0
	.word	>A40,372,283,>0
	.word	>A40,494,147,>0
	.word	>A40,496,283,>0
	.word	>4041,498,52,>6
	.word	>A40,618,147,>0
	.word	>A40,620,283,>0
	.word	>A40,742,147,>0
	.word	>A40,744,283,>0
	.word	>A40,866,147,>0
	.word	>A40,868,283,>0
	.word	>A40,990,147,>0
	.word	>A40,992,283,>0
	.word	>4044,1008,29,>3
	.word	>A40,1114,147,>0
	.word	>A40,1116,283,>0
	.word	>A40,1238,147,>0
	.word	>A40,1240,283,>0
	.word	>A40,1362,147,>0
	.word	>A40,1364,283,>0
	.word	>2973,1400,0,>9
	.word	>2953,1401,20,>C
	.word	>2953,1401,108,>9
	.word	>2843,1413,109,>F
	.word	>2863,1414,1,>F
	.word	>2842,1420,20,>12
	.word	>2A43,1439,109,>15
	.word	>A40,1486,147,>0
	.word	>A40,1488,283,>0
	.word	>2943,1496,108,>9
	.word	>2943,1496,21,>C
	.word	>2963,1497,0,>9
	.word	>A40,1610,147,>0
	.word	>A40,1612,283,>0
	.word	>A40,1734,147,>0
	.word	>A40,1736,283,>0
	.word	>4041,1851,52,>6
	.word	>A40,1858,147,>0
	.word	>A40,1860,283,>0
	.word	>A40,1982,147,>0
	.word	>A40,1984,283,>0
	.word	>A40,2106,147,>0
	.word	>A40,2108,283,>0
	.word	>4044,2154,29,>3
	.word	>A40,2230,147,>0
	.word	>A40,2232,283,>0
	.word	>A40,2354,147,>0
	.word	>A40,2356,283,>0
	.word	>4041,2385,52,>6
	.word	>A40,2478,147,>0
	.word	>A40,2480,283,>0
	.word	>A40,2602,147,>0
	.word	>A40,2604,283,>0
	.word	>4045,2664,28,>18
	.word	>4045,2664,12,>1B
	.word	>4055,2724,12,>1B
	.word	>A40,2726,147,>0
	.word	>A40,2726,283,>0
	.word	>4055,2772,28,>18
	.word	0FFFFH	;End Marker

HDRMMOD0BLKS:
	.word	0FFFFH		;End Marker
HEADRBMOD:
	.word	2850,419,66	;x size, y size, #blocks
	.long	HEADRBLKS, HDRMHDRS, HDRMPALS
