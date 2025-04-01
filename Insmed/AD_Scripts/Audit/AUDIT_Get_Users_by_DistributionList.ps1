$DGName = "CN=InsmedIT- All,CN=Users,DC=insmed,DC=local"
Get-ADGroupMember -Identity $DGName | Select Name, PrimarySMTPAddress |
Export-CSV "C:\temp\AD_Reports\Reports\AD_Groups\All.InsmedIT-List-Members.csv" -NoTypeInformation -Encoding UTF8