function Get-UnifiSiteNetworks {
    <#
    .SYNOPSIS
        Retrieves network configurations for a specific site.

    .DESCRIPTION
        Returns all network/VLAN configurations for the specified UniFi site,
        including corporate networks, guest networks, and VLANs.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteNetworks -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | ForEach-Object { Get-UnifiSiteNetworks -SiteName $_.name }

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
        Invoke-UnifiApi -Endpoint 'rest/networkconf' -SiteName $SiteName
    }
}
