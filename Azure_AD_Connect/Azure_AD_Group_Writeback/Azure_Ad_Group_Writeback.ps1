######################################################################################################################
#
# Azure_AD_Group_Writeback.ps1
#
# Shelby Mader, Novick Tech
# shelby@novick.tech
# November 2022
#
# Purpose: 
### Group writeback is a feature that allows you to write cloud groups back to your on-premises Active Directory instance by using Azure Active Directory (Azure AD) Connect sync.
#
### https://identity-man.eu/2022/07/05/using-the-new-group-writeback-functionality-in-azure-ad/
#
## Requirements for Script to Run:
# - Must have Azure AD admin credentials for connection
# - Must have permission for all scopes with your admin account in Microsoft Graph
#
## Change Log:
# - Version 0.1 - Nov 2022
#
####################################################################################################################


#Connect to Azure tenant with global admin
Connect-AzureAD



### INSTALL TOOLS

#Install MSIdentity Tools module
Install-Module -Name MSIdentityTools -RequiredVersion 2.0.16

#Install Microsoft Graph for all users
Install-Module Microsoft.Graph -Scope AllUsers





### AUDIT

#Get currently enabled features
Get-ADSyncAADCompanyFeature

#Get the default writeback settings for newly created Microsoft 365 groups (Default is set to automatically writeback new groups)
#If you get nothing back from this line, it means you’re using the default directory settings, which is to enable group writeback for newly created groups, which is the desired behavior.
(Get-AzureADDirectorySetting | ? { $_.DisplayName -eq "Group.Unified"} | FL *).values

#Discover the current writeback settings for existing Microsoft 365 groups
#Go to https://developer.microsoft.com/en-us/graph/graph-explorer
#Run the following command https://graph.microsoft.com/beta/groups?$filter=groupTypes/any(c:c eq 'Unified')&$select=id,displayName,writebackConfiguration
#If it comes back with “null” for WritebackConfiguration, that means group writeback is not enabled.

#Get list of groups in Azure and their group type
#Connect-MgGraph -Scopes 'Group.Read.All'
#Get-MgGroup | 
#  Format-List Id,DisplayName,Description,GroupTypes
 
#Get group list with ALL properties
#Connect-MgGraph -Scopes 'Group.Read.All'
#Get-MgGroup | 
#  Format-List -Property *

#Get list of Azure AD groups with object ID
#get-azureadgroup

#Get an easy to read list of all groups 
Connect-MgGraph -Scopes 'Group.Read.All'
Get-MgGroup -ConsistencyLevel eventual -Count groupCount


### CUTOVER

## Set writeback for existing Microsoft 365 groups
#This was not tested and also is probably not necessary as the next script will achieve the same goal, which is to be able to remove groups from AD by selecting "no writeback" on the group in Azure

#Import-module
Import-module Microsoft.Graph

#Connect to MgGraph Beta
Connect-MgGraph -Scopes Group.ReadWrite.All
Select-MgProfile -Name beta

#Retrieve all Groups
$Groups = Get-MgGroup -All | where {$_.GroupTypes -like "*unified*"}

Foreach ($group in $groups) {
	Update-MgGroup -GroupId $group.id -WritebackConfiguration @{isEnabled=$false}
}



# Configure to delete groups when they're disabled for writeback or soft deleted

#Disable the Azure AD Connect Sync Scheduler:
Set-ADSyncScheduler -SyncCycleEnabled $false  


#Make sure to check the Synchronization Rules Editor to find a number that doesn't have a rule yet

import-module ADSync 
$precedenceValue = Read-Host -Prompt "Enter a unique sync rule precedence value [0-99]" 

New-ADSyncRule  `
-Name 'In from AAD - Group SOAinAAD Delete WriteBackOutOfScope and SoftDelete' `
-Identifier 'cb871f2d-0f01-4c32-a333-ff809145b947' `
-Description 'Delete AD groups that fall out of scope of Group Writeback or get Soft Deleted in Azure AD' `
-Direction 'Inbound' `
-Precedence $precedenceValue `
-PrecedenceAfter '00000000-0000-0000-0000-000000000000' `
-PrecedenceBefore '00000000-0000-0000-0000-000000000000' `
-SourceObjectType 'group' `
-TargetObjectType 'group' `
-Connector 'b891884f-051e-4a83-95af-2544101c9083' `
-LinkType 'Join' `
-SoftDeleteExpiryInterval 0 `
-ImmutableTag '' `
-OutVariable syncRule

Add-ADSyncAttributeFlowMapping  `
-SynchronizationRule $syncRule[0] `
-Destination 'reasonFiltered' `
-FlowType 'Expression' `
-ValueMergeType 'Update' `
-Expression 'IIF((IsPresent([reasonFiltered]) = True) && (InStr([reasonFiltered], "WriteBackOutOfScope") > 0 || InStr([reasonFiltered], "SoftDelete") > 0), "DeleteThisGroupInAD", [reasonFiltered])' `
 -OutVariable syncRule

New-Object  `
-TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition' `
-ArgumentList 'cloudMastered','true','EQUAL' `
-OutVariable condition0

Add-ADSyncScopeConditionGroup  `
-SynchronizationRule $syncRule[0] `
-ScopeConditions @($condition0[0]) `
-OutVariable syncRule

New-Object  `
-TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.JoinCondition' `
-ArgumentList 'cloudAnchor','cloudAnchor',$false `
-OutVariable condition0

Add-ADSyncJoinConditionGroup  `
-SynchronizationRule $syncRule[0] `
-JoinConditions @($condition0[0]) `
-OutVariable syncRule

Add-ADSyncRule  `
-SynchronizationRule $syncRule[0]

Get-ADSyncRule  `
-Identifier 'cb871f2d-0f01-4c32-a333-ff809145b947'


#Enable the Azure AD Connect Sync Scheduler again:
Set-ADSyncScheduler -SyncCycleEnabled $true   




#For the actual cutover, recommend following the MS guide and use the Azure AD Connect Wizard to enable Universal Group Writeback initially and select which OU you want to sync to
#https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-group-writeback-enable#enable-group-writeback-by-using-the-azure-ad-connect-wizard


#Then, after a full sync finishes, enable GroupWritebackV2 - Make sure there is no active sync cycle happening before you run this
Import-Module 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'
Set-ADSyncScheduler -SyncCycleEnabled $false
Set-ADSyncAADCompanyFeature -GroupWritebackV2 $true
Set-ADSyncScheduler -SyncCycleEnabled $true

#Do another full sync after this
Start-ADSyncSyncCycle -PolicyType Initial

#Once the sync finishes, you must go to Azure AD portal and turn on group writeback for EACH group you wish to enable it for.
#Also note that Microsoft 365 groups have multiple options for the type of group they can writeback as - Security, Mail Enabled Security, Distribution (default for all groups in V1 of group writeback)