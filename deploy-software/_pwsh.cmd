@echo off
SETLOCAL
net session >nul 2>&1
if %errorlevel% == 0 goto :SCRIPTEXECUTION
goto :NOTADMIN

:SCRIPTEXECUTION
	IF NOT EXIST C:\temp MKDIR C:\temp
	SET POWERSHELL_INSTALLER_URL_VAR=
	SET FILENAME=

	FOR /F "tokens=* USEBACKQ" %%F IN (`powershell -Command "Invoke-RestMethod -Uri 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest' | Select-Object -ExpandProperty assets | Where-Object { $_.browser_download_url -like '*win-x64.msi' } | Select-Object -ExpandProperty browser_download_url"`) DO (
		SET POWERSHELL_INSTALLER_URL_VAR=%%F
    FOR %%I IN (%%F) DO SET FILENAME=%%~nI%%~xI
	)
	IF "%POWERSHELL_INSTALLER_URL_VAR%"=="" (
		echo Unable to find the PowerShell installer URL.
		goto :END
	)

	echo Downloading PowerShell ( %FILENAME% ) to C:\temp...
	powershell -Command "Invoke-WebRequest -Uri '%POWERSHELL_INSTALLER_URL_VAR%' -OutFile 'C:\temp\%FILENAME%'"
	echo Installing PowerShell...
	msiexec /i C:\temp\%FILENAME% /qn /norestart
	echo Installed Powershell.
	goto :CLEANUP


:NOTADMIN
	echo Requesting administrator privileges...
	set /p adminUser=Enter the DOMAIN\Username of an account with administrator privileges: 
	runas /user:%adminUser% "%0"
	exit /b
	goto :eof

:CLEANUP
	echo Performing cleanup tasks (Placeholder right now)
	REM echo Removing %FILENAME%
	goto :END

:END
	ENDLOCAL
	echo Done.

