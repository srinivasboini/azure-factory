# Azure Factory - Complete Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Setup Instructions](#setup-instructions)
5. [Deployment Guide](#deployment-guide)
6. [Configuration](#configuration)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Maintenance](#maintenance)

## Project Overview

Azure Factory is an Ansible-based automation solution for deploying Azure infrastructure and web applications. It provides a modular, scalable approach to Azure resource management with support for User Assigned Managed Identity (UAMI), private endpoints, and custom domains.

### Key Features
- **Modular Architecture**: Separate roles for different Azure services
- **User Assigned Managed Identity**: Secure authentication for web applications
- **Private Endpoints**: Enhanced security with private connectivity
- **Custom Domains**: Support for custom domain configuration
- **Environment Management**: Separate configurations for dev/prod environments
- **Cost Optimization**: Basic tier support for development

## Architecture

### Infrastructure Components
- **Resource Group**: Container for all resources
- **Virtual Network**: Network isolation and security
- **Network Security Group**: Firewall rules and security policies
- **App Service Plan**: Hosting platform for web applications
- **Web App**: Application hosting with UAMI support
- **User Assigned Managed Identity**: Secure authentication mechanism

### Network Architecture
```
Internet → VNet → Subnets → App Service → Web App
                ↓
            Private Endpoints (Optional)
                ↓
            Private DNS Zones
```

### File Structure
```
azure-factory/
├── collections/azure_factory/          # Ansible collections
│   ├── app/                           # Application-related roles
│   ├── core/                          # Core infrastructure roles
│   └── network/                       # Network-related roles
├── inventories/                        # Environment configurations
│   └── dev/                          # Development environment
├── playbooks/                         # Deployment playbooks
├── ansible-env/                       # Python virtual environment
└── DOCUMENTATION.md                   # This file
```

## Prerequisites

### System Requirements
- **Operating System**: macOS, Linux, or Windows with WSL
- **Python**: 3.9 or higher
- **Azure CLI**: Latest version
- **Ansible**: 2.19 or higher

### Azure Requirements
- **Azure Subscription**: Active subscription with appropriate permissions
- **Resource Group**: Permissions to create/manage resources
- **Network**: Permissions to create VNets, NSGs, and subnets
- **App Service**: Permissions to create App Service Plans and Web Apps

### Environment Variables
```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_AUTH_METHOD="cli"  # or "service_principal"
```

## Setup Instructions

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd azure-factory
```

### 2. Activate Ansible Environment
```bash
source ansible-env/bin/activate
```

### 3. Azure Authentication
```bash
# Login to Azure CLI
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Verify login
az account show
```

### 4. Configure Environment Variables
```bash
# Get your subscription details
az account show --query "{subscriptionId:id, tenantId:tenantId}" -o table

# Set environment variables
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_AUTH_METHOD="cli"
```

### 5. Verify Setup
```bash
# Test Ansible installation
ansible --version

# Test Azure CLI
az --version

# Test playbook syntax
ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml --check
```

## Deployment Guide

### Infrastructure Deployment
Deploy the complete infrastructure including VNet, NSG, and App Service Plan:

```bash
ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml
```

### Web Application Deployment
Deploy the web application with UAMI and private endpoints:

```bash
ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml
```

### Complete Deployment
Deploy both infrastructure and web application:

```bash
# Deploy infrastructure first
ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml

# Then deploy web application
ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml
```

### Destruction
Clean up resources in the correct order:

```bash
# Destroy web application first
ansible-playbook -i inventories/dev playbooks/destroy_webapp_only.yml

# Then destroy infrastructure
ansible-playbook -i inventories/dev playbooks/destroy_infrastructure.yml
```

## Configuration

### Environment Configuration
Edit `inventories/dev/group_vars/all.yml` for common settings:

```yaml
# Environment settings
env_name: dev
project_name: "myapp"
default_location: "Southeast Asia"

# Resource naming
resource_prefix: "{{ project_name }}-{{ env_name }}"
resource_group_name: "{{ project_name }}-{{ env_name }}-rg"

# App Service Plan settings
sku_name: "B1"  # Basic tier
sku_tier: "Basic"
sku_size: "B1"
sku_capacity: 1
```

### Web Application Configuration
Edit `inventories/dev/group_vars/webapp.yml` for web app settings:

```yaml
# Web App settings
webapp_name: "{{ project_name }}-{{ env_name }}-webapp"
webapp_framework: "python"
webapp_framework_version: "3.9"

# UAMI settings
enable_user_assigned_identity: true
user_assigned_identity_name: "{{ project_name }}-{{ env_name }}-uami"

# Private endpoint settings
enable_private_endpoint: true
private_endpoint_name: "{{ project_name }}-{{ env_name }}-pe"
```

### Network Configuration
Configure VNet and subnets in `inventories/dev/group_vars/all.yml`:

```yaml
# VNet settings
vnet_name: "{{ project_name }}-{{ env_name }}-vnet"
vnet_address_prefix: "10.0.0.0/16"

# Subnet settings
delegated_subnet_name: "appservice-delegated"
non_delegated_subnet_name: "appservice-private"
delegated_subnet_prefix: "10.0.1.0/24"
non_delegated_subnet_prefix: "10.0.2.0/24"
```

## Troubleshooting

### Common Issues

#### 1. Azure Authentication Errors
```bash
# Re-authenticate
az logout
az login

# Verify subscription
az account show
```

#### 2. Resource Creation Failures
- **Throttling**: Wait and retry, or change region
- **Permissions**: Verify Azure RBAC permissions
- **Naming**: Ensure resource names follow Azure naming conventions

#### 3. Ansible Variable Errors
- **Undefined Variables**: Check inventory files for missing variables
- **Recursive Loops**: Avoid `var: "{{ var }}"` patterns
- **Reserved Names**: Don't use `environment` as variable name

#### 4. Network Issues
- **NSG Rules**: Check firewall rules and priorities
- **Subnet Delegation**: Ensure proper subnet configuration
- **Private Endpoints**: Verify DNS zone configuration

### Debug Commands
```bash
# Check Ansible syntax
ansible-playbook --syntax-check playbooks/deploy_infrastructure.yml

# Dry run deployment
ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml --check

# Verbose output
ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml -v

# Check Azure resources
az resource list --resource-group myapp-dev-rg --output table
```

## Best Practices

### Security
- **Use UAMI**: Enable User Assigned Managed Identity for secure authentication
- **Private Endpoints**: Use private connectivity for sensitive applications
- **NSG Rules**: Implement least-privilege network security rules
- **Resource Tags**: Tag all resources for governance and cost tracking

### Cost Optimization
- **Basic Tier**: Use B1 Basic tier for development environments
- **Auto-shutdown**: Enable auto-shutdown for non-production resources
- **Resource Cleanup**: Regularly destroy unused resources
- **Monitoring**: Set up cost alerts and monitoring

### Development Workflow
- **Environment Separation**: Use separate resource groups for dev/prod
- **Version Control**: Commit all configuration changes
- **Testing**: Always test in development before production
- **Documentation**: Update documentation with any changes

### Naming Conventions
- **Resources**: Use consistent naming patterns
- **Tags**: Apply standard tags to all resources
- **Variables**: Use descriptive variable names
- **Playbooks**: Name playbooks clearly

## Maintenance

### Regular Tasks
- **Update Dependencies**: Keep Ansible and Azure CLI updated
- **Review Costs**: Monitor and optimize resource usage
- **Security Updates**: Apply security patches regularly
- **Backup Configuration**: Backup inventory and playbook files

### Monitoring
- **Resource Health**: Monitor resource health and performance
- **Cost Tracking**: Track costs and set up alerts
- **Security Compliance**: Regular security assessments
- **Performance**: Monitor application performance

### Updates
- **Ansible Roles**: Update roles for new features
- **Azure Services**: Stay current with Azure service updates
- **Documentation**: Keep documentation current
- **Testing**: Regular testing of deployment processes

---

## Support and Contributing

For issues, questions, or contributions:
1. Check this documentation first
2. Review the Azure CLI commands reference
3. Test in development environment
4. Document any new procedures

**Remember**: Always test changes in development before applying to production environments.
