<#
.SYNOPSIS
    Unit tests for UnifiAPI module - no controller required.

.DESCRIPTION
    Tests module loading, function exports, parameter validation, and help quality.
    Uses dynamic discovery to automatically test all exported functions.

.NOTES
    Version:        3.0.0
    Author:         Chris Taylor
#>

# BeforeDiscovery runs before test discovery - used for -ForEach data
BeforeDiscovery {
    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $OutputModule = Get-ChildItem -Path "$ProjectRoot/output/UnifiAPI/*/UnifiAPI.psd1" -ErrorAction SilentlyContinue |
        Sort-Object { [version](Split-Path (Split-Path $_.FullName -Parent) -Leaf) } -Descending |
        Select-Object -First 1

    if (-not $OutputModule) {
        throw "Module not built. Run '.\build.ps1 -Tasks build' first."
    }

    Import-Module $OutputModule.FullName -Force -ErrorAction Stop

    # Discover all exported functions for -ForEach tests
    $script:AllFunctions = @(Get-Command -Module UnifiAPI -CommandType Function)

    # Site-aware functions (should have SiteName parameter with pipeline support)
    $script:SiteAwareFunctions = @($script:AllFunctions | Where-Object {
        $_.Name -match 'Site|Device|WLAN|Firmware|Rogue|Neighbor|Log|Alert|Client|Network|Firewall|Radius|Health|Event|Statistic' -and
        $_.Name -notmatch 'Sites$|Connect|Disconnect|DisconnectedWaps|FirmwareStatus|ControllerStatus|CurrentUser|EventStrings|^Remove-UnifiDevice$|^Remove-UnifiSite$|^New-UnifiSite$'
    })

    # Destructive functions (should support ShouldProcess)
    $script:DestructiveFunctions = @($script:AllFunctions | Where-Object {
        $_.Name -match '^(Remove-|Clear-|New-|Set-|Update-|Invoke-UnifiDeviceAction|Grant-|Revoke-)'
    })

    # Functions with OutputType (should be all of them in v3.0.0)
    $script:FunctionsWithOutputType = @($script:AllFunctions | Where-Object {
        $_.OutputType.Count -gt 0
    })
}

BeforeAll {
    # Import module for test execution
    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $OutputModule = Get-ChildItem -Path "$ProjectRoot/output/UnifiAPI/*/UnifiAPI.psd1" -ErrorAction SilentlyContinue |
        Sort-Object { [version](Split-Path (Split-Path $_.FullName -Parent) -Leaf) } -Descending |
        Select-Object -First 1

    Import-Module $OutputModule.FullName -Force -ErrorAction Stop
}

#region Module Loading Tests

Describe 'Module: UnifiAPI' {
    Context 'Module Loading' {
        It 'Module is loaded' {
            Get-Module -Name UnifiAPI | Should -Not -BeNullOrEmpty
        }

        It 'Module has correct name' {
            (Get-Module -Name UnifiAPI).Name | Should -Be 'UnifiAPI'
        }

        It 'Module version is 1.0.0 or higher' {
            $version = (Get-Module -Name UnifiAPI).Version
            $version | Should -BeGreaterOrEqual ([version]'1.0.0')
        }

        It 'Requires PowerShell 7.0 or higher' {
            $module = Get-Module -Name UnifiAPI
            $module.PowerShellVersion | Should -BeGreaterOrEqual ([version]'7.0')
        }

        It 'Is compatible with PowerShell Core only' {
            $module = Get-Module -Name UnifiAPI
            $module.CompatiblePSEditions | Should -Be @('Core')
        }

        It 'Exports at least 25 functions' {
            $FunctionCount = (Get-Command -Module UnifiAPI -CommandType Function).Count
            $FunctionCount | Should -BeGreaterOrEqual 25
        }

        It 'Does not export any aliases (v3.0.0 breaking change)' {
            $module = Get-Module -Name UnifiAPI
            $module.ExportedAliases.Count | Should -Be 0
        }
    }
}

#endregion

#region Generic Function Tests (Apply to ALL functions)

