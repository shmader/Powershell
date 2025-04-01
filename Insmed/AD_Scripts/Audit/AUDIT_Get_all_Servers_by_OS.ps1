Import-Module ActiveDirectory
Search-ADAccount  -SearchBase "OU=Disabled Users,DC=insmed,DC=local" –AccountDisabled -UsersOnly |
 Select -Property Name,DistinguishedName,Enabled,LastLogonDate |
 Export-CSV "C:\temp\Logs\DisabledADUsers.csv" -NoTypeInformation -Encoding UTF8