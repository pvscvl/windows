$FFINSTALLED = Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe"
if (-not $FFINSTALLED) {
	$DOWNLOAD_URL = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de"
	$URL = "https://product-details.mozilla.org/1.0/firefox_versions.json"
	$JSON_DATA = Invoke-RestMethod -Uri $URL
	$LATEST_VERSION = $JSON_DATA.LATEST_FIREFOX_VERSION
	$FILE_NAME = "C:\temp\Firefox_Setup.exe"
	$WEB_CLIENT = New-Object System.Net.WebClient
	$WEB_CLIENT.DownloadFile($DOWNLOAD_URL, $FILE_NAME)
	Start-Process -FilePath $FILE_NAME -Args "/silent" -Verb RunAs -Wait
}


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


$NPPINSTALLED = Test-Path "C:\Program Files\Notepad++\notepad++.exe"
if (-not $NPPINSTALLED) {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$NPPBASEURI = "https://notepad-plus-plus.org"
	$NPPBASEPAGE = Invoke-WebRequest -Uri $NPPBASEURI -UseBasicParsing
	$NPPCHILDPATH = $NPPBASEPAGE.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href
	$NPPVERSION_PARTS = $NPPCHILDPATH -split '/'
	$NPPVERSION = $NPPVERSION_PARTS | Where-Object { $_ -and $_.StartsWith('v') }
	$NPPDOWNLOADPAGEURI = $NPPBASEURI + $NPPCHILDPATH
	$NPPDOWNLOADPAGE = Invoke-WebRequest -Uri $NPPDOWNLOADPAGEURI -UseBasicParsing
	if ( [System.Environment]::Is64BitOperatingSystem ) {
    		$NPPDLURL = $NPPDOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href -Unique
	} else {
    		$NPPDLURL = $NPPDOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.exe"*' } | Select-Object -ExpandProperty href -Unique
	}
	$NPPFILENAME = $( Split-Path -Path $NPPDLURL -Leaf )
	$NPPINSTALLERPATH = "C:\temp\" + $NPPFILENAME
 	Invoke-WebRequest -Uri $NPPDLURL -OutFile $NPPINSTALLERPATH | Out-Null
	Start-Process -FilePath $NPPINSTALLERPATH -Args "/S" -Verb RunAs -Wait
}


$ADOBE32INSTALLED = Test-Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
$ADOBE64INSTALLED = Test-Path "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd64.exe"
if (-not ($ADOBE32INSTALLED -or $ADOBE64INSTALLED)) {
	$ADOBEVERSION = "2300820470"
	$ADOBEDLURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/$ADOBEVERSION/AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	$ADOBEDLPATH = "C:\temp\AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	Invoke-WebRequest -Uri $ADOBEDLURL -OutFile $ADOBEDLPATH
	Start-Process -FilePath $ADOBEDLPATH -Args "/sAll /rs /msi EULA_ACCEPT=YES"
}



