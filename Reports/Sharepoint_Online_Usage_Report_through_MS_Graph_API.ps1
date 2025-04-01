#Function to Call Graph API
Function Get-UsageReport {
param (
    [parameter(Mandatory = $true)] [string]$ClientID,
    [parameter(Mandatory = $true)] [string]$ClientSecret,
    [parameter(Mandatory = $true)] [string]$TenantName,
    [parameter(Mandatory=$true)] [string]$GraphUrl
)
    Try {
        #Graph API URLs
        $LoginUrl = "https://login.microsoft.com"
        $ResourceUrl = "https://graph.microsoft.com"
  
        #Compose REST request
        $Body = @{ grant_type = "client_credentials"; resource = $ResourceUrl; client_id = $ClientID; client_secret = $ClientSecret }
        $OAuth = Invoke-RestMethod -Method Post -Uri $LoginUrl/$TenantName/oauth2/token?api-version=1.0 -Body $Body
  
        #Perform REST call
        $HeaderParams = @{ 'Authorization' = "$($OAuth.token_type) $($OAuth.access_token)" }
        $Result = (Invoke-WebRequest -UseBasicParsing -Headers $HeaderParams -Uri $GraphUrl)
 
        #Format Microsoft Graph Output
        (($Result).RawContent -Split "\?\?\?")[1] | ConvertFrom-Csv
    }   
    Catch {
        Write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
}
 
#Parameters
$ClientID = "b92a23bb-7e91-4a93-861a-96cbe4101dbb"
$ClientSecret = "XYT7Q~YaVAKPQDhPWy2C5_f.3BsOt1c5mR0wV"
$TenantName = "novicktech.onmicrosoft.com"
$GraphUrl = "https://graph.microsoft.com/v1.0/reports/getSharePointSiteUsageDetail(period='D30')"
 
#Call the function to get usage data
$UsageData = Get-UsageReport -ClientID $ClientID -ClientSecret $ClientSecret -TenantName $TenantName -GraphUrl $GraphUrl
$UsageData
$UsageData | Export-Csv "C:\Temp\siteusage.csv" -NoTypeInformation



#For full instructions: https://www.sharepointdiary.com/2019/11/sharepoint-online-usage-reports-using-graph-api-powershell.html#ixzz7P7orBPFb