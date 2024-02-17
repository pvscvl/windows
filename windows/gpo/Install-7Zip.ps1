$7ZIPINSTALLED = Test-Path 'C:\Program Files\7-Zip\7z.exe'
if (-not $7ZIPINSTALLED) {
	$7ZIPDLURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' |
	Select-Object -ExpandProperty Links |
        Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} |
        Select-Object -First 1 |
        Select-Object -ExpandProperty href)
	$7ZIPINSTALLPATH = Join-Path 'C:\temp' (Split-Path $7ZIPDLURL -Leaf)
        Invoke-WebRequest $7ZIPDLURL -OutFile $7ZIPINSTALLPATH
        Start-Process -FilePath $7ZIPINSTALLPATH -Args "/S" -Wait
}