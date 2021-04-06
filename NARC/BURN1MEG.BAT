echo off
if "%1" == "" goto MROMERR
key-fake 20 "5511" 13 0 0 "5g1" 13 0 0 "8narcfc.0" 13 20 0 0 "0yc" 20 0 0 27 "y" 		 
pp
key-fake 20 "5511" 13 0 0 "5g10" 13 0 0 "8narcfc.1" 13 20 0 0 "0yc" 20 0 0 27 "y"		 
pp
key-fake 20 "5511" 13 0 0 "5g11" 13 0 0 "8narcfe.0" 13 20 0 0 "0yc" 20 0 0 27 "y"		 
pp
key-fake 20 "5511" 13 0 0 "5g12" 13 0 0 "8narcfe.1" 13 20 0 0 "0yc" 20 0 0 27 "y"		 
pp
DATAIO %1.00
DATAIO %1.01
DATAIO %1.02
DATAIO %1.03
goto MROMEND
:MROMERR
echo Error! No arguments specified for monroms
:MROMEND
