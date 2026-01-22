---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# New-UnifiSiteFirewallRule

## SYNOPSIS
Creates a new firewall rule for a specific site.

## SYNTAX

```
New-UnifiSiteFirewallRule [-SiteName] <String> [-Name] <String> [-Action] <String> [-RuleSet] <String>
 [[-Protocol] <String>] [[-SourceType] <String>] [[-SourceAddress] <String>] [[-SourceNetworkId] <String>]
 [[-DestinationType] <String>] [[-DestinationAddress] <String>] [[-DestinationNetworkId] <String>]
 [[-DestinationPort] <String>] [[-Enabled] <Boolean>] [-Logging] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new user-defined firewall rule for the specified UniFi site.

## EXAMPLES

### EXAMPLE 1
```
New-UnifiSiteFirewallRule -SiteName 'default' -Name 'Block SSH' -Action 'drop' -RuleSet 'WAN_IN' -Protocol 'tcp' -DestinationPort '22'
```

### EXAMPLE 2
```
New-UnifiSiteFirewallRule -SiteName 'default' -Name 'Allow HTTPS' -Action 'accept' -RuleSet 'WAN_IN' -Protocol 'tcp' -DestinationPort '443' -Logging
```

## PARAMETERS

### -SiteName
The internal site name (not description).

```yaml
Type: String
Parameter Sets: (All)
Aliases: Site

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name for the firewall rule.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
Action to take: 'accept', 'drop', or 'reject'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RuleSet
Which ruleset to add the rule to: 'WAN_IN', 'WAN_OUT', 'WAN_LOCAL',
'LAN_IN', 'LAN_OUT', 'LAN_LOCAL', 'GUEST_IN', 'GUEST_OUT', 'GUEST_LOCAL'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Protocol to match: 'all', 'tcp', 'udp', 'icmp', 'tcp_udp', or protocol number.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceType
Source address type: 'ADDRv4' for IP/subnet or 'NETv4' for network.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceAddress
Source IP address or CIDR subnet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceNetworkId
Source network ID (from Get-UnifiSiteNetworks).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationType
Destination address type: 'ADDRv4' for IP/subnet or 'NETv4' for network.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationAddress
Destination IP address or CIDR subnet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationNetworkId
Destination network ID (from Get-UnifiSiteNetworks).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPort
Destination port or port range (e.g., '80', '80-443', '22,80,443').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Whether the rule is enabled.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Logging
Enable logging for this rule.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
Controls how the cmdlet responds to progress updates from background jobs or remote commands. Has no effect on cmdlet output.

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
