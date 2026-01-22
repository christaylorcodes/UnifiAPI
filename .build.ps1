# Custom build tasks for UnifiAPI module

task Invoke_PSScriptAnalyzer {
    $SourcePath = Join-Path $BuildRoot 'source'
    $SettingsFile = Join-Path $BuildRoot 'PSScriptAnalyzerSettings.psd1'

    if (-not (Test-Path $SourcePath)) {
        Write-Build Yellow "Source path not found: $SourcePath"
        return
    }

    Write-Build Cyan "Running PSScriptAnalyzer on: $SourcePath"

    $AnalyzerParams = @{
        Path        = $SourcePath
        Recurse     = $true
        ErrorAction = 'SilentlyContinue'
    }

    if (Test-Path $SettingsFile) {
        Write-Build Cyan "Using settings file: $SettingsFile"
        $AnalyzerParams['Settings'] = $SettingsFile
    }

    $Results = Invoke-ScriptAnalyzer @AnalyzerParams

    if ($Results) {
        Write-Build Yellow "`nPSScriptAnalyzer found $($Results.Count) issue(s):`n"

        $Results | ForEach-Object {
            $Color = switch ($_.Severity) {
                'Error' { 'Red' }
                'Warning' { 'Yellow' }
                'Information' { 'Cyan' }
                default { 'White' }
            }
            Write-Build $Color "$($_.Severity): $($_.ScriptName):$($_.Line) - $($_.RuleName)"
            Write-Build White "  $($_.Message)"
        }

        $Errors = $Results | Where-Object { $_.Severity -eq 'Error' }
        if ($Errors) {
            throw "PSScriptAnalyzer found $($Errors.Count) error(s). Build failed."
        }

        Write-Build Yellow "`nPSScriptAnalyzer completed with warnings."
    }
    else {
        Write-Build Green "PSScriptAnalyzer: No issues found!"
    }
}

task Generate_Markdown_Help {
    $OutputPath = Join-Path $BuildRoot 'docs'
    $ModulePath = Get-ChildItem -Path "$BuildRoot/output/UnifiAPI/*/UnifiAPI.psd1" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $ModulePath) {
        Write-Build Yellow "Module not built yet. Run 'build' task first."
        return
    }

    if (-not (Test-Path $OutputPath)) {
        New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
    }

    # Import the built module
    Import-Module $ModulePath.FullName -Force

    # Generate or update markdown help
    $ExistingDocs = Get-ChildItem -Path $OutputPath -Filter '*.md' -ErrorAction SilentlyContinue

    if ($ExistingDocs) {
        Write-Build Cyan "Updating existing markdown help files..."
        Update-MarkdownHelp -Path $OutputPath -Force
    }
    else {
        Write-Build Cyan "Generating markdown help files..."
        New-MarkdownHelp -Module UnifiAPI -OutputFolder $OutputPath -Force -NoMetadata
    }

    Write-Build Green "Markdown help files generated in: $OutputPath"
}

task Generate_MAML_Help {
    $DocsPath = Join-Path $BuildRoot 'docs'
    $ModuleOutputPath = Get-ChildItem -Path "$BuildRoot/output/UnifiAPI/*" -Directory |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $ModuleOutputPath) {
        Write-Build Yellow "Module not built yet. Run 'build' task first."
        return
    }

    if (-not (Test-Path $DocsPath)) {
        Write-Build Yellow "No markdown docs found. Run 'Generate_Markdown_Help' first."
        return
    }

    $MamlPath = Join-Path $ModuleOutputPath.FullName 'en-US'
    if (-not (Test-Path $MamlPath)) {
        New-Item -Path $MamlPath -ItemType Directory -Force | Out-Null
    }

    Write-Build Cyan "Generating MAML help from markdown..."
    New-ExternalHelp -Path $DocsPath -OutputPath $MamlPath -Force

    Write-Build Green "MAML help generated in: $MamlPath"
}
