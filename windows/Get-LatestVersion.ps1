function Get-LatestVersion {
    param (
        [string]$repo,
        [switch]$Verbose
    )

    $repoName = [System.IO.Path]::GetFileName($repo)  # Extract the repository name
    $latestVersion = (Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest").tag_name

    if ($Verbose) {
        Write-Output "Latest $repoName version: $latestVersion"
    }
    else {
        Write-Output $latestVersion
    }
}

# Example usage without verbose switch:
# $version = Get-LatestVersion "rustdesk/rustdesk-server-pro"
#Write-Output "Latest version: $version"

# Example usage with verbose switch:
# Get-LatestVersion "rustdesk/rustdesk-server-pro" -Verbose
