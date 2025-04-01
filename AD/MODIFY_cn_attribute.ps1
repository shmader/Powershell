
# set needed variables
$dn="CN=Mary,OU=User,OU=SJNO_Accounts,DC=sjno,DC=net"
$newCN="Mary"

#changes the 'name' attribute you can't change via UI
Rename-ADObject -Identity $dn -NewName $new
