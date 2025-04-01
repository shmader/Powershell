#####################################################################################################################
#
# Delete_Disabled_Users.ps1
#
# Shelby Mader, Novick Tech
# Email: shelby@novick.tech
# Updated August 2022
#
# Purpose: 
# This script will delete the unused user accounts in the "Users pending delete" OU using the last logon attributes. 
# The user must be disabled and have a last logon greater than 120 days
#
## Requirements for Script to Run:
#  - Active Directory PowerShell Module (Install via Add/Remove Features > RSAT > AD DS and AD LDS Tools)
#  - AD_Cleanup service account (used to run scheduled task) must have full control permissions on the following OUs:
#	-Disabled Computers
#	-Disabled Users
#	-Computers Pending Delete
#	-Users Pending Delete
#
## Change Log:
#  - Version 0.1 - August 2022
#
#################################################################################################################### 


$todaysdate=Get-Date -Format "MM-dd-yyyy"

$logfilepath= "C:\temp\AD_Reports\Users_Cleanup\AD_Users_Deletion_Log_"+$todaysdate+".txt"
$logFile = $logFilePath

Add-Content $logFile "Starting.."
Add-Content $logFile $(get-date)

$395days = (Get-Date).AddDays(-395) 
# The 395 is the number of days from today since the last logon.

$users = Get-ADUser -Filter * -SearchBase "OU=Users Pending Delete,OU=Disabled Users,DC=insmed,DC=local" -SearchScope Subtree -Properties *

foreach ($user in $users) {

    if ($user.LastLogonDate -lt $395days) {

        if ($user.Enabled -eq $false) {
            Write-Host $user.Name, $user.Enabled, $user.LastlogonDate
            Add-Content $logFile "Deleting user: $user.Name : $(get-date)"
            Remove-ADObject -Identity $user.DistinguishedName -Confirm:$false

        }
    }
}
