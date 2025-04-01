### You need to update the following for your environment:
# $root - the PSDrive to your "root" OU. "Country" in your question
# $sourceOU - the source OU (name, not DN) from which you will copy the ACEs.
# $sourceGroup - the group (name, not DN or domain) listed in the ACL which you will copy.
# $targetGroups - Hash of groups (name, not DN or domain) and OUs (name, not DN) for applying the ACEs.

Import-Module ActiveDirectory

$root          = "AD:\DC=insmed,DC=local"
$sourceOU       = "HR"
$sourceACL      = Get-Acl $root.Replace("AD:\", "AD:\OU=$sourceOU,")
$sourceGroup    = "Account Operators"

# Hash for the new groups and their OUs
$targetGroups = @{}
$targetGroups.Add("Advanced Privileges - Service Desk", @("Administration", "AWS", "AWS Workspace Computers", "Builtin", "CEO", "Clinical", "Commercial", "Computers", "Computers Pending Delete", "Corporate Development", "Disabled Computers", "Disabled Users", "Distribution Groups", "Drug Safety & Risk Management", "DT", "Europe", "Executives", "External Users", "Field Force", "Finance", "G&A", "GPO Exclude OU", "HCServers", "HR", "iHRIS Users", "Insmed Encrypted Computers", "Insmed Lab Computers", "Insmed Servers", "Interact", "Intune Test", "IT", "IT Admins", "IT Consultants", "Legal", "LostAndFound", "MacBooks", "Medical Affairs", "Microsoft Exchange Security Groups", "Program Management", "QA", "R&D", "Regulatory Affairs", "Remote Access", "Safety", "Scan", "SCCMOSD", "Security Groups", "Service Accounts All", "ServiceNow", "TAD", "Tech Ops", "Temps & Consultants", "Users", "Users Pending Delete"))

# Get the uniherited ACEs for the $sourceGroup from $sourceOU
$sourceACEs = $sourceACL |
    Select-Object -ExpandProperty Access |
        Where-Object { $_.IdentityReference -match "$($sourceGroup)$" -and $_.IsInherited -eq $False }

# Walk each targetGroup in the hash
foreach ( $g in $targetGroups.GetEnumerator() ) {

    # Get the AD object for the targetGroup
    Write-Output $g.Name
    $group      = Get-ADGroup $g.Name
    $identity   = New-Object System.Security.Principal.SecurityIdentifier $group.SID

    # Could be multiple ACEs for the sourceGroup
    foreach ( $a in $sourceACEs ) {

        # From from the sourceACE for the ActiveDirectoryAccessRule constructor  
        $adRights               = $a.ActiveDirectoryRights
        $type                   = $a.AccessControlType
        $objectType             = New-Object Guid $a.ObjectType
        $inheritanceType        = $a.InheritanceType
        $inheritedObjectType    = New-Object Guid $a.InheritedObjectType

        # Create the new "copy" of the ACE using the target group. http://msdn.microsoft.com/en-us/library/w72e8e69.aspx
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity, $adRights, $type, $objectType, $inheritanceType, $inheritedObjectType    

        # Walk each city OU of the target group
        foreach ( $city in $g.Value ) {

            Write-Output "`t$city"
            # Set the $cityOU
            $cityOU = $root.Replace("AD:\", "AD:\OU=$city,")
            # Get the ACL for $cityOU
            $cityACL = Get-ACL $cityOU
            # Add it to the ACL
            $cityACL.AddAccessRule($ace)
            # Set the ACL back to the OU
            Set-ACL -AclObject $cityACL $cityOU

        }

    }

}