@echo off

:Start
REM Get target drive letter
echo Enter drive letter of Windows install
set /p userDrive=

REM Change working directory to target registry hive folder
cd /d %userDrive%:\Windows\System32\config
IF NOT %errorlevel% == 0 pause & goto CleanAndExit

REM Check for 'regback' file in Regback folder to determine if this script has been ran previously
IF NOT exist ".\RegBack\regback" goto SkipDoubleRun

:DoubleRun
REM Script has already been run on this volume
echo This script has already been ran on this volume.
echo Delete 'regback' file from RegBack folder to prevent this message.
echo.
CHOICE /T 15 /C ysn /D y /M "Press y to continue, s to open ShadowCopyView, or n to cancel. (Defaults to y in 15 seconds)"
IF %errorlevel%==2 goto Shadowcopy
IF %errorlevel%==3 goto Cancel
IF NOT %errorlevel%==1 goto Fatalerror

:SkipDoubleRun
REM If RegBack is empty, print error
IF NOT exist ".\RegBack\SYSTEM" goto Empty

REM Create temp bat file that will return file size of passed parameter
echo echo %%~z1 > "%TEMP%\filesize.bat"

REM Calls above temp bat file on the SYSTEM hive in the RegBack folder and sets %size% to return value
call "%TEMP%\filesize.bat" ".\RegBack\SYSTEM" > "%TEMP%\RegBackSize.txt"
set /p size= < "%TEMP%\RegBackSize.txt"

REM Deletes temp bat file
del "%TEMP%\filesize.bat" "%TEMP%\RegBackSize.txt"

REM If RegBack SYSTEM hive is empty, print error
IF %size%==0 goto Empty
echo.

REM Display contents of Regback for quality assurance
echo Contents of Regback:
dir ".\RegBack\"
echo.

REM Gives choice of continuing, cancelling, or restarting from beggining
CHOICE /T 15 /C ynr /D y /M "Press y to continue, n to cancel, r to restart. (Defaults to y in 15 seconds)"
IF %errorlevel%==2 goto Cancel
IF %errorlevel%==3 goto Start
IF NOT %errorlevel%==1 goto Fatalerror

REM Set variables containing cleanly formatted date/time
set tempDate=%date:~4%
set tempDate=%tempDate:/=_%
set tempTime=%time:~0,8%
set tempTime=%tempTime::=_%

REM Creates directory with date/time
mkdir ".\Backup %tempDate% %tempTime%\"

REM Copies current files in config folder to previously created folder for backup
xcopy "*.*" ".\Backup %tempDate% %tempTime%\" /h
IF ERRORLEVEL 1 goto XCopyError

REM Deletes current config files
del /ah *.regtrans-ms *.blf *.LOG *.LOG1 *.LOG2
del /ah DEFAULT SAM SECURITY SOFTWARE SYSTEM

REM Copies backup files from RegBack to current config
copy ".\RegBack\*" ".\*"
goto Success

:XCopyError
REM Prints error if the backup fails, removes the backup folder
echo Could not back up current config
rmdir ".\Backup %tempDate% %tempTime%\"
pause
goto CleanAndExit

:Empty
REM Print error if Regback is empty or contains empty hives
echo System hive is empty or does not exist
echo.

REM Asks to run ShadowCopyView
CHOICE /T 15 /C yn /D y /M "Do you want to open ShadowCopyView? (Defaults to y in 15 seconds)"
IF %errorlevel%==2 goto CleanAndExit
IF NOT %errorlevel%==1 goto Fatalerror

:Shadowcopy
echo Opening ShadowCopyView
ping -n 2 0.0.0.0 > NUL
start "" "C:\Program Files\Shadowcopyview\SCV.lnk"
goto CleanAndExit

:Cancel
echo Script cancelled
pause
goto CleanAndExit

:Fatalerror
echo Fatal error: Unexpected errorlevel = %errorlevel%
echo Exitting
pause
goto CleanAndExit

:Success
echo Backed up current hives to
echo %userDrive%:\Windows\System32\config\Backup %tempDate% %tempTime%
echo Copied hives from RegBack into current config.
echo Regback replacement already performed > "%userDrive%:\Windows\System32\config\Regback\regback"
pause
goto CleanAndExit

:CleanAndExit
REM Cleaning temp variables and exit
set userDrive=
set size=
set tempDate=
set tempTime=
exit