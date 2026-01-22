function Set-UnifiWLAN {
    <#
    .SYNOPSIS
        Modifies an existing wireless network (WLAN) configuration.

    .DESCRIPTION
        Updates properties of an existing WLAN on the specified UniFi site.
        Only specified parameters are changed; others remain unchanged.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER WLANId
        The _id of the WLAN to modify (from Get-UnifiWLANConfigs).

    .PARAMETER WLAN
        A WLAN object from Get-UnifiWLANConfigs. Can be piped.

    .PARAMETER Name
        New SSID name for the wireless network.

    .PARAMETER Passphrase
        New network password (8-63 characters).

    .PARAMETER HideSSID
        Hide or show the SSID. Use $true to hide, $false to broadcast.

    .PARAMETER Enabled
        Enable or disable the WLAN.

    .PARAMETER VLAN
        VLAN ID to assign. Use 0 to disable VLAN tagging.

    .PARAMETER UserGroupId
        User group ID for bandwidth limiting.

    .PARAMETER MacFilterEnabled
        Enable or disable MAC address filtering.

    .PARAMETER MacFilterPolicy
        MAC filter policy: 'allow' or 'deny'.

    .PARAMETER MacFilterList
        Array of MAC addresses for the filter list.

    .EXAMPLE
        Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -Passphrase 'NewSecurePass!'

    .EXAMPLE
        # Disable a WLAN (SiteName required when piping)
        $wlan = Get-UnifiWLANConfigs -SiteName 'default' | Where-Object name -eq 'Guest-WiFi'
        Set-UnifiWLAN -SiteName 'default' -WLANId $wlan._id -Enabled $false

    .EXAMPLE
        Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -VLAN 200 -HideSSID $true

    .EXAMPLE
        # Unhide an SSID
        Set-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -HideSSID $false

    .OUTPUTS
        PSCustomObject. The updated WLAN configuration.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ById')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id', '_id')]
        [string]$WLANId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$WLAN,

        [Parameter()]
        [ValidateLength(1, 32)]
        [string]$Name,

        [Parameter()]
        [ValidateLength(8, 63)]
        [string]$Passphrase,

        [Parameter()]
        [bool]$HideSSID,

        [Parameter()]
        [bool]$Enabled,

        [Parameter()]
        [ValidateRange(0, 4094)]
        [int]$VLAN,

        [Parameter()]
        [string]$UserGroupId,

        [Parameter()]
        [bool]$MacFilterEnabled,

        [Parameter()]
        [ValidateSet('allow', 'deny')]
        [string]$MacFilterPolicy,

        [Parameter()]
        [string[]]$MacFilterList
    )

    process {
        # Get the WLAN ID from object if provided
        $TargetId = if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $WLAN._id
        }
        else {
            $WLANId
        }

        # Build body with only specified parameters
        $Body = @{}

        if ($PSBoundParameters.ContainsKey('Name')) {
            $Body.name = $Name
        }

        if ($PSBoundParameters.ContainsKey('Passphrase')) {
            $Body.x_passphrase = $Passphrase
        }

        if ($PSBoundParameters.ContainsKey('HideSSID')) {
            $Body.hide_ssid = $HideSSID
        }

        if ($PSBoundParameters.ContainsKey('Enabled')) {
            $Body.enabled = $Enabled
        }

        if ($PSBoundParameters.ContainsKey('VLAN')) {
            if ($VLAN -eq 0) {
                $Body.vlan_enabled = $false
            }
            else {
                $Body.vlan_enabled = $true
                $Body.vlan = $VLAN.ToString()
            }
        }

        if ($PSBoundParameters.ContainsKey('UserGroupId')) {
            $Body.usergroup_id = $UserGroupId
        }

        if ($PSBoundParameters.ContainsKey('MacFilterEnabled')) {
            $Body.mac_filter_enabled = $MacFilterEnabled
        }

        if ($PSBoundParameters.ContainsKey('MacFilterPolicy')) {
            $Body.mac_filter_policy = $MacFilterPolicy
        }

        if ($PSBoundParameters.ContainsKey('MacFilterList')) {
            $Body.mac_filter_list = @($MacFilterList)
        }

        if ($Body.Count -eq 0) {
            Write-Warning "No parameters specified to update."
            return
        }

        $Target = $Name ?? $TargetId

        if ($PSCmdlet.ShouldProcess($Target, 'Update WLAN')) {
            Invoke-UnifiApi -Endpoint "rest/wlanconf/$TargetId" -SiteName $SiteName -Method Put -Body $Body
        }
    }
}
