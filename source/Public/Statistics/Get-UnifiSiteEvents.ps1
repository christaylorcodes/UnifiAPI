function Get-UnifiSiteEvents {
    <#
    .SYNOPSIS
        Retrieves events for a specific site.

    .DESCRIPTION
        Returns site events (up to 3000) for the specified UniFi site,
        ordered by most recent first.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER IncludeArchived
        Include archived events in the results.

    .EXAMPLE
        Get-UnifiSiteEvents -SiteName 'default'
        # Returns non-archived events only

    .EXAMPLE
        Get-UnifiSiteEvents -SiteName 'default' -IncludeArchived
        # Returns all events including archived

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        Results are limited to 3000 events.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter()]
        [switch]$IncludeArchived
    )

    process {
        if ($IncludeArchived) {
            Invoke-UnifiApi -Endpoint 'stat/event' -SiteName $SiteName
        }
        else {
            Invoke-UnifiApi -Endpoint 'stat/event' -SiteName $SiteName -QueryParams @{ archived = 'false' }
        }
    }
}
