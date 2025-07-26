# Azure Accommodation Application Form - BlazorApp

## Overview

This is a minimal Blazor Server application that demonstrates the proper configuration pattern for Azure deployment where **only appsettings.json** is used for configuration, with environment variables explicitly disabled.

## Key Features

- **Configuration from appsettings.json only**: Environment variables are explicitly disabled
- **Mock data support**: Configurable via appsettings.json
- **Environment-specific configuration**: Support for Development, Staging, and Production settings
- **Azure-ready deployment**: appsettings.json files are included in publish output

## Configuration

The application uses a configuration-first approach where all settings are loaded from appsettings.json files:

- `appsettings.json`: Base configuration for all environments
- `appsettings.Development.json`: Development-specific overrides
- `appsettings.{Environment}.json`: Environment-specific overrides

### Sample Configuration

```json
{
  "AppSettings": {
    "UseMockData": true,
    "MockDataSettings": {
      "AccommodationFormsEnabled": true,
      "MaxFormsPerUser": 5,
      "DefaultLocation": "Azure Test Environment"
    },
    "ApplicationTitle": "Azure Accommodation Application Form",
    "Features": {
      "EnableNotifications": true,
      "EnableReporting": false,
      "EnableAdvancedSearch": true
    }
  }
}
```

## Running the Application

### Prerequisites
- .NET 8.0 SDK

### Local Development
```bash
cd BlazorApp
dotnet restore
dotnet run
```

The application will start on `http://localhost:5173` and log the configuration values to verify they're loaded from appsettings.json.

### Building and Publishing
```bash
cd BlazorApp
dotnet build
dotnet publish -c Release -o publish
```

The publish output will include all appsettings.json files for deployment.

## Deployment

The application is designed to be deployed to Azure App Service:

1. All configuration comes from appsettings.json files (no environment variables needed)
2. Set `ASPNETCORE_ENVIRONMENT` to the desired environment (Development, Staging, Production)
3. Deploy the published output including all appsettings.json files

## Architecture

The application follows these principles:

- **Configuration as Code**: All settings are in source control via appsettings.json
- **Environment Isolation**: Environment-specific settings override base settings
- **No Secret Dependencies**: No reliance on external configuration providers
- **Deployment Simplicity**: Self-contained configuration deployment

## Project Structure

```
BlazorApp/
├── Models/
│   └── AppConfiguration.cs      # Configuration model classes
├── Services/
│   └── ConfigurationLoggingService.cs  # Configuration verification service
├── Components/                  # Blazor components (default)
├── appsettings.json            # Base configuration
├── appsettings.Development.json # Development overrides
├── BlazorApp.csproj            # Project file with publish settings
└── Program.cs                  # Application startup with explicit config loading
```

## See Also

- [CONFIGURATION.md](./CONFIGURATION.md) - Detailed configuration documentation
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Azure deployment instructions