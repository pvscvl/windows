$LOGFOLDER = "C:\Logs"
$TEMPFOLDER = "C:\temp"
if (-not (Test-Path -Path $LOGFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $LOGFOLDER | Out-Null
}
if (-not (Test-Path -Path $TEMPFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $TEMPFOLDER | Out-Null
}

	$NPPINSTALLED = Test-Path "C:\Program Files\Notepad++\notepad++.exe"
	if (-not $NPPINSTALLED) {
		$INSTALLERPATH = "\\tkm-sv-fs01.tkm.local\ " 
		Start-Process -FilePath $INSTALLERPATH -Args "/S" -Verb RunAs -Wait
	}