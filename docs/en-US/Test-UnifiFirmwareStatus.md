---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Test-UnifiFirmwareStatus

## SYNOPSIS
Checks if any devices need firmware updates.

## SYNTAX

```
Test-UnifiFirmwareStatus [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Scans all sites and reports whether firmware updates are available.

## EXAMPLES

### EXAMPLE 1
```
Test-UnifiFirmwareStatus
```

## PARAMETERS

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

### Returns an object indicating firmware status across all sites.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
