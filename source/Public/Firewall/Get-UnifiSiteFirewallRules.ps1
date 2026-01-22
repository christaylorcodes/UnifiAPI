function Get-UnifiSiteFirewallRules {
    <#
    .SYNOPSIS
        Retrieves firewall rules for a specific site.

    .DESCRIPTION
        Returns all user-defined firewall rules for the specified UniFi site.
        Auto-generated rules are not included.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiSiteFirewallRules -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'rest/firewallrule' -SiteName $SiteName
    }
}
