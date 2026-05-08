# 🏗️ Azure Infrastructure as Code - Calculator App Deployment

**Complete IaC solution for deploying .NET Framework Calculator to Azure App Service**

---

## 📁 Repository Structure

```
📦 CopliotPOCdotnetapp/
├── 📂 terraform-azure-modules/          # Reusable Terraform modules
│   ├── 📂 app-service/                  # App Service module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── 📂 networking/                   # VNet, NSG, Private Endpoints
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── 📂 security/                     # Key Vault, Security Center
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── 📂 monitoring/                   # Application Insights, Log Analytics
│   └── 📂 storage/                      # Storage Account configuration
│
├── 📂 terraform-appservice-environment/ # Environment-specific configs
│   ├── 📂 dev/                          # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   ├── 📂 staging/                      # Staging environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── 📂 production/                   # Production environment
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
│
├── 📂 ci-cd-runbooks/                   # CI/CD pipelines and scripts
│   ├── 📂 github-actions/               # GitHub Actions workflows
│   │   └── deploy-azure-appservice.yml
│   ├── 📂 azure-pipelines/              # Azure DevOps pipelines
│   │   └── azure-pipeline.yml
│   └── 📂 scripts/                      # Deployment scripts
│       ├── deploy-to-azure.ps1
│       ├── rollback.ps1
│       └── health-check.ps1
│
├── 📂 security-policies/                # Security policies and configurations
│   ├── 📂 azure-policy/                 # Azure Policy definitions
│   │   ├── app-service-managed-identity.json
│   │   ├── app-service-https-only.json
│   │   └── keyvault-secrets-expiration.json
│   ├── 📂 network-security/             # Network security rules
│   │   ├── network-security-rules.md
│   │   └── nsg-rules.json
│   └── 📂 compliance/                   # Compliance documentation
│       ├── COMPLIANCE.md
│       └── security-checklist.md
│
└── 📂 sample-dotnet-app/                # The Calculator application
    ├── Calculator.csproj
    ├── CalculatorWeb.csproj
    ├── Program.cs
    ├── Startup.cs
    ├── wwwroot/
    └── [All application files]
```

---

## 🚀 Quick Start

### Prerequisites

- ✅ **Azure CLI** (>= 2.50.0): `winget install Microsoft.AzureCLI`
- ✅ **Terraform** (>= 1.5.0): `winget install Hashicorp.Terraform`
- ✅ **.NET Framework 4.8**: Pre-installed on Windows 10/11
- ✅ **PowerShell** (>= 7.0): `winget install Microsoft.PowerShell`
- ✅ **Azure Subscription**: With contributor access

### 1. Clone Repository

```powershell
cd d:\CopliotPOCdotnetapp
```

### 2. Login to Azure

```powershell
az login
az account set --subscription "<your-subscription-id>"
```

### 3. Initialize Terraform (Development)

```powershell
cd terraform-appservice-environment\dev
terraform init
```

### 4. Create terraform.tfvars

```powershell
# Copy example and edit
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 5. Plan and Apply

```powershell
terraform plan -out=tfplan
terraform apply tfplan
```

### 6. Deploy Application

```powershell
cd ..\..\ci-cd-runbooks\scripts
.\deploy-to-azure.ps1 -Environment dev
```

---

## 📖 Detailed Documentation

### Terraform Modules

#### App Service Module
Deploys Azure App Service with:
- Windows-based App Service Plan
- .NET Framework 4.8 runtime
- Managed Identity
- Application Insights
- Staging slots (optional)
- Custom domain support

**Usage:**
```hcl
module "app_service" {
  source = "../../terraform-azure-modules/app-service"
  
  app_service_name = "calculator-dotnet-dev"
  location         = "East US"
  sku_name         = "B1"
  // ... other variables
}
```

#### Networking Module
Creates secure network infrastructure:
- Virtual Network with subnets
- Network Security Groups
- Private Endpoints
- Private DNS Zones

#### Security Module
Manages security resources:
- Azure Key Vault
- Managed secrets
- Access policies
- Log Analytics Workspace
- Security Center integration

---

## 🔄 CI/CD Pipelines

### GitHub Actions

**Location**: `ci-cd-runbooks/github-actions/deploy-azure-appservice.yml`

**Features**:
- Multi-environment deployment (dev, staging, production)
- Automated builds
- Security scanning
- Blue-green deployment with slot swap
- Automated rollback on failure

**Required Secrets**:
```yaml
AZURE_CREDENTIALS           # Azure service principal credentials
AZURE_WEBAPP_NAME_DEV       # Dev App Service name
AZURE_WEBAPP_NAME_PROD      # Prod App Service name
AZURE_RESOURCE_GROUP        # Resource group name
DB_CONNECTION_STRING        # Database connection string
API_KEY                     # API key for application
SECURITY_EMAIL              # Email for security alerts
```

**Workflow Stages**:
1. **Build** - Compiles .NET application
2. **Security Scan** - Runs SAST/DAST tools
3. **Terraform Plan** - Validates infrastructure
4. **Deploy Dev** - Deploys to development (on `develop` branch)
5. **Deploy Staging** - Deploys to staging slot (on `main` branch)
6. **Deploy Production** - Blue-green swap to production

### Azure DevOps Pipeline

**Location**: `ci-cd-runbooks/azure-pipelines/azure-pipeline.yml`

**Stages**:
- Build Application
- Security Scanning
- Deploy to Dev
- Deploy to Staging
- Deploy to Production (with approvals)

---

## 🔒 Security Policies

### Azure Policy Definitions

1. **App Service Managed Identity** (`azure-policy/app-service-managed-identity.json`)
   - Ensures all App Services use managed identity
   - Effect: Deny

2. **HTTPS Only** (`azure-policy/app-service-https-only.json`)
   - Enforces HTTPS-only connections
   - Effect: Deny

3. **Key Vault Secret Expiration** (`azure-policy/keyvault-secrets-expiration.json`)
   - Requires expiration dates on secrets
   - Effect: Audit

### Apply Policies

```powershell
# Create policy definition
az policy definition create `
  --name "app-service-managed-identity" `
  --rules azure-policy\app-service-managed-identity.json `
  --mode All

# Assign policy to subscription
az policy assignment create `
  --name "enforce-managed-identity" `
  --policy "app-service-managed-identity" `
  --scope "/subscriptions/<subscription-id>"
