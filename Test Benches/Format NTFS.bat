@echo off

:cleanDisk
echo list disk | diskpart
echo.
echo What drive do you want to format?
echo.
set /p drive=
echo.
(echo sel disk %drive%
echo clean) | diskpart

set tempLetter=fghijklmnopqrstuvwxyz
:findAvailableLetter
IF "%tempLetter%"=="" goto noAvailableLetter
IF NOT EXIST %tempLetter:~0,1%:\ (
    set tempLetter=%tempLetter:~0,1%
    goto formatDisk
) else (
    set tempLetter=%tempLetter:~1%
    goto findAvailableLetter
)

:noAvailableLetter
echo.
echo No letter was available to use for renaming.
pause
exit

:formatDisk
(echo sel disk %drive%
echo create part pri
echo format quick fs=ntfs
echo assign letter=%tempLetter%) | diskpart
Label %tempLetter%: Storage
exit