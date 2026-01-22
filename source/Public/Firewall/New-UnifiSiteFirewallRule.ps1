function New-UnifiSiteFirewallRule {
    <#
    .SYNOPSIS
        Creates a new firewall rule for a specific site.

    .DESCRIPTION
        Creates a new user-defined firewall rule for the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Name
        Name for the firewall rule.

    .PARAMETER Action
        Action to take: 'accept', 'drop', or 'reject'.

    .PARAMETER RuleSet
        Which ruleset to add the rule to: 'WAN_IN', 'WAN_OUT', 'WAN_LOCAL',
        'LAN_IN', 'LAN_OUT', 'LAN_LOCAL', 'GUEST_IN', 'GUEST_OUT', 'GUEST_LOCAL'.

    .PARAMETER Protocol
        Protocol to match: 'all', 'tcp', 'udp', 'icmp', 'tcp_udp', or protocol number.

    .PARAMETER SourceType
        Source address type: 'ADDRv4' for IP/subnet or 'NETv4' for network.

    .PARAMETER SourceAddress
        Source IP address or CIDR subnet.

    .PARAMETER SourceNetworkId
        Source network ID (from Get-UnifiSiteNetworks).

    .PARAMETER DestinationType
        Destination address type: 'ADDRv4' for IP/subnet or 'NETv4' for network.

    .PARAMETER DestinationAddress
        Destination IP address or CIDR subnet.

    .PARAMETER DestinationNetworkId
        Destination network ID (from Get-UnifiSiteNetworks).

    .PARAMETER DestinationPort
        Destination port or port range (e.g., '80', '80-443', '22,80,443').

    .PARAMETER Enabled
        Whether the rule is enabled. Default is $true.

    .PARAMETER Logging
        Enable logging for this rule.

    .EXAMPLE
        New-UnifiSiteFirewallRule -SiteName 'default' -Name 'Block SSH' -Action 'drop' -RuleSet 'WAN_IN' -Protocol 'tcp' -DestinationPort '22'

    .EXAMPLE
        New-UnifiSiteFirewallRule -SiteName 'default' -Name 'Allow HTTPS' -Action 'accept' -RuleSet 'WAN_IN' -Protocol 'tcp' -DestinationPort '443' -Logging

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('accept', 'drop', 'reject')]
        [string]$Action,

        [Parameter(Mandatory)]
        [ValidateSet('WAN_IN', 'WAN_OUT', 'WAN_LOCAL', 'LAN_IN', 'LAN_OUT', 'LAN_LOCAL', 'GUEST_IN', 'GUEST_OUT', 'GUEST_LOCAL')]
        [string]$RuleSet,

        [Parameter()]
        [string]$Protocol = 'all',

        [Parameter()]
        [ValidateSet('ADDRv4', 'NETv4')]
        [string]$SourceType,

        [Parameter()]
        [string]$SourceAddress,

        [Parameter()]
        [string]$SourceNetworkId,

        [Parameter()]
        [ValidateSet('ADDRv4', 'NETv4')]
        [string]$DestinationType,

        [Parameter()]
        [string]$DestinationAddress,

        [Parameter()]
        [string]$DestinationNetworkId,

        [Parameter()]
        [string]$DestinationPort,

        [Parameter()]
        [bool]$Enabled = $true,

        [Parameter()]
        [switch]$Logging
    )

    $Body = @{
        name          = $Name
        action        = $Action
        ruleset       = $RuleSet
        protocol      = $Protocol
        enabled       = $Enabled
        logging       = $Logging.IsPresent
        protocol_match_excepted = $false
    }

    # Source configuration
    if ($SourceType -and $SourceAddress) {
        $Body.src_firewallgroup_ids = @()
        $Body.src_mac_address = ''
        $Body.src_address = $SourceAddress
        $Body.src_networkconf_type = $SourceType
    }
    elseif ($SourceNetworkId) {
        $Body.src_networkconf_id = $SourceNetworkId
        $Body.src_networkconf_type = 'NETv4'
    }

    # Destination configuration
    if ($DestinationType -and $DestinationAddress) {
        $Body.dst_firewallgroup_ids = @()
        $Body.dst_address = $DestinationAddress
        $Body.dst_networkconf_type = $DestinationType
    }
    elseif ($DestinationNetworkId) {
        $Body.dst_networkconf_id = $DestinationNetworkId
        $Body.dst_networkconf_type = 'NETv4'
    }

    if ($DestinationPort) {
        $Body.dst_port = $DestinationPort
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create firewall rule')) {
        Invoke-UnifiApi -Endpoint 'rest/firewallrule' -SiteName $SiteName -Method Post -Body $Body
    }
}
