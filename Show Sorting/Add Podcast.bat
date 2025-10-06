@echo off
:checkPrivileges 
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
setlocal & pushd .
CLS

@echo off
setlocal enabledelayedexpansion

set /p "newShowName=Enter show name: "

:getNewShowNameLength
set tempShowName=%newShowName%
set newShowNameLength=0
:CountNewShowNameLength
IF "%tempShowName%"=="" goto LengthFound
set /a newShowNameLength+=1
set tempShowName=%tempShowName:~0,-1%
goto CountNewShowNameLength

:LengthFound
if %newShowNameLength%==0 goto ZeroLengthError
:ConvertToHex
set /a newShowNameLength-=1
set upper=ABCDEFGHIJKLMNOPQRSTUVWXYZ
set lower=abcdefghijklmnopqrstuvwxyz
set hexList=0123456789abcdef

for /L %%i in (0,1,%newShowNameLength%) do (
    set char=!newShowName:~%%i,1!
    set charIntValue=0
    set charHexValue=0
    set tens=
    set ones=
    :LowerCharToHex
    for /L %%j in (0,1,25) do (
        if "!char!" EQU "!lower:~%%j,1!" set /a charIntValue=97+%%j
        set /a tens=!charIntValue!/16%
        set /a ones=!charIntValue!%%16
    )
    :UpperCharToHex
    for /L %%j in (0,1,25) do (
        if "!char!" EQU "!upper:~%%j,1!" set /a charIntValue=65+%%j
        set /a tens=!charIntValue!/16%
        set /a ones=!charIntValue!%%16
    )
    :SpaceChar
    if "!char!"==" " (
        set tens=2
        set ones=0
    )
    if !tens!==0 goto InvalidCharacterInShowNameProvided
    for /f "tokens=1" %%j in ("!tens!") do set charHexValue=!hexList:~%%j,1!
    for /f "tokens=1" %%j in ("!ones!") do set charHexValue=!charHexValue!!hexList:~%%j,1!
    
    set "NewShowNameHex=!NewShowNameHex!!charHexValue!,"
)

set "NewShowNameHex=!NewShowNameHex!\"
echo !NewShowNameHex!

REM Create .reg file to import
REM This isn't working :C It creates a UTF-8 file and REG needs UTF-16 LE
REM Instead, create the key, open it, and copy needed command to clipboard
goto CreateRegistryKey
cd /d C:\
echo Windows Registry Editor Version 5.00 > %newShowName%.reg
echo. >> %newShowName%.reg
echo [HKEY_CLASSES_ROOT\*\shell\Rename Episodically\shell\%newShowName%] >> %newShowName%.reg
echo. >> %newShowName%.reg
echo [HKEY_CLASSES_ROOT\*\shell\Rename Episodically\shell\%newShowName%\command] >> %newShowName%.reg
echo @=hex(2):63,00,6d,00,64,00,20,00,2f,00,63,00,20,00,22,00,22,00,25,00,4f,00,6e,\ >> %newShowName%.reg
echo   00,65,00,44,00,72,00,69,00,76,00,65,00,25,00,5c,00,50,00,43,00,5c,00,42,00,\ >> %newShowName%.reg
echo   61,00,74,00,63,00,68,00,20,00,46,00,69,00,6c,00,65,00,73,00,5c,00,47,00,65,\ >> %newShowName%.reg
echo   00,74,00,20,00,45,00,70,00,69,00,73,00,6f,00,64,00,65,00,20,00,4e,00,75,00,\ >> %newShowName%.reg
echo   6d,00,62,00,65,00,72,00,73,00,2e,00,62,00,61,00,74,00,22,00,20,00,22,00,25,\ >> %newShowName%.reg
echo   00,31,00,22,00,20,00,22,00,50,00,6f,00,64,00,63,00,61,00,73,00,74,00,73,00,\ >> %newShowName%.reg
echo   22,00,20,00,\ >> %newShowName%.reg
echo   22,\ >> %newShowName%.reg
echo   %NewShowNameHex% >> %newShowName%.reg
echo   00,22,00,22,00,00,00 >> %newShowName%.reg

notepad.exe %newShowName%.reg
REM REG IMPORT %newShowName%.reg
del %newShowName%.reg

:CreateRegistryKey
REG ADD "HKCR\*\shell\Rename Episodically\shell\%newShowName%\command" /t REG_EXPAND_SZ
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v LastKey /t REG_SZ /d "HKCR\*\shell\Rename Episodically\shell\%newShowName%\command" /f
set "defaultValue=cmd /c ""%OneDrive%\PC\Batch Files\Show Sorting\Episode Rename and Sort.bat" "%%1" "Podcasts" "%newShowName%"""
echo %defaultValue% | clip.exe
start "" regedit.exe
goto quit

:InvalidCharacterInShowNameProvided
CLS
echo.
echo An invalid character was entered. Only letters and spaces are allowed.
pause
goto quit

:ZeroLengthError
CLS
echo.
echo Empty name or invalid character specified. Only letters and spaces are allowed.
pause
goto quit

:quit
exit