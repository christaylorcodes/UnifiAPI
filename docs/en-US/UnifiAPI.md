---
Module Name: UnifiAPI
Module Guid: 62f26195-5ab9-4248-9639-0514f31bb0f8
Download Help Link: https://github.com/christaylorcodes/UnifiAPI/tree/main/docs/en-US
Help Version: 2.0.0
Locale: en-US
---

# UnifiAPI Module

## Description

PowerShell module for interacting with the Ubiquiti UniFi Controller API. Provides functions to manage UniFi network infrastructure including sites, devices, clients, WLAN configurations, firewall rules, firmware updates, backups, admin management, and more.

## UnifiAPI Cmdlets

### [Connect-Unifi](Connect-Unifi.md)

Establishes a session with a UniFi Controller.

### [Disconnect-Unifi](Disconnect-Unifi.md)

Closes the current UniFi Controller session.

### [Invoke-UnifiApi](Invoke-UnifiApi.md)

Makes a generic API call to any UniFi Controller endpoint.

### [Get-UnifiSites](Get-UnifiSites.md)

Retrieves all sites from the UniFi Controller.

### [Get-UnifiSiteSettings](Get-UnifiSiteSettings.md)

Retrieves settings for a specific site.

### [Get-UnifiSiteHealth](Get-UnifiSiteHealth.md)

Retrieves health status for a specific site.

### [Get-UnifiSiteSystemInfo](Get-UnifiSiteSystemInfo.md)

Retrieves system information for a specific site.

### [Get-UnifiSiteCountryCodes](Get-UnifiSiteCountryCodes.md)

Retrieves available country codes for regulatory compliance.

### [Get-UnifiSiteTimezones](Get-UnifiSiteTimezones.md)

Retrieves available timezones for site configuration.

### [Get-UnifiSiteTags](Get-UnifiSiteTags.md)

Retrieves tags configured for a specific site.

### [Remove-UnifiSite](Remove-UnifiSite.md)

Removes a site from the UniFi Controller.

### [Get-UnifiDevices](Get-UnifiDevices.md)

Retrieves devices for a specific site.

### [Get-UnifiDisconnectedWaps](Get-UnifiDisconnectedWaps.md)

Retrieves disconnected wireless access points.

### [Invoke-UnifiDeviceAction](Invoke-UnifiDeviceAction.md)

Performs an action on a UniFi device (restart, adopt, etc.).

### [Remove-UnifiDevice](Remove-UnifiDevice.md)

Removes a device from the UniFi Controller.

### [Set-UnifiDeviceMigration](Set-UnifiDeviceMigration.md)

Configures device migration to another controller.

### [Get-UnifiSiteClients](Get-UnifiSiteClients.md)

Retrieves connected clients for a specific site.

### [Get-UnifiSiteUserGroups](Get-UnifiSiteUserGroups.md)

Retrieves user groups configured for a specific site.

### [Get-UnifiWLANConfigs](Get-UnifiWLANConfigs.md)

Retrieves WLAN configurations for a specific site.

### [Get-UnifiWLANGroups](Get-UnifiWLANGroups.md)

Retrieves WLAN groups for a specific site.

### [Get-UnifiSiteNetworks](Get-UnifiSiteNetworks.md)

Retrieves network configurations for a specific site.

### [Get-UnifiSiteRouting](Get-UnifiSiteRouting.md)

Retrieves routing configuration for a specific site.

### [Get-UnifiSitePortForwards](Get-UnifiSitePortForwards.md)

Retrieves port forwarding rules for a specific site.

### [Get-UnifiSiteDynamicDNS](Get-UnifiSiteDynamicDNS.md)

Retrieves dynamic DNS configuration for a specific site.

### [Get-UnifiSiteSwitchProfiles](Get-UnifiSiteSwitchProfiles.md)

Retrieves switch port profiles for a specific site.

### [Get-UnifiSiteFirewallRules](Get-UnifiSiteFirewallRules.md)

Retrieves firewall rules for a specific site.

### [Get-UnifiSiteFirewallGroups](Get-UnifiSiteFirewallGroups.md)

Retrieves firewall groups for a specific site.

### [New-UnifiSiteFirewallRule](New-UnifiSiteFirewallRule.md)

Creates a new firewall rule for a specific site.

### [Get-UnifiAdmins](Get-UnifiAdmins.md)

Retrieves all administrators from the UniFi Controller.

### [Get-UnifiSiteAdmins](Get-UnifiSiteAdmins.md)

Retrieves administrators for a specific site.

### [Get-UnifiCurrentUser](Get-UnifiCurrentUser.md)

Retrieves information about the currently authenticated user.

### [New-UnifiSiteAdmin](New-UnifiSiteAdmin.md)

Creates a new administrator for a specific site.

### [Remove-UnifiSiteAdmin](Remove-UnifiSiteAdmin.md)

Removes an administrator from a specific site.

### [Grant-UnifiSuperAdmin](Grant-UnifiSuperAdmin.md)

Grants super admin privileges to an administrator.

### [Revoke-UnifiSuperAdmin](Revoke-UnifiSuperAdmin.md)

Revokes super admin privileges from an administrator.

### [Get-UnifiFirmware](Get-UnifiFirmware.md)

Retrieves available firmware for UniFi devices.

### [Test-UnifiFirmwareStatus](Test-UnifiFirmwareStatus.md)

Tests firmware update status for devices.

### [Update-UnifiFirmware](Update-UnifiFirmware.md)

Updates firmware on UniFi devices.

### [Get-UnifiRogue](Get-UnifiRogue.md)

Retrieves detected rogue access points.

### [Get-UnifiKnownRogue](Get-UnifiKnownRogue.md)

Retrieves known rogue access points.

### [Get-UnifiNeighborAP](Get-UnifiNeighborAP.md)

Retrieves neighboring access points.

### [Get-UnifiSiteStatistics](Get-UnifiSiteStatistics.md)

Retrieves statistics for a specific site.

### [Get-UnifiSiteEvents](Get-UnifiSiteEvents.md)

Retrieves events for a specific site.

### [Get-UnifiEventStrings](Get-UnifiEventStrings.md)

Retrieves event string definitions.

### [Get-UnifiLog](Get-UnifiLog.md)

Retrieves logs from the UniFi Controller.

### [Get-UnifiAlert](Get-UnifiAlert.md)

Retrieves alerts from the UniFi Controller.

### [Get-UnifiSiteAlarms](Get-UnifiSiteAlarms.md)

Retrieves alarms for a specific site.

### [Get-UnifiSiteWarnings](Get-UnifiSiteWarnings.md)

Retrieves warnings for a specific site.

### [Clear-UnifiSiteAlarm](Clear-UnifiSiteAlarm.md)

Clears alarms for a specific site.

### [Get-UnifiSiteBackup](Get-UnifiSiteBackup.md)

Retrieves backup information for a specific site.

### [Import-UnifiSiteBackup](Import-UnifiSiteBackup.md)

Imports a backup to a specific site.

### [New-UnifiSiteMigration](New-UnifiSiteMigration.md)

Creates a site migration configuration.

### [Get-UnifiControllerStatus](Get-UnifiControllerStatus.md)

Retrieves the status of the UniFi Controller.

### [Get-UnifiSiteRadiusProfiles](Get-UnifiSiteRadiusProfiles.md)

Retrieves RADIUS profiles for a specific site.

### [Get-UnifiSiteRadiusAccounts](Get-UnifiSiteRadiusAccounts.md)

Retrieves RADIUS accounts for a specific site.
