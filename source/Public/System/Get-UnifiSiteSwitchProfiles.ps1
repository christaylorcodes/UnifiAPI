function Get-UnifiSiteSwitchProfiles {
    <#
    .SYNOPSIS
        Retrieves switch port profiles for a specific site.

    .DESCRIPTION
        Returns all switch port profiles (port configurations) for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteSwitchProfiles -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/portconf' -SiteName $SiteName
    }
}
