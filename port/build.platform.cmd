@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=install
if "%1" == "make" set ACTION=install

rem ---
if "%1" == "debug" set XYO_COMPILE_DEBUG=1
if "%1" == "debug" set ACTION=install
rem ---

echo -^> %ACTION% build-sdk

goto StepX
:build
if "%1" == "" goto :eof
if exist "..\%1\" goto :cmdBuildCheck
echo "Error - not found: %1"
exit 1
:cmdBuildCheck
if exist "..\%1\port\build.platform.cmd" goto :cmdBuildRun
echo "Error - not found: ..\%1\port\build.platform.cmd"
exit 1
:cmdBuildRun
echo.
pushd "..\%1"
cmd.exe /C ".\port\build.platform %ACTION%"
if errorlevel 1 goto cmdBuildError
popd
goto :eof
:cmdBuildError
popd
echo "Error - build-sdk %ACTION% : %1"
exit 1
:StepX

for /F "eol=# tokens=1" %%i in (.\source\windows.txt) do call :build %%i
