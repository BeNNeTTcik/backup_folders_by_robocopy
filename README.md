# Automated copying of files between two drives/folders twice an hour by Robocopy.exe

The script ‘copy.ps1’ allows you to copy a selected folder/disk and save a copy of the files on the target path. I prepared this script because backing up data is crucial for continued integration. Moreover, it helps when the disk breaks.

## Installation

Below, I have presented several steps on how to run the script and configure the Windows system to automate the copying of files.

The script has 3 modes: 
- install - installation all the requirements to automate copying files
- run - copy files - manually start the script by pasting the following command into 'PowerShell': ```C:\<path>\copy.ps1 -Mode run```
- logs - remove logs older then 30 days - manually start the script ```C:\<path>\copy.ps1 -Mode logs```

1. Download the repository. Click on 'Search' in the left corner -> write 'Windows PowerShell' -> Right-Click -> click 'Run as Administrator' -> paste the following command into the terminal: ```Expand-Archive -Path "$env:USERPROFILE\Downloads\backup_folders_by_robocopy-main.zip" -DestinationPath "$env:USERPROFILE\Downloads\backup_folders_by_robocopy-main" -Force```

2. Enter the folder and edit 'copy.ps1' using Notepad, WordPad or Visual Studio Code. Find the variable section. I have briefly explained what the variables are used for in the file. Save the script after making modifications.

```PROTIP!!! I suggest not modifying the variables 'targetFolderScript' and 'logsLabel', because these files are more likely to remain unchanged on the C disk.```

3. Open the Windows PowerShell window ('Run as Administrator') and paste the following command into the terminal: ``` Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$env:USERPROFILE\Downloads\backup_folders_by_robocopy-main\backup_folders_by_robocopy-main\copy.ps1`" -Mode install" ```

What took place: The script creates two folders: one to save scripts (copy.ps1 and silent-launch.vbs). The first script is a copy of the installation script, and the second allows the script to run in the background (without pop-up windows, etc.). The second folder saves the logs after the files have been copied (in the structure 'logs_yyyyMMdd.txt'). The final step of the script involves registering a new task in Windows at specified intervals.

__Verification after installation__

On your keyboard, press Windows + R and write "taskschd.msc." In the window that opens, find and click on the folder "Task Scheduler Library." In the opened "Task Scheduler Library," find your script by name and view more details.

__Modification after installation__ 

The default path is ```C:\robocopy```, where you can find the ```copy.ps1``` script. Use a text editor such as Notepad, WordPad, or Visual Studio Code to modify it.

## Documentation 
- [Microsoft Robocopy Documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
- [Microsoft PowerShell Documentation](https://learn.microsoft.com/en-us/powershell)