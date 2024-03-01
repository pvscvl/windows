$ApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
$DestinationPath = "C:/temp/pwsh-win-x64.msi"
$VersionFilePath = "C:/temp/pwsh-win-x64_ver.txt"
$WebClient = New-Object System.Net.WebClient
try {
    $LatestRelease = Invoke-RestMethod -Uri $ApiUrl
    $LatestVersion = $LatestRelease.tag_name
    $DownloadUrl = $LatestRelease.assets | Where-Object { $_.name -like "PowerShell-*-win-x64.msi" } | Select-Object -ExpandProperty browser_download_url

#    Write-Host "Downloading the latest PowerShell setup (version $LatestVersion)..."
    $webClient.DownloadFile($DownloadUrl, $DestinationPath)
#    Write-Host "PowerShell setup downloaded successfully to: $DestinationPath"

    $LatestVersion | Set-Content -Path $VersionFilePath
#    Write-Host "Version information saved to: $VersionFilePath"
} catch {
    Write-Host "Failed to download PowerShell setup. Error: $_.Exception.Message"
}
