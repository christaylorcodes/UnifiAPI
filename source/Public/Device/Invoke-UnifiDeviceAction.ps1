function Invoke-UnifiDeviceAction {
    <#
    .SYNOPSIS
        Performs actions on UniFi devices.

    .DESCRIPTION
        Executes various management actions on UniFi devices including restart, adopt,
        provision, locate, power cycle, speed test, and spectrum scan.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .PARAMETER MacAddress
        The MAC address of the target device. Accepts common formats:
        xx:xx:xx:xx:xx:xx, xx-xx-xx-xx-xx-xx, or xxxxxxxxxxxx

    .PARAMETER Action
        The action to perform:
        - 'restart': Reboot the device
        - 'adopt': Adopt a pending device
        - 'adopt-advanced': Adopt with custom SSH credentials (requires -Username, -Password, -SshUrl)
        - 'provision': Force re-provision the device
        - 'locate': Start LED blinking for physical identification
        - 'unlocate': Stop LED blinking
        - 'upgrade': Upgrade firmware to latest version
        - 'speedtest': Start a speed test (gateway only)
        - 'speedtest-status': Get speed test results
        - 'power-cycle': Power cycle a switch port (requires -Port)
        - 'spectrum-scan': Start RF spectrum scan (AP only)
        - 'led-on': Override device LED to always on
        - 'led-off': Override device LED to always off
        - 'led-default': Reset device LED to default behavior
        - 'enable': Enable a disabled device
        - 'disable': Disable a device

    .PARAMETER Port
        Switch port number for power-cycle action.

    .PARAMETER FirmwareUrl
        Custom firmware URL for upgrade action.

    .PARAMETER Credential
        PSCredential with SSH username/password for adopt-advanced action.

    .PARAMETER SshUrl
        SSH URL for adopt-advanced action (e.g., 'ssh://192.168.1.20:22').

    .PARAMETER DeviceId
        Device _id for LED and enable/disable actions (from Get-UnifiDevices).

    .EXAMPLE
        Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'restart'

    .EXAMPLE
        Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'locate'

    .EXAMPLE
        Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'power-cycle' -Port 5

    .EXAMPLE
        Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'upgrade' -FirmwareUrl 'https://example.com/firmware.bin'

    .EXAMPLE
        Invoke-UnifiDeviceAction -SiteName 'default' -Action 'speedtest'

    .EXAMPLE
        # Turn off LED on a device
        $device = Get-UnifiDevices -SiteName 'default' | Where-Object name -eq 'Lobby-AP'
        Invoke-UnifiDeviceAction -SiteName 'default' -DeviceId $device._id -Action 'led-off'

    .EXAMPLE
        # Disable an AP
        Invoke-UnifiDeviceAction -SiteName 'default' -DeviceId '5f123...' -Action 'disable'

    .EXAMPLE
        # Adopt with custom SSH credentials
        $cred = Get-Credential
        Invoke-UnifiDeviceAction -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Action 'adopt-advanced' -Credential $cred -SshUrl 'ssh://192.168.1.20:22'

    .OUTPUTS
        PSCustomObject. API response from the device action, or $null for some actions.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('mac')]
        [string]$MacAddress,

        [Parameter(Mandatory)]
        [ValidateSet('restart', 'adopt', 'adopt-advanced', 'provision', 'locate', 'unlocate', 'upgrade', 'speedtest', 'speedtest-status', 'power-cycle', 'spectrum-scan', 'led-on', 'led-off', 'led-default', 'enable', 'disable')]
        [string]$Action,

        [Parameter()]
        [ValidateRange(1, 52)]
        [int]$Port,

        [Parameter()]
        [ValidatePattern('^https?://')]
        [string]$FirmwareUrl,

        [Parameter()]
        [PSCredential]$Credential,

        [Parameter()]
        [ValidatePattern('^ssh://')]
        [string]$SshUrl,

        [Parameter()]
        [Alias('_id', 'Id')]
        [string]$DeviceId
    )

    process {
        # Validate MAC is provided for actions that require it
        $MacRequiredActions = @('restart', 'adopt', 'adopt-advanced', 'provision', 'locate', 'unlocate', 'upgrade', 'power-cycle', 'spectrum-scan')
        if ($Action -in $MacRequiredActions) {
            if (-not $MacAddress) {
                throw "MacAddress parameter is required for $Action action"
            }
            # Validate and normalize MAC address
            $NormalizedMac = Test-UnifiMacAddress -MacAddress $MacAddress -Normalize
        }

        # Validate DeviceId is provided for device-level actions
        $DeviceIdRequiredActions = @('led-on', 'led-off', 'led-default', 'enable', 'disable')
        if ($Action -in $DeviceIdRequiredActions -and -not $DeviceId) {
            throw "DeviceId parameter is required for $Action action. Get it from Get-UnifiDevices."
        }

        # Build the command body based on action
        $Body = switch ($Action) {
            'restart' { @{ cmd = 'restart'; mac = $NormalizedMac } }
            'adopt' { @{ cmd = 'adopt'; mac = $NormalizedMac } }
            'adopt-advanced' {
                if (-not $Credential -or -not $SshUrl) {
                    throw "Credential and SshUrl parameters are required for adopt-advanced action"
                }
                @{
                    cmd      = 'adopt'
                    mac      = $NormalizedMac
                    url      = $SshUrl
                    username = $Credential.UserName
                    password = $Credential.GetNetworkCredential().Password
                }
            }
            'provision' { @{ cmd = 'force-provision'; mac = $NormalizedMac } }
            'locate' { @{ cmd = 'set-locate'; mac = $NormalizedMac } }
            'unlocate' { @{ cmd = 'unset-locate'; mac = $NormalizedMac } }
            'upgrade' {
                if ($FirmwareUrl) {
                    @{ cmd = 'upgrade-external'; mac = $NormalizedMac; url = $FirmwareUrl }
                }
                else {
                    @{ cmd = 'upgrade'; mac = $NormalizedMac }
                }
            }
            'speedtest' { @{ cmd = 'speedtest' } }
            'speedtest-status' { @{ cmd = 'speedtest-status' } }
            'power-cycle' {
                if (-not $Port) {
                    throw "Port parameter is required for power-cycle action"
                }
                @{ cmd = 'power-cycle'; mac = $NormalizedMac; port_idx = $Port }
            }
            'spectrum-scan' { @{ cmd = 'spectrum-scan'; mac = $NormalizedMac } }
            # LED and enable/disable use REST endpoint instead of cmd/devmgr
            'led-on' { @{ led_override = 'on' } }
            'led-off' { @{ led_override = 'off' } }
            'led-default' { @{ led_override = 'default' } }
            'enable' { @{ disabled = $false } }
            'disable' { @{ disabled = $true } }
        }

        $Target = $MacAddress ? $NormalizedMac : ($DeviceId ?? $SiteName)

        if ($PSCmdlet.ShouldProcess($Target, $Action)) {
            # Device-level actions use REST PUT endpoint
            if ($Action -in $DeviceIdRequiredActions) {
                Invoke-UnifiApi -Endpoint "rest/device/$DeviceId" -SiteName $SiteName -Method Put -Body $Body
            }
            else {
                Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName $SiteName -Method Post -Body $Body
            }
        }
    }
}
