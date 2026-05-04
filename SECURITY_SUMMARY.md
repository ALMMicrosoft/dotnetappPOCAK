# 🔐 Security Vulnerabilities - Quick Summary

## ⚠️ INTENTIONAL VULNERABILITIES ADDED

This document provides a quick overview of the 17+ security vulnerabilities intentionally added to the application.

---

## 📊 Vulnerability Breakdown

| Severity | Count | Files Affected |
|----------|-------|----------------|
| 🔴 Critical | 5 | Startup.cs, script.js, index.html |
| 🟠 High | 7 | Startup.cs, script.js, index.html |
| 🟡 Medium | 4 | Startup.cs, script.js, index.html |
| 🟢 Low | 1 | script.js |

---

## 🎯 Quick Reference

### Critical Vulnerabilities

1. **Path Traversal** - `/api/file?path=` endpoint
2. **SQL Injection** - `/api/logs?userId=` endpoint  
3. **Insecure Deserialization** - `TypeNameHandling.All`
4. **Hard-coded Credentials** - Database connection string
5. **Credentials in Comments** - HTML source code

### High Vulnerabilities

6. **XSS in Display** - `innerHTML` usage
7. **XSS in History** - `innerHTML` usage
8. **Exposed API Keys** - Client-side JavaScript
9. **Unrestricted CORS** - Allow-Origin: *
10. **No CSP** - Missing Content Security Policy
11. **External Scripts Without SRI** - jQuery without integrity check
12. **Inline JavaScript** - HTML inline scripts

### Medium Vulnerabilities

13. **Logging Sensitive Data** - Console and file logs
14. **Detailed Error Messages** - Stack traces exposed
15. **API Key in Headers** - Client sends API key
16. **Debug Mode Enabled** - Production debug logs

### Low Vulnerabilities

17. **Console Logging** - Development logs in production

---

## 🧪 Testing Commands

### Test SQL Injection
```bash
curl "http://localhost:5000/api/logs?userId=1'%20OR%20'1'='1"
```

### Test Path Traversal  
```bash
curl "http://localhost:5000/api/file?path=../../../../windows/win.ini"
```

### Test XSS
Open calculator and enter:
```html
<img src=x onerror=alert('XSS')>
```

### Test CORS from Browser Console
```javascript
fetch('http://localhost:5000/api/calculate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        firstNumber: 1,
        secondNumber: 2,
        operation: 'add'
    })
}).then(r => r.json()).then(console.log);
```

---

## 📁 Affected Files

### Backend (C#)
- ✅ `Startup.cs` - 8 vulnerabilities added
  - Hard-coded credentials
  - CORS misconfiguration
  - Path traversal endpoint
  - SQL injection endpoint
  - Insecure deserialization
  - Sensitive data logging
  - Detailed error messages
  - No input validation

### Frontend (JavaScript)
- ✅ `wwwroot/script.js` - 5 vulnerabilities added
  - Exposed secrets
  - XSS vulnerabilities (2)
  - API key in requests
  - Console logging

### Frontend (HTML)
- ✅ `wwwroot/index.html` - 4 vulnerabilities added
  - No CSP
  - External scripts without SRI
  - Inline JavaScript
  - Credentials in comments

---

## 🛡️ Detection Tools

Run these tools to detect vulnerabilities:

```bash
# OWASP ZAP
zap-cli quick-scan http://localhost:5000

# Snyk (for dependencies)
snyk test

# SonarQube Scanner
sonar-scanner

# ESLint Security
eslint wwwroot/*.js --plugin security
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `SECURITY_VULNERABILITIES.md` | Complete detailed documentation |
| `SECURITY_SUMMARY.md` | This quick reference (current file) |
| `README.md` | Updated with security warning |

---

## ⚖️ Legal Notice

**FOR EDUCATIONAL PURPOSES ONLY**

These vulnerabilities are intentionally added for:
- Security training
- Penetration testing practice
- Vulnerability assessment learning
- Secure coding education

**DO NOT:**
- Deploy to production
- Use on systems you don't own
- Exploit maliciously

---

## 🔧 Next Steps

1. **Study the vulnerabilities** - Read `SECURITY_VULNERABILITIES.md`
2. **Test the vulnerabilities** - Use provided commands
3. **Learn to fix them** - Understand proper mitigations
4. **Practice secure coding** - Apply learned concepts

---

## 📋 Checklist for Security Testing

- [ ] Read full documentation (`SECURITY_VULNERABILITIES.md`)
- [ ] Set up local testing environment
- [ ] Test SQL Injection vulnerability
- [ ] Test Path Traversal vulnerability
- [ ] Test XSS vulnerabilities
- [ ] Test CORS misconfiguration
- [ ] Test insecure deserialization
- [ ] Review hard-coded credentials
- [ ] Check error message exposure
- [ ] Verify logging issues
- [ ] Document findings
- [ ] Practice fixing each vulnerability

---

## 🎓 Learning Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Web Security Academy](https://portswigger.net/web-security)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [CWE Top 25](https://cwe.mitre.org/top25/)

---

**Status:** ⚠️ VULNERABLE BY DESIGN  
**Environment:** Development/Testing Only  
**Last Updated:** May 4, 2026

---

## 💡 Pro Tips

1. **Always test in isolated environment**
2. **Document your findings**
3. **Learn both exploitation and mitigation**
4. **Keep a security checklist**
5. **Stay updated on new vulnerabilities**

For complete details, see: **[SECURITY_VULNERABILITIES.md](SECURITY_VULNERABILITIES.md)**
