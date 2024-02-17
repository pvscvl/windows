param(
	[switch]$INSTALL,
	[switch]$VERBOSE,
	[switch]$LOG
)

$ID = "Firefox"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

If ($LOG) { Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null }

	If ($VERBOSE) { Write-Time "ID: $ID" /verbose }
$DOWNLOAD_URL = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de"
	If ($VERBOSE) { Write-Time "DOWNLOAD_URL: $DOWNLOAD_URL" /verbose }
$URL = "https://product-details.mozilla.org/1.0/firefox_versions.json"
	If ($VERBOSE) { Write-Time "URL: $URL" /verbose }
$JSON_DATA = Invoke-RestMethod -Uri $URL
$LATEST_VERSION = $JSON_DATA.LATEST_FIREFOX_VERSION
	If ($VERBOSE) { Write-Time "LATEST_VERSION: $LATEST_VERSION" /verbose }
$FILE_NAME = "C:\temp\Firefox_$LATEST_VERSION.exe"
	If ($VERBOSE) { Write-Time "FILE_NAME: $FILE_NAME" /verbose}
	$WEB_CLIENT = New-Object System.Net.WebClient
	If ($VERBOSE) { Write-Time "WEB_CLIENT: $WEB_CLIENT" /verbose }
	Write-Time "Firefox DE x64 version $LATEST_VERSION downloading..."
$WEB_CLIENT.DownloadFile($DOWNLOAD_URL, $FILE_NAME)
	Write-Time "Firefox DE x64 version $LATEST_VERSION downloaded to: $FILE_NAME"

	If ($INSTALL) {
			Write-Time "Starting silent install of Firefox"
		Start-Process -FilePath $FILE_NAME -Args "/silent" -Verb RunAs -Wait
			Write-Time "Installed Firefox $LATEST_VERSION" /OK
	}

	If ($LOG) { Stop-Transcript | Out-Null }
