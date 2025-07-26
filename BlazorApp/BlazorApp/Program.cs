using BlazorApp.Components;
using BlazorApp.Models;

// Create builder with explicit configuration setup
var builder = WebApplication.CreateBuilder();

// Clear default configuration sources and add only JSON files
builder.Configuration.Sources.Clear();

// Explicitly load appsettings.json and environment-specific appsettings
builder.Configuration
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true);

// Note: Intentionally NOT adding Environment Variables to ensure only appsettings.json is used
// .AddEnvironmentVariables() is omitted to meet requirement of using only appsettings.json

// Bind configuration to strongly typed model
var appConfig = new AppConfiguration();
builder.Configuration.GetSection("AppSettings").Bind(appConfig);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// Register configuration as singleton service
builder.Services.AddSingleton(appConfig);

// Log configuration values to verify they're loaded from appsettings.json only
builder.Services.AddSingleton<IHostedService>(provider =>
{
    var logger = provider.GetRequiredService<ILogger<ConfigurationLoggingService>>();
    var config = provider.GetRequiredService<AppConfiguration>();
    
    return new ConfigurationLoggingService(logger, config);
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
