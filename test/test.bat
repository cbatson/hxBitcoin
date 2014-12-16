@echo off

set _TARGET=%1
if "%1" == "" set _TARGET=windows
haxe targets\%_TARGET%.hxml
if errorlevel 1 goto _end
goto %_TARGET%

:windows
bin\%_TARGET%\TestMain.exe
goto _end

:neko
neko test.n
goto _end

:_end
