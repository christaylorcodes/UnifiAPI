---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Set-UnifiSiteUserGroup

## SYNOPSIS
Modifies an existing user group.

## SYNTAX

### ById (Default)
```
Set-UnifiSiteUserGroup -SiteName <String> -UserGroupId <String> [-Name <String>] [-DownloadLimit <Int32>]
 [-UploadLimit <Int32>] [-DownloadLimitMbps <Int32>] [-UploadLimitMbps <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByObject
```
Set-UnifiSiteUserGroup -SiteName <String> -UserGroup <PSObject> [-Name <String>] [-DownloadLimit <Int32>]
 [-UploadLimit <Int32>] [-DownloadLimitMbps <Int32>] [-UploadLimitMbps <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates properties of an existing user group including name and
bandwidth limits.

## EXAMPLES

### EXAMPLE 1
```
Set-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -DownloadLimit 10000
```

### EXAMPLE 2
```
Get-UnifiSiteUserGroups -SiteName 'default' | Where-Object name -eq 'Guest' | Set-UnifiSiteUserGroup -DownloadLimitMbps 25 -UploadLimitMbps 10
```

### EXAMPLE 3
```
Set-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -Name 'New-Group-Name'
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
The _id of the user group to modify (from Get-UnifiSiteUserGroups).

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

### -Name
New name for the user group.

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

### -DownloadLimit
Maximum download speed in Kbps.
Use -1 for unlimited.

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

### -UploadLimit
Maximum upload speed in Kbps.
Use -1 for unlimited.

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

### -DownloadLimitMbps
Maximum download speed in Mbps (convenience parameter).

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

### -UploadLimitMbps
Maximum upload speed in Mbps (convenience parameter).

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

### PSCustomObject. The updated user group.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
