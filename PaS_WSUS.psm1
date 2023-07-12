# Module manifest for PaS_misc Module

@{
    ModuleVersion = '1.0'
    Author = 'Pascal Schoofs'
    Description = 'A module for WSUS actions.'
    FunctionsToExport = 'Test-ComputerOnline', '_user', '_build', '_model', '_cpu','Get-CitrixVersion','Get-CitrixVersion'
    PowerShellVersion = '5.1'
}


function _gpupdate{
        param (
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string]$Computer
        )
    	        if (-Not (Test-ComputerOnline -Computer $Computer)) {
                        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                        $logMessage = "$timestamp $Computer : gpupdate: N/A"
                        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
		        Write-Host -NoNewline $Computer 
		        Write-Host ":`t N/A "
                        return
                }        
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logMessage = "$timestamp $Computer : gpupdate starting."
                Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
                    Invoke-Command -ComputerName $Computer -ScriptBlock { gpupdate }
}

function Test-ComputerOnline {
        param (
                [Parameter(Mandatory=$true)]
                [ValidateNotNullOrEmpty()]
                [string]$Computer
        )
        $ping = Test-Connection -ComputerName $Computer -Count 1 -Quiet
        return $ping}


function Force-WSUSCheckin {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
        )
	    if (-Not (Test-ComputerOnline -Computer $Computer)) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $logMessage = "$timestamp $Computer : WSUSCheckin: N/A"
            Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
		    Write-Host -NoNewline $Computer 
		    Write-Host ":`t N/A "
            return
        }
        
        $targetDir = 'C:\bin'
        $psexecPath = Join-Path $targetDir 'psexec.exe'
        $pstoolsZipUrl = 'https://download.sysinternals.com/files/PSTools.zip'

        if (-Not (Test-Path -Path $psexecPath)) {
            Write-Host "Downloading PSTools.zip..."
        try {
            $zipFilePath = Join-Path $env:TEMP 'PSTools.zip'
            Invoke-WebRequest -Uri $pstoolsZipUrl -OutFile $zipFilePath -ErrorAction Stop

           Write-Host "Extracting PSTools"
           Expand-Archive -Path $zipFilePath -DestinationPath $targetDir -Force

            $extractedPsexecPath = Get-ChildItem -Path $targetDir -Filter 'psexec.exe' -Recurse | Select-Object -First 1
            if ($extractedPsexecPath) {
                Move-Item -Path $extractedPsexecPath.FullName -Destination $psexecPath -Force
            }

            Remove-Item -Path $zipFilePath -Force

            Write-Host "PSTools downloaded and saved to C:\bin"
        } catch {
            Write-Host "Failed to download PSTools.zip. Error: $_.Exception.Message"
            exit 1
        }
    } else {
        Write-Host ""
    }
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : WSUSCheckin started."
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            Start-Service wuauserv -Verbose
        }

    $Cmd = '$updateSession = new-object -com "Microsoft.Update.Session";$updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates'
    & c:\bin\psexec.exe -s \\$Computer powershell.exe -Command $Cmd

    Write-Host "Waiting 10 seconds for SyncUpdates webservice to complete to add to the wuauserv queue so that it can be reported on"
    Start-Sleep -Seconds 10

    Invoke-Command -ComputerName $Computer -ScriptBlock {
        wuauclt /detectnow
        (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
        wuauclt /reportnow
        c:\windows\system32\UsoClient.exe startscan
    }
}


