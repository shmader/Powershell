Start-Transcript -Path C:\Users\Logs\Starting_Point_PS_log.txt

#Copy zipped folder from network share and unzip into a newly created directory

Expand-Archive -Path 'Starting_Point_Test_Share\StartingPoint_v5.6.1_IND.zip' -DestinationPath C:\StartingPoint\ -Force -Verbose

#To turn off Read-Only attribute on Author.dotm

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

#Runs certutil to install Accenture Cert into computer store under TrustedPublisher
# if you started this script without admin rights, this will first start a new console with admin rights then run the script below
# the original console will be closed
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # add -noexit before -encodedcommand to keep the admin console open after the script is run
    start powershell "-encodedcommand $([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script:MyInvocation.MyCommand.ScriptBlock)))" -Verb RunAs
    # comment this out to leave the non admin console open, but you'll not be needing it since a new one will open with admin rights
    # NOTE!: if you do comment this out, the rest of the script will be executed first as non admin, then again when the admin console appears
    # you could add another if statement down below saying if you're not admin, do something else, or add an else to this if statment
    exit
}

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

#Copies Cert to C:

Copy-Item -Path "\\misc2\Starting_Point_Test_Share\Accenture_StartingPoint_Publisher.cer" -Destination (New-item -Name "Cert" -Type Directory -Path "C:\StartingPoint\") -Force -Verbose

#Runs certutil to install Accenture Cert into computer store under TrustedPublisher
# if you started this script without admin rights, this will first start a new console with admin rights then run the script below
# the original console will be closed
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # add -noexit before -encodedcommand to keep the admin console open after the script is run
    start powershell "-encodedcommand $([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script:MyInvocation.MyCommand.ScriptBlock)))" -Verb RunAs
    # comment this out to leave the non admin console open, but you'll not be needing it since a new one will open with admin rights
    # NOTE!: if you do comment this out, the rest of the script will be executed first as non admin, then again when the admin console appears
    # you could add another if statement down below saying if you're not admin, do something else, or add an else to this if statment
    exit
}

#Adds certificate to store under Trusted Publisher

certutil.exe -addstore TrustedPublisher C:\StartingPoint\Cert\Accenture_StartingPoint_Publisher.cer