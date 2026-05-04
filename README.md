# .NET Framework Calculator Application

A simple console-based calculator application built with .NET Framework 4.8.

## Features

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
