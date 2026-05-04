# GitHub Actions CI/CD Setup Guide

This guide explains how to set up and use GitHub Actions for the .NET Framework Calculator project.

## 📋 Overview

The project includes a complete CI/CD pipeline that automatically:
- ✅ Builds both Windows Forms and Web versions
- ✅ Creates downloadable artifacts
- ✅ Generates release packages
- ✅ Runs on every push and pull request

## 🚀 Quick Start

### 1. Push to GitHub

```bash
# Initialize git repository (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit with GitHub Actions workflow"

# Add remote (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

### 2. Enable GitHub Actions

GitHub Actions is enabled by default. Once you push your code, the workflow will automatically run.

### 3. View Build Status

1. Go to your repository on GitHub
2. Click the **Actions** tab
3. You'll see the "Build .NET Framework Calculator" workflow running

## 📊 Workflow Triggers

The workflow runs automatically on:

- **Push** to `main`, `master`, or `develop` branches
- **Pull requests** targeting `main`, `master`, or `develop`
- **Manual trigger** from the Actions tab

### Manual Trigger

To manually run the workflow:
1. Go to **Actions** tab
2. Select "Build .NET Framework Calculator"
3. Click **Run workflow**
4. Choose branch and click **Run workflow**

## 📦 Build Artifacts

After each successful build, the following artifacts are available:

### 1. Calculator-WindowsForms
Contains the desktop application:
- `Calculator.exe`
- `Calculator.exe.config`
- Required DLL files

**Retention:** 30 days

### 2. Calculator-Web
Contains the web application:
- `CalculatorWeb.exe`
- `CalculatorWeb.exe.config`
- `wwwroot/` folder with HTML, CSS, JS
- All required dependencies (Owin, Newtonsoft.Json, etc.)

**Retention:** 30 days

### 3. Calculator-Release-Packages (Main/Master only)
Timestamped ZIP files ready for distribution:
- `Calculator-WindowsForms-vYYYY.MM.DD.HHmm.zip`
- `Calculator-Web-vYYYY.MM.DD.HHmm.zip`

**Retention:** 90 days

## 📥 Downloading Artifacts

1. Go to **Actions** tab
2. Click on a completed workflow run
3. Scroll to **Artifacts** section
4. Click on the artifact name to download

## 🔧 Workflow Configuration

The workflow is defined in `.github/workflows/build.yml`

### Key Steps

1. **Checkout code** - Gets the latest code from repository
2. **Setup build tools** - Configures MSBuild and NuGet
3. **Restore packages** - Downloads NuGet dependencies
4. **Build projects** - Compiles both applications
5. **Copy wwwroot** - Ensures web files are in output
6. **Create artifacts** - Packages build outputs
7. **Create releases** - Generates ZIP files (main/master only)

### Build Configuration

- **Runner:** `windows-latest` (Windows Server 2022)
- **Target Framework:** .NET Framework 4.8
- **Build Configuration:** Release
- **Build Tool:** dotnet CLI / MSBuild

## 🎯 Build Status Badge

Add this to your README.md to show build status:

```markdown
[![Build Status](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Build%20.NET%20Framework%20Calculator/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions)
```

Replace `YOUR_USERNAME` and `YOUR_REPO` with your actual values.

## 🐛 Troubleshooting

### Build Fails with "Cannot find project"

**Solution:** Ensure `.csproj` files are in the repository root

### wwwroot files not copied

**Solution:** The workflow includes a step to copy wwwroot files. Check the build log.

### Artifacts not appearing

**Solution:** 
- Check if the build completed successfully
- Artifacts are only created on successful builds
- Check artifact retention period (30 days)

### NuGet restore fails

**Solution:**
- Check internet connectivity on runner
- Verify package sources in NuGet.config (if exists)
- Check if packages exist on nuget.org

## 📝 Customization

### Change Branch Triggers

Edit `.github/workflows/build.yml`:

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Add your branches
  pull_request:
    branches: [ main, develop ]
```

### Add Test Projects

The workflow automatically discovers and runs test projects:

```yaml
- name: Run tests
  run: dotnet test --configuration Release --no-build
```

### Change Retention Period

Modify the `retention-days` in artifact upload steps:

```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v4
  with:
    retention-days: 60  # Change from 30 to 60
```

## 🔐 Secrets and Environment Variables

If you need to add secrets (API keys, etc.):

1. Go to repository **Settings**
2. Click **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add your secret name and value

Use in workflow:

```yaml
- name: Deploy
  run: echo "Deploying with key ${{ secrets.API_KEY }}"
```

## 📈 Best Practices

1. **Always test locally** before pushing
2. **Use meaningful commit messages**
3. **Review build logs** for warnings
4. **Keep dependencies updated**
5. **Monitor artifact storage** usage

## 🆘 Support

If you encounter issues:

1. Check the **Actions** tab for detailed logs
2. Review this documentation
3. Check `.github/workflows/README.md`
4. Create an issue in the repository

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [.NET Framework Setup](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Artifact Upload/Download](https://github.com/actions/upload-artifact)

---

**Last Updated:** May 4, 2026
