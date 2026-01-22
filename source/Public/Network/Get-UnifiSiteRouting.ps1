function Get-UnifiSiteRouting {
    <#
    .SYNOPSIS
        Retrieves routing information for a specific site.

    .DESCRIPTION
        Returns routing table information for the specified UniFi site.
        By default, returns only user-defined routes. Use -All to include system routes.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER All
        Include system-generated routes in addition to user-defined routes.

    .EXAMPLE
        Get-UnifiSiteRouting -SiteName 'default'
        # Returns user-defined routes only

    .EXAMPLE
        Get-UnifiSiteRouting -SiteName 'default' -All
        # Returns all routes including system routes

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter()]
        [switch]$All
    )

    process {
        if ($All) {
            Invoke-UnifiApi -Endpoint 'stat/routing' -SiteName $SiteName
        }
        else {
            Invoke-UnifiApi -Endpoint 'rest/routing' -SiteName $SiteName
        }
    }
}
