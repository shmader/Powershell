Set-ADUser -Identity user.name -Replace @{pwdlastset="0"}
Set-ADUser -Identity user.name -Replace @{pwdlastset="-1"}