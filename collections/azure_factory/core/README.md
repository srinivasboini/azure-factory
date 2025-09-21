# Azure Factory Core Collection

This collection provides core functionality for Azure infrastructure management including authentication, common variables, and shared roles.

## Roles

### azure_auth

Handles Azure authentication and basic setup.

**Variables:**
- `azure_subscription_id`: Azure subscription ID
- `azure_tenant_id`: Azure tenant ID
- `azure_auth_method`: Authentication method (cli, service_principal, msi)
- `project_name`: Project name
- `environment`: Environment name (dev, test, prod)

**Example:**
```yaml
- name: Authenticate with Azure
  import_role:
    name: azure_factory.core.azure_auth
  vars:
    project_name: "myapp"
    environment: "dev"
```

## Dependencies

- azure.azcollection >= 1.0.0

## Requirements

- Ansible >= 2.9
- Azure CLI or Service Principal credentials
