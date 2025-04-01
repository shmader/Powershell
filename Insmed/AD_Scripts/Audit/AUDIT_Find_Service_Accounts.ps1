## WMI Query to Retrieve All Services, Get the Accounts Used to Log on to Them, and Export Them to a CSV File on the Local Computer

$CSV_File_Path  = "C:\temp\test.csv"

$Services = Get-WmiObject Win32_Service

$Services_Info = $Services | Select-Object Name, Caption, StartName, StartMode

$Services_Info | Export-Csv $CSV_File_Path