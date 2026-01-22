function Get-UnifiSiteTags {
    <#
    .SYNOPSIS
        Retrieves tags for a specific site.

    .DESCRIPTION
        Returns all tags configured for the specified UniFi site.
        Tags can be used to organize and categorize devices.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteTags -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/tag' -SiteName $SiteName
    }
}
