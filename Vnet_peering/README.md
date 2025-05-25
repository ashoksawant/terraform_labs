# Terraform Azure VNet Peering and VM Deployment

## 🧾 Overview

This Terraform project provisions:
- A new Azure Virtual Network (VNet2) and subnet.
- Peering between an existing VNet (VNet1) and the new VNet2.
- Two Linux Virtual Machines:
  - One in the existing VNet1.
  - One in the new VNet2.
- Network Security Group (NSG) rules to allow ICMP (ping) traffic.
- Verification of connectivity between the VMs using ping.

## ✅ Prerequisites

- Terraform
- Azure CLI
- An existing Azure Resource Group and VNet (VNet1)
- Azure subscription with sufficient permissions

## 📁 Project Structure

. ├── main.tf # Main Terraform configuration ├── variables.tf # Input variable definitions ├── terraform.tfvars # Variable values ├── provider.tf # Azure provider configuration └── README.md # Project documentation


## ⚙️ Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/terraform-vnet-peering.git
   cd terraform-vnet-peering
Login to Azure:

az login

Initialize Terraform:

terraform init


Review the execution plan:

terraform plan


Apply the configuration:

terraform apply


🧪 Verification
After deployment, get the public IP of vm1 from the Azure portal or Terraform output.
SSH into vm1:

ssh azureuser@<vm1-public-ip>


Ping the private IP of vm2:

ping <vm2-private-ip>


You should see successful ICMP replies if peering and NSG rules are correctly configured.
🧹 Cleanup
To destroy all resources created by this project:

terraform destroy


