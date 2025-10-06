@echo off
echo list disk | diskpart
echo.
echo What drive do you want to wipe?
echo.
set /p drive=
echo.
(echo sel disk %drive%
echo clean) | diskpart
exit