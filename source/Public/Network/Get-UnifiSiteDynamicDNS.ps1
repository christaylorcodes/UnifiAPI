function Get-UnifiSiteDynamicDNS {
    <#
    .SYNOPSIS
        Retrieves Dynamic DNS configurations for a specific site.

    .DESCRIPTION
        Returns all Dynamic DNS (DDNS) configurations for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteDynamicDNS -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/dynamicdns' -SiteName $SiteName
    }
}
