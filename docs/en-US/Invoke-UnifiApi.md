---
external help file: UnifiAPI-help.xml
GeneratedBy: Sampler update_help_source task
Module Name: UnifiAPI
online version:
schema: 2.0.0
---

# Invoke-UnifiApi

## SYNOPSIS
Invokes a UniFi Controller API endpoint.

## SYNTAX

```
Invoke-UnifiApi [-Endpoint] <String> [[-SiteName] <String>] [[-Method] <String>] [[-Body] <Hashtable>]
 [[-QueryParams] <Hashtable>] [-ApiV2] [-Raw] [-Paginate] [[-PageSize] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Generic function to call any UniFi API endpoint.
Used internally by all
module functions, but also available for direct use on custom/undocumented endpoints.

Handles session validation, URI construction, error handling, and JSON conversion.

## EXAMPLES

### EXAMPLE 1
```
# Get all sites (no site parameter needed)
Invoke-UnifiApi -Endpoint 'self/sites'
```

### EXAMPLE 2
```
# Get devices for a specific site
Invoke-UnifiApi -Endpoint 'stat/device' -SiteName 'default'
```

### EXAMPLE 3
```
# Get rogue APs with query parameters
Invoke-UnifiApi -Endpoint 'stat/rogueap' -SiteName 'default' -QueryParams @{ within = 12; _limit = 1000 }
```

### EXAMPLE 4
```
# POST request with body
Invoke-UnifiApi -Endpoint 'cmd/devmgr' -SiteName 'default' -Method Post -Body @{ cmd = 'restart'; mac = '00:11:22:33:44:55' }
```

### EXAMPLE 5
```
# Custom endpoint not covered by module functions
Invoke-UnifiApi -Endpoint 'rest/networkconf' -SiteName 'default'
```

### EXAMPLE 6
```
# v2 API endpoint
Invoke-UnifiApi -Endpoint 'next-ai/logs' -SiteName 'default' -ApiV2
```

## PARAMETERS

### -Endpoint
The API endpoint path (e.g., 'stat/device', 'rest/wlanconf', 'self/sites').
Do not include the /api/s/{site}/ prefix - this is added automatically.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteName
The site name to use in the API path.
Required for site-specific endpoints.
Not required for global endpoints like 'self/sites'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name, Site

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Method
HTTP method to use.
Default is 'Get'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Request body as a hashtable.
Will be automatically converted to JSON.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryParams
Query parameters as a hashtable.
Will be appended to the URL.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiV2
Use the v2 API path (/v2/api/site/{site}/) instead of v1 (/api/s/{site}/).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return the full API response instead of just the .data property.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Paginate
Automatically handle pagination for endpoints that support it.
Fetches all pages and returns combined results.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of items per page when using -Paginate. Default is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
Controls how the cmdlet responds to progress updates from background jobs or remote commands. Has no effect on cmdlet output.

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Requires an active UniFi session.
Use Connect-Unifi first.

## RELATED LINKS
