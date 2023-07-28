#!/bin/bash

# Set the names of the resource groups
resource_groups=("ResourceGroup1" "ResourceGroup2" "ResourceGroup3")

# Set the Azure region where the resource groups will be created
region="East US"

# Loop through the array and create each resource group
for rg in "${resource_groups[@]}"
do
    # Check if the resource group already exists
    if az group show --name "$rg" &>/dev/null; then
        echo "Resource group '$rg' already exists. Skipping creation."
    else
        # Create the resource group
        az group create --name "$rg" --location "$region"
        echo "Resource group '$rg' created successfully."
    fi
done
