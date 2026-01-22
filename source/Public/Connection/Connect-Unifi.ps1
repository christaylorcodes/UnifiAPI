function Connect-Unifi {
    <#
    .SYNOPSIS
        Establishes a session with a UniFi Controller.

    .DESCRIPTION
        Authenticates to a UniFi Controller and stores the session for subsequent API calls.
        Supports both credential object and username/password authentication.

    .PARAMETER BaseURI
        The base URL of the UniFi Controller (e.g., https://unifi.example.com:8443).

    .PARAMETER Credential
        PSCredential object containing username and password. Recommended for security.

    .PARAMETER Username
        Username for authentication. Use -Credential instead when possible.

    .PARAMETER Password
        Password as SecureString. Use -Credential instead when possible.

    .PARAMETER SkipCertificateCheck
        Skip SSL/TLS certificate validation. Useful for self-signed certificates
        commonly found on UniFi Controllers. Use with caution in production.

    .PARAMETER TimeoutSec
        Connection timeout in seconds. Default is 30 seconds.

    .EXAMPLE
        $cred = Get-Credential
        Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Credential $cred

    .EXAMPLE
        Connect-Unifi -BaseURI 'https://unifi.example.com:8443' -Username 'admin' -Password (Read-Host -AsSecureString)

    .EXAMPLE
        # Connect with self-signed certificate
        Connect-Unifi -BaseURI 'https://192.168.1.1:8443' -Credential $cred -SkipCertificateCheck

    .OUTPUTS
        None. Stores session in module-scoped variable for use by other functions.

    .NOTES
        The session is stored in $script:UnifiSession and used by all other module functions.
        Use Get-UnifiSession to check connection status.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseURI,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [PSCredential]$Credential,

        [Parameter(Mandatory, ParameterSetName = 'PlainText')]
        [string]$Username,

        [Parameter(Mandatory, ParameterSetName = 'PlainText')]
        [SecureString]$Password,

        [Parameter()]
        [switch]$SkipCertificateCheck,

        [Parameter()]
        [ValidateRange(1, 300)]
        [int]$TimeoutSec = 30
    )

    $credBody = $null
    $Body = $null

    try {
        # Build credential body (PS7+ ternary and ConvertFrom-SecureString)
        $credBody = $PSCmdlet.ParameterSetName -eq 'Credential' ? @{
            username = $Credential.UserName
            password = $Credential.GetNetworkCredential().Password
        } : @{
            username = $Username
            password = $Password | ConvertFrom-SecureString -AsPlainText
        }

        $Body = $credBody | ConvertTo-Json

        # Initialize session storage (module-scoped)
        $script:UnifiSession = @{
            BaseURI              = $BaseURI.TrimEnd('/')
            SkipCertificateCheck = $SkipCertificateCheck.IsPresent
            TimeoutSec           = $TimeoutSec
        }

        # Build request parameters
        $RequestParams = @{
            Uri             = "$($script:UnifiSession.BaseURI)/api/login"
            Method          = 'Post'
            Body            = $Body
            ContentType     = 'application/json; charset=utf-8'
            SessionVariable = 'WebSession'
            TimeoutSec      = $TimeoutSec
        }

        if ($SkipCertificateCheck) {
            $RequestParams.SkipCertificateCheck = $true
        }

        # Authenticate
        $null = Invoke-RestMethod @RequestParams

        $script:UnifiSession.WebSession = $WebSession

        Write-Verbose "Successfully connected to UniFi Controller at $($script:UnifiSession.BaseURI)"
    }
    catch {
        $script:UnifiSession = $null

        # Sanitize error message to avoid exposing sensitive details
        $ErrorMessage = switch -Regex ($_.Exception.Message) {
            'Unable to connect|Connection refused|No such host' {
                'Unable to connect to controller. Verify the URL and network connectivity.'
            }
            'certificate|SSL|TLS' {
                'Certificate validation failed. Use -SkipCertificateCheck for self-signed certificates.'
            }
            '401|Unauthorized|Invalid' {
                'Authentication failed. Verify username and password.'
            }
            'timeout|timed out' {
                "Connection timed out after $TimeoutSec seconds."
            }
            default {
                'Connection failed. Check controller URL and credentials.'
            }
        }

        throw "Failed to connect to UniFi Controller: $ErrorMessage"
    }
    finally {
        # Clear sensitive data from memory
        if ($credBody) { $credBody.password = $null }
        $credBody = $null
        $Body = $null
    }
}
