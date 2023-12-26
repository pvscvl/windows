$sourcePath = "Q:\"
$backupFileNamePattern = "FirefoxProfile_*.zip"
$tempPath = "C:\temp"
$firefoxProfilePath = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"

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

$latestBackup = Get-ChildItem -Path $sourcePath -Filter $backupFileNamePattern | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestBackup -ne $null) {

    $tempFilePath = Join-Path $tempPath $latestBackup.Name
    Copy-Item -Path $latestBackup.FullName -Destination $tempFilePath -Force

    $firefoxProfiles = Get-ChildItem -Path $firefoxProfilePath -Directory

    $latestProfile = $firefoxProfiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if ($latestProfile -ne $null) {
        $profileFolderPath = $latestProfile.FullName

        Expand-Archive -Path $tempFilePath  -DestinationPath $profileFolderPath -Force | Out-Null

        Remove-Item -Path $tempFilePath -Force

        Write-Host "Firefox profile imported from backup."

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
    } else {
        Write-Host "No Firefox profile found in the specified directory."
    }
} else {
    Write-Host "No Firefox profile backup found in the specified path."
}
