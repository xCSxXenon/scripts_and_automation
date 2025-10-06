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
echo Copying files to Desktop...
robocopy /MIR "\\fileserver\storage\Jordan's Suite\Tech Toolkit\Portable Apps\PortableApps\HWiNFOPortable" "%USERPROFILE%\Desktop\Temp\HWiNFOPortable" 1> NUL 2> NUL
robocopy /MIR "\\fileserver\storage\Jordan's Suite\Tech Toolkit\Portable Apps\PortableApps\MSI Kombustor" "%USERPROFILE%\Desktop\Temp\MSI Kombustor" 1> NUL 2> NUL
echo Starting HWiNFO and MSI Kombustor...
start "" "%USERPROFILE%\Desktop\Temp\HWiNFOPortable\HWiNFOPortable.exe"
timeout 1 1> NUL 2> NUL
echo When finished, come back and press any key to close and cleanup
timeout 7 1> NUL 2> NUL
start "" "%USERPROFILE%\Desktop\Temp\MSI Kombustor\MSI-Kombustor-x64.exe"
start "" "%USERPROFILE%\Desktop\Temp\MSI Kombustor\CPU-Burner-x32.exe"
pause > NUL
taskkill /f /im HWiNFOPortable.exe 1> NUL 2> NUL
taskkill /f /im HWiNFO32.exe 1> NUL 2> NUL
taskkill /f /im HWiNFO64.exe 1> NUL 2> NUL
taskkill /f /im MSI-Kombustor-x64.exe 1> NUL 2> NUL
taskkill /f /im CPU-Burner-x32.exe 1> NUL 2> NUL
timeout 2 1> NUL 2> NUL
rd /s /q "%USERPROFILE%\Desktop\Temp\HWiNFOPortable"
rd /s /q "%USERPROFILE%\Desktop\Temp\MSI Kombustor"
dir /b "%USERPROFILE%\Desktop\Temp\" | findstr /R "." && goto notempty
rd /s /q "%USERPROFILE%\Desktop\Temp\"
:notempty
exit