```

---

## 🌍 Environment Configurations

### Development
- **Purpose**: Testing and development
- **SKU**: B1 (Basic)
- **Always On**: Disabled
- **Staging Slot**: No
- **Private Endpoint**: No
- **Autoscale**: No

### Staging
- **Purpose**: Pre-production validation
- **SKU**: S1 (Standard)
- **Always On**: Enabled
- **Staging Slot**: Yes
- **Private Endpoint**: Optional
- **Autoscale**: No

### Production
- **Purpose**: Live application
- **SKU**: P1v3 (Premium)
- **Always On**: Enabled
- **Staging Slot**: Yes (for blue-green deployment)
- **Private Endpoint**: Yes
- **Autoscale**: Yes (2-10 instances)
- **DDoS Protection**: Standard
- **WAF**: Recommended (via Front Door)

---

## 📊 Cost Estimation

### Monthly Costs (USD, approximate)

| Resource | Dev | Staging | Production |
|----------|-----|---------|------------|
| App Service Plan | $13 | $75 | $214 |
| Key Vault | $0.25 | $0.25 | $0.25 |
| Storage Account | $2 | $5 | $20 |
| Application Insights | $5 | $10 | $50 |
| Log Analytics | $2 | $5 | $20 |
| VNet | Free | $2 | $10 |
| Private Endpoint | - | - | $7 |
| **Total** | **~$22** | **~$97** | **~$321** |

*Prices are estimates and may vary by region*

---

## 🛠️ Operations

### Deploy to Specific Environment

```powershell
# Development
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment dev

# Staging
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment staging

# Production (with approval)
.\ci-cd-runbooks\scripts\deploy-to-azure.ps1 -Environment production
```

### Rollback Deployment

```powershell
# Swap slots back
az webapp deployment slot swap `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod `
  --slot production `
  --target-slot staging
```

### View Logs

```powershell
# Stream logs
az webapp log tail `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod

# Download logs
az webapp log download `
  --resource-group rg-calculator-dotnet-prod `
  --name calculator-dotnet-prod `
  --log-file app-logs.zip
```

### Scale Application

```powershell
# Manual scale
az appservice plan update `
  --name asp-calculator-dotnet-prod `
  --resource-group rg-calculator-dotnet-prod `
  --number-of-workers 5
```

---

## 🧪 Testing

### Health Check Endpoint

```powershell
# Test application health
Invoke-WebRequest -Uri "https://calculator-dotnet-prod.azurewebsites.net" -UseBasicParsing
```

### Load Testing

```powershell
# Using Azure Load Testing (requires setup)
az load test create `
  --name calculator-load-test `
  --resource-group rg-calculator-dotnet-prod `
  --test-plan ./load-test-plan.jmx
```

---

## 📋 Compliance Checklist

- [ ] All secrets stored in Key Vault
- [ ] HTTPS-only enforced
- [ ] Managed Identity enabled
- [ ] Private Endpoints configured (production)
- [ ] Network Security Groups applied
- [ ] Application Insights configured
- [ ] Log Analytics retention set (365 days for production)
- [ ] Azure Policy assignments in place
- [ ] DDoS Protection enabled (production)
- [ ] Backup and disaster recovery configured
- [ ] Security Center monitoring enabled
- [ ] Vulnerability scanning automated
- [ ] Incident response plan documented

---

## 🤝 Contributing

1. Create a feature branch
2. Make changes
3. Test in dev environment
4. Submit pull request
5. Await approval and CI checks
6. Merge to `develop` for dev deployment
7. Merge to `main` for staging/production

---

## 📞 Support

- **Documentation**: See individual module READMEs
- **Issues**: Create an issue in this repository
- **Security**: Report to security@example.com
- **Azure Support**: https://portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade

---

## 📚 Additional Resources

- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [.NET Framework on Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore)

---

**Version**: 1.0.0  
**Last Updated**: May 8, 2026  
**Maintained By**: DevOps Team
