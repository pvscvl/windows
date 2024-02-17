function Show-ADComputersInGridView {
    $computers = Get-ADComputer -Filter * -Properties Name, Description
    
    $computerInfo = @()

    foreach ($computer in $computers) {
        $computerName = $computer.Name
        $description = $computer.Description

        $computerInfo += [PSCustomObject]@{
            "ComputerName" = $computerName
            "Description" = $description
        }
    }

    $computerInfo | Sort-Object -Property "ComputerName" | Out-GridView -Title "Active Directory Computers"
   # $computerInfo | Out-GridView -Title "Active Directory Computers"
}

# Call the function to display computer information in a grid view
Show-ADComputersInGridView
