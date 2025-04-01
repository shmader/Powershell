
#Updates custom attribute countryCode and writes errors back into a report.
import-csv -Path C:\temp\Scripts\Attributeupdatetest.csv |
 ForEach-Object { try {
 set-aduser -Identity $_.samaccountname -Replace @{countryCode = $_.countryCode}}

Catch{ Write-host "Encountered Error:"$_.Exception.Message
    $Error[0] | Out-File -FilePath "C:\temp\Scripts\CountryCodefailedupdate.csv" -Encoding UTF8 -Append
}
}


#Update the manager attribute. Managers must be in DN format.Appends errors to a csv file.
import-csv -Path C:\temp\Scripts\Attributeupdatetest.csv | 
ForEach-Object { try { set-aduser -Identity $_.samaccountname -Manager $_.managerDN}
Catch{ Write-host "Encountered Error:"$_.Exception.Message
    $Error[0] | Out-File -FilePath "C:\temp\Scripts\Managerfailedupdate.csv" -Encoding UTF8 -Append
}
}



#Updates the Office attribute. Appends errors to a csv file.
import-csv -Path C:\temp\Scripts\Attributeupdatetest.csv |
 ForEach-Object { try {set-aduser -Identity $_.samaccountname -Office $_.Office}
 Catch{ Write-host "Encountered Error:"$_.Exception.Message
    $Error[0] | Out-File -FilePath "C:\temp\Scripts\Officefailedupdate.csv" -Encoding UTF8 -Append
}
}


 #Updates the Country attribute. Appends errors to a csv file.
import-csv -Path C:\temp\Scripts\Attributeupdatetest.csv |
 ForEach-Object { try {set-aduser -Identity $_.samaccountname -Country $_.c}
 Catch{ Write-host "Encountered Error:"$_.Exception.Message
    $Error[0] | Out-File -FilePath "C:\temp\Scripts\Countryfailedupdate.csv" -Encoding UTF8 -Append
}
}