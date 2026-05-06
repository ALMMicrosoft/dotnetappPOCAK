# 🚀 Quick Start Guide

**Get up and running with the .NET Framework Calculator in 5 minutes!**

---

## Prerequisites

- ✅ Windows Operating System
- ✅ .NET Framework 4.8 (pre-installed on Windows 10/11)
- ✅ PowerShell (pre-installed on Windows)

---

## 🏃 Fast Track (30 seconds)

### Option 1: Run Pre-built Desktop Calculator
```powershell
# Navigate to project
cd d:\CopliotPOCdotnetapp\dotnetappPOCAK

# Run desktop version
.\bin\Release\net48\Calculator.exe
```

### Option 2: Run Pre-built Web Calculator
```powershell
# Navigate to project
cd d:\CopliotPOCdotnetapp\dotnetappPOCAK

# Run web version
.\bin\Release\net48\CalculatorWeb.exe

# Open in browser: http://localhost:5000
```

---

## 🔨 Build from Source (2 minutes)

### Build Desktop Calculator
```powershell
# Navigate to project
cd d:\CopliotPOCdotnetapp\dotnetappPOCAK

# Build
dotnet build Calculator.csproj --configuration Release

# Run
.\bin\Release\net48\Calculator.exe
```

### Build Web Calculator
```powershell
# Navigate to project
cd d:\CopliotPOCdotnetapp\dotnetappPOCAK

# Build
dotnet build CalculatorWeb.csproj --configuration Release

# Copy web assets
Copy-Item -Path "wwwroot\*" -Destination "bin\Release\net48\wwwroot\" -Recurse -Force

# Run
.\bin\Release\net48\CalculatorWeb.exe

# Open in browser: http://localhost:5000
```

---

## 🎯 Using the Calculator

### Desktop Version
1. Enter first number
2. Select operation (Add, Subtract, Multiply, Divide, Power, Square Root)
3. Enter second number (if required)
4. View result
5. Perform another calculation or exit

### Web Version
1. Open http://localhost:5000 in your browser
2. Click number buttons or use keyboard
3. Click operation buttons (+, −, ×, ÷, x^y, √)
4. Click = to calculate
5. Click C to clear all, CE to clear entry

---

## 📚 Available Operations

| Operation | Desktop Key | Web Button | Example |
|-----------|-------------|------------|---------|
| Addition | 1 | + | 5 + 3 = 8 |
| Subtraction | 2 | − | 10 − 4 = 6 |
| Multiplication | 3 | × | 6 × 7 = 42 |
| Division | 4 | ÷ | 20 ÷ 4 = 5 |
| Power | 5 | x^y | 2 ^ 3 = 8 |
| Square Root | 6 | √ | √16 = 4 |

---

## 🔧 Troubleshooting

### Desktop Calculator Won't Start
```powershell
# Check .NET Framework is installed
dotnet --info

# Rebuild
dotnet build Calculator.csproj --configuration Release

# Try Debug build
.\bin\Debug\net48\Calculator.exe
```

### Web Calculator Port Already in Use
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill process (replace <PID> with actual process ID)
taskkill /PID <PID> /F

# Or edit WebProgram.cs to use different port
```

### Web Assets Not Loading
```powershell
# Ensure web assets are copied
Copy-Item -Path "wwwroot\*" -Destination "bin\Release\net48\wwwroot\" -Recurse -Force

# Check wwwroot folder exists
Test-Path "bin\Release\net48\wwwroot"
```

---

## 📖 Next Steps

### Learn More
- 📋 **[PROJECT_COMPLETION_SUMMARY.md](PROJECT_COMPLETION_SUMMARY.md)** - Complete project overview
- 📖 **[README.md](README.md)** - Detailed documentation
- 📚 **[INDEX.md](INDEX.md)** - Full documentation index

### Security Information
- 🛡️ **[SECURITY_VERIFICATION_REPORT.md](SECURITY_VERIFICATION_REPORT.md)** - Security status
- 🔒 **[SECURITY_FIXES.md](SECURITY_FIXES.md)** - Security improvements

### Development
- 🚀 **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Production deployment
- ⚙️ **[CI_CD_COMPLETE.md](CI_CD_COMPLETE.md)** - CI/CD pipeline
- 🔧 **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command reference

---

## 🎓 Educational Features

This project demonstrates:
- ✅ .NET Framework application development
- ✅ Windows Forms UI design
- ✅ Web application with OWIN
- ✅ REST API implementation
- ✅ Security best practices
- ✅ CI/CD with GitHub Actions

### Security Learning
This application was built to demonstrate:
1. Common security vulnerabilities (17 total)
2. How to identify and analyze them
3. How to fix them properly

**All vulnerabilities have been fixed!** See [SECURITY_FIXES.md](SECURITY_FIXES.md) for details.

---

## 💡 Tips

### Desktop Calculator
- Press `Ctrl+C` to exit
- Enter numbers directly from keyboard
- Use menu numbers (1-6) to select operations

### Web Calculator
- Use keyboard numbers and operators
- Responsive design works on tablets
- Modern UI with smooth animations

### Development
```powershell
# Watch for changes (requires additional setup)
dotnet watch run

# Build both versions at once
dotnet build Calculator.csproj; dotnet build CalculatorWeb.csproj

# Clean build artifacts
Remove-Item -Recurse -Force bin, obj
```

---

## 🌐 Web Calculator Features

- **Modern UI** - Clean, calculator-like interface
- **Responsive** - Works on desktop, tablet, mobile
- **History Display** - Shows calculation history
- **Error Handling** - Clear error messages
- **Security** - All vulnerabilities fixed
- **Fast** - Instant calculations via REST API

---

## 🖥️ Desktop Calculator Features

- **Classic UI** - Familiar Windows Forms interface
- **Interactive** - Console-based menu system
- **Continuous** - Multiple calculations in one session
- **Clear Output** - Formatted results
- **Error Handling** - Handles invalid inputs gracefully

---

## 📱 System Requirements

### Minimum
- Windows 7 or later
- .NET Framework 4.8
- 50 MB disk space
- 256 MB RAM

### Recommended
- Windows 10/11
- .NET Framework 4.8
- 100 MB disk space
- 512 MB RAM

---

## 🎉 You're Ready!

You now have a fully functional calculator application with:
- ✅ Desktop version
- ✅ Web version
- ✅ Secure codebase
- ✅ CI/CD pipeline ready
- ✅ Production-ready builds

### Quick Commands Summary
```powershell
# Desktop
.\bin\Release\net48\Calculator.exe

# Web
.\bin\Release\net48\CalculatorWeb.exe
# http://localhost:5000

# Build
dotnet build Calculator.csproj --configuration Release
dotnet build CalculatorWeb.csproj --configuration Release
```

---

## 🆘 Need Help?

1. **Check Documentation:**
   - [INDEX.md](INDEX.md) - Complete documentation index
   - [README.md](README.md) - Main documentation
   - [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Command cheat sheet

2. **Troubleshooting:**
   - Check the troubleshooting sections above
   - Review [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
   - Ensure .NET Framework 4.8 is installed

3. **For Security Questions:**
   - [SECURITY_VERIFICATION_REPORT.md](SECURITY_VERIFICATION_REPORT.md)
   - [SECURITY_FIXES.md](SECURITY_FIXES.md)

---

**Happy Calculating! 🧮**

---

*Last Updated: May 6, 2026*  
*Project Status: ✅ Complete and Production Ready*
