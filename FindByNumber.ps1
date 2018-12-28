#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Searches Active Directory for anyone with the Mobile or Office #
#      number <number>. <Enabled> will find enabled or disabled users #
#      or both if null.                                               #
#                                                                     #
#######################################################################

param(
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
    [String]$number,
    [Nullable[Bool]]$Enabled = $true
    )

if ([String]::IsNullOrEmpty($number))
{
    Write-Host "Find User by Phone Number";
    Write-Host "===================================";
    $number = Read-Host -Prompt "Enter Number in format 123-456-7890 or 1234567890"
}

$numberArr = $number.ToCharArray()
$trimmedNum = ""

foreach ($char in $numberArr)
{
 if($char -match "[0-9]")
 {
    $trimmedNum += $char
 }   
}
# If the number includes the country code, remove it.
if($trimmedNum.Length -eq 11 -and $trimmedNum[0] -eq "1") {$trimmedNum = $trimmedNum.Substring(1,10)}
if($trimmedNum.Length -eq 10)
{
    $formattedNum = [String]::Concat($trimmedNum.Substring(0,3),"-",$trimmedNum.Substring(3,3),"-",$trimmedNum.Substring(6,4))
    $result = Get-ADUser -Filter * -Properties Mobile,OfficePhone,Title,Office,Department | select Name,Mobile,OfficePhone,Title,Office,Department
    # If we are sorting by whether or not the user is enabled
    if ($Enabled -ne $null) {$result | Where-Object {($_.Mobile -eq $formattedNum -or $_.OfficePhone -eq $formattedNum) -and $_.enabled -eq $Enabled}}
    else {$result | Where-Object {$_.Mobile -eq $formattedNum -or $_.OfficePhone -eq $formattedNum}}
}
else
{
    Write-Error -Message "number is not valid"
}