#####################################################################################################################
#
# Check_Attributes.ps1
# For Every On-Prem User: Get MSOL user, Compare Attributes, Report Results
# PowerShell script to check attributes related to Azure AD matching (Azure AD Connect)
#
# S. Jordan Novick, Novick Tech
# Email: jordan@novick.tech
# Updated November 2020
#
# Purpose: Audit your cloud and on-prem users in preparation for Azure AD Connect Soft/Hard Match
#
## Requirements for Script to Run:
#  - Active Directory PowerShell Module (Install via Add/Remove Features > RSAT > AD DS and AD LDS Tools)
#  - Azure / MSOnline V1 PowerShell module: https://docs.microsoft.com/en-us/powershell/module/msonline/?view=azureadps-1.0
#  - Valid credentials to connect to Azure AD / MSOnline
#  - Translate_ImmutableID.ps1 script by Jumlins TechBlog: https://blog.jumlin.com/2018/09/powershell-script-convert-immutableid/
#  -    (Script modified slightly by SJN, Nov 2020. Silenced all output except for returning value in the format of ImmutableID)
#
## Change Log:
#  - Version 0.1 - 2016
#  - Version 0.2 - Updated November 2020
#
####################################################################################################################

#####
##### EDIT THESE VALUES TO MATCH YOUR ENVIRONMENT

#$report = "C:\Users\administrator.NOVICK\Desktop\o365_hard_match_scripts\Report2.txt"
$report = "C:\temp\AADC_Match\Report1.txt"

#$server = 'dc1.novick.tech'
$server = 'campusfcu.org'

#$baseDN = 'OU=NT_Accounts,DC=Novick,DC=Tech'
$baseDN = 'OU=User Accounts,DC=campusfcu,DC=org'

#####
#####


#Install-Module MSOnline

ipmo msonline
ipmo activedirectory

#connect to msol
$cred = Get-Credential
connect-msolservice -credential $cred



# identification helper functions
function isGUID ($data) { 
	try { 	$guid = [GUID]$data 
		return 1 } 
	catch { return 0 } 
}

function isBase64 ($data) { 
	try { 	$decodedII = [system.convert]::frombase64string($data) 
        	return 1 } 
	catch { return 0 } 
}

function isHEX ($data) { 
	try { 	$decodedHEX = "$data" -split ' ' | foreach-object { if ($_) {[System.Convert]::ToByte($_,16)}}
		return 1 } 
	catch { return 0 } 
}

function isDN ($data) { 
	If ($data.ToLower().StartsWith("cn=")) {
		return 1 }
	else {	return 0 }
}

# conversion functions
function ConvertIItoDecimal ($data) {
	if (isBase64 $data) {
		$dec=([system.convert]::FromBase64String("$data") | ForEach-Object ToString) -join ' '
		return $dec
	}
}

function ConvertIIToHex ($data) {
	if (isBase64 $data) {
		$hex=([system.convert]::FromBase64String("$data") | ForEach-Object ToString X2) -join ' '
		return $hex
	}	
}

function ConvertIIToGuid ($data) {
	if (isBase64 $data) {
		$guid=[system.convert]::FromBase64String("$data")
		return [guid]$guid
	}
}

function ConvertHexToII ($data) {
	if (isHex $data) {
		$bytearray="$data" -split ' ' | foreach-object { if ($_) {[System.Convert]::ToByte($_,16)}}
		$ImmID=[system.convert]::ToBase64String($bytearray)
		return $ImmID
	}
}

function ConvertIIToDN ($data) {
	if (isBase64 $data) {
		$enc = [system.text.encoding]::utf8
		$result = $enc.getbytes($data)
		$dn=$result | foreach { ([convert]::ToString($_,16)) }
		$dn=$dn -join ''
		return $dn
	}
}

function ConvertDNtoII ($data) {
	if (isDN $data) {
		$hexstring = $data.replace("CN={","")
		$hexstring = $hexstring.replace("}","")
		$array = @{}
		$array = $hexstring -split "(..)" | ? {$_}
		$ImmID=$array | FOREACH { [CHAR][BYTE]([CONVERT]::ToInt16($_,16))}
		$ImmID=$ImmID -join ''
		return $ImmID
	}
}

