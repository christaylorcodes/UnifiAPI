function Set-UnifiWLANGroup {
    <#
    .SYNOPSIS
        Modifies an existing WLAN group.

    .DESCRIPTION
        Updates properties of an existing WLAN group on the specified UniFi site.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER WLANGroupId
        The _id of the WLAN group to modify (from Get-UnifiWLANGroups).

    .PARAMETER WLANGroup
        A WLAN group object from Get-UnifiWLANGroups. Can be piped.

    .PARAMETER Name
        New name for the WLAN group.

    .PARAMETER DeviceMacs
        Array of AP MAC addresses to include in this group.
        This replaces the existing list.

    .PARAMETER AddDeviceMacs
        Array of AP MAC addresses to add to the existing list.

    .PARAMETER RemoveDeviceMacs
        Array of AP MAC addresses to remove from the existing list.

    .EXAMPLE
        Set-UnifiWLANGroup -SiteName 'default' -WLANGroupId '5f123...' -Name 'New-Group-Name'

    .EXAMPLE
        # Update a group with explicit SiteName (required)
        $group = Get-UnifiWLANGroups -SiteName 'default' | Where-Object name -eq 'Lobby-APs'
        Set-UnifiWLANGroup -SiteName 'default' -WLANGroupId $group._id -AddDeviceMacs '00:11:22:33:44:55'

    .OUTPUTS
        PSCustomObject. The updated WLAN group.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ById')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [Parameter(Mandatory, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [Alias('Site')]
        [string]$SiteName,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id', '_id')]
        [string]$WLANGroupId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$WLANGroup,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string[]]$DeviceMacs,

        [Parameter()]
        [string[]]$AddDeviceMacs,

        [Parameter()]
        [string[]]$RemoveDeviceMacs
    )

    process {
        # Get the group ID from object if provided
        $TargetId = if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $WLANGroup._id
        } else {
            $WLANGroupId
        }

        $Body = @{}

        if ($PSBoundParameters.ContainsKey('Name')) {
            $Body.name = $Name
        }

        # Handle device MAC updates
        if ($PSBoundParameters.ContainsKey('DeviceMacs')) {
            # Replace entire list
            $NormalizedMacs = $DeviceMacs | ForEach-Object {
                Test-UnifiMacAddress -MacAddress $_ -Normalize
            }
            $Body.device_macs = @($NormalizedMacs)
        }
        elseif ($AddDeviceMacs -or $RemoveDeviceMacs) {
            # Need to get current list first
            $CurrentGroup = if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
                $WLANGroup
            } else {
                Invoke-UnifiApi -Endpoint 'rest/wlangroup' -SiteName $SiteName | Where-Object { $_._id -eq $TargetId }
            }

            # Handle null/empty device_macs array
            $CurrentMacs = if ($CurrentGroup.device_macs) {
                @($CurrentGroup.device_macs)
            } else {
                @()
            }

            if ($AddDeviceMacs) {
                $NormalizedAdd = $AddDeviceMacs | ForEach-Object {
                    Test-UnifiMacAddress -MacAddress $_ -Normalize
                }
                $CurrentMacs = @($CurrentMacs) + @($NormalizedAdd) | Select-Object -Unique
            }

            if ($RemoveDeviceMacs) {
                $NormalizedRemove = $RemoveDeviceMacs | ForEach-Object {
                    Test-UnifiMacAddress -MacAddress $_ -Normalize
                }
                $CurrentMacs = $CurrentMacs | Where-Object { $_ -notin $NormalizedRemove }
            }

            $Body.device_macs = @($CurrentMacs)
        }

        if ($Body.Count -eq 0) {
            Write-Warning "No parameters specified to update."
            return
        }

        $Target = $Name ?? $TargetId

        if ($PSCmdlet.ShouldProcess($Target, 'Update WLAN group')) {
            Invoke-UnifiApi -Endpoint "rest/wlangroup/$TargetId" -SiteName $SiteName -Method Put -Body $Body
        }
    }
}
