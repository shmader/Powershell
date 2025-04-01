#First run this to audit all accounts for current numbers in case we need to roll back
Get-ADuser -Filter * -Properties Name, sAMAccountName, userPrincipalName, OfficePhone, Mobilephone, enabled |
Export-CSV "C:\temp\Scripts\AD_Scripts\Add\Phone Number Format Change\Phone List Before Format Change.csv" -NoTypeInformation -Encoding UTF8


#Need to include paramaters in the CSV of samaccountname,telephoneNumber,mobile
import-csv -Path C:\temp\Scripts\Phonenumberformat.csv | ForEach-Object { 
set-aduser -Identity $_.samaccountname -OfficePhone $_.telephoneNumber -Mobile $_.mobile} 


#Run one more time for the new format report
Get-ADuser -Filter * -Properties Name, sAMAccountName, userPrincipalName, OfficePhone, Mobilephone, enabled |
Export-CSV "C:\temp\Scripts\AD_Scripts\Add\Phone Number Format Change\Phone List After Format Change.csv" -NoTypeInformation -Encoding UTF8
