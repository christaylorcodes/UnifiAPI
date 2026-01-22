function Get-UnifiEventStrings {
    <#
    .SYNOPSIS
        Retrieves event string definitions for a specific site.

    .DESCRIPTION
        Returns the event string definitions used for event messages
        in the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiEventStrings -SiteName 'default'

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName
    )

    process {
        Invoke-UnifiApi -Endpoint 'stat/event-strings' -SiteName $SiteName
    }
}
