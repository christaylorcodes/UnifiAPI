function Get-UnifiSitePortForwards {
    <#
    .SYNOPSIS
        Retrieves port forwarding rules for a specific site.

    .DESCRIPTION
        Returns all configured port forwarding rules for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSitePortForwards -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/portforward' -SiteName $SiteName
    }
}
