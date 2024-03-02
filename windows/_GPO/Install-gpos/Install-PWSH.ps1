$LOGFOLDER = "C:\Logs"
$TEMPFOLDER = "C:\temp"
$TIMESTAMP = Get-Date
$TIMESTAMP = $TIMESTAMP.ToString("yyyy-MM-dd HHmmss")
$PWSHINSTALLER = "\\tkm-sv-fs01.tkm.local\temp\" 

$PWSHINSTALLED = Test-Path "C:\Program Files\PowerShell\7\pwsh.exe"

if (-not (Test-Path -Path $LOGFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $LOGFOLDER | Out-Null
}
if (-not (Test-Path -Path $TEMPFOLDER -PathType Container)) {
    New-Item -ItemType Directory -Path $TEMPFOLDER | Out-Null
}

if (-not $PWSHINSTALLED) {
	#msiexec /i $PWSHINSTALLER /L*V "C:\Logs\$TIMESTAMP PWSH.log"
	Start-Process $PWSHINSTALLER -ArgumentList "/quiet /passive ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1"
}

