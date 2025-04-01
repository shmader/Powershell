$OUpath = 'OU=Conference Room PCs,OU=Insmed Encrypted Computers,DC=insmed,DC=local' 
$ExportPath = 'c:\temp\Conference_Room_PCs.csv'
Get-ADComputer -Filter * -SearchBase $OUpath | Select-object Name,DistinguishedName,DNSHostName | Export-Csv -NoType $ExportPath


Get-ADComputer -Filter * -SearchBase 'OU=Insmed Lab Computers,DC=insmed,DC=local'