function ConvertGUIDToII ($data) {
	if (isGUID $data) {
		$guid = [GUID]$data
    		$bytearray = $guid.tobytearray()
    		$ImmID=[system.convert]::ToBase64String($bytearray)
		return $ImmID
	}
}

Function OctetToGUID ($Octet)
{
    # Function to convert Octet value (byte array) into string GUID value.
    $GUID = [GUID]$Octet
    Return $GUID.ToString("B")
}

Clear-Content $report
Add-content $report "ObjectGUID Match, ConsistencyGUID Match, Cloud UPN, On-prem UPN, On-Prem Mail, proxyAddresses, Cloud ImmutableID, On-prem ObjectGUID, On-prem ConsistencyGUID"

$index=0
$red=0

$users = Get-ADUser -Properties mail,userprincipalname,proxyaddresses,objectguid,ms-ds-consistencyguid -SearchBase "$baseDN" -SearchScope Subtree -Server "$server" -Filter * 

foreach ($user in $users){
    
    $mail = $null
    $ad = $null
    $ad2 = $null
    $upn = $null
    $guid = $null
    $premUPN = $null
    $cloudUPN = $null
    $ImmutableID = $null
    $guid = $null
    $guid64 = $null
    $objectGuid = $null
    $consistOctet = $null
    $consistGuid = $null
    $consistGuid1 = $null
    $consistGuid2 = $null
    $msol = $null
    $proxy = $null
    $match1 = "No"
    $match2 = "No"

    $mail = $user.mail
    $upn = $user.userprincipalname
    $proxy = $user.proxyaddresses
    $guid = $user.objectguid
    $bytearray = $guid.ToByteArray()
    $guid64 = [system.convert]::ToBase64String($bytearray)

    <#
    $consistOctet = $user.'ms-ds-consistencyguid'
    if ($consistOctet -ne $null){
        $consistGuid1 = OctetToGUID($consistOctet)
        $consistGuid = C:\Users\administrator.NOVICK\Desktop\o365_hard_match_scripts\Modules\Translate_ImmutableID_JN.ps1 "$consistGuid1"
    }#>
    
    $consistGuid1 = $user.'ms-ds-consistencyguid'
    if($consistGuid1 -ne $null){
        $consistGuid1 = [system.convert]::ToBase64String($consistGuid1)
        if(isGUID $consistGuid1){$consistGuid2 = ConvertGUIDToII $consistGuid1}
        if(isBase64 $consistGuid1){$consistGuid2 = $consistGuid1}
        if(isHEX $consistGuid1){$consistGuid2 = ConvertHexToII $consistGuid1}
        #if(isDN $consistGuid1){$consistGuid2 = ConvertDNtoII $consistGuid1}
    }

    $msol = get-msoluser -userprincipalname $upn -EA SilentlyContinue | select ImmutableId,UserPrincipalName
    $ImmutableID = $msol.ImmutableID
    $cloudUPN = $msol.UserPrincipalName

    if(($immutableID -ne $null) -and ($ImmutableID -eq $guid64)){$match1="Yes"}
    if(($immutableID -ne $null) -and ($immutableID -eq $consistGuid2)){$match2="Yes"}

    write "ObjectGUID Match: $match1"
    write "ConsistencyGUID Match: $match2"
    write "O365 upn: $cloudUPN"
    write "On-prem upn: $upn"
    write "On-prem mail: $mail"
    write "O365 ImmutableID: $ImmutableId"
    Write "On-prem ObjectGUID: $guid64"
    write "On-prem consistencyGuid: $consistGuid2"
    write "On-prem proxyAddresses: $proxy"
    write "-----"

    #Add-content $report "Cloud User, On-Prem User, Cloud UPN, On-prem UPN, Cloud ImmutableID, On-prem ObjectGUID, On-prem ConsistencyGUID"
    Add-content $report "$match1, $match2, $cloudUPN, $upn, $mail, $proxy, $ImmutableID, $guid64, $consistGuid2"
}
