######################################################################################################################
#
# Move_Disabled_Computers_To_Pending_Delete_OU.ps1
#
# Shelby Mader, Novick Tech
# shelby@novick.tech
# April 2021
#
# Purpose: 
# - Finds all computers in the "Pending Delete" OU and checks that they are BOTH disabled AND logon is over 90 days ago.
# - Deletes the computers that meet criteria
#
#
## Requirements for Script to Run:
# - None
#
## Change Log:
# - Version 0.1 - April 2022
# - Version 0.2 - August 2022
#
####################################################################################################################


$todaysdate=Get-Date -Format "MM-dd-yyyy"

$logfilepath= "C:\temp\AD_Reports\Computers_Cleanup\AD_Computers_Deletion_Log_"+$todaysdate+".txt"
$logFile = $logFilePath

Add-Content $logFile "Starting.."
Add-Content $logFile $(get-date)

$120days = (Get-Date).AddDays(-120) 
# The 120 is the number of days from today since the last logon.

$computers = Get-ADComputer -Filter * -SearchBase "OU=Computers Pending Delete,OU=Disabled Computers,DC=insmed,DC=local" -SearchScope Subtree -Properties *

foreach ($computer in $computers) {

    if ($computer.LastLogonDate -lt $120days) {

        if ($computer.Enabled -eq $false) {
            Write-Host $computer.Name, $computer.Enabled, $computer.LastlogonDate
            Add-Content $logFile "Deleting computer: $computer.Name : $(get-date)"
            Remove-ADObject -Identity $computer.DistinguishedName -Confirm:$false

        }
    }
}
