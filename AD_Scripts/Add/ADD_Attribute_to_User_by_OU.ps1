﻿Get-ADUser -filter * -SearchBase "OU=Cloud Team,OU=IT Admins,DC=insmed,DC=local" | Set-ADUser -Add @{MSExchExtensionCustomattribute1="HideFromGAL"}