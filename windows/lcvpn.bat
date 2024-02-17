@echo off
setlocal

:: Define paths and filenames
set "installer=LANCOM_VPN_Client_6_Setup.exe"
set "profile_ini=vpn_profile.ini"
set "license_key=YOUR_LICENSE_KEY_HERE"

:: Check if the installer exists
if not exist "%installer%" (
    echo Error: LANCOM Advanced VPN Client installer not found.
    pause
    exit /b 1
)

:: Install LANCOM VPN Client silently
echo InstallingLANCOM Advanced VPN Client...
start /wait "" "%installer%" /S

:: Check if the installation was successful
if %errorlevel% neq 0 (
    echo Error: LANCOM Advanced VPN Client installation failed.
    pause
    exit /b 1
)

:: Check if a license key is set
if "%license_key%"=="" (
    :: Prompt for license key input
    set /p license_key=Enter your license key: 
)

if not "%license_key%"=="" (
    echo Applying license key...
    "C:\Program Files (x86)\LANCOM\LANCOM Advanced VPN Client\vpnclient.exe" -setlicensekey "%license_key%"
)

:: Check if the INI file exists and import it if it does
if exist "%profile_ini%" (
    echo Importing VPN profile from %profile_ini%...
    "C:\Program Files (x86)\LANCOM\LANCOM Advanced VPN Client\vpnclient.exe" -importprofile "%profile_ini%"
)

echo LANCOM Advanced VPN Client installation and configuration completed.
pause
