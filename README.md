# Automated copying of files between two drives/folders twice an hour by Robocopy.exe

The script ‘copy.ps1’ allows you to copy a selected folder/disk and save a copy of the files on the target path. I prepared this script because backing up data is crucial for continued integration. 

Open the downloaded script and change variables such as source and destination folders, intervals (I use 30 minutes), select the log_robocopy path (I use the C drive to avoid accidental deletion by robocopy). The last variable is the copy parameters. If you want to modify the parameters, use this link to

## Installation

Below, I have presented several steps on how to run the script and configure the Windows system to automate the copying of files.

The script has 3 modes: 
- installation - install all the requirements to automate copying files
- run - copy files - manually start the script by pasting the following command into 'PowerShell': ```C:\<path>\copy.ps1 -Mode run```
- logs - remove logs older then 30 days - manually start the script ```C:\<path>\copy.ps1 -Mode logs```

1. Download the repository and unzip it to the 'backup_folders_by_robocopy-main' folder.

2. Enter the folder and edit 'copy.ps1' using Notepad, WordPad or Visual Studio Code. Find the variable section. I have briefly explained what the variables are used for in the file.

3. Click on 'Search' in the left corner -> write 'PowerShell' -> Right-Click -> click 'Run as Administrator' -> paste the following command into the terminal
``` C:\Users\{}\Downloads\\copy.ps1 -Mode install ```

What took place: The script creates two folders: one to save scripts (copy.ps1 and silent-launch.vbs). The first script is a copy of the installation script, and the second allows the script to run in the background (without pop-up windows, etc.). The second folder saves the logs after the files have been copied (in the structure 'logs_yyyyMMdd.txt'). The final step of the script involves registering a new task in Windows at specified intervals.

```PROTIP!!! I suggest not modifying the variables 'targetFolderScript' and 'logsLabel', because these files are more likely to remain unchanged on the C disk.```

__Verification after installation__

Press on your keyboard Windows + R -> write 'taskschd.msc'. In the window, find your script by name and view more details.

## Documentation 
[Microsoft Documentation Robocopy](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy).