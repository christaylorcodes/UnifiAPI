function New-UnifiWLANGroup {
    <#
    .SYNOPSIS
        Creates a new WLAN group for a specific site.

    .DESCRIPTION
        Creates a new WLAN group that can be used to organize wireless networks
        and assign them to specific access points.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Name
        The name for the WLAN group.

    .PARAMETER DeviceMacs
        Array of AP MAC addresses to include in this group.
        If not specified, the group will be empty.

    .EXAMPLE
        New-UnifiWLANGroup -SiteName 'default' -Name 'Building-A-APs'

    .EXAMPLE
        New-UnifiWLANGroup -SiteName 'default' -Name 'Lobby-APs' -DeviceMacs @('00:11:22:33:44:55', 'aa:bb:cc:dd:ee:ff')

    .OUTPUTS
        PSCustomObject. The created WLAN group.

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
        [string]$Name,

        [Parameter()]
        [string[]]$DeviceMacs
    )

    $Body = @{
        name = $Name
    }

    if ($DeviceMacs) {
        # Normalize MAC addresses using helper
        $NormalizedMacs = $DeviceMacs | ForEach-Object {
            Test-UnifiMacAddress -MacAddress $_ -Normalize
        }
        $Body.device_macs = @($NormalizedMacs)
    }
    else {
        $Body.device_macs = @()
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create WLAN group')) {
        Invoke-UnifiApi -Endpoint 'rest/wlangroup' -SiteName $SiteName -Method Post -Body $Body
    }
}
