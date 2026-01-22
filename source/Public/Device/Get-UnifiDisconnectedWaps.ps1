function Get-UnifiDisconnectedWaps {
    <#
    .SYNOPSIS
        Finds all disconnected wireless access points.

    .DESCRIPTION
        Scans all sites and returns WAPs that are currently disconnected,
        excluding devices marked as spare.

    .EXAMPLE
        Get-UnifiDisconnectedWaps

    .EXAMPLE
        Get-UnifiDisconnectedWaps | Select-Object name, site_desc, disconnected

    .OUTPUTS
        Returns device objects with additional site_desc, site_name, and disconnected properties.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    # PS7+ null-coalescing for session validation
    $script:UnifiSession ?? (throw "No UniFi session found. Please run 'Connect-Unifi' first.")

    try {
        $Sites = Get-UnifiSites
        foreach ($Site in $Sites) {
            Get-UnifiDevices -SiteName $Site.name | Where-Object {
                $_.state -eq 0 -and $_.name -notlike '*spare*'
            } | ForEach-Object {
                # PS7+ Add-Member with hashtable for multiple properties
                $DisconnectedUtc = [DateTime]::UnixEpoch.AddMilliseconds($_.start_disconnected_millis)
                $_ | Add-Member -NotePropertyMembers @{
                    site_desc    = $Site.desc
                    site_name    = $Site.name
                    disconnected = $DisconnectedUtc.ToLocalTime()
                } -Force -PassThru
            }
        }
    }
    catch {
        Invoke-UnifiApiError -ErrorRecord $_ -Operation 'getting disconnected WAPs'
    }
}
