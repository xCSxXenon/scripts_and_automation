@echo off
pushd "%LOCALLOW%\semiwork\Repo\saves"
for /d %%a in (.\*) do (
    set saveName=%%~na
    goto getYear
)
:getYear
set year=%saveName:~10,4%
IF %year%==2025 (set year=2024) else (set year=2025)
:createBackup
set backupName=%saveName:~0,10%%year%%saveName:~14%
mkdir %backupName%
copy "%saveName%\%saveName%.es3" "%backupName%\%backupName%.es3"