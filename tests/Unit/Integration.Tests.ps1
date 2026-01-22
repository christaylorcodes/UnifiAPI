<#
.SYNOPSIS
    Integration tests for UnifiAPI module - requires live controller.

.DESCRIPTION
    Smoke tests to verify functions work against a real UniFi Controller.
    Uses dynamic discovery to automatically test all exported functions.
    Uses environment variables for credentials.

.NOTES
    Version:        3.0.0
    Author:         Chris Taylor

    Environment Variables:
        UNIFI_CONTROLLER_URL      - Controller URL (e.g., https://unifi.example.com:8443)
        UNIFI_USERNAME            - Username
        UNIFI_PASSWORD            - Password
        UNIFI_SKIP_CERT_CHECK     - Set to 'true' to skip certificate validation (for self-signed certs)

    Usage:
        # Run integration tests only
        Invoke-Pester -Path .\Integration.Tests.ps1 -Tag 'Integration'

        # Or with the build system (exclude by default, include explicitly)
        .\build.ps1 -Tasks test -PesterTag 'Integration'
#>

BeforeDiscovery {
    # Get all exported functions for dynamic testing
    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $OutputModule = Get-ChildItem -Path "$ProjectRoot/output/UnifiAPI/*/UnifiAPI.psd1" -ErrorAction SilentlyContinue |
        Sort-Object { [version](Split-Path (Split-Path $_.FullName -Parent) -Leaf) } -Descending |
        Select-Object -First 1

    if ($OutputModule) {
        Import-Module $OutputModule.FullName -Force -ErrorAction Stop
    }

    # Categorize functions for organized testing
    $script:AllFunctions = @(Get-Command -Module UnifiAPI -CommandType Function)

    # Read-only functions safe to test (GET operations)
    $script:ReadOnlyFunctions = @($script:AllFunctions | Where-Object {
        $_.Name -match '^Get-' -and
        $_.Name -notmatch 'DisconnectedWaps|FirmwareStatus'  # These iterate all sites
    })

    # Functions that require SiteName parameter (and ONLY SiteName as mandatory)
    # Exclude functions with additional mandatory params or deprecated endpoints
    $script:SiteFunctions = @($script:ReadOnlyFunctions | Where-Object {
        $_.Parameters.Keys -contains 'SiteName' -and
        $_.Name -notmatch 'SiteStatistics|EventStrings|Rogue$|KnownRogue'  # Have extra mandatory params or 404 on some controllers
    })

    # Global functions (no SiteName needed)
    $script:GlobalFunctions = @($script:ReadOnlyFunctions | Where-Object {
        $_.Parameters.Keys -notcontains 'SiteName' -and
        $_.Name -ne 'Get-UnifiSites'  # Tested separately
    })
}

BeforeAll {
    # Check for required environment variables
    $script:ControllerUrl = $env:UNIFI_CONTROLLER_URL
    if (-not $script:ControllerUrl) {
        throw "UNIFI_CONTROLLER_URL environment variable not set."
    }

    if (-not $env:UNIFI_USERNAME -or -not $env:UNIFI_PASSWORD) {
        throw "UNIFI_USERNAME and UNIFI_PASSWORD environment variables required."
    }

    $SecurePassword = ConvertTo-SecureString $env:UNIFI_PASSWORD -AsPlainText -Force
    $script:Credential = New-Object PSCredential($env:UNIFI_USERNAME, $SecurePassword)

    # Import module
    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $OutputModule = Get-ChildItem -Path "$ProjectRoot/output/UnifiAPI/*/UnifiAPI.psd1" -ErrorAction SilentlyContinue |
        Sort-Object { [version](Split-Path (Split-Path $_.FullName -Parent) -Leaf) } -Descending |
        Select-Object -First 1

    if ($OutputModule) {
        Import-Module $OutputModule.FullName -Force -ErrorAction Stop
    }
    else {
        throw "Module not built. Run '.\build.ps1 -Tasks build' first."
    }

    # Connect to controller (support self-signed certificates via env var)
    $ConnectParams = @{
        BaseURI    = $script:ControllerUrl
        Credential = $script:Credential
    }
    if ($env:UNIFI_SKIP_CERT_CHECK -eq 'true') {
        $ConnectParams.SkipCertificateCheck = $true
    }
    Connect-Unifi @ConnectParams

    # Get test site
    $script:Sites = Get-UnifiSites
    $script:TestSiteName = if ($script:Sites) { $script:Sites[0].name } else { 'default' }
}

#region Connection Tests

Describe 'Connection Tests' -Tag 'Integration' {
    It 'Connect-Unifi creates session' {
        # Check module-scoped session variable
        $session = & (Get-Module UnifiAPI) { $script:UnifiSession }
        $session | Should -Not -BeNullOrEmpty
        $session.WebSession | Should -Not -BeNullOrEmpty
    }

    It 'Session has correct BaseURI' {
        $session = & (Get-Module UnifiAPI) { $script:UnifiSession }
        $session.BaseURI | Should -Be $script:ControllerUrl
    }

    It 'Get-UnifiSites returns data' {
        $result = Get-UnifiSites
        $result | Should -Not -BeNullOrEmpty
    }
}

#endregion

#region Pipeline Tests

Describe 'Pipeline Support' -Tag 'Integration' {
    It 'Get-UnifiSites | Get-UnifiDevices works via pipeline' {
        # Should not throw when piping sites to devices
        { Get-UnifiSites | Select-Object -First 1 | Get-UnifiDevices } | Should -Not -Throw
    }

    It 'Get-UnifiSites | Get-UnifiSiteClients works via pipeline' {
        { Get-UnifiSites | Select-Object -First 1 | Get-UnifiSiteClients } | Should -Not -Throw
    }

    It 'Get-UnifiSites | Invoke-UnifiApi works via pipeline' {
        $result = Get-UnifiSites | Select-Object -First 1 | Invoke-UnifiApi -Endpoint 'stat/health'
        $result | Should -Not -BeNullOrEmpty
    }
}

#endregion

#region Site-Scoped Function Tests (Dynamic)

Describe 'Site-Scoped Functions' -Tag 'Integration' {
    It '<_.Name> does not throw' -ForEach $script:SiteFunctions {
        { & $_.Name -SiteName $script:TestSiteName } | Should -Not -Throw
    }
}

#endregion

#region Global Function Tests (Dynamic)

Describe 'Global Functions' -Tag 'Integration' {
    It '<_.Name> does not throw' -ForEach $script:GlobalFunctions {
        { & $_.Name } | Should -Not -Throw
    }
}

#endregion

#region Special Case Functions

Describe 'Special Case Functions' -Tag 'Integration' {
    Context 'Functions that iterate all sites' {
        It 'Get-UnifiDisconnectedWaps does not throw' {
            { Get-UnifiDisconnectedWaps } | Should -Not -Throw
        }

        It 'Test-UnifiFirmwareStatus does not throw' {
            { Test-UnifiFirmwareStatus } | Should -Not -Throw
        }
    }

    Context 'Functions with special parameters' {
        It 'Get-UnifiNeighborAP with TimeSpanHours does not throw' {
            { Get-UnifiNeighborAP -SiteName $script:TestSiteName -TimeSpanHours 24 } | Should -Not -Throw
        }

        It 'Get-UnifiAlert with Days parameter does not throw' {
            { Get-UnifiAlert -SiteName $script:TestSiteName -Days 7 } | Should -Not -Throw
        }
    }
}

#endregion

#region Response Data Validation

Describe 'Response Data Validation' -Tag 'Integration' {
    Context 'Get-UnifiSites' {
        BeforeAll {
            $script:SitesResult = Get-UnifiSites
        }

        It 'Returns at least one site' {
            $script:SitesResult | Should -Not -BeNullOrEmpty
        }

        It 'Site objects have required properties' {
            $site = $script:SitesResult | Select-Object -First 1
            $site.PSObject.Properties.Name | Should -Contain 'name'
            $site.PSObject.Properties.Name | Should -Contain 'desc'
            $site.PSObject.Properties.Name | Should -Contain '_id'
        }

        It 'Site name is a non-empty string' {
            $site = $script:SitesResult | Select-Object -First 1
            $site.name | Should -BeOfType [string]
            $site.name | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-UnifiDevices' {
        BeforeAll {
            $script:DevicesResult = Get-UnifiDevices -SiteName $script:TestSiteName
        }

        It 'Returns result or null' {
            # Result can be null, single object, or array - all valid
            { $script:DevicesResult } | Should -Not -Throw
        }

        It 'Device objects have required properties' -Skip:(-not $script:DevicesResult) {
            $device = @($script:DevicesResult)[0]
            $device.PSObject.Properties.Name | Should -Contain 'mac'
            $device.PSObject.Properties.Name | Should -Contain 'type'
            $device.PSObject.Properties.Name | Should -Contain 'model'
        }

        It 'Device MAC address is valid format' -Skip:(-not $script:DevicesResult) {
            $device = @($script:DevicesResult)[0]
            $device.mac | Should -Match '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'
        }
    }

    Context 'Get-UnifiSiteClients' {
        BeforeAll {
            $script:ClientsResult = Get-UnifiSiteClients -SiteName $script:TestSiteName
        }

        It 'Returns result or null' {
            { $script:ClientsResult } | Should -Not -Throw
        }

        It 'Client objects have mac property' -Skip:(-not $script:ClientsResult) {
            $client = @($script:ClientsResult)[0]
            $client.PSObject.Properties.Name | Should -Contain 'mac'
        }

        It 'Client MAC address is valid format' -Skip:(-not $script:ClientsResult) {
            $client = @($script:ClientsResult)[0]
            $client.mac | Should -Match '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'
        }
    }

    Context 'Get-UnifiSiteNetworks' {
        BeforeAll {
            $script:NetworksResult = Get-UnifiSiteNetworks -SiteName $script:TestSiteName
        }

        It 'Returns result or null' {
            { $script:NetworksResult } | Should -Not -Throw
        }

        It 'Network objects have required properties' -Skip:(-not $script:NetworksResult) {
            $network = @($script:NetworksResult)[0]
            $network.PSObject.Properties.Name | Should -Contain 'name'
            $network.PSObject.Properties.Name | Should -Contain '_id'
        }
    }

    Context 'Get-UnifiWLANConfigs' {
        BeforeAll {
            $script:WLANsResult = Get-UnifiWLANConfigs -SiteName $script:TestSiteName
        }

        It 'Returns result or null' {
            { $script:WLANsResult } | Should -Not -Throw
        }

        It 'WLAN objects have required properties' -Skip:(-not $script:WLANsResult) {
            $wlan = @($script:WLANsResult)[0]
            $wlan.PSObject.Properties.Name | Should -Contain 'name'
            $wlan.PSObject.Properties.Name | Should -Contain '_id'
            $wlan.PSObject.Properties.Name | Should -Contain 'enabled'
        }
    }

    Context 'Get-UnifiSiteHealth' {
        BeforeAll {
            $script:HealthResult = Get-UnifiSiteHealth -SiteName $script:TestSiteName
        }

        It 'Returns health data' {
            $script:HealthResult | Should -Not -BeNullOrEmpty
        }

        It 'Health objects have subsystem property' {
            $health = @($script:HealthResult)[0]
            $health.PSObject.Properties.Name | Should -Contain 'subsystem'
        }
    }

    Context 'Invoke-UnifiApi raw response structure' {
        BeforeAll {
            $script:RawResult = Invoke-UnifiApi -Endpoint 'self/sites' -Raw
        }

        It 'Raw response has meta property' {
            $script:RawResult.PSObject.Properties.Name | Should -Contain 'meta'
        }

        It 'Raw response has data property' {
            $script:RawResult.PSObject.Properties.Name | Should -Contain 'data'
        }

        It 'Meta contains rc (result code)' {
            $script:RawResult.meta.PSObject.Properties.Name | Should -Contain 'rc'
            $script:RawResult.meta.rc | Should -Be 'ok'
        }
    }
}

#endregion

#region Core API Function Tests

Describe 'Core API Function' -Tag 'Integration' {
    It 'Invoke-UnifiApi returns health data' {
        $result = Invoke-UnifiApi -Endpoint 'stat/health' -SiteName $script:TestSiteName
        $result | Should -Not -BeNullOrEmpty
    }

    It 'Invoke-UnifiApi with Raw returns full response' {
        $result = Invoke-UnifiApi -Endpoint 'stat/health' -SiteName $script:TestSiteName -Raw
        $result | Should -Not -BeNullOrEmpty
        $result.meta | Should -Not -BeNullOrEmpty
    }

    It 'Invoke-UnifiApi can call custom endpoint' {
        { Invoke-UnifiApi -Endpoint 'rest/networkconf' -SiteName $script:TestSiteName } | Should -Not -Throw
    }

    It 'Invoke-UnifiApi with Paginate does not throw' {
        # May return null if no clients, which is valid
        { Invoke-UnifiApi -Endpoint 'stat/sta' -SiteName $script:TestSiteName -Paginate } | Should -Not -Throw
    }
}

#endregion

#region WLAN CRUD Tests (Destructive)

Describe 'WLAN CRUD Operations' -Tag 'Integration', 'Destructive' {
    BeforeAll {
        $script:TestWLANName = "PesterTest-$([guid]::NewGuid().ToString().Substring(0,8))"
        $script:TestWLANId = $null
    }

    Context 'Create WLAN' {
        It 'New-UnifiWLAN creates an open network' {
            $result = New-UnifiWLAN -SiteName $script:TestSiteName -Name $script:TestWLANName -Security 'open' -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.name | Should -Be $script:TestWLANName
            $script:TestWLANId = $result._id
        }

        It 'New WLAN appears in Get-UnifiWLANConfigs' -Skip:(-not $script:TestWLANId) {
            $wlans = Get-UnifiWLANConfigs -SiteName $script:TestSiteName -Name $script:TestWLANName
            $wlans | Should -Not -BeNullOrEmpty
            $wlans.name | Should -Be $script:TestWLANName
        }
    }

    Context 'Modify WLAN' {
        It 'Set-UnifiWLAN can disable the network' -Skip:(-not $script:TestWLANId) {
            $result = Set-UnifiWLAN -SiteName $script:TestSiteName -WLANId $script:TestWLANId -Enabled $false -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Set-UnifiWLAN can hide the SSID' -Skip:(-not $script:TestWLANId) {
            $result = Set-UnifiWLAN -SiteName $script:TestSiteName -WLANId $script:TestWLANId -HideSSID $true -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Set-UnifiWLAN can unhide the SSID' -Skip:(-not $script:TestWLANId) {
            $result = Set-UnifiWLAN -SiteName $script:TestSiteName -WLANId $script:TestWLANId -HideSSID $false -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Verify SSID is not hidden' -Skip:(-not $script:TestWLANId) {
            $wlan = Get-UnifiWLANConfigs -SiteName $script:TestSiteName -Name $script:TestWLANName
            $wlan.hide_ssid | Should -Be $false
        }
    }

    Context 'Delete WLAN' {
        It 'Remove-UnifiWLAN deletes the network' -Skip:(-not $script:TestWLANId) {
            { Remove-UnifiWLAN -SiteName $script:TestSiteName -WLANId $script:TestWLANId -Confirm:$false } | Should -Not -Throw
            # Clear ID so AfterAll doesn't try to delete again
            $script:DeletedWLANId = $script:TestWLANId
            $script:TestWLANId = $null
        }

        It 'WLAN no longer exists' -Skip:(-not $script:DeletedWLANId) {
            $wlans = Get-UnifiWLANConfigs -SiteName $script:TestSiteName -Name $script:TestWLANName
            $wlans | Should -BeNullOrEmpty
        }
    }

    AfterAll {
        # Cleanup in case of test failure (only if not already deleted)
        if ($script:TestWLANId) {
            Remove-UnifiWLAN -SiteName $script:TestSiteName -WLANId $script:TestWLANId -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}

#endregion

#region WLAN Group CRUD Tests (Destructive)

Describe 'WLAN Group CRUD Operations' -Tag 'Integration', 'Destructive' {
    BeforeAll {
        $script:TestWLANGroupName = "PesterTest-$([guid]::NewGuid().ToString().Substring(0,8))"
        $script:TestWLANGroupId = $null
    }

    Context 'Create WLAN Group' {
        It 'New-UnifiWLANGroup creates a group' {
            $result = New-UnifiWLANGroup -SiteName $script:TestSiteName -Name $script:TestWLANGroupName -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.name | Should -Be $script:TestWLANGroupName
            $script:TestWLANGroupId = $result._id
        }

        It 'New WLAN group appears in Get-UnifiWLANGroups' -Skip:(-not $script:TestWLANGroupId) {
            $groups = Get-UnifiWLANGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:TestWLANGroupId }
            $group | Should -Not -BeNullOrEmpty
            $group.name | Should -Be $script:TestWLANGroupName
        }
    }

    Context 'Modify WLAN Group' {
        It 'Set-UnifiWLANGroup can rename the group' -Skip:(-not $script:TestWLANGroupId) {
            $newName = "$script:TestWLANGroupName-Renamed"
            $result = Set-UnifiWLANGroup -SiteName $script:TestSiteName -WLANGroupId $script:TestWLANGroupId -Name $newName -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            # Update name for subsequent tests
            $script:TestWLANGroupName = $newName
        }

        It 'Verify renamed group' -Skip:(-not $script:TestWLANGroupId) {
            $groups = Get-UnifiWLANGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:TestWLANGroupId }
            $group.name | Should -Be $script:TestWLANGroupName
        }
    }

    Context 'Delete WLAN Group' {
        It 'Remove-UnifiWLANGroup deletes the group' -Skip:(-not $script:TestWLANGroupId) {
            { Remove-UnifiWLANGroup -SiteName $script:TestSiteName -WLANGroupId $script:TestWLANGroupId -Confirm:$false } | Should -Not -Throw
            # Clear ID so AfterAll doesn't try to delete again
            $script:DeletedWLANGroupId = $script:TestWLANGroupId
            $script:TestWLANGroupId = $null
        }

        It 'WLAN group no longer exists' -Skip:(-not $script:DeletedWLANGroupId) {
            $groups = Get-UnifiWLANGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:DeletedWLANGroupId }
            $group | Should -BeNullOrEmpty
        }
    }

    AfterAll {
        # Cleanup in case of test failure (only if not already deleted)
        if ($script:TestWLANGroupId) {
            Remove-UnifiWLANGroup -SiteName $script:TestSiteName -WLANGroupId $script:TestWLANGroupId -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}

#endregion

#region User Group CRUD Tests (Destructive)

Describe 'User Group CRUD Operations' -Tag 'Integration', 'Destructive' {
    BeforeAll {
        $script:TestGroupName = "PesterTest-$([guid]::NewGuid().ToString().Substring(0,8))"
        $script:TestGroupId = $null
    }

    Context 'Create User Group' {
        It 'New-UnifiSiteUserGroup creates a group with bandwidth limits' {
            $result = New-UnifiSiteUserGroup -SiteName $script:TestSiteName -Name $script:TestGroupName -DownloadLimitMbps 10 -UploadLimitMbps 5 -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.name | Should -Be $script:TestGroupName
            $script:TestGroupId = $result._id
        }

        It 'New group has correct bandwidth limits' -Skip:(-not $script:TestGroupId) {
            $groups = Get-UnifiSiteUserGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:TestGroupId }
            $group.qos_rate_max_down | Should -Be 10000  # 10 Mbps = 10000 Kbps
            $group.qos_rate_max_up | Should -Be 5000     # 5 Mbps = 5000 Kbps
        }
    }

    Context 'Modify User Group' {
        It 'Set-UnifiSiteUserGroup can update bandwidth' -Skip:(-not $script:TestGroupId) {
            $result = Set-UnifiSiteUserGroup -SiteName $script:TestSiteName -UserGroupId $script:TestGroupId -DownloadLimitMbps 25 -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Verify updated bandwidth' -Skip:(-not $script:TestGroupId) {
            $groups = Get-UnifiSiteUserGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:TestGroupId }
            $group.qos_rate_max_down | Should -Be 25000
        }
    }

    Context 'Delete User Group' {
        It 'Remove-UnifiSiteUserGroup deletes the group' -Skip:(-not $script:TestGroupId) {
            { Remove-UnifiSiteUserGroup -SiteName $script:TestSiteName -UserGroupId $script:TestGroupId -Confirm:$false } | Should -Not -Throw
            # Clear ID so AfterAll doesn't try to delete again
            $script:DeletedGroupId = $script:TestGroupId
            $script:TestGroupId = $null
        }

        It 'Group no longer exists' -Skip:(-not $script:DeletedGroupId) {
            $groups = Get-UnifiSiteUserGroups -SiteName $script:TestSiteName
            $group = $groups | Where-Object { $_._id -eq $script:DeletedGroupId }
            $group | Should -BeNullOrEmpty
        }
    }

    AfterAll {
        # Cleanup in case of test failure (only if not already deleted)
        if ($script:TestGroupId) {
            Remove-UnifiSiteUserGroup -SiteName $script:TestSiteName -UserGroupId $script:TestGroupId -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}

#endregion

#region Get-UnifiWLANConfigs Filter Tests

Describe 'Get-UnifiWLANConfigs Filtering' -Tag 'Integration' {
    BeforeAll {
        $script:AllWLANs = Get-UnifiWLANConfigs -SiteName $script:TestSiteName
    }

    It 'Filtering by Enabled returns subset' -Skip:(-not $script:AllWLANs) {
        $enabledCount = ($script:AllWLANs | Where-Object enabled -eq $true).Count
        $filtered = Get-UnifiWLANConfigs -SiteName $script:TestSiteName -Enabled $true
        @($filtered).Count | Should -Be $enabledCount
    }

    It 'Filtering by Name with wildcard works' -Skip:(-not $script:AllWLANs) {
        $firstWLAN = $script:AllWLANs | Select-Object -First 1
        # Use at least 1 character for wildcard, handle short names
        $prefixLength = [Math]::Min(3, $firstWLAN.name.Length)
        $pattern = "$($firstWLAN.name.Substring(0, $prefixLength))*"
        $filtered = Get-UnifiWLANConfigs -SiteName $script:TestSiteName -Name $pattern
        $filtered | Should -Not -BeNullOrEmpty
    }
}

#endregion

AfterAll {
    # Cleanup
    Disconnect-Unifi
    Remove-Module -Name UnifiAPI -Force -ErrorAction SilentlyContinue
}
