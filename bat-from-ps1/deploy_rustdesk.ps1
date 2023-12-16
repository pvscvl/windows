Start-Transcript -Path 'C:\logs\rustdesk.log'
Write-Output "########################################################"
Write-Output "`tStarting execution of Batch-Script."
Write-Output "########################################################"
Write-Output ""
Write-Output ""
cmd /c C:\temp\deploy_rustdesk.bat
Write-Output ""
Write-Output ""
Write-Output "########################################################"
Write-Output "`tBatch-Script execution stopped."
Write-Output "########################################################"
Stop-Transcript
