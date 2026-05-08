# Network Security Rules for Azure App Service

This document defines the network security rules and configurations for the Calculator application deployed on Azure App Service.

## Network Security Groups (NSG) Rules

### Inbound Rules

| Priority | Name | Port | Protocol | Source | Destination | Action |
|----------|------|------|----------|--------|-------------|--------|
| 100 | AllowHTTPS | 443 | TCP | Internet | * | Allow |
| 110 | AllowHTTP | 80 | TCP | Internet | * | Allow |
| 200 | AllowAzureLoadBalancer | * | * | AzureLoadBalancer | * | Allow |
| 4096 | DenyAllInbound | * | * | * | * | Deny |

### Outbound Rules

| Priority | Name | Port | Protocol | Source | Destination | Action |
|----------|------|------|----------|--------|-------------|--------|
| 100 | AllowAzureServices | 443 | TCP | * | AzureCloud | Allow |
| 110 | AllowSQL | 1433 | TCP | * | Sql | Allow |
| 120 | AllowKeyVault | 443 | TCP | * | AzureKeyVault | Allow |
| 4096 | DenyAllOutbound | * | * | * | * | Deny |

## IP Restrictions (Production)

### Allowed IP Ranges

```json
{
  "ipRestrictions": [
    {
      "name": "AllowCorporateNetwork",
      "ipAddress": "203.0.113.0/24",
      "action": "Allow",
      "priority": 100,
      "description": "Corporate network range"
    },
    {
      "name": "AllowVPN",
      "ipAddress": "198.51.100.0/24",
      "action": "Allow",
      "priority": 110,
      "description": "VPN users"
    },
    {
      "name": "AllowAdminAccess",
      "ipAddress": "192.0.2.50/32",
      "action": "Allow",
      "priority": 120,
      "description": "Admin workstation"
    }
  ],
  "scmIpRestrictions": [
    {
      "name": "AllowDevOps",
      "ipAddress": "203.0.113.10/32",
      "action": "Allow",
      "priority": 100,
      "description": "DevOps deployment agent"
    }
  ]
}
```

## Private Endpoint Configuration

### Enable Private Endpoint (Production Only)

```hcl
# In terraform-appservice-environment/production/main.tf
enable_private_endpoint = true
```

### Private DNS Zone

- **Zone Name**: `privatelink.azurewebsites.net`
- **Purpose**: Resolve App Service private endpoint to internal IP
- **Linked VNets**: App Service VNet

## Service Endpoints

### Enabled Service Endpoints

1. **Microsoft.Web** - For App Service VNet integration
2. **Microsoft.KeyVault** - Secure access to Key Vault
3. **Microsoft.Sql** - Database connectivity
4. **Microsoft.Storage** - Storage account access

## CORS Configuration

### Development

```json
{
  "allowedOrigins": [
    "http://localhost:5000",
    "https://calculator-dotnet-dev.azurewebsites.net"
  ],
  "supportCredentials": false
}
```

### Production

```json
{
  "allowedOrigins": [
    "https://calculator-dotnet-prod.azurewebsites.net",
    "https://www.yourcustomdomain.com"
  ],
  "supportCredentials": false,
  "allowedMethods": ["GET", "POST"],
  "allowedHeaders": ["Content-Type", "Authorization"],
  "maxAge": 3600
}
```

## Web Application Firewall (WAF)

### Recommended WAF Rules (Azure Front Door)

1. **SQL Injection Protection** - Enabled
2. **XSS Protection** - Enabled
3. **Rate Limiting** - 1000 requests/minute per IP
4. **Geo-Blocking** - Block high-risk countries (if needed)
5. **Bot Protection** - Enabled

### Custom WAF Rules

```json
{
  "customRules": [
    {
      "name": "RateLimitPerIP",
      "priority": 10,
      "ruleType": "RateLimitRule",
      "rateLimitDuration": "PT1M",
      "rateLimitThreshold": 1000,
      "matchConditions": [
        {
          "matchVariable": "RemoteAddr",
          "operator": "IPMatch",
          "matchValue": ["0.0.0.0/0"]
        }
      ],
      "action": "Block"
    },
    {
      "name": "BlockMaliciousUserAgents",
      "priority": 20,
      "ruleType": "MatchRule",
      "matchConditions": [
        {
          "matchVariable": "RequestHeader",
          "selector": "User-Agent",
          "operator": "Contains",
          "matchValue": ["sqlmap", "nikto", "nmap"]
        }
      ],
      "action": "Block"
    }
  ]
}
```

## DDoS Protection

### Standard Tier (Production)

- **Enabled**: Yes (for production)
- **Protection Type**: Azure DDoS Protection Standard
- **Alert Threshold**: 80% of baseline traffic
- **Notification**: Email to security team

## TLS/SSL Configuration

### Minimum TLS Version

```json
{
  "minTlsVersion": "1.2",
  "requireTls": true,
  "cipherSuites": [
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384"
  ]
}
```

### Custom Domain SSL

```bash
# Bind SSL certificate to custom domain
az webapp config ssl bind \
  --resource-group rg-calculator-dotnet-prod \
  --name calculator-dotnet-prod \
  --certificate-thumbprint <thumbprint> \
  --ssl-type SNI
```

## Monitoring and Logging

### Network Logs to Capture

1. **NSG Flow Logs** - All traffic patterns
2. **Application Gateway Logs** - WAF events
3. **App Service Diagnostic Logs** - HTTP logs
4. **Key Vault Audit Logs** - Access attempts

### Log Analytics Queries

```kusto
// Detect potential SQL Injection attempts
AppServiceHTTPLogs
| where TimeGenerated > ago(1h)
| where CsUriQuery contains "'" or CsUriQuery contains "--" or CsUriQuery contains "/*"
| project TimeGenerated, CIp, CsMethod, CsUriStem, CsUriQuery, ScStatus

// Monitor blocked IPs
AzureDiagnostics
| where Category == "NetworkSecurityGroupRuleCounter"
| where type_s == "block"
| summarize Count=count() by SourceIP=split(ResourceId, "/")[8]
| order by Count desc
```

## Compliance Requirements

### Standards Adherence

- ✅ CIS Microsoft Azure Foundations Benchmark
- ✅ NIST Cybersecurity Framework
- ✅ PCI-DSS (if handling payment data)
- ✅ GDPR (for EU data)
- ✅ SOC 2 Type II

### Network Segmentation

```
Internet
   ↓
[Azure Front Door + WAF]
   ↓
[Application Gateway]
   ↓
[App Service (in VNet)]
   ↓
[Private Endpoint]
   ↓
[Key Vault / SQL Database]
```

## Incident Response

### Security Incident Procedures

1. **Detection**: Monitor alerts from Security Center
2. **Isolation**: Block suspicious IPs via NSG
3. **Investigation**: Review logs in Log Analytics
4. **Remediation**: Apply patches, rotate keys
5. **Documentation**: Record incident details

### Emergency Contacts

- **Security Team**: security@example.com
- **On-Call Engineer**: +1-555-0100
- **Azure Support**: https://portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade

## Review Schedule

- **Monthly**: Review NSG rules and IP restrictions
- **Quarterly**: Audit network architecture
- **Annually**: Full security assessment and penetration testing

---

**Last Updated**: May 8, 2026  
**Approved By**: Security Team  
**Next Review**: August 8, 2026
