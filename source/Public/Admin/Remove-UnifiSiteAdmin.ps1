function Remove-UnifiSiteAdmin {
    <#
    .SYNOPSIS
        Removes an administrator from a site.

    .DESCRIPTION
        Revokes administrator access from the specified site for a given admin ID.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER AdminId
        The _id of the admin to remove (from Get-UnifiAdmins).

    .EXAMPLE
        Remove-UnifiSiteAdmin -SiteName 'default' -AdminId '5f1234567890abcdef123456'

    .EXAMPLE
        Get-UnifiAdmins | Where-Object { $_.name -eq 'oldadmin' } | ForEach-Object {
            Remove-UnifiSiteAdmin -SiteName 'default' -AdminId $_._id
        }

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
        [string]$AdminId
    )

    process {
        $Body = @{
            cmd   = 'revoke-admin'
            admin = $AdminId
        }

        if ($PSCmdlet.ShouldProcess($AdminId, 'Remove admin from site')) {
            Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $SiteName -Method Post -Body $Body
        }
    }
}
