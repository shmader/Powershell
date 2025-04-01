#This script allows you to add a DL to the attribute dLMemSubmitPerms of another DL
#This may be needed when EOL environment used to be on prem or hybrid and on prem DLs still and exist and are syncing to EOL, but the on prem Exchange server is deprecated
#You cannot edit the attribute directly in AD, so you must connect to MSOL to update the attribute and add send as permisisons

#MSOL Install, import, and connection if needed

Install-Module -Name MSOnline -Scope CurrentUser

Import-Module MSOnline

Connect-MsolService


#Run this line to get the DN for the distribution list you are trying to add to the other distribution list (Can also add invdividual users)

(Get-ADGroup -Identity “Groupname”).DistinguishedName

#Set your first CN= to the list you want to add to and the second CN= to the DL you want to add to the attribute dLMemSubmitPerms

Set-ADObject “CN=Insmed-Japan,CN=Users,DC=insmed,DC=local” -Add @{dLMemSubmitPerms=”CN=Japan Compliance,CN=Users,DC=insmed,DC=local”}