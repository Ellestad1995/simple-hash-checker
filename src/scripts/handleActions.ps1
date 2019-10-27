<#
    .SYNOPSIS
        Handle user interactions with the actions on the notifications
#>
Param($Argument="") # If the protocol is ran you always at least get the protocol name as an argument. (if using the %1)
[String]
$Argument 

function Handle-Actions { # The cmdlet 'Handle-Actions' uses an unapproved verb. 
    [cmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [String]
        $Argument 
    )
    $Argumuments = $Argument.Split([Char]0x0026) # Splits by `?`
    #Argumnets is now in an array, do whatever you need to next.
    $Argumuments | %{
        Write-Host $_ # Writes each argument that was seperated by ? to a line
    }
}

Handle-Actions -Argument $Argument