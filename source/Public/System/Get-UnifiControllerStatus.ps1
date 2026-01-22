function Get-UnifiControllerStatus {
    <#
    .SYNOPSIS
        Retrieves the status of the UniFi controller.

    .DESCRIPTION
        Returns basic status information about the UniFi controller
        without requiring authentication.

    .EXAMPLE
        Get-UnifiControllerStatus

    .NOTES
        This endpoint does not require authentication.
        Requires an active UniFi session for the base URL. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param()

    # PS7+ null-coalescing for session validation
    $script:UnifiSession ?? (throw "No UniFi session found. Please run 'Connect-Unifi' first.")

    $Uri = "$($script:UnifiSession.BaseURI)/status"

    try {
        $Response = Invoke-RestMethod -Uri $Uri -Method Get -WebSession $script:UnifiSession.WebSession
        return $Response
    }
    catch {
        throw "Failed to get controller status: $($_.Exception.Message)"
    }
}
