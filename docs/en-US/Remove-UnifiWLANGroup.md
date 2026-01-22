---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Remove-UnifiWLANGroup

## SYNOPSIS
Removes a WLAN group from a site.

## SYNTAX

### ById (Default)
```
Remove-UnifiWLANGroup -SiteName <String> -WLANGroupId <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByObject
```
Remove-UnifiWLANGroup -SiteName <String> -WLANGroup <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes an existing WLAN group from the specified UniFi site.
Note: You cannot delete the default WLAN group.

## EXAMPLES

### EXAMPLE 1
```
Remove-UnifiWLANGroup -SiteName 'default' -WLANGroupId '5f1234567890abcdef123456'
```

### EXAMPLE 2
```
Get-UnifiWLANGroups -SiteName 'default' | Where-Object name -eq 'Old-Group' | Remove-UnifiWLANGroup -SiteName 'default'
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
The _id of the WLAN group to delete (from Get-UnifiWLANGroups).

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

### None.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.
The default WLAN group cannot be deleted.

## RELATED LINKS
