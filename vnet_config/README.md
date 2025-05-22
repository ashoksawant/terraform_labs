# Terraform Backend Migration with Azure

This guide walks through updating the Terraform backend configuration to use Azure Storage for remote state management and migrating existing state data.

## 📁 Directory Structure
vnet_config/ ├── terraform.tf ├── backend-config.tfbackend └── ..
## 🛠️ Prerequisites

- Terraform CLI installed
- Azure CLI authenticated
- Existing Azure Storage Account and Resource Group
- Terraform state file present locally

## 🔧 Step-by-Step Instructions

### 1. Update `terraform.tf`

In the `vnet_config` directory, update the `terraform.tf` file with the following content:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    # Backend configuration will be provided via -backend-config
  }
}

### 2. Create backend-config.tfbackend
-  Create a new file named backend-config.tfbackend:

    '''touch backend-config.tfbackend'''

    ```hcl
    resource_group_name  = "RESOURCE_GROUP_NAME"
    storage_account_name = "STORAGE_ACCOUNT_NAME"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
🔁 Replace RESOURCE_GROUP_NAME and STORAGE_ACCOUNT_NAME with actual values from your Azure setup.

### 3. Initialize Terraform and Migrate State
- Run the following command to initialize the backend and migrate the state:

''' terraform init -backend-config="backend-config.tfbackend" '''

Accept the prompt to migrate the state to the Azure Storage backend.

### 4. Verify Migration
- Check that the local state file is now empty:
''' cat terraform.tfstate '''



