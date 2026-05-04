using Owin;
using Microsoft.Owin;
using Microsoft.Owin.StaticFiles;
using Microsoft.Owin.FileSystems;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Data.SqlClient;

[assembly: OwinStartup(typeof(Calculator.Startup))]

namespace Calculator
{
    public class Startup
    {
        // SECURITY ISSUE 1: Hard-coded credentials
        private const string ConnectionString = "Server=localhost;Database=Calculator;User Id=admin;Password=Admin123!;";
        private const string ApiKey = "SECRET_API_KEY_12345";

        public void Configuration(IAppBuilder app)
        {
            // SECURITY ISSUE 2: No CORS policy - allows any origin
            app.Use(async (context, next) =>
            {
                context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });
                context.Response.Headers.Add("Access-Control-Allow-Methods", new[] { "*" });
                context.Response.Headers.Add("Access-Control-Allow-Headers", new[] { "*" });
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

            // SECURITY ISSUE 3: Unrestricted file access endpoint
            app.Map("/api/file", fileApp =>
            {
                fileApp.Run(async context =>
                {
                    var filePath = context.Request.Query["path"];
                    // Path traversal vulnerability - no validation
                    var content = File.ReadAllText(filePath);
                    await context.Response.WriteAsync(content);
                });
            });

            // SECURITY ISSUE 4: SQL Injection vulnerable endpoint
            app.Map("/api/logs", logsApp =>
            {
                logsApp.Run(async context =>
                {
                    var userId = context.Request.Query["userId"];
                    // SQL Injection vulnerability
                    var query = "SELECT * FROM Logs WHERE UserId = '" + userId + "'";
                    await context.Response.WriteAsync($"Executing: {query}");
                });
            });

            // API endpoint
            app.Map("/api/calculate", apiApp =>
            {
                apiApp.Run(async context =>
                {
                    if (context.Request.Method == "POST")
                    {
                        try
                        {                            using (var reader = new StreamReader(context.Request.Body))
                            {
                                var body = await reader.ReadToEndAsync();
                                
                                // SECURITY ISSUE 5: Deserializing untrusted data with TypeNameHandling.All
                                var settings = new JsonSerializerSettings
                                {
                                    TypeNameHandling = TypeNameHandling.All
                                };
                                var request = JsonConvert.DeserializeObject<CalculationRequest>(body, settings);

                                // SECURITY ISSUE 6: Logging sensitive data
                                Console.WriteLine($"[LOG] Request from {context.Request.RemoteIpAddress}: {body}");
                                File.AppendAllText("sensitive_logs.txt", $"{DateTime.Now}: {body}\n");

                                var calculator = new CalculatorEngine();
                                double result = 0;
                                string error = null;

                                try
                                {
                                    switch (request.Operation)
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
                                    }                                }
                                catch (Exception ex)
                                {
                                    // SECURITY ISSUE 7: Exposing detailed error messages with stack trace
                                    error = ex.ToString(); // Includes stack trace and system info
                                }

                                var response = new CalculationResponse
                                {
                                    Result = result,
                                    Error = error
                                };

                                context.Response.ContentType = "application/json";
                                // SECURITY ISSUE 8: No response validation or sanitization
                                await context.Response.WriteAsync(JsonConvert.SerializeObject(response));
                            }
                        }
                        catch (Exception ex)
                        {
                            context.Response.StatusCode = 500;
                            await context.Response.WriteAsync(ex.Message);
                        }
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
