# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Existing VNet (vnet1)
data "azurerm_virtual_network" "vnet1" {
  name                = var.vnetname1
  resource_group_name = data.azurerm_resource_group.main.name
}

# Existing subnet in vnet1
data "azurerm_subnet" "subnet1" {
  name                 = var.vnet1_subnet1 # Adjust to actual subnet name in vnet1
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

# New VNet (vnet2)
resource "azurerm_virtual_network" "vnet2" {
  name                = var.vnetname2
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  address_space       = var.address_space
}

# Subnet for vnet2
resource "azurerm_subnet" "subnet2" {
  for_each = var.subnet2

  name                 = each.key
  address_prefixes     = [each.value]
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
}

# VNet peering from vnet1 to vnet2
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                         = "vnet1-to-vnet2"
  resource_group_name          = data.azurerm_resource_group.main.name
  virtual_network_name         = data.azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNet peering from vnet2 to vnet1
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                         = "vnet2-to-vnet1"
  resource_group_name          = data.azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# NSG to allow ICMP (ping)
resource "azurerm_network_security_group" "nsg" {
  name                = "allow-ping"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowICMP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IPs
resource "azurerm_public_ip" "pubip" {
  for_each = toset(var.public_ip)

  name                = each.value
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Basic"
}

# NICs: vm1 in vnet1's subnet, vm2 in vnet2's subnet
resource "azurerm_network_interface" "nic" {
  for_each = {
    "vm1" = {
      subnet_id = data.azurerm_subnet.subnet1.id
      pip_name  = "vm1_publicip"
    }
    "vm2" = {
      subnet_id = azurerm_subnet.subnet2["web"].id
      pip_name  = "vm2_publicip"
    }
  }

  name                = "${each.key}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip[each.value.pip_name].id
  }
}

# Associate NSG with each NIC
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each = azurerm_network_interface.nic

  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Linux VMs
resource "azurerm_linux_virtual_machine" "vms" {
  for_each = {
    "vm1" = {
      nic_id = azurerm_network_interface.nic["vm1"].id
    }
    "vm2" = {
      nic_id = azurerm_network_interface.nic["vm2"].id
    }
  }

  name                            = each.key
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = "Standard_DS1_v2"
  admin_username                  = each.key
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids           = [each.value.nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
