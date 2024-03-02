$LOGFOLDER = "C:\Logs"
$TEMPFOLDER = "C:\temp"
if (-not (Test-Path -Path $LOGFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $LOGFOLDER | Out-Null
}
if (-not (Test-Path -Path $TEMPFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $TEMPFOLDER | Out-Null


$ADOBE32INSTALLED = Test-Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
$ADOBE64INSTALLED = Test-Path "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd64.exe"

if (-not ($ADOBE32INSTALLED -or $ADOBE64INSTALLED)) {
	$INSTALLERPATH = "\\tkm-sv-fs01.tkm.local\ " 
	Start-Process -FilePath $INSTALLERPATH -Args "/sAll /rs /msi EULA_ACCEPT=YES"
}