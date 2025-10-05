@echo off
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

If exist "C:\ProgramData\Sleep Control\disabled.txt" goto EnableSleep

:DisableSleep
set status=disabled
powercfg /x standby-timeout-ac 0
powercfg /x standby-timeout-dc 0
powercfg /x monitor-timeout-ac 0
powercfg /x monitor-timeout-dc 0
mkdir "C:\ProgramData\Sleep Control\"
echo This file means sleep has been disabled by Jordan's script > "C:\ProgramData\Sleep Control\disabled.txt"
goto end

:EnableSleep
set status=enabled
powercfg -x -standby-timeout-ac 30
powercfg -x -standby-timeout-dc 15
powercfg /x monitor-timeout-ac 10
powercfg /x monitor-timeout-dc 5
rd /s /q "C:\ProgramData\Sleep Control\"
goto end

:end
start "" mshta javascript:alert("Sleep has been %status%");close()
exit
