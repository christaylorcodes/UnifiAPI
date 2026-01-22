function Get-UnifiSiteClients {
    <#
    .SYNOPSIS
        Retrieves connected clients for a specific site.

    .DESCRIPTION
        Returns clients for the specified UniFi site with various filtering options.
        By default returns currently connected clients. Use switches to get historical
        or guest clients, or filter by MAC address or time range.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .PARAMETER Known
        Retrieve all known clients (historical) instead of just currently connected ones.

    .PARAMETER Guest
        Retrieve only guest clients.

    .PARAMETER MacAddress
        Get a specific client by MAC address.

    .PARAMETER ActiveWithinHours
        Get clients that were active within the specified number of hours.
        Returns historical data based on activity time.

    .EXAMPLE
        Get-UnifiSiteClients -SiteName 'default'
        # Returns currently connected clients

    .EXAMPLE
        Get-UnifiSiteClients -SiteName 'default' -Known
        # Returns all known clients (historical)

    .EXAMPLE
        Get-UnifiSiteClients -SiteName 'default' -Guest
        # Returns only guest clients

    .EXAMPLE
        Get-UnifiSiteClients -SiteName 'default' -MacAddress '00:11:22:33:44:55'
        # Returns specific client by MAC

    .EXAMPLE
        Get-UnifiSiteClients -SiteName 'default' -ActiveWithinHours 24
        # Returns clients active in last 24 hours

    .EXAMPLE
        # Pipeline from Get-UnifiSites
        Get-UnifiSites | Get-UnifiSiteClients

    .OUTPUTS
        PSCustomObject. Client objects with properties including mac, hostname, ip, etc.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Current')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter(ParameterSetName = 'Known')]
        [switch]$Known,

        [Parameter(ParameterSetName = 'Guest')]
        [switch]$Guest,

        [Parameter(ParameterSetName = 'ByMac')]
        [ValidateNotNullOrEmpty()]
        [Alias('mac')]
        [string]$MacAddress,

        [Parameter(ParameterSetName = 'ActiveWithin')]
        [ValidateRange(1, 8760)]
        [int]$ActiveWithinHours
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Known' {
                Invoke-UnifiApi -Endpoint 'rest/user' -SiteName $SiteName
            }
            'Guest' {
                Invoke-UnifiApi -Endpoint 'stat/guest' -SiteName $SiteName
            }
            'ByMac' {
                $NormalizedMac = Test-UnifiMacAddress -MacAddress $MacAddress -Normalize
                Invoke-UnifiApi -Endpoint "stat/user/$NormalizedMac" -SiteName $SiteName
            }
            'ActiveWithin' {
                # stat/alluser with within parameter (hours)
                Invoke-UnifiApi -Endpoint 'stat/alluser' -SiteName $SiteName -QueryParams @{ within = $ActiveWithinHours }
            }
            default {
                # Current connected clients
                Invoke-UnifiApi -Endpoint 'stat/sta' -SiteName $SiteName
            }
        }
    }
}
