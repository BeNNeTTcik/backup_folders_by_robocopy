# Automated copying of files between two drives twice an hour by Robocopy.exe

The script ‘copy.ps1’ allows you to copy a selected folder/disk and save a copy of the files on the target path.

Open the downloaded script and change variables such as source and destination folders, intervals (I use 30 minutes), select the log_robocopy path (I use the C drive to avoid accidental deletion by robocopy). The last variable is the copy parameters. If you want to modify the parameters, use this link to [Microsoft Documentation Robocopy](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy).

## Installation

Search -> PowerShell -> Right-Click -> Run as Administrator -> Paste the following command into the terminal
```
C:\Users\{}\Downloads\
```

Windows + R -> taskschd.msc