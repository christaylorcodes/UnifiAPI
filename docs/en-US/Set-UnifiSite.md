---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Set-UnifiSite

## SYNOPSIS
Updates the description (display name) of an existing site.

## SYNTAX

### ByName (Default)
```
Set-UnifiSite -SiteName <String> -Description <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ByObject
```
Set-UnifiSite -Site <PSObject> -Description <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Renames a site by updating its description/display name.
The internal site name cannot be changed.

## EXAMPLES

### EXAMPLE 1
```
Set-UnifiSite -SiteName 'abc123xyz' -Description 'Client ABC - New Name'
```

### EXAMPLE 2
```
Get-UnifiSites | Where-Object desc -like '*Old Name*' | Set-UnifiSite -Description 'New Name'
```

## PARAMETERS

### -SiteName
The internal site name (not description) to update.

```yaml
Type: String
Parameter Sets: ByName
Aliases: name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Site
A site object from Get-UnifiSites.
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

### -Description
The new display name/description for the site.

```yaml
Type: String
Parameter Sets: (All)
Aliases: NewName, Desc

Required: True
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

### PSCustomObject. The updated site object.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
