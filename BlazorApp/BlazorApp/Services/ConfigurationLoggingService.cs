using BlazorApp.Models;

public class ConfigurationLoggingService : IHostedService
{
    private readonly ILogger<ConfigurationLoggingService> _logger;
    private readonly AppConfiguration _config;

    public ConfigurationLoggingService(ILogger<ConfigurationLoggingService> logger, AppConfiguration config)
    {
        _logger = logger;
        _config = config;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("=== Configuration Loaded from appsettings.json ===");
        _logger.LogInformation($"Application Title: {_config.ApplicationTitle}");
        _logger.LogInformation($"Use Mock Data: {_config.UseMockData}");
        _logger.LogInformation($"Accommodation Forms Enabled: {_config.MockDataSettings.AccommodationFormsEnabled}");
        _logger.LogInformation($"Max Forms Per User: {_config.MockDataSettings.MaxFormsPerUser}");
        _logger.LogInformation($"Default Location: {_config.MockDataSettings.DefaultLocation}");
        _logger.LogInformation($"Enable Notifications: {_config.Features.EnableNotifications}");
        _logger.LogInformation($"Enable Reporting: {_config.Features.EnableReporting}");
        _logger.LogInformation($"Enable Advanced Search: {_config.Features.EnableAdvancedSearch}");
        _logger.LogInformation("=== End Configuration ===");

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}