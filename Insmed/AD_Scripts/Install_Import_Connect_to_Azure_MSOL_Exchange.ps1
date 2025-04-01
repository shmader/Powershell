
#Install, import, and connection strings for Microsoft Online services


#Azure AD

Install-Module -Name AzureAD -Scope CurrentUser

Import-Module AzureADJapan Compliance

Connect-AzureAD


#Exchange Online

Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser

Import-Module ExchangeOnlineManagement 

Connect-ExchangeOnline

#MSOL

Install-Module -Name MSOnline -Scope CurrentUser

Import-Module MSOnline

Connect-MsolService
