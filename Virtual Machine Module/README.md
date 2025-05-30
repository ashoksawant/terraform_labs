
# Using the Virtual Machine Module

## Introduction
Welcome to the Using the Virtual Machine Module lab. In this lab, we will cover three objectives:
1. Use an existing subnet as a data source
2. Deploy an Azure VM using the Virtual Machine Module
3. Add a Network Security Group to the VM

By the end of this lab, you'll have successfully deployed Azure VMs to an existing subnet and added security groups to the VMs to access a web page.

## Additional Information and Resources
As a DevOps engineer at Globomantics, you've been tasked with deploying a new web server to Azure. The web server will host the Taco Wagon web page that will be used for a marketing campaign. The web page will be accessible to the public, so you need to ensure that the web server allows traffic on port 80 and 443 from anywhere. The VM will be deployed to an existing subnet named `app` that has been prepared for you.

## Prerequisites
To complete this lab you will need the following prerequisites installed locally:
- VS Code (or a similar code editor)
- Terraform CLI
- Azure CLI
