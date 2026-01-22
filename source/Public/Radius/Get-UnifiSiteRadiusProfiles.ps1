function Get-UnifiSiteRadiusProfiles {
    <#
    .SYNOPSIS
        Retrieves RADIUS profiles for a specific site.

    .DESCRIPTION
        Returns all RADIUS server profiles configured for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteRadiusProfiles -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/radiusprofile' -SiteName $SiteName
    }
}
