$LOGFOLDER = "C:\Logs"
$TEMPFOLDER = "C:\temp"
if (-not (Test-Path -Path $LOGFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $LOGFOLDER | Out-Null
}
if (-not (Test-Path -Path $TEMPFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $TEMPFOLDER | Out-Null
}

$7ZIPINSTALLED = Test-Path 'C:\Program Files\7-Zip\7z.exe'

if (-not $7ZIPINSTALLED) {
	$INSTALLERPATH = "\\tkm-sv-fs01.tkm.local" 
	Start-Process -FilePath $INSTALLERPATH  -Args "/S" -Wait
}