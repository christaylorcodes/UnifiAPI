function Set-UnifiDeviceMigration {
    <#
    .SYNOPSIS
        Migrates a UniFi device to a different controller.

    .DESCRIPTION
        Updates the inform URL of a device to migrate it to a different UniFi controller.
        Can also cancel a pending migration.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER MacAddress
        The MAC address of the device to migrate.

    .PARAMETER InformUrl
        The new inform URL for the target controller.

    .PARAMETER Cancel
        Cancel a pending migration for the device.

    .EXAMPLE
        Set-UnifiDeviceMigration -SiteName 'default' -MacAddress '00:11:22:33:44:55' -InformUrl 'https://newcontroller:8080/inform'

    .EXAMPLE
        Set-UnifiDeviceMigration -SiteName 'default' -MacAddress '00:11:22:33:44:55' -Cancel

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Migrate')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress,

        [Parameter(Mandatory, ParameterSetName = 'Migrate')]
        [ValidateNotNullOrEmpty()]
        [string]$InformUrl,

        [Parameter(Mandatory, ParameterSetName = 'Cancel')]
        [switch]$Cancel
    )

    # Normalize MAC address
    $NormalizedMac = $MacAddress -replace '([0-9a-fA-F]{2})[^0-9a-fA-F]?(?=.)', '$1:'

    if ($Cancel) {
        $Body = @{
            cmd = 'cancel-migrate'
            mac = $NormalizedMac
        }
        $Operation = 'Cancel migration'
    }
    else {
        $Body = @{
            cmd        = 'migrate'
            mac        = $NormalizedMac
            inform_url = $InformUrl
        }
        $Operation = "Migrate to $InformUrl"
    }

    if ($PSCmdlet.ShouldProcess($NormalizedMac, $Operation)) {
        Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName $SiteName -Method Post -Body $Body
    }
}
