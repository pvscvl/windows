$7ZIP_INSTALLPATH = 'C:\temp\7zip.exe'
$versionFilePath = 'C:\temp\7zip-version.txt'
$7ZIPDLURL = 'https://www.7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.7-zip.org/' |
    Select-Object -ExpandProperty Links |
    Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} |
    Select-Object -First 1 |
    Select-Object -ExpandProperty href)
$7zipVersion = ($7ZIPDLURL -split '/' | Select-Object -Last 1) -replace '.exe', ''
 $currentVersion = Get-Content -Path $versionFilePath
if (Test-Path $versionFilePath) {
    if ($currentVersion -eq $7zipVersion) {
        Write-Host "You already have the latest version of 7zip."
        exit
    }
}

Invoke-WebRequest $7ZIPDLURL -OutFile $7ZIP_INSTALLPATH
$7zipVersion | Out-File -FilePath $versionFilePath
