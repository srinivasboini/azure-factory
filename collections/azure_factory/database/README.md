# Azure Factory Database Collection

This collection provides database infrastructure components for Azure PostgreSQL Flexible Server using **ONLY Azure CLI commands** as per project rules.

## Roles

### postgresql_flexible_server

Creates and manages Azure PostgreSQL Flexible Server with private endpoints, UAMI integration, and security configurations using Azure CLI commands only.

**Variables:**
- `postgresql_server_name`: Name of the PostgreSQL server
- `postgresql_admin_username`: Administrator username
- `postgresql_admin_password`: Administrator password (use Ansible Vault)
- `postgresql_version`: PostgreSQL version (13, 14, 15, 16)
- `postgresql_sku_name`: SKU name (B_Standard_B1ms for minimal pricing)
- `postgresql_tier`: Performance tier (Burstable for cost optimization)
- `postgresql_storage_size`: Storage size in GB (32GB minimum)
- `postgresql_backup_retention`: Backup retention in days
- `postgresql_public_access`: Enable public access (false for private)
- `postgresql_ssl_enforcement`: Enable SSL enforcement
- `postgresql_databases`: List of databases to create
- `postgresql_firewall_rules`: List of firewall rules
- `enable_private_endpoint`: Enable private endpoint
- `enable_uami_integration`: Enable UAMI integration

**Example:**
```yaml
- name: Deploy PostgreSQL Flexible Server
  import_role:
    name: azure_factory.database.postgresql_flexible_server
  vars:
    postgresql_server_name: "myapp-dev-postgres"
    postgresql_admin_username: "postgresadmin"
    postgresql_admin_password: "{{ vault_postgresql_password }}"
    postgresql_version: "15"
    postgresql_sku_name: "B_Standard_B1ms"
    postgresql_tier: "Burstable"
    postgresql_storage_size: 32
    postgresql_backup_retention: 7
    postgresql_public_access: false
    postgresql_ssl_enforcement: true
    enable_private_endpoint: true
    enable_uami_integration: true
    uami_name: "myapp-dev-uami"
    postgresql_databases:
      - name: "myapp_dev_db"
        charset: "UTF8"
        collation: "en_US.UTF8"
```

## Architecture

The PostgreSQL Flexible Server deployment creates the following Azure resources using Azure CLI:

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Group                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────────────────────┐   │
│  │   VNet          │  │   PostgreSQL Flexible Server      │   │
│  │                 │  │                                 │   │
│  │ ┌─────────────┐ │  │  ┌─────────────────────────────┐│   │
│  │ │ Database    │ │  │  │   Private Endpoint          ││   │
│  │ │ Subnet      │ │  │  │   (via az network commands) ││   │
│  │ │ (10.0.5.0/24)│ │  │  │                             ││   │
│  │ └─────────────┘ │  │  │  ┌─────────────────────────┐││   │
│  │                 │  │  │  │   Private DNS Zone       │││   │
│  │                 │  │  │  │   (via az network dns)   │││   │
│  │                 │  │  │  └─────────────────────────┘││   │
│  │                 │  │  └─────────────────────────────┘│   │
│  └─────────────────┘  └─────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              User Assigned Managed Identity             ││
│  │              (for secure database access)               ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

## Features

- **Azure CLI Only**: All operations use `az postgres flexible-server` commands
- **Private Endpoints**: Secure database access through VNet using `az network private-endpoint`
- **UAMI Integration**: Secure authentication using `az postgres flexible-server ad-admin`
- **SSL/TLS Enforcement**: Encrypted connections via Azure CLI parameters
- **Firewall Rules**: Network-level security using `az postgres flexible-server firewall-rule`
- **Backup Configuration**: Automated backups with retention
- **Database Management**: Automatic database creation using `az postgres flexible-server db`
- **Cost Optimization**: Minimal pricing tier (B_Standard_B1ms) for development

## Dependencies

- azure_factory.core >= 1.0.0
- azure_factory.network >= 1.0.0

## Requirements

- Ansible >= 2.9
- Azure CLI installed and configured
- Existing VNet with database subnet
- Proper network security group rules

## Security Considerations

- **Private Access Only**: Database accessible only through VNet
- **SSL Enforcement**: All connections encrypted
- **UAMI Authentication**: No password-based authentication
- **Network Isolation**: Database in dedicated subnet
- **Firewall Rules**: Restrictive access policies
- **Backup Encryption**: Encrypted backups

## Cost Optimization

- **Burstable Tier**: B_Standard_B1ms for development
- **Minimal Storage**: 32GB for development
- **Short Retention**: 7 days backup retention
- **No HA**: Disable high availability for dev
- **No Geo-Redundancy**: Disable for cost savings

## Azure CLI Commands Used

- `az postgres flexible-server create`
- `az postgres flexible-server db create`
- `az postgres flexible-server firewall-rule create`
- `az postgres flexible-server parameter set`
- `az postgres flexible-server ad-admin create`
- `az network private-endpoint create`
- `az network private-dns zone create`
