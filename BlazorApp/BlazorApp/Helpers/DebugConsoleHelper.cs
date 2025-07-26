using Microsoft.JSInterop;
using System.Text.Json;

namespace BlazorApp.Helpers
{
    /// <summary>
    /// Static helper class for logging debug information to the browser console using Blazor JS interop.
    /// </summary>
    public static class DebugConsoleHelper
    {
        /// <summary>
        /// Logs a message and optional data object to the browser console.
        /// </summary>
        /// <param name="js">The IJSRuntime instance for JS interop</param>
        /// <param name="message">The debug message to log</param>
        /// <param name="data">Optional data object to serialize and log</param>
        /// <returns>Task representing the async operation</returns>
        public static async Task LogAsync(IJSRuntime js, string message, object? data = null)
        {
            try
            {
                if (data != null)
                {
                    var jsonData = JsonSerializer.Serialize(data, new JsonSerializerOptions
                    {
                        WriteIndented = true,
                        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                    });
                    await js.InvokeVoidAsync("console.log", $"[DEBUG] {message}", jsonData);
                }
                else
                {
                    await js.InvokeVoidAsync("console.log", $"[DEBUG] {message}");
                }
            }
            catch (Exception ex)
            {
                // Fallback to regular console log if JS interop fails
                Console.WriteLine($"[DEBUG] {message} (JS interop failed: {ex.Message})");
                if (data != null)
                {
                    Console.WriteLine($"Data: {JsonSerializer.Serialize(data)}");
                }
            }
        }

        /// <summary>
        /// Logs an error message and optional data object to the browser console using console.error.
        /// </summary>
        /// <param name="js">The IJSRuntime instance for JS interop</param>
        /// <param name="message">The error message to log</param>
        /// <param name="data">Optional data object to serialize and log</param>
        /// <returns>Task representing the async operation</returns>
        public static async Task ErrorAsync(IJSRuntime js, string message, object? data = null)
        {
            try
            {
                if (data != null)
                {
                    var jsonData = JsonSerializer.Serialize(data, new JsonSerializerOptions
                    {
                        WriteIndented = true,
                        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                    });
                    await js.InvokeVoidAsync("console.error", $"[ERROR] {message}", jsonData);
                }
                else
                {
                    await js.InvokeVoidAsync("console.error", $"[ERROR] {message}");
                }
            }
            catch (Exception ex)
            {
                // Fallback to regular console log if JS interop fails
                Console.WriteLine($"[ERROR] {message} (JS interop failed: {ex.Message})");
                if (data != null)
                {
                    Console.WriteLine($"Data: {JsonSerializer.Serialize(data)}");
                }
            }
        }
    }
}