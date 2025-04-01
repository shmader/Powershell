New-Item -Path "c:\" -Name "StartingPoint"-ItemType "directory" -force
Copy-Item -Path "C:\Users\shelby\Intune_Package\StartingPointv5.6.1_IND\*" -Destination "C:\StartingPoint" -Recurse -force