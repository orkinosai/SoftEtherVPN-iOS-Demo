namespace BlazorApp.Models
{
    public class AppConfiguration
    {
        public bool UseMockData { get; set; }
        public MockDataSettings MockDataSettings { get; set; } = new();
        public string ApplicationTitle { get; set; } = string.Empty;
        public Features Features { get; set; } = new();
    }

    public class MockDataSettings
    {
        public bool AccommodationFormsEnabled { get; set; }
        public int MaxFormsPerUser { get; set; }
        public string DefaultLocation { get; set; } = string.Empty;
    }

    public class Features
    {
        public bool EnableNotifications { get; set; }
        public bool EnableReporting { get; set; }
        public bool EnableAdvancedSearch { get; set; }
    }

    public class ApplicationSettings
    {
        public string ApplicationName { get; set; } = string.Empty;
        public string ApplicationUrl { get; set; } = string.Empty;
        public int TokenExpirationMinutes { get; set; }
        public int TokenLength { get; set; }
    }

    public class EmailSettings
    {
        public string CompanyEmail { get; set; } = string.Empty;
        public string FromEmail { get; set; } = string.Empty;
        public string FromName { get; set; } = string.Empty;
        public string SmtpPassword { get; set; } = string.Empty;
        public int SmtpPort { get; set; }
        public string SmtpServer { get; set; } = string.Empty;
        public string SmtpUsername { get; set; } = string.Empty;
        public bool UseSsl { get; set; }
    }

    public class BlobStorageSettings
    {
        public string ConnectionString { get; set; } = string.Empty;
        public string ContainerName { get; set; } = string.Empty;
    }

    public class ApplicationInsightsSettings
    {
        public string ConnectionString { get; set; } = string.Empty;
        public string AgentExtensionVersion { get; set; } = string.Empty;
        public string Mode { get; set; } = string.Empty;
    }

    public class DiagnosticsSettings
    {
        public int AzureBlobRetentionInDays { get; set; }
        public int WebsiteHttpLoggingRetentionDays { get; set; }
    }
}