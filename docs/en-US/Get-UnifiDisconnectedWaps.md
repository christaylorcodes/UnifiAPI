---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiDisconnectedWaps

## SYNOPSIS
Finds all disconnected wireless access points.

## SYNTAX

```
Get-UnifiDisconnectedWaps [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Scans all sites and returns WAPs that are currently disconnected,
excluding devices marked as spare.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiDisconnectedWaps
```

### EXAMPLE 2
```
Get-UnifiDisconnectedWaps | Select-Object name, site_desc, disconnected
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

### Returns device objects with additional site_desc, site_name, and disconnected properties.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
