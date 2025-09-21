# Azure Factory

An Ansible-based automation solution for deploying Azure infrastructure and web applications with User Assigned Managed Identity (UAMI) support.

## Quick Start

1. **Setup Environment**
   ```bash
   source ansible-env/bin/activate
   az login
   export AZURE_SUBSCRIPTION_ID="your-subscription-id"
   export AZURE_TENANT_ID="your-tenant-id"
   ```

2. **Deploy Infrastructure**
   ```bash
   ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml
   ```

3. **Deploy Web Application**
   ```bash
   ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml
   ```

4. **Clean Up**
   ```bash
   ansible-playbook -i inventories/dev playbooks/destroy_webapp_only.yml
   ansible-playbook -i inventories/dev playbooks/destroy_infrastructure.yml
   ```

## Documentation

- **[Complete Documentation](DOCUMENTATION.md)** - Comprehensive guide covering setup, deployment, configuration, and troubleshooting
- **[Azure CLI Commands Reference](AZURE_CLI_COMMANDS.md)** - Complete reference for all Azure CLI commands used in this project

## Features

- ✅ **User Assigned Managed Identity** for secure authentication
- ✅ **Private Endpoints** for enhanced security
- ✅ **Modular Architecture** with separate roles for different services
- ✅ **Environment Management** with dev/prod configurations
- ✅ **Cost Optimization** with Basic tier support
- ✅ **Automated Cleanup** with proper destruction playbooks

## Architecture

```
Internet → VNet → Subnets → App Service → Web App
                ↓
            Private Endpoints (Optional)
                ↓
            Private DNS Zones
```

## Requirements

- Python 3.9+
- Azure CLI
- Ansible 2.19+
- Azure Subscription with appropriate permissions

---

**For detailed information, see [DOCUMENTATION.md](DOCUMENTATION.md)**