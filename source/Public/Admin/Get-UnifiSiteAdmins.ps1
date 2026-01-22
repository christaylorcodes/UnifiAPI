function Get-UnifiSiteAdmins {
    <#
    .SYNOPSIS
        Retrieves administrators for a specific site.

    .DESCRIPTION
        Returns all administrator accounts that have access to the specified site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteAdmins -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $SiteName -Method Post -Body @{ cmd = 'get-admins' }
    }
}
