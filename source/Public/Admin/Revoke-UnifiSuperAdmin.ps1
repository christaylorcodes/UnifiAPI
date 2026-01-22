function Revoke-UnifiSuperAdmin {
    <#
    .SYNOPSIS
        Revokes super admin privileges from an admin.

    .DESCRIPTION
        Removes super admin status from an administrator account,
        restricting access to only assigned sites.

    .PARAMETER AdminId
        The _id of the admin to demote (from Get-UnifiAdmins).

    .EXAMPLE
        Revoke-UnifiSuperAdmin -AdminId '5f1234567890abcdef123456'

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AdminId
    )

    $Body = @{
        cmd   = 'revoke-super-admin'
        admin = $AdminId
    }

    if ($PSCmdlet.ShouldProcess($AdminId, 'Revoke super admin')) {
        Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName 'default' -Method Post -Body $Body
    }
}
