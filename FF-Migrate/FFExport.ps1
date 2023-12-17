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

# Define source and destination paths
$userProfilePath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$firefoxProfilesPath = Join-Path $userProfilePath "AppData\Roaming\Mozilla\Firefox\Profiles"
$backupPath = "Q:\"

if (-Not (Test-Path -Path $backupPath -PathType Container)) {
    New-Item -Path $backupPath -ItemType Directory -Force
}

# Find the most recent profile
$latestProfile = Get-ChildItem $firefoxProfilesPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestProfile -ne $null) {
    $latestProfilePath = $latestProfile.FullName

    # Change the current directory to the most recent profile folder
    Set-Location -Path $latestProfilePath

    # Create a backup file name based on the profile name and current date
    $backupFileName = "FirefoxProfile_$($latestProfile.Name)_$(Get-Date -Format 'yyyyMMdd').zip"
    $backupFilePath = Join-Path $backupPath $backupFileName

    # Compress everything within the profile folder, including the folder structure
    Compress-Archive -Path .\* -DestinationPath $backupFilePath -Force
} else {
    Write-Host "No Firefox profile found in the specified path."
}

# Part 2: Start Firefox (both 32-bit and 64-bit versions)

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

# Optional: Display a message to the user
Write-Host "Firefox profile backup complete. Firefox has been restarted."
