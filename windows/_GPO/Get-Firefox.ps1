	$DOWNLOAD_URL = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de"
	$URL = "https://product-details.mozilla.org/1.0/firefox_versions.json"
	$JSON_DATA = Invoke-RestMethod -Uri $URL
	$LATEST_VERSION = $JSON_DATA.LATEST_FIREFOX_VERSION
	$FILE_NAME = "C:\temp\Firefox.exe"
	$VERSION_FILE_NAME = "C:\temp\Firefox_ver.txt"
	$CURRENTVERSION = Get-Content -Path $VERSION_FILE_NAME
	if (Test-Path $VERSION_FILE_NAME) {
    		if ($CURRENTVERSION -eq $LATEST_VERSION) {
        Write-Host "You already have the latest version of Firefox."
        exit
    }
}
	$WEB_CLIENT = New-Object System.Net.WebClient
	$WEB_CLIENT.DownloadFile($DOWNLOAD_URL, $FILE_NAME)
	$LATEST_VERSION  | Set-Content -Path $VERSION_FILE_NAME
