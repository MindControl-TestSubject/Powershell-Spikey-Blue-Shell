######################################################################
#   Author: Evan Brown                                               #
#   Date: 26-12-2018                                                 #
#   Description:                                                     #
#      This script takes an ADUser's SamAccountName <UserID>, and    #
#      a list of additional property names and outputs the User's    #
#      important properties.                                         #
#                                                                    #
######################################################################

param(
    [Parameter(Mandatory=$true,Position=0)][string]$UserID,
    [Parameter(Position=1)][String[]]$Props
)

$Command = "Get-ADUser $UserID -prop * | select Name,Title,Office,Department,MobilePhone,OfficePhone,Description"

foreach($Prop in $Props)
{
    $Command += ",$Prop"
}

iex $Command #Invoke-Expression