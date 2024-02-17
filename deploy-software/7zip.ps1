param(
	[switch]$INSTALL,
	[switch]$VERBOSE,
	[switch]$LOG
)

$ID = "7zip"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

If ($LOG) { Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null }
If ($VERBOSE) { Write-Time "ID: $ID" /verbose } 
$7ZipExePath = 'C:\Program Files\7-Zip\7z.exe'
	if (Test-Path -Path $7ZipExePath) {
        	Write-Time "7-Zip is already installed in $7ZipExePath" /OK
	} else {
		$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | 
        	Select-Object -ExpandProperty Links | 
        	Where-Object {($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | 
        	Select-Object -First 1 | 
        	Select-Object -ExpandProperty href)
        		If ($VERBOSE) { Write-Time "dlurl: $dlurl" /verbose }
		$installerPath = Join-Path 'C:\temp' (Split-Path $dlurl -Leaf)
        		If ($VERBOSE) { Write-Time "Value of installerPath: $installerPath " /verbose  }
        		Write-Time "Downloading 7zip."
        	Invoke-WebRequest $dlurl -OutFile $installerPath
        		Write-Time "Downloaded 7zip to: $installerPath" /OK
        	If ($INSTALL) { 
        			Write-Time "Starting silent install of 7zip"
        		Start-Process -FilePath $installerPath -Args "/S" -Wait
        			Write-Time "7zip has been installed." /OK
        			If ($VERBOSE) { Write-Time "Removing 7zip Installer" /verbose }
        		Remove-Item $installerPath
        			If ($VERBOSE) { Write-Time "$installerPath removed" /verbose }
        			If ($VERBOSE) { Write-Time "Script complete" /verbose }
	  		}
    }
    
If ($LOG) { Stop-Transcript }
