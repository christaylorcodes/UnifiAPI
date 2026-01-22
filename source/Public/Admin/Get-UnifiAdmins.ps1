function Get-UnifiAdmins {
    <#
    .SYNOPSIS
        Retrieves all administrators from the UniFi controller.

    .DESCRIPTION
        Returns a list of all administrator accounts and their permissions across the controller.

    .EXAMPLE
        Get-UnifiAdmins

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    Invoke-UnifiApi -Endpoint 'stat/admin'
}
