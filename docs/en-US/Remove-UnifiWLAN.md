---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Remove-UnifiWLAN

## SYNOPSIS
Removes a wireless network (WLAN) from a site.

## SYNTAX

### ById (Default)
```
Remove-UnifiWLAN -SiteName <String> -WLANId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByObject
```
Remove-UnifiWLAN -SiteName <String> -WLAN <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes an existing WLAN configuration from the specified UniFi site.

## EXAMPLES

### EXAMPLE 1
```
Remove-UnifiWLAN -SiteName 'default' -WLANId '5f1234567890abcdef123456'
```

### EXAMPLE 2
```
# Remove a WLAN by name (SiteName always required)
$wlan = Get-UnifiWLANConfigs -SiteName 'default' | Where-Object name -eq 'Old-Network'
Remove-UnifiWLAN -SiteName 'default' -WLANId $wlan._id
```

### EXAMPLE 3
```
Remove-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -Confirm:$false
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
The _id of the WLAN to delete (from Get-UnifiWLANConfigs).

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

## RELATED LINKS
