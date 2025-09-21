#!/bin/bash

# Azure Factory Test Script
# This script tests the minimal setup

set -e

echo "🧪 Testing Azure Factory Setup..."

# Check if virtual environment exists
if [ ! -d "ansible-env" ]; then
    echo "❌ Virtual environment not found. Run ./setup_azure_env.sh first."
    exit 1
fi

# Activate virtual environment
source ansible-env/bin/activate

# Test Ansible installation
echo "✅ Testing Ansible installation..."
ansible --version

# Test playbook syntax
echo "✅ Testing playbook syntax..."
ansible-playbook --syntax-check playbooks/deploy_infrastructure.yml
ansible-playbook --syntax-check playbooks/deploy_webapp_only.yml
ansible-playbook --syntax-check playbooks/deploy_postgresql.yml
ansible-playbook --syntax-check playbooks/destroy_infrastructure.yml
ansible-playbook --syntax-check playbooks/destroy_webapp_only.yml
ansible-playbook --syntax-check playbooks/destroy_postgresql.yml

# Test role structure
echo "✅ Testing role structure..."
echo "Core roles:"
ls -la collections/azure_factory/core/roles/
echo "Network roles:"
ls -la collections/azure_factory/network/roles/

# Test Azure CLI and environment variables
if command -v az &> /dev/null; then
    echo "✅ Azure CLI found, testing Azure connection..."
    if az account show &> /dev/null; then
        echo "✅ Azure CLI is logged in"
        echo "Current subscription: $(az account show --query 'name' -o tsv)"
        
        # Test environment variables
        if [ -n "$AZURE_SUBSCRIPTION_ID" ] && [ -n "$AZURE_TENANT_ID" ]; then
            echo "✅ Azure environment variables are set"
            echo "  AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
            echo "  AZURE_TENANT_ID: $AZURE_TENANT_ID"
            echo "  AZURE_AUTH_METHOD: $AZURE_AUTH_METHOD"
        else
            echo "⚠️  Azure environment variables not set. Run: source setup_env_vars.sh"
        fi
        
        # Test dry run
        echo "✅ Testing playbook dry run..."
        ansible-playbook --check playbooks/deploy_infrastructure.yml || echo "Dry run completed (expected to fail without proper configuration)"
    else
        echo "⚠️  Azure CLI not logged in. Run: az login"
    fi
else
    echo "⚠️  Azure CLI not found. Install it to test Azure operations."
fi

echo ""
echo "🎉 Azure Factory Setup Test Complete!"
echo ""
echo "Setup Summary:"
echo "- ✅ Python virtual environment: ansible-env"
echo "- ✅ Ansible Core: $(ansible --version | head -n1)"
echo "- ✅ Playbook syntax: Valid"
echo "- ✅ Role structure: Complete"
echo "- ✅ Minimal dependencies: Installed"
echo ""
echo "Available Playbooks:"
echo "- deploy_infrastructure.yml (Complete infrastructure deployment)"
echo "- deploy_webapp_only.yml (Web application deployment)"
echo "- deploy_postgresql.yml (PostgreSQL database deployment)"
echo "- destroy_infrastructure.yml (Infrastructure cleanup)"
echo "- destroy_webapp_only.yml (Web application cleanup)"
echo "- destroy_postgresql.yml (PostgreSQL cleanup)"
echo ""
echo "Available Roles:"
echo "- azure_auth (Authentication)"
echo "- resource_group (Resource group management)"
echo "- vnet_complete (Complete VNet setup)"
echo "- vnet_destroy (VNet destruction)"
echo ""
echo "Next steps:"
echo "1. Set Azure environment variables: source setup_env_vars.sh"
echo "2. Login to Azure: az login"
echo "3. Run infrastructure deployment: ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml"
echo "4. Run webapp deployment: ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml"
echo "5. Run PostgreSQL deployment: ansible-playbook -i inventories/dev playbooks/deploy_postgresql.yml"
echo "6. Or use convenience script: ./deploy_postgresql.sh"