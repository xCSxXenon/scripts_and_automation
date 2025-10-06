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
net use \\TECH /user:readonly readonly
cls
echo Copying to Desktop...
robocopy /MIR "\\fileserver\storage\Jordan's Suite\Tech Toolkit\Portable Apps\PortableApps\Gsmart" "%USERPROFILE%\Desktop\Temp\Gsmart" 1> NUL 2> NUL
echo rd /s /q "%USERPROFILE%\Desktop\Temp\" > "%USERPROFILE%\desktop\Remove.bat"
echo del "%USERPROFILE%\desktop\Remove.bat" >> "%USERPROFILE%\desktop\Remove.bat"
echo Gsmart can't be started via CMD, opening File explorer...
timeout 1 1> NUL 2> NUL
start "" "explorer.exe" "%USERPROFILE%\Desktop\Temp\Gsmart"