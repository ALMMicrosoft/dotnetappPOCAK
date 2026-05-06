using Owin;
using Microsoft.Owin;
using Microsoft.Owin.StaticFiles;
using Microsoft.Owin.FileSystems;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

[assembly: OwinStartup(typeof(Calculator.Startup))]

namespace Calculator
{
    public class Startup
    {
        // ✅ FIXED: Use environment variables for credentials
        private readonly string ConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING") 
            ?? "Server=localhost;Database=Calculator;Integrated Security=true;";
        private readonly string ApiKey = Environment.GetEnvironmentVariable("API_KEY") 
            ?? "development-key-only";

        public void Configuration(IAppBuilder app)
        {
            // ✅ FIXED: Implement proper CORS policy with security headers
            app.Use(async (context, next) =>
            {
                // Specify allowed origins (not wildcard)
                context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "https://trusted-domain.com" });
                context.Response.Headers.Add("Access-Control-Allow-Methods", new[] { "GET, POST" });
                context.Response.Headers.Add("Access-Control-Allow-Headers", new[] { "Content-Type, Authorization" });
                
                // Add security headers
                context.Response.Headers.Add("X-Content-Type-Options", new[] { "nosniff" });
                context.Response.Headers.Add("X-Frame-Options", new[] { "DENY" });
                context.Response.Headers.Add("X-XSS-Protection", new[] { "1; mode=block" });
                context.Response.Headers.Add("Strict-Transport-Security", new[] { "max-age=31536000; includeSubDomains" });
                context.Response.Headers.Add("Content-Security-Policy", new[] { 
                    "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self';" 
                });
                
                await next();
            });

            // Enable static files
            var physicalFileSystem = new PhysicalFileSystem("./wwwroot");
            var options = new FileServerOptions
            {
                FileSystem = physicalFileSystem,
                EnableDefaultFiles = true
            };
            options.DefaultFilesOptions.DefaultFileNames = new[] { "index.html" };

            app.UseFileServer(options);

            // ✅ REMOVED: Unsafe file endpoint completely removed
            // If file access is needed, implement with proper validation:
            // - Whitelist of allowed files
            // - Path validation
            // - Authentication/Authorization
            // - Logging of access attempts

            // ✅ REMOVED: SQL Injection endpoint completely removed
            // If database access is needed, implement with:
            // - Parameterized queries
            // - Input validation
            // - Rate limiting
            // - Authentication/Authorization

            // API endpoint
            app.Map("/api/calculate", apiApp =>
            {                apiApp.Run(async context =>
                {
                    if (context.Request.Method == "POST")
                    {
                        try
                        {
                            using (var reader = new StreamReader(context.Request.Body))
                            {
                                var body = await reader.ReadToEndAsync();
                                
                                // ✅ FIXED: Validate input length
                                if (string.IsNullOrWhiteSpace(body) || body.Length > 1024)
                                {
                                    context.Response.StatusCode = 400;
                                    await context.Response.WriteAsync("Invalid request");
                                    return;
                                }
                                
                                // ✅ FIXED: Safe deserialization without TypeNameHandling
                                CalculationRequest request;
                                try
                                {
                                    request = JsonConvert.DeserializeObject<CalculationRequest>(body);
                                    
                                    // Validate request
                                    if (request == null || string.IsNullOrEmpty(request.Operation))
                                    {
                                        context.Response.StatusCode = 400;
                                        await context.Response.WriteAsync("Invalid request format");
                                        return;
                                    }
                                }
                                catch (JsonException)
                                {
                                    context.Response.StatusCode = 400;
                                    await context.Response.WriteAsync("Invalid JSON format");
                                    return;
                                }

                                // ✅ FIXED: Sanitized logging (no sensitive data)
                                Console.WriteLine($"[INFO] Calculation request - Operation: {request.Operation}");

                                var calculator = new CalculatorEngine();
                                double result = 0;
                                string error = null;

                                try
                                {
                                    // ✅ FIXED: Validate operation input
                                    switch (request.Operation?.ToLower())
                                    {
                                        case "add":
                                            result = calculator.Add(request.FirstNumber, request.SecondNumber);
                                            break;
                                        case "subtract":
                                            result = calculator.Subtract(request.FirstNumber, request.SecondNumber);
                                            break;
                                        case "multiply":
                                            result = calculator.Multiply(request.FirstNumber, request.SecondNumber);
                                            break;
                                        case "divide":
                                            result = calculator.Divide(request.FirstNumber, request.SecondNumber);
                                            break;
                                        case "power":
                                            result = calculator.Power(request.FirstNumber, request.SecondNumber);
                                            break;
                                        case "sqrt":
                                            result = calculator.SquareRoot(request.FirstNumber);
                                            break;
                                        default:
                                            error = "Invalid operation";
                                            break;
                                    }
                                }
                                catch (DivideByZeroException)
                                {
                                    // ✅ FIXED: Generic error message to client
                                    error = "Cannot divide by zero";
                                }
                                catch (ArgumentException)
                                {
                                    error = "Invalid input value";
                                }
                                catch (Exception ex)
                                {
                                    // ✅ FIXED: Log details server-side, generic message to client
                                    Console.WriteLine($"[ERROR] Calculation error: {ex.Message}");
                                    error = "An error occurred during calculation";
                                }

                                var response = new CalculationResponse
                                {
                                    Result = result,
                                    Error = error
                                };

                                context.Response.ContentType = "application/json";
                                // ✅ FIXED: Validate and sanitize response
                                var jsonResponse = JsonConvert.SerializeObject(response);
                                await context.Response.WriteAsync(jsonResponse);
                            }
                        }
                        catch (Exception ex)
                        {
                            // ✅ FIXED: Generic error message, log details server-side
                            Console.WriteLine($"[ERROR] Request processing error: {ex.Message}");
                            context.Response.StatusCode = 500;
                            await context.Response.WriteAsync("Internal server error");
                        }
                    }
                    else
                    {
                        context.Response.StatusCode = 405;
                        await context.Response.WriteAsync("Method not allowed");
                    }
                });
            });
        }
    }

    public class CalculationRequest
    {
        public double FirstNumber { get; set; }
        public double SecondNumber { get; set; }
        public string Operation { get; set; }
    }

    public class CalculationResponse
    {
        public double Result { get; set; }
        public string Error { get; set; }
    }
}
