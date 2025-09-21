# Azure Web App with Private Endpoint - Ansible Collection

This Ansible collection provides roles and playbooks for deploying Azure Web Apps with private endpoints, custom domains, and SSL certificates.

## Overview

This collection includes the following components:

- **App Service Plan**: Creates Azure App Service Plans with configurable SKUs and regions
- **Web App**: Deploys Azure Web Apps with framework support and app settings
- **Private Endpoint**: Creates private endpoints for secure access to Web Apps
- **Private DNS Zone**: Manages DNS zones for private endpoint resolution
- **Custom Domain**: Configures custom domains and SSL certificates

## Architecture

The deployment creates the following Azure resources:

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Group                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────────────────────┐   │
│  │   VNet          │  │     App Service Plan            │   │
│  │                 │  │                                 │   │
│  │ ┌─────────────┐ │  │  ┌─────────────────────────────┐│   │
│  │ │ Delegated   │ │  │  │        Web App              ││   │
│  │ │ Subnet      │ │  │  │                             ││   │
│  │ │ (App Plan)  │ │  │  │  ┌─────────────────────────┐││   │
│  │ └─────────────┘ │  │  │  │   Private Endpoint      │││   │
│  │                 │  │  │  │   (Non-delegated subnet) │││   │
│  │ ┌─────────────┐ │  │  │  └─────────────────────────┘││   │
│  │ │ Non-delegated│ │  │  └─────────────────────────────┘│   │
│  │ │ Subnet      │ │  │                                 │   │
│  │ │ (Private EP)│ │  │  ┌─────────────────────────────┐│   │
│  │ └─────────────┘ │  │  │    Private DNS Zone        ││   │
│  └─────────────────┘  │  └─────────────────────────────┘│   │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

### 1. Azure CLI Authentication

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Set environment variables
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_AUTH_METHOD="cli"
```

### 2. Ansible Environment

```bash
# Activate the Ansible environment
source ansible-env/bin/activate

# Install required collections
ansible-galaxy collection install azure.azcollection
```

### 3. Required Python Packages

```bash
pip install -r requirements.txt
```

## Quick Start

### 1. Configure Variables

Edit the group variables file for your environment:

```bash
# For development
vim inventories/dev/group_vars/webapp.yml

# For production
vim inventories/prod/group_vars/webapp.yml
```

### 2. Encrypt Sensitive Data (Optional)

```bash
# Create vault file with sensitive data
ansible-vault create inventories/dev/group_vars/vault.yml

# Edit vault file
ansible-vault edit inventories/dev/group_vars/vault.yml
```

### 3. Deploy Web App

```bash
# Deploy to development
ansible-playbook -i inventories/dev playbooks/deploy_webapp.yml

# Deploy to production
ansible-playbook -i inventories/prod playbooks/deploy_webapp.yml --ask-vault-pass
```

## Configuration

### App Service Plan Configuration

```yaml
# App Service Plan settings
app_service_plan_name: "myapp-dev-asp"
sku_name: "P1V2"  # B1, B2, B3, S1, S2, S3, P1, P2, P3, P1V2, P2V2, P3V2, P1V3, P2V3, P3V3
sku_tier: "PremiumV2"
app_service_plan_kind: "Linux"  # Linux or Windows
app_service_plan_reserved: true  # Required for Linux plans
```

### Web App Configuration

```yaml
# Web App settings
webapp_name: "myapp-dev-webapp"
webapp_framework: "python"  # python, node, dotnet, java, php
webapp_framework_version: "3.9"

# App settings
webapp_app_settings:
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: "false"
  WEBSITES_PORT: "8000"
  SCM_DO_BUILD_DURING_DEPLOYMENT: "true"
  # Add your custom settings here
```

### Private Endpoint Configuration

```yaml
# Private Endpoint settings
enable_private_endpoint: true
private_endpoint_name: "myapp-dev-pe"
private_endpoint_group_ids: ["sites"]  # For Web App, use "sites"
```

### Custom Domain Configuration

```yaml
# Custom Domain settings
custom_domain_name: "myapp-dev.example.com"
create_dns_zone: false  # Set to true if you want to create DNS zone
create_ssl_certificate: false  # Set to true if you want to create SSL certificate

