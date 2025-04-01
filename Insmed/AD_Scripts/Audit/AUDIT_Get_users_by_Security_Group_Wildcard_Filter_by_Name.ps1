$ExportPath = 'C:\temp\AD_Reports\Qlik_Users\Zscaler - Commercial Operations - Commerical Management - EU.csv'
Get-ADGroupMember -Identity "Zscaler - Commercial Operations - Commerical Management - EU" | Select Name, userPrincipalName, sAMAccountName | Export-Csv -NoType $ExportPath


$adgroups = Get-ADGroup -Filter "name -like '*Qlik*'" | sort name

$data = foreach ($adgroup in $adgroups) {
    $members = $adgroup | get-adgroupmember | sort name
    foreach ($member in $members) {
        [PSCustomObject]@{
            Group   = $adgroup.name
            Members = $member
        }
    }
}

$data | export-csv "C:\temp\AD_Reports\Qlik_Users\test.csv" -NoTypeInformation