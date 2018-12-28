###########################################################
# AUTHOR  : Evan Brown
# CREATED : 2017-07-05
# UPDATED : 2017-07-05
# COMMENT : This script returns all users in specified
#           OU's whose password are expired.
###########################################################

Import-Module ActiveDirectory

$OUs = "OU=Users_Employees,DC=<domain>,DC=com",
"OU=Users_ITEmployees,DC=<domain>,DC=com"

$ADServer = 'servername'

$AllADUsers = ForEach ($OU in $OUs) {Get-ADUser -server $ADServer -SearchBase $OU -Filter * -Properties * | where passwordexpired -EQ $True | select Name,PasswordLastSet | sort Name}
$AllADUsers