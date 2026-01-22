function Clear-UnifiSiteAlarm {
    <#
    .SYNOPSIS
        Archives/clears alarms for a specific site.

    .DESCRIPTION
        Archives (clears) alarms for the specified UniFi site.
        Can archive a specific alarm by ID or all alarms at once.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER AlarmId
        The _id of a specific alarm to archive (from Get-UnifiSiteAlarms).

    .PARAMETER All
        Archive all alarms for the site.

    .EXAMPLE
        Clear-UnifiSiteAlarm -SiteName 'default' -AlarmId '5f1234567890abcdef123456'

    .EXAMPLE
        Clear-UnifiSiteAlarm -SiteName 'default' -All

    .EXAMPLE
        Get-UnifiSiteAlarms -SiteName 'default' | Where-Object { $_.msg -like '*disconnected*' } | ForEach-Object {
            Clear-UnifiSiteAlarm -SiteName 'default' -AlarmId $_._id
        }

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Single')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateNotNullOrEmpty()]
        [string]$AlarmId,

        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch]$All
    )

    if ($All) {
        $Body = @{
            cmd = 'archive-all-alarms'
        }
        $Target = 'all alarms'
    }
    else {
        $Body = @{
            cmd = 'archive-alarm'
            _id = $AlarmId
        }
        $Target = "alarm $AlarmId"
    }

    if ($PSCmdlet.ShouldProcess($Target, 'Archive alarm')) {
        Invoke-UnifiApi -Endpoint 'cmd/evtmgr' -SiteName $SiteName -Method Post -Body $Body
    }
}
