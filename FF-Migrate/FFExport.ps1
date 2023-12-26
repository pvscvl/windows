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

$userProfilePath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$firefoxProfilesPath = Join-Path $userProfilePath "AppData\Roaming\Mozilla\Firefox\Profiles"
$tempFolderPath = "C:\temp"
$backupPath = "Q:\"

if (-Not (Test-Path -Path $backupPath -PathType Container)) {
    New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
}

if (-Not (Test-Path -Path $tempFolderPath -PathType Container)) {
    New-Item -Path $tempFolderPath -ItemType Directory -Force | Out-Null
}

$latestProfile = Get-ChildItem $firefoxProfilesPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestProfile -ne $null) {
    $latestProfilePath = $latestProfile.FullName 

    Set-Location -Path $latestProfilePath | Out-Null

    $backupFileName = "FirefoxProfile_$($latestProfile.Name)_$(Get-Date -Format 'yyyyMMdd').zip"
    $backupFilePath = Join-Path $tempFolderPath $backupFileName

    & "C:\Program Files\7-Zip\7z.exe" a -tzip -mx0 $backupFilePath .\* | Out-Null

    Copy-Item -Path $backupFilePath -Destination $backupPath -Force
    Remove-Item -Path $backupFilePath -Force

    Set-Location -Path $userProfilePath | Out-Null
} else {
    Write-Host "No Firefox profile found in the specified path."
}


$firefox64Path = "C:\Program Files\Mozilla Firefox\firefox.exe"
if (Test-Path $firefox64Path) {
    Start-Process -FilePath $firefox64Path | Out-Null
} else {
    $firefox32Path = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
    if (Test-Path $firefox32Path) {
        Start-Process -FilePath $firefox32Path | Out-Null
    } else {
        Write-Host "Firefox not found in the expected locations."
    }
}

Write-Host "Firefox profile backup complete. Firefox has been restarted."
