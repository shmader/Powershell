#Securely store credentials using PowerShell into a file. Run these below lines to store encrypted credentials into a text file. This is far better than storing the password in plain text.

$ADCred = Get-Credential
$ADCred.Password | ConvertFrom-SecureString | Out-File "C:\temp\ADCred_sec.txt"
$AzureAD = Get-Credential
$AzureAD.Password | ConvertFrom-SecureString | Out-File "C:\temp\AzureAD_sec.txt"