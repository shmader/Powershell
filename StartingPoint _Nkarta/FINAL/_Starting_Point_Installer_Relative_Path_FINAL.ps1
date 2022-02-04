
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
    }
}

$MyDir = (Split-Path $MyInvocation.MyCommand.Path)
# "-----> $MyDir"

Start-Transcript -Path $MyDir\Starting_Point_PS_log.txt

# Copy zipped folder from network share and unzip into a newly created directory
Expand-Archive -Path $MyDir\StartingPoint_v5.6.1_IND.zip -DestinationPath C:\StartingPoint\ -Force -Verbose

# To turn off Read-Only attribute on Author.dotm
Set-ItemProperty -Path "C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates\Author.dotm" -Name IsReadOnly -Value $False -Verbose

# Set variables to indicate value and key to set - Turns on File Explorer extensions
$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$Name         = 'HideFileExt'
$Value        = '0'
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose
Stop-Process -processname explorer -Verbose

# Set variables to indicate value and key to set - Adds Developer Tab to ribbon in Word
$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Word\Options'
$Name         = 'DeveloperTools'
$Value        = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose

# Set variables to indicate value and key to set - Sets macro security settings
$RegistryPath = 'HKCU:\Software\Microsoft\Office\16.0\Word\Security'
$Name         = 'VBAWarnings'
$Value        = '3'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force -Verbose

# Runs certutil to install Accenture Cert into computer store under TrustedPublisher
# Set variables to indicate value and key to set - Sets workgroup templates path in Word
$RegistryPath = 'HKCU:\Software\Policies\Microsoft\office\16.0\common\general'
$Name         = 'sharedtemplates'
$Value        = 'C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType ExpandString -Force -Verbose

# Adds certificate to store under Trusted Publisher
Import-Certificate -FilePath "$MyDir\Accenture_StartingPoint_Publisher.cer" -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

#Create dialogue box popup
$wshell = New-Object -ComObject Wscript.Shell
$Output = $wshell.Popup("Success!")