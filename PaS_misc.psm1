# Module manifest for PaS_misc Module

@{
    ModuleVersion = '1.0'
    Author = 'Pascal Schoofs'
    Description = 'A module for misc. actions.'
    FunctionsToExport = 'Test-ComputerOnline', '_user', '_build', '_model', '_cpu','Get-CitrixVersion','Get-CitrixVersion'
    PowerShellVersion = '5.1'
}

function Test-ComputerOnline {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
    $ping = Test-Connection -ComputerName $Computer -Count 1 -Quiet
    return $ping
}

function _user {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        Write-Host "Device $Computer is not online."
        return
    }
    query user /server:$Computer
} 

function _build {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        Write-Host "Device $Computer is not online."
        return
    }
    (Get-WmiObject -ComputerName $Computer -ClassName Win32_OperatingSystem).BuildNumber
} 

function _model {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        Write-Host "Device $Computer is not online."
        return
    }
    Get-WmiObject -ComputerName $Computer -ClassName Win32_ComputerSystem | Select-Object Model
}

function _cpu {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Computer
    )
    if (-Not (Test-ComputerOnline -Computer $Computer)) {
        Write-Host "Device $Computer is not online."
        return
    }
    Get-WmiObject -ComputerName $Computer -ClassName Win32_Processor | Select-Object Name
}

function Generate-Password {
    function Get-RandomCharacters($length, $characters) {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = ""
        return [String]$characters[$random]
    }
    $pvscvlpasswordpt1 = Get-RandomCharacters -length 4 -characters 'ABCDEFGHKLMNPRQSTUVWXYZ'
    $pvscvlpasswordpt2 = Get-RandomCharacters -length 4 -characters 'abcdefghikmnoprstuvwxyz'
    $pvscvlpasswordpt3 = Get-RandomCharacters -length 4 -characters '1234567890'
    $pvscvlpassword = $pvscvlpasswordpt1
    $pvscvlpassword += "-"
    $pvscvlpassword += $pvscvlpasswordpt2
    $pvscvlpassword += "#"
    $pvscvlpassword += $pvscvlpasswordpt3
    
    echo -n $pvscvlpassword | Set-Clipboard
    Write-Host ""
    Write-Host ""
    #Write-Host "`t $pvscvlpassword"
    Write-Host "$pvscvlpassword"
    Write-Host ""
}

function Get-CitrixVersion {
    $url = "https://www.citrix.com/downloads/workspace-app/windows/workspace-app-for-windows-latest.html"
    $response = Invoke-WebRequest -Uri $url
    $title = $response.ParsedHtml.title
    $currentVersion = [regex]::Match($title, "\d+").Value

    Write-Host "Latest Citrix Workspace App Version: ", "$currentVersion"
}

function _citrix {
    $url = "https://www.citrix.com/downloads/workspace-app/windows/workspace-app-for-windows-latest.html"
    $response = Invoke-WebRequest -Uri $url
    $title = $response.ParsedHtml.title
    $currentVersion = [regex]::Match($title, "\d+").Value

    Write-Host "Latest Citrix Workspace App Version: ", "$currentVersion"
}

