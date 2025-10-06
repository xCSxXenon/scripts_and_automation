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
echo Copying to Desktop
robocopy /mir "\\fileserver\storage\Jordan's Suite\Tech Toolkit\Portable Apps\PortableApps\PatchCleaner" "%USERPROFILE%\Desktop\Temp\PatchCleaner" 1> NUL 2> NUL
start "" "%USERPROFILE%\Desktop\Temp\PatchCleaner\PatchCleaner.exe"
timeout 1 1>NUL
taskkill /f /im "PatchCleaner.exe" 1>NUL 2>NUL
for /D %%a in ("%LOCALAPPDATA%\HomeDev\*") do (
    for /D %%b in ("%%a\*") do (
        copy /Y "%USERPROFILE%\Desktop\Temp\PatchCleaner\user.config" "%%b" 1>NUL 2>NUL
    )
)
echo Running Patch cleaner...
"%USERPROFILE%\Desktop\Temp\PatchCleaner\PatchCleaner.exe" /d
echo.
echo Finished cleaning!
pause
rd /s /q "%LOCALAPPDATA%\HomeDev"
rd /s /q "%USERPROFILE%\Desktop\Temp\PatchCleaner"
dir /b "%USERPROFILE%\Desktop\Temp\" | findstr /R "." && goto notempty
rd /s /q "%USERPROFILE%\Desktop\Temp\"
:notempty
exit
