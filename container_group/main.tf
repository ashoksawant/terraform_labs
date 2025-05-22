data "azurerm_resource_group" "rgname" {
  name = var.resourcegname
}

resource "azurerm_container_group" "conatinergroup" {
  resource_group_name = data.azurerm_resource_group.rgname.name
  location            = data.azurerm_resource_group.rgname.location
  name                = var.azure_containername
  ip_address_type     = "Public"
  dns_name_label      = var.azure_containername
  os_type             = "Linux"
  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"

    }

  }
}