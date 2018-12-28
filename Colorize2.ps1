#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Makes the output of whatever is piped into this rainbow colors #
#      Every character is a new color (or every <width> characters)   #
#                                                                     #
#######################################################################

param(
    [Parameter(ValueFromPipeline=$true)][Object]$object,
    [Parameter(Position=0)][Int]$width = 1
)

$lines = $object | Out-String -Stream
$j = 0

foreach ($line in $lines) {
    if ([String]::IsNullOrEmpty($line)) {
        Write-Host $line
        continue
    }
    $i=0
    $j=0

    foreach ($char in $line.toCharArray())
    {
        $j++
        switch ($i) {
            0{Write-Host -NoNewLine -ForegroundColor DarkRed $char}
            1{Write-Host -NoNewLine -ForegroundColor Red $char}
            2{Write-Host -NoNewLine -ForegroundColor DarkYellow $char}
            3{Write-Host -NoNewLine -ForegroundColor Yellow $char}
            4{Write-Host -NoNewLine -ForegroundColor Cyan $char}
            5{Write-Host -NoNewLine -ForegroundColor DarkGray $char}
            6{Write-Host -NoNewLine -ForegroundColor Blue $char}
            7{Write-Host -NoNewLine -ForegroundColor Magenta $char}
        }

        if ( $j % $width -eq 0 ) { $i++ }
        if ( $i -ge 8 ) { $i = 0 }
    }
    Write-Host
}