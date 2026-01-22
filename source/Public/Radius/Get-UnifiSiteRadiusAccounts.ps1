function Get-UnifiSiteRadiusAccounts {
    <#
    .SYNOPSIS
        Retrieves RADIUS user accounts for a specific site.

    .DESCRIPTION
        Returns all RADIUS user accounts configured for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteRadiusAccounts -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/account' -SiteName $SiteName
    }
}
