function Remove-UnifiSiteUserGroup {
    <#
    .SYNOPSIS
        Removes a user group from a site.

    .DESCRIPTION
        Deletes an existing user group from the specified UniFi site.
        Note: You cannot delete the default user group.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER UserGroupId
        The _id of the user group to delete (from Get-UnifiSiteUserGroups).

    .PARAMETER UserGroup
        A user group object from Get-UnifiSiteUserGroups. Can be piped.

    .EXAMPLE
        Remove-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f1234567890abcdef123456'

    .EXAMPLE
        Get-UnifiSiteUserGroups -SiteName 'default' | Where-Object name -eq 'Old-Group' | Remove-UnifiSiteUserGroup -SiteName 'default'

    .EXAMPLE
        Remove-UnifiSiteUserGroup -SiteName 'default' -UserGroupId '5f123...' -Confirm:$false

    .OUTPUTS
        None.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        The default user group cannot be deleted.
        Groups that are in use by WLANs or clients cannot be deleted.
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
        [string]$UserGroupId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$UserGroup
    )

    process {
        # Get the group ID from object if provided
        if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $TargetId = $UserGroup._id
            $GroupName = $UserGroup.name
        }
        else {
            $TargetId = $UserGroupId
            $GroupName = $UserGroupId
        }

        if ($PSCmdlet.ShouldProcess($GroupName, 'Delete user group')) {
            Invoke-UnifiApi -Endpoint "rest/usergroup/$TargetId" -SiteName $SiteName -Method Delete
        }
    }
}
