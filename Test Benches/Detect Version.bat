@echo off
setlocal
call :setESC
cls
echo.
echo.
set /p drive=Enter drive letter:
if /i %drive%==c goto OnlineOS
if not exist %drive%:\Windows\System32\config\SOFTWARE (goto HiveNotFound) else (goto Found)

:OnlineOS
cls
echo.
echo.
echo %ESC%[31mYou're a monster, use winver%ESC%[0m
echo.
echo.
echo.
pause
goto CleanAndExit

:HiveNotFound
if not exist %drive%:\Windows (goto OSNotFound)
cls
echo.
echo.
echo %ESC%[31mSOFTWARE registry hive not found in %drive%:\Windows\System32\config\%ESC%[0m
echo.
echo.
echo.
pause
goto CleanAndExit

:OSNotFound
cls
echo.
echo.
echo %ESC%[31mWindows OS not found on %drive%.%ESC%[0m
echo.
echo.
echo.
pause
goto CleanAndExit

:Found
cls
echo Retrieving OS details...
reg load HKLM\temp %drive%:\Windows\System32\config\SOFTWARE 1> DetectVersionError.txt 1> NUL 2> NUL
if %errorlevel%==1 goto FailedToMount
reg query "HKLM\temp\Microsoft\Windows NT\CurrentVersion" /v ProductName 1> NUL 2> NUL
if %errorlevel%==1 goto Corrupted
for /f "tokens=3*" %%i in ('reg query "HKLM\temp\Microsoft\Windows NT\CurrentVersion" /v ProductName') do set version=%%i %%j
for /f "tokens=3*" %%i in ('reg query "HKLM\temp\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion') do set edition=%%i
for /f "tokens=3*" %%i in ('reg query "HKLM\temp\Microsoft\Windows NT\CurrentVersion" /v CSDVersion') do set servicePack=%%i %%j
cls
echo Retrieving OS details...
powershell "(Get-Disk (Get-Partition -DriveLetter '%drive%').DiskNumber | select PartitionStyle | format-list | Out-String).Trim() | out-file PartitionStyle.txt -encoding utf8
set /p partitionStyle=<PartitionStyle.txt
set partitionStyle=%partitionStyle:~-3%
cls
echo.
echo.
echo.
echo %ESC%[92m%version% %edition%%servicePack% %partitionStyle%%ESC%[0m
echo.
echo.
pause
goto CleanAndExit

:Corrupted
cls
echo.
echo.
echo %ESC%[31mHive corrupted%ESC%[0m
echo.
echo.
echo.
pause
goto CleanAndExit

:FailedToMount
set /p error=DetectVersionError.txt
cls
echo.
echo.
echo %ESC%[31mCouldn't mount SOFTWARE hive. Error:%ESC%[0m
echo %ESC%[31m%error%%ESC%[0m
echo.
echo.
echo.
pause
goto CleanAndExit

:CleanAndExit
del DetectVersionError.txt 1> NUL 2> NUL
del PartitionStyle.txt 1> NUL 2> NUL
set error=
set drive=
set partitionStyle=
reg unload HKLM\temp 1> NUL 2> NUL
exit


:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)
