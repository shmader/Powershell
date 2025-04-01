## Gets the name of the owner of a security group as seen in the "managed by" tab.

Get-ADGroup -Properties name,managedby | select name,managedby | 
Export-CSV "C:\temp\AD_Reports\Reports\AD_Groups\REPORT_security_group_managedby.csv" -NoTypeInformation -Encoding UTF8

## Sets the new "managed by" user to the DN in the script below for the security groups contained in the .csv 

Import-Csv "C:\temp\Scripts\AD_Scripts\Add\Update ManagedBy for Groups\Update_group_managedby.csv" | ForEach-Object {
    Set-ADGroup -Identity $_.Group -ManagedBy "CN=Shelby Mader-C,OU=TEST_GPO,OU=Temps & Consultants,DC=insmed,DC=local"
}

## Sets the new "managed by" user to blank for the security groups contained in the .csv 

Import-Csv "C:\temp\Scripts\AD_Scripts\Add\Update ManagedBy for Groups\Update_group_managedby.csv" | ForEach-Object {
    Set-ADGroup -Identity $_.Group -ManagedBy $null
}