data "azurerm_resource_group" "rgname" {
  name = var.resource_group
}
data "azurerm_virtual_network" "vnet" {
  resource_group_name = data.azurerm_resource_group.rgname.name
  name                = var.vnet

}
data "azurerm_subnet" "subnet" {
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rgname.name
  name                 = var.subnet
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm1_nic"
  location            = data.azurerm_resource_group.rgname.location
  resource_group_name = data.azurerm_resource_group.rgname.name
  ip_configuration {
    name                          = "vm1ip_address"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id

  }
}
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip
  allocation_method   = "Static"
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  sku                 = "Standard"

}
module "linux" {
  source  = "Azure/virtual-machine/azurerm"
  version = "1.1.0"
  # insert the 7 required variables here
  name                            = var.vmname
  location                        = data.azurerm_resource_group.rgname.location
  resource_group_name             = data.azurerm_resource_group.rgname.name
  size                            = var.vmsize
  os_simple                       = "UbuntuServer"
  allow_extension_operations      = false
  new_network_interface           = null
  boot_diagnostics                = true
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  os_disk                         = var.os_disks
  admin_username                  = var.user_name
  admin_password                  = var.vm_password
  subnet_id                       = data.azurerm_subnet.subnet.id
  image_os                        = var.vm_os_image

  custom_data = base64encode(templatefile("${path.module}/custom_data.tpl", {
    admin_username = var.user_name
    port           = var.application_port
  }))
  depends_on = [azurerm_network_interface.vm_nic]
}

resource "azurerm_network_security_group" "app-nsg" {
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  name                = var.nsg_name

}
resource "azurerm_network_security_rule" "http" {
  resource_group_name         = data.azurerm_resource_group.rgname.name
  network_security_group_name = azurerm_network_security_group.app-nsg.name
  name                        = "http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = var.application_port
  destination_address_prefix  = "*"
}


resource "azurerm_network_interface_security_group_association" "app-vm" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}