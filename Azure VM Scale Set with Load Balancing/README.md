
# Deploy an Azure VM Scale Set with Load Balancing

## Introduction
Welcome to the Deploy a VM Scale Set with Load Balancing lab. In this lab, we will cover three objectives:
- Use an existing subnet as a data source
- Create and configure an Azure load balancer
- Create and configure an Azure VM Scale Set

By the end of this lab, you will have created an Azure VM Scale Set and load balancer using Terraform and a module from the public registry.

## Additional Information and Resources
As a DevOps engineer at Globomantics, you've been asked to deploy the front-end component for their Taco Wagon web application to Azure using Terraform. The front-end is made up of a virtual machine scale-set and public-facing load balancer, along with the necessary network security groups and rules. The startup script will be provided to you along with an existing subnet to use for the deployment.

## Prerequisites
To complete this lab you will need the following prerequisites installed locally:
- VS Code (or a similar code editor)
- Terraform CLI
- Azure CLI
