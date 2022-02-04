#####################################################################################################################
#
# DO_NOT_RUN.ps1
#
# Shelby Mader, Novick Tech
# shelby@novick.tech
# February 2021
#
# Purpose: 
# - Unzips StartingPoint_v5.6.1_IND and moves to a new directory StartingPoint at root of C:
# - Turns off "read only" on author.dotm file
# - Turns on file explorer extensions
# - Adds "Developer" tab to the ribbon in Word
# - Sets Word macro security settings to "Disable all macros except digitally signed macros"
# - Sets the workgroup shared templates in Word to the following path - StartingPoint\StartingPoint_v5.6.1_IND\Templates
# - Imports Accenture_StartingPoint_Publisher.cer to the local computer certificate store under "Trusted Publisher"
# - 
#
## Requirements for Script to Run:
# - Set execution policy must allow scripts
#
## Change Log:
# - Version 0.1 - February 2021
#
####################################################################################################################



# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
    }
}

#Sets relative path where script is located
$MyDir = (Split-Path $MyInvocation.MyCommand.Path)
# "-----> $MyDir"

Start-Transcript -Path $MyDir\Starting_Point_PS_log.txt

# Copy zipped file StartingPoint_v5.6.1_INC.zip from the unzipped Starting_Point_Installer_Package
Expand-Archive -Path $MyDir\StartingPoint_v5.6.1_IND.zip -DestinationPath C:\StartingPoint\ -Force -Verbose

# Turns off Read-Only attribute on Author.dotm
Set-ItemProperty -Path "C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates\Author.dotm" -Name IsReadOnly -Value $False -Verbose

# Set variables to indicate value and key - Turns on File Explorer extensions
$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$Name         = 'HideFileExt'
$Value        = '0'
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose
Stop-Process -processname explorer -Verbose

# Set variables to indicate value and key - Adds Developer Tab to ribbon in Word
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Word\Options'
$Name         = 'DeveloperTools'
$Value        = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now sets the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose

# Set variables to indicate value and key - Sets macro security settings
$RegistryPath = 'HKCU:\Software\Microsoft\Office\16.0\Word\Security'
$Name         = 'VBAWarnings'
$Value        = '3'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose

# Set variables to indicate value and key (requires elevation)  - Sets workgroup templates path in Word
$RegistryPath = 'HKCU:\Software\Policies\Microsoft\office\16.0\common\general'
$Name         = 'sharedtemplates'
$Value        = 'C:\'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType ExpandString -Force -Verbose

# Adds certificate to store under Trusted Publisher
Import-Certificate -FilePath "$MyDir\Accenture_StartingPoint_Publisher.cer" -CertStoreLocation Cert:\LocalMachine\TrustedPublisher


#Checks log file for any errors and pop up dialogue box for user that script ran succesfully or ran with errors.
$SEL = get-content $MyDir\Starting_Point_PS_log.txt
if( $SEL -imatch "error" ) 
{
   Write-Host 'Contains String'
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("Script completed with errors. Please contact your adminitrator")
}
else
{
   Write-Host 'Does not contain String'
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("Script has completed! Click OK to exit.")
}