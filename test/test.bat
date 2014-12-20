@echo off

set _TARGET=%1
if "%1" == "" set _TARGET=windows
mkdir bin\%_TARGET% > NUL 2>&1
haxe targets\%_TARGET%.hxml
if errorlevel 1 goto _end
goto %_TARGET%

:windows
bin\%_TARGET%\TestMain.exe
goto _end

:neko
neko bin\%_TARGET%\test.n
goto _end

:_end
