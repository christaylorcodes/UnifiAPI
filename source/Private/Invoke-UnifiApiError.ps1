function Invoke-UnifiApiError {
    <#
    .SYNOPSIS
        Standardized error handling for UniFi API calls.

    .DESCRIPTION
        Internal helper function to process API errors consistently.
        Extracts error messages from JSON responses and formats them appropriately.
        Sanitizes error messages to avoid exposing sensitive information.

    .PARAMETER ErrorRecord
        The error record from the caught exception.

    .PARAMETER Operation
        A description of the operation that failed (for error message context).

    .NOTES
        This is a private function and should not be called directly.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter(Mandatory)]
        [string]$Operation
    )

    # Extract API error message from JSON response if available
    $RawMessage = try {
        ($ErrorRecord.ErrorDetails.Message | ConvertFrom-Json)?.meta?.msg ?? $ErrorRecord.Exception.Message
    }
    catch {
        $ErrorRecord.Exception.Message
    }

    # Map common API errors to user-friendly messages
    $ErrorMessage = switch -Regex ($RawMessage) {
        'api\.err\.LoginRequired' { "Session expired. Please run 'Connect-Unifi' again." }
        'api\.err\.NoPermission' { 'Access denied. Insufficient permissions for this operation.' }
        'api\.err\.InvalidPayload' { 'Invalid request. Check the parameters provided.' }
        'api\.err\..*NotFound' { 'Resource not found. Verify the site name and identifiers.' }
        'api\.err\.DeviceNotFound' { 'Device not found. Verify the device MAC address.' }
        'api\.err\.InvalidSite' { 'Invalid site. Verify the site name exists.' }
        'certificate|SSL|TLS' { 'Certificate validation failed. Use -SkipCertificateCheck when connecting.' }
        'timeout|timed out' { 'Request timed out. Check network connectivity and controller status.' }
        'Unable to connect|Connection refused' { 'Unable to reach controller. Check network connectivity.' }
        default { $RawMessage }
    }

    throw "Error during ${Operation}: $ErrorMessage"
}
