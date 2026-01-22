---
external help file: UnifiAPI-help.xml
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Set-UnifiSiteSettings

## SYNOPSIS
Updates site settings for a specific site.

## SYNTAX

```
Set-UnifiSiteSettings [-SiteName] <String> [-SettingKey] <String> [-SettingId] <String>
 [[-Settings] <Hashtable>] [[-CountryCode] <String>] [[-Timezone] <String>] [[-LEDEnabled] <Boolean>]
 [[-AlertEnabled] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Modifies site-level settings including country, timezone, management,
guest access, and connectivity options.

## EXAMPLES

### EXAMPLE 1
```
Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'country' -SettingId '5f123...' -CountryCode 'US'
```

### EXAMPLE 2
```
Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'locale' -SettingId '5f123...' -Timezone 'America/Chicago'
```

### EXAMPLE 3
```
Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'mgmt' -SettingId '5f123...' -LEDEnabled $true
```

### EXAMPLE 4
```
# Advanced: Pass custom settings hashtable
$settings = @{ ntp_server_1 = 'pool.ntp.org' }
Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'ntp' -SettingId '5f123...' -Settings $settings
```

## PARAMETERS

### -SiteName
The internal site name (not description).

```yaml
Type: String
Parameter Sets: (All)
Aliases: Site, name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SettingKey
The setting category to update.
Valid values:
- 'country': Country/region code
- 'locale': Timezone and language
- 'mgmt': Management settings (LED, alerts)
- 'guest_access': Guest portal configuration
- 'ntp': NTP server settings
- 'connectivity': Uplink monitoring
- 'snmp': SNMP configuration

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

### -SettingId
The _id of the setting to update (from Get-UnifiSiteSettings).

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id, _id

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Settings
Hashtable of settings to apply.
Properties vary by SettingKey.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountryCode
Country code (e.g., 'US', 'GB', 'DE').
Use with -SettingKey 'country'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timezone
Timezone string (e.g., 'America/New_York').
Use with -SettingKey 'locale'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LEDEnabled
Enable/disable device LEDs.
Use with -SettingKey 'mgmt'.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertEnabled
Enable/disable alerts.
Use with -SettingKey 'mgmt'.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
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

### PSCustomObject. The updated setting object.
## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.
Use Get-UnifiSiteSettings to retrieve current settings and their _id values.

## RELATED LINKS
