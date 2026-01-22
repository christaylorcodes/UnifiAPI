function Invoke-UnifiRequest {
    <#
    .SYNOPSIS
        Makes an HTTP request to the UniFi Controller.

    .DESCRIPTION
        Internal helper function to make HTTP requests with proper session handling,
        retry logic, and error checking.

    .PARAMETER Uri
        The full URI to request.

    .PARAMETER Method
        HTTP method to use.

    .PARAMETER Body
        Optional request body as hashtable.

    .NOTES
        This is a private function and should not be called directly.
        Requires $script:UnifiSession to be set.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [string]$Uri,

        [Parameter(Mandatory)]
        [string]$Method,

        [Parameter()]
        [hashtable]$Body
    )

    $RequestParams = @{
        Uri                = $Uri
        Method             = $Method
        WebSession         = $script:UnifiSession.WebSession
        SkipHttpErrorCheck = $true
        StatusCodeVariable = 'HttpStatus'
        MaximumRetryCount  = 3
        RetryIntervalSec   = 2
    }

    if ($script:UnifiSession.SkipCertificateCheck) {
        $RequestParams.SkipCertificateCheck = $true
    }
    if ($script:UnifiSession.TimeoutSec) {
        $RequestParams.TimeoutSec = $script:UnifiSession.TimeoutSec
    }

    if ($Body) {
        $RequestParams.Body = $Body | ConvertTo-Json -Depth 10
        $RequestParams.ContentType = 'application/json'
    }

    Write-Verbose "Invoking UniFi API: $Method $Uri"

    $Response = Invoke-RestMethod @RequestParams

    if ($HttpStatus -ge 400) {
        # Handle both JSON API errors and non-JSON responses (e.g., HTML from proxies)
        $ErrorMsg = try {
            if ($Response -is [PSCustomObject] -and $Response.meta.msg) {
                $Response.meta.msg
            }
            else {
                "HTTP Error: $HttpStatus"
            }
        }
        catch {
            "HTTP Error: $HttpStatus"
        }
        throw "API request failed ($HttpStatus): $ErrorMsg"
    }

    return $Response
}
