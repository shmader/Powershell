$OUpath = 'OU=Service Accounts All,DC=insmed,DC=local'
$ExportPath = 'C:\temp\AD_Reports\Reports\Service_Accounts\Service_Accounts_All.csv'
Get-ADUser -Filter * -Properties description -SearchBase $OUpath | Select-object UserPrincipalName, description | Export-Csv -NoType $ExportPath
