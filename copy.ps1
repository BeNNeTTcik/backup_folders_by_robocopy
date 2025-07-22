# PowerShell script to copy files from one directory to another using Robocopy
# This script is designed to be run when two specific drives are connected
# Program consists of two parts:
# 1. Copy files using Robocopy
# 2. Register a scheduled task to run the script periodically
# Usage:
# - To run the script immediately: '.\copy.ps1 -Mode run'
# - To register the script as a scheduled task: '.\copy.ps1 -Mode install'
# - To remove logs older than 30 days: '.\copy.ps1 -Mode logs'
# All operations can be run from the command line or PowerShell console. 
# In use the script will run silently in the background.

# Deafult parameter is "run", which means the script will copy files immediately.
param (
    [string]$Mode = "run"
)

# --------- VARIABLES ---------

# Set the task name and interval for the scheduled task
$taskName = "CopyFilesUsingRobocopy"
$intervalMinutes = 30

# Define source, destination, and logs paths
$srcLabel = "D:\test"                           #path to source
$dstLabel = "E:\test"                           #patch to destination / pozniej zmienic na Samsung2
$targetFolderScript = "C:\robocopy"             #path to the script
$targetNameScript = "copy.ps1"                  #name of the script
$logsLabel = "C:\logs_robocopy"                 #path to logs
$copyparams = "/E /XO /FFT /Z /R:3 /W:5 /PURGE" #change copy parameters as needed, the list of all parameters can be found here: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
#silent launch vb script

# ------------ FUNCTIONS ------------
# Synhronize files between two drives using Robocopy
function Copy-ByRobocopy {
    if((Test-Path $srcLabel) -and (Test-Path $dstLabel)) {
        $logFile = $logsLabel+"\log_" + (Get-Date -Format "yyyyMMdd") + ".txt"      

        # Arguments for Robocopy
        $arglist = @(
        $srcLabel
        $dstLabel
        $copyparams
        "/LOG+:$logFile"
        )

        # Start the Robocopy process, which will copy files from source to destination
        $p = Start-Process -FilePath "robocopy.exe" -ArgumentList $arglist -WindowStyle Hidden -PassThru
        $p.WaitForExit()
    }
}

function Remove-Logs {
    # Remove logs older than 30 days
    $name = (Get-Date).AddDays(-30).ToString("yyyyMMdd")

    # Find logs older than 30 days in the logs directory
    $filename = Get-ChildItem -Path $logsLabel -Filter "log_*.txt" | Where-Object { 
        if ($_ -match "log_(\d{8})"){
            $fileDate = $matches[1]
            return [int]$fileDate -lt [int]$name
           
        }
        return $false
    }

    # Remove the found log files
    foreach ($file in $filename) {
        Remove-Item $file.FullName -Force
    }
    Write-Host "Removed: $($filename.FullName)"
}

# Regisrter the scheduled task to run the script
function Register-Task {

    # ------- Robocopy task registration -------
    $scriptPath = $PSCommandPath

    # Check the folder where the script will be copied. If it does not exist, create it
    if(-not (Test-Path $targetFolderScript)) {
        New-Item -Path $targetFolderScript -ItemType Directory -Force | Out-Null
        Write-Host "Created folder $targetFolderScript"
    }

    # Create logs directory if it does not exist
    if((Test-Path $logsLabel) -eq $false) {
        New-Item -Path $logsLabel -ItemType Directory | Out-Null
        Write-Host "Created folder $logsLabel"
    }

    # Copy the script to the target folder
    Copy-Item -Path $scriptPath -Destination $targetFolderScript -Force
    Write-Host "Script copied to $targetFolderScript"

    # Prepare the VBScript to run the PowerShell script silently
    $target = $targetFolderScript + "\" + $targetNameScript
    $vbsPath = $targetFolderScript+ "\"+ "silent-launch.vbs"
    $content = @"
    Set shell = CreateObject("WScript.Shell")
    shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""$target"" -Mode run", 0, True
    shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""$target"" -Mode logs", 0, False
"@
    Set-Content -Path $vbsPath -Value $content -Encoding ASCII
    Write-Host "Created VBScript to run PowerShell script silently at $vbsPath"

    # Register the scheduled task. The task will run the VBScript every $intervalMinutes minutes
    $scriptPathRegister = $targetFolderScript + "\silent-launch.vbs"
    $action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$scriptPathRegister`""
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date.AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes $intervalMinutes) 
    Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -RunLevel Highest -Force
}

# Switch case to handle different modes:
# "run" will execute the copy operation immediately
# "install" will set up the scheduled task
# "logs" will remove old logs
switch ($Mode.ToLower()) {
    "run" { Copy-ByRobocopy }
    "install" { Register-Task }
    "logs" { Remove-Logs }
    default { Write-Host "Choose 'run' - run script or 'install' - first time use script or 'logs' - clear the oldest logs files." }
}
