---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiSiteStatistics

## SYNOPSIS
Retrieves statistics for a specific site.

## SYNTAX

```
Get-UnifiSiteStatistics [-SiteName] <String> [-Type] <String> [-Interval] <String> [[-Start] <DateTime>]
 [[-End] <DateTime>] [[-MacAddress] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns detailed statistics for access points, gateways, switches, or the entire site.
Statistics include traffic, performance metrics, and client counts.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiSiteStatistics -SiteName 'default' -Type 'site' -Interval 'hourly'
```

### EXAMPLE 2
```
Get-UnifiSiteStatistics -SiteName 'default' -Type 'ap' -Interval 'daily' -Start (Get-Date).AddDays(-7)
```

### EXAMPLE 3
```
Get-UnifiSiteStatistics -SiteName 'default' -Type 'gw' -Interval '5minutes' -MacAddress '00:11:22:33:44:55'
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

### -Type
Type of statistics to retrieve:
- 'site': Overall site statistics
- 'ap': Access point statistics
- 'gw': Gateway statistics
- 'sw': Switch statistics

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

### -Interval
Time interval for statistics:
- '5minutes': 5-minute intervals
- 'hourly': Hourly intervals
- 'daily': Daily intervals

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

### -Start
Start date/time for the statistics range.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
End date/time for the statistics range.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacAddress
Filter statistics by device MAC address(es).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
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

## RELATED LINKS
