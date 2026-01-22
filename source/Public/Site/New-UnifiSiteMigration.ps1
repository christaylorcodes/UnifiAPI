function New-UnifiSiteMigration {
    <#
    .SYNOPSIS
        Migrates devices to a new UniFi Controller.

    .DESCRIPTION
        Instructs specified devices to adopt to a new controller URL.

    .PARAMETER SiteName
        The current site name containing the devices. Accepts pipeline input.

    .PARAMETER NewInformUrl
        The inform URL of the new controller (e.g., http://new-controller:8080/inform).

    .PARAMETER MacAddresses
        Array of MAC addresses of devices to migrate.

    .EXAMPLE
        New-UnifiSiteMigration -SiteName 'default' -NewInformUrl 'http://new-controller:8080/inform' -MacAddresses @('00:11:22:33:44:55')

    .OUTPUTS
        PSCustomObject. Migration operation result.

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

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^https?://')]
        [string]$NewInformUrl,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$MacAddresses
    )

    process {
        # Validate and normalize MAC addresses
        $NormalizedMacs = $MacAddresses | ForEach-Object {
            Test-UnifiMacAddress -MacAddress $_ -Normalize
        }

        if ($PSCmdlet.ShouldProcess("$($MacAddresses.Count) device(s)", "Migrate to $NewInformUrl")) {
            Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName $SiteName -Method Post -Body @{
                cmd        = 'migrate'
                inform_url = $NewInformUrl
                macs       = $NormalizedMacs
            }
        }
    }
}
