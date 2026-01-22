function Get-UnifiWLANConfigs {
    <#
    .SYNOPSIS
        Retrieves WLAN configurations for a specific site.

    .DESCRIPTION
        Returns wireless network configurations for the specified site.
        Supports filtering by name, enabled status, and security type.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .PARAMETER Name
        Filter by SSID name. Supports wildcards.

    .PARAMETER Enabled
        Filter to only enabled ($true) or disabled ($false) WLANs.

    .PARAMETER Security
        Filter by security type: 'open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap'.

    .PARAMETER GuestOnly
        Return only guest networks.

    .EXAMPLE
        Get-UnifiWLANConfigs -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiWLANConfigs

    .EXAMPLE
        Get-UnifiWLANConfigs -SiteName 'default' -Enabled $true
        # Returns only enabled WLANs

    .EXAMPLE
        Get-UnifiWLANConfigs -SiteName 'default' -Name 'Guest*'
        # Returns WLANs matching 'Guest*' pattern

    .EXAMPLE
        Get-UnifiWLANConfigs -SiteName 'default' -Security 'wpa2' -Enabled $true
        # Returns enabled WPA2 networks

    .EXAMPLE
        Get-UnifiWLANConfigs -SiteName 'default' -GuestOnly
        # Returns only guest networks

    .OUTPUTS
        PSCustomObject. WLAN configuration objects.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter()]
        [SupportsWildcards()]
        [string]$Name,

        [Parameter()]
        [bool]$Enabled,

        [Parameter()]
        [ValidateSet('open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap')]
        [string]$Security,

        [Parameter()]
        [switch]$GuestOnly
    )

    process {
        $Results = Invoke-UnifiApi -Endpoint 'rest/wlanconf' -SiteName $SiteName

        # Apply filters
        if ($PSBoundParameters.ContainsKey('Name')) {
            $Results = $Results | Where-Object { $_.name -like $Name }
        }

        if ($PSBoundParameters.ContainsKey('Enabled')) {
            $Results = $Results | Where-Object { $_.enabled -eq $Enabled }
        }

        if ($PSBoundParameters.ContainsKey('Security')) {
            $Results = $Results | Where-Object { $_.security -eq $Security }
        }

        if ($GuestOnly) {
            $Results = $Results | Where-Object { $_.is_guest -eq $true }
        }

        $Results
    }
}
