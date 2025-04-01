# Manual rotation of kerberos decryption key for Azure SSO computer account
# https://azurecloudai.blog/2020/08/03/roll-over-kerberos-decryption-key-for-seamless-sso-computer-account/

__________________________________________________

#Open Windows PowerShell and navigate to the “Microsoft Azure Active Directory Connect” folder:

cd 'C:\Program Files\Microsoft Azure Active Directory Connect\'

#Import the Seamless SSO PowerShell module:

Import-Module .\AzureADSSO.psd1

#Now run the following command to authenticate with Azure AD using your Global Administrator credentials:

New-AzureADSSOAuthenticationContext

#We can view the current list of Active Directory forests that have Seamless SSO enabled. This is useful when you have multiple Active Directory forests synchronizing to the same Azure AD tenant:

Get-AzureADSSOStatus | ConvertFrom-Json

#Run the following command to update the Kerberos decryption key for the target forest. You will be prompted to provide credentials.
#Provide the domain administrator credentials for the root domain in the target forest. It has to be entered in the “domain\samaccountname” format otherwise it will not work.

Update-AzureADSSOForest

#You can check the AZUREADSSOACC computer object in AD UC to make sure the pwdlastset has been updated