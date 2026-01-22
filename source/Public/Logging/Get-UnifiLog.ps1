function Get-UnifiLog {
    <#
    .SYNOPSIS
        Retrieves AI logs for a site (v2 API).

    .DESCRIPTION
        Returns Next-AI logs from the UniFi Controller v2 API.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiLog -SiteName 'default'

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        Uses the v2 API endpoint.
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
        Invoke-UnifiApi -Endpoint 'next-ai/logs' -SiteName $SiteName -ApiV2 -Raw
    }
}
