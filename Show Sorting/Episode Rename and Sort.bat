@echo on

IF "%~1"=="%%1" goto noFileProvided
IF "%~1"=="" goto noFileProvided

REM Checks if show has a season for the current year
set year=%date:~-4%
set category=%~2
set series=%~3
set categoryPath=\\fileserver\media\%category%
set showPath=\\fileserver\media\%category%\%series%
:returnFromNewSeason
set seriesPath=\\fileserver\media\%category%\%series%\%year%
if EXIST "%~dp1%category%\%series%\%year%" set seriesPath=%~dp1%category%\%series%\%year%
if NOT EXIST "%seriesPath%" GOTO notFound
GOTO getNextEpisode

REM Show is current, get next epsiode number
REM Rename, sort into folder, create copy for phone
:getNextEpisode
for /f %%i in ('dir "%seriesPath%" /b/a-d/on') do set seasonAndEpisode=%%i	
if "%seasonAndEpisode%"=="" GOTO currentSeasonEmpty
set seasonNumber=%seasonAndEpisode:~0,4%
set episodeNumber=%seasonAndEpisode:~4%
IF %episodeNumber% LSS 10 set episodeNumber=%episodeNumber:~1%
set /a episodeNumber=%episodeNumber%+1
IF %episodeNumber% LSS 10 set episodeNumber=0%episodeNumber%
move "%~1" "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1"
copy "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1" "%~dp1Podcast - %~n1%~x1"
mkdir "%~dp1%category%\%series%\%year%"
move "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1" "%~dp1%category%\%series%\%year%\%seasonNumber%%episodeNumber% %~n1%~x1"
goto exit


REM Current year's folder not found for show
REM Determine if new show or new season/year
:notFound
IF NOT EXIST "%categoryPath%" GOTO serverDisconnected
if NOT EXIST "%showPath%" GOTO newShow
goto newSeason


REM Show exists but it's a new year/season. Detect last season # and start at E01
REM Rename, sort into folder, create copy for phone
:newSeason
set episodeNumber=01
for /f "tokens=*" %%i in ('dir "%showPath%" /b/ad/on') do set lastYear=%%i

REM If seasons aren't organized by year, use season # as 'year'. This will require new seaons to be crated manually
IF /I %lastYear:~0,6%==Season set year=%lastYear%& goto returnFromNewSeason
for /f %%i in ('dir "%showPath%\%lastYear%" /b/a-d/on') do (
    set seasonAndEpisode=%%i
    goto break1
)
:break1
if "%seasonAndEpisode%"=="" GOTO error
set seasonNumber=%seasonAndEpisode:~1,2%
set /a seasonNumber=%seasonNumber%+1
IF %seasonNumber% LSS 10 set seasonNumber=0%seasonNumber%
set seasonNumber=S%seasonNumber%E
move "%~1" "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1"
copy "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1" "%~dp1Podcast - %~n1%~x1"
mkdir "%~dp1%category%\%series%\%year%"
move "%~dp1%seasonNumber%%episodeNumber% %~n1%~x1" "%~dp1%category%\%series%\%year%\%seasonNumber%%episodeNumber% %~n1%~x1"
goto exit


REM Show doesn't exist yet
:newShow
move "%~1" "%~dp1S01E01 %~n1%~x1"
copy "%~dp1S01E01 %~n1%~x1" "%~dp1Podcast - %~n1%~x1"
mkdir "%~dp1%category%\%series%\%year%"
move "%~dp1S01E01 %~n1%~x1" "%~dp1%category%\%series%\%year%\S01E01 %~n1%~x1"
goto exit


:error
rem cls
color 04
echo There was an error
pause
goto exit

:currentSeasonEmpty
rem cls
color 04
echo Current season folder exists but is empty.
pause
goto exit

:noFileProvided
rem cls
color 04
echo No file was provided
pause
goto exit

:serverDisconnected
rem cls
color 04
echo Not connected to server.
pause
goto exit

:exit
REM pause
exit