function Test-UnifiFirmwareStatus {
    <#
    .SYNOPSIS
        Checks if any devices need firmware updates.

    .DESCRIPTION
        Scans all sites and reports whether firmware updates are available.

    .EXAMPLE
        Test-UnifiFirmwareStatus

    .OUTPUTS
        Returns an object indicating firmware status across all sites.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    # PS7+ null-coalescing for session validation
    $script:UnifiSession ?? (throw "No UniFi session found. Please run 'Connect-Unifi' first.")

    try {
        # Check each site for upgradable devices
        $SitesWithUpdates = Get-UnifiSites | ForEach-Object {
            $Warnings = Get-UnifiSiteWarnings -SiteName $_.name
            $Warnings.'has_upgradable_devices' ? $_.desc : $null
        } | Where-Object { $_ }

        # PS7+ ternary for message
        [PSCustomObject]@{
            UpdatesNeeded    = $SitesWithUpdates.Count -gt 0
            SitesWithUpdates = $SitesWithUpdates
            Message          = $SitesWithUpdates.Count -gt 0 ? 'Firmware updates needed.' : 'All firmware up to date.'
        }
    }
    catch {
        Invoke-UnifiApiError -ErrorRecord $_ -Operation 'checking firmware status'
    }
}
