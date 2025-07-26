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
}