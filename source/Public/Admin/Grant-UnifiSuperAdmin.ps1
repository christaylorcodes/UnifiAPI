function Grant-UnifiSuperAdmin {
    <#
    .SYNOPSIS
        Grants super admin privileges to an existing admin.

    .DESCRIPTION
        Elevates an existing administrator account to super admin status,
        granting access to all sites on the controller.

    .PARAMETER AdminId
        The _id of the admin to promote (from Get-UnifiAdmins).

    .EXAMPLE
        Grant-UnifiSuperAdmin -AdminId '5f1234567890abcdef123456'

    .EXAMPLE
        Get-UnifiAdmins | Where-Object { $_.name -eq 'newadmin' } | ForEach-Object {
            Grant-UnifiSuperAdmin -AdminId $_._id
        }

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        The admin must have 'is_verified' set to true for this command to work.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AdminId
    )

    $Body = @{
        cmd   = 'grant-super-admin'
        admin = $AdminId
    }

    if ($PSCmdlet.ShouldProcess($AdminId, 'Grant super admin')) {
        Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName 'default' -Method Post -Body $Body
    }
}
