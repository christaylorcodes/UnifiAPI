function ConvertTo-UnifiUnixTime {
    <#
    .SYNOPSIS
        Converts a DateTime to Unix timestamp in milliseconds.

    .DESCRIPTION
        Internal helper function to convert DateTime objects to Unix timestamps
        in milliseconds, which is the format expected by UniFi API endpoints.

    .PARAMETER DateTime
        The DateTime to convert. If not specified, returns current time.

    .PARAMETER Seconds
        Return Unix timestamp in seconds instead of milliseconds.

    .NOTES
        This is a private function and should not be called directly.
    #>
    [CmdletBinding()]
    [OutputType([long])]
    param(
        [Parameter(ValueFromPipeline)]
        [datetime]$DateTime = (Get-Date),

        [Parameter()]
        [switch]$Seconds
    )

    process {
        $UnixTime = [long]([DateTimeOffset]$DateTime).ToUnixTimeMilliseconds()

        if ($Seconds) {
            return [long]($UnixTime / 1000)
        }

        return $UnixTime
    }
}
