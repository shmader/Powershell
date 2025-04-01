# Get current settings for DNS Server
Get-DNSServerDiagnostics

# Set log file rollover to disabled to prevent new log files from getting created and taking up space on the C: Drive. This will allow for overwrite of the specified log file in the DNS settings 
# and follow the max logfile size set
Set-DNSServerDiagnostics -EnableLogFileRollover $false