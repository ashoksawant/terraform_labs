data "azurerm_resource_group" "rgname" {
  name = var.rgname
}
data "azurerm_virtual_network" "vnetname" {
  resource_group_name = data.azurerm_resource_group.rgname.name
  name                = var.vnetname
}
data "azurerm_subnet" "subnet_name" {
  resource_group_name  = data.azurerm_resource_group.rgname.name
  virtual_network_name = data.azurerm_virtual_network.vnetname.name
  name                 = var.subnet_name
}
module "tacoweb" {
  source              = "Azure/loadbalancer/azurerm"
  version             = "4.4.0"
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  type                = "public"
  pip_sku             = "Standard"
  allocation_method   = "Static"
  lb_sku              = "Standard"
  prefix              = var.prefix
  lb_port = {
    http = ["80", "Tcp", "${var.application_port}"]
  }

  lb_probe = {
    http = ["Http", "${var.application_port}", "/"]
  }
}
resource "azurerm_network_security_group" "nsgname" {
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  name                = var.nsgname
}
resource "azurerm_network_security_rule" "nsg_rulename" {
  network_security_group_name = azurerm_network_security_group.nsgname.name
  resource_group_name         = data.azurerm_resource_group.rgname.name
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
resource "azurerm_network_interface" "nic" {
  name                = "nic1-config"
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    name                          = "nic1-config"
    subnet_id                     = data.azurerm_subnet.subnet_name.id
  }
}
resource "azurerm_subnet_network_security_group_association" "subnet_bind_nsg" {
  subnet_id                 = data.azurerm_subnet.subnet_name.id
  network_security_group_id = azurerm_network_security_group.nsgname.id

}

resource "azurerm_linux_virtual_machine_scale_set" "vmssname" {
  name                = var.vmssname
  location            = data.azurerm_resource_group.rgname.location
  resource_group_name = data.azurerm_resource_group.rgname.name
  sku                 = var.vmssku
  instances           = var.vms_count
  admin_username      = var.user_name
  admin_password      = var.vm_password
  disable_password_authentication = false 
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  network_interface {
    name                      = "${var.vmssname}-nic"
    network_security_group_id = azurerm_network_security_group.nsgname.id
    primary                   = true
    ip_configuration {
      name                                   = "${var.vmssname}-ip"
      subnet_id                              = data.azurerm_subnet.subnet_name.id
      load_balancer_backend_address_pool_ids = [module.tacoweb.azurerm_lb_backend_address_pool_id]
      primary                                = true
    }
  }
  health_probe_id = module.tacoweb.azurerm_lb_probe_ids[0]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  custom_data = base64encode(templatefile("${path.module}/custom_data.tpl", {
    admin_username = var.user_name
    port           = var.application_port
  }))
  depends_on = [module.tacoweb]
}
