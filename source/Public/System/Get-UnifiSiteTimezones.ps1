function Get-UnifiSiteTimezones {
    <#
    .SYNOPSIS
        Retrieves available timezones for a specific site.

    .DESCRIPTION
        Returns the list of available timezones that can be configured for the site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteTimezones -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'stat/current-channel' -SiteName $SiteName
    }
}
