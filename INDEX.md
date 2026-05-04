# 📚 Project Documentation Index

## 🔐 Security Vulnerabilities Documentation

**⚠️ THIS APPLICATION CONTAINS INTENTIONAL SECURITY VULNERABILITIES**

### Security Documentation Files

1. **[SECURITY_VULNERABILITIES.md](SECURITY_VULNERABILITIES.md)** ⭐ START HERE
   - Complete detailed documentation of all 17 vulnerabilities
   - Impact assessment and risk levels
   - Code examples and exploitation techniques
   - Remediation guidance
   - Testing procedures
   - Tool recommendations

2. **[SECURITY_SUMMARY.md](SECURITY_SUMMARY.md)** 
   - Quick reference guide
   - Vulnerability breakdown table
   - Testing commands
   - Checklist for security testing
   - Learning resources

3. **[README.md](README.md)**
   - Main project documentation
   - Security warning banner
   - Feature overview
   - Build instructions

---

## 🚀 CI/CD Documentation

### GitHub Actions Setup

1. **[CI_CD_COMPLETE.md](CI_CD_COMPLETE.md)**
   - Complete CI/CD setup guide
   - Visual workflow diagram
   - Artifact information
   - Success criteria

2. **[GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md)**
   - Comprehensive setup instructions
   - Troubleshooting guide
   - Customization options
   - Best practices

3. **[SETUP_SUMMARY.md](SETUP_SUMMARY.md)**
   - Quick setup overview
   - Next steps checklist
   - File structure

4. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**
   - One-line commands
   - Quick troubleshooting
   - Cheat sheet

---

## 📂 Project Structure

```
Calculator Application/
├── 🔐 Security Documentation
│   ├── SECURITY_VULNERABILITIES.md (Detailed vulnerabilities)
│   └── SECURITY_SUMMARY.md (Quick reference)
│
├── 🚀 CI/CD Documentation  
│   ├── CI_CD_COMPLETE.md (Complete guide)
│   ├── GITHUB_ACTIONS_GUIDE.md (Setup guide)
│   ├── SETUP_SUMMARY.md (Quick overview)
│   └── QUICK_REFERENCE.md (Cheat sheet)
│
├── 📱 Application Code
│   ├── Calculator.csproj (Windows Forms app)
│   ├── CalculatorWeb.csproj (Web app)
│   ├── MainForm.cs (Desktop UI)
│   ├── Program.cs (Desktop entry)
│   ├── WebProgram.cs (Web entry)
│   ├── Startup.cs (Web server config) ⚠️ VULNERABLE
│   ├── CalculatorEngine.cs (Core logic)
│   └── wwwroot/ (Web frontend) ⚠️ VULNERABLE
│       ├── index.html ⚠️ VULNERABLE
│       ├── script.js ⚠️ VULNERABLE
│       └── styles.css
│
└── ⚙️ Configuration
    ├── .github/workflows/build.yml (CI/CD pipeline)
    ├── .gitignore (Git ignore rules)
    └── README.md (Main documentation)
```

---

## 🎯 Quick Navigation

### For Security Testing
1. Start with **SECURITY_VULNERABILITIES.md**
2. Use **SECURITY_SUMMARY.md** for quick tests
3. Review vulnerable code in:
   - `Startup.cs`
   - `wwwroot/script.js`
   - `wwwroot/index.html`

### For CI/CD Setup
1. Start with **CI_CD_COMPLETE.md**
2. Follow **GITHUB_ACTIONS_GUIDE.md** for detailed setup
3. Use **QUICK_REFERENCE.md** for commands

### For Building & Running
1. Read **README.md** for overview
2. Build Windows Forms: `dotnet build Calculator.csproj`
3. Build Web: `dotnet build CalculatorWeb.csproj`
4. Run: `.\bin\Debug\net48\Calculator.exe` or `CalculatorWeb.exe`

---

## 📊 Vulnerability Summary

| Category | Count | Files |
|----------|-------|-------|
| 🔴 Critical | 5 | Startup.cs, index.html |
| 🟠 High | 7 | Startup.cs, script.js, index.html |
| 🟡 Medium | 4 | Startup.cs, script.js |
| 🟢 Low | 1 | script.js |
| **Total** | **17** | **3 files** |

---

## 🛠️ Common Tasks

### Security Testing
```bash
# View all vulnerabilities
cat SECURITY_VULNERABILITIES.md

# Quick reference
cat SECURITY_SUMMARY.md

# Test SQL Injection
curl "http://localhost:5000/api/logs?userId=1' OR '1'='1"
```

### Building
```powershell
# Build both versions
dotnet build Calculator.csproj
dotnet build CalculatorWeb.csproj

# Copy web files
Copy-Item -Path "wwwroot\*" -Destination "bin\Debug\net48\wwwroot\" -Recurse -Force
```

### Running
```powershell
# Run Desktop version
.\bin\Debug\net48\Calculator.exe

# Run Web version
.\bin\Debug\net48\CalculatorWeb.exe
# Then open: http://localhost:5000
```

### GitHub Actions
```bash
# Push to trigger workflow
git push origin main

# View in GitHub
# Go to: Repository → Actions tab
```

---

## ⚠️ Important Warnings

### 🔴 Security
- **DO NOT** deploy this code to production
- **DO NOT** use on systems you don't own
- **ONLY** for educational and testing purposes
- Contains intentional vulnerabilities

### 📝 Legal
- For educational use only
- Unauthorized testing is illegal
- Follow responsible disclosure practices
- Respect privacy and laws

---

## 🎓 Learning Path

### Beginner
1. Read **README.md**
2. Review **SECURITY_SUMMARY.md**
3. Try basic vulnerability tests
4. Study one vulnerability at a time

### Intermediate
1. Read **SECURITY_VULNERABILITIES.md** completely
2. Test all vulnerabilities
3. Study remediation techniques
4. Practice fixing vulnerabilities

### Advanced
1. Use professional security tools (OWASP ZAP, Burp Suite)
2. Write automated security tests
3. Create secure version of the app
4. Document security improvements

---

## 📚 External Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [Web Security Academy](https://portswigger.net/web-security)
- [.NET Security](https://docs.microsoft.com/en-us/dotnet/standard/security/)

---

## 🆘 Need Help?

- **Security Questions**: See SECURITY_VULNERABILITIES.md
- **CI/CD Issues**: See GITHUB_ACTIONS_GUIDE.md
- **Build Problems**: See README.md
- **Quick Commands**: See QUICK_REFERENCE.md

---

## ✅ Quick Checklist

- [ ] Read README.md security warning
- [ ] Review SECURITY_VULNERABILITIES.md
- [ ] Set up local testing environment
- [ ] Test vulnerabilities safely
- [ ] Study remediation techniques
- [ ] Practice secure coding
- [ ] Set up GitHub Actions (optional)
- [ ] Document your findings

---

**Last Updated:** May 4, 2026  
**Status:** ⚠️ VULNERABLE BY DESIGN - Educational Use Only  
**Version:** 1.0.0

---

## 📞 Contact & Contributing

See `.github/CONTRIBUTING.md` for contribution guidelines.

**Remember:** Use responsibly and ethically! 🛡️
