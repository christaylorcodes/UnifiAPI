---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiControllerStatus

## SYNOPSIS
Retrieves the status of the UniFi controller.

## SYNTAX

```
Get-UnifiControllerStatus [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns basic status information about the UniFi controller
without requiring authentication.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiControllerStatus
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

## NOTES
This endpoint does not require authentication.
Requires an active UniFi session for the base URL.
Use Connect-Unifi first.

## RELATED LINKS
