#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Uses a local CodeSigningCert to sign a powershell script at    #
#      <scriptPath>. This will allow the execution of a script that   #
#      would otherwise not meet the execution policy requirements.    #
#                                                                     #
#######################################################################

param([String]$scriptPath)

Set-AuthenticodeSignature $scriptPath @(Get-ChildItem cert:\CurrentUser\My -CodeSigningCert )[0]