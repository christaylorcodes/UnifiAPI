# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | :white_check_mark: |
| < 2.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability within UnifiAPI, please take the following steps:

1. **Do NOT** open a public GitHub issue for security vulnerabilities
2. Email the maintainer directly at the email address listed in the module manifest
3. Include as much detail as possible:
   - Type of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Best Practices

When using this module, follow these security recommendations:

### Credential Management

- **Never hardcode credentials** in scripts
- Use secure credential storage:
  - PowerShell `Get-Credential` for interactive sessions
  - Environment variables for CI/CD pipelines
  - Azure Key Vault or similar secrets management for production

```powershell
# Good - Interactive
$Credential = Get-Credential
Connect-Unifi -BaseURI $ControllerUrl -Credential $Credential

# Good - CI/CD with environment variables
$SecurePassword = ConvertTo-SecureString $env:UNIFI_PASSWORD -AsPlainText -Force
$Credential = New-Object PSCredential($env:UNIFI_USERNAME, $SecurePassword)
Connect-Unifi -BaseURI $env:UNIFI_CONTROLLER_URL -Credential $Credential

# Bad - Never do this
Connect-Unifi -BaseURI 'https://unifi:8443' -Credential (New-Object PSCredential('admin', (ConvertTo-SecureString 'password123' -AsPlainText -Force)))
```

### Network Security

- Always use HTTPS connections to your UniFi Controller
- Verify SSL certificates in production environments
- Use dedicated API accounts with minimal required permissions

### Session Management

- Call `Disconnect-Unifi` when finished to clean up sessions
- Avoid storing session objects in persistent locations

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week
- **Resolution Target**: Depends on severity
  - Critical: As soon as possible
  - High: Within 2 weeks
  - Medium: Within 1 month
  - Low: Next regular release

## Recognition

We appreciate responsible disclosure and will acknowledge security researchers who report valid vulnerabilities (unless they prefer to remain anonymous).
