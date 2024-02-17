param(
	[switch]$INSTALL,
	[switch]$VERBOSE,
	[switch]$LOG
)

$ID = "WSM"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

If ($LOG) { Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null }
	If ($VERBOSE) { Write-Time "ID: $ID" /verbose }
$WG_URL = "https://software.watchguard.com/SoftwareDownloads?current=true&familyId=a2R6S000000NkiOUAS"
	If ($VERBOSE) { Write-Time "WG_URL: $WG_URL" /verbose }
$WG_CONTENT = Invoke-WebRequest -Uri $WG_URL
	# Parse the page content to find the download link
$WSM_DOWNLOAD = $WG_CONTENT.Links | Where-Object { $_.href -like "*wsm_*.exe" } | Select-Object -ExpandProperty href -First 1
	If ($VERBOSE) { Write-Time "WSM_DOWNLOAD: $WSM_DOWNLOAD" /verbose }
	if ($WSM_DOWNLOAD -ne $null) {
		$WSM_FILENAME = Split-Path -Path $WSM_DOWNLOAD -Leaf
			If ($VERBOSE) { Write-Time "WSM_FILENAME: $WSM_FILENAME" /verbose }
		$WSM_INSTALLER_PATH = "C:\temp\" + $WSM_FILENAME
			If ($VERBOSE) { Write-Time "WSM_INSTALLER_PATH: $WSM_INSTALLER_PATH" /verbose }
    
    			Write-Time "Watchguard System Manager downloading to $WSM_INSTALLER_PATH" 
		Invoke-WebRequest -Uri $WSM_DOWNLOAD  -OutFile $WSM_INSTALLER_PATH
  			Write-Time "Watchguard System Manager downloaded to $WSM_INSTALLER_PATH" /OK
		If ($INSTALL) {
   				Write-Time "Starting Install Routine..."
        		Start-Process -FilePath $WSM_INSTALLER_PATH -Wait
        			Write-Time "Watchguard System Manager has been installed." /OK
	        		If ($VERBOSE) { Write-Time "Removing WSM Installer" /verbose }
       	 		Remove-Item $WSM_INSTALLER_PATH
				If ($VERBOSE) { Write-Time "$WSM_INSTALLER_PATH removed" /verbose }
		}
        	If ($VERBOSE) { Write-Time "Script complete" /verbose }
	} else {
		Write-Time "Watchguard System Manager Downloadlink not found" /ERROR
 	 	Write-Time "Script execution failed." /ERROR
	}

If ($LOG) { Stop-Transcript | Out-Null }

