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
set HAS_OPTIONAL=No
if "%ACTION%" == "optional" set HAS_OPTIONAL=Yes&& set ACTION=install
if "%ACTION%" == "optional-install" set HAS_OPTIONAL=Yes&& set ACTION=install
if "%ACTION%" == "optional-clean" set HAS_OPTIONAL=Yes&& set ACTION=clean
if "%ACTION%" == "optional-release" set HAS_OPTIONAL=Yes&& set ACTION=release
if "%ACTION%" == "optional-test" set HAS_OPTIONAL=Yes&& set ACTION=test
rem ---

echo -^> %ACTION% sdk

goto StepX
:build
if "%1" == "" goto :eof
if exist ..\%1\ goto :cmdBuildCheck
echo "Error - not found: %1"
exit 1
:cmdBuildCheck
if exist ..\%1\build.msvc.cmd goto :cmdBuildRun
echo "Error - not found: ..\%1\build.msvc.cmd"
exit 1
:cmdBuildRun
pushd "..\%1"
call build.msvc.cmd %ACTION%
if errorlevel 1 goto cmdBuildError
popd
goto :eof
:cmdBuildError
popd
echo "Error - sdk %ACTION% : %1"
exit 1
:StepX

for /F "eol=# tokens=1" %%i in (build-sdk.source.windows.txt) do call :build %%i
if "%HAS_OPTIONAL%" == "Yes" for /F "eol=# tokens=1" %%i in (build-sdk.source.windows.optional.txt) do call :build %%i
