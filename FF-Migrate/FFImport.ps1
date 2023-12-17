# Define source and destination paths
$sourcePath = "Q:\"
$backupFileNamePattern = "FirefoxProfile_*.zip"
$firefoxProfilePath = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"

# Close Firefox gracefully if it's running
$firefoxProcesses = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefoxProcesses) {
    foreach ($process in $firefoxProcesses) {
        $process.CloseMainWindow()
        $process.WaitForExit(10)
        if (!$process.HasExited) {
            $process | Stop-Process -Force
        }
    }
}

# Find the most recent backup file matching the pattern
$latestBackup = Get-ChildItem -Path $sourcePath -Filter $backupFileNamePattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$latestProfile = Get-ChildItem -Path $firefoxProfilePath -Filter $backupFileNamePattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestBackup -ne $null) {
    $profileFilePath = $latestProfile.FullName
    $backupFilePath = $latestBackup.FullName


    # Extract the contents of the backup zip file
    Expand-Archive -Path $backupFilePath -DestinationPath $firefoxProfilePath -Force
    #Expand-Archive -Path $profileFilePath -DestinationPath $firefoxProfilePath -Force

    # Optional: Display a message to the user
    Write-Host "Firefox profile imported from backup."

    # Check if 64-bit Firefox exists and start it if found
    $firefox64Path = "C:\Program Files\Mozilla Firefox\firefox.exe"
    if (Test-Path $firefox64Path) {
        Start-Process -FilePath $firefox64Path
    } else {
        # If 64-bit version doesn't exist, check for 32-bit version and start it
        $firefox32Path = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
        if (Test-Path $firefox32Path) {
            Start-Process -FilePath $firefox32Path
        } else {
            Write-Host "Firefox not found in the expected locations."
        }
    }
} else {
    Write-Host "No Firefox profile backup found in the specified path."
}
