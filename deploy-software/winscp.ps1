$ID = "WinSCP"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null
		Write-Time "Value of ID: $ID" /verbose
  
	$WINSCP_TAGS_URL = "https://api.github.com/repos/winscp/winscp/tags"
		Write-Time "Value of WINSCP_TAGS_URL: $WINSCP_TAGS_URL" /verbose
	$WINSCP_TAGS = Invoke-RestMethod -Uri $WINSCP_TAGS_URL
	$LATEST_STABLE_WINSCP_TAG = $WINSCP_TAGS | Where-Object { $_.name -notlike '*beta*' } | Select-Object -First 1
	$LATEST_WINSCP_VERSION = $LATEST_STABLE_WINSCP_TAG.name
		Write-Time "Value of LATEST_WINSCP_VERSION: $LATEST_WINSCP_VERSION" /verbose
	$FILENAME = "WinSCP-" + $LATEST_WINSCP_VERSION + "-Setup.exe"
 		Write-Time "Value of FILENAME: $FILENAME" /verbose
	$DLPATH = "C:\temp\" + $FILENAME
 		Write-Time "Value of DLPATH: $DLPATH" /verbose

	$SOURCEFORGE_URL = "https://sourceforge.net/projects/winscp/files/latest/download"
 		Write-Time "Value of SOURCEFORGE_URL: $SOURCEFORGE_URL" /verbose
   		Write-Time "Downloading $ID $LATEST_WINSCP_VERSION ..." /Verbose
	Invoke-WebRequest -UserAgent "Wget" -Uri https://sourceforge.net/projects/winscp/files/latest/download -OutFile $DLPATH 
		Write-Time "Downloaded WinSCP $LATEST_WINSCP_VERSION Installer to $DLPATH" /OK 
		Write-Time "Starting silent install" /verbose
	Start-Process -FilePath $DLPATH -Args "/SP /VERYSILENT /NORESTART" -Verb RunAs -Wait
		Write-Time "WinSCP $LATEST_WINSCP_VERSION installed" /OK 
		Write-Time "Cleanup: Removing installer" /Verbose
	Remove-Item -Path $DLPATH
		Write-Time "$DLPATH removed" /Verbose

Stop-Transcript | Out-Null
