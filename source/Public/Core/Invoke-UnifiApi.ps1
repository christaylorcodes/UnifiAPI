function Invoke-UnifiApi {
    <#
    .SYNOPSIS
        Invokes a UniFi Controller API endpoint.

    .DESCRIPTION
        Generic function to call any UniFi API endpoint. Used internally by all
        module functions, but also available for direct use on custom/undocumented endpoints.

        Handles session validation, URI construction, error handling, pagination, and JSON conversion.

    .PARAMETER Endpoint
        The API endpoint path (e.g., 'stat/device', 'rest/wlanconf', 'self/sites').
        Do not include the /api/s/{site}/ prefix - this is added automatically.

    .PARAMETER SiteName
        The site name to use in the API path. Required for site-specific endpoints.
        Not required for global endpoints like 'self/sites'.
        Accepts pipeline input by property name.

    .PARAMETER Method
        HTTP method to use. Default is 'Get'.

    .PARAMETER Body
        Request body as a hashtable. Will be automatically converted to JSON.

    .PARAMETER QueryParams
        Query parameters as a hashtable. Will be appended to the URL.

    .PARAMETER ApiV2
        Use the v2 API path (/v2/api/site/{site}/) instead of v1 (/api/s/{site}/).

    .PARAMETER Raw
        Return the full API response instead of just the .data property.

    .PARAMETER Paginate
        Automatically handle pagination for endpoints that support it.
        Fetches all pages and returns combined results.

    .PARAMETER PageSize
        Number of items per page when using -Paginate. Default is 100.

    .EXAMPLE
        # Get all sites (no site parameter needed)
        Invoke-UnifiApi -Endpoint 'self/sites'

    .EXAMPLE
        # Get devices for a specific site
        Invoke-UnifiApi -Endpoint 'stat/device' -SiteName 'default'

    .EXAMPLE
        # Get rogue APs with query parameters
        Invoke-UnifiApi -Endpoint 'stat/rogueap' -SiteName 'default' -QueryParams @{ within = 12 }

    .EXAMPLE
        # POST request with body
        Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName 'default' -Method Post -Body @{ cmd = 'restart'; mac = '00:11:22:33:44:55' }

    .EXAMPLE
        # Get all clients with automatic pagination
        Invoke-UnifiApi -Endpoint 'stat/alluser' -SiteName 'default' -Paginate

    .EXAMPLE
        # Pipeline from Get-UnifiSites
        Get-UnifiSites | Invoke-UnifiApi -Endpoint 'stat/device'

    .OUTPUTS
        PSCustomObject. API response data, or full response if -Raw specified.

    .NOTES
        Requires an active UniFi session. Use Connect-Unifi first.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('name', 'Site')]
        [string]$SiteName,

        [Parameter()]
        [ValidateSet('Get', 'Post', 'Put', 'Delete', 'Patch')]
        [string]$Method = 'Get',

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [hashtable]$QueryParams,

        [Parameter()]
        [switch]$ApiV2,

        [Parameter()]
        [switch]$Raw,

        [Parameter()]
        [switch]$Paginate,

        [Parameter()]
        [ValidateRange(10, 1000)]
        [int]$PageSize = 100
    )

    begin {
        if (-not $script:UnifiSession) {
            throw "No UniFi session found. Please run 'Connect-Unifi' first."
        }
    }

    process {
        try {
            # Build the URI
            $BaseUri = $script:UnifiSession.BaseURI
            $Uri = if ($ApiV2) {
                # v2 API: /v2/api/site/{site}/ or /v2/api/
                $SiteName ? "$BaseUri/v2/api/site/$SiteName/$Endpoint" : "$BaseUri/v2/api/$Endpoint"
            } else {
                # v1 API: /api/s/{site}/ for site-scoped, /api/ for global
                $SiteName ? "$BaseUri/api/s/$SiteName/$Endpoint" : "$BaseUri/api/$Endpoint"
            }

            # Initialize query parameters
            $CurrentQueryParams = $QueryParams ? [hashtable]$QueryParams.Clone() : @{}

            # Handle pagination
            if ($Paginate -and $Method -eq 'Get') {
                $AllResults = @()
                $Offset = 0

                do {
                    $CurrentQueryParams['_start'] = $Offset
                    $CurrentQueryParams['_limit'] = $PageSize

                    $PageUri = Build-UnifiQueryUri -BaseUri $Uri -QueryParams $CurrentQueryParams
                    $Response = Invoke-UnifiRequest -Uri $PageUri -Method $Method -Body $Body

                    $PageData = $Response.data
                    if ($PageData) {
                        $AllResults += $PageData
                    }

                    $Offset += $PageSize
                    $HasMore = $PageData -and ($PageData.Count -eq $PageSize)

                    Write-Verbose "Fetched $($AllResults.Count) items (page offset: $($Offset - $PageSize))"
                } while ($HasMore)

                return $AllResults
            }
            else {
                # Single request (no pagination)
                $FinalUri = Build-UnifiQueryUri -BaseUri $Uri -QueryParams $CurrentQueryParams
                $Response = Invoke-UnifiRequest -Uri $FinalUri -Method $Method -Body $Body

                return $Raw ? $Response : $Response.data
            }
        }
        catch {
            Invoke-UnifiApiError -ErrorRecord $_ -Operation "API call to $Endpoint"
        }
    }
}
