function Get-UnifiKnownRogue {
    <#
    .SYNOPSIS
        Retrieves known rogue devices for a site.

    .DESCRIPTION
        Returns devices that have been identified and categorized as known rogues.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiKnownRogue -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/rogueknown' -SiteName $SiteName
    }
}
