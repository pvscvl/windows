$ID = "NotepadPlusPlus"
$LOGTIME = Get-Date -Format "yyyyMMdd-HHmm"
$LOGFILE = "${ID}_${LOGTIME}.log"


. .\__functions.ps1


Start-Transcript -path C:\temp\logs\$LOGFILE | Out-Null
		Write-Time "Value of ID: $ID" /verbose
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$BASEURI = "https://notepad-plus-plus.org"
		Write-Time "Value of BASEURI: $BASEURI" /verbose
	$BASEPAGE = Invoke-WebRequest -Uri $BASEURI -UseBasicParsing
	$CHILDPATH = $BASEPAGE.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href
		Write-Time "Value of CHILDPATH: $CHILDPATH" /verbose
	$VERSION_PARTS = $CHILDPATH -split '/'
	$VERSION = $VERSION_PARTS | Where-Object { $_ -and $_.StartsWith('v') }
		Write-Time "Value of VERSION: $VERSION" /verbose
	$DOWNLOADPAGEURI = $BASEURI + $CHILDPATH
		Write-Time "Value of DOWNLOADPAGEURI: $DOWNLOADPAGEURI" /verbose
	$DOWNLOADPAGE = Invoke-WebRequest -Uri $DOWNLOADPAGEURI -UseBasicParsing
 
	if ( [System.Environment]::Is64BitOperatingSystem ) {
    		$DownloadUrl = $DOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href -Unique
	} else {
    		$DownloadUrl = $DOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.exe"*' } | Select-Object -ExpandProperty href -Unique
	}
 
	$NPPFILENAME = $( Split-Path -Path $DownloadUrl -Leaf )
 		Write-Time "Value of NPPFILENAME: $NPPFILENAME" /verbose
	$NPPINSTALLERPATH = "C:\temp\" + $NPPFILENAME
 		Write-Time "Value of NPPINSTALLERPATH: $NPPINSTALLERPATH" /verbose
	Write-Time "Downloading Notepad++ $VERSION"
 	Invoke-WebRequest -Uri $DownloadUrl -OutFile $NPPINSTALLERPATH | Out-Null
	Write-Time "Notepad++ $VERSION downloaded to $NPPINSTALLERPATH" /OK 

	Write-Time "Starting silent install of Notepad++ $VERSION" 
	Start-Process -FilePath $NPPINSTALLERPATH -Args "/S" -Verb RunAs -Wait
	Write-Time "Notepad++ $VERSION installed" /OK

		Write-Time "Deleting Installer" /Verbose
	Remove-Item $NPPINSTALLERPATH
		Write-Time "Installer deleted" /verbose

Stop-Transcript | Out-Null
