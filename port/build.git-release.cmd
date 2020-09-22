@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

SETLOCAL ENABLEDELAYEDEXPANSION

echo -^> git-release build-sdk

goto StepX

:doRelease
if "%1" == "" goto :eof
if exist "..\%1\" goto cmdRelease
echo "Error - not found: %1"
exit 1
:cmdRelease
if not exist "..\%1\release" echo "Error - build-sdk git-release: %1 - no release" & exit 1

pushd "..\%1"

set PROJECT=%1
if not exist source\%PROJECT%.version.ini goto cmdCheckVersion2
FOR /F "tokens=* USEBACKQ" %%F IN (`xyo-version --no-bump --get "--version-file=source\%PROJECT%.version.ini" %PROJECT%`) DO (
	SET VERSION=%%F
)
goto versionOk

:cmdCheckVersion2
SET PROJECT_VENDOR=%PROJECT:vendor-=%
if not exist %PROJECT_VENDOR%.version.ini echo "Error - no version info" & goto cmdReleaseError
FOR /F "tokens=* USEBACKQ" %%F IN (`xyo-version --no-bump --get "--version-file=%PROJECT_VENDOR%.version.ini" %PROJECT_VENDOR%`) DO (
	SET VERSION=%%F
)
goto versionOk

:versionOk

echo -^> git-release %PROJECT% v%VERSION%

git pull --tags origin master
git rev-parse --quiet "v%VERSION%" 1>NUL 2>NUL
if not errorlevel 1 goto tagExists
git tag -a v%VERSION% -m "v%VERSION%"
git push --tags
echo "Create release %PROJECT% v%VERSION%"
github-release release --repo %PROJECT% --tag v%VERSION% --name "v%VERSION%" --description ""
pushd release
for /r %%i in (*.7z) do echo "Upload %%~nxi" & github-release upload --repo %PROJECT% --tag v%VERSION% --name "%%~nxi" --file "%%i"
for /r %%i in (*.csv) do echo "Upload %%~nxi" & github-release upload --repo %PROJECT% --tag v%VERSION% --name "%%~nxi" --file "%%i"
popd

:tagExists
popd
goto :eof

:cmdReleaseError
popd
echo "Error - build-sdk git-release: %1"
exit 1

:StepX

for /F "eol=# tokens=1" %%i in (.\source\windows.txt) do call :doRelease %%i
