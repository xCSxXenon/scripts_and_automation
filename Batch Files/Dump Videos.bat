@echo off
set videoLocation=NULL
set moveToPlex=FALSE
if /i "%computername%"=="jordan-antec" goto jordan-antec
if /i "%computername%"=="jl-bench" goto jl-bench
if %videoLocation%==NULL goto ComputerUndefined

:ComputerUndefined
echo Computer not defined, add computer to batch script
pause
start "" notepad.exe "%~dpnx0"
goto Quit

:jordan-antec
SET videoLocation=D:\Temp
SET moveToPlex=TRUE
goto PushFilesToPhone

:jl-bench
SET videoLocation=D:\Phone
goto PushFilesToPhone

:PushFilesToPhone
IF %videoLocation%==NULL SET errMsg=Video location equals NULL & goto Error
IF EXIST "%videoLocation%\Podcasts" IF %moveToPlex%==FALSE "C:\Program Files\ADB\adb.exe" push "%videoLocation%\Podcasts" "/sdcard/Videos/Phone"
IF %errorlevel% NEQ 0 SET errMsg=Pushing 'Podcasts' folder to phone failed & goto Error
FOR %%a in ("%videoLocation%\*") do "C:\Program Files\ADB\adb.exe" push "%%a" "/sdcard/Videos/Phone"
IF %errorlevel% NEQ 0 SET errMsg=pushing files to phone failed & goto Error
goto MoveToPlex

:MoveToPlex
IF %moveToPlex%==FALSE goto Cleanup
IF NOT EXIST "%videoLocation%\Podcasts" goto Cleanup
IF NOT EXIST "\\fileserver\media" SET errMsg=Media folder on server not accessible & goto Error
XCOPY /S "%videoLocation%\Podcasts" "\\fileserver\media\Podcasts"
goto Cleanup

:Cleanup
rd /s /q "%videoLocation%\Podcasts"
del /Q "%videoLocation%\*.mp4" "%videoLocation%\*.mkv"
exit

:Error
@echo Error: %errMsg%
pause
exit

:Quit
exit