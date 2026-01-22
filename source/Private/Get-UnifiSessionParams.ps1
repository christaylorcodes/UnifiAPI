function Get-UnifiSessionParams {
    <#
    .SYNOPSIS
        Returns common request parameters from the current session.

    .DESCRIPTION
        Internal helper function that builds a hashtable of common Invoke-RestMethod
        parameters based on the current UniFi session settings. Used by functions
        that need direct Invoke-RestMethod calls (file upload/download operations).

    .NOTES
        This is a private function and should not be called directly.
        Requires $script:UnifiSession to be set.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $Params = @{
        WebSession = $script:UnifiSession.WebSession
    }

    if ($script:UnifiSession.SkipCertificateCheck) {
        $Params.SkipCertificateCheck = $true
    }

    if ($script:UnifiSession.TimeoutSec) {
        $Params.TimeoutSec = $script:UnifiSession.TimeoutSec
    }

    return $Params
}
