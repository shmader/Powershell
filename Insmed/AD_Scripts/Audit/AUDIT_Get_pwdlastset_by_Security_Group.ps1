## Run this line to figure out which Fine Grained Password Policy a user is getting and how many day until their password will expire
Get-ADUserResultantPasswordPolicy -Identity daniel.hawkins

## Run this line to get a list of users by security group and their passwordlastset date
$ExportPath = 'C:\temp\AD_Reports\Password Policy Changes\TEST.csv'
(get-adgroup FGPP_IT_Pilot -properties members).members | % { get-aduser $_ -properties PasswordLastSet } | select name,passwordlastset | Export-Csv -NoTypeinformation $ExportPath