# .NET Framework Calculator - CI/CD

This project uses GitHub Actions for continuous integration and deployment.

## Workflows

### Build Workflow (`build.yml`)

Automatically builds the application on:
- **Push** to `main`, `master`, or `develop` branches
- **Pull requests** to `main`, `master`, or `develop` branches
- **Manual trigger** via workflow_dispatch

#### What it does:

1. **Builds Windows Forms Calculator** (`Calculator.csproj`)
   - Desktop application with GUI
   - Outputs to `bin/Release/net48/`

2. **Builds Web Calculator** (`CalculatorWeb.csproj`)
   - Web-based application with OWIN server
   - Copies wwwroot files to output
   - Outputs to `bin/Release/net48/`

3. **Creates Artifacts**
   - `Calculator-WindowsForms`: Desktop application files
   - `Calculator-Web`: Web application files with dependencies
   - `Calculator-Release-Packages`: ZIP files (only on main/master branch)

4. **Runs Tests** (if test projects exist)
   - Automatically discovers and runs test projects

#### Artifacts Retention:
- Build artifacts: 30 days
- Release packages: 90 days

## Manual Workflow Trigger

You can manually trigger the build workflow from the GitHub Actions tab:
1. Go to **Actions** tab in your repository
2. Select **Build .NET Framework Calculator** workflow
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

## Build Status

Add this badge to your README.md to show build status:

```markdown
[![Build Status](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Build%20.NET%20Framework%20Calculator/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions)
```

## Requirements

The workflow uses:
- **windows-latest** runner (Windows Server 2022)
- **.NET Framework 4.8** (pre-installed on Windows runners)
- **MSBuild** for building
- **NuGet** for package restoration

## Local Build

To build locally (matching the CI process):

```powershell
# Restore and build Windows Forms Calculator
dotnet restore Calculator.csproj
dotnet build Calculator.csproj --configuration Release

# Restore and build Web Calculator
dotnet restore CalculatorWeb.csproj
dotnet build CalculatorWeb.csproj --configuration Release

# Copy wwwroot files for Web Calculator
Copy-Item -Path "wwwroot\*" -Destination "bin\Release\net48\wwwroot\" -Recurse -Force
```

## Downloading Build Artifacts

After a successful build:
1. Go to the **Actions** tab
2. Click on the completed workflow run
3. Scroll down to **Artifacts** section
4. Download the desired artifact (ZIP file)

## Release Packages

On commits to `main` or `master` branch, the workflow creates timestamped release packages:
- `Calculator-WindowsForms-vYYYY.MM.DD.HHmm.zip`
- `Calculator-Web-vYYYY.MM.DD.HHmm.zip`

These packages are ready for deployment and distribution.
