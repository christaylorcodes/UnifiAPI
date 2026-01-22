---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Invoke-UnifiDeviceAction

## SYNOPSIS
Performs actions on UniFi devices.

## SYNTAX

```
Invoke-UnifiDeviceAction [-SiteName] <String> [[-MacAddress] <String>] [-Action] <String> [[-Port] <Int32>]
 [[-FirmwareUrl] <String>] [[-Credential] <PSCredential>] [[-SshUrl] <String>] [[-DeviceId] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Executes various management actions on UniFi devices including restart, adopt,
provision, locate, power cycle, speed test, and spectrum scan.

## EXAMPLES

### EXAMPLE 1
```
Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'restart'
```

### EXAMPLE 2
```
Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'locate'
```

### EXAMPLE 3
```
Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'power-cycle' -Port 5
```

### EXAMPLE 4
```
Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'upgrade' -FirmwareUrl 'https://example.com/firmware.bin'
```

### EXAMPLE 5
```
Invoke-UnifiDeviceAction -SiteName 'default' -Action 'speedtest'
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

### -MacAddress
The MAC address of the target device.

```yaml
Type: String
Parameter Sets: (All)
Aliases: mac

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Action
The action to perform:
- 'restart': Reboot the device
- 'adopt': Adopt a pending device
- 'provision': Force re-provision the device
- 'locate': Start LED blinking for physical identification
- 'unlocate': Stop LED blinking
- 'upgrade': Upgrade firmware to latest version
- 'speedtest': Start a speed test (gateway only)
- 'speedtest-status': Get speed test results
- 'power-cycle': Power cycle a switch port (requires -Port)
- 'spectrum-scan': Start RF spectrum scan (AP only)

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

### -Port
Switch port number for power-cycle action.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirmwareUrl
Custom firmware URL for upgrade action.

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

### -Credential
PSCredential with SSH username/password for adopt-advanced action.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SshUrl
SSH URL for adopt-advanced action (e.g., 'ssh://192.168.1.20:22').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
Device _id for LED and enable/disable actions (from Get-UnifiDevices).

```yaml
Type: String
Parameter Sets: (All)
Aliases: _id, Id

Required: False
Position: 8
Default value: None
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
