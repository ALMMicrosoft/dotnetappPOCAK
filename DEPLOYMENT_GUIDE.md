# 🚀 Deployment Guide

## Pre-Deployment Checklist

### ✅ Security Verification
- [x] All 17 vulnerabilities fixed
- [x] Code review completed
- [x] Builds successful
- [ ] Environment variables configured
- [ ] Security scanning completed
- [ ] Penetration testing performed

---

## Environment Setup

### 1. Required Environment Variables

#### Windows (PowerShell)
```powershell
# Production Database
[System.Environment]::SetEnvironmentVariable('DB_CONNECTION_STRING', 'Server=prod-db;Database=Calculator;User Id=appuser;Password=SecurePassword!2024;Encrypt=True;', [System.EnvironmentVariableTarget]::Machine)

# API Key for external services (if needed)
[System.Environment]::SetEnvironmentVariable('API_KEY', 'your-production-api-key-here', [System.EnvironmentVariableTarget]::Machine)
```

#### Linux/Docker
```bash
export DB_CONNECTION_STRING="Server=prod-db;Database=Calculator;User Id=appuser;Password=SecurePassword!2024;Encrypt=True;"
export API_KEY="your-production-api-key-here"
```

#### Azure App Service
```bash
az webapp config appsettings set --name YourAppName --resource-group YourResourceGroup \
  --settings DB_CONNECTION_STRING="Server=prod-db;..." API_KEY="your-key"
```

---

## Deployment Options

### Option 1: IIS Deployment (Recommended for Windows)

#### Step 1: Prepare Build
```powershell
# Build in Release mode
dotnet build CalculatorWeb.csproj --configuration Release

# Copy web assets
Copy-Item -Path "wwwroot\*" -Destination "bin\Release\net48\wwwroot\" -Recurse -Force
```

#### Step 2: Configure IIS
```powershell
# Install IIS features (if not already installed)
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45

# Create application pool
New-WebAppPool -Name "CalculatorAppPool"
Set-ItemProperty IIS:\AppPools\CalculatorAppPool managedRuntimeVersion v4.0

# Create website
New-Website -Name "Calculator" -Port 80 -PhysicalPath "C:\inetpub\wwwroot\Calculator" -ApplicationPool "CalculatorAppPool"

# Copy files to IIS directory
Copy-Item -Path "bin\Release\net48\*" -Destination "C:\inetpub\wwwroot\Calculator\" -Recurse -Force
```

#### Step 3: Configure HTTPS
```powershell
# Bind SSL certificate
New-WebBinding -Name "Calculator" -IP "*" -Port 443 -Protocol https
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*yourdomain.com*"}
$binding = Get-WebBinding -Name "Calculator" -Protocol "https"
$binding.AddSslCertificate($cert.GetCertHashString(), "my")
```

---

### Option 2: Self-Hosted (OWIN)

#### Step 1: Build Application
```powershell
dotnet build CalculatorWeb.csproj --configuration Release
Copy-Item -Path "wwwroot\*" -Destination "bin\Release\net48\wwwroot\" -Recurse -Force
```

#### Step 2: Run as Windows Service
```powershell
# Install NSSM (Non-Sucking Service Manager)
choco install nssm -y

# Create Windows Service
nssm install CalculatorService "C:\path\to\bin\Release\net48\CalculatorWeb.exe"
nssm set CalculatorService AppDirectory "C:\path\to\bin\Release\net48"
nssm set CalculatorService DisplayName "Calculator Web Application"
nssm set CalculatorService Description "Secure calculator web application"

# Set environment variables for service
nssm set CalculatorService AppEnvironmentExtra DB_CONNECTION_STRING="Server=..." API_KEY="..."

# Start service
nssm start CalculatorService
```

#### Step 3: Configure Firewall
```powershell
# Allow inbound connections
New-NetFirewallRule -DisplayName "Calculator Web App" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

---

### Option 3: Azure App Service

#### Step 1: Prepare for Azure
```powershell
# Create publish profile
dotnet publish CalculatorWeb.csproj --configuration Release --output ./publish
```

#### Step 2: Deploy to Azure
```bash
# Login to Azure
az login

