---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Set-UnifiWLANGroup

## SYNOPSIS
Modifies an existing WLAN group.

## SYNTAX

### ById (Default)
```
Set-UnifiWLANGroup -SiteName <String> -WLANGroupId <String> [-Name <String>] [-DeviceMacs <String[]>]
 [-AddDeviceMacs <String[]>] [-RemoveDeviceMacs <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByObject
```
Set-UnifiWLANGroup -SiteName <String> -WLANGroup <PSObject> [-Name <String>] [-DeviceMacs <String[]>]
 [-AddDeviceMacs <String[]>] [-RemoveDeviceMacs <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates properties of an existing WLAN group on the specified UniFi site.

## EXAMPLES

### EXAMPLE 1
```
Set-UnifiWLANGroup -SiteName 'default' -WLANGroupId '5f123...' -Name 'New-Group-Name'
```

### EXAMPLE 2
```
# Update a group with explicit SiteName (required)
$group = Get-UnifiWLANGroups -SiteName 'default' | Where-Object name -eq 'Lobby-APs'
Set-UnifiWLANGroup -SiteName 'default' -WLANGroupId $group._id -AddDeviceMacs '00:11:22:33:44:55'
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

### -WLANGroupId
The _id of the WLAN group to modify (from Get-UnifiWLANGroups).

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

### -WLANGroup
A WLAN group object from Get-UnifiWLANGroups.
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
New name for the WLAN group.

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

### -DeviceMacs
Array of AP MAC addresses to include in this group.
This replaces the existing list.

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

### -AddDeviceMacs
Array of AP MAC addresses to add to the existing list.

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

### -RemoveDeviceMacs
Array of AP MAC addresses to remove from the existing list.

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

### PSCustomObject. The updated WLAN group.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
