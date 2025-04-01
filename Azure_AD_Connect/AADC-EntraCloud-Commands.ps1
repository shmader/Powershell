# Azure AD Connect / Entra Cloud Commands


#Sync and Scheduler Commands

Start-ADSyncSyncCycle -PolicyType Delta
Stop-ADSyncSyncCycle
Set-ADSyncScheduler -SyncCycleEnabled $true


#Sync Tools

Install-AADCloudSyncToolsPrerequisites

Import-module -Name "C:\Program Files\Microsoft Azure AD Connect Provisioning Agent\Utility\AADCloudSyncTools"

Connect-AADCloudSyncTools

Get-module AADCloudSyncTools



Get-AADCloudSyncToolsInfo

Get-AADCloudSyncToolsJob

Get-AADCloudSyncToolsJobSettings

Get-AADCloudSyncToolsJobStatus

Export-AADCloudSyncToolsLogs

Start-AADCloudSyncToolsVerboseLogs

Stop-AADCloudSyncToolsVerboseLogs



Repair-AADCloudSyncToolsAccount


