#AD Auditing

#Get list of DLs

Get-ADGroup -filter {groupCategory -eq 'Distribution'} | Select Name,CanonicalName, DistinguishedName | Sort-Object Name | Export-Csv -Path C:\temp\AD_Reports\Reports\AD_Groups\Distribution_Lists.csv -NoTypeInformation -Encoding UTF8

#Get list of Security Groups

Get-ADGroup -filter {groupCategory -eq 'Security'} | Select Name,CanonicalName, DistinguishedName | Sort-Object Name | Export-Csv -Path C:\temp\AD_Reports\Reports\AD_Groups\Security_Groups.csv -NoTypeInformation -Encoding UTF8

#Get list of Security Groups by OU

$OU = 'OU=CEO,dc=insmed,dc=local'
# Use Get-AdUser to search within organizational unit to get users name
Get-ADGroup -Filter {groupCategory -eq 'Security'} -SearchBase $OU | Select-object Name,DistinguishedName |
Export-Csv -NoType 'C:\temp\AD_Reports\Reports\AD_Groups\Security_Groups_ADMINSITRATION_OU.csv'