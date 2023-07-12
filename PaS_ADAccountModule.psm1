# Module manifest for PaS_ADAccountModule

@{
    ModuleVersion = '1.0'
    Author = 'Pascal Schoofs'
    Description = 'A module for Active Directory operations'
    FunctionsToExport ='Test-ADCredentials','Get-LockedADAccounts','Unlock-ADAccount','Test-TKMDefaultCredentials','Test-TKSDefaultCredentials'
    PowerShellVersion = '5.1'
    RequiredModules = 'ActiveDirectory'
}



function Test-ADCredentials {
    [CmdletBinding()]
    Param (
        [string]$UserName,
        [string]$Password
    )
    if (!($UserName) -or !($Password)) {
        Write-Warning 'Test-ADCredential: Please specify both user name and password'
    }
    else {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
        
        $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($DS, $UserName)
        if ($user) {
            if ($user.IsAccountLockedOut()) {
                Write-Host "User $UserName is locked out. Unlocking..."
                $user.UnlockAccount()
                Write-Host "User $UserName has been unlocked."
            }
        }
        
        $DS.ValidateCredentials($UserName, $Password)
    }
}

function Get-LockedADAccounts {
    $lockedOutAccounts = Search-AdAccount -LockedOut
    $selectedProperties = "lastlogondate", "name", "samaccountname"
    
    if ($lockedOutAccounts.Count -eq 0) {
        Write-Output "No accounts locked out"
    } else {
        $lockedOutAccounts | Select-Object $selectedProperties
    }
}

function Unlock-ADAccount {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SamAccountName
    )

    try {
        Unlock-ADAccount -Identity $SamAccountName -ErrorAction Stop
        Write-Host "Account '$SamAccountName' has been unlocked."
    }
    catch {
        Write-Host "Failed to unlock account '$SamAccountName'."
        Write-Host "Error: $_"
    }
}

function Test-TKMDefaultCredentials {
    [CmdletBinding()]
    Param
    (
        [string]$UserName
    )

    if (!$UserName) {
        $UserName = Read-Host "Enter the username"
    }

    $Password = "TKM#12345"

    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
    $isValid = $DS.ValidateCredentials($UserName, $Password)

    if ($isValid) {
        Write-Warning "Initial Password in use."
    } else {
        Write-Host "User is not using the initial password"
    }
}

function Test-TKSDefaultCredentials {
    [CmdletBinding()]
    Param
    (
        [string]$UserName
    )

    if (!$UserName) {
        $UserName = Read-Host "Enter the username"
    }

    $Password = "TKS#12345"

    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
    $isValid = $DS.ValidateCredentials($UserName, $Password)

    if ($isValid) {
        Write-Warning "Initial Password in use."
    } else {
        Write-Host "User is not using the initial password"
    }
}
