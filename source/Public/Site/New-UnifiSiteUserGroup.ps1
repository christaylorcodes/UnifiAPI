function New-UnifiSiteUserGroup {
    <#
    .SYNOPSIS
        Creates a new user group for bandwidth limiting.

    .DESCRIPTION
        Creates a new user group that can be assigned to clients or WLANs
        for bandwidth rate limiting.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Name
        The name for the user group.

    .PARAMETER DownloadLimit
        Maximum download speed in Kbps. Use -1 for unlimited.
        Default is -1 (unlimited).

    .PARAMETER UploadLimit
        Maximum upload speed in Kbps. Use -1 for unlimited.
        Default is -1 (unlimited).

    .PARAMETER DownloadLimitMbps
        Maximum download speed in Mbps (convenience parameter).
        Overrides DownloadLimit if specified.

    .PARAMETER UploadLimitMbps
        Maximum upload speed in Mbps (convenience parameter).
        Overrides UploadLimit if specified.

    .EXAMPLE
        New-UnifiSiteUserGroup -SiteName 'default' -Name 'Guest-Limited' -DownloadLimit 5000 -UploadLimit 2000

    .EXAMPLE
        New-UnifiSiteUserGroup -SiteName 'default' -Name 'VIP-Users' -DownloadLimitMbps 100 -UploadLimitMbps 50

    .EXAMPLE
        New-UnifiSiteUserGroup -SiteName 'default' -Name 'Unlimited-Users'

    .OUTPUTS
        PSCustomObject. The created user group.

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
        [Alias('GroupName')]
        [string]$Name,

        [Parameter()]
        [ValidateRange(-1, [int]::MaxValue)]
        [int]$DownloadLimit = -1,

        [Parameter()]
        [ValidateRange(-1, [int]::MaxValue)]
        [int]$UploadLimit = -1,

        [Parameter()]
        [ValidateRange(1, 10000)]
        [int]$DownloadLimitMbps,

        [Parameter()]
        [ValidateRange(1, 10000)]
        [int]$UploadLimitMbps
    )

    # Convert Mbps to Kbps if specified
    $DownRate = if ($PSBoundParameters.ContainsKey('DownloadLimitMbps')) {
        $DownloadLimitMbps * 1000
    } else {
        $DownloadLimit
    }

    $UpRate = if ($PSBoundParameters.ContainsKey('UploadLimitMbps')) {
        $UploadLimitMbps * 1000
    } else {
        $UploadLimit
    }

    $Body = @{
        name              = $Name
        qos_rate_max_down = $DownRate
        qos_rate_max_up   = $UpRate
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create user group')) {
        Invoke-UnifiApi -Endpoint 'rest/usergroup' -SiteName $SiteName -Method Post -Body $Body
    }
}
