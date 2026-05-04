# 🔐 SECURITY VULNERABILITIES DOCUMENTATION

## ⚠️ WARNING
This application contains **INTENTIONAL SECURITY VULNERABILITIES** for educational and testing purposes.

**DO NOT USE IN PRODUCTION!**

## 📋 List of Security Issues

### Backend Vulnerabilities (Startup.cs)

#### 1. **Hard-coded Credentials** (Line ~18-19)
```csharp
private const string ConnectionString = "Server=localhost;Database=Calculator;User Id=admin;Password=Admin123!;";
private const string ApiKey = "SECRET_API_KEY_12345";
```
**Impact:** High  
**Type:** CWE-798 - Use of Hard-coded Credentials  
**Risk:** Attackers can extract credentials from compiled code  
**Fix:** Use environment variables or secure key management systems (Azure Key Vault, AWS Secrets Manager)

---

#### 2. **Unrestricted CORS Policy** (Line ~23-28)
```csharp
context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });
context.Response.Headers.Add("Access-Control-Allow-Methods", new[] { "*" });
```
**Impact:** High  
**Type:** CWE-942 - Overly Permissive CORS Policy  
**Risk:** Allows any website to make requests to the API  
**Fix:** Specify allowed origins explicitly

---

#### 3. **Path Traversal Vulnerability** (Line ~44-51)
```csharp
app.Map("/api/file", fileApp =>
{
    var filePath = context.Request.Query["path"];
    var content = File.ReadAllText(filePath); // No validation!
});
```
**Impact:** Critical  
**Type:** CWE-22 - Path Traversal  
**Risk:** Attackers can read any file on the server  
**Example Attack:** `/api/file?path=../../../../windows/system32/config/sam`  
**Fix:** Validate and sanitize file paths, use whitelist approach

---

#### 4. **SQL Injection** (Line ~54-61)
```csharp
var userId = context.Request.Query["userId"];
var query = "SELECT * FROM Logs WHERE UserId = '" + userId + "'";
```
**Impact:** Critical  
**Type:** CWE-89 - SQL Injection  
**Risk:** Database compromise, data theft, data manipulation  
**Example Attack:** `/api/logs?userId=1' OR '1'='1`  
**Fix:** Use parameterized queries or ORM

---

#### 5. **Insecure Deserialization** (Line ~81-84)
```csharp
var settings = new JsonSerializerSettings
{
    TypeNameHandling = TypeNameHandling.All
};
```
**Impact:** Critical  
**Type:** CWE-502 - Deserialization of Untrusted Data  
**Risk:** Remote code execution  
**Fix:** Avoid TypeNameHandling.All, validate input types

---

#### 6. **Logging Sensitive Data** (Line ~87-88)
```csharp
Console.WriteLine($"[LOG] Request from {context.Request.RemoteIpAddress}: {body}");
File.AppendAllText("sensitive_logs.txt", $"{DateTime.Now}: {body}\n");
```
**Impact:** Medium  
**Type:** CWE-532 - Information Exposure Through Log Files  
**Risk:** Sensitive data in logs can be accessed by unauthorized users  
**Fix:** Sanitize logs, avoid logging sensitive data

---

#### 7. **Detailed Error Messages** (Line ~123)
```csharp
error = ex.ToString(); // Includes stack trace
```
**Impact:** Medium  
**Type:** CWE-209 - Information Exposure Through Error Message  
**Risk:** Reveals system architecture and internal paths  
**Fix:** Return generic error messages to clients, log details server-side

---

#### 8. **No Input Validation** (Line ~131)
```csharp
await context.Response.WriteAsync(JsonConvert.SerializeObject(response));
```
**Impact:** Low  
**Type:** CWE-20 - Improper Input Validation  
**Risk:** Various injection attacks  
**Fix:** Validate all inputs and outputs

---

### Frontend Vulnerabilities (wwwroot/)

#### 9. **Exposed Secrets in JavaScript** (script.js Line ~1-3)
```javascript
const API_KEY = 'SECRET_API_KEY_12345';
const ADMIN_PASSWORD = 'Admin123!';
```
**Impact:** High  
**Type:** CWE-540 - Information Exposure Through Source Code  
**Risk:** Anyone can view client-side code  
**Fix:** Never store secrets in client-side code

---

