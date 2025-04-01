
#########################################################################################################################################
#### CONNECT TO MSOL SERVICE (Azure AD v1 Module) ####

#import msol module
ipmo msonline

#check msol module version
(get-item C:\Windows\System32\WindowsPowerShell\v1.0\Modules\MSOnline\Microsoft.Online.Administration.Automation.PSModule.dll).VersionInfo.FileVersion

#connect
$cred = Get-Credential
connect-msolservice -credential $cred

Get-MsolUser -All | Select DisplayName,UserPrincipalName,LastPasswordChangeTimeStamp,pwdlastset | sort LastPasswordChangeTimestamp

Get-MsolUser -ObjectId relay@novicktech.onmicrosoft.com | Select DisplayName,UserPrincipalName,LastPasswordChangeTimeStamp

Get-MsolUser -userprincipalname jordan@novick.tech | select DisplayName, LastPasswordChangeTimeStamp,@{Name=”PasswordAge”;Expression={(Get-Date)-$_.LastPasswordChangeTimeStamp}}

Get-MsolUser -userprincipalname jordan@novick.tech | select DisplayName, LastPasswordChangeTimeStamp,@{Name=”PasswordAge”;Expression={(Get-Date)-$_.LastPasswordChangeTimeStamp}}`

Get-MsolUser -userprincipalname jordan@novick.tech | fl




##### PASSWORD POLICY
Get-MsolPasswordPolicy -DomainName novicktech.onmicrosoft.com
Get-MsolPasswordPolicy -DomainName novick.tech
Get-MsolPasswordPolicy -DomainName sjno.net
Get-MsolPasswordPolicy -DomainName hancockcountyfoodpantry.com
Get-MsolPasswordPolicy -DomainName 1776arms.com
Get-MsolPasswordPolicy -DomainName ipkek.com

Set-MsolPasswordPolicy -DomainName novick.tech -ValidityPeriod 2147483647 -NotificationDays 14
Set-MsolPasswordPolicy -DomainName sjno.net -ValidityPeriod 2147483647 -NotificationDays 14


#########################################################################################################################################
### Connect to Azure AD v2 Module ###
# Reference: https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell?view=o365-worldwide
# Run only once to install
# Install-Module -Name AzureAD

# Connect-AzureAD

# Get all attributes of a single user:
Get-AzureADUser -ObjectId relay@novicktech.onmicrosoft.com | fl

# Get password policy of a single user:
(Get-AzureADUser -objectID jordan@novick.tech).passwordpolicies
(Get-AzureADUser -objectID mary@novick.tech).passwordpolicies
(Get-AzureADUser -objectID admin@novicktech.onmicrosoft.com).passwordpolicies
(Get-AzureADUser -objectID relay@novicktech.onmicrosoft.com).passwordpolicies

Get-AzureADUser -objectID admin@novicktech.onmicrosoft.com | fl

# To see the Password never expires setting for all users, run the following cmdlet:
Get-AzureADUser -All $true | Select-Object UserprincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
 }

# To set the password of one user to never expire, run the following cmdlet by using the UPN or the user ID of the user:
Set-AzureADUser -ObjectId relay@novicktech.onmicrosoft.com -PasswordPolicies DisablePasswordExpiration
Get-AzureADUser -ObjectId mary@novick.tech -PasswordPolicies

# To enable the EnforceCloudPasswordPolicyForPasswordSyncedUsers feature
Set-MsolDirSyncFeature -Feature EnforceCloudPasswordPolicyForPasswordSyncedUsers -Enable $False

Set-MsolDirSyncFeature -Feature EnforceCloudPasswordPolicyForPasswordSyncedUsers


# Get status of all MSOL DirSync features
Get-MsolDirSyncFeatures


#########################################################################################################################################
### CONNECT TO EXCHANGE ONLINE (EAC) SERVICE (v1 Module) ###

$cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session


Get-TransportConfig | ft SmtpClientAuthenticationDisabled


# Un-hide Teams-created groups from Outlook clients
Get-UnifiedGroup
Set-UnifiedGroup -Identity 'IT_092e78de-ab1f-4ac6-b519-c9bbb4d993ad' -HiddenFromAddressListsEnabled $false


###################################

#########################################################################################################################################
### Connect to Exchange Online with Exchange Online PowerShell V2 module ###
# Reference: https://docs.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps#connect-to-exchange-online-powershell-without-using-mfa
# Run only once to install
# Install-Module -Name ExchangeOnlineManagement

Import-Module ExchangeOnlineManagement

# Use the it@ahhe.com account
$UserCredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true



###################################








Get-MsolAccountSku


get-msoluser -userprincipalname jbarnett@omnisite.com | select lastpasswordchangetimestamp