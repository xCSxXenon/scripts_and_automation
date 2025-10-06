@echo off
set "removeDriveEXELocation=%OneDrive%\PC\Batch Files\USB Setup\RemoveDrive.exe"

:start
rem Get drive letter of flash drive
echo list vol | diskpart
echo What is the drive letter of your USB?
set /p usbLetter=

rem Checks drive letter against drives that shouldn't be formatted
rem If a restricted drive letter is used, goto reject at end of script
IF %usbLetter%==c goto reject
IF %usbLetter%==d goto reject

rem Get name and MID to use for flash drive label
echo Enter customer name and MID (if applicble):
set /p usbLabel=

rem Format selected drive letter as exFAT, quickly, force dismount, name it "Temp"
rem Change label from "Temp" to "Flash Drive" because the format command doesn't support spaces
rem Not using name/MID since 11 characters is the max unless using autorun file
format %usbLetter%: /FS:exFAT /Q /X /V:Temp /y
label %usbLetter%: Flash Drive

rem Switch working directory to now formatted flash drive
rem Copy icon and autorun files to flash drive
%usbLetter%:
xcopy /Q /Y "%OneDrive%\PC\Batch Files\USB Setup\icon.ico" ".\"
xcopy /Q /Y "%OneDrive%\PC\Batch Files\USB Setup\autorun.inf" ".\"

rem Enter info into autorun file using name/MID from earlier and make them hidden
REM echo [Autorun] > ".\autorun.inf"
REM echo Icon=icon.ico >> ".\autorun.inf"
echo Label=%usbLabel% >> ".\autorun.inf"
attrib +H ".\autorun.inf"
attrib +H ".\icon.ico"
CHOICE /c yn /d n /t 30 /n /m "Do you want to eject? [Y/N]"
if %errorlevel%==1 goto eject
exit

:eject
rem Change working directory to C:, eject the flash drive, repeat if not successful
rem Clean up variables used and exit
C:
"%removeDriveEXELocation%" %usbLetter%: -L
exit

:reject
rem This displays an error and restarts when an invalid letter is specified
echo Invalid letter
goto start
