$ADOBE32INSTALLED = Test-Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
$ADOBE64INSTALLED = Test-Path "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd64.exe"
if (-not ($ADOBE32INSTALLED -or $ADOBE64INSTALLED)) {
	$ADOBEVERSION = "2300820470"
	$ADOBEDLURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/$ADOBEVERSION/AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	$ADOBEDLPATH = "C:\temp\AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	Invoke-WebRequest -Uri $ADOBEDLURL -OutFile $ADOBEDLPATH
	Start-Process -FilePath $ADOBEDLPATH -Args "/sAll /rs /msi EULA_ACCEPT=YES"
}



