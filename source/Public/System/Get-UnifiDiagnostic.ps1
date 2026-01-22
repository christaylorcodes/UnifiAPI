function Get-UnifiDiagnostic {
    <#
    .SYNOPSIS
        Returns diagnostic information about the UnifiAPI module and environment.

    .DESCRIPTION
        Provides comprehensive diagnostic information including:
        - Module version and installation details
        - PowerShell version and edition
        - Current session status and connection details
        - Controller version (if connected)

        Useful for troubleshooting and support requests.

    .PARAMETER IncludeControllerStatus
        Attempt to retrieve controller status even if not authenticated.

    .EXAMPLE
        Get-UnifiDiagnostic
        # Returns module, PowerShell, and session information

    .EXAMPLE
        Get-UnifiDiagnostic -IncludeControllerStatus
        # Also attempts to fetch controller status

    .OUTPUTS
        PSCustomObject with diagnostic information.

    .NOTES
        Does not require authentication for basic diagnostics.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [switch]$IncludeControllerStatus
    )

    # Get module information
    $Module = Get-Module -Name UnifiAPI -ErrorAction SilentlyContinue

    $ModuleInfo = if ($Module) {
        [ordered]@{
            Name           = $Module.Name
            Version        = $Module.Version.ToString()
            ModuleBase     = $Module.ModuleBase
            LoadedCommands = $Module.ExportedCommands.Count
        }
    }
    else {
        [ordered]@{
            Name           = 'UnifiAPI'
            Version        = 'Not Loaded'
            ModuleBase     = $null
            LoadedCommands = 0
        }
    }

    # Get PowerShell environment
    $PSInfo = [ordered]@{
        Version      = $PSVersionTable.PSVersion.ToString()
        Edition      = $PSVersionTable.PSEdition
        OS           = $PSVersionTable.OS ?? [System.Environment]::OSVersion.VersionString
        Platform     = $PSVersionTable.Platform ?? 'Windows'
        Architecture = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
    }

    # Get session information (properties from Connect-Unifi: BaseURI, SkipCertificateCheck, TimeoutSec, WebSession)
    $SessionInfo = if ($script:UnifiSession) {
        [ordered]@{
            Connected     = $true
            ControllerUrl = $script:UnifiSession.BaseURI
            SkipCertCheck = $script:UnifiSession.SkipCertificateCheck
            TimeoutSec    = $script:UnifiSession.TimeoutSec
            HasWebSession = $null -ne $script:UnifiSession.WebSession
        }
    }
    else {
        [ordered]@{
            Connected     = $false
            ControllerUrl = $null
        }
    }

    # Attempt to get controller status if requested
    $ControllerInfo = $null
    if ($IncludeControllerStatus -and $script:UnifiSession) {
        try {
            $Status = Get-UnifiControllerStatus -ErrorAction Stop
            $ControllerInfo = [ordered]@{
                ServerVersion  = $Status.server_version ?? $Status.version ?? 'Unknown'
                ServerName     = $Status.server_name ?? $Status.name ?? 'Unknown'
                IsSetup        = $Status.is_setup ?? $true
                Uptime         = $Status.uptime ?? 'Unknown'
            }
        }
        catch {
            $ControllerInfo = [ordered]@{
                Error = "Failed to retrieve: $($_.Exception.Message)"
            }
        }
    }

    # Build result object
    $Result = [PSCustomObject]@{
        Module      = [PSCustomObject]$ModuleInfo
        PowerShell  = [PSCustomObject]$PSInfo
        Session     = [PSCustomObject]$SessionInfo
        Controller  = if ($ControllerInfo) { [PSCustomObject]$ControllerInfo } else { $null }
        Timestamp   = Get-Date -Format 'o'
    }

    return $Result
}
