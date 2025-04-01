Get-ADComputer -Filter * -SearchBase "DC=insmed,DC=local" -Properties *  |
 Select -Property Name,DNSHostName,Enabled,DistinguishedName,LastLogonDate | 
 Export-CSV "C:\Temp\Logs\AllComputers.csv" -NoTypeInformation -Encoding UTF8