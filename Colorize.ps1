#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Makes the output of whatever is piped into this rainbow colors #
#      Each line is the next color.                                   #
#                                                                     #
#######################################################################

param(
    [Parameter(ValueFromPipeline=$true)][Object]$object
)

$lines = $object | Out-String -Stream
$i = 0

foreach ($line in $lines) {
    if ([String]::IsNullOrEmpty($line)) {
        Write-Host $line
        continue
    }
    switch ($i) {
        0{Write-Host -ForegroundColor DarkRed $line}
        1{Write-Host -ForegroundColor Red $line}
        2{Write-Host -ForegroundColor DarkYellow $line}
        3{Write-Host -ForegroundColor Yellow $line}
        4{Write-Host -ForegroundColor Cyan $line}
        5{Write-Host -ForegroundColor DarkGray $line}
        6{Write-Host -ForegroundColor Blue $line}
        7{Write-Host -ForegroundColor Magenta $line}
    }
    $i++
    if ( $i -ge 8 ) { $i = 0 }
}