#### 10-11. **DOM-based XSS** (script.js Line ~15, 20)
```javascript
display.innerHTML = currentValue; // XSS vulnerability
history.innerHTML = text;
```
**Impact:** High  
**Type:** CWE-79 - Cross-Site Scripting (XSS)  
**Risk:** JavaScript injection, session hijacking  
**Example Attack:** Input `<img src=x onerror=alert('XSS')>`  
**Fix:** Use `textContent` instead of `innerHTML`

---

#### 12. **API Key in Request Headers** (script.js Line ~89)
```javascript
headers: {
    'X-API-Key': API_KEY
}
```
**Impact:** Medium  
**Type:** CWE-319 - Cleartext Transmission of Sensitive Information  
**Risk:** API key exposed in network traffic  
**Fix:** Use OAuth, JWT, or server-side authentication

---

#### 13. **Sensitive Data in Console Logs** (script.js Line ~99-102)
```javascript
console.log('API Response:', data);
console.log('Request details:', { previousValue, secondNumber, operation });
```
**Impact:** Low  
**Type:** CWE-532 - Information Exposure Through Log Files  
**Risk:** Information leakage through browser console  
**Fix:** Remove debug logs in production

---

#### 14. **No Content Security Policy** (index.html Line ~9)
```html
<!-- No CSP headers -->
```
**Impact:** Medium  
**Type:** CWE-693 - Protection Mechanism Failure  
**Risk:** XSS and injection attacks  
**Fix:** Implement CSP headers

---

#### 15. **External Resources Without SRI** (index.html Line ~11)
```html
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
```
**Impact:** Medium  
**Type:** CWE-353 - Missing Support for Integrity Check  
**Risk:** Compromised CDN can inject malicious code  
**Fix:** Use Subresource Integrity (SRI) hashes

---

#### 16. **Inline JavaScript** (index.html Line ~14-17)
```html
<script>
    var adminMode = true;
    var secretToken = "abc123xyz789";
</script>
```
**Impact:** Medium  
**Type:** CWE-80 - Improper Neutralization of Script-Related HTML Tags  
**Risk:** XSS vulnerabilities  
**Fix:** Move JavaScript to external files, use CSP

---

#### 17. **Credentials in HTML Comments** (index.html Line ~21-23)
```html
<!-- Admin Panel: http://localhost:5000/admin 
     Username: admin
     Password: Admin123! -->
```
**Impact:** Critical  
**Type:** CWE-615 - Information Exposure Through Comments  
**Risk:** Exposed credentials in source code  
**Fix:** Never include sensitive information in comments

---

## 🎯 Testing the Vulnerabilities

### Test SQL Injection
```bash
curl "http://localhost:5000/api/logs?userId=1'%20OR%20'1'='1"
```

### Test Path Traversal
```bash
curl "http://localhost:5000/api/file?path=../../../windows/system32/drivers/etc/hosts"
```

### Test XSS
1. Open browser console
2. Enter: `<img src=x onerror=alert('XSS')>` in calculator
3. Observe script execution

### Test CORS
```javascript
fetch('http://localhost:5000/api/calculate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ firstNumber: 1, secondNumber: 1, operation: 'add' })
})
```

---

## 🛡️ Security Scanning Tools

Use these tools to detect vulnerabilities:

1. **OWASP ZAP** - Web application security scanner
2. **Burp Suite** - Web vulnerability scanner
3. **SonarQube** - Static code analysis
4. **Snyk** - Dependency vulnerability scanning
5. **ESLint Security Plugin** - JavaScript security linting
6. **Brakeman** - Static analysis security scanner

---

## 📚 References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE List](https://cwe.mitre.org/)
- [SANS Top 25](https://www.sans.org/top25-software-errors/)
- [.NET Security Best Practices](https://docs.microsoft.com/en-us/dotnet/standard/security/)

---

## ⚖️ Legal Disclaimer

These vulnerabilities are introduced for **EDUCATIONAL PURPOSES ONLY**. 

**DO NOT:**
- Deploy this code to production
- Use these techniques for malicious purposes
- Test on systems you don't own or have permission to test

**Unauthorized testing or exploitation is illegal and unethical.**

---

## 🔧 How to Fix

For a secure version, refer to the branch `secure-version` (to be created) which implements:
- Input validation and sanitization
- Parameterized queries
- Secure deserialization
- Proper error handling
- Content Security Policy
- Secure credential management
- HTTPS enforcement
- Rate limiting
- Authentication & Authorization

---

**Created for:** Security training and vulnerability assessment  
**Status:** ⚠️ INTENTIONALLY VULNERABLE - DO NOT USE IN PRODUCTION  
**Last Updated:** May 4, 2026
