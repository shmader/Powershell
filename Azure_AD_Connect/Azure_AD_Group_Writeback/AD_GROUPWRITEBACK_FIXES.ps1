###################################
# Azure Active Directory PowerShell for Graph Preview module
# The Azure Active Directory PowerShell for Graph Preview module can be downloaded and installed from the PowerShell Gallery, www.powershellgallery.com

 

# Must uninstall AzureAD module before you can install AzureADPreview Module
Uninstall-Module AzureAD

 

Install-Module AzureADPreview

 

Connect-AzureAD

 

####### Group Writeback Testing 12/16/2022

 

### Disable automatic writeback of all Microsoft 365 groups via "UnifiedGroupWriteback" (group writeback V1): https://learn.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-modify-group-writeback#disable-automatic-writeback-of-all-microsoft-365-groups

 

# Create NEW setting (will not work if setting already exists)

 

    $TemplateId = (Get-AzureADDirectorySettingTemplate | where {$_.DisplayName -eq "Group.Unified" }).Id 
    $Template = Get-AzureADDirectorySettingTemplate | where -Property Id -Value $TemplateId -EQ 
    $Setting = $Template.CreateDirectorySetting() 
    $Setting["NewUnifiedGroupWritebackDefault"] = "False" 
    New-AzureADDirectorySetting -DirectorySetting $Setting

 

# Modify EXISTING setting
    Get-AzureADDirectorySetting | fl
    # Then record the Setting ID value

 

    $TemplateId = (Get-AzureADDirectorySettingTemplate | where {$_.DisplayName -eq "Group.Unified" }).Id 
    $Template = Get-AzureADDirectorySettingTemplate | where -Property Id -Value $TemplateId -EQ 
    $Setting = $Template.CreateDirectorySetting() 
    $Setting["NewUnifiedGroupWritebackDefault"] = "False"

 

    Set-AzureADDirectorySetting -DirectorySetting $Setting -Id a188fd6a-0a66-48ca-b103-43987077024e # (ID value reorded from pervious step)

 

#######