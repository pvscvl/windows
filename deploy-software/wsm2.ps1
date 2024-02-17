 $WG_URL = "https://software.watchguard.com/SoftwareDownloads?current=true&familyId=a2R6S000000NkiOUAS"
Write-Host "WG_URL: $WG_URL"

$WG_CONTENT = Invoke-WebRequest -Uri $WG_URL
Write-Host "WG_CONTENT obtained"

$WSM_DOWNLOAD_INFO = $WG_CONTENT.Links | Where-Object { $_.href -like "*wsm_*.exe" } | Select-Object -First 1
$H5_TITLE = $null
$RELEASE_DATE = $null
$TRIMDATE = $null
Write-Host "Initial H5_TITLE: $H5_TITLE"
Write-Host "Initial RELEASE_DATE: $RELEASE_DATE"
Write-Host "Initial TRIMDATE: $TRIMDATE"

if ($WSM_DOWNLOAD_INFO -ne $null) {
    # Find the h5 element that contains 'Fireware' and store the entire title
    $H5_TITLE = ($WG_CONTENT.ParsedHtml.getElementsByTagName('h5') | Where-Object { $_.InnerText -like '*Fireware*' }).InnerText
    if ($H5_TITLE) {
        Write-Host "Extracted H5_TITLE: $H5_TITLE"
        # Remove "Fireware: " from the title
        $CLEANED_TITLE = $H5_TITLE -replace 'Fireware: ', ''
        Write-Host "CLEANED_TITLE: $CLEANED_TITLE"
    } else {
        Write-Host "H5 Title containing 'Fireware' not found"
    }

    # Extract the release date
    $RELEASE_DATE = ($WG_CONTENT.ParsedHtml.getElementsByClassName('dateCheckSum') | Select-Object -First 1).InnerText
    if ($RELEASE_DATE) {
        Write-Host "Extracted RELEASE_DATE: $RELEASE_DATE"
        # Trim the release date to get only the date in MM/dd/yyyy format
        $TRIMDATE_PATTERN = '\d{2}/\d{2}/\d{4}'
        if ($RELEASE_DATE -match $TRIMDATE_PATTERN) {
            $TRIMDATE = $matches[0]
            # Convert to DateTime and format to dd.MM.yyyy
            $TRIMDATE = [DateTime]::ParseExact($TRIMDATE, 'MM/dd/yyyy', $null).ToString('dd.MM.yyyy')
            Write-Host "Formatted TRIMDATE: $TRIMDATE"
        } else {
            Write-Host "Date format not matched"
        }
    } else {
        Write-Host "Release date not found"
    }

    $WSM_DOWNLOAD = $WSM_DOWNLOAD_INFO.href
    Write-Host "WSM_DOWNLOAD: $WSM_DOWNLOAD"

    $WSM_FILENAME = Split-Path -Path $WSM_DOWNLOAD -Leaf
    Write-Host "WSM_FILENAME: $WSM_FILENAME"

    $WSM_INSTALLER_PATH = "C:\temp\" + $WSM_FILENAME
    Write-Host "WSM_INSTALLER_PATH: $WSM_INSTALLER_PATH"

    Invoke-WebRequest -Uri $WSM_DOWNLOAD -OutFile $WSM_INSTALLER_PATH
} else {
    Write-Host "Watchguard System Manager Download link not found"
}
 
