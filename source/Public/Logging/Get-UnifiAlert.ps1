function Get-UnifiAlert {
    <#
    .SYNOPSIS
        Retrieves system alerts for a site (v2 API).

    .DESCRIPTION
        Returns Next-AI alerts from the UniFi Controller v2 API for the specified time period.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Days
        Number of days to look back for alerts. Default is 7.

    .PARAMETER Categories
        Alert categories to retrieve. Default includes DEVICE, CLIENT, INTERNET, VPN.

    .PARAMETER PageSize
        Number of alerts per page. Default is 100.

    .EXAMPLE
        Get-UnifiAlert -SiteName 'default' -Days 7

    .EXAMPLE
        Get-UnifiAlert -SiteName 'default' -Days 30 -Categories @('DEVICE', 'INTERNET')

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        Uses the v2 API endpoint.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter()]
        [ValidateRange(1, 365)]
        [int]$Days = 7,

        [Parameter()]
        [ValidateSet('DEVICE', 'CLIENT', 'INTERNET', 'VPN')]
        [string[]]$Categories = @('DEVICE', 'CLIENT', 'INTERNET', 'VPN'),

        [Parameter()]
        [ValidateRange(1, 1000)]
        [int]$PageSize = 100
    )

    process {
        $Response = Invoke-UnifiApi -Endpoint 'system-log/next-ai-alert' -SiteName $SiteName -ApiV2 -Method Post -Body @{
            nextAiCategory = $Categories
            pageNumber     = 0
            pageSize       = $PageSize
            timestampFrom  = [System.DateTimeOffset]::new((Get-Date).AddDays(-$Days)).ToUnixTimeMilliseconds()
            timestampTo    = [System.DateTimeOffset]::new((Get-Date)).ToUnixTimeMilliseconds()
        } -Raw

        return $Response.data
    }
}