# SSL Certificate settings
ssl_cert_path: "/path/to/certificate.pfx"
ssl_cert_password: "{{ vault_ssl_cert_password }}"
```

## Roles

### app_service_plan

Creates Azure App Service Plans with configurable settings.

**Variables:**
- `app_service_plan_name`: Name of the App Service Plan
- `resource_group_name`: Resource group name
- `location`: Azure region
- `sku_name`: SKU name (B1, B2, B3, S1, S2, S3, P1, P2, P3, P1V2, P2V2, P3V2, P1V3, P2V3, P3V3)
- `sku_tier`: SKU tier (Free, Basic, Standard, Premium, PremiumV2, PremiumV3)
- `app_service_plan_kind`: Plan kind (Linux or Windows)
- `app_service_plan_reserved`: Reserved flag (required for Linux plans)

### webapp

Creates Azure Web Apps with framework support and app settings.

**Variables:**
- `webapp_name`: Name of the Web App
- `resource_group_name`: Resource group name
- `app_service_plan_name`: App Service Plan name
- `location`: Azure region
- `webapp_framework`: Framework (python, node, dotnet, java, php)
- `webapp_framework_version`: Framework version
- `webapp_app_settings`: Application settings dictionary

### private_endpoint

Creates private endpoints for Azure resources.

**Variables:**
- `private_endpoint_name`: Name of the private endpoint
- `resource_group_name`: Resource group name
- `vnet_name`: Virtual network name
- `subnet_name`: Subnet name
- `target_resource_id`: Target resource ID
- `private_endpoint_group_ids`: Group IDs for the private endpoint

### private_dns_zone

Creates private DNS zones for private endpoint resolution.

**Variables:**
- `dns_zone_name`: Name of the DNS zone
- `resource_group_name`: Resource group name
- `vnet_name`: Virtual network name

### custom_domain

Configures custom domains and SSL certificates for Web Apps.

**Variables:**
- `webapp_name`: Web App name
- `resource_group_name`: Resource group name
- `custom_domain_name`: Custom domain name
- `create_dns_zone`: Whether to create DNS zone
- `create_ssl_certificate`: Whether to create SSL certificate
- `ssl_cert_path`: Path to SSL certificate file
- `ssl_cert_password`: SSL certificate password

## Network Configuration

The deployment creates a VNet with two subnets:

1. **Delegated Subnet**: For the App Service Plan
   - Delegated to `Microsoft.Web/serverFarms`
   - Supports App Service Environment v3 integration

2. **Non-delegated Subnet**: For the Private Endpoint
   - Contains the Web App private endpoint
   - Provides secure access to the Web App

## Security Considerations

1. **Private Endpoints**: Enable private endpoints for secure access
2. **NSG Rules**: Configure appropriate network security group rules
3. **SSL Certificates**: Use SSL certificates for HTTPS traffic
4. **Vault Encryption**: Encrypt sensitive data using Ansible Vault
5. **Service Endpoints**: Enable service endpoints for Azure services

## Monitoring and Logging

The deployment includes:

- Application Insights integration
- Log Analytics workspace
- Diagnostic settings
- NSG flow logs (optional)

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Ensure Azure CLI is logged in
   az login
   az account show
   ```

2. **Permission Errors**
   ```bash
   # Check subscription permissions
   az role assignment list --assignee $(az account show --query user.name -o tsv)
   ```

3. **Resource Conflicts**
   ```bash
   # Check if resources already exist
   az resource list --resource-group "your-resource-group"
   ```

### Debug Mode

Run playbook in debug mode:

```bash
ansible-playbook -i inventories/dev playbooks/deploy_webapp.yml -vvv
```

## Best Practices

1. **Use Environment-Specific Variables**: Separate dev/prod configurations
2. **Encrypt Sensitive Data**: Use Ansible Vault for secrets
3. **Tag Resources**: Apply consistent tagging strategy
4. **Monitor Costs**: Use appropriate SKUs for your workload
5. **Backup Configuration**: Store playbooks in version control
6. **Test Changes**: Use check mode before applying changes

## Support

For issues and questions:

1. Check the troubleshooting section
2. Review Azure documentation
3. Check Ansible Azure collection documentation
4. Create an issue in the repository

## License

This project is licensed under the MIT License.
