function Get-UnifiWLANGroups {
    <#
    .SYNOPSIS
        Retrieves WLAN groups for a specific site.

    .DESCRIPTION
        Returns the WLAN groups configured on the specified site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiWLANGroups -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiWLANGroups

    .OUTPUTS
        PSCustomObject. WLAN group objects.

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
        Invoke-UnifiApi -Endpoint 'rest/wlangroup' -SiteName $SiteName
    }
}
