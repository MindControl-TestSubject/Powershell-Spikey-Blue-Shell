#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Sets the <Value> of a SharePoint user property <PropName>      #
#      for the user with the email address <UserEmail>                #
#      <credential> = your sharepoint admin credentials               #
#                                                                     #
#######################################################################

param(
      [Parameter(Mandatory=$false)][PSCredential]$credential,
      [Parameter(Mandatory=$true)][String]$UserEmail,
      [Parameter(Mandatory=$true)][String]$PropName,
      [Parameter(Mandatory=$true)][Object]$Value
     )

# add SharePoint CSOM libraries
Import-Module Microsoft.Online.SharePoint.PowerShell -NoClobber
Import-Module 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll' -NoClobber
Import-Module 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll' -NoClobber
Import-Module 'C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.UserProfiles.dll' -NoClobber

# Defaults
$spoAdminUrl = "https://<domain>-admin.sharepoint.com"

# Get credentials of account that is a SharePoint Online Admin
if ([String]::IsNullOrEmpty($credential.UserName))
{
    $credential = Get-Credential
}

Try
{
    # Get credentials for SharePointOnline
    $spoCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credential.GetNetworkCredential().Username, (ConvertTo-SecureString $credential.GetNetworkCredential().Password -AsPlainText -Force))
    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($spoAdminUrl)
    $ctx.Credentials = $spoCredentials

    # Get SharePoint User
    $User = $ctx.Web.EnsureUser($UserEmail)
    $ctx.Load($User)
    $ctx.ExecuteQuery()

    # Get User Profile
    $spoPeopleManager = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($ctx)
    $UserProfile = $spoPeopleManager.GetPropertiesFor($User.LoginName)
    $ctx.Load($UserProfile)
    $ctx.ExecuteQuery()

    # Set Property
    $targetSPOUserAccount = ("i:0#.f|membership|" + $UserEmail)
    $spoPeopleManager.SetSingleValueProfileProperty($targetSPOUserAccount, $PropName, $Value)
    $ctx.ExecuteQuery()

}
Catch 
{
    Write-Host -ForegroundColor Red "Error : Unable to change User Property" $_.Exception.Message
}
