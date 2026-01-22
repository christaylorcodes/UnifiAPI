function Get-UnifiSiteStatistics {
    <#
    .SYNOPSIS
        Retrieves statistics for a specific site.

    .DESCRIPTION
        Returns detailed statistics for access points, gateways, switches, or the entire site.
        Statistics include traffic, performance metrics, and client counts.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Type
        Type of statistics to retrieve:
        - 'site': Overall site statistics
        - 'ap': Access point statistics
        - 'gw': Gateway statistics
        - 'sw': Switch statistics
        - 'user': Per-client statistics

    .PARAMETER Interval
        Time interval for statistics:
        - '5minutes': 5-minute intervals
        - 'hourly': Hourly intervals
        - 'daily': Daily intervals
        - 'monthly': Monthly intervals

    .PARAMETER Start
        Start date/time for the statistics range.

    .PARAMETER End
        End date/time for the statistics range.

    .PARAMETER MacAddress
        Filter statistics by device MAC address(es).

    .EXAMPLE
        Get-UnifiSiteStatistics -SiteName 'default' -Type 'site' -Interval 'hourly'

    .EXAMPLE
        Get-UnifiSiteStatistics -SiteName 'default' -Type 'ap' -Interval 'daily' -Start (Get-Date).AddDays(-7)

    .EXAMPLE
        Get-UnifiSiteStatistics -SiteName 'default' -Type 'gw' -Interval '5minutes' -MacAddress '00:11:22:33:44:55'

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

        [Parameter(Mandatory)]
        [ValidateSet('site', 'ap', 'gw', 'sw', 'user')]
        [string]$Type,

        [Parameter(Mandatory)]
        [ValidateSet('5minutes', 'hourly', 'daily', 'monthly')]
        [string]$Interval,

        [Parameter()]
        [datetime]$Start,

        [Parameter()]
        [datetime]$End,

        [Parameter()]
        [string[]]$MacAddress
    )

    # PS7+ null-coalescing assignment for default time ranges
    $Start ??= switch ($Interval) {
        '5minutes' { (Get-Date).AddHours(-2) }
        'hourly' { (Get-Date).Date }
        'daily' { (Get-Date).Date.AddDays(-7) }
        'monthly' { (Get-Date).Date.AddMonths(-12) }
    }

    $End ??= Get-Date

    # Convert to Unix timestamp (milliseconds)
    $StartUnix = ConvertTo-UnifiUnixTime -DateTime $Start
    $EndUnix = ConvertTo-UnifiUnixTime -DateTime $End

    $Body = @{
        attrs = @(
            'satisfaction', 'bytes', 'num_sta', 'time',
            'tx_packets', 'rx_packets', 'tx_bytes', 'rx_bytes',
            'wan-tx_packets', 'wan-rx_packets', 'wan-tx_bytes', 'wan-rx_bytes',
            'lan-tx_packets', 'lan-rx_packets', 'lan-tx_bytes', 'lan-rx_bytes',
            'tx_dropped', 'rx_dropped', 'tx_errors', 'rx_errors',
            'tx_retries', 'wifi_tx_attempts', 'wifi_tx_dropped',
            'mem', 'cpu', 'loadavg_5',
            'lan-num_sta', 'wlan-num_sta', 'wlan_bytes'
        )
        start = $StartUnix
        end   = $EndUnix
    }

    # Add MAC filter if specified
    if ($MacAddress) {
        $NormalizedMacs = $MacAddress | ForEach-Object {
            Test-UnifiMacAddress -MacAddress $_ -Normalize
        }
        $Body.macs = @($NormalizedMacs)
    }

    Invoke-UnifiApi -Endpoint "stat/report/$Interval.$Type" -SiteName $SiteName -Method Post -Body $Body
}
