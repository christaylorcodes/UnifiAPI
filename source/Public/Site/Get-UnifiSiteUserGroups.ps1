function Get-UnifiSiteUserGroups {
    <#
    .SYNOPSIS
        Retrieves user groups for a specific site.

    .DESCRIPTION
        Returns the user groups configured for bandwidth limiting on the specified site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiSiteUserGroups -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiSiteUserGroups

    .OUTPUTS
        PSCustomObject. User group objects with bandwidth settings.

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
        Invoke-UnifiApi -Endpoint 'rest/usergroup' -SiteName $SiteName
    }
}
