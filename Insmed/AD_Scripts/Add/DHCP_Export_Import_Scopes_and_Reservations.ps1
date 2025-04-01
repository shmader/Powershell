
#Export all settings from existing DHCP server. Run this on the new DHCP server and make sure you have the directory C:\DHCP created on the new server
Export-DhcpServer -ComputerName "OLDHCPSERVER.insmed.local" -Leases -File "C:\DHCP\OLD_DHCP_Config.xml" –Verbose

#Run this on the new DHCP server to import all scopes and settings
Import-DhcpServer -Leases –File "C:\DHCP\OLD_DHCP_Config.xml" -BackupPath "C:\DHCP\Backup" –Verbose

#Get all reservations for a DHCP scope to a csv file
Get-DhcpServerv4Scope -ComputerName INSJPDC01.insmed.local | Get-DhcpServerv4Reservation -ComputerName INSJPDC01.insmed.local | Export-CSV "C:\Temp\INJPDC01_DHCP_Reservations.csv" -NoTypeInformation -Encoding UTF8

#Add all reservations to a scope from a csv file
Import-Csv -Path "C:\Temp\INJPDC01_DHCP_Reservations.csv" | Add-DhcpServerv4Reservation -ComputerName "insawsdrdc01.insmed.local"