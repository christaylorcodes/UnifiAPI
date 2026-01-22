function Get-UnifiSiteWarnings {
    <#
    .SYNOPSIS
        Retrieves warnings for a specific site.

    .DESCRIPTION
        Returns warning indicators for the specified site, including firmware update availability.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiSiteWarnings -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiSiteWarnings

    .OUTPUTS
        PSCustomObject. Warning objects.

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
        Invoke-UnifiApi -Endpoint 'stat/widget/warnings' -SiteName $SiteName
    }
}
