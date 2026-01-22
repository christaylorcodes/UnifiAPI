# Code to run before functions are loaded

# Enable TLS 1.2 for API calls
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Load System.Web assembly for URI query string handling (not auto-loaded in PS7+)
Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue
