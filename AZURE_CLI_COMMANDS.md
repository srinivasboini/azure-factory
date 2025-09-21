# Azure CLI Commands Reference

## Table of Contents
1. [Authentication & Account Management](#authentication--account-management)
2. [Resource Group Management](#resource-group-management)
3. [Virtual Network Management](#virtual-network-management)
4. [Network Security Group Management](#network-security-group-management)
5. [App Service Management](#app-service-management)
6. [Web App Management](#web-app-management)
7. [PostgreSQL Flexible Server Management](#postgresql-flexible-server-management)
8. [Managed Identity Management](#managed-identity-management)
9. [Private Endpoint Management](#private-endpoint-management)
10. [DNS Zone Management](#dns-zone-management)
11. [Resource Management](#resource-management)
12. [Monitoring & Diagnostics](#monitoring--diagnostics)
13. [Troubleshooting Commands](#troubleshooting-commands)

## Authentication & Account Management

### Login and Authentication
```bash
# Login to Azure CLI
az login

# Login with specific tenant
az login --tenant <tenant-id>

# Login with service principal
az login --service-principal --username <app-id> --password <password> --tenant <tenant-id>

# Logout
az logout

# Check current account
az account show

# List all accounts
az account list

# Set active subscription
az account set --subscription <subscription-id>

# Get subscription details
az account show --query "{subscriptionId:id, tenantId:tenantId, name:name}" -o table
```

### Examples
```bash
# Login and set subscription
az login
az account set --subscription "eb76f98c-b940-4246-a516-98ed8d1d7334"

# Verify login
az account show --query "name" -o tsv
```

## Resource Group Management

### Resource Group Operations
```bash
# Create resource group
az group create --name <resource-group-name> --location <location> --tags "Project=<project>" "Environment=<env>"

# Show resource group
az group show --name <resource-group-name>

# List resource groups
az group list --output table

# Update resource group
az group update --name <resource-group-name> --tags "Updated=true"

# Delete resource group
az group delete --name <resource-group-name> --yes --no-wait

# Check if resource group exists
az group show --name <resource-group-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Examples
```bash
# Create resource group for development
az group create --name "myapp-dev-rg" --location "Southeast Asia" --tags "Project=myapp" "Environment=dev"

# Check if resource group exists
az group show --name "myapp-dev-rg" --query "name" -o tsv 2>/dev/null || echo "Resource group not found"

# Delete resource group
az group delete --name "myapp-dev-rg" --yes --no-wait
```

## Virtual Network Management

### VNet Operations
```bash
# Create virtual network
az network vnet create --resource-group <rg-name> --name <vnet-name> --address-prefix <cidr> --tags "Project=<project>" "Environment=<env>"

# Show virtual network
az network vnet show --resource-group <rg-name> --name <vnet-name>

# List virtual networks
az network vnet list --resource-group <rg-name> --output table

# Update virtual network
az network vnet update --resource-group <rg-name> --name <vnet-name> --tags "Updated=true"

# Delete virtual network
az network vnet delete --resource-group <rg-name> --name <vnet-name>

# Check if VNet exists
az network vnet show --resource-group <rg-name> --name <vnet-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Subnet Operations
```bash
# Create subnet
az network vnet subnet create --resource-group <rg-name> --vnet-name <vnet-name> --name <subnet-name> --address-prefix <cidr>

# Show subnet
az network vnet subnet show --resource-group <rg-name> --vnet-name <vnet-name> --name <subnet-name>

# List subnets
az network vnet subnet list --resource-group <rg-name> --vnet-name <vnet-name> --output table

# Update subnet
az network vnet subnet update --resource-group <rg-name> --vnet-name <vnet-name> --name <subnet-name> --network-security-group <nsg-name>

# Delete subnet
az network vnet subnet delete --resource-group <rg-name> --vnet-name <vnet-name> --name <subnet-name>
```

### Examples
```bash
# Create VNet with subnets
az network vnet create --resource-group "myapp-dev-rg" --name "myapp-dev-vnet" --address-prefix "10.0.0.0/16" --tags "Project=myapp" "Environment=dev"

# Create subnet
az network vnet subnet create --resource-group "myapp-dev-rg" --vnet-name "myapp-dev-vnet" --name "appservice-delegated" --address-prefix "10.0.1.0/24"

# Check VNet exists
az network vnet show --resource-group "myapp-dev-rg" --name "myapp-dev-vnet" --query "name" -o tsv 2>/dev/null || echo "VNet not found"
```

## Network Security Group Management

### NSG Operations
```bash
# Create network security group
az network nsg create --resource-group <rg-name> --name <nsg-name> --tags "Project=<project>" "Environment=<env>"

# Show network security group
az network nsg show --resource-group <rg-name> --name <nsg-name>

# List network security groups
az network nsg list --resource-group <rg-name> --output table

# Update network security group
az network nsg update --resource-group <rg-name> --name <nsg-name> --tags "Updated=true"

# Delete network security group
az network nsg delete --resource-group <rg-name> --name <nsg-name>

# Check if NSG exists
az network nsg show --resource-group <rg-name> --name <nsg-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### NSG Rules Operations
```bash
# Create NSG rule
az network nsg rule create --resource-group <rg-name> --nsg-name <nsg-name> --name <rule-name> --priority <priority> --direction <direction> --access <access> --protocol <protocol> --source-port-ranges <ports> --destination-port-ranges <ports> --source-address-prefixes <prefixes> --destination-address-prefixes <prefixes>

# Show NSG rule
az network nsg rule show --resource-group <rg-name> --nsg-name <nsg-name> --name <rule-name>

# List NSG rules
az network nsg rule list --resource-group <rg-name> --nsg-name <nsg-name> --output table

# Update NSG rule
az network nsg rule update --resource-group <rg-name> --nsg-name <nsg-name> --name <rule-name> --priority <new-priority>

# Delete NSG rule
az network nsg rule delete --resource-group <rg-name> --nsg-name <nsg-name> --name <rule-name>
```

### Examples
```bash
# Create NSG
az network nsg create --resource-group "myapp-dev-rg" --name "myapp-dev-nsg" --tags "Project=myapp" "Environment=dev"

# Create NSG rule for HTTP
az network nsg rule create --resource-group "myapp-dev-rg" --nsg-name "myapp-dev-nsg" --name "AllowHTTP" --priority 1100 --direction "Inbound" --access "Allow" --protocol "Tcp" --source-port-ranges "*" --destination-port-ranges "80" --source-address-prefixes "*" --destination-address-prefixes "*"

# Check NSG exists
az network nsg show --resource-group "myapp-dev-rg" --name "myapp-dev-nsg" --query "name" -o tsv 2>/dev/null || echo "NSG not found"
```

## App Service Management

### App Service Plan Operations
```bash
# Create app service plan
az appservice plan create --resource-group <rg-name> --name <plan-name> --location <location> --sku <sku> --is-linux

# Show app service plan
az appservice plan show --resource-group <rg-name> --name <plan-name>

# List app service plans
az appservice plan list --resource-group <rg-name> --output table

# Update app service plan
az appservice plan update --resource-group <rg-name> --name <plan-name> --sku <new-sku>

# Delete app service plan
az appservice plan delete --resource-group <rg-name> --name <plan-name> --yes

# Check if App Service Plan exists
az appservice plan show --resource-group <rg-name> --name <plan-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Examples
```bash
# Create Linux App Service Plan
az appservice plan create --resource-group "myapp-dev-rg" --name "myapp-dev-asp" --location "Southeast Asia" --sku "B1" --is-linux

# Check App Service Plan exists
az appservice plan show --resource-group "myapp-dev-rg" --name "myapp-dev-asp" --query "name" -o tsv 2>/dev/null || echo "App Service Plan not found"

# Delete App Service Plan
az appservice plan delete --resource-group "myapp-dev-rg" --name "myapp-dev-asp" --yes
```

## Web App Management

### Web App Operations
```bash
# Create web app
az webapp create --resource-group <rg-name> --plan <plan-name> --name <webapp-name> --runtime <runtime>

# Show web app
az webapp show --resource-group <rg-name> --name <webapp-name>

# List web apps
az webapp list --resource-group <rg-name> --output table

# Update web app
az webapp update --resource-group <rg-name> --name <webapp-name> --runtime <new-runtime>

# Delete web app
az webapp delete --resource-group <rg-name> --name <webapp-name>

# Check if Web App exists
az webapp show --resource-group <rg-name> --name <webapp-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Web App Configuration
```bash
# Configure app settings
az webapp config appsettings set --resource-group <rg-name> --name <webapp-name> --settings <key>=<value>

# Get app settings
az webapp config appsettings list --resource-group <rg-name> --name <webapp-name> --output table

# Configure connection strings
az webapp config connection-string set --resource-group <rg-name> --name <webapp-name> --connection-string-type <type> --settings <name>=<value>

# Get connection strings
az webapp config connection-string list --resource-group <rg-name> --name <webapp-name> --output table
```

### Examples
```bash
# Create Python web app
az webapp create --resource-group "myapp-dev-rg" --plan "myapp-dev-asp" --name "myapp-dev-webapp" --runtime "PYTHON|3.9"

# Check Web App exists
az webapp show --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --query "name" -o tsv 2>/dev/null || echo "Web App not found"

# Delete Web App
az webapp delete --resource-group "myapp-dev-rg" --name "myapp-dev-webapp"
```

## PostgreSQL Flexible Server Management

### PostgreSQL Flexible Server Operations
```bash
# Create PostgreSQL Flexible Server
az postgres flexible-server create --resource-group <rg-name> --name <server-name> --admin-user <admin-username> --admin-password <admin-password> --version <version> --sku-name <sku-name> --tier <tier> --storage-size <storage-size> --backup-retention <retention-days> --location <location> --public-access <enabled/disabled> --ssl-enforcement <enabled/disabled> --minimal-tls-version <tls-version> --geo-redundant-backup <enabled/disabled> --high-availability <enabled/disabled> --zone <zone-number> --tags <tags>

# Show PostgreSQL Flexible Server
az postgres flexible-server show --resource-group <rg-name> --name <server-name>

# List PostgreSQL Flexible Servers
az postgres flexible-server list --resource-group <rg-name> --output table

# Update PostgreSQL Flexible Server
az postgres flexible-server update --resource-group <rg-name> --name <server-name> --sku-name <new-sku> --storage-size <new-size>

# Delete PostgreSQL Flexible Server
az postgres flexible-server delete --resource-group <rg-name> --name <server-name> --yes

# Check if PostgreSQL Flexible Server exists
az postgres flexible-server show --resource-group <rg-name> --name <server-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### PostgreSQL Database Operations
```bash
# Create database
az postgres flexible-server db create --resource-group <rg-name> --server-name <server-name> --database-name <db-name> --charset <charset> --collation <collation>

# Show database
az postgres flexible-server db show --resource-group <rg-name> --server-name <server-name> --database-name <db-name>

# List databases
az postgres flexible-server db list --resource-group <rg-name> --server-name <server-name> --output table

# Delete database
az postgres flexible-server db delete --resource-group <rg-name> --server-name <server-name> --database-name <db-name> --yes

# Check if database exists
az postgres flexible-server db show --resource-group <rg-name> --server-name <server-name> --database-name <db-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### PostgreSQL Firewall Rules Operations
```bash
# Create firewall rule
az postgres flexible-server firewall-rule create --resource-group <rg-name> --name <server-name> --rule-name <rule-name> --start-ip-address <start-ip> --end-ip-address <end-ip>

# Show firewall rule
az postgres flexible-server firewall-rule show --resource-group <rg-name> --name <server-name> --rule-name <rule-name>

# List firewall rules
az postgres flexible-server firewall-rule list --resource-group <rg-name> --name <server-name> --output table

# Update firewall rule
az postgres flexible-server firewall-rule update --resource-group <rg-name> --name <server-name> --rule-name <rule-name> --start-ip-address <new-start-ip> --end-ip-address <new-end-ip>

# Delete firewall rule
az postgres flexible-server firewall-rule delete --resource-group <rg-name> --name <server-name> --rule-name <rule-name>
```

### PostgreSQL Configuration Parameters
```bash
# Set configuration parameter
az postgres flexible-server parameter set --resource-group <rg-name> --server-name <server-name> --name <parameter-name> --value <parameter-value>

# Show configuration parameter
az postgres flexible-server parameter show --resource-group <rg-name> --server-name <server-name> --name <parameter-name>

# List configuration parameters
az postgres flexible-server parameter list --resource-group <rg-name> --server-name <server-name> --output table

# Reset configuration parameter
az postgres flexible-server parameter reset --resource-group <rg-name> --server-name <server-name> --name <parameter-name>
```

### PostgreSQL Azure AD Authentication
```bash
# Create Azure AD admin
az postgres flexible-server ad-admin create --resource-group <rg-name> --server-name <server-name> --display-name <display-name> --object-id <object-id> --tenant-id <tenant-id>

# Show Azure AD admin
az postgres flexible-server ad-admin show --resource-group <rg-name> --server-name <server-name>

# List Azure AD admins
az postgres flexible-server ad-admin list --resource-group <rg-name> --server-name <server-name> --output table

# Delete Azure AD admin
az postgres flexible-server ad-admin delete --resource-group <rg-name> --server-name <server-name> --object-id <object-id>
```

### Examples
```bash
# Create minimal PostgreSQL Flexible Server for development
az postgres flexible-server create --resource-group "myapp-dev-rg" --name "myapp-dev-postgres" --admin-user "postgresadmin" --admin-password "MySecurePassword123!" --version "15" --sku-name "B_Standard_B1ms" --tier "Burstable" --storage-size 32 --backup-retention 7 --location "Southeast Asia" --public-access "Disabled" --ssl-enforcement "Enabled" --minimal-tls-version "TLS1_2" --geo-redundant-backup "Disabled" --high-availability "Disabled" --zone "1" --tags "Project=myapp" "Environment=dev"

# Create database
az postgres flexible-server db create --resource-group "myapp-dev-rg" --server-name "myapp-dev-postgres" --database-name "myapp_dev_db" --charset "UTF8" --collation "en_US.UTF8"

# Create firewall rule for Azure services
az postgres flexible-server firewall-rule create --resource-group "myapp-dev-rg" --name "myapp-dev-postgres" --rule-name "AllowAzureServices" --start-ip-address "0.0.0.0" --end-ip-address "0.0.0.0"

# Set performance parameters
az postgres flexible-server parameter set --resource-group "myapp-dev-rg" --server-name "myapp-dev-postgres" --name "shared_preload_libraries" --value "pg_stat_statements"
az postgres flexible-server parameter set --resource-group "myapp-dev-rg" --server-name "myapp-dev-postgres" --name "max_connections" --value "100"

# Create Azure AD admin using UAMI
az postgres flexible-server ad-admin create --resource-group "myapp-dev-rg" --server-name "myapp-dev-postgres" --display-name "myapp-dev-uami" --object-id "12345678-1234-1234-1234-123456789012" --tenant-id "87654321-4321-4321-4321-210987654321"

# Check PostgreSQL server exists
az postgres flexible-server show --resource-group "myapp-dev-rg" --name "myapp-dev-postgres" --query "name" -o tsv 2>/dev/null || echo "PostgreSQL server not found"

# Delete PostgreSQL server
az postgres flexible-server delete --resource-group "myapp-dev-rg" --name "myapp-dev-postgres" --yes
```

## Managed Identity Management

### User Assigned Managed Identity Operations
```bash
# Create user assigned managed identity
az identity create --resource-group <rg-name> --name <identity-name> --location <location> --tags "Project=<project>" "Environment=<env>"

# Show user assigned managed identity
az identity show --resource-group <rg-name> --name <identity-name>

# List user assigned managed identities
az identity list --resource-group <rg-name> --output table

# Update user assigned managed identity
az identity update --resource-group <rg-name> --name <identity-name> --tags "Updated=true"

# Delete user assigned managed identity
az identity delete --resource-group <rg-name> --name <identity-name>

# Check if UAMI exists
az identity show --resource-group <rg-name> --name <identity-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Web App Identity Operations
```bash
# Assign user assigned managed identity to web app
az webapp identity assign --resource-group <rg-name> --name <webapp-name> --identities <identity-resource-id>

# Show web app identity
az webapp identity show --resource-group <rg-name> --name <webapp-name>

# Remove web app identity
az webapp identity remove --resource-group <rg-name> --name <webapp-name> --identities <identity-resource-id>
```

### Examples
```bash
# Create UAMI
az identity create --resource-group "myapp-dev-rg" --name "myapp-dev-uami" --location "Southeast Asia" --tags "Project=myapp" "Environment=dev"

# Get UAMI details
az identity show --resource-group "myapp-dev-rg" --name "myapp-dev-uami" --query "{id:id, clientId:clientId, principalId:principalId}" -o table

# Assign UAMI to web app
az webapp identity assign --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --identities "/subscriptions/eb76f98c-b940-4246-a516-98ed8d1d7334/resourceGroups/myapp-dev-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myapp-dev-uami"

# Check UAMI exists
az identity show --resource-group "myapp-dev-rg" --name "myapp-dev-uami" --query "name" -o tsv 2>/dev/null || echo "UAMI not found"
```

## Private Endpoint Management

### Private Endpoint Operations
```bash
# Create private endpoint
az network private-endpoint create --resource-group <rg-name> --name <pe-name> --vnet-name <vnet-name> --subnet <subnet-name> --private-connection-resource-id <resource-id> --group-ids <group-ids> --connection-name <connection-name>

# Show private endpoint
az network private-endpoint show --resource-group <rg-name> --name <pe-name>

# List private endpoints
az network private-endpoint list --resource-group <rg-name> --output table

# Update private endpoint
az network private-endpoint update --resource-group <rg-name> --name <pe-name> --tags "Updated=true"

# Delete private endpoint
az network private-endpoint delete --resource-group <rg-name> --name <pe-name>

# Check if Private Endpoint exists
az network private-endpoint show --resource-group <rg-name> --name <pe-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### Examples
```bash
# Create private endpoint for web app
az network private-endpoint create --resource-group "myapp-dev-rg" --name "myapp-dev-pe" --vnet-name "myapp-dev-vnet" --subnet "appservice-private" --private-connection-resource-id "/subscriptions/eb76f98c-b940-4246-a516-98ed8d1d7334/resourceGroups/myapp-dev-rg/providers/Microsoft.Web/sites/myapp-dev-webapp" --group-ids "sites" --connection-name "webapp-connection"

# Check Private Endpoint exists
az network private-endpoint show --resource-group "myapp-dev-rg" --name "myapp-dev-pe" --query "name" -o tsv 2>/dev/null || echo "Private Endpoint not found"
```

## DNS Zone Management

### Private DNS Zone Operations
```bash
# Create private DNS zone
az network private-dns zone create --resource-group <rg-name> --name <zone-name>

# Show private DNS zone
az network private-dns zone show --resource-group <rg-name> --name <zone-name>

# List private DNS zones
az network private-dns zone list --resource-group <rg-name> --output table

# Update private DNS zone
az network private-dns zone update --resource-group <rg-name> --name <zone-name> --tags "Updated=true"

# Delete private DNS zone
az network private-dns zone delete --resource-group <rg-name> --name <zone-name>

# Check if Private DNS Zone exists
az network private-dns zone show --resource-group <rg-name> --name <zone-name> --query "name" -o tsv 2>/dev/null || echo "Not found"
```

### DNS Record Operations
```bash
# Create DNS record
az network private-dns record-set a create --resource-group <rg-name> --zone-name <zone-name> --name <record-name>

# Add DNS record
az network private-dns record-set a add-record --resource-group <rg-name> --zone-name <zone-name> --record-set-name <record-name> --ipv4-address <ip-address>

# Show DNS record
az network private-dns record-set a show --resource-group <rg-name> --zone-name <zone-name> --name <record-name>

# List DNS records
az network private-dns record-set list --resource-group <rg-name> --zone-name <zone-name> --output table

# Delete DNS record
az network private-dns record-set a delete --resource-group <rg-name> --zone-name <zone-name> --name <record-name>
```

### Examples
```bash
# Create private DNS zone
az network private-dns zone create --resource-group "myapp-dev-rg" --name "privatelink.azurewebsites.net"

# Create DNS record
az network private-dns record-set a create --resource-group "myapp-dev-rg" --zone-name "privatelink.azurewebsites.net" --name "myapp-dev-webapp"

# Add IP address to DNS record
az network private-dns record-set a add-record --resource-group "myapp-dev-rg" --zone-name "privatelink.azurewebsites.net" --record-set-name "myapp-dev-webapp" --ipv4-address "10.0.2.4"

# Check Private DNS Zone exists
az network private-dns zone show --resource-group "myapp-dev-rg" --name "privatelink.azurewebsites.net" --query "name" -o tsv 2>/dev/null || echo "Private DNS Zone not found"
```

## Resource Management

### General Resource Operations
```bash
# List all resources in resource group
az resource list --resource-group <rg-name> --output table

# Show specific resource
az resource show --resource-group <rg-name> --name <resource-name> --resource-type <resource-type>

# Delete specific resource
az resource delete --resource-group <rg-name> --name <resource-name> --resource-type <resource-type>

# Move resource
az resource move --destination-group <dest-rg> --ids <resource-ids>

# Tag resource
az resource tag --resource-group <rg-name> --name <resource-name> --resource-type <resource-type> --tags <tags>
```

### Examples
```bash
# List all resources
az resource list --resource-group "myapp-dev-rg" --output table

# Delete web app using resource delete
az resource delete --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --resource-type "Microsoft.Web/sites"

# Tag resource
az resource tag --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --resource-type "Microsoft.Web/sites" --tags "Environment=dev" "Project=myapp"
```

## Monitoring & Diagnostics

### Log and Monitoring Operations
```bash
# Get web app logs
az webapp log tail --resource-group <rg-name> --name <webapp-name>

# Download web app logs
az webapp log download --resource-group <rg-name> --name <webapp-name>

# Configure log settings
az webapp log config --resource-group <rg-name> --name <webapp-name> --application-logging <level> --web-server-logging <level>

# Get web app metrics
az monitor metrics list --resource <resource-id> --metric <metric-name> --start-time <start-time> --end-time <end-time>
```

### Examples
```bash
# Tail web app logs
az webapp log tail --resource-group "myapp-dev-rg" --name "myapp-dev-webapp"

# Configure logging
az webapp log config --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --application-logging "filesystem" --web-server-logging "filesystem"

# Get metrics
az monitor metrics list --resource "/subscriptions/eb76f98c-b940-4246-a516-98ed8d1d7334/resourceGroups/myapp-dev-rg/providers/Microsoft.Web/sites/myapp-dev-webapp" --metric "HttpResponseTime" --start-time "2024-01-01T00:00:00Z" --end-time "2024-01-02T00:00:00Z"
```

## Troubleshooting Commands

### Common Troubleshooting
```bash
# Check Azure CLI version
az --version

# Check login status
az account show

# Check resource group status
az group show --name <rg-name> --query "properties.provisioningState" -o tsv

# Check resource status
az resource show --resource-group <rg-name> --name <resource-name> --resource-type <resource-type> --query "properties.provisioningState" -o tsv

# Check deployment status
az deployment group show --resource-group <rg-name> --name <deployment-name> --query "properties.provisioningState" -o tsv

# Get resource health
az resource health events list --query "[?resourceType=='Microsoft.Web/sites']" --output table
```

### Examples
```bash
# Check if resource group is being deleted
az group show --name "myapp-dev-rg" --query "properties.provisioningState" -o tsv

# Check web app status
az resource show --resource-group "myapp-dev-rg" --name "myapp-dev-webapp" --resource-type "Microsoft.Web/sites" --query "properties.state" -o tsv

# Check VNet status
az resource show --resource-group "myapp-dev-rg" --name "myapp-dev-vnet" --resource-type "Microsoft.Network/virtualNetworks" --query "properties.provisioningState" -o tsv
```

---

## Notes for Future Changes

**IMPORTANT**: When adding new Azure CLI commands to this project:

1. **Always add the command to this file** with:
   - Full command syntax
   - Description of what it does
   - Example usage with actual values
   - Error handling examples

2. **Test the command** before adding to playbooks

3. **Update the playbook** with proper error handling (`failed_when: false`)

4. **Document any new variables** in the inventory files

5. **Add troubleshooting steps** if the command can fail

6. **Include both success and failure scenarios** in examples

This ensures consistency and helps with future maintenance and troubleshooting.
