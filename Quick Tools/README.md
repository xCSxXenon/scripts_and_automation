These are all scripts I wrote to automate and enhance workflow during service.

"7zip, NanaZip, LibreOffice, VLC Installer.bat" is a standalone script that allows you to install/uninstall the listed programs. It detects Windows 10 or 11 and queues 7zip for 10 and NanaZip for 11. Uses WinGet for installation.

"Activate Windows 10-11.bat" uses [Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts) to activate Windows. Just as Microsoft's own support has used it, I have used it for legitimate copies of Windows that simply refuse to activate.
Use at your own risk, get a legal key, whatever, I'm not your lawyer or your mom.

"BitLocker Decryption with Progress Bar.bat" is just for convenience. It asks for a volume letter and decrypts it while showing a big yellow progress bar. Can't clone BitLocked drives in an efficient way, IYKYK. This makes it easy to glance at a screen to check progress without
having to move across a room or building.

"DDU.bat" copies [Display Driver Uninstaller](https://www.wagnardsoft.com/display-driver-uninstaller-ddu) from my server, runs it, and then deletes it once closed.

"Driver Removers.bat" uses [DevManView](https://www.nirsoft.net/utils/device_manager_view.html) and [DriverStoreExplorer](https://github.com/lostindark/DriverStoreExplorer/tree/v0.12.127). Copies them from my server, runs DevManView to remove old/disconnected devices,
runs DriverStoreExplorer to remove old drivers and drivers for old/disconnected devices, then opens Device Manager to scan for devices to restore any false positives.

"Find IPv4.bat" finds ipv4 addresses present in the system.

"Get OEM Key.bat" displays the OEM Windows activation key embedded in the ACPI of the system. Usually nothing for custom builds, but super valuable for recovering keys on pre-builts and laptops.

"Gsmart.bat" copies [GSmartControl](https://gsmartcontrol.shaduri.dev/) from my server and opens the destination folder in File explorer. Opening it via CLI doesn't display a GUI for some reason, so it has to be clicked manually. Leaves a "Remove.bat"
on the Desktop to remove GSmart manually.

"HWiNFO + MSI Kombustor.bat" copies [HWiNFO](https://www.hwinfo.com/) and [MSI Kombustor](https://geeks3d.com/furmark/kombustor/) from my server and opens them. Used for stress testing and monitoring system metrics.

"MiniTool.bat" copies [MiniTool Partition Wizard](https://www.partitionwizard.com/) from my server and opens it. Mainly used for visualizing disk layouts and fixing erroneously formatted drives.

"Patch Cleaner.bat" copies [Patch Cleaner](https://www.homedev.com.au/free/patchcleaner) from my server, runs it via CMD, displays results, and removes itself after.

"Swap Drive Letters.bat" takes two volume letters from the user and swaps them. Easier than diskpart or Disk Management.

"Toggle Sleep.bat" Enables/disables turning off display and going to sleep. Helpful for leaving devices unattended to finish processing.

"UCheck.bat" copies [UCheck](https://www.adlice.com/ucheck/) from my server, opens it, then removes itself after being closed. Used for updating software.

"Update Nvidia Drivers.bat" copies [TNUC](https://github.com/ElPumpo/TinyNvidiaUpdateChecker) from my server, makes sure prereqs are installed, and updates Nvidia GPU drivers.

"User Data.bat" parsed folder names on a local server and copied the selected folder to the Desktop. Plaintext credentials are fine because they are readonly, accessing this script required other secure credentials, and you'd need access to the local network.

"Why Not Windows 11.bat" copies [WhyNotWin11](https://whynotwin11.com/) from my server, runs it, and removes itself after closing.

"WizTree.bat" copies [WizTree](https://diskanalyzer.com/) from my server, opens it, and removes itself after closing.
