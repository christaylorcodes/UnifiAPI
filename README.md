<h1 align="center">
  <br>
  <img src="./Media/logo.webp" alt="UnifiAPI" height="300"></a>
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

## Features

- **68 public functions** for comprehensive UniFi Controller API management
- **Pipeline support** - Chain commands like `Get-UnifiSites | Get-UnifiDevices`
- **Automatic pagination** via `-Paginate` parameter in `Invoke-UnifiApi`
- **Generic API access** - Use `Invoke-UnifiApi` to call any endpoint directly
- **Input validation** for MAC addresses and IP addresses
- **Module-scoped session** - No global variables polluting your environment

## Functions

See the [full function reference](docs/en-US/UnifiAPI.md) for detailed documentation on all functions.

You can also use `Get-Command -Module UnifiAPI` to list available functions, or `Get-Help <FunctionName>` for help on specific functions.

### Function Categories

| Category | Functions | Description |
|----------|-----------|-------------|
| **Connection** | 2 | `Connect-Unifi`, `Disconnect-Unifi` |
| **Core** | 1 | `Invoke-UnifiApi` - Generic API access for any endpoint |
| **Site** | 15 | Site management, settings, backups, user groups, migrations |
| **Device** | 5 | Device listing, actions, removal, migration |
| **Client** | 1 | Connected client information |
| **WLAN** | 8 | Wireless network and WLAN group configuration |
| **Network** | 4 | Networks, routing, port forwards, dynamic DNS |
| **Firewall** | 3 | Firewall rules and groups |
| **Admin** | 6 | Administrator management and super admin permissions |
| **Firmware** | 3 | Firmware updates and status checking |
| **System** | 9 | Controller status, diagnostics, country codes, timezones |
| **Statistics** | 4 | Site health, events, statistics, alarm management |
| **Logging** | 2 | Logs and alerts |
| **Rogue** | 3 | Rogue AP, known rogue, and neighbor AP detection |
| **RADIUS** | 2 | RADIUS profiles and accounts |

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
