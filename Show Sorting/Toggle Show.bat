@echo off
setlocal enabledelayedexpansion
cls

set enableDisableStatus=enabled
set updatingStatus=false
set "keyPath=HKCR\*\shell\Rename Episodically\shell"
set "tempKeyPath=HKCR\*\Disabled Shows"
set charactersToStrip=52

:GetListOfShows
set iter=1
for /F "delims=" %%a in ('reg query "%keyPath%"') do (
    set "entryName=%%a"
    set "entryName=!entryName:~%charactersToStrip%!"
    set "show!iter!=!entryName!"
    set /a iter=!iter!+1
    
)

set /a numberOfEntries=%iter%-1
if %updatingStatus%==false echo.
set updatingStatus=false

:DisplayList
echo.
echo Currently %enableDisableStatus% shows:
for /L %%a in (1,1,%numberOfEntries%) do (
    echo %%a: !show%%a!
)

:GetSelection
echo.
set selection=
echo Enter 't' to toggle enable/disable or 'q' to cancel and quit.
set /p "selection=Enter number to disable: "
if %selection% EQU q cls & goto :EOF
if %selection% EQU t cls & goto ToggleEnableDisable
if %selection% LSS 1 cls & echo Invalid number & goto DisplayList
if %selection% GTR %numberOfEntries% cls & echo Invalid number & goto DisplayList
echo.
echo You selected "%selection%": !show%selection%!
REG COPY "%keyPath%\!show%selection%!" "%tempKeyPath%\!show%selection%!" /s /f
REG DELETE "%keyPath%\!show%selection%!" /f
cls
if %enableDisableStatus%==enabled (
    set updatingStatus=true
    echo Disabled "!show%selection%!" successfully!
) else (
    set updatingStatus=true
    echo Enabled "!show%selection%!" successfully!
)
goto GetListOfShows


:ToggleEnableDisable
if %enableDisableStatus%==enabled (
    set enableDisableStatus=disabled
    set charactersToStrip=35
) else (
    set enableDisableStatus=enabled
    set charactersToStrip=52
)
set "swapPath=%keyPath%"
set "keyPath=%tempKeyPath%"
set "tempKeyPath=%swapPath%"
set swapPath=
cls
goto GetListOfShows