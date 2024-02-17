param (
	[string]$Version = "2300820421",
 	[switch]$INSTALL,
	[switch]$VERBOSE,
	[switch]$LOG
)

$ID = "AdobeAcrobatReader"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

	If ($LOG) { Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null }
	If ($VERBOSE) { Write-Time "ID: $ID" /verbose
	If ($VERBOSE) { Write-Time "Version: $Version" /verbose }
$DownloadUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/$Version/AcroRdrDC${Version}_de_DE.exe"
	If ($VERBOSE) { Write-Time "DownloadUrl: $DownloadUrl" /verbose }
$DownloadPath = "C:\temp\AcroRdrDC${Version}_de_DE.exe"
	If ($VERBOSE) { Write-Time "DownloadPath: $DownloadPath" /verbose }
	Write-Time "Downloading Adobe Acrobat Reader (Version: $Version)..."
	If ($VERBOSE) { Write-Time "Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath" /verbose }
Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath
	If ($VERBOSE) { Write-Time "Command 'Invoke-WebRequest' completed " /verbose }
if (Test-Path $DownloadPath) {
		Write-Time "Adobe Acrobat Reader (Version: $Version) downloaded to $DownloadPath" /OK
		If ($VERBOSE) { Write-Time "File exists: $DownloadPath " /verbose }
  		If ($INSTALL) { 
				If ($VERBOSE) { Write-Time "Starting silent install..." /Verbose }
			Start-Process -FilePath $DownloadPath -Args "/sAll /rs /msi EULA_ACCEPT=YES"
				Write-Time "Adobe Acrobat Reader has been installed" /OK
    		}
} else {
	Write-Time "Failed to download Adobe Acrobat Reader." /FAIL
	If ($VERBOSE) { Write-Time "File does not exist: $DownloadPath " /verbose }
}

If ($LOG) { Stop-Transcript | Out-Null }