Describe 'All Exported Functions' {
    Context 'Function Standards' {
        It '<_.Name> uses CmdletBinding' -ForEach $script:AllFunctions {
            $_.CmdletBinding | Should -Be $true -Because "All functions should use [CmdletBinding()]"
        }

        It '<_.Name> has help synopsis' -ForEach $script:AllFunctions {
            $Help = Get-Help $_.Name -ErrorAction SilentlyContinue
            $Help.Synopsis | Should -Not -BeNullOrEmpty
            $Help.Synopsis | Should -Not -Match "^\s*$($_.Name)\s*$" -Because "Synopsis should not just be the function name"
        }

        It '<_.Name> has OutputType attribute' -ForEach $script:AllFunctions {
            $_.OutputType.Count | Should -BeGreaterThan 0 -Because "All functions should declare [OutputType()]"
        }
    }

    Context 'Site-Aware Functions' {
        It '<_.Name> has SiteName parameter' -ForEach $script:SiteAwareFunctions {
            $_.Parameters.Keys | Should -Contain 'SiteName' -Because "Site-aware functions need a SiteName parameter"
        }

        It '<_.Name> SiteName accepts pipeline input' -ForEach $script:SiteAwareFunctions {
            $param = $_.Parameters['SiteName']
            $pipelineAttr = $param.Attributes | Where-Object {
                $_ -is [System.Management.Automation.ParameterAttribute] -and
                $_.ValueFromPipelineByPropertyName -eq $true
            }
            $pipelineAttr | Should -Not -BeNullOrEmpty -Because "SiteName should accept pipeline input by property name"
        }
    }

    Context 'Destructive Functions' {
        It '<_.Name> supports WhatIf/Confirm' -ForEach $script:DestructiveFunctions {
            $_.Parameters.Keys | Should -Contain 'WhatIf' -Because "Destructive functions should support -WhatIf"
            $_.Parameters.Keys | Should -Contain 'Confirm' -Because "Destructive functions should support -Confirm"
        }
    }
}

#endregion

#region Core Function Tests

