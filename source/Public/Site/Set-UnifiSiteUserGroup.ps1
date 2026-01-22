function Set-UnifiSiteUserGroup {
    <#
    .SYNOPSIS
        Modifies an existing user group.

    .DESCRIPTION
        Updates properties of an existing user group including name and
        bandwidth limits.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER UserGroupId
        The _id of the user group to modify (from Get-UnifiSiteUserGroups).

    .PARAMETER UserGroup
        A user group object from Get-UnifiSiteUserGroups. Can be piped.

    .PARAMETER Name
        New name for the user group.

    .PARAMETER DownloadLimit
        Maximum download speed in Kbps. Use -1 for unlimited.

    .PARAMETER UploadLimit
        Maximum upload speed in Kbps. Use -1 for unlimited.

    .PARAMETER DownloadLimitMbps
        Maximum download speed in Mbps (convenience parameter).

    .PARAMETER UploadLimitMbps
        Maximum upload speed in Mbps (convenience parameter).

    .EXAMPLE
        Set-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -DownloadLimit 10000

    .EXAMPLE
        Get-UnifiSiteUserGroups -SiteName 'default' | Where-Object name -eq 'Guest' | Set-UnifiSiteUserGroup -DownloadLimitMbps 25 -UploadLimitMbps 10

    .EXAMPLE
        Set-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -Name 'New-Group-Name'

    .OUTPUTS
        PSCustomObject. The updated user group.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ById')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id', '_id')]
        [string]$UserGroupId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$UserGroup,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [ValidateRange(-1, [int]::MaxValue)]
        [int]$DownloadLimit,

        [Parameter()]
        [ValidateRange(-1, [int]::MaxValue)]
        [int]$UploadLimit,

        [Parameter()]
        [ValidateRange(1, 10000)]
        [int]$DownloadLimitMbps,

        [Parameter()]
        [ValidateRange(1, 10000)]
        [int]$UploadLimitMbps
    )

    process {
        # Get the group ID from object if provided
        $TargetId = if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $UserGroup._id
        }
        else {
            $UserGroupId
        }

        $Body = @{}

        if ($PSBoundParameters.ContainsKey('Name')) {
            $Body.name = $Name
        }

        # Handle bandwidth limits (Mbps takes precedence)
        if ($PSBoundParameters.ContainsKey('DownloadLimitMbps')) {
            $Body.qos_rate_max_down = $DownloadLimitMbps * 1000
        }
        elseif ($PSBoundParameters.ContainsKey('DownloadLimit')) {
            $Body.qos_rate_max_down = $DownloadLimit
        }

        if ($PSBoundParameters.ContainsKey('UploadLimitMbps')) {
            $Body.qos_rate_max_up = $UploadLimitMbps * 1000
        }
        elseif ($PSBoundParameters.ContainsKey('UploadLimit')) {
            $Body.qos_rate_max_up = $UploadLimit
        }

        if ($Body.Count -eq 0) {
            Write-Warning "No parameters specified to update."
            return
        }

        $Target = $Name ?? $TargetId

        if ($PSCmdlet.ShouldProcess($Target, 'Update user group')) {
            Invoke-UnifiApi -Endpoint "rest/usergroup/$TargetId" -SiteName $SiteName -Method Put -Body $Body
        }
    }
}
