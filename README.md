# .NET Framework Calculator Application

[![Build Status](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Build%20.NET%20Framework%20Calculator/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions)
![Security](https://img.shields.io/badge/Security-Fixed-green)

A modern calculator application built with .NET Framework 4.8, available in both **Windows Forms (desktop)** and **Web** versions.

## ✅ SECURITY STATUS: ALL VULNERABILITIES FIXED

**This application has been secured** - All 17 security vulnerabilities have been remediated.

### 🛡️ Security Improvements Implemented:
- ✅ Credentials moved to environment variables
- ✅ Proper CORS policy implemented
- ✅ Security headers added (CSP, X-Frame-Options, etc.)
- ✅ Unsafe endpoints removed (file access, SQL injection)
- ✅ Secure deserialization implemented
- ✅ Input validation added
- ✅ XSS vulnerabilities fixed (using textContent)
- ✅ Secrets removed from client-side code
- ✅ SRI added to external scripts
- ✅ Inline scripts removed
- ✅ Sensitive data removed from comments
- ✅ Generic error messages for clients
- ✅ Sanitized logging implemented

📖 **See [SECURITY_FIXES.md](SECURITY_FIXES.md) for detailed remediation documentation**

---

## 🚀 Features

- **Addition**: Add two numbers
- **Subtraction**: Subtract one number from another
- **Multiplication**: Multiply two numbers
- **Division**: Divide one number by another (with zero-division protection)
- **Power**: Raise a number to a power
- **Square Root**: Calculate the square root of a number
- **Error Handling**: Comprehensive error handling for invalid inputs
- **Interactive Loop**: Perform multiple calculations in one session

## Project Structure

```
Calculator/
├── Calculator.csproj       # Project file
├── App.config             # Application configuration
├── Program.cs             # Main entry point and UI logic
├── CalculatorEngine.cs    # Calculator logic/engine
├── Properties/
│   └── AssemblyInfo.cs   # Assembly metadata
└── README.md             # This file
```

## Building the Application

### Using MSBuild (Command Line)
```powershell
msbuild Calculator.csproj /p:Configuration=Release
```

### Using Visual Studio
1. Open `Calculator.csproj` in Visual Studio
2. Press `Ctrl+Shift+B` to build the solution
3. Or go to **Build** → **Build Solution**

## Running the Application

After building, run the executable:
```powershell
.\bin\Debug\Calculator.exe
```

Or run directly with:
```powershell
dotnet run
```

## Usage Example

```
=======================================
    .NET Framework Calculator App
=======================================

Enter first number: 10
Select operation:
1. Addition (+)
2. Subtraction (-)
3. Multiplication (*)
4. Division (/)
5. Power (^)
6. Square Root (√)

Enter your choice (1-6): 1
Enter second number: 5

10 + 5 = 15

---------------------------------------

Do you want to perform another calculation? (y/n): n
Thank you for using the Calculator!
```

## Requirements

- .NET Framework 4.8
- Windows Operating System
- Visual Studio 2015 or later (for development)

## License

This is a sample application for demonstration purposes.
