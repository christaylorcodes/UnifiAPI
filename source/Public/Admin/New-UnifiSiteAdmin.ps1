function New-UnifiSiteAdmin {
    <#
    .SYNOPSIS
        Creates a new site administrator.

    .DESCRIPTION
        Creates a new administrator account for the specified site. Can create a local admin,
        invite via email, or grant access to an existing admin.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER Name
        Username for the new admin (alphanumeric and underscore only).

    .PARAMETER Email
        Email address for the new admin.

    .PARAMETER Password
        Password for the new admin account (as SecureString).

    .PARAMETER Role
        Role for the admin: 'admin' for full access or 'readonly' for read-only access.

    .PARAMETER EmailInvite
        Send an email invitation instead of creating credentials directly.

    .PARAMETER ForcePasswordChange
        Require password change on first login.

    .PARAMETER DeviceAdopt
        Allow the admin to adopt devices.

    .EXAMPLE
        $securePass = ConvertTo-SecureString 'P@ssw0rd!' -AsPlainText -Force
        New-UnifiSiteAdmin -SiteName 'default' -Name 'newadmin' -Email 'admin@example.com' -Password $securePass -Role 'admin'

    .EXAMPLE
        New-UnifiSiteAdmin -SiteName 'default' -Email 'admin@example.com' -Role 'readonly' -EmailInvite

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Create')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'Create')]
        [ValidatePattern('^[a-zA-Z0-9_]+$')]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Email,

        [Parameter(Mandatory, ParameterSetName = 'Create')]
        [SecureString]$Password,

        [Parameter(Mandatory)]
        [ValidateSet('admin', 'readonly')]
        [string]$Role,

        [Parameter(Mandatory, ParameterSetName = 'Invite')]
        [switch]$EmailInvite,

        [Parameter(ParameterSetName = 'Create')]
        [switch]$ForcePasswordChange,

        [Parameter()]
        [switch]$DeviceAdopt
    )

    process {
        $Permissions = @()
        if ($DeviceAdopt) {
            $Permissions += 'API_DEVICE_ADOPT'
        }

        if ($EmailInvite) {
            $Body = @{
                cmd         = 'invite-admin'
                email       = $Email
                role        = $Role
                permissions = $Permissions
            }
        }
        else {
            $Body = @{
                cmd                   = 'create-admin'
                name                  = $Name
                email                 = $Email
                x_password            = $Password | ConvertFrom-SecureString -AsPlainText
                role                  = $Role
                requires_new_password = $ForcePasswordChange.IsPresent
                permissions           = $Permissions
            }
        }

        if ($PSCmdlet.ShouldProcess($Email, 'Create admin')) {
            Invoke-UnifiApi -Endpoint 'cmd/sitemgr' -SiteName $SiteName -Method Post -Body $Body
        }
    }
}
