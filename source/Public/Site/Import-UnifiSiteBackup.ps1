function Import-UnifiSiteBackup {
    <#
    .SYNOPSIS
        Imports a site backup to the UniFi Controller.

    .DESCRIPTION
        Uploads and restores a site configuration from a backup file.

    .PARAMETER SiteName
        The internal site name to restore to. Accepts pipeline input.

    .PARAMETER FilePath
        Path to the backup file (.unf).

    .EXAMPLE
        Import-UnifiSiteBackup -SiteName 'default' -FilePath 'C:\Backups\site-backup.unf'

    .OUTPUTS
        PSCustomObject. Restore operation result.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$FilePath
    )

    process {
        if (-not $script:UnifiSession) {
            throw "No UniFi session found. Please run 'Connect-Unifi' first."
        }

        try {
            if ($PSCmdlet.ShouldProcess($SiteName, "Import site backup from $FilePath")) {
                $UploadParams = Get-UnifiSessionParams
                $UploadParams.Uri = "$($script:UnifiSession.BaseURI)/api/s/$SiteName/cmd/backup"
                $UploadParams.Method = 'Post'
                $UploadParams.Form = @{ file = Get-Item -Path $FilePath }

                $Response = Invoke-RestMethod @UploadParams
                return $Response.data
            }
        }
        catch {
            Invoke-UnifiApiError -ErrorRecord $_ -Operation 'importing site backup'
        }
    }
}
