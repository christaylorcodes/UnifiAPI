---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Disconnect-Unifi

## SYNOPSIS
Disconnects from the UniFi Controller and clears the session.

## SYNTAX

```
Disconnect-Unifi [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Logs out of the UniFi Controller API and removes the stored session.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Unifi
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
Safe to call even if no session exists.

## RELATED LINKS
