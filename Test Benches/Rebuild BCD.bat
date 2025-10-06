@echo off

::TODO - Detect if selected Windows volume and selected boot partition are the same, error if true

::This finds a free letter for rebuilding the BCD later
set tempLetter=abcdefghijklmnopqrstuvwxyz
:FindAvailableLetter
IF "%tempLetter%"=="" goto NoAvailableLetter
IF NOT EXIST %tempLetter:~0,1%:\ (
    set tempLetter=%tempLetter:~0,1%
    goto GetWindowsLetter
) else (
    set tempLetter=%tempLetter:~1%
    goto FindAvailableLetter
)

:NoAvailableLetter
echo.
echo No letter was available to use.
pause
exit

:GetWindowsLetter
echo list vol | diskpart
set /p drive=Enter drive letter:
IF NOT EXIST %drive%: echo Invalid letter & echo. & pause & goto GetWindowsLetter
IF NOT EXIST %drive%:\Windows echo Windows not found & echo. & pause & goto GetWindowsLetter

::Gets partition scheme (GPT/MBR) of disk containing selected volume
(echo sel vol %drive%
echo list disk) | diskpart > partitionScheme.txt
for /f "delims=" %%a in ('find /N "* Disk" partitionScheme.txt') do (
  set partitionScheme=%%a
)
set partitionScheme=%partitionScheme:~-1%
IF "%partitionScheme%"=="*" (set partitionScheme=GPT) else (set partitionScheme=MBR)
del partitionScheme.txt

:GetBootPartitionNumber
(echo sel vol %drive%
echo list part) | diskpart
echo. 
echo Select boot partition #
set /p bootPartitionNumber=

:Rebuildboot
if /I %partitionScheme%==GPT (
    set bootPartitionStyle=EFI
    set bootPartitionFormat=FAT32
) else (
    set bootPartitionStyle=PRI
    set bootPartitionFormat=NTFS
)

(echo sel vol %drive%
echo sel part %bootPartitionNumber%
echo del part override
echo create part %bootPartitionStyle%
echo format quick fs=%bootPartitionFormat%
echo assign letter=%tempLetter%
echo active) | diskpart

:Rebuildbcd
echo.
if /I %partitionScheme%==GPT (
    bcdboot %drive%:\windows /s %tempLetter%:\ /f UEFI
) else (
    bcdboot %drive%:\Windows /s %tempLetter%:\ /f BIOS
)
(echo sel vol %tempLetter%
echo remove) | diskpart

cls
echo.
echo BCD rebuild complete
pause
exit