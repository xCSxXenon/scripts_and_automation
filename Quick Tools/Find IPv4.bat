@echo off
setlocal enabledelayedexpansion
echo.
echo.
echo.
set count=0
for /f "delims=" %%a in ('ipconfig') do (
set "result=%%a"
IF NOT "!result:~0,3!"=="   " set "adapterName=!result!"
IF "!result:~3,12!"=="IPv4 Address" set /a count+=1 & echo !adapterName! & echo !result:~39! & echo.
)
echo %count% IPs found
echo.
echo.
echo.
echo.
echo.
pause