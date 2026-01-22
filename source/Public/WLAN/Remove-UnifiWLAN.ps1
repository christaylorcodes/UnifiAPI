function Remove-UnifiWLAN {
    <#
    .SYNOPSIS
        Removes a wireless network (WLAN) from a site.

    .DESCRIPTION
        Deletes an existing WLAN configuration from the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER WLANId
        The _id of the WLAN to delete (from Get-UnifiWLANConfigs).

    .PARAMETER WLAN
        A WLAN object from Get-UnifiWLANConfigs. Can be piped.

    .EXAMPLE
        Remove-UnifiWLAN -SiteName 'default' -WLANId '5f1234567890abcdef123456'

    .EXAMPLE
        # Remove a WLAN by name (SiteName always required)
        $wlan = Get-UnifiWLANConfigs -SiteName 'default' | Where-Object name -eq 'Old-Network'
        Remove-UnifiWLAN -SiteName 'default' -WLANId $wlan._id

    .EXAMPLE
        Remove-UnifiWLAN -SiteName 'default' -WLANId '5f123...' -Confirm:$false

    .OUTPUTS
        None.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
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
        [string]$WLANId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$WLAN
    )

    process {
        # Get the WLAN ID from object if provided
        if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $TargetId = $WLAN._id
            $WLANName = $WLAN.name
        } else {
            $TargetId = $WLANId
            $WLANName = $WLANId
        }

        if ($PSCmdlet.ShouldProcess($WLANName, 'Delete WLAN')) {
            Invoke-UnifiApi -Endpoint "rest/wlanconf/$TargetId" -SiteName $SiteName -Method Delete
        }
    }
}
