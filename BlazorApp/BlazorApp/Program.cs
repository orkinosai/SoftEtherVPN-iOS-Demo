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

// Bind configuration to strongly typed models
var appConfig = new AppConfiguration();
builder.Configuration.GetSection("AppSettings").Bind(appConfig);

var applicationSettings = new ApplicationSettings();
builder.Configuration.GetSection("ApplicationSettings").Bind(applicationSettings);

var emailSettings = new EmailSettings();
builder.Configuration.GetSection("EmailSettings").Bind(emailSettings);

var blobStorageSettings = new BlobStorageSettings();
builder.Configuration.GetSection("BlobStorageSettings").Bind(blobStorageSettings);

var applicationInsightsSettings = new ApplicationInsightsSettings();
builder.Configuration.GetSection("ApplicationInsights").Bind(applicationInsightsSettings);

var diagnosticsSettings = new DiagnosticsSettings();
builder.Configuration.GetSection("Diagnostics").Bind(diagnosticsSettings);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// Register configuration as singleton services
builder.Services.AddSingleton(appConfig);
builder.Services.AddSingleton(applicationSettings);
builder.Services.AddSingleton(emailSettings);
builder.Services.AddSingleton(blobStorageSettings);
builder.Services.AddSingleton(applicationInsightsSettings);
builder.Services.AddSingleton(diagnosticsSettings);

// Log configuration values to verify they're loaded from appsettings.json only
builder.Services.AddSingleton<IHostedService>(provider =>
{
    var logger = provider.GetRequiredService<ILogger<ConfigurationLoggingService>>();
    var config = provider.GetRequiredService<AppConfiguration>();
    var appSettings = provider.GetRequiredService<ApplicationSettings>();
    var emailConfig = provider.GetRequiredService<EmailSettings>();
    var blobConfig = provider.GetRequiredService<BlobStorageSettings>();
    var aiConfig = provider.GetRequiredService<ApplicationInsightsSettings>();
    var diagConfig = provider.GetRequiredService<DiagnosticsSettings>();
    
    return new ConfigurationLoggingService(logger, config, appSettings, emailConfig, blobConfig, aiConfig, diagConfig);
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
