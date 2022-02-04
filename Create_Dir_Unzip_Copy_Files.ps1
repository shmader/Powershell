#Create new directory where your unzipped files will be copied to

New-Item -Path "c:\" -Name "StartingPoint"-ItemType "directory" -force

#To unzip and folder to a new directory

Expand-Archive -LiteralPath 'C:\Users\shelby\StartingPointv5.6.1_IND.zip' -DestinationPath C:\StartingPoint

#To turn off Read-Only attribute on Author.dotm

Set-ItemProperty -Path "C:\StartingPoint\StartingPoint v5.6.1 IND\Templates\Author.dotm" -Name IsReadOnly -Value $False