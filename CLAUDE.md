# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UnifiAPI is a PowerShell 7.0+ (Core only) module for interacting with Ubiquiti UniFi Controller APIs. Contains 68 public functions organized across 14 functional categories.

## Build Commands

```powershell
# First-time setup (installs dependencies and builds)
.\build.ps1 -ResolveDependency

# Build module
.\build.ps1 -Tasks build

# Run unit tests
.\build.ps1 -Tasks test

# Build + test (default)
.\build.ps1

# Generate documentation (platyPS)
.\build.ps1 -Tasks docs

# Package for publishing (.nupkg)
.\build.ps1 -Tasks pack

# Format source code (PSScriptAnalyzer Invoke-Formatter)
.\build.ps1 -Tasks format

# Lint (check formatting + PSScriptAnalyzer)
.\build.ps1 -Tasks lint

# Run tests with specific tag
.\build.ps1 -Tasks test -PesterTag 'specific-tag'
```

Output goes to `output/UnifiAPI/{version}/`.

## Architecture

### Source Structure
- `source/Private/` - Internal helper functions (not exported)
  - `Invoke-UnifiRequest.ps1` - Central HTTP request handler
  - `Invoke-UnifiApiError.ps1` - Error message sanitization
  - `Build-UnifiQueryUri.ps1` - URI construction
  - `Test-UnifiMacAddress.ps1` - MAC address validation
- `source/Public/` - Exported functions organized by category:
  - `Connection/` - Connect-Unifi, Disconnect-Unifi
  - `Core/` - Invoke-UnifiApi (generic API gateway)
  - `Device/`, `Client/`, `WLAN/`, `Firewall/`, `Network/`, `Site/`, `Admin/`, `Firmware/`, `Statistics/`, `Logging/`, `Radius/`, `Rogue/`, `System/`

### Key Patterns
- Session stored as module-scoped variable (not global)
- All functions use `[CmdletBinding()]` and `[OutputType()]`
- Site-aware functions accept `-SiteName` via pipeline by property name
- Destructive functions (New-, Set-, Remove-) support `-WhatIf` and `-Confirm`
- `Invoke-UnifiApi` is the generic endpoint for any API call (supports v1/v2, pagination, raw responses)

## Code Standards

### PSScriptAnalyzer Rules (PSScriptAnalyzerSettings.psd1)
- 4-space indentation
- Opening braces on same line
- Comment-based help required for exported functions
- `PSUseSingularNouns` is intentionally excluded (functions use plurals for clarity)

### Git Commit Messages
- Use present tense, imperative mood ("Add feature" not "Added feature")
- Limit first line to 72 characters
- Reference issues/PRs after first line
- Use `[ci skip]` for documentation-only changes
- Emojis: `:art:` format, `:racehorse:` performance, `:memo:` documentation

## Testing

Tests located in `tests/Unit/Module.Tests.ps1` using Pester 5.6.1.

Test coverage includes:
- Module loading and exports
- CmdletBinding, OutputType, help synopsis on all functions
- SiteName pipeline support for site-aware functions
- WhatIf/Confirm support for destructive functions
- MAC address validation

Tags `helpQuality` and `Integration` are excluded by default.
