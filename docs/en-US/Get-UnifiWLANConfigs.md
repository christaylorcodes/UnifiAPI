---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiWLANConfigs

## SYNOPSIS
Retrieves WLAN configurations for a specific site.

## SYNTAX

```
Get-UnifiWLANConfigs [-SiteName] <String> [[-Name] <String>] [[-Enabled] <Boolean>] [[-Security] <String>]
 [-GuestOnly] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns all wireless network configurations for the specified site.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiWLANConfigs -SiteName 'default'
```

### EXAMPLE 2
```
Get-UnifiWLANConfigs -SiteName 'default' | Select-Object name, security, enabled
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
Filter by SSID name. Supports wildcards.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Enabled
Filter to only enabled ($true) or disabled ($false) WLANs.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Security
Filter by security type: 'open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GuestOnly
Return only guest networks.

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
