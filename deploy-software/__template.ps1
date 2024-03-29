param(
	[switch]$INSTALL,
	[switch]$VERBOSE,
	[switch]$LOG
)

$ID = "__TEMPLATE__"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"

. .\__functions.ps1

If ($LOG) { Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null }
	If ($VERBOSE) { Write-Time "ID: $ID" /verbose }

###########################################################################################################################
################################################## SCRIPT PART ############################################################
###########################################################################################################################

	If ($VERBOSE) {  }
	If ($LOG) { }
	If ($INSTALL {  }

###########################################################################################################################
################################################## SCRIPT PART ############################################################
###########################################################################################################################


If ($LOG) {Stop-Transcript | Out-Null }
