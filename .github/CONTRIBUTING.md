# Contributing to .NET Framework Calculator

Thank you for your interest in contributing to the Calculator project! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Screenshots (if applicable)
- Your environment (OS, .NET Framework version)

### Suggesting Enhancements

We welcome feature requests! Please create an issue with:
- A clear description of the enhancement
- Why this enhancement would be useful
- Example use cases

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed
3. **Test your changes**
   - Ensure both Windows Forms and Web versions build successfully
   - Test all calculator functions
4. **Commit your changes**
   - Use clear, descriptive commit messages
   - Reference any related issues
5. **Push to your fork** and submit a pull request

### Development Setup

```powershell
# Clone the repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Restore NuGet packages
dotnet restore Calculator.csproj
dotnet restore CalculatorWeb.csproj

# Build the projects
dotnet build Calculator.csproj
dotnet build CalculatorWeb.csproj

# Copy wwwroot files for Web Calculator
Copy-Item -Path "wwwroot\*" -Destination "bin\Debug\net48\wwwroot\" -Recurse -Force
```

### Code Style

- Use meaningful variable and method names
- Keep methods small and focused
- Add XML documentation comments for public APIs
- Follow C# naming conventions

### Testing

Before submitting a PR:
- [ ] Windows Forms Calculator builds without errors
- [ ] Web Calculator builds without errors
- [ ] All calculator operations work correctly
- [ ] UI displays properly (no cut edges or layout issues)
- [ ] No compiler warnings

## Project Structure

```
├── Calculator.csproj          # Windows Forms application
├── CalculatorWeb.csproj       # Web application
├── CalculatorEngine.cs        # Core calculation logic
├── MainForm.cs               # Windows Forms UI
├── Program.cs                # Windows Forms entry point
├── WebProgram.cs             # Web application entry point
├── Startup.cs                # OWIN configuration
└── wwwroot/                  # Web static files
    ├── index.html
    ├── styles.css
    └── script.js
```

## Questions?

Feel free to create an issue for any questions or clarifications!

Thank you for contributing! 🙏
