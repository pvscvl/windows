$NPPINSTALLED = Test-Path "C:\Program Files\Notepad++\notepad++.exe"

if (!(Test-Path -Path "C:\temp\")) {
	New-Item -ItemType directory -Path "C:\temp\"
}

if (-not $NPPINSTALLED) {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$NPPBASEURI = "https://notepad-plus-plus.org"
	$NPPBASEPAGE = Invoke-WebRequest -Uri $NPPBASEURI -UseBasicParsing
	$NPPCHILDPATH = $NPPBASEPAGE.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href
	$NPPVERSION_PARTS = $NPPCHILDPATH -split '/'
	$NPPVERSION = $NPPVERSION_PARTS | Where-Object { $_ -and $_.StartsWith('v') }
	$NPPDOWNLOADPAGEURI = $NPPBASEURI + $NPPCHILDPATH
	$NPPDOWNLOADPAGE = Invoke-WebRequest -Uri $NPPDOWNLOADPAGEURI -UseBasicParsing
	if ( [System.Environment]::Is64BitOperatingSystem ) {
    		$NPPDLURL = $NPPDOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href -Unique
	} else {
    		$NPPDLURL = $NPPDOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.exe"*' } | Select-Object -ExpandProperty href -Unique
	}
	$NPPFILENAME = $( Split-Path -Path $NPPDLURL -Leaf )
	$NPPINSTALLERPATH = "C:\temp\" + $NPPFILENAME
 	Invoke-WebRequest -Uri $NPPDLURL -OutFile $NPPINSTALLERPATH | Out-Null
	Start-Process -FilePath $NPPINSTALLERPATH -Args "/S" -Verb RunAs -Wait
}
