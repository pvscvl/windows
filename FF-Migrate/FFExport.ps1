param (
	[switch]$Verbose
)

$VERBOSE = $Verbose

function VerboseOutput($message) {
	if ($VERBOSE) {
        	Write-Host $message
    	}
}

	Write-Host "Closing Firefox processes"
$FIREFOX_PROCESSES = Get-Process -Name firefox -ErrorAction SilentlyContinue
	VerboseOutput "Retrieved Firefox processes."

if ($FIREFOX_PROCESSES) {
	foreach ($PROCESS in $FIREFOX_PROCESSES) {
        	$PROCESS.CloseMainWindow() | Out-Null
        		VerboseOutput "Requested to close Firefox main window for process ID $($PROCESS.Id)."
		$PROCESS.WaitForExit(10) | Out-Null
			VerboseOutput "Waited for process ID $($PROCESS.Id) to exit."
   
        	if (!$PROCESS.HasExited) {
            		$PROCESS | Stop-Process -Force | Out-Null
            			VerboseOutput "Forcefully stopped process ID $($PROCESS.Id)."
        	}
    	}
}

	Write-Host "Exporting Firefox Profile to vol Q."
$USER_PROFILE_PATH = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
	VerboseOutput "User profile path: $USER_PROFILE_PATH"

$FIREFOX_PROFILES_PATH = Join-Path $USER_PROFILE_PATH "AppData\Roaming\Mozilla\Firefox\Profiles"
	VerboseOutput "Firefox profiles path: $FIREFOX_PROFILES_PATH"

$TEMP_FOLDER_PATH = "C:\temp"
$BACKUP_PATH = "Q:\"

if (-Not (Test-Path -Path $BACKUP_PATH -PathType Container)) {
	New-Item -Path $BACKUP_PATH -ItemType Directory -Force | Out-Null
	VerboseOutput "Created backup path: $BACKUP_PATH"
}

if (-Not (Test-Path -Path $TEMP_FOLDER_PATH -PathType Container)) {
	New-Item -Path $TEMP_FOLDER_PATH -ItemType Directory -Force | Out-Null
	VerboseOutput "Created temporary folder path: $TEMP_FOLDER_PATH"
}

$LATEST_PROFILE = Get-ChildItem $FIREFOX_PROFILES_PATH | Sort-Object LastWriteTime -Descending | Select-Object -First 1
	VerboseOutput "Retrieved latest Firefox profile."
	VerboseOutput "LATEST_PROFILE: $LATEST_PROFILE"
if ($LATEST_PROFILE -ne $null) {
	$LATEST_PROFILE_PATH = $LATEST_PROFILE.FullName
		VerboseOutput "Latest profile path: $LATEST_PROFILE_PATH"
	Set-Location -Path $LATEST_PROFILE_PATH | Out-Null
		VerboseOutput "Changed location to the latest profile path."
		VerboseOutput "LATEST_PROFILE_PATH: $LATEST_PROFILE_PATH"

	$BACKUP_FILE_NAME = "FirefoxProfile_$($LATEST_PROFILE.Name)_$(Get-Date -Format 'yyyyMMdd').zip"
	$BACKUP_FILE_PATH = Join-Path $TEMP_FOLDER_PATH $BACKUP_FILE_NAME
		VerboseOutput "Backup file name and path set."
		VerboseOutput "BACKUP_FILE_NAME: $BACKUP_FILE_NAME"
		VerboseOutput "BACKUP_FILE_PATH: $BACKUP_FILE_PATH"
	& "C:\Program Files\7-Zip\7z.exe" a -tzip -mx0 $BACKUP_FILE_PATH .\* | Out-Null
		VerboseOutput "Created zip archive of the profile."
	Copy-Item -Path $BACKUP_FILE_PATH -Destination $BACKUP_PATH -Force
	Remove-Item -Path $BACKUP_FILE_PATH -Force
   
	Set-Location -Path $USER_PROFILE_PATH | Out-Null
		VerboseOutput "Changed location back to user profile path."
} else {
	Write-Host "No Firefox profile found in the specified path."
}

$FIREFOX_64_PATH = "C:\Program Files\Mozilla Firefox\firefox.exe"
if (Test-Path $FIREFOX_64_PATH) {
	Start-Process -FilePath $FIREFOX_64_PATH | Out-Null
		VerboseOutput "Started 64-bit Firefox."
} else {
	$FIREFOX_32_PATH = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
    	if (Test-Path $FIREFOX_32_PATH) {
        	Start-Process -FilePath $FIREFOX_32_PATH | Out-Null
        		VerboseOutput "Started 32-bit Firefox."
	} else {
		Write-Host "Firefox not found in the expected locations."
    	}
}

Write-Host "Firefox profile backup complete. Firefox has been restarted." 
