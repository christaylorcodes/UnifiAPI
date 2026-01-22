function Get-UnifiNeighborAP {
    <#
    .SYNOPSIS
        Retrieves neighboring/rogue access points detected by the site.

    .DESCRIPTION
        Returns APs detected in the area that are not part of the UniFi network.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER TimeSpanHours
        Number of hours to look back. Default is 12.

    .PARAMETER Limit
        Maximum number of results to return. Default is 1000.

    .EXAMPLE
        Get-UnifiNeighborAP -SiteName 'default'

    .EXAMPLE
        Get-UnifiNeighborAP -SiteName 'default' -TimeSpanHours 24 -Limit 500

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
        [ValidateRange(1, 168)]
        [int]$TimeSpanHours = 12,

        [Parameter()]
        [ValidateRange(1, 10000)]
        [int]$Limit = 1000
    )

    process {
        Invoke-UnifiApi -Endpoint 'stat/rogueap' -SiteName $SiteName -QueryParams @{
            within = $TimeSpanHours
            _limit = $Limit
        }
    }
}
