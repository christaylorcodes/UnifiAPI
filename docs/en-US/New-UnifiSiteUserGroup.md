---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# New-UnifiSiteUserGroup

## SYNOPSIS
Creates a new user group for bandwidth limiting.

## SYNTAX

```
New-UnifiSiteUserGroup [-SiteName] <String> [-Name] <String> [[-DownloadLimit] <Int32>]
 [[-UploadLimit] <Int32>] [[-DownloadLimitMbps] <Int32>] [[-UploadLimitMbps] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new user group that can be assigned to clients or WLANs
for bandwidth rate limiting.

## EXAMPLES

### EXAMPLE 1
```
New-UnifiSiteUserGroup -SiteName 'default' -Name 'Guest-Limited' -DownloadLimit 5000 -UploadLimit 2000
```

### EXAMPLE 2
```
New-UnifiSiteUserGroup -SiteName 'default' -Name 'VIP-Users' -DownloadLimitMbps 100 -UploadLimitMbps 50
```

### EXAMPLE 3
```
New-UnifiSiteUserGroup -SiteName 'default' -Name 'Unlimited-Users'
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
The name for the user group.

```yaml
Type: String
Parameter Sets: (All)
Aliases: GroupName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadLimit
Maximum download speed in Kbps.
Use -1 for unlimited.
Default is -1 (unlimited).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -UploadLimit
Maximum upload speed in Kbps.
Use -1 for unlimited.
Default is -1 (unlimited).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadLimitMbps
Maximum download speed in Mbps (convenience parameter).
Overrides DownloadLimit if specified.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UploadLimitMbps
Maximum upload speed in Mbps (convenience parameter).
Overrides UploadLimit if specified.

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

### PSCustomObject. The created user group.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
