function Disconnect-Unifi {
    <#
    .SYNOPSIS
        Disconnects from the UniFi Controller and clears the session.

    .DESCRIPTION
        Logs out of the UniFi Controller API and removes the stored session.

    .EXAMPLE
        Disconnect-Unifi

    .OUTPUTS
        None. Clears the module-scoped session variable.

    .NOTES
        Safe to call even if no session exists.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param()

    try {
        if ($script:UnifiSession) {
            $LogoutParams = @{
                Uri         = "$($script:UnifiSession.BaseURI)/api/logout"
                Method      = 'Post'
                WebSession  = $script:UnifiSession.WebSession
                ErrorAction = 'SilentlyContinue'
            }

            if ($script:UnifiSession.SkipCertificateCheck) {
                $LogoutParams.SkipCertificateCheck = $true
            }

            $null = Invoke-RestMethod @LogoutParams
        }
    }
    finally {
        $script:UnifiSession = $null
        Write-Verbose 'Disconnected from UniFi Controller'
    }
}
