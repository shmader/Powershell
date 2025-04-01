Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\temp\Scripts\AD_Scripts\Add\Add Users to Security Group\test_script.csv"

foreach ($User in $Users) {
    
    # Retrieve UPN
    $UPN = $User.UserPrincipalName

     # Retrieve UPN related SamAccountName
    $ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Set-ADUser -Clear description 
    }
