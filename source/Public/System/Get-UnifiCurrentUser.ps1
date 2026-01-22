function Get-UnifiCurrentUser {
    <#
    .SYNOPSIS
        Retrieves information about the currently authenticated user.

    .DESCRIPTION
        Returns details about the currently logged-in administrator including
        permissions and site access.

    .PARAMETER SiteName
        The internal site name (not description).

    .EXAMPLE
        Get-UnifiCurrentUser -SiteName 'default'

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
        Invoke-UnifiApi -Endpoint 'self' -SiteName $SiteName
    }
}
