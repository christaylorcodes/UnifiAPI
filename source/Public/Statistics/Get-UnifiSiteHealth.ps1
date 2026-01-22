function Get-UnifiSiteHealth {
    <#
    .SYNOPSIS
        Retrieves health status for a specific site.

    .DESCRIPTION
        Returns the health status of all subsystems (WAN, LAN, WLAN, VPN, etc.)
        for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteHealth -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | ForEach-Object {
            [PSCustomObject]@{
                Site = $_.desc
                Health = (Get-UnifiSiteHealth -SiteName $_.name)
            }
        }

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
        Invoke-UnifiApi -Endpoint 'stat/health' -SiteName $SiteName
    }
}
