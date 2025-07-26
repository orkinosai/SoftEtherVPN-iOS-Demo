using System.ComponentModel.DataAnnotations;

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

    /// <summary>
    /// Model for demo form submission to demonstrate debug console logging.
    /// </summary>
    public class FormSubmissionModel
    {
        [Required(ErrorMessage = "Email address is required")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address")]
        public string Email { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string Name { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "Subject is required")]
        [StringLength(200, ErrorMessage = "Subject cannot exceed 200 characters")]
        public string Subject { get; set; } = string.Empty;
        
        [StringLength(1000, ErrorMessage = "Message cannot exceed 1000 characters")]
        public string Message { get; set; } = string.Empty;
        
        public bool IncludePdf { get; set; } = true;
        public DateTime SubmittedAt { get; set; } = DateTime.UtcNow;
    }

    /// <summary>
    /// Model for API response simulation.
    /// </summary>
    public class ApiResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string TransactionId { get; set; } = string.Empty;
        public DateTime ProcessedAt { get; set; } = DateTime.UtcNow;
    }
}