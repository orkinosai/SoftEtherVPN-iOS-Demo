# Configuration Guide

## Overview

This BlazorApp has been configured to use **only** appsettings.json for configuration, with environment variables explicitly disabled to meet the requirement of using appsettings.json as the sole configuration source.

## Configuration Setup

### Program.cs Changes

The application has been configured with the following key changes in `Program.cs`:

1. **Explicit Configuration Source Management**: The default configuration sources are cleared and only JSON files are added:
   ```csharp
   // Clear default configuration sources and add only JSON files
   builder.Configuration.Sources.Clear();
   
   // Explicitly load appsettings.json and environment-specific appsettings
   builder.Configuration
       .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
       .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true, reloadOnChange: true);
   ```

2. **Environment Variables Disabled**: The `AddEnvironmentVariables()` method is intentionally omitted to prevent environment variables from overriding configuration.

3. **Configuration Binding**: The configuration is bound to a strongly-typed model and registered as a singleton service.

### Project File Configuration

The `BlazorApp.csproj` file has been updated to ensure appsettings.json files are included in the publish output:

```xml
<ItemGroup>
  <Content Update="appsettings.json">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    <CopyToPublishDirectory>PreserveNewest</CopyToPublishDirectory>
  </Content>
  <Content Update="appsettings.Development.json">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    <CopyToPublishDirectory>PreserveNewest</CopyToPublishDirectory>
  </Content>
</ItemGroup>
```

## Configuration Files

### appsettings.json (Base Configuration)
- Contains the main application configuration
- Includes mock data settings suitable for production/staging
- Sets base feature flags

### appsettings.Development.json (Development Override)
- Extends the base configuration for development
- Enables additional features for debugging
- Uses development-specific values

## Configuration Structure

The configuration uses the following structure:

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

## Verification

When the application starts, it logs all configuration values to verify they are loaded from appsettings.json only:

```
=== Configuration Loaded from appsettings.json ===
Application Title: Azure Accommodation Application Form (Development)
Use Mock Data: True
Accommodation Forms Enabled: True
Max Forms Per User: 10
Default Location: Development Environment
Enable Notifications: True
Enable Reporting: True
Enable Advanced Search: True
=== End Configuration ===
```

## Deployment Considerations

1. **Azure App Service**: The appsettings.json file will be deployed with the application and used as the primary configuration source.

2. **Environment Switching**: To switch between environments, set the `ASPNETCORE_ENVIRONMENT` environment variable to the desired environment name (Development, Staging, Production).

3. **No Environment Variable Dependencies**: The application will ignore any environment variables for configuration, ensuring consistent behavior across environments.

## Testing

To verify the configuration is working correctly:

1. Build the application: `dotnet build`
2. Run the application: `dotnet run`
3. Check the console output for configuration logging
4. Publish the application: `dotnet publish` and verify appsettings.json files are included in the output