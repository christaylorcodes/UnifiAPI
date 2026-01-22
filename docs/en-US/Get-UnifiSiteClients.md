---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Get-UnifiSiteClients

## SYNOPSIS
Retrieves connected clients for a specific site.

## SYNTAX

### Current (Default)
```
Get-UnifiSiteClients -SiteName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Known
```
Get-UnifiSiteClients -SiteName <String> [-Known] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Guest
```
Get-UnifiSiteClients -SiteName <String> [-Guest] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByMac
```
Get-UnifiSiteClients -SiteName <String> [-MacAddress <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ActiveWithin
```
Get-UnifiSiteClients -SiteName <String> [-ActiveWithinHours <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns all currently connected clients (stations) for the specified UniFi site.
Use the -Known switch to retrieve all known clients (historical), which can be a large list.

## EXAMPLES

### EXAMPLE 1
```
Get-UnifiSiteClients -SiteName 'default'
# Returns currently connected clients
```

### EXAMPLE 2
```
Get-UnifiSiteClients -SiteName 'default' -Known
# Returns all known clients (historical)
```

### EXAMPLE 3
```
Get-UnifiSites | ForEach-Object { Get-UnifiSiteClients -SiteName $_.name }
```

## PARAMETERS

### -SiteName
The internal site name (not description).

```yaml
Type: String
Parameter Sets: (All)
Aliases: name, Site

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Known
Switch to retrieve all known clients (historical) instead of just currently connected ones.

```yaml
Type: SwitchParameter
Parameter Sets: Known
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Guest
Retrieve only guest clients.

```yaml
Type: SwitchParameter
Parameter Sets: Guest
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacAddress
Get a specific client by MAC address.

```yaml
Type: String
Parameter Sets: ByMac
Aliases: mac

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveWithinHours
Get clients that were active within the specified number of hours.
Returns historical data based on activity time.

```yaml
Type: Int32
Parameter Sets: ActiveWithin
Aliases:

Required: False
Position: Named
Default value: 0
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
