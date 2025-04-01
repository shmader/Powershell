$OUpath = 'CN=Users,DC=insmed,DC=local'
$ExportPath = 'C:\temp\AD_Reports\Reports\Service_Accounts\Users_Service_Accounts.csv'
Get-ADUser -Filter  {(objectClass -eq "user")} -Properties description -SearchBase $OUpath | Select-object UserPrincipalName, description | Export-Csv -NoType $ExportPath

## filter by object class (like user, security group, etc..)
# -Filter  {(objectClass -eq "user")}

#$OUpath = 'OU=Service Accounts All,DC=insmed,DC=local'
#$ExportPath = 'C:\temp\AD_Reports\Reports\Service_Accounts\Service_Accounts_All.csv'
#Get-ADUser -Filter  {(objectClass -eq "user")} -Properties description -SearchBase $OUpath | Select-object UserPrincipalName, description | Export-Csv -NoType $ExportPath