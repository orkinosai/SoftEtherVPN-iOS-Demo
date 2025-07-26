# Azure Deployment Guide

## Overview

This guide explains how to deploy the Azure Accommodation Application Form BlazorApp to Azure App Service with appsettings.json-only configuration.

## Prerequisites

- Azure subscription
- Azure CLI or Azure Portal access
- .NET 8.0 SDK (for local building)

## Deployment Steps

### 1. Prepare Application for Deployment

```bash
cd BlazorApp
dotnet publish -c Release -o publish
```

Verify that appsettings.json files are included in the publish output:
```bash
ls publish/appsettings*
# Should show:
# publish/appsettings.json
# publish/appsettings.Development.json
```

### 2. Create Azure App Service

#### Using Azure CLI
```bash
# Create resource group
az group create --name myResourceGroup --location "East US"

# Create App Service plan
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku FREE

# Create web app
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name myUniqueAppName --runtime "DOTNET|8.0"
```

#### Using Azure Portal
1. Navigate to Azure Portal
2. Create new App Service
3. Select .NET 8.0 runtime
4. Choose appropriate pricing tier

### 3. Configure Environment

Set the environment variable for the app:

#### Using Azure CLI
```bash
az webapp config appsettings set --resource-group myResourceGroup --name myUniqueAppName --settings ASPNETCORE_ENVIRONMENT=Development
```

#### Using Azure Portal
1. Go to your App Service
2. Navigate to Configuration → Application settings
3. Add new setting: `ASPNETCORE_ENVIRONMENT` = `Development` (or `Production`)

### 4. Deploy Application

#### Option A: Using Azure CLI
```bash
# Deploy from publish folder
az webapp deploy --resource-group myResourceGroup --name myUniqueAppName --src-path publish.zip --type zip
```

#### Option B: Using Visual Studio
1. Right-click project → Publish
2. Choose Azure App Service
3. Select your subscription and app service
4. Publish

#### Option C: Using GitHub Actions
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Azure
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v1
      with:
        dotnet-version: 8.0.x
        
    - name: Publish
      run: dotnet publish BlazorApp/BlazorApp.csproj -c Release -o publish
      
    - name: Deploy to Azure
      uses: azure/webapps-deploy@v2
      with:
        app-name: myUniqueAppName
        publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
        package: publish
```

### 5. Verify Deployment

1. Navigate to your App Service URL
2. Check the application logs in Azure Portal:
   - Go to App Service → Monitoring → Log stream
   - Verify configuration logging shows correct values from appsettings.json

Expected log output:
```
=== Configuration Loaded from appsettings.json ===
Application Title: Azure Accommodation Application Form (Development)
Use Mock Data: True
Accommodation Forms Enabled: True
Max Forms Per User: 10
Default Location: Development Environment
...
=== End Configuration ===
```

## Environment Configuration

### Development Environment
- Uses `appsettings.Development.json` overrides
- Enhanced logging enabled
- Mock data enabled with higher limits

### Production Environment
- Uses `appsettings.json` base configuration
- Reduced logging
- Production-appropriate mock data settings

## Configuration Verification

The application logs its configuration at startup, allowing you to verify:

1. **Configuration Source**: Confirms values are loaded from appsettings.json
2. **Environment Detection**: Shows which environment-specific file is used
3. **Mock Data Settings**: Displays current mock data configuration
4. **Feature Flags**: Shows enabled/disabled features

## Security Considerations

1. **No Secrets in appsettings.json**: Store sensitive data in Azure Key Vault if needed
2. **Environment Variables**: Only `ASPNETCORE_ENVIRONMENT` should be set
3. **Application Settings**: No application configuration in Azure App Service settings

## Troubleshooting

### Common Issues

1. **Configuration not loading**:
   - Verify appsettings.json files are in the deployment package
   - Check file permissions and accessibility

2. **Wrong environment configuration**:
   - Verify `ASPNETCORE_ENVIRONMENT` is set correctly
   - Check that corresponding appsettings.{Environment}.json exists

3. **Application not starting**:
   - Check application logs in Azure Portal
   - Verify .NET 8.0 runtime is selected

### Diagnostic Commands

```bash
# Check deployed files
az webapp ssh --resource-group myResourceGroup --name myUniqueAppName
# Then: ls -la /home/site/wwwroot/

# View application logs
az webapp log tail --resource-group myResourceGroup --name myUniqueAppName
```

## Monitoring

1. **Application Insights**: Enable for detailed telemetry
2. **Log Stream**: Real-time log monitoring
3. **Metrics**: Monitor application performance
4. **Alerts**: Set up alerts for application health

## Scaling

- **Scale Up**: Increase instance size for more CPU/memory
- **Scale Out**: Add more instances for higher availability
- **Auto-scaling**: Configure based on metrics

The application is stateless and configuration-driven, making it suitable for horizontal scaling.