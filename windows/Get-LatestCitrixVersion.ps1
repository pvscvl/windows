$CITRIX_URL = "https://www.citrix.com/downloads/workspace-app/windows/workspace-app-for-windows-latest.html"

# Create a web request to fetch the HTML content of the download page
$CITRIX_URL_RESPONSE = Invoke-WebRequest -Uri $CITRIX_URL

# Use regular expressions to extract the version information and release date from the HTML content
$CITRIX_VERSION_PATTERN = "<h1>Citrix Workspace app ([\d\.]+)"
$CITRIX_RELEASEDATE_PATTERN = "<h3>Release Date: ([A-Za-z]+\s+\d{1,2},\s+\d{4})<\/h3>"

$CITRIX_VERSION_MATCH = [regex]::Match($CITRIX_URL_RESPONSE.Content, $CITRIX_VERSION_PATTERN)
$CITRIX_RELEASEDATE_MATCH = [regex]::Match($CITRIX_URL_RESPONSE.Content, $CITRIX_RELEASEDATE_PATTERN)

# Check if matches were found
if ($CITRIX_VERSION_MATCH.Success -and $CITRIX_RELEASEDATE_MATCH.Success) {
    	$CITRIX_LATEST_VERSION = $CITRIX_VERSION_MATCH.Groups[1].Value
	$CITRIX_RELEASEDATE_TEXT = $CITRIX_RELEASEDATE_MATCH.Groups[1].Value
    	$CITRIX_RELEASEDATE = Get-Date $CITRIX_RELEASEDATE_TEXT -Format "yyyy-MM-dd"
	Write-Host ""
	Write-Host "`tCitrix WorkspaceApp (for Windows)"
	Write-Host ""
    	Write-Host "`t`tLatest version:`t$CITRIX_LATEST_VERSION"
    	Write-Host "`t`tRelease Date:`t$CITRIX_RELEASEDATE"
	Write-Host ""
} else {
#    	Write-Warning "Failed to retrieve the latest version or release date."
	Write-Error "Failed to retrieve the latest version or release date."

}
