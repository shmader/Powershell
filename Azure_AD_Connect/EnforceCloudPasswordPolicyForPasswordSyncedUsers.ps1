######################################################################################################################
#
# EnforceCloudPasswordPolicyForPasswordSyncedUsers.ps1
#
# Shelby Mader, Novick Tech
# shelby@novick.tech
# November 2022
#
# Purpose: 
### Microsoft has released the EnforceCloudPasswordPolicyForPasswordSyncedUsers feature in February this year which was then in public preview. 
### When organizations don’t use this feature and sync their identities with password hash sync enabled, users with an expired password can continue working with their Azure AD account.
### With this feature, we reconcile our on prem AD and Azure AD password policy.
#
### https://www.bilalelhaddouchi.nl/index.php/2020/09/24/enforcecloudpasswordpolicyforpasswordsyncedusers/
#
## Requirements for Script to Run:
# - Must have MSOL and Azure AD admin credentials for connection
#
## Change Log:
# - Version 0.1 - Nov 2022
#
####################################################################################################################


### CONNECT

# Connect to Msol
Connect-MsolService

# Get list of enabled dirsync features and their status
Get-MsolDirSyncFeatures

# To enable the EnforceCloudPasswordPolicyForPasswordSyncedUsers, run the below command in your tenant:
Set-MsolDirSyncFeature -Feature EnforceCloudPasswordPolicyForPasswordSyncedUsers -Enable $true

# Update validity period and notification for domain
Set-MsolPasswordPolicy -ValidityPeriod 180 -NotificationDays 14 -DomainName "sjno.net"

#Check Password validity period and notification
Get-MsolPasswordPolicy -DomainName "sjno.net"

# Connect to Azure
Connect-AzureAD


### AUDITING

# Run the below command to check which user has a password expiration set, dirsync status, and account status for each user
### Get-AzureADUser -All $true | Select-Object UserPrincipalName,DirSyncEnabled, PasswordPolicies, AccountEnabled

# Additionally, you can run this line to find all enabled accounts in Azure with the same properties above, run the next line below to get the password expiry for MSOL users, then sort by
# username alphabetically and merge the two lists to get password expiry for all the cloud users. 
Get-AzureADUser -Filter "accountEnabled eq true" -All $true | Select-Object DisplayName,UserPrincipalName,DirSyncEnabled,PasswordPolicies,AccountEnabled | Export-csv -Path C:\Temp\Log\REPORT_Pwd_Expiry_Policy.csv -NoTypeInformation -Encoding UTF8 

Get-MsolUser -EnabledFilter EnabledOnly -ALL | Select DisplayName,UserPrincipalName,LastPasswordChangeTimeStamp | Export-csv -Path C:\Temp\Log\REPORT_PwdLastSet_MSOL.csv -NoTypeInformation -Encoding UTF8 

## Finally, this line will get you all of the dirsyncenabled and accountenabled accounts in Azure, but won't return password last set
## You can use this list to figure out any service account you DON'T want to include in the password policy because you don't want the password to expire
Get-AzureADUser -All $true | Where-Object { $_.DirSyncEnabled -eq $true -and $_.PasswordPolicies -eq ‘DisablePasswordExpiration’ } | Select-Object UserPrincipalName,DirSyncEnabled, PasswordPolicies, AccountEnabled | Export-csv -Path C:\Temp\Log\REPORT_Pwd_Expiry_Policy2.csv -NoTypeInformation -Encoding UTF8 



### ENFORCEMENT

# When you want to comply with the on-premise password expiration policy, the PasswordPolicies value should be set to None. 

# You should change the on-premise password for a user and start initial sync to get this done. After the sync, the value should change to “None.”
# Run the below command to change the value manually to “None” for a specific user:
### Set-AzureADUser -ObjectID testing2@sjno.net -PasswordPolicies None

#  Additionally, run the below command to update the value for all the users. Read the important notice below before running the command:
# ***Important note: If you have specific synchronized AD accounts, e.g., Service Accounts, that need non-expiring passwords in Azure AD, you must explicitly add the DisablePasswordExpiration value to the PasswordPolicies attribute.
Get-AzureADUser -All $true | Where-Object { $_.DirSyncEnabled -eq $true -and $_.PasswordPolicies -eq ‘DisablePasswordExpiration’ } | ForEach-Object {
Set-AzureADUser -ObjectId $_.ObjectID -PasswordPolicies None
}

# To set service accounts and other account you DO NOT want to have expiring passwords, run the following command for the specific user:
#Set-AzureADUser -ObjectID SERVICEACCOUNT@domain.com -PasswordPolicies DisablePasswordExpiration

# THEN, to set a .csv file of service accounts you DO NOT want to have expiring passwords, run the following command, changing the path/name of csv file
Import-Csv -Path c:\temp\Excluded_Service_Accounts.csv | ForEach-Object {
    Get-AzureADUser -ObjectId $_.ObjectID | Set-AzureADUser -PasswordPolicies None
}


#Run a Sync for AD Connect
Start-ADSyncSyncCycle -PolicyType Delta 


### OTHER AUDITING CMDS

# Run the below command to check which user has a password expiration set, dirsync status, and account status for each user
#Get-AzureADUser -All $true | Select-Object UserPrincipalName,DirSyncEnabled, PasswordPolicies, AccountEnabled

#Additionally, you can run this line to find all enabled accounts in Azure with the same properties above, run the next line below to get the password expiry for MSOL users, then sort by
# username alphabetically and merge the two lists to get password expiry for all the cloud users. 
Get-AzureADUser -Filter "accountEnabled eq true" -All $true | Select-Object DisplayName,UserPrincipalName,DirSyncEnabled,PasswordPolicies,AccountEnabled | Export-csv -Path C:\Temp\Log\REPORT_Pwd_Expiry_Policy.csv -NoTypeInformation -Encoding UTF8 
Get-MsolUser -EnabledFilter EnabledOnly -ALL | Select DisplayName,UserPrincipalName,LastPasswordChangeTimeStamp | Export-csv -Path C:\Temp\Log\REPORT_PwdLastSet_MSOL.csv -NoTypeInformation -Encoding UTF8 

## Finally, this line will get you all of the dirsyncenabled and accountenabled accounts in Azure, but won't return password last set
## You can use this list to figure out any service account you DON'T want to include in the password policy because you don't want the password to expire
#Get-AzureADUser -All $true | Where-Object { $_.DirSyncEnabled -eq $true -and $_.PasswordPolicies -eq ‘DisablePasswordExpiration’ } | Select-Object UserPrincipalName,DirSyncEnabled, PasswordPolicies, AccountEnabled | Export-csv -Path C:\Temp\Log\REPORT_Pwd_Expiry_Policy2.csv -NoTypeInformation -Encoding UTF8 

