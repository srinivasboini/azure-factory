#!/bin/bash

# PostgreSQL Deployment Script - Learning Mode
# This script deploys PostgreSQL with plain text password for learning purposes

echo "🗄️ PostgreSQL Deployment Script - Learning Mode"
echo "================================================"
echo ""

# Check if virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "🔧 Activating Ansible virtual environment..."
    source ansible-env/bin/activate
fi

# Check if Azure CLI is logged in
echo "🔍 Checking Azure CLI login status..."
if ! az account show &> /dev/null; then
    echo "❌ Azure CLI is not logged in. Please run: az login"
    exit 1
fi

echo "✅ Azure CLI is logged in"
echo "Current subscription: $(az account show --query 'name' -o tsv)"
echo ""

# Check if environment variables are set
echo "🔍 Checking environment variables..."
if [[ -z "$AZURE_SUBSCRIPTION_ID" ]] || [[ -z "$AZURE_TENANT_ID" ]]; then
    echo "⚠️  Environment variables not set. Running setup..."
    source setup_env_vars.sh
fi

echo "✅ Environment variables are set"
echo ""

# Check if infrastructure exists
echo "🔍 Checking if infrastructure exists..."
if ! az group show --name "myapp-dev-rg" &> /dev/null; then
    echo "❌ Infrastructure not found. Please deploy infrastructure first:"
    echo "   ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml"
    echo ""
    echo "Or run the complete deployment sequence:"
    echo "   1. ansible-playbook -i inventories/dev playbooks/deploy_infrastructure.yml"
    echo "   2. ansible-playbook -i inventories/dev playbooks/deploy_webapp_only.yml"
    echo "   3. ansible-playbook -i inventories/dev playbooks/deploy_postgresql.yml"
    exit 1
fi

echo "✅ Infrastructure exists"
echo ""

# Deploy PostgreSQL
echo "🚀 Deploying PostgreSQL Flexible Server..."
echo "Password: MySecurePostgresPassword123! (plain text for learning)"
echo ""

ansible-playbook -i inventories/dev playbooks/deploy_postgresql.yml

echo ""
echo "🎉 PostgreSQL deployment completed!"
echo ""
echo "Next steps:"
echo "1. Check PostgreSQL server: az postgres flexible-server show --resource-group myapp-dev-rg --name myapp-dev-postgres"
echo "2. Connect to database: psql -h myapp-dev-postgres.postgres.database.azure.com -U postgresadmin -d myapp_dev_db"
echo "3. Clean up: ansible-playbook -i inventories/dev playbooks/destroy_postgresql.yml"
