﻿$is64bit = [IntPtr]::Size * 8 -eq 64
Write-Host "Is 64-bit script: $is64bit"
#helper function to check for if 0x800 bit is set
function checkTls12Bit([Int] $regValue) {
    return ($regValue -band 0x800) -ne 0x800
}
	
function setRegKeyToBitValue([string] $regBranch, [string] $regKey) {
    $current = Get-ItemProperty -Path $regBranch -ErrorAction SilentlyContinue
    if ($current -eq $null) {
        Write-Host "$regBranch\$regKey does not exist. No change." 
	    return $false
    }
    $regValue = $current.$regKey
	if ($regValue -eq $null -or (checkTls12Bit $regValue) ) {
	    if ($regValue -eq $null) {
	       $regValue = 0x800
	     } else    {
	         $regValue = $regValue -bor 0x800
	      }
	
	     $p = New-ItemProperty $regBranch -Name $regKey -PropertyType DWord -Value $regValue -ErrorAction Stop -Force
	     Write-Host "Updated $regBranch\$regKey value to $regValue" 
	     return $true
	}
	Write-Host "$regBranch\$regKey value is $regValue. No change."
	return $false
}
	
function setRegKeyToValueOfOne([string] $regBranch, [string] $regKey) {
	$current = Get-ItemProperty -Path $regBranch -ErrorAction SilentlyContinue
	if ($current -eq $null) {
	    Write-Host "$regBranch\$regKey does not exist. No change." 
	    return $false
	}
	if ($current.$regKey -ne 1) {
	    $p = New-ItemProperty $regBranch -Name $regKey -PropertyType DWord -Value 1 -ErrorAction Stop -Force
	    Write-Host "Updated $regBranch\$regKey value to 1"
	    return $true
	 }
	Write-Host "$regBranch\$regKey value is 1. No change."
	return $false
	}
	
#setup .net tls settings
function setupTls4NET([boolean]$is64bit, [string]$regBranch, [string]$reg32bitBranch) {
# https://docs.microsoft.com/en-us/dotnet/framework/network-programming/tls
    $updated = setRegKeyToValueOfOne $regBranch "SchUseStrongCrypto"
    $updated = (setRegKeyToValueOfOne $regBranch "SystemDefaultTlsVersions") -or $updated

    if ($is64bit) {
        $updated = (setRegKeyToValueOfOne $reg32bitBranch "SchUseStrongCrypto") -or $updated
        $updated = (setRegKeyToValueOfOne $reg32bitBranch "SystemDefaultTlsVersions") -or $updated
    }

    return $updated
}                            
# https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed

$version = Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release
# 394254 - .NET Framework 4.6.1, which is the current target of the installer
if ($version.Release -ge 394254)  {
    $ev = [environment]::Version
    $v = "v" + $ev.Major + "." + $ev.Minor + "." + $ev.Build
    $updated = setupTls4NET $is64bit "HKLM:\SOFTWARE\Microsoft\.NETFramework\$v" "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\$v"
# https://support.microsoft.com/en-ca/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in

    $updated = (setRegKeyToBitValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" "DefaultSecureProtocols") -or $updated
    $updated = (setRegKeyToBitValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols") -or $updated

    # updated the 32-bit branches if we are on 64-bit machine
	    if ($is64bit) {
        $updated = (setRegKeyToBitValue "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" "DefaultSecureProtocols") -or $updated
        $updated = (setRegKeyToBitValue "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols") -or $updated
    }
	
    # current user settings
    $updated = (setRegKeyToBitValue "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols") -or $updated
	
    # local system account
    $userSid = ".DEFAULT"
    $updated = (setRegKeyToBitValue "Registry::HKEY_USERS\$userSid\Software\Microsoft\Windows\CurrentVersion\Internet Settings" "SecureProtocols") -or $updated

    if ($updated) {
        Write-Host "Done. Updated required settings."
    }
    else
    {
        Write-Host "Done. No updates are required."
    }
}
else 
{
    Write-Host "No changes were made. Your version of .NET Framework is earlier version than 4.6.1, please upgrade."
}         