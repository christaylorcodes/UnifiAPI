function Update-UnifiFirmware {
    <#
    .SYNOPSIS
        Triggers a firmware update for a device.

    .DESCRIPTION
        Initiates a firmware upgrade for the specified device by MAC address.

    .PARAMETER SiteName
        The internal site name containing the device. Accepts pipeline input.

    .PARAMETER MacAddress
        The MAC address of the device. Accepts common formats.

    .PARAMETER Version
        Optional specific firmware version to upgrade to. If not specified, upgrades to latest.

    .EXAMPLE
        Update-UnifiFirmware -SiteName 'default' -MacAddress '00:11:22:33:44:55'

    .EXAMPLE
        Update-UnifiFirmware -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Version '6.0.21'

    .OUTPUTS
        PSCustomObject. Firmware update result.

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

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('mac')]
        [string]$MacAddress,

        [Parameter()]
        [string]$Version
    )

    process {
        # Validate and normalize MAC address
        $NormalizedMac = Test-UnifiMacAddress -MacAddress $MacAddress -Normalize

        $TargetVersion = $Version ? $Version : 'latest'

        if ($PSCmdlet.ShouldProcess($NormalizedMac, "Update firmware to $TargetVersion")) {
            $Body = @{
                mac = $NormalizedMac
                cmd = 'upgrade'
            }

            if ($Version) {
                $Body.'upgrade_to_firmware' = $Version
            }

            Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName $SiteName -Method Post -Body $Body
        }
    }
}
