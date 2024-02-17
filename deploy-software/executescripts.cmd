@echo off
setlocal enabledelayedexpansion

	set "SUBFOLDER=ps1"
	cd %SUBFOLDER%

	for %%i in (*.ps1) do (
		set "SCRIPT=%%i"
		set /p EXECUTE=Execute !SCRIPT!? 
		if /i !EXECUTE! equ y (
			set "SCRIPTS2EXECUTE=!SCRIPTS2EXECUTE! "!SCRIPT!""
		) else (
			timeout /nobreak /t 1 >nul
		)
	)

echo.
echo.
echo.

	if defined SCRIPTS2EXECUTE (
REM   echo Executing selected scripts...
		for %%s in (%SCRIPTS2EXECUTE%) do (
			echo Executing %%s...
			powershell -ExecutionPolicy Bypass -File "%%s"
		REM	pwsh -ExecutionPolicy Bypass -f "%%s"
			echo.
			echo.
			echo.
		)
	) else (
		echo ELSE MSG?
	)

cd ..

echo Done.
pause
echo Exiting.
pause
