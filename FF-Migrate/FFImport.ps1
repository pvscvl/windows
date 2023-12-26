# Define source and destination paths
$sourcePath = "Q:\"
$backupFileNamePattern = "FirefoxProfile_*.zip"
$destinationPath = "C:\temp"  # Specify the destination folder
$firefoxProfilePath = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"

# Close Firefox gracefully if it's running
$firefoxProcesses = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefoxProcesses) {
    foreach ($process in $firefoxProcesses) {
        $process.CloseMainWindow() | Out-Null
        $process.WaitForExit(10) | Out-Null
        if (!$process.HasExited) {
            $process | Stop-Process -Force | Out-Null
        }
    }
}

# Find the most recent backup file matching the pattern
$latestBackup = Get-ChildItem -Path $sourcePath -Filter $backupFileNamePattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestBackup -ne $null) {
    # Copy the backup file to the destination folder
    $destinationFilePath = Join-Path $destinationPath $latestBackup.Name
    Copy-Item -Path $latestBackup.FullName -Destination $destinationFilePath -Force

    # Get the list of profiles in the Firefox directory
    $firefoxProfiles = Get-ChildItem -Path $firefoxProfilePath -Directory

    # Find the most recent profile based on LastWriteTime
    $latestProfile = $firefoxProfiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($latestProfile -ne $null) {
        $profileFolderPath = $latestProfile.FullName

        # Extract the contents of the backup zip file from the destination folder
        Expand-Archive -Path $destinationFilePath -DestinationPath $profileFolderPath -Force | Out-Null

        # Remove the .zip file from C:\temp
        Remove-Item -Path $destinationFilePath -Force

        # Optional: Display a message to the user
        Write-Host "Firefox profile imported from backup."

        # Check if 64-bit Firefox exists and start it if found
        $firefox64Path = "C:\Program Files\Mozilla Firefox\firefox.exe"
        if (Test-Path $firefox64Path) {
            Start-Process -FilePath $firefox64Path | Out-Null
        } else {
            # If 64-bit version doesn't exist, check for 32-bit version and start it
            $firefox32Path = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
            if (Test-Path $firefox32Path) {
                Start-Process -FilePath $firefox32Path | Out-Null
            } else {
                Write-Host "Firefox not found in the expected locations."
            }
        }
    } else {
        Write-Host "No Firefox profile found in the specified directory."
    }
} else {
    Write-Host "No Firefox profile backup found in the specified path."
}