function _Force-WSUSCheckin {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
	    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : WSUSCheckin: N/A"
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
		Write-Host -NoNewline $Computer 
		Write-Host ":`t N/A "
        return
    }

        Invoke-Command -ComputerName $Computer -ScriptBlock { gpupdate }

    $targetDir = 'C:\bin'
    $psexecPath = Join-Path $targetDir 'psexec.exe'
    $pstoolsZipUrl = 'https://download.sysinternals.com/files/PSTools.zip'

    if (-Not (Test-Path -Path $psexecPath)) {
        Write-Host "Downloading PSTools.zip..."
        try {
            $zipFilePath = Join-Path $env:TEMP 'PSTools.zip'
            Invoke-WebRequest -Uri $pstoolsZipUrl -OutFile $zipFilePath -ErrorAction Stop

            Write-Host "Extracting PSTools"
            Expand-Archive -Path $zipFilePath -DestinationPath $targetDir -Force

            # Renaming the extracted file to psexec.exe if needed (it might be in a subdirectory inside the zip)
            $extractedPsexecPath = Get-ChildItem -Path $targetDir -Filter 'psexec.exe' -Recurse | Select-Object -First 1
        if ($extractedPsexecPath) {
            Move-Item -Path $extractedPsexecPath.FullName -Destination $psexecPath -Force
            }

        Remove-Item -Path $zipFilePath -Force

        Write-Host "PSTools downloaded and saved to C:\bin"
        } catch {
        Write-Host "Failed to download PSTools.zip. Error: $_.Exception.Message"
        exit 1
        }
        } else {
        Write-Host ""
        }
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : gpupdate complete. WSUSCheckin starting."
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
        Invoke-Command -ComputerName $Computer -ScriptBlock {
        Start-Service wuauserv -Verbose
        }

        $Cmd = '$updateSession = new-object -com "Microsoft.Update.Session";$updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates'
        & c:\bin\psexec.exe -s \\$Computer powershell.exe -Command $Cmd

        Write-Host "Waiting 10 seconds for SyncUpdates webservice to complete to add to the wuauserv queue so that it can be reported on"
        Start-Sleep -Seconds 10

        Invoke-Command -ComputerName $Computer -ScriptBlock {
            wuauclt /detectnow
            (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
            wuauclt /reportnow
            wuauclt /updatenow
            c:\windows\system32\UsoClient.exe ScanInstallWait
        }
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : WSUSCheckin complete."
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
}


function Force-WSUSUpdate {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
	
	
	
	    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : Force-WSUSUpdate: N/A"
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
		Write-Host -NoNewline $Computer 
		Write-Host ":`t N/A "
        return
    }
	
        $targetDir = 'C:\bin'
        $psexecPath = Join-Path $targetDir 'psexec.exe'
        $pstoolsZipUrl = 'https://download.sysinternals.com/files/PSTools.zip'

    if (-Not (Test-Path -Path $psexecPath)) {
        Write-Host "Downloading PSTools.zip..."
        try {
            $zipFilePath = Join-Path $env:TEMP 'PSTools.zip'
            Invoke-WebRequest -Uri $pstoolsZipUrl -OutFile $zipFilePath -ErrorAction Stop

            Write-Host "Extracting PSTools"
            Expand-Archive -Path $zipFilePath -DestinationPath $targetDir -Force

            # Renaming the extracted file to psexec.exe if needed (it might be in a subdirectory inside the zip)
            $extractedPsexecPath = Get-ChildItem -Path $targetDir -Filter 'psexec.exe' -Recurse | Select-Object -First 1
            if ($extractedPsexecPath) {
            Move-Item -Path $extractedPsexecPath.FullName -Destination $psexecPath -Force
        }

        Remove-Item -Path $zipFilePath -Force

        Write-Host "PSTools downloaded and saved to C:\bin"
    } catch {
        Write-Host "Failed to download PSTools.zip. Error: $_.Exception.Message"
        exit 1
    }
    } else {
    Write-Host ""
    }
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp $Computer : Force-WSUSUpdate started."
        Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        Start-Service wuauserv -Verbose
    }

    # Have to use psexec with the -s parameter as otherwise we receive an "Access denied" message loading the comobject
    $Cmd = '$updateSession = new-object -com "Microsoft.Update.Session";$updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates'
    & c:\bin\psexec.exe -s \\$Computer powershell.exe -Command $Cmd

    Invoke-Command -ComputerName $Computer -ScriptBlock {
        wuauclt /updatenow
        c:\windows\system32\UsoClient.exe ScanInstallWait
    }
}

function Test-ADCredential {
    [CmdletBinding()]
    Param
    (
        [string]$UserName,
        [string]$Password
    )
    if (!($UserName) -or !($Password)) {
        Write-Warning 'Test-ADCredential: Please specify both user name and password'
    } else {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
        $DS.ValidateCredentials($UserName, $Password)
    }
}


function Get-UniqueSortedComputerList {
    $OUpaths = @(
        "OU=Deployment,OU=FIBU,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Produktion,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Vertrieb,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Buero,OU=THS,DC=tkm,DC=local",
        "OU=Deployment,OU=Projektleiter,OU=TKS,DC=tkm,DC=local",
        "OU=Deploy-1803,OU=Entwicklung,OU=KTS,DC=tkm,DC=local",
        "OU=Deployment,OU=Einkauf,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=PM,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Verwaltung,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Doku,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Controlling,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=PV-QS,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Entwicklung,OU=TKM,DC=tkm,DC=local"
    )

    $computerlist = @()

    foreach ($iOUpath in $OUpaths) {
        $computerlist += Get-ADComputer -SearchBase $iOUpath -Filter *
    }

    $uniqueSortedComputerList = $computerlist | Select-Object -Property Name -Unique | Sort-Object -Property Name

    return $uniqueSortedComputerList
}

