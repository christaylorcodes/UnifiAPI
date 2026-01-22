function Get-UnifiFirmware {
    <#
    .SYNOPSIS
        Lists available firmware versions for a site.

    .DESCRIPTION
        Returns available firmware updates for devices on the specified site.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .EXAMPLE
        Get-UnifiFirmware -SiteName 'default'

    .EXAMPLE
        Get-UnifiSites | Get-UnifiFirmware

    .OUTPUTS
        PSCustomObject. Available firmware information.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName
    )

    process {
        Invoke-UnifiApi -Endpoint 'cmd/firmware' -SiteName $SiteName -Method Post -Body @{
            cmd = 'list-available'
        }
    }
}
