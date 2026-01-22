---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Remove-UnifiSiteUserGroup

## SYNOPSIS
Removes a user group from a site.

## SYNTAX

### ById (Default)
```
Remove-UnifiSiteUserGroup -SiteName <String> -UserGroupId <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByObject
```
Remove-UnifiSiteUserGroup -SiteName <String> -UserGroup <PSObject> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes an existing user group from the specified UniFi site.
Note: You cannot delete the default user group.

## EXAMPLES

### EXAMPLE 1
```
Remove-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f1234567890abcdef123456'
```

### EXAMPLE 2
```
Get-UnifiSiteUserGroups -SiteName 'default' | Where-Object name -eq 'Old-Group' | Remove-UnifiSiteUserGroup -SiteName 'default'
```

### EXAMPLE 3
```
Remove-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -Confirm:$false
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

### -UserGroupId
The _id of the user group to delete (from Get-UnifiSiteUserGroups).

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

### -UserGroup
A user group object from Get-UnifiSiteUserGroups.
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
The default user group cannot be deleted.
Groups that are in use by WLANs or clients cannot be deleted.

## RELATED LINKS
