param (
	[switch]$VERBOSE
)

	$CURRENTDIRECTORY = Get-Location
	$TEMP_FOLDER_PATH = "C:\temp"
	$BACKUP_PATH = "Q:\"
	$7ZIP64EXE = "C:\Program Files\7-Zip\7z.exe"
	$7ZIP32EXE = "C:\Program Files (x86)\7-Zip\7z.exe"
	$FIREFOX32EXE = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
	$FIREFOX64EXE = "C:\Program Files\Mozilla Firefox\firefox.exe"
 	$USER_PROFILE_PATH = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
	$FIREFOX_PROFILES_PATH = Join-Path $USER_PROFILE_PATH "AppData\Roaming\Mozilla\Firefox\Profiles"
 	$LATEST_PROFILE = Get-ChildItem $FIREFOX_PROFILES_PATH | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  
	Write-Host "Closing Firefox processes ..."
	$FIREFOX_PROCESSES = Get-Process -Name firefox -ErrorAction SilentlyContinue
	If ($VERBOSE) { Write-Host "Retrieved Firefox processes." }

	if ($FIREFOX_PROCESSES) {
		foreach ($PROCESS in $FIREFOX_PROCESSES) {
        		$PROCESS.CloseMainWindow() | Out-Null
	          		If ($VERBOSE) { Write-Host "" }
        			If ($VERBOSE) { Write-Host "Requested to close Firefox process ID $($PROCESS.Id)." }
			$PROCESS.WaitForExit(10) | Out-Null
				If ($VERBOSE) { Write-Host "Waited for process ID $($PROCESS.Id) to exit." }
   
        		if (!$PROCESS.HasExited) {
            			$PROCESS | Stop-Process -Force | Out-Null
            			If ($VERBOSE) { Write-Host "Forcefully stopped process ID $($PROCESS.Id)." }
        		}
    		}
	}

	Write-Host "Exporting Firefox Profile to vol Q."
#	$USER_PROFILE_PATH = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
	If ($VERBOSE) { Write-Host "User profile path: $USER_PROFILE_PATH" }

#	$FIREFOX_PROFILES_PATH = Join-Path $USER_PROFILE_PATH "AppData\Roaming\Mozilla\Firefox\Profiles"
	If ($VERBOSE) { Write-Host "Firefox profiles path: $FIREFOX_PROFILES_PATH" }


if (-Not (Test-Path -Path $BACKUP_PATH -PathType Container)) {
	New-Item -Path $BACKUP_PATH -ItemType Directory -Force | Out-Null
	If ($VERBOSE) { Write-Host "Created backup path: $BACKUP_PATH" }
}

if (-Not (Test-Path -Path $TEMP_FOLDER_PATH -PathType Container)) {
	New-Item -Path $TEMP_FOLDER_PATH -ItemType Directory -Force | Out-Null
	If ($VERBOSE) { Write-Host "Created temporary folder path: $TEMP_FOLDER_PATH" }
}

#	$LATEST_PROFILE = Get-ChildItem $FIREFOX_PROFILES_PATH | Sort-Object LastWriteTime -Descending | Select-Object -First 1
	If ($VERBOSE) { Write-Host "Retrieved latest Firefox profile." }
	If ($VERBOSE) { Write-Host "LATEST_PROFILE: $LATEST_PROFILE" }
if ($LATEST_PROFILE -ne $null) {
	$LATEST_PROFILE_PATH = $LATEST_PROFILE.FullName
		If ($VERBOSE) { Write-Host "Latest profile path: $LATEST_PROFILE_PATH" }
	Set-Location -Path $LATEST_PROFILE_PATH | Out-Null
		If ($VERBOSE) { Write-Host "Changed location to the latest profile path." }
		If ($VERBOSE) { Write-Host "LATEST_PROFILE_PATH: $LATEST_PROFILE_PATH" }

	$BACKUP_FILE_NAME = "FirefoxProfile_$($LATEST_PROFILE.Name)_$(Get-Date -Format 'yyyyMMdd').zip"
	$BACKUP_FILE_PATH = Join-Path $TEMP_FOLDER_PATH $BACKUP_FILE_NAME
 
		If ($VERBOSE) { Write-Host "Backup file name and path set." }
		If ($VERBOSE) { Write-Host "BACKUP_FILE_NAME: $BACKUP_FILE_NAME" }
		If ($VERBOSE) { Write-Host "BACKUP_FILE_PATH: $BACKUP_FILE_PATH" }

		if (Test-Path $7ZIP64EXE) {
  			If ($VERBOSE) { Write-Host "Using 7Zip (64Bit) to compress profile." }
    			& $7ZIP64EXE a -tzip -mx0 $BACKUP_FILE_PATH .\* | Out-Null 
		}
		elseif (Test-Path $7ZIP32EXE) {
  			If ($VERBOSE) { Write-Host "Using 7Zip (32Bit) to compress profile." }
    			& $7ZIP32EXE a -tzip -mx0 $BACKUP_FILE_PATH .\* | Out-Null
		} 
		else {
  			If ($VERBOSE) { Write-Host "Using native windows Compress-Archive function to compress profile." }
    			Compress-Archive -Path .\* -DestinationPath $BACKUP_FILE_PATH -CompressionLevel NoCompression
		}
  
		If ($VERBOSE) { Write-Host "Created zip archive of the profile." }
	Copy-Item -Path $BACKUP_FILE_PATH -Destination $BACKUP_PATH -Force
	Remove-Item -Path $BACKUP_FILE_PATH -Force
   
	# Set-Location -Path $USER_PROFILE_PATH | Out-Null
 	Set-Location -Path $CURRENTDIRECTORY | Out-Null
		If ($VERBOSE) { Write-Host "Changed location back to $CURRENTDIRECTORY " }
} else {
	Write-Host "No Firefox profile found in the specified path."
}

if (Test-Path $FIREFOX64EXE) {
	Start-Process -FilePath $FIREFOX64EXE | Out-Null
		If ($VERBOSE) { Write-Host "Started 64-bit Firefox." }
} 
elseif (Test-Path $FIREFOX32EXE) {
        Start-Process -FilePath $FIREFOX32EXE | Out-Null
		If ($VERBOSE) { Write-Host "Started 32-bit Firefox." }
	} else {
		Write-Host "Firefox not found in the expected locations."
    	}


Write-Host "Firefox profile backup complete. Firefox has been restarted." 
