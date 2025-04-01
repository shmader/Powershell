#This script searches an OU for a specific UPN suffix and replaces those with a new suffix.
#
#

$OldUPN = Get-ADUser -Filter {UserPrincipalName -like '*insmed.local'} -SearchBase "DC=insmed,DC=local" -Properties UserPrincipalName -ResultSetSize $null
$OldUPN | foreach {$newUpn = $_.UserPrincipalName.Replace("insmed.local","insmed.com"); $_ | Set-ADUser -UserPrincipalName $newUpn}