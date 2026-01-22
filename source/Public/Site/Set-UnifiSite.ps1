function Set-UnifiSite {
    <#
    .SYNOPSIS
        Updates the description (display name) of an existing site.

    .DESCRIPTION
        Renames a site by updating its description/display name.
        The internal site name cannot be changed.

    .PARAMETER SiteName
        The internal site name (not description) to update.

    .PARAMETER Site
        A site object from Get-UnifiSites. Can be piped.

    .PARAMETER Description
        The new display name/description for the site.

    .EXAMPLE
        Set-UnifiSite -SiteName 'abc123xyz' -Description 'Client ABC - New Name'

    .EXAMPLE
        Get-UnifiSites | Where-Object desc -like '*Old Name*' | Set-UnifiSite -Description 'New Name'

    .OUTPUTS
        PSCustomObject. The updated site object.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [Alias('name')]
        [string]$SiteName,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$Site,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias('NewName', 'Desc')]
        [string]$Description
    )

    process {
        # Get the site name from object if provided
        $TargetSite = if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $Site.name
        } else {
            $SiteName
        }

        $Body = @{
            cmd  = 'update-site'
            desc = $Description
        }

        if ($PSCmdlet.ShouldProcess($TargetSite, "Rename to '$Description'")) {
            Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $TargetSite -Method Post -Body $Body
        }
    }
}
