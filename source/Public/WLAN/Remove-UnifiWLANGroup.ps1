function Remove-UnifiWLANGroup {
    <#
    .SYNOPSIS
        Removes a WLAN group from a site.

    .DESCRIPTION
        Deletes an existing WLAN group from the specified UniFi site.
        Note: You cannot delete the default WLAN group.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER WLANGroupId
        The _id of the WLAN group to delete (from Get-UnifiWLANGroups).

    .PARAMETER WLANGroup
        A WLAN group object from Get-UnifiWLANGroups. Can be piped.

    .EXAMPLE
        Remove-UnifiWLANGroup -SiteName 'default' -WLANGroupId '5f1234567890abcdef123456'

    .EXAMPLE
        Get-UnifiWLANGroups -SiteName 'default' | Where-Object name -eq 'Old-Group' | Remove-UnifiWLANGroup -SiteName 'default'

    .OUTPUTS
        None.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        The default WLAN group cannot be deleted.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ById')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id', '_id')]
        [string]$WLANGroupId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$WLANGroup
    )

    process {
        # Get the group ID from object if provided
        if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $TargetId = $WLANGroup._id
            $GroupName = $WLANGroup.name
        }
        else {
            $TargetId = $WLANGroupId
            $GroupName = $WLANGroupId
        }

        if ($PSCmdlet.ShouldProcess($GroupName, 'Delete WLAN group')) {
            Invoke-UnifiApi -Endpoint "rest/wlangroup/$TargetId" -SiteName $SiteName -Method Delete
        }
    }
}
