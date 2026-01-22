function Get-UnifiSiteAlarms {
    <#
    .SYNOPSIS
        Retrieves alarms for a specific site.

    .DESCRIPTION
        Returns active alarms for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiSiteAlarms -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiSiteAlarms

    .OUTPUTS
        PSCustomObject. Alarm objects with properties including key, msg, datetime, etc.

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
        Invoke-UnifiApi -Endpoint 'stat/alarm' -SiteName $SiteName
    }
}