# Create resource group
az group create --name CalculatorRG --location eastus

# Create App Service plan
az appservice plan create --name CalculatorPlan --resource-group CalculatorRG --sku B1

# Create web app
az webapp create --name YourCalculatorApp --resource-group CalculatorRG --plan CalculatorPlan

# Configure environment variables
az webapp config appsettings set --name YourCalculatorApp --resource-group CalculatorRG \
  --settings DB_CONNECTION_STRING="Server=..." API_KEY="..."

# Deploy application
az webapp deployment source config-zip --name YourCalculatorApp --resource-group CalculatorRG --src ./publish.zip
```

#### Step 3: Configure SSL
```bash
# Enable HTTPS only
az webapp update --name YourCalculatorApp --resource-group CalculatorRG --https-only true

# Configure custom domain and SSL (optional)
az webapp config hostname add --webapp-name YourCalculatorApp --resource-group CalculatorRG --hostname yourdomain.com
az webapp config ssl bind --name YourCalculatorApp --resource-group CalculatorRG --certificate-thumbprint <thumbprint> --ssl-type SNI
```

---

### Option 4: Docker Container

#### Step 1: Create Dockerfile
```dockerfile
# Create file: Dockerfile
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

WORKDIR /app

# Copy application files
COPY bin/Release/net48/ .

# Set environment variables (override at runtime)
ENV DB_CONNECTION_STRING=""
ENV API_KEY=""

# Expose port
EXPOSE 5000

# Run application
CMD ["CalculatorWeb.exe"]
```

#### Step 2: Build and Run
```powershell
# Build Docker image
docker build -t calculator-app:latest .

# Run container
docker run -d -p 5000:5000 `
  -e DB_CONNECTION_STRING="Server=..." `
  -e API_KEY="..." `
  --name calculator-app `
  calculator-app:latest
```

---

## Configuration Checklist

### 1. Update CORS Origins
Edit `Startup.cs` line 29:
```csharp
// Replace with your actual domains
context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { 
    "https://yourdomain.com", 
    "https://app.yourdomain.com" 
});
```

### 2. Configure Logging
```csharp
// In Startup.cs, add structured logging
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.File("logs/calculator.txt", rollingInterval: RollingInterval.Day)
    .WriteTo.Console()
    .CreateLogger();
```

### 3. Enable Rate Limiting (Optional)
Install package:
```powershell
Install-Package AspNetCoreRateLimit
```

### 4. Add Health Check Endpoint
```csharp
// In Startup.cs
app.Map("/health", healthApp =>
{
    healthApp.Run(async context =>
    {
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsync("{\"status\":\"healthy\"}");
    });
});
```

---

## Monitoring Setup

### Application Insights (Azure)
```bash
# Install package
dotnet add package Microsoft.ApplicationInsights.AspNetCore

# Configure in Startup.cs
services.AddApplicationInsightsTelemetry(Configuration["ApplicationInsights:InstrumentationKey"]);
```

### Custom Logging
```csharp
// Add to Startup.cs
private void LogSecurityEvent(string eventType, string details)
{
    var logEntry = new
    {
        Timestamp = DateTime.UtcNow,
        EventType = eventType,
        Details = details,
        Source = "CalculatorApp"
    };
    
    // Log to file, database, or monitoring service
    Console.WriteLine($"[SECURITY] {JsonConvert.SerializeObject(logEntry)}");
}
```

---

## Security Testing

### Before Going Live

#### 1. Run OWASP ZAP
```bash
# Download OWASP ZAP
# https://www.zaproxy.org/download/

# Run automated scan
zap-cli quick-scan --spider -r http://localhost:5000

# Generate report
zap-cli report -o security-report.html -f html
```

#### 2. SSL/TLS Verification
```bash
# Test SSL configuration
nmap --script ssl-enum-ciphers -p 443 yourdomain.com

