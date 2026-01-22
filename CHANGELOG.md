# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-01-21

### Initial Public Release

**Overview:**
PowerShell 7.0+ (Core only) module for comprehensive Ubiquiti UniFi Controller API management with 68 public functions organized across 14 functional categories.

**Features:**
- Generic API gateway via `Invoke-UnifiApi` supporting v1/v2 endpoints, pagination, and raw responses
- Connection management with `Connect-Unifi` and `Disconnect-Unifi`
- Comprehensive site, device, client, and WLAN management
- Firewall rule, network, and port profile configuration
- Firmware management and device provisioning
- Statistics, logging, and RADIUS server management
- Rogue AP detection and system backup/restore
- Pipeline support for `SiteName` parameter across all site-aware functions
- `WhatIf` and `Confirm` support for all destructive operations
- Full `[OutputType()]` declarations and input validation
- Centralized HTTP request handling with sanitized error messages

**Architecture:**
- Sampler/ModuleBuilder build automation
- Comprehensive Pester 5.6.1 test suite
- PSScriptAnalyzer validation
- CI/CD pipeline for automated testing and publishing
- PlatyPS-generated documentation
