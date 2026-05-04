using Owin;
using Microsoft.Owin;
using Microsoft.Owin.StaticFiles;
using Microsoft.Owin.FileSystems;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Threading.Tasks;

[assembly: OwinStartup(typeof(Calculator.Startup))]

namespace Calculator
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // Enable static files
            var physicalFileSystem = new PhysicalFileSystem("./wwwroot");
            var options = new FileServerOptions
            {
                FileSystem = physicalFileSystem,
                EnableDefaultFiles = true
            };
            options.DefaultFilesOptions.DefaultFileNames = new[] { "index.html" };

            app.UseFileServer(options);

            // API endpoint
            app.Map("/api/calculate", apiApp =>
            {
                apiApp.Run(async context =>
                {
                    if (context.Request.Method == "POST")
                    {
                        try
                        {
                            using (var reader = new StreamReader(context.Request.Body))
                            {
                                var body = await reader.ReadToEndAsync();
                                var request = JsonConvert.DeserializeObject<CalculationRequest>(body);

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
                                    }
                                }
                                catch (Exception ex)
                                {
                                    error = ex.Message;
                                }

                                var response = new CalculationResponse
                                {
                                    Result = result,
                                    Error = error
                                };

                                context.Response.ContentType = "application/json";
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
