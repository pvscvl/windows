$FFINSTALLED = Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe"

if (!(Test-Path -Path "C:\temp\")) {
	New-Item -ItemType directory -Path "C:\temp\"
}

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