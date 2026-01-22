function Get-UnifiSites {
    <#
    .SYNOPSIS
        Retrieves all sites from the UniFi Controller.

    .DESCRIPTION
        Returns a list of all sites configured on the UniFi Controller.
        Each site object contains the 'name' property used by other functions.

    .EXAMPLE
        Get-UnifiSites

    .EXAMPLE
        Get-UnifiSites | Where-Object { $_.desc -like '*Office*' }

    .EXAMPLE
        # Pipeline to get devices for all sites
        Get-UnifiSites | Get-UnifiDevices

    .OUTPUTS
        PSCustomObject. Site objects with properties including name, desc, role, etc.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    Invoke-UnifiApi -Endpoint 'self/sites'
}
