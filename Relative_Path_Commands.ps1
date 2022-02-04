#Use the following to get the relative path (same directory the PS script is located in) when running from ISE

$MyDir = (Split-Path $psISE.CurrentFile.FullPath)
"-----> $MyDir"

$MyDir = (Split-Path $psISE.CurrentFile.FullPath) + "\Relative_Path_Test.ps1"
"-----> $MyDir"

#Use the following to get the relative path (same directory the PS script is located in) when running from regular Powershell window

$MyDir = (Split-Path $MyInvocation.MyCommand.Path)
"-----> $MyDir"

$MyDir = (Split-Path $MyInvocation.MyCommand.Path) + "\Starting_Point_Installer_Package"
"-----> $MyDir"

#Use to copy item from your current working directory (where PS script is located) to another location
Copy-Item -path $MyDir\test.txt -Destination C:\StartingPoint -Force -Verbose