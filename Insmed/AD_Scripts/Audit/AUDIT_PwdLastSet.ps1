get-aduser -Filter 'enabled -eq $true' -properties passwordlastset -SearchBase "DC=insmed,DC=local" | 
sort pwdlastset | select Name, passwordlastset, enabled | 
Export-csv -Path C:\Temp\REPORT_PwdLastSet.csv -NoTypeInformation -Encoding UTF8