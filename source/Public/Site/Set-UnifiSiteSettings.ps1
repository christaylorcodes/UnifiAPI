function Set-UnifiSiteSettings {
    <#
    .SYNOPSIS
        Updates site settings for a specific site.

    .DESCRIPTION
        Modifies site-level settings including country, timezone, management,
        guest access, and connectivity options.

    .PARAMETER SiteName
        The internal site name (not description).

    .PARAMETER SettingKey
        The setting category to update. Valid values:
        - 'country': Country/region code
        - 'locale': Timezone and language
        - 'mgmt': Management settings (LED, alerts)
        - 'guest_access': Guest portal configuration
        - 'ntp': NTP server settings
        - 'connectivity': Uplink monitoring
        - 'snmp': SNMP configuration

    .PARAMETER SettingId
        The _id of the setting to update (from Get-UnifiSiteSettings).

    .PARAMETER Settings
        Hashtable of settings to apply. Properties vary by SettingKey.

    .PARAMETER CountryCode
        Country code (e.g., 'US', 'GB', 'DE'). Use with -SettingKey 'country'.

    .PARAMETER Timezone
        Timezone string (e.g., 'America/New_York'). Use with -SettingKey 'locale'.

    .PARAMETER LEDEnabled
        Enable/disable device LEDs. Use with -SettingKey 'mgmt'.

    .PARAMETER AlertEnabled
        Enable/disable alerts. Use with -SettingKey 'mgmt'.

    .EXAMPLE
        Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'country' -SettingId '5f123...' -CountryCode 'US'

    .EXAMPLE
        Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'locale' -SettingId '5f123...' -Timezone 'America/Chicago'

    .EXAMPLE
        Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'mgmt' -SettingId '5f123...' -LEDEnabled $true

    .EXAMPLE
        # Advanced: Pass custom settings hashtable
        $settings = @{ ntp_server_1 = 'pool.ntp.org' }
        Set-UnifiSiteSettings -SiteName 'default' -SettingKey 'ntp' -SettingId '5f123...' -Settings $settings

    .OUTPUTS
        PSCustomObject. The updated setting object.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
        Use Get-UnifiSiteSettings to retrieve current settings and their _id values.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Site', 'name')]
        [string]$SiteName,

        [Parameter(Mandatory)]
        [ValidateSet('country', 'locale', 'mgmt', 'guest_access', 'ntp', 'connectivity', 'snmp')]
        [string]$SettingKey,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id', '_id')]
        [string]$SettingId,

        [Parameter()]
        [hashtable]$Settings,

        # Country settings
        [Parameter()]
        [ValidateLength(2, 3)]
        [string]$CountryCode,

        # Locale settings
        [Parameter()]
        [string]$Timezone,

        # Management settings
        [Parameter()]
        [bool]$LEDEnabled,

        [Parameter()]
        [bool]$AlertEnabled
    )

    # Build settings body based on parameters
    $Body = if ($Settings) {
        $Settings.Clone()
    }
    else {
        @{}
    }

    # Apply typed parameters
    switch ($SettingKey) {
        'country' {
            if ($CountryCode) {
                $Body.code = $CountryCode
            }
        }
        'locale' {
            if ($Timezone) {
                $Body.timezone = $Timezone
            }
        }
        'mgmt' {
            if ($PSBoundParameters.ContainsKey('LEDEnabled')) {
                $Body.led_enabled = $LEDEnabled
            }
            if ($PSBoundParameters.ContainsKey('AlertEnabled')) {
                $Body.alert_enabled = $AlertEnabled
            }
        }
    }

    if ($Body.Count -eq 0) {
        Write-Warning "No settings specified to update."
        return
    }

    if ($PSCmdlet.ShouldProcess("$SettingKey settings", 'Update site settings')) {
        Invoke-UnifiApi -Endpoint "rest/setting/$SettingKey/$SettingId" -SiteName $SiteName -Method Put -Body $Body
    }
}
