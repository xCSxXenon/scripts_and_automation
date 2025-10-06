@echo off
set "ytdlp=%OneDrive%\PC\Batch Files\Video Downloading\yt-dlp.exe"
set "ffmpeg=%OneDrive%\PC\Batch Files\Video Downloading\ffmpeg.exe"
set destination=NULL

if /i "%computername%"=="jordan-antec" set destination=D:\temp
if /i "%computername%"=="jl-bench" set destination=NULL
if %destination%==NULL goto ComputerUndefined
goto Input

:ComputerUndefined
echo Computer not defined, no destination set
echo Add computer and destination in batch script
pause
start "" notepad.exe "%~dpnx0"
goto Quit

:LocationNotFound
cls
echo.
echo Destination or OneDrive location does not exist
pause
goto Quit

:Input
if not exist %destination% goto LocationNotFound
if not exist %onedrive% goto LocationNotFound
echo Enter link
set /p answer=
goto Download

:Download
cls
echo.
"%ytdlp%" -o "%destination%\%%(title)s.%%(ext)s" --cookies %USERPROFILE%\cookies.txt --ffmpeg-location "%ffmpeg%" --merge-output-format mp4 --format bestvideo[ext=mp4]+bestaudio --no-playlist %answer%
goto Quit

:Quit
exit