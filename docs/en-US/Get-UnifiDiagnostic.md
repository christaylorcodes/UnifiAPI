---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiDiagnostic

## SYNOPSIS
Returns diagnostic information about the UnifiAPI module and environment.

## SYNTAX

```
Get-UnifiDiagnostic [-IncludeControllerStatus] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Provides comprehensive diagnostic information including:
- Module version and installation details
- PowerShell version and edition
- Current session status and connection details
- Controller version (if connected)

Useful for troubleshooting and support requests.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiDiagnostic
# Returns module, PowerShell, and session information
```

### EXAMPLE 2
```
Get-UnifiDiagnostic -IncludeControllerStatus
# Also attempts to fetch controller status
```

## PARAMETERS

### -IncludeControllerStatus
Attempt to retrieve controller status even if not authenticated.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### PSCustomObject with diagnostic information.
## NOTES
Does not require authentication for basic diagnostics.

## RELATED LINKS
