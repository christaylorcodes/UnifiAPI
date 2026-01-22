function Get-UnifiSiteBackup {
    <#
    .SYNOPSIS
        Exports a backup of a specific site.

    .DESCRIPTION
        Creates and downloads a backup file for the specified site configuration.

    .PARAMETER SiteName
        The internal site name (not description). Accepts pipeline input.

    .PARAMETER OutputPath
        Optional path to save the backup file. Defaults to temp directory.

    .EXAMPLE
        Get-UnifiSiteBackup -SiteName 'default'

    .EXAMPLE
        Get-UnifiSiteBackup -SiteName 'default' -OutputPath 'C:\Backups'

    .OUTPUTS
        System.String. Returns the full path to the downloaded backup file.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter()]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$OutputPath = $env:TEMP
    )

    process {
        try {
            # Request backup creation (Invoke-UnifiApi validates session)
            $Result = Invoke-UnifiApi -Endpoint 'cmd/backup' -SiteName $SiteName -Method Post -Body @{
                cmd = 'export-site'
            }

            # Download the backup file using session parameters
            $FileName = Split-Path $Result.url -Leaf
            $FullPath = Join-Path $OutputPath $FileName

            $DownloadParams = Get-UnifiSessionParams
            $DownloadParams.Uri = "$($script:UnifiSession.BaseURI)/$($Result.url)"
            $DownloadParams.OutFile = $FullPath

            Invoke-RestMethod @DownloadParams

            return $FullPath
        }
        catch {
            Invoke-UnifiApiError -ErrorRecord $_ -Operation 'exporting site backup'
        }
    }
}
