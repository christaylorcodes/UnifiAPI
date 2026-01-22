function Get-UnifiSiteSettings {
    <#
    .SYNOPSIS
        Retrieves settings for a specific site.

    .DESCRIPTION
        Returns the configuration settings for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiSiteSettings -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiSiteSettings

    .OUTPUTS
        PSCustomObject. Site settings objects.

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
        Invoke-UnifiApi -Endpoint 'get/setting' -SiteName $SiteName
    }
}
