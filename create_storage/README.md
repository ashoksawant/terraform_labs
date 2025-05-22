# Creating an Azure Storage Account using Terraform

This guide provides step-by-step instructions for creating an Azure Storage Account using Terraform.

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform (v0.12 or later)
- Azure CLI
- An Azure subscription

## 1. Provider Configuration

Create a file named `main.tf` and add the following:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
