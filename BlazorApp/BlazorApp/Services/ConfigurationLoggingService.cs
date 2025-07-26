using BlazorApp.Models;

public class ConfigurationLoggingService : IHostedService
{
    private readonly ILogger<ConfigurationLoggingService> _logger;
    private readonly AppConfiguration _config;
    private readonly ApplicationSettings _applicationSettings;
    private readonly EmailSettings _emailSettings;
    private readonly BlobStorageSettings _blobStorageSettings;
    private readonly ApplicationInsightsSettings _applicationInsightsSettings;
    private readonly DiagnosticsSettings _diagnosticsSettings;

    public ConfigurationLoggingService(
        ILogger<ConfigurationLoggingService> logger, 
        AppConfiguration config,
        ApplicationSettings applicationSettings,
        EmailSettings emailSettings,
        BlobStorageSettings blobStorageSettings,
        ApplicationInsightsSettings applicationInsightsSettings,
        DiagnosticsSettings diagnosticsSettings)
    {
        _logger = logger;
        _config = config;
        _applicationSettings = applicationSettings;
        _emailSettings = emailSettings;
        _blobStorageSettings = blobStorageSettings;
        _applicationInsightsSettings = applicationInsightsSettings;
        _diagnosticsSettings = diagnosticsSettings;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("=== Configuration Loaded from appsettings.json ===");
        
        // AppSettings section
        _logger.LogInformation($"Application Title: {_config.ApplicationTitle}");
        _logger.LogInformation($"Use Mock Data: {_config.UseMockData}");
        _logger.LogInformation($"Accommodation Forms Enabled: {_config.MockDataSettings.AccommodationFormsEnabled}");
        _logger.LogInformation($"Max Forms Per User: {_config.MockDataSettings.MaxFormsPerUser}");
        _logger.LogInformation($"Default Location: {_config.MockDataSettings.DefaultLocation}");
        _logger.LogInformation($"Enable Notifications: {_config.Features.EnableNotifications}");
        _logger.LogInformation($"Enable Reporting: {_config.Features.EnableReporting}");
        _logger.LogInformation($"Enable Advanced Search: {_config.Features.EnableAdvancedSearch}");
        
        // ApplicationSettings section
        _logger.LogInformation($"Application Name: {_applicationSettings.ApplicationName}");
        _logger.LogInformation($"Application URL: {_applicationSettings.ApplicationUrl}");
        _logger.LogInformation($"Token Expiration Minutes: {_applicationSettings.TokenExpirationMinutes}");
        _logger.LogInformation($"Token Length: {_applicationSettings.TokenLength}");
        
        // EmailSettings section
        _logger.LogInformation($"Company Email: {_emailSettings.CompanyEmail}");
        _logger.LogInformation($"From Email: {_emailSettings.FromEmail}");
        _logger.LogInformation($"From Name: {_emailSettings.FromName}");
        _logger.LogInformation($"SMTP Server: {_emailSettings.SmtpServer}");
        _logger.LogInformation($"SMTP Port: {_emailSettings.SmtpPort}");
        _logger.LogInformation($"SMTP Username: {_emailSettings.SmtpUsername}");
        _logger.LogInformation($"Use SSL: {_emailSettings.UseSsl}");
        
        // BlobStorageSettings section
        _logger.LogInformation($"Blob Container Name: {_blobStorageSettings.ContainerName}");
        _logger.LogInformation($"Blob Connection String: {(!string.IsNullOrEmpty(_blobStorageSettings.ConnectionString) ? "[CONFIGURED]" : "[NOT SET]")}");
        
        // ApplicationInsights section
        _logger.LogInformation($"Application Insights Mode: {_applicationInsightsSettings.Mode}");
        _logger.LogInformation($"Application Insights Agent Version: {_applicationInsightsSettings.AgentExtensionVersion}");
        _logger.LogInformation($"Application Insights Connection: {(!string.IsNullOrEmpty(_applicationInsightsSettings.ConnectionString) ? "[CONFIGURED]" : "[NOT SET]")}");
        
        // Diagnostics section
        _logger.LogInformation($"Azure Blob Retention Days: {_diagnosticsSettings.AzureBlobRetentionInDays}");
        _logger.LogInformation($"Website HTTP Logging Retention Days: {_diagnosticsSettings.WebsiteHttpLoggingRetentionDays}");
        
        _logger.LogInformation("=== End Configuration ===");

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}