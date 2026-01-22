---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# New-UnifiWLAN

## SYNOPSIS
Creates a new wireless network (WLAN) for a specific site.

## SYNTAX

```
New-UnifiWLAN [-SiteName] <String> [-Name] <String> [-WLANGroupId] <String> [[-Security] <String>]
 [[-Passphrase] <String>] [-HideSSID] [-IsGuest] [[-VLAN] <Int32>] [[-UserGroupId] <String>]
 [[-Enabled] <Boolean>] [-MacFilterEnabled] [[-MacFilterPolicy] <String>] [[-RadiusProfileId] <String>]
 [[-PMF] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new WLAN configuration on the specified UniFi site.
Supports various security modes, guest networks, and VLAN assignment.

## EXAMPLES

### EXAMPLE 1
```
New-UnifiWLAN -SiteName 'default' -Name 'Corporate-WiFi' -WLANGroupId '123abc' -Passphrase 'SecurePass123!'
```

### EXAMPLE 2
```
New-UnifiWLAN -SiteName 'default' -Name 'Guest-WiFi' -WLANGroupId '123abc' -Passphrase 'GuestPass!' -IsGuest -VLAN 100
```

### EXAMPLE 3
```
New-UnifiWLAN -SiteName 'default' -Name 'Open-Lobby' -WLANGroupId '123abc' -Security 'open' -IsGuest
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
The SSID name for the wireless network.

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

### -WLANGroupId
The WLAN group ID to assign this network to.
Get from Get-UnifiWLANGroups.

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

### -Security
Security mode: 'open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap'.
Default is 'wpa2'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Wpa2
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passphrase
The network password.
Required for WPA2/WPA3 security modes.
Must be 8-63 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideSSID
Hide the SSID from broadcast.

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

### -IsGuest
Configure as a guest network with client isolation.

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

### -VLAN
VLAN ID to assign to this network.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroupId
User group ID for bandwidth limiting.
Get from Get-UnifiSiteUserGroups.

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

### -Enabled
Whether the WLAN is enabled.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacFilterEnabled
Enable MAC address filtering.

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

### -MacFilterPolicy
MAC filter policy: 'allow' or 'deny'.
Default is 'deny'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Deny
Accept pipeline input: False
Accept wildcard characters: False
```

### -RadiusProfileId
RADIUS profile ID for enterprise authentication.

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

### -PMF
Protected Management Frames mode: 'disabled', 'optional', 'required'.

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
{{ Fill ProgressAction Description }}

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

### PSCustomObject. The created WLAN configuration.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
