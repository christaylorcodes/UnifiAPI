function New-UnifiWLAN {
    <#
    .SYNOPSIS
        Creates a new wireless network (WLAN) for a specific site.

    .DESCRIPTION
        Creates a new WLAN configuration on the specified UniFi site.
        Supports various security modes, guest networks, and VLAN assignment.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Name
        The SSID name for the wireless network.

    .PARAMETER WLANGroupId
        The WLAN group ID to assign this network to. Get from Get-UnifiWLANGroups.

    .PARAMETER Security
        Security mode: 'open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap'.
        Default is 'wpa2'.

    .PARAMETER Passphrase
        The network password. Required for WPA2/WPA3 security modes.
        Must be 8-63 characters.

    .PARAMETER HideSSID
        Hide the SSID from broadcast.

    .PARAMETER IsGuest
        Configure as a guest network with client isolation.

    .PARAMETER VLAN
        VLAN ID to assign to this network.

    .PARAMETER UserGroupId
        User group ID for bandwidth limiting. Get from Get-UnifiSiteUserGroups.

    .PARAMETER Enabled
        Whether the WLAN is enabled. Default is $true.

    .PARAMETER MacFilterEnabled
        Enable MAC address filtering.

    .PARAMETER MacFilterPolicy
        MAC filter policy: 'allow' or 'deny'. Default is 'deny'.

    .PARAMETER RadiusProfileId
        RADIUS profile ID for enterprise authentication.

    .PARAMETER PMF
        Protected Management Frames mode: 'disabled', 'optional', 'required'.

    .EXAMPLE
        New-UnifiWLAN -SiteName 'default' -Name 'Corporate-WiFi' -WLANGroupId '123abc' -Passphrase 'SecurePass123!'

    .EXAMPLE
        New-UnifiWLAN -SiteName 'default' -Name 'Guest-WiFi' -WLANGroupId '123abc' -Passphrase 'GuestPass!' -IsGuest -VLAN 100

    .EXAMPLE
        New-UnifiWLAN -SiteName 'default' -Name 'Open-Lobby' -WLANGroupId '123abc' -Security 'open' -IsGuest

    .OUTPUTS
        PSCustomObject. The created WLAN configuration.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 32)]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WLANGroupId,

        [Parameter()]
        [ValidateSet('open', 'wpa2', 'wpa3', 'wpa2wpa3', 'wpaeap', 'wpa3eap')]
        [string]$Security = 'wpa2',

        [Parameter()]
        [ValidateLength(8, 63)]
        [string]$Passphrase,

        [Parameter()]
        [switch]$HideSSID,

        [Parameter()]
        [switch]$IsGuest,

        [Parameter()]
        [ValidateRange(1, 4094)]
        [int]$VLAN,

        [Parameter()]
        [string]$UserGroupId,

        [Parameter()]
        [bool]$Enabled = $true,

        [Parameter()]
        [switch]$MacFilterEnabled,

        [Parameter()]
        [ValidateSet('allow', 'deny')]
        [string]$MacFilterPolicy = 'deny',

        [Parameter()]
        [string]$RadiusProfileId,

        [Parameter()]
        [ValidateSet('disabled', 'optional', 'required')]
        [string]$PMF
    )

    process {
        # Validate passphrase/RADIUS requirements based on security mode
        $PSKModes = @('wpa2', 'wpa3', 'wpa2wpa3')
        $EAPModes = @('wpaeap', 'wpa3eap')

        if ($Security -in $PSKModes -and -not $Passphrase) {
            throw "Passphrase is required for $Security security mode."
        }

        if ($Security -in $EAPModes -and -not $RadiusProfileId) {
            throw "RadiusProfileId is required for $Security enterprise authentication."
        }

        $Body = @{
            name         = $Name
            wlangroup_id = $WLANGroupId
            enabled      = $Enabled
            security     = $Security
            hide_ssid    = $HideSSID.IsPresent
            is_guest     = $IsGuest.IsPresent
        }

        # Add passphrase for non-open networks
        if ($Passphrase) {
            $Body.x_passphrase = $Passphrase
        }

        # VLAN configuration
        if ($VLAN) {
            $Body.vlan_enabled = $true
            $Body.vlan = $VLAN.ToString()
        }

        # User group for bandwidth limiting
        if ($UserGroupId) {
            $Body.usergroup_id = $UserGroupId
        }

        # MAC filtering
        if ($MacFilterEnabled) {
            $Body.mac_filter_enabled = $true
            $Body.mac_filter_policy = $MacFilterPolicy
            $Body.mac_filter_list = @()
        }

        # RADIUS profile for enterprise auth
        if ($RadiusProfileId) {
            $Body.radius_profile_id = $RadiusProfileId
        }

        # Protected Management Frames
        if ($PMF) {
            $Body.pmf_mode = switch ($PMF) {
                'disabled' { 0 }
                'optional' { 1 }
                'required' { 2 }
            }
        }

        if ($PSCmdlet.ShouldProcess($Name, 'Create WLAN')) {
            Invoke-UnifiApi -Endpoint 'rest/wlanconf' -SiteName $SiteName -Method Post -Body $Body
        }
    }
}
