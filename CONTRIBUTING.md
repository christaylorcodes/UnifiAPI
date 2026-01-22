# Contributing to UnifiAPI

Please refer to our organization-wide Contributing guidelines:

**[Contributing Guidelines](https://github.com/christaylorcodes/GitHub-Template/blob/main/CONTRIBUTING.md)**

## Project-Specific Notes

### Build Commands

```powershell
# First-time setup (installs dependencies and builds)
.\build.ps1 -ResolveDependency

# Build module
.\build.ps1 -Tasks build

# Run unit tests
.\build.ps1 -Tasks test

# Build + test (default)
.\build.ps1
```

### Documentation

Documentation is built with [platyPS](https://github.com/PowerShell/platyPS).

```powershell
.\build.ps1 -Tasks docs
```
