<h1 align="center">
  <br>
  <img src="./Media/Logo.webp" alt="UnifiAPI" height="300"></a>
  <br>
  UnifiAPI
  <br>
</h1>

<h4 align="center">

PowerShell module for interacting with the Ubiquiti UniFi Controller API.

</h4>

<div align="center">

[![Gallery](https://img.shields.io/powershellgallery/v/UnifiAPI?label=PS%20Gallery&logo=powershell&logoColor=white)](https://www.powershellgallery.com/packages/UnifiAPI)
[![Downloads](https://img.shields.io/powershellgallery/dt/UnifiAPI?label=Downloads&logo=powershell&logoColor=white)](https://www.powershellgallery.com/packages/UnifiAPI)
[![License](https://img.shields.io/github/license/christaylorcodes/UnifiAPI)](https://github.com/christaylorcodes/UnifiAPI/blob/main/LICENSE)
[![Donate](https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&style=flat)](https://github.com/christaylorcodes/UnifiAPI/blob/main/DONATE.md)

</div>

<p align="center">
    <a href="#functions">Functions</a> •
    <a href="#examples">Examples</a> •
    <a href="#install">Install</a> •
    <a href="https://github.com/christaylorcodes/UnifiAPI/blob/main/CONTRIBUTING.md">Contribute</a> •
    <a href="https://github.com/christaylorcodes/UnifiAPI/blob/main/CONTRIBUTING.md#reporting-bugs">Submit a Bug</a> •
    <a href="https://github.com/christaylorcodes/UnifiAPI/blob/main/CONTRIBUTING.md#suggesting-enhancements">Request a Feature</a>
</p>

<!-- Summary -->

This module provides functions to manage UniFi network infrastructure including sites, devices, clients, WLAN configurations, firewall rules, firmware updates, backups, admin management, rogue AP detection, and more.

<!-- Summary -->

## Requirements

- **PowerShell 7.0 or higher** (PowerShell Core only)
- UniFi Controller with API access

## Install

```powershell
Install-Module UnifiAPI
```

> If you are having issues accessing the PowerShell Gallery check out my [repair script](https://github.com/christaylorcodes/Initialize-PSGallery)

## Examples

```powershell
# Import the module
Import-Module UnifiAPI

# Connect to your UniFi Controller
$Credential = Get-Credential
Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Credential $Credential

# List all sites
Get-UnifiSites

# Get devices for a site
Get-UnifiDevices -SiteName 'default'

# Pipeline support - get devices for all sites
Get-UnifiSites | Get-UnifiDevices

# Get site health and statistics
Get-UnifiSiteHealth -SiteName 'default'

# Get connected clients
Get-UnifiSiteClients -SiteName 'default'

# Get all known clients with automatic pagination
Invoke-UnifiApi -Endpoint 'stat/alluser' -SiteName 'default' -Paginate

# Get firewall rules
Get-UnifiSiteFirewallRules -SiteName 'default'

# Generic API call for any endpoint
Invoke-UnifiApi -Endpoint 'stat/health' -SiteName 'default'

# Disconnect when done
Disconnect-Unifi
```

## Version 3.0.0 Breaking Changes

- **PowerShell 7.0+ required** - No longer supports Windows PowerShell 5.1
- **Removed all backward compatibility aliases** - Use the correct function names
- **Removed global `$UnifiWebSession` variable** - Session is now module-scoped only

## Functions

For the complete function reference, see the [documentation](docs/en-US/UnifiAPI.md).

You can also use `Get-Command -Module UnifiAPI` to list all available functions, or `Get-Help <FunctionName>` for detailed help on any function.

### Function Categories

| Category | Description |
|----------|-------------|
| **Connection** | `Connect-Unifi`, `Disconnect-Unifi` - Session management |
| **Core** | `Invoke-UnifiApi` - Generic API access for any endpoint |
| **Sites** | Site management, settings, backups, and migrations |
| **Devices** | Device listing, actions, and removal |
| **Clients** | Connected client information |
| **WLAN** | Wireless network configuration |
| **Network** | Networks, routing, port forwards, dynamic DNS |
| **Firewall** | Firewall rules and groups |
| **Admin** | Administrator management and permissions |
| **Firmware** | Firmware updates and status checking |
| **Rogue AP** | Rogue and neighbor AP detection |
| **Statistics** | Health, events, and statistics |
| **Logging** | Logs, alerts, and alarms |
| **Backup** | Site backup and restore |
| **System** | Controller status and system information |
| **RADIUS** | RADIUS profiles and accounts |

## Building

This module uses [Sampler](https://github.com/gaelcolas/Sampler) for build automation.

```powershell
# Install dependencies and build
.\build.ps1

# Build only
.\build.ps1 -Tasks build

# Run tests
.\build.ps1 -Tasks test

# Generate documentation (platyPS)
.\build.ps1 -Tasks docs

# Package for publishing
.\build.ps1 -Tasks pack
```

## [Contributing](https://github.com/christaylorcodes/UnifiAPI/blob/main/CONTRIBUTING.md)

If you use this project please give it a star and follow so you can get updated when new features are released. This also lets me know what projects are getting used and what ones I should dedicate more time to. If you want to get more involved please see the [contributing page](https://github.com/christaylorcodes/UnifiAPI/blob/main/CONTRIBUTING.md). Projects need all kinds of help even if you don't know how to code.

## [Donating](https://github.com/christaylorcodes/UnifiAPI/blob/main/DONATE.md)

If you cant take time to contribute maybe you would like to help another way.

It takes time to maintain this project. Does the time spent on this module help you do cool things? Is that time worth a beer or two?

Donations allow me to spend more time on this project and implement your feature requests.
