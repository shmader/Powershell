Get-Content -Path $MyDir\Starting_Point_PS_log.txt "Error"


If (Get-Content $MyDir\Starting_Point_PS_log.txt | %{$_ -match "error"}) 
{
    echo Contains String
}
else
{
    echo Not Contains String
}





if (Select-String -Path $MyDir\Starting_Point_PS_log.txt -Pattern "error" -SimpleMatch -Quiet)
{
    echo "Contains String"
}
else
{
    echo "Not Contains String"
}



$SEL = get-content $MyDir\Starting_Point_PS_log.txt
if( $SEL -imatch "error" ) 
{
   Write-Host 'Contains String'
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("Script completed with errors. Please contact your adminitrator")
}
else
{
   Write-Host 'Does not contain String'
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("Script has completed! Click OK to exit.")
}
