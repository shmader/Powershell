## https://brandoncanty.wordpress.com/2015/03/30/powershell-copy-ou-structure/

## Full code, you should only have to change the BaseOU and NewOU variables.

$BaseOU = "ou=los angeles,dc=widgets,dc=local"
$NewOU = "ou=Dallas,ou=-usa,dc=widgets,dc=local"

$GetCookiecutter = get-adorganizationalunit -searchbase $BaseOU -filter * -searchscope 2 

#We use the replace function later which is CaSe sensitive, we will make sure the inital OU supplied will match the case.
$NewBaseDN = $getcookiecutter.distinguishedname[0]

foreach ($OU in $getcookiecutter) {
    #skip the first one on the list, as it's the base OU
    if ($OU.name -like $Getcookiecutter.name[0]) {
        #do nothing
        }
    else {
        #we need to remove the first section of the DN so we are pointing to a valid path so we have to do some crazy trimming
        #Example  if we are copying the OU layout "ou=groups,ou=some-site,dc=test,dc=test"  and we want to make a new OU under
        #ou=some-new-site,dc=test,dc=test  we need to remove that initial "ou=groups"
        #we copy the original ou path, and replace it with the new path, then trim off that first location, so we can create it. 
        $SampleDN = $ou.distinguishedname.replace($NewBaseDN,$newou)
        $NewDN = $sampleDN.trimstart($sampledn.split(',')[0]).trim(",")

        $NewOUname = $ou.name
      
        write-host -f cyan "we copied the OU from location:"$OU 
        write-host -f yellow "Going to create an OU named:" $newOUname 
        write-host -f yellow "at the location of:" $newDN
        New-ADOrganizationalUnit -name $newOuName -path $NewDN -instance $OU -whatif
        }

    }