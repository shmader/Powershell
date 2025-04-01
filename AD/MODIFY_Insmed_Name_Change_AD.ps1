## Rename-ADObject — allows you to change the values of the attributes: cn, distinguishedName, name;
## Set-ADUser — allows you to change samAccountName, UPN, given name, surname, and other names of a user.

Rename-ADObject –identity “CN=Name Change,OU=Sync,OU=NT_Accounts,DC=Novick,DC=Tech” -NewName "Name Modify"

Get-ADUser name.change | Set-ADUser –displayname “Name Modify” –SamAccountName name.modify –Surname “Modify” -UserPrincipalName name.modify@novick.tech