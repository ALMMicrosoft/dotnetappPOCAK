# PowerShell Deployment Script for Azure App Service
# This script deploys the Calculator app to Azure App Service

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('dev', 'staging', 'production')]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$AppServiceName,
    
    [Parameter(Mandatory=$false)]
    [string]$PackagePath = ".\bin\Release\net48"
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Azure App Service Deployment Script  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration based on environment
$config = @{
    dev = @{
        ResourceGroup = "rg-calculator-dotnet-dev"
        AppService = "calculator-dotnet-dev"
        Slot = $null
    }
    staging = @{
        ResourceGroup = "rg-calculator-dotnet-prod"
        AppService = "calculator-dotnet-prod"
        Slot = "staging"
    }
    production = @{
        ResourceGroup = "rg-calculator-dotnet-prod"
        AppService = "calculator-dotnet-prod"
        Slot = $null
    }
}

# Use provided values or defaults from config
$rgName = if ($ResourceGroupName) { $ResourceGroupName } else { $config[$Environment].ResourceGroup }
$appName = if ($AppServiceName) { $AppServiceName } else { $config[$Environment].AppService }
$slotName = $config[$Environment].Slot

Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Resource Group: $rgName" -ForegroundColor Yellow
Write-Host "App Service: $appName" -ForegroundColor Yellow
if ($slotName) {
    Write-Host "Deployment Slot: $slotName" -ForegroundColor Yellow
}
Write-Host ""

# Check if Azure CLI is installed
Write-Host "Checking Azure CLI installation..." -ForegroundColor Green
try {
    $azVersion = az version --output json | ConvertFrom-Json
    Write-Host "✅ Azure CLI version: $($azVersion.'azure-cli')" -ForegroundColor Green
} catch {
    Write-Error "❌ Azure CLI is not installed. Please install it from: https://aka.ms/installazurecliwindows"
    exit 1
}

# Check if logged in to Azure
Write-Host "Checking Azure login status..." -ForegroundColor Green
try {
    $account = az account show --output json | ConvertFrom-Json
    Write-Host "✅ Logged in as: $($account.user.name)" -ForegroundColor Green
    Write-Host "   Subscription: $($account.name)" -ForegroundColor Green
} catch {
    Write-Error "❌ Not logged in to Azure. Please run 'az login'"
    exit 1
}

# Build the application
Write-Host ""
Write-Host "Building application..." -ForegroundColor Green
try {
    dotnet build CalculatorWeb.csproj --configuration Release
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed"
    }
    Write-Host "✅ Build successful" -ForegroundColor Green
} catch {
    Write-Error "❌ Build failed: $_"
    exit 1
}

# Copy wwwroot files
Write-Host ""
Write-Host "Copying web assets..." -ForegroundColor Green
try {
    Copy-Item -Path "wwwroot\*" -Destination "$PackagePath\wwwroot\" -Recurse -Force
    Write-Host "✅ Web assets copied" -ForegroundColor Green
} catch {
    Write-Error "❌ Failed to copy web assets: $_"
    exit 1
}

# Create deployment package
Write-Host ""
Write-Host "Creating deployment package..." -ForegroundColor Green
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$zipFile = "calculator-web-$Environment-$timestamp.zip"

try {
    if (Test-Path $zipFile) {
        Remove-Item $zipFile -Force
    }
    Compress-Archive -Path "$PackagePath\*" -DestinationPath $zipFile -Force
    Write-Host "✅ Package created: $zipFile" -ForegroundColor Green
} catch {
    Write-Error "❌ Failed to create package: $_"
    exit 1
}

# Deploy to Azure
Write-Host ""
Write-Host "Deploying to Azure App Service..." -ForegroundColor Green

try {
    if ($slotName) {
        # Deploy to slot
        Write-Host "Deploying to slot: $slotName" -ForegroundColor Cyan
        az webapp deployment source config-zip `
            --resource-group $rgName `
            --name $appName `
            --slot $slotName `
            --src $zipFile `
            --timeout 600
    } else {
        # Deploy to production directly
        Write-Host "Deploying to production" -ForegroundColor Cyan
        az webapp deployment source config-zip `
            --resource-group $rgName `
            --name $appName `
            --src $zipFile `
            --timeout 600
    }
    
    if ($LASTEXITCODE -ne 0) {
        throw "Deployment failed"
    }
    Write-Host "✅ Deployment successful" -ForegroundColor Green
} catch {
    Write-Error "❌ Deployment failed: $_"
    exit 1
}

# Health check
Write-Host ""
Write-Host "Running health check..." -ForegroundColor Green
Start-Sleep -Seconds 10

try {
    if ($slotName) {
        $url = "https://$appName-$slotName.azurewebsites.net"
    } else {
        $url = "https://$appName.azurewebsites.net"
    }
    
    Write-Host "Testing: $url" -ForegroundColor Cyan
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
    
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Health check passed (Status: $($response.StatusCode))" -ForegroundColor Green
    } else {
        Write-Warning "⚠️ Unexpected status code: $($response.StatusCode)"
    }
} catch {
    Write-Warning "⚠️ Health check failed: $_"
    Write-Host "Please check the application logs in Azure Portal"
}

# Slot swap for production (if deploying to staging)
if ($Environment -eq 'staging') {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Ready to swap to production?" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $swap = Read-Host "Swap staging to production? (yes/no)"
    
    if ($swap -eq 'yes') {
        Write-Host "Swapping staging slot to production..." -ForegroundColor Green
        
        try {
            az webapp deployment slot swap `
                --resource-group $rgName `
                --name $appName `
                --slot staging `
                --target-slot production
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Slot swap successful" -ForegroundColor Green
                
                # Post-swap health check
                Write-Host "Running post-swap health check..." -ForegroundColor Green
                Start-Sleep -Seconds 15
                
                $prodUrl = "https://$appName.azurewebsites.net"
                $response = Invoke-WebRequest -Uri $prodUrl -UseBasicParsing -TimeoutSec 30
                
                if ($response.StatusCode -eq 200) {
                    Write-Host "✅ Production is healthy (Status: $($response.StatusCode))" -ForegroundColor Green
                } else {
                    Write-Warning "⚠️ Production health check returned: $($response.StatusCode)"
                }
            }
        } catch {
            Write-Error "❌ Slot swap failed: $_"
            Write-Host "You may need to manually rollback if needed"
        }
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Complete                   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Green
Write-Host "App Service: $appName" -ForegroundColor Green
Write-Host "URL: https://$appName.azurewebsites.net" -ForegroundColor Green
Write-Host ""
Write-Host "To view logs: az webapp log tail --resource-group $rgName --name $appName" -ForegroundColor Yellow
Write-Host "To restart: az webapp restart --resource-group $rgName --name $appName" -ForegroundColor Yellow
Write-Host ""
