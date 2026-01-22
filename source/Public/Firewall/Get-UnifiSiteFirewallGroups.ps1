function Get-UnifiSiteFirewallGroups {
    <#
    .SYNOPSIS
        Retrieves firewall groups for a specific site.

    .DESCRIPTION
        Returns all firewall groups (IP groups, port groups) for the specified UniFi site.
        These groups can be used in firewall rules.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteFirewallGroups -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/firewallgroup' -SiteName $SiteName
    }
}
