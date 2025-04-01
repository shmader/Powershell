##### PSPKI and PSPKIAudit Commands

#SHELBY NOTES

Download the module from GitHub and extract it to C:\Temp\PSPKI

#Import the module 

cd C:\temp\PSPKI

Get-ChildItem -Recurse | Unblock-File

Import-Module -Verbose .\PSPKIAudit.psm1

# Open an administrative Powershell window and run the following to begin PSPKI-Audit:
Invoke-PKIAudit 
 
# If you want your results to be put into a txt file, run the following command:
Get-AuditCertificateAuthority [-CAComputerName CA.DOMAIN.COM | -CAName X-Y-Z] | Export-Csv -NoTypeInformation CAs.csv





# PSPKI: https://github.com/PKISolutions/PSPKI
# PSPKI: https://www.powershellgallery.com/packages/PSPKI/3.7.2
# PSPKI: https://www.pkisolutions.com/tools/pspki/

###### For Server 2012 R2
# Download PSPKI from github link above, drop into path similar to below
# Import-Module 'C:\temp\PKI\PSPKI\PSPKI-master(1)\PSPKI-master\PSPKI\PSPKI.psd1'

##### For Server 2016/2019
# Install this package using PowerShellGet
# Install-Module -Name PSPKI

# Import PSPKI module
# Import-Module PSPKI


# When all else fails, run the following two cmds to get going
# Install-Module -Name PSPKI
# Import-Module PSPKI

Get-Command -Module PSPKI


# NT-Root-CA / CA01
# NT-Issuing-CA / CA02

$CA = "INS700VMICA01.insmed.local"

# $template1 = "1.3.6.1.4.1.311.21.8.14819760.9374725.4669610.548711.2455387.203.9248192.10735212"
# $template2 = ""
# $template3 = ""

Get-CertificationAuthority | fl *

Get-CertificateTemplate | fl *

# Get-CertificateTemplate | Where-Object Name -eq "AirwatchCEP" | fl *


# $certs = Get-IssuedRequest -CertificationAuthority $CA | Where-Object CertificateTemplate -eq $template1

# $certs = Get-IssuedRequest -CertificationAuthority $CA -filter "CertificateTemplate -eq $template1"

$certs = Get-IssuedRequest -CertificationAuthority $CA -filter "CertificateTemplate -eq _NT_Web_Server"


$certs | Export-Csv C:\temp\pki\test1.csv

# Check for HTTP enrollment endpoints with PSPKI
get-certificationauthority | select Name,Enroll* | fl *


# Loop through all CA's looking for certs issued from specific template with specific validity date

$certs = ""
$CAs = Get-CertificationAuthority

foreach ($CA in $CAs){

$certs = Get-IssuedRequest -CertificationAuthority $CA -filter "CertificateTemplate -eq LDAPoverSSL", "NotAfter -ge $(Get-Date)"

}

$certs | Export-Csv C:\temp\pki\test1.csv


#Need to run the $CA= line to populate the variable before running 

$certs = Get-IssuedRequest -CertificationAuthority $CA -filter "CertificateTemplate -eq LDAPoverSSL", "NotAfter -ge $(Get-Date)"

#Then you can just run $certs by itself after running the entire line to load the results from the above line 