# Use to query which PCs have LAPS agent installed and which OU they are in

Get-ADComputer -Filter {(ms-Mcs-AdmPwdExpirationTime -like "*") } -Properties Name, ms-Mcs-AdmPwdExpirationTime | Select Name,distinguishedName,ms-Mcs-AdmPwdExpirationTime > C:\temp\AD_Reports\Reports\Computer\LAPS_Agent_Installed.csv