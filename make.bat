@echo off

set ROM=rom.gen

if not exist out mkdir out
if not exist obj mkdir obj

setlocal EnableDelayedExpansion

for /R %%F in (*.asm) do (
    set "REL=%%~dpF"
    set "REL=!REL:%CD%\=!"

    if not exist "obj\!REL!" mkdir "obj\!REL!"
    bin\asm68k.exe /k /m /l /o ae- /o c+ /o l+ /o v+ /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ "%%F","obj\!REL!\%%~nF.obj","obj\!REL!\%%~nF.sym","obj\!REL!\%%~nF.lst"
)

endlocal

bin\psylink /c /p /s /v @linker.lk,out/%ROM%,out/symbols.sym,out/mappings.map
bin\mdromfix -q -p 255 out/%ROM%
pause