# Enable/Disable Accelerated Networking on Azure VM
# https://thesleepyadmins.com/2022/03/05/enable-accelerated-networking-on-existing-azure-vms/

#Set your execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#Install the Azure Module 
Install-Module -Name Az

#Update the module
Update-Module Az.*

#Disable login by WAM (will open a browser for auth instead)
Update-AzConfig -EnableLoginByWam $false

#Auth with your Azure Admin acct
Connect-AzAccount

#Check that your resource has the same subscription assigned to it
get-azcontext

#Set the correct subscription based on the Azure resource you are trying to modify
Set-azcontext -Subscription "0d210278-89fb-4569-9040-3cac0c37c3d6"

#Check if the NIC for your resource has Accelerated Networking Enabled or Disabled
Get-AzNetworkInterface -ResourceGroupName rg-coreinfra-prod-001 | Select-Object Name,EnableAcceleratedNetworking


#Change the ResourceGroupName, Name (for your NIC), and value to T or F for EnabledAccelerated Networking
$networkacc = Get-AzNetworkInterface -ResourceGroupName rg-coreinfra-prod-001 -Name nt-cove-workbench981_z1
$networkacc.EnableAcceleratedNetworking = $false
$networkacc | Set-AzNetworkInterface