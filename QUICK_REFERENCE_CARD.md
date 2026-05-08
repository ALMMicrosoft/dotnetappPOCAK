# 🚀 Quick Reference Card - Azure IaC Deployment

**One-page reference for deploying the Calculator app to Azure**

---

## 📋 Prerequisites Checklist

```powershell
# Check Azure CLI
az --version  # Should be >= 2.50.0

# Check Terraform
terraform --version  # Should be >= 1.5.0

# Check .NET
dotnet --version  # .NET Framework 4.8

# Login to Azure
az login
az account show
```

---

## 🏗️ Quick Deploy - Development

```powershell
# 1. Navigate to dev environment
cd d:\CopliotPOCdotnetapp\terraform-appservice-environment\dev

# 2. Initialize Terraform
terraform init

# 3. Create terraform.tfvars
@"
db_connection_string = "Server=localhost;Database=Calculator;Integrated Security=true;"
api_key = "dev-api-key-$(Get-Random)"
security_contact_email = "your-email@example.com"
"@ | Out-File terraform.tfvars

# 4. Plan and apply
terraform plan -out=tfplan
terraform apply tfplan

# 5. Deploy application
cd ..\..\ci-cd-runbooks\scripts
.\deploy-to-azure.ps1 -Environment dev
```

---

## 📁 Folder Navigation

| Path | Purpose |
|------|---------|
| `terraform-azure-modules/app-service/` | App Service module |
| `terraform-azure-modules/networking/` | VNet, NSG, Private Endpoints |
| `terraform-azure-modules/security/` | Key Vault, Security Center |
| `terraform-appservice-environment/dev/` | Dev environment config |
| `terraform-appservice-environment/production/` | Prod environment config |
| `ci-cd-runbooks/github-actions/` | GitHub Actions workflows |
| `ci-cd-runbooks/scripts/` | PowerShell deployment scripts |
| `security-policies/azure-policy/` | Azure Policy definitions |

---

## 🔑 Required Secrets (GitHub Actions)

```yaml
AZURE_CREDENTIALS:
  {
    "clientId": "<service-principal-id>",
    "clientSecret": "<service-principal-secret>",
    "subscriptionId": "<subscription-id>",
    "tenantId": "<tenant-id>"
  }

AZURE_WEBAPP_NAME_DEV: "calculator-dotnet-dev"
AZURE_WEBAPP_NAME_PROD: "calculator-dotnet-prod"
AZURE_RESOURCE_GROUP: "rg-calculator-dotnet-prod"
DB_CONNECTION_STRING: "Server=...;Database=...;..."
API_KEY: "your-api-key-here"
SECURITY_EMAIL: "security@example.com"
```

---

## 🔧 Common Commands

### Terraform

```powershell
# Initialize
terraform init

# Plan
terraform plan -out=tfplan

# Apply
terraform apply tfplan

# Destroy
terraform destroy

# Show outputs
terraform output

# Format code
terraform fmt -recursive

# Validate
terraform validate
```

### Azure CLI

```powershell
# List App Services
az webapp list --resource-group rg-calculator-dotnet-dev --output table

# View App Service
az webapp show --name calculator-dotnet-dev --resource-group rg-calculator-dotnet-dev

# Stream logs
az webapp log tail --name calculator-dotnet-dev --resource-group rg-calculator-dotnet-dev

# Restart App Service
az webapp restart --name calculator-dotnet-dev --resource-group rg-calculator-dotnet-dev

# Slot swap
az webapp deployment slot swap `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod `
  --slot staging `
  --target-slot production

# List secrets in Key Vault
az keyvault secret list --vault-name kv-calculatordotnetdev

# Get secret value
az keyvault secret show --vault-name kv-calculatordotnetdev --name api-key
```

### Deployment

```powershell
# Deploy to dev
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment dev

# Deploy to staging
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment staging

# Deploy to production
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment production
```

---

## 🔍 Troubleshooting

### Issue: Terraform init fails

```powershell
# Clear backend
Remove-Item -Recurse -Force .terraform

# Re-initialize
terraform init -reconfigure
```

### Issue: Deployment fails

```powershell
# Check App Service logs
az webapp log tail --name <app-name> --resource-group <rg-name>

# Download logs
az webapp log download --name <app-name> --resource-group <rg-name> --log-file logs.zip
```

### Issue: Key Vault access denied

```powershell
# Assign access policy
az keyvault set-policy `
  --name <vault-name> `
  --object-id <managed-identity-id> `
  --secret-permissions get list
```

### Issue: App not responding

```powershell
# Restart App Service
az webapp restart --name <app-name> --resource-group <rg-name>

# Check health
Invoke-WebRequest -Uri https://<app-name>.azurewebsites.net -UseBasicParsing
```

---

## 📊 Environment Comparison

| Feature | Dev | Staging | Production |
|---------|-----|---------|------------|
| **SKU** | B1 | S1 | P1v3 |
| **Always On** | No | Yes | Yes |
| **Staging Slot** | No | No | Yes |
| **Private Endpoint** | No | Optional | Yes |
| **Autoscale** | No | No | Yes (2-10) |
| **Cost/Month** | ~$22 | ~$97 | ~$321 |

---

## 🔒 Security Quick Checks

```powershell
# Verify HTTPS only
az webapp config show --name <app-name> --resource-group <rg-name> --query httpsOnly

# Check managed identity
az webapp identity show --name <app-name> --resource-group <rg-name>

# List NSG rules
az network nsg rule list --nsg-name <nsg-name> --resource-group <rg-name> --output table

# View Key Vault network rules
az keyvault network-rule list --name <vault-name>
```

---

## 📈 Monitoring

```powershell
# View Application Insights
az monitor app-insights component show --app <app-name> --resource-group <rg-name>

# Query logs
az monitor app-insights query `
  --app <app-name> `
  --analytics-query "requests | where timestamp > ago(1h) | summarize count() by resultCode"

# View metrics
az monitor metrics list `
  --resource <app-service-id> `
  --metric-names "CpuPercentage,MemoryPercentage"
```

---

## 🚨 Emergency Rollback

```powershell
# Swap slots back (if in production)
az webapp deployment slot swap `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod `
  --slot production `
  --target-slot staging

# Or redeploy previous version
$previousPackage = "calculator-web-production-<previous-timestamp>.zip"
az webapp deployment source config-zip `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod `
  --src $previousPackage
```

---

## 📚 Documentation Links

| Document | Purpose |
|----------|---------|
| [README-IaC.md](README-IaC.md) | Complete IaC documentation |
| [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) | Folder structure visualization |
| [SETUP_COMPLETE.md](SETUP_COMPLETE.md) | Setup completion summary |
| [sample-dotnet-app/DEPLOYMENT_GUIDE.md](sample-dotnet-app/DEPLOYMENT_GUIDE.md) | App deployment guide |
| [security-policies/network-security/network-security-rules.md](security-policies/network-security/network-security-rules.md) | Network security rules |

---

## 🆘 Support

- **Azure Portal**: https://portal.azure.com
- **Azure CLI Docs**: https://docs.microsoft.com/en-us/cli/azure/
- **Terraform Docs**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **App Service Docs**: https://docs.microsoft.com/en-us/azure/app-service/

---

## ✅ Quick Health Check

```powershell
# One-liner health check
$url = "https://calculator-dotnet-dev.azurewebsites.net"
(Invoke-WebRequest -Uri $url -UseBasicParsing).StatusCode -eq 200 ? "✅ Healthy" : "❌ Unhealthy"
```

---

**Version**: 1.0  
**Last Updated**: May 8, 2026  
**Keep this card handy for quick reference!**
