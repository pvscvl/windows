#	$ADOBEVERSION = "2300820470"
	$ADOBEVERSION = "2300820555"
	$ADOBE_VERSION_FILE = "AcroRdrDC_de_DE_ver.txt"
	$ADOBEDLURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/$ADOBEVERSION/AcroRdrDC${ADOBEVERSION}_de_DE.exe"
#	$ADOBEDLPATH = "C:\temp\AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	$ADOBEDLPATH = "C:\temp\AcroRdrDC_de_DE.exe"
	Invoke-WebRequest -Uri $ADOBEDLURL -OutFile $ADOBEDLPATH
		$ADOBEVERSION  | Set-Content -Path $ADOBE_VERSION_FILE