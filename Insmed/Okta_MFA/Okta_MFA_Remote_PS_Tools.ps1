######################################################################################################################
#
# Okta_MFA_Remote_PS_Tools.ps1
#
# Shelby Mader, Insmed
# shelby.mader@insmed.com
# December 2022
#
# Purpose: 
# - Adds a registry value for Okta Credential Provider to disable it temporarily (for staging install or for rolling back if you can't access the server)
# - Remove registry value for Okta Crednetial Provider when ready to make Okta MFA for RDP live
#
## Requirements for Script to Run:
# - None
#
## Change Log:
# - Version 0.1 - December 2022
#
####################################################################################################################

#Run this line to begin a remote powershell session to a specific server
Enter-PSSession

#Run this line to get a list of credential providers
reg query "hklm\software\microsoft\windows\currentversion\authentication\Credential Provider Filters"

#Copy one of the values from the previous line including the brackets (e.g. {6D269AEA-159E-4F45-BC6A-02AA9C14F310}) into the line below to determine which one is the Okta Credential Provider 
reg query "hklm\software\microsoft\windows\currentversion\authentication\Credential Providers\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}"

reg query "hklm\software\microsoft\windows\currentversion\authentication\Credential Provider Filters\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}"


#Once you have identified which value is the Okta Credential provider, copy and paste that same value (e.g. {6D269AEA-159E-4F45-BC6A-02AA9C14F310}) into the line below and run to disable this credential provider
reg add "hklm\software\microsoft\windows\currentversion\authentication\Credential Providers\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}" /f /v Disabled /t REG_DWORD /d 1

reg add "hklm\software\microsoft\windows\currentversion\authentication\Credential Provider Filters\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}" /f /v Disabled /t REG_DWORD /d 1


#When ready to go LIVE, you can enable the Okta Credential Provider by deleting the registry value you created from line 11. Be sure the value (e.g. {6D269AEA-159E-4F45-BC6A-02AA9C14F310}) for the credential provider matches from line 11
reg delete "hklm\software\microsoft\windows\currentversion\authentication\Credential Providers\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}" /f /v Disabled

reg delete "hklm\software\microsoft\windows\currentversion\authentication\Credential Provider Filters\{6D269AEA-159E-4F45-BC6A-02AA9C14F310}" /f /v Disabled


#Run this line to exit PS session
Exit-PSSession
