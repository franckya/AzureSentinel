#!/bin/bash

# Set the variables
resource_group="YanSentinelRG"
workspace_name="YaSentinelWK"
subscription_name="Pay-As-You-Go"
region="East US"
retention_days=30

# Set the active subscription
az account set --subscription "$subscription_name"

# Check if the Log Analytics workspace already exists
if az monitor log-analytics workspace show --resource-group "$resource_group" --workspace-name "$workspace_name" &>/dev/null; then
    echo "Log Analytics workspace '$workspace_name' already exists in the resource group '$resource_group'. Skipping creation."
else
    # Create the Log Analytics workspace
    az monitor log-analytics workspace create --resource-group "$resource_group" --workspace-name "$workspace_name" --sku PerGB2018 --retention-time "$retention_days"
    echo "Log Analytics workspace '$workspace_name' created successfully in the resource group '$resource_group'."
fi

# Get the Customer ID of the workspace
customer_id=$(az monitor log-analytics workspace show --resource-group "$resource_group" --workspace-name "$workspace_name" --query properties.customerId -o tsv)
echo "Customer ID for the Log Analytics workspace: $customer_id"

# Link the Log Analytics workspace to Azure Sentinel
sentinel_workspace_link=$(az monitor sentinel workspace link show --resource-group "$resource_group" --workspace-name "$workspace_name" --query id -o tsv)

if [ -z "$sentinel_workspace_link" ]; then
    az monitor sentinel workspace link create --resource-group "$resource_group" --workspace-name "$workspace_name" --primary-workspace "$workspace_name"
    echo "Log Analytics workspace '$workspace_name' linked to Azure Sentinel."
else
    echo "Log Analytics workspace '$workspace_name' is already linked to Azure Sentinel."
fi
