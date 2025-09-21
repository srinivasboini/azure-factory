# Azure Factory Network Collection

This collection provides network infrastructure components for Azure including Virtual Networks, subnets, Network Security Groups, and more.

## Roles

### vnet

Creates and manages Azure Virtual Networks with subnets and NSGs.

**Variables:**
- `vnet_name`: Name of the virtual network
- `vnet_address_prefix`: Address space for the VNet (e.g., "10.0.0.0/16")
- `subnets`: List of subnets to create
- `nsg_rules`: Network Security Group rules
- `create_nsg`: Whether to create NSG (default: true)
- `create_private_endpoints`: Whether to create private endpoints (default: false)

**Example:**
```yaml
- name: Deploy VNet with Subnets
  import_role:
    name: azure_factory.network.vnet
  vars:
    vnet_name: "myapp-dev-vnet"
    vnet_address_prefix: "10.0.0.0/16"
    subnets:
      - name: "frontend"
        address_prefix: "10.0.1.0/24"
        service_endpoints: []
      - name: "backend"
        address_prefix: "10.0.2.0/24"
        service_endpoints: []
      - name: "database"
        address_prefix: "10.0.3.0/24"
        service_endpoints: ["Microsoft.Sql", "Microsoft.Storage"]
    nsg_rules:
      - name: "AllowSSH"
        priority: 1000
        direction: "Inbound"
        access: "Allow"
        protocol: "Tcp"
        source_port_range: "*"
        destination_port_range: "22"
        source_address_prefix: "*"
        destination_address_prefix: "*"
```

## Dependencies

- azure_factory.core >= 1.0.0
- azure.azcollection >= 1.0.0

## Requirements

- Ansible >= 2.9
- Azure CLI or Service Principal credentials
- Proper network address space planning
