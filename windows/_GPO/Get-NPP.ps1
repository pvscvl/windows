	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$NPPBASEURI = "https://notepad-plus-plus.org"
	$NPP_VERSION_FILE = "C:\temp\npp.installer.x64_ver.txt"
	$NPPBASEPAGE = Invoke-WebRequest -Uri $NPPBASEURI -UseBasicParsing
	$NPPCHILDPATH = $NPPBASEPAGE.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href
	$NPPVERSION_PARTS = $NPPCHILDPATH -split '/'
	$NPPVERSION = $NPPVERSION_PARTS | Where-Object { $_ -and $_.StartsWith('v') }
	$NPPDOWNLOADPAGEURI = $NPPBASEURI + $NPPCHILDPATH
	$NPPDOWNLOADPAGE = Invoke-WebRequest -Uri $NPPDOWNLOADPAGEURI -UseBasicParsing
	$NPPDLURL = $NPPDOWNLOADPAGE.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href -Unique
	#$NPPFILENAME = $( Split-Path -Path $NPPDLURL -Leaf )
	$NPPFILENAME = "npp.installer.x64.exe"
	$NPPINSTALLERPATH = "C:\temp\" + $NPPFILENAME
	$NPPCURRENTVERSION = Get-Content -Path $NPP_VERSION_FILE 
	if ($CURRENTVERSION -eq $NPPVERSION) {
        		exit
   	 	}
 	Invoke-WebRequest -Uri $NPPDLURL -OutFile $NPPINSTALLERPATH | Out-Null
	$NPPVERSION  | Set-Content -Path $NPP_VERSION_FILE 


