using Microsoft.Owin.Hosting;
using System;

namespace Calculator
{
    public class WebProgram
    {
        public static void Main(string[] args)
        {
            string url = "http://localhost:5000";

            Console.WriteLine("╔════════════════════════════════════════════════════╗");
            Console.WriteLine("║   .NET Framework Calculator - Web Application     ║");
            Console.WriteLine("╚════════════════════════════════════════════════════╝");
            Console.WriteLine();
            Console.WriteLine($"🌐 Server starting on: {url}");
            Console.WriteLine();
            Console.WriteLine("   Open your browser and navigate to:");
            Console.WriteLine($"   👉 {url}");
            Console.WriteLine();
            Console.WriteLine("   Press Ctrl+C to stop the server.");
            Console.WriteLine("════════════════════════════════════════════════════");
            Console.WriteLine();

            try
            {
                using (WebApp.Start<Startup>(url))
                {
                    Console.WriteLine("✅ Server is running...");
                    Console.WriteLine();
                    Console.ReadLine();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error starting server: {ex.Message}");
                Console.WriteLine();
                Console.WriteLine("Press any key to exit...");
                Console.ReadKey();
            }
        }
    }
}
