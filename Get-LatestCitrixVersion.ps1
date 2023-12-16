$CITRIXURL = "https://www.citrix.com/downloads/workspace-app/windows/workspace-app-for-windows-latest.html"

# Create a web request to fetch the HTML content of the download page
$response = Invoke-WebRequest -Uri $CITRIXURL

# Use regular expressions to extract the version information and release date from the HTML content
$VersionPattern = "<h1>Citrix Workspace app ([\d\.]+)"
$ReleaseDatePattern = "<h3>Release Date: ([A-Za-z]+\s+\d{1,2},\s+\d{4})<\/h3>"

$VersionMatch = [regex]::Match($response.Content, $VersionPattern)
$ReleaseDateMatch = [regex]::Match($response.Content, $ReleaseDatePattern)

# Check if matches were found
if ($VersionMatch.Success -and $ReleaseDateMatch.Success) {
    	$LatestVersion = $VersionMatch.Groups[1].Value
	$ReleaseDateText = $ReleaseDateMatch.Groups[1].Value
    	$ReleaseDate = Get-Date $ReleaseDateText -Format "yyyy-MM-dd"
	Write-Host ""
	Write-Host "`tCitrix WorkspaceApp (for Windows)"
	Write-Host ""
    	Write-Host "`t`tLatest version:`t$LatestVersion"
    	Write-Host "`t`tRelease Date:`t$ReleaseDate"
	Write-Host ""
} else {
#    	Write-Warning "Failed to retrieve the latest version or release date."
	Write-Error "Failed to retrieve the latest version or release date."

}
