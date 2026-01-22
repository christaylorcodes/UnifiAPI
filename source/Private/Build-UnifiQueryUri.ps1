function Build-UnifiQueryUri {
    <#
    .SYNOPSIS
        Builds a URI with query parameters.

    .DESCRIPTION
        Internal helper function to construct URIs with properly encoded query parameters.

    .PARAMETER BaseUri
        The base URI without query string.

    .PARAMETER QueryParams
        Hashtable of query parameters to append.

    .NOTES
        This is a private function and should not be called directly.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$BaseUri,

        [Parameter()]
        [hashtable]$QueryParams
    )

    if ($QueryParams?.Count -gt 0) {
        $UriBuilder = [System.UriBuilder]$BaseUri
        $QueryCollection = [System.Web.HttpUtility]::ParseQueryString($UriBuilder.Query)
        foreach ($Param in $QueryParams.GetEnumerator()) {
            $QueryCollection[$Param.Key] = $Param.Value
        }
        $UriBuilder.Query = $QueryCollection.ToString()
        return $UriBuilder.Uri.AbsoluteUri
    }
    return $BaseUri
}
