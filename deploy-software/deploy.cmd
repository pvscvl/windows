@echo off
net session >nul 2>&1
if %errorlevel% == 0 goto :runScript
goto :notAdmin

:runScript
	echo executing wsm.ps1
	pwsh -ExecutionPolicy Bypass -f .\wsm.ps1

	pause

	pause

	echo executing 7zip.ps1
	pwsh -ExecutionPolicy Bypass -f .\7zip.ps1

	echo executing firefox.ps1
	pwsh -ExecutionPolicy Bypass -f .\firefox.ps1

	echo executing adobe.ps1
	pwsh -ExecutionPolicy Bypass -f .\adobe.ps1

	echo executing npp.ps1
	pwsh -ExecutionPolicy Bypass -f .\npp.ps1

	echo executing winscp.ps1
	pwsh -ExecutionPolicy Bypass -f .\winscp.ps1

	goto :End

:depScriptParts
	echo This script is running with administrator privileges.
	echo executing 7zip.ps1
	powershell -ExecutionPolicy Bypass -f .\ps\7zip.ps1
	echo executing firefox.ps1
	powershell -ExecutionPolicy Bypass -f .\ps\firefox.ps1
	echo executing adobe.ps1
	powershell -ExecutionPolicy Bypass -f .\ps\adobe.ps1
	goto :End

:notAdmin
	echo Requesting administrator privileges...
	set /p adminUser=Enter the DOMAIN\Username of an account with administrator privileges: 
	runas /user:%adminUser% "%0"
	exit /b
	goto :End

:End
	echo Done.
