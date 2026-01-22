<h1 align="center">
  <br>
  <img src="./Media/logo.webp" alt="UnifiAPI" height="300"></a>
  <br>
  UnifiAPI
  <br>
</h1>

<h4 align="center">

A PowerShell module for managing Ubiquiti UniFi infrastructure via the Controller API.

</h4>

<div align="center">

[![PSGallery Version](https://img.shields.io/powershellgallery/v/UnifiAPI?label=PSGallery&logo=powershell&logoColor=white)](https://www.powershellgallery.com/packages/UnifiAPI)
[![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/UnifiAPI?label=Downloads&logo=powershell&logoColor=white)](https://www.powershellgallery.com/packages/UnifiAPI)
[![CI](https://github.com/christaylorcodes/UnifiAPI/actions/workflows/ci.yml/badge.svg)](https://github.com/christaylorcodes/UnifiAPI/actions/workflows/ci.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/d101c07f796c434cb56250ae80ec275c)](https://app.codacy.com/gh/christaylorcodes/UnifiAPI/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![License](https://img.shields.io/github/license/christaylorcodes/UnifiAPI)](https://github.com/christaylorcodes/UnifiAPI/blob/main/LICENSE)

</div>

<p align="center">
    <a href="#-quick-start">Quick Start</a> &bull;
    <a href="#-installation">Installation</a> &bull;
    <a href="#-features">Features</a> &bull;
    <a href="#-examples">Examples</a> &bull;
    <a href="#-documentation">Documentation</a> &bull;
    <a href="#-troubleshooting">Troubleshooting</a> &bull;
    <a href="CONTRIBUTING.md">Contributing</a>
</p>

---

## Overview

UnifiAPI provides **68 PowerShell functions** for comprehensive management of Ubiquiti UniFi network infrastructure. Manage sites, devices, clients, WLANs, firewall rules, firmware, and more - all from PowerShell.

## Requirements

| Requirement | Version |
|-------------|---------|
| PowerShell | 7.0+ (Core only) |
| UniFi Controller | 5.x, 6.x, 7.x, 8.x |

> **Note:** Windows PowerShell 5.1 is not supported. This module requires PowerShell Core.

## Installation

```powershell
Install-Module -Name UnifiAPI
```

<details>
<summary>Having trouble with PowerShell Gallery?</summary>

If you're experiencing issues accessing the PowerShell Gallery, try this [repair script](https://github.com/christaylorcodes/Initialize-PSGallery).

</details>

## Quick Start

```powershell
# Import the module
Import-Module UnifiAPI

# Connect to your controller
Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Credential (Get-Credential)

# List all sites
Get-UnifiSites

# Get devices for a specific site
Get-UnifiDevices -SiteName 'default'

# Disconnect when done
Disconnect-Unifi
```

## Features

- **Comprehensive Coverage** - 68 functions across 14 categories
- **Pipeline Support** - Chain commands like `Get-UnifiSites | Get-UnifiDevices`
- **Automatic Pagination** - Handle large datasets with `-Paginate`
- **Generic API Access** - Call any endpoint with `Invoke-UnifiApi`
- **Input Validation** - Built-in MAC and IP address validation
- **Safe Operations** - `-WhatIf` and `-Confirm` for destructive commands
- **Modern PowerShell** - Full `[CmdletBinding()]` and `[OutputType()]` support

## Examples

### Basic Operations

```powershell
# Get all sites and their health status
Get-UnifiSites | Get-UnifiSiteHealth

# Find all devices across all sites
Get-UnifiSites | Get-UnifiDevices

# Get connected clients for a site
Get-UnifiSiteClients -SiteName 'default'
```

### WLAN Management

```powershell
# List all wireless networks
Get-UnifiWLANConfigs -SiteName 'default'

# Create a new WLAN (supports -WhatIf)
New-UnifiWLAN -SiteName 'default' -Name 'Guest-WiFi' -Passphrase 'SecurePass123' -WhatIf
```

### Device Operations

```powershell
# Restart a device
Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress 'AA:BB:CC:DD:EE:FF' -Action restart

# Check firmware status
Test-UnifiFirmwareStatus -SiteName 'default'

# Update firmware on all devices
Update-UnifiFirmware -SiteName 'default'
```

### Firewall & Security

```powershell
# Get firewall rules
Get-UnifiSiteFirewallRules -SiteName 'default'

# Detect rogue access points
Get-UnifiRogue -SiteName 'default'
```

### Generic API Access

```powershell
# Call any API endpoint directly
Invoke-UnifiApi -Endpoint 'stat/health' -SiteName 'default'

# With automatic pagination for large datasets
Invoke-UnifiApi -Endpoint 'stat/alluser' -SiteName 'default' -Paginate

# POST request with body
Invoke-UnifiApi -Endpoint 'cmd/stamgr' -SiteName 'default' -Method Post -Body @{
    cmd = 'kick-sta'
    mac = 'AA:BB:CC:DD:EE:FF'
}
```

### Backup & Restore

```powershell
# Download site backup
Get-UnifiSiteBackup -SiteName 'default' -Path './backup.unf'

# Restore from backup
Import-UnifiSiteBackup -SiteName 'default' -Path './backup.unf'
```

## Documentation

### Function Reference

See the [full documentation](docs/en-US/UnifiAPI.md) for detailed help on all functions.

```powershell
# List all available commands
Get-Command -Module UnifiAPI

# Get help for a specific function
Get-Help Connect-Unifi -Full
Get-Help Get-UnifiDevices -Examples
```

<details>
<summary><strong>Function Categories (click to expand)</strong></summary>

| Category | Count | Description |
|----------|-------|-------------|
| **Connection** | 2 | `Connect-Unifi`, `Disconnect-Unifi` |
| **Core** | 1 | `Invoke-UnifiApi` - Generic API gateway |
| **Site** | 15 | Site management, settings, backups, migrations |
| **Device** | 5 | Device listing, actions, removal, migration |
| **Client** | 1 | Connected client information |
| **WLAN** | 8 | Wireless networks and WLAN groups |
| **Network** | 4 | Networks, routing, port forwards, DDNS |
| **Firewall** | 3 | Firewall rules and groups |
| **Admin** | 6 | Administrator and super admin management |
| **Firmware** | 3 | Firmware updates and status |
| **System** | 9 | Controller status, diagnostics, timezones |
| **Statistics** | 4 | Health, events, statistics, alarms |
| **Logging** | 2 | Logs and alerts |
| **Rogue** | 3 | Rogue AP and neighbor detection |
| **RADIUS** | 2 | RADIUS profiles and accounts |

</details>

## Troubleshooting

### SSL Certificate Errors

If connecting to a controller with a self-signed certificate:

```powershell
# Option 1: Skip certificate validation (development only)
Connect-Unifi -BaseURI 'https://unifi:8443' -Credential $cred -SkipCertificateCheck

# Option 2: Add certificate to trusted store (recommended for production)
# Import your controller's certificate to the trusted root store
```

### Authentication Failed

- Verify credentials work in the UniFi web interface
- Ensure the account has API access enabled
- Check if 2FA is enabled (may require app password)

### Connection Timeout

```powershell
# Default timeout is 30 seconds. For slow connections:
Connect-Unifi -BaseURI 'https://unifi:8443' -Credential $cred -TimeoutSec 60
```

### "Site not found" Errors

```powershell
# List available sites to find the correct name
Get-UnifiSites | Select-Object name, desc

# Site names are case-sensitive and use the 'name' property, not 'desc'
```

### Module Not Loading

```powershell
# Verify PowerShell version (must be 7.0+)
$PSVersionTable.PSVersion

# Check if module is installed
Get-Module -ListAvailable UnifiAPI
```

## Building from Source

This module uses [Sampler](https://github.com/gaelcolas/Sampler) for build automation.

```powershell
# First-time setup
./build.ps1 -ResolveDependency

# Build
./build.ps1 -Tasks build

# Test
./build.ps1 -Tasks test

# Build + Test (default)
./build.ps1
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

- [Report a Bug](https://github.com/christaylorcodes/UnifiAPI/issues/new?template=bug_report.md)
- [Request a Feature](https://github.com/christaylorcodes/UnifiAPI/issues/new?template=feature_request.md)

## Support

If this module helps you manage your UniFi infrastructure, consider:

- Giving the project a star
- [Contributing](CONTRIBUTING.md) code or documentation
- [Donating](DONATE.md) to support development

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
