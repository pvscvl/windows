$PREPPATH = "C:\prep\"

 $FF = Join-Path -path $PREP -childpath firefox.exe
if (!(Test-Path -Path $PREPPATH)) {
	New-Item -ItemType directory -Path $PREPPATH
}

	$DOWNLOAD_URL = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de"
	$URL = "https://product-details.mozilla.org/1.0/firefox_versions.json"
	$JSON_DATA = Invoke-RestMethod -Uri $URL
	$LATEST_VERSION = $JSON_DATA.LATEST_FIREFOX_VERSION
	$FILE_NAME = Join-Path -path $PREPPATH -childpath firefox_Setup.exe
	$WEB_CLIENT = New-Object System.Net.WebClient
	$WEB_CLIENT.DownloadFile($DOWNLOAD_URL, $FILE_NAME)


	$7ZIPDLURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' |
	Select-Object -ExpandProperty Links |
        Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} |
        Select-Object -First 1 |
        Select-Object -ExpandProperty href)
	$7ZIPINSTALLPATH = Join-Path -path $PREPPATH -childpath 7zip_setup.exe
        Invoke-WebRequest $7ZIPDLURL -OutFile $7ZIPINSTALLPATH


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
	$NPPINSTALLERPATH = Join-Path -path $PREPPATH -childpath npp_setup.exe
 	Invoke-WebRequest -Uri $NPPDLURL -OutFile $NPPINSTALLERPATH | Out-Null

	$ADOBEVERSION = "2300820470"
	$ADOBEDLURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/$ADOBEVERSION/AcroRdrDC${ADOBEVERSION}_de_DE.exe"
	$ADOBEDLPATH = Join-Path -path $PREPPATH -childpath AcroRdrDC_DE_setup.exe
	Invoke-WebRequest -Uri $ADOBEDLURL -OutFile $ADOBEDLPATH




