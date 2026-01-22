# UnifiAPI Module - Future Enhancements

This document tracks API endpoints and features to be added in future releases, based on analysis of the [Art-of-WiFi/UniFi-API-client](https://github.com/Art-of-WiFi/UniFi-API-client) PHP project.

## Completed (v3.1.0)

### WLAN Management (Tier 1)
- [x] `New-UnifiWLAN` - Create wireless networks
- [x] `Set-UnifiWLAN` - Modify WLAN settings (HideSSID, Enabled, VLAN, etc.)
- [x] `Remove-UnifiWLAN` - Delete wireless networks
- [x] `New-UnifiWLANGroup` - Create WLAN groups for AP organization
- [x] `Set-UnifiWLANGroup` - Modify WLAN groups (Add/Remove device MACs)
- [x] `Remove-UnifiWLANGroup` - Delete WLAN groups
- [x] `Get-UnifiWLANConfigs` enhancements - Name/Enabled/Security/GuestOnly filters

### Site Management (Tier 2)
- [x] `New-UnifiSite` - Create new sites
- [x] `Set-UnifiSite` - Rename sites
- [x] `Set-UnifiSiteSettings` - Update site settings (country, locale, mgmt, etc.)
- [x] `New-UnifiSiteUserGroup` - Create bandwidth limiting groups
- [x] `Set-UnifiSiteUserGroup` - Modify user group bandwidth limits
- [x] `Remove-UnifiSiteUserGroup` - Delete user groups

### Enhanced Existing Functions
- [x] `Get-UnifiSiteStatistics` - Added 'monthly' interval and 'user' type
- [x] `Invoke-UnifiDeviceAction` - Added LED override, enable/disable, adopt-advanced
- [x] `Get-UnifiSiteClients` - Added Guest, MacAddress, ActiveWithinHours parameters

---

## Tier 3: Alerting & Monitoring (Priority: High)

### Alert Management
- [ ] `Get-UnifiAlarms` - Retrieve alarms (different from alerts)
  - Endpoint: `list/alarm` or `cnt/alarm`
  - Parameters: `archived` (bool), consider `count_alarms()` variant
- [ ] `Set-UnifiAlarmArchive` - Archive alarms
  - Endpoint: `cmd/evtmgr` with `archive-all-alarms`
- [ ] `Remove-UnifiSiteAlerts` - Clear site alerts (already partially exists?)
  - Verify current implementation

### Event Management
- [ ] `Get-UnifiEvents` - Enhanced event retrieval
  - Endpoint: `stat/event`
  - Add: `Start`/`End` datetime filtering, `Limit` parameter
  - Consider: `_sort` and `_start` for pagination

### Health & Status
- [ ] `Get-UnifiControllerStatus` - Controller system info
  - Endpoint: `stat/sysinfo` (no site needed)
- [ ] `Get-UnifiSiteHealthSummary` - Aggregated health across subsystems
  - Build on existing `Get-UnifiSiteHealth`

---

## Tier 4: Client Management (Priority: Medium)

### Client Operations
- [ ] `Set-UnifiClient` - Modify client settings
  - Endpoint: `rest/user/{id}` PUT
  - Properties: name, note, usergroup_id, fixed_ip, use_fixedip
- [ ] `Block-UnifiClient` / `Unblock-UnifiClient`
  - Endpoint: `cmd/stamgr` with `block-sta` / `unblock-sta`
- [ ] `Disconnect-UnifiClient` - Force reconnect
  - Endpoint: `cmd/stamgr` with `kick-sta`
- [ ] `Set-UnifiClientNote` - Add/update client notes
  - Endpoint: `set/user-note` or via `rest/user`

### Client Authorization (Hotspot/Guest)
- [ ] `Grant-UnifiGuestAccess` - Authorize guest
  - Endpoint: `cmd/stamgr` with `authorize-guest`
  - Parameters: mac, minutes, up_kbps, down_kbps, bytes
- [ ] `Revoke-UnifiGuestAccess` - Unauthorize guest
  - Endpoint: `cmd/stamgr` with `unauthorize-guest`
- [ ] `Extend-UnifiGuestAccess` - Extend guest authorization
  - Endpoint: `cmd/hotspot` with `extend`

### Voucher Management
- [ ] `New-UnifiVoucher` - Create guest vouchers
  - Endpoint: `cmd/hotspot` with `create-voucher`
  - Parameters: count, quota, expire_minutes, note, up_kbps, down_kbps
- [ ] `Get-UnifiVouchers` - List vouchers
  - Endpoint: `stat/voucher`
- [ ] `Remove-UnifiVoucher` - Delete voucher
  - Endpoint: `cmd/hotspot` with `delete-voucher`

---

## Tier 5: Network Configuration (Priority: Medium)

### Network CRUD
- [ ] `New-UnifiSiteNetwork` - Create networks (LAN, VLAN, etc.)
  - Endpoint: `rest/networkconf` POST
  - Complex: Many network types with different properties
- [ ] `Set-UnifiSiteNetwork` - Modify networks
  - Endpoint: `rest/networkconf/{id}` PUT
- [ ] `Remove-UnifiSiteNetwork` - Delete networks
  - Endpoint: `rest/networkconf/{id}` DELETE

### Port Forwarding
- [ ] `Get-UnifiPortForwarding` - List port forward rules
  - Endpoint: `rest/portforward`
- [ ] `New-UnifiPortForward` - Create port forward
  - Endpoint: `rest/portforward` POST
- [ ] `Set-UnifiPortForward` - Modify port forward
- [ ] `Remove-UnifiPortForward` - Delete port forward

### Firewall Rules
- [ ] `Get-UnifiFirewallRules` - List firewall rules
  - Endpoint: `rest/firewallrule`
- [ ] `New-UnifiFirewallRule` - Create firewall rule
- [ ] `Set-UnifiFirewallRule` - Modify firewall rule
- [ ] `Remove-UnifiFirewallRule` - Delete firewall rule

### Firewall Groups
- [ ] `Get-UnifiFirewallGroups` - List firewall groups (IP, port, etc.)
  - Endpoint: `rest/firewallgroup`
- [ ] `New-UnifiFirewallGroup` - Create firewall group
- [ ] `Set-UnifiFirewallGroup` - Modify firewall group
- [ ] `Remove-UnifiFirewallGroup` - Delete firewall group

---

## Tier 6: Device Management (Priority: Medium)

### Device Configuration
- [ ] `Set-UnifiDevice` - Comprehensive device settings
  - Endpoint: `rest/device/{id}` PUT
  - Properties: name, config overrides, port profiles
- [ ] `Set-UnifiDevicePortProfile` - Configure switch ports
  - Endpoint: via device PUT with port_overrides
- [ ] `Set-UnifiAPRadioSettings` - Configure AP radio settings
  - Endpoint: via device PUT with radio settings

### Device Provisioning
- [ ] `Start-UnifiDeviceProvision` - Force provision
  - Endpoint: `cmd/devmgr` with `force-provision`
- [ ] `Start-UnifiDeviceSpeedTest` - Run speed test
  - Endpoint: `cmd/devmgr` with `speedtest` or `speedtest-status`
- [ ] `Get-UnifiDeviceSpeedTestResults` - Get speed test results

### Device Locating
- [ ] `Start-UnifiDeviceLocate` - Start locate (flash LED)
  - Endpoint: `cmd/devmgr` with `set-locate`
- [ ] `Stop-UnifiDeviceLocate` - Stop locate
  - Endpoint: `cmd/devmgr` with `unset-locate`

---

## Tier 7: Backup & Admin (Priority: Low)

### Backup Operations
- [ ] `Get-UnifiBackups` - List available backups
  - Endpoint: `cmd/backup` with `list-backups`
- [ ] `New-UnifiBackup` - Create backup
  - Endpoint: `cmd/system` with `backup`
- [ ] `Remove-UnifiBackup` - Delete backup
  - Endpoint: `cmd/system` with `delete-backup`
- [ ] `Restore-UnifiBackup` - Restore from backup
  - Endpoint: Complex, involves file upload

### Admin Management
- [ ] `Get-UnifiAdmins` - List admins
  - Endpoint: `cmd/sitemgr` with `get-admins`
- [ ] `New-UnifiAdmin` - Create admin (if API supports)
- [ ] `Set-UnifiAdmin` - Modify admin permissions
- [ ] `Remove-UnifiAdmin` - Revoke admin from site
  - Endpoint: `cmd/sitemgr` with `revoke-admin`

### Site Operations
- [ ] `Remove-UnifiSite` - Delete site
  - Endpoint: `cmd/sitemgr` with `delete-site`
  - **Danger**: Destructive operation, needs extra confirmation

---

## Tier 8: RADIUS & Authentication (Priority: Low)

### RADIUS Profiles
- [ ] `Get-UnifiRadiusProfiles` - List RADIUS profiles
  - Endpoint: `rest/radiusprofile`
- [ ] `New-UnifiRadiusProfile` - Create RADIUS profile
- [ ] `Set-UnifiRadiusProfile` - Modify RADIUS profile
- [ ] `Remove-UnifiRadiusProfile` - Delete RADIUS profile

### RADIUS Accounts
- [ ] `Get-UnifiRadiusAccounts` - List RADIUS accounts
  - Endpoint: `rest/account`
- [ ] `New-UnifiRadiusAccount` - Create RADIUS account
- [ ] `Set-UnifiRadiusAccount` - Modify RADIUS account
- [ ] `Remove-UnifiRadiusAccount` - Delete RADIUS account

---

## Tier 9: Statistics & Reporting (Priority: Low)

### Enhanced Statistics
- [ ] `Get-UnifiDailyStats` - Daily site statistics
  - Endpoint: `stat/report/daily.site`
- [ ] `Get-UnifiHourlyStats` - Hourly statistics
  - Endpoint: `stat/report/hourly.site`
- [ ] `Get-UnifiClientStats` - Per-client statistics over time
  - Endpoint: `stat/report/daily.user` or `hourly.user`

### AP Statistics
- [ ] `Get-UnifiAPStats` - Per-AP statistics
  - Endpoint: `stat/report/daily.ap` or `hourly.ap`

### DPI (Deep Packet Inspection)
- [ ] `Get-UnifiDPIStats` - DPI statistics
  - Endpoint: `stat/sitedpi` or `stat/stadpi`
- [ ] `Get-UnifiDPIApps` - DPI application categories

---

## API Notes

### Endpoint Patterns
- `stat/*` - Statistics/read operations (GET)
- `rest/*` - CRUD operations (GET/POST/PUT/DELETE)
- `cmd/*` - Command operations (POST with `cmd` in body)
- `list/*` - List operations (GET, sometimes POST)

### API Versions
- v1: `/api/s/{site}/` - Most endpoints
- v2: `/v2/api/site/{site}/` - Newer endpoints (traffic routes, etc.)

### Common Body Patterns
```powershell
# Command pattern
@{ cmd = 'command-name'; param1 = 'value' }

# CRUD pattern
@{ property1 = 'value'; property2 = 123 }
```

### References
- [Art-of-WiFi/UniFi-API-client](https://github.com/Art-of-WiFi/UniFi-API-client) - PHP client
- [Art-of-WiFi/UniFi-API-browser](https://github.com/Art-of-WiFi/UniFi-API-browser) - API browser tool
- [Unofficial UniFi API docs](https://ubntwiki.com/products/software/unifi-controller/api) - Community docs
