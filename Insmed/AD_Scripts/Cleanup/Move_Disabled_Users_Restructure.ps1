#####################################################################################################################
#
# Move_Disabled_Users.ps1
#
# Shelby Mader, Novick Tech
# Email: shelby@novick.tech
# Updated April 2024
#
# Purpose: 
# This script will find and move unused user accounts from the new "Disabled Users" OU into the new "Users Pending Delete" OU using the last logon attributes. 
# The user must be disabled and have a last logon greater than 90 days
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
#  - Version 0.2 - April 2024
#
#################################################################################################################### 

$todaysdate=Get-Date -Format "MM-dd-yyyy"

$logfilepath= "C:\temp\AD_Reports\Users_Cleanup\AD_Disabled_Users_Move_To_Delete_OU_Log_Restructure"+$todaysdate+".txt"
$logFile = $logFilePath

Add-Content $logFile "Starting.."
Add-Content $logFile $(get-date)

$365days = (Get-Date).AddDays(-365) 

$users = Get-ADUser -Filter * -SearchBase "OU=Disabled Users,OU=Insmed Users,DC=insmed,DC=local" -SearchScope Subtree -Properties *

foreach ($user in $users) {

    if ($user.LastLogonDate -lt $365days) {

        if ($user.Enabled -eq $false) {
            Write-Host $user.Name, $user.Enabled, $user.LastlogonDate
            Add-Content $logFile "Moving user: $user.Name : $(get-date)"
            Move-ADObject -TargetPath "OU=Users Pending Delete,OU=Disabled Users,OU=Insmed Users,DC=insmed,DC=local" -Identity $user.DistinguishedName

        }
    }
}
