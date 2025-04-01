######################################################################################################################
#
# Move_Disabled_Computers_To_Pending_Delete_OU.ps1
#
# Shelby Mader, Novick Tech
# shelby@novick.tech
# April 2021
#
# Purpose: 
# - Finds all computers in the "Disabled Computers" OU and checks that they are BOTH disabled AND logon is over 90 days ago.
# - Moves the computers that meet criteria above into "Pending Delete" OU
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

$logfilepath= "C:\temp\AD_Reports\Computers_Cleanup\AD_Disabled_Computers_Move_To_Delete_OU_Log_"+$todaysdate+".txt"
$logFile = $logFilePath

Add-Content $logFile "Starting.."
Add-Content $logFile $(get-date)

$90days = (Get-Date).AddDays(-90) 
# The 90 is the number of days from today since the last logon.

$computers = Get-ADComputer -Filter * -SearchBase "OU=Disabled Computers,DC=insmed,DC=local" -SearchScope Subtree -Properties *

foreach ($computer in $computers) {

    if ($computer.LastLogonDate -lt $90days) {

        if ($computer.Enabled -eq $false) {
            Write-Host $computer.Name, $computer.Enabled, $computer.LastlogonDate
            Add-Content $logFile "Moving computer: $computer.Name : $(get-date)"
            Move-ADObject -TargetPath "OU=Computers Pending Delete,OU=Disabled Computers,DC=insmed,DC=local" -Identity $computer.DistinguishedName

        }
    }
}
