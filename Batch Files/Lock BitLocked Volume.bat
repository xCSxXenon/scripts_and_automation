@echo off
setlocal enabledelayedexpansion
set lockTimeoutSeconds=15

REM A script that takes an input volume name and locks it.
REM Usage: Call script with a volume name as a quoted parameter. Ex: GetDriveLetterFromVolumeName.bat "USB drive"

REM LIMITATIONS
REM This only searches using the first 11 characters. If multiple volume names share the first 11 characters, this is unreliable.
REM If the search string contains extra spaces at the end, or vice versa, it still matches. Feature? Only works on local storage.

REM Diskpart only displays the first 11 characters, so pad and truncate for easier comparison later
set volumeName=%~1
set limitedVolumeName=%volumeName%           
set limitedVolumeName=%limitedVolumeName:~0,11%

REM Save output of DiskPart 'list vol' in a file and parses it looking for volume name. Keep first 30 characters to confirm
REM volume name. This prevents false positives in cases where a volume name is a possible value for another column.
set found=false
echo list vol | diskpart > volumes.txt
for /f "delims=" %%a in ('find /I "   %limitedVolumeName%  " volumes.txt') do (
  set volumeLine=%%a
  set volumeLine=!volumeLine:~0,30!
  IF /I "!volumeLine:~-11!"=="%limitedVolumeName%" (set found=true)
)

IF %found%==false goto VolumeNotFound
REM Edge case: If you search for "volumes.txt" but it isn't an existing volume, %found% will be true because 'findstr' also
REM returns the file name for some reason. The below conditional checks for this.
IF "%volumeLine:~0,10%"=="----------" goto VolumeNotFound

REM Get the volume letter and check if it is empty
set volumeLetter=%volumeLine:~15,1%
IF "%volumeLetter%"==" " goto NoLetterAssigned

REM Lock volume
:Lock
cls
manage-bde -lock %volumeLetter%:
IF EXIST %volumeLetter%:\ goto LockTimeout
goto Quit
:LockTimeout
cls
echo Failed to lock, retrying in: %lockTimeoutSeconds%
set count=%lockTimeoutSeconds%
set seconds=%time:~6,2%
:CountTime
IF %seconds% == %time:~6,2% (goto CountTime) else (set seconds=%time:~6,2%)
cls
set /A count-=1
echo Failed to lock, retrying in: %count%
IF %count% LEQ 0 goto lock
goto CountTime

:NoLetterAssigned
echo.
echo Volume name found but it has no assigned letter.
echo It may be mounted using a mountpoint, which isn't supported.
goto Quit

:VolumeNotFound
echo.
echo Volume name not found. Search is not case-sensitive, but check for typos
goto Quit

:Quit
del volumes.txt
exit