## Remote PS connection to host

Enter-PSSession

#Get all services running on host and logon name

Get-WmiObject Win32_Service | Select-Object Name,StartName

#Get all scheduled tasks running on host and the run as name
 
get-scheduledtask | select-object taskname,Author, @{ n = 'UserId'; e = { $_.principal.userid}}
 