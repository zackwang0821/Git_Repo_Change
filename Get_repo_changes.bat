@echo off
chcp 65001 > NUL
REM set color YELLOW/BLACK
color E0
call :WELCOME

REM ============================================================
REM CONFIG

set "START_COMMIT=8ea08ee8a724c412c63961f46df5ee382c74e233"
set "UNTIL_COMMIT=1776be427f4e54e8907f173b695c04cd4636ce7c"
set "SOURCE_CODE_DIR_NAME=5.dmc-fw_DB1"

REM ============================================================
REM BASE_ENV

set "MSG="
set "EXE_7z=C:\Program Files\7-Zip\7z.exe"
set "DIR_PUSHED=FALSE"
set "WORKDIR=%CD%"
set "OUTPUT_DIR=%CD%\%SOURCE_CODE_DIR_NAME%_change_list"
set "OUTPUT_LIST_NAME=change_list.txt"

REM ============================================================
REM CMDs

set "GIT_VER=git --version "
set "GIT_LOG=git log --decorate=short"

REM ============================================================
REM PRE_CHECK

REM Check git
%GIT_VER%  >NUL 2>&1 || ( call :ERROR_WITH_MSG "Git not found" && goto :END )

REM Check SOURCE_CODE_DIR_NAME
if "%SOURCE_CODE_DIR_NAME%"=="" ( call :ERROR_WITH_MSG "Source directory ARG not found." && goto :END )
if not exist "%SOURCE_CODE_DIR_NAME%" ( call :ERROR_WITH_MSG "Source directory not found." && goto :END )

REM Check OUTPUT_DIR
if not exist "%OUTPUT_DIR%" (
  mkdir "%OUTPUT_DIR%" || ( call :ERROR_WITH_MSG "Create directory failed." && goto :END )
  echo "%OUTPUT_DIR% was created."
)
del /Q "%OUTPUT_DIR%\*.*"

REM ============================================================
REM Main Program region
pushd %SOURCE_CODE_DIR_NAME% && set "DIR_PUSHED=TRUE"

REM Get commit change list
echo Getting commit change list...
%GIT_LOG% "%START_COMMIT%".."%UNTIL_COMMIT%" > "%OUTPUT_DIR%\%OUTPUT_LIST_NAME%"

REM Main Program end
echo.
echo Done
echo.
:END
if "%DIR_PUSHED%"=="TRUE" ( popd )
if not "%MSG%" == "" echo %MSG%
timeout -1
REM set color BLACK/WHITE
color 07
goto :EOF

REM ============================================================
REM Subroutine region

:ERROR_WITH_MSG
set "MSG=%~1"
exit /b 0

:WELCOME
echo.
echo --------------------------------
echo.
set  "script_version=1.0"
echo Program name: Get repo changes v%script_version%
echo.
echo --------------------------------
echo.
exit /b 0