Describe 'Core Functions' {
    Context 'Connect-Unifi' {
        BeforeAll {
            $script:ConnectCmd = Get-Command -Name Connect-Unifi
        }

        It 'Has mandatory BaseURI parameter' {
            $script:ConnectCmd.Parameters['BaseURI'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Has mandatory Credential parameter' {
            $script:ConnectCmd.Parameters['Credential'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Credential parameter accepts PSCredential' {
            $script:ConnectCmd.Parameters['Credential'].ParameterType.Name | Should -Be 'PSCredential'
        }

        It 'Has SkipCertificateCheck switch for self-signed certificates' {
            $script:ConnectCmd.Parameters['SkipCertificateCheck'].SwitchParameter | Should -Be $true
        }

        It 'Has TimeoutSec parameter with valid range' {
            $script:ConnectCmd.Parameters['TimeoutSec'] | Should -Not -BeNullOrEmpty
            $ValidateRange = $script:ConnectCmd.Parameters['TimeoutSec'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange | Should -Not -BeNullOrEmpty
        }

        It 'Has OutputType of void' {
            $script:ConnectCmd.OutputType.Type.Name | Should -Contain 'Void'
        }
    }

    Context 'Invoke-UnifiApi' {
        BeforeAll {
            $script:ApiCmd = Get-Command -Name Invoke-UnifiApi
        }

        It 'Has mandatory Endpoint parameter' {
            $script:ApiCmd.Parameters['Endpoint'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Method parameter has ValidateSet including Patch' {
            $ValidateSet = $script:ApiCmd.Parameters['Method'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $ValidateSet | Should -Not -BeNullOrEmpty
            $ValidateSet.ValidValues | Should -Contain 'Get'
            $ValidateSet.ValidValues | Should -Contain 'Post'
            $ValidateSet.ValidValues | Should -Contain 'Patch'
        }

        It 'Has ApiV2 switch for v2 API endpoints' {
            $script:ApiCmd.Parameters['ApiV2'].SwitchParameter | Should -Be $true
        }

        It 'Has Raw switch for full response' {
            $script:ApiCmd.Parameters['Raw'].SwitchParameter | Should -Be $true
        }

        It 'Has Paginate switch for automatic pagination' {
            $script:ApiCmd.Parameters['Paginate'].SwitchParameter | Should -Be $true
        }

        It 'Has PageSize parameter with valid range' {
            $script:ApiCmd.Parameters['PageSize'] | Should -Not -BeNullOrEmpty
            $ValidateRange = $script:ApiCmd.Parameters['PageSize'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange | Should -Not -BeNullOrEmpty
        }

        It 'SiteName accepts pipeline input by property name' {
            $param = $script:ApiCmd.Parameters['SiteName']
            $pipelineAttr = $param.Attributes | Where-Object {
                $_ -is [System.Management.Automation.ParameterAttribute] -and
                $_.ValueFromPipelineByPropertyName -eq $true
            }
            $pipelineAttr | Should -Not -BeNullOrEmpty
        }

        It 'Throws when not connected' {
            # Clear any existing session
            & (Get-Module UnifiAPI) { $script:UnifiSession = $null }
            { Invoke-UnifiApi -Endpoint 'self/sites' } | Should -Throw "*Connect-Unifi*"
        }
    }

    Context 'Disconnect-Unifi' {
        It 'Has OutputType of void' {
            $cmd = Get-Command -Name Disconnect-Unifi
            $cmd.OutputType.Type.Name | Should -Contain 'Void'
        }

        It 'Does not throw when already disconnected' {
            & (Get-Module UnifiAPI) { $script:UnifiSession = $null }
            { Disconnect-Unifi } | Should -Not -Throw
        }
    }

    Context 'Get-UnifiSites' {
        It 'Throws when not connected' {
            & (Get-Module UnifiAPI) { $script:UnifiSession = $null }
            { Get-UnifiSites } | Should -Throw "*Connect-Unifi*"
        }

        It 'Has OutputType declared' {
            $cmd = Get-Command -Name Get-UnifiSites
            # PSCustomObject is an alias for PSObject, so accept either
            $cmd.OutputType.Type.Name | Should -Match 'PSCustomObject|PSObject'
        }
    }

    Context 'Get-UnifiDevices' {
        BeforeAll {
            $script:DevicesCmd = Get-Command -Name Get-UnifiDevices
        }

        It 'SiteName is mandatory' {
            $script:DevicesCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'SiteName accepts pipeline input' {
            $param = $script:DevicesCmd.Parameters['SiteName']
            $pipelineAttr = $param.Attributes | Where-Object {
                $_ -is [System.Management.Automation.ParameterAttribute] -and
                $_.ValueFromPipelineByPropertyName -eq $true
            }
            $pipelineAttr | Should -Not -BeNullOrEmpty
        }

        It 'Has OutputType declared' {
            # PSCustomObject is an alias for PSObject, so accept either
            $script:DevicesCmd.OutputType.Type.Name | Should -Match 'PSCustomObject|PSObject'
        }
    }
}

#endregion

#region WLAN CRUD Function Tests

Describe 'WLAN CRUD Functions' {
    Context 'New-UnifiWLAN' {
        BeforeAll {
            $script:NewWLANCmd = Get-Command -Name New-UnifiWLAN
        }

        It 'Has mandatory SiteName parameter' {
            $script:NewWLANCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Has mandatory Name parameter' {
            $script:NewWLANCmd.Parameters['Name'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Has Passphrase parameter (required for secured networks)' {
            $script:NewWLANCmd.Parameters['Passphrase'] | Should -Not -BeNullOrEmpty
            # Note: Passphrase is conditionally required based on Security type, not always mandatory
        }

        It 'Security parameter has ValidateSet' {
            $ValidateSet = $script:NewWLANCmd.Parameters['Security'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $ValidateSet | Should -Not -BeNullOrEmpty
            $ValidateSet.ValidValues | Should -Contain 'open'
            $ValidateSet.ValidValues | Should -Contain 'wpa2'
            $ValidateSet.ValidValues | Should -Contain 'wpa3'
        }

        It 'VLAN parameter has ValidateRange 1-4094' {
            $ValidateRange = $script:NewWLANCmd.Parameters['VLAN'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange | Should -Not -BeNullOrEmpty
            $ValidateRange.MinRange | Should -Be 1
            $ValidateRange.MaxRange | Should -Be 4094
        }

        It 'Supports ShouldProcess' {
            $script:NewWLANCmd.Parameters.Keys | Should -Contain 'WhatIf'
            $script:NewWLANCmd.Parameters.Keys | Should -Contain 'Confirm'
        }
    }

    Context 'Set-UnifiWLAN' {
        BeforeAll {
            $script:SetWLANCmd = Get-Command -Name Set-UnifiWLAN
        }

        It 'Has mandatory SiteName parameter' {
            $script:SetWLANCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Has WLANId parameter for ById parameter set' {
            $script:SetWLANCmd.Parameters['WLANId'] | Should -Not -BeNullOrEmpty
        }

        It 'Has WLAN parameter for ByObject parameter set' {
            $script:SetWLANCmd.Parameters['WLAN'] | Should -Not -BeNullOrEmpty
        }

        It 'HideSSID is bool type (not switch)' {
            $script:SetWLANCmd.Parameters['HideSSID'].ParameterType.Name | Should -Be 'Boolean'
        }

        It 'Enabled is bool type' {
            $script:SetWLANCmd.Parameters['Enabled'].ParameterType.Name | Should -Be 'Boolean'
        }

        It 'Supports ShouldProcess' {
            $script:SetWLANCmd.Parameters.Keys | Should -Contain 'WhatIf'
        }

        It 'SiteName does not have name alias (to avoid conflicts)' {
            $aliases = $script:SetWLANCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }

    Context 'Remove-UnifiWLAN' {
        BeforeAll {
            $script:RemoveWLANCmd = Get-Command -Name Remove-UnifiWLAN
        }

        It 'Has mandatory SiteName parameter in both parameter sets' {
            # Check ById set
            $ByIdAttr = $script:RemoveWLANCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.ParameterSetName -eq 'ById' }
            $ByIdAttr.Mandatory | Should -Be $true

            # Check ByObject set
            $ByObjAttr = $script:RemoveWLANCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.ParameterSetName -eq 'ByObject' }
            $ByObjAttr.Mandatory | Should -Be $true
        }

        It 'Has ConfirmImpact High' {
            $CmdletBinding = $script:RemoveWLANCmd.ScriptBlock.Attributes |
                Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $CmdletBinding.ConfirmImpact | Should -Be 'High'
        }

        It 'SiteName does not have name alias (to avoid conflicts)' {
            $aliases = $script:RemoveWLANCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }

    Context 'Get-UnifiWLANConfigs filtering' {
        BeforeAll {
            $script:GetWLANCmd = Get-Command -Name Get-UnifiWLANConfigs
        }

        It 'Has Name filter parameter with wildcard support' {
            $script:GetWLANCmd.Parameters['Name'] | Should -Not -BeNullOrEmpty
            $supportsWildcards = $script:GetWLANCmd.Parameters['Name'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.SupportsWildcardsAttribute] }
            $supportsWildcards | Should -Not -BeNullOrEmpty
        }

        It 'Has Enabled filter parameter as bool' {
            $script:GetWLANCmd.Parameters['Enabled'].ParameterType.Name | Should -Be 'Boolean'
        }

        It 'Has Security filter with ValidateSet' {
            $ValidateSet = $script:GetWLANCmd.Parameters['Security'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $ValidateSet | Should -Not -BeNullOrEmpty
        }

        It 'Has GuestOnly switch parameter' {
            $script:GetWLANCmd.Parameters['GuestOnly'].ParameterType.Name | Should -Be 'SwitchParameter'
        }

        It 'SiteName does not have name alias (to avoid conflicts with Name filter)' {
            $aliases = $script:GetWLANCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }
}

#endregion

#region WLAN Group Function Tests

Describe 'WLAN Group Functions' {
    Context 'New-UnifiWLANGroup' {
        BeforeAll {
            $script:NewGroupCmd = Get-Command -Name New-UnifiWLANGroup
        }

        It 'Has mandatory SiteName and Name parameters' {
            $script:NewGroupCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_.Mandatory -eq $true } | Should -Not -BeNullOrEmpty
            $script:NewGroupCmd.Parameters['Name'].Attributes |
                Where-Object { $_.Mandatory -eq $true } | Should -Not -BeNullOrEmpty
        }

        It 'Has optional DeviceMacs parameter as string array' {
            $script:NewGroupCmd.Parameters['DeviceMacs'].ParameterType.Name | Should -Be 'String[]'
        }

        It 'Supports ShouldProcess' {
            $script:NewGroupCmd.Parameters.Keys | Should -Contain 'WhatIf'
        }

        It 'SiteName does not have name alias' {
            $aliases = $script:NewGroupCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }

    Context 'Set-UnifiWLANGroup' {
        BeforeAll {
            $script:SetGroupCmd = Get-Command -Name Set-UnifiWLANGroup
        }

        It 'Has DeviceMacs, AddDeviceMacs, and RemoveDeviceMacs parameters' {
            $script:SetGroupCmd.Parameters['DeviceMacs'] | Should -Not -BeNullOrEmpty
            $script:SetGroupCmd.Parameters['AddDeviceMacs'] | Should -Not -BeNullOrEmpty
            $script:SetGroupCmd.Parameters['RemoveDeviceMacs'] | Should -Not -BeNullOrEmpty
        }

        It 'All MAC parameters are string arrays' {
            $script:SetGroupCmd.Parameters['DeviceMacs'].ParameterType.Name | Should -Be 'String[]'
            $script:SetGroupCmd.Parameters['AddDeviceMacs'].ParameterType.Name | Should -Be 'String[]'
            $script:SetGroupCmd.Parameters['RemoveDeviceMacs'].ParameterType.Name | Should -Be 'String[]'
        }
    }

    Context 'Remove-UnifiWLANGroup' {
        BeforeAll {
            $script:RemoveGroupCmd = Get-Command -Name Remove-UnifiWLANGroup
        }

        It 'Has ConfirmImpact High' {
            $CmdletBinding = $script:RemoveGroupCmd.ScriptBlock.Attributes |
                Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $CmdletBinding.ConfirmImpact | Should -Be 'High'
        }

        It 'SiteName does not have name alias' {
            $aliases = $script:RemoveGroupCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }
}

#endregion

#region Site Management Function Tests

Describe 'Site Management Functions' {
    Context 'New-UnifiSite' {
        BeforeAll {
            $script:NewSiteCmd = Get-Command -Name New-UnifiSite
        }

        It 'Has mandatory Description parameter' {
            $script:NewSiteCmd.Parameters['Description'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Supports ShouldProcess' {
            $script:NewSiteCmd.Parameters.Keys | Should -Contain 'WhatIf'
        }
    }

    Context 'Set-UnifiSite' {
        BeforeAll {
            $script:SetSiteCmd = Get-Command -Name Set-UnifiSite
        }

        It 'Has mandatory Description parameter' {
            $script:SetSiteCmd.Parameters['Description'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }

        It 'Has SiteName parameter with name alias (valid for site piping)' {
            $aliases = $script:SetSiteCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Contain 'name'
        }
    }

    Context 'Set-UnifiSiteSettings' {
        BeforeAll {
            $script:SetSettingsCmd = Get-Command -Name Set-UnifiSiteSettings
        }

        It 'Has mandatory SettingKey parameter with ValidateSet' {
            $script:SetSettingsCmd.Parameters['SettingKey'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty

            $ValidateSet = $script:SetSettingsCmd.Parameters['SettingKey'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $ValidateSet | Should -Not -BeNullOrEmpty
            $ValidateSet.ValidValues | Should -Contain 'country'
            $ValidateSet.ValidValues | Should -Contain 'locale'
            $ValidateSet.ValidValues | Should -Contain 'mgmt'
        }

        It 'Has mandatory SettingId parameter' {
            $script:SetSettingsCmd.Parameters['SettingId'].Attributes |
                Where-Object { $_.Mandatory -eq $true } |
                Should -Not -BeNullOrEmpty
        }
    }
}

#endregion

#region User Group Function Tests

Describe 'User Group Functions' {
    Context 'New-UnifiSiteUserGroup' {
        BeforeAll {
            $script:NewUserGroupCmd = Get-Command -Name New-UnifiSiteUserGroup
        }

        It 'Has mandatory SiteName and Name parameters' {
            $script:NewUserGroupCmd.Parameters['SiteName'].Attributes |
                Where-Object { $_.Mandatory -eq $true } | Should -Not -BeNullOrEmpty
            $script:NewUserGroupCmd.Parameters['Name'].Attributes |
                Where-Object { $_.Mandatory -eq $true } | Should -Not -BeNullOrEmpty
        }

        It 'Has both Kbps and Mbps bandwidth parameters' {
            $script:NewUserGroupCmd.Parameters['DownloadLimit'] | Should -Not -BeNullOrEmpty
            $script:NewUserGroupCmd.Parameters['UploadLimit'] | Should -Not -BeNullOrEmpty
            $script:NewUserGroupCmd.Parameters['DownloadLimitMbps'] | Should -Not -BeNullOrEmpty
            $script:NewUserGroupCmd.Parameters['UploadLimitMbps'] | Should -Not -BeNullOrEmpty
        }

        It 'Kbps parameters allow -1 for unlimited' {
            $ValidateRange = $script:NewUserGroupCmd.Parameters['DownloadLimit'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange.MinRange | Should -Be -1
        }

        It 'SiteName does not have name alias' {
            $aliases = $script:NewUserGroupCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }

    Context 'Set-UnifiSiteUserGroup' {
        BeforeAll {
            $script:SetUserGroupCmd = Get-Command -Name Set-UnifiSiteUserGroup
        }

        It 'Has both ById and ByObject parameter sets' {
            $paramSets = $script:SetUserGroupCmd.ParameterSets.Name
            $paramSets | Should -Contain 'ById'
            $paramSets | Should -Contain 'ByObject'
        }

        It 'Has bandwidth limit parameters' {
            $script:SetUserGroupCmd.Parameters['DownloadLimit'] | Should -Not -BeNullOrEmpty
            $script:SetUserGroupCmd.Parameters['DownloadLimitMbps'] | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Remove-UnifiSiteUserGroup' {
        BeforeAll {
            $script:RemoveUserGroupCmd = Get-Command -Name Remove-UnifiSiteUserGroup
        }

        It 'Has ConfirmImpact High' {
            $CmdletBinding = $script:RemoveUserGroupCmd.ScriptBlock.Attributes |
                Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $CmdletBinding.ConfirmImpact | Should -Be 'High'
        }

        It 'SiteName does not have name alias' {
            $aliases = $script:RemoveUserGroupCmd.Parameters['SiteName'].Aliases
            $aliases | Should -Not -Contain 'name'
        }
    }
}

#endregion

#region Private Function Tests

Describe 'Private Helper Functions' {
    Context 'MAC Address Validation' {
        It 'Test-UnifiMacAddress is available within module scope' {
            $result = & (Get-Module UnifiAPI) { Get-Command Test-UnifiMacAddress -ErrorAction SilentlyContinue }
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Validates correct MAC addresses' {
            $validMacs = @(
                '00:11:22:33:44:55',
                '00-11-22-33-44-55',
                '001122334455',
                'AA:BB:CC:DD:EE:FF'
            )
            foreach ($mac in $validMacs) {
                $result = & (Get-Module UnifiAPI) { param($m) Test-UnifiMacAddress -MacAddress $m } $mac
                $result | Should -Be $true -Because "MAC '$mac' should be valid"
            }
        }

        It 'Rejects invalid MAC addresses' {
            $invalidMacs = @(
                '00:11:22:33:44',      # Too short
                '00:11:22:33:44:55:66', # Too long
                'GG:HH:II:JJ:KK:LL',   # Invalid hex
                'not-a-mac'
            )
            foreach ($mac in $invalidMacs) {
                $result = & (Get-Module UnifiAPI) { param($m) Test-UnifiMacAddress -MacAddress $m } $mac
                $result | Should -Be $false -Because "MAC '$mac' should be invalid"
            }
        }

        It 'Normalizes MAC addresses correctly' {
            $result = & (Get-Module UnifiAPI) { Test-UnifiMacAddress -MacAddress 'AA-BB-CC-DD-EE-FF' -Normalize }
            $result | Should -Be 'aa:bb:cc:dd:ee:ff'
        }
    }
}

#endregion

AfterAll {
    Remove-Module -Name UnifiAPI -Force -ErrorAction SilentlyContinue
}
