"Clean Disk.bat" takes a Disk # from the user and cleans all partitions off of it.

"Detect Version.bat" gets a drive letter from the user and returns the version and boot format of the installed Windows installation.

"Format NTFS.bat" takes a Disk # from the user, wipes all partitions off of it, then formats it to NTFS.

"Organize User Data.bat" takes a user's home directory as an argument and then very aggressively cleans/organizes it.

"Rebuild BCD.bat" detects the boot scheme and rebuilds the BCD of the given Windows installation based on OS drive letter and boot partition number. Does not detect if given
volumes are the same and will clobber the Windows install of they are. GPT is almost ubiquitous so it was never important enough to fix.

"RegBack.bat" is a beauty. Sometimes Windows won't boot due to a broken registry file. Windows used to store VSS copies in the RegBack folder, this script will backup the current registry files and replace
them with these backup copies if they exist. Microsoft turned this off to save a few KBs, so if they don't exist or are corrupt, I use [ShadowCopyView](https://www.nirsoft.net/utils/shadow_copy_view.html) to browse for these files in a restore point.
If they exist, I can manually put them in the RegBack folder and run this script again, mainly to maintain good and timestamps backups.
