---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiAlert

## SYNOPSIS
Retrieves system alerts for a site (v2 API).

## SYNTAX

```
Get-UnifiAlert [-SiteName] <String> [[-Days] <Int32>] [[-Categories] <String[]>] [[-PageSize] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns Next-AI alerts from the UniFi Controller v2 API for the specified time period.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiAlert -SiteName 'default' -Days 7
```

### EXAMPLE 2
```
Get-UnifiAlert -SiteName 'default' -Days 30 -Categories @('DEVICE', 'INTERNET')
```

## PARAMETERS

### -SiteName
The internal site name (not description).

```yaml
Type: String
Parameter Sets: (All)
Aliases: name, Site

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Days
Number of days to look back for alerts.
Default is 7.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### -Categories
Alert categories to retrieve.
Default includes DEVICE, CLIENT, INTERNET, VPN.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @('DEVICE', 'CLIENT', 'INTERNET', 'VPN')
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of alerts per page.
Default is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 100
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
Uses the v2 API endpoint.

## RELATED LINKS
