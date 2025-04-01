﻿$users = Get-ADUser -SearchBase "OU=Cognizant Users,OU=External Users,DC=insmed,DC=local" -SearchScope Subtree -Filter * -Properties UserPrincipalName,LastLogonDate | Export-CSV "C:\Temp\Logs\Cognizant_Users_Last_Logon.csv" -NoTypeInformation -Encoding UTF8