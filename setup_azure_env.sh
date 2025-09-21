#!/bin/bash

# Azure Factory Environment Setup Script
# This script sets up the minimal environment for Azure Factory

set -e

echo "🚀 Setting up Azure Factory Environment..."

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it from:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "ansible-env" ]; then
    echo "📦 Creating Python virtual environment..."
    python3 -m venv ansible-env
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source ansible-env/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install minimal requirements
echo "📥 Installing minimal requirements..."
pip install -r requirements.txt

# Check Ansible installation
echo "✅ Checking Ansible installation..."
ansible --version

# Check Azure CLI version
echo "✅ Checking Azure CLI installation..."
az --version

echo ""
echo "🎉 Azure Factory Environment Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Set your Azure environment variables:"
echo "   export AZURE_SUBSCRIPTION_ID='your-subscription-id'"
echo "   export AZURE_TENANT_ID='your-tenant-id'"
echo "   export AZURE_AUTH_METHOD='cli'"
echo ""
echo "2. Login to Azure:"
echo "   az login"
echo ""
echo "3. Run a playbook:"
echo "   ansible-playbook playbooks/create_vnet_example.yml"
echo ""
echo "To activate the environment in the future, run:"
echo "   source ansible-env/bin/activate"