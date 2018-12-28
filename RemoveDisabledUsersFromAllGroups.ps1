#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Loops through all the OUs defined in $OUs and removes any      #
#      disabled users from all ADGroups they are in.                  #
#                                                                     #
#######################################################################

$OUs = "OU=Users_Employees,DC=domain,DC=com",
"OU=Users_ITEmployees,DC=domain,DC=com",
"OU=Users_FormerAssociates,DC=domain,DC=com"

$allgroups = Get-ADGroup -Filter * | where name -NE "Domain Users"
$allUsers = foreach ($OU in $OUs) {Get-ADUser -SearchBase $OU -Filter * | where enabled -EQ $false | select -ExpandProperty samAccountName}

foreach ($group in $allgroups) {
    Remove-ADGroupMember $group -Members $allUsers -Confirm:$false
}

foreach ($user in $allUsers) {
    Write-Host -NoNewline $user.PadRight(60,'.')
    if ((Get-ADUser $user -Properties memberof | select -ExpandProperty memberof) -ne $null)
    {
        Write-Host -ForegroundColor White -BackgroundColor Red " Failed "
    }
    else
    {
        Write-Host -ForegroundColor White -BackgroundColor Green " Passed "
    }
}