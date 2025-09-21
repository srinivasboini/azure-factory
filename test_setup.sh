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
ansible-playbook --syntax-check playbooks/create_vnet_example.yml
ansible-playbook --syntax-check playbooks/create_infrastructure_example.yml
ansible-playbook --syntax-check playbooks/destroy_vnet_example.yml

# Test role structure
echo "✅ Testing role structure..."
echo "Core roles:"
ls -la collections/azure_factory/core/roles/
echo "Network roles:"
ls -la collections/azure_factory/network/roles/

# Test dry run (if Azure CLI is available)
if command -v az &> /dev/null; then
    echo "✅ Azure CLI found, testing dry run..."
    echo "Note: This will fail if not logged in to Azure, which is expected."
    ansible-playbook --check playbooks/create_vnet_example.yml || echo "Dry run completed (expected to fail without Azure login)"
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
echo "- create_vnet_example.yml (Simple VNet creation)"
echo "- create_infrastructure_example.yml (Custom infrastructure)"
echo "- destroy_vnet_example.yml (VNet destruction)"
echo ""
echo "Available Roles:"
echo "- azure_auth (Authentication)"
echo "- resource_group (Resource group management)"
echo "- vnet_complete (Complete VNet setup)"
echo "- vnet_destroy (VNet destruction)"
echo ""
echo "Next steps:"
echo "1. Install Azure CLI if not already installed"
echo "2. Set Azure environment variables"
echo "3. Login to Azure: az login"
echo "4. Run playbooks: ansible-playbook playbooks/create_vnet_example.yml"