function Get-UnifiSiteSystemInfo {
    <#
    .SYNOPSIS
        Retrieves system information for the UniFi controller.

    .DESCRIPTION
        Returns system information about the UniFi controller including version,
        hostname, and other system details.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteSystemInfo -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'stat/sysinfo' -SiteName $SiteName
    }
}
