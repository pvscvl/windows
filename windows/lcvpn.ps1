# Define paths and filenames
$installer = "LANCOM_VPN_Client_6_Setup.exe"
$profileIni = "vpn_profile.ini"
$licenseKey = "YOUR_LICENSE_KEY_HERE"

# Check if the installer exists
if (-not (Test-Path -Path $installer)) {
    Write-Host "Error: LANCOM VPN Client installer not found in the same directory as this script."
    Read-Host -Prompt "Press Enter to exit..."
    exit 1
}

# Install LANCOM VPN Client silently
Write-Host "Installing LANCOM VPN Client..."
Start-Process -FilePath $installer -ArgumentList "/S" -Wait

# Check if the installation was successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: LANCOM VPN Client installation failed."
    Read-Host -Prompt "Press Enter to exit..."
    exit 1
}

# Check if a license key is set
if ($licenseKey -eq "YOUR_LICENSE_KEY_HERE") {
    # Prompt for license key input
    $licenseKey = Read-Host "Enter your license key:"
}

if ($licenseKey -ne "") {
    Write-Host "Applying license key..."
    & "C:\Program Files (x86)\LANCOM\LANCOM Advanced VPN Client\vpnclient.exe" -setlicensekey $licenseKey
}

# Check if the INI file exists and import it if it does
if (Test-Path -Path $profileIni) {
    Write-Host "Importing VPN profile from $profileIni..."
    & "C:\Program Files (x86)\LANCOM\LANCOM Advanced VPN Client\vpnclient.exe" -importprofile $profileIni
}

Write-Host "LANCOM VPN Client installation and configuration completed."
Read-Host -Prompt "Press Enter to exit..."