# Or use SSL Labs
# https://www.ssllabs.com/ssltest/
```

#### 3. Dependency Scanning
```powershell
# Check for vulnerable packages
dotnet list package --vulnerable
```

---

## Production Checklist

### Pre-Launch
- [ ] Environment variables configured
- [ ] CORS origins updated
- [ ] SSL certificate installed
- [ ] HTTPS enforced
- [ ] Firewall rules configured
- [ ] Database connection tested
- [ ] Backup procedures in place
- [ ] Monitoring configured
- [ ] Error logging working
- [ ] Health check endpoint accessible

### Security
- [ ] Security headers verified (CSP, HSTS, etc.)
- [ ] XSS protection tested
- [ ] CORS policy tested
- [ ] Input validation tested
- [ ] Error handling verified (no stack traces)
- [ ] Secrets removed from code
- [ ] SRI hashes on external scripts
- [ ] Rate limiting configured (optional)

### Performance
- [ ] Load testing completed
- [ ] Response times acceptable
- [ ] Resource usage monitored
- [ ] Caching configured (if needed)
- [ ] CDN configured (if needed)

### Operations
- [ ] Deployment process documented
- [ ] Rollback procedure tested
- [ ] Incident response plan created
- [ ] Team trained on deployment
- [ ] Support contacts documented
- [ ] Backup/restore tested

---

## Rollback Procedure

### IIS Deployment
```powershell
# Stop application
Stop-Website -Name "Calculator"

# Restore previous version
Copy-Item -Path "C:\backup\Calculator\*" -Destination "C:\inetpub\wwwroot\Calculator\" -Recurse -Force

# Start application
Start-Website -Name "Calculator"
```

### Azure App Service
```bash
# Swap deployment slots
az webapp deployment slot swap --name YourCalculatorApp --resource-group CalculatorRG --slot staging

# Or restore from backup
az webapp restore --name YourCalculatorApp --resource-group CalculatorRG --backup-name <backup-name>
```

---

## Troubleshooting

### Common Issues

#### 1. Environment Variables Not Loading
```powershell
# Verify variables are set
[System.Environment]::GetEnvironmentVariable('DB_CONNECTION_STRING', [System.EnvironmentVariableTarget]::Machine)

# Restart application/service after setting variables
Restart-Service CalculatorService
```

#### 2. CORS Errors
- Verify allowed origins in `Startup.cs`
- Check browser console for specific errors
- Ensure preflight requests are handled

#### 3. SSL Certificate Issues
```powershell
# Verify certificate binding
Get-WebBinding -Name "Calculator" -Protocol https
netsh http show sslcert
```

#### 4. Port Already in Use
```powershell
# Find process using port
netstat -ano | findstr :5000

# Kill process
taskkill /PID <process-id> /F
```

---

## Support and Maintenance

### Log Locations
- **IIS:** `C:\inetpub\logs\LogFiles\`
- **Self-hosted:** `.\logs\` (in application directory)
- **Azure:** Use Azure Portal → App Service → Log Stream

### Performance Monitoring
```powershell
# Check application performance
Get-Counter '\Process(CalculatorWeb)\% Processor Time'
Get-Counter '\Process(CalculatorWeb)\Working Set'
```

### Database Maintenance
```sql
-- Check connection health
SELECT @@SERVERNAME as ServerName, 
       DB_NAME() as DatabaseName,
       GETDATE() as CurrentTime;

-- Monitor active connections
SELECT * FROM sys.dm_exec_sessions 
WHERE program_name LIKE '%Calculator%';
```

---

## Additional Resources

- [SECURITY_FIXES.md](SECURITY_FIXES.md) - Detailed security remediations
- [SECURITY_VERIFICATION_REPORT.md](SECURITY_VERIFICATION_REPORT.md) - Security audit report
- [CI_CD_COMPLETE.md](CI_CD_COMPLETE.md) - CI/CD pipeline documentation
- [GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md) - GitHub Actions setup

---

## Contact

For deployment issues or security concerns, please:
1. Check the troubleshooting section
2. Review security documentation
3. Contact the development team

---

**Last Updated:** December 2024  
**Status:** Production Ready (with proper configuration)
