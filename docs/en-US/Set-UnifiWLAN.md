---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Set-UnifiWLAN

## SYNOPSIS
Modifies an existing wireless network (WLAN) configuration.

## SYNTAX

### ById (Default)
```
Set-UnifiWLAN -SiteName <String> -WLANId <String> [-Name <String>] [-Passphrase <String>] [-HideSSID <Boolean>]
 [-Enabled <Boolean>] [-VLAN <Int32>] [-UserGroupId <String>] [-MacFilterEnabled <Boolean>]
 [-MacFilterPolicy <String>] [-MacFilterList <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByObject
```
Set-UnifiWLAN -SiteName <String> -WLAN <PSObject> [-Name <String>] [-Passphrase <String>] [-HideSSID <Boolean>]
 [-Enabled <Boolean>] [-VLAN <Int32>] [-UserGroupId <String>] [-MacFilterEnabled <Boolean>]
 [-MacFilterPolicy <String>] [-MacFilterList <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates properties of an existing WLAN on the specified UniFi site.
Only specified parameters are changed; others remain unchanged.

## EXAMPLES

### EXAMPLE 1
```
Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -Passphrase 'NewSecurePass!'
```

### EXAMPLE 2
```
# Disable a WLAN (SiteName required when piping)
$wlan = Get-UnifiWLANConfigs -SiteName 'default' | Where-Object name -eq 'Guest-WiFi'
Set-UnifiWLAN -SiteName 'default' -WLANId $wlan._id -Enabled $false
```

### EXAMPLE 3
```
Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -VLAN 200 -HideSSID $true
```

### EXAMPLE 4
```
# Unhide an SSID
Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -HideSSID $false
```

## PARAMETERS

### -SiteName
The internal site name (not description).

```yaml
Type: String
Parameter Sets: ById
Aliases: Site

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ByObject
Aliases: Site

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WLANId
The _id of the WLAN to modify (from Get-UnifiWLANConfigs).

```yaml
Type: String
Parameter Sets: ById
Aliases: Id, _id

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WLAN
A WLAN object from Get-UnifiWLANConfigs.
Can be piped.

```yaml
Type: PSObject
Parameter Sets: ByObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
New SSID name for the wireless network.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passphrase
New network password (8-63 characters).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideSSID
Hide or show the SSID.
Use $true to hide, $false to broadcast.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Enable or disable the WLAN.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -VLAN
VLAN ID to assign.
Use 0 to disable VLAN tagging.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroupId
User group ID for bandwidth limiting.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacFilterEnabled
Enable or disable MAC address filtering.

```yaml
Type: Boolean
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacFilterList
Array of MAC addresses for the filter list.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### PSCustomObject. The updated WLAN configuration.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
