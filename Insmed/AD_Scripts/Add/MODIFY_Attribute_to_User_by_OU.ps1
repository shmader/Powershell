$users = get-adobject -filter {objectclass -eq "user"} -searchbase "<Distinguished Name of the OU>"

foreach ($User in $users)
{
    Set-ADObject $user -replace @{msExchHideFromAddressLists=$true}
}


