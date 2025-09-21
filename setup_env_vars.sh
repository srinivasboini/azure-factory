#!/bin/bash

# Azure Factory Environment Variables Setup
# This script sets up the Azure environment variables for the current session

echo "🔧 Setting up Azure Factory Environment Variables..."

# Azure Subscription Information
export AZURE_SUBSCRIPTION_ID='eb76f98c-b940-4246-a516-98ed8d1d7334'
export AZURE_TENANT_ID='2f7db868-812c-498f-8642-9fbf48b549d5'
export AZURE_AUTH_METHOD='cli'

echo "✅ Environment variables set successfully!"
echo ""
echo "Current Azure Environment:"
echo "  AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
echo "  AZURE_TENANT_ID: $AZURE_TENANT_ID"
echo "  AZURE_AUTH_METHOD: $AZURE_AUTH_METHOD"
echo ""

# Verify Azure CLI login
echo "🔍 Verifying Azure CLI login..."
if az account show &> /dev/null; then
    echo "✅ Azure CLI is logged in"
    echo "Current subscription: $(az account show --query 'name' -o tsv)"
else
    echo "⚠️  Azure CLI is not logged in. Please run: az login"
fi

echo ""
echo "🎉 Environment setup complete!"
echo ""
echo "You can now run Azure Factory playbooks:"
echo "  ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml"
echo "  ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml"
echo "  ansible-playbook -i inventories/dev playbooks/deploy_postgresql.yml --ask-vault-pass"
echo ""
echo "To make these variables permanent, add them to your ~/.bashrc or ~/.zshrc:"
echo "  export AZURE_SUBSCRIPTION_ID='eb76f98c-b940-4246-a516-98ed8d1d7334'"
echo "  export AZURE_TENANT_ID='2f7db868-812c-498f-8642-9fbf48b549d5'"
echo "  export AZURE_AUTH_METHOD='cli'"
