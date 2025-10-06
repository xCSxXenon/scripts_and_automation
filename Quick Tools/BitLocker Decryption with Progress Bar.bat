@echo off
setlocal
call :setESC

set name=%~n0%~x0

:check
IF "%~0" == "%TEMP%\%name%" goto start
del /f "%TEMP%\%name%" 1> NUL 2> NUL
copy %0 "%TEMP%\" 1> NUL 2> NUL
call "%TEMP%\%name%"
exit

:start
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 

:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 

:gotPrivileges 
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
setlocal & pushd .

:getDriveLetter
echo Enter drive letter to decrypt:
set /p drive=
cls
manage-bde -status %drive%: >NUL
IF %ERRORLEVEL%==-1 goto invalidDrive
manage-bde -off %drive%: >NUL

:getPercent
for /f "delims=: tokens=1*" %%a in ('manage-bde -status %drive%:') do (IF "%%a"=="    Percentage Encrypted" SET "rawPercent=%%b")
set percent=%rawPercent:~1,-3%%rawPercent:~-2,1%
IF %percent% LSS 10 set percent=%percent:~1%
REM color 0a

:loading
if %percent%==0 goto Finished
@echo off
set load=
set /a count=0
:loop
if %count%==%percent% goto displayProgress
set load=%load%H
set /a count=%count%+1
goto loop

:displayProgress
cls
echo.
echo %ESC%[35mCurrent Percentage Encrypted:%ESC%[36m%rawPercent%%ESC%[0m
echo %ESC%[31mDecrypting... Please Wait...%ESC%[0m
echo.
echo %ESC%[33;43m%load%%ESC%[0m
timeout 15 >NUL
REM set /a percent=%percent%-1
goto getPercent

:invalidDrive
cls
echo.
echo %ESC%[31mInvalid drive specified%ESC%[0m
echo %ESC%[31mPress any key to continue . . .%ESC%[0m
pause >NUL
exit

:Finished
cls
echo.
echo %ESC%[32mDecryption finished%ESC%[0m
echo %ESC%[32mPress any key to continue . . .%ESC%[0m
pause >NUL
exit

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

:quit
exit