function WSUSPrep {
    $OUpaths = @(
        "OU=Deployment,OU=FIBU,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Produktion,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Vertrieb,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Buero,OU=THS,DC=tkm,DC=local",
        "OU=Deployment,OU=Projektleiter,OU=TKS,DC=tkm,DC=local",
        "OU=Deploy-1803,OU=Entwicklung,OU=KTS,DC=tkm,DC=local",
        "OU=Deployment,OU=Einkauf,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=PM,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Verwaltung,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Doku,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Controlling,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=PV-QS,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Entwicklung,OU=TKM,DC=tkm,DC=local"
    )



    # Define log file path
    $logFilePath = "C:\Logs\scriptlog.txt"

    # Create or append to the log file with the start timestamp
    $startTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$startTimestamp WSUSPrep - START" | Out-File -FilePath $logFilePath -Append
  Write-Output " " | Out-File -FilePath $logFilePath -Append
    $computerlist = @()

    foreach ($iOUpath in $OUpaths) {
        $computerlist += Get-ADComputer -SearchBase $iOUpath -Filter *
    }

    $uniqueSortedComputerList = $computerlist | Select-Object -Property Name -Unique | Sort-Object -Property Name

    foreach ($computer in $uniqueSortedComputerList) {
        $computerName = $computer.Name
                # Log end of commands for the current computer
        #$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        #$logMessage = "$timestamp $computerName : START"
        #Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
        # Log start of command 1

        # Perform command 1 with $computerName as argument
        _gpupdate $computerName

        # Perform command 2 with $computerName as argument
       Force-WSUSCheckin $computerName

        # Perform command 3 with $computerName as argument
        Force-WSUSUpdate $computerName

        # Log end of commands for the current computer
        Write-Output " " | Out-File -FilePath $logFilePath -Append
    }

    # Log the end timestamp
    $endTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$endTimestamp WSUSPREP - ENDE" | Out-File -FilePath $logFilePath -Append
    Rename-Item C:\Logs\scriptlog.txt "$((get-date).toString('yyyy-MM-dd_hhmm'))_WSUSPrep.log"
}


function _WSUSPrep {
    $OUpaths = @(
        "OU=Deployment,OU=FIBU,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Produktion,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Vertrieb,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Lager,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Buero,OU=THS,DC=tkm,DC=local",
        "OU=Deployment,OU=Projektleiter,OU=TKS,DC=tkm,DC=local",
        "OU=Deploy-1803,OU=Entwicklung,OU=KTS,DC=tkm,DC=local",
        "OU=Deployment,OU=Einkauf,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=PM,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Verwaltung,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Doku,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=Controlling,OU=TKS,DC=tkm,DC=local",
        "OU=Deployment,OU=PV-QS,OU=TKM,DC=tkm,DC=local",
        "OU=Deployment,OU=Entwicklung,OU=TKM,DC=tkm,DC=local"
    )



    # Define log file path
    $logFilePath = "C:\Logs\scriptlog.txt"

    # Create or append to the log file with the start timestamp
    $startTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$startTimestamp WSUSPrep - START" | Out-File -FilePath $logFilePath -Append
  Write-Output " " | Out-File -FilePath $logFilePath -Append
    $computerlist = @()

    foreach ($iOUpath in $OUpaths) {
        $computerlist += Get-ADComputer -SearchBase $iOUpath -Filter *
    }

    $uniqueSortedComputerList = $computerlist | Select-Object -Property Name -Unique | Sort-Object -Property Name

    foreach ($computer in $uniqueSortedComputerList) {
        $computerName = $computer.Name
                # Log end of commands for the current computer
        #$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        #$logMessage = "$timestamp $computerName : START"
        #Write-Output $logMessage | Out-File -FilePath $logFilePath -Append
        # Log start of command 1

        # Perform command 1 with $computerName as argument
        _gpupdate $computerName

        # Perform command 2 with $computerName as argument
       _Force-WSUSCheckin $computerName

        # Log end of commands for the current computer
        Write-Output " " | Out-File -FilePath $logFilePath -Append
    }

    # Log the end timestamp
    $endTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$endTimestamp WSUSPREP - ENDE" | Out-File -FilePath $logFilePath -Append
    Rename-Item $logFilePath "$((get-date).toString('yyyy-MM-dd_hhmm'))_WSUSPrep.log"
}
