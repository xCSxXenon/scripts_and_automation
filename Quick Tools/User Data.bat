@echo off
net use n: "\\jl-bench1\client data" /USER:readonly readonly
SETLOCAL EnableDelayedExpansion
cls

:beginning
set /A step=1
for /d %%a in ("N:\*") do (
	echo !step!.  %%~na
	set dir!step!=%%~na
	set /a step=step+1
	set limit=!step!
)
echo.
echo.
echo Which folder do you want?
echo Enter 0 to cancel
set answer=empty
set /p answer=
if %answer% LEQ -1 goto negative
if %answer%==empty goto empty
if %answer%==0 goto quit
if %answer% GEQ !limit! goto large
goto transfer

:negative
echo.
echo.
echo Error: Answer can't be negative.
echo.
echo.
timeout 5
cls
echo.
echo.
goto beginning


:empty
echo.
echo.
echo Error: Answer can't be left blank.
echo.
echo.
timeout 5
cls
echo.
echo.
goto beginning

:large
echo.
echo.
echo Error: Answer can't be !limit! or higher.
echo.
echo.
timeout 5
cls
echo.
echo.
goto beginning

:transfer
set answer=!dir%answer%!
robocopy /MIR /MT "N:\%answer%" "%USERPROFILE%\Desktop\%answer%" /XD "N:\%answer%\Image"
net use n: /delete
cls
color 02
echo.
echo Finished copying "%answer%" to the Desktop.
echo.
echo.
pause

:quit
exit
