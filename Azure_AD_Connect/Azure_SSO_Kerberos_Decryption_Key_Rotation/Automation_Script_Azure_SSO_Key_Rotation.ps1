#Enter the domain user and Azure AD user which has necessary permissions in this below script and save it. Recommend creating the following service accounts to run the script:

# On prem AD service account with "logon as batch job" and local administrator permissions on the AD Connect server
# O365 service account with Global Administrator and MFA disabled (can use CAP to restrict MFA disable based on the source IP of the AD Connect server if you have licensing to turn on Global Secure Access feature)

$ADUser = 'SJNO\azuressotest' #Must be entered in the SAM account name format contoso.com\jdoe
$ADUserEncrypted = Get-Content "C:\temp\ADCred_sec.txt" | ConvertTo-SecureString
$OnPremADCred = New-Object System.Management.Automation.PsCredential($ADUser,$OnPremADCred)

$AzureADUser = 'azuretest@sjnonet.onmicrosoft.com'
$AzureADUserEncrypted = Get-Content "C:\temp\AzureAD_sec.txt" | ConvertTo-SecureString
$AzureADCred = New-Object System.Management.Automation.PsCredential($AzureADUser,$AzureADUserEncrypted)

Import-Module 'C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1'
New-AzureADSSOAuthenticationContext -CloudCredentials $AzureADCred
Update-AzureADSSOForest -OnPremCredentials $OnPremADCred