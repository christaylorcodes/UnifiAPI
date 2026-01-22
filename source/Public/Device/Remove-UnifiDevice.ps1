function Remove-UnifiDevice {
    <#
    .SYNOPSIS
        Removes a device from a site.

    .DESCRIPTION
        Deletes a device from the UniFi Controller. The device must be disconnected.

    .PARAMETER Device
        The device object to remove. Must include 'mac' and 'site_name' properties.

    .EXAMPLE
        $device = Get-UnifiDisconnectedWaps | Where-Object { $_.name -eq 'Old AP' }
        Remove-UnifiDevice -Device $device

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [PSCustomObject]$Device
    )

    process {
        $DeviceName = if ($Device.name) { $Device.name } else { $Device.mac }

        if ($PSCmdlet.ShouldProcess($DeviceName, 'Delete device')) {
            Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $Device.site_name -Method Post -Body @{
                cmd = 'delete-device'
                mac = $Device.mac
            }
        }
    }
}
