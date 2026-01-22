function Remove-UnifiSite {
    <#
    .SYNOPSIS
        Deletes a site from the UniFi Controller.

    .DESCRIPTION
        Permanently removes a site and all its configuration from the controller.

    .PARAMETER Site
        The site object to remove. Obtain from Get-UnifiSites.

    .EXAMPLE
        $site = Get-UnifiSites | Where-Object { $_.desc -eq 'Old Site' }
        Remove-UnifiSite -Site $site

    .EXAMPLE
        Get-UnifiSites | Where-Object { $_.desc -eq 'Old Site' } | Remove-UnifiSite

    .OUTPUTS
        PSCustomObject. Deletion result.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [PSCustomObject]$Site
    )

    process {
        if ($PSCmdlet.ShouldProcess($Site.desc, 'Delete site')) {
            Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $Site.name -Method Post -Body @{
                cmd  = 'delete-site'
                site = $Site._id
            }
        }
    }
}
