@{
    # Module identification
    RootModule           = 'UnifiAPI.psm1'
    ModuleVersion        = '1.0.0'
    GUID                 = '62f26195-5ab9-4248-9639-0514f31bb0f8'

    # Author information
    Author               = 'Chris Taylor'
    CompanyName          = 'ChrisTaylorCodes'
    Copyright            = '(c) Chris Taylor. All rights reserved.'

    # Module description
    Description          = 'PowerShell module for interacting with the Ubiquiti UniFi Controller API. Provides functions to manage UniFi network infrastructure including sites, devices, WLAN configurations, firmware updates, backups, and more.'

    # PowerShell requirements
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')

    # Functions to export - ModuleBuilder will populate this during build
    # Use wildcard pattern for development/direct import scenarios
    FunctionsToExport    = @('*-Unifi*')

    # Cmdlets to export (none - this is a function-based module)
    CmdletsToExport      = @()

    # Variables to export (none)
    VariablesToExport    = @()

    # Aliases to export (none - v3.0.0 removes all legacy aliases)
    AliasesToExport      = @()

    # Private data / PSData for PowerShell Gallery
    PrivateData          = @{
        PSData = @{
            Tags         = @('UniFi', 'Ubiquiti', 'ChrisTaylorCodes')
            LicenseUri   = 'https://github.com/christaylorcodes/UnifiAPI/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/christaylorcodes/UnifiAPI'
            IconUri      = ''
            Prerelease   = ''
            ReleaseNotes = @'
## Version 1.0.0

### Initial Public Release
- 68 public functions for comprehensive UniFi Controller API management
- PowerShell 7.0+ (Core only) support
- Pipeline input support for `SiteName` parameter across all site-scoped functions
- Automatic pagination support via `-Paginate` parameter in `Invoke-UnifiApi`
- Full `[OutputType()]` declarations on all functions
- Input validation for MAC addresses and IP addresses
- Support for all HTTP methods including Patch
- Centralized HTTP request handling with proper error sanitization
- Comprehensive Pester 5.6.1 test suite
- CI/CD pipeline for automated testing and publishing
'@
        }
    }
}
