:: Enthaelt aktuell nur den Part zur Pruefung ob Windows curl integriert hat, andernfalls wird die curl.exe aus verzeichnis genutzt
@echo off
setlocal enabledelayedexpansion

set "url=https://tms.local/"
set "system32curl=C:\Windows\System32\curl.exe"
set "tempcurl=C:\temp\curl.exe"

REM Check if curl.exe exists in C:\Windows\System32
if exist "%system32curl%" (
    set "curlpath=%system32curl%"
) else (
    set "curlpath=%tempcurl%"
)

REM Check if the selected curl executable exists
if exist "!curlpath!" (
    echo Using curl from "!curlpath!" for %url%
	"!curlpath!" --version
    	"!curlpath!" %url%
) else (
    echo Curl executable not found in both C:\Windows\System32 and C:\temp
    echo Please install curl or provide a valid path to curl.exe.
)

endlocal