#To turn off Read-Only attribute on a file

Set-ItemProperty -Path "C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates\Author.dotm" -Name IsReadOnly -Value $False

