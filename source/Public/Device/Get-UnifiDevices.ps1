function Get-UnifiDevices {
    <#
    .SYNOPSIS
        Retrieves devices for a specific site.

    .DESCRIPTION
        Returns all UniFi devices (APs, switches, gateways) for the specified site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiDevices -SiteName 'default'

    .EXAMPLE
        # Pipeline from Get-UnifiSites
        Get-UnifiSites | Get-UnifiDevices

    .EXAMPLE
        # Get devices for multiple sites
        'site1', 'site2' | ForEach-Object { Get-UnifiDevices -SiteName $_ }

    .OUTPUTS
        PSCustomObject. Device objects with properties including mac, name, type, model, etc.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName
    )

    process {
        Invoke-UnifiApi -Endpoint 'stat/device' -SiteName $SiteName
    }
}
