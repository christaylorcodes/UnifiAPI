---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version: https://github.com/christaylorcodes/UnifiAPI/blob/main/docs/en-US/Connect-Unifi.md
schema: 2.0.0
---

# Connect-Unifi

## SYNOPSIS
Establishes a session with a UniFi Controller.

## SYNTAX

### Credential (Default)
```
Connect-Unifi -BaseURI <String> -Credential <PSCredential> [-SkipCertificateCheck] [-TimeoutSec <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### PlainText
```
Connect-Unifi -BaseURI <String> -Username <String> -Password <SecureString> [-SkipCertificateCheck]
 [-TimeoutSec <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Authenticates to a UniFi Controller and stores the session for subsequent API calls.
Supports both credential object and username/password authentication.

## EXAMPLES

### EXAMPLE 1
```
$cred = Get-Credential
Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Credential $cred
```

### EXAMPLE 2
```
Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Username 'admin' -Password (Read-Host -AsSecureString)
```

### EXAMPLE 3

```powershell
# Connect with self-signed certificate
Connect-Unifi -BaseURI 'https://192.168.1.1:8443' -Credential $cred -SkipCertificateCheck
```

## PARAMETERS

### -BaseURI
The base URL of the UniFi Controller (e.g., https://unifi.example.com:8443).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
PSCredential object containing username and password.
Recommended for security.

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username for authentication.
Use -Credential instead when possible.

```yaml
Type: String
Parameter Sets: PlainText
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password as SecureString.
Use -Credential instead when possible.

```yaml
Type: SecureString
Parameter Sets: PlainText
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Skip SSL/TLS certificate validation. Useful for self-signed certificates
commonly found on UniFi Controllers. Use with caution in production.

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

### -TimeoutSec
Connection timeout in seconds. Default is 30 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
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
The session is stored in $global:UnifiWebSession and used by all other module functions.

## RELATED LINKS
