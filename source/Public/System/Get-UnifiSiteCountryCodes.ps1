function Get-UnifiSiteCountryCodes {
    <#
    .SYNOPSIS
        Retrieves available country codes for a specific site.

    .DESCRIPTION
        Returns the list of available country codes that can be configured
        for wireless regulatory compliance.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteCountryCodes -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'stat/ccode' -SiteName $SiteName
    }
}
