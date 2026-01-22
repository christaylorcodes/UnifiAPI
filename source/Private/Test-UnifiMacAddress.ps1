function Test-UnifiMacAddress {
    <#
    .SYNOPSIS
        Validates a MAC address format.

    .DESCRIPTION
        Internal helper function to validate MAC address format.
        Accepts common formats: xx:xx:xx:xx:xx:xx, xx-xx-xx-xx-xx-xx, xxxxxxxxxxxx

    .PARAMETER MacAddress
        The MAC address string to validate.

    .PARAMETER Normalize
        If specified, returns the normalized MAC address (lowercase, colon-separated).
        Otherwise returns $true/$false.

    .NOTES
        This is a private function and should not be called directly.
    #>
    [CmdletBinding()]
    [OutputType([bool], [string])]
    param(
        [Parameter(Mandatory)]
        [string]$MacAddress,

        [Parameter()]
        [switch]$Normalize
    )

    # Remove common separators and convert to lowercase
    $CleanMac = $MacAddress.ToLower() -replace '[:\-\.]', ''

    # Validate format (12 hex characters)
    if ($CleanMac -notmatch '^[0-9a-f]{12}$') {
        if ($Normalize) {
            throw "Invalid MAC address format: $MacAddress. Expected format: xx:xx:xx:xx:xx:xx"
        }
        return $false
    }

    if ($Normalize) {
        # Return normalized format (lowercase, colon-separated)
        return ($CleanMac -replace '(.{2})', '$1:').TrimEnd(':')
    }

    return $true